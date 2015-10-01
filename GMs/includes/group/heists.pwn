/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)

	Developers:
		- Jingles
		
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


#include <YSI\y_hooks>


#define 		MAX_SAFES 						5*MAX_GROUPS
#define 		MAX_ROBBERS 					20

#define 		DYNAMICCP_BOMBPOINT 			1500
#define 		BOMBMAKER_MINUTES 				1


#define 		MAX_TEXTGRIDS 					16


new BOMBMAKER_PRICE,
	BOMBMAKER_MATS;

enum eTextGrid {
	text_iMine,
	text_iSave,
	Text:text_iTextID
};
new TextGrid[MAX_TEXTGRIDS][eTextGrid];


enum eSafeData {
	safe_iDBID,
	safe_iType,
	safe_iTypeID,
	safe_iMoney,
	safe_iVW,
	safe_iInt,
	safe_iModelID,
	safe_iObjectID,
	safe_iRobberyPickup,
	safe_iRobbed,
	safe_tRobbedTime,
	Float:safe_fPos[6],
	safe_iPin[5],
	Text3D:safe_iTextLabel,
	safe_iAreaID
}
new SafeData[MAX_SAFES][eSafeData];


enum eMoneyBagData {
	mb_iObjectID,
	Float:safe_fPos[3],
	safe_iMoney,
	Text3D:safe_iTextLabel
}
new MoneyBagData[MAX_ROBBERS][eMoneyBagData];


enum eBombMaker {
	Float:bomb_fPos[3],
	Text3D:bomb_iText
}
new arrBombMaker[eBombMaker];




new ROB_MAX_PERCENTAGE = 30,
	ROB_COLLECT_RATE = 5000,
	ROB_MIN_MEMBERS = 1;


new Text:safe_TextDraw[9];

hook OnGameModeInit()
{
	TextGrid_SaveInit();
	TextGrid_Init();
	TextSafe_Init();
	return 1;
}

hook OnGameModeExit()
{
	stopRobbery();
	for(new i; i < MAX_SAFES; i++) destroySafe(i);
	for(new i; i < sizeof(safe_TextDraw); ++i)
	{
		TextDrawHideForAll(safe_TextDraw[i]);
		TextDrawDestroy(safe_TextDraw[i]);
	}
	return 1;
}

hook OnPlayerConnect(playerid) {

	DeletePVar(playerid, "_RobbingSafe");
	DeletePVar(playerid, "_RobberID");
	DeletePVar(playerid, "_CollectTimer");
	DeletePVar(playerid, "_CollectedMoney");
	DeletePVar(playerid, "_ShowingSafe");
	DeletePVar(playerid, "_CollectingMoney");
	DeletePVar(playerid, "_BombPlayerOffer");
	DeletePVar(playerid, "_BombPlayerAmount");
	DeletePVar(playerid, "_BombPlayerCost");
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	dropBag(playerid);
	return 1;
}

hook OnPlayerDeath(playerid) {

	dropBag(playerid);
}
hook OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	szMiscArray[0] = 0;
	if(pickupid == GetGVarInt("RobberyDeliverPickupID") && GetPVarType(playerid, "_HasBag"))
	{
		new collected = GetPVarInt(playerid, "_CollectedMoney"),
			iRobberID = GetPVarInt(playerid, "_RobberID"),
			iSafeID = GetGVarInt("RobbedSafeID"),
			iCount;

		DisablePlayerCheckpoint(playerid);
		format(szMiscArray, sizeof(szMiscArray), "Heist successful! $%s has been succesfully transferred to your safe!", number_format(collected));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		arrGroupData[PlayerInfo[playerid][pMember]][g_iBudget] += collected;
		SafeMoney(playerid, iSafeID, -collected);

		DestroyDynamic3DTextLabel(MoneyBagData[iRobberID][safe_iTextLabel]);
		RemovePlayerAttachedObject(playerid, 8);
		RemovePlayerAttachedObject(playerid, 9);
		DeletePVar(playerid, "_CollectedMoney");
		DeletePVar(playerid, "_HasBag");
		DeletePVar(playerid, "_RobberID");

		foreach(new i : Player) if(GetPVarType(i, "_RobberID")) iCount++;
		if(iCount == 0) stopRobbery();

		format(szMiscArray, sizeof(szMiscArray), "There are %d robbers left.", iCount);

		foreach(new i : Player) {
			if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember]) {
				if(iCount) SendClientMessageEx(i, COLOR_GRAD1, szMiscArray);
				else SendClientMessageEx(i, COLOR_GRAD1, "The heist was completed.");
			}
		}

	}
	/*
	if(pickupid == GetGVarInt("RobberyEntrancePickupID") && GetPVarInt(playerid, "_RobberyBeacon"))
	{
		DisablePlayerCheckpoint(playerid);
		SetTimerEx("OnRobberyEnterBeacon", 5000, false, "i", playerid);
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are now invulnerable for 5 seconds.");
	}
	*/
}


