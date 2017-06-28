/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Find the Flag Event

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

// Load the result live, this way i can display them on the CP live :)
#include <YSI\y_hooks>

new 
	FlagActive = 0,
	FlagHint[128];

enum FindFlag {
	ftObject,
	Text3D: ftTextID,
	ftModel,
	Float:ftPos[3],
	ftVw,
	ftInt,
	ftSpawnID,
	ftTagId,
	ftTags,
	ftTime,
	ftActive
}
new FlagEvent[1][FindFlag];

new Float:FlagSpawns[28][4] = {
	{-78.84, -1187.78, 1.75}, // Flint Gas
	{-47.71, -1613.97, 2.94}, // Old IRA Pier
	{335.72, -1522.80, 35.10}, // FBI HQ
	{154.20, -1949.38, 47.87}, // LS Lighthouse (DP Lounge)*
	{378.54, -1886.01, 2.03}, // Under Santa Marina Beach Pier
	{818.23, -1361.82, -0.50}, // Market Station (Behind SANews)
	{1061.80, -1496.98, 22.76}, // Mall (East Side)
	{1481.10, -1756.67, 17.53}, // City Hall Steps
	{1551.65, -1338.43, 330.00}, // Star Tower
	{2488.61, -1667.29, 13.34}, // Grove Circle
	{2499.87, -2074.12, 26.57}, // Garbage Job
	{2605.70, -1469.83, 16.77}, // East LS Sewer
	{2400.25, -1222.74, 25.73}, // Pig Pen
	{2267.30, -1030.08, 59.29}, // Las Colinas
	{1687.44, -994.56, 24.07}, // Mullholland Parking Lot
	{1641.70, 259.11, 19.61}, // Under the 25
	{2103.01, -103.94, 2.27}, // Palomino Pier
	{1232.85, 293.21, 28.75}, // Montgomery Hospital Roof
	{921.18, -29.10, 94.42}, // Hill Behind Hilltop
	{-47.55, 31.13, 6.48}, // Blueberry Field Barn
	{-2684.36, 2171.54, 41.79}, // Under Gant Bridge
	{-2375.93, 2215.95, 4.98}, // Behind Bayside Lighthouse
	{-2091.77, 2313.78, 25.91}, // Tierra Robada
	{-940.80, 2641.67, 42.33}, // Los Venturas Pier
	{-734.01, 1546.48, 39.00}, // Los Barrancas Ruins
	{-2232.64, -1737.78, 480.83}, // Mount Chilliad
	{-1816.90, 1313.89, 59.73}, // San Fierro Parkade
	{-2994.25, 472.65, 4.91} // San Fierro Pier
};

hook OnGameModeInit() {
	for(new i = 0; i < 1; i++) {
		FlagEvent[i][ftObject] = -1;
		FlagEvent[i][ftTextID] = Text3D: -1;
		format(FlagHint, sizeof(FlagHint), "There is currently no hint setup!");
	}
	return 1;
}

stock LoadFindTheFlag() {
	printf("[FTFE] Loading Find the Flag Event data...");
	mysql_function_query(MainPipeline, "SELECT * FROM `findflag`", true, "OnLoadFlag", "");
}

forward OnLoadFlag();
public OnLoadFlag() {
	new i, rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	while(i < 1)
	{
		FlagEvent[i][ftModel] = cache_get_field_content_int(i, "Model", MainPipeline);
		FlagEvent[i][ftPos][0] = cache_get_field_content_float(i, "PosX", MainPipeline);
		FlagEvent[i][ftPos][1] = cache_get_field_content_float(i, "PosY", MainPipeline);
		FlagEvent[i][ftPos][2] = cache_get_field_content_float(i, "PosZ", MainPipeline);
		FlagEvent[i][ftVw] = cache_get_field_content_int(i, "Vw", MainPipeline);
		FlagEvent[i][ftInt] = cache_get_field_content_int(i, "Int", MainPipeline);
		FlagEvent[i][ftSpawnID] = cache_get_field_content_int(i, "Spawn", MainPipeline);
		FlagEvent[i][ftTagId] = cache_get_field_content_int(i, "TagID", MainPipeline);
		FlagEvent[i][ftTags] = cache_get_field_content_int(i, "Tags", MainPipeline);
		FlagEvent[i][ftTime] = cache_get_field_content_int(i, "Time", MainPipeline);
		FlagEvent[i][ftActive] = cache_get_field_content_int(i, "Active", MainPipeline);
		SetUpFlag(i);
		i++;
	}
	if(i > 0) printf("[FTFE] Flag event has been loaded.", i), FlagActive = 1;
	else printf("[FTFE] There is no flag to load!");
	return 1;
}

