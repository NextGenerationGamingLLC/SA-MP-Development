/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						LS Elevator

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

//Leave this here
new Float:FloorZOffsets[21] =
{
    0.0,		// 0.0,
    8.5479,		// 8.5479,
    13.99945,   // 8.5479 + (5.45155 * 1.0),
    19.45100,   // 8.5479 + (5.45155 * 2.0),
    24.90255,   // 8.5479 + (5.45155 * 3.0),
    30.35410,   // 8.5479 + (5.45155 * 4.0),
    35.80565,   // 8.5479 + (5.45155 * 5.0),
    41.25720,   // 8.5479 + (5.45155 * 6.0),
    46.70875,   // 8.5479 + (5.45155 * 7.0),
    52.16030,   // 8.5479 + (5.45155 * 8.0),
    57.61185,   // 8.5479 + (5.45155 * 9.0),
    63.06340,   // 8.5479 + (5.45155 * 10.0),
    68.51495,   // 8.5479 + (5.45155 * 11.0),
    73.96650,   // 8.5479 + (5.45155 * 12.0),
    79.41805,   // 8.5479 + (5.45155 * 13.0),
    84.86960,   // 8.5479 + (5.45155 * 14.0),
    90.32115,   // 8.5479 + (5.45155 * 15.0),
    95.77270,   // 8.5479 + (5.45155 * 16.0),
    101.22425,  // 8.5479 + (5.45155 * 17.0),
    106.67580,	// 8.5479 + (5.45155 * 18.0),
    112.12735	// 8.5479 + (5.45155 * 19.0)
};

stock LoadElevatorStuff() {

	if(!fexist("elevator.ini")) return 1;

	new
		szFileStr[64],
		iIndex,
		File: iFileHandle = fopen("elevator.ini", io_read);

	while(iIndex < 20 && fread(iFileHandle, szFileStr)) {
		sscanf(szFileStr, "p<|>s[24]s[24]", LAElevatorFloorData[0][iIndex], LAElevatorFloorData[1][iIndex]);
		StripNL(LAElevatorFloorData[1][iIndex]);
	 	iIndex++;
	}
	printf("[LoadElevatorStuff] %i floors loaded.", iIndex);
	return fclose(iFileHandle);
}

stock SaveElevatorStuff() {

	new
		File: iFileHandle = fopen("elevator.ini", io_write);

	for(new iIndex; iIndex < 20; ++iIndex) {
		fwrite(iFileHandle, LAElevatorFloorData[0][iIndex]);
		fputchar(iFileHandle, '|', false);
		fwrite(iFileHandle, LAElevatorFloorData[1][iIndex]);
		fwrite(iFileHandle, "\r\n");
	}
	return fclose(iFileHandle);
}


stock Float:GetElevatorZCoordForFloor(floorid)
{
    return (GROUND_Z_COORD + FloorZOffsets[floorid] + ELEVATOR_OFFSET); // A small offset for the elevator object itself.
}

stock Float:GetDoorsZCoordForFloor(floorid)
{
	return (GROUND_Z_COORD + FloorZOffsets[floorid]);
}

forward Elevator_Boost(floorid);
public Elevator_Boost(floorid)
{
	// Increases the elevator's speed until it reaches 'floorid'

	MoveDynamicObject(Obj_Elevator, 1786.678100, -1303.459472, GetElevatorZCoordForFloor(floorid), ELEVATOR_SPEED);
    MoveDynamicObject(Obj_ElevatorDoors[0], X_DOOR_CLOSED, -1303.459472, GetDoorsZCoordForFloor(floorid), ELEVATOR_SPEED);
    MoveDynamicObject(Obj_ElevatorDoors[1], X_DOOR_CLOSED, -1303.459472, GetDoorsZCoordForFloor(floorid), ELEVATOR_SPEED);
}

forward Elevator_TurnToIdle();
public Elevator_TurnToIdle()
{
	ElevatorState = ELEVATOR_STATE_IDLE;
	ReadNextFloorInQueue();
}

