// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Example Filterscript for the new LS Apartments 1 Building with Elevator
// -----------------------------------------------------------------------
// Original elevator code by Zamaroht in 2010
//
// Updated by Kye in 2011
// * Added a sound effect for the elevator starting/stopping
//
// Edited by Matite in January 2015
// * Added code to remove the existing building, add the new building and
//   edited the elevator code so it works in this new building
//
// Updated to v1.02 by Matite in February 2015
// * Added code for the new car park object and edited the elevator to
//   include the car park
//
// This script creates the new LS Apartments 1 building object, removes the
// existing GTASA building object, adds the new car park object and creates
// an elevator that can be used to travel between all levels.
//
// You can un-comment the OnPlayerCommandText callback below to enable a simple
// teleport command (/lsa) that teleports you to the LS Apartments 1 building.
//
// Warning...
// This script uses a total of:
// * 27 objects = 1 for the elevator, 2 for the elevator doors, 22 for the
//   elevator floor doors, 1 for the replacement LS Apartments 1 building
//   and 1 for the car park
// * 12 3D Text Labels = 11 on the floors and 1 in the elevator
// * 1 dialog (for the elevator - dialog ID 876)
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Includes
// --------

// SA-MP include
#include <a_samp>

// For PlaySoundForPlayersInRange()
#include "../include/gl_common.inc"

// -----------------------------------------------------------------------------
// Defines
// -------

// Movement speed of the elevator
#define ELEVATOR_SPEED      (5.0)

// Movement speed of the doors
#define DOORS_SPEED         (5.0)

// Time in ms that the elevator will wait in each floor before continuing with the queue...
// be sure to give enough time for doors to open
#define ELEVATOR_WAIT_TIME  (5000)  

// Dialog ID for the LS Apartments building elevator dialog
#define DIALOG_ID           (876)

// Position defines
#define Y_DOOR_CLOSED       (-1180.535917)
#define Y_DOOR_R_OPENED     Y_DOOR_CLOSED - 1.6
#define Y_DOOR_L_OPENED     Y_DOOR_CLOSED + 1.6

#define GROUND_Z_COORD      (20.879316)

#define ELEVATOR_OFFSET     (0.059523)

#define X_ELEVATOR_POS      (1181.622924)
#define Y_ELEVATOR_POS      (-1180.554687)

// Elevator state defines
#define ELEVATOR_STATE_IDLE     (0)
#define ELEVATOR_STATE_WAITING  (1)
#define ELEVATOR_STATE_MOVING   (2)

// Invalid floor define
#define INVALID_FLOOR           (-1)

// Used for chat text messages
#define COLOR_MESSAGE_YELLOW        0xFFDD00AA

// -----------------------------------------------------------------------------
// Constants
// ---------

// Elevator floor names for the 3D text labels
static FloorNames[11][] =
{
	"Car Park",
	"Ground Floor",
	"First Floor",
	"Second Floor",
	"Third Floor",
	"Fourth Floor",
	"Fifth Floor",
	"Sixth Floor",
	"Seventh Floor",
	"Eighth Floor",
	"Ninth Floor"
};

// Elevator floor Z heights
static Float:FloorZOffsets[11] =
{
    0.0, 		// Car Park
    13.604544,	// Ground Floor
    18.808519,	// First Floor = 13.604544 + 5.203975
    24.012494,  // Second Floor = 18.808519 + 5.203975
    29.216469,  // Third Floor = 24.012494 + 5.203975
    34.420444,  // Fourth Floor = 29.216469 + 5.203975
    39.624419,  // Fifth Floor = 34.420444 + 5.203975
    44.828394,  // Sixth Floor = 39.624419 + 5.203975
    50.032369,  // Seventh Floor = 44.828394 + 5.203975
    55.236344,  // Eighth Floor = 50.032369 + 5.203975
    60.440319   // Ninth Floor = 55.236344 + 5.203975
};

// ------------------------------------------------------------------------------
// Variables
// ---------

// Stores the created object number of the replacement building so it can be
// destroyed when the filterscript is unloaded
new LSApartments1Object;

// Stores the created object number of the new cark park so it can be
// destroyed when the filterscript is unloaded
new LSApartments1CPObject;

