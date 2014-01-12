#include <a_samp>
#include <streamer>
#include <foreach>

#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_YELLOW 0xFFFF00AA
#define LIGHT_BLUE 0x33CCFFAA

new backlift;
new sidelift;
new backhatch;

new Carrier[17];
new CarrierS[14];
new NGVehicles[21];
new Range;
new RangeGuy[6];

new control[MAX_PLAYERS];
new controlspeed[MAX_PLAYERS];
new controldistance[MAX_PLAYERS];
new ControlTimer[MAX_PLAYERS];

forward ControlCam(playerid);
forward RedoRange();
forward RedoRange2();

new canmove;

public OnFilterScriptInit()
{
    sidelift = CreateObject(3114, 231.916656, 4615.134277, 17.269205, 0.0000, 0.0000, 0.0000); // Side Lift Up
	backhatch = CreateObject(3113, 180.344864, 4600.390137, 2.516232, 0.0000, 0.0000, 0.0000); // Back Hatch Closed
	backlift = CreateObject(3115, 189.694626, 4599.983398, 17.483730, 0.0000, 0.0000, 0.0000); // Back Lift Up

	Carrier[0] = CreateObject(10771, 288.665771, 4600.003418, 6.032381, 0.0000, 0.0000, 0.0000, 300);
	Carrier[1] = CreateObject(11145, 225.782196, 4600.015137, 4.754915, 0.0000, 0.0000, 0.0000, 300);
	Carrier[2] = CreateObject(11149, 282.526093, 4594.805176, 12.487646, 0.0000, 0.0000, 0.0000, 300);
	Carrier[3] = CreateObject(11146, 279.620544, 4600.541016, 12.893089, 0.0000, 0.0000, 0.0000, 300);
	Carrier[4] = CreateObject(10770, 291.858917, 4592.397949, 39.171509, 0.0000, 0.0000, 0.0000, 300);
	Carrier[5] = CreateObject(10772, 290.014313, 4599.787598, 17.833616, 0.0000, 0.0000, 0.0000, 300);
	Carrier[6] = CreateObject(1671, 354.860748, 4589.442383, 11.234554, 0.0000, 0.0000, 175.3254, 300);
	Carrier[7] = CreateObject(925, 304.330383, 4589.067383, 11.735489, 0.0000, 0.0000, 0.0000, 300);
	Carrier[8] = CreateObject(930, 301.851654, 4588.497070, 11.131838, 0.0000, 0.0000, 0.0000, 300);
	Carrier[9] = CreateObject(930, 301.856079, 4589.598145, 11.181837, 0.0000, 0.0000, 0.0000, 300);
	Carrier[10] = CreateObject(964, 300.513062, 4589.303711, 10.705961, 0.0000, 0.0000, 177.4217, 300);
	Carrier[11] = CreateObject(964, 299.024902, 4589.362793, 10.698584, 0.0000, 0.0000, 177.4217, 300);
	Carrier[12] = CreateObject(1271, 305.058319, 4591.442871, 11.048584, 0.0000, 0.0000, 359.1406, 300);
	Carrier[13] = CreateObject(1431, 303.009491, 4591.383789, 11.253574, 0.0000, 0.0000, 0.0000, 300);
	Carrier[14] = CreateObject(2567, 297.100800, 4591.239746, 12.558563, 0.0000, 0.0000, 91.1003, 300);
	Carrier[15] = CreateObject(3576, 301.050110, 4593.777344, 12.198634, 0.0000, 0.0000, 0.0000, 300);
	Carrier[16] = CreateObject(3633, 304.567841, 4593.262207, 11.173386, 0.0000, 0.0000, 0.0000, 300);
	
	CarrierS[0] = CreateDynamicObject(3267, 320.358582, 4592.519043, 21.567169, 0.0000, 0.0000, 0.0000);
	CarrierS[1] = CreateDynamicObject(11237, 291.557526, 4592.407715, 39.065594, 0.0000, 0.0000, 0.0000);
	CarrierS[2] = CreateDynamicObject(3395, 354.861725, 4590.989746, 10.797120, 0.0000, 0.0000, 88.0403);
	CarrierS[3] = CreateDynamicObject(1671, 356.571838, 4588.612793, 11.234554, 0.0000, 0.0000, 134.9316);
	CarrierS[4] = CreateDynamicObject(3393, 358.360016, 4588.834961, 10.797121, 0.0000, 0.0000, 0.0000);
	CarrierS[5] = CreateDynamicObject(3277, 320.391876, 4592.538086, 21.514416, 0.0000, 0.0000, 164.0483);
	
 	NGVehicles[0] = AddStaticVehicleEx(520,248.0794,3594.3105,11.5239,2.7183,0,0,30000); // hydra 1
  	NGVehicles[1] = AddStaticVehicleEx(520,237.9068,3594.1855,11.5200,359.5102,0,0,30000); // hydra2
   	NGVehicles[2] = AddStaticVehicleEx(520,227.9109,3594.4126,11.5253,357.3820,0,0,30000); // hydra3
   	NGVehicles[3] = AddStaticVehicleEx(430,199.3280,3591.4453,-0.6940,90.6359,0,110,30000); // Cop boat
   	NGVehicles[4] = AddStaticVehicleEx(430,200.1194,3596.4458,-0.7851,91.4565,0,110,30000); // Cop boat 2
   	NGVehicles[5] = AddStaticVehicleEx(595,201.8044,3609.0137,0.2197,92.5798,112,20,30000); // predator
    NGVehicles[6] = AddStaticVehicleEx(595,204.8774,3603.1533,-0.2992,89.2164,112,20,30000); // predator2
    NGVehicles[7] = AddStaticVehicleEx(539,221.6902,3609.5674,2.8996,89.0397,0,110,30000); // vortex 1
    NGVehicles[8] = AddStaticVehicleEx(539,221.7372,3603.2832,2.9000,91.7202,0,110,30000); // vortex 2
    NGVehicles[9] = AddStaticVehicleEx(425,251.1378,3595.0029,19.5374,38.5798,0,0,30000); // hunterondeck1
    NGVehicles[10] = AddStaticVehicleEx(425,239.3769,3595.5366,19.5370,34.9381,0,0,30000); // hunterondeck2
    NGVehicles[11] = AddStaticVehicleEx(425,227.2570,3595.8970,19.5330,36.2626,0,0,30000); // hunterondeck3
    NGVehicles[12] = AddStaticVehicleEx(548,339.1287,3592.5342,19.5370,318.6580,0,0,30000); // cargoondeck4
    NGVehicles[13] = AddStaticVehicleEx(548,350.7022,3592.5835,19.5370,322.3175,0,0,30000); // cargoondeck5
    NGVehicles[14] = AddStaticVehicleEx(548,362.1107,3592.6118,19.5370,323.1028,0,0,30000); // cargoondeck6
    NGVehicles[15] = AddStaticVehicleEx(548,373.5303,3592.8457,19.5370,324.9776,0,0,30000); // cargoondeck7
    NGVehicles[16] = AddStaticVehicleEx(417,213.0728,3592.1421,20.4642,269.6004,1,1,30000); // Leviathan
    NGVehicles[17] = AddStaticVehicleEx(417,384.6175,3592.6875,19.3947,90.9128,43,0,30000); // Leviathan
    NGVehicles[18] = AddStaticVehicleEx(520,351.6037,3607.6841,12.5242,88.6799,0,0,30000); // Hydra
    NGVehicles[19] = AddStaticVehicleEx(520,351.6037,3597.3706,12.5242,88.6799,0,0,30000); // Hydra
    NGVehicles[20] = AddStaticVehicleEx(583,308.3741,3591.9722,11.7993,266.5796,1,1,30000); // Caddy
    
    for(new x;x<sizeof(NGVehicles);x++)
    {
		OnVehicleSpawn(NGVehicles[x]);
	}

	return 1;
}

Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
  new Float:x, Float:y, Float:z;
  x = x1-x2;
  y = y1-y2;
  z = z1-z2;
  return floatsqroot(x*x+y*y+z*z);
}