stock Elevator_Initialize()
{
	// Initializes the elevator.

	Obj_Elevator 			= CreateDynamicObject(18755, 1786.678100, -1303.459472, GROUND_Z_COORD + ELEVATOR_OFFSET, 0.000000, 0.000000, 270.000000);
	Obj_ElevatorDoors[0] 	= CreateDynamicObject(18757, X_DOOR_CLOSED, -1303.459472, GROUND_Z_COORD, 0.000000, 0.000000, 270.000000);
	Obj_ElevatorDoors[1] 	= CreateDynamicObject(18756, X_DOOR_CLOSED, -1303.459472, GROUND_Z_COORD, 0.000000, 0.000000, 270.000000);

	Label_Elevator          = CreateDynamic3DTextLabel("Press '~k~~GROUP_CONTROL_BWD~' to use elevator", COLOR_YELLOW, 1784.9822, -1302.0426, 13.6491, 4.0);


	new string[128],
		Float:z;

	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
	    Obj_FloorDoors[i][0] 	= CreateDynamicObject(18757, X_DOOR_CLOSED, -1303.171142, GetDoorsZCoordForFloor(i), 0.000000, 0.000000, 270.000000);
		Obj_FloorDoors[i][1] 	= CreateDynamicObject(18756, X_DOOR_CLOSED, -1303.171142, GetDoorsZCoordForFloor(i), 0.000000, 0.000000, 270.000000);

		format(string, sizeof(string), "%s\nPress '~k~~GROUP_CONTROL_BWD~' to call", LAElevatorFloorData[0][i]);

		if(i == 0)
		    z = 13.4713;
		else
		    z = 13.4713 + 8.7396 + ((i-1) * 5.45155);

		Label_Floors[i]         = CreateDynamic3DTextLabel(string, COLOR_YELLOW, 1783.9799, -1300.7660, z, 10.5);
		// Label_Elevator, Text3D:Label_Floors[21];
	}

	// Open ground floor doors:
	Floor_OpenDoors(0);
	Elevator_OpenDoors();
}

stock Elevator_OpenDoors()
{
	// Opens the elevator's doors.

	new Float:x, Float:y, Float:z;

	GetDynamicObjectPos(Obj_ElevatorDoors[0], x, y, z);
	MoveDynamicObject(Obj_ElevatorDoors[0], X_DOOR_L_OPENED, y, z, DOORS_SPEED);
	MoveDynamicObject(Obj_ElevatorDoors[1], X_DOOR_R_OPENED, y, z, DOORS_SPEED);
}

stock Elevator_CloseDoors()
{
    // Closes the elevator's doors.

    if(ElevatorState == ELEVATOR_STATE_MOVING)
	    return 0;

    new Float:x, Float:y, Float:z;

	GetDynamicObjectPos(Obj_ElevatorDoors[0], x, y, z);
	MoveDynamicObject(Obj_ElevatorDoors[0], X_DOOR_CLOSED, y, z, DOORS_SPEED);
	MoveDynamicObject(Obj_ElevatorDoors[1], X_DOOR_CLOSED, y, z, DOORS_SPEED);
	return 1;
}