// Stores the created object numbers of the elevator, the elevator doors and
// the elevator floor doors so they can be destroyed when the filterscript
// is unloaded
new Obj_Elevator, Obj_ElevatorDoors[2], Obj_FloorDoors[11][2];
	
// Stores a reference to the 3D text labels used on each floor and inside the
// elevator itself so they can be detroyed when the filterscript is unloaded
new Text3D:Label_Elevator, Text3D:Label_Floors[11];

// Stores the current state of the elevator (ie ELEVATOR_STATE_IDLE,
// ELEVATOR_STATE_WAITING or ELEVATOR_STATE_MOVING)
new ElevatorState;

// Stores the current floor the elevator is on or heading to... if the value is
// ELEVATOR_STATE_IDLE or ELEVATOR_STATE_WAITING this is the current floor. If
// the value is ELEVATOR_STATE_MOVING then it is the floor it's moving to
new	ElevatorFloor;  

// Stores the elevator queue for each floor
new ElevatorQueue[11];

// Stores who requested the floor for the elevator queue...
// FloorRequestedBy[floor_id] = playerid;  (stores who requested which floor)
new	FloorRequestedBy[11];

// Used for a timer that makes the elevator move faster after players start
// surfing the object
new ElevatorBoostTimer;

// ------------------------------------------------------------------------------
// Function Forwards
// -----------------

// Public:
forward CallElevator(playerid, floorid);    // You can use INVALID_PLAYER_ID too.
forward ShowElevatorDialog(playerid);

// Private:
forward Elevator_Initialize();
forward Elevator_Destroy();

forward Elevator_OpenDoors();
forward Elevator_CloseDoors();
forward Floor_OpenDoors(floorid);
forward Floor_CloseDoors(floorid);

forward Elevator_MoveToFloor(floorid);
forward Elevator_Boost(floorid);        	// Increases the elevator speed until it reaches 'floorid'.
forward Elevator_TurnToIdle();

forward ReadNextFloorInQueue();
forward RemoveFirstQueueFloor();
forward AddFloorToQueue(floorid);
forward IsFloorInQueue(floorid);
forward ResetElevatorQueue();

forward DidPlayerRequestElevator(playerid);

forward Float:GetElevatorZCoordForFloor(floorid);
forward Float:GetDoorsZCoordForFloor(floorid);

// ------------------------------------------------------------------------------
// Callbacks
// ---------


// Uncomment the OnPlayerCommandText callback below (remove the "/*" and the "*/")
// to enable a simple teleport command (/lsa) which teleports the player to
// outside the LS Apartments 1 building.

/*
public OnPlayerCommandText(playerid, cmdtext[])
{
	// Check command text
	if (strcmp("/lsa", cmdtext, true, 4) == 0)
	{
	    // Set the interior
		SetPlayerInterior(playerid, 0);

		// Set player position and facing angle
		SetPlayerPos(playerid, 1131.07 + random(3), -1180.72 + random(2), 33.32);
		SetPlayerFacingAngle(playerid, 270);

		// Fix camera position after teleporting
		SetCameraBehindPlayer(playerid);

		// Send a gametext message to the player
		GameTextForPlayer(playerid, "~b~~h~LS Apartments 1!", 3000, 3);
	
	    // Exit here
	    return 1;
	}
	
	// Exit here (return 0 as the command was not handled in this filterscript)
	return 0;
}
*/

