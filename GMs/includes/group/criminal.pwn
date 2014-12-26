/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Criminal Group Type

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)
					
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

stock SendFamilyMessage(family, color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pMember] == family || PlayerInfo[i][pLeader] == family) {
			if(!gFam[i]) {
				SendClientMessageEx(i, color, string);
			}
		}
	}	
}

stock FamilyLog(familyid, string[])
{
	new month, day, year, file[32];
	getdate(year, month, day);
	format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", familyid, year, month, day);
	return Log(file, string);
}

stock ClearFamily(family)
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pFMember] == family) {
			SendClientMessageEx(i, COLOR_LIGHTBLUE, "* The Family you are in has just been deleted by an Admin, you have been kicked out automatically.");
			PlayerInfo[i][pFMember] = INVALID_FAMILY_ID;
		}
	}	

	new string[MAX_PLAYER_NAME];
	format(string, sizeof(string), "None");
	FamilyInfo[family][FamilyTaken] = 0;
	strmid(FamilyInfo[family][FamilyName], string, 0, strlen(string), 255);
	strmid(FamilyMOTD[family][0], string, 0, strlen(string), 128);
	strmid(FamilyMOTD[family][1], string, 0, strlen(string), 128);
	strmid(FamilyMOTD[family][2], string, 0, strlen(string), 128);
	strmid(FamilyInfo[family][FamilyLeader], string, 0, strlen(string), 255);
	format(string, sizeof(string), "Newb");
	strmid(FamilyRankInfo[family][0], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Outsider");
	strmid(FamilyRankInfo[family][1], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Associate");
	strmid(FamilyRankInfo[family][2], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Soldier");
	strmid(FamilyRankInfo[family][3], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Capo");
	strmid(FamilyRankInfo[family][4], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Underboss");
	strmid(FamilyRankInfo[family][5], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Godfather");
	strmid(FamilyRankInfo[family][6], string, 0, strlen(string), 30);
	format(string, sizeof(string), "None");
	for(new i = 0; i < 5; i++)
	{
		strmid(FamilyDivisionInfo[family][i], string, 0, 16, 30);
	}
	FamilyInfo[family][FamilyColor] = 0;
	FamilyInfo[family][FamilyTurfTokens] = 24;
	FamilyInfo[family][FamilyMembers] = 0;
	for(new i = 0; i < 4; i++)
	{
		FamilyInfo[family][FamilySpawn][i] = 0.0;
	}
	for(new i = 0; i < 10; i++)
	{
		FamilyInfo[family][FamilyGuns][i] = 0;
	}
	FamilyInfo[family][FamilyCash] = 0;
	FamilyInfo[family][FamilyMats] = 0;
	FamilyInfo[family][FamilyHeroin] = 0;
	FamilyInfo[family][FamilyPot] = 0;
	FamilyInfo[family][FamilyCrack] = 0;
	FamilyInfo[family][FamilySafe][0] = 0.0;
	FamilyInfo[family][FamilySafe][1] = 0.0;
	FamilyInfo[family][FamilySafe][2] = 0.0;
	FamilyInfo[family][FamilySafeVW] = 0;
	FamilyInfo[family][FamilySafeInt] = 0;
	FamilyInfo[family][FamilyUSafe] = 0;
	FamilyInfo[family][FamColor] = 0x01FCFF;
	DestroyDynamicPickup( FamilyInfo[family][FamilyEntrancePickup] );
	DestroyDynamicPickup( FamilyInfo[family][FamilyExitPickup] );
	DestroyDynamic3DTextLabel( Text3D:FamilyInfo[family][FamilyEntranceText] );
	DestroyDynamic3DTextLabel( Text3D:FamilyInfo[family][FamilyExitText] );
	DestroyDynamicPickup( FamilyInfo[family][FamilyPickup] );
	new query[60];
	format(query, sizeof(query), "UPDATE `accounts` SET `FMember` = 255 WHERE `FMember` = %d", family);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	SaveFamilies();
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case HQENTRANCE:
		{
			if(response)
			{
				new Float: x, Float: y, Float: z, Float: a;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);
				if(GetPVarInt(playerid, "editingfamhqaction") == 5)
				{
					DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] );
					DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] );
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][0] = x;
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][1] = y;
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][2] = z;
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][3] = a;
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] = CreateDynamicPickup(1318, 23, x, y, z);
					format(szMiscArray, sizeof(szMiscArray), "%s", FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyName]);
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, x, y, z+0.6, 4.0);
					SendClientMessageEx(playerid, COLOR_GRAD2, "HQ Entrance changed!.");
					TogglePlayerControllable(playerid, true);
					SaveFamiliesHQ(GetPVarInt(playerid, "editingfamhq"));
					return 1;
				}
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][0] = x;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][1] = y;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][2] = z;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][3] = a;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] = CreateDynamicPickup(1318, 23, x, y, z);
				format(szMiscArray, sizeof(szMiscArray), "%s", FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyName]);
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, x, y, z+0.6, 4.0);
				SendClientMessageEx(playerid, COLOR_GRAD2, "HQ Entrance saved! Please stand where you want the exit at, once ready press the fire button.");
				SetPVarInt(playerid, "editingfamhqaction", 2);
				TogglePlayerControllable(playerid, true);
			}
			else
			{
				if(GetPVarInt(playerid, "editingfamhqaction") == 5)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have cancelled the exterior change of this HQ.");
					SetPVarInt(playerid, "editingfamhqaction", 0);
					SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
					TogglePlayerControllable(playerid, true);
					return 1;
				}
				SendClientMessageEx(playerid, COLOR_GRAD2, "You have cancelled the creation of this HQ.");
				DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] );
				DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitPickup] );
				DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] );
				DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitText] );
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][0] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][1] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][2] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][3] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][0] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][1] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][2] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][3] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = 0;
				SetPVarInt(playerid, "editingfamhqaction", 0);
				SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
				TogglePlayerControllable(playerid, true);
			}
		}
		case HQEXIT:
		{
			if(response)
			{
				new Float: x, Float: y, Float: z, Float: a;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);
				if(GetPVarInt(playerid, "editingfamhqaction") == 6)
				{
					DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitPickup] );
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][0] = x;
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][1] = y;
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][2] = z;
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][3] = a;
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = GetPlayerInterior(playerid);
					FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyVirtualWorld] = GetPVarInt(playerid, "editingfamhq")+900000;
					SendClientMessageEx(playerid, COLOR_GRAD2, "HQ Exit changed!.");
					TogglePlayerControllable(playerid, true);
					SaveFamiliesHQ(GetPVarInt(playerid, "editingfamhq"));
					return 1;
				}
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][0] = x;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][1] = y;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][2] = z;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][3] = a;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = GetPlayerInterior(playerid);
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyVirtualWorld] = GetPVarInt(playerid, "editingfamhq")+900000;
				format(szMiscArray,sizeof(szMiscArray),"HQ Exit saved!\n\nIs this interior a custom mapped one?");
				ShowPlayerDialog(playerid,HQCUSTOMINT,DIALOG_STYLE_MSGBOX,"Warning:",szMiscArray,"Yes","No");
				SetPVarInt(playerid, "editingfamhqaction", 3);
				TogglePlayerControllable(playerid, true);
			}
			else
			{
				if(GetPVarInt(playerid, "editingfamhqaction") == 6)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have cancelled the interior change of this HQ.");
					SetPVarInt(playerid, "editingfamhqaction", 0);
					SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
					TogglePlayerControllable(playerid, true);
					return 1;
				}
				SendClientMessageEx(playerid, COLOR_GRAD2, "You have cancelled the creation of this HQ.");
				DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] );
				DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitPickup] );
				DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] );
				DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitText] );
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][0] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][1] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][2] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][3] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][0] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][1] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][2] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][3] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = 0;
				SetPVarInt(playerid, "editingfamhqaction", 0);
				SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
				TogglePlayerControllable(playerid, true);
			}
		}
		case HQCUSTOMINT:
		{
			if(response)
			{
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyCustomMap] = 1;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = 255;
				if(GetPVarInt(playerid, "editingfamhqaction") == 7)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully changed the custom interior for this HQ.");
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully created this HQ.");
				}
				SaveFamiliesHQ(GetPVarInt(playerid, "editingfamhq"));
				SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
			}
			else
			{
				if(GetPVarInt(playerid, "editingfamhqaction") == 7)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully changed the custom interior for this HQ.");
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully created this HQ.");
				}
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyCustomMap] = 0;
				SaveFamiliesHQ(GetPVarInt(playerid, "editingfamhq"));
				SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
			}
		}
		case HQDELETE:
		{
			if(!response)
			{
			}
			else
			{
				format(szMiscArray,sizeof(szMiscArray),"You have successfully deleted '%s' HQ", FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyName]);
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] );
				DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitPickup] );
				DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] );
				DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitText] );
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][0] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][1] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][2] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][3] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][0] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][1] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][2] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][3] = 0.0;
				FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = 0;
				SaveFamiliesHQ(GetPVarInt(playerid, "editingfamhq"));
				SetPVarInt(playerid, "editingfamhqaction", 0);
				SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
				TogglePlayerControllable(playerid, true);
			}
		}
	}
	return 1;
}