stock Floor_OpenDoors(floorid)
{
    // Opens the doors at the specified floor.
    MoveDynamicObject(Obj_FloorDoors[floorid][0], X_DOOR_L_OPENED, -1303.171142, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
	MoveDynamicObject(Obj_FloorDoors[floorid][1], X_DOOR_R_OPENED, -1303.171142, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
}

stock Floor_CloseDoors(floorid)
{
    // Closes the doors at the specified floor.

    MoveDynamicObject(Obj_FloorDoors[floorid][0], X_DOOR_CLOSED, -1303.171142, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
	MoveDynamicObject(Obj_FloorDoors[floorid][1], X_DOOR_CLOSED, -1303.171142, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
}

stock Elevator_MoveToFloor(floorid)
{
	// Moves the elevator to specified floor (doors are meant to be already closed).

	ElevatorState = ELEVATOR_STATE_MOVING;
	ElevatorFloor = floorid;

	// Move the elevator slowly, to give time to clients to sync the object surfing. Then, boost it up:
	MoveDynamicObject(Obj_Elevator, 1786.678100, -1303.459472, GetElevatorZCoordForFloor(floorid), 0.25);
    MoveDynamicObject(Obj_ElevatorDoors[0], X_DOOR_CLOSED, -1303.459472, GetDoorsZCoordForFloor(floorid), 0.25);
    MoveDynamicObject(Obj_ElevatorDoors[1], X_DOOR_CLOSED, -1303.459472, GetDoorsZCoordForFloor(floorid), 0.25);
    DestroyDynamic3DTextLabel(Label_Elevator);

	ElevatorBoostTimer = SetTimerEx("Elevator_Boost", 2000, 0, "i", floorid);
}
			
stock RemoveFirstQueueFloor()
{
	// Removes the data in ElevatorQueue[0], and reorders the queue accordingly.

	for(new i; i < sizeof(ElevatorQueue) - 1; i ++)
	    ElevatorQueue[i] = ElevatorQueue[i + 1];

	ElevatorQueue[sizeof(ElevatorQueue) - 1] = INVALID_FLOOR;
}

stock AddFloorToQueue(floorid)
{
 	// Adds 'floorid' at the end of the queue.

	// Scan for the first empty space:
	new slot = -1;
	for(new i; i < sizeof(ElevatorQueue); i ++)
	{
	    if(ElevatorQueue[i] == INVALID_FLOOR)
	    {
	        slot = i;
	        break;
	    }
	}

	if(slot != -1)
	{
	    ElevatorQueue[slot] = floorid;

     	// If needed, move the elevator.
	    if(ElevatorState == ELEVATOR_STATE_IDLE)
	        ReadNextFloorInQueue();

	    return 1;
	}
	return 0;
}

stock ResetElevatorQueue()
{
	// Resets the queue.

	for(new i; i < sizeof(ElevatorQueue); i ++)
	{
	    ElevatorQueue[i] 	= INVALID_FLOOR;
	    FloorRequestedBy[i] = INVALID_PLAYER_ID;
	}
}

stock IsFloorInQueue(floorid)
{
	// Checks if the specified floor is currently part of the queue.

	for(new i; i < sizeof(ElevatorQueue); i ++)
	    if(ElevatorQueue[i] == floorid)
	        return 1;

	return 0;
}

stock ReadNextFloorInQueue()
{
	// Reads the next floor in the queue, closes doors, and goes to it.

	if(ElevatorState != ELEVATOR_STATE_IDLE || ElevatorQueue[0] == INVALID_FLOOR)
	    return 0;

	Elevator_CloseDoors();
	Floor_CloseDoors(ElevatorFloor);
	return 1;
}

stock DidPlayerRequestElevator(playerid)
{
	for(new i; i < sizeof(FloorRequestedBy); i ++)
	    if(FloorRequestedBy[i] == playerid)
	        return 1;

	return 0;
}

stock ShowElevatorDialog(playerid, elev)
{
	new string[512], maxfloors;
	switch(elev)
	{
		case 1: maxfloors = 20;
		case 2: maxfloors = 8;
	}
 	for(new x; x < maxfloors; x++)
	{
  		format(string, sizeof(string), "%s%d - %s\n", string, (x+1), LAElevatorFloorData[0][x]);
	}

	ShowPlayerDialogEx(playerid, LAELEVATOR, DIALOG_STYLE_LIST, "Elevator", string, "Select", "Cancel");
}

stock CallElevator(playerid, floorid)
{
	// Calls the elevator (also used with the elevator dialog).

	if(FloorRequestedBy[floorid] != INVALID_PLAYER_ID || IsFloorInQueue(floorid))
	    return 0;

	FloorRequestedBy[floorid] = playerid;
	AddFloorToQueue(floorid);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!IsPlayerInAnyVehicle(playerid) && newkeys & KEY_CTRL_BACK)
	{
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		if(pos[1] < -1301.4 && pos[1] > -1303.2417 && pos[0] < 1786.2131 && pos[0] > 1784.1555)
		{    // He is using the elevator button
			PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 10.0, 0, 0, 0, 0, 0);
			ShowElevatorDialog(playerid, 1);
		}
		else    // Is he in a floor button?
		{
			if(pos[1] > -1301.4 && pos[1] < -1299.1447 && pos[0] < 1785.6147 && pos[0] > 1781.9902)
			{
				// He is most likely using it, check floor:
				new i=20;
				while(pos[2] < GetDoorsZCoordForFloor(i) + 3.5 && i > 0)
					i --;

				if(i == 0 && pos[2] < GetDoorsZCoordForFloor(0) + 2.0)
					i = -1;

				if(i <= 19)
				{
					PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
					ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 10.0, 0, 0, 0, 0, 0);
					CallElevator(playerid, i + 1);
					GameTextForPlayer(playerid, "~r~Elevator called", 3500, 4);
				}
			}
		}
	}

	return 1;
}

CMD:floorpass(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new floor, tmp[24];
	if(sscanf(params, "is[24]", floor, tmp))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /floorpass [floor] [pass]");
		return 1;
	}
	new string[128];
	format(LAElevatorFloorData[1][floor-1],24, "%s", tmp);
	format(string, sizeof(string), "Floor %d pass set to %s", floor, LAElevatorFloorData[1][floor-1]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	SaveElevatorStuff();
	return 1;
}

CMD:floorpassr(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new floor;
	if(sscanf(params, "i", floor))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /floorpassr [floor]");
		return 1;
	}
	new string[128];
	floor = floor  - 1;
	format(LAElevatorFloorData[1][floor-1],24, "");
	format(string, sizeof(string), "Floor %d pass removed", floor);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	SaveElevatorStuff();

	new Float:z;
	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
		format(string, sizeof(string), "%s\nPress '~k~~GROUP_CONTROL_BWD~' to call", LAElevatorFloorData[0][i]);

		if(i == 0)
		    z = 13.4713;
		else
		    z = 13.4713 + 8.7396 + ((i-1) * 5.45155);

		DestroyDynamic3DTextLabel(Label_Floors[i]);
		Label_Floors[i]         = CreateDynamic3DTextLabel(string, COLOR_YELLOW, 1783.9799, -1300.7660, z, 10.5);
	}
	return 1;
}