public OnFilterScriptInit()
{
    // Display information in the Server Console
	print("\n");
	print("  |---------------------------------------------------");
	print("  |--- LS Apartments 1 Filterscript");
    print("  |--  Script v1.02");
    print("  |--  5th February 2015");
	print("  |---------------------------------------------------");

	// Create the LS Apartments 1 Building object
    LSApartments1Object = CreateObject(19595, 1160.96, -1180.58, 70.4141, 0, 0, 0);

    // Display information in the Server Console
    print("  |--  LS Apartments 1 Building object created");
    
    // Create the LS Apartments 1 Car Park object
    LSApartments1CPObject = CreateObject(19798, 1160.96, -1180.58, 20.4141, 0, 0, 0);

    // Display information in the Server Console
    print("  |--  LS Apartments 1 Car Park object created");

    // Reset the elevator queue
	ResetElevatorQueue();

	// Create the elevator object, the elevator doors and the floor doors
	Elevator_Initialize();

	// Display information in the Server Console
    print("  |--  LS Apartments 1 Elevator created");
    print("  |---------------------------------------------------");
    
    // Loop
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        // Check if the player is connected and not a NPC
        if (IsPlayerConnected(i) && !IsPlayerNPC(i))
        {
            // Remove default GTASA building map object, LOD and awning shadows
            // (so any player currently ingame does not have to rejoin for them
			//  to be removed when this filterscript is loaded)
			RemoveBuildingForPlayer(i, 5766, 1160.96, -1180.58, 70.4141, 250.0); // Awning shadows
			RemoveBuildingForPlayer(i, 5767, 1160.96, -1180.58, 70.4141, 250.0); // Building
			RemoveBuildingForPlayer(i, 5964, 1160.96, -1180.58, 70.4141, 250.0); // LOD
        }
    }

	// Exit here
	return 1;
}

public OnFilterScriptExit()
{
    // Check for valid object
	if (IsValidObject(LSApartments1Object))
	{
		// Destroy the LS Apartments 1 Building object
		DestroyObject(LSApartments1Object);

		// Display information in the Server Console
		print("  |---------------------------------------------------");
    	print("  |--  LS Apartments 1 Building object destroyed");
    }
    
    // Check for valid object
	if (IsValidObject(LSApartments1CPObject))
	{
		// Destroy the LS Apartments 1 Car Park object
		DestroyObject(LSApartments1CPObject);

		// Display information in the Server Console
    	print("  |--  LS Apartments 1 Car Park object destroyed");
    }

    // Destroy the elevator, the elevator doors and the elevator floor doors
	Elevator_Destroy();

	// Display information in the Server Console
    print("  |--  LS Apartments 1 Elevator destroyed");
    print("  |---------------------------------------------------");

    // Exit here
	return 1;
}

public OnPlayerConnect(playerid)
{
    // Remove default GTASA building map object, LOD and awning shadows
	RemoveBuildingForPlayer(playerid, 5766, 1160.96, -1180.58, 70.4141, 250.0); // Awning shadows
	RemoveBuildingForPlayer(playerid, 5767, 1160.96, -1180.58, 70.4141, 250.0); // Building
	RemoveBuildingForPlayer(playerid, 5964, 1160.96, -1180.58, 70.4141, 250.0); // LOD

	// Exit here
	return 1;
}