CMD:togfamily(playerid, params[])
{
	return cmd_togfam(playerid, params);
}

CMD:togfam(playerid, params[])
{
	if (!gFam[playerid])
	{
		gFam[playerid] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have disabled family chat.");
	}
	else
	{
		gFam[playerid] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have enabled family chat.");
	}
	return 1;
}

CMD:safebalance(playerid, params[]) {
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID) {
		if(FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyUSafe] < 1) {
			SendClientMessageEx(playerid, COLOR_GRAD1, "Your family doesn't have a safe.");
		}
		else
		{
			new string[128];

			new weaponsinlocker;
			for(new s = 0; s < 10; s++)
			{
				if(FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyGuns][s] != 0)
				{
					weaponsinlocker++;
				}
			}

			format(string, sizeof(string), " Safe: %s | Gunlockers: %d/10 | Cash: $%d | Pot: %d | Crack: %d | Materials: %d | Heroin: %d", FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyName], weaponsinlocker, FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyCash], FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyPot], FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyCrack], FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyMats], FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyHeroin]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a family.");
	return 1;
}

CMD:safehelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________________");
	SendClientMessageEx(playerid, COLOR_WHITE, "SAFE HELP: Type a command for more information.");
	SendClientMessageEx(playerid, COLOR_WHITE, "SAFE: /safebalance /safedeposit /safewithdraw /fstoregun /fgetgun.");
	return 1;
}

CMD:quitfamily(playerid, params[]) {
	return cmd_quitgang(playerid, params);
}

CMD:quitgang(playerid, params[])
{
    if(PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID)
	{
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have quit the family, you are now a civilian again.");
		new string[128], file[32], month, day, year;
		getdate(year,month,day);
		format(string, sizeof(string), "%s has quit %s as rank %i", GetPlayerNameEx(playerid), FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyName], PlayerInfo[playerid][pRank]);
		format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", PlayerInfo[playerid][pFMember], year, month, day);
		Log(file, string);
		PlayerInfo[playerid][pFMember] = INVALID_FAMILY_ID;
		PlayerInfo[playerid][pRank] = 0;
		PlayerInfo[playerid][pDivision] = -1;
		if(!IsValidSkin(GetPlayerSkin(playerid)))
		{
		    new rand = random(sizeof(CIV));
			SetPlayerSkin(playerid,CIV[rand]);
			PlayerInfo[playerid][pModel] = CIV[rand];
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a family.");
	}
	return 1;
}