stock SaveFlag(i) {
	new query[2048];

	format(query, 2048, "UPDATE `findflag` SET ");
	SaveInteger(query, "findflag", i+1, "Model", FlagEvent[i][ftModel]);
	SaveFloat(query, "findflag", i+1, "PosX", FlagEvent[i][ftPos][0]);
	SaveFloat(query, "findflag", i+1, "PosY", FlagEvent[i][ftPos][1]);
	SaveFloat(query, "findflag", i+1, "PosZ", FlagEvent[i][ftPos][2]);
	SaveInteger(query, "findflag", i+1, "Vw", FlagEvent[i][ftVw]);
	SaveInteger(query, "findflag", i+1, "Int", FlagEvent[i][ftInt]);
	SaveInteger(query, "findflag", i+1, "Spawn", FlagEvent[i][ftSpawnID]);
	SaveInteger(query, "findflag", i+1, "TagID", FlagEvent[i][ftTagId]);
	SaveInteger(query, "findflag", i+1, "Tags", FlagEvent[i][ftTags]);
	SaveInteger(query, "findflag", i+1, "Time", FlagEvent[i][ftTime]);
	SaveInteger(query, "findflag", i+1, "Active", FlagEvent[i][ftActive]);
	SQLUpdateFinish(query, "findflag", i+1);
	return 1;
}

/*
	Flag Objects:

	blue - 19307
	red - 19306
*/

forward SetUpFlag(id);
public SetUpFlag(id) {
	new string[256], spawned = 0;
	if(IsValidDynamicObject(FlagEvent[id][ftObject])) DestroyDynamicObject(FlagEvent[id][ftObject]), FlagEvent[id][ftObject] = -1;
	if(IsValidDynamic3DTextLabel(FlagEvent[id][ftTextID])) DestroyDynamic3DTextLabel(FlagEvent[id][ftTextID]), FlagEvent[id][ftTextID] = Text3D: -1;

	if(!FlagEvent[id][ftActive]) return 1;

	// Check if the flag is at any of the spawns.
	for(new s; s < sizeof(FlagSpawns); s++)
	{
		if(FlagEvent[id][ftPos][0] == FlagSpawns[s][0] && FlagEvent[id][ftPos][1] == FlagSpawns[s][1] && FlagEvent[id][ftPos][2] == FlagSpawns[s][2]) {
			spawned = 1;
		}
	}
	// Not spawned at the given coords destroy it.
	if(!spawned) {
		DestroyFlag(id);
		return 1;
	}

	format(string, sizeof(string), "{FFFF00}Type {1FBDFF}/flagclaim{FFFF00} to tag this flag!\nTime Remaining: {1FBDFF}%s", TimeConvert(FlagEvent[id][ftTime]));

	FlagEvent[id][ftTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, FlagEvent[id][ftPos][0], FlagEvent[id][ftPos][1], FlagEvent[id][ftPos][2]+0.3, 20.0, .testlos = 1, .worldid = FlagEvent[id][ftVw], .interiorid = FlagEvent[id][ftInt], .streamdistance = 10.0);
	FlagEvent[id][ftObject] = CreateDynamicObject(FlagEvent[id][ftModel], FlagEvent[id][ftPos][0], FlagEvent[id][ftPos][1], FlagEvent[id][ftPos][2]-1, 0.00000000, 0.00000000, 0.00000000, FlagEvent[id][ftVw], FlagEvent[id][ftInt]);
	return 1;
}

forward DestroyFlag(id);
public DestroyFlag(id) {
	FlagEvent[id][ftPos][0] = 0.00000;
	FlagEvent[id][ftPos][1] = 0.00000;
	FlagEvent[id][ftPos][2] = 0.00000;
	FlagEvent[id][ftVw] = 0;
	FlagEvent[id][ftInt] = 0;
	FlagEvent[id][ftSpawnID] = -1;
	FlagEvent[id][ftTime] = 3600;
	FlagEvent[id][ftActive] = 0;
	SetUpFlag(id);
	return 1;
}