public OnObjectMoved(objectid)
{
	// Create variables
    new Float:x, Float:y, Float:z;
    
    // Loop
	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
	    // Check if the object that moved was one of the elevator floor doors
		if(objectid == Obj_FloorDoors[i][0])
		{
		    GetObjectPos(Obj_FloorDoors[i][0], x, y, z);

            // Some floor doors have shut, move the elevator to next floor in queue:
            if (y < Y_DOOR_L_OPENED - 0.5)
		    {
				Elevator_MoveToFloor(ElevatorQueue[0]);
				RemoveFirstQueueFloor();
			}
		}
	}

	if(objectid == Obj_Elevator)   // The elevator reached the specified floor.
	{
	    KillTimer(ElevatorBoostTimer);  // Kills the timer, in case the elevator reached the floor before boost.

	    FloorRequestedBy[ElevatorFloor] = INVALID_PLAYER_ID;

	    Elevator_OpenDoors();
	    Floor_OpenDoors(ElevatorFloor);

	    GetObjectPos(Obj_Elevator, x, y, z);
	    Label_Elevator	= Create3DTextLabel("{CCCCCC}Press '{FFFFFF}~k~~CONVERSATION_YES~{CCCCCC}' to use elevator", 0xCCCCCCAA, X_ELEVATOR_POS - 1.7, Y_ELEVATOR_POS - 1.75, z - 0.4, 4.0, 0, 1);

	    ElevatorState 	= ELEVATOR_STATE_WAITING;
	    SetTimer("Elevator_TurnToIdle", ELEVATOR_WAIT_TIME, 0);
	}

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_ID)
    {
        if(!response)
            return 0;

        if(FloorRequestedBy[listitem] != INVALID_PLAYER_ID || IsFloorInQueue(listitem))
            GameTextForPlayer(playerid, "~r~The floor is already in the queue", 3500, 4);
		else if(DidPlayerRequestElevator(playerid))
		    GameTextForPlayer(playerid, "~r~You already requested the elevator", 3500, 4);
		else
	        CallElevator(playerid, listitem);

		return 1;
    }

	return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    // Check if the player is not in a vehicle and pressed the conversation yes key (Y by default)
	if (!IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_YES))
	{
	    // Create variables and get the players current position
	    new Float:pos[3];
	    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    
	    // For debug
	    //printf("X = %0.2f | Y = %0.2f | Z = %0.2f", pos[0], pos[1], pos[2]);

        // Check if the player is using the button inside the elevator
	    if (pos[1] > (Y_ELEVATOR_POS - 1.8) && pos[1] < (Y_ELEVATOR_POS + 1.8) && pos[0] < (X_ELEVATOR_POS + 1.8) && pos[0] > (X_ELEVATOR_POS - 1.8))
	    {
	        // The player is using the button inside the elevator
	        // --------------------------------------------------
	        
	        // Show the elevator dialog to the player
	        ShowElevatorDialog(playerid);
	    }
		else
		{
		    // Check if the player is using the button on one of the floors
		    if(pos[1] < (Y_ELEVATOR_POS - 1.81) && pos[1] > (Y_ELEVATOR_POS - 3.8) && pos[0] > (X_ELEVATOR_POS - 3.8) && pos[0] < (X_ELEVATOR_POS - 1.81))
		    {
		        // The player is most likely using an elevator floor button... check which floor
		        // -----------------------------------------------------------------------------
		        
		        // Create variable with the number of floors to check (total floors minus 1)
				new i = 10;

				// Loop
				while(pos[2] < GetDoorsZCoordForFloor(i) + 3.5 && i > 0)
				    i --;

				if(i == 0 && pos[2] < GetDoorsZCoordForFloor(0) + 2.0)
				    i = -1;

				if (i <= 9)
				{
				    // Check if the elevator is not moving (idle or waiting)
				    if (ElevatorState != ELEVATOR_STATE_MOVING)
				    {
				        // Check if the elevator is already on the floor it was called from
				        if (ElevatorFloor == i + 1)
				        {
				            // Display gametext message to the player
							GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~y~~h~LS Apartments 1 Elevator Is~n~~y~~h~Already On This Floor...~n~~w~Walk Inside It~n~~w~And Press '~k~~CONVERSATION_YES~'", 3500, 3);

							// Display chat text message to the player
	                        SendClientMessage(playerid, COLOR_MESSAGE_YELLOW, "* The LS Apartments 1 elevator is already on this floor... walk inside it and press '{FFFFFF}~k~~CONVERSATION_YES~{CCCCCC}'");

                            // Exit here (return 1 so this callback is processed in other scripts)
	                        return 1;
				        }
				    }

				    // Call function to call the elevator to the floor
					CallElevator(playerid, i + 1);

					// Display gametext message to the player
					GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~g~~h~LS Apartments 1 Elevator~n~~g~~h~Has Been Called...~n~~w~Please Wait", 3000, 3);

					// Create variable for formatted message
					new strTempString[100];
					
					// Check if the elevator is moving
					if (ElevatorState == ELEVATOR_STATE_MOVING)
					{
					    // Format chat text message
						format(strTempString, sizeof(strTempString), "* The LS Apartments 1 elevator has been called... it is currently moving towards the %s.", FloorNames[ElevatorFloor]);
					}
					else
					{
					    // Check if the floor is the car park
					    if (ElevatorFloor == 0)
					    {
					    	// Format chat text message
							format(strTempString, sizeof(strTempString), "* The LS Apartments 1 elevator has been called... it is currently at the %s.", FloorNames[ElevatorFloor]);
						}
						else
						{
					    	// Format chat text message
							format(strTempString, sizeof(strTempString), "* The LS Apartments 1 elevator has been called... it is currently on the %s.", FloorNames[ElevatorFloor]);
						}
					}
					
					// Display formatted chat text message to the player
					SendClientMessage(playerid, COLOR_MESSAGE_YELLOW, strTempString);

					// Exit here (return 1 so this callback is processed in other scripts)
					return 1;
				}
		    }
		}
	}

    // Exit here (return 1 so this callback is processed in other scripts)
	return 1;
}

