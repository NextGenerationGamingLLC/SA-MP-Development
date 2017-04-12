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

/*
enum {
	DIALOG_SAFE_CREATE,
	DIALOG_SAFE_CTYPEID,
	DIALOG_SAFE_CTYPE,
	DIALOG_SAFE_CTYPEID_CONFIRM,
	DIALOG_SAFE_CMODELID,
	DIALOG_SAFE_CMODELID_CONFIRM,
	DIALOG_SAFE_MAIN,
	DIALOG_SAFE_BALANCE,
	DIALOG_SAFE_WITHDRAW,
	DIALOG_SAFE_DEPOSIT,
	DIALOG_SAFE_PIN,
	DIALOG_SAFE_PIN_EDIT,
	DIALOG_SAFE_PIN_AEDIT,
	DIALOG_SAFE_BREACH,
	DIALOG_ROBBERY_SAFE
};
*/

hook OnGameModeExit()
{
	DeleteGVar("RobbedSafeID");
	DeleteGVar("RobberyStage");
	DeleteGVar("RobberyPlayerID");
	stopRobbery();
	for(new i; i < MAX_SAFES; i++) 
	{
		destroyMoneyBag(i);
		destroySafe(i);
	}
	return 1;
}


hook OnPlayerDisconnect(playerid)
{
	dropBag(playerid);
	DeletePVar(playerid, "_RobbingSafe");
	DeletePVar(playerid, "_RobberID");
	DeletePVar(playerid, "_CollectTimer");
	DeletePVar(playerid, "_CollectedMoney");
	return 1;
}

hook OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == GetGVarInt("RobberyDeliverPickupID") && GetPVarInt(playerid, "_HasBag"))
	{
		new str[128],
			collected = GetPVarInt(playerid, "_CollectedMoney");
		DisablePlayerCheckpoint(playerid);
		format(str, sizeof(str), "Heist successful! $%s has been succesfully transferred to your safe!", number_format(collected));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, str);
		arrGroupData[PlayerInfo[playerid][pMember]][g_iBudget] += collected;
		RemovePlayerAttachedObject(playerid, 8);
		RemovePlayerAttachedObject(playerid, 9);
		DeletePVar(playerid, "_CollectedMoney");
		DeletePVar(playerid, "_HasBag");
	}
	if(pickupid == GetGVarInt("RobberyEntrancePickupID") && GetPVarInt(playerid, "_RobberyBeacon"))
	{
		DisablePlayerCheckpoint(playerid);
		SetTimerEx("OnRobberyEnterBeacon", 5000, false, "i", playerid);
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are now invulnerable for 5 seconds.");
	}
}	

hook OnPlayerEnterCheckpoint(playerid)
{
	if(GetGVarInt("RobberyStage") == 2 && GetSafeID(playerid) > -1)
	{
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Use /robsafe to open the safe. Press F to attempt to crack the code.");
		DisablePlayerCheckpoint(playerid);
	}
}

