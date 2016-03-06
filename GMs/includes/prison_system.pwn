/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Prison System

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

DocIsolate(playerid, cellid, ooc)
{
	SetPlayerPos(playerid, DocIsolation[cellid][0], DocIsolation[cellid][1], DocIsolation[cellid][2]);
	SetPlayerFacingAngle(playerid, 0);
	SetPlayerInterior(playerid, 1);
	Player_StreamPrep(playerid, DocIsolation[cellid][0], DocIsolation[cellid][1], DocIsolation[cellid][2], FREEZE_TIME);

	PlayerInfo[playerid][pIsolated] = cellid + 1;
	if(ooc >= 1)
	{
	    SetPlayerVirtualWorld(playerid, 666);
	    PlayerInfo[playerid][pVW] = 666;
	}
}

ListDetainees(playerid)
{
	new szPrisoners[1028],
		iCount = 0,
		temp[4];

	foreach(Player, i)
	{
		if(GetPVarInt(i, "ArrestPoint") == GetArrestPointID(playerid) + 1)
		{
			strcat(szPrisoners, "{3333CC}Prisoner:{FFFFFF}");
			strcat(szPrisoners, "(");
			valstr(temp, i);
			strcat(szPrisoners, temp);
			strcat(szPrisoners, ")");
			strcat(szPrisoners, GetPlayerNameEx(i));
			strcat(szPrisoners, "\n");
			iCount++;
		}
	}
	if(iCount == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "No prisoners at this arrest point.");
	return ShowPlayerDialog(playerid, DIALOG_LOAD_DETAINEES, DIALOG_LOAD_DETAINEES, "Detainees List", szPrisoners, "Load", "Cancel");
}

LoadPrisoner(iLoadingID, iPrisonerID, iVehicleID, iVehicleSeat, iNewVW, iNewIW)
{
	SetPlayerVirtualWorld(iPrisonerID, iNewVW);
	PlayerInfo[iPrisonerID][pVW] = iNewVW;
	SetPlayerInterior(iPrisonerID, iNewIW);
	PlayerInfo[iPrisonerID][pInt] = iNewIW;
	PutPlayerInVehicle(iPrisonerID, iVehicleID, iVehicleSeat);
	TogglePlayerControllable(iPrisonerID, 0);
	DeletePVar(iPrisonerID, "ArrestPoint");

	SendClientMessageEx(iPrisonerID, COLOR_LIGHTBLUE, "You have been loaded into a prisoner transport bus by and will be transported to DOC");
	ListDetainees(iLoadingID);
}

ShowDocPrisonControls(playerid, icontrolid)
{
	szMiscArray[0] = 0;

	switch(icontrolid)
	{
		case 0:
		{
			// main dialog
			format(szMiscArray, sizeof(szMiscArray), "Cell-block A\nIsolation Cells\nArea Doors\nLockdown\nIntercom");
			ShowPlayerDialog(playerid, DIALOG_DOC_CP, DIALOG_STYLE_LIST, "Doc Control Pannel", szMiscArray, "Select", "Cancel");
		}
		case 1:
		{
			// sub-dialog
			format(szMiscArray, sizeof(szMiscArray), "Floor 1\nFloor 2\nAll Floor 1\nAll Floor 2");
			ShowPlayerDialog(playerid, DIALOG_DOC_CP_SUB, DIALOG_STYLE_LIST, "Doc Control Pannel", szMiscArray, "Select", "Back");
		}
		case 2:
		{
			// floor 1
			format(szMiscArray, sizeof(szMiscArray), "Cell 1 (%s)\n\
			Cell 2 (%s)\n\
			Cell 3 (%s)\n\
			Cell 4 (%s)\n\
			Cell 5 (%s)\n\
			Cell 6 (%s)\n\
			Cell 7 (%s)\n\
			Cell 8 (%s)\n\
			Cell 9 (%s)\n\
			Cell 10 (%s)\n\
			Cell 11 (%s)\n\
			Cell 12 (%s)\n\
			Cell 13 (%s)\n\
			Cell 14 (%s)\n\
			Cell 15 (%s)\n\
			Cell 16 (%s)",
			((bDocCellOpen[0] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[1] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[2] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[3] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[4] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[5] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[6] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[7] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[8] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[9] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[10] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[11] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[12] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[13] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[14] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[15] == false) ? ("{FF0000}Closed"):("{00FF00}Open"))
			);
			ShowPlayerDialog(playerid, DIALOG_DOC_CP_C1F1, DIALOG_STYLE_LIST, "Doc Control Pannel", szMiscArray, "Select", "Back");
		}
		case 3:
		{
			// floor 2
			format(szMiscArray, sizeof(szMiscArray), "Cell 1 (%s)\n\
			Cell 2 (%s)\n\
			Cell 3 (%s)\n\
			Cell 4 (%s)\n\
			Cell 5 (%s)\n\
			Cell 6 (%s)\n\
			Cell 7 (%s)\n\
			Cell 8 (%s)\n\
			Cell 9 (%s)\n\
			Cell 10 (%s)\n\
			Cell 11 (%s)\n\
			Cell 12 (%s)\n\
			Cell 13 (%s)\n\
			Cell 14 (%s)\n\
			Cell 15 (%s)",
			((bDocCellOpen[16] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[17] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[18] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[19] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[20] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[21] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[22] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[23] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[24] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[25] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[26] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[27] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[28] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[29] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocCellOpen[30] == false) ? ("{FF0000}Closed"):("{00FF00}Open"))
			);
			ShowPlayerDialog(playerid, DIALOG_DOC_CP_C1F2, DIALOG_STYLE_LIST, "Doc Control Pannel", szMiscArray, "Select", "Back");
		}
		case 4:
		{
			// area controls
			format(szMiscArray, sizeof(szMiscArray), "Cell-block 1(%s)\n\
			Cell-block 2 (%s)\n\
			Showers (%s)\n\
			Cafe 1 (%s)\n\
			Cafe 2 (%s)\n\
			Laundry Room (%s)\n\
			Isolation Block (%s)\n\
			Control Room (%s)\n\
			Processing 1 (%s)\n\
			Processing 2 (%s)\n\
			Processing 3 (%s)\n\
			Classroom (%s)\n\
			Janitor's Closet (%s)\n\
			Medical Ward (%s)\n\
			Hallway(%s)\n\
			Lobby 1 (%s)\n\
			Lobby 2 (%s)\n\
			Visitation (%s)",
			((bDocAreaOpen[0] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[1] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[2] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[3] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[4] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[5] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[6] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[7] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[8] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[9] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[10] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[11] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[12] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[13] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[14] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[15] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[16] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[17] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocAreaOpen[18] == false) ? ("{FF0000}Closed"):("{00FF00}Open"))
			);
			ShowPlayerDialog(playerid, DIALOG_DOC_CP_AREA, DIALOG_STYLE_LIST, "Doc Control Pannel", szMiscArray, "Select", "Back");
		}
	}
	return 1;
}

DocLockdown(playerid)
{
	new szWarning[128];

	if(bDocLockdown == false)
	{

		bDocLockdown = true;
		for(new i = 0; i < 31; i++)
		{
			OpenDocCells(i, 0);
		}
		for(new i = 0; i < 19; i++)
		{
			OpenDocAreaDoors(i, 0);
		}
		format( szWarning, sizeof(szWarning), "ALERT: The DeMorgan Correctional Facility is now on lockdown for an emergency (( %s ))", GetPlayerNameEx(playerid));
		SendGroupMessage(1, COLOR_RED, szWarning);

		format(szMiscArray, sizeof szMiscArray, "%s has set the DeMorgan Correctional Facilty on lockdown.", GetPlayerNameEx(playerid));
 		GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
	}
	else
	{
		bDocLockdown = false;
		format( szWarning, sizeof(szWarning), "ALERT: The DeMorgan Correctional Facility is no longer on lockdown (( %s ))", GetPlayerNameEx(playerid));
		SendGroupMessage(1, COLOR_YELLOW, szWarning);

		format(szMiscArray, sizeof szMiscArray, "%s has removed the DeMorgan Correctional Facilty from lockdown.", GetPlayerNameEx(playerid));
 		GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
	}
}

Prison_SetPlayerSkin(playerid) {
	switch(PlayerInfo[playerid][pSex]) {
		case 1: {
			SetPlayerSkin(playerid, 8);
			PlayerInfo[playerid][pModel] = 8;
		}
		case 2: {
			SetPlayerSkin(playerid, 211);
			PlayerInfo[playerid][pModel] = 211;
		}
	}
}

GetClosestPrisonPhone(playerid)
{
	new returnval;
	for(new i = 0; i < 5; i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2, JailPhonePos[i][0], JailPhonePos[i][1], JailPhonePos[i][2]))
		{
			returnval = i;
			break;
		}
	}
	return returnval;
}

forward OpenDocAreaDoors(doorid, open);
public OpenDocAreaDoors(doorid, open)
{
	switch(doorid)
	{
		case 0: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[0], 568.36981, 1453.9955, 5999.47168, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[0], 568.36981, 1455.3355, 5999.47168, 0.9);
		}
		case 1: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[1], 572.8498, 1453.9955, 5999.47168, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[1], 572.8498, 1455.3155, 5999.47168, 0.9);
		}
		case 2: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[2], 585.77289, 1448.87915, 5999.45947, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[2], 585.7729, 1447.5592, 5999.4595, 0.9);
		}
		case 3: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[3], 553.98120, 1466.11426, 5999.44971, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[3], 552.6612, 1466.1143, 5999.4497, 0.9);
		}
		case 4: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[4], 553.98169, 1474.47205, 5999.48877, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[4], 552.6617, 1474.4720, 5999.4888, 0.9);
		}
		case 5: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[5], 583.51978, 1455.05212, 5999.47266, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[5], 582.1798, 1455.0521, 5999.4727, 0.9);
		}
		case 6: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[6], 531.66589, 1428.00647, 10999.45703, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[6], 530.3259, 1428.0065, 10999.4570, 0.9);
		}
		case 7: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[7], 566.54053, 1462.30774, 6003.41699, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[7], 565.2205, 1462.30774, 6003.41699, 0.9);
		}
		case 8: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[8], 572.98657, 1447.5975, 5999.4727, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[8], 572.98657, 1449.12683, 5999.4727, 0.9);
		}
		case 9: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[9], 597.01477, 1452.43774, 5999.44873 , 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[9], 597.0148, 1451.0177, 5999.4487, 0.9);
		}
		case 10: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[10], 599.12000, 1451.45422, 5999.47754, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[10],  597.7200, 1451.4742, 5999.4775, 0.9);
		}
		case 11: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[11],  589.21820, 1448.87537, 5999.46826, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[11],  589.2182, 1447.4754, 5999.4683, 0.9);
		}
		case 12: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[12],  579.57898, 1463.63379, 5999.46143, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[12],  579.5790, 1462.3338, 5999.4614, 0.9);
		}
		case 13: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[13], 572.99377, 1468.63940, 5999.43994, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[13],  572.9938, 1467.3394, 5999.4399, 0.9);
		}
		case 14: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[14],  572.98419, 1434.65295, 5999.52295, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[14],  572.9842, 1433.2330, 5999.5229, 0.9);
		}
		case 15: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[15],  575.50751, 1461.82019, 5999.47168, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[15],  574.1475, 1461.82019, 5999.47168, 0.9);
		}
		case 16: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[16],  526.92139, 1414.63281, 10999.45703, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[16],  526.92139, 1415.9528, 10999.45703, 0.9);
		}
		case 17: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[17],  529.96143, 1414.63281, 10999.45703, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[17],  529.96143, 1415.9528, 10999.45703, 0.9);
		}
		case 18: {
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[18],  542.2069, 1417.86682, 10999.45703, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[18],  542.2069, 1416.5468, 10999.45703, 0.9);
		}
	}
	if(open == 0) bDocAreaOpen[doorid] = false;
	else if(open == 1) bDocAreaOpen[doorid] = true;
}