CMD:flagstatus(playerid, params[]) {
	new location[MAX_ZONE_NAME];
	if(PlayerInfo[playerid][pAdmin] >= 1337) {
		if(!FlagActive) return SendClientMessageEx(playerid, COLOR_RED, "Find the Flag hasn't been loaded from the database!");
		if(FlagEvent[0][ftActive]) {
			Get3DZone(FlagEvent[0][ftPos][0], FlagEvent[0][ftPos][1], FlagEvent[0][ftPos][2], location, sizeof(location));
			SendClientMessageEx(playerid, COLOR_YELLOW, "[Find the Flag]: Flag is currently active.", location);
			SendClientMessageEx(playerid, COLOR_YELLOW, "Location: %s | Tags Total: %s | Time Left: %s", location, number_format(FlagEvent[0][ftTags]), TimeConvert(FlagEvent[0][ftTime]));
		} else {
			SendClientMessageEx(playerid, COLOR_YELLOW, "[Find the Flag]: Flag is currently disabled (/flagevent) to start.");
		}
	} else {
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:flagevent(playerid, params[]) {
	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pPR] > 1) {
		if(!FlagActive) return SendClientMessageEx(playerid, COLOR_RED, "Find the Flag hasn't been loaded from the database!");
		if(FlagEvent[0][ftActive]) {
			DestroyFlag(0);
			SendClientMessageToAllEx(COLOR_LIGHTBLUE, "[Flag Event]: Event has been disabled by an administrator; Thanks for playing!");
			format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has disabled the 'Find the Flag' event.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
		} else {
			FlagEvent[0][ftActive] = 1;
			MoveFlag(0, 0);
			SendClientMessageToAllEx(COLOR_LIGHTBLUE, "[Flag Event]: Event has been started by an administrator; Find the flag!");
			format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has enabled the 'Find the Flag' event.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
		}
	} else {
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:gotoflag(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pPR] > 1) {
		if(!FlagActive) return SendClientMessageEx(playerid, COLOR_RED, "Find the Flag hasn't been loaded from the database!");
		if(!FlagEvent[0][ftActive]) return SendClientMessageEx(playerid, COLOR_RED, "The flag is currently not active.");

		SetPlayerPos(playerid, FlagEvent[0][ftPos][0], FlagEvent[0][ftPos][1], FlagEvent[0][ftPos][2]+1.0);
		SetPlayerInterior(playerid, FlagEvent[0][ftInt]);
		PlayerInfo[playerid][pInt] = FlagEvent[0][ftInt];
		SetPlayerVirtualWorld(playerid, FlagEvent[0][ftVw]);
		PlayerInfo[playerid][pVW] = FlagEvent[0][ftVw];	
		if(FlagEvent[0][ftInt] > 0) Player_StreamPrep(playerid, FlagEvent[0][ftPos][0], FlagEvent[0][ftPos][1], FlagEvent[0][ftPos][2]+1.0, FREEZE_TIME);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have teleported to the flag!");
	} else {
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:flagmove(playerid, params[]) {
	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pPR] > 1) {
		if(!FlagActive) return SendClientMessageEx(playerid, COLOR_RED, "Find the Flag hasn't been loaded from the database!");
		if(!FlagEvent[0][ftActive]) return SendClientMessageEx(playerid, COLOR_RED, "The flag is currently not active.");
		MoveFlag(0, 1);
		format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s force moved the flag for the 'Find the Flag' event.", GetPlayerNameEx(playerid));
		ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
		format(szMiscArray, sizeof(szMiscArray), "%s has forced the flag to move to a new location.", GetPlayerNameEx(playerid));
		Log("logs/flagevent.log", szMiscArray);
	} else {
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}
	return 1;
}