CMD:switchfam(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 1 || PlayerInfo[playerid][pFactionModerator] >= 4)
	{
		new string[128], familyid;
		if(sscanf(params, "d", familyid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /switchfam [familyid]");
		if(familyid < 1 || familyid > MAX_FAMILY) return SendClientMessageEx(playerid, COLOR_WHITE, "Invalid Family Number.");
		format(string, sizeof(string), "You have switched to family ID %d (%s).", familyid, FamilyInfo[familyid][FamilyName]);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		PlayerInfo[playerid][pRank] = 6;
		PlayerInfo[playerid][pFMember] = familyid;
		PlayerInfo[playerid][pMember] = INVALID_GROUP_ID;
		PlayerInfo[playerid][pLeader] = INVALID_GROUP_ID;

	}
	return 1;
}

CMD:gangwarn(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 1 || PlayerInfo[playerid][pFactionModerator] >= 4)
	{
		new string[128], giveplayerid, reason[64];
		if(sscanf(params, "us[64]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gangwarn [player] [reason]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pAdmin] >= 2)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "Admins can not be gang warned!");
				return 1;
			}
			if(PlayerInfo[giveplayerid][pGangWarn] >= 3)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That person is already banned from gangs.");
				return 1;
			}
			PlayerInfo[giveplayerid][pGangWarn] += 1;
			if(PlayerInfo[giveplayerid][pGangWarn] == 3)
			{
				format(string, sizeof(string), "AdmCmd: %s(%d) was banned from gangs by %s (had 3 Gang Warnings), reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason);
				Log("logs/admin.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned from gangs by %s (had 3 Gang Warnings), reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
				ABroadCast(COLOR_LIGHTRED, string, 2);
				format(string, sizeof(string), "You have been banned from gangs by %s (had 3 Gang Warnings), reason: %s", GetPlayerNameEx(playerid), reason);
				SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
				PlayerInfo[giveplayerid][pFMember] = INVALID_FAMILY_ID;
				PlayerInfo[giveplayerid][pRank] = 0;
				PlayerInfo[giveplayerid][pModel] = NOOB_SKIN;
				SetPlayerSkin(giveplayerid, NOOB_SKIN);
				return 1;
			}
			format(string, sizeof(string), "AdmCmd: %s was gang warned by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
			ABroadCast(COLOR_LIGHTRED, string, 2);
			format(string, sizeof(string), "AdmCmd: %s(%d) was gang warned by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason);
			Log("logs/admin.log", string);
			format(string, sizeof(string), "You were given a gang warning by %s, reason: %s", GetPlayerNameEx(playerid), reason);
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
			return 1;
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	return 1;
}

CMD:gangban(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
		new string[128], giveplayerid, reason[64];
		if(sscanf(params, "us[64]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gangban [player] [reason]");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
		if(PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "Admins can not be gang warned!");
		if(PlayerInfo[giveplayerid][pGangWarn] >= 3) return SendClientMessageEx(playerid, COLOR_GRAD2, "That person is already banned from gangs.");
		format(string, sizeof(string), "AdmCmd: %s(%d) was banned from gangs by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason);
		Log("logs/admin.log", string);
		format(string, sizeof(string), "AdmCmd: %s was banned from gangs by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
		ABroadCast(COLOR_LIGHTRED, string, 2);
		format(string, sizeof(string), "You have been banned from gangs by %s, reason: %s", GetPlayerNameEx(playerid), reason);
		SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
		PlayerInfo[giveplayerid][pGangWarn] = 3;
		PlayerInfo[giveplayerid][pFMember] = INVALID_FAMILY_ID;
		PlayerInfo[giveplayerid][pRank] = 0;
		PlayerInfo[giveplayerid][pModel] = NOOB_SKIN;
		SetPlayerSkin(giveplayerid, NOOB_SKIN);
	}
	return 1;
}

CMD:gangunban(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gangunban [player]");

		if( IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pGangWarn] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "That person isn't banned from gangs." );
			format(string, sizeof(string), "You have unbanned %s from gangs.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "You have been unbanned from gangs by Admin %s.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
			PlayerInfo[giveplayerid][pGangWarn] = 0;

			format(string, sizeof(string), "AdmCmd: %s(%d) has been unbanned from gangs by %s.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been unbanned from gangs by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, string, 2);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Player not connected.");
		}
	}
	return 1;
}

CMD:fedithq(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
		new family, x_hq[64], string[128];
		if(sscanf(params, "is[64]", family, x_hq))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fedithq [family] [name]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Create, Delete, Editexterior, Editinterior, Custominterior");
			return 1;
		}

		if(family < 1 || family > MAX_FAMILY) {
			format(string,sizeof(string), "   FamilyNr can't be below 1 or above %i!", MAX_FAMILY);
			SendClientMessageEx(playerid, COLOR_GREY, string);
			return 1;
		}
		if(strcmp(x_hq,"create",true) == 0)
		{
	   		SetPVarInt(playerid, "editingfamhq", family);
			SetPVarInt(playerid, "editingfamhqaction", 1);
			SendClientMessageEx(playerid, COLOR_WHITE, "Please stand where you want the entrance to be at.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Once ready press the fire button.");
		}
		else if(strcmp(x_hq,"delete",true) == 0)
		{
		    SetPVarInt(playerid, "editingfamhq", family);
			SetPVarInt(playerid, "editingfamhqaction", 4);
			format(string,128,"Are you sure you want to delete this HQ?");
			ShowPlayerDialog(playerid,HQDELETE,DIALOG_STYLE_MSGBOX,"Warning:",string,"Yes","No");
		}
		else if(strcmp(x_hq,"editexterior",true) == 0)
		{
		    SetPVarInt(playerid, "editingfamhq", family);
			SetPVarInt(playerid, "editingfamhqaction", 5);
			SendClientMessageEx(playerid, COLOR_WHITE, "Please stand where you want the entrance to be at.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Once ready press the fire button.");
		}
		else if(strcmp(x_hq,"editinterior",true) == 0)
		{
		    SetPVarInt(playerid, "editingfamhq", family);
			SetPVarInt(playerid, "editingfamhqaction", 6);
			SendClientMessageEx(playerid, COLOR_WHITE, "Please stand where you want the exit to be at.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Once ready press the fire button.");
		}
		else if(strcmp(x_hq,"custominterior",true) == 0)
		{
		    SetPVarInt(playerid, "editingfamhq", family);
			SetPVarInt(playerid, "editingfamhqaction", 3);
			format(string,128,"Is '%s' interior a custom mapped one?", FamilyInfo[family][FamilyName]);
			ShowPlayerDialog(playerid,HQCUSTOMINT,DIALOG_STYLE_MSGBOX,"Warning:",string,"Yes","No");
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "	Not a valid HQ name.");
		}
		SaveFamily(family);
		return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:adjustdiv(playerid, params[])
{
    if(PlayerInfo[playerid][pFMember] >= 1)
	{
		if(PlayerInfo[playerid][pRank] >= 6)
		{
		    new iFamily, iDiv, divisionname[GROUP_MAX_DIV_LEN], szMessage[128];
		    if(sscanf(params, "is[16]", iDiv, divisionname))
		    {
		        SendClientMessageEx(playerid, COLOR_GREY, "Usage: /adjustdiv [division id] [division name]");
		        return 1;
		    }
		    if(0 <= iDiv <= 4)
			{
				new file[32], month, day, year;
				getdate(year,month,day);
			    iFamily = PlayerInfo[playerid][pFMember];
				format(FamilyDivisionInfo[iFamily][iDiv], 16, "%s", divisionname);
				SaveFamily(iFamily);
				format(szMessage, sizeof(szMessage), "* You have changed the name of division %d to %s.", iDiv, divisionname);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
				format(szMessage, sizeof(szMessage), "%s adjusted %s's division %d to %s", GetPlayerNameEx(playerid), FamilyInfo[iFamily][FamilyName], iDiv, divisionname);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", iFamily, year, month, day);
				Log(file, szMessage);
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "Invalid division ID!");
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "You're not authorized to use this command!");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You're not in a family!");
	return 1;
}

CMD:fedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
		new family, x_job[64], x_hq[64], ammount, string[128];
		if(sscanf(params, "is[64]s[64]", family, x_job, x_hq))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fedit [family] [name] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Tokens, Leader, MaxSkins, Skin1, Skin2, Skin3, Skin4, Skin5, Skin6, Skin7, Skin8");
			return 1;
		}
        ammount = strval(x_hq);
		if(family < 1 || family > MAX_FAMILY) {
			format(string,sizeof(string), "   FamilyNr can't be below 1 or above %i!", MAX_FAMILY);
		 	SendClientMessageEx(playerid, COLOR_GREY, string);
		  	return 1;
		  }
		if(strcmp(x_job,"tokens",true) == 0)
		{
			FamilyInfo[family][FamilyTurfTokens] = ammount * 12;
			format(string, sizeof(string), "You have changed '%s' tokens amount to %d.", FamilyInfo[family][FamilyName], ammount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			return 1;
		}
		else if (strcmp(x_job,"leader",true) == 0)
		{
			if(strlen(x_hq) >= 20 )
			{
				SendClientMessageEx( playerid, COLOR_GRAD1, "That leader name is too long, please refrain from using more than 20 characters." );
				return 1;
			}
			strcpy(FamilyInfo[family][FamilyLeader], x_hq, MAX_PLAYER_NAME);
			format(string, sizeof(string), "You have changed '%s' leader name to %s.", FamilyInfo[family][FamilyName], x_hq);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			return 1;
		}
		else if(strcmp(x_job,"maxskins",true) == 0)
		{
			if(ammount > 8) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot set the maxskins more than 8.");
			if(ammount == 7)
			{
				FamilyInfo[family][FamilySkins][7] = 0;
			}
			if(ammount == 6)
			{
				FamilyInfo[family][FamilySkins][7] = 0;
				FamilyInfo[family][FamilySkins][6] = 0;
			}
			if(ammount == 5)
			{
				FamilyInfo[family][FamilySkins][7] = 0;
				FamilyInfo[family][FamilySkins][6] = 0;
				FamilyInfo[family][FamilySkins][5] = 0;
			}
			if(ammount == 4)
			{
				FamilyInfo[family][FamilySkins][7] = 0;
				FamilyInfo[family][FamilySkins][6] = 0;
				FamilyInfo[family][FamilySkins][5] = 0;
				FamilyInfo[family][FamilySkins][4] = 0;
			}
			if(ammount == 3)
			{
				FamilyInfo[family][FamilySkins][7] = 0;
				FamilyInfo[family][FamilySkins][6] = 0;
				FamilyInfo[family][FamilySkins][5] = 0;
				FamilyInfo[family][FamilySkins][4] = 0;
				FamilyInfo[family][FamilySkins][3] = 0;
			}
			if(ammount == 2)
			{
				FamilyInfo[family][FamilySkins][7] = 0;
				FamilyInfo[family][FamilySkins][6] = 0;
				FamilyInfo[family][FamilySkins][5] = 0;
				FamilyInfo[family][FamilySkins][4] = 0;
				FamilyInfo[family][FamilySkins][3] = 0;
				FamilyInfo[family][FamilySkins][2] = 0;
			}

			if(ammount == 1)
			{
				FamilyInfo[family][FamilySkins][7] = 0;
				FamilyInfo[family][FamilySkins][6] = 0;
				FamilyInfo[family][FamilySkins][5] = 0;
				FamilyInfo[family][FamilySkins][4] = 0;
				FamilyInfo[family][FamilySkins][3] = 0;
				FamilyInfo[family][FamilySkins][2] = 0;
				FamilyInfo[family][FamilySkins][1] = 0;
			}

			FamilyInfo[family][FamilyMaxSkins] = ammount;
			format(string, sizeof(string), "You have changed '%s' max skins amount to %d.", FamilyInfo[family][FamilyName], ammount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else if(strcmp(x_job,"skin1",true) == 0)
		{
			FamilyInfo[family][FamilySkins][0] = ammount;
			format(string, sizeof(string), "You have changed '%s' skin #1 to %d.", FamilyInfo[family][FamilyName], ammount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else if(strcmp(x_job,"skin2",true) == 0)
		{
			FamilyInfo[family][FamilySkins][1] = ammount;
			format(string, sizeof(string), "You have changed '%s' skin #2 to %d.", FamilyInfo[family][FamilyName], ammount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else if(strcmp(x_job,"skin3",true) == 0)
		{
			FamilyInfo[family][FamilySkins][2] = ammount;
			format(string, sizeof(string), "You have changed '%s' skin #3 to %d.", FamilyInfo[family][FamilyName], ammount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else if(strcmp(x_job,"skin4",true) == 0)
		{
			FamilyInfo[family][FamilySkins][3] = ammount;
			format(string, sizeof(string), "You have changed '%s' skin #4 to %d.", FamilyInfo[family][FamilyName], ammount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else if(strcmp(x_job,"skin5",true) == 0)
		{
			FamilyInfo[family][FamilySkins][4] = ammount;
			format(string, sizeof(string), "You have changed '%s' skin #5 to %d.", FamilyInfo[family][FamilyName], ammount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else if(strcmp(x_job,"skin6",true) == 0)
		{
			FamilyInfo[family][FamilySkins][5] = ammount;
			format(string, sizeof(string), "You have changed '%s' skin #6 to %d.", FamilyInfo[family][FamilyName], ammount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else if(strcmp(x_job,"skin7",true) == 0)
		{
			FamilyInfo[family][FamilySkins][6] = ammount;
			format(string, sizeof(string), "You have changed '%s' skin #7 to %d.", FamilyInfo[family][FamilyName], ammount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else if(strcmp(x_job,"skin8",true) == 0)
		{
			FamilyInfo[family][FamilySkins][7] = ammount;
			format(string, sizeof(string), "You have changed '%s' skin #8 to %d.", FamilyInfo[family][FamilyName], ammount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "	Not a valid name.");
			return 1;
		}
    	SaveFamily(family);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:families(playerid, params[])
{
	new
		string[128],
		familyid;

	if(sscanf(params, "d", familyid))
	{
		for(new i = 1; i < sizeof(FamilyInfo); i++)
		{
			new count;
			foreach(Player, j)
			{
				if(PlayerInfo[j][pFMember] == i) count++;
			}
			if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID)
			{
				format(string, sizeof(string), "%s (%d) | Members: %d | Members Online: %d", FamilyInfo[i][FamilyName], i, FamilyInfo[i][FamilyMembers], count);
			}
			else
			{
				format(string, sizeof(string), "%s (%d) | Leader: %s | Members: %d | Claim Tokens: %d | Members Online: %d", FamilyInfo[i][FamilyName], i, FamilyInfo[i][FamilyLeader], FamilyInfo[i][FamilyMembers], (FamilyInfo[i][FamilyTurfTokens] < 12)?0:FamilyInfo[i][FamilyTurfTokens]/12, count);
			}
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		return 1;
	}

	if(PlayerInfo[playerid][pAdmin] >= 2 || IsAHitman(playerid) || (PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID && PlayerInfo[playerid][pFMember] == familyid))
	{
		if(familyid < 1 || familyid >= MAX_FAMILY)
		{
			format(string, sizeof(string), "Family slot must be between 1 and %i.", MAX_FAMILY-1);
			SendClientMessageEx(playerid, COLOR_GREY, string);
		 	return 1;
 	 	}
		if(FamilyInfo[familyid][FamilyTaken] != 1)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That family slot is empty.");
			return 1;
		}

		foreach(new i: Player)
		{
			new division[GROUP_MAX_DIV_LEN];
			if(PlayerInfo[i][pFMember] == familyid && (PlayerInfo[i][pTogReports] == 1 || PlayerInfo[i][pAdmin] < 2))
			{
				if(0 <= PlayerInfo[i][pDivision] < 5)
				{
					format(division, sizeof(division), "%s", FamilyDivisionInfo[PlayerInfo[i][pFMember]][PlayerInfo[i][pDivision]]);
				} else {
					division = "None";
				}
				if(PlayerInfo[i][pRank] == 0)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (0) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][0], division);
				}
				else if(PlayerInfo[i][pRank] == 1)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (1) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][1], division);
				}
				else if(PlayerInfo[i][pRank] == 2)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (2) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][2], division);
				}
				else if(PlayerInfo[i][pRank] == 3)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (3) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][3], division);
				}
				else if(PlayerInfo[i][pRank] == 4)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (4) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][4], division);
				}
				else if(PlayerInfo[i][pRank] == 5)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (5) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][5], division);
				}
				else if(PlayerInfo[i][pRank] == 6)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (6) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][6], division);
				}
				else
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][0], division);
				}
				if(PlayerInfo[playerid][pFMember] == familyid && PlayerInfo[playerid][pRank] >= 5 && playerAFK[i] != 0 && playerAFK[i] > 60)
				{
					format(string, sizeof(string), "%s (AFK: %d minutes)", string, playerAFK[i] / 60);
				}
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
		}
	}	
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "This command has been restricted to family members and administrators.");
	}
	return 1;
}