CMD:floornamer(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new floor;
	if(sscanf(params, "i", floor))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /floornamer [floor]");
		return 1;
	}
	new string[128];
	format(LAElevatorFloorData[0][floor-1],24, "");
	format(string, sizeof(string), "Floor %d name removed", floor);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	SaveElevatorStuff();
	new Float:z;
	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
		format(string, sizeof(string), "%s\nPress '~k~~GROUP_CONTROL_BWD~' to call", LAElevatorFloorData[0][i]);

		if(i == 0)
		    z = 13.4713;
		else
		    z = 13.4713 + 8.7396 + ((i-1) * 5.45155);

		DestroyDynamic3DTextLabel(Label_Floors[i]);
		Label_Floors[i]         = CreateDynamic3DTextLabel(string, COLOR_YELLOW, 1783.9799, -1300.7660, z, 10.5);
	}
	return 1;
}

CMD:floorname(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new floor, tmp[24];
	if(sscanf(params, "is[24]", floor, tmp))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /floorname [floor] [name]");
		return 1;
	}
	new string[128];
	format(LAElevatorFloorData[0][floor-1],24, "%s", tmp);
	format(string, sizeof(string), "Renamed Floor %d to %s", floor, LAElevatorFloorData[0][floor-1]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	SaveElevatorStuff();

	new Float:z;
	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
		format(string, sizeof(string), "%s\nPress '~k~~GROUP_CONTROL_BWD~' to call", LAElevatorFloorData[0][i]);

		if(i == 0)
		    z = 13.4713;
		else
		    z = 13.4713 + 8.7396 + ((i-1) * 5.45155);

        DestroyDynamic3DTextLabel(Label_Floors[i]);
		Label_Floors[i]         = CreateDynamic3DTextLabel(string, COLOR_YELLOW, 1783.9799, -1300.7660, z, 10.5);
	}
	return 1;
}