/*
hook OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	if(GetPVarInt(playerid, "_RobberyBeacon"))
	{
		new Float:armour,
			Float:health;
		GetArmour(playerid, armour);
		if(armour > 0.0) SetArmour(playerid, armour+amount);
		else SetHealth(playerid, health+amount);
	}
	return 1;
}
*/

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_ROBBERY_SETUP:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0: ShowPlayerDialogEx(playerid, DIALOG_ROBBERY_SETUP_PERC, DIALOG_STYLE_INPUT, "Robbery Setup | Robable Percentage", "Enter the percentage that's takeable by the robbers.", "Cancel", "Confirm");
				case 1: ShowPlayerDialogEx(playerid, DIALOG_ROBBERY_SETUP_RATE, DIALOG_STYLE_INPUT, "Robbery Setup | Collect Rate", "Enter the amount of money taken each 10 seconds.", "Cancel", "Confirm");
				case 2: ShowPlayerDialogEx(playerid, DIALOG_ROBBERY_SETUP_MIN, DIALOG_STYLE_INPUT, "Robbery Setup | Minimum Robbers", "Enter the minimum amount of robbers needed in the robbery.", "Cancel", "Confirm");
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
				if(!strcmp(inputtext, SafeData[GetSafeID(playerid)][g_iPin], true))
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
				iTypeID = SafeData[iSafeID][g_iTypeID];
			switch(SafeData[iSafeID][g_iType])
			{
				case 0: 
				{
					format(szTitle, sizeof(szTitle), "(ID: %i) UNSPECIFIED Safe", iSafeID);
					format(szDialog, sizeof(szDialog), "_________________________________\n\n--------------------\n Balance Sheet\n--------------------\n%s\n\nVault balance: $%s\n\n_________________________", "UNSPECIFIED", number_format(SafeData[iSafeID][g_iMoney]));
				}
				case 1: 
				{
					format(szTitle, sizeof(szTitle), "(ID: %i) Bank Safe", iSafeID);
					format(szDialog, sizeof(szDialog), "_________________________________\n\n--------------------\n Balance Sheet\n--------------------\nState Bank\n\nVault balance: $%s\n\n_________________________", number_format(SafeData[iSafeID][g_iMoney]));
				}
				case 2: 
				{
					format(szTitle, sizeof(szTitle), "(ID: %i) {%s}%s's Safe", iSafeID, Group_NumToDialogHex(arrGroupData[iTypeID][g_hDutyColour]), arrGroupData[iTypeID][g_szGroupName]);
					format(szDialog, sizeof(szDialog), "_________________________________\n\n--------------------\n Balance Sheet\n--------------------\n%s\n\nVault balance: $%s\n\n_________________________", arrGroupData[iTypeID][g_szGroupName], number_format(SafeData[iSafeID][g_iMoney]));
				}
				case 3: 
				{
					format(szTitle, sizeof(szTitle), "(ID: %i) %s's Safe Menu", iSafeID, Businesses[iTypeID][bName]);
					format(szDialog, sizeof(szDialog), "_________________________________\n\n--------------------\n Balance Sheet\n--------------------\n%s\n\nVault balance: $%s\n\n_________________________",  Businesses[iTypeID][bName], number_format(SafeData[iSafeID][g_iMoney]));
				}
				case 4: 
				{
					format(szTitle, sizeof(szTitle), "(ID: %i) Player Safe Menu", iSafeID);
					format(szDialog, sizeof(szDialog), "_________________________________\n\n--------------------\nBalance Sheet\n--------------------\nPlayer\n\nVault balance: $%s\n\n_________________________________", number_format(SafeData[iSafeID][g_iMoney]));
				}
			}
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialogEx(playerid, DIALOG_SAFE_BALANCE, DIALOG_STYLE_MSGBOX, szTitle, szDialog, "---", "---");
				}
				case 1:
				{
					return ShowPlayerDialogEx(playerid, DIALOG_SAFE_WITHDRAW, DIALOG_STYLE_INPUT, szTitle, "Specify the amount you would like to withdraw", "Cancel", "Withdraw");
				}
				case 2:
				{
					return ShowPlayerDialogEx(playerid, DIALOG_SAFE_DEPOSIT, DIALOG_STYLE_INPUT, szTitle, "Specify the amount you would like to deposit.", "Cancel", "Deposit");
				}
				case 3:
				{
					return ShowPlayerDialogEx(playerid, DIALOG_SAFE_PIN_EDIT, DIALOG_STYLE_INPUT, szTitle, "Please edit the new PIN.", "Back", "Proceed");
				}
			}	
		}
		case DIALOG_SAFE_BALANCE: return safeMenu(playerid);
		case DIALOG_SAFE_WITHDRAW:
		{
			if(!response || isnull(inputtext)) return safeMenu(playerid);
			{
				new iSafeID = GetPVarInt(playerid, "_EditingSafeID");
				if(!checkSafePerms(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must own this safe to withdraw money from it.");
				if(SafeData[iSafeID][g_iMoney] < strval(inputtext)) return SendClientMessageEx(playerid, COLOR_GRAD1, "There is not enough money in the safe.");
				SafeData[iSafeID][g_iMoney] = SafeData[iSafeID][g_iMoney] - strval(inputtext);
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
				if(GetPlayerCash(playerid) < strval(inputtext)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough money.");
				SafeData[iSafeID][g_iMoney] = SafeData[iSafeID][g_iMoney] + strval(inputtext);
				GivePlayerCash(playerid, -strval(inputtext));
				saveSafe(iSafeID);
				DeletePVar(playerid, "_EditingSafeID");
				return safeMenu(playerid);
			}
		}
		case DIALOG_SAFE_PIN_EDIT:
		{
			if(!response || !IsNumeric(inputtext)) return safeMenu(playerid);
			{
				if(isnull(inputtext) && strlen(inputtext) != 4) return safeMenu(playerid);
				new iSafeID = GetPVarInt(playerid, "_EditingSafeID"),
					str[32];
				if(!checkSafePerms(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must be a group leader to edit the safe's PIN.");
				format(SafeData[iSafeID][g_iPin], 5, "%s", inputtext);
				format(str, sizeof(str), "Pin changed to: %s", SafeData[iSafeID][g_iPin]);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, str);
				saveSafe(iSafeID);
				return safeMenu(playerid);
			}
		}
		case DIALOG_SAFE_CREATE:
		{
			if(!response) return DeletePVar(playerid, "_EditingSafeID");
			switch(listitem)
			{
				case 0: return ShowPlayerDialogEx(playerid, DIALOG_SAFE_CTYPE, DIALOG_STYLE_LIST, "Safe Menu | Safe Type", "Bank\nGroup\nBusiness\nPlayer", "Cancel", "Select");
				case 1: return ShowPlayerDialogEx(playerid, DIALOG_SAFE_CTYPEID, DIALOG_STYLE_INPUT, "Safe Menu | Safe Type ID", "Please specify the ID of the safe's owner.", "Cancel", "Select");
				case 2: return ShowPlayerDialogEx(playerid, DIALOG_SAFE_CMODELID_CONFIRM, DIALOG_STYLE_LIST, "Safe Menu | Model Selection", "Big Safe\nMedium Safe\nSmall Safe", "Cancel", "Select");
				case 3: return safePosition(playerid, GetPVarInt(playerid, "_EditingSafeID"));
				case 4: return ShowPlayerDialogEx(playerid, DIALOG_SAFE_PIN_AEDIT, DIALOG_STYLE_INPUT, "Safe Menu | Edit Safe PIN", "Please edit the new PIN.", "Back", "Proceed");
				case 5: { processSafe(GetPVarInt(playerid, "_EditingSafeID")); return DeletePVar(playerid, "_EditingSafeID"); }
			}
		}
		case DIALOG_SAFE_CTYPE:
		{
			if(!response) return safeEditMenu(playerid);
			new iSafeID = GetPVarInt(playerid, "_EditingSafeID");
			switch(listitem)
			{
				case 0: SafeData[iSafeID][g_iType] = 1;
				case 1: SafeData[iSafeID][g_iType] = 2;
				case 2: SafeData[iSafeID][g_iType] = 3;
				case 3: SafeData[iSafeID][g_iType] = 4;
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
			if(SafeData[iSafeID][g_iType] == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "Please first set the safe's type.");
				return safeEditMenu(playerid);
			}
			switch(SafeData[iSafeID][g_iType])
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
			ShowPlayerDialogEx(playerid, DIALOG_SAFE_CTYPEID_CONFIRM, DIALOG_STYLE_MSGBOX, "Safe Menu | Confirm Owner", szDialog, "Confirm", "Cancel");
			return 1;
		}
		case DIALOG_SAFE_CMODELID_CONFIRM:
		{
			if(!response) return safeEditMenu(playerid);
			new iSafeID = GetPVarInt(playerid, "_EditingSafeID");
			switch(listitem)
			{
				case 0: { SafeData[iSafeID][g_iModelID] = 19799; processSafe(iSafeID); saveSafe(iSafeID); }
				case 1: { SafeData[iSafeID][g_iModelID] = 2197; processSafe(iSafeID); saveSafe(iSafeID); }
				case 2: { SafeData[iSafeID][g_iModelID] = 2332; processSafe(iSafeID); saveSafe(iSafeID); }
			}
			return safeEditMenu(playerid);
		}	
		case DIALOG_SAFE_CTYPEID_CONFIRM:
		{
			if(!response) return safeEditMenu(playerid);
			new iSafeID = GetPVarInt(playerid, "_EditingSafeID"),
				iTypeID = GetPVarInt(playerid, "_SafeTypeID"),
				str[64];
			SafeData[iSafeID][g_iTypeID] = iTypeID;
			DeletePVar(playerid, "_SaveTypeID");
			processSafe(iSafeID);
			saveSafe(iSafeID);
			switch(SafeData[iSafeID][g_iType])
			{
				case 1:
				{
					format(str, sizeof(str), "Safe assigned to: State Bank");
				}
				case 2:
				{
					format(str, sizeof(str), "Safe assigned to: %s", arrGroupData[iTypeID][g_szGroupName]);
				}
				case 3:
				{
					format(str, sizeof(str), "Safe assigned to: %s", Businesses[iTypeID][bName]);
				}
				case 4:
				{
					format(str, sizeof(str), "Safe assigned to: %s", GetPlayerNameEx(iTypeID));
				}
			}
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, str);	
			return safeEditMenu(playerid);			
		}
		case DIALOG_SAFE_PIN_AEDIT:
		{
			if(!response || !IsNumeric(inputtext)) return safeMenu(playerid);
			{
				if(isnull(inputtext) && strlen(inputtext) != 4) return safeMenu(playerid);
				new iSafeID = GetPVarInt(playerid, "_EditingSafeID"),
					str[32];
				format(SafeData[iSafeID][g_iPin], 5, "%s", inputtext);
				format(str, sizeof(str), "[ADM] Pin changed to: %s", SafeData[iSafeID][g_iPin]);
				SendClientMessageEx(playerid, COLOR_YELLOW, str);
				saveSafe(iSafeID);
				return safeEditMenu(playerid);
			}
		}
		case DIALOG_SAFE_BREACH:
		{
			if(response) 
			{
				return cmd_robsafe(playerid, "");
			}
			else 
			{ 
				return ClearAnimationsEx(playerid); 
			}
		}
		case DIALOG_ROBBERY_SAFE:
		{
			if(response)
			{
				if(!strcmp(inputtext, SafeData[GetGVarInt("RobbedSafeID")][g_iPin], true))
				{
					new iSafeID = GetGVarInt("RobbedSafeID"),
						str[200], 
						iTypeID = SafeData[iSafeID][g_iTypeID];
					GameTextForPlayer(playerid, "~g~Safe breached!~n~~n~~w~Press ~g~'F' ~w~to start collecting.", 4000, 3);
					ClearAnimationsEx(playerid);
					SafeData[iSafeID][g_iRobbed] = 1;
					SafeData[iSafeID][g_tRobbedTime] = gettime();
					switch(SafeData[iSafeID][g_iType])
					{
						case 0: format(str, sizeof(str), "(ID: %i)\nUNSPECIFIED\n%s", iSafeID);
						case 1: format(str, sizeof(str), "(ID: %i)\n State Bank Safe", iSafeID);
						case 2: format(str, sizeof(str), "(ID: %i)\nGroup Safe\n%s", iSafeID, arrGroupData[iTypeID][g_szGroupName]);
						case 3: format(str, sizeof(str), "(ID: %i)\nBusiness Safe\n%s\nOwner: %s", iSafeID, Businesses[iTypeID][bName], StripUnderscore(Businesses[iTypeID][bOwnerName]));
						case 4: format(str, sizeof(str), "(ID: %i)\nPlayer Safe\nOwner: UNSPECIFIED", iSafeID, StripUnderscore(Businesses[iTypeID][bOwnerName]));
					}
					strins(str, "{FF0000}Robbed", strlen(str)+2, sizeof(str)+20);
					if(IsValidDynamicObject(SafeData[iSafeID][g_iObjectID]) && SafeData[iSafeID][g_iModelID] == 2332)
					{
						DestroyDynamicObject(SafeData[iSafeID][g_iObjectID]);
						SafeData[iSafeID][g_iObjectID] = CreateDynamicObject(1829, SafeData[iSafeID][g_fPos][0], SafeData[iSafeID][g_fPos][1], SafeData[iSafeID][g_fPos][2], SafeData[iSafeID][g_fPos][3], SafeData[iSafeID][g_fPos][4],SafeData[iSafeID][g_fPos][5], SafeData[iSafeID][g_iVW], SafeData[iSafeID][g_iInt]);
					}
					UpdateDynamic3DTextLabelText(SafeData[iSafeID][g_iTextLabel], COLOR_YELLOW, str);
					saveSafe(iSafeID);
					return 1;
				}
				else return SendClientMessageEx(playerid, COLOR_LIGHTRED, "Code rejected");
			}
		}
	}
	return 0;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetGVarInt("RobberyStage") && !GetPVarInt(playerid, "_RobbingSafe") && newkeys == KEY_SECONDARY_ATTACK)
	{
		new iSafeID = GetSafeID(playerid);
		if(iSafeID != GetGVarInt("RobbedSafeID") || iSafeID == -1) return 1;
		if(SafeData[iSafeID][g_iRobbed])
		{
			startCollectMoney(playerid, iSafeID);
		}
		else
		{
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0);
			SetPVarInt(playerid, "_RobbingSafe", 1);
			breachSafe(playerid, GetGVarInt("RobbedSafeID"));
		}
		return 1;
	}
	if(GetPVarInt(playerid, "_RobbingSafe") && newkeys == KEY_SECONDARY_ATTACK)
	{
		ClearAnimationsEx(playerid);
		stopCollectMoney(playerid);
		return 1;
	}
	return 1;
}

