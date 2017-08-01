/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Gang Tag System

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

stock LoadGangTags()
{
	new query[128];
	format(query, sizeof(query), "SELECT * FROM `gangtags` LIMIT %d", MAX_GANGTAGS);
	mysql_tquery(MainPipeline, query, true, "OnGangTagQueryFinish", "ii", LOAD_GANGTAGS, -1);
}

stock SaveGangTag(gangtag)
{
	new query[256];
	format(query, sizeof(query), "UPDATE `gangtags` SET \
		`posx` = %f, \
		`posy` = %f, \
		`posz` = %f, \
		`posrx` = %f, \
		`posry` = %f, \
		`posrz` = %f, \
		`objectid` = %d, \
		`vw` = %d, \
		`interior` = %d, \
		`family` = %d, \
		`time` = %d, \
		`used` = %d WHERE `id` = %d",
		GangTags[gangtag][gt_PosX],
		GangTags[gangtag][gt_PosY],
		GangTags[gangtag][gt_PosZ],
		GangTags[gangtag][gt_PosRX],
		GangTags[gangtag][gt_PosRY],
		GangTags[gangtag][gt_PosRZ],
		GangTags[gangtag][gt_ObjectID],
		GangTags[gangtag][gt_VW],
		GangTags[gangtag][gt_Int],
		GangTags[gangtag][gt_Family],
		GangTags[gangtag][gt_Time],
		GangTags[gangtag][gt_Used],
		GangTags[gangtag][gt_SQLID]
	);
	mysql_tquery(MainPipeline, query, false, "OnGangTagQueryFinish", "ii", SAVE_GANGTAG, gangtag);
}

forward OnGangTagQueryFinish(threadid, extraid);
public OnGangTagQueryFinish(threadid, extraid)
{
	new fields, rows;
	cache_get_data(rows, fields, MainPipeline);
	switch(threadid)
	{
		case LOAD_GANGTAGS:
		{
			new row, result[64];
			while(row < rows)
			{
				cache_get_field_content(row, "id", result, MainPipeline); GangTags[row][gt_SQLID] = strval(result);
				cache_get_field_content(row, "posx", result, MainPipeline); GangTags[row][gt_PosX] = floatstr(result);
				cache_get_field_content(row, "posy", result, MainPipeline); GangTags[row][gt_PosY] = floatstr(result);
				cache_get_field_content(row, "posz", result, MainPipeline); GangTags[row][gt_PosZ] = floatstr(result);
				cache_get_field_content(row, "posrx", result, MainPipeline); GangTags[row][gt_PosRX] = floatstr(result);
				cache_get_field_content(row, "posry", result, MainPipeline); GangTags[row][gt_PosRY] = floatstr(result);
				cache_get_field_content(row, "posrz", result, MainPipeline); GangTags[row][gt_PosRZ] = floatstr(result);
				cache_get_field_content(row, "objectid", result, MainPipeline); GangTags[row][gt_ObjectID] = strval(result);
				cache_get_field_content(row, "vw", result, MainPipeline); GangTags[row][gt_VW] = strval(result);
				cache_get_field_content(row, "interior", result, MainPipeline); GangTags[row][gt_Int] = strval(result);
				cache_get_field_content(row, "family", result, MainPipeline); GangTags[row][gt_Family] = strval(result);
				cache_get_field_content(row, "used", result, MainPipeline); GangTags[row][gt_Used] = strval(result);
				cache_get_field_content(row, "time", result, MainPipeline); GangTags[row][gt_Time] = strval(result);
				CreateGangTag(row);
				row++;
			}
			if(row > 0)
			{
				printf("[MYSQL] Successfully loaded %d gang tags.", row);
			}
			else
			{
				print("[MYSQL] Failed loading any gang tags.");
			}
		}
		case SAVE_GANGTAG:
		{
			if(mysql_affected_rows(MainPipeline))
			{
				printf("[MYSQL] Successfully saved gang tag %d (SQLID: %d).", extraid, GangTags[extraid][gt_SQLID]);
			}
			else
			{
				printf("[MYSQL] Failed saving gang tag %d (SQLID: %d).", extraid, GangTags[extraid][gt_SQLID]);
			}
		}
	}
	return 1;
}