forward MoveFlag(id, type);
public MoveFlag(id, type) {
	new loc = Random(0, 27);
	if(FlagEvent[id][ftSpawnID] == loc) return MoveFlag(id, type);

	FlagEvent[id][ftPos][0] = FlagSpawns[loc][0];
	FlagEvent[id][ftPos][1] = FlagSpawns[loc][1];
	FlagEvent[id][ftPos][2] = FlagSpawns[loc][2];
	FlagEvent[id][ftTagId] += 1;
	FlagEvent[id][ftSpawnID] = loc;
	FlagEvent[id][ftTime] = 3600;
	SaveFlag(id);
	if(type) SendClientMessageToAllEx(COLOR_LIGHTBLUE, "[Flag Event]: Time has expired and the flag has moved to a new location!");
	SetUpFlag(id);
	return 1;
}

forward FlagUpdate(id);
public FlagUpdate(id) {
	new string[256];
	if(IsValidDynamic3DTextLabel(FlagEvent[id][ftTextID])) {
		format(string, sizeof(string), "{FFFF00}Type {1FBDFF}/flagclaim{FFFF00} to tag this flag!\nTime Remaining: {1FBDFF}%s", TimeConvert(FlagEvent[id][ftTime]));
		UpdateDynamic3DTextLabelText(FlagEvent[id][ftTextID], COLOR_ORANGE, string);
	}
	return 1;
}

task UpdateFlagData[1000]() {
	if(FlagActive) {
		if(FlagEvent[0][ftActive]) {
			if(FlagEvent[0][ftTime] > 0) FlagEvent[0][ftTime]--;
			if(!FlagEvent[0][ftTime]) {
				MoveFlag(0, 1);
			}
			FlagUpdate(0);
		}
	}
}

CMD:flagclaim(playerid, params[]) {
	new query[256];
	if(!FlagActive) return SendClientMessageEx(playerid, COLOR_RED, "Find the Flag event is currently not active.");
	if(!FlagEvent[0][ftActive]) return SendClientMessageEx(playerid, COLOR_RED, "Find the Flag event is currently not active.");
	if(PlayerInfo[playerid][pAdmin] > 1) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: Administrators can't claim the flag!");
	if(IsPlayerInRangeOfPoint(playerid, 2, FlagEvent[0][ftPos][0], FlagEvent[0][ftPos][1], FlagEvent[0][ftPos][2])) {
		format(query,sizeof(query),"SELECT `FlagID` FROM `findflagtrack` WHERE `Userid` = %d AND `FlagID` = %d", GetPlayerSQLId(playerid), FlagEvent[0][ftTagId]);
		mysql_function_query(MainPipeline, query, false, "OnClaimFlag", "i", playerid);
	} else {
		SendClientMessageEx(playerid, COLOR_GREY, "Your not near any flag to claim!");
	}
	return 1;
}

forward OnClaimFlag(playerid);
public OnClaimFlag(playerid) {

	new rows, fields, szResult[512];
	cache_get_data(rows, fields, MainPipeline);

	if(!rows) {
		mysql_format(MainPipeline, szResult, sizeof(szResult), "INSERT INTO `findflagtrack` (`Userid`, `FlagID`) VALUES (%d, %d)", GetPlayerSQLId(playerid), FlagEvent[0][ftTagId]);
		mysql_tquery(MainPipeline, szResult, "OnQueryFinish", "i", SENDDATA_THREAD);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[Flag Event]: You have successfully claimed this flag.");
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[Flag Event]: You can track how many flags/credits you've claimed via the '/flagstats' command.");
		format(szResult, sizeof(szResult), "* %s has tagged the flag!", GetPlayerNameEx(playerid));
		ProxDetector(20.0, playerid, szResult, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		PlayerInfo[playerid][pFlagClaimed] += 1;
		PlayerInfo[playerid][pFlagCredits] += 1;
		FlagEvent[0][ftTags]++;
		SaveFlag(0);
		OnPlayerStatsUpdate(playerid);
	} else {
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[Flag Event]: You've already claimed this flag; Please wait for the next spawn.");
	}
	return 1;
}

CMD:flagstats(playerid, params[]) {
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[Flag Event]: You have tagged %d flag%s. | Flag Credits: %d", PlayerInfo[playerid][pFlagClaimed], (PlayerInfo[playerid][pFlagClaimed] == 1) ? ("") : ("s"), PlayerInfo[playerid][pFlagCredits]);
	return 1;
}

CMD:flagwins(playerid, params[]) {
	new target;
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pPR] > 1) {
		if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /flagwins [player]");
		if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[Flag Event]: %s have tagged %d flag%s. | Flag Credits: %d", PlayerInfo[target][pFlagClaimed], (PlayerInfo[target][pFlagClaimed] == 1) ? ("") : ("s"), PlayerInfo[target][pFlagCredits]);

	} else {
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:flagwinsall(playerid, params[]) {
	new query[128];
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pPR] > 1) {
		format(query,sizeof(query),"SELECT `Username`, `FlagClaimed` FROM `accounts` ORDER BY `FlagClaimed` DESC LIMIT 20");
		mysql_function_query(MainPipeline, query, false, "OnViewClaimed", "i", playerid);
	} else {
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}
	return 1;
}