hook OnPlayerEnterCheckpoint(playerid)
{
	if(GetGVarInt("RobberyStage") == 2 && GetSafeID(playerid) > -1)
	{
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Use /robsafe to open the safe. Press ~k~~VEHICLE_ENTER_EXIT~ to attempt to crack the code.");
		DisablePlayerCheckpoint(playerid);
	}
	if(GetPVarType(playerid, "_BombCP")) 
	{
		DeletePVar(playerid, "_BombCP");
		DisablePlayerCheckpoint(playerid);
	}
	return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == safe_TextDraw[7])
	{
		new flag_count;
		for(new i; i < sizeof(TextGrid); ++i)
		{
			if(TextGrid[i][text_iSave] == 2) flag_count++;
		}
		if(flag_count > 2) 
		{
			TextGrid_Destroy();
			safeBreached(playerid);
		}
		else 
		{
			TextGrid_Destroy();
			GameTextForPlayer(playerid, "Breach ~r~unsuccessful! ~n~~w~You were injured by a shock.", 4000, 3);
			TogglePlayerControllable(playerid, 0);
			SetPVarInt(playerid, "_SafeInjured", 1);
			ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
			SetTimerEx("Safe_ResetAnims", 15000, false, "i", playerid);
		}
		return 1;
	}
	for(new i; i < sizeof(TextGrid); ++i)
	{
		if(TextGrid[i][text_iTextID] == clickedid)
		{
			switch(TextGrid[i][text_iMine])
			{
				case 0: {

					TextDrawSetString(clickedid, "--");
					TextDrawBoxColor(clickedid, 0x222222FF);
				}
				case 1: {

					TextDrawSetString(clickedid, "X");
					TextDrawBoxColor(clickedid, 0xFFFF0000);
					TextGrid_Destroy();
					TogglePlayerControllable(playerid, 0);
					GameTextForPlayer(playerid, "Breach ~r~unsuccessful! ~n~~w~You were injured by a shock.", 4000, 3);
					SetPVarInt(playerid, "_SafeInjured", 1);
					ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
					SetTimerEx("Safe_ResetAnims", 15000, false, "i", playerid);
					return 1;
				}
			}
			if(TextGrid[i][text_iSave] > 0) {

				TextGrid[i][text_iSave] = 2;
				// TextDrawSetString(clickedid, SafeData[GetSafeID(playerid)][safe_iPin][SafeText_PinCount]);
				// SafeText_PinCount++;
				TextDrawSetString(clickedid, "O");
				TextDrawBoxColor(clickedid, 0xFF00FF00);
			}
			TextDrawHideForPlayer(playerid, TextGrid[i][text_iTextID]);
			TextDrawShowForPlayer(playerid, TextGrid[i][text_iTextID]);
		}
	}
	new savegridcount;
	for(new i; i < sizeof(TextGrid); ++i)
	{
		if(TextGrid[i][text_iSave] == 2) savegridcount++;
		if(savegridcount > 3) {

			ProxDetector(15.0, playerid, "[SAFE]: *You would hear a click*", COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
			break;
		}
	}
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DIALOG_BOMBMAKER_OFFER:
		{
			if(response)
			{
				szMiscArray[0] = 0;
				format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `bombmaker` WHERE `DBID` = %d", GetPlayerSQLId(playerid));
				mysql_function_query(MainPipeline, szMiscArray, true, "Bomb_OnCheckOrder", "i", playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD1, "You declined the offer.");
			}
		}
		case DIALOG_MECHANIC_REPAIRDOOR:
		{
			if(!response) return 1;
			else
			{
				szMiscArray[0] = 0;
				new targetid = GetNearestBrokenGateOrDoor(playerid),
					targettype = GetPVarInt(playerid, "_TargetType");
				if(targetid == 0) return SendClientMessage(playerid, COLOR_GRAD1, "You are not near a broken door or gate.");
				PlayerInfo[playerid][pMats] -= 5000;
				format(szMiscArray, sizeof(szMiscArray), "%s is repairing the gate/door...", GetPlayerNameEx(playerid));
				ProxChatBubble(playerid, szMiscArray);
				SendClientMessage(playerid, COLOR_GRAD1, "You paid 5K materials and are now repairing the gate/door.");
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 10000, 0);
				SetPVarInt(playerid, "_RepairingDoor", 1);
				SetTimerEx("Mechanic_InitSeconds", 1000, false, "ii", playerid, 1000, targetid, targettype);
			}
		}
		case DIALOG_ROBBERY_SETUP:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, DIALOG_ROBBERY_SETUP_PERC, DIALOG_STYLE_INPUT, "Robbery Setup | Robable Percentage", "Enter the percentage that's takeable by the robbers.", "Confirm", "Cancel");
				case 1: ShowPlayerDialog(playerid, DIALOG_ROBBERY_SETUP_RATE, DIALOG_STYLE_INPUT, "Robbery Setup | Collect Rate", "Enter the amount of money taken each 10 seconds.", "Confirm", "Cancel");
				case 2: ShowPlayerDialog(playerid, DIALOG_ROBBERY_SETUP_MIN, DIALOG_STYLE_INPUT, "Robbery Setup | Minimum Robbers", "Enter the minimum amount of robbers needed in the robbery.",  "Confirm", "Cancel");
			}
			return 1;
		}
		case DIALOG_ROBBERY_SETUP_PERC:
		{
			if(response && !isnull(inputtext) && strval(inputtext) <= 100)
				ROB_MAX_PERCENTAGE = strval(inputtext);
			return cmd_editrobbery(playerid, "");
		}
		case DIALOG_ROBBERY_SETUP_RATE:
		{
			if(response && !isnull(inputtext))
				ROB_COLLECT_RATE = strval(inputtext);
			return cmd_editrobbery(playerid, "");
		}
		case DIALOG_ROBBERY_SETUP_MIN:
		{
			if(response && !isnull(inputtext) && strval(inputtext) > 0)
				ROB_MIN_MEMBERS = strval(inputtext);
			return cmd_editrobbery(playerid, "");
		}
		case DIALOG_SAFE_PIN:
		{
			if(response && !isnull(inputtext))
			{
				if(!strcmp(inputtext, SafeData[GetSafeID(playerid)][safe_iPin], true))
				{
					return safeMenu(playerid);
				}
				else return SendClientMessageEx(playerid, COLOR_LIGHTRED, "Wrong PIN.");
			}
		}
		case DIALOG_SAFE_MAIN:
		{
			if(!response) return 1;
			new	szTitle[64],
				szDialog[256],
				iSafeID = GetPVarInt(playerid, "_EditingSafeID"),
				iTypeID = SafeData[iSafeID][safe_iTypeID];

			switch(SafeData[iSafeID][safe_iType])
			{
				case 0: 
				{
					format(szTitle, sizeof(szTitle), "(ID: %i) UNSPECIFIED Safe", iSafeID);
					format(szDialog, sizeof(szDialog), "_________________________________\n\n--------------------\n Balance Sheet\n--------------------\n%s\n\nVault balance: $%s\n\n_________________________", "UNSPECIFIED", number_format(GetSafeMoney(iSafeID)));
				}
				case 1: 
				{
					format(szTitle, sizeof(szTitle), "(ID: %i) Bank Safe", iSafeID);
					format(szDialog, sizeof(szDialog), "_________________________________\n\n--------------------\n Balance Sheet\n--------------------\nState Bank\n\nVault balance: $%s\n\n_________________________", number_format(SafeData[iSafeID][safe_iMoney]));
				}
				case 2: 
				{
					format(szTitle, sizeof(szTitle), "(ID: %i) {%s}%s's Safe", iSafeID, Group_NumToDialogHex(arrGroupData[iTypeID][g_hDutyColour]), arrGroupData[iTypeID][g_szGroupName]);
					format(szDialog, sizeof(szDialog), "_________________________________\n\n--------------------\n Balance Sheet\n--------------------\n%s\n\nVault balance: $%s\n\n_________________________", arrGroupData[iTypeID][g_szGroupName], number_format(GetSafeMoney(iSafeID)));
				}
				case 3: 
				{
					format(szTitle, sizeof(szTitle), "(ID: %i) %s's Safe Menu", iSafeID, Businesses[iTypeID][bName]);
					format(szDialog, sizeof(szDialog), "_________________________________\n\n--------------------\n Balance Sheet\n--------------------\n%s\n\nVault balance: $%s\n\n_________________________",  Businesses[iTypeID][bName], number_format(GetSafeMoney(iSafeID)));
				}
				case 4: 
				{
					format(szTitle, sizeof(szTitle), "(ID: %i) Player Safe Menu", iSafeID);
					format(szDialog, sizeof(szDialog), "_________________________________\n\n--------------------\nBalance Sheet\n--------------------\nPlayer\n\nVault balance: $%s\n\n_________________________________", number_format(SafeData[iSafeID][safe_iMoney]));
				}
			}
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_SAFE_BALANCE, DIALOG_STYLE_MSGBOX, szTitle, szDialog, "---", "---");
				}
				case 1:
				{
					return ShowPlayerDialog(playerid, DIALOG_SAFE_WITHDRAW, DIALOG_STYLE_INPUT, szTitle, "Specify the amount you would like to withdraw", "Withdraw", "Cancel");
				}
				case 2:
				{
					return ShowPlayerDialog(playerid, DIALOG_SAFE_DEPOSIT, DIALOG_STYLE_INPUT, szTitle, "Specify the amount you would like to deposit.", "Deposit", "Cancel");
				}
				case 3:
				{
					return ShowPlayerDialog(playerid, DIALOG_SAFE_PIN_EDIT, DIALOG_STYLE_INPUT, szTitle, "Please edit the new PIN.", "Proceed", "Back");
				}
			}	
		}
		case DIALOG_SAFE_BALANCE: return safeMenu(playerid);
		case DIALOG_SAFE_WITHDRAW:
		{
			if(!response || isnull(inputtext)) return safeMenu(playerid);
			{
				new iSafeID = GetPVarInt(playerid, "_EditingSafeID");
				if(SafeData[iSafeID][safe_iType] == 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "Use /gwithdraw to withdraw from the vault.");
				if(!checkSafePerms(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must own this safe to withdraw money from it.");
				if(strval(inputtext) < 0 || isnull(inputtext) || strval(inputtext) > FLOAT_INFINITY) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount.");
				if(SafeData[iSafeID][safe_iType] == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "It is strictly illegal to withdraw from a bank's safe.");
				if(GetSafeMoney(SafeData[iSafeID][safe_iMoney]) < strval(inputtext)) return SendClientMessageEx(playerid, COLOR_GRAD1, "There is not enough money in the safe.");
				
				SafeMoney(playerid, iSafeID, -strval(inputtext));
				GivePlayerCash(playerid, strval(inputtext));
				saveSafe(iSafeID);
				DeletePVar(playerid, "_EditingSafeID");
				return safeMenu(playerid);
			}
		}
		case DIALOG_SAFE_DEPOSIT:
		{
			if(!response) return safeMenu(playerid);
			{
				new iSafeID = GetPVarInt(playerid, "_EditingSafeID");
				if(isnull(inputtext)) return safeMenu(playerid);
				if(GetPlayerMoney(playerid) < strval(inputtext)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough money.");
				if(strval(inputtext) < 0 || strval(inputtext) > FLOAT_INFINITY) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount.");
				
				SafeMoney(playerid, iSafeID, strval(inputtext));
				GivePlayerCash(playerid, -strval(inputtext));
				saveSafe(iSafeID);
				DeletePVar(playerid, "_EditingSafeID");
				return safeMenu(playerid);
			}
		}
		case DIALOG_SAFE_PIN_EDIT:
		{
			if(!response || !IsNumeric(inputtext)) return safeMenu(playerid);
			if(isnull(inputtext) && strlen(inputtext) != 4) return safeMenu(playerid);
			new iSafeID = GetPVarInt(playerid, "_EditingSafeID");
			if(!checkSafePerms(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must be a group leader to edit the safe's PIN.");
			format(SafeData[iSafeID][safe_iPin], 5, "%s", inputtext);
			format(szMiscArray, sizeof(szMiscArray), "Pin changed to: %s", SafeData[iSafeID][safe_iPin]);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			saveSafe(iSafeID);
			return safeMenu(playerid);
		}
		case DIALOG_SAFE_CREATE:
		{
			if(!response) return DeletePVar(playerid, "_EditingSafeID");
			switch(listitem)
			{
				case 0: return ShowPlayerDialog(playerid, DIALOG_SAFE_CTYPE, DIALOG_STYLE_LIST, "Safe Menu | Safe Type", "Bank\nGroup\nBusiness\nPlayer", "Select", "Cancel");
				case 1: return ShowPlayerDialog(playerid, DIALOG_SAFE_CTYPEID, DIALOG_STYLE_INPUT, "Safe Menu | Safe Type ID", "Please specify the ID of the safe's owner.", "Select", "Cancel");
				case 2: return ShowPlayerDialog(playerid, DIALOG_SAFE_CMODELID_CONFIRM, DIALOG_STYLE_LIST, "Safe Menu | Model Selection", "Big Safe\nMedium Safe\nSmall Safe", "Select", "Cancel");
				case 3: return safePosition(playerid, GetPVarInt(playerid, "_EditingSafeID"));
				case 4: return ShowPlayerDialog(playerid, DIALOG_SAFE_PIN_AEDIT, DIALOG_STYLE_INPUT, "Safe Menu | Edit Safe PIN", "Please edit the new PIN.", "Proceed", "Back");
				case 5: { processSafe(GetPVarInt(playerid, "_EditingSafeID")); return DeletePVar(playerid, "_EditingSafeID"); }
			}
		}
		case DIALOG_SAFE_CTYPE:
		{
			if(!response) return safeEditMenu(playerid);
			new iSafeID = GetPVarInt(playerid, "_EditingSafeID");
			switch(listitem)
			{
				case 0: SafeData[iSafeID][safe_iType] = 1;
				case 1: SafeData[iSafeID][safe_iType] = 2;
				case 2: SafeData[iSafeID][safe_iType] = 3;
				case 3: SafeData[iSafeID][safe_iType] = 4;
			}
			processSafe(iSafeID);
			saveSafe(iSafeID);
			return safeEditMenu(playerid);
		}
		case DIALOG_SAFE_CTYPEID:
		{
			if(!response || isnull(inputtext) || !IsNumeric(inputtext)) return safeEditMenu(playerid);
			new iSafeID = GetPVarInt(playerid, "_EditingSafeID"),
				szDialog[128];
			if(SafeData[iSafeID][safe_iType] == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "Please first set the safe's type.");
				return safeEditMenu(playerid);
			}
			switch(SafeData[iSafeID][safe_iType])
			{
				case 1:
				{
					format(szDialog, sizeof(szDialog), "You are assigning this Bank safe to: State Bank");
				}
				case 2:
				{
					format(szDialog, sizeof(szDialog), "You are assigning this Group safe to: {%s}%s", Group_NumToDialogHex(arrGroupData[strval(inputtext)][g_hDutyColour]), arrGroupData[strval(inputtext)][g_szGroupName]);
				}
				case 3:
				{
					format(szDialog, sizeof(szDialog), "You are assigning this Business safe to: %s", Businesses[strval(inputtext)][bName]);
				}
				case 4:
				{
					format(szDialog, sizeof(szDialog), "You are assigning this Player safe to: %s", GetPlayerNameEx(strval(inputtext)));
				}
			}
			SetPVarInt(playerid, "_SafeTypeID", strval(inputtext));
			ShowPlayerDialog(playerid, DIALOG_SAFE_CTYPEID_CONFIRM, DIALOG_STYLE_MSGBOX, "Safe Menu | Confirm Owner", szDialog, "Confirm", "Cancel");
			return 1;
		}
		case DIALOG_SAFE_CMODELID_CONFIRM:
		{
			if(!response) return safeEditMenu(playerid);
			new iSafeID = GetPVarInt(playerid, "_EditingSafeID");
			switch(listitem)
			{
				case 0: { SafeData[iSafeID][safe_iModelID] = 19799; processSafe(iSafeID); saveSafe(iSafeID); }
				case 1: { SafeData[iSafeID][safe_iModelID] = 2197; processSafe(iSafeID); saveSafe(iSafeID); }
				case 2: { SafeData[iSafeID][safe_iModelID] = 2332; processSafe(iSafeID); saveSafe(iSafeID); }
			}
			return safeEditMenu(playerid);
		}	
		case DIALOG_SAFE_CTYPEID_CONFIRM:
		{
			if(!response) return safeEditMenu(playerid);
			new iSafeID = GetPVarInt(playerid, "_EditingSafeID"),
				iTypeID = GetPVarInt(playerid, "_SafeTypeID");
			DeletePVar(playerid, "_SafeTypeID");

			SafeData[iSafeID][safe_iTypeID] = iTypeID;
			switch(SafeData[iSafeID][safe_iType])
			{
				case 1:	{

					SafeData[iSafeID][safe_iMoney] = 100000000;
					format(szMiscArray, sizeof(szMiscArray), "Safe assigned to: State Bank");
				}
				case 2:
				{
					format(szMiscArray, sizeof(szMiscArray), "Safe assigned to: %s", arrGroupData[iTypeID][g_szGroupName]);
				}
				case 3:
				{
					format(szMiscArray, sizeof(szMiscArray), "Safe assigned to: %s", Businesses[iTypeID][bName]);
				}
				case 4:
				{
					format(szMiscArray, sizeof(szMiscArray), "Safe assigned to: %s", GetPlayerNameEx(iTypeID));
				}
			}
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			processSafe(iSafeID);
			saveSafe(iSafeID);	
			return safeEditMenu(playerid);			
		}
		case DIALOG_SAFE_PIN_AEDIT:
		{
			if(!response || !IsNumeric(inputtext)) return safeMenu(playerid);
			if(isnull(inputtext) && strlen(inputtext) != 4) return safeMenu(playerid);
			new iSafeID = GetPVarInt(playerid, "_EditingSafeID");
			format(SafeData[iSafeID][safe_iPin], 5, "%s", inputtext);
			format(szMiscArray, sizeof(szMiscArray), "[ADM] Pin changed to: %s", SafeData[iSafeID][safe_iPin]);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			saveSafe(iSafeID);
			return safeEditMenu(playerid);
		}
		case DIALOG_SAFE_BREACH:
		{
			if(response) 
			{
				return cmd_robsafe(playerid, "");
			}
			else 
			{ 
				return ClearAnimations(playerid); 
			}
		}
		case DIALOG_ROBBERY_SAFE:
		{
			if(response)
			{
				if(!strcmp(inputtext, SafeData[GetGVarInt("RobbedSafeID")][safe_iPin], true))
				{
					safeBreached(playerid);
					return 1;
				}
				else return SendClientMessageEx(playerid, COLOR_LIGHTRED, "Code rejected");
			}
		}
	}
	return 1;
}

safeBreached(playerid)
{
	szMiscArray[0] = 0;
	new iSafeID = GetGVarInt("RobbedSafeID"),
		iTypeID = SafeData[iSafeID][safe_iTypeID];
	GameTextForPlayer(playerid, "~g~Safe breached!~n~~n~~w~Press ~g~'F' ~w~to start collecting.", 4000, 3);
	ClearAnimations(playerid);
	SafeData[iSafeID][safe_iRobbed] = 1;
	SafeData[iSafeID][safe_tRobbedTime] = gettime();
	switch(SafeData[iSafeID][safe_iType])
	{
		case 0: format(szMiscArray, sizeof(szMiscArray), "(ID: %i)\nUNSPECIFIED\n%s", iSafeID);
		case 1: format(szMiscArray, sizeof(szMiscArray), "(ID: %i)\n State Bank Safe", iSafeID);
		case 2: format(szMiscArray, sizeof(szMiscArray), "(ID: %i)\nGroup Safe\n%s", iSafeID, arrGroupData[iTypeID][g_szGroupName]);
		case 3: format(szMiscArray, sizeof(szMiscArray), "(ID: %i)\nBusiness Safe\n%s\nOwner: %s", iSafeID, Businesses[iTypeID][bName], StripUnderscore(Businesses[iTypeID][bOwnerName]));
		case 4: format(szMiscArray, sizeof(szMiscArray), "(ID: %i)\nPlayer Safe\nOwner: UNSPECIFIED", iSafeID, StripUnderscore(Businesses[iTypeID][bOwnerName]));
	}
	strins(szMiscArray, "{FF0000}Robbed", strlen(szMiscArray)+2, sizeof(szMiscArray)+20);
	if(IsValidDynamicObject(SafeData[iSafeID][safe_iObjectID]) && SafeData[iSafeID][safe_iModelID] == 2332)
	{
		DestroyDynamicObject(SafeData[iSafeID][safe_iObjectID]);
		SafeData[iSafeID][safe_iObjectID] = CreateDynamicObject(1829, SafeData[iSafeID][safe_fPos][0], SafeData[iSafeID][safe_fPos][1], SafeData[iSafeID][safe_fPos][2], SafeData[iSafeID][safe_fPos][3], SafeData[iSafeID][safe_fPos][4],SafeData[iSafeID][safe_fPos][5], SafeData[iSafeID][safe_iVW], SafeData[iSafeID][safe_iInt]);
	}
	UpdateDynamic3DTextLabelText(SafeData[iSafeID][safe_iTextLabel], COLOR_YELLOW, szMiscArray);
	saveSafe(iSafeID);
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_FIRE) {	

		if(PlayerInfo[playerid][pGuns][8] == 40) {

			if(GetPVarType(playerid, "_BombPlanted")) {
				Bomb_Detonate(playerid, GetPVarInt(playerid, "_TargetID"), GetPVarInt(playerid, "_TargetType"));
			}
		}
	}
	if(GetPVarType(playerid, "_PickingLock") && newkeys & KEY_JUMP)
	{
		ClearAnimations(playerid);
		SendClientMessage(playerid, COLOR_GRAD1, "You stopped picking the lock");
		DeletePVar(playerid, "_PickingLock");
	}
	if(GetGVarInt("RobberyStage") && !GetPVarInt(playerid, "_RobbingSafe") && newkeys & KEY_SECONDARY_ATTACK)
	{
		new iSafeID = GetSafeID(playerid);
		if(iSafeID != GetGVarInt("RobbedSafeID") || iSafeID == -1) return 1;
		if(GetPVarType(playerid, "_SafeInjured")) return SendClientMessage(playerid, COLOR_GRAD1, "You're currently injured from your previous attempt.");
		if(SafeData[iSafeID][safe_iRobbed])
		{
			startCollectMoney(playerid, iSafeID);
		}
		else
		{
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0);
			SetPVarInt(playerid, "_RobbingSafe", 1);
			breachSafe(playerid);
		}
		return 1;
	}
	if(GetPVarType(playerid, "_RobbingSafe") && newkeys & KEY_SECONDARY_ATTACK)
	{
		ClearAnimations(playerid);
		stopCollectMoney(playerid);
	}
	return 1;
}

GetSafeMoney(iSafeID) {

	switch(SafeData[iSafeID][safe_iType]) {
		case 0: return 0;
		case 1: return 100000000;
		case 2: return arrGroupData[SafeData[iSafeID][safe_iTypeID]][g_iBudget];
		case 3: return Businesses[SafeData[iSafeID][safe_iTypeID]][bSafeBalance];
		case 4: return SafeData[iSafeID][safe_iMoney];
	}
	return 0;
}

