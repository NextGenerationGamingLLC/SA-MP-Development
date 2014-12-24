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

DocIsolate(playerid, cellid)
{
	SetPlayerPos(playerid, DocIsolation[cellid][0], DocIsolation[cellid][1], DocIsolation[cellid][2]);
	SetPlayerFacingAngle(playerid, 0);
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
	return ShowPlayerDialog(playerid, DIALOG_LOAD_DETAINEES, DIALOG_STYLE_LIST, "Detainees List", szPrisoners, "Load", "Cancel");
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
	new string[1024];
	
	switch(icontrolid)
	{
		case 0:
		{
			// main dialog
			format(string, sizeof(string), "Cell-block A\nIsolation Cells\nArea Doors\nLockdown");
			ShowPlayerDialog(playerid, DIALOG_DOC_CP, DIALOG_STYLE_LIST, "Doc Control Pannel", string, "Select", "Cancel");
		}
		case 1:
		{
			// sub-dialog 
			format(string, sizeof(string), "Floor 1\nFloor 2\nAll Floor 1\nAll Floor 2");
			ShowPlayerDialog(playerid, DIALOG_DOC_CP_SUB, DIALOG_STYLE_LIST, "Doc Control Pannel", string, "Select", "Back");
		}
		case 2:
		{
			// floor 1
			format(string, sizeof(string), "Cell 1 (%s)\n\
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
			ShowPlayerDialog(playerid, DIALOG_DOC_CP_C1F1, DIALOG_STYLE_LIST, "Doc Control Pannel", string, "Select", "Back");
		}
		case 3:
		{
			// floor 2
			format(string, sizeof(string), "Cell 1 (%s)\n\
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
			ShowPlayerDialog(playerid, DIALOG_DOC_CP_C1F2, DIALOG_STYLE_LIST, "Doc Control Pannel", string, "Select", "Back");
		}
		case 4:
		{
			// area controls
			format(string, sizeof(string), "Café%s)\n\
			Cell-block (%s)\n\
			Cell-block Corridor (%s)\n\
			Café Kitchen (%s)\n\
			Courtyard Access (%s)\n\
			Isolation Door 1 (%s)\n\
			Isolation Door 2 (%s)\n\
			Cell-block Hallway (%s)\n\
			Showers (%s)\n\
			Inside Gym (%s)\n\
			Telephone Room (%s)\n\
			Courtyard Door 1 (%s)\n\
			Courtyard Door 2 (%s)", 
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
			((bDocAreaOpen[12] == false) ? ("{FF0000}Closed"):("{00FF00}Open"))
			);
			ShowPlayerDialog(playerid, DIALOG_DOC_CP_AREA, DIALOG_STYLE_LIST, "Doc Control Pannel", string, "Select", "Back");
		}
		case 5: 
		{
			// isolation controls
			format(string, sizeof(string), "Isolation Cell 1 (%s)\n\
			Isolation Cell 2 (%s)\n\
			Isolation Cell 3 (%s)\n\
			Isolation Cell 4 (%s)\n\
			Isolation Cell 5 (%s)\n\
			Isolation Cell 6 (%s)", 
			((bDocIsolationOpen[0] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocIsolationOpen[1] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocIsolationOpen[2] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocIsolationOpen[3] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocIsolationOpen[4] == false) ? ("{FF0000}Closed"):("{00FF00}Open")),
			((bDocIsolationOpen[5] == false) ? ("{FF0000}Closed"):("{00FF00}Open"))
			);
			ShowPlayerDialog(playerid, DIALOG_DOC_CP_ISOLATION, DIALOG_STYLE_LIST, "Doc Control Pannel", string, "Select", "Back");
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
		for(new i = 0; i < 13; i++)
		{
			OpenDocAreaDoors(i, 0);
		}
		for(new i = 0; i < 6; i++)
		{
			OpenDocIsolationCells(i, 0);
		}
		format( szWarning, sizeof(szWarning), "ALERT: The Easter Basin Correctional Facility is now on Lockdown for an emergency (( %s ))", GetPlayerNameEx(playerid));
		SendGroupMessage(1, COLOR_RED, szWarning);
		//PlayAudioStreamForPlayer(i, "http://sampweb.ng-gaming.net/brendan/siren.mp3", -1083.90002441,4289.70019531,7.59999990, 500, 1);
	}
	else 
	{
		bDocLockdown = false;
		format( szWarning, sizeof(szWarning), "ALERT: The Easter Basin Correctional Facility is no longer on lockdown (( %s ))", GetPlayerNameEx(playerid));
		SendGroupMessage(1, COLOR_YELLOW, szWarning);
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

IsPlayerInRangeOfJailPhone(playerid)
{
	for(new i = 0; i < 5; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2, JailPhonePos[i][0], JailPhonePos[i][1], JailPhonePos[i][2]))
		{
			return true;
		}
	}
	return 0;
}

forward OpenDocIsolationCells(cellid, open);
public OpenDocIsolationCells(cellid, open)
{	
	switch(cellid)
	{
		case 0:
		{
			if(open == 0) MoveDynamicObject(DocIsolationCells[0], 562.73242, 1454.49622, 5995.95801, 0.9);
			if(open == 1) MoveDynamicObject(DocIsolationCells[0], 562.73242, 1454.49622 - 1.34, 5995.95801, 0.9);
		}
		case 1:
		{
			if(open == 0) MoveDynamicObject(DocIsolationCells[1], 562.73242, 1451.27612, 5995.95801, 0.9);
			if(open == 1) MoveDynamicObject(DocIsolationCells[1], 562.73242, 1451.27612 - 1.34, 5995.95801, 0.9);
		}
		case 2:
		{
			if(open == 0) MoveDynamicObject(DocIsolationCells[2], 560.25751, 1450.35547, 5995.95801, 0.9);
			if(open == 1) MoveDynamicObject(DocIsolationCells[2], 560.25751 - 1.34, 1450.35547, 5995.95801, 0.9);
		}
		case 3:
		{
			if(open == 0) MoveDynamicObject(DocIsolationCells[3], 557.04352, 1450.35547, 5995.95801, 0.9);
			if(open == 1) MoveDynamicObject(DocIsolationCells[3], 557.04352 - 1.34, 1450.35547, 5995.95801, 0.9);
		}
		case 4:
		{
			if(open == 0) MoveDynamicObject(DocIsolationCells[4], 553.84729, 1450.35547, 5995.95801,   0.9);
			if(open == 1) MoveDynamicObject(DocIsolationCells[4], 553.84729 - 1.34, 1450.35547, 5995.95801,   0.9);
		}
		case 5:
		{
			if(open == 0) MoveDynamicObject(DocIsolationCells[5], 550.66852, 1450.35547, 5995.95801, 0.9);
			if(open == 1) MoveDynamicObject(DocIsolationCells[5], 550.66852 - 1.34, 1450.35547, 5995.95801, 0.9);
		}
	}
	if(open == 0) bDocIsolationOpen[cellid] = false;
	else if(open == 1) bDocIsolationOpen[cellid] = true;
}

forward OpenDocAdmDoor(door, open);
public OpenDocAdmDoor(door, open)
{	
	switch(door)
	{
		case 0:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[0], 597.56000, 1494.96692, 5999.42773, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor1[0], 597.56000 - 1.34, 1494.96692, 5999.42773, 0.9);
		}
		case 1:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[1], 587.84039, 1495.08362, 5999.40771, 0.9);//
			if(open == 1) MoveDynamicObject(DocAdmFloor1[1], 587.84039 - 1.34, 1495.08362, 5999.40771, 0.9);//
		}
		case 2:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[2], 590.28851, 1484.60571, 5999.42773, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor1[2], 590.28851, 1484.60571 + 1.34, 5999.42773, 0.9);
		}
		case 3:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[3], 590.30060, 1481.43665, 5999.42773, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor1[3], 590.30060, 1481.43665 + 1.34, 5999.42773, 0.9);
		}
		case 4:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[4], 579.84003, 1495.06958, 5999.42773, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor1[4], 579.84003 - 1.34, 1495.06958, 5999.42773, 0.9);
		}
		case 5:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[5], 585.3600, 1478.2000, 5999.42773, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor1[5], 585.3600, 1478.2000 + 1.34, 5999.42773, 0.9);
		}
		case 6:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[6], 588.07373, 1475.81750, 5999.42773, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor1[6], 588.07373 - 1.34, 1475.81750, 5999.42773, 0.9);
		}
		case 7:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[7], 565.61963, 1475.81018, 5999.42773, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor1[7], 565.61963 - 1.34, 1475.81018, 5999.42773, 0.9);
		}
		case 8:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[8], 562.43921, 1473.47998, 5999.42676, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor1[8], 562.43921, 1473.47998 - 1.34, 5999.42676, 0.9);
		}
		case 9:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[9], 587.85999, 1487.88196, 5999.40771, 0.9);//
			if(open == 1) MoveDynamicObject(DocAdmFloor1[9], 587.85999 - 1.34, 1487.88196, 5999.40771, 0.9);//
		}
		case 10:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor1[10], 579.83752, 1492.54773, 5999.40771, 0.9);//
			if(open == 1) MoveDynamicObject(DocAdmFloor1[10], 579.83752 - 1.34, 1492.54773, 5999.40771, 0.9);//
		}
		case 11:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor2[0], 585.09998, 1475.88965, 6006.48047, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor2[0], 585.09998 - 1.34, 1475.88965, 6006.48047, 0.9);
		}
		case 12:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor2[1], 578.65002, 1471.09973, 6006.48047, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor2[1], 578.65002 - 1.34, 1471.09973, 6006.48047, 0.9);
		}
		case 13:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor2[2], 587.15039, 1495.40857, 6006.48047, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor2[2], 587.15039 - 1.34, 1495.40857, 6006.48047, 0.9);
		}
		case 14:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor2[3], 590.52771, 1495.39905, 6006.48047, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor2[3], 590.52771 - 1.34, 1495.39905, 6006.48047, 0.9);
		} 
		case 15:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor2[4], 588.08301, 1475.89587, 6006.48047, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor2[4], 588.08301 - 1.34, 1475.89587, 6006.48047, 0.9);
		}
		case 16:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor2[5], 597.62762, 1492.52954, 6006.48047, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor2[5], 597.62762 - 1.34, 1492.52954, 6006.48047, 0.9);
		}
		case 17:
		{
			if(open == 0) MoveDynamicObject(DocAdmFloor2[6], 591.09857, 1486.54163, 6013.39307, 0.9);
			if(open == 1) MoveDynamicObject(DocAdmFloor2[6], 591.09857 + 1.34, 1486.54163, 6013.39307, 0.9);
		}
	}
}