Float:GetPointDistanceToPointEx(Float:x1,Float:y1,Float:x2,Float:y2)
{
  new Float:x, Float:y;
  x = x1-x2;
  y = y1-y2;
  return floatsqroot(x*x+y*y);
}

stock LoadNGVehicles()
{
    new Float:X, Float:Y, Float:Z;
    for(new x;x<sizeof(NGVehicles);x++)
	{
	    GetVehiclePos(NGVehicles[x], X, Y, Z);
	    if(GetPointDistanceToPointEx(X, Y, 20000, 20000) < 1000) SetVehicleToRespawn(NGVehicles[x]);
	}
}

stock UnloadNGVehicles()
{
    new Float:X, Float:Y, Float:Z;
    new Float:XB, Float:YB, Float:ZB;
    GetObjectPos(Carrier[0], XB, YB, ZB);
    for(new x;x<sizeof(NGVehicles);x++)
	{
	    GetVehiclePos(NGVehicles[x], X, Y, Z);
	    if(GetPointDistanceToPoint(X, Y, Z, XB, YB, ZB) < 250) SetVehiclePos(NGVehicles[x], 20000, 20000, 20000);
	}
}

public OnVehicleSpawn(vehicleid)
{
    for(new x;x<sizeof(NGVehicles);x++)
	{
	    if(NGVehicles[x] == vehicleid)
	    {
	        new Float:X, Float:Y, Float:Z;
	        GetObjectPos(Carrier[0], X, Y, Z);
	    	if(vehicleid == NGVehicles[0]) SetVehiclePos(vehicleid, (X-40.586371), (Y-5.692918), 11.5239);
	    	else if(vehicleid == NGVehicles[1]) SetVehiclePos(vehicleid, (X-50.758971), (Y-5.817918), 11.5200);
		    else if(vehicleid == NGVehicles[2]) SetVehiclePos(vehicleid, (X-60.754871), (Y-5.590818), 11.5239);
		    else if(vehicleid == NGVehicles[3]) SetVehiclePos(vehicleid, (X-89.337771), (Y-8.558118) ,-0.6940);
		    else if(vehicleid == NGVehicles[4]) SetVehiclePos(vehicleid, (X-88.546371), (Y-3.55761), -0.7851);
		    else if(vehicleid == NGVehicles[5]) SetVehiclePos(vehicleid, (X-83.861371), (Y+9.010282),0.2197);
		    else if(vehicleid == NGVehicles[6]) SetVehiclePos(vehicleid, (X-83.788371), (Y+3.149882), -0.2992);
		    else if(vehicleid == NGVehicles[7]) SetVehiclePos(vehicleid, (X-66.975571), (Y+2.436018), 2.8996);
		    else if(vehicleid == NGVehicles[8]) SetVehiclePos(vehicleid, (X-66.928571), (Y+8.720218), 2.9000);
		    else if(vehicleid == NGVehicles[9]) SetVehiclePos(vehicleid, (X-37.527971), (Y-5.000518), 19.5374);
		    else if(vehicleid == NGVehicles[10]) SetVehiclePos(vehicleid, (X-49.288871), (Y-4.466818), 19.5374);
		    else if(vehicleid == NGVehicles[11]) SetVehiclePos(vehicleid, (X-61.408771), (Y-4.106418), 19.5374);
		   	else if(vehicleid == NGVehicles[12]) SetVehiclePos(vehicleid, (X+50.462929), (Y-7.469218), 19.5374);
		    else if(vehicleid == NGVehicles[13]) SetVehiclePos(vehicleid, (X+62.036429), (Y-7.419918), 19.5374);
		    else if(vehicleid == NGVehicles[14]) SetVehiclePos(vehicleid, (X+73.444929), (Y-7.391618), 19.5374);
		    else if(vehicleid == NGVehicles[15]) SetVehiclePos(vehicleid, (X+84.864529), (Y-7.157718), 19.5374);
		    else if(vehicleid == NGVehicles[16]) SetVehiclePos(vehicleid, (X-75.592971), (Y-7.861318), 20.4642);
		    else if(vehicleid == NGVehicles[17]) SetVehiclePos(vehicleid, (X+95.951729), (Y-7.315918), 19.3947);
		    else if(vehicleid == NGVehicles[18]) SetVehiclePos(vehicleid, (X+62.937929), (Y+7.680682), 12.5242);
		    else if(vehicleid == NGVehicles[19]) SetVehiclePos(vehicleid, (X+62.937929), (Y-2.632818), 12.5242);
		    else if(vehicleid == NGVehicles[20]) SetVehiclePos(vehicleid, (X+19.708329), (Y-8.031218), 11.7993);
	    }
	}
}