SafeMoney(playerid, iSafeID, iMoney) {

	switch(SafeData[iSafeID][safe_iType]) {
		case 0: SendClientMessage(playerid, COLOR_GRAD1, "This safe has not been setup yet.");
		case 1: SendClientMessage(playerid, COLOR_GRAD1, "You cannot interact with a bank's safe.");
		case 2: arrGroupData[SafeData[iSafeID][safe_iTypeID]][g_iBudget] += iMoney;
		case 3: Businesses[SafeData[iSafeID][safe_iTypeID]][bSafeBalance] += iMoney;
		case 4: SafeData[iSafeID][safe_iMoney] += iMoney;
	}
	if(iMoney > 0) format(szMiscArray, sizeof(szMiscArray), "%s(ID %d) has deposited $%s into %s's safe (ID %d)", GetPlayerNameExt(playerid), PlayerInfo[playerid][pId], number_format(iMoney), GetSafeOwner(iSafeID), iSafeID);
	else format(szMiscArray, sizeof(szMiscArray), "%s(ID %d) has taken $%s from %s's safe (ID %d)", GetPlayerNameExt(playerid), PlayerInfo[playerid][pId], number_format(iMoney), GetSafeOwner(iSafeID), iSafeID);
	Log("logs/safes.log", szMiscArray);
	return 1;
}

GetSafeOwner(iSafeID) {

	new szOwner[64];
	switch(SafeData[iSafeID][safe_iType]) {
		case 0: szOwner = "Unspecified";
		case 1: szOwner = "Bank of Los Santos";
		case 2: strcat(szOwner, arrGroupData[SafeData[iSafeID][safe_iTypeID]][g_szGroupName], sizeof(szOwner));
		case 3: strcat(szOwner, Businesses[SafeData[iSafeID][safe_iTypeID]][bName], sizeof(szOwner));
		case 4: szOwner = "Player Owned";
	}
	return szOwner;
}

GetSafeID(playerid)
{
	for(new i; i < MAX_SAFES; i++)
	{
		if(IsPlayerInDynamicArea(playerid, SafeData[i][safe_iAreaID])) return i;
	}
	return -1;
}

GetMoneyBagID(playerid)
{
	new Float:fPos[3];
	for(new i; i < MAX_ROBBERS; i++)
	{
		GetDynamicObjectPos(MoneyBagData[i][mb_iObjectID], fPos[0], fPos[1], fPos[2]);
		if(IsPlayerInRangeOfPoint(playerid, 3.0, fPos[0], fPos[1], fPos[2])) return i;
	}
	return -1;
}


safePosition(playerid, iSafeID)
{
	szMiscArray[0] = 0;
	if(iSafeID == -1) return 1;
	SetPVarInt(playerid, "_EditingSafeID", iSafeID);
	SetPVarInt(playerid, "_EditingSafeObjectID", SafeData[iSafeID][safe_iObjectID]);
	EditDynamicObject(playerid, SafeData[iSafeID][safe_iObjectID]);
	format(szMiscArray, sizeof szMiscArray, "You're editing safe ID %i's position.", iSafeID);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	return 1;
}


safeDelete(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
	    new
	        iSafeID;
	        
		if(sscanf(params, "i", iSafeID))
		    return SendClientMessageEx(playerid, 0xFFFFFFFF, "Usage: /deletesafe [safeid]");
		    
		if(!(0 <= iSafeID < MAX_SAFES))
		    return SendClientMessageEx(playerid, 0xFFFFFFFF, "Invalid safe ID specified.");
		    
		if(!IsValidDynamicObject(SafeData[iSafeID][safe_iObjectID]))
			return SendClientMessageEx(playerid, 0xFFFFFFFF, "The specified safe ID has not been used.");
		    
		format(szMiscArray, sizeof szMiscArray, "DELETE FROM `safes` WHERE `safeDBID` = %i", SafeData[iSafeID][safe_iDBID]);
		mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", NO_THREAD);

		destroySafe(iSafeID);
		
		SafeData[iSafeID][safe_iDBID] = 0;
		SafeData[iSafeID][safe_iModelID] = 0;
        SafeData[iSafeID][safe_iType] = 0;
		SafeData[iSafeID][safe_iTypeID] = 0;
		SafeData[iSafeID][safe_iVW] = 0;
		SafeData[iSafeID][safe_fPos][0] = 0.0;
		SafeData[iSafeID][safe_fPos][1] = 0.0;
		SafeData[iSafeID][safe_fPos][2] = 0.0;
		SafeData[iSafeID][safe_fPos][3] = 0.0;
		SafeData[iSafeID][safe_fPos][4] = 0.0;
		SafeData[iSafeID][safe_fPos][5] = 0.0;

		SafeData[iSafeID][safe_iPin] = "0000";
		SafeData[iSafeID][safe_iRobbed] = 0;
		SafeData[iSafeID][safe_tRobbedTime] = 0;
		
		format(szMiscArray, sizeof szMiscArray, "You have deleted safe ID %i.", iSafeID);
		SendClientMessageEx(playerid, 0xFFFFFFFF, szMiscArray);
	}
	return 1;	
}


safeMove(playerid, iSafeID)
{
	szMiscArray[0] = 0;
	if(!(0 <= iSafeID < MAX_SAFES))
		return SendClientMessageEx(playerid, 0xFFFFFFFF, "Invalid safe ID specified.");
		
	if(!IsValidDynamicObject(SafeData[iSafeID][safe_iObjectID]))
		return SendClientMessageEx(playerid, 0xFFFFFFFF, "The specified safe ID has not been used.");
		
	GetPlayerPos(playerid, SafeData[iSafeID][safe_fPos][0], SafeData[iSafeID][safe_fPos][1], SafeData[iSafeID][safe_fPos][2]);
	SafeData[iSafeID][safe_iVW] = GetPlayerVirtualWorld(playerid);
	SafeData[iSafeID][safe_iInt] = GetPlayerVirtualWorld(playerid);
	processSafe(iSafeID);
	format(szMiscArray, sizeof szMiscArray, "You have moved safe ID %i.", iSafeID);
	SendClientMessageEx(playerid, 0xFFFFFFFF, szMiscArray);
	return 1;	
}

startCollectMoney(playerid, iSafeID) {

	format(szMiscArray, sizeof(szMiscArray), "Robbing Safe ID: %i", iSafeID);
	SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	SetPVarInt(playerid, "_RobbingSafe", 1);
	format(szMiscArray, sizeof(szMiscArray), "%s starts to collect from the safe.", GetPlayerNameEx(playerid));
	ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	KillTimer(GetPVarInt(playerid, "_CollectingMoney"));
	if(!GetPVarInt(playerid, "_CollectingMoney")) SetTimerEx("collectMoney", 10000, false, "ii", playerid, iSafeID);
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0);
	RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 2);
	RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 1);
	SetPlayerAttachedObject(playerid,MAX_PLAYER_ATTACHED_OBJECTS - 2,1550,1,0.059999,-0.245000,0.057000,-4.199984,6.600003,99.299903,1.000000,1.000000,1.000000);
	SetPlayerAttachedObject(playerid,MAX_PLAYER_ATTACHED_OBJECTS - 1,1550,1,0.017999,-0.235000,-0.136999,168.799987,-3.799941,35.799995,1.000000,1.000000,1.000000);
	SetPVarInt(playerid, "_HasBag", 1);
	GameTextForPlayer(playerid, "~g~Collecting...", 5000, 5);
	DisablePlayerCheckpoint(playerid);
	if(!GetGVarInt("RobberyDeliverPickupID")) SetGVarInt("RobberyDeliverPickupID", CreateDynamicPickup(1274, 1, arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][0], arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][1], arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][2], 0));
	SetPlayerCheckpoint(playerid, arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][0], arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][1], arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][2], 5.0);
}


stopCollectMoney(playerid)
{
	KillTimer(GetPVarInt(playerid, "_CollectingMoney"));
	DeletePVar(playerid, "_RobbingSafe");
	DeletePVar(playerid, "_CollectingMoney");
}

forward Safe_ResetAnims(playerid);
public Safe_ResetAnims(playerid)
{
	DeletePVar(playerid, "_SafeInjured");
	TogglePlayerControllable(playerid, 1);
	ClearAnimations(playerid);
	return 1;
}

CalculateMaxRobAmount() {

	new globcollected = GetGVarInt("_GCollect"),
		iSafeMoney = GetGVarInt("SafeMoney");
		
	if(globcollected > 5000000 || globcollected >= iSafeMoney) return 0;
	return 1;
}

forward collectMoney(playerid, iSafeID);
public collectMoney(playerid, iSafeID)
{
	szMiscArray[0] = 0;
	if(iSafeID != GetSafeID(playerid))
	{
		stopCollectMoney(playerid);
		return 1;
	}
	new collected = GetPVarInt(playerid, "_CollectedMoney"),
		globcollected = GetGVarInt("SafeMoney");

	collected += ROB_COLLECT_RATE;
	globcollected += ROB_COLLECT_RATE;
	// DEBUG
	// format(szMiscArray, sizeof(szMiscArray), "MONEY: %i | PERCENTAGE: %i", SafeData[iSafeID][safe_iInitialMoney], SafeData[iSafeID][safe_iInitialMoney] * ROB_MAX_PERCENTAGE / 100);
	// SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);	
	if(!CalculateMaxRobAmount())
	{
		stopCollectMoney(playerid);
		ClearAnimations(playerid);
		return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "The safe is empty.");
	}

	SetGVarInt("_GCollect", globcollected);
	new robberid = GetPVarInt(playerid, "_RobberID");
	format(szMiscArray, sizeof(szMiscArray), "Money Bag: $%S (ID: %i)\nDropped by: %s", number_format(collected), robberid, GetPlayerNameEx(playerid));
	
	if(!IsValidDynamic3DTextLabel(MoneyBagData[robberid][safe_iTextLabel]))
	{
		MoneyBagData[robberid][safe_iTextLabel] = CreateDynamic3DTextLabel(szMiscArray, COLOR_LIGHTBLUE, 0.0, -0.3, 0.0, 10.0, playerid, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
	}
	else Update3DTextLabelText(MoneyBagData[robberid][safe_iTextLabel], COLOR_LIGHTBLUE, szMiscArray);
	SetPVarInt(playerid, "_CollectingMoney", 1);
	SetPVarInt(playerid, "_CollectedMoney", collected);
	GivePlayerCash(playerid, collected);
	format(szMiscArray, sizeof(szMiscArray), "You collected $%s from the safe. You now have $%s stored in your bag.", number_format(ROB_COLLECT_RATE), number_format(collected));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	SetTimerEx("collectMoney", 10000, false, "ii", playerid, iSafeID);
	return 1;
}

forward OnRobberyEnterBeacon(playerid);
public OnRobberyEnterBeacon(playerid)
{
	DeletePVar(playerid, "_RobberyBeacon");
}

saveSafe(iSafeID) {
	if(!(0 <= iSafeID < MAX_SAFES))
	    return 0;
	    
	if(!IsValidDynamicObject(SafeData[iSafeID][safe_iObjectID]))
	    return 0;
	    
	new
	    szQuery[512];
	    
	format(szQuery, sizeof szQuery, "UPDATE `safes` SET `safeType` = %i, \
		`safeTypeID` = %i, \
		`safeVW` = %i, \
	    `safeInt` = %i, \
		`safeModel` = %i, \
	    `safePosX` = %f, \
	    `safePosY` = %f, \
	    `safePosZ` = %f, \
		`safeRotX` = %f, \
		`safeRotY` = %f, \
	    `safeRotZ` = %f",
		SafeData[iSafeID][safe_iType],
		SafeData[iSafeID][safe_iTypeID],
		SafeData[iSafeID][safe_iVW],
		SafeData[iSafeID][safe_iInt],
		SafeData[iSafeID][safe_iModelID],
		SafeData[iSafeID][safe_fPos][0],
		SafeData[iSafeID][safe_fPos][1],
		SafeData[iSafeID][safe_fPos][2],
		SafeData[iSafeID][safe_fPos][3],
		SafeData[iSafeID][safe_fPos][4],
		SafeData[iSafeID][safe_fPos][5]
	);
	format(szQuery, sizeof szQuery, "%s, `safeMoney` = %i, \
		`safePin` = '%s', \
		`safeRobbed` = %i, \
		`safeRobbedTime` = %i \
		WHERE `safeDBID` = %i",
		szQuery,
		SafeData[iSafeID][safe_iMoney],
		SafeData[iSafeID][safe_iPin],
		SafeData[iSafeID][safe_iRobbed],
		SafeData[iSafeID][safe_tRobbedTime],
		SafeData[iSafeID][safe_iDBID]
    );
    return mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", NO_THREAD);
}

loadSafes() {
	printf("[LoadSafes] Loading Safes from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `safes`", true, "OnLoadSafes", "");
}

forward OnLoadSafes();
public OnLoadSafes() {
	new
	    iRows,
	    iFields;
	   
	cache_get_data(iRows, iFields, MainPipeline);
	
	if(!iRows) return printf("[LoadSafes] Failed to load any Safes.");
	    
	for(new iRow; iRow < iRows; iRow++) {

		SafeData[iRow][safe_iDBID] = cache_get_field_content_int(iRow, "safeDBID", MainPipeline);
		SafeData[iRow][safe_iType] = cache_get_field_content_int(iRow, "safeType", MainPipeline);
		SafeData[iRow][safe_iTypeID] = cache_get_field_content_int(iRow, "safeTypeID", MainPipeline);
		SafeData[iRow][safe_iVW] = cache_get_field_content_int(iRow, "safeVW", MainPipeline);
		SafeData[iRow][safe_iInt] = cache_get_field_content_int(iRow, "safeInt", MainPipeline);
		SafeData[iRow][safe_iModelID] = cache_get_field_content_int(iRow, "safeModel", MainPipeline);
		SafeData[iRow][safe_fPos][0] = cache_get_field_content_float(iRow, "safePosX", MainPipeline);
		SafeData[iRow][safe_fPos][1] = cache_get_field_content_float(iRow, "safePosY", MainPipeline);
		SafeData[iRow][safe_fPos][2] = cache_get_field_content_float(iRow, "safePosZ", MainPipeline);
		SafeData[iRow][safe_fPos][3] = cache_get_field_content_float(iRow, "safeRotX", MainPipeline);
		SafeData[iRow][safe_fPos][4] = cache_get_field_content_float(iRow, "safeRotY", MainPipeline);
		SafeData[iRow][safe_fPos][5] = cache_get_field_content_float(iRow, "safeRotZ", MainPipeline);
		SafeData[iRow][safe_iMoney] = cache_get_field_content_int(iRow, "safeMoney", MainPipeline);
		cache_get_field_content(iRow, "safePin", SafeData[iRow][safe_iPin], MainPipeline, 5);
		SafeData[iRow][safe_iRobbed] = cache_get_field_content_int(iRow, "safeRobbed", MainPipeline);
		SafeData[iRow][safe_tRobbedTime] = cache_get_field_content_int(iRow, "safeRobbedTime", MainPipeline);

		processSafe(iRow);
	}
	return printf("[MySQL] Loaded %i Safes from database.", iRows);
}