// ------------------------ Functions ------------------------
stock Elevator_Initialize()
{
	// Create the elevator and elevator door objects
	Obj_Elevator 			= CreateObject(18755, X_ELEVATOR_POS, Y_ELEVATOR_POS, GROUND_Z_COORD + ELEVATOR_OFFSET, 0.000000, 0.000000, 0.000000);
	Obj_ElevatorDoors[0] 	= CreateObject(18757, X_ELEVATOR_POS, Y_ELEVATOR_POS, GROUND_Z_COORD + ELEVATOR_OFFSET, 0.000000, 0.000000, 0.000000);
	Obj_ElevatorDoors[1] 	= CreateObject(18756, X_ELEVATOR_POS, Y_ELEVATOR_POS, GROUND_Z_COORD + ELEVATOR_OFFSET, 0.000000, 0.000000, 0.000000);

    // Create the 3D text label for inside the elevator
	Label_Elevator = Create3DTextLabel("{CCCCCC}Press '{FFFFFF}~k~~CONVERSATION_YES~{CCCCCC}' to use elevator", 0xCCCCCCAA, X_ELEVATOR_POS - 1.7, Y_ELEVATOR_POS - 1.75, GROUND_Z_COORD - 0.4, 4.0, 0, 1);

	// Create variables
	new string[128], Float:z;

	// Loop
	for (new i; i < sizeof(Obj_FloorDoors); i ++)
	{
	    // Create elevator floor door objects
	    Obj_FloorDoors[i][0] 	= CreateObject(18757, X_ELEVATOR_POS - 0.245, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(i), 0.000000, 0.000000, 0.000000);
		Obj_FloorDoors[i][1] 	= CreateObject(18756, X_ELEVATOR_POS - 0.245, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(i), 0.000000, 0.000000, 0.000000);

		// Format string for the floor 3D text label
		format(string, sizeof(string), "{CCCCCC}[%s]\n{CCCCCC}Press '{FFFFFF}~k~~CONVERSATION_YES~{CCCCCC}' to call", FloorNames[i]);

		// Get label Z position
		z = GetDoorsZCoordForFloor(i);

		// Create floor label
		Label_Floors[i] = Create3DTextLabel(string, 0xCCCCCCAA, X_ELEVATOR_POS - 2.5, Y_ELEVATOR_POS - 2.5, z - 0.2, 10.5, 0, 1);
	}

	// Open the car park floor doors and the elevator doors
	Floor_OpenDoors(0);
	Elevator_OpenDoors();

    // Exit here
	return 1;
}

stock Elevator_Destroy()
{
	// Destroys the elevator.

	DestroyObject(Obj_Elevator);
	DestroyObject(Obj_ElevatorDoors[0]);
	DestroyObject(Obj_ElevatorDoors[1]);
	Delete3DTextLabel(Label_Elevator);

	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
	    DestroyObject(Obj_FloorDoors[i][0]);
		DestroyObject(Obj_FloorDoors[i][1]);
		Delete3DTextLabel(Label_Floors[i]);
	}

	return 1;
}

stock Elevator_OpenDoors()
{
	// Opens the elevator's doors.

	new Float:x, Float:y, Float:z;

	GetObjectPos(Obj_ElevatorDoors[0], x, y, z);
	MoveObject(Obj_ElevatorDoors[0], x, Y_DOOR_L_OPENED, z, DOORS_SPEED);
	MoveObject(Obj_ElevatorDoors[1], x, Y_DOOR_R_OPENED, z, DOORS_SPEED);

	return 1;
}

stock Elevator_CloseDoors()
{
    // Closes the elevator's doors.

    if(ElevatorState == ELEVATOR_STATE_MOVING)
	    return 0;

    new Float:x, Float:y, Float:z;

	GetObjectPos(Obj_ElevatorDoors[0], x, y, z);
	MoveObject(Obj_ElevatorDoors[0], x, Y_DOOR_CLOSED, z, DOORS_SPEED);
	MoveObject(Obj_ElevatorDoors[1], x, Y_DOOR_CLOSED, z, DOORS_SPEED);

	return 1;
}