public OnFilterScriptExit()
{
	for(new x;x<sizeof(Carrier);x++)
	{
	    if(IsValidObject(Carrier[x]))
	    {
	        DestroyObject(Carrier[x]);
		}
	}
	for(new x;x<sizeof(RangeGuy);x++)
	{
	    if(IsValidObject(RangeGuy[x])) DestroyObject(RangeGuy[x]);
	}
	DestroyObject(sidelift);
	DestroyObject(backhatch);
	DestroyObject(backlift);
	
	for(new x;x<sizeof(NGVehicles);x++)
	{
		DestroyVehicle(NGVehicles[x]);
	}
}

public OnPlayerDisconnect(playerid)
{
	if(control[playerid] == 1)
	{
		control[playerid] = 0;
		KillTimer(ControlTimer[playerid]);
	}
}

public OnDynamicObjectMoved(objectid)
{
	if(objectid == CarrierS[5])
	{
	    canmove = 0;
	}
}

public ControlCam(playerid)
{
    new Float:X, Float:Y, Float:Z;
	GetObjectPos(Carrier[0], X, Y, Z);
 	SetPlayerCameraPos(playerid, X-200, Y, Z+40);
  	SetPlayerCameraLookAt(playerid, X, Y, Z);
}

public OnPlayerUpdate(playerid)
{
    if(control[playerid] == 1)
	{
	    new Keys,ud,lr;
	    GetPlayerKeys(playerid,Keys,ud,lr);

	    if(ud > 0)
		{
		    if(canmove == 1) return 1;
		    else canmove = 1;

			new distance = controldistance[playerid];
		    new speed = controlspeed[playerid];

		    new Float:XA[17], Float:YA[17], Float:ZA[17];
		    new Float:XB[14], Float:YB[14], Float:ZB[14];
		    new Float:XC[3], Float:YC[3], Float:ZC[3];

			for(new x;x<sizeof(Carrier);x++)
			{
			    GetObjectPos(Carrier[x], XA[x], YA[x], ZA[x]);
			}
			for(new x;x<sizeof(CarrierS);x++)
			{
			    GetDynamicObjectPos(CarrierS[x], XB[x], YB[x], ZB[x]);
			}

			GetObjectPos(sidelift, XC[0], YC[0], ZC[0]);
			GetObjectPos(backhatch, XC[1], YC[1], ZC[1]);
			GetObjectPos(backlift, XC[2], YC[2], ZC[2]);

			for(new x;x<sizeof(Carrier);x++)
			{
   				MoveObject(Carrier[x], XA[x]-distance, YA[x], ZA[x], speed);
			}
			for(new x;x<sizeof(CarrierS);x++)
			{
				MoveDynamicObject(CarrierS[x], XB[x]-distance, YB[x], ZB[x], speed);
			}

			MoveObject(sidelift, XC[0]-distance, YC[0], ZC[0], speed);
			MoveObject(backhatch, XC[1]-distance, YC[1], ZC[1], speed);
			MoveObject(backlift, XC[2]-distance, YC[2], ZC[2], speed);
		}
	    else if(ud < 0)
		{
		    if(canmove == 1) return 1;
		    else canmove = 1;

            new distance = controldistance[playerid];
		    new speed = controlspeed[playerid];

		    new Float:XA[17], Float:YA[17], Float:ZA[17];
		    new Float:XB[14], Float:YB[14], Float:ZB[14];
		    new Float:XC[3], Float:YC[3], Float:ZC[3];
		    
			for(new x;x<sizeof(Carrier);x++)
			{
			    GetObjectPos(Carrier[x], XA[x], YA[x], ZA[x]);
			}
			for(new x;x<sizeof(CarrierS);x++)
			{
			    GetDynamicObjectPos(CarrierS[x], XB[x], YB[x], ZB[x]);
			}
			
			GetObjectPos(sidelift, XC[0], YC[0], ZC[0]);
			GetObjectPos(backhatch, XC[1], YC[1], ZC[1]);
			GetObjectPos(backlift, XC[2], YC[2], ZC[2]);
			
			for(new x;x<sizeof(Carrier);x++)
			{
   				MoveObject(Carrier[x], XA[x]+distance, YA[x], ZA[x], speed);
			}
			for(new x;x<sizeof(CarrierS);x++)
			{
				MoveDynamicObject(CarrierS[x], XB[x]+distance, YB[x], ZB[x], speed);
			}
			
			MoveObject(sidelift, XC[0]+distance, YC[0], ZC[0], speed);
			MoveObject(backhatch, XC[1]+distance, YC[1], ZC[1], speed);
			MoveObject(backlift, XC[2]+distance, YC[2], ZC[2], speed);
		}

	    if(lr > 0)
		{
		    if(canmove == 1) return 1;
		    else canmove = 1;

		    new distance = controldistance[playerid];
		    new speed = controlspeed[playerid];

   		 	new Float:XA[17], Float:YA[17], Float:ZA[17];
		    new Float:XB[14], Float:YB[14], Float:ZB[14];
		    new Float:XC[3], Float:YC[3], Float:ZC[3];

			for(new x;x<sizeof(Carrier);x++)
			{
			    GetObjectPos(Carrier[x], XA[x], YA[x], ZA[x]);
			}
			for(new x;x<sizeof(CarrierS);x++)
			{
			    GetDynamicObjectPos(CarrierS[x], XB[x], YB[x], ZB[x]);
			}

			GetObjectPos(sidelift, XC[0], YC[0], ZC[0]);
			GetObjectPos(backhatch, XC[1], YC[1], ZC[1]);
			GetObjectPos(backlift, XC[2], YC[2], ZC[2]);

			for(new x;x<sizeof(Carrier);x++)
			{
   				MoveObject(Carrier[x], XA[x], YA[x]-distance, ZA[x], speed);
			}
			for(new x;x<sizeof(CarrierS);x++)
			{
				MoveDynamicObject(CarrierS[x], XB[x], YB[x]-distance, ZB[x], speed);
			}

			MoveObject(sidelift, XC[0], YC[0]-distance, ZC[0], speed);
			MoveObject(backhatch, XC[1], YC[1]-distance, ZC[1], speed);
			MoveObject(backlift, XC[2], YC[2]-distance, ZC[2], speed);
		}
	    else if(lr < 0)
		{
		    if(canmove == 1) return 1;
		    else canmove = 1;
		    
   		 	new distance = controldistance[playerid];
		    new speed = controlspeed[playerid];

		    new Float:XA[17], Float:YA[17], Float:ZA[17];
		    new Float:XB[14], Float:YB[14], Float:ZB[14];
		    new Float:XC[3], Float:YC[3], Float:ZC[3];

			for(new x;x<sizeof(Carrier);x++)
			{
			    GetObjectPos(Carrier[x], XA[x], YA[x], ZA[x]);
			}
			for(new x;x<sizeof(CarrierS);x++)
			{
			    GetDynamicObjectPos(CarrierS[x], XB[x], YB[x], ZB[x]);
			}

			GetObjectPos(sidelift, XC[0], YC[0], ZC[0]);
			GetObjectPos(backhatch, XC[1], YC[1], ZC[1]);
			GetObjectPos(backlift, XC[2], YC[2], ZC[2]);

			for(new x;x<sizeof(Carrier);x++)
			{
   				MoveObject(Carrier[x], XA[x], YA[x]+distance, ZA[x], speed);
			}
			for(new x;x<sizeof(CarrierS);x++)
			{
				MoveDynamicObject(CarrierS[x], XB[x], YB[x]+distance, ZB[x], speed);
			}

			MoveObject(sidelift, XC[0], YC[0]+distance, ZC[0], speed);
			MoveObject(backhatch, XC[1], YC[1]+distance, ZC[1], speed);
			MoveObject(backlift, XC[2], YC[2]+distance, ZC[2], speed);
		}
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp(cmdtext, "/showmeship", true)==0)
	{
	    new Float:X, Float:Y, Float:Z;
	    GetObjectPos(Carrier[0], X, Y, Z);
	    SetPlayerCheckpoint(playerid,X, Y, Z, 4.0);
		GameTextForPlayer(playerid, "~w~Waypoint set ~r~USS Nimitz", 5000, 1);
	}
	
    if (strcmp(cmdtext, "/control", true)==0)
	{
 		if(control[playerid] == 1)
		{
		    TogglePlayerControllable(playerid, true);
		    SetCameraBehindPlayer(playerid);
		    KillTimer(ControlTimer[playerid]);
		    LoadNGVehicles();
  			control[playerid] = 0;
     		SendClientMessage(playerid, COLOR_WHITE, "You are no longer controlling the Aircraft Carrier");
		}
		else
		{
		    UnloadNGVehicles();
      		new Float:X, Float:Y, Float:Z;
		    GetObjectPos(Carrier[0], X, Y, Z);
		    SetPlayerCameraPos(playerid, X-200, Y, Z+40);
		    SetPlayerCameraLookAt(playerid, X, Y, Z);
		    TogglePlayerControllable(playerid, false);
		    ControlTimer[playerid] = SetTimerEx("ControlCam", 1000, true, "i", playerid);
		    control[playerid] = 1;
      		controlspeed[playerid] = 50;
      		controldistance[playerid] = 100;
 		   	SendClientMessage(playerid, COLOR_WHITE, "You are now controlling the Aircraft Carrier with Speed 50, Distance 100");
		}
		return 1;
	}

    if (strcmp(cmdtext, "/goslow", true)==0)
	{
 		if(control[playerid] == 1)
		{
			controlspeed[playerid] = 10;
			controldistance[playerid] = 2;
			SendClientMessage(playerid, COLOR_WHITE, "slow");
		}
	}

	if (strcmp(cmdtext, "/gofast", true)==0)
	{
 		if(control[playerid] == 1)
		{
      		controlspeed[playerid] = 50;
   			controldistance[playerid] = 100;
			SendClientMessage(playerid, COLOR_WHITE, "fast");
		}
	}
	
	if (strcmp(cmdtext, "/bldown", true)==0) // Command (changable)
	{
	    if(canmove == 1) return 1;
	    new Float:X, Float:Y, Float:Z;
	    GetObjectPos(backlift, X, Y, Z);
		MoveObject (backlift,X, Y, 10.435794,1); // Back Lift (down position)
		SendClientMessage(playerid, LIGHT_BLUE, "The Back Lift Is Now Going Down!");
		return 1;
	}
	if (strcmp(cmdtext, "/blup", true)==0)
	{
	    if(canmove == 1) return 1;
	    new Float:X, Float:Y, Float:Z;
	    GetObjectPos(backlift, X, Y, Z);
		MoveObject (backlift,X, Y, 17.483730,1); // Back Lift (up position)
		SendClientMessage(playerid, LIGHT_BLUE, "The Back Lift Is Now Going Up!");
		return 1;
	}
    if(!strcmp(cmdtext, "/sldown", true))
	{
	    if(canmove == 1) return 1;
        new Float:X, Float:Y, Float:Z;
	    GetObjectPos(sidelift, X, Y, Z);
		MoveObject (sidelift,X, Y, 10.271654,1); // Side Lift (down position)
		SendClientMessage(playerid, LIGHT_BLUE, "The Side Lift Is Now Going Down!");
		return 1;
	}
 	if(!strcmp(cmdtext, "/slup", true))
	{
	    if(canmove == 1) return 1;
		new Float:X, Float:Y, Float:Z;
	    GetObjectPos(sidelift, X, Y, Z);
		MoveObject (sidelift,X, Y, 17.269205,1); // Side Lift (down position)
		SendClientMessage(playerid, LIGHT_BLUE, "The Side Lift Is Now Going Up!");
		return 1;
	}
 	if(!strcmp(cmdtext, "/bhdown", true))
	{
	    if(canmove == 1) return 1;
	    new Float:X, Float:Y, Float:Z;
	    GetObjectPos(backhatch, X, Y, Z);
		MoveObject (backhatch, X, Y, 2.516232,1); // Back Hatch (down position)
		SendClientMessage(playerid, LIGHT_BLUE, "The Back Hatch Is Now Going Down!");
		return 1;
	}
 	if(!strcmp(cmdtext, "/bhup", true))
	{
	    if(canmove == 1) return 1;
	    new Float:X, Float:Y, Float:Z;
	    GetObjectPos(backhatch, X, Y, Z);
		MoveObject (backhatch,X, Y, 17.280232,1); // Back Hatch (up position)
		SendClientMessage(playerid, LIGHT_BLUE, "The Back Hatch Is Now Going Up!");
		return 1;
	}
	
	if(strcmp(cmdtext, "/range1", true) == 0)
	{
		if(Range == 0)
		{
		   	if (IsPlayerInRangeOfPoint(playerid, 6.0, 300.1054,-164.4170,999.6105))
		   	{
			   	ShowPlayerDialog(playerid,999999,DIALOG_STYLE_MSGBOX,"Objective","Shooting Range: When the targets pop up, shoot them.\nTo stop the range type: /stoprange. ","OK","");
				Range = 1;
				SetTimer("RedoRange", 1000, 0);
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, " You are not at the shooting range!");
			}
		}
  		else
		{
			SendClientMessage(playerid, COLOR_WHITE, " Someone is already doing the shooting range!");
		}
		return 1;
	}
	if(strcmp(cmdtext, "/stoprange1", true) == 0)
	{
		if(Range == 1)
		{
		   	if (IsPlayerInRangeOfPoint(playerid, 6.0,300.1054,-164.4170,999.6105))
		   	{
				Range = 0;
				for(new x;x<sizeof(RangeGuy);x++)
				{
				    if(IsValidObject(RangeGuy[x])) DestroyObject(RangeGuy[x]);
				}
				SendClientMessage(playerid, COLOR_WHITE, " You have stopped the shooting range!");
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, " You are not at the shooting range!");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, " You are not is doing the shooting range!");
		}
		return 1;
	}
	return 0;
}