forward onCreateSafe(iExtraID, iSafeID); 
public onCreateSafe(iExtraID, iSafeID)
{
	szMiscArray[0] = 0;
	new
	    iDBID = cache_insert_id(MainPipeline);
	    
	SafeData[iSafeID][safe_iDBID] = iDBID;
	processSafe(iSafeID);
	format(szMiscArray, sizeof szMiscArray, "You have created an Safe using ID %i (DBID: %i).", iSafeID, iDBID);
	SendClientMessageEx(iExtraID, 0xFFFFFFFF, szMiscArray);	
	return 1;
}

safeMenu(playerid)
{
	new	szTitle[64],
		iSafeID = GetSafeID(playerid);
	if(iSafeID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near a safe.");
	SetPVarInt(playerid, "_EditingSafeID", iSafeID);
	format(szTitle, sizeof(szTitle), "%s's Safe Menu (ID: %i)", "test", iSafeID);
	ShowPlayerDialog(playerid, DIALOG_SAFE_MAIN, DIALOG_STYLE_LIST, szTitle, "Request Balance Sheet\nWithdraw Money\nDeposit Money\nEdit PIN", "Proceed", "Cancel");
	return 1;
}


destroySafe(iSafeID)
{
	if(IsValidDynamic3DTextLabel(SafeData[iSafeID][safe_iTextLabel]))
		DestroyDynamic3DTextLabel(SafeData[iSafeID][safe_iTextLabel]);
	if(IsValidDynamicObject(SafeData[iSafeID][safe_iObjectID]))
		DestroyDynamicObject(SafeData[iSafeID][safe_iObjectID]);
	if(IsValidDynamicArea(SafeData[iSafeID][safe_iAreaID]))
		DestroyDynamicArea(SafeData[iSafeID][safe_iAreaID]);
}

destroyMoneyBag(iBagID)
{
	if(IsValidDynamic3DTextLabel(MoneyBagData[iBagID][safe_iTextLabel]))
		DestroyDynamic3DTextLabel(MoneyBagData[iBagID][safe_iTextLabel]);
	if(IsValidDynamicObject(MoneyBagData[iBagID][mb_iObjectID]))
		DestroyDynamicObject(MoneyBagData[iBagID][mb_iObjectID]);
}

processSafe(iSafeID) {
	szMiscArray[0] = 0;
	if(!(0 <= iSafeID < MAX_SAFES)) return 0;
	    
	if(SafeData[iSafeID][safe_tRobbedTime] != 0 && SafeData[iSafeID][safe_tRobbedTime] < (gettime() - 86400 * 2)) SafeData[iSafeID][safe_iRobbed] = 0;
	
	if(IsValidDynamicObject(SafeData[iSafeID][safe_iObjectID])) 
		destroySafe(iSafeID);
	
	if(SafeData[iSafeID][safe_iModelID] == 2332 && SafeData[iSafeID][safe_iRobbed]) 
	{
		SafeData[iSafeID][safe_iObjectID] = CreateDynamicObject(1829, SafeData[iSafeID][safe_fPos][0], SafeData[iSafeID][safe_fPos][1], SafeData[iSafeID][safe_fPos][2], SafeData[iSafeID][safe_fPos][3], SafeData[iSafeID][safe_fPos][4],SafeData[iSafeID][safe_fPos][5], SafeData[iSafeID][safe_iVW], SafeData[iSafeID][safe_iInt]);
	}
	else SafeData[iSafeID][safe_iObjectID] = CreateDynamicObject(SafeData[iSafeID][safe_iModelID], SafeData[iSafeID][safe_fPos][0], SafeData[iSafeID][safe_fPos][1], SafeData[iSafeID][safe_fPos][2], SafeData[iSafeID][safe_fPos][3], SafeData[iSafeID][safe_fPos][4],SafeData[iSafeID][safe_fPos][5], SafeData[iSafeID][safe_iVW], SafeData[iSafeID][safe_iInt]);
	
	SafeData[iSafeID][safe_iAreaID] = CreateDynamicSphere(SafeData[iSafeID][safe_fPos][0], SafeData[iSafeID][safe_fPos][1], SafeData[iSafeID][safe_fPos][2], 5.0, SafeData[iSafeID][safe_iVW], SafeData[iSafeID][safe_iInt]);

	new iTypeID = SafeData[iSafeID][safe_iTypeID];
	switch(SafeData[iSafeID][safe_iType])
	{
		case 0: format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}(ID: %i)\n{FFFF00}UNSPECIFIED\n{FFFFFF}%s", iSafeID);
		case 1: format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}(ID: %i)\n{FFFF00}Bank Safe", iSafeID, arrGroupData[iTypeID][g_szGroupName]);
		case 2: format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}(ID: %i)\n{FFFF00}Group Safe\n{%s}%s", iSafeID, Group_NumToDialogHex(arrGroupData[iTypeID][g_hDutyColour]), arrGroupData[iTypeID][g_szGroupName]);
		case 3: format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}(ID: %i)\n{FFFF00}Business Safe\n{FFFFFF}%s\nOwner: %s", iSafeID, Businesses[iTypeID][bName], StripUnderscore(Businesses[iTypeID][bOwnerName]));
		case 4: format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}(ID: %i)\n{FFFF00}Player Safe\n{FFFFFF}Owner: UNSPECIFIED", iSafeID, StripUnderscore(Businesses[iTypeID][bOwnerName]));
	}
	if(SafeData[iSafeID][safe_iRobbed]) strins(szMiscArray, "\n{FF0000}Robbed", strlen(szMiscArray), sizeof(szMiscArray)+20);
	SafeData[iSafeID][safe_iTextLabel] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, SafeData[iSafeID][safe_fPos][0], SafeData[iSafeID][safe_fPos][1], SafeData[iSafeID][safe_fPos][2] + 0.75, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, SafeData[iSafeID][safe_iVW], SafeData[iSafeID][safe_iInt]);
	return 1;
}

safeEditMenu(playerid)
{
	new szTitle[64],
		iSafeID = GetPVarInt(playerid, "_EditingSafeID");
	switch(SafeData[iSafeID][safe_iType])
	{
		case 0: format(szTitle, sizeof(szTitle), "Safe Menu | (NONE)");
		case 1: format(szTitle, sizeof(szTitle), "Safe Menu | State Bank (Bank)");
		case 2: format(szTitle, sizeof(szTitle), "Safe Menu | {%s}%s", Group_NumToDialogHex(arrGroupData[SafeData[iSafeID][safe_iTypeID]][g_hDutyColour]), arrGroupData[SafeData[iSafeID][safe_iTypeID]][g_szGroupName]);
		case 3: format(szTitle, sizeof(szTitle), "Safe Menu | %s (Business)", Businesses[SafeData[iSafeID][safe_iTypeID]][bName]);
		case 4: format(szTitle, sizeof(szTitle), "Safe Menu | %s (Player)", GetPlayerNameEx(SafeData[iSafeID][safe_iTypeID]));
	}
	ShowPlayerDialog(playerid, DIALOG_SAFE_CREATE, DIALOG_STYLE_LIST, szTitle, "\
		Safe Type (Bank / Group / Business)\n\
		Safe Type ID\n\
		Safe Size\n\
		Safe Position\n\
		Safe PIN\n\
		Finish Safe", "Select", "Cancel");
	return 1;
}

safeCreate(playerid)
{	
	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		for(new i = 0; i < MAX_SAFES; ++i) if(!IsValidDynamicObject(SafeData[i][safe_iObjectID]))
		{
			SafeData[i][safe_iType] = 0;
			SafeData[i][safe_iTypeID] = 0;
			SafeData[i][safe_iModelID] = 2332;
			SafeData[i][safe_iVW] = GetPlayerVirtualWorld(playerid);
			SafeData[i][safe_iInt] = GetPlayerInterior(playerid);
			SafeData[i][safe_iMoney] = 0;
			SafeData[i][safe_iRobbed] = 0;
			SafeData[i][safe_tRobbedTime] = 0;
			GetPlayerPos(playerid, SafeData[i][safe_fPos][0], SafeData[i][safe_fPos][1], SafeData[i][safe_fPos][2]);
			GetPlayerFacingAngle(playerid, SafeData[i][safe_fPos][5]);
			format(SafeData[i][safe_iPin], MAX_PLAYER_NAME, "0000");
			format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `safes` (`safeDBID`, `safeModel`, `safeType`, `safeTypeID`, `safeVW`, `safeINT`, `safePosX`, `safePosY`, `safePosZ`, `safeRotX`, `safeRotY`, `safeRotZ`, \
				`safeMoney`, `safePin`, `safeRobbed`, `safeRobbedTime`) VALUES (%i, %i, %i, %i, %i, %i, %f, %f, %f, %f, %f, %f, %i, '%s', %i, %i)",
				SafeData[i][safe_iDBID],
				SafeData[i][safe_iModelID],
				SafeData[i][safe_iType],
				SafeData[i][safe_iTypeID],
				SafeData[i][safe_iVW],
				SafeData[i][safe_iInt],
				SafeData[i][safe_fPos][0],
				SafeData[i][safe_fPos][1],
				SafeData[i][safe_fPos][2],
				SafeData[i][safe_fPos][3],
				SafeData[i][safe_fPos][4],
				SafeData[i][safe_fPos][5],
				SafeData[i][safe_iMoney],
				SafeData[i][safe_iPin],
				SafeData[i][safe_iRobbed],
				SafeData[i][safe_tRobbedTime]
			);
			return mysql_function_query(MainPipeline, szMiscArray, true, "onCreateSafe", "ii", playerid, i);
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "There are no more safe slots available.");
	}
	return 1;
}

ProxGangMemberCheck(playerid)
{
	szMiscArray[0] = 0;
	new count;
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember] && GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid) && GetPlayerInterior(i) == GetPlayerInterior(playerid))
		{
			if(count > MAX_ROBBERS)
			{
				format(szMiscArray, sizeof(szMiscArray), "You cannot have more than %i robbers. You now have %i available.", MAX_ROBBERS, count);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, szMiscArray);
				return 0;
			}
			SetPVarInt(i, "_RobberID", count);
			format(szMiscArray, sizeof(szMiscArray), "You are now part of the heist. (Robber ID: %i)", count);			
			SendClientMessageEx(i, COLOR_LIGHTRED, szMiscArray);
			count++;
		}
	}
	if(count >= ROB_MIN_MEMBERS) return 1;
	else return 0;
}

IsPlayerGangLeader(playerid)
{
	if(PlayerInfo[playerid][pMember] > -1 && PlayerInfo[playerid][pLeader] > -1) return 1;
	else return 0;
}

checkRobbery(playerid)
{
	SendClientMessageEx(playerid, COLOR_YELLOW, "Awaiting approval..." );
	format(szMiscArray, sizeof(szMiscArray), "Robbery Request - ((/approve)(/deny)robbery) - %s", GetPlayerNameEx(playerid));
	ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
}