stock ClearGangTag(gangtag)
{
	GangTags[gangtag][gt_PosX] = 0.0;
	GangTags[gangtag][gt_PosY] = 0.0;
	GangTags[gangtag][gt_PosZ] = 0.0;
	GangTags[gangtag][gt_PosRX] = 0.0;
	GangTags[gangtag][gt_PosRY] = 0.0;
	GangTags[gangtag][gt_PosRZ] = 0.0;
	GangTags[gangtag][gt_VW] = 0;
	GangTags[gangtag][gt_Int] = 0;
	GangTags[gangtag][gt_ObjectID] = 1490;
	GangTags[gangtag][gt_Family] = INVALID_FAMILY_ID;
	GangTags[gangtag][gt_Used] = 0;
	GangTags[gangtag][gt_Time] = 0;
	if(IsValidDynamicObject(GangTags[gangtag][gt_Object]))
	{
		DestroyDynamicObject(GangTags[gangtag][gt_Object]);
	}
	return 1;
}

stock CreateGangTag(gangtag)
{
	if(GangTags[gangtag][gt_Used] == 0)
	{
		return 1;
	}
	if(IsValidDynamicObject(GangTags[gangtag][gt_Object]))
	{
		DestroyDynamicObject(GangTags[gangtag][gt_Object]);
	}
	new fam = GangTags[gangtag][gt_Family];
	if(fam < 1 || fam == INVALID_FAMILY_ID)
	{
		GangTags[gangtag][gt_Object] = CreateDynamicObject(1490, GangTags[gangtag][gt_PosX], GangTags[gangtag][gt_PosY], GangTags[gangtag][gt_PosZ], GangTags[gangtag][gt_PosRX], GangTags[gangtag][gt_PosRY], GangTags[gangtag][gt_PosRZ], GangTags[gangtag][gt_VW], GangTags[gangtag][gt_Int], -1, 200.0);
	}
	else if(FamilyInfo[fam][gt_SPUsed] == 0)
	{
		GangTags[gangtag][gt_Object] = CreateDynamicObject(1490, GangTags[gangtag][gt_PosX], GangTags[gangtag][gt_PosY], GangTags[gangtag][gt_PosZ], GangTags[gangtag][gt_PosRX], GangTags[gangtag][gt_PosRY], GangTags[gangtag][gt_PosRZ], GangTags[gangtag][gt_VW], GangTags[gangtag][gt_Int], -1, 200.0);
	}
	else
	{
		GangTags[gangtag][gt_Object] = CreateDynamicObject(FamilyInfo[fam][gtObject], GangTags[gangtag][gt_PosX], GangTags[gangtag][gt_PosY], GangTags[gangtag][gt_PosZ], GangTags[gangtag][gt_PosRX], GangTags[gangtag][gt_PosRY], GangTags[gangtag][gt_PosRZ], GangTags[gangtag][gt_VW], GangTags[gangtag][gt_Int], -1, 200.0);
	}
	if(fam > 0 && fam != INVALID_FAMILY_ID && FamilyInfo[fam][gt_SPUsed] == 0)
	{
		SetDynamicObjectMaterialText(GangTags[gangtag][gt_Object], 0, FamilyInfo[fam][gt_Text], OBJECT_MATERIAL_SIZE_256x128, FamilyInfo[fam][gt_FontFace], FamilyInfo[fam][gt_FontSize], FamilyInfo[fam][gt_Bold], FamilyInfo[fam][gt_FontColor], 0, 1);
	}	
	return 1;
}

stock GetFreeGangTag()
{
	for(new i = 0; i < MAX_GANGTAGS; i++)
	{
		if(GangTags[i][gt_Used] == 0)
		{
			return i;
		}
	}
	return -1;
}

stock ReCreateGangTags(fam)
{
	for(new i = 0; i < MAX_GANGTAGS; ++i)
	{
		if(GangTags[i][gt_Family] == fam)
		{
			CreateGangTag(i);
		}
	}
}

