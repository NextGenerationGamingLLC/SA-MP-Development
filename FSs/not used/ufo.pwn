#include <a_samp>
#define COLOR_WHITE 0xFFFFFFAA

new ufo1, ufo2;
new control[MAX_PLAYERS];

public OnFilterScriptExit()
{
    DestroyObject(ufo1);
    DestroyObject(ufo2);
}

public OnFilterScriptInit()
{
	ufo1 = CreateObject(13607, -1460.199829, -943.961182, 219.348648, 0.0000, 0.0000, 0.0000);
	ufo2 = CreateObject(13607, -1460.167114, -944.012512, 206.879150, 179.6226, 0.0000, 0.0000);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp(cmdtext, "/control", true)==0)
	{
		if(IsPlayerAdmin(playerid))
 		{
 		    if(control[playerid] == 1)
 		    {
 		        control[playerid] = 0;
 		        SendClientMessage(playerid, COLOR_WHITE, "You are no longer controlling the UFO");
			}
			else
			{
			    control[playerid] = 1;
 		    	SendClientMessage(playerid, COLOR_WHITE, "You are now controlling the UFO");
			}
		}
	}
	
 	if(strcmp(cmdtext, "/ufo", true) == 0)
	{
	    if(IsPlayerAdmin(playerid))
	    {
			new Float:X,Float:Y,Float:Z;
			GetObjectPos(ufo1,X,Y,Z);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				SetVehiclePos(GetPlayerVehicleID(playerid),X,Y,Z);
				SetPlayerInterior(playerid,0);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid),0);
			}
			else
			{
			    SetPlayerPos(playerid,X,Y,Z);
				SetPlayerInterior(playerid,0);
			}
		}
		return 1;
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
    if(control[playerid] == 1)
	{
	    new Keys,ud,lr;
	    GetPlayerKeys(playerid,Keys,ud,lr);

	    if(ud > 0)
		{
		    new Float:X, Float:Y, Float:Z, Float:XB, Float:YB, Float:ZB;
		    GetObjectPos(ufo1, X, Y, Z);
		    GetObjectPos(ufo2, XB, YB, ZB);
			MoveObject(ufo1, X, Y - 20, Z, 20);
			MoveObject(ufo2, XB, YB - 20, ZB, 20);
		}
	    else if(ud < 0)
		{
		    new Float:X, Float:Y, Float:Z, Float:XB, Float:YB, Float:ZB;
		    GetObjectPos(ufo1, X, Y, Z);
		    GetObjectPos(ufo2, XB, YB, ZB);
			MoveObject(ufo1, X, Y + 20, Z, 20);
			MoveObject(ufo2, XB, YB + 20, ZB, 20);
		}

	    if(lr > 0)
		{
		    new Float:X, Float:Y, Float:Z, Float:XB, Float:YB, Float:ZB;
		    GetObjectPos(ufo1, X, Y, Z);
		    GetObjectPos(ufo2, XB, YB, ZB);
			MoveObject(ufo1, X + 20, Y, Z, 20);
			MoveObject(ufo2, XB + 20, YB, ZB, 20);
		}
	    else if(lr < 0)
		{
		    new Float:X, Float:Y, Float:Z, Float:XB, Float:YB, Float:ZB;
		    GetObjectPos(ufo1, X, Y, Z);
		    GetObjectPos(ufo2, XB, YB, ZB);
			MoveObject(ufo1, X - 20, Y, Z, 20);
			MoveObject(ufo2, XB - 20, YB, ZB, 20);
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(control[playerid] == 1)
	{
	    if (newkeys & KEY_SPRINT)
	    {
	        new Float:X, Float:Y, Float:Z, Float:XB, Float:YB, Float:ZB;
		    GetObjectPos(ufo1, X, Y, Z);
		    GetObjectPos(ufo2, XB, YB, ZB);
			MoveObject(ufo1, X, Y, Z, 20);
			MoveObject(ufo2, XB, YB, ZB, 20);
			SendClientMessage(playerid, COLOR_WHITE, "Stopping Movement");
	    }
	    if (newkeys & KEY_JUMP)
	    {
	        new Float:X, Float:Y, Float:Z, Float:XB, Float:YB, Float:ZB;
		    GetObjectPos(ufo1, X, Y, Z);
		    GetObjectPos(ufo2, XB, YB, ZB);
			MoveObject(ufo1, X, Y, Z + 10, 20);
			MoveObject(ufo2, XB, YB, ZB + 10, 20);
	    }
	    if (newkeys & KEY_CROUCH)
	    {
            new Float:X, Float:Y, Float:Z, Float:XB, Float:YB, Float:ZB;
		    GetObjectPos(ufo1, X, Y, Z);
		    GetObjectPos(ufo2, XB, YB, ZB);
			MoveObject(ufo1, X, Y, Z - 10, 20);
			MoveObject(ufo2, XB, YB, ZB - 10, 20);
		}
	}
}