initiateRobbery(playerid)
{
	szMiscArray[0] = 0;
	if(GetGVarInt("RobberyStage")) return SendClientMessageEx(playerid, COLOR_YELLOW,"A robbery is already taking place.");
	format(szMiscArray, sizeof(szMiscArray), "* %s initiated the robbery.", GetPlayerNameEx(playerid));
	ProxDetector(10.0, playerid, szMiscArray, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
	SetGVarInt("RobberyStage", 1);
	OnRobbery(playerid, PlayerInfo[playerid][pMember]);
	return 1;
}

denyRobbery(playerid)
{
	szMiscArray[0] = 0;
	if(GetGVarInt("RobberyStage")) return SendClientMessageEx(playerid, COLOR_YELLOW,"A robbery is already taking place.");
	format(szMiscArray, sizeof(szMiscArray), "* %s's robbery request has been denied by an admin.", GetPlayerNameEx(playerid));
	ProxDetector(10.0, playerid, szMiscArray, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
	DeleteGVar("RobberyPlayerID");
	DeleteGVar("RobbedSafeID");
	foreach(new i : Player) if(GetPVarType(i, "_RobberID")) DeletePVar(i, "_RobberID");
	return 1;
}

stopRobbery()
{
	if(IsValidDynamicPickup(GetGVarInt("RobberyDeliverPickupID")))
		DestroyDynamicPickup(GetGVarInt("RobberyDeliverPickupID"));
	if(IsValidDynamicPickup(GetGVarInt("RobberyEntrancePickupID")))
		DestroyDynamicPickup(GetGVarInt("RobberyEntrancePickupID"));
	DeleteGVar("RobbedSafeID");
	DeleteGVar("RobberyStage");
	DeleteGVar("RobberyPlayerID");
	DeleteGVar("RobberyDeliverPickupID");
	DeleteGVar("RobberyEntrancePickupID");
	TextGrid_Init();
	TextGrid_SaveInit();
	foreach(new i : Player)
	{
		if(GetPVarType(i, "_HasBag"))
		{
			RemovePlayerAttachedObject(i, MAX_PLAYER_ATTACHED_OBJECTS - 2);
			RemovePlayerAttachedObject(i, MAX_PLAYER_ATTACHED_OBJECTS - 1);
		}
		DeletePVar(i, "_RobbingSafe");
		DeletePVar(i, "_RobberID");
		DeletePVar(i, "_CollectTimer");
		DeletePVar(i, "_CollectedMoney");
	}
	for(new i; i < MAX_ROBBERS; i++) destroyMoneyBag(i);
	return 1;
}


forward OnRobbery(playerid, groupid);
public OnRobbery(playerid, groupid)
{
	szMiscArray[0] = 0;
	new stage = GetGVarInt("RobberyStage"),
		iSafeID = GetGVarInt("RobbedSafeID");
	switch(stage)
	{
		case 1:
		{
			SetTimerEx("OnRobbery", 60000 * 1, false, "ii", playerid, PlayerInfo[playerid][pMember]);
			SetGVarInt("RobberyStage", 2);
			format(szMiscArray, sizeof(szMiscArray), "Robbing Safe ID: %i", iSafeID);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			SafeData[iSafeID][safe_iRobberyPickup] = CreateDynamicPickup(1212, 23, SafeData[iSafeID][safe_fPos][0], SafeData[iSafeID][safe_fPos][1], SafeData[iSafeID][safe_fPos][2] + 1.0);
			foreach(new giveplayerid : Player) {
				if(GetPVarType(giveplayerid, "_RobberID")) {

					SetPlayerCheckpoint(giveplayerid, SafeData[iSafeID][safe_fPos][0], SafeData[iSafeID][safe_fPos][1], SafeData[iSafeID][safe_fPos][2], 2.0);
				}
			}
		}
		case 2:
		{
			new szMessage[128];
			switch(SafeData[iSafeID][safe_iType])
			{
				case 1: szMessage = "** DISPATCH: All units, there is a robbery at the bank. (/rbeacon)";
				case 2: format(szMessage, sizeof(szMessage), "** DISPATCH: All units, there is a robbery at %s. (/rbeacon)", arrGroupData[SafeData[iSafeID][safe_iTypeID]][g_szGroupName]);
				case 3: format(szMessage, sizeof(szMessage), "** DISPATCH: All units, there is a robbery at %s. (/rbeacon)", arrGroupData[SafeData[iSafeID][safe_iTypeID]][g_szGroupName]);
				case 4: format(szMessage, sizeof(szMessage), "** DISPATCH: All units, there is a robbery at %s. (/rbeacon)", Businesses[SafeData[iSafeID][safe_iTypeID]][bName]);
				case 5: szMessage = "** DISPATCH: All units, there is a robbery at someone's house. (/rbeacon)";				
			}
			SendGroupMessage(1, COLOR_LIGHTRED, szMessage);
			SetGVarInt("RobberyStage", 3);		
		}
	}
	return 1;
}

checkSafePerms(playerid)
{
	new iSafeID = GetSafeID(playerid);
	switch(SafeData[iSafeID][safe_iType])
	{
		case 1: if(PlayerInfo[playerid][pAdmin] < 4) return 1;
		case 2: if(SafeData[iSafeID][safe_iTypeID] == PlayerInfo[playerid][pLeader]) return 1;
		case 3: if(SafeData[iSafeID][safe_iTypeID] == PlayerInfo[playerid][pBusiness] && PlayerInfo[playerid][pBusinessRank] == 5) return 1;
	}
	return 0;
}

breachSafe(playerid)
{
	TogglePlayerControllable(playerid, 0);
	// TextDrawSetString(safe_TextDraw[4], arrGroupData[SafeData[GetSafeID(playerid)][safe_iTypeID]][g_szGroupName]);
	if(GetPVarType(playerid, "_ShowingSafe"))
	{
	    DeletePVar(playerid, "_ShowingSafe");
		CancelSelectTextDraw(playerid);
		for(new i; i < sizeof(safe_TextDraw); ++i) TextDrawHideForPlayer(playerid, safe_TextDraw[i]);
		for(new i; i < sizeof(TextGrid); ++i) TextDrawHideForPlayer(playerid, TextGrid[i][text_iTextID]);
	}
	else
	{
		SelectTextDraw(playerid, 0x00FF00FF);
    	SetPVarInt(playerid, "_ShowingSafe", 1);
		for(new i; i < sizeof(safe_TextDraw); ++i) TextDrawShowForPlayer(playerid, safe_TextDraw[i]);
		for(new i; i < sizeof(TextGrid); ++i) TextDrawShowForPlayer(playerid, TextGrid[i][text_iTextID]);
	}
}

dropBag(playerid)
{
	szMiscArray[0] = 0;
	if(GetPVarType(playerid, "_HasBag"))
	{
		new iRobberID = GetPVarInt(playerid, "_RobberID");
		MoneyBagData[iRobberID][safe_iMoney] = GetPVarInt(playerid, "_CollectedMoney");
		DeletePVar(playerid, "_CollectedMoney");
		DeletePVar(playerid, "_HasBag");
		// GivePlayerCash(playerid, -MoneyBagData[iRobberID][safe_iMoney]);
		GetPlayerPos(playerid, MoneyBagData[iRobberID][safe_fPos][0], MoneyBagData[iRobberID][safe_fPos][1], MoneyBagData[iRobberID][safe_fPos][2]);
		RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 2);
		RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 1);
		MoneyBagData[iRobberID][mb_iObjectID] = CreateDynamicObject(1550, MoneyBagData[iRobberID][safe_fPos][0], MoneyBagData[iRobberID][safe_fPos][1], MoneyBagData[iRobberID][safe_fPos][2]-0.5, 0.0, 90.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		DestroyDynamic3DTextLabel(MoneyBagData[iRobberID][safe_iTextLabel]);
		format(szMiscArray, sizeof(szMiscArray), "Money Bag: $%s (ID: %i)", number_format(MoneyBagData[iRobberID][safe_iMoney]), iRobberID);
		MoneyBagData[iRobberID][safe_iTextLabel] = CreateDynamic3DTextLabel(szMiscArray, COLOR_LIGHTBLUE, MoneyBagData[iRobberID][safe_fPos][0], MoneyBagData[iRobberID][safe_fPos][1], MoneyBagData[iRobberID][safe_fPos][2], 10.0, INVALID_PLAYER_ID);
	}
}

TextGrid_SaveInit()
{
	new counter = 0;
	for(new i; i < sizeof(TextGrid); ++i)
	{
		if(counter > 3) break;
		new rand = random(sizeof(TextGrid));
		if(TextGrid[rand][text_iMine] == 0)
		{
			counter++;
			TextGrid[rand][text_iSave] = 1;
		}
	}
}

TextGrid_Init()
{
	new Float:x = 275.0, Float:y = 152.0;
	for(new i; i < sizeof(TextGrid); ++i) TextGrid[i][text_iMine] = 0;
	for(new i; i < 2; ++i)
	{
		new rand = random(sizeof(TextGrid));
		if(TextGrid[rand][text_iSave] == 0) TextGrid[rand][text_iMine] = 1;
	}
	
	for(new i; i < sizeof(TextGrid); ++i)
	{
		if(x > 380.0 && y < 320.0) 
		{
			y += 30.0;	
			x = 275.0; 
		}
		if(x < 421.0)
		{
			TextGrid[i][text_iTextID] = TextDrawCreate(x, y, "-");
		}
		x += 30.0;
		TextDrawAlignment(TextGrid[i][text_iTextID], 2);
		TextDrawBackgroundColor(TextGrid[i][text_iTextID], 255);
		TextDrawFont(TextGrid[i][text_iTextID], 1);
		TextDrawLetterSize(TextGrid[i][text_iTextID], 0.500000, 1.400000);
		TextDrawColor(TextGrid[i][text_iTextID], 0xFFEEEEEE);
		TextDrawSetOutline(TextGrid[i][text_iTextID], 0);
		TextDrawSetProportional(TextGrid[i][text_iTextID], 1);
		TextDrawSetShadow(TextGrid[i][text_iTextID], 1);
		TextDrawUseBox(TextGrid[i][text_iTextID], 1);
		TextDrawBoxColor(TextGrid[i][text_iTextID], 0xFFEEEEEE);
		TextDrawTextSize(TextGrid[i][text_iTextID], 22.000000, 22.000000);
		TextDrawSetSelectable(TextGrid[i][text_iTextID], 1);
	}
}

TextGrid_Destroy()
{
    foreach(new playerid : Player)
    {
    	if(GetPVarType(playerid, "_ShowingSafe"))
    	{
    		DeletePVar(playerid, "_ShowingSafe");
			CancelSelectTextDraw(playerid);
			TogglePlayerControllable(playerid, 1);
			for(new i; i < sizeof(safe_TextDraw); ++i) TextDrawHideForPlayer(playerid, safe_TextDraw[i]);
			for(new i; i < sizeof(TextGrid); ++i)
			{
				TextGrid[i][text_iMine] = 0;
				TextDrawHideForPlayer(playerid, TextGrid[i][text_iTextID]);
				TextDrawDestroy(TextGrid[i][text_iTextID]);
			}
    	}
    }
	TextGrid_Init();
}

TextSafe_Init()
{
	safe_TextDraw[0] = TextDrawCreate(321.000000, 90.000000, "pad_background");
	TextDrawAlignment(safe_TextDraw[0], 2);
	TextDrawBackgroundColor(safe_TextDraw[0], 255);
	TextDrawFont(safe_TextDraw[0], 1);
	TextDrawLetterSize(safe_TextDraw[0], 2.100000, 20.000000);
	TextDrawColor(safe_TextDraw[0], 0);
	TextDrawSetOutline(safe_TextDraw[0], 0);
	TextDrawSetProportional(safe_TextDraw[0], 1);
	TextDrawSetShadow(safe_TextDraw[0], 0);
	TextDrawUseBox(safe_TextDraw[0], 1);
	TextDrawBoxColor(safe_TextDraw[0], 150);
	TextDrawTextSize(safe_TextDraw[0], 100.000000, 120.000000);
	TextDrawSetSelectable(safe_TextDraw[0], 0);

	safe_TextDraw[1] = TextDrawCreate(320.000000, 93.000000, "SAFE");
	TextDrawAlignment(safe_TextDraw[1], 2);
	TextDrawBackgroundColor(safe_TextDraw[1], 255);
	TextDrawFont(safe_TextDraw[1], 2);
	TextDrawLetterSize(safe_TextDraw[1], 0.539999, 2.000000);
	TextDrawColor(safe_TextDraw[1], -1);
	TextDrawSetOutline(safe_TextDraw[1], 0);
	TextDrawSetProportional(safe_TextDraw[1], 1);
	TextDrawSetShadow(safe_TextDraw[1], 1);
	TextDrawSetSelectable(safe_TextDraw[1], 0);

	safe_TextDraw[2] = TextDrawCreate(321.000000, 280.000000, "pad_line2bot");
	TextDrawAlignment(safe_TextDraw[2], 2);
	TextDrawBackgroundColor(safe_TextDraw[2], 255);
	TextDrawFont(safe_TextDraw[2], 1);
	TextDrawLetterSize(safe_TextDraw[2], 2.369999, -0.900000);
	TextDrawColor(safe_TextDraw[2], 0);
	TextDrawSetOutline(safe_TextDraw[2], 0);
	TextDrawSetProportional(safe_TextDraw[2], 1);
	TextDrawSetShadow(safe_TextDraw[2], 0);
	TextDrawUseBox(safe_TextDraw[2], 1);
	TextDrawBoxColor(safe_TextDraw[2], -6);
	TextDrawTextSize(safe_TextDraw[2], 530.000000, 120.000000);
	TextDrawSetSelectable(safe_TextDraw[2], 0);

	safe_TextDraw[3] = TextDrawCreate(321.000000, 275.000000, "pad_line2bot");
	TextDrawAlignment(safe_TextDraw[3], 2);
	TextDrawBackgroundColor(safe_TextDraw[3], 255);
	TextDrawFont(safe_TextDraw[3], 1);
	TextDrawLetterSize(safe_TextDraw[3], 2.369999, -0.900000);
	TextDrawColor(safe_TextDraw[3], 0);
	TextDrawSetOutline(safe_TextDraw[3], 0);
	TextDrawSetProportional(safe_TextDraw[3], 1);
	TextDrawSetShadow(safe_TextDraw[3], 0);
	TextDrawUseBox(safe_TextDraw[3], 1);
	TextDrawBoxColor(safe_TextDraw[3], 842150450);
	TextDrawTextSize(safe_TextDraw[3], 530.000000, 120.000000);
	TextDrawSetSelectable(safe_TextDraw[3], 0);

	safe_TextDraw[4] = TextDrawCreate(320.000000, 118.000000, "");
	TextDrawAlignment(safe_TextDraw[4], 2);
	TextDrawBackgroundColor(safe_TextDraw[4], 255);
	TextDrawFont(safe_TextDraw[4], 2);
	TextDrawLetterSize(safe_TextDraw[4], 0.300000, 1.599999);
	TextDrawColor(safe_TextDraw[4], 0xFFDDEEFF);
	TextDrawSetOutline(safe_TextDraw[4], 0);
	TextDrawSetProportional(safe_TextDraw[4], 1);
	TextDrawSetShadow(safe_TextDraw[4], 1);
	TextDrawSetSelectable(safe_TextDraw[4], 0);

	

	safe_TextDraw[6] = TextDrawCreate(284.000000, 280.000000, "CANCEL");
	TextDrawAlignment(safe_TextDraw[6], 2);
	TextDrawBackgroundColor(safe_TextDraw[6], 255);
	TextDrawFont(safe_TextDraw[6], 2);
	TextDrawLetterSize(safe_TextDraw[6], 0.280000, 1.300000);
	TextDrawColor(safe_TextDraw[6], -1);
	TextDrawSetOutline(safe_TextDraw[6], 0);
	TextDrawSetProportional(safe_TextDraw[6], 1);
	TextDrawSetShadow(safe_TextDraw[6], 1);
	TextDrawUseBox(safe_TextDraw[6], 1);
	TextDrawBoxColor(safe_TextDraw[6], -938863416);
	TextDrawTextSize(safe_TextDraw[6], 195.000000, 44.000000);
	TextDrawSetSelectable(safe_TextDraw[6], 1);

	safe_TextDraw[7] = TextDrawCreate(359.000000, 280.000000, "BREACH");
	TextDrawAlignment(safe_TextDraw[7], 2);
	TextDrawBackgroundColor(safe_TextDraw[7], 255);
	TextDrawFont(safe_TextDraw[7], 2);
	TextDrawLetterSize(safe_TextDraw[7], 0.250000, 1.300000);
	TextDrawColor(safe_TextDraw[7], 0);
	TextDrawSetOutline(safe_TextDraw[7], 0);
	TextDrawSetProportional(safe_TextDraw[7], 1);
	TextDrawSetShadow(safe_TextDraw[7], 1);
	TextDrawUseBox(safe_TextDraw[7], 1);
	TextDrawBoxColor(safe_TextDraw[7], 0xDDFFEEFF);
	TextDrawTextSize(safe_TextDraw[7], 195.000000, 44.000000);
	TextDrawSetSelectable(safe_TextDraw[7], 1);


	safe_TextDraw[8] = TextDrawCreate(321.000000, 91.000000, "pad_line1top");
	TextDrawAlignment(safe_TextDraw[8], 2);
	TextDrawBackgroundColor(safe_TextDraw[8], 255);
	TextDrawFont(safe_TextDraw[8], 1);
	TextDrawLetterSize(safe_TextDraw[8], 2.369999, -0.900000);
	TextDrawColor(safe_TextDraw[8], 0);
	TextDrawSetOutline(safe_TextDraw[8], 0);
	TextDrawSetProportional(safe_TextDraw[8], 1);
	TextDrawSetShadow(safe_TextDraw[8], 0);
	TextDrawUseBox(safe_TextDraw[8], 1);
	TextDrawBoxColor(safe_TextDraw[8], -6);
	TextDrawTextSize(safe_TextDraw[8], 530.000000, 120.000000);
	TextDrawSetSelectable(safe_TextDraw[8], 0);
}

CMD:rbeacon(playerid, params[])
{
	if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a LEO.");
	if(GetGVarInt("RobberyStage") < 3) return 1;
	else
	{
		new iSafeID = GetGVarInt("RobbedSafeID"),
			iTypeID = SafeData[iSafeID][safe_iTypeID];
		SetPVarInt(playerid, "_RobberyBeacon", 1);
		switch(SafeData[iSafeID][safe_iType])
		{
			case 1: 
			{
				SetPlayerCheckpoint(playerid, 1458.5452, -1012.2787, 27.3707, 4.0);
				if(GetGVarInt("RobberyEntrancePickupID"))
					SetGVarInt("RobberyEntrancePickupID", CreateDynamicPickup(1313, 1, 1458.5452, -1012.2787, 27.3707, 0));
			}
			case 2: 
			{
				SetPlayerCheckpoint(playerid, arrGroupData[iTypeID][g_fGaragePos][0], arrGroupData[iTypeID][g_fGaragePos][1], arrGroupData[iTypeID][g_fGaragePos][2], 4.0);
				if(GetGVarInt("RobberyEntrancePickupID"))
					SetGVarInt("RobberyEntrancePickupID", CreateDynamicPickup(1313, 1, arrGroupData[iTypeID][g_fGaragePos][0], arrGroupData[iTypeID][g_fGaragePos][1], arrGroupData[iTypeID][g_fGaragePos][2], 0));
			}
			case 3: 
			{
				SetPlayerCheckpoint(playerid, arrGroupData[iTypeID][g_fGaragePos][0], arrGroupData[iTypeID][g_fGaragePos][1], arrGroupData[iTypeID][g_fGaragePos][2], 4.0);
				if(GetGVarInt("RobberyEntrancePickupID"))
					SetGVarInt("RobberyEntrancePickupID", CreateDynamicPickup(1313, 1, arrGroupData[iTypeID][g_fGaragePos][0], arrGroupData[iTypeID][g_fGaragePos][1], arrGroupData[iTypeID][g_fGaragePos][2], 0));
			}
			case 4: 
			{
				SetPlayerCheckpoint(playerid, Businesses[iTypeID][bExtPos][0], Businesses[iTypeID][bExtPos][1], Businesses[iTypeID][bExtPos][2], 4.0);
				if(GetGVarInt("RobberyEntrancePickupID"))
					SetGVarInt("RobberyEntrancePickupID", CreateDynamicPickup(1313, 1, Businesses[iTypeID][bExtPos][0], Businesses[iTypeID][bExtPos][1], Businesses[iTypeID][bExtPos][2], 0));
			}
			case 5: 
			{
				SetPlayerCheckpoint(playerid, 0.0, 0.0, 0.0, 4.0);
				if(GetGVarInt("RobberyEntrancePickupID"))
					SetGVarInt("RobberyEntrancePickupID", CreateDynamicPickup(1313, 1, 0.0, 0.0, 0.0, 0));
			}
		}
	}
	return 1;
}

/*
CMD:mask(playerid, params[])
{
	if(GetPVarInt(playerid, "_WearingMask"))
	{
		DeletePVar(playerid, "_WearingMask");
		RemovePlayerAttachedObject(playerid, 9);
		foreach(new i: Player) 
		{
			if(PlayerInfo[i][pAdmin] == 0)
				ShowPlayerNameTagForPlayer(i, playerid, true);
		}
	}
	else
	{
		SetPVarInt(playerid, "_WearingMask", 1);
		SetPlayerAttachedObject(playerid, 9, 19801, 2, 0.060999, 0.024000, -0.000999, 5.400002, 85.799995, 176.399963, 1.310001, 1.230000, 1.133000);
		foreach(new i: Player) ShowPlayerNameTagForPlayer(i, playerid, false);
	}
	return 1;
}
*/

CMD:safehelp(playerid, params[]) {
	cmd_robhelp(playerid, "");
	return 1;
}

CMD:robhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_TWGREEN, "__________________________________");
	SendClientMessage(playerid, COLOR_WHITE, "Safe/Robbery Help");
	if(PlayerInfo[playerid][pAdmin] > 0) SendClientMessage(playerid, COLOR_LIGHTRED, "[Safe ADM] /createsafe - /editsafe - /safetome");
	if(PlayerInfo[playerid][pAdmin] > 0) SendClientMessage(playerid, COLOR_LIGHTRED, "[Robbery ADM] /editrobbery - /approverobbery - /denyrobbery");
	SendClientMessage(playerid, COLOR_GRAD1, "[Safe] /safe - /robsafe");
	SendClientMessage(playerid, COLOR_GRAD1, "[Robbery] /robbery - /robstatus - /dropbag - /takebag - /picklock - /placebomb");
	SendClientMessage(playerid, COLOR_TWGREEN, "__________________________________");
	return 1;
}

