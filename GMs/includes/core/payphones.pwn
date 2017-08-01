/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

    	   			Pay Phones System
    			        by Jingles

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

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_YES) {

		new areaid[1];
		GetPlayerDynamicAreas(playerid, areaid); //Assign nearest areaid
		// new a = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid[1], E_STREAMER_EXTRA_ID);

		if(areaid[0] != INVALID_STREAMER_ID) {
			for(new a; a < MAX_PAYPHONES; ++a) {

				if(areaid[0] == arrPayPhoneData[a][pp_iAreaID]) {

					if(IsPlayerInAnyVehicle(playerid)) return 1;
					SetPVarInt(playerid, "AtPayPhone", a);
					break;
				}
			}
		}
		if(GetPVarType(playerid, "AtPayPhone")) {

			if(GetPVarType(playerid, "PayPhone")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are already communicating with a pay phone.");

			new i = GetPVarInt(playerid, "AtPayPhone");
			if(arrPayPhoneData[i][pp_iCallerID] != INVALID_PLAYER_ID) {
				
				SetPVarInt(playerid, "PayPhone", i); 
				cmd_pickup(playerid, "");
				return 1;
			}
			PayPhone_Menu(playerid, i);
			DeletePVar(playerid, "AtPayPhone");
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_PAYPHONE: {

			if(!response || isnull(inputtext)) return DeletePVar(playerid, "PayPhone"), 1;
			if(strval(inputtext) == PlayerInfo[playerid][pPnumber]) return DeletePVar(playerid, "PayPhone"), SendClientMessageEx(playerid, COLOR_GRAD1, "You shouldn't call yourself, dumbo.");
			if(strval(inputtext) == 0) return DeletePVar(playerid, "PayPhone"), SendClientMessageEx(playerid, COLOR_GRAD1, "You shouldn't call 0, weirdo.");
			cmd_call(playerid, inputtext);
			return 1;
		}
		case DIALOG_PAYPHONE_ADMIN: {

			if(!response) return 1;

			new Float:fPos[3],
				i = ListItemTrackId[playerid][listitem];

			GetDynamicObjectPos(arrPayPhoneData[i][pp_iObjectID], fPos[0], fPos[1], fPos[2]);
			Player_StreamPrep(playerid, fPos[0], fPos[1], fPos[2], FREEZE_TIME);
			SetPlayerVirtualWorld(playerid, Streamer_GetIntData(STREAMER_TYPE_OBJECT, arrPayPhoneData[i][pp_iObjectID], E_STREAMER_WORLD_ID));
			SetPlayerInterior(playerid, Streamer_GetIntData(STREAMER_TYPE_OBJECT, arrPayPhoneData[i][pp_iObjectID], E_STREAMER_INTERIOR_ID));
			return 1;
		}
	}
	return 0;
}

GetPhoneZone(id, zone[], len) {

	new Float:x, Float:y, Float:z;
	GetDynamicObjectPos(arrPayPhoneData[id][pp_iObjectID], x, y, z);

	for(new i = 0; i != sizeof(gMainZones); i++) {

		if(x >= gMainZones[i][SAZONE_AREA][0]
				&& x <= gMainZones[i][SAZONE_AREA][3]
				&& y >= gMainZones[i][SAZONE_AREA][1]
				&& y <= gMainZones[i][SAZONE_AREA][4]
				&& z >= gMainZones[i][SAZONE_AREA][2]
				&& z <= gMainZones[i][SAZONE_AREA][5]) {
			format(zone, len, gMainZones[i][SAZONE_NAME], 0);
		}
	}
	
	for(new i = 0; i != sizeof(gSAZones); i++) {

		if(x >= gSAZones[i][SAZONE_AREA][0]
				&& x <= gSAZones[i][SAZONE_AREA][3]
				&& y >= gSAZones[i][SAZONE_AREA][1]
				&& y <= gSAZones[i][SAZONE_AREA][4]
				&& z >= gSAZones[i][SAZONE_AREA][2]
				&& z <= gSAZones[i][SAZONE_AREA][5]) {
			return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}

GetPhoneAreaCode(i) {

	new iAreaCode;
	GetPhoneZone(i, szMiscArray, sizeof(szMiscArray));
	if(strcmp(szMiscArray, "DOC", true) == 0) iAreaCode = 420;
	if(strcmp(szMiscArray, "Los Santos", true) == 0) iAreaCode = 500;
	if(strcmp(szMiscArray, "Red County", true) == 0) iAreaCode = 300;
	if(strcmp(szMiscArray, "Flint County", true) == 0) iAreaCode = 400;
	if(strcmp(szMiscArray, "San Fierro", true) == 0) iAreaCode = 600;
	if(strcmp(szMiscArray, "Las Venturas", true) == 0) iAreaCode = 700;
	if(strcmp(szMiscArray, "Bone County", true) == 0) iAreaCode = 666;
	if(strcmp(szMiscArray, "Tiera Robada", true) == 0) iAreaCode = 999;
	if(strcmp(szMiscArray, "Downtown Los Santos", true) == 0) iAreaCode = 502;
	if(strcmp(szMiscArray, "Pershing Square", true) == 0) iAreaCode = 503;
	if(strcmp(szMiscArray, "Temple", true) == 0) iAreaCode = 504;
	if(strcmp(szMiscArray, "Market", true) == 0) iAreaCode = 505;
	if(strcmp(szMiscArray, "Rodeo", true) == 0) iAreaCode = 540;
	if(strcmp(szMiscArray, "Idlewood", true) == 0) iAreaCode = 569;
	if(strcmp(szMiscArray, "Glen Park", true) == 0) iAreaCode = 570;
	if(strcmp(szMiscArray, "Jefferson", true) == 0) iAreaCode = 572;
	if(strcmp(szMiscArray, "East Los Santos", true) == 0) iAreaCode = 580;
	if(strcmp(szMiscArray, "Blueberry", true) == 0) iAreaCode = 444;
	if(strcmp(szMiscArray, "Angel Pine", true) == 0) iAreaCode = 838;
	return iAreaCode;
}

PayPhone_Menu(playerid, i) {

	szMiscArray[0] = 0;

	SetPVarInt(playerid, "PayPhone", i);
	GetPhoneZone(i, szMiscArray, sizeof(szMiscArray));
	format(szMiscArray, sizeof(szMiscArray), "Number: %d\nArea Code: %d | {FFFF00}%s\n\n{FFFFFF}Please enter the number you would like to dial.", arrPayPhoneData[i][pp_iNumber], GetPhoneAreaCode(i), szMiscArray);
	ShowPlayerDialogEx(playerid, DIALOG_PAYPHONE, DIALOG_STYLE_INPUT, "Pay Phone", szMiscArray, "Dial", "<<");
}

LoadPayPhones() {

	print("[Pay Phones] Loading pay phones from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `payphones`", "OnLoadPayPhones", "");
}

forward OnLoadPayPhones();
public OnLoadPayPhones()
{
	new iRows;
	cache_get_row_count(iRows);
	if(!iRows) return print("[Pay Phones] No pay phones were found in the database.");
	new iRow, value, Float:fValue;

	while(iRow < iRows) {

		cache_get_value_name_int(iRow, "number", arrPayPhoneData[iRow][pp_iNumber]);
		arrPayPhoneData[iRow][pp_iCallerID] = INVALID_PLAYER_ID;

		ProcessPayPhone(iRow,
			cache_get_value_name_float(iRow, "posx", fValue),
			cache_get_value_name_float(iRow, "posy", fValue),
			cache_get_value_name_float(iRow, "posz", fValue),
			cache_get_value_name_float(iRow, "rotz", fValue),
			cache_get_value_name_int(iRow, "vw", value),
			cache_get_value_name_int(iRow, "int", value));
	    
		iRow++;
	}
	return printf("[MySQL] Loaded %i pay phones from database.", iRows);
}

forward OnCreatePayPhone(playerid, i, Float:X, Float:Y, Float:Z, Float:RZ, iVW, iINT); 
public OnCreatePayPhone(playerid, i, Float:X, Float:Y, Float:Z, Float:RZ, iVW, iINT) {


	if(mysql_errno(MainPipeline)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Something went wrong. Please contact the development team.");
	   
	ProcessPayPhone(i, X, Y, Z, RZ, iVW, iINT);

	format(szMiscArray, sizeof szMiscArray, "You have created a pay phone using ID %i.", i);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	
	format(szMiscArray, sizeof szMiscArray, "%s has creatd a pay phone using ID %i.", GetPlayerNameEx(playerid), i);
	Log("logs/payphones.log", szMiscArray);
	return 1;
}

forward OnDeletePayPhone(playerid, i);
public OnDeletePayPhone(playerid, i) {

	if(mysql_errno(MainPipeline)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Something went wrong. Please contact the development team.");
	DestroyDynamicObject(arrPayPhoneData[i][pp_iObjectID]);

	#if defined TEXTLABEL_DEBUG
	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, arrPayPhoneData[i][pp_iTextID], E_STREAMER_EXTRA_ID, 7);
	#endif
	
	DestroyDynamic3DTextLabel(arrPayPhoneData[i][pp_iTextID]);
	DestroyDynamicArea(arrPayPhoneData[i][pp_iAreaID]);
	
	format(szMiscArray, sizeof szMiscArray, "You have deleted pay phone ID %i.", i);
	SendClientMessageEx(playerid, COLOR_LIGHTRED, szMiscArray);
	
	format(szMiscArray, sizeof szMiscArray, "%s (%d) has deleted pay phone ID %i.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], i);
	Log("logs/payphones.log", szMiscArray);
	return 1;
}

PayPhone_UpdateTextLabel(i, choice) {

	switch(choice) {

		case 0: {

			format(szMiscArray, sizeof(szMiscArray), "Pay Phone {DDDDDD}(ID: %d)\n{FFFF00} Number: %d\n\n{DDDDDD}Press ~k~~CONVERSATION_YES~ to dial.", i, arrPayPhoneData[i][pp_iNumber]);
			UpdateDynamic3DTextLabelText(arrPayPhoneData[i][pp_iTextID], COLOR_YELLOW, szMiscArray);

		}
		case 1: UpdateDynamic3DTextLabelText(arrPayPhoneData[i][pp_iTextID], COLOR_PURPLE, "** The pay phone is ringing **\nPress ~k~~CONVERSATION_YES~ to answer.");
	}
}

ProcessPayPhone(i, Float:X, Float:Y, Float:Z, Float:RZ, iVW, iINT) {

	if(X != 0 && Y != 0) {
		
		arrPayPhoneData[i][pp_iCallerID] = INVALID_PLAYER_ID;
		arrPayPhoneData[i][pp_iObjectID] = CreateDynamicObject(1216, X, Y, Z - 0.3, 0.0, 0.0, RZ + 180.0, .worldid = iVW, .interiorid = iINT);
		format(szMiscArray, sizeof(szMiscArray), "Pay Phone {DDDDDD}(ID: %d)\n{FFFF00} Number: %d\n\n{DDDDDD}Press ~k~~CONVERSATION_YES~ to dial.", i, arrPayPhoneData[i][pp_iNumber]);
		arrPayPhoneData[i][pp_iTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, X, Y, Z + 1.0, 5.0, .worldid = iVW, .interiorid = iINT);
		arrPayPhoneData[i][pp_iAreaID] = CreateDynamicSphere(X, Y, Z, 3.0, iVW, iINT);
	}
}

PayPhone_Save(i, Float:X, Float:Y, Float:Z, Float:RZ, iVW, iINT) {

	if(!IsValidDynamicArea(arrPayPhoneData[i][pp_iAreaID])) return 1;    
	    
	mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `payphones` SET\
		`number` = %d, \
		`vw` = %i, \
	    `int` = %i, \
	    `posx` = %f, \
	    `posy` = %f, \
	    `posz` = %f, \
	    `rotz` = %f",
	    arrPayPhoneData[i][pp_iNumber],
		iVW,
		iINT,
		X,
		Y,
		Z,
		RZ
	);
	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

CMD:phones(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_GENERAL)) return 1;

	szMiscArray[0] = 0;

	new x,
		szZone[MAX_ZONE_NAME];

	for(new i = 0; i < MAX_PAYPHONES; ++i) {

		if(IsValidDynamicArea(arrPayPhoneData[i][pp_iAreaID])) {

			GetPhoneZone(i, szZone, sizeof(szZone));
			format(szMiscArray, sizeof(szMiscArray), "%s\n%d - Number: %d - Location: %s", szMiscArray, i, arrPayPhoneData[i][pp_iNumber], szZone);
			ListItemTrackId[playerid][x] = i;
			x++;
		}
	}
	if(isnull(szMiscArray)) return SendClientMessageEx(playerid, COLOR_GRAD1, "There are no pay phones.");
	ShowPlayerDialogEx(playerid, DIALOG_PAYPHONE_ADMIN, DIALOG_STYLE_LIST, "Pay Phones", szMiscArray, "Teleport", "Cancel");
	return 1;
}

CMD:createphone(playerid, params[]) {
	
	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;
	    
	for(new i = 0; i < MAX_PAYPHONES; ++i) {

		if(!IsValidDynamicArea(arrPayPhoneData[i][pp_iAreaID])) {

			new Float:fPos[4],
				iVW = GetPlayerVirtualWorld(playerid),
	    		iINT = GetPlayerInterior(playerid);

			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			GetPlayerFacingAngle(playerid, fPos[3]);

			arrPayPhoneData[i][pp_iObjectID] = CreateDynamicObject(1216, fPos[0], fPos[1], fPos[2] - 0.3, 0.0, 0.0, fPos[3] + 180.0); // temp object to get zone

			format(szMiscArray, sizeof(szMiscArray), "024%d%d", GetPhoneAreaCode(i), Random(100, 999));			
			arrPayPhoneData[i][pp_iNumber] = strval(szMiscArray);

			for(new x; x < MAX_PAYPHONES; ++x) {

				if(!IsValidDynamicArea(arrPayPhoneData[i][pp_iAreaID])) continue;

				if(arrPayPhoneData[i][pp_iNumber] == arrPayPhoneData[x][pp_iNumber]) {
					
					DestroyDynamicObject(arrPayPhoneData[i][pp_iObjectID]);
					arrPayPhoneData[i][pp_iNumber] = -1;
					return SendClientMessageEx(playerid, COLOR_GRAD1, "Please try again. The system generated an already existing number.");
				}
			}

			DestroyDynamicObject(arrPayPhoneData[i][pp_iObjectID]);
      		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `payphones` SET `number` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', `rotz` = '%f', `vw` = '%d', `int` = '%d' WHERE `id` = '%d'",
	    		arrPayPhoneData[i][pp_iNumber],
	    		fPos[0],
	    		fPos[1],
	    		fPos[2],
	    		fPos[3],
	    		iVW,
	    		iINT,
	    		i+1);

			return mysql_tquery(MainPipeline, szMiscArray, "OnCreatePayPhone", "iiffffii", playerid, i, fPos[0], fPos[1], fPos[2], fPos[3], iVW, iINT);
		}
	}
	SendClientMessageEx(playerid, COLOR_GRAD1, "There are no more pay phone slots available.");
	return 1;
}


CMD:destroyphone(playerid, params[]) {
	
	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;

    new i;
        
	if(sscanf(params, "i", i))
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "/destroyphone [phoneid]");
	    
	if(!IsValidDynamicArea(arrPayPhoneData[i][pp_iAreaID]))
		return SendClientMessageEx(playerid, COLOR_GRAD1, "The specified pay phone ID has not been used.");
	    
	mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `payphones` SET `number` = '-1', `posx` = '0', `posy` = '0', `posz` = '0', `vw` = '0', `int` = '0' WHERE `id` = %i", i+1);
	mysql_tquery(MainPipeline, szMiscArray, "OnDeletePayPhone", "ii", playerid, i);
	return 1;
}


CMD:editphone(playerid, params[]) 
{
	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;

	new i;

	if(sscanf(params, "i", i))
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "/editphone [id]");
	    
  	if(!IsValidDynamicArea(arrPayPhoneData[i][pp_iAreaID]))
		return SendClientMessageEx(playerid, COLOR_GRAD1, "The specified pay phone ID has not been used.");
	  
	new Float:fPos[4];
	    
	GetDynamicObjectPos(arrPayPhoneData[i][pp_iObjectID], fPos[0], fPos[1], fPos[2]);

    if(!IsPlayerInRangeOfPoint(playerid, 50.0, fPos[0], fPos[1], fPos[2]))
        return SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be near the specified pay phone to edit the position.");
	    
    GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
    GetPlayerFacingAngle(playerid, fPos[3]);

    new iVW = GetPlayerVirtualWorld(playerid),
    	iINT = GetPlayerInterior(playerid);

	PayPhone_Save(i, fPos[0], fPos[1], fPos[2], fPos[3], iVW, iINT);

	DestroyDynamicObject(arrPayPhoneData[i][pp_iObjectID]);
    DestroyDynamicArea(arrPayPhoneData[i][pp_iAreaID]);
    DestroyDynamic3DTextLabel(arrPayPhoneData[i][pp_iTextID]);

    ProcessPayPhone(i, fPos[0], fPos[1], fPos[2], fPos[3], iVW, iINT);

	format(szMiscArray, sizeof(szMiscArray), "You have edited phone ID %i's position.", i);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	return 1;
}