public RedoRange()
{
	if(Range == 1)
	{
	    new rand[6], model[6], Float:rand2[6], Float:rand3[6];
		rand[0] = Random(0,100); rand2[0] = Random(0,20); rand3[0] = Random(0,11);
	    rand[1] = Random(0,100); rand2[1] = Random(0,20); rand3[1] = Random(0,11);
	    rand[2] = Random(0,100); rand2[2] = Random(0,20); rand3[2] = Random(0,11);
   		rand[3] = Random(0,100); rand2[3] = Random(0,20); rand3[3] = Random(0,11);
	    rand[4] = Random(0,100); rand2[4] = Random(0,20); rand3[4] = Random(0,11);
	    rand[5] = Random(0,100); rand2[5] = Random(0,20); rand3[5] = Random(0,11);

		for(new x;x<sizeof(rand);x++)
		{
		    if(rand[x] < 20) model[x] = 1585;
		    else if(rand[x] > 20 && rand[x] < 60) model[x] = 1584;
		    else if(rand[x] > 60 && rand[x] <= 100) model[x] = 1583;
		}
		    
	    for(new x;x<sizeof(RangeGuy);x++)
	    {
	    	RangeGuy[x] = CreateObject((model[x]), (294.0-rand2[x]), (-169.0+rand3[x]), 996, 0.000000, 0.00000, 90); //object (tar_gun1) (2)
			MoveObject(RangeGuy[x], (294-rand2[x]), (-169+rand3[x]), 998.5, 5);
		}
		
		SetTimer("RedoRange2", 4000, 0);
	}
}

public RedoRange2()
{
    for(new x;x<sizeof(RangeGuy);x++)
	{
 		if(IsValidObject(RangeGuy[x])) DestroyObject(RangeGuy[x]);
	}
    new rand = Random(2000,5000);
	SetTimer("RedoRange", rand, 0);
}

stock Random(min, max)
{
    new a = random(max - min) + min;
    return a;
}