CMD:safe(playerid, params[])
{
	new iSafeID = GetSafeID(playerid);
	if(iSafeID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near a safe");
	if(PlayerInfo[playerid][pAdmin] == 0)
	{
		switch(SafeData[iSafeID][safe_iType])
		{
			case 1: if(!IsAdminLevel(playerid, ADMIN_SENIOR, 0)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot access this safe.");
			case 2: if(SafeData[iSafeID][safe_iTypeID] != PlayerInfo[playerid][pMember]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot access this safe.");
			case 3: if(SafeData[iSafeID][safe_iTypeID] != PlayerInfo[playerid][pBusiness]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot access this safe.");
		}
	}
	ShowPlayerDialog(playerid, DIALOG_SAFE_PIN, DIALOG_STYLE_INPUT, "Safe | Enter Pin", "Please enter the safe's pin to open it.", "X", "V");
	return 1;
}

CMD:createsafe(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have the authority to use this command");
	safeCreate(playerid);
	return 1;
}

CMD:editsafe(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have the authority to use this command");
	new iSafeID = GetSafeID(playerid);
	if(iSafeID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be near a safe to edit it.");
	SetPVarInt(playerid, "_EditingSafeID", iSafeID);
	safeEditMenu(playerid);
	return 1;
}

CMD:deletesafe(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have the authority to use this command");
	safeDelete(playerid, params);
	return 1;
}

CMD:safetome(playerid, params[]) {
	new iSafeID;
	if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have the authority to use this command");
	if(sscanf(params, "i", iSafeID)) return SendClientMessageEx(playerid, 0xFFFFFFFF, "Usage: /safetome [safeid]");
	safeMove(playerid, iSafeID);
	return 1;
}

CMD:dropbag(playerid, params[])
{
	dropBag(playerid);
	return 1;
}

CMD:takebag(playerid, params[])
{
	szMiscArray[0] = 0;
	if(!GetPVarType(playerid, "_HasBag"))
	{
		new iBagID = GetMoneyBagID(playerid);
		if(iBagID == -1) return 1;
		if(IsValidDynamic3DTextLabel(MoneyBagData[iBagID][safe_iTextLabel]))
		{
			format(szMiscArray, sizeof(szMiscArray), "Money Bag: $%s (ID: %i)", number_format(MoneyBagData[iBagID][safe_iMoney]), iBagID);
			DestroyDynamic3DTextLabel(MoneyBagData[iBagID][safe_iTextLabel]);
			SetPVarInt(playerid, "_RobberID", iBagID);
			MoneyBagData[iBagID][safe_iTextLabel] = CreateDynamic3DTextLabel(szMiscArray, COLOR_LIGHTBLUE, 0.0, -0.3, 0.0, 10.0, playerid, INVALID_VEHICLE_ID, 1);
		}
		DestroyDynamicObject(MoneyBagData[iBagID][mb_iObjectID]);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
		RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 2);
		RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 1);
		SetPlayerAttachedObject(playerid,MAX_PLAYER_ATTACHED_OBJECTS - 2,1550,1,0.059999,-0.245000,0.057000,-4.199984,6.600003,99.299903,1.000000,1.000000,1.000000);
		SetPlayerAttachedObject(playerid,MAX_PLAYER_ATTACHED_OBJECTS - 1,1550,1,0.017999,-0.235000,-0.136999,168.799987,-3.799941,35.799995,1.000000,1.000000,1.000000);
		SetPVarInt(playerid, "_HasBag", 1);
		SetPVarInt(playerid, "_CollectedMoney", MoneyBagData[iBagID][safe_iMoney]);
	}
	return 1;
}

CMD:approverobbery(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2) initiateRobbery(GetGVarInt("RobberyPlayerID"));
	return 1;
}

CMD:denyrobbery(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2) denyRobbery(GetGVarInt("RobberyPlayerID"));
	else ProxDetector(10.0, GetGVarInt("RobberyPlayerID"), "[ADM NOTICE] Your robbery request has been denied.", COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED);
	return 1;
}

CMD:robstatus(playerid, params[]) {

	if(IsACriminal(playerid) && GetPVarType(playerid, "_RobberID")) {

		new iCount;
		foreach(new i : Player) if(GetPVarType(playerid, "_RobberID")) iCount++;
		format(szMiscArray, sizeof(szMiscArray), "Total collected cash: $%s | Robbers: %d", number_format(GetGVarInt("_GCollect")), iCount);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
	}
	return 1;
}

CMD:robbery(playerid, params[])
{
	if(!IsACriminal(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You have to be in a gang to use this command.");
	new iSafeID = GetSafeID(playerid);
	if(iSafeID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near a safe.");
	if(IsPlayerGangLeader(playerid) && ProxGangMemberCheck(playerid))
	{
		SetGVarInt("RobberyPlayerID", playerid);
		SetGVarInt("RobbedSafeID", iSafeID);
		SetGVarInt("SafeMoney", 10000000); //changeme
		checkRobbery(playerid);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a gang leader or you do not have enough participating gang members.");	
	}
	return 1;	
}

CMD:editrobbery(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return 1;
	new szDialog[256];
	format(szDialog, sizeof(szDialog), "Robable percentage\t\t%i\nCollect rate\t\t$%s / 10s\nMinimum robbers\t\t%i", ROB_MAX_PERCENTAGE, number_format(ROB_COLLECT_RATE), ROB_MIN_MEMBERS);
	ShowPlayerDialog(playerid, DIALOG_ROBBERY_SETUP, DIALOG_STYLE_TABLIST, "Robbery Setup Menu", szDialog, "Select", "Cancel");
	return 1;
}

CMD:endrobbery(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return 1;
	stopRobbery();
	return 1;
}

CMD:robsafe(playerid, params[])
{
	if(!GetGVarInt("RobberyStage")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You did not get an approval yet.");
	if(GetSafeID(playerid) != GetGVarInt("RobbedSafeID")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near the safe.");
	ShowPlayerDialog(playerid, DIALOG_ROBBERY_SAFE, DIALOG_STYLE_INPUT, "Safe PIN", "Please enter the PIN to open the safe.", "Enter", "Cancel");
	return 1;
}

CMD:picklock(playerid, params[])
{
	szMiscArray[0] = 0;
	new targetid,
		time = 60000;
	if(PlayerInfo[playerid][pLockKit] < 1) return SendClientMessage(playerid, COLOR_GRAD1, "You do not have any items in your lock kit anymore.");
	if(GetPVarType(playerid, "_TargetID")) return SendClientMessage(playerid, COLOR_GRAD1, "You are already trying to breach something.");
	if(!PlayerInfo[playerid][pToolBox]) return SendClientMessageEx(playerid, COLOR_WHITE, "You need a Tool Box in order to lock pick a vehicle, get one from a Craftsman.");
	if(!PlayerInfo[playerid][pScrewdriver]) return SendClientMessageEx(playerid, COLOR_WHITE, "You need a Screwdriver in order to lock pick a vehicle, get one from a Craftsman.");

	time = 60000 - (5000 * PlayerInfo[playerid][pDetSkill]);
	targetid = GetNearestGateOrDoor(playerid);
	if(targetid == 0) return SendClientMessage(playerid, COLOR_GRAD1, "You are not near a gate or door.");
	SetPVarInt(playerid, "_TargetID", targetid);
	SetPVarInt(playerid, "_PickingLock", 1);
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, time, 0);
	format(szMiscArray, sizeof(szMiscArray), "%s attempts to pick a lock...", GetPlayerNameEx(playerid));
	ProxChatBubble(playerid, szMiscArray);
	SetTimerEx("LockPick_InitSeconds", 1000, false, "ii", playerid, time);
	return 1;
}

forward Player_ClearAnimations(playerid);
public Player_ClearAnimations(playerid)
{
	ClearAnimations(playerid);
	return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(GetPVarType(playerid, "_PickingLock"))
	{
		ClearAnimations(playerid);
		TogglePlayerControllable(playerid, 1);
		DeletePVar(playerid, "_PickingLock");
	}
	return 1;
}

forward LockPick_InitSeconds(playerid, time);
public LockPick_InitSeconds(playerid, time)
{
	szMiscArray[0] = 0;
	if(!GetPVarType(playerid, "_PickingLock")) return 1;
	time -= 1000;
	new timesec = time/1000;
	format(szMiscArray, sizeof(szMiscArray), "~w~ Picking... ~r~ %d", timesec);
	GameTextForPlayer(playerid, szMiscArray, 4000, 3);
	if(time > 1) return SetTimerEx("LockPick_InitSeconds", 1000, false, "ii", playerid, time);
	LockPick_Init(playerid);
	return 1;
}

forward LockPick_Init(playerid);
public LockPick_Init(playerid)
{
	new rand,
		targetid = GetPVarInt(playerid, "_TargetID"),
		targettype = GetPVarInt(playerid, "_TargetType");

	switch(PlayerInfo[playerid][pDetSkill])
	{
		case 0: rand = 4;
		case 1: rand = 4;
		case 2: rand = 3;
		case 3: rand = 2;
		case 4: rand = 1;
		default: rand = 0;
	}
	if(random(rand) == 1 || rand == 0)
	{
		GameTextForPlayer(playerid, "~g~ Success! ~w~ Target breached.", 4000, 3);
		switch(targettype)
		{
			case 1:
			{
				MoveDynamicObject(GateInfo[targetid][gGATE], GateInfo[targetid][gPosXM], GateInfo[targetid][gPosYM], GateInfo[targetid][gPosZM], 3.0, GateInfo[targetid][gRotXM], GateInfo[targetid][gRotYM], GateInfo[targetid][gRotZM]);
				GateInfo[targetid][gStatus] = 2;
			}
			case 2:
			{
				DDoorsInfo[targetid][ddLocked] = 2; // using this param for now.
				if(DDoorsInfo[targetid][ddType] != 0) format(szMiscArray, sizeof(szMiscArray), "%s | Owner: %s\nID: %d", DDoorsInfo[targetid][ddDescription], StripUnderscore(DDoorsInfo[targetid][ddOwnerName]), targetid);
				else format(szMiscArray, sizeof(szMiscArray), "%s\nID: %d", DDoorsInfo[targetid][ddDescription], targetid);
				format(szMiscArray, sizeof(szMiscArray), "%s\n\n {FF0000}BREACHED DOOR\n{CCCCCC}(Use /repairdoor to repair it)", szMiscArray);
				UpdateDynamic3DTextLabelText(DDoorsInfo[targetid][ddTextID], COLOR_YELLOW, szMiscArray);
			}
			case 3:
			{
				Businesses[targetid][bStatus] = 2; // using this param for now.
				szMiscArray = "{FF0000} BREACHED DOOR\n(Use /repairdoor to repair it)";
				UpdateDynamic3DTextLabelText(DDoorsInfo[targetid][ddTextID], COLOR_YELLOW, szMiscArray);
			}
			case 4:
			{
				HouseInfo[targetid][hLock] = 2; // using this param for now.
				format(szMiscArray, sizeof(szMiscArray), "This house is owned by\n%s\nLevel: %d\nID: %d", StripUnderscore(HouseInfo[targetid][hOwnerName]), HouseInfo[targetid][hLevel], targetid);
				format(szMiscArray, sizeof(szMiscArray), "%s\n\n{FF0000} BREACHED DOOR\n{CCCCCC}(Use /repairdoor to repair it)", szMiscArray);
				UpdateDynamic3DTextLabelText(HouseInfo[targetid][hTextID], COLOR_GREEN, szMiscArray);			
			}
		}	
	}
	else GameTextForPlayer(playerid, "~w~ Breach ~r~failed~w~!", 4000, 3);
	PlayerInfo[playerid][pLockKit]--;	
	ClearAnimations(playerid);
	DeletePVar(playerid, "_PickingLock");
	DeletePVar(playerid, "_TargetID");
	DeletePVar(playerid, "_TargetType");
	return 1;
}

GetNearestGateOrDoor(playerid)
{
	szMiscArray[0] = 0;
	for(new i, Float: fGatePos[3]; i < MAX_GATES; ++i)
	{
		GetDynamicObjectPos(GateInfo[i][gGATE], fGatePos[0], fGatePos[1], fGatePos[2]);
		if(IsPlayerInRangeOfPoint(playerid, 3.0, fGatePos[0], fGatePos[1], fGatePos[2]))
		{
			if(GateInfo[i][gModel] != 0)
			{
				SetPVarInt(playerid, "_TargetType", 1);
				return i;
			}
		}
	}
	for(new i; i < MAX_DDOORS; ++i)
	{
		if(strcmp(DDoorsInfo[i][ddDescription], "None", true) != 0)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]))
			{
				SetPVarInt(playerid, "_TargetType", 2);
				return i;
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]))
			{
				SetPVarInt(playerid, "_TargetType", 2);
				return i;
			}
		}
	}
	for(new i; i < MAX_BUSINESSES; ++i)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]))
		{
			SetPVarInt(playerid, "_TargetType", 3);
			return i;			
		}
	}
	for(new i; i < MAX_HOUSES; ++i)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW])
		{
			SetPVarInt(playerid, "_TargetType", 4);
			return i;			
		}
	}
	return 0;
}