GetSafeID(playerid)
{
	for(new i; i < MAX_SAFES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, SafeData[i][g_fPos][0], SafeData[i][g_fPos][1], SafeData[i][g_fPos][2])) return i;
	}
	return -1;
}

GetMoneyBagID(playerid)
{
	for(new i; i < MAX_ROBBERS; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, MoneyBagData[i][g_fPos][0], MoneyBagData[i][g_fPos][1], MoneyBagData[i][g_fPos][2])) return i;
	}
	return -1;
}


safePosition(playerid, iSafeID)
{
	if(iSafeID == -1) return 1;
	new str[64];
	SetPVarInt(playerid, "_EditingSafeID", iSafeID);
	SetPVarInt(playerid, "_EditingSafeObjectID", SafeData[iSafeID][g_iObjectID]);
	EditDynamicObject(playerid, SafeData[iSafeID][g_iObjectID]);
	format(str, sizeof str, "You're editing safe ID %i's position.", iSafeID);
	SendClientMessageEx(playerid, COLOR_GRAD1, str);
	return 1;
}


safeDelete(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
	    new
	        iSafeID,
	        str[64];
	        
		if(sscanf(params, "i", iSafeID))
		    return SendClientMessageEx(playerid, 0xFFFFFFFF, "Usage: /deletesafe [safeid]");
		    
		if(!(0 <= iSafeID < MAX_SAFES))
		    return SendClientMessageEx(playerid, 0xFFFFFFFF, "Invalid safe ID specified.");
		    
		if(SafeData[iSafeID][g_iDBID] == 0)
			return SendClientMessageEx(playerid, 0xFFFFFFFF, "The specified safe ID has not been used.");
		    
		format(str, sizeof str, "DELETE FROM `safes` WHERE `safeDBID` = %i", SafeData[iSafeID][g_iDBID]);
		mysql_tquery(MainPipeline, str, false, "OnQueryFinish", "i", NO_THREAD);
		
		if(IsValidDynamicObject(SafeData[iSafeID][g_iObjectID])) 
			destroySafe(iSafeID);
		
		SafeData[iSafeID][g_iDBID] = 0;
		SafeData[iSafeID][g_iModelID] = 0;
        SafeData[iSafeID][g_iType] = 0;
		SafeData[iSafeID][g_iTypeID] = 0;
		SafeData[iSafeID][g_iVW] = 0;
		SafeData[iSafeID][g_fPos][0] = 0.0;
		SafeData[iSafeID][g_fPos][1] = 0.0;
		SafeData[iSafeID][g_fPos][2] = 0.0;
		SafeData[iSafeID][g_fPos][3] = 0.0;
		SafeData[iSafeID][g_fPos][4] = 0.0;
		SafeData[iSafeID][g_fPos][5] = 0.0;

		SafeData[iSafeID][g_iPin] = "0000";
		SafeData[iSafeID][g_iRobbed] = 0;
		SafeData[iSafeID][g_tRobbedTime] = 0;
		
		format(str, sizeof str, "You have deleted safe ID %i.", iSafeID);
		SendClientMessageEx(playerid, 0xFFFFFFFF, str);
	}
	return 1;	
}