CMD:fbalance(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are not at the bank!");
		return 1;
	}

	new family, string[128];
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
		family = PlayerInfo[playerid][pFMember];
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a family.");
		return 1;
	}

	format(string, sizeof(string), "Your family has $%d in their account.", FamilyInfo[family][FamilyBank]);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:fdeposit(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are not at the bank!");
		return 1;
	}

	new family;
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
		family = PlayerInfo[playerid][pFMember];
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a family.");
		return 1;
	}

	new string[128], file[32], month, day, year, amount;
	if(sscanf(params, "d", amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fdeposit [amount]");
		format(string, sizeof(string), "Your family has $%s in their account.", number_format(FamilyInfo[family][FamilyBank]));
		SendClientMessageEx(playerid, COLOR_GRAD3, string);
		return 1;
	}

	if (amount > GetPlayerCash(playerid) || amount < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have that much.");
		return 1;
	}
	GivePlayerCash(playerid,-amount);
	new curfunds = FamilyInfo[family][FamilyBank];
	FamilyInfo[family][FamilyBank] = amount + FamilyInfo[family][FamilyBank];
	SendClientMessageEx(playerid, COLOR_WHITE, "|___ FAMILY BANK STATEMENT ___|");
	format(string, sizeof(string), "  Old Balance: $%s", number_format(curfunds));
	SendClientMessageEx(playerid, COLOR_GRAD2, string);
	format(string, sizeof(string), "  Deposit: $%s", number_format(amount));
	SendClientMessageEx(playerid, COLOR_GRAD4, string);
	SendClientMessageEx(playerid, COLOR_GRAD6, "|-----------------------------------------|");
	format(string, sizeof(string), "  New Balance: $%s", number_format(FamilyInfo[family][FamilyBank]));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string,sizeof(string),"%s has deposited $%s into %s's bank account.", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyName]);
	getdate(year, month, day);
	format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
	Log(file, string);
	return 1;
}