GetNearestBrokenGateOrDoor(playerid)
{
	szMiscArray[0] = 0;
	for(new i, Float: fGatePos[3]; i < MAX_GATES; ++i)
	{
		GetDynamicObjectPos(GateInfo[i][gGATE], fGatePos[0], fGatePos[1], fGatePos[2]);
		if(IsPlayerInRangeOfPoint(playerid, 3.0, fGatePos[0], fGatePos[1], fGatePos[2]))
		{
			if(GateInfo[i][gStatus] == 2)
			{
				SetPVarInt(playerid, "_TargetType", 1);
				return i;
			}
		}
	}
	for(new i; i < MAX_DDOORS; ++i)
	{
		if(DDoorsInfo[i][ddLocked] == 2)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]))
			{
				SetPVarInt(playerid, "_TargetType", 2);
				return i;
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]))
			{
				SetPVarInt(playerid, "_TargetType", 2);
				return i;
			}
		}
	}
	for(new i; i < MAX_BUSINESSES; ++i)
	{
		if(Businesses[i][bStatus] == 2)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]))
			{
				SetPVarInt(playerid, "_TargetType", 3);
				return i;			
			}
		}
	}
	for(new i; i < MAX_HOUSES; ++i)
	{
		if(HouseInfo[i][hLock] == 2)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW])
			{
				SetPVarInt(playerid, "_TargetType", 4);
				return i;			
			}
		}
	}
	return 0;
}

forward Bomb_Detonate(playerid, targetid, targettype);
public Bomb_Detonate(playerid, targetid, targettype)
{
	new	Float:fPos[3];
	switch(targettype)
	{
		case 1:
		{
			GetDynamicObjectPos(GateInfo[targetid][gGATE], fPos[0], fPos[1], fPos[2]);
			CreateExplosion(fPos[0], fPos[1], fPos[2], 0, 6.0);
			MoveDynamicObject(GateInfo[targetid][gGATE], GateInfo[targetid][gPosXM], GateInfo[targetid][gPosYM], GateInfo[targetid][gPosZM], 50.0, GateInfo[targetid][gRotXM], GateInfo[targetid][gRotYM], GateInfo[targetid][gRotZM]);
			GateInfo[targetid][gStatus] = 2;
		}
		case 2:
		{
			CreateExplosion(DDoorsInfo[targetid][ddInteriorX], DDoorsInfo[targetid][ddInteriorY], DDoorsInfo[targetid][ddInteriorZ], 0, 6.0);
			CreateExplosion(DDoorsInfo[targetid][ddExteriorX], DDoorsInfo[targetid][ddExteriorY], DDoorsInfo[targetid][ddExteriorZ], 0, 6.0);
			DDoorsInfo[targetid][ddLocked] = 2; // using this param for now.
			if(DDoorsInfo[targetid][ddType] != 0) format(szMiscArray, sizeof(szMiscArray), "%s | Owner: %s\nID: %d", DDoorsInfo[targetid][ddDescription], StripUnderscore(DDoorsInfo[targetid][ddOwnerName]), targetid);
			else format(szMiscArray, sizeof(szMiscArray), "%s\nID: %d", DDoorsInfo[targetid][ddDescription], targetid);
			format(szMiscArray, sizeof(szMiscArray), "%s\n\n{FF0000} BREACHED DOOR\n{CCCCCC}(Use /repairdoor to repair it)", szMiscArray);
			UpdateDynamic3DTextLabelText(DDoorsInfo[targetid][ddTextID], COLOR_YELLOW, szMiscArray);
		}
		case 3:
		{
			CreateExplosion(Businesses[targetid][bExtPos][0], Businesses[targetid][bExtPos][1], Businesses[targetid][bExtPos][2], 0, 6.0);
			Businesses[targetid][bStatus] = 2; // using this param for now.
			szMiscArray = "{FF0000} BREACHED DOOR\n{CCCCCC}(Use /repairdoor to repair it)";
			UpdateDynamic3DTextLabelText(Businesses[targetid][bDoorText], COLOR_YELLOW, szMiscArray);
		}
		case 4:
		{
			CreateExplosion(HouseInfo[targetid][hExteriorX], HouseInfo[targetid][hExteriorY], HouseInfo[targetid][hExteriorZ], 0, 6.0);
			HouseInfo[targetid][hLock] = 2; // using this param for now.
			format(szMiscArray, sizeof(szMiscArray), "This house is owned by\n%s\nLevel: %d\nID: %d", StripUnderscore(HouseInfo[targetid][hOwnerName]), HouseInfo[targetid][hLevel], targetid);
			format(szMiscArray, sizeof(szMiscArray), "%s\n\n{FF0000} BREACHED DOOR\n{CCCCCC}(Use /repairdoor to repair it)", szMiscArray);
			UpdateDynamic3DTextLabelText(HouseInfo[targetid][hTextID], COLOR_GREEN, szMiscArray);			
		}
	}
	DestroyDynamicObject(GetPVarInt(playerid, "_BombPlanted"));
	DeletePVar(playerid, "_BombPlanted");
	DeletePVar(playerid, "_TargetID");
	DeletePVar(playerid, "_TargetType");
	return 1;
}

CMD:repairgate(playerid, params[]) {

	cmd_repairdoor(playerid, params);
	return 1;
}

CMD:repairdoor(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 7 && PlayerInfo[playerid][pJob2] != 7) return SendClientMessage(playerid, COLOR_GRAD1, "You are not a mechanic.");
	ShowPlayerDialog(playerid, DIALOG_MECHANIC_REPAIRDOOR, DIALOG_STYLE_MSGBOX, "Mechanic | Repair Door", "Are you sure you want to repair this gate/door?\nCost: 5.000 materials.", "Confirm", "Cancel");
	return 1;
}


forward Mechanic_InitSeconds(playerid, time, targetid, targettype);
public Mechanic_InitSeconds(playerid, time, targetid, targettype)
{
	szMiscArray[0] = 0;
	if(!GetPVarType(playerid, "_RepairingDoor")) return 1;
	if(!GetPVarType(playerid, "reptime")) SetPVarInt(playerid, "reptime", 10000);
	
	new timesec;
	time -= 1000;
	SetPVarInt(playerid, "reptime", time);
	timesec = time/1000;
	format(szMiscArray, sizeof(szMiscArray), "~w~ Reparing... ~r~ %d", timesec);
	GameTextForPlayer(playerid, szMiscArray, 4000, 3);
	if(time != 0) return SetTimerEx("Mechanic_InitSeconds", 1000, false, "ii", playerid, time, targetid, targettype);
	Mechanic_RepairDoor(playerid, targetid, targettype);
	return 1;
}

forward Mechanic_RepairDoor(playerid, targetid, targettype);
public Mechanic_RepairDoor(playerid, targetid, targettype)
{
	switch(targettype)
	{
		case 1:
		{
			MoveDynamicObject(GateInfo[targetid][gGATE], GateInfo[targetid][gPosX], GateInfo[targetid][gPosY], GateInfo[targetid][gPosZ], 50.0, GateInfo[targetid][gRotX], GateInfo[targetid][gRotY], GateInfo[targetid][gRotZ]);
			GateInfo[targetid][gStatus] = 1;
		}
		case 2:
		{
			DDoorsInfo[targetid][ddLocked] = 0; // using this param for now.
			if(DDoorsInfo[targetid][ddType] != 0) format(szMiscArray, sizeof(szMiscArray), "%s | Owner: %s\nID: %d", DDoorsInfo[targetid][ddDescription], StripUnderscore(DDoorsInfo[targetid][ddOwnerName]), targetid);
			else format(szMiscArray, sizeof(szMiscArray), "%s\nID: %d", DDoorsInfo[targetid][ddDescription], targetid);
			UpdateDynamic3DTextLabelText(DDoorsInfo[targetid][ddTextID], COLOR_YELLOW, szMiscArray);
		}
		case 3:
		{
			Businesses[targetid][bStatus] = 0; // using this param for now.
			UpdateDynamic3DTextLabelText(Businesses[targetid][bDoorText], COLOR_YELLOW, szMiscArray);
		}
		case 4:
		{
			HouseInfo[targetid][hLock] = 0; // using this param for now.
			format(szMiscArray, sizeof(szMiscArray), "This house is owned by\n%s\nLevel: %d\nID: %d", StripUnderscore(HouseInfo[targetid][hOwnerName]), HouseInfo[targetid][hLevel], targetid);
			UpdateDynamic3DTextLabelText(HouseInfo[targetid][hTextID], COLOR_GREEN, szMiscArray);			
		}
	}
	format(szMiscArray, sizeof(szMiscArray), "%s has repaired the gate/door.", GetPlayerNameEx(playerid));
	ClearAnimations(playerid);
	ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	DeletePVar(playerid, "_TargetID");
	DeletePVar(playerid, "_TargetType");
	DeletePVar(playerid, "_ReparingDoor");
	DeletePVar(playerid, "reptime");
	return 1;
}


Bomb_BombMakerInit()
{
	mysql_function_query(MainPipeline, "SELECT * FROM `bombmaker` WHERE `DBID` = 0", true, "Bomb_OnLoadBombMaker", "");
}

Bomb_ProcessPosition()
{
	DestroyDynamic3DTextLabel(arrBombMaker[bomb_iText]);
	arrBombMaker[bomb_iText] = CreateDynamic3DTextLabel("Bomb Maker\n{DDDDDD}Use /requestbombs or /collectbombs to talk to the bombmaker.", COLOR_YELLOW, arrBombMaker[bomb_fPos][0], arrBombMaker[bomb_fPos][1], arrBombMaker[bomb_fPos][2], 10.0);
}

Bomb_CreateOrder(playerid) {
	
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `bombmaker` \
		(`DBID`, `timestamp`) VALUES (%d, %d)", GetPlayerSQLId(playerid), gettime());
	return mysql_function_query(MainPipeline, szMiscArray, true, "Bomb_OnCreateOrder", "i", playerid);
}

Bomb_ShowOrders(iPlayerID) {
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `bombmaker` WHERE `DBID` > 0");
	return mysql_function_query(MainPipeline, szMiscArray, true, "Bomb_OnShowOrders", "i", iPlayerID);
}