forward OpenDocAreaDoors(doorid, open);
public OpenDocAreaDoors(doorid, open)
{
	switch(doorid)
	{
		case 0:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[0], 553.22644, 1475.87146, 5995.95947, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[0], 553.22644 - 1.34, 1475.87146, 5995.95947, 0.9);
		}
		case 1:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[1], 553.96301, 1466.10803, 5999.47119, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[1], 553.96301 - 1.34, 1466.10803, 5999.47119, 0.9);
		}
		case 2:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[2], 568.22601, 1455.32703, 5999.47119, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[2], 568.22601, 1455.32703 - 1.34, 5999.47119, 0.9);
		}
		case 3:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[3], 547.46350, 1498.26025, 5995.95947, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[3], 547.46350 - 1.34, 1498.26025, 5995.95947, 0.9);
		}
		case 4:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[4], 549.62292, 1473.38794, 5995.95947, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[4], 549.62292, 1473.38794 - 1.34, 5995.95947, 0.9);
		}
		case 5:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[5], 551.03003, 1471.72058, 5995.95947, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[5], 551.03003 - 1.34, 1471.72058, 5995.95947, 0.9);
		}
		case 6:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[6], 551.03961, 1462.23999, 5995.95947, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[6], 551.03961 - 1.34, 1462.23999, 5995.95947, 0.9);
		}
		case 7:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[7], 573.79968, 1454.22156, 5999.47168, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[7], 573.79968 + 1.34, 1454.22156, 5999.47168, 0.9);
		}
		case 8:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[8], 576.60413, 1449.64075, 5999.47168, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[8], 576.60413, 1449.64075 + 1.34, 5999.47168, 0.9);
		}
		case 9:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[9], 566.11102, 1429.46960, 5999.47168, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[9], 566.11102 + 1.34, 1429.46960, 5999.47168, 0.9);
		}
		case 10:
		{
			if(open == 0) MoveDynamicObject(DocCellRoomDoors[10], 553.28021, 1429.46667, 5999.47168, 0.9);
			if(open == 1) MoveDynamicObject(DocCellRoomDoors[10], 553.28021 + 1.34, 1429.46667, 5999.47168, 0.9);
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

forward MoveDocElevator(level);
public MoveDocElevator(level)
{
	switch(level)
	{
		case 0:
		{
			MoveDynamicObject(DocElevator, 577.03979, 1490.21484, 6001.3125, 0.5);
			MoveDynamicObject(DocInnerElevator[1], 577.0448, 1492.2283, 6001.2954, 0.5);
			MoveDynamicObject(DocInnerElevator[0], 577.0448, 1488.2407, 6001.2954, 0.5);
			MoveButton(DocElevatorInside, 578.91467, 1492.18884, 6001.04785, 0.5);
			iDocElevatorLevel = 0;
			bDocElevatorMoving = true;
		}
		case 1:
		{
			MoveDynamicObject(DocElevator, 577.03979, 1490.21484, 6008.3350, 0.5);
			MoveDynamicObject(DocInnerElevator[1], 577.0448, 1492.2283, 6008.3179, 0.5);
			MoveDynamicObject(DocInnerElevator[0], 577.0448, 1488.2407, 6008.3179, 0.5);
			MoveButton(DocElevatorInside, 578.91467, 1492.18884, 6008.1504, 0.5);
			iDocElevatorLevel = 1;
			bDocElevatorMoving = true;
		}
		case 2:
		{
			MoveDynamicObject(DocElevator, 577.03979, 1490.21484, 6015.3423, 0.5);
			MoveDynamicObject(DocInnerElevator[1], 577.0448, 1492.2283, 6015.3105, 0.5);
			MoveDynamicObject(DocInnerElevator[0], 577.0448, 1488.2407, 6015.3105, 0.5);
			MoveButton(DocElevatorInside, 578.91467, 1492.18884, 6015.1641, 0.5);
			iDocElevatorLevel = 2;
			bDocElevatorMoving = true;
		}
	}
	return 1;
}

forward OpenElevatorDoors(level, open);
public OpenElevatorDoors(level, open)
{
	switch(level)
	{
		case 0:
		{
			if(open == 0)
			{
				MoveDynamicObject(DocElevatorExt[0], 577.10480, 1488.24072, 6001.21533, 0.9);
				MoveDynamicObject(DocElevatorExt[1], 577.10480, 1492.22827, 6001.21533, 0.9);
			}
			if(open == 1)
			{
				MoveDynamicObject(DocElevatorExt[0], 577.10480, 1488.24072 - 1.74, 6001.21533, 0.9);
				MoveDynamicObject(DocElevatorExt[1], 577.10480, 1492.22827 + 1.74, 6001.21533, 0.9);
			}
		}
		case 1:
		{
			if(open == 0)
			{
				MoveDynamicObject(DocElevatorExt[2], 577.10480, 1488.24072, 6008.37744, 0.9);
				MoveDynamicObject(DocElevatorExt[3], 577.10480, 1492.22827, 6008.37744, 0.9);
			}
			if(open == 1)
			{
				MoveDynamicObject(DocElevatorExt[2], 577.10480, 1488.24072 - 1.74, 6008.37744, 0.9);
				MoveDynamicObject(DocElevatorExt[3], 577.10480, 1492.22827 + 1.74, 6008.37744, 0.9);
			}
		}
		case 2:
		{
			if(open == 0)
			{
				MoveDynamicObject(DocElevatorExt[4], 577.10480, 1488.24072, 6015.39063, 0.9);
				MoveDynamicObject(DocElevatorExt[5], 577.10480, 1492.22827, 6015.39063, 0.9);
			}
			if(open == 1)
			{
				MoveDynamicObject(DocElevatorExt[4], 577.10480, 1488.24072 - 1.74, 6015.39063, 0.9);
				MoveDynamicObject(DocElevatorExt[5], 577.10480, 1492.22827 + 1.74, 6015.39063, 0.9);
			}
		}
	}
	return 1;
}

forward OpenInnerDoors(open);
public OpenInnerDoors(open)
{
	switch(open)
	{
		case 0:
		{
			if(iDocElevatorLevel == 0)
			{
				MoveDynamicObject(DocInnerElevator[0], 577.04480, 1488.24072, 6001.29541, 0.9);
				MoveDynamicObject(DocInnerElevator[1], 577.04480, 1492.22827, 6001.29541, 0.9);
			}
			if(iDocElevatorLevel == 1)
			{
				MoveDynamicObject(DocInnerElevator[0], 577.04480, 1488.24072, 6008.37744 + 0.08008, 0.9);
				MoveDynamicObject(DocInnerElevator[1], 577.04480, 1492.22827, 6008.37744 + 0.08008, 0.9);
			}
			if(iDocElevatorLevel == 2)
			{
				MoveDynamicObject(DocInnerElevator[0], 577.04480, 1488.24072, 6015.39063 + 0.08008, 0.9);
				MoveDynamicObject(DocInnerElevator[1], 577.04480, 1492.22827, 6015.39063 + 0.08008, 0.9);
			}
		}
		case 1:
		{
			if(iDocElevatorLevel == 0)
			{
				MoveDynamicObject(DocInnerElevator[0], 577.04480, 1488.24072 - 1.80, 6001.29541, 0.9);
				MoveDynamicObject(DocInnerElevator[1], 577.04480, 1492.22827 + 1.80, 6001.29541, 0.9);
			}
			if(iDocElevatorLevel == 1)
			{
				MoveDynamicObject(DocInnerElevator[0], 577.04480, 1488.24072 - 1.80, 6008.37744 + 0.08008, 0.9);
				MoveDynamicObject(DocInnerElevator[1], 577.04480, 1492.22827 + 1.80, 6008.37744 + 0.08008, 0.9);
			}
			if(iDocElevatorLevel == 2)
			{
				MoveDynamicObject(DocInnerElevator[0], 577.04480, 1488.24072 - 1.80, 6015.39063 + 0.08008, 0.9);
				MoveDynamicObject(DocInnerElevator[1], 577.04480, 1492.22827 + 1.80, 6015.39063 + 0.08008, 0.9);
			}
		}
	}
	return 1;
}

CallDocElevator(playerid, level)
{
	if(bDocElevatorMoving == true) return SendClientMessageEx(playerid, COLOR_RED, "The elevator is currently moving so you are unable to call it.");
	else if(level == iDocElevatorLevel)
	{
		OpenInnerDoors(1);
		OpenElevatorDoors(level, 1);
	}
	else 
	{
		OpenInnerDoors(0);
		OpenElevatorDoors(iDocElevatorLevel, 0);
		SetTimerEx("MoveDocElevator", 5000, false, "i", level); 
	}
	
	return 1;
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
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DIALOG_DOC_ELEVATOR:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: CallDocElevator(playerid, 0);
					case 1: CallDocElevator(playerid, 1);
					case 2: CallDocElevator(playerid, 2);
				}
			}
		}
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
				if(listitem == 11)
				{
					if(bDocAreaOpen[11] == false) bDocAreaOpen[11] = true;
					else bDocAreaOpen[11] = false;
				}
				else if(listitem == 12)
				{
					if(bDocAreaOpen[12] == false) bDocAreaOpen[12] = true;
					else bDocAreaOpen[12] = false;
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
		case DIALOG_DOC_CP_ISOLATION:
		{
			if(response)
			{
				if(bDocIsolationOpen[listitem] == false) OpenDocIsolationCells(listitem, 1);
				else OpenDocIsolationCells(listitem, 0);
				ShowDocPrisonControls(playerid, 5);
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
	return 1;
}

CMD:bail(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0)
	{
		if(JailPrice[playerid] > 0)
		{
			if(GetPlayerCash(playerid) > JailPrice[playerid])
			{
				new string[128];
				format(string, sizeof(string), "You bailed yourself out for $%d.", JailPrice[playerid]);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				GivePlayerCash(playerid, -JailPrice[playerid]);
				JailPrice[playerid] = 0;
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

CMD:backentrance(playerid, params[])
{
	if(IsACop(playerid) && PlayerInfo[playerid][pRank] >= 3) {
	    if(BackEntrance) {
	        BackEntrance = 0;
	        SendClientMessageEx(playerid, COLOR_WHITE, "The back entrance has been locked.");
	    }
	    else {
	        BackEntrance = 1;
	        SendClientMessageEx(playerid, COLOR_WHITE, "The back entrance has been unlocked.");
	    }
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
	return 1;
}

/*CMD:isolate(playerid, params[])
{
	if(!IsACop(playerid)) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}

	else {

		new
		    iGivePlayer,
			szMessage[128];

	    if(sscanf(params, "u", iGivePlayer)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /isolate [player]");
		}
		else if(iGivePlayer == playerid) {
		    SendClientMessageEx(playerid, COLOR_GREY, "You can't use this command on yourself!");
		}
		else if(!IsPlayerConnected(iGivePlayer)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		}
		else if(!ProxDetectorS(10.0, playerid, iGivePlayer)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "That person is to far from you.");
		}
		else {
			if(strfind(PlayerInfo[iGivePlayer][pPrisonReason], "[IC]", true) != -1)
   			{
                strcpy(PlayerInfo[iGivePlayer][pPrisonReason], "[ISOLATE] EBCF Arrest", 128);
         		format(szMessage, sizeof(szMessage), "You have sent %s to isolation.", GetPlayerNameEx(iGivePlayer));
           		SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
            	format(szMessage, sizeof(szMessage), "%s has sent you to isolation.", GetPlayerNameEx(playerid));
	            SendClientMessageEx(iGivePlayer, COLOR_WHITE, szMessage);
	            SetPlayerPos(iGivePlayer, -2095.3391, -215.8563, 978.8315);

	        }
	        else if(strfind(PlayerInfo[iGivePlayer][pPrisonReason], "[ISOLATE]", true) != -1)
	        {
         		new rand;
           		strcpy(PlayerInfo[iGivePlayer][pPrisonReason], "[IC] EBCF Arrest", 128);
	            format(szMessage, sizeof(szMessage), "You have released %s from isolation.", GetPlayerNameEx(iGivePlayer));
	            SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	            format(szMessage, sizeof(szMessage), "%s has released you from isolation.", GetPlayerNameEx(playerid));
	            SendClientMessageEx(iGivePlayer, COLOR_WHITE, szMessage);
          		rand = random(sizeof(DocPrison));
				SetPlayerPos(iGivePlayer, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
		    }
		    else SendClientMessageEx(playerid, COLOR_WHITE, "That person isn't imprisoned.");
		}
	}
	return 1;
}*/

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
			SetPVarInt(playerid, "Arrest_Suspect", suspect);
			SetPVarInt(playerid, "Arrest_Type", 2);
			format(string, sizeof(string), "Please write a brief arrest report on how %s acted during the arrest.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(suspect));
			ShowPlayerDialog(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", string, "Submit", "");
	    }
	}
	return 1;
}

/*CMD:docarrest(playerid, params[])
{
	if(!IsACop(playerid)) SendClientMessageEx(playerid, COLOR_GREY, "You are not part of a LEO faction. ");
	else if(!IsAtArrestPoint(playerid, 2)) SendClientMessageEx(playerid, COLOR_GREY, "You are not at the DoC Prison arrest point." );

	else
	{
   		new
     		moneys,
       		time,
			string[128];

        new suspect = GetClosestPlayer(playerid);
  		if(sscanf(params, "dddd", moneys, time)) SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docarrest [fine] [minutes]");
		else if(!(1 <= moneys <= 250000)) SendClientMessageEx(playerid, COLOR_GREY, "The jail fine can't be below $1 or above $250,000.");
		else if(!(1 <= time <= 120)) SendClientMessageEx(playerid, COLOR_GREY, "Jail time can't be below 1 or above 120 minutes - take the person to prison for more time.");
		else if(!IsPlayerConnected(suspect)) SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		else if(!ProxDetectorS(5.0, playerid, suspect)) SendClientMessageEx(playerid, COLOR_GREY, "You are close enough to the suspect.");
		else if(PlayerInfo[suspect][pWantedLevel] < 1 && PlayerInfo[playerid][pMember] != 12) SendClientMessageEx(playerid, COLOR_GREY, "The person must have a wanted level of at least one star.");
		else {

			format(string, sizeof(string), "* You arrested %s!", GetPlayerNameEx(suspect));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			GivePlayerCash(suspect, -moneys);
			new money = floatround(moneys / 3), iGroupID = PlayerInfo[playerid][pMember];
			Tax += money;
			arrGroupData[iGroupID][g_iBudget] += money;
			new str[128], file[32];
            format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to %s's budget fund.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money, arrGroupData[iGroupID][g_szGroupName]);
            new month, day, year;
			getdate(year,month,day);
			format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
			Log(file, str);
			ResetPlayerWeaponsEx(suspect);
			for(new x; x < MAX_PLAYERVEHICLES; x++) if(PlayerVehicleInfo[suspect][x][pvTicket] >= 1) {
				PlayerVehicleInfo[suspect][x][pvTicket] = 0;
			}
			SetPlayerInterior(suspect, 10);
			new rand = random(sizeof(DocPrison));
			SetPlayerFacingAngle(suspect, 0);
			SetPlayerPos(suspect, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
			if(PlayerInfo[suspect][pDonateRank] >= 2) PlayerInfo[suspect][pJailTime] = ((time*60)*75)/100;
			else PlayerInfo[suspect][pJailTime] = time * 60;
			DeletePVar(suspect, "IsFrozen");
			PhoneOnline[suspect] = 1;
			PlayerInfo[suspect][pArrested] += 1;
			SetPlayerFree(suspect,playerid, "was arrested");
			PlayerInfo[suspect][pWantedLevel] = 0;
			SetPlayerToTeamColor(suspect);
			SetPlayerWantedLevel(suspect, 0);
			WantLawyer[suspect] = 1;
			TogglePlayerControllable(suspect, 1);
			ClearAnimations(suspect);
			SetPlayerSpecialAction(suspect, SPECIAL_ACTION_NONE);
			PlayerCuffed[suspect] = 0;
			DeletePVar(suspect, "PlayerCuffed");
			PlayerCuffedTime[suspect] = 0;
			PlayerInfo[suspect][pVW] = 0;
			SetPlayerVirtualWorld(suspect, 0);
			SetHealth(suspect, 100);
			strcpy(PlayerInfo[suspect][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			strcpy(PlayerInfo[suspect][pPrisonReason], "[IC] EBCF Arrest", 128);
			SetPlayerToTeamColor(suspect);
			Player_StreamPrep(suspect, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);
	    }
	}
	return 1;
}*/

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
     		/*moneys,
       		time,
         	bail,
          	bailprice,*/
			string[256];

        new suspect = GetClosestPlayer(playerid);
  		/*if(sscanf(params, "dddd", moneys, time, bail, bailprice)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /arrest [price] [time (minutes)] [bail (0=no 1=yes)] [bailprice]");
		}
		else if(!(1 <= moneys <= 30000)) {
  			SendClientMessageEx(playerid, COLOR_GREY, "The jail price can't be below $1 or above $30,000.");
		}
		else if(!(1 <= time <= 30)) {
  			SendClientMessageEx(playerid, COLOR_GREY, "Jail time can't be below 1 or above 30 minutes - take the person to prison for more time.");
		}
		else if(!(0 <= bail <= 1)) {
  			SendClientMessageEx(playerid, COLOR_GREY, "The bail option must be set to 0 or 1.");
		}
		else if(!(0 <= bailprice <= 100000)) {
  			SendClientMessageEx(playerid, COLOR_GREY, "The bail price can't be below $0 or above $100,000.");
		}*/
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
			//SetPVarInt(playerid, "Arrest_Bail", bail);
			//SetPVarInt(playerid, "Arrest_BailPrice", bailprice);
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
	if(IsPlayerInRangeOfPoint(playerid, 8, 554.3956,1497.6799,5996.9590))
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
	else if(GetPVarInt(playerid, "OfferingMeal") == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You may only offer food to one person at a time.");
	else if(!PlayerInfo[iGiveTo][pJailTime]) return SendClientMessageEx(playerid, COLOR_WHITE, "You may only offer food to prison inmates.");
	else if(!GetPVarInt(playerid, "inmatefood")) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have any prison food to offer.");
	else if(ProxDetectorS(5.0, playerid, iGiveTo))
	{
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
		ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		//ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 0, 4000, 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 1, 0);
		SetTimerEx("ClearAnims", 3000, false, "d", playerid);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not in range of the person offering you food.");
	return 1;
}

CMD:getfood(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 8, 554.3956,1497.6799,5996.9590))
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
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in IC Jail.");
	else if(iTargetID == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You cannot use this command on yourself.");
	else if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is not connected.");
	else if(!(0 <= iCellID < sizeof(DocIsolation))) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Valid Isolation Cells [0-5]");
	else if(PlayerInfo[iTargetID][pIsolated] == 0)
	{
		DocIsolate(iTargetID, iCellID);
		
		format(string, sizeof(string), "You have been sent to isolation by %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have sent %s to isolation.", GetPlayerNameEx(iTargetID));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
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
			format(szInmates, sizeof(szInmates), "%s\n* %s: %s", szInmates, GetPlayerNameEx(i), TimeConvert(PlayerInfo[i][pJailTime]));
		}
	}
	if(strlen(szInmates) == 0) format(szInmates, sizeof(szInmates), "No inmates");
	ShowPlayerDialog(playerid, DIALOG_DOC_INMATES, DIALOG_STYLE_LIST, "DOC Inmates Logbook", szInmates, "Close", "");
	
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
	if(!IsPlayerInRangeOfPoint(playerid, 20, 594.7211,1481.1313,6007.4780)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the DOC courthouse to use this");
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
	if(!IsPlayerInRangeOfPoint(playerid, 20, 594.7211,1481.1313,6007.4780)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the DOC courthouse to use this");
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
	if(!IsPlayerInRangeOfPoint(playerid, 20, 594.7211,1481.1313,6007.4780)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the DOC courthouse to use this");
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

CMD:jailcall(playerid, params[])
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
				if(GetPlayerSpecialAction(giveplayerid) == SPECIAL_ACTION_HANDSUP || PlayerCuffed[giveplayerid] == 1)
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