stock Floor_OpenDoors(floorid)
{
    // Opens the doors at the specified floor.

    MoveObject(Obj_FloorDoors[floorid][0], X_ELEVATOR_POS - 0.245, Y_DOOR_L_OPENED, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
	MoveObject(Obj_FloorDoors[floorid][1], X_ELEVATOR_POS - 0.245, Y_DOOR_R_OPENED, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
	
	PlaySoundForPlayersInRange(6401, 50.0, X_ELEVATOR_POS, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(floorid) + 5.0);

	return 1;
}

stock Floor_CloseDoors(floorid)
{
    // Closes the doors at the specified floor.

    MoveObject(Obj_FloorDoors[floorid][0], X_ELEVATOR_POS - 0.245, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
	MoveObject(Obj_FloorDoors[floorid][1], X_ELEVATOR_POS - 0.245, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
	
	PlaySoundForPlayersInRange(6401, 50.0, X_ELEVATOR_POS, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(floorid) + 5.0);

	return 1;
}

stock Elevator_MoveToFloor(floorid)
{
	// Moves the elevator to specified floor (doors are meant to be already closed).

	ElevatorState = ELEVATOR_STATE_MOVING;
	ElevatorFloor = floorid;

	// Move the elevator slowly, to give time to clients to sync the object surfing. Then, boost it up:
	MoveObject(Obj_Elevator, X_ELEVATOR_POS, Y_ELEVATOR_POS, GetElevatorZCoordForFloor(floorid), 0.25);
    MoveObject(Obj_ElevatorDoors[0], X_ELEVATOR_POS, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(floorid), 0.25);
    MoveObject(Obj_ElevatorDoors[1], X_ELEVATOR_POS, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(floorid), 0.25);
    Delete3DTextLabel(Label_Elevator);

	ElevatorBoostTimer = SetTimerEx("Elevator_Boost", 2000, 0, "i", floorid);

	return 1;
}

public Elevator_Boost(floorid)
{
	// Increases the elevator's speed until it reaches 'floorid'
	StopObject(Obj_Elevator);
	StopObject(Obj_ElevatorDoors[0]);
	StopObject(Obj_ElevatorDoors[1]);
	
	MoveObject(Obj_Elevator, X_ELEVATOR_POS, Y_ELEVATOR_POS, GetElevatorZCoordForFloor(floorid), ELEVATOR_SPEED);
    MoveObject(Obj_ElevatorDoors[0], X_ELEVATOR_POS, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(floorid), ELEVATOR_SPEED);
    MoveObject(Obj_ElevatorDoors[1], X_ELEVATOR_POS, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(floorid), ELEVATOR_SPEED);

	return 1;
}

public Elevator_TurnToIdle()
{
	ElevatorState = ELEVATOR_STATE_IDLE;
	ReadNextFloorInQueue();

	return 1;
}

stock RemoveFirstQueueFloor()
{
	// Removes the data in ElevatorQueue[0], and reorders the queue accordingly.

	for(new i; i < sizeof(ElevatorQueue) - 1; i ++)
	    ElevatorQueue[i] = ElevatorQueue[i + 1];

	ElevatorQueue[sizeof(ElevatorQueue) - 1] = INVALID_FLOOR;

	return 1;
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

	return 1;
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

stock ShowElevatorDialog(playerid)
{
	new string[512];
	for(new i; i < sizeof(ElevatorQueue); i ++)
	{
	    if(FloorRequestedBy[i] != INVALID_PLAYER_ID)
	        strcat(string, "{FF0000}");

	    strcat(string, FloorNames[i]);
	    strcat(string, "\n");
	}

	ShowPlayerDialog(playerid, DIALOG_ID, DIALOG_STYLE_LIST, "LS Apartments 1 Elevator...", string, "Accept", "Cancel");

	return 1;
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

stock Float:GetElevatorZCoordForFloor(floorid)
{
    // Return Z height value plus a small offset
    return (GROUND_Z_COORD + FloorZOffsets[floorid] + ELEVATOR_OFFSET);
}

stock Float:GetDoorsZCoordForFloor(floorid)
{
	// Return Z height value plus a small offset
	return (GROUND_Z_COORD + FloorZOffsets[floorid] + ELEVATOR_OFFSET);
}