Bomb_Deliver(playerid)
{
	szMiscArray[0] = 0;
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, arrBombMaker[bomb_fPos][0], arrBombMaker[bomb_fPos][1], arrBombMaker[bomb_fPos][2])) return SendClientMessage(playerid, COLOR_GRAD1, "You are not in range of the bomb maker's location.");
	if(GetPlayerCash(playerid) < BOMBMAKER_PRICE) return SendClientMessage(playerid, COLOR_GRAD1, "You do not have enough cash on you.");
	if(PlayerInfo[playerid][pMats] < BOMBMAKER_MATS) return SendClientMessage(playerid, COLOR_GRAD1, "You do not have enough materials on you.");
	GivePlayerCash(playerid, -BOMBMAKER_PRICE);
	PlayerInfo[playerid][pMats] -= BOMBMAKER_MATS;
	format(szMiscArray, sizeof(szMiscArray), "%s has accepted the bomb maker's offer and paid $%s and %sK materials.", GetPlayerNameEx(playerid), number_format(BOMBMAKER_PRICE), number_format(BOMBMAKER_MATS));
	ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	PlayerInfo[playerid][pBombs] = 3;
	format(szMiscArray, sizeof(szMiscArray), "DELETE FROM `bombmaker` WHERE `DBID` = %d", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

forward Bomb_OnCheckOrder(playerid);
public Bomb_OnCheckOrder(playerid)
{
	szMiscArray[0] = 0;
	new iRows,
		iFields,
		iDBID = GetPlayerSQLId(playerid),
		iTimeStamp,
		iPickupTime = 60*BOMBMAKER_MINUTES;
	cache_get_data(iRows, iFields, MainPipeline);
	iRows = cache_get_row_count();
	if(iRows > 0) 
	{
		for(new row; row < iRows; ++row)
		{
			if(cache_get_field_content_int(row, "DBID", MainPipeline) == iDBID)
			{
				iTimeStamp = cache_get_field_content_int(row, "timestamp", MainPipeline);
				printf("SQLID: %d TIMESTAMP: %d PICKUP TIME: %d", iDBID, iTimeStamp, iTimeStamp + iPickupTime);
				if(iTimeStamp + iPickupTime > gettime()) return SendClientMessage(playerid, COLOR_WHITE, "The bomb maker didn't finish your order yet.");
				Bomb_Deliver(playerid);
				return 1;
			}
		}
	}
	else Bomb_CreateOrder(playerid);
	return 1;
}

forward Bomb_OnLoadBombMaker(playerid);
public Bomb_OnLoadBombMaker(playerid)
{
	szMiscArray[0] = 0;
	new iRows = cache_get_row_count();
	if(iRows > 0) 
	{
		arrBombMaker[bomb_fPos][0]	= cache_get_field_content_float(0, "posx", MainPipeline);
		arrBombMaker[bomb_fPos][1]	= cache_get_field_content_float(0, "posy", MainPipeline);
		arrBombMaker[bomb_fPos][2]	= cache_get_field_content_float(0, "posz", MainPipeline);
		BOMBMAKER_PRICE 			= cache_get_field_content_int(0, "price", MainPipeline);
		BOMBMAKER_MATS				= cache_get_field_content_int(0, "mats", MainPipeline);
		printf("X: %f\nY:%f\nZ:%f", arrBombMaker[bomb_fPos][0], arrBombMaker[bomb_fPos][1], arrBombMaker[bomb_fPos][2]);
		Bomb_ProcessPosition();
	}
	else print("[Bomb Maker] Something went wrong when loading the bomb point coordinates.");
	return 1;
}

forward Bomb_OnCreateOrder(playerid);
public Bomb_OnCreateOrder(playerid)
{
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "[BOMB MAKER] (DBID: %i) [Name: %s]", GetPlayerSQLId(playerid), GetPlayerNameEx(playerid));
	Log("logs/bombmaker.log", szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "[Bomb Maker]: You can pick up your bombs in %d minutes.", BOMBMAKER_MINUTES);
	SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
	return 1;
}

forward Bomb_OnShowOrders(iPlayerID);
public Bomb_OnShowOrders(iPlayerID) {

	szMiscArray[0] = 0;

	new 
		iRows, 
		iCount;

	iRows = cache_get_row_count();
	if(!iRows) return SendClientMessage(iPlayerID, COLOR_WHITE, "There are no bomb orders.");
	while(iCount < iRows) {
		szMiscArray[3999] 	= 	cache_get_field_content_int(iCount, "DBID", MainPipeline);
		szMiscArray[4000] 	= 	cache_get_field_content_int(iCount, "timestamp", MainPipeline);
		format(szMiscArray, sizeof(szMiscArray), "%s(ID: %i) - %s\n",
			szMiscArray,
			szMiscArray[3999],
			date(szMiscArray[4000], 2));

		iCount++;
	}
	ShowPlayerDialog(iPlayerID, DIALOG_NOTHING, DIALOG_STYLE_LIST, "Listing Bomb Orders", szMiscArray, "Select", "Cancel");
	return 1;
}

CMD:bomborders(playerid, params[])
{
	if(IsAdminLevel(playerid, ADMIN_SENIOR)) Bomb_ShowOrders(playerid);
	return 1;
}


CMD:setbombpoint(playerid, params[])
{
	if(!IsAdminLevel(playerid, ADMIN_HEAD)) return 1;
	GetPlayerPos(playerid, arrBombMaker[bomb_fPos][0], arrBombMaker[bomb_fPos][1], arrBombMaker[bomb_fPos][2]);
	Bomb_ProcessPosition();
	SendClientMessage(playerid, COLOR_YELLOW, "You have successfully set the bomb point to your location.");
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `bombmaker` SET `posx` = '%f', `posy` = '%f', `posz` = '%f' WHERE `DBID` = 0", arrBombMaker[bomb_fPos][0], arrBombMaker[bomb_fPos][1], arrBombMaker[bomb_fPos][2]);
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

CMD:setbombcost(playerid, params[])
{
	if(!IsAdminLevel(playerid, ADMIN_HEAD)) return 1;
	new szChoice[8],
		iAmount;
	if(sscanf(params, "%s[8]%d", szChoice, iAmount))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "Usage: /setbombcost [name] [amount]");
		return SendClientMessage(playerid, COLOR_GRAD1, "Available names: 'Price' (whole $) | 'Mats' (multiplied by 100)");
	}
	if(strcmp(szChoice, "price", true) == 0)
	{
		BOMBMAKER_PRICE = iAmount;
		format(szMiscArray, sizeof(szMiscArray), "You have successfully changed the price of 3 bombs to: $%s", number_format(BOMBMAKER_PRICE));
	}
	if(strcmp(szChoice, "mats", true) == 0)
	{
		BOMBMAKER_MATS = iAmount;
		format(szMiscArray, sizeof(szMiscArray), "You have successfully changed the material cost of 3 bombs to: %s", number_format(BOMBMAKER_MATS));
	}
	SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `bombmaker` SET `price` = '%d', `mats` = '%d' WHERE `DBID` = 0", BOMBMAKER_PRICE, BOMBMAKER_MATS);
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

CMD:gotobombpoint(playerid, params[]) {

	if(IsAdminLevel(playerid, ADMIN_GENERAL)) SetPlayerPos(playerid, arrBombMaker[bomb_fPos][0], arrBombMaker[bomb_fPos][1], arrBombMaker[bomb_fPos][2]);
	return 1;
}

CMD:bombpoint(playerid, params[]) {

	DisablePlayerCheckpoint(playerid);
	SetPVarInt(playerid, "_BombCP", 1);
	SetPlayerCheckpoint(playerid, arrBombMaker[bomb_fPos][0], arrBombMaker[bomb_fPos][1], arrBombMaker[bomb_fPos][2], 10.0);
	return 1;
}


CMD:bombhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_TWGREEN, "__________________________________");
	SendClientMessage(playerid, COLOR_WHITE, "Bomb Help");
	if(PlayerInfo[playerid][pAdmin] > 0) SendClientMessage(playerid, COLOR_LIGHTRED, "[Bombs ADM] /gotobombpoint - /setbombpoint - /bomborders - /setbombcost");
	SendClientMessage(playerid, COLOR_GRAD1, "[Bombs] /bombpoint - /requestbombs - /collectbombs - /placebomb - /offerbomb - /acceptbomb.");
	SendClientMessage(playerid, COLOR_TWGREEN, "__________________________________");
	return 1;
}

CMD:placebomb(playerid, params[])
{
	szMiscArray[0] = 0;
	new Float:fPos[3], targetid;
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot place a bomb while in a vehicle.");
	if(PlayerInfo[playerid][pBombs] == 0) return SendClientMessage(playerid, COLOR_GRAD1, "You are not carrying any bombs with you. Use /bombpoint for the bomb maker's location.");
	targetid = GetNearestGateOrDoor(playerid);
	if(targetid == 0) return SendClientMessage(playerid, COLOR_GRAD1, "You are not near a gate or door.");
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 4000, 0);
	SetTimerEx("Player_ClearAnimations", 4000, false, "i", playerid);
	format(szMiscArray, sizeof(szMiscArray), "%s installs a C2-Bomb.", GetPlayerNameEx(playerid));
	PlayerInfo[playerid][pBombs]--;
	ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	SetPVarInt(playerid, "_BombPlanted", CreateDynamicObject(1252, fPos[0], fPos[1], fPos[2]-0.25, 90.0, 0.0, 0.0));
	SetPVarInt(playerid, "_TargetID", targetid);
	GivePlayerValidWeapon(playerid, 40, 1);
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Bomb]: {CCCCCC}Bomb armed.");
	return 1;
}


CMD:requestbombs(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, arrBombMaker[bomb_fPos][0], arrBombMaker[bomb_fPos][1], arrBombMaker[bomb_fPos][2])) return SendClientMessage(playerid, COLOR_GRAD1, "You are not in range of the bomb maker's location.");
	if(PlayerInfo[playerid][pBombs] > 2) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot carry more bombs.");
	format(szMiscArray, sizeof(szMiscArray), "Would you like to buy a C2-Bomb?\nThils will cost you:\n\n1. $%s\n2. %sK materials.\n\nDo you accept the offer?", number_format(BOMBMAKER_PRICE), number_format(BOMBMAKER_MATS));
	ShowPlayerDialog(playerid, DIALOG_BOMBMAKER_OFFER, DIALOG_STYLE_MSGBOX, "Bomb Maker", szMiscArray, "Yes", "No");
	return 1;
}

CMD:collectbombs(playerid, params[])
{
	szMiscArray[0] = 0;
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, arrBombMaker[bomb_fPos][0], arrBombMaker[bomb_fPos][1], arrBombMaker[bomb_fPos][2])) return SendClientMessage(playerid, COLOR_GRAD1, "You are not in range of the bomb maker's location.");
	if(PlayerInfo[playerid][pBombs] > 2) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot carry more bombs.");
	format(szMiscArray, sizeof(szMiscArray), "Would you like to buy a C2-Bomb?\nThils will cost you:\n\n1. $%s\n2. %sK materials.\n\nDo you accept the offer?", number_format(BOMBMAKER_PRICE), number_format(BOMBMAKER_MATS));
	ShowPlayerDialog(playerid, DIALOG_BOMBMAKER_OFFER, DIALOG_STYLE_MSGBOX, "Bomb Maker", szMiscArray, "Yes", "No");
	return 1;
}

CMD:acceptbomb(playerid, params[])
{
	if(GetPVarType(playerid, "_BombPlayerOffer"))
	{
		new offerid = GetPVarInt(playerid, "_BombPlayerOffer"),
			amount = GetPVarInt(playerid, "_BombPlayerAmount"),
			cost = GetPVarInt(playerid, "_BombPlayerCost"),
			Float:fPos[3];
		GetPlayerPos(offerid, fPos[0], fPos[1], fPos[2]);
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, fPos[0], fPos[1], fPos[2])) return SendClientMessage(playerid, COLOR_GRAD1, "You must be near him/her to accept the bomb offer.");
		if(PlayerInfo[playerid][pBombs] + amount > 3) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot carry more bombs.");
		if(GetPlayerCash(playerid) < cost) return SendClientMessage(playerid, COLOR_GRAD1, "You do not have enough cash on you.");
		format(szMiscArray, sizeof(szMiscArray), "%s accepted your %d bombs.", GetPlayerNameEx(playerid), amount);
		SendClientMessage(offerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "%s has given %s a suspicious package.", GetPlayerNameEx(playerid), GetPlayerNameEx(offerid));
		ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		PlayerInfo[offerid][pBombs] -= amount;
		PlayerInfo[playerid][pBombs] += amount;
		GivePlayerCash(offerid, cost);
		GivePlayerCash(playerid, -cost);
		DeletePVar(playerid, "_BombPlayerOffer");
		DeletePVar(playerid, "_BombPlayerAmount");
		DeletePVar(playerid, "_BombPlayerCost");
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "No one has offered you a bomb.");
	return 1;
}

CMD:offerbomb(playerid, params[])
{
	szMiscArray[0] = 0;
	new giveplayerid,
		Float:fPos[3],
		amount,
		cost;
	if(sscanf(params, "udd", giveplayerid, amount, cost)) return SendClientMessage(playerid, COLOR_GRAD1, "Usage: /offerbomb [playerid] [amount] [cost]");
	if(playerid == giveplayerid) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot offer yourself a bomb.");
	GetPlayerPos(giveplayerid, fPos[0], fPos[1], fPos[2]);
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, fPos[0], fPos[1], fPos[2])) return SendClientMessage(playerid, COLOR_GRAD1, "You must be near him/her to offer the bomb.");
	if(PlayerInfo[playerid][pBombs] < amount) return SendClientMessage(playerid, COLOR_GRAD1, "You do not have so many bombs");
	SetPVarInt(giveplayerid, "_BombPlayerOffer", playerid); // fix 0;
	SetPVarInt(giveplayerid, "_BombPlayerAmount", amount);
	SetPVarInt(giveplayerid, "_BombPlayerCost", cost);
	format(szMiscArray, sizeof(szMiscArray), "%s offered you %d bombs for $%d.", GetPlayerNameEx(playerid), amount, cost);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
	SendClientMessage(playerid, COLOR_GRAD1, "Use /acceptbomb to accept the offer");
	return 1;
}