CMD:fwithdraw(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are not at the bank!");
		return 1;
	}
	new family;
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
		family = PlayerInfo[playerid][pFMember];
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a family.");
		return 1;
	}
	if(PlayerInfo[playerid][pRank] < 5)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Only ranks five and six may use the family bank.");
		return 1;
	}

	new string[128], file[32], month, day, year, amount;
	if(sscanf(params, "d", amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fwithdraw [amount]");
		format(string, sizeof(string), "Your family has $%s in their account.", number_format(FamilyInfo[family][FamilyBank]));
		SendClientMessageEx(playerid, COLOR_GRAD3, string);
		return 1;
	}

	if (amount > FamilyInfo[family][FamilyBank] || amount < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Your family doesn't have that much.");
		return 1;
	}

	GivePlayerCash(playerid, amount);
	FamilyInfo[family][FamilyBank] = FamilyInfo[family][FamilyBank] - amount;
	format(string, sizeof(string), "  You have withdrawn $%s from your family account. Total: $%s", number_format(amount), number_format(FamilyInfo[family][FamilyBank]));
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string,sizeof(string),"%s has withdrawn $%s from %s's bank account.", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyName]);
	getdate(year, month, day);
	format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
	Log(file, string);
	return 1;
}

CMD:fstoregun(playerid, params[])
{
	if(GetPVarInt(playerid, "IsInArena") >= 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
	if(GetPVarInt( playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
	if(PlayerInfo[playerid][pDonateRank] > 2 || PlayerInfo[playerid][pFamed] > 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can not give away weapons if you're Gold+ VIP/Famed+!");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx (playerid, COLOR_GRAD2, "You can not store weapons from a vehicle!");
	new Float:health;
	GetHealth(playerid, health);
	if (health < 80) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can not store weapons if your health is below 80!");
	if(GetPVarInt(playerid, "Injured") != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pHospital] != 0 || GetPlayerState(playerid) == 7) 
		return SendClientMessageEx (playerid, COLOR_GRAD2, "You cannot do this at this time.");
	if(PlayerInfo[playerid][pMember] != INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can not store weapons in a family safe when in a faction!");

	new family;
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID) family = PlayerInfo[playerid][pFMember];
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a family.");

	new string[128], weaponchoice[32], slot;
	if(sscanf(params, "s[32]d", weaponchoice, slot)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fstoregun [weapon] [slot]");
	if (GetPVarInt(playerid, "GiveWeaponTimer") > 0)
	{
		format(string, sizeof(string), "You must wait %d seconds before depositing another weapon.", GetPVarInt(playerid, "GiveWeaponTimer"));
		return SendClientMessageEx(playerid,COLOR_GREY,string);
	}
	if(slot < 1 || slot > 10) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid slot.");
	if( FamilyInfo[family][FamilyGuns][slot-1] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Your family has a weapon stored in that slot already.");
	if(IsPlayerInRangeOfPoint(playerid, 3.0, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2]) && GetPlayerVirtualWorld(playerid) == FamilyInfo[family][FamilySafeVW] && GetPlayerInterior(playerid) == FamilyInfo[family][FamilySafeInt])
	{
		new weapon;
		if(strcmp(weaponchoice, "sdpistol", true, strlen(weaponchoice)) == 0)
		{
			if( PlayerInfo[playerid][pGuns][2] == 23 && PlayerInfo[playerid][pAGuns][2] == 0 )
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a silenced pistol into your gun locker.");
				weapon = PlayerInfo[playerid][pGuns][2];
				format(string,sizeof(string), "* %s deposited their silenced pistol in a safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		else if(strcmp(weaponchoice, "deagle", true, strlen(weaponchoice)) == 0)
		{
			if( PlayerInfo[playerid][pGuns][2] == 24 && PlayerInfo[playerid][pAGuns][2] == 0 )
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a Desert Eagle in your gun locker.");
				weapon = PlayerInfo[playerid][pGuns][2];
				format(string,sizeof(string), "* %s deposited their Desert Eagle in a safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		else if(strcmp(weaponchoice, "shotgun", true, strlen(weaponchoice)) == 0)
		{
			if( PlayerInfo[playerid][pGuns][3] == 25 && PlayerInfo[playerid][pAGuns][3] == 0 )
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a shotgun in your gun locker.");
				weapon = PlayerInfo[playerid][pGuns][3];
				format(string,sizeof(string), "* %s deposited their Shotgun in a safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		else if(strcmp(weaponchoice, "spas12", true, strlen(weaponchoice)) == 0)
		{
			if( PlayerInfo[playerid][pGuns][3] == 27 && PlayerInfo[playerid][pAGuns][3] == 0 )
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a combat shotgun in your gun locker.");
				weapon = PlayerInfo[playerid][pGuns][3];
				format(string,sizeof(string), "* %s deposited their Combat Shotgun in a safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		else if(strcmp(weaponchoice, "mp5", true, strlen(weaponchoice)) == 0)
		{
			if( PlayerInfo[playerid][pGuns][4] == 29 && PlayerInfo[playerid][pAGuns][4] == 0 )
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited an MP5 in your gun locker.");
				weapon = PlayerInfo[playerid][pGuns][4];
				format(string,sizeof(string), "* %s deposited their MP5 in a safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		else if(strcmp(weaponchoice, "ak47", true, strlen(weaponchoice)) == 0)
		{
			if( PlayerInfo[playerid][pGuns][5] == 30 && PlayerInfo[playerid][pAGuns][5] == 0 )
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited an AK-47 in your gun locker.");
				weapon = PlayerInfo[playerid][pGuns][5];
				format(string,sizeof(string), "* %s deposited their AK-47 in a safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		else if(strcmp(weaponchoice, "m4", true, strlen(weaponchoice)) == 0)
		{
			if( PlayerInfo[playerid][pGuns][5] == 31 && PlayerInfo[playerid][pAGuns][5] == 0 )
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited an M4 in your gun locker.");
				weapon = PlayerInfo[playerid][pGuns][5];
				format(string,sizeof(string), "* %s deposited their M4 in a safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		else if(strcmp(weaponchoice, "rifle", true, strlen(weaponchoice)) == 0)
		{
			if( PlayerInfo[playerid][pGuns][6] == 33 && PlayerInfo[playerid][pAGuns][6] == 0 )
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a rifle in your gun locker.");
				weapon = PlayerInfo[playerid][pGuns][6];
				format(string,sizeof(string), "* %s deposited their rifle in a safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		else if(strcmp(weaponchoice, "sniper", true, strlen(weaponchoice)) == 0)
		{
			if( PlayerInfo[playerid][pGuns][6] == 34 && PlayerInfo[playerid][pAGuns][6] == 0 )
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a sniper rifle in your gun locker.");
				weapon = PlayerInfo[playerid][pGuns][6];
				format(string,sizeof(string), "* %s deposited their sniper rifle in a safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		else return SendClientMessageEx(playerid,COLOR_GREY,"   Invalid weapon name!"); 
		if(weapon == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have that weapon.");
		if(FamilyInfo[family][FamilyGuns][slot-1] == 0)
		{
			FamilyInfo[family][FamilyGuns][slot-1] = weapon;
			RemovePlayerWeapon(playerid, weapon);
			SaveFamily(family);
			return 1;
		}
	}
	else
	{
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not at your family safe.");
	}
	return 1;
}

CMD:fgetgun(playerid, params[])
{
	new string[128], slot;
	if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this as you are currently restricted from possessing weapons!");

	new family;
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID) family = PlayerInfo[playerid][pFMember];
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a family.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can not get weapons from a vehicle!");

	if(sscanf(params, "d", slot))
	{
		new weaponname[50];
		SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
		format(string, sizeof(string), "*** %s Safe ***", FamilyInfo[family][FamilyName]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		for(new s = 0; s < 10; s++)
		{
			if( FamilyInfo[family][FamilyGuns][s] != 0 )
			{
				GetWeaponName(FamilyInfo[family][FamilyGuns][s], weaponname, sizeof(weaponname));
				format(string, sizeof(string), "Slot %d: %s", s+1, weaponname);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
		}
		SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fgetgun [slot]");
		return 1;
	}

	if (GetPVarInt(playerid, "GiveWeaponTimer") > 0)
	{
		format(string, sizeof(string), "   You must wait %d seconds before getting another weapon.", GetPVarInt(playerid, "GiveWeaponTimer"));
		return SendClientMessageEx(playerid,COLOR_GREY,string);
	}

	if(slot < 1 || slot > 10) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid slot.");
	if(PlayerInfo[playerid][pRank] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "Only rank 4+ can withdraw guns from the family safe.");
	if(IsPlayerInRangeOfPoint(playerid, 3.0, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2]) && GetPlayerVirtualWorld(playerid) == FamilyInfo[family][FamilySafeVW] && GetPlayerInterior(playerid) == FamilyInfo[family][FamilySafeInt])
	{
		if(FamilyInfo[family][FamilyGuns][slot-1] != 0)
		{
			new weaponname[50];
			GetWeaponName(FamilyInfo[family][FamilyGuns][slot-1], weaponname, sizeof(weaponname));
			GivePlayerValidWeapon(playerid, FamilyInfo[family][FamilyGuns][slot-1], 60000);
			FamilyInfo[family][FamilyGuns][slot-1] = 0;
			if(strcmp(weaponname, "silenced pistol", true, strlen(weaponname)) == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a silenced pistol from your family's gun locker.");
				format(string,sizeof(string), "* %s has withdrawn a silenced pistol from a family safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
			if(strcmp(weaponname, "desert eagle", true, strlen(weaponname)) == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a Desert Eagle from your family's gun locker.");
				format(string,sizeof(string), "* %s has withdrawn a Desert Eagle from a family safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
			if(strcmp(weaponname, "shotgun", true, strlen(weaponname)) == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a shotgun from your family's gun locker.");
				format(string,sizeof(string), "* %s has withdrawn a shotgun from a family safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
			if(strcmp(weaponname, "combat shotgun", true, strlen(weaponname)) == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a combat shotgun from your family's gun locker.");
				format(string,sizeof(string), "* %s has withdrawn a combat shotgun from a family safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
			if(strcmp(weaponname, "mp5", true, strlen(weaponname)) == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn an MP5 from your family's gun locker.");
				format(string,sizeof(string), "* %s has withdrawn an MP5 from a family safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
			if(strcmp(weaponname, "ak47", true, strlen(weaponname)) == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn an AK-47 from your family's gun locker.");
				format(string,sizeof(string), "* %s has withdrawn an AK-47 from a family safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
			if(strcmp(weaponname, "m4", true, strlen(weaponname)) == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn an M4 from your family's gun locker.");
				format(string,sizeof(string), "* %s has withdrawn an M4 from a family safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
			if(strcmp(weaponname, "rifle", true, strlen(weaponname)) == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a rifle from your family's gun locker.");
				format(string,sizeof(string), "* %s has withdrawn a rifle from a family safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
			if(strcmp(weaponname, "sniper rifle", true, strlen(weaponname)) == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a sniper rifle from your family's gun locker.");
				SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
				format(string,sizeof(string), "* %s has withdrawn a sniper rifle from a safe.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
			SaveFamily(family);
			return 1;
		}
		else
		{
			return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a weapon stored in that slot.");
		}
	}
	else
	{
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not at your family safe.");
	}
}

CMD:safedeposit(playerid, params[]) // TransferStorage(playerid, storageid, fromplayerid, fromstorageid, itemid, amount, price, special)
{
	new family;

	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID) family = PlayerInfo[playerid][pFMember];
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a family.");

	if(FamilyInfo[family][FamilyUSafe] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your family has not upgraded their safe.");

	new string[128], itemid, storageid, amount;

	if(sscanf(params, "dd", itemid, amount) || itemid < 1 || itemid > 5)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /safedeposit [itemid] [amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Heroin");
		return 1;
	}
	if(amount < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't deposit less than 1.");
	if(IsPlayerInRangeOfPoint(playerid, 3.0, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2]) && GetPlayerVirtualWorld(playerid) == FamilyInfo[family][FamilySafeVW] && GetPlayerInterior(playerid) == FamilyInfo[family][FamilySafeInt])
	{
		new file[32], month, day, year;
		getdate(year,month,day);
		switch(itemid)
		{
			case 1: // Cash
			{
				if(storageid == 0) {
					if(PlayerInfo[playerid][pCash] >= amount) PlayerInfo[playerid][pCash] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}
				else {
					if(StorageInfo[playerid][storageid-1][sCash] >= amount) StorageInfo[playerid][storageid-1][sCash] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}

				FamilyInfo[family][FamilyCash] += amount;
				format(string, sizeof(string), "You have deposited $%s to your family's safe.", number_format(amount));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				OnPlayerStatsUpdate(playerid);
				format(string, sizeof(string), "%s has deposited $%s into %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
			case 2: // Pot
			{
				if(storageid == 0) {
					if(PlayerInfo[playerid][pPot] >= amount) PlayerInfo[playerid][pPot] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}
				else {
					if(StorageInfo[playerid][storageid-1][sPot] >= amount) StorageInfo[playerid][storageid-1][sPot] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}

				FamilyInfo[family][FamilyPot] += amount;
				format(string, sizeof(string), "You have deposited %s grams of pot to your family's safe.", number_format(amount));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				OnPlayerStatsUpdate(playerid);
				format(string, sizeof(string), "%s has deposited %s pot into %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
			case 3: // Crack
			{
				if(storageid == 0) {
					if(PlayerInfo[playerid][pCrack] >= amount) PlayerInfo[playerid][pCrack] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}
				else {
					if(StorageInfo[playerid][storageid-1][sCrack] >= amount) StorageInfo[playerid][storageid-1][sCrack] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}

				FamilyInfo[family][FamilyCrack] += amount;
				format(string, sizeof(string), "You have deposited %s grams of crack to your family's safe.", number_format(amount));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				OnPlayerStatsUpdate(playerid);
				format(string, sizeof(string), "%s has deposited %s crack into %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
			case 4: // Materials
			{
				if(storageid == 0) {
					if(PlayerInfo[playerid][pMats] >= amount) PlayerInfo[playerid][pMats] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}
				else {
					if(StorageInfo[playerid][storageid-1][sMats] >= amount) StorageInfo[playerid][storageid-1][sMats] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}

				FamilyInfo[family][FamilyMats] += amount;
				format(string, sizeof(string), "You have deposited %s materials to your family's safe.", number_format(amount));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				OnPlayerStatsUpdate(playerid);
				format(string, sizeof(string), "%s has deposited %s materials into %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
			case 5: // Heroin
			{
				if(PlayerInfo[playerid][pHeroin] >= amount) PlayerInfo[playerid][pHeroin] -= amount;
				else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");

				FamilyInfo[family][FamilyHeroin] += amount;
				format(string, sizeof(string), "You have deposited %s heroin to your family's safe.", number_format(amount));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				OnPlayerStatsUpdate(playerid);
				format(string, sizeof(string), "%s has deposited %s heroin into %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
		}
	}
	else
	{
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not at your family safe.");
	}
	return 1;
}

CMD:safewithdraw(playerid, params[]) // TransferStorage(playerid, storageid, fromplayerid, fromstorageid, itemid, amount, price, special)
{
	new family;

	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID) family = PlayerInfo[playerid][pFMember];
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a family.");

	if(FamilyInfo[family][FamilyUSafe] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your family has not upgraded their safe.");
	if(PlayerInfo[playerid][pRank] < 5) return SendClientMessageEx(playerid, COLOR_GRAD1, "Only ranks 5 and 6 can withdraw items from the family safe.");

	new itemid, amount, string[128];
	if(sscanf(params, "dd", itemid, amount) || (itemid < 1 || itemid > 5))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /safewithdraw [itemid] [amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Heroin");
		return 1;
	}

	if(amount < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't withdraw less than 1.");
	if(IsPlayerInRangeOfPoint(playerid, 3.0, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2]) && GetPlayerVirtualWorld(playerid) == FamilyInfo[family][FamilySafeVW] && GetPlayerInterior(playerid) == FamilyInfo[family][FamilySafeInt])
	{
		switch(itemid)
		{
			case 1: // Cash
			{
				if(FamilyInfo[family][FamilyCash] >= amount)
				{
					SetPVarInt(playerid, "Special_FamilyID", family);
					TransferStorage(playerid, -1, -1, -1, itemid, amount, -1, 5);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Your family safe does not have enough for you to withdraw!");
			}
			case 2: // Pot
			{
				if(FamilyInfo[family][FamilyPot] >= amount)
				{
					SetPVarInt(playerid, "Special_FamilyID", family);
					TransferStorage(playerid, -1, -1, -1, itemid, amount, -1, 5);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Your family safe does not have enough for you to withdraw!");
			}
			case 3: // Crack
			{
				if(FamilyInfo[family][FamilyCrack] >= amount)
				{
					SetPVarInt(playerid, "Special_FamilyID", family);
					TransferStorage(playerid, -1, -1, -1, itemid, amount, -1, 5);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Your family safe does not have enough for you to withdraw!");
			}
			case 4: // Materials
			{
				if(FamilyInfo[family][FamilyMats] >= amount)
				{
					SetPVarInt(playerid, "Special_FamilyID", family);
					TransferStorage(playerid, -1, -1, -1, itemid, amount, -1, 5);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Your family safe does not have enough for you to withdraw!");
			}
			case 5: // Heroin
			{
				if(FamilyInfo[family][FamilyHeroin] >= amount)
				{
					new file[32], month, day, year;
					getdate(year,month,day);
					FamilyInfo[family][FamilyHeroin] -= amount;
					PlayerInfo[playerid][pHeroin] += amount;
					OnPlayerStatsUpdate(playerid);
					format(string, sizeof(string), "You have withdrawn %s heroin from your family safe.", number_format(amount));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					format(string, sizeof(string), "%s has withdrawn %s heroin from %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
					format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
					Log(file, string);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Your family safe does not have enough for you to withdraw!");
			}
		}
	}
	else
	{
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not at your family safe.");
	}
	return 1;
}

CMD:adjust(playerid, params[])
{
	if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You aren't in a family.");
		return 1;
	}
	new family = PlayerInfo[playerid][pFMember];
	new string[128], file[32], month, day, year;
	getdate(year,month,day);
	if(PlayerInfo[playerid][pRank] >= 5)
	{
		new choice[32], opstring[100];
		if(sscanf(params, "s[32]S[100]", choice, opstring))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adjust [name]");
			SendClientMessageEx(playerid, COLOR_WHITE, "Available Names: Name, Safe");
			return 1;
		}

		if(strcmp(choice,"name",true) == 0)
		{
			if(PlayerInfo[playerid][pRank] == 6)
			{
				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adjust name [family name]");
					return 1;
				}
				if(strfind(opstring, "|", true) != -1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2,  "You can't use '|' in a family name.");
					return 1;
				}
				if(strlen(opstring) >= 40 )
				{
					SendClientMessageEx( playerid, COLOR_GRAD1, "That family name is too long, please refrain from using more than 40 characters." );
					return 1;
				}
				strmid(FamilyInfo[family][FamilyName], opstring, 0, strlen(opstring), 100);
				SaveFamilies();
				SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted your family's name.");
				format(string, sizeof(string), "%s adjusted %s's name to %s", GetPlayerNameEx(playerid), FamilyInfo[family][FamilyName], opstring);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
		}
		else if(strcmp(choice,"safe",true) == 0)
		{
			if(PlayerInfo[playerid][pRank] == 6)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "Adjusting your Family Safe will reset all your safe stats.");
				SendClientMessageEx(playerid, COLOR_GRAD1, "If you want to adjust your safe, type /adjust confirm.");
				SendClientMessageEx(playerid, COLOR_GRAD1, "Upgrading your family safe will cost $50,000.");
				return 1;
			}
		}
		else if(strcmp(choice,"confirm",true) == 0)
		{
			if(PlayerInfo[playerid][pRank] == 6)
			{
				if(GetPlayerCash(playerid) < 50000)
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have $50,000 to upgrade your family safe.");
					return 1;
				}
				GivePlayerCash(playerid, -50000);
				GetPlayerPos(playerid, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2]);
				FamilyInfo[family][FamilySafeVW] = GetPlayerVirtualWorld(playerid);
				FamilyInfo[family][FamilySafeInt] = GetPlayerInterior(playerid);
				FamilyInfo[family][FamilyCash] = 0;
				FamilyInfo[family][FamilyMats] = 0;
				FamilyInfo[family][FamilyPot] = 0;
				FamilyInfo[family][FamilyCrack] = 0;
				if(FamilyInfo[family][FamilyUSafe]) DestroyDynamicPickup(FamilyInfo[family][FamilyPickup]);
				FamilyInfo[family][FamilyUSafe] = 1;
				FamilyInfo[family][FamilyPickup] = CreateDynamicPickup(1239, 23, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2], .worldid = FamilyInfo[family][FamilySafeVW], .interiorid = FamilyInfo[family][FamilySafeInt]);
				SaveFamilies();
				SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted your family's Safe.");
				format(string, sizeof(string), "%s adjusted %s's safe", GetPlayerNameEx(playerid), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You do not have a high enough rank to use this command!");
		return 1;
	}
	return 1;
}

CMD:adjustrankname(playerid, params[])
{
	if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You aren't in a family.");
		return 1;
	}
	new family = PlayerInfo[playerid][pFMember];
	new string[128], rank, rankname[30];
	if(sscanf(params, "ds[30]", rank, rankname)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adjustrankname [rank number 0-6] [rank name]");

	if(PlayerInfo[playerid][pRank] == 6)
	{
		if(rank < 0 || rank > 6)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Rank number must be from 0 to 6.");
			return 1;
		}
		if(strfind(rankname, "|", true) != -1)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2,  "You can't use '|' in a rank name.");
			return 1;
		}
		if(strlen(rankname) >= 19 )
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "That rank name is too long, please refrain from using more than 19 characters.");
			return 1;
		}

		new file[32], month, day, year ;
		getdate(year,month,day);
		format(FamilyRankInfo[family][rank], 30, "%s", rankname);
		SaveFamily(family);
		format(string, sizeof(string), "* You have changed rank %d to %s.", rank, rankname);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "%s adjusted %s's rank %d to %s", GetPlayerNameEx(playerid), FamilyInfo[family][FamilyName], rank, rankname);
		format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
		Log(file, string);
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "   You are not high rank enough to use this command!");
	return 1;
}

CMD:fcreate(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
		new string[128], family, giveplayerid;
		if(sscanf(params, "du", family, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fcreate [FamilyNr] [player]");
		if(family < 1 || family > MAX_FAMILY-1) {
			format(string, sizeof(string), "   FamilyNr can't be below 1 or above %i!", MAX_FAMILY-1);
		 	SendClientMessageEx(playerid, COLOR_GREY, string);
	 	    return 1;
	   }

		if(IsPlayerConnected(giveplayerid))
		{
			if(FamilyInfo[family][FamilyTaken] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   That Family Slot is already taken!" );
				return 1;
			}

			format(string, sizeof(string), "* You've made %s the Leader of Family Slot %d.",GetPlayerNameEx(giveplayerid),family);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* Admin %s has made you a Family Leader.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);

			new sendername[MAX_PLAYER_NAME];
			GetPlayerName(giveplayerid, sendername, sizeof(sendername));
			format(string, sizeof(string), "%s",sendername);
			strmid(FamilyInfo[family][FamilyLeader], string, 0, strlen(string), 24);
			FamilyInfo[family][FamilyMembers] ++;
			FamilyInfo[family][FamilyTaken] = 1;
			PlayerInfo[giveplayerid][pFMember] = family;
			PlayerInfo[giveplayerid][pRank] = 6;
			PlayerInfo[giveplayerid][pDivision] = 0;
			SaveFamily(family);

		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
			return 1;
		}
	}
	return 1;
}

CMD:fdelete(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
		new family, string[128];
		if(sscanf(params, "d", family)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fdelete [familyid]");

		if(family < 1 || family > MAX_FAMILY-1) {
	 		format(string,sizeof(string), "   Family Slot can't be below 1 or above %i!", MAX_FAMILY-1);
			SendClientMessageEx(playerid, COLOR_GREY, string);
		 	return 1;
	 	}
		if(FamilyInfo[family][FamilyTaken] != 1)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   That Family Slot isn't taken!");
			return 1;
		}
		ClearFamily(family);
		SaveFamily(family);
	}
	return 1;
}

CMD:clothes(playerid, params[])
{
	new biz = InBusiness(playerid);
	if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a Family/Gang!");
	if (biz != INVALID_BUSINESS_ID && Businesses[biz][bType] == BUSINESS_TYPE_CLOTHING)
	{
		new fSkin[8];
		fSkin[0] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][0];
		fSkin[1] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][1];
		fSkin[2] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][2];
		fSkin[3] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][3];
		fSkin[4] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][4];
		fSkin[5] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][5];
		fSkin[6] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][6];
		fSkin[7] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][7];
		ShowModelSelectionMenuEx(playerid, fSkin, 8, "Change your family clothes.", DYNAMIC_FAMILY_CLOTHES, 0.0, 0.0, -55.0);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a clothing shop.");
	return true;
}	

/*CMD:f(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(gFam[playerid] == 1)
	{
		SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "You have your family chat disabled. /togfamily!");
		return 1;
	}

	new string[128];
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: (/f)amily [family chat]");

	//if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS))
	if(IsAHitman(playerid))
	{
		format(string, sizeof(string), "** (%d) %s %s: %s **", PlayerInfo[playerid][pRank], arrGroupRanks[PlayerInfo[playerid][pMember]][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), params);
		SendFamilyMessage(PlayerInfo[playerid][pMember], TEAM_AZTECAS_COLOR, string);
	}
	else if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
	    new fam = PlayerInfo[playerid][pFMember];
	    if(0 <= PlayerInfo[playerid][pDivision] < 5)
	    {
	        new division[GROUP_MAX_DIV_LEN];
	        format(division, sizeof(division), "%s", FamilyDivisionInfo[PlayerInfo[playerid][pFMember]][PlayerInfo[playerid][pDivision]]);
		    format(string, sizeof(string), "** (%i) %s (%s) %s: %s **", PlayerInfo[playerid][pRank], FamilyRankInfo[fam][PlayerInfo[playerid][pRank]], division, GetPlayerNameEx(playerid), params);
			SendNewFamilyMessage(fam, FamilyInfo[PlayerInfo[playerid][pFMember]][FamColor] * 256 + 255, string);
		}
		else
		{
		    format(string, sizeof(string), "** (%i) %s %s: %s **", PlayerInfo[playerid][pRank], FamilyRankInfo[fam][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), params);
			SendNewFamilyMessage(fam, FamilyInfo[PlayerInfo[playerid][pFMember]][FamColor] * 256 + 255, string);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You're not a part of a group!");
	}
	return 1;
}*/

CMD:feditcolor(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
		new fam, color, string[128];
		if(sscanf(params, "dh", fam, color)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /feditcolor [family] [color]"), SendClientMessageEx(playerid, COLOR_GREY, "Color Must be in Hex format! Ex: 01FCFF");
		if(fam < 1 || fam > MAX_FAMILY-1) return format(string,sizeof(string), "   FamilyNr can't be below 1 or above %i!", MAX_FAMILY-1), SendClientMessageEx(playerid, COLOR_GREY, string);
		FamilyInfo[fam][FamColor] = color;
		format(string, sizeof(string), "%s has set the family color to %x in %s (%d)", GetPlayerNameEx(playerid), FamilyInfo[fam][FamColor], FamilyInfo[fam][FamilyName], fam);
		SendClientMessageEx(playerid, FamilyInfo[fam][FamColor] * 256 + 255, string);
		Log("logs/family.log", string);
		SaveFamily(fam);
	}
	return 1;
}

/*CMD:gbuylock(playerid, params[])
{

    if(!IsAt247(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "   You are not in a 24-7 !");
		return 1;
	}
	if(PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID && PlayerInfo[playerid][pRank] >= 6)
	{
		ShowPlayerDialog(playerid, DIALOG_CDGLOCKBUY, DIALOG_STYLE_LIST, "24/7", "Alarm Lock		$10000\nElectric Lock		$500000\nIndustrial Lock		$50000", "Buy", "Cancel");
	}
	else
	{
 		SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be in a family and have rank 6 to use this command.");
	}
	return 1;

} */