startCollectMoney(playerid, iSafeID)
{
	new str[128],
		iRobberID = GetPVarInt(playerid, "_RobberID");
	
	format(str, sizeof(str), "Robbing Safe ID: %i", iSafeID);
	SendClientMessageEx(playerid, COLOR_WHITE, str);
	SetPVarInt(playerid, "_RobbingSafe", 1);
	SetTimerEx("collectMoney", 10000, false, "ii", playerid, iSafeID);
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0);
	RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 2);
	RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 1);
	MoneyBagData[iRobberID][g_iObjectID][0] = SetPlayerAttachedObject(playerid,MAX_PLAYER_ATTACHED_OBJECTS - 2,1550,1,0.059999,-0.245000,0.057000,-4.199984,6.600003,99.299903,1.000000,1.000000,1.000000);
	MoneyBagData[iRobberID][g_iObjectID][1] = SetPlayerAttachedObject(playerid,MAX_PLAYER_ATTACHED_OBJECTS - 1,1550,1,0.017999,-0.235000,-0.136999,168.799987,-3.799941,35.799995,1.000000,1.000000,1.000000);
	SetPVarInt(playerid, "_HasBag", 1);
	GameTextForPlayer(playerid, "~g~Collecting...", 5000, 5);
	DisablePlayerCheckpoint(playerid);
	if(!GetGVarInt("RobberyDeliverPickupID")) SetGVarInt("RobberyDeliverPickupID", CreateDynamicPickup(1274, 1, arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][0], arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][1], arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][2], 0));
	SetPlayerCheckpoint(playerid, arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][0], arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][1], arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][2], 5.0);
}


stopCollectMoney(playerid)
{
	DeletePVar(playerid, "_RobbingSafe");
}


forward collectMoney(playerid, iSafeID);
public collectMoney(playerid, iSafeID)
{
	if(iSafeID != GetSafeID(playerid))
	{
		stopCollectMoney(playerid);
		return 1;
	}
	new collected = GetPVarInt(playerid, "_CollectedMoney"),
		str[128];
	collected += ROB_COLLECT_RATE;

	if(collected > SafeData[iSafeID][g_iInitialMoney] * ROB_MAX_PERCENTAGE / 100)
	{
		stopCollectMoney(playerid);
		ClearAnimationsEx(playerid);
		return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "The safe is empty.");
	}
	new robberid = GetPVarInt(playerid, "_RobberID");
	format(str, sizeof(str), "Money Bag: $%S (ID: %i)\nDropped by: %s", number_format(collected), robberid, GetPlayerNameEx(playerid));
	
	if(!IsValidDynamic3DTextLabel(MoneyBagData[robberid][g_iTextLabel]))
	{
		MoneyBagData[robberid][g_iTextLabel] = CreateDynamic3DTextLabel(str, COLOR_LIGHTBLUE, 0.0, -0.3, 0.0, 10.0, playerid, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
	}
	else Update3DTextLabelText(MoneyBagData[robberid][g_iTextLabel], COLOR_LIGHTBLUE, str);
	
	SetPVarInt(playerid, "_CollectedMoney", collected);
	SafeData[iSafeID][g_iMoney] -= collected;
	GivePlayerCash(playerid, collected);
	format(str, sizeof(str), "You collected $%s from the safe. You now have $%s stored in your bag.", number_format(ROB_COLLECT_RATE), number_format(collected));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, str);
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
	    
	if(SafeData[iSafeID][g_iDBID] == 0)
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
		SafeData[iSafeID][g_iType],
		SafeData[iSafeID][g_iTypeID],
		SafeData[iSafeID][g_iVW],
		SafeData[iSafeID][g_iInt],
		SafeData[iSafeID][g_iModelID],
		SafeData[iSafeID][g_fPos][0],
		SafeData[iSafeID][g_fPos][1],
		SafeData[iSafeID][g_fPos][2],
		SafeData[iSafeID][g_fPos][3],
		SafeData[iSafeID][g_fPos][4],
		SafeData[iSafeID][g_fPos][5]
	);
	format(szQuery, sizeof szQuery, "%s, `safeMoney` = %i, \
		`safePin` = '%s', \
		`safeRobbed` = %i, \
		`safeRobbedTime` = %i \
		WHERE `safeDBID` = %i",
		szQuery,
		SafeData[iSafeID][g_iMoney],
		SafeData[iSafeID][g_iPin],
		SafeData[iSafeID][g_iRobbed],
		SafeData[iSafeID][g_tRobbedTime],
		SafeData[iSafeID][g_iDBID]
    );
    return mysql_tquery(MainPipeline, szQuery, false, "OnQueryFinish", "i", NO_THREAD);
}