forward SprayWall(gangtag, playerid);
public SprayWall(gangtag, playerid)
{
	if(!IsPlayerConnected(playerid))
	{
		GangTags[gangtag][gt_TimeLeft] = 0;
		KillTimer(GangTags[gangtag][gt_Timer]);
		DeletePVar(playerid, "gt_Spraying");
		DeletePVar(playerid, "gt_Spray");
		return 1;
	}
	if(!IsPlayerInRangeOfPoint(playerid, 3, GangTags[gangtag][gt_PosX], GangTags[gangtag][gt_PosY], GangTags[gangtag][gt_PosZ]))
	{
		GangTags[gangtag][gt_TimeLeft] = 0;
		SendClientMessageEx(playerid, COLOR_WHITE, "You failed spraying the tag because you moved away from it.");
		KillTimer(GangTags[gangtag][gt_Timer]);
		DeletePVar(playerid, "gt_Spraying");
		DeletePVar(playerid, "gt_Spray");
		ClearAnimationsEx(playerid);
		return 1;
	}
	if(!GetPVarType(playerid, "gt_Spraying"))
	{
		GangTags[gangtag][gt_TimeLeft] = 0;
		SendClientMessageEx(playerid, COLOR_WHITE, "You failed spraying the tag because you got attacked.");
		KillTimer(GangTags[gangtag][gt_Timer]);
		DeletePVar(playerid, "gt_Spraying");
		DeletePVar(playerid, "gt_Spray");
		ClearAnimationsEx(playerid);
		return 1;
	}
	if(playerTabbed[playerid] != 0)
  	{
		GangTags[gangtag][gt_TimeLeft] = 0;
      	SendClientMessageEx(playerid, COLOR_WHITE, "You failed spraying the tag because you tabbed.");
		KillTimer(GangTags[gangtag][gt_Timer]);
		DeletePVar(playerid, "gt_Spraying");
		DeletePVar(playerid, "gt_Spray");
		ClearAnimationsEx(playerid);
		return 1;
   	}
	GangTags[gangtag][gt_TimeLeft]--;
	if(GangTags[gangtag][gt_TimeLeft] == 0)
	{
		new string[128];
		GangTags[gangtag][gt_Time] = 15;
		GangTags[gangtag][gt_TimeLeft] = 0;
		GangTags[gangtag][gt_Family] = PlayerInfo[playerid][pFMember];
		GangTags[gangtag][gt_ObjectID] = FamilyInfo[PlayerInfo[playerid][pFMember]][gtObject];
		CreateGangTag(gangtag);
		format(string, sizeof(string), "{FF8000}** {C2A2DA}%s successfully sprayed their family tag on the wall.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		DeletePVar(playerid, "gt_Spraying");
		ClearAnimationsEx(playerid);
		SaveGangTag(gangtag);
		KillTimer(GangTags[gangtag][gt_Timer]);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DIALOG_GANGTAG_MAIN:
		{
			if(response)
			{
				if(listitem == 0)
				{
					if(GetFreeGangTag() == -1) return SendClientMessageEx(playerid, COLOR_GREY, "There is no free gang tag to use!");
					SetPVarInt(playerid, "CreateGT", 1);
					SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: Press the FIRE button to save the position. You can cancel this action by pressing the AIM button.");
				}
				else if(listitem == 1)
				{
					ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_ID, DIALOG_STYLE_INPUT, "Gang Tag ID", "Please specify a vaild tag id:", "Select", "Close");
				}
			}
		}
		case DIALOG_GANGTAG_ID:
		{
			if(response == 1)
			{
				new gangtag = strval(inputtext);
				if(gangtag < 0 || gangtag > MAX_GANGTAGS)
				{
					ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_ID, DIALOG_STYLE_INPUT, "Gang Tag ID", "Please specify a vaild tag id:", "Select", "Close");
					SendClientMessageEx(playerid, COLOR_GREY, "You specified an invalid gang tag id.");
					return 1;				
				}
				if(GangTags[gangtag][gt_Used] == 0)
				{
					ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_ID, DIALOG_STYLE_INPUT, "Gang Tag ID", "Please specify a vaild tag id:", "Select", "Close");
					SendClientMessageEx(playerid, COLOR_GREY, "You specified an invalid gang tag id.");
					return 1;
				}
				new szMessage[128];
				SetPVarInt(playerid, "gt_ID", gangtag);
				format(szMessage, sizeof(szMessage), "Editing Gang Tag %d", gangtag);
				ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_EDIT, DIALOG_STYLE_LIST, szMessage, "Set to my position\nEdit position\nDelete", "Choose", "Close");
			}
			else
			{
				ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_MAIN, DIALOG_STYLE_LIST, "Gang Tags", "Create new gang tag\nEdit gang tag", "Choose", "Close");
			}
		}
		case DIALOG_GANGTAG_EDIT:
		{
			if(response == 1)
			{
				switch(listitem)
				{
					case 0: // Set to my position
					{
						SetPVarInt(playerid, "gt_Edit", 1);
						SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: Press the FIRE button to save the position. You can cancel this action by pressing the AIM button.");
					}
					case 1: // Edit position
					{
						new gangtag = GetPVarInt(playerid, "gt_ID");
						if(IsPlayerInRangeOfPoint(playerid, 10, GangTags[gangtag][gt_PosX], GangTags[gangtag][gt_PosY], GangTags[gangtag][gt_PosZ]))
						{
							SetPVarInt(playerid, "gt_Edit", 2);
							EditDynamicObject(playerid, GangTags[GetPVarInt(playerid, "gt_ID")][gt_Object]);
						}
						else
						{
							new szMessage[64];
							format(szMessage, sizeof(szMessage), "Editing Gang Tag %d", gangtag);
							ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_EDIT, DIALOG_STYLE_LIST, szMessage, "Set to my position\nEdit position\nDelete", "Choose", "Close");
							SendClientMessageEx(playerid, COLOR_GREY, "You are not in range of this gang tag!");
						}
					}
					case 2: // Delete
					{
						new szMessage[64];
						SetPVarInt(playerid, "gt_Edit", 3);
						format(szMessage, sizeof(szMessage), "Are you sure that you want to delete gang tag %d?", GetPVarInt(playerid, "gt_ID"));
						ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_EDIT1, DIALOG_STYLE_MSGBOX, "Delete Gang Tag", szMessage, "Yes", "No");
					}
				}
			}
			else
			{
				DeletePVar(playerid, "gt_ID");
				ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_ID, DIALOG_STYLE_INPUT, "Gang Tag ID", "Please specify a vaild tag id:", "Select", "Close");
			}
		}
		case DIALOG_GANGTAG_EDIT1:
		{
			new szMessage[64];
			if(response == 1)
			{
				switch(GetPVarInt(playerid, "gt_Edit"))
				{
					case 3: // Delete
					{
						ClearGangTag(GetPVarInt(playerid, "gt_ID"));
						SaveGangTag(GetPVarInt(playerid, "gt_ID"));
						format(szMessage, sizeof(szMessage), "You successfully deleted gang tag %d!", GetPVarInt(playerid, "gt_ID"));
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						format(szMessage, sizeof(szMessage), "%s has deleted gang tag %d.", GetPlayerNameEx(playerid), GetPVarInt(playerid, "gt_ID"));
						Log("Logs/GangTags.log", szMessage);
					}
				}
				DeletePVar(playerid, "gt_Edit");
				DeletePVar(playerid, "gt_ID");
			}
			else
			{
				DeletePVar(playerid, "gt_Edit");
				format(szMessage, sizeof(szMessage), "Editing Gang Tag %d", GetPVarInt(playerid, "gt_ID"));
				ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_EDIT, DIALOG_STYLE_LIST, szMessage, "Set to my position\nEdit position\nDelete", "Choose", "Close");
			}
		}
		case DIALOG_GANGTAG_FTAG:
		{
			if((PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] >= 1) || (PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID && PlayerInfo[playerid][pRank] >= 6 && GetPVarType(playerid, "gt_Perm")))
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: // Text
						{
							SetPVarInt(playerid, "gt_fEdit", 1);
							ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_INPUT, "Text", "Please enter the text below:", "Set", "Close");
						}
						case 1: // Color
						{
							SetPVarInt(playerid, "gt_fEdit", 2);
							ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_INPUT, "Color", "Please enter a hex color\nExample: 0xFFFFFFFF (aRGB)\nExample: 0xFF and then the RGB HEX", "Set", "Close");
						}
						case 2: // Font
						{
							SetPVarInt(playerid, "gt_fEdit", 3);
							ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_LIST, "Font", "Arial\nArial Black\nComic Sans MS\nImpact\nPalatino Linotype\nVerdana\nTimes New Roman\nLucida Console\nGeorgia", "Set", "Close");
						}
						case 3: // Font Size
						{
							SetPVarInt(playerid, "gt_fEdit", 4);
							ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_INPUT, "Font Size", "Please enter a size below:", "Set", "Close");
						}
						case 4: // Backcolor
						{
							SetPVarInt(playerid, "gt_fEdit", 5);
							ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_INPUT, "Color", "Please enter a hex color\nExample: 0xFFFFFFFF (aRGB)\nExample: 0xFF and then the RGB HEX", "Set", "Close");
						}
						case 5: // Bold
						{
							SetPVarInt(playerid, "gt_fEdit", 6);
							ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_MSGBOX, "Bold", "Would you like to toggle bold?", "Yes", "No");
						}
						case 6: // SP Tags
						{
							SetPVarInt(playerid, "gt_fEdit", 7);
							ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_LIST, "Single-Player Tags", "Frontyard Ballas 1\nFrontyard Ballas 2\nFrontyard Ballas 3\nSan Fierro Rifa\nRollin Heights Ballas\nSeville Blvd\nTemple Drive Ballas\nLos Santos Vagos\nVarrio Los Aztecas\nGrove Street 4Life\nDisable", "Choose", "Close");
						}
					}
				}
				else
				{
					DeletePVar(playerid, "gt_Fam");
				}
			}	
		}
		case DIALOG_GANGTAG_FTAGSEL:
		{
			if(response)
			{
				if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] >= 1)	
				{
					new fam = strval(inputtext);
					if(fam < 1 || fam > MAX_FAMILY)
					{
						ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAGSEL, DIALOG_STYLE_INPUT, "Family ID", "Specify a valid family id:", "Choose", "Close");
						SendClientMessageEx(playerid, COLOR_GREY, "You specified an invalid family id!");
						return 1;
					}
					SetPVarInt(playerid, "gt_Fam", fam);
					new szMessage[32];
					format(szMessage, sizeof(szMessage), "Gang Tag Edit - %s", FamilyInfo[fam][FamilyName]);
					ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAG, DIALOG_STYLE_LIST, szMessage, "Text\nColor\nFont\nFont Size\nBackcolor\nBold\nSP Tags", "Choose", "Close");
				}
			}
		}
		case DIALOG_GANGTAG_FTAGEDIT:
		{
			if((PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] >= 1) || (PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID && PlayerInfo[playerid][pRank] >= 6 && GetPVarType(playerid, "gt_Perm")))
			{
				new szMessage[128];
				new fam = GetPVarInt(playerid, "gt_Fam");
				if(response)
				{
					switch(GetPVarInt(playerid, "gt_fEdit"))
					{
						case 1: // Text
						{
							format(FamilyInfo[fam][gt_Text], 32, "%s", inputtext);
							format(szMessage, sizeof(szMessage), "You have set the text to %s.", inputtext);
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
							format(szMessage, sizeof(szMessage), "%s has set the gang tag text of family %s to %s.", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName], inputtext);
							Log("Logs/GangTags.log", szMessage);
							ReCreateGangTags(fam);
							SaveFamily(fam);
						}
						case 2: // Color
						{
							if(sscanf(inputtext, "h", FamilyInfo[fam][gt_FontColor]))
							{
								ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_INPUT, "Color", "Please enter a hex color (Example: \"0xFFFFFFFF\" ARGB Format)", "Set", "Close");
								SendClientMessageEx(playerid, COLOR_GREY, "You specified an invalid hex color!");
								return 1;
							}
							SendClientMessageEx(playerid, COLOR_WHITE, "You have adjusted the color.");
							format(szMessage, sizeof(szMessage), "%s has adjusted the gang tag text color of family %s", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName]);
							Log("Logs/GangTags.log", szMessage);	
							ReCreateGangTags(fam);
							SaveFamily(fam);
						}
						case 3: // Font
						{
							format(FamilyInfo[fam][gt_FontFace], 32, "%s", inputtext);
							format(szMessage, sizeof(szMessage), "You have set the font to %s.", inputtext);
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
							format(szMessage, sizeof(szMessage), "%s has set the gang tag font of family %s to %s.", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName], inputtext);
							Log("Logs/GangTags.log", szMessage);	
							ReCreateGangTags(fam);
							SaveFamily(fam);
						}
						case 4: // Font Size
						{
							new size = strval(inputtext);
							FamilyInfo[fam][gt_FontSize] = size;
							format(szMessage, sizeof(szMessage), "You have set the font-size to %d.", size);
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
							format(szMessage, sizeof(szMessage), "%s has set the gang tag font-size of family %s to %d.", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName], size);
							Log("Logs/GangTags.log", szMessage);	
							ReCreateGangTags(fam);
							SaveFamily(fam);
						}
						case 5: // Backcolor
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "This function has been disabled for now.");
						}
						case 6: // Bold
						{
							if(FamilyInfo[fam][gt_Bold])
							{
								FamilyInfo[fam][gt_Bold] = 0;
								SendClientMessageEx(playerid, COLOR_WHITE, "You have toggled off bold.");
							}
							else
							{
								FamilyInfo[fam][gt_Bold] = 1;
								SendClientMessageEx(playerid, COLOR_WHITE, "You have toggled on bold.");
							}
							format(szMessage, sizeof(szMessage), "%s has toggled the gang tag bold for family %s.", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName]);
							Log("Logs/GangTags.log", szMessage);		
							ReCreateGangTags(fam);
							SaveFamily(fam);
						}
						case 7: // SP Tags
						{
							if(listitem == 0)
							{
								FamilyInfo[fam][gtObject] = 1490;
								FamilyInfo[fam][gt_SPUsed] = 1;
							}
							else if(listitem == 1)
							{
								FamilyInfo[fam][gtObject] = 1524;
								FamilyInfo[fam][gt_SPUsed] = 1;
							}
							else if(listitem == 2)
							{
								FamilyInfo[fam][gtObject] = 1525;
								FamilyInfo[fam][gt_SPUsed] = 1;
							}
							else if(listitem == 3)
							{
								FamilyInfo[fam][gtObject] = 1526;
								FamilyInfo[fam][gt_SPUsed] = 1;
							}
							else if(listitem == 4)
							{
								FamilyInfo[fam][gtObject] = 1527;
								FamilyInfo[fam][gt_SPUsed] = 1;
							}
							else if(listitem == 5)
							{
								FamilyInfo[fam][gtObject] = 1528;
								FamilyInfo[fam][gt_SPUsed] = 1;
							}
							else if(listitem == 6)
							{
								FamilyInfo[fam][gtObject] = 1529;
								FamilyInfo[fam][gt_SPUsed] = 1;
							}
							else if(listitem == 7)
							{
								FamilyInfo[fam][gtObject] = 1530;
								FamilyInfo[fam][gt_SPUsed] = 1;
							}
							else if(listitem == 8)
							{
								FamilyInfo[fam][gtObject] = 1531;
								FamilyInfo[fam][gt_SPUsed] = 1;
							}
							else if(listitem == 9)
							{
								FamilyInfo[fam][gtObject] = 18659;
								FamilyInfo[fam][gt_SPUsed] = 1;
							}
							else if(listitem == 10)
							{
								FamilyInfo[fam][gtObject] = 1490;
								FamilyInfo[fam][gt_SPUsed] = 0;
							}
							format(szMessage, sizeof(szMessage), "You have set the single-player tag to %s.", inputtext);
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
							format(szMessage, sizeof(szMessage), "%s has set the single-player tag of family %s to %s.", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName], inputtext);
							Log("Logs/GangTags.log", szMessage);		
							ReCreateGangTags(fam);
							SaveFamily(fam);
						}
					}
					DeletePVar(playerid, "gt_fEdit");
					DeletePVar(playerid, "gt_Fam");
				}
				else
				{
					DeletePVar(playerid, "gt_fEdit");
					format(szMessage, sizeof(szMessage), "Gang Tag Edit - %s", FamilyInfo[fam][FamilyName]);
					ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAG, DIALOG_STYLE_LIST, szMessage, "Text\nColor\nFont\nFont Size\nBackcolor\nBold\nSP Tags", "Choose", "Close");	
				}
			}	
		}
	}
	return 0;
}

