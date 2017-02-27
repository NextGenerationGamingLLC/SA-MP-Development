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

DocIsolate(playerid, cellid)
{
	SetPlayerPos(playerid, DocIsolation[cellid][0], DocIsolation[cellid][1], DocIsolation[cellid][2]);
	SetPlayerFacingAngle(playerid, 0);
	SetPlayerInterior(playerid, 1);
	Player_StreamPrep(playerid, DocIsolation[cellid][0], DocIsolation[cellid][1], DocIsolation[cellid][2], FREEZE_TIME);
	
	PlayerInfo[playerid][pIsolated] = cellid + 1;
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
	return ShowPlayerDialogEx(playerid, DIALOG_LOAD_DETAINEES, DIALOG_STYLE_LIST, "Detainees List", szPrisoners, "Load", "Cancel");
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
			format(szMiscArray, sizeof(szMiscArray), "Cell-block A\nIsolation Cells\nArea Doors\nLockdown");
			ShowPlayerDialogEx(playerid, DIALOG_DOC_CP, DIALOG_STYLE_LIST, "Doc Control Pannel", szMiscArray, "Select", "Cancel");
		}
		case 1:
		{
			// sub-dialog 
			format(szMiscArray, sizeof(szMiscArray), "Floor 1\nFloor 2\nAll Floor 1\nAll Floor 2");
			ShowPlayerDialogEx(playerid, DIALOG_DOC_CP_SUB, DIALOG_STYLE_LIST, "Doc Control Pannel", szMiscArray, "Select", "Back");
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
			ShowPlayerDialogEx(playerid, DIALOG_DOC_CP_C1F1, DIALOG_STYLE_LIST, "Doc Control Pannel", szMiscArray, "Select", "Back");
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
			ShowPlayerDialogEx(playerid, DIALOG_DOC_CP_C1F2, DIALOG_STYLE_LIST, "Doc Control Pannel", szMiscArray, "Select", "Back");
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
			ShowPlayerDialogEx(playerid, DIALOG_DOC_CP_AREA, DIALOG_STYLE_LIST, "Doc Control Pannel", szMiscArray, "Select", "Back");
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
		format( szWarning, sizeof(szWarning), "ALERT: The Easter Basin Correctional Facility is now on Lockdown for an emergency (( %s ))", GetPlayerNameEx(playerid));
		SendGroupMessage(GROUP_TYPE_LEA, COLOR_RED, szWarning);
		//PlayAudioStreamForPlayer(i, "http://sampweb.ng-gaming.net/brendan/siren.mp3", -1083.90002441,4289.70019531,7.59999990, 500, 1);
	}
	else 
	{
		bDocLockdown = false;
		format( szWarning, sizeof(szWarning), "ALERT: The Easter Basin Correctional Facility is no longer on lockdown (( %s ))", GetPlayerNameEx(playerid));
		SendGroupMessage(GROUP_TYPE_LEA, COLOR_YELLOW, szWarning);
		//StopAudioStreamForPlayer(i);
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

Prison_SetPlayerSkin(playerid) {
	switch(PlayerInfo[playerid][pSex]) {
		case 1: SetPlayerSkin(playerid, 8);
		case 2: SetPlayerSkin(playerid, 211);
	}
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

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
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
	}
	return 0;
}