loadSafes() {
	printf("[LoadSafes] Loading Safes from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `safes`", true, "onloadSafes", "");
}

forward onloadSafes();
public onloadSafes() {
	new
	    iRows,
	    iFields,
	    szResult[64];
	   
	cache_get_data(iRows, iFields, MainPipeline);
	
	if(!iRows)
	    return printf("[LoadSafes] Failed to load any Safes.");
	    
	for(new iRow; iRow < iRows; iRow++) {
		cache_get_field_content(iRow, "safeDBID", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_iDBID] = strval(szResult);
		cache_get_field_content(iRow, "safeType", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_iType] = strval(szResult);
		cache_get_field_content(iRow, "safeTypeID", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_iTypeID] = strval(szResult);
		cache_get_field_content(iRow, "safeVW", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_iVW] = strval(szResult);
		cache_get_field_content(iRow, "safeInt", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_iVW] = strval(szResult);
		cache_get_field_content(iRow, "safeModel", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_iModelID] = strval(szResult);
		cache_get_field_content(iRow, "safePosX", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_fPos][0] = floatstr(szResult);
		cache_get_field_content(iRow, "safePosY", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_fPos][1] = floatstr(szResult);
		cache_get_field_content(iRow, "safePosZ", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_fPos][2] = floatstr(szResult);
		cache_get_field_content(iRow, "safeRotX", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_fPos][3] = floatstr(szResult);
		cache_get_field_content(iRow, "safeRotY", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_fPos][4] = floatstr(szResult);
		cache_get_field_content(iRow, "safeRotZ", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_fPos][5] = floatstr(szResult);
		cache_get_field_content(iRow, "safeMoney", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_iMoney] = strval(szResult);
		cache_get_field_content(iRow, "safePin", SafeData[iRow][g_iPin], MainPipeline, 5);
		cache_get_field_content(iRow, "safeRobbed", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_iRobbed] = strval(szResult);
		cache_get_field_content(iRow, "safeRobbedTime", szResult, MainPipeline, sizeof szResult); SafeData[iRow][g_tRobbedTime] = strval(szResult);
		processSafe(iRow);
	}
	return printf("[MySQL] Loaded %i Safes from database.", iRows);
}


forward onCreateSafe(iExtraID, iSafeID); 
public onCreateSafe(iExtraID, iSafeID)
{
	new
	    iDBID = cache_insert_id();
	    
	SafeData[iSafeID][g_iDBID] = iDBID;
	
	processSafe(iSafeID);
	
    new str[64];
	format(str, sizeof str, "You have created an Safe using ID %i (DBID: %i).", iSafeID, iDBID);
	SendClientMessageEx(iExtraID, 0xFFFFFFFF, str);	
	return 1;
}