/*CMD:gtedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_MAIN, DIALOG_STYLE_LIST, "Gang Tags", "Create new gang tag\nEdit gang tag", "Choose", "Close");
	return 1;
}

CMD:gtnear(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	new string[128];
	SendClientMessageEx(playerid, COLOR_RED, "Listing all gang tags within 30 meters of you...");
	for(new i = 0; i < MAX_GANGTAGS; i++)
	{
		if(GangTags[i][gt_Used] != 0 && IsPlayerInRangeOfPoint(playerid, 30, GangTags[i][gt_PosX], GangTags[i][gt_PosY], GangTags[i][gt_PosZ]))
		{
			format(string, sizeof(string), "ID: %d | Range: %f | VW: %d | Int: %d", i, GetPlayerDistanceFromPoint(playerid, GangTags[i][gt_PosX], GangTags[i][gt_PosY], GangTags[i][gt_PosZ]), GangTags[i][gt_VW], GangTags[i][gt_Int]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	return 1;
}

CMD:gotogt(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	new gangtag;
	if(sscanf(params, "d", gangtag)) return SendClientMessageEx(playerid, COLOR_WHITE, "Syntax: /gotogt <gangtag>");
	if(gangtag < 0 || gangtag > MAX_GANGTAGS) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid gang tag specified.");
	if(GangTags[gangtag][gt_Used] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "This gang tag is not being used.");
	SetPlayerPos(playerid, GangTags[gangtag][gt_PosX], GangTags[gangtag][gt_PosY], GangTags[gangtag][gt_PosZ]);
	SendClientMessageEx(playerid, COLOR_GREY, "You have been teleported.");
	return 1;
}

CMD:gtstatus(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	new gangtag;
	if(sscanf(params, "d", gangtag)) return SendClientMessageEx(playerid, COLOR_WHITE, "Syntax: /gtstatus <gangtag>");
	if(gangtag < 0 || gangtag > MAX_GANGTAGS) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid gang tag specified.");
	new string[128];
	format(string, sizeof(string), "Status of gang tag %d:", gangtag);
	SendClientMessageEx(playerid, COLOR_GREEN, string);
	SendClientMessageEx(playerid, COLOR_GREEN, "__________________________________________________________________________________");
	format(string, sizeof(string), "SQLID: %d | PosX: %f | PosY: %f | PosZ: %f", GangTags[gangtag][gt_SQLID], GangTags[gangtag][gt_PosX], GangTags[gangtag][gt_PosY], GangTags[gangtag][gt_PosZ]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "RotX: %f | RotY: %f | RotZ: %f", GangTags[gangtag][gt_PosRX], GangTags[gangtag][gt_PosRY], GangTags[gangtag][gt_PosRZ]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Family: %d | ObjectID: %d | VW: %d | Int: %d | Time: %d", GangTags[gangtag][gt_Family], GangTags[gangtag][gt_ObjectID], GangTags[gangtag][gt_VW], GangTags[gangtag][gt_Int], GangTags[gangtag][gt_Time]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	SendClientMessageEx(playerid, COLOR_GREEN, "__________________________________________________________________________________");
	return 1;
}

CMD:taginfo(playerid, params[])
{
	new string[64];
	for(new i = 0; i < MAX_GANGTAGS; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, GangTags[i][gt_PosX], GangTags[i][gt_PosY], GangTags[i][gt_PosZ]) && GangTags[i][gt_Used] != 0)
		{
			if(GangTags[i][gt_Family] != INVALID_FAMILY_ID)
			{
				format(string, sizeof(string), "This is the tag of %s.", FamilyInfo[GangTags[i][gt_Family]][FamilyName]);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "There's no information about this tag.");
			}
			return 1;
		}
	}
	SendClientMessageEx(playerid, COLOR_GREY, "You are not near any gang tag.");
	return 1;
}

CMD:spraytag(playerid, params[])
{
	if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID) return SendClientMessageEx(playerid, COLOR_GREY, "You are not part of a family!");
	if(PlayerInfo[playerid][pRank] < 5) return SendClientMessageEx(playerid, COLOR_GREY, "You need to be rank 5 to use this feature!");
	new string[128];
	for(new i = 0; i < MAX_GANGTAGS; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, GangTags[i][gt_PosX], GangTags[i][gt_PosY], GangTags[i][gt_PosZ]))
		{
			if(GangTags[i][gt_TimeLeft] > 0)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "This tag is already being sprayed.");
				return 1;
			}
			if(GangTags[i][gt_Family] == PlayerInfo[playerid][pFMember])
			{
				SendClientMessageEx(playerid, COLOR_GREY, "This is already your families tag.");
				return 1;
			}
			if(GangTags[i][gt_Time] > 0)
			{
				format(string, sizeof(string), "This tag will be available to spray in %d minute(s).", GangTags[i][gt_Time]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
				return 1;
			}
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s starts spraying something on the wall.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SendClientMessageEx(playerid, COLOR_WHITE, "You started spraying your family tag on the wall, it will be finished in 30 seconds.");
			SendClientMessageEx(playerid, COLOR_WHITE, "You can press the fire key to stop spraying the wall.");
			GangTags[i][gt_TimeLeft] = 30;
			SetPVarInt(playerid, "gt_Spraying", 1);
			SetPVarInt(playerid, "gt_Spray", i);
			GangTags[i][gt_Timer] = SetTimerEx("SprayWall", 1000, true, "ii", i, playerid);
			ApplyAnimation(playerid, "SPRAYCAN", "spraycan_full", 4.0, 1, 1, 1, 0, 0, 1);
			return 1;
		}
	}
	SendClientMessageEx(playerid, COLOR_GREY, "You are not near any family tag!");
	return 1;
}

CMD:tagperm(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Syntax: /tagperm <FamilyMember>");
		SendClientMessageEx(playerid, COLOR_GREY, "NOTE: The player needs to be a R6.");
		SendClientMessageEx(playerid, COLOR_GREY, "NOTE: Use this command again to remove his permissions.");
		return 1;
	}
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	new string[128];
	if(GetPVarType(giveplayerid, "gt_Perm"))
	{
		DeletePVar(giveplayerid, "gt_Perm");
		format(string, sizeof(string), "You have revoked the /tagedit permissions from %s.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "%s has revoked your /tagedit permissions.", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
		return 1;
	}
	if(PlayerInfo[giveplayerid][pFMember] == INVALID_FAMILY_ID) return SendClientMessageEx(playerid, COLOR_GREY, "This player is not part of a family.");
	if(PlayerInfo[giveplayerid][pRank] < 6) return SendClientMessageEx(playerid, COLOR_GREY, "This player is not a R6.");
	SetPVarInt(giveplayerid, "gt_Perm", 1);
	format(string, sizeof(string), "You have granted %s permissions to use /tagedit for Family %s.", GetPlayerNameEx(giveplayerid), FamilyInfo[PlayerInfo[giveplayerid][pFMember]][FamilyName]);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "%s granted you permissions to use /tagedit.", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "%s has granted %s to use /tagedit for family '%s'.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), FamilyInfo[PlayerInfo[giveplayerid][pFMember]][FamilyName]);
	Log("Logs/GangTags.log", string);
	return 1;
}

CMD:tagedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
		ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAGSEL, DIALOG_STYLE_INPUT, "Family ID", "Specify a valid family id:", "Choose", "Close");
	}
	else if(GetPVarInt(playerid, "gt_Perm") == 1 && PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID && PlayerInfo[playerid][pRank] >= 6)
	{
		new string[32];
		format(string, sizeof(string), "Gang Tag Edit - %s", FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyName]);
		SetPVarInt(playerid, "gt_Fam", PlayerInfo[playerid][pFMember]);
		ShowPlayerDialogEx(playerid, DIALOG_GANGTAG_FTAG, DIALOG_STYLE_LIST, string, "Text\nColor\nFont\nFont Size\nBackcolor\nBold\nSP Tags", "Choose", "Close");	
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	}
	return 1;
}
*/