forward OnViewClaimed(playerid);
public OnViewClaimed(playerid) {
	new rows, fields, szResult[MAX_PLAYER_NAME];
	szMiscArray[0] = 0;
	cache_get_data(rows, fields, MainPipeline);
	format(szMiscArray, sizeof(szMiscArray), "Username\tTotal Claimed\n");
	for(new i = 0; i < rows; i++)
	{
		cache_get_field_content(i, "Username", szResult, MainPipeline);
		format(szMiscArray, sizeof(szMiscArray), "%s\n%s\t%d", szMiscArray, szResult, cache_get_field_content_int(i, "FlagClaimed", MainPipeline));
	}
	return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Find the Flag - Top 20 Players", szMiscArray, "Close", "");
}

CMD:flaghelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** FLAG HELP *** - type a command for more infomation.");
	SendClientMessageEx(playerid, COLOR_GRAD3,"*** FLAG HELP *** /flagclaim /flagstats /flagshop /flaghint");
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pPR] > 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD3, "*** ADMIN *** /flagstatus /flagwins /flagwinsall /setflaghint /flagmove");
	}
    return 1;
}

CMD:flagshop(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 1) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: Administrators can't access the flag store!");
	ShowFlagShop(playerid);
	return 1;
}

stock ShowFlagShop(playerid) {
	new title[54];
	szMiscArray[0] = 0;
	format(title, sizeof(title), "Flag Shop - Flag Credits: %s", number_format(PlayerInfo[playerid][pFlagCredits]));
	Dialog_Show(playerid, flag_shop, DIALOG_STYLE_TABLIST_HEADERS, title,
	"Item\tCost\n\
	Gift Reset\t2\n\
	Custom Car Voucher\t6\n\
	House Interior Change\t6\n\
	Bronze VIP 1 Month\t12\n\
	Silver VIP 1 Month\t20\n\
	Gold VIP 2 Month\t35\n\
	Platinum VIP 1 Month\t40", 
	"Select", "Go Back");
	return 1;
}