safeMenu(playerid)
{
	new	szTitle[64],
		iSafeID = GetSafeID(playerid);
	if(iSafeID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near a safe.");
	SetPVarInt(playerid, "_EditingSafeID", iSafeID);
	format(szTitle, sizeof(szTitle), "%s's Safe Menu (ID: %i)", "test", iSafeID);
	ShowPlayerDialogEx(playerid, DIALOG_SAFE_MAIN, DIALOG_STYLE_LIST, szTitle, "Request Balance Sheet\nWithdraw Money\nDeposit Money\nEdit PIN", "Cancel", "Proceed");
	return 1;
}


destroySafe(iSafeID)
{
	if(IsValidDynamic3DTextLabel(SafeData[iSafeID][g_iTextLabel]))
		DestroyDynamic3DTextLabel(SafeData[iSafeID][g_iTextLabel]);
	if(IsValidDynamicObject(SafeData[iSafeID][g_iObjectID]))
		DestroyDynamicObject(SafeData[iSafeID][g_iObjectID]);
}

destroyMoneyBag(iBagID)
{
	if(IsValidDynamic3DTextLabel(MoneyBagData[iBagID][g_iTextLabel]))
		DestroyDynamic3DTextLabel(MoneyBagData[iBagID][g_iTextLabel]);
	if(IsValidDynamicObject(MoneyBagData[iBagID][g_iObjectID][0]))
		DestroyDynamicObject(MoneyBagData[iBagID][g_iObjectID][0]);
	if(IsValidDynamicObject(MoneyBagData[iBagID][g_iObjectID][1]))
		DestroyDynamicObject(MoneyBagData[iBagID][g_iObjectID][1]);
}

processSafe(iSafeID) {
	if(!(0 <= iSafeID < MAX_SAFES))
	    return 0;
	    
	if(SafeData[iSafeID][g_iDBID] == 0)
	    return 0;

	if(SafeData[iSafeID][g_tRobbedTime] != 0 &&  SafeData[iSafeID][g_tRobbedTime] < (gettime() - 86400 * 2)) SafeData[iSafeID][g_iRobbed] = 0;
	
	if(IsValidDynamicObject(SafeData[iSafeID][g_iObjectID])) 
		destroySafe(iSafeID);
	
	if(SafeData[iSafeID][g_iModelID] == 2332 && SafeData[iSafeID][g_iRobbed]) 
	{
		SafeData[iSafeID][g_iObjectID] = CreateDynamicObject(1829, SafeData[iSafeID][g_fPos][0], SafeData[iSafeID][g_fPos][1], SafeData[iSafeID][g_fPos][2], SafeData[iSafeID][g_fPos][3], SafeData[iSafeID][g_fPos][4],SafeData[iSafeID][g_fPos][5], SafeData[iSafeID][g_iVW], SafeData[iSafeID][g_iInt]);
	}
	else SafeData[iSafeID][g_iObjectID] = CreateDynamicObject(SafeData[iSafeID][g_iModelID], SafeData[iSafeID][g_fPos][0], SafeData[iSafeID][g_fPos][1], SafeData[iSafeID][g_fPos][2], SafeData[iSafeID][g_fPos][3], SafeData[iSafeID][g_fPos][4],SafeData[iSafeID][g_fPos][5], SafeData[iSafeID][g_iVW], SafeData[iSafeID][g_iInt]);
	
	new str[216],
		iTypeID = SafeData[iSafeID][g_iTypeID];
	switch(SafeData[iSafeID][g_iType])
	{
		case 0: format(str, sizeof(str), "{FFFFFF}(ID: %i)\n{FFFF00}UNSPECIFIED\n{FFFFFF}%s", iSafeID);
		case 1: format(str, sizeof(str), "{FFFFFF}(ID: %i)\n{FFFF00}Bank Safe", iSafeID, arrGroupData[iTypeID][g_szGroupName]);
		case 2: format(str, sizeof(str), "{FFFFFF}(ID: %i)\n{FFFF00}Group Safe\n{%s}%s", iSafeID, Group_NumToDialogHex(arrGroupData[iTypeID][g_hDutyColour]), arrGroupData[iTypeID][g_szGroupName]);
		case 3: format(str, sizeof(str), "{FFFFFF}(ID: %i)\n{FFFF00}Business Safe\n{FFFFFF}%s\nOwner: %s", iSafeID, Businesses[iTypeID][bName], StripUnderscore(Businesses[iTypeID][bOwnerName]));
		case 4: format(str, sizeof(str), "{FFFFFF}(ID: %i)\n{FFFF00}Player Safe\n{FFFFFF}Owner: UNSPECIFIED", iSafeID, StripUnderscore(Businesses[iTypeID][bOwnerName]));
	}
	if(SafeData[iSafeID][g_iRobbed]) strins(str, "\n{FF0000}Robbed", strlen(str), sizeof(str)+20);
	SafeData[iSafeID][g_iTextLabel] = CreateDynamic3DTextLabel(str, COLOR_YELLOW, SafeData[iSafeID][g_fPos][0], SafeData[iSafeID][g_fPos][1], SafeData[iSafeID][g_fPos][2] + 0.75, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, SafeData[iSafeID][g_iVW], SafeData[iSafeID][g_iInt]);
	return 1;
}

safeEditMenu(playerid)
{
	new szTitle[64],
		iSafeID = GetPVarInt(playerid, "_EditingSafeID");
	switch(SafeData[iSafeID][g_iType])
	{
		case 0: format(szTitle, sizeof(szTitle), "Safe Menu | (NONE)");
		case 1: format(szTitle, sizeof(szTitle), "Safe Menu | State Bank (Bank)");
		case 2: format(szTitle, sizeof(szTitle), "Safe Menu | {%s}%s", Group_NumToDialogHex(arrGroupData[SafeData[iSafeID][g_iTypeID]][g_hDutyColour]), arrGroupData[SafeData[iSafeID][g_iTypeID]][g_szGroupName]);
		case 3: format(szTitle, sizeof(szTitle), "Safe Menu | %s (Business)", Businesses[SafeData[iSafeID][g_iTypeID]][bName]);
		case 4: format(szTitle, sizeof(szTitle), "Safe Menu | %s (Player)", GetPlayerNameEx(SafeData[iSafeID][g_iTypeID]));
	}
	ShowPlayerDialogEx(playerid, DIALOG_SAFE_CREATE, DIALOG_STYLE_LIST, szTitle, "\
		Safe Type (Bank / Group / Business)\n\
		Safe Type ID\n\
		Safe Size\n\
		Safe Position\n\
		Safe PIN\n\
		Finish Safe", "Cancel", "Select");
	return 1;
}

safeCreate(playerid)
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new	szQuery[512];
		for(new i = 0; i < MAX_SAFES; ++i) if(SafeData[i][g_iDBID] == 0)
		{
			SafeData[i][g_iType] = 0;
			SafeData[i][g_iTypeID] = 0;
			SafeData[i][g_iModelID] = 2332;
			SafeData[i][g_iVW] = GetPlayerVirtualWorld(playerid);
			SafeData[i][g_iInt] = GetPlayerInterior(playerid);
			SafeData[i][g_iMoney] = 0;
			SafeData[i][g_iRobbed] = 0;
			SafeData[i][g_tRobbedTime] = 0;
			GetPlayerPos(playerid, SafeData[i][g_fPos][0], SafeData[i][g_fPos][1], SafeData[i][g_fPos][2]);
			GetPlayerFacingAngle(playerid, SafeData[i][g_fPos][5]);
			format(SafeData[i][g_iPin], MAX_PLAYER_NAME, "0000");
			format(szQuery, sizeof szQuery, "INSERT INTO `safes` (`safeDBID`, `safeModel`, `safeType`, `safeTypeID`, `safeVW`, `safeINT`, `safePosX`, `safePosY`, `safePosZ`, `safeRotX`, `safeRotY`, `safeRotZ`, \
				`safeMoney`, `safePin`, `safeRobbed`, `safeRobbedTime`) VALUES (%i, %i, %i, %i, %i, %i, %f, %f, %f, %f, %f, %f, %i, '%s', %i, %i)",
				SafeData[i][g_iDBID],
				SafeData[i][g_iModelID],
				SafeData[i][g_iType],
				SafeData[i][g_iTypeID],
				SafeData[i][g_iVW],
				SafeData[i][g_iInt],
				SafeData[i][g_fPos][0],
				SafeData[i][g_fPos][1],
				SafeData[i][g_fPos][2],
				SafeData[i][g_fPos][3],
				SafeData[i][g_fPos][4],
				SafeData[i][g_fPos][5],
				SafeData[i][g_iMoney],
				SafeData[i][g_iPin],
				SafeData[i][g_iRobbed],
				SafeData[i][g_tRobbedTime]
			);
			return mysql_tquery(MainPipeline, szQuery, true, "onCreateSafe", "ii", playerid, i);
		}
		SendClientMessageEx(playerid, 0xFFFFFFFF, "There are no more safe slots available.");
	}
	return 1;
}

ProxGangMemberCheck(playerid)
{
	new str[64],
		count;
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember] && GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid) && GetPlayerInterior(i) == GetPlayerInterior(playerid))
		{
			if(count > MAX_ROBBERS)
			{
				format(str, sizeof(str), "You cannot have more than %i robbers. You now have %i available.", MAX_ROBBERS, count);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, str);
			}
			SetPVarInt(i, "_RobberID", count);
			format(str, sizeof(str), "You are now part of the heist. (Robber ID: %i)", count);			
			SendClientMessageEx(i, COLOR_LIGHTRED, str);
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
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	SendClientMessageEx(playerid, COLOR_YELLOW, "Awaiting approval..." );
	ABroadCast(COLOR_LIGHTRED, "(Gang Leader) Robbery Request - ((/approve)(/deny)robbery)", 2);
}

