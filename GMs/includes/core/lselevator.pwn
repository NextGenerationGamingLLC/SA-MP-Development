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

	ShowPlayerDialog(playerid, LAELEVATOR, DIALOG_STYLE_LIST, "Elevator", string, "Select", "Cancel");
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

CMD:floorpass(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4)
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
    if(PlayerInfo[playerid][pAdmin] < 4)
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
    if(PlayerInfo[playerid][pAdmin] < 4)
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
    if(PlayerInfo[playerid][pAdmin] < 4)
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