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