CMD:setbail(playerid, params[]) {

	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in DoC to use this command.");
	if(PlayerInfo[playerid][pLeader] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a Warden to use this command.");

	new uPlayer,
		iBail;

	if(sscanf(params, "dd", uPlayer, iBail)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /setbail [player] [amount]");

	if(!(0 < iBail < 50000000)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount ($1 - $50.000.000).");
	
	PlayerInfo[uPlayer][pBailPrice] = iBail;

	format(szMiscArray, sizeof(szMiscArray), "You have set %s's bail to: $%s", GetPlayerNameEx(uPlayer), number_format(iBail));
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "Your bail has been set to $%s by %s", number_format(iBail), GetPlayerNameEx(playerid));
	SendClientMessageEx(uPlayer, COLOR_YELLOW, szMiscArray);

	format(szMiscArray, sizeof szMiscArray, "%s has set %s's bail price to $%s.", GetPlayerNameEx(playerid), GetPlayerNameEx(uPlayer), number_format(PlayerInfo[uPlayer][pBailPrice]));
 	GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
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
				format(string, sizeof string, "%s has bailed themselves out for $%s.", GetPlayerNameEx(playerid), number_format(PlayerInfo[playerid][pBailPrice]));
 				for(new x; x < MAX_GROUPS; ++x) if(arrGroupData[x][g_iDoCAccess] >= 0 && arrGroupData[x][g_iDoCAccess] != INVALID_RANK) GroupLog(x, string);
				GivePlayerCash(playerid, -PlayerInfo[playerid][pBailPrice]);
				PlayerInfo[playerid][pBailPrice] = 0;
				WantLawyer[playerid] = 0; CallLawyer[playerid] = 0;
				PlayerInfo[playerid][pJailTime] = 1;
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
			ShowPlayerDialogEx(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", string, "Submit", "");
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
			format(szMiscArray, sizeof(szMiscArray), "Please write a brief arrest report on how %s acted during the arrest.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(suspect));
			ShowPlayerDialogEx(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", szMiscArray, "Submit", "");
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
	ShowPlayerDialogEx(playerid, DIALOG_DOC_INMATES, DIALOG_STYLE_LIST, szString, szInmates, "Close", "");
	
	return 1;
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
		SetPVarInt(iOffering, "inmatefood", GetPVarInt(iOffering, "inmatefood") - 1);	
		if(!GetPVarInt(iOffering, "inmatefood")) {
			RemovePlayerAttachedObject(iOffering, 9);
			SetPlayerSpecialAction(iOffering, SPECIAL_ACTION_NONE);
		}
		if (PlayerInfo[playerid][pFitness] >= 3)
		{
			PlayerInfo[playerid][pFitness] -= 3;
		}
		else
		{
			PlayerInfo[playerid][pFitness] = 0;
		}
		DeletePVar(playerid, "OfferedMeal");
		DeletePVar(playerid, "OfferedMealBy");
		DeletePVar(iOffering, "OfferingMeal");
		DeletePVar(iOffering, "OfferedMealTo");
		format(string, sizeof(string), "* %s takes a plate of food from %s and begins to eat it.", GetPlayerNameEx(playerid), GetPlayerNameEx(iOffering));
		ProxChatBubble(playerid, string);
		// ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		//ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 0, 4000, 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 1, 0);
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
		format(string, sizeof(string), "* %s grabs the food from the tray and eats it.", GetPlayerNameEx(playerid));
		ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		DeletePVar(playerid, "carryingfood");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 1, 0);
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
		DocIsolate(iTargetID, iCellID);
		
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

CMD:inmates(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new szInmates[1024];
	
	foreach(Player, i)
	{
		if(PlayerInfo[i][pJailTime] > 0 && strfind(PlayerInfo[i][pPrisonReason], "[IC]", true) != -1)
		{
			if(PlayerInfo[i][pBailPrice]) format(szInmates, sizeof(szInmates), "%s\n* %s: %s - Bail: $%s", szInmates, GetPlayerNameEx(i), TimeConvert(PlayerInfo[i][pJailTime]), number_format(PlayerInfo[i][pBailPrice]));
			else format(szInmates, sizeof(szInmates), "%s\n* %s: %s", szInmates, GetPlayerNameEx(i), TimeConvert(PlayerInfo[i][pJailTime]));
		}
	}
	if(strlen(szInmates) == 0) format(szInmates, sizeof(szInmates), "No inmates");
	ShowPlayerDialogEx(playerid, DIALOG_DOC_INMATES, DIALOG_STYLE_LIST, "DOC Inmates Logbook", szInmates, "Close", "");
	
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

CMD:startbrawl(playerid, params[])
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
}

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
			format(szCountry, sizeof(szCountry), "[NE] ");
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
		ShowPlayerDialogEx(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", string, "Submit", "");
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You must be in range of that player");
	
	return 1;
}

/*CMD:jailcall(playerid, params[])
{
	new phonenumb,
		JailPhone = GetClosestPrisonPhone(playerid), 
		string[128];
	
	if(sscanf(params, "d", phonenumb)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /jailcall [phone number]");
	if(!IsPlayerInRangeOfJailPhone(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in range of a prison call phone");
	if(bJailPhoneUse[JailPhone] == true) return SendClientMessageEx(playerid, COLOR_GREY, "That phone is in use, please find another");
	if(Mobile[playerid] != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "  You are already on a call...");
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pPnumber] == phonenumb && phonenumb != 0)
		{
			new giveplayerid = i;
			Mobile[playerid] = giveplayerid; //caller connecting
			if(IsPlayerConnected(giveplayerid))
			{
				if(giveplayerid != INVALID_PLAYER_ID)
				{
					if(PhoneOnline[giveplayerid] > 0)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "That player's phone is switched off.");
						Mobile[playerid] = INVALID_PLAYER_ID;
						return 1;
					}
					if(Mobile[giveplayerid] != INVALID_PLAYER_ID)
					{
						SendClientMessageEx(playerid, COLOR_GRAD2, "You just get a busy tone...");
						Mobile[playerid] = INVALID_PLAYER_ID;
						return 1;
					}
					if(Spectating[giveplayerid]!=0)
					{
						SendClientMessageEx(playerid, COLOR_GRAD2, "You just get a busy tone...");
						Mobile[playerid] = INVALID_PLAYER_ID;
						return 1;
					}
					if (Mobile[giveplayerid] == INVALID_PLAYER_ID)
					{
						format(string, sizeof(string), "* %s dials in a number.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						
						format(string, sizeof(string), "Your mobile is ringing - type /p to answer it. [Caller ID: DOC Phoneline]");
						SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);
						format(string, sizeof(string), "* %s's phone begins to ring.", GetPlayerNameEx(i));
						SendClientMessageEx(playerid, COLOR_WHITE, "HINT: You now use T to talk on your cellphone, type /jailhangup to hang up.");
						ProxDetector(30.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
						TogglePlayerControllable(playerid, 0);
						SetPVarInt(playerid, "_UsingJailPhone", 1);
						bJailPhoneUse[JailPhone] = true;
						return 1;
					}
				}
			}
		}
	}
	SendClientMessageEx(playerid, COLOR_WHITE, "The call could not completed as requested, please try again");
	return 1;
}

CMD:jailhangup(playerid,params[])
{
	new string[128];
	new caller = Mobile[playerid],
		JailPhone = GetClosestPrisonPhone(playerid);
	if((IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID))
	{
		if(caller < MAX_PLAYERS)
		{
			SendClientMessageEx(caller,  COLOR_GRAD2, "   They hung up.");
			format(string, sizeof(string), "* %s puts away their cellphone.", GetPlayerNameEx(caller));
			ProxDetector(30.0, caller, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			Mobile[caller] = INVALID_PLAYER_ID;
		}
		SendClientMessageEx(playerid,  COLOR_GRAD2, "   You hung up.");
		format(string, sizeof(string), "* %s steps away from the phone.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		Mobile[playerid] = INVALID_PLAYER_ID;
		RemovePlayerAttachedObject(caller, 9);
		TogglePlayerControllable(playerid, 1);
		SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		bJailPhoneUse[JailPhone] = false;
		DeletePVar(playerid, "_UsingJailPhone");
		return 1;
	}
	SendClientMessageEx(playerid,  COLOR_GRAD2, "   Your phone is in your pocket.");
	return 1;
}*/

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
				if(GetPlayerSpecialAction(giveplayerid) == SPECIAL_ACTION_HANDSUP || PlayerCuffed[giveplayerid] == 1)
				{
					format(string, sizeof(string), "* You have been handcuffed by %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* You handcuffed %s, till uncuff.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* %s handcuffs %s, tightening the cuffs securely.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					GameTextForPlayer(giveplayerid, "~r~Cuffed", 2500, 3);
					ClearAnimationsEx(giveplayerid);
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