Dialog:flag_shop(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(response) {
		SetPVarInt(playerid, "FlagItem", listitem);
		switch(listitem) {
			case 0: {
				if(PlayerInfo[playerid][pFlagCredits] < 2) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 2 flag credits to purchase a gift reset."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Gift Reset\nDescription: Ability to reset your gift timer.\nYour Flag Credits: %d\nCost: {FFD700}2{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-2));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 1: {
				if(PlayerInfo[playerid][pFlagCredits] < 6) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 6 flag credits to purchase a custom car voucher."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Gift Reset\nDescription: Ability to get a personal vehicle from /myvouchers.\nYour Flag Credits: %d\nCost: {FFD700}6{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-6));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 2: {
				if(PlayerInfo[playerid][pFlagCredits] < 6) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 6 flag credits to purchase a house interior change."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: House Interior Change\nDescription: Ability to change your house interior (Account Flag).\nYour Flag Credits: %d\nCost: {FFD700}6{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-6));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 3: {
				if(PlayerInfo[playerid][pFlagCredits] < 12) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 12 flag credits to purchase bronze VIP. (1 month)."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Bronze VIP (1 Month)\nDescription: Item is non-transferable. (Account Flag)\nYour Flag Credits: %d\nCost: {FFD700}12{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-12));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 4: {
				if(PlayerInfo[playerid][pFlagCredits] < 20) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 20 flag credits to purchase silver VIP. (1 month)."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Silver VIP (1 Month)\nDescription: Item is non-transferable. (Account Flag)\nYour Flag Credits: %d\nCost: {FFD700}20{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-20));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 5: {
				if(PlayerInfo[playerid][pFlagCredits] < 35) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 35 flag credits to purchase gold VIP. (2 month)."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Gold VIP (2 Month)\nDescription: Item is non-transferable. (Account Flag)\nYour Flag Credits: %d\nCost: {FFD700}35{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-35));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 6: {
				if(PlayerInfo[playerid][pFlagCredits] < 40) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 40 flag credits to purchase platinum VIP. (1 month)."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Platinum VIP (1 Month)\nDescription: Item is non-transferable. (Account Flag)\nYour Flag Credits: %d\nCost: {FFD700}40{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-40));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
		}
	}
	return 1;
}

Dialog:IssueFlagOrder(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(!GetPVarType(playerid, "FlagItem")) return 1;
	if(response) {
		switch(GetPVarInt(playerid, "FlagItem")) {
			case 0: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Gift Reset Voucher (Cost: 2 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-2));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 2;
				PlayerInfo[playerid][pGiftVoucher] += 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a gift reset voucher you can access it via \"/myvouchers\".");
			}
			case 1: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Custom Car Voucher (Cost: 6 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-6));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 6;
				PlayerInfo[playerid][pVehVoucher] += 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a gift reset voucher you can access it via \"/myvouchers\".");
			}
			case 2: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a House Interior Change (Cost: 6 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-6));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 6;
				AddFlag(playerid, INVALID_PLAYER_ID, "[Flag Event] House Interior Change | NT");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a house interior change (Flagged to your account) you can claim it via \"/report > Prize Claim\".");
			}
			case 3: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Bronze VIP (1 Month) (Cost: 12 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-12));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 12;
				AddFlag(playerid, INVALID_PLAYER_ID, "[Flag Event] Bronze VIP (1 Month) | NT");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a Bronze VIP (1 Month) (Flagged to your account) you can claim it via \"/report > Prize Claim\".");
				SendClientMessageEx(playerid, COLOR_WHITE, "This item can only be claimed to you and cannot be sold to another player.");
			}
			case 4: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Silver VIP (1 Month) (Cost: 20 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-20));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 20;
				AddFlag(playerid, INVALID_PLAYER_ID, "[Flag Event] Silver VIP (1 Month) | NT");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a Silver VIP (1 Month) (Flagged to your account) you can claim it via \"/report > Prize Claim\".");
				SendClientMessageEx(playerid, COLOR_WHITE, "This item can only be claimed to you and cannot be sold to another player.");
			}
			case 5: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Gold VIP (2 Month) (Cost: 35 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-35));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 35;
				AddFlag(playerid, INVALID_PLAYER_ID, "[Flag Event] Gold VIP (2 Month) | NT");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a Gold VIP (2 Month) (Flagged to your account) you can claim it via \"/report > Prize Claim\".");
				SendClientMessageEx(playerid, COLOR_WHITE, "This item can only be claimed to you and cannot be sold to another player.");
			}
			case 6: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Gold VIP (2 Month) (Cost: 40 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-40));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 40;
				AddFlag(playerid, INVALID_PLAYER_ID, "[Flag Event] Platinum VIP (1 Month) | NT");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a Platinum VIP (1 Month) (Flagged to your account) you can claim it via \"/report > Prize Claim\".");
				SendClientMessageEx(playerid, COLOR_WHITE, "This item can only be claimed to you and cannot be sold to another player.");
			}
		}
		DeletePVar(playerid, "FlagItem");
	} else {
		DeletePVar(playerid, "FlagItem");
		ShowFlagShop(playerid);
	}
	return 1;
}

CMD:flaghint(playerid, params[]) {
	SendClientMessageEx(playerid, COLOR_GREEN, "|___________ Flag Event Hint ___________|");
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, FlagHint);
	return 1;
}

CMD:setflaghint(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pPR] > 1) {
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "/setflaghint [text]");
		strmid(FlagHint, params, 0, strlen(params), 128);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[Flag Event]: Flag hint successfully update to the following:");
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "%s", params);
	} else {
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}
	return 1;
}