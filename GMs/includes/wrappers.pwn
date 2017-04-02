/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[WRAPPERS.PWN]--------------------------------


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

			/*  ---------------- WRAPPERS ----------------- */

Internal_SetPlayerPos(playerid, Float:X, Float:Y, Float:Z) {

	Bit_On(arrPAntiCheat[playerid], ac_bitValidPlayerPos);
	return SetPlayerPos(playerid, X, Y, Z);
}


Internal_TogglePlayerSpectating(playerid, toggle) {

	Bit_On(arrPAntiCheat[playerid], ac_bitValidSpectating);
	return TogglePlayerSpectating(playerid, toggle);
}

/*
Internal_ShowPlayerNameTag(playerid, showplayerid, show) {

	if(PlayerInfo[playerid][pAdmin] > 0 || PlayerInfo[showplayerid][pAdmin] > 0) show = 1;
	return ShowPlayerNameTagForPlayer(playerid, showplayerid, show);
}
*/
/*
Internal_SetPlayerHealth(playerid, Float:health) {

	//PlayerInfo[playerid][pHealth] = health;
	return SetPlayerHealth(playerid, health);
}

Internal_SetPlayerArmour(playerid, Float:armour) {

	//PlayerInfo[playerid][pArmor] = armour;
	return SetPlayerArmour(playerid, armour);
}
*/

ClearAnimationsEx(playerid, forcesync = 0) {
	IsDoingAnim[playerid] = 0;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return ClearAnimations(playerid, forcesync);
}

ShowPlayerDialogEx(playerid, dialogid, style, caption[], info[], button1[], button2[]) {

	iLastDialogID[playerid] = dialogid;
	return ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
}

Internal_PutPlayerInVehicle(playerid, vehicle, seat){ 

	arrAntiCheat[playerid][ac_iVehID] = vehicle;
	return PutPlayerInVehicle(playerid,vehicle,seat); 
}

Internal_SetPlayerWeather(playerid, iWeatherID) {

	if(Bit_State(arrPlayerBits[playerid], dr_bitInDrugEffect)) return 1;
	return SetPlayerWeather(playerid, iWeatherID);
}

Internal_SetPlayerTime(playerid, iHour, iMinute) {

	if(Bit_State(arrPlayerBits[playerid], dr_bitInDrugEffect)) return 1;
	return SetPlayerTime(playerid, iHour, iMinute);
}

Internal_CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0) {

	new i = CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren);
	Iter_Add(Vehicles, i);
	return i;
}

Internal_DestroyVehicle(vehicleid) {
	
	Iter_Remove(Vehicles, vehicleid);
	return DestroyVehicle(vehicleid);
}

Internal_SetPlayerVirtualWorld(playerid, iVW) {
	PlayerInfo[playerid][pVW] = iVW;
	return SetPlayerVirtualWorld(playerid, iVW);
}

Internal_SetPlayerInterior(playerid, iInt) {
	PlayerInfo[playerid][pInt] = iInt;
	return SetPlayerInterior(playerid, iInt);
}

/*
Internal_SetPlayerName(playerid, szName[]) {

	UpdateDynamic3DTextLabelText(PlayerLabel[playerid], 0xFFFFFFFF, GetHealthArmorForLabel(playerid));
	return SetPlayerName(playerid, szName);
}

Internal_SetPlayerColor(playerid, color) {

	UpdateDynamic3DTextLabelText(PlayerLabel[playerid], color + 255, GetHealthArmorForLabel(playerid));
	return SetPlayerColor(playerid, color);
}
*/


// From fixer.inc
stock FIX_GetTickCount() {

	new ret = GetTickCount();

	if (ret < 0)
		ret += 2147483647;

	return ret;
}