OpenDocCells(cellid, open)
{
	switch(cellid)
	{
		case 0:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[0], 567.21069, 1445.88171, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[0], 567.21069 - 1.58, 1445.88171, 6000.74609, 0.9);
		}
		case 1:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[1], 563.58539, 1445.88171, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[1], 563.58539 - 1.58, 1445.88171, 6000.74609, 0.9);
		}
		case 2:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[2], 559.87738, 1445.88171, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[2], 559.87738 - 1.58, 1445.88171, 6000.74609, 0.9);
		}
		case 3:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[3], 556.21832, 1445.88171, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[3], 556.21832 - 1.58, 1445.88171, 6000.74609, 0.9);
		}
		case 4:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[4], 552.55121, 1445.88171, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[4], 552.55121 - 1.58, 1445.88171, 6000.74609, 0.9);
		}
		case 5:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[5], 548.86353, 1445.88171, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[5], 548.86353 - 1.58, 1445.88171, 6000.74609, 0.9);
		}
		case 6:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[6], 545.21039, 1445.86316, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[6], 545.21039 - 1.58, 1445.86316, 6000.74609, 0.9);
		}
		case 7:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[7], 542.56842, 1446.81152, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[7], 542.56842, 1446.81152 + 1.58, 6000.74609, 0.9);
		}
		case 8:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[8], 542.54321, 1450.46936, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[8], 542.54321, 1450.46936  + 1.58, 6000.74609, 0.9);
		}
		case 9:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[9], 542.55432, 1454.13354, 6000.74609, 0.9);//
			if(open == 1) MoveDynamicObject(DocCellsFloor1[9], 542.55432, 1454.13354 + 1.58, 6000.74609, 0.9);//
		}
		case 10:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[10], 542.55432, 1457.79626, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[10], 542.55432, 1457.79626 + 1.58, 6000.74609, 0.9);
		}
		case 11:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[11], 543.48657, 1462.26819, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[11], 543.48657  + 1.58, 1462.26819, 6000.74609, 0.9);
		}
		case 12:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[12], 547.16162, 1462.26819, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[12], 547.16162 + 1.58, 1462.26819, 6000.74609, 0.9);
		}
		case 13:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[13], 550.84277, 1462.28821, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[13], 550.84277  + 1.58, 1462.28821, 6000.74609, 0.9);
		}
		case 14:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[14], 556.91632, 1462.26819, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[14], 556.91632  + 1.58, 1462.26819, 6000.74609, 0.9);
		}
		case 15:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor1[15], 560.60620, 1462.26819, 6000.74609, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor1[15],560.60620 + 1.58, 1462.26819, 6000.74609, 0.9);
		}
		case 16:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[0], 567.23071, 1445.88171, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[0], 567.23071 - 1.58, 1445.88171, 6004.63135, 0.9);
		}
		case 17:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[1], 563.58539, 1445.88171, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[1], 563.58539 - 1.58, 1445.88171, 6004.63135, 0.9);
		}
		case 18:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[2], 559.87738, 1445.88171, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[2], 559.87738 - 1.58, 1445.88171, 6004.63135, 0.9);
		}
		case 19:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[3], 556.21832, 1445.88171, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[3], 556.21832 - 1.58, 1445.88171, 6004.63135, 0.9);
		}
		case 20:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[4], 552.55121, 1445.88171, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[4], 552.55121 - 1.58, 1445.88171, 6004.63135, 0.9);
		}
		case 21:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[5], 548.86353, 1445.88171, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[5], 548.86353 - 1.58, 1445.88171, 6004.63135, 0.9);
		}
		case 22:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[6], 545.21039, 1445.86316, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[6], 545.21039 - 1.58, 1445.86316, 6004.63135, 0.9);
		}
		case 23:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[7], 542.56842, 1446.81152, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[7], 542.56842, 1446.81152 + 1.58, 6004.63135, 0.9);
		}
		case 24:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[8], 542.54321, 1450.46936, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[8], 542.54321, 1450.46936 + 1.58, 6004.63135, 0.9);
		}
		case 25:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[9], 542.55432, 1454.13354, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[9], 542.55432, 1454.13354 + 1.58, 6004.63135, 0.9);
		}
		case 26:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[10], 542.55432, 1457.79626, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[10], 542.55432, 1457.79626 + 1.58, 6004.63135, 0.9);
		}
		case 27:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[11], 543.48657, 1462.26819, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[11], 543.48657 + 1.58, 1462.26819, 6004.63135, 0.9);
		}
		case 28:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[12], 547.16162, 1462.26819, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[12], 547.16162 + 1.58, 1462.26819, 6004.63135, 0.9);
		}
		case 29:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[13], 550.84277, 1462.28821, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[13], 550.84277 + 1.58, 1462.28821, 6004.63135, 0.9);
		}
		case 30:
		{
			if(open == 0) MoveDynamicObject(DocCellsFloor2[14], 556.91632, 1462.26819, 6004.63135, 0.9);
			if(open == 1) MoveDynamicObject(DocCellsFloor2[14], 556.91632 + 1.58, 1462.26819, 6004.63135, 0.9);
		}
	}
	if(open == 0) bDocCellOpen[cellid] = false;
	else if(open == 1) bDocCellOpen[cellid] = true;
}

/*GetClosestJailBoxingRing(iTargetID)
{
	new iClosest;
	for(new i = 0; i < MAX_JAIL_BOXINGS; i++)
	{
		if(IsPlayerInRangeOfPoint(iTargetID, 5, JailBoxingPos[i][0], JailBoxingPos[i][1], JailBoxingPos[i][2]))
		{
			iClosest = i;
			break;
		}
	}
	return iClosest;
}

IsPlayerAtJailBoxing(iTargetID)
{
	for(new i = 0; i < MAX_JAIL_BOXINGS; i++)
	{
		if(IsPlayerInRangeOfPoint(iTargetID, 5, JailBoxingPos[i][0], JailBoxingPos[i][1], JailBoxingPos[i][2]))
		{
			return true;
		}
	}
	return 0;
}

SetPlayerIntoJailBoxing(iTargetID)
{
	new index = GetClosestJailBoxingRing(iTargetID);

	if(arrJailBoxingData[index][bInProgress] == false && arrJailBoxingData[index][iParticipants] < 2)
	{
		SetPlayerPos(iTargetID, JailBoxingPos[index][0], JailBoxingPos[index][1], JailBoxingPos[index][2]);
		arrJailBoxingData[index][iParticipants]++;
		SetPVarInt(iTargetID, "_InJailBoxing", index + 1);
		SendClientMessageEx(iTargetID, COLOR_WHITE, "You have joined the boxing queue.");

		if(arrJailBoxingData[index][iParticipants] == 2)
		{
			foreach(Player, i)
			{
				if(GetPVarInt(i, "_InJailBoxing") == index + 1 && i != iTargetID)
				{
					SetPVarInt(iTargetID, "_JailBoxingChallenger", i);
					SetPVarInt(i, "_JailBoxingChallenger", iTargetID);
					break;
				}
			}
			arrJailBoxingData[index][iDocBoxingCountdown] = 4;
			arrJailBoxingData[index][iDocCountDownTimer] = SetTimerEx("StartJailBoxing", 1000, true, "i", index);
		}
	}
	else SendClientMessageEx(iTargetID, COLOR_WHITE, "You cannot join this arena at the moment.");
}*/

RemoveFromJailBoxing(iTargetID)
{
	arrJailBoxingData[GetPVarInt(iTargetID, "_InJailBoxing") - 1][iParticipants]--;

	//DeletePVar(GetPVarInt(iTargetID, "_JailBoxingChallenger"));

	DeletePVar(iTargetID, "_InJailBoxing");
	DeletePVar(iTargetID, "_JailBoxingChallenger");
}

forward StartJailBoxing(iArenaID);
public StartJailBoxing(iArenaID)
{
	new string[60 + MAX_PLAYER_NAME];
	new iRangePoint;

	foreach(Player, i)
	{
		if(GetPVarType(i, "_InJailBoxing") && GetPVarInt(i, "_InJailBoxing") - 1 == iArenaID)
		iRangePoint = i;
		break;
	}

	arrJailBoxingData[iArenaID][iDocBoxingCountdown]--;
	if(arrJailBoxingData[iArenaID][iDocBoxingCountdown] == 0)
	{
		format(string, sizeof(string), "** [Boxing Countdown (Arena:%d)] The bell rings **", iArenaID);
		ProxDetector(10.0, iRangePoint, string, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		arrJailBoxingData[iArenaID][bInProgress] = true;
		KillTimer(arrJailBoxingData[iArenaID][iDocCountDownTimer]);
		arrJailBoxingData[iArenaID][iDocBoxingCountdown] = 4;
	}
	else
	{
		format(string, sizeof(string), "** [Boxing Countdown (Arena:%d)] %d seconds until start! **", iArenaID, arrJailBoxingData[iArenaID][iDocBoxingCountdown]);
		ProxDetector(10.0, iRangePoint, string, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_DOC_CP:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: ShowDocPrisonControls(playerid, 1);
					case 1: ShowDocPrisonControls(playerid, 5);
					case 2: ShowDocPrisonControls(playerid, 4);
					case 3: DocLockdown(playerid);
					case 4: ShowPlayerDialog(playerid, DIALOG_DOC_CP_INT, DIALOG_STYLE_LIST, "Doc Control Pannel - Intercom", "Prison\nYard\nAll", "Select", "Back");
				}
			}
		}
		case DIALOG_DOC_CP_SUB:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: // floor 1
					{
						ShowDocPrisonControls(playerid, 2);
					}
					case 1: // floor 2
					{
						ShowDocPrisonControls(playerid, 3);
					}
					case 2: // all floor 1
					{
						if(bDocCellsFloorOpen[0] == false)
						{
							for(new i = 0; i < 16; i++)
							{
								OpenDocCells(i, 1);
							}
							bDocCellsFloorOpen[0] = true;
						}
						else if(bDocCellsFloorOpen[0] == true)
						{
							for(new i = 0; i < 16; i++)
							{
								OpenDocCells(i, 0);
							}
							bDocCellsFloorOpen[0] = false;
						}
					}
					case 3: // all floor 2
					{
						if(bDocCellsFloorOpen[1] == false)
						{
							for(new i = 16; i < 31; i++)
							{
								OpenDocCells(i, 1);
							}
							bDocCellsFloorOpen[1] = true;
						}
						else if(bDocCellsFloorOpen[1] == true)
						{
							for(new i = 16; i < 31; i++)
							{
								OpenDocCells(i, 0);
							}
							bDocCellsFloorOpen[1] = false;
						}
					}
				}
			}
			else ShowDocPrisonControls(playerid, 0);
		}
		case DIALOG_DOC_CP_AREA:
		{
			if(response)
			{
				if(listitem == 9)
				{
					if(bDocAreaOpen[9] == false) bDocAreaOpen[9] = true;
					else bDocAreaOpen[9] = false;
				}
				else if(listitem == 10)
				{
					if(bDocAreaOpen[10] == false) bDocAreaOpen[10] = true;
					else bDocAreaOpen[10] = false;
				}
				else
				{
					if(bDocAreaOpen[listitem] == false) OpenDocAreaDoors(listitem, 1);
					else OpenDocAreaDoors(listitem, 0);
				}
				ShowDocPrisonControls(playerid, 4);
			}
			else ShowDocPrisonControls(playerid, 0);
		}
		case DIALOG_DOC_CP_C1F1:
		{
			if(response)
			{
				if(bDocCellOpen[listitem] == false) OpenDocCells(listitem, 1);
				else OpenDocCells(listitem, 0);
				ShowDocPrisonControls(playerid, 2);
			}
			else ShowDocPrisonControls(playerid, 1);
		}
		case DIALOG_DOC_CP_C1F2:
		{
			if(response)
			{
				if(bDocCellOpen[listitem + 16] == false) OpenDocCells(listitem + 16, 1);
				else OpenDocCells(listitem + 16, 0);
				ShowDocPrisonControls(playerid, 3);
			}
			else ShowDocPrisonControls(playerid, 1);
		}
		case DIALOG_DOC_CP_INT:
		{
			if(response)
			{
				ShowPlayerDialog(playerid, DIALOG_DOC_CP_INT2, DIALOG_STYLE_INPUT, "DoC Control Panel - Intercom", "Enter your message below:", "Login", "Cancel");
				switch(listitem)
				{
					case 0: SetPVarInt(playerid, "pPrisonIntercom", 1);
					case 1: SetPVarInt(playerid, "pPrisonIntercom", 2);
					case 2: SetPVarInt(playerid, "pPrisonIntercom", 3);
					default: return 0;
				}
			}
		}
		case DIALOG_DOC_CP_INT2:
		{
			if(response)
			{
				new string[256];
				format(string, sizeof(string), "[Intercom] %s: %s", GetPlayerNameEx(playerid), inputtext);
				switch(GetPVarInt(playerid, "pPrisonIntercom"))
				{
					case 1: 
					{
						foreach(new i: Player)
						{
							if(IsPlayerInRangeOfPoint(i, 90.0, 584.2271,1443.5724,6000.4751) || IsPlayerInRangeOfPoint(i, 90.0, 554.5073,1424.2986,11000.4756) && GetPlayerVirtualWorld(i) != 666) 
							{
								SendClientMessageEx(i, COLOR_YELLOW, string); 
							}
						}
						DeletePVar(playerid, "pPrisonIntercom");
					}
					case 2: 
					{
						foreach(new i: Player)
						{
							if(IsPlayerInRangeOfPoint(i, 90.0, 129.0239,1847.9410,17.6697)) 
							{
								SendClientMessageEx(i, COLOR_YELLOW, string); 
							}
						}
						DeletePVar(playerid, "pPrisonIntercom");
					}
					case 3: 
					{
						foreach(new i: Player)
						{
							if(IsPlayerInRangeOfPoint(i, 90.0, 584.2271,1443.5724,6000.4751) || IsPlayerInRangeOfPoint(i, 90.0, 554.5073,1424.2986,11000.4756) && GetPlayerVirtualWorld(i) != 666 || IsPlayerInRangeOfPoint(i, 90.0, 129.0239,1847.9410,17.6697)) 
							{							
								SendClientMessageEx(i, COLOR_YELLOW, string); 
							}
						}
						DeletePVar(playerid, "pPrisonIntercom");
					}
					default: return 0;
				}
			}
		}
		case DIALOG_LOAD_DETAINEES:
		{
			if(response)
			{
				new stpos = strfind(inputtext, "(");
			    new fpos = strfind(inputtext, ")");
			    new prisoneridstr[4], prisonerid;
			    strmid(prisoneridstr, inputtext, stpos+1, fpos);
			    prisonerid = strval(prisoneridstr);

				new	getVW = GetPlayerVirtualWorld(playerid);
				new	getIW = GetPlayerInterior(playerid);
				new	getVeh = GetPlayerVehicleID(playerid);
				new iVehicleSeat = 0;

				for(new i = 1; i < 9; i++)
				{
					if(IsSeatAvailable(getVeh, i))
					{
						iVehicleSeat = i;
						break;
					}
				}
				LoadPrisoner(playerid, prisonerid, getVeh, iVehicleSeat, getVW, getIW);
			}
		}
    	case DIALOG_STAYPRISON:
    	{
        	if(!response)
        	{
            	strcpy(PlayerInfo[playerid][pPrisonReason], "[IC] [DNRL] Prison Gang", 128);
            	SendClientMessageEx(playerid, COLOR_GRAD1, "You have chosen to stay in prison. Use /docrelease if you wish to finish serving your sentence.");
            	PlayerInfo[playerid][pJailTime] = 9999999;
        	}
        	else
        	{
            	ReleasePlayerFromPrison(playerid);
        	}
    	}
    	case DIALOG_PRISONCREDS:
    	{
        	if(response)
        	{
            	switch(listitem)
            	{
           	 		case 5:
                	{
                	    if(PlayerInfo[playerid][pPrisonCredits] >= 10)
                	    {
							PlayerInfo[playerid][pCigar] = 1;
							PlayerInfo[playerid][pPrisonCredits] -= 10;
							PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

							SendClientMessageEx(playerid, COLOR_GREY, "You have purchased some cigarettes from the prison shop for 10 credits.");
						}
					 	else return SendClientMessageEx(playerid, COLOR_GREY, "  You do not have enough prison credits!");
                	}
                	case 0:
                	{
                	    if(PlayerInfo[playerid][pPrisonCredits] >= 5)
						{
                    		if(PlayerInfo[playerid][pDice] >= 1) return SendClientMessageEx(playerid, COLOR_GREY, "You already have a dice!");

							PlayerInfo[playerid][pDice] = 1;
							PlayerInfo[playerid][pPrisonCredits] -= 5;
							PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

							SendClientMessageEx(playerid, COLOR_GREY, "You have purchased a dice from the prison shop for 5 credits.");
						}
						else return SendClientMessageEx(playerid, COLOR_GREY, "  You do not have enough prison credits!");
                	}
                	case 1:
                	{
                	    if(PlayerInfo[playerid][pPrisonCredits] >= 5)
						{
                	    	PlayerInfo[playerid][pPaper] += 1;
							PlayerInfo[playerid][pPrisonCredits] -= 5;
							PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

							SendClientMessageEx(playerid, COLOR_GREY, "You have purchased some paper from the prison shop for 5 credits.");
						}
						else return SendClientMessageEx(playerid, COLOR_GREY, "  You do not have enough prison credits!");
                	}
                	case 6:
                	{
                    	if(PlayerInfo[playerid][pCDPlayer] >= 1) return SendClientMessageEx(playerid, COLOR_GREY, "You already have a MP3!");

                    	if(PlayerInfo[playerid][pPrisonCredits] >= 50)
                    	{
							PlayerInfo[playerid][pCDPlayer] = 1;
							PlayerInfo[playerid][pPrisonCredits] -= 50;
							PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

							SendClientMessageEx(playerid, COLOR_GREY, "You have purchased an MP3 Player from the prison shop for 50 credits.");
						}
						else return SendClientMessageEx(playerid, COLOR_GREY, "  You do not have enough prison credits!");
                	}
                	case 7:
                	{

                    	if(PlayerInfo[playerid][pPrisonCredits] >= 250)
                    	{
                    		SetPVarInt(playerid, "pPrisonSelectingSkin", 1);
							switch(PlayerInfo[playerid][pSex])
							{
	                    		case 1: return ShowModelSelectionMenuEx(playerid, g_aMaleSkins, sizeof(g_aMaleSkins), "Skin Model", PRISON_SKINSELECT, -16.0, 0.0, -55.0);
								case 2: return ShowModelSelectionMenuEx(playerid, g_aFemaleSkins, sizeof(g_aFemaleSkins), "Skin Model", PRISON_SKINSELECT, -16.0, 0.0, -55.0);
               				}
						}
						else return SendClientMessageEx(playerid, COLOR_GREY, "  You do not have enough prison credits!");
                	}
                	case 2:
                	{
                	    if(PlayerInfo[playerid][pPrisonCredits] >= 5)
                	    {
                	        if(GetPVarInt(playerid, "pPrisonSoap") >= 5) return SendClientMessageEx(playerid, COLOR_GREY, "You can only cary five soap at a time!");

							SetPVarInt(playerid, "pPrisonSoap", GetPVarInt(playerid, "pPrisonSoap") + 1); // these need to be added to the db and the enum
							PlayerInfo[playerid][pPrisonCredits] -= 5;
							PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

							SendClientMessageEx(playerid, COLOR_GREY, "You have purchased a bar of soap from the prison shop for 5 credits.");
						}
						else return SendClientMessageEx(playerid, COLOR_GREY, "  You do not have enough prison credits!");
                	}
                	case 3:
                	{
                	    if(PlayerInfo[playerid][pPrisonCredits] >= 5)
                	    {

							SetPVarInt(playerid, "pPrisonSugar", GetPVarInt(playerid, "pPrisonSugar") + 1); // these need to be added to the db and the enum
							PlayerInfo[playerid][pPrisonCredits] -= 5;
							PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

							SendClientMessageEx(playerid, COLOR_GREY, "You have purchased a packet of sugar from the prison shop for 5 credits.");
						}
						else return SendClientMessageEx(playerid, COLOR_GREY, "  You do not have enough prison credits!");
                	}
                	case 4:
                	{
                	    if(PlayerInfo[playerid][pPrisonCredits] >= 5)
                	    {
                	        if(GetPVarInt(playerid, "pPrisonBread") >= 1) return SendClientMessageEx(playerid, COLOR_GREY, "You can only carry one loaf of bread at a time!");

							SetPVarInt(playerid, "pPrisonBread", 1); // these need to be added to the db and the enum
							PlayerInfo[playerid][pPrisonCredits] -= 10;
							PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

							SendClientMessageEx(playerid, COLOR_GREY, "You have purchased a loaf of bread from the prison shop for 10 credits.");
						}
						else return SendClientMessageEx(playerid, COLOR_GREY, "  You do not have enough prison credits!");
                	}
            	}
			}
        }
	}
	return 1;
}