initiateRobbery(playerid)
{
	if(GetGVarInt("RobberyStage")) return SendClientMessageEx(playerid, COLOR_YELLOW,"A robbery is already taking place.");
	new str[MAX_PLAYER_NAME + 64];
	format(str, sizeof(str), "* %s initiated the robbery.", GetPlayerNameEx(playerid));
	ProxDetector(10.0, playerid, str, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
	SetGVarInt("RobberyStage", 1);
	OnRobbery(playerid, PlayerInfo[playerid][pMember]);
	return 1;
}

denyRobbery(playerid)
{
	if(GetGVarInt("RobberyStage")) return SendClientMessageEx(playerid, COLOR_YELLOW,"A robbery is already taking place.");
	new str[MAX_PLAYER_NAME + 64];
	format(str, sizeof(str), "* %s's robbery request has been denied by an admin.", GetPlayerNameEx(playerid));
	ProxDetector(10.0, playerid, str, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
	DeleteGVar("RobberyPlayerID");
	DeleteGVar("RobbedSafeID");
	foreach(new i : Player) if(GetPVarInt(i, "_iRobberyID")) DeletePVar(i, "_RobberID");
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
	foreach(new i : Player)
	{
		if(GetPVarInt(i, "_RobberID"))
		{
			RemovePlayerAttachedObject(i, 8);
			RemovePlayerAttachedObject(i, 9);
		}
		DeletePVar(i, "_RobbingSafe");
		DeletePVar(i, "_RobberID");
		DeletePVar(i, "_CollectTimer");
		DeletePVar(i, "_CollectedMoney");
	}
	for(new i; i < MAX_ROBBERS; i++) destroyMoneyBag(i);
	return 1;
}


breachSafe(playerid, iSafeID)
{
	new szTitle[32],
		szDialog[256];
	format(szTitle, sizeof(szTitle), "Safe Breach (ID: %i)", iSafeID);
	format(szDialog, sizeof(szDialog), "ee115a\t8df9\t12zfja\n\
		%b\t48ff\t00f\n\
		125f\t14k\%b\n\
		150z\335f\teta\n\
		1a0z\t48ff\t00f\n\
		%b\t48ff\a64b\n\
		1a0z\t48ff\%b", SafeData[iSafeID][g_iPin][0], SafeData[iSafeID][g_iPin][1], SafeData[iSafeID][g_iPin][2], SafeData[iSafeID][g_iPin][3]);
	return ShowPlayerDialogEx(playerid, DIALOG_SAFE_BREACH, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szDialog, "Try Code", "Cancel");
}


forward OnRobbery(playerid, groupid);
public OnRobbery(playerid, groupid)
{
	new stage = GetGVarInt("RobberyStage"),
		iSafeID = GetGVarInt("RobbedSafeID");
	switch(stage)
	{
		case 1:
		{
			SetTimerEx("OnRobbery", 60000 * 1, false, "ii", playerid, PlayerInfo[playerid][pMember]);
			SetGVarInt("RobberyStage", 2);
			new str[128];
			format(str, sizeof(str), "Robbing Safe ID: %i", iSafeID);
			SendClientMessageEx(playerid, COLOR_WHITE, str);
			SafeData[iSafeID][g_iRobberyPickup] = CreateDynamicPickup(1212, 23, SafeData[iSafeID][g_fPos][0], SafeData[iSafeID][g_fPos][1], SafeData[iSafeID][g_fPos][2] + 1.0);
			foreach(new giveplayerid : Player) if(GetPVarInt(giveplayerid, "_RobberID"))
				SetPlayerCheckpoint(giveplayerid, SafeData[iSafeID][g_fPos][0], SafeData[iSafeID][g_fPos][1], SafeData[iSafeID][g_fPos][2], 2.0);	
		}
		case 2:
		{
			new szMessage[128];
			switch(SafeData[iSafeID][g_iType])
			{
				case 1: format(szMessage, sizeof(szMessage), "** DISPATCH: All units, there is a robbery at %s. (/rbeacon)", "the bank");
				case 2: format(szMessage, sizeof(szMessage), "** DISPATCH: All units, there is a robbery at %s. (/rbeacon)", arrGroupData[SafeData[iSafeID][g_iTypeID]][g_szGroupName]);
				case 3: format(szMessage, sizeof(szMessage), "** DISPATCH: All units, there is a robbery at %s. (/rbeacon)", arrGroupData[SafeData[iSafeID][g_iTypeID]][g_szGroupName]);
				case 4: format(szMessage, sizeof(szMessage), "** DISPATCH: All units, there is a robbery at %s. (/rbeacon)", Businesses[SafeData[iSafeID][g_iTypeID]][bName]);
				case 5: format(szMessage, sizeof(szMessage), "** DISPATCH: All units, there is a robbery at %s's house. (/rbeacon)", "a person");				
			}
			SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTRED, szMessage);
			SetGVarInt("RobberyStage", 3);		
		}
	}
	return 1;
}

CMD:rbeacon(playerid, params[])
{
	if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a LEO.");
	if(GetGVarInt("RobberyStage") < 3) return 1;
	else
	{
		new iSafeID = GetGVarInt("RobbedSafeID"),
			iTypeID = SafeData[iSafeID][g_iTypeID];
		SetPVarInt(playerid, "_RobberyBeacon", 1);
		switch(SafeData[iSafeID][g_iType])
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

/*CMD:mask(playerid, params[])
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
}*/

checkSafePerms(playerid)
{
	new iSafeID = GetSafeID(playerid);
	switch(SafeData[iSafeID][g_iType])
	{
		case 1: if(PlayerInfo[playerid][pAdmin] < 1337) return 1;
		case 2: if(SafeData[iSafeID][g_iTypeID] == PlayerInfo[playerid][pLeader]) return 1;
		case 3: if(SafeData[iSafeID][g_iTypeID] == PlayerInfo[playerid][pBusiness] && PlayerInfo[playerid][pBusinessRank] == 5) return 1;
	}
	return 0;
}

CMD:safe(playerid, params[])
{
	new iSafeID = GetSafeID(playerid);
	if(iSafeID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near a safe");
	if(PlayerInfo[playerid][pAdmin] == 0)
	{
		switch(SafeData[iSafeID][g_iType])
		{
			case 1: if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot access this safe.");
			case 2: if(SafeData[iSafeID][g_iTypeID] != PlayerInfo[playerid][pMember]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot access this safe.");
			case 3: if(SafeData[iSafeID][g_iTypeID] != PlayerInfo[playerid][pBusiness]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot access this safe.");
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_SAFE_PIN, DIALOG_STYLE_INPUT, "Safe | Enter Pin", "Please enter the safe's pin to open it.", "X", "V");
	return 1;
}

CMD:createsafe(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have the authority to use this command");
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
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have the authority to use this command");
	safeDelete(playerid, params);
	return 1;
}

CMD:dropbag(playerid, params[])
{
	dropBag(playerid);
	return 1;
}

dropBag(playerid)
{
	if(GetPVarInt(playerid, "_HasBag"))
	{
		new iRobberID = GetPVarInt(playerid, "_RobberID"),
			str[64];
		MoneyBagData[iRobberID][g_iMoney] = GetPVarInt(playerid, "_CollectedMoney");
		DeletePVar(playerid, "_CollectedMoney");
		DeletePVar(playerid, "_HasBag");
		GivePlayerCash(playerid, -MoneyBagData[iRobberID][g_iMoney]);
		GetPlayerPos(playerid, MoneyBagData[iRobberID][g_fPos][0], MoneyBagData[iRobberID][g_fPos][1], MoneyBagData[iRobberID][g_fPos][2]);
		RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 2);
		RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 1);
		MoneyBagData[iRobberID][g_iObjectID][0] = CreateDynamicObject(1550, MoneyBagData[iRobberID][g_fPos][0], MoneyBagData[iRobberID][g_fPos][1], MoneyBagData[iRobberID][g_fPos][2]-0.5, 0.0, 90.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		if(IsValidDynamic3DTextLabel(MoneyBagData[iRobberID][g_iTextLabel]))
			DestroyDynamic3DTextLabel(MoneyBagData[iRobberID][g_iTextLabel]);
		format(str, sizeof(str), "Money Bag: $%s (ID: %i)", number_format(MoneyBagData[iRobberID][g_iMoney]), iRobberID);
		MoneyBagData[iRobberID][g_iTextLabel] = CreateDynamic3DTextLabel(str, COLOR_LIGHTBLUE, MoneyBagData[iRobberID][g_fPos][0], MoneyBagData[iRobberID][g_fPos][1], MoneyBagData[iRobberID][g_fPos][2], 10.0, INVALID_PLAYER_ID);
	}
}

CMD:takebag(playerid, params[])
{
	if(!GetPVarInt(playerid, "_HasBag"))
	{
		new iBagID = GetMoneyBagID(playerid);
		if(iBagID == -1) return 1;
		if(IsValidDynamic3DTextLabel(MoneyBagData[iBagID][g_iTextLabel]))
		{
			new str[64];
			format(str, sizeof(str), "Money Bag: $%s (ID: %i)", number_format(MoneyBagData[iBagID][g_iMoney]), iBagID);
			DestroyDynamic3DTextLabel(MoneyBagData[iBagID][g_iTextLabel]);
			MoneyBagData[iBagID][g_iTextLabel] = CreateDynamic3DTextLabel(str, COLOR_LIGHTBLUE, 0.0, -0.3, 0.0, 10.0, playerid, INVALID_VEHICLE_ID, 1);
		}
		DestroyDynamicObject(MoneyBagData[iBagID][g_iObjectID][0]);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
		RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 2);
		RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 1);
		MoneyBagData[iBagID][g_iObjectID][0] = SetPlayerAttachedObject(playerid,MAX_PLAYER_ATTACHED_OBJECTS - 2,1550,1,0.059999,-0.245000,0.057000,-4.199984,6.600003,99.299903,1.000000,1.000000,1.000000);
		MoneyBagData[iBagID][g_iObjectID][1] = SetPlayerAttachedObject(playerid,MAX_PLAYER_ATTACHED_OBJECTS - 1,1550,1,0.017999,-0.235000,-0.136999,168.799987,-3.799941,35.799995,1.000000,1.000000,1.000000);
		SetPVarInt(playerid, "_HasBag", 1);
		SetPVarInt(playerid, "_CollectedMoney", MoneyBagData[iBagID][g_iMoney]);
	}
	return 1;
}

CMD:approverobbery(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337) initiateRobbery(GetGVarInt("RobberyPlayerID"));
	return 1;
}

CMD:denyrobbery(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337) denyRobbery(GetGVarInt("RobberyPlayerID"));
	else ProxDetector(10.0, GetGVarInt("RobberyPlayerID"), "[ADM NOTICE] Your robbery request has been denied.", COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED,COLOR_LIGHTRED);
	return 1;
}

CMD:robbery(playerid, params[])
{
	if(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] != GROUP_TYPE_CRIMINAL) return SendClientMessageEx(playerid, COLOR_GRAD1, "You have to be in a gang to use this command.");
	new iSafeID = GetSafeID(playerid);
	if(iSafeID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near a safe.");
	if(IsPlayerGangLeader(playerid) && ProxGangMemberCheck(playerid))
	{
		SetGVarInt("RobberyPlayerID", playerid);
		SetGVarInt("RobbedSafeID", iSafeID);
		SafeData[iSafeID][g_iInitialMoney] = SafeData[iSafeID][g_iMoney];
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
	if(PlayerInfo[playerid][pAdmin] < 1337) return 1;
	new szDialog[256];
	format(szDialog, sizeof(szDialog), "Robable percentage\t\t%i\nCollect rate\t\t$%s / 10s\nMinimum robbers\t\t%i", ROB_MAX_PERCENTAGE, number_format(ROB_COLLECT_RATE), ROB_MIN_MEMBERS);
	ShowPlayerDialogEx(playerid, DIALOG_ROBBERY_SETUP, DIALOG_STYLE_TABLIST, "Robbery Setup Menu", szDialog, "Cancel", "Select");
	return 1;
}

CMD:endrobbery(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return 1;
	stopRobbery();
	return 1;
}

CMD:robsafe(playerid, params[])
{
	if(!GetGVarInt("RobberyStage")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You did not get an approval yet.");
	if(GetSafeID(playerid) != GetGVarInt("RobbedSafeID")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near the safe.");
	ShowPlayerDialogEx(playerid, DIALOG_ROBBERY_SAFE, DIALOG_STYLE_INPUT, "Safe PIN", "Please enter the PIN to open the safe.", "Cancel", "Enter");
	return 1;
}