#if defined TEXTLABEL_DEBUG
Int_DestDyn3DTxtLabel(Text3D:id) {

	new szString[128],
		iTrackID = Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, id, E_STREAMER_EXTRA_ID),
		Float:fPos[3],
		iData[2];

	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, id, E_STREAMER_X, fPos[0]);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, id, E_STREAMER_Y, fPos[1]);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, id, E_STREAMER_Z, fPos[2]);
	iData[0] = Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, id, E_STREAMER_WORLD_ID);
	iData[1] = Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL, id, E_STREAMER_INTERIOR_ID);

	switch(iTrackID) {
		
		case 1: szString = "Businesses[iBusiness][GasPumpSaleTextID][iPump]";
		case 2: szString = "Businesses[i][bDoorText]";
		case 3: szString = "Businesses[i][bStateText]";
		case 4: szString = "Businesses[i][bSupplyText]";
		case 5: szString = "RFLTeamN3D[playerid]";
		case 6: szString = "Text3D:GetPVarInt(playerid, PVAR_TEMPTEXT)";
		case 7: szString = "arrPayPhoneData[i][pp_iTextID]";
		case 8: szString = "PollInfo[iPollID][poll_textLabel]";
		case 9: szString = "DynPoints[id][poTextID]";
		case 10: szString = "Businesses[iBusiness][GasPumpInfoTextID][iPump]";
		default: szString = "Unknown";
	}
	format(szString, sizeof(szString), "Removed TextLabel: %d | Tracker: %s", _:id, szString);
	SendDiscordMessage(3, szString);

	format(szString, sizeof(szString), "TL (%d) data: %0.2f, %0.2f, %0.2f, VW: %d, INT: %d", _:id, fPos[0], fPos[1], fPos[2], iData[0], iData[1]);
	SendDiscordMessage(3, szString);

	if(!IsValidDynamic3DTextLabel(id)) {

		format(szString, sizeof(szString), "Text Label %d (Tracker %s) deleted a non-created text label.", _:id, szString);
		SendDiscordMessage(3, szString);
	}
	return DestroyDynamic3DTextLabel(id);
}
#endif

#if defined AREA_DEBUG
Internal_CreateDynamicSphere(Float:x, Float:y, Float:z, Float:size, worldid = -1, interiorid = -1, playerid = -1) {

	new iTemp = CreateDynamicSphere(x, y, z, size, worldid, interiorid, playerid);
	printf("[DEBUG][AREA][SPHERE][A%d] X: %f Y: %f Z: %f SIZE: %f WID: %d INTID: %d PID: %d", iTemp, x, y, z, size, worldid, interiorid, playerid);
	return iTemp;
}

Internal_DestroyDynamicArea(areaid) {
	printf("[DEBUG][AREA][DESTROY] AID: %d", areaid);
	return DestroyDynamicArea(areaid);
}

Internal_CreateDynamicCuboid(Float:minx, Float:miny, Float:minz, Float:maxx, Float:maxy, Float:maxz, worldid = -1, interiorid = -1, playerid = -1) {

	new iTemp = CreateDynamicCuboid(minx, miny, minz, maxx, maxy, maxz, worldid, interiorid, playerid);
	printf("[DEBUG][AREA][CUBOID][A%d] MINX: %f MINY: %f MINZ: %f MAXX: %f MAXY: %f MAXZ: %f WID: %d INTID: %d PID: %d", iTemp, minx, miny, minz, maxx, maxy, maxz, worldid, interiorid, playerid);
	return iTemp;
}

Internal_StreamerSetIntData(type, id, data, value) {
	printf("[DEBUG][STREAMER][INTDATA] T: %d ID: %d D: %d V: %d", type, id, data, value);
	return Streamer_SetIntData(type, id, data, value);
}
#endif

#define PutPlayerInVehicle(%0) Internal_PutPlayerInVehicle(%0)
#define SetPlayerWeather(%0) Internal_SetPlayerWeather(%0)
#define SetPlayerTime(%0) Internal_SetPlayerTime(%0)
//#define SetPlayerHealth(%0) Internal_SetPlayerHealth(%0)
//#define SetPlayerArmour(%0) Internal_SetPlayerArmour(%0)
#define CreateVehicle(%0) Internal_CreateVehicle(%0)
#define DestroyVehicle(%0) Internal_DestroyVehicle(%0)
#define SetPlayerPos(%0) Internal_SetPlayerPos(%0)
#define TogglePlayerSpectating(%0) Internal_TogglePlayerSpectating(%0)
//#define ShowPlayerNameTagForPlayer(%0) Internal_ShowPlayerNameTag(%0)

//#define SetPlayerHealth(%0) Internal_SetPlayerHealth(%0)
//#define SetPlayerArmour(%0) Internal_SetPlayerArmour(%0)

#define SetPlayerVirtualWorld(%0) Internal_SetPlayerVirtualWorld(%0)
#define SetPlayerInterior(%0) Internal_SetPlayerInterior(%0)
//#define SetPlayerName(%0) Internal_SetPlayerName(%0)
//#define SetPlayerColor(%0) Internal_SetPlayerColor(%0)
#define GetTickCount(%0) FIX_GetTickCount(%0)

#if defined TEXTLABEL_DEBUG
#define DestroyDynamic3DTextLabel(%0) Int_DestDyn3DTxtLabel(%0)
#endif

#if defined AREA_DEBUG
#define CreateDynamicSphere(%0) Internal_CreateDynamicSphere(%0)
#define CreateDynamicCuboid(%0) Internal_CreateDynamicCuboid(%0)
#define DestroyDynamicArea(%0) Internal_DestroyDynamicArea(%0)
#define Streamer_SetIntData(%0) Internal_StreamerSetIntData(%0)
#endif