CMD:bail(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0)
	{
		if(PlayerInfo[playerid][pBailPrice] > 0)
		{
			if(GetPlayerCash(playerid) > PlayerInfo[playerid][pBailPrice])
			{
				new string[128];

				format(string, sizeof(string), "You bailed yourself out for $%d.", PlayerInfo[playerid][pBailPrice]);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				GivePlayerCash(playerid, -PlayerInfo[playerid][pBailPrice]);
				PlayerInfo[playerid][pBailPrice] = 0;
				WantLawyer[playerid] = 0; CallLawyer[playerid] = 0;
				PlayerInfo[playerid][pJailTime] = 1;

				format(string, sizeof string, "%s has bailed themselves out for $%s.", GetPlayerNameEx(playerid), number_format(PlayerInfo[playerid][pBailPrice]));
 				GroupLog(2, string); // Prison Group ID (September 2015).
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "You can't afford the bail price.");
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a bail price.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in jail.");
	}
	return 1;
}

CMD:docarrest(playerid, params[])
{
	if(!IsACop(playerid)) SendClientMessageEx(playerid, COLOR_GREY, "You are not part of a LEO faction. ");
	else if(!IsAtArrestPoint(playerid, 2)) SendClientMessageEx(playerid, COLOR_GREY, "You are not at the DoC Prison arrest point." );

	else
	{
   		new
     		//moneys,
       		//time,
			string[256];

        new suspect = GetClosestPlayer(playerid);
  		/*if(sscanf(params, "dddd", moneys, time)) SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docarrest [fine] [minutes]");
		else if(!(1 <= moneys <= 250000)) SendClientMessageEx(playerid, COLOR_GREY, "The jail fine can't be below $1 or above $250,000.");
		else if(!(1 <= time <= 120)) SendClientMessageEx(playerid, COLOR_GREY, "Jail time can't be below 1 or above 120 minutes - take the person to prison for more time.");*/
		if(!IsPlayerConnected(suspect)) SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		else if(!ProxDetectorS(5.0, playerid, suspect)) SendClientMessageEx(playerid, COLOR_GREY, "You are close enough to the suspect.");
		else if(PlayerInfo[suspect][pWantedLevel] < 1 && PlayerInfo[playerid][pMember] != 12) SendClientMessageEx(playerid, COLOR_GREY, "The person must have a wanted level of at least one star.");
		else {
			SetPVarInt(playerid, "Arrest_Price", PlayerInfo[suspect][pWantedJailFine]);
			SetPVarInt(playerid, "Arrest_Time", PlayerInfo[suspect][pWantedJailTime]);
			SetPVarInt(playerid, "Arrest_Bail", 1);
			SetPVarInt(playerid, "Arrest_BailPrice", PlayerInfo[suspect][pWantedJailFine]*2);
			SetPVarInt(playerid, "Arrest_Suspect", suspect);
			SetPVarInt(playerid, "Arrest_Type", 2);
			format(string, sizeof(string), "Please write a brief arrest report on how %s acted during the arrest.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(suspect));
			ShowPlayerDialog(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", string, "Submit", "");
	    }
	}
	return 1;
}

CMD:arrest(playerid, params[])
{
	if(!IsACop(playerid)) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You are not part of a LEO faction. ");
	}
	else if(!IsAtArrestPoint(playerid, 0) && !IsAtArrestPoint(playerid, 1)) {
 		SendClientMessageEx(playerid, COLOR_GREY, "You are not at a arrest point." );
 	}

	else {


   		new
			string[256];

        new suspect = GetClosestPlayer(playerid);
		if(!IsPlayerConnected(suspect)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		}
		else if(!ProxDetectorS(5.0, playerid, suspect)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "You are not close enough to the suspect.");
		}
		else if(PlayerInfo[suspect][pWantedLevel] < 1 && !IsAJudge(playerid)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "The person must have a wanted level of at least one star.");
		}
		else {
			SetPVarInt(playerid, "Arrest_Price", PlayerInfo[suspect][pWantedJailFine]);
			SetPVarInt(playerid, "Arrest_Time", PlayerInfo[suspect][pWantedJailTime]);
			SetPVarInt(playerid, "Arrest_Bail", 1);
			SetPVarInt(playerid, "Arrest_BailPrice", PlayerInfo[suspect][pWantedJailFine]*2);
			SetPVarInt(playerid, "Arrest_Suspect", suspect);
			SetPVarInt(playerid, "Arrest_Type", 0);
			format(string, sizeof(string), "Please write a brief arrest report on how %s acted during the arrest.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(suspect));
			ShowPlayerDialog(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", string, "Submit", "");
	    }
	}
	return 1;
}

CMD:listprisoners(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new szInmates[1024],
		szString[20],
		id;
	if(sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /listprisoners [arrestpoint id]");
	foreach(Player, i)
	{
		if((GetPVarInt(i, "ArrestPoint") == id + 1) && PlayerInfo[i][pJailTime] > 0)
		{
			format(szInmates, sizeof(szInmates), "%s\n* [%d] Prisoner Name: %s", szInmates, i, GetPlayerNameEx(i));
		}
	}
	if(strlen(szInmates) == 0) format(szInmates, sizeof(szInmates), "Holding cell empty!");
	format(szString, sizeof(szString), "Holding Cell %d", id);
	ShowPlayerDialog(playerid, DIALOG_DOC_INMATES, DIALOG_STYLE_LIST, szString, szInmates, "Close", "");

	return 1;
}

CMD:inmates(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	ListInmates(playerid);
	return 1;
}

ListInmates(playerid)
{
	new szInmates[2000], IsoString[24], BailString[50], TimeString[50];

	foreach(Player, i)
	{
		if(PlayerInfo[i][pJailTime] > 0 && strfind(PlayerInfo[i][pPrisonReason], "[IC]", true) != -1)
		{
			if(PlayerInfo[i][pIsolated] >= 1) 
			{
				if(GetPlayerVirtualWorld(i) == 666) {
					format(IsoString, sizeof(IsoString), "[OOC-ISO] ");
				}
				else { format(IsoString, sizeof(IsoString), "[ISO] "); }
			}
			else format(IsoString, sizeof(IsoString), "");

			if(PlayerInfo[i][pBailPrice]) 
			{
				format(BailString, sizeof(BailString), "| Bail: $%s", number_format(PlayerInfo[i][pBailPrice]));
			}
			else format(BailString, sizeof(BailString), "", number_format(PlayerInfo[i][pBailPrice]));

			if(strfind(PlayerInfo[i][pPrisonReason], "[DNRL]", true) != -1)
			{
				format(TimeString, sizeof(TimeString), "Lifetime");
			}
			else format(TimeString, sizeof(TimeString), "%s", TimeConvert(PlayerInfo[i][pJailTime]));

			format(szInmates, sizeof(szInmates), "%s\n* %s%s: %s | Cell: %d | Credits: %d %s", szInmates, IsoString, GetPlayerNameEx(i), TimeString, PlayerInfo[i][pPrisonCell], PlayerInfo[i][pPrisonCredits], BailString);
		}
	}
	if(strlen(szInmates) == 0) format(szInmates, sizeof(szInmates), "No inmates");
	ShowPlayerDialog(playerid, DIALOG_DOC_INMATES, DIALOG_STYLE_LIST, "DOC Inmates Logbook", szInmates, "Close", "");
}

CMD:loadprisoners(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	if(GetArrestPointID(playerid) == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a arrest point.");
	new	getVeh = GetPlayerVehicleID(playerid);

	if(GetVehicleModel(getVeh) == 431 || GetVehicleModel(getVeh) == 427)
	{
		ListDetainees(playerid);
	}
	else SendClientMessage(playerid, COLOR_WHITE, "You need to be in a bus to transport prisoners.");
	return 1;
}

CMD:deliverinmates(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	if(!IsPlayerInRangeOfPoint(playerid, 4, -2053.6279,-198.0207,15.0703)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the doc delivery point");
	foreach(Player, i)
	{
		if(IsPlayerInVehicle(i, GetPlayerVehicleID(playerid)) && GetPlayerVehicleSeat(i) != 0)
		{
			new rand = random(sizeof(DocPrison));
			SetPlayerFacingAngle(i, 0);
			SetPlayerPos(i, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
			DeletePVar(i, "IsFrozen");
			TogglePlayerControllable(i, 1);
			SetPlayerInterior(i, 10);
			SetPlayerVirtualWorld(i, 0);
			PlayerInfo[i][pVW] = 0;
			Player_StreamPrep(i, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);
		}
	}
	return 1;
}

CMD:getinmatefood(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 8, 555.8644,1485.1359,6000.4258))
	{
		new string[64];
		if(GetPVarInt(playerid, "inmatefood") < 5)
		{
			SetPVarInt(playerid, "inmatefood", 5);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			SetPlayerAttachedObject(playerid, 9, 2767, 6, 0.195999, 0.042999, -0.191, -108.6, 168.6, -83.4999);
			format(string, sizeof(string), "* %s has picked up a food tray.", GetPlayerNameEx(playerid));
			ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You cannot carry anymore food on your tray.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not at the Prison Cafe!");
	return 1;
}

CMD:dropfoodtray(playerid, params[])
{
	new string[64];
	if(GetPVarInt(playerid, "inmatefood") > 0 || GetPVarInt(playerid, "carryingfood") > 0)
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		RemovePlayerAttachedObject(playerid, 9);
		format(string, sizeof(string), "* %s has dropped their food tray.", GetPlayerNameEx(playerid));
		ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		DeletePVar(playerid, "inmatefood");
		DeletePVar(playerid, "carryingfood");
		DeletePVar(playerid, "OfferedMealTo");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You do not have a foodtray with food on it.");
	}
	return 1;
}

CMD:offerinmatefood(playerid, params[])
{
	new iGiveTo,
		string[92];
	if(sscanf(params, "u", iGiveTo)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /offerinmatefood [playerid]");
	else if(iGiveTo == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot offer yourself food.");
	else if(!IsPlayerConnected(iGiveTo)) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not connected");
	//else if(GetPVarInt(playerid, "OfferingMeal") == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You may only offer food to one person at a time.");
	else if(!PlayerInfo[iGiveTo][pJailTime]) return SendClientMessageEx(playerid, COLOR_WHITE, "You may only offer food to prison inmates.");
	else if(!GetPVarInt(playerid, "inmatefood")) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have any prison food to offer.");
	else if(ProxDetectorS(5.0, playerid, iGiveTo))
	{
		if(GetPVarInt(playerid, "OfferingMeal") == 1) { // added as a bug report fix
			new iOfferingToOld = GetPVarInt(playerid, "OfferedMealTo");
			DeletePVar(iOfferingToOld, "OfferedMeal");
			DeletePVar(iOfferingToOld, "OfferedMealBy");
			DeletePVar(playerid, "OfferingMeal");
			DeletePVar(playerid, "OfferedMealTo");
		}

		SetPVarInt(iGiveTo, "OfferedMeal", 1);
		SetPVarInt(iGiveTo, "OfferedMealBy", playerid);
		SetPVarInt(playerid, "OfferingMeal", 1);
		SetPVarInt(playerid, "OfferedMealTo", iGiveTo);
		format(string, sizeof(string), "%s has offered you a meal. Type /acceptjailfood to take it.", GetPlayerNameEx(playerid));
		SendClientMessageEx(iGiveTo, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s some prisoner food", GetPlayerNameEx(iGiveTo));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not in range of that player.");
	return 1;
}

CMD:acceptjailfood(playerid, params[])
{
	new iOffering = GetPVarInt(playerid, "OfferedMealBy"),
		string[101];
	if(GetPVarInt(playerid, "OfferedMeal") == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "No one offered you a meal.");
	else if(!IsPlayerConnected(GetPVarInt(playerid, "OfferedMealBy"))) return SendClientMessageEx(playerid, COLOR_WHITE, "The person offering you food has disconnected.");
	else if(ProxDetectorS(5.0, playerid, iOffering))
	{
		if(PlayerInfo[playerid][pHunger] <= 100)
		{
			PlayerInfo[playerid][pHunger] += 33;
			if(PlayerInfo[playerid][pHunger] > 100) PlayerInfo[playerid][pHunger] = 100;
			if (PlayerInfo[playerid][pFitness] >= 3)
			{
				PlayerInfo[playerid][pFitness] -= 3;
			}
			else
			{
				PlayerInfo[playerid][pFitness] = 0;
			}
		}
		SetPVarInt(iOffering, "inmatefood", GetPVarInt(iOffering, "inmatefood") - 1);
		if(!GetPVarInt(iOffering, "inmatefood")) {
			RemovePlayerAttachedObject(iOffering, 9);
			SetPlayerSpecialAction(iOffering, SPECIAL_ACTION_NONE);
		}
		DeletePVar(playerid, "OfferedMeal");
		DeletePVar(playerid, "OfferedMealBy");
		DeletePVar(iOffering, "OfferingMeal");
		DeletePVar(iOffering, "OfferedMealTo");
		format(string, sizeof(string), "* %s takes a plate of food from %s and begins to eat it.", GetPlayerNameEx(playerid), GetPlayerNameEx(iOffering));
		ProxChatBubble(playerid, string);
		ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		//PlayAnimEx(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 0, 4000, 1);
		PlayAnimEx(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 1, 0, 0);
		SetTimerEx("ClearAnims", 3000, false, "d", playerid);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not in range of the person offering you food.");
	return 1;
}

CMD:getfood(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 8, 555.8644,1485.1359,6000.4258))
	{
		new string[94];
		if(GetPVarInt(playerid, "carryingfood") < 1)
		{
			SetPVarInt(playerid, "carryingfood", 1);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			SetPlayerAttachedObject(playerid, 9, 2767, 6, 0.195999, 0.042999, -0.191, -108.6, 168.6, -83.4999);
			format(string, sizeof(string), "* %s reaches towards the counter, grabbing a tray of food.", GetPlayerNameEx(playerid));
			ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You cannot carry anymore food on your tray.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not at the Prison Cafe!");
	return 1;
}

CMD:eatfood(playerid, params[])
{
	if(GetPVarInt(playerid, "carryingfood") == 1)
	{
		new string[94];
		if(PlayerInfo[playerid][pHunger] <= 100)
		{
			PlayerInfo[playerid][pHunger] += 33;
			if(PlayerInfo[playerid][pHunger] > 100) PlayerInfo[playerid][pHunger] = 100;
			if (PlayerInfo[playerid][pFitness] >= 3)
			{
				PlayerInfo[playerid][pFitness] -= 3;
			}
			else
			{
				PlayerInfo[playerid][pFitness] = 0;
			}
		}
		format(string, sizeof(string), "* %s grabs the food from the tray and eats it.", GetPlayerNameEx(playerid));
		ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		DeletePVar(playerid, "carryingfood");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		PlayAnimEx(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 1, 0, 0);
		SetTimerEx("ClearAnims", 3000, false, "d", playerid);
		RemovePlayerAttachedObject(playerid, 9);

	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not carrying a food tray");
	return 1;
}

CMD:extendsentence(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new iTargetID,
		iExtended,
		string[64];
	if(sscanf(params, "ud", iTargetID, iExtended)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /extendsentence [playerid] [percentage to extend (1 - 30)]");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[IC]", true) == -1)  return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in IC Jail.");
	else if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is not connected.");
	else if(iTargetID == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You cannot use this command on yourself.");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[EXT]", true) != -1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player has already had their time extended.");
	else if(iExtended >= 1 && iExtended <= 30)
	{
		new StartJail = PlayerInfo[iTargetID][pJailTime];
		new Float:EndJail;
		new Float:Manip;
		Manip = 1.0 + (float(iExtended) / 100);
		EndJail = StartJail * Manip;
		PlayerInfo[iTargetID][pJailTime] = floatround(EndJail);
		format(string, sizeof(string), "Your jail time has been extended by %s by %d percent.", GetPlayerNameEx(playerid), iExtended);
		SendClientMessageEx(iTargetID, COLOR_RED, string);
		format(string, sizeof(string), "You have extended %s's jail sentence by %d percent.", GetPlayerNameEx(iTargetID), iExtended);
		SendClientMessageEx(playerid, COLOR_RED, string);
		format(string, sizeof(string), "Original Time: %s ------ New Time: %s", TimeConvert(StartJail), TimeConvert(PlayerInfo[iTargetID][pJailTime]));
		SendClientMessageEx(playerid, COLOR_RED, string);
		strcat(PlayerInfo[iTargetID][pPrisonReason], "[EXT]", 128);

		format(string, sizeof string, "%s has extended %s's sentence by %d percent. (Original: %s, New: %s)", GetPlayerNameEx(playerid), GetPlayerNameExt(iTargetID), iExtended, TimeConvert(StartJail), TimeConvert(PlayerInfo[iTargetID][pJailTime]));
 		GroupLog(PlayerInfo[playerid][pMember], string);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: The extension percentage cannot be less than 1 or greater than 10.");
	return 1;
}

CMD:reducesentence(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new iTargetID,
		iReduce,
		string[64];
	if(sscanf(params, "ud", iTargetID, iReduce)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /reducesentence [playerid] [percentage to reduce (1 - 30)]");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[IC]", true) == -1)  return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in IC Jail.");
	else if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is not connected.");
	else if(iTargetID == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You cannot use this command on yourself.");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[RED]", true) != -1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player has already had their time reduced.");
	else if(iReduce >= 1 && iReduce <= 30)
	{
		new StartJail = PlayerInfo[iTargetID][pJailTime];
		new Float:EndJail;
		new Float:Manip;
		Manip = 1.0 - (float(iReduce) / 100);
		EndJail = StartJail * Manip;
		PlayerInfo[iTargetID][pJailTime] = floatround(EndJail);
		format(string, sizeof(string), "Your jail time has been reduced by %s by %d percent.", GetPlayerNameEx(playerid), iReduce);
		SendClientMessageEx(iTargetID, COLOR_RED, string);
		format(string, sizeof(string), "You have reduced %s's jail sentence by %d percent.", GetPlayerNameEx(iTargetID), iReduce);
		SendClientMessageEx(playerid, COLOR_RED, string);
		format(string, sizeof(string), "Original Time: %s ------ New Time: %s", TimeConvert(StartJail), TimeConvert(PlayerInfo[iTargetID][pJailTime]));
		SendClientMessageEx(playerid, COLOR_RED, string);
		strcat(PlayerInfo[iTargetID][pPrisonReason], "[RED]", 128);

		format(string, sizeof string, "%s has reduced %s's sentence by %d percent. (Original: %s, New: %s)", GetPlayerNameEx(playerid), GetPlayerNameExt(iTargetID), iReduce, TimeConvert(StartJail), TimeConvert(PlayerInfo[iTargetID][pJailTime]));
 		GroupLog(PlayerInfo[playerid][pMember], string);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: The reduction percentage cannot be less than 1 or greater than 10.");

	return 1;
}

CMD:isolateinmate(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new iTargetID,
		iCellID,
		string[128];

	if(sscanf(params, "ud", iTargetID, iCellID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /isolateinmate [playerid] [cellid]");
	else if(iTargetID == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You cannot use this command on yourself.");
	else if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is not connected.");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in IC Jail.");
	else if(!(0 <= iCellID < sizeof(DocIsolation))) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Valid Isolation Cells [0-24]");
	else if(PlayerInfo[iTargetID][pIsolated] == 0)
	{
		DocIsolate(iTargetID, iCellID, 0);

		format(string, sizeof(string), "You have been sent to isolation by %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have sent %s to isolation.", GetPlayerNameEx(iTargetID));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

		format(string, sizeof string, "%s has sent %s to isolation.", GetPlayerNameEx(playerid), GetPlayerNameExt(iTargetID));
 		GroupLog(PlayerInfo[playerid][pMember], string);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is already in isolation.");

	return 1;
}

CMD:unisolateinmate(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new iTargetID,
		string[128];

	if(sscanf(params, "u", iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /unisolateinmate [playerid]");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in IC Jail");
	else if(iTargetID == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You cannot use this command on yourself.");
	else if(PlayerInfo[iTargetID][pIsolated] == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in isolation");
	else if(IsPlayerConnected(iTargetID))
	{
		PlayerInfo[iTargetID][pIsolated] = 0;

		format(string, sizeof(string), "You have been released from isolation by %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have released %s from isolation.", GetPlayerNameEx(iTargetID));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

		format(string, sizeof string, "%s has brought %s back from isolation.", GetPlayerNameEx(playerid), GetPlayerNameExt(iTargetID));
 		GroupLog(PlayerInfo[playerid][pMember], string);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is not connected.");
	return 1;
}

/*CMD:joinjailboxing(playerid, params[])
{
	if(IsPlayerAtJailBoxing(playerid))
	{
		if(GetPVarInt(playerid, "_InJailBoxing") != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're already in a boxing arena. Use /leavejailboxing to leave.");
		else if(arrJailBoxingData[GetClosestJailBoxingRing(playerid)][bInProgress] == true) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are unable to join a boxing match that is in progress.");
		else SetPlayerIntoJailBoxing(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in range of a jail boxing ring.");

	return 1;
}

CMD:leavejailboxing(playerid, params[])
{
	if(GetPVarInt(playerid, "_InJailBoxing") == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a boxing arena. Please use /joinjailboxing to join one.");
	else if(arrJailBoxingData[GetClosestJailBoxingRing(playerid)][bInProgress] == true) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are unable to leave a boxing match that is in progress.");
	else
	{
		RemoveFromJailBoxing(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have withdrawn yourself from the boxing arena queue.");
	}
	return 1;
}*/

/*CMD:startbrawl(playerid, params[])
{
	new iTargetID,
		string[MAX_PLAYER_NAME + 35];

	if(sscanf(params, "u", iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /startbrawl [playerid]");
	else if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "You must be in IC jail to do this.");
	else if(!ProxDetectorS(8.0, playerid, iTargetID)) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in range of that player.");
	else if(IsPlayerConnected(iTargetID))
	{
		SetPVarInt(playerid, "_InJailBrawl", iTargetID + 1);
		SetPVarInt(iTargetID, "_InJailBrawl", playerid + 1);

		format(string, sizeof(string), "You have initiated a brawl with %s", GetPlayerNameEx(iTargetID));
		SendClientMessageEx(playerid, COLOR_RED, string);

		format(string, sizeof(string), "%s has initiated a brawl with you", GetPlayerNameEx(playerid));
		SendClientMessageEx(iTargetID, COLOR_RED, string);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");

	return 1;
}*/

CMD:docjudgesubpoena(playerid, params[])
{
	new iTargetID,
		szCaseName[128],
		szString[128];

	if(sscanf(params, "us[128]", iTargetID, szCaseName)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docjudgesubpoena [playerid] [case reason]");
	if(!IsPlayerConnected(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "ERROR: That player is not connected");
	if(!IsPlayerInRangeOfPoint(playerid, 15, 525.86, 1427.05, 11001.28)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the DOC courthouse to use this");
	else if(IsAJudge(playerid))
	{
		format(szString, sizeof(szString), "You have subpoenaed %s. Case: %s", GetPlayerNameEx(iTargetID), szCaseName);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szString);

		format(szString, sizeof(szString), "You have been subpoenaed by %s. Case %s", GetPlayerNameEx(playerid), szCaseName);
		SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szString);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You must be a judge to use this command");
	return 1;
}

CMD:docjudgecharge(playerid, params[])
{
	new iTargetID,
		iTime,
		iFine,
		szCountry[5],
		szReason[128],
		szCrime[128],
		szMessage[128];

	if(sscanf(params, "udds[128]", iTargetID, iTime, iFine, szReason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docjudgecharge [playerid] [time] [fine] [reason]");
	if(!IsPlayerInRangeOfPoint(playerid, 15, 525.86, 1427.05, 11001.28)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the DOC courthouse to use this");
	if(!IsPlayerConnected(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "ERROR: That player is not connected");
	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a judge to use this command");
	if(ProxDetectorS(14.0, playerid, iTargetID))
	{
		PlayerInfo[iTargetID][pWantedJailTime] += iTime;
		PlayerInfo[iTargetID][pWantedJailFine] += iFine;
		if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 1)
		{
			format(szCountry, sizeof(szCountry), "[SA] ");
		}
		else if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2)
		{
			format(szCountry, sizeof(szCountry), "[TR] ");
		}
		strcat(szCrime, szCountry);
		strcat(szCrime, szReason);
		AddCrime(playerid, iTargetID, szCrime);

		format(szMessage, sizeof(szMessage), "You've commited a crime ( %s ). Reporter: %s.", szCrime, GetPlayerNameEx(playerid));
		SendClientMessageEx(iTargetID, COLOR_LIGHTRED, szMessage);

		format(szMessage, sizeof(szMessage), "Current wanted level: %d", PlayerInfo[iTargetID][pWantedLevel]);
		SendClientMessageEx(iTargetID, COLOR_YELLOW, szMessage);

		format(szMessage, sizeof(szMessage), "You have charged %s with a crime.", GetPlayerNameEx(iTargetID));
		SendClientMessage(playerid, COLOR_LIGHTRED, szMessage);

		format(szMessage, sizeof(szMessage), "%s: Time: %i minutes. Fine: %i", szCrime, iTime, iFine);
		SendClientMessage(playerid, COLOR_LIGHTRED, szMessage);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You must be in range of that player");
	return 1;
}

CMD:docjudgesentence(playerid, params[])
{
	new iSuspect,
		string[256];

	if(sscanf(params, "u", iSuspect)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docjudgesentence [suspect]");
	if(!IsPlayerInRangeOfPoint(playerid, 15, 525.86, 1427.05, 11001.28)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the DOC courthouse to use this");
	if(!IsPlayerConnected(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "ERROR: That player is not connected");
	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a judge to use this command");
	if(ProxDetectorS(14.0, playerid, iSuspect))
	{
		SetPVarInt(playerid, "Arrest_Price", PlayerInfo[iSuspect][pWantedJailFine]);
		SetPVarInt(playerid, "Arrest_Time", PlayerInfo[iSuspect][pWantedJailTime]);
		SetPVarInt(playerid, "Arrest_Suspect", iSuspect);
		SetPVarInt(playerid, "Arrest_Type", 3);
		format(string, sizeof(string), "Please write a brief report on how %s acted during the process.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(iSuspect));
		ShowPlayerDialog(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", string, "Submit", "");
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You must be in range of that player");

	return 1;
}

CMD:jailcuff(playerid, params[])
{
	if(IsACop(playerid))
	{
		if(GetPVarInt(playerid, "Injured") == 1 || GetPVarInt(playerid, "jailcuffs") > 0 || PlayerCuffed[ playerid ] >= 1 || PlayerInfo[ playerid ][ pJailTime ] > 0 || PlayerInfo[playerid][pHospital] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You can't do this right now.");
			return 1;
		}

		if(PlayerInfo[playerid][pHasCuff] < 1)
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "You do not have any pair of cuffs on you!");
		    return 1;
		}

		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /jailcuff [player]");
		if(IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot cuff yourself!"); return 1; }
				if(GetPlayerSpecialAction(giveplayerid) == SPECIAL_ACTION_HANDSUP || PlayerCuffed[giveplayerid] == 1 || GetPVarInt(playerid, "pBagged") >= 1)
				{
					format(string, sizeof(string), "* You have been handcuffed by %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* You handcuffed %s, till uncuff.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* %s handcuffs %s, tightening the cuffs securely.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					GameTextForPlayer(giveplayerid, "~r~Cuffed", 2500, 3);
					ClearAnimations(giveplayerid);
					TogglePlayerControllable(giveplayerid, 0);
					SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_CUFFED);
					TogglePlayerControllable(giveplayerid, 1);
					SetPVarInt(giveplayerid, "jailcuffs", 1);
				}
				else if(GetPVarType(giveplayerid, "IsTackled"))
				{
				    format(string, sizeof(string), "* %s removes a set of cuffs from his belt and attempts to cuff %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					SetTimerEx("CuffTackled", 4000, 0, "ii", playerid, giveplayerid);
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "That person isn't restrained!");
					return 1;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not a law enforcement officer.");
	}
	return 1;
}

// WINTERFIELD: VERSION .278 PRISON SYSTEM

CMD:prisonhelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_WHITE, "-------------------------------------------------------------------------------------------------------------------------------------");
 	SendClientMessageEx(playerid, COLOR_GREY, "GENERAL: /prisonhelp, /getfood, /eatfood, /dropfoodtray, /acceptinmatefood, /jailcall, /jailhangup, /prisoncraft, /prisoninv(entory)");
 	if(strfind(PlayerInfo[playerid][pPrisonReason], "[DNRL]", true) != -1) { SendClientMessageEx(playerid, COLOR_GREY, "LIFE SENTENCE: /docrelease"); }
 	if(IsADocGuard(playerid)) { 
 		SendClientMessageEx(playerid, COLOR_GREY, "GUARD:	/reducesentence, /extendsentence, /(jail)cuff, /(get)(offer)inmatefood, /listprisoners, /inmates, /acceptrelease"); 
 		SendClientMessageEx(playerid, COLOR_GREY, "GUARD:	/denyrelease, /beanbag, /(un)isolateinmate, /oocisolateinmate, /loadinmates, /deliverinmates, /giveprisoncredits"); 
 	}
 	if(IsADocGuard(playerid) && PlayerInfo[playerid][pLeader] != INVALID_GROUP_ID) { 
 		SendClientMessageEx(playerid, COLOR_GREY, "LEADER:	/setbail, /takeprisoncredits, /changeinmatecell, /prisonermotd"); 
 	}
  	if(IsAJudge(playerid)) { SendClientMessageEx(playerid, COLOR_GREY, "JUDGE:	/docjudgesentence, /docjudgecharge, /docjudgesubpoena"); }
   	if(GetPVarInt(playerid, "pPrisonShank") >= 1) { SendClientMessageEx(playerid, COLOR_GREY, "SHANK:	/shank - increases damage upon punching. | usable 15 times before 'breaking.'"); }
   	if(GetPVarInt(playerid, "pPrisonCellChisel") >= 1) { SendClientMessageEx(playerid, COLOR_GREY, "CELL:	/prisoncelldeposit, /prisoncellwithdraw"); }
   	if(GetPVarInt(playerid, "pPrisonWine") >= 1 || GetPVarInt(playerid, "pPrisonMWine") >= 1) { SendClientMessageEx(playerid, COLOR_GREY, "WINE:	/prisonfinishwine, /prisondrinkwine - increases damage upon punching. | forces drunk walk."); }
    SendClientMessageEx(playerid, COLOR_WHITE, "-------------------------------------------------------------------------------------------------------------------------------------");
	return 1;
}

CMD:beanbag(playerid, params[])
{
    if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");

    if(GetPlayerWeapon(playerid) == 25)
    {
        new string[128];
    	if(GetPVarInt(playerid, "pBeanBag") >= 1)
    	{
            format(string, sizeof string, "{FF8000}* {C2A2DA}%s loads their shotgun with live action rounds.", GetPlayerNameEx(playerid));
    		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
    		format(string, sizeof string, "{FF8000}> {C2A2DA}%s loads their shotgun with live action rounds.", GetPlayerNameEx(playerid));
    		SendClientMessage(playerid, COLOR_PURPLE, string);

    		SetPVarInt(playerid, "pBeanBag", 0);
    	}
    	else
    	{
    		format(string, sizeof string, "{FF8000}* {C2A2DA}%s loads their shotgun with beanbag rounds.", GetPlayerNameEx(playerid));
    		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
    		format(string, sizeof string, "{FF8000}> {C2A2DA}%s loads their shotgun with beanbag rounds.", GetPlayerNameEx(playerid));
    		SendClientMessage(playerid, COLOR_PURPLE, string);

    		SetPVarInt(playerid, "pBeanBag", 1);
    	}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You need to equip a shotgun!");
	return 1;
}

CMD:giveprisoncredits(playerid, params[]) // these NEED to show up on /frisk and /inv (only when the player is in prison)
{
	new id, amount, string[128];
    if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
    if(strfind(PlayerInfo[id][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_GREY, "This player is not in prison!");

    if(sscanf(params, "ud", id, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givepcredits [playerid] [amount]");
    if(!(0 < amount < 51)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount (1 - 50).");

    if (ProxDetectorS(16.0, playerid, id))
    {
        if(GetPVarInt(playerid, "pGivePCred") < gettime())
        {
    		format(string, sizeof string, "{FF8000}* {C2A2DA}%s has handed %s some prison credits.", GetPlayerNameEx(playerid), GetPlayerNameEx(id));
    		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
    		SendClientMessage(playerid, COLOR_PURPLE, string);
			PlayerInfo[id][pPrisonCredits] += amount; // these need to be added to the db and the enum

			SetPVarInt(playerid, "pGivePCred", gettime() + 10);

			format(string, sizeof string, "%s has gifted %s %d prison credits.", GetPlayerNameEx(playerid), GetPlayerNameEx(id), amount);
			GroupLog(PlayerInfo[playerid][pMember], string);
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "  You must wait 10 seconds between each prison credit transaction.");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "  You must be near this player.");
    return 1;
}

CMD:takeprisoncredits(playerid, params[])
{
	new id, amount, string[128];
    if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
    if(PlayerInfo[playerid][pLeader] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a group leader.");

    if(sscanf(params, "ud", id, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /takepcredits [playerid] [amount]");
    if(!(0 < amount < 100)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount (1 - 100).");
    if(amount > PlayerInfo[id][pPrisonCredits]) return SendClientMessageEx(playerid, COLOR_GRAD1, "  They don't have that many.");
    if(strfind(PlayerInfo[id][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_GREY, "This player is not in prison!");

    if (ProxDetectorS(16.0, playerid, id))
    {
    	if(GetPVarInt(playerid, "pGivePCred") < gettime())
        {
    		format(string, sizeof string, "{FF8000}* {C2A2DA}%s has taken some of %s's prison credits.", GetPlayerNameEx(playerid), GetPlayerNameEx(id));
    		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
    		SendClientMessage(playerid, COLOR_PURPLE, string);
			PlayerInfo[id][pPrisonCredits] -= amount; // these need to be added to the db and the enum

			SetPVarInt(playerid, "pGivePCred", gettime() + 10);

			format(string, sizeof string, "%s has taken %d prison credits from %s.", GetPlayerNameEx(playerid), amount, GetPlayerNameEx(id));
			GroupLog(PlayerInfo[playerid][pMember], string);
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "  You must wait 10 seconds between each prison credit transaction.");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "  You must be near this player.");
    return 1;
}

CMD:changeinmatecell(playerid, params[])
{
	new id, amount;
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
    if(PlayerInfo[playerid][pLeader] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a group leader.");
	if(sscanf(params, "ud", id, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /changeinmatecell [playerid] [cell]");
	if(!(-1 < amount < 30)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount (0 - 29).");
	if(PlayerInfo[id][pIsolated] >= 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't change the cell of an insolated inmate.");
	if(strfind(PlayerInfo[id][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_GREY, "This player is not in prison!");

	PlayerInfo[id][pPrisonCell] = amount;

	format(szMiscArray, sizeof(szMiscArray), "You have set %s's cell to: %d", GetPlayerNameEx(id), amount);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "Your cell has been set to %d by %s", amount, GetPlayerNameEx(playerid));
	SendClientMessageEx(id, COLOR_YELLOW, szMiscArray);

	format(szMiscArray, sizeof szMiscArray, "%s has set %s's bail price to $%s.", GetPlayerNameEx(playerid), GetPlayerNameEx(id), PlayerInfo[id][pPrisonCell]);
 	GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
	return 1;
}

CMD:setbail(playerid, params[]) { // Can no longer set negative bail prices & bail price deducted significantly.

	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in DoC to use this command.");
	if(PlayerInfo[playerid][pLeader] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GREY, "  You must be a group leader.");

	new uPlayer,
		iBail;

	if(strfind(PlayerInfo[uPlayer][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_GREY, "This player is not in prison!");
	if(sscanf(params, "dd", uPlayer, iBail)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /setbail [player] [amount]");

	if(!(0 < iBail <= 15000000)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount ($1 - $15,000,000).");

	PlayerInfo[uPlayer][pBailPrice] = iBail;

	format(szMiscArray, sizeof(szMiscArray), "You have set %s's bail to: $%s", GetPlayerNameEx(uPlayer), number_format(iBail));
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "Your bail has been set to $%s by %s", number_format(iBail), GetPlayerNameEx(playerid));
	SendClientMessageEx(uPlayer, COLOR_YELLOW, szMiscArray);

	format(szMiscArray, sizeof szMiscArray, "%s has set %s's bail price to $%s.", GetPlayerNameEx(playerid), GetPlayerNameEx(uPlayer), number_format(PlayerInfo[uPlayer][pBailPrice]));
 	GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
	return 1;
}


CMD:shank(playerid, params[])
{
    if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1)
    {
        if(GetPVarInt(playerid, "pPrisonShank") >= 1)
        {
            new string[156];
            if(GetPVarInt(playerid, "pPrisonShankOut") == 1)
            {
                format(string, sizeof string, "{FF8000}> {C2A2DA}%s secretly holsters a prison shank.", GetPlayerNameEx(playerid));
    			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    			SendClientMessage(playerid, COLOR_PURPLE, string);
                SetPVarInt(playerid, "pPrisonShankOut", 0);
                RemovePlayerAttachedObject(playerid, 9);
            }
            else
            {
                format(string, sizeof string, "{FF8000}> {C2A2DA}%s secretly unholsters a prison shank.", GetPlayerNameEx(playerid));
    			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    			SendClientMessage(playerid, COLOR_PURPLE, string);
                SetPVarInt(playerid, "pPrisonShankOut", 1);
                SetPlayerAttachedObject(playerid, 9, 335, 6);
            }
        }
        else return SendClientMessageEx(playerid, COLOR_GREY, "   You are not in prison!");
    }
    else SendClientMessageEx(playerid, COLOR_GREY, "   You are not in prison!");
	return 1;
}

CMD:oocisolateinmate(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new id, cell, string[128];

	if(sscanf(params, "ud", id, cell)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /oocisolateinmate [playerid] [cellid]");
	else if(id == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You cannot use this command on yourself.");
	else if(!IsPlayerConnected(id)) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is not connected.");
	else if(strfind(PlayerInfo[id][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in IC Jail.");
	else if(!(0 <= cell < sizeof(DocIsolation))) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Valid Isolation Cells [0-24]");
	else if(PlayerInfo[id][pIsolated] == 0)
	{
		DocIsolate(id, cell, 1);

		format(string, sizeof(string), "You have been sent to OOC isolation by %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(id, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have sent %s to OOC isolation.", GetPlayerNameEx(id));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

		format(string, sizeof string, "%s has sent %s to OOC isolation.", GetPlayerNameEx(playerid), GetPlayerNameEx(id));
 		GroupLog(PlayerInfo[playerid][pMember], string);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is already in (ooc)isolation.");

	return 1;
}

CMD:docrelease(playerid, params)
{
	if(PlayerInfo[playerid][pJailTime] > 0 && strfind(PlayerInfo[playerid][pPrisonReason], "[DNRL]", true) != -1)
	{
		if(GetPVarInt(playerid, "Injured") == 1 || GetPVarInt(playerid, "jailcuffs") > 0 || GetPVarInt(playerid, "_pBeingReleased") >= 1 || PlayerCuffed[ playerid ] >= 1 || PlayerInfo[playerid][pHospital] > 0)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't do this right now.");
		}

		if(GetPVarInt(playerid, "_pBeingReleased") == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You must wait 45 seconds before doing this again.");

		new string[258];
		format( string, sizeof(string), "ALERT: Inmate %s is requesting to be released. Type /acceptrelease or /denyrelease. They will be released in 45 seconds.", GetPlayerNameEx(playerid));
		foreach(new i: Player)
		{
			if(IsADocGuard(i)) { SendClientMessageEx(i, COLOR_RED, string); }
		}
		SetPVarInt(playerid, "_pBeingReleased", 1);
		TogglePlayerControllable(playerid, FALSE);

		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have requested to be released from prison, waiting for a guard to accept...");
		SetTimerEx("_ReleaseTimer", 45000, false, "d", playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You can only use this command when you're serving a life sentence.");
	return 1;
}

CMD:acceptrelease(playerid, params[])
{
    if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
    new id;

    if(sscanf(params, "u", id)) return SendClientMessageEx(playerid, COLOR_GREY, "Usage: /acceptrelease [player]");

    if(strfind(PlayerInfo[id][pPrisonReason], "[DNRL]", true) != -1 && GetPVarInt(id, "_pBeingReleased") >= 1)
    {
        new string[128];
        ReleasePlayerFromPrison(id);
        format(string, sizeof(string), "You have accepted %s's release request.", GetPlayerNameEx(id));
        SendClientMessageEx(playerid, COLOR_GREY, string);

        SetPVarInt(playerid, "_pBeingReleased", 2);

        format(szMiscArray, sizeof szMiscArray, "%s has accepted %s's release request.", GetPlayerNameEx(playerid), GetPlayerNameEx(id));
 		GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
    }
    else SendClientMessage(playerid, COLOR_GRAD1, "You cannot use this command on an inmate who has not served their initial sentence or does not have a release request.");
    return 1;
}

CMD:denyrelease(playerid, params[])
{
    if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
    new id, reason[128];

    if(sscanf(params, "us[128]", id, reason)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /denyrelease [player] [reason]");

    if(strfind(PlayerInfo[id][pPrisonReason], "[DNRL]", true) != -1 && GetPVarInt(id, "_pBeingReleased") >= 1)
    {
        new string[128];
        format(string, sizeof(string), "You have denied %s's release request for: %s.", GetPlayerNameEx(id), reason);
        SendClientMessageEx(playerid, COLOR_GREY, string);

        format(string, sizeof(string), "%s has denied your release request. Reason: %s", GetPlayerNameEx(playerid), reason);
        SendClientMessageEx(id, COLOR_GREY, string);

        SetPVarInt(id, "_pBeingReleased", -1);

        TogglePlayerControllable(playerid, TRUE);

        format(szMiscArray, sizeof szMiscArray, "%s has denied %s's release request. Reason: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(id), reason);
 		GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
    }
    else SendClientMessage(playerid, COLOR_GRAD1, "You cannot use this command on an inmate who has not served their initial sentence or does not have a release request.");
    return 1;
}

CMD:prisoncraft(playerid, params[])
{
    if (PlayerInfo[playerid][pJailTime] > 0)
	{
	    if(GetPVarInt(playerid, "Injured") == 1 || GetPVarInt(playerid, "jailcuffs") > 0 || GetPVarInt(playerid, "_pBeingReleased") >= 1 || PlayerCuffed[ playerid ] >= 1 || PlayerInfo[playerid][pHospital] > 0)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't do this right now.");
		}

		new value[32], string[128];
		if(sscanf(params, "s[32]", value))
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
   			SendClientMessageEx(playerid, COLOR_YELLOW, "<< Available prison crafts >>");
			SendClientMessageEx(playerid, COLOR_GRAD1, "shank\t\t\t\t\t\t\t\t\t\twine");
			SendClientMessageEx(playerid, COLOR_GRAD1, "radio\t\t\t\t\t\t\t\t\t\tchisel");
			SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /prisoncraft [craftname]");
			return 1;
		}

		if(strcmp(value, "shank", true) == 0)
		{
			if(GetPVarInt(playerid, "pPrisonShank") >= 1) return SendClientMessageEx(playerid, COLOR_GREY, "You already have a prison shank.");
			if(PlayerInfo[playerid][pPrisonMaterials] <= 3) return SendClientMessageEx(playerid, COLOR_GREY, "You need to obtain 3 prison materials.");

            format(string, sizeof string, "{FF8000}> {C2A2DA}%s secretly crafts a shank.", GetPlayerNameEx(playerid));
			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
			SendClientMessage(playerid, COLOR_PURPLE, string);

			PlayerInfo[playerid][pPrisonMaterials] -= 3;
			SetPVarInt(playerid, "pPrisonShank", 1);
			SetPVarInt(playerid, "pShankUsages", 15);
	        SetPVarInt(playerid, "pPrisonShankOut", 0);
		}

		else if(strcmp(value, "wine", true) == 0)
		{
			if(GetPVarInt(playerid, "pPrisonWine") >= 1) return SendClientMessageEx(playerid, COLOR_GREY, "You already have wine.");
			if(PlayerInfo[playerid][pPrisonMaterials] <= 1) return SendClientMessageEx(playerid, COLOR_GREY, "You need to obtain a prison material.");
			if(GetPVarInt(playerid, "pPrisonSugar") <= 2) return SendClientMessageEx(playerid, COLOR_GREY, "You need to buy 3 packets of sugar.");
			if(GetPVarInt(playerid, "pPrisonBread") <= 0) return SendClientMessageEx(playerid, COLOR_GREY, "You need to buy a loaf of bread.");

			if(IsPlayerInCell(playerid))
			{
            	format(string, sizeof string, "{FF8000}> {C2A2DA}%s stuffs some bread into their toilet, pouring sugar over it.", GetPlayerNameEx(playerid));
				SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
				SendClientMessage(playerid, COLOR_PURPLE, string);

				SendClientMessage(playerid, COLOR_GREY, "You have started to make prison wine. It will be ready in twenty four hours. Use /prisoninv(entory) to check the progress.");

				PlayerInfo[playerid][pPrisonMaterials] -= 1;
				SetPVarInt(playerid, "pPrisonSugar", GetPVarInt(playerid, "pPrisonSugar") - 3);
				SetPVarInt(playerid, "pPrisonBread", GetPVarInt(playerid, "pPrisonBread") - 1);
				SetPVarInt(playerid, "pPrisonMWine", 1);

				PlayerInfo[playerid][pPrisonWineTime] = gettime()+60;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "  You are not in your prison cell!");
		}

		else if(strcmp(value, "radio", true) == 0)
		{
			if(PlayerInfo[playerid][pPrisonMaterials] <= 9) return SendClientMessageEx(playerid, COLOR_GREY, "You need to obtain ten prison materials.");
			if(PlayerInfo[playerid][pRadio] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You already have a radio.");

			format(string, sizeof string, "{FF8000}> {C2A2DA}%s crafts a radio with some materials.", GetPlayerNameEx(playerid));
			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
			SendClientMessage(playerid, COLOR_PURPLE, string);
			PlayerInfo[playerid][pRadio] = 1;

			SendClientMessage(playerid, COLOR_GREY, "You have crafted a radio. Use /pr to communicate.");
		}

		else if(strcmp(value, "chisel", true) == 0)
		{
			if(GetPVarInt(playerid, "pPrisonChisel") >= 1) return SendClientMessageEx(playerid, COLOR_GREY, "You already have a chisel.");
			if(PlayerInfo[playerid][pPrisonMaterials] <= 4) return SendClientMessageEx(playerid, COLOR_GREY, "You need to obtain five prison materials.");

			format(string, sizeof string, "{FF8000}> {C2A2DA}%s flattens some metal into an object.", GetPlayerNameEx(playerid));
			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
			SendClientMessage(playerid, COLOR_PURPLE, string);
			SetPVarInt(playerid, "pPrisonChisel", 1);

			SendClientMessage(playerid, COLOR_GREY, "You have crafted a chisel. Press Y in your cell to dig a hole. This chisel will go away after one use.");

			PlayerInfo[playerid][pPrisonMaterials] -= 5;
		}

		else if(isnull(value))
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
			SendClientMessageEx(playerid, COLOR_YELLOW, "<< Available prison crafts >>");
			SendClientMessageEx(playerid, COLOR_GRAD1, "shank\t\t\t\t\t\t\t\t\t\twine");
			SendClientMessageEx(playerid, COLOR_GRAD1, "radio\t\t\t\t\t\t\t\t\t\tchisel");
			SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /prisoncraft [craftname]");
			return 1;
		}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "  You are not in prison!");
	return 1;
}

CMD:prisondrinkwine(playerid, params[])
{
    if(PlayerInfo[playerid][pJailTime] > 0)
    {
        if(GetPVarInt(playerid, "pPrisonWine") >= 1)
        {
            new string[256];
    	    SetPVarInt(playerid, "pPrisonWine", GetPVarInt(playerid, "pPrisonWine") - 1);

    	    format(string, sizeof string, "{FF8000}> {C2A2DA}%s drinks some prison wine from a bottle.", GetPlayerNameEx(playerid));
			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
			SendClientMessage(playerid, COLOR_PURPLE, string);

			SetPVarInt(playerid, "pWineConsumed", 1);
			PlayAnimEx(playerid, "PED", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
			SetPlayerDrunkLevel(playerid, 10000);
			SetTimerEx("_DrinkWineTimer", 30000, false, "d", playerid);

		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "  You do you not have any wine!");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "  You are not in prison!");
	return 1;
}

CMD:prisonfinishwine(playerid, params[]) // add to /interact
{
    if(PlayerInfo[playerid][pJailTime] > 0)
    {
        if(GetPVarInt(playerid, "pPrisonMWine") >= 2)
        {
    		if(PlayerInfo[playerid][pPrisonWineTime] <= gettime())
			{
			    if(IsPlayerInCell(playerid))
			    {
			    	new string[256];
					SetPVarInt(playerid, "pPrisonWine", GetPVarInt(playerid, "pPrisonWine") + 1);
					SetPVarInt(playerid, "pPrisonMWine", 0);
					SendClientMessage(playerid, COLOR_WHITE, "You now have prison wine, use /prisonrisonhelp to learn how to use it.");

					PlayerInfo[playerid][pPrisonWineTime] = 0;

					format(string, sizeof string, "{FF8000}> {C2A2DA}%s dips a bottle into their toilet, secretly filling it with wine.", GetPlayerNameEx(playerid));
					SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
					SendClientMessage(playerid, COLOR_PURPLE, string);
				}
				else return SendClientMessageEx(playerid, COLOR_GREY, "  You are not in your cell");
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "  Your wine is not finished yet!");
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "  You are not making wine or your wine is not finished yet!");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "  You are not in prison!");
	return 1;
}

CMD:prisoncelldeposit(playerid, params[])
{
    if(PlayerInfo[playerid][pJailTime] > 0)
    {
    	new value, amount;
     	if(sscanf(params, "dd", value, amount))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /prisoncelldeposit [value] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "Drugs: (1) LSD - (2) Cannabis - (3) Meth - (4) Heroin - (5) Cocaine - (6) Crack - (7) Opium");
			SendClientMessageEx(playerid, COLOR_GREY, "Drugs: (8) Ecstasy - (9) Speed - (10) Alcohol - (11) Demerol - (12) Morphine - (13) Haloperidol - (14) Aspirin");
			return 1;
		}
        if(IsPlayerInCell(playerid))
        {
			if(amount < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Your amount must be greater than one.");

			if(GetPVarInt(playerid, "pPrisonCellChisel") <= 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You need to use a chisel to cut a storage space. Otherwise, the guards will find it.");

			switch(value)
			{
			    case 1 .. 14:
			    {
					new string[255];
			        if(PlayerInfo[playerid][p_iDrug][value - 1] >= amount)
			        {
			        	PlayerInfo[playerid][p_iDrug][value - 1] -= amount;
			        	PlayerInfo[playerid][p_iPrisonDrug][value - 1] += amount;

			        	format(string, sizeof string, "{FF8000}> {C2A2DA}%s stashes some drugs in their cell.", GetPlayerNameEx(playerid));
						SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
						SendClientMessage(playerid, COLOR_PURPLE, string);
					}
					else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough.");
				}
				default:
				{
				    return SendClientMessageEx(playerid, COLOR_GREY, "Values are 1-14");
				}
			}
        }
        else return SendClientMessageEx(playerid, COLOR_GREY, "  You are not in your cell!");
    }
    else SendClientMessageEx(playerid, COLOR_GREY, "  You are not in prison!");
	return 1;
}

CMD:prisoncellwithdraw(playerid, params[])
{
    if(PlayerInfo[playerid][pJailTime] > 0)
    {
    	new value, amount;
     	if(sscanf(params, "dd", value, amount))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /prisoncellwithdraw [value] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "Drugs: (1) LSD - (2) Cannabis - (3) Meth - (4) Heroin - (5) Cocaine - (6) Crack - (7) Opium");
			SendClientMessageEx(playerid, COLOR_GREY, "Drugs: (8) Ecstasy - (9) Speed - (10) Alcohol - (11) Demerol - (12) Morphine - (13) Haloperidol - (14) Aspirin");
			return 1;
		}
        if(IsPlayerInCell(playerid))
        {
			if(amount < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Your amount must be greater than one.");

			if(GetPVarInt(playerid, "pPrisonCellChisel") <= 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You need to use a chisel to cut a storage space. Otherwise, the guards will find it.");

			switch(value)
			{
			    case 1 .. 14:
			    {
					new string[255];
			        if(PlayerInfo[playerid][p_iPrisonDrug][value - 1] >= amount)
			        {
			        	PlayerInfo[playerid][p_iDrug][value - 1] += amount;
			        	PlayerInfo[playerid][p_iPrisonDrug][value - 1] -= amount;

			        	format(string, sizeof string, "{FF8000}> {C2A2DA}%s takes some drugs stashed their cell.", GetPlayerNameEx(playerid));
						SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
						SendClientMessage(playerid, COLOR_PURPLE, string);
					}
					else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough.");
				}
				default:
				{
					return SendClientMessageEx(playerid, COLOR_GREY, "Values are 1-14");
				}
			}
        }
        else return SendClientMessageEx(playerid, COLOR_GREY, "  You are not in your cell!");
    }
    else SendClientMessageEx(playerid, COLOR_GREY, "  You are not in prison!");
	return 1;
}

CMD:prisoninv(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0)
	{
		ShowPrisonInventory(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "  You are not in prison!");
	return 1;
}

CMD:prisoninventory(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0)
	{
		ShowPrisonInventory(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "  You are not in prison!");
	return 1;
}

IsPlayerInCell(playerid)
{
	switch(PlayerInfo[playerid][pPrisonCell])
	{
	    case 0: { if(IsPlayerInRangeOfPoint(playerid, 2, 566.7456,1444.0634,6000.4751)) return 1; }
	    case 1: { if(IsPlayerInRangeOfPoint(playerid, 2, 563.0581,1444.1854,6000.4751)) return 1; }
	    case 2: { if(IsPlayerInRangeOfPoint(playerid, 2, 559.4159,1443.9288,6000.4751)) return 1; }
	    case 3: { if(IsPlayerInRangeOfPoint(playerid, 2, 555.6315,1444.2306,6000.4751)) return 1; }
	    case 4: { if(IsPlayerInRangeOfPoint(playerid, 2, 552.0065,1444.1968,6000.4751)) return 1; }
	    case 5: { if(IsPlayerInRangeOfPoint(playerid, 2, 548.0844,1444.0985,6000.4751)) return 1; }
	    case 6: { if(IsPlayerInRangeOfPoint(playerid, 2, 544.6454,1444.1449,6000.4751)) return 1; }
	    case 7: { if(IsPlayerInRangeOfPoint(playerid, 2, 540.5981,1447.5231,6000.4751)) return 1; }
	    case 8: { if(IsPlayerInRangeOfPoint(playerid, 2, 540.4813,1450.9047,6000.4751)) return 1; }
	    case 9: { if(IsPlayerInRangeOfPoint(playerid, 2, 540.4357,1454.4258,6000.4751)) return 1; }
	    case 10: { if(IsPlayerInRangeOfPoint(playerid, 2, 540.7283,1458.2170,6000.4751)) return 1; }
	    case 11: { if(IsPlayerInRangeOfPoint(playerid, 2, 544.1293,1464.5228,6000.4751)) return 1; }
	    case 12: { if(IsPlayerInRangeOfPoint(playerid, 2, 547.7798,1464.7081,6000.4751)) return 1; }
	    case 13: { if(IsPlayerInRangeOfPoint(playerid, 2, 551.2144,1464.6027,6000.4751)) return 1; }
	    case 14: { if(IsPlayerInRangeOfPoint(playerid, 2, 557.2998,1464.8198,6000.4751)) return 1; }
	    // end of first floor
	    case 15: { if(IsPlayerInRangeOfPoint(playerid, 2, 566.3901,1443.7551,6004.4946)) return 1; }
	    case 16: { if(IsPlayerInRangeOfPoint(playerid, 2, 562.5015,1443.7295,6004.4946)) return 1; }
	    case 17: { if(IsPlayerInRangeOfPoint(playerid, 2, 559.0636,1444.0476,6004.4946)) return 1; }
	    case 18: { if(IsPlayerInRangeOfPoint(playerid, 2, 555.3583,1444.0355,6004.4946)) return 1; }
	    case 19: { if(IsPlayerInRangeOfPoint(playerid, 2, 551.9474,1443.7928,6004.4946)) return 1; }
	    case 20: { if(IsPlayerInRangeOfPoint(playerid, 2, 548.2891,1444.0117,6004.4946)) return 1; }
	    case 21: { if(IsPlayerInRangeOfPoint(playerid, 2, 544.8405,1444.0632,6004.4946)) return 1; }
	    case 22: { if(IsPlayerInRangeOfPoint(playerid, 2, 540.6741,1447.4341,6004.4946)) return 1; }
	    case 23: { if(IsPlayerInRangeOfPoint(playerid, 2, 540.6885,1451.2081,6004.4946)) return 1; }
	    case 24: { if(IsPlayerInRangeOfPoint(playerid, 2, 540.7267,1454.9779,6004.4946)) return 1; }
	    case 25: { if(IsPlayerInRangeOfPoint(playerid, 2, 540.4955,1458.8861,6004.4946)) return 1; }
	    case 26: { if(IsPlayerInRangeOfPoint(playerid, 2, 543.8416,1464.8979,6004.4946)) return 1; }
	    case 27: { if(IsPlayerInRangeOfPoint(playerid, 2, 547.9120,1464.5593,6004.4946)) return 1; }
	    case 28: { if(IsPlayerInRangeOfPoint(playerid, 2, 551.5958,1464.7749,6004.4946)) return 1; }
	    case 29: { if(IsPlayerInRangeOfPoint(playerid, 2, 557.6133,1464.9932,6004.4946)) return 1; }
	    // end of second floor
	}
	return 0;
}

IsPlayerInAShower(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 1, 588.8344,1445.8480,6000.4751)) return 1; 
	if(IsPlayerInRangeOfPoint(playerid, 1, 588.8367,1444.4164,6000.4751)) return 1; 
	if(IsPlayerInRangeOfPoint(playerid, 1, 588.8370,1443.2065,6000.4751)) return 1; 
	if(IsPlayerInRangeOfPoint(playerid, 1, 588.8370,1441.8711,6000.4751)) return 1; 
	if(IsPlayerInRangeOfPoint(playerid, 1, 588.7004,1438.7772,6000.4751)) return 1; 
	if(IsPlayerInRangeOfPoint(playerid, 1, 587.4869,1438.7759,6000.4751)) return 1; 
	if(IsPlayerInRangeOfPoint(playerid, 1, 586.3864,1438.7767,6000.4751)) return 1;
	if(IsPlayerInRangeOfPoint(playerid, 1, 585.2564,1438.7821,6000.4751)) return 1;
	if(IsPlayerInRangeOfPoint(playerid, 1, 584.0064,1438.7770,6000.4751)) return 1;
	if(IsPlayerInRangeOfPoint(playerid, 1, 582.7442,1438.7784,6000.4751)) return 1;
	if(IsPlayerInRangeOfPoint(playerid, 1, 581.4688,1438.7760,6000.4751)) return 1;
	if(IsPlayerInRangeOfPoint(playerid, 1, 580.2315,1438.7755,6000.4751)) return 1;
	else return 0;
}


/* TESTING COMANDS - REMOOOVE */

CMD:givemematerials(playerid, params[])
{
    PlayerInfo[playerid][pPrisonMaterials] += 100000;
	return 1;
}

CMD:givemeprisoncredits(playerid, params[])
{
    PlayerInfo[playerid][pPrisonCredits] += 100000;
	return 1;
}

CMD:mycell(playerid, params[])
{
	new string[255];
	format(string, sizeof(string), "%d.", PlayerInfo[playerid][pPrisonCell]);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

CMD:docarrestme(playerid, params[])
{
	if(!IsAtArrestPoint(playerid, 2)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not at the DoC Prison arrest point." );
	{
   		new
     		//moneys,
       		//time,
			string[256];

        new suspect = playerid;
  		/*if(sscanf(params, "dddd", moneys, time)) SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docarrest [fine] [minutes]");
		else if(!(1 <= moneys <= 250000)) SendClientMessageEx(playerid, COLOR_GREY, "The jail fine can't be below $1 or above $250,000.");
		else if(!(1 <= time <= 120)) SendClientMessageEx(playerid, COLOR_GREY, "Jail time can't be below 1 or above 120 minutes - take the person to prison for more time.");*/
		if(!IsPlayerConnected(suspect)) SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		//else if(PlayerInfo[suspect][pWantedLevel] < 1 && PlayerInfo[playerid][pMember] != 12) SendClientMessageEx(playerid, COLOR_GREY, "The person must have a wanted level of at least one star.");
		else {
			SetPVarInt(playerid, "Arrest_Price", PlayerInfo[suspect][pWantedJailFine]);
			// change pWantedJailFine
			SetPVarInt(playerid, "Arrest_Time", 2);
			SetPVarInt(playerid, "Arrest_Bail", 1);
			SetPVarInt(playerid, "Arrest_BailPrice", PlayerInfo[suspect][pWantedJailFine]*2);
			SetPVarInt(playerid, "Arrest_Suspect", suspect);
			SetPVarInt(playerid, "Arrest_Type", 2);
			SendClientMessageEx(playerid, COLOR_GREY, "Please (if not already) switch to a LEO group or this will not work!");
			format(string, sizeof(string), "Please write a brief arrest report on how %s acted during the arrest.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(suspect));
			ShowPlayerDialog(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", string, "Submit", "");
	    }
	}
	return 1;
}
/* TESTING COMANDS - REMOOOVE */

ShowPrisonInventory(playerid)
{
	new string[64];
	SendClientMessageEx(playerid, COLOR_GREY, "------------------------------------------------------");

	format(string, sizeof(string), "Prison Cell: %d.", PlayerInfo[playerid][pPrisonCell]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	SendClientMessage(playerid, COLOR_WHITE, "");

	if(PlayerInfo[playerid][pPrisonCredits] >= 1)
	{
	    format(string, sizeof string, "Prison Credits: %d.", PlayerInfo[playerid][pPrisonCredits]);
	    SendClientMessageEx(playerid, COLOR_WHITE, string);
	}

	if(PlayerInfo[playerid][pPrisonMaterials] >= 1)
	{
	    format(string, sizeof string, "Prison Materials: %d.", PlayerInfo[playerid][pPrisonMaterials]);
	    SendClientMessageEx(playerid, COLOR_WHITE, string);
	}

	if(GetPVarInt(playerid, "pPrisonSoap") >= 1)
	{
	    format(string, sizeof string, "Soap: %d.", GetPVarInt(playerid, "pPrisonSoap"));
	    SendClientMessageEx(playerid, COLOR_WHITE, string);
	}

	if(GetPVarInt(playerid, "pPrisonSugar") >= 1)
	{
	    format(string, sizeof string, "Sugar: %d.", GetPVarInt(playerid, "pPrisonSugar"));
	    SendClientMessageEx(playerid, COLOR_WHITE, string);
	}

	if(GetPVarInt(playerid, "pPrisonBread") >= 1)
	{
	    format(string, sizeof string, "Bread: %d.", GetPVarInt(playerid, "pPrisonBread"));
	    SendClientMessageEx(playerid, COLOR_WHITE, string);
	}

	if(GetPVarInt(playerid, "pPrisonWine") >= 1)
	{
	    format(string, sizeof string, "Wine: %d.", GetPVarInt(playerid, "pPrisonWine"));
	    SendClientMessageEx(playerid, COLOR_WHITE, string);
	}

	if(GetPVarInt(playerid, "pPrisonShank") >= 1)
	{
	    format(string, sizeof string, "Shank: %d. | Uses: %d", GetPVarInt(playerid, "pPrisonShank"), GetPVarInt(playerid, "pShankUsages"));
	    SendClientMessageEx(playerid, COLOR_WHITE, string);
	}

	if(GetPVarInt(playerid, "pPrisonMWine") >= 1)
	{
	    if(PlayerInfo[playerid][pPrisonWineTime] <= gettime())
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "");
			SendClientMessageEx(playerid, COLOR_GREY, "Wine Time Left: 0 seconds.");
		}
		else
		{
	    	format(string, sizeof(string), "Wine Time Left: %s.", TimeConvert(PlayerInfo[playerid][pPrisonWineTime]-gettime()));
	    	SendClientMessageEx(playerid, COLOR_WHITE, "");
	    	SendClientMessageEx(playerid, COLOR_GREY, string);
		}
	}

	SendClientMessageEx(playerid, COLOR_GREY, "------------------------------------------------------");
	return 1;
}

forward _UnbeanbagTimer(playerid);
public _UnbeanbagTimer(playerid)
{
	if(PlayerCuffed[playerid] <= 0 && GetPVarInt(playerid, "jailcuffs") <= 0)
	{
		ClearAnimations(playerid);
		TogglePlayerControllable(playerid, TRUE);

		SetPlayerDrunkLevel(playerid, 0);
		SetPVarInt(playerid, "pBagged", 0);

		ClearAnimations(playerid);
	}
	return 1;
}

forward _ShowerTimer(playerid);
public _ShowerTimer(playerid)
{
	new Float: health;
	GetPlayerHealth(playerid, health);

	SetPlayerHealth(playerid, 150.0);

	ClearAnimations(playerid);

	switch(GetPVarInt(playerid, "pPrisonShowerStage"))
	{
		case 1:
		{
			SendClientMessage(playerid, COLOR_GREY, "You have finished showering.");
			TogglePlayerControllable(playerid, TRUE);
			DeletePVar(playerid, "pPrisonShowerStage");
		}
		default: 
		{
			PlayAnimEx(playerid, "MISC", "Scratchballs_01", 4.0, 0, 0, 0, 0, 0, 1);
			SetPVarInt(playerid, "pPrisonShowerStage", 1);

			SetTimerEx("_ShowerTimer", 10000, false, "d", playerid);
		}
	}
	RandomMaterialChance(playerid);
	return 1;
}

forward _DrinkWineTimer(playerid);
public _DrinkWineTimer(playerid)
{
	new Float: health;
	GetPlayerHealth(playerid, health);

	SetPlayerHealth(playerid, 200.0);

	SendClientMessage(playerid, COLOR_GREY, "You begin to stabalize, you also feel stronger.");
	SetPVarInt(playerid, "pWineConsumed", 2);
	SetTimerEx("_DrinkWineTimer2", 60000, false, "d", playerid);

	SetPlayerDrunkLevel(playerid, 1000);
	ClearAnimations(playerid);
	return 1;
}

forward _DrinkWineTimer2(playerid);
public _DrinkWineTimer2(playerid)
{
	new Float: health;
	GetPlayerHealth(playerid, health);

	SendClientMessage(playerid, COLOR_GREY, "The wine has lost it's effect.");
	SetPVarInt(playerid, "pWineConsumed", 0);

	SetPlayerDrunkLevel(playerid, 0);
	ClearAnimations(playerid);
	return 1;
}

forward _KitchenTimer(playerid);
public _KitchenTimer(playerid)
{
	PlayerInfo[playerid][pMechTime] = gettime()+60;
	SendClientMessage(playerid, COLOR_GREY, "You have finished preparing food.");
	TogglePlayerControllable(playerid, TRUE);
	SetPVarInt(playerid, "pDoingPJob", 0);

	PlayerInfo[playerid][pPrisonCredits] += 3;
	RandomMaterialChance(playerid);

	ClearAnimations(playerid);
	return 1;
}

forward _ReleaseTimer(playerid);
public _ReleaseTimer(playerid)
{
    if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1 && GetPVarInt(playerid, "_pBeingReleased") >= 1)
	{
 		ReleasePlayerFromPrison(playerid);
 		SetPVarInt(playerid, "_pBeingReleased", 0);
	}
	else if(GetPVarInt(playerid, "_pBeingReleased") == -1) { SetPVarInt(playerid, "_pBeingReleased", 0); }
	return 1;
}

ReleasePlayerFromPrison(playerid)
{
	if(playerTabbed[playerid] == 0)
	{
		if(PlayerInfo[playerid][pJailTime] > 0 && --PlayerInfo[playerid][pJailTime] <= 0)
		{
			if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1)
	    	{
				SetPlayerInterior(playerid, 0);
				PlayerInfo[playerid][pInt] = 0;
				SetPlayerVirtualWorld(playerid, 0);
				PlayerInfo[playerid][pVW] = 0;
				SetPlayerPos(playerid, -1528.5812,489.6914,7.1797);
	 		}
		}
		else
		{
			SetPlayerInterior(playerid, 0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SetPlayerPos(playerid, 1544.5059,-1675.5673,13.5585);
		}
	}

	PlayerInfo[playerid][pPrisonCredits] = 0;
	PlayerInfo[playerid][pPrisonMaterials] = 0;
	PlayerInfo[playerid][pPrisonWineTime] = 0;
	PlayerInfo[playerid][pPrisonCell] = 0;

	SetPVarInt(playerid, "pPrisonSoap", 0);
	SetPVarInt(playerid, "pPrisonSugar", 0);
	SetPVarInt(playerid, "pPrisonBread", 0);
	SetPVarInt(playerid, "pPrisonShank", 0);
	SetPVarInt(playerid, "pPrisonShankOut", 0);
	SetPVarInt(playerid, "pShankUsages", 0);
	SetPVarInt(playerid, "pPrisonWine", 0);
	SetPVarInt(playerid, "pPrisonMWine", 0);
	SetPVarInt(playerid, "pPrisonChisel", 0);
	SetPVarInt(playerid, "pPrisonCellChisel", 0);

	SetPlayerHealth(playerid, 100);
	PlayerInfo[playerid][pJailTime] = 0;
	PlayerInfo[playerid][pIsolated] = 0;
	PlayerInfo[playerid][pPrisonCredits] = 0;
	strcpy(PlayerInfo[playerid][pPrisonReason], "None");
	PhoneOnline[playerid] = 0;
	SendClientMessageEx(playerid, COLOR_GRAD1,"   You have paid your debt to society.");
	GameTextForPlayer(playerid, "~g~Freedom~n~~w~Try to be a better citizen", 5000, 1);
	TogglePlayerControllable(playerid, TRUE);
	SetPVarInt(playerid, "_pBeingReleased", 0);
	SetPlayerToTeamColor(playerid); //For some reason this is a being a bitch now so let's reset their colour to white and let the script decide what colour they should have afterwords
	ClearCrimes(playerid);
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if ((newkeys & KEY_YES) && !(oldkeys & KEY_YES))
    {
        if(IsPlayerInRangeOfPoint(playerid, 2, 567.7756,1450.0720,6000.4751))
        {
            if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1) { ShowPlayerDialog(playerid, DIALOG_PRISONCREDS, DIALOG_STYLE_LIST, "Prison Canteen", "Dice\t\t\t\t\t\t5\nPaper\t\t\t\t\t\t5\nSoap\t\t\t\t\t\t5\nSugar\t\t\t\t\t\t5\nBread\t\t\t\t\t\t10\nCigarettes\t\t\t\t\t10\n\nMP3 Player\t\t\t\t\t50\nClothes\t\t\t\t\t500", "Purchase", "Cancel"); }
        }

        else if(IsPlayerInRangeOfPoint(playerid, 5, 546.7458,1484.4885,6000.4678))
        {
            new string[255];
    		if(gettime() < PlayerInfo[playerid][pMechTime])
			{
  				format(string, sizeof(string), "You must wait %d seconds!", PlayerInfo[playerid][pMechTime]-gettime());
     			return SendClientMessageEx(playerid, COLOR_GRAD1, string);
     		}
     		if(GetPVarInt(playerid, "pDoingPJob") >= 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "  You are already on a job!");

            TogglePlayerControllable(playerid, FALSE);
			SetTimerEx("_KitchenTimer", 25000, false, "d", playerid);

			format(string, sizeof string, "{FF8000}> {C2A2DA}%s begins to prepare some food for the kitchen.", GetPlayerNameEx(playerid));
    		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
    		SendClientMessage(playerid, COLOR_PURPLE, string);
    		SetPVarInt(playerid, "pDoingPJob", 1);

    		TogglePlayerControllable(playerid, FALSE);

    		PlayAnimEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
        }
	    else if(IsPlayerInAShower(playerid))
	    {
	        if(GetPVarInt(playerid, "pPrisonSoap") >= 1)
			{
				new string[128];
	        	new Float: health;
				GetPlayerHealth(playerid, health);
	        	if(health >= 150.0) return SendClientMessage(playerid, COLOR_GREY, "  You don't need to shower.");

      	  		format(string, sizeof string, "{FF8000}> {C2A2DA}%s wipes theirselves down with a bar of soap.", GetPlayerNameEx(playerid));
				SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
				SendClientMessage(playerid, COLOR_PURPLE, string);

				SetPVarInt(playerid, "pPrisonSoap", GetPVarInt(playerid, "pPrisonSoap") - 1);
				TogglePlayerControllable(playerid, FALSE);

				SetTimerEx("_ShowerTimer", 10000, false, "d", playerid);

				PlayAnimEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
			}
			else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have any soap.");
	    }

	    else if(GetPVarInt(playerid, "pPrisonChisel") >= 1 && IsPlayerInCell(playerid))
	    {
	        new string[255];
	        format(string, sizeof string, "{FF8000}> {C2A2DA}%s digs at their cell wall with a small object.", GetPlayerNameEx(playerid));
			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
			SendClientMessage(playerid, COLOR_PURPLE, string);

			SetPVarInt(playerid, "pPrisonCellChisel", 1);
			SetPVarInt(playerid, "pPrisonChisel", 0);

			PlayAnimEx(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0,0);

			SendClientMessage(playerid, COLOR_WHITE, "You have chiseled a hole in your cell, type /prisoncelldeposit to deposit contraband.");
	    }
    }
	return 1;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
{
	new string[128];
	if(GetPVarInt(playerid, "pPrisonShankOut") >= 1 && weaponid == 0)
	{
	    new Float:health;
	    GetPlayerHealth(damagedid, health);
	    SetPlayerHealth(damagedid, health - random(20)+40);

	    SetPVarInt(playerid, "pShankUsages", GetPVarInt(playerid, "pShankUsages") - 1);

	    if(GetPVarInt(playerid, "pShankUsages") <= 0)
	    {
	        SetPVarInt(playerid, "pShankUsages", 0);
	        SetPVarInt(playerid, "pPrisonShank", 0);
	        SetPVarInt(playerid, "pPrisonShankOut", 0);

	        format(string, sizeof string, "{FF8000}> {C2A2DA}%s shank dulls.", GetPlayerNameEx(playerid));
    		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);

    		SendClientMessageEx(playerid, COLOR_GREY, "Your prison shank has exceeded it's uses.");

	        RemovePlayerAttachedObject(playerid, 9);
	    }
	}

	if(GetPVarInt(playerid, "pBeanBag") >= 1 && weaponid == 25)
	{
	    if(GetPVarInt(damagedid, "pBagged") >= 1) return 0;
	    else
		{
	    	new Float:health;
	    	GetPlayerHealth(damagedid, health);
	    	SetPlayerHealth(damagedid, health + amount);

	    	TogglePlayerControllable(damagedid, FALSE);
     		PlayAnimEx(damagedid,"PED","KO_shot_stom",4.1,0,0,0,0,0,0);
	    	SetTimerEx("_UnbeanbagTimer", 20000, false, "d", damagedid);
	    	SetPlayerDrunkLevel(damagedid, 10000);
	    	PlayerTextDrawShow(damagedid, _vhudFlash[damagedid]);
     		SetTimerEx("TurnOffFlash", 2500, 0, "i", damagedid);

     		SetPVarInt(damagedid, "pBagged", 1);

	    	GameTextForPlayer(damagedid, "~r~Bagged!", 7000, 3);
	    }
	}

	if(GetPVarInt(playerid, "pWineConsumed") >= 2)
	{
	    new Float:health;
    	GetPlayerHealth(damagedid, health);
    	SetPlayerHealth(damagedid, health - 15.0);
	}
    return 1;
}

RandomMaterialChance(playerid)
{
	switch(random(50))
	{
	    case 0 .. 45:
	    {
	        return 0;
	    }
	    default:
	    {
	        PlayerInfo[playerid][pPrisonMaterials] +=1;
	        SendClientMessage(playerid, COLOR_WHITE, "You have found a secret prison material. You can use these in /prisoncraft.");
	    }
	}
	return 1;
}