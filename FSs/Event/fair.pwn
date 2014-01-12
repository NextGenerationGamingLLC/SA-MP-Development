#include <a_samp>
#include <streamer>
#include <zcmd>

new gocarts[5];
new musicarea;
new bumpercars;
new Text3D:karttext;
new Text3D:piratetext;
new kartraceinfo[7];
new pirateship[2];
new piratestep[8];

enum posenum
{
	Float:posx,
	Float:posy,
	Float:posz,
	Float:rot
}

new bumperspawns[10][posenum] = {
{1509.0797,-64.9944,26.9080,329.6529},
{1516.2323,-55.0962,26.9271,345.0430},
{1518.5360,-39.1518,26.9179,13.7316},
{1508.8268,-29.9964,26.9196,123.8321},
{1503.8162,-37.9906,26.9408,171.2591},
{1497.4014,-48.4876,26.9138,76.2519},
{1492.9607,-40.7950,26.9149,269.7835},
{1505.6836,-32.8667,26.9330,275.1056},
{1515.4636,-35.6011,26.9223,196.8903},
{1514.7443,-48.7944,26.9353,136.1681}
};

new kartspawns[34][posenum] = {
{1564.00964355,17.07140732,23.49634361,190.00000000},
{1561.82348633,16.54862213,23.49634361,190.00000000},
{1559.88293457,15.93473053,23.49634361,189.99755859},
{1557.90283203,15.30996132,23.49634361,189.99755859},
{1555.62036133,14.53450584,23.49634361,189.99755859},
{1564.2979,19.8998,23.4477,192.3600},
{1562.3704,19.3897,23.4478,192.7268},
{1560.6278,19.0925,23.4476,195.8536},
{1558.5475,18.3385,23.4480,192.6586},
{1556.8177,18.3449,23.4465,193.2574},
{1554.8568,17.8215,23.4380,193.6009},
{1553.8881,21.1286,23.4269,193.5916},
{1555.5220,21.0739,23.4345,190.0444},
{1556.8367,22.0668,23.4380,188.4365},
{1558.2001,23.5059,23.4429,190.4256},
{1559.6775,24.1726,23.4476,184.8009},
{1561.3840,24.0859,23.4478,187.2630},
{1562.7532,25.0298,23.4478,180.4760},
{1562.5829,27.7668,23.4478,191.7696},
{1560.8351,26.3097,23.4477,199.6867},
{1558.8903,26.1727,23.4481,192.8379},
{1557.2906,27.3436,23.4350,198.5173},
{1557.4248,27.2700,23.4438,202.0928},
{1555.8507,25.5446,23.4348,187.7344},
{1553.8242,25.1185,23.4291,188.0691},
{1551.3418,24.6591,23.4239,195.6346},
{1550.6317,27.2813,23.4237,194.9919},
{1552.1284,28.1989,23.4274,192.2468},
{1554.1768,28.7966,23.4343,192.7393},
{1555.8494,28.9580,23.4385,188.9234},
{1557.7314,29.7238,23.4478,194.9809},
{1559.2167,30.2656,23.4477,195.7509},
{1561.0835,30.4947,23.4479,203.4948},
{1563.6442,31.1704,23.4479,175.8033}
};

new kartcheckpoints[22][posenum] = {
{1561.1425,-0.6959,22.2056},
{1560.0236,-63.4405,20.2049},
{1541.8403,-161.8614,15.2990},
{1448.9148,-211.3230,8.8160},
{1367.7023,-211.0382,6.6549},
{1302.9319,-181.8514,23.0594},
{1261.6588,-151.0969,37.4276},
{1219.6796,-106.5497,39.0666},
{1164.2017,-70.1262,29.1771},
{1067.8438,-63.6197,20.4266},
{968.9000,-86.8389,19.0257},
{889.7670,-88.6949,23.1655},
{829.8240,-106.7988,24.3264},
{771.7855,-137.4116,20.1231},
{722.7872,-174.7025,20.1587},
{649.4225,-196.4490,10.9428},
{586.3651,-200.5624,12.3490},
{529.7865,-209.4404,15.3095},
{486.7947,-250.3996,10.1345},
{435.4356,-297.3609,5.9730},
{379.3389,-319.6147,12.8056},
{314.3939,-365.6910,8.8709}
};

new pirateshipspawn[51][posenum] = {
{1368.3156,-157.4080,38.8022},
{1367.7076,-156.7162,38.8022},
{1367.0004,-156.1516,38.8022},
{1366.5372,-155.3416,38.8022},
{1365.8599,-154.7898,38.8022},
{1366.0726,-153.8185,38.8073},
{1366.2477,-154.5297,38.8022},
{1367.1639,-154.9416,38.8022},
{1367.8494,-155.9007,38.8022},
{1368.4381,-156.6313,38.8022},
{1369.5812,-156.3377,38.8022},
{1368.9663,-155.7623,38.8022},
{1368.2111,-155.2064,38.8022},
{1367.6128,-154.4204,38.8022},
{1367.3668,-153.4461,38.8073},
{1367.3884,-152.7107,38.8073},
{1367.9076,-153.5258,38.8073},
{1368.6387,-154.1646,38.8073},
{1368.9137,-154.4801,38.8022},
{1369.2083,-155.1617,38.8022},
{1369.8506,-155.7930,38.8022},
{1370.7736,-155.3378,38.8022},
{1370.1151,-154.5368,38.8022},
{1369.4979,-153.6514,38.8073},
{1368.9086,-152.8132,38.8073},
{1368.1691,-152.1746,38.8073},
{1368.9674,-151.5208,38.8073},
{1369.5686,-152.4011,38.8073},
{1370.4342,-153.3024,38.8073},
{1370.8665,-154.1247,38.8073},
{1371.5293,-154.6986,38.8022},
{1372.0619,-154.2571,38.8022},
{1371.7343,-153.4149,38.8073},
{1371.2455,-152.7113,38.8073},
{1370.9978,-151.9384,38.8022},
{1370.1422,-151.6086,38.8073},
{1369.8403,-150.7298,38.8073},
{1377.4641,-149.3647,37.7709},
{1377.2501,-148.4664,37.7709},
{1376.4216,-147.5100,37.7709},
{1375.4967,-147.0543,37.7709},
{1375.6320,-145.8949,37.7709},
{1376.4155,-146.4493,37.7709},
{1376.9457,-147.3245,37.7709},
{1377.2776,-148.1663,37.7709},
{1378.1124,-148.4439,37.7709},
{1378.6742,-148.0090,37.7709},
{1378.3854,-147.0647,37.7709},
{1377.7249,-146.2822,37.7709},
{1377.0049,-145.7251,37.7709},
{1376.3148,-145.1906,37.7709}
};

new Float:gFerrisOrigin[3] = {1426.39831543,-69.21621704,40.51242828};
new gFerrisWheel, gFerrisBase;
new gFerrisCages[10];
new Float:gCurrentTargetYAngle = 0.0;
new gWheelTransAlternate = 0;

CMD:bumpercars(playerid, params[])
{
	if(!GetPVarType(playerid, "pBumperCar"))
 	{
 	    if(IsPlayerInRangeOfPoint(playerid, 10.0, 1495.4183,-34.8586,27.5))
 	    {
			if(bumpercars > 15)
			{
				SendClientMessage(playerid, 0xFFFFFFFF, "The arena is full, please wait your turn!");
			}
			else
			{
	  			new rand=random(10);
	  			SetPVarInt(playerid, "pBumperCar", CreateVehicle(539, bumperspawns[rand][posx], bumperspawns[rand][posy], bumperspawns[rand][posz], bumperspawns[rand][rot], random(10), random(10), 15));
	     		new veh = GetPVarInt(playerid, "pBumperCar");
				new engine,lights,alarm,doors,bonnet,boot,objective;
	 			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
				SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
				PutPlayerInVehicle(playerid, veh, 0);
				SetPVarInt(playerid, "pBumperTimer", SetTimerEx("BumperCars", 1000, false, "i", playerid));
				bumpercars++;
				SetTimerEx("KartUpdate", 1000, false, "i", playerid);
				SendClientMessage(playerid, 0xFFFFFFFF, "Type /bumpercars again to stop playing!");
			}
		}
		else
		{
		    SendClientMessage(playerid, 0xFFFFFFFF, "You are not near the bumper cars area!");
		}
	}
	else
	{
	    new veh = GetPVarInt(playerid, "pBumperCar");
		if(GetVehicleModel(veh)) DestroyVehicle(veh);
		DeletePVar(playerid, "pBumperCar");
		KillTimer(GetPVarInt(playerid, "pBumperTimer"));
		DeletePVar(playerid, "pBumperTimer");
		if(bumpercars > 0) bumpercars--;
		SetPlayerPos(playerid, 1489.0814,-37.4118,26.3549);
		SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
	}
	return 1;
}

CMD:kartrace(playerid, params[])
{
	if(!GetPVarType(playerid, "pKartCar"))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 10.0, 1550.7883,17.4276,24.1364))
	    {
			if(kartraceinfo[3] != 2)
			{
			    if(kartraceinfo[0] < 33)
			    {
				    new engine,lights,alarm,doors,bonnet,boot,objective;
					SetPVarInt(playerid, "pKartCar", CreateVehicle(571, kartspawns[kartraceinfo[0]][posx], kartspawns[kartraceinfo[0]][posy], kartspawns[kartraceinfo[0]][posz], kartspawns[kartraceinfo[0]][rot], random(10), random(10), 15));
					new veh = GetPVarInt(playerid, "pKartCar");
					GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights,alarm,VEHICLE_PARAMS_ON,bonnet,boot,objective);
					PutPlayerInVehicle(playerid, veh, 0);
					TogglePlayerControllable(playerid, 0);

					SetTimerEx("KartUpdate", 1000, false, "i", playerid);
					kartraceinfo[0]++;
			  		UpdateKartLabel();
			  		SendClientMessage(playerid, 0xFFFFFFFF, "Type /kartrace again to leave the race");
				}
				else
				{
				    SendClientMessage(playerid, 0xFFFFFFFF, "The race is full, try again next time!");
				}
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFFF, "The race has already started");
			}
		}
		else
		{
		    SendClientMessage(playerid, 0xFFFFFFFF, "You are not at the starting line");
		}
	}
	else
	{
	    new veh = GetPVarInt(playerid, "pKartCar");
		if(GetVehicleModel(veh)) DestroyVehicle(veh);
		DeletePVar(playerid, "pKartCar");
		DeletePVar(playerid, "pKartCheckpoint");
		SetPlayerPos(playerid, 1550.7883,17.4276,24.1364);
		//kartraceinfo[0]--;
		UpdateKartLabel();
		TogglePlayerControllable(playerid, 1);
		DisablePlayerCheckpoint(playerid);
		SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
	}
	return 1;
}

CMD:pirateshipreset(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
	    if(IsObjectMoving(pirateship[0])) StopObject(pirateship[0]);
	    MoveObject(pirateship[0], 1382.96, -143.02, 57.13, 0.1, 0.0, 0.0, 40.0);
	    piratestep[3] = 2;
	}
	return 1;
}

CMD:pirateship(playerid, params[])
{
	if(!GetPVarType(playerid, "pPirate"))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 10.0, 1404.3282,-133.6953,23.3361))
	    {
			if(piratestep[5] == 0)
			{
			    if(piratestep[6] < 51)
			    {
			        if(piratestep[6] == 0)
			        {
			            piratestep[7] = gettime()+60;
					}
					SetPVarInt(playerid, "pPirate", 1);
					new Float:HP; GetPlayerHealth(playerid, HP);
				    SetPVarFloat(playerid, "pOldHealth", HP);
					SetPlayerPos(playerid, pirateshipspawn[piratestep[6]][posx], pirateshipspawn[piratestep[6]][posy], pirateshipspawn[piratestep[6]][posz]);
					SetPlayerHealth(playerid, 1000.0);
					SetPlayerFacingAngle(playerid, pirateshipspawn[piratestep[6]][rot]);
					piratestep[6]++;
			  		SendClientMessage(playerid, 0xFFFFFFFF, "Type /pirateship again to leave the ship, if you don't move you won't fall");
				}
				else
				{
				    SendClientMessage(playerid, 0xFFFFFFFF, "The race is full, try again next time!");
				}
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFFF, "The ride has already started");
			}
		}
		else
		{
		    SendClientMessage(playerid, 0xFFFFFFFF, "You are not at the ride entrance");
		}
	}
	else
	{
	    DeletePVar(playerid, "pPirate");
	    if(piratestep[6] > 0) piratestep[6]--;
	    SetPlayerPos(playerid, 1427.0665,-129.3872,23.2147);
	    SetPlayerHealth(playerid, GetPVarFloat(playerid, "pOldHealth"));
	    DeletePVar(playerid, "pOldHealth");
	}
	return 1;
}

stock UpdatePirateLabel()
{
	new string[256];
	if(piratestep[6] == 0 && piratestep[5] == 0) format(string, sizeof(string), "{FFFF00}Type {FF0000}/pirateship {FFFF00}to join in!\nWaiting for at least 1 participant");
	else
	{
		if(piratestep[5] == 1) format(string, sizeof(string), "{FFFF00}Ride in progress!\nParticipants: {FF0000}%d", piratestep[6]);
		else format(string, sizeof(string), "{FFFF00}Type {FF0000}/pirateship {FFFF00}to join in!\nParticipant: {FF0000}%d\nRide Starts: %d", piratestep[6], piratestep[7]-gettime());
	}
	UpdateDynamic3DTextLabelText(piratetext, 0xFFFFFFFF, string);
}
stock UpdateKartLabel()
{
	new string[256];
	if(kartraceinfo[3] == 2) format(string, sizeof(string), "{FFFF00}Race in progress!\nRacers: {FF0000}%d\nTime left: %d seconds", kartraceinfo[0], kartraceinfo[5]-gettime());
	else format(string, sizeof(string), "{FFFF00}Type {FF0000}/kartrace {FFFF00}to join in!\nRacers: {FF0000}%d", kartraceinfo[0]);
	UpdateDynamic3DTextLabelText(karttext, 0xFFFFFFFF, string);
}

forward KartUpdate(playerid);
public KartUpdate(playerid)
{
    if(GetPVarType(playerid, "pKartCar"))
    {
        if(kartraceinfo[3] == 1)
        {
			new string[64];
			format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Race starting in %d seconds", kartraceinfo[4]-gettime());
			GameTextForPlayer(playerid, string, 1100, 3);
        }
        else if(kartraceinfo[3] == 0)
        {
            GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Waiting for more racers..", 1100, 3);
        }
        else if(kartraceinfo[3] == 2)
        {
            new engine,lights,alarm,doors,bonnet,boot,objective;
        	new veh=GetPVarInt(playerid, "pKartCar");
			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
			if(engine != VEHICLE_PARAMS_ON) SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
		}
        SetTimerEx("KartUpdate", 1000, false, "i", playerid);
    }
	if(GetPVarType(playerid, "pBumperCar"))
	{
	    new engine,lights,alarm,doors,bonnet,boot,objective;
    	new veh=GetPVarInt(playerid, "pKartCar");
		GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
		if(engine != VEHICLE_PARAMS_ON) SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
		SetTimerEx("KartUpdate", 1000, false, "i", playerid);
	}
}

forward KartUpdateGlobal();
public KartUpdateGlobal()
{
 	UpdatePirateLabel();
 	if(piratestep[5] == 0 && piratestep[6] > 0 && (piratestep[7]-gettime()) <= 0)
 	{
	    piratestep[5] = 1;
		SetTimer("MovePirateShip", 1000, false);
	}
	if(kartraceinfo[3] == 1)
	{
		if(kartraceinfo[4]-gettime() <= 0)
		{
		    kartraceinfo[3] = 2;
			for(new x;x<MAX_PLAYERS;x++)
			{
			    if(IsPlayerConnected(x) && GetPVarType(x, "pKartCar"))
			    {
			        kartraceinfo[5] = gettime()+150;
			        new engine,lights,alarm,doors,bonnet,boot,objective;
			        new veh=GetPVarInt(x, "pKartCar");
					GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
			        GameTextForPlayer(x, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~GO!", 2000, 3);
			        SetPlayerCheckpoint(x, kartcheckpoints[0][posx], kartcheckpoints[0][posy], kartcheckpoints[0][posz], 5.0);
			        SetPVarInt(x, "pKartCheckpoint", 0);
			        TogglePlayerControllable(x, 1);
			    }
			}
		}
	    return 1;
	}
	else if(kartraceinfo[3] == 2)
	{
		if(kartraceinfo[5]-gettime() <= 0)
		{
		    kartraceinfo[0] = 0; kartraceinfo[2] = 0; kartraceinfo[3] = 0; kartraceinfo[4] = 0; kartraceinfo[5] = 0; kartraceinfo[6] = 0;
		    UpdateKartLabel();
		    for(new x;x<MAX_PLAYERS;x++)
		    {
		        if(IsPlayerConnected(x) && GetPVarType(x, "pKartCar"))
		        {
		            new veh = GetPVarInt(x, "pKartCar");
					if(GetVehicleModel(veh)) DestroyVehicle(veh);
					DeletePVar(x, "pKartCar");
					DeletePVar(x, "pKartCheckpoint");
					SetPlayerPos(x, 1550.7883,17.4276,24.1364);
					TogglePlayerControllable(x, 1);
					DisablePlayerCheckpoint(x);
					SendClientMessage(x, 0xFFFFFFFF, "Thanks for playing!");
		        }
		    }
		}
		else
		{
		    UpdateKartLabel();
		}
	}
	if(kartraceinfo[0] >= 2 && kartraceinfo[3] == 0)
	{
	    kartraceinfo[3] = 1;
	    kartraceinfo[4] = gettime()+15;
		return 1;
	}
	if(kartraceinfo[0] < 1 && kartraceinfo[3] == 1)
	{
		kartraceinfo[3] = 0;
		return 1;
	}
	for(new i;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i) && GetPVarType(i, "pBumperCar"))
	    {
	        new engine,lights,alarm,doors,bonnet,boot,objective;
        	new veh=GetPVarInt(i, "pBumperCar");
			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
			SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
	    }
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(GetPVarType(playerid, "pKartCar"))
	{
	    new checkpoint = GetPVarInt(playerid, "pKartCheckpoint");
	    if(checkpoint == (sizeof(kartcheckpoints)-1))
	    {
            kartraceinfo[6]++;
            for(new x;x<MAX_PLAYERS;x++)
            {
                if(IsPlayerConnected(x) && (GetPVarInt(x, "pKartCar") || IsPlayerInRangeOfPoint(x, 15.0, 1550.7883,17.4276,24.1364)))
                {
					new string[MAX_PLAYER_NAME+24];
					format(string, sizeof(string), "%s has come in place %d", GetPlayerNameEx(playerid), kartraceinfo[6]);
					SendClientMessage(x, 0xFFFFFFFF, string);
                }
			}
			
			new veh = GetPVarInt(playerid, "pKartCar");
			if(GetVehicleModel(veh)) DestroyVehicle(veh);
			DeletePVar(playerid, "pKartCar");
			DeletePVar(playerid, "pKartCheckpoint");
			SetPlayerPos(playerid, 1550.7883,17.4276,24.1364);
			if(kartraceinfo[0] > 0) kartraceinfo[0]--;
			UpdateKartLabel();
			TogglePlayerControllable(playerid, 1);
			DisablePlayerCheckpoint(playerid);
	    }
	    else
	    {
	        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
		    checkpoint++;
	        SetPVarInt(playerid, "pKartCheckpoint", checkpoint);
	        DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, kartcheckpoints[checkpoint][posx], kartcheckpoints[checkpoint][posy], kartcheckpoints[checkpoint][posz], 5.0);
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_ONFOOT)
	{
	    if(GetPVarType(playerid, "pBumperCar"))
	    {
	        new veh = GetPVarInt(playerid, "pBumperCar");
			if(GetVehicleModel(veh)) DestroyVehicle(veh);
			DeletePVar(playerid, "pBumperCar");
			KillTimer(GetPVarInt(playerid, "pBumperTimer"));
			DeletePVar(playerid, "pBumperTimer");
			SetPlayerPos(playerid, 1489.0814,-37.4118,26.3549);
			if(bumpercars > 0) bumpercars--;
			SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
	    }
	    if(GetPVarType(playerid, "pKartCar"))
	    {
	        new veh = GetPVarInt(playerid, "pKartCar");
			if(GetVehicleModel(veh)) DestroyVehicle(veh);
			DeletePVar(playerid, "pKartCar");
			DeletePVar(playerid, "pKartCheckpoint");
			SetPlayerPos(playerid, 1550.7883,17.4276,24.1364);
			if(kartraceinfo[0] > 0) kartraceinfo[0]--;
			UpdateKartLabel();
			TogglePlayerControllable(playerid, 1);
			DisablePlayerCheckpoint(playerid);
			SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
	    }
	}
	return 1;
}

public OnPlayerDisconnect(playerid)
{
    if(GetPVarType(playerid, "pBumperCar"))
    {
    	new veh = GetPVarInt(playerid, "pBumperCar");
		if(GetVehicleModel(veh)) DestroyVehicle(veh);
		KillTimer(GetPVarInt(playerid, "pBumperTimer"));
		SetPlayerPos(playerid, 1489.0814,-37.4118,26.3549);
		if(bumpercars > 0) bumpercars--;
  	}
  	if(GetPVarType(playerid, "pKartCar"))
   	{
    	new veh = GetPVarInt(playerid, "pKartCar");
		if(GetVehicleModel(veh)) DestroyVehicle(veh);
		SetPlayerPos(playerid, 1550.7883,17.4276,24.1364);
		if(kartraceinfo[0] > 0) kartraceinfo[0]--;
  	}
  	return 1;
}

forward BumperCars(playerid);
public BumperCars(playerid)
{
	new Float:hp;
	GetVehicleHealth(GetPVarInt(playerid, "pBumperCar"), hp);
	if(hp < 500)
	{
	    new veh = GetPVarInt(playerid, "pBumperCar");
		if(GetVehicleModel(veh)) DestroyVehicle(veh);
		DeletePVar(playerid, "pBumperCar");
		DeletePVar(playerid, "pBumperTimer");
		SetPlayerPos(playerid, 1489.0814,-37.4118,26.3549);
		SendClientMessage(playerid, 0xFFFFFFFF, "Too damaged to continue, thanks for playing!");
		if(bumpercars > 0) bumpercars--;
	}
	else
	{
	    SetPVarInt(playerid, "pBumperTimer", SetTimerEx("BumperCars", 1000, false, "i", playerid));
	}
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == musicarea)
	{
	    StopAudioStreamForPlayer(playerid);
		PlayAudioStreamForPlayer(playerid, "http://samp.ng-gaming.net:8000/listen.pls", 1330.3715,37.1724,33.1021, 50.0, 1);
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(areaid == musicarea)
	{
	    StopAudioStreamForPlayer(playerid);
	}
	return 1;
}

public OnFilterScriptInit()
{
    Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 399);
	SetTimer("KartUpdateGlobal", 1000, true);
	
	musicarea = CreateDynamicSphere(1330.3715,37.1724,33.1021, 50.0);
    CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/bumpercars {FFFF00}to join in!", 0xFFFFFFF, 1495.4183,-34.8586,27.5, 10.0);
    karttext = CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/kartrace {FFFF00}to join in!", 0xFFFFFFF, 1550.7883,17.4276,24.1364, 15.0);
	piratetext = CreateDynamic3DTextLabel("", 0xFFFFFFF, 1404.3282,-133.6953,23.3361, 15.0);
	
	// GoCart Vehicles
	/*gocarts[0] = CreateVehicle(571,1564.00964355,17.07140732,23.49634361,190.00000000,-1,-1,15); //Kart
    gocarts[1] = CreateVehicle(571,1561.82348633,16.54862213,23.49634361,190.00000000,-1,-1,15); //Kart
    gocarts[2] = CreateVehicle(571,1559.88293457,15.93473053,23.49634361,189.99755859,-1,-1,15); //Kart
    gocarts[3] = CreateVehicle(571,1557.90283203,15.30996132,23.49634361,189.99755859,-1,-1,15); //Kart
    gocarts[4] = CreateVehicle(571,1555.62036133,14.53450584,23.49634361,189.99755859,-1,-1,15); //Kart*/
	
    new Float:gFerrisCageOffsets[10][3] = {
	{0.0699, 0.0600, -11.7500},
	{-6.9100, -0.0899, -9.5000},
	{11.1600, 0.0000, -3.6300},
	{-11.1600, -0.0399, 3.6499},
	{-6.9100, -0.0899, 9.4799},
	{0.0699, 0.0600, 11.7500},
	{6.9599, 0.0100, -9.5000},
	{-11.1600, -0.0399, -3.6300},
	{11.1600, 0.0000, 3.6499},
	{7.0399, -0.0200, 9.3600}
	};
    gFerrisWheel = CreateObject( 18877, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2],
	  							 0.0, 0.0, 218.0, 300.0 );
	gFerrisBase = CreateObject( 18878, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2],
	  							 0.0, 0.0, 218.0, 300.0 );
 	for(new x;x<10;x++)
    {
        gFerrisCages[x] = CreateObject( 19316, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2],
	  							 0.0, 0.0, 218.0, 300.0 );

        AttachObjectToObject( gFerrisCages[x], gFerrisWheel,
							  gFerrisCageOffsets[x][0],
							  gFerrisCageOffsets[x][1],
	  						  gFerrisCageOffsets[x][2],
							  0.0, 0.0, 218.0, 0 );
	}

	SetTimer("RotateWheel",3*1000,0);

	// Wheel of fortune Objects.
    /*CreateDynamicObject(1895,1457.13513184,-43.57703018,28.54137039,0.00000000,0.00000000,40.00000000); //object(wheel_o_fortune) (1)
    CreateDynamicObject(1895,1460.70190430,-40.59095001,28.54137039,0.00000000,0.00000000,39.99572754); //object(wheel_o_fortune) (2)
    CreateDynamicObject(1895,1459.84326172,-38.51583862,28.54137039,0.00000000,0.00000000,219.99572754); //object(wheel_o_fortune) (3)
    CreateDynamicObject(1895,1456.10400391,-41.68433380,28.54137039,0.00000000,0.00000000,219.99023438); //object(wheel_o_fortune) (4)*/

	// Objects.
	pirateship[0] = CreateObject(3502, 1382.96, -143.02, 57.13,   0.00, 0.00, 40.00);
 	pirateship[1] = CreateObject(8493, 1392.29, -134.77, 44.06,   0.00, 0.00, 310.00);
 	AttachObjectToObject(pirateship[1], pirateship[0], 9.33, 0.0, -8.07, 0.0, 0.0, 270.0);
 	
    CreateDynamicObject(7017, 1442.59, -75.17, 21.27,   0.00, 0.00, 220.00);
	CreateDynamicObject(7017, 1386.18, -122.48, 21.27,   0.00, 0.00, 220.00);
	CreateDynamicObject(7017, 1489.16, -36.06, 21.27,   0.00, 0.00, 220.00);
	CreateDynamicObject(7017, 1450.75, -29.57, 25.87,   0.00, 0.00, 220.00);
	CreateDynamicObject(7017, 1414.16, -60.33, 25.87,   0.00, 0.00, 220.00);
	CreateDynamicObject(7017, 1455.28, 22.17, 25.87,   0.00, 0.00, 310.00);
	CreateDynamicObject(7017, 1362.44, -55.81, 25.87,   0.00, 0.00, 130.00);
	CreateDynamicObject(7017, 1334.45, -117.93, 21.27,   0.00, 0.00, 130.00);
	CreateDynamicObject(7017, 1489.43, 13.18, 21.27,   0.00, 0.00, 310.00);
	CreateDynamicObject(7017, 1492.25, -30.94, 21.27,   0.00, 0.00, 40.00);
	CreateDynamicObject(7017, 1477.48, -50.42, 21.27,   0.00, 0.00, 130.00);
	CreateDynamicObject(4100, 1506.61, -74.00, 23.91,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1517.03, -65.18, 23.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1527.52, -56.40, 23.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(7017, 1523.86, -11.46, 21.27,   0.00, 0.00, 310.00);
	CreateDynamicObject(4100, 1538.06, -47.60, 23.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1542.48, -43.82, 23.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1542.48, -43.82, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(7017, 1315.78, 9.97, 26.57,   0.00, 0.00, 130.00);
	CreateDynamicObject(7017, 1315.78, 9.97, 21.62,   0.00, 0.00, 130.00);
	CreateDynamicObject(18783, 1332.50, 68.82, 20.56,   0.00, 270.00, 310.00);
	CreateDynamicObject(18783, 1301.44, 42.61, 20.56,   0.00, 270.00, 309.99);
	CreateDynamicObject(18783, 1317.16, 55.95, 20.56,   0.00, 270.00, 309.99);
	CreateDynamicObject(18783, 1315.38, 54.36, 20.56,   0.00, 270.00, 309.99);
	CreateDynamicObject(7017, 1362.18, 48.86, 26.57,   0.00, 0.00, 310.00);
	CreateDynamicObject(7017, 1362.18, 48.86, 21.67,   0.00, 0.00, 310.00);
	CreateDynamicObject(6300, 1431.02, 4.06, 22.02,   0.00, 0.00, 40.00);
	CreateDynamicObject(6300, 1384.45, -35.02, 22.02,   0.00, 0.00, 40.00);
	CreateDynamicObject(6300, 1449.68, -18.97, 17.31,   0.00, 0.00, 40.00);
	CreateDynamicObject(6300, 1403.10, -58.06, 17.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(6300, 1356.50, -97.14, 17.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(6300, 1480.79, -29.10, 14.17,   0.00, 0.00, 40.00);
	CreateDynamicObject(6300, 1434.19, -68.18, 14.17,   0.00, 0.00, 40.00);
	CreateDynamicObject(6300, 1387.63, -107.26, 14.17,   0.00, 0.00, 40.00);
	CreateDynamicObject(6300, 1508.08, -61.63, 14.16,   0.00, 0.00, 39.99);
	CreateDynamicObject(6300, 1461.47, -100.71, 14.16,   0.00, 0.00, 39.99);
	CreateDynamicObject(6300, 1414.92, -139.84, 14.16,   0.00, 0.00, 39.99);
	CreateDynamicObject(3115, 1512.39, -31.44, 26.24,   0.00, 0.00, 40.00);
	CreateDynamicObject(6300, 1499.53, -29.60, 17.30,   0.00, 0.00, 40.00);
	CreateDynamicObject(3115, 1524.43, -45.84, 26.24,   0.00, 0.00, 40.00);
	CreateDynamicObject(3115, 1508.25, -59.40, 31.79,   0.00, 0.00, 220.00);
	CreateDynamicObject(3115, 1496.20, -45.02, 26.24,   0.00, 0.00, 219.99);
	CreateDynamicObject(3578, 1510.23, -45.10, 27.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(3578, 1510.54, -45.49, 27.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(3578, 1510.77, -21.45, 27.32,   0.00, 0.00, 40.00);
	CreateDynamicObject(3578, 1503.16, -28.27, 27.32,   0.00, 0.00, 44.00);
	CreateDynamicObject(3578, 1487.45, -41.44, 27.32,   0.00, 0.00, 35.99);
	CreateDynamicObject(3578, 1486.25, -48.34, 27.32,   0.00, 0.00, 129.99);
	CreateDynamicObject(3578, 1492.83, -56.21, 27.32,   0.00, 0.00, 129.98);
	CreateDynamicObject(3578, 1499.42, -64.10, 27.32,   0.00, 0.00, 129.98);
	CreateDynamicObject(3578, 1503.20, -68.62, 27.32,   0.00, 0.00, 129.98);
	CreateDynamicObject(3578, 1510.28, -68.83, 27.32,   0.00, 0.00, 219.98);
	CreateDynamicObject(3578, 1518.18, -62.22, 27.32,   0.00, 0.00, 219.98);
	CreateDynamicObject(3578, 1526.04, -55.64, 27.32,   0.00, 0.00, 219.98);
	CreateDynamicObject(3578, 1533.93, -49.06, 27.32,   0.00, 0.00, 219.98);
	CreateDynamicObject(3578, 1534.19, -42.17, 27.32,   0.00, 0.00, 309.98);
	CreateDynamicObject(3578, 1527.58, -34.27, 27.32,   0.00, 0.00, 309.97);
	CreateDynamicObject(3578, 1520.98, -26.37, 27.32,   0.00, 0.00, 309.97);
	CreateDynamicObject(3578, 1517.49, -22.21, 27.32,   0.00, 0.00, 309.97);
	CreateDynamicObject(18762, 1506.23, -72.34, 29.04,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1482.91, -44.65, 29.04,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1514.34, -18.34, 29.04,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1537.53, -46.08, 29.04,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1514.66, -41.71, 29.04,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1506.07, -48.89, 29.04,   0.00, 0.00, 310.00);
	CreateDynamicObject(3115, 1512.39, -31.44, 31.79,   0.00, 0.00, 40.00);
	CreateDynamicObject(3115, 1496.20, -45.02, 31.79,   0.00, 0.00, 219.99);
	CreateDynamicObject(3115, 1508.25, -59.40, 26.24,   0.00, 0.00, 219.99);
	CreateDynamicObject(3115, 1524.43, -45.83, 31.79,   0.00, 0.00, 40.00);
	CreateDynamicObject(18762, 1521.61, -59.01, 29.04,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1499.10, -32.10, 29.04,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1492.05, -38.16, 29.04,   0.00, 0.00, 310.00);
	CreateDynamicObject(8572, 1496.42, -31.44, 25.29,   0.00, 0.00, 220.00);
	CreateDynamicObject(8614, 1491.08, -35.91, 25.30,   0.00, 0.00, 220.00);
	CreateDynamicObject(997, 1496.69, -34.92, 26.58,   0.00, 0.00, 40.00);
	CreateDynamicObject(997, 1492.77, -38.30, 26.58,   0.00, 0.00, 40.00);
	CreateDynamicObject(6283, 1462.59, -102.47, 27.00,   0.00, 0.00, 39.00);
	CreateDynamicObject(1594, 1440.83, -95.66, 22.70,   0.00, 0.00, 346.00);
	CreateDynamicObject(1594, 1446.16, -89.92, 22.70,   0.00, 0.00, 18.00);
	CreateDynamicObject(1594, 1434.45, -90.52, 22.70,   0.00, 0.00, 48.00);
	CreateDynamicObject(1594, 1433.04, -98.15, 22.70,   0.00, 0.00, 71.99);
	CreateDynamicObject(1594, 1440.90, -87.51, 22.70,   0.00, 0.00, 97.99);
	CreateDynamicObject(1594, 1456.57, -92.55, 22.70,   0.00, 0.00, 119.99);
	CreateDynamicObject(1594, 1438.46, -116.40, 22.69,   0.00, 0.00, 135.99);
	CreateDynamicObject(1594, 1471.94, -101.40, 22.69,   0.00, 0.00, 135.98);
	CreateDynamicObject(1594, 1466.40, -118.97, 22.69,   0.00, 0.00, 155.98);
	CreateDynamicObject(1594, 1479.93, -105.01, 22.69,   0.00, 0.00, 171.98);
	CreateDynamicObject(1594, 1472.98, -78.18, 22.69,   0.00, 0.00, 191.97);
	CreateDynamicObject(1594, 1468.18, -72.91, 22.70,   0.00, 0.00, 209.97);
	CreateDynamicObject(1594, 1464.65, -76.17, 22.70,   0.00, 0.00, 231.97);
	CreateDynamicObject(6462, 1419.85, -109.90, 24.23,   0.00, 0.00, 308.25);
	CreateDynamicObject(6299, 1477.66, -64.96, 24.49,   0.00, 0.00, 220.00);
	CreateDynamicObject(8614, 1442.35, -76.71, 24.12,   0.00, 0.00, 39.75);
	CreateDynamicObject(8614, 1415.57, -99.23, 24.12,   0.00, 0.00, 39.74);
	CreateDynamicObject(8614, 1479.73, -54.71, 24.12,   0.00, 0.00, 309.74);
	CreateDynamicObject(8614, 1506.82, -75.11, 24.12,   0.00, 0.00, 39.74);
	CreateDynamicObject(994, 1497.10, -73.63, 25.35,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1493.04, -68.78, 25.35,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1488.97, -63.93, 25.35,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1484.89, -59.08, 25.35,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1480.80, -54.22, 25.35,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1470.29, -51.95, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1465.46, -56.01, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1460.60, -60.08, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1455.76, -64.14, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1450.89, -68.21, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1446.02, -72.30, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1441.19, -76.36, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1433.77, -82.61, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1428.93, -86.66, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1424.10, -90.70, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1419.24, -94.77, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1414.40, -98.82, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1406.98, -105.03, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1402.13, -109.11, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1397.29, -113.18, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(8614, 1398.45, -113.56, 24.12,   0.00, 0.00, 39.74);
	CreateDynamicObject(1342, 1464.21, -84.27, 23.25,   0.00, 0.00, 218.00);
	CreateDynamicObject(1341, 1451.61, -81.33, 23.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1340, 1452.09, -83.57, 23.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1474.41, -47.50, 25.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1441.07, -75.50, 25.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1414.16, -98.19, 25.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1397.15, -112.50, 25.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1457.22, -62.23, 25.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1452.73, -92.23, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1468.97, -64.83, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1495.47, -30.22, 25.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1489.80, -35.01, 25.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1502.00, -77.49, 25.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1441.49, -104.34, 18.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1435.89, -110.19, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1460.97, -72.10, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1415.79, -106.54, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1430.06, -123.82, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1469.50, -123.31, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1492.06, -107.14, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1490.89, -81.77, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(18649, 1510.01, -44.83, 27.75,   0.00, 0.00, 310.00);
	CreateDynamicObject(18649, 1510.73, -45.72, 27.75,   0.00, 0.00, 310.00);
	CreateDynamicObject(18650, 1467.20, -79.09, 27.81,   0.00, 0.00, 309.50);
	CreateDynamicObject(18650, 1460.69, -84.37, 27.76,   0.00, 0.00, 309.50);
	CreateDynamicObject(18650, 1463.97, -81.70, 27.79,   0.00, 0.00, 309.50);
	CreateDynamicObject(18650, 1457.85, -113.60, 27.65,   0.00, 0.00, 309.50);
	CreateDynamicObject(18650, 1464.96, -94.59, 25.34,   0.00, 0.00, 309.50);
	CreateDynamicObject(8879, 1440.69, -122.50, 28.31,   0.00, 0.00, 72.00);
	CreateDynamicObject(8879, 1490.40, -94.12, 28.31,   0.00, 0.00, 354.00);
	CreateDynamicObject(8880, 1435.84, -121.08, 29.07,   0.00, 0.00, 74.00);
	CreateDynamicObject(8880, 1490.93, -89.05, 29.07,   0.00, 0.00, 354.00);
	CreateDynamicObject(1594, 1423.91, -108.24, 22.70,   0.00, 0.00, 95.99);
	CreateDynamicObject(1594, 1425.42, -114.84, 22.70,   0.00, 0.00, 95.99);
	CreateDynamicObject(6289, 1498.67, -106.86, 24.71,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1510.89, -109.23, 22.22,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1515.83, -105.07, 22.22,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1520.77, -100.92, 22.22,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1525.72, -96.74, 22.22,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1530.75, -92.56, 22.22,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1535.75, -88.37, 22.22,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1540.72, -84.21, 22.22,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1545.72, -80.05, 22.22,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1550.71, -75.87, 22.22,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1488.57, -128.18, 22.22,   0.00, 0.00, 46.00);
	CreateDynamicObject(994, 1483.58, -132.36, 22.22,   0.00, 0.00, 39.99);
	CreateDynamicObject(994, 1478.53, -136.59, 22.22,   0.00, 0.00, 39.99);
	CreateDynamicObject(994, 1473.55, -140.77, 22.22,   0.00, 0.00, 39.99);
	CreateDynamicObject(994, 1468.56, -144.94, 22.22,   0.00, 0.00, 39.99);
	CreateDynamicObject(994, 1463.62, -149.10, 22.28,   0.00, 0.00, 39.99);
	CreateDynamicObject(3113, 1396.07, -135.60, 21.74,   0.00, 285.25, 39.00);
	CreateDynamicObject(3113, 1404.83, -128.50, 21.69,   0.00, 285.25, 38.99);
	CreateDynamicObject(994, 1395.89, -120.92, 22.22,   0.00, 0.00, 38.00);
	CreateDynamicObject(994, 1390.78, -124.93, 22.22,   0.00, 0.00, 37.99);
	CreateDynamicObject(994, 1407.65, -140.88, 22.22,   0.00, 0.00, 38.98);
	CreateDynamicObject(994, 1415.19, -134.53, 22.22,   0.00, 0.00, 128.98);
	CreateDynamicObject(994, 1411.13, -129.53, 22.22,   0.00, 0.00, 128.98);
	CreateDynamicObject(994, 1405.11, -121.92, 22.22,   0.00, 0.00, 128.98);
	CreateDynamicObject(994, 1555.66, -71.46, 22.22,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1551.43, -66.43, 22.22,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1547.20, -61.40, 22.22,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1542.90, -56.34, 22.22,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1538.67, -51.35, 22.22,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1547.45, -39.68, 25.35,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1543.24, -34.73, 25.35,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1539.05, -29.76, 25.35,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1534.90, -24.81, 25.35,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1530.66, -19.78, 25.35,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1526.43, -14.76, 25.35,   0.00, 0.00, 130.00);
	CreateDynamicObject(994, 1522.21, -9.81, 25.35,   0.00, 0.00, 192.00);
	CreateDynamicObject(994, 1515.98, -11.13, 25.35,   0.00, 0.00, 219.99);
	CreateDynamicObject(994, 1511.00, -14.85, 25.35,   0.00, 0.00, 129.99);
	CreateDynamicObject(994, 1506.84, -9.93, 25.35,   0.00, 0.00, 115.98);
	CreateDynamicObject(994, 1503.81, -4.13, 25.35,   0.00, 0.00, 129.98);
	CreateDynamicObject(994, 1499.65, 0.78, 25.35,   0.00, 0.00, 129.98);
	CreateDynamicObject(994, 1495.46, 5.70, 25.35,   0.00, 0.00, 129.98);
	CreateDynamicObject(994, 1487.38, -91.69, 24.94,   0.00, 0.00, 129.73);
	CreateDynamicObject(994, 1483.90, -87.49, 24.95,   0.00, 0.00, 129.98);
	CreateDynamicObject(994, 1474.97, -86.83, 24.95,   0.00, 0.00, 39.98);
	CreateDynamicObject(997, 1415.11, -134.80, 22.22,   0.00, 0.00, 219.50);
	CreateDynamicObject(997, 1507.74, -72.28, 25.35,   0.00, 0.00, 229.49);
	CreateDynamicObject(997, 1541.44, -44.52, 25.35,   0.00, 0.00, 207.49);
	CreateDynamicObject(997, 1544.07, -42.38, 25.35,   0.00, 0.00, 219.49);
	CreateDynamicObject(997, 1546.93, -39.97, 25.35,   0.00, 0.00, 219.48);
	CreateDynamicObject(1556, 1457.77, -97.96, 22.21,   0.00, 0.00, 309.25);
	CreateDynamicObject(1556, 1458.71, -99.10, 22.21,   0.00, 0.00, 309.25);
	CreateDynamicObject(3472, 1496.46, -14.30, 25.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1449.58, -50.52, 25.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1408.23, -111.56, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1420.27, -127.33, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1362.69, -125.09, 25.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1233.95, -142.18, 38.43,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1222.10, -128.53, 38.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1474.13, 78.61, 29.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1481.34, 66.79, 29.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1370.48, -26.88, 33.13,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1364.19, -14.14, 33.06,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1568.07, -2.92, 21.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1551.56, -5.23, 21.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1541.78, 54.15, 25.09,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1553.79, 58.67, 25.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1477.54, -129.77, 22.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(2773, 1496.77, -29.74, 25.88,   0.00, 0.00, 310.00);
	CreateDynamicObject(2773, 1498.55, -28.27, 25.87,   0.00, 0.00, 312.00);
	CreateDynamicObject(2773, 1496.57, -26.63, 25.87,   0.00, 0.00, 308.00);
	CreateDynamicObject(2773, 1498.44, -25.12, 25.87,   0.00, 0.00, 307.99);
	CreateDynamicObject(2773, 1501.75, -26.71, 25.87,   0.00, 0.00, 221.99);
	CreateDynamicObject(2773, 1500.17, -24.98, 25.87,   0.00, 0.00, 221.99);
	CreateDynamicObject(2773, 1408.45, -123.89, 22.74,   0.00, 0.00, 307.99);
	CreateDynamicObject(2773, 1408.27, -122.12, 22.74,   0.00, 0.00, 223.99);
	CreateDynamicObject(2773, 1406.63, -120.43, 22.74,   0.00, 0.00, 223.99);
	CreateDynamicObject(2773, 1404.04, -118.49, 22.74,   0.00, 0.00, 309.99);
	CreateDynamicObject(3113, 1538.85, -65.37, 21.69,   0.00, 285.25, 38.99);
	CreateDynamicObject(3113, 1527.69, -74.38, 21.69,   0.00, 285.25, 218.99);
	CreateDynamicObject(994, 1528.98, -85.56, 22.22,   0.00, 0.00, 309.25);
	CreateDynamicObject(994, 1524.90, -80.52, 22.22,   0.00, 0.00, 309.24);
	CreateDynamicObject(994, 1514.23, -67.08, 22.22,   0.00, 0.00, 309.24);
	CreateDynamicObject(994, 1518.33, -72.21, 22.22,   0.00, 0.00, 309.24);
	CreateDynamicObject(994, 1519.20, -62.97, 22.22,   0.00, 0.00, 219.24);
	CreateDynamicObject(994, 1524.19, -58.89, 22.22,   0.00, 0.00, 219.24);
	CreateDynamicObject(994, 1529.15, -54.85, 22.22,   0.00, 0.00, 219.24);
	CreateDynamicObject(994, 1534.13, -50.78, 22.22,   0.00, 0.00, 219.24);
	CreateDynamicObject(2773, 1523.87, -81.50, 22.73,   0.00, 0.00, 307.99);
	CreateDynamicObject(2773, 1521.10, -77.85, 22.73,   0.00, 0.00, 307.99);
	CreateDynamicObject(2773, 1522.47, -79.44, 22.73,   0.00, 0.00, 307.99);
	CreateDynamicObject(2773, 1517.69, -78.74, 22.73,   0.00, 0.00, 217.99);
	CreateDynamicObject(2773, 1519.15, -80.60, 22.73,   0.00, 0.00, 217.99);
	CreateDynamicObject(2773, 1520.58, -82.45, 22.73,   0.00, 0.00, 217.99);
	CreateDynamicObject(2773, 1522.08, -84.38, 22.73,   0.00, 0.00, 217.99);
	CreateDynamicObject(2773, 1519.22, -77.11, 22.73,   0.00, 0.00, 217.99);
	CreateDynamicObject(2773, 1524.07, -83.17, 22.73,   0.00, 0.00, 217.99);
	CreateDynamicObject(16770, 1452.54, -17.73, 31.66,   0.00, 0.00, 40.00);
	CreateDynamicObject(7922, 1458.40, 15.92, 31.19,   0.00, 0.00, 310.00);
	CreateDynamicObject(16770, 1446.75, -10.83, 31.65,   0.00, 0.00, 40.00);
	CreateDynamicObject(2678, 1461.60, 11.50, 31.16,   89.44, 243.44, 156.56);
	CreateDynamicObject(2678, 1464.98, 7.42, 31.16,   89.44, 243.44, 156.56);
	CreateDynamicObject(2678, 1469.02, 2.64, 31.16,   89.44, 243.44, 156.56);
	CreateDynamicObject(2678, 1472.55, -1.58, 31.16,   89.44, 243.44, 156.56);
	CreateDynamicObject(2678, 1467.03, 5.02, 31.16,   89.44, 243.44, 156.56);
	CreateDynamicObject(2678, 1470.74, 0.59, 31.16,   89.44, 243.44, 156.56);
	CreateDynamicObject(2678, 1463.27, 9.52, 31.16,   89.44, 243.44, 156.56);
	CreateDynamicObject(2678, 1474.46, -3.85, 31.16,   89.44, 243.44, 156.56);
	CreateDynamicObject(2678, 1459.83, 13.54, 31.16,   89.44, 243.44, 156.56);
	CreateDynamicObject(1517, 1459.63, 14.35, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1459.79, 14.16, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1460.04, 13.87, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1460.24, 13.63, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1460.49, 13.34, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1460.71, 13.07, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1461.29, 12.38, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1461.63, 11.98, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1461.98, 11.56, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1462.24, 11.26, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1462.52, 10.93, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1462.93, 10.43, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1463.19, 10.13, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1463.48, 9.78, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1463.84, 9.36, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1464.17, 8.96, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1464.74, 8.29, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1464.98, 8.01, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1465.30, 7.63, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1465.59, 7.28, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1465.95, 6.86, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1466.73, 5.93, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1467.06, 5.54, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1467.35, 5.20, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1467.67, 4.82, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1468.01, 4.42, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1468.77, 3.52, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1468.96, 3.29, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1469.28, 2.91, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1469.59, 2.55, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1469.91, 2.16, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1470.47, 1.50, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1470.83, 1.07, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1471.13, 0.71, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1471.42, 0.37, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1471.76, -0.03, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1472.31, -0.68, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1472.52, -0.93, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1472.86, -1.33, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1473.13, -1.65, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1473.50, -2.09, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1474.21, -2.93, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1474.55, -3.33, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1474.82, -3.66, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1475.16, -4.06, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1475.48, -4.44, 31.40,   0.00, 0.00, 40.00);
	CreateDynamicObject(1431, 1454.41, 6.55, 30.62,   0.00, 0.00, 344.00);
	CreateDynamicObject(1431, 1461.09, -0.17, 30.62,   0.00, 0.00, 310.00);
	CreateDynamicObject(1431, 1466.90, -8.69, 30.61,   0.00, 0.00, 282.00);
	CreateDynamicObject(2912, 1453.42, 1.43, 30.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(2912, 1458.62, -5.04, 30.07,   0.00, 0.00, 22.00);
	CreateDynamicObject(2912, 1470.67, -5.95, 30.07,   0.00, 0.00, 43.99);
	CreateDynamicObject(2912, 1459.87, 4.11, 30.07,   0.00, 0.00, 49.99);
	CreateDynamicObject(1517, 1459.83, 4.18, 30.97,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1453.50, 1.59, 30.97,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1453.55, 1.30, 30.97,   0.00, 0.00, 40.00);
	CreateDynamicObject(1517, 1458.65, -4.96, 30.97,   0.00, 0.00, 40.00);
	CreateDynamicObject(1501, 1443.20, 0.71, 30.07,   0.00, 0.00, 308.00);
	CreateDynamicObject(1967, 1442.31, 1.86, 31.07,   0.00, 0.00, 38.00);
	CreateDynamicObject(1967, 1441.77, 2.55, 31.07,   0.00, 0.00, 38.00);
	CreateDynamicObject(1594, 1456.27, -74.15, 22.70,   0.00, 0.00, 18.00);
	CreateDynamicObject(1594, 1458.82, -82.44, 22.70,   0.00, 0.00, 18.00);
	CreateDynamicObject(1594, 1449.85, -76.24, 22.70,   0.00, 0.00, 18.00);
	CreateDynamicObject(1594, 1432.89, -113.28, 22.69,   0.00, 0.00, 18.00);
	CreateDynamicObject(1594, 1468.13, -107.66, 22.69,   0.00, 0.00, 18.00);
	CreateDynamicObject(1594, 1486.22, -111.15, 22.69,   0.00, 0.00, 18.00);
	CreateDynamicObject(994, 1222.21, -136.27, 38.53,   0.00, 0.00, 310.00);
	CreateDynamicObject(1228, 1227.87, -140.30, 38.89,   0.00, 0.00, 36.00);
	CreateDynamicObject(1228, 1225.91, -137.72, 38.84,   0.00, 0.00, 40.00);
	CreateDynamicObject(1228, 1223.62, -135.20, 38.90,   0.00, 0.00, 40.00);
	CreateDynamicObject(1237, 1220.35, -136.52, 38.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1221.86, -138.33, 38.55,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1223.66, -140.73, 38.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1225.27, -142.90, 38.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1247.41, -130.05, 37.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1234.78, -139.07, 38.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1459.77, -218.28, 9.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1453.04, -218.53, 8.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1447.16, -218.80, 8.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1441.23, -218.94, 7.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1474.51, -215.62, 9.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1478.33, -214.49, 10.05,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1482.25, -213.05, 10.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1518.54, -194.14, 11.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1521.24, -191.68, 12.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1523.44, -189.63, 12.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1540.85, -170.42, 14.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1543.03, -167.80, 14.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1545.13, -165.36, 14.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1547.62, -162.41, 15.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1555.96, -149.94, 16.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1556.58, -147.25, 16.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1557.09, -144.27, 16.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1557.71, -141.43, 16.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1560.78, -126.07, 17.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1561.21, -98.54, 19.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1561.58, -95.56, 19.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1566.05, 15.85, 23.16,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1553.14, 11.78, 23.16,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1566.34, -8.88, 21.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1565.97, -4.47, 21.46,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1565.78, -0.27, 21.87,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1565.81, 4.23, 22.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1554.49, -9.73, 20.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1553.95, -5.40, 21.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1553.95, -2.22, 21.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1553.81, 1.18, 22.13,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1564.93, -23.06, 20.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1565.40, -18.23, 20.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1565.98, -13.01, 20.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1555.00, -21.24, 20.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1554.33, -15.57, 20.63,   0.00, 0.00, 0.00);
	CreateDynamicObject(997, 1561.10, 32.16, 23.16,   0.00, 0.00, 12.00);
	CreateDynamicObject(997, 1557.80, 31.36, 23.16,   0.00, 0.00, 12.00);
	CreateDynamicObject(997, 1554.40, 30.55, 23.15,   0.00, 0.00, 12.00);
	CreateDynamicObject(997, 1550.94, 29.73, 23.14,   0.00, 0.00, 12.00);
	CreateDynamicObject(997, 1547.37, 28.89, 23.14,   0.00, 0.00, 12.00);
	CreateDynamicObject(997, 1543.23, 22.53, 23.14,   0.00, 0.00, 102.00);
	CreateDynamicObject(994, 1556.94, -43.09, 20.20,   0.00, 0.00, 94.00);
	CreateDynamicObject(994, 1555.75, -64.60, 19.92,   0.00, 0.00, 87.99);
	CreateDynamicObject(994, 1553.67, -87.13, 19.65,   0.00, 0.00, 87.99);
	CreateDynamicObject(1237, 1291.42, -75.20, 35.55,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1293.13, -73.76, 35.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1295.14, -72.17, 35.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1296.99, -70.65, 35.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1298.89, -69.03, 35.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1300.53, -67.70, 35.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(18766, 1458.30, -40.61, 27.86,   0.00, 0.00, 40.00);
	CreateDynamicObject(18766, 1458.90, -41.32, 27.86,   0.00, 0.00, 40.00);
	CreateDynamicObject(1896, 1458.65, -45.48, 26.34,   0.00, 0.00, 40.00);
	CreateDynamicObject(1896, 1462.41, -42.62, 26.34,   0.00, 0.00, 40.00);
	CreateDynamicObject(1896, 1458.71, -37.04, 26.34,   0.00, 0.00, 220.00);
	CreateDynamicObject(1896, 1454.40, -40.21, 26.34,   0.00, 0.00, 219.99);
	CreateDynamicObject(18766, 1460.17, -42.83, 30.81,   90.00, 180.04, 219.95);
	CreateDynamicObject(18766, 1456.98, -39.04, 30.81,   90.00, 180.04, 219.95);
	CreateDynamicObject(18762, 1464.94, -41.37, 27.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1458.02, -47.20, 27.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1452.35, -40.44, 27.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1459.17, -34.69, 27.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(18766, 1465.88, -34.79, 27.86,   0.00, 0.00, 130.00);
	CreateDynamicObject(18766, 1464.32, -36.08, 30.81,   90.00, 180.04, 129.95);
	CreateDynamicObject(18766, 1469.29, -31.86, 27.86,   0.00, 0.00, 40.00);
	CreateDynamicObject(18766, 1468.44, -29.32, 30.81,   90.00, 180.04, 39.94);
	CreateDynamicObject(18766, 1471.65, -33.16, 30.81,   90.00, 180.03, 39.94);
	CreateDynamicObject(18762, 1476.33, -31.78, 27.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1470.59, -24.98, 27.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(1896, 1471.86, -33.70, 26.34,   0.00, 0.00, 40.00);
	CreateDynamicObject(1895, 1470.27, -31.80, 28.54,   0.00, 0.00, 40.00);
	CreateDynamicObject(3472, 1410.54, -83.67, 25.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1250.36, -132.59, 37.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1255.63, -136.96, 37.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1260.21, -141.23, 37.87,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1264.46, -144.91, 37.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1258.35, -156.28, 37.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1253.65, -152.17, 38.09,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1248.98, -147.48, 38.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1243.80, -143.91, 38.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1239.01, -140.90, 38.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(1515, 1446.29, -45.51, 25.36,   0.00, 0.00, 310.00);
	CreateDynamicObject(1515, 1446.79, -46.11, 25.36,   0.00, 0.00, 310.00);
	CreateDynamicObject(1515, 1447.29, -46.70, 25.36,   0.00, 0.00, 310.00);
	CreateDynamicObject(1515, 1447.79, -47.30, 25.36,   0.00, 0.00, 310.00);
	CreateDynamicObject(1515, 1448.28, -47.89, 25.36,   0.00, 0.00, 310.00);
	CreateDynamicObject(1515, 1447.06, -44.88, 25.36,   0.00, 0.00, 130.00);
	CreateDynamicObject(1515, 1447.57, -45.47, 25.36,   0.00, 0.00, 130.00);
	CreateDynamicObject(1515, 1448.07, -46.06, 25.36,   0.00, 0.00, 130.00);
	CreateDynamicObject(1515, 1448.56, -46.66, 25.36,   0.00, 0.00, 130.00);
	CreateDynamicObject(1515, 1449.06, -47.24, 25.36,   0.00, 0.00, 130.00);
	CreateDynamicObject(1515, 1451.28, -51.63, 25.36,   0.00, 0.00, 310.00);
	CreateDynamicObject(1515, 1451.79, -52.23, 25.36,   0.00, 0.00, 310.00);
	CreateDynamicObject(1515, 1452.29, -52.83, 25.36,   0.00, 0.00, 310.00);
	CreateDynamicObject(1515, 1452.80, -53.42, 25.36,   0.00, 0.00, 310.00);
	CreateDynamicObject(1515, 1453.29, -54.02, 25.36,   0.00, 0.00, 310.00);
	CreateDynamicObject(1515, 1454.06, -53.38, 25.36,   0.00, 0.00, 130.00);
	CreateDynamicObject(1515, 1453.56, -52.78, 25.36,   0.00, 0.00, 130.00);
	CreateDynamicObject(1515, 1453.06, -52.19, 25.36,   0.00, 0.00, 130.00);
	CreateDynamicObject(1515, 1452.55, -51.60, 25.36,   0.00, 0.00, 130.00);
	CreateDynamicObject(1515, 1452.05, -51.00, 25.36,   0.00, 0.00, 130.00);
	CreateDynamicObject(1837, 1464.54, -34.16, 26.19,   0.00, 0.00, 310.00);
	CreateDynamicObject(1837, 1466.57, -36.60, 26.19,   0.00, 0.00, 310.00);
	CreateDynamicObject(1838, 1467.48, -32.48, 26.18,   0.00, 0.00, 220.00);
	CreateDynamicObject(1838, 1468.48, -31.61, 26.18,   0.00, 0.00, 220.00);
	CreateDynamicObject(1838, 1469.47, -30.78, 26.18,   0.00, 0.00, 220.00);
	CreateDynamicObject(1838, 1470.49, -29.93, 26.18,   0.00, 0.00, 220.00);
	CreateDynamicObject(1838, 1471.64, -28.96, 26.18,   0.00, 0.00, 220.00);
	CreateDynamicObject(1838, 1464.10, -31.65, 26.18,   0.00, 0.00, 130.00);
	CreateDynamicObject(1722, 1470.95, -27.94, 25.36,   0.00, 0.00, 220.00);
	CreateDynamicObject(1722, 1466.28, -30.92, 25.36,   0.00, 0.00, 220.00);
	CreateDynamicObject(1722, 1465.38, -30.47, 25.36,   0.00, 0.00, 156.00);
	CreateDynamicObject(1722, 1462.92, -34.04, 25.36,   0.00, 0.00, 257.99);
	CreateDynamicObject(1722, 1464.82, -36.59, 25.36,   0.00, 0.00, 293.99);
	CreateDynamicObject(3472, 1203.73, -160.84, 39.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1192.29, -149.74, 39.46,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1451.23, 24.96, 30.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1433.73, 6.98, 30.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1477.69, -6.23, 32.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(3361, 1444.67, -36.25, 27.98,   0.00, 0.00, 40.00);
	CreateDynamicObject(3361, 1437.14, -42.57, 27.98,   0.00, 0.00, 220.00);
	CreateDynamicObject(3361, 1432.50, -46.44, 23.96,   0.00, 0.00, 219.99);
	CreateDynamicObject(3361, 1449.30, -32.37, 23.96,   0.00, 0.00, 39.99);
	CreateDynamicObject(3361, 1386.44, -87.29, 27.98,   0.00, 0.00, 309.99);
	CreateDynamicObject(3361, 1388.04, -85.96, 27.98,   0.00, 0.00, 309.98);
	CreateDynamicObject(3361, 1390.32, -91.90, 23.96,   0.00, 0.00, 309.99);
	CreateDynamicObject(3361, 1391.89, -90.55, 23.96,   0.00, 0.00, 309.98);
	CreateDynamicObject(997, 1440.36, -41.07, 30.06,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1449.82, -30.27, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1444.94, -34.37, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1432.67, -44.76, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1427.70, -48.89, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1422.77, -52.97, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1417.85, -57.10, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1412.89, -61.30, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1407.89, -65.46, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1402.92, -69.65, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1397.97, -73.80, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1393.05, -77.94, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1387.81, -82.29, 30.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(6300, 1380.68, -38.17, 22.00,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1378.42, -82.26, 30.07,   0.00, 0.00, 324.00);
	CreateDynamicObject(994, 1374.01, -77.01, 30.07,   0.00, 0.00, 309.99);
	CreateDynamicObject(994, 1369.38, -71.52, 30.07,   0.00, 0.00, 309.99);
	CreateDynamicObject(18766, 1394.51, -55.39, 32.57,   0.00, 0.00, 40.00);
	CreateDynamicObject(18090, 1395.94, -57.25, 32.64,   0.00, 0.00, 130.00);
	CreateDynamicObject(18762, 1400.54, -55.12, 32.57,   0.00, 0.00, 308.00);
	CreateDynamicObject(18762, 1400.23, -54.73, 32.57,   0.00, 0.00, 307.99);
	CreateDynamicObject(2904, 1399.13, -53.45, 33.78,   0.00, 0.00, 310.00);
	CreateDynamicObject(2723, 1400.66, -57.25, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(2723, 1398.88, -58.87, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(2723, 1397.18, -60.22, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(2723, 1395.55, -61.49, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(2723, 1393.39, -62.19, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(2723, 1391.12, -60.48, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(1594, 1388.68, -67.47, 30.55,   0.00, 0.00, 77.99);
	CreateDynamicObject(1594, 1397.17, -69.06, 30.55,   0.00, 0.00, 93.99);
	CreateDynamicObject(1594, 1404.29, -62.90, 30.55,   0.00, 0.00, 113.99);
	CreateDynamicObject(1594, 1410.94, -56.64, 30.55,   0.00, 0.00, 125.98);
	CreateDynamicObject(1594, 1404.66, -54.95, 30.55,   0.00, 0.00, 125.98);
	CreateDynamicObject(1594, 1411.17, -50.33, 30.54,   0.00, 0.00, 145.98);
	CreateDynamicObject(1594, 1391.94, -74.80, 30.55,   0.00, 0.00, 145.98);
	CreateDynamicObject(1594, 1379.99, -66.43, 30.55,   0.00, 0.00, 167.98);
	CreateDynamicObject(18090, 1393.20, -53.51, 32.64,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1388.38, -55.57, 32.57,   0.00, 0.00, 307.99);
	CreateDynamicObject(18762, 1388.68, -55.97, 32.57,   0.00, 0.00, 307.99);
	CreateDynamicObject(2904, 1389.78, -57.21, 33.78,   0.00, 0.00, 310.00);
	CreateDynamicObject(1543, 1395.02, -50.43, 31.11,   0.00, 0.00, 0.00);
	CreateDynamicObject(1543, 1390.77, -54.11, 31.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1543, 1392.36, -52.32, 31.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1543, 1396.24, -51.01, 31.11,   0.00, 0.00, 0.00);
	CreateDynamicObject(1543, 1398.44, -56.34, 31.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1543, 1397.89, -57.45, 31.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1543, 1396.70, -58.13, 31.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1543, 1394.84, -59.66, 31.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1543, 1392.51, -59.55, 31.11,   0.00, 0.00, 0.00);
	CreateDynamicObject(1594, 1396.93, -41.82, 30.55,   0.00, 0.00, 125.98);
	CreateDynamicObject(1594, 1382.23, -53.69, 30.55,   0.00, 0.00, 125.98);
	CreateDynamicObject(1594, 1388.20, -47.21, 30.55,   0.00, 0.00, 125.98);
	CreateDynamicObject(2723, 1387.67, -53.44, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(2723, 1389.45, -52.15, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(2723, 1390.97, -50.77, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(2723, 1392.58, -49.09, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(2723, 1394.60, -48.33, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(2723, 1397.48, -49.37, 30.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(11489, 1374.26, -73.49, 30.07,   0.00, 0.00, 130.00);
	CreateDynamicObject(3472, 1512.61, 108.34, 28.69,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1528.75, 130.84, 29.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1518.87, 110.13, 28.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1521.10, 110.83, 28.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1523.67, 112.21, 28.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1526.20, 113.34, 28.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1528.40, 114.45, 28.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1615.88, 139.94, 29.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1531.05, 115.86, 28.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1615.32, 135.95, 29.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1615.47, 133.31, 28.91,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1614.81, 130.52, 28.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1615.13, 127.75, 28.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1615.36, 125.12, 29.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1616.23, 122.65, 29.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(9833, 1438.06, -27.60, 32.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(9833, 1423.16, -40.80, 32.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(9833, 1417.68, -19.67, 32.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1453.23, -23.33, 30.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1438.50, -6.40, 30.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1434.86, 30.11, 30.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1402.77, 2.36, 31.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1378.05, -20.41, 32.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1325.03, -67.81, 34.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1355.96, -40.99, 33.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1256.36, -123.25, 37.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1473.67, 61.50, 29.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1518.92, 90.43, 28.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1574.08, 116.32, 28.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1458.66, 16.76, 32.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1431.69, -43.49, 30.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1407.08, -64.92, 30.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1387.50, -80.82, 30.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1402.92, -49.02, 30.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1568, 1384.54, -63.86, 30.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(6300, 1364.35, -0.82, 22.82,   0.00, 0.00, 220.00);
	CreateDynamicObject(6300, 1340.10, 28.06, 22.81,   0.00, 0.00, 219.99);
	CreateDynamicObject(1237, 1597.11, 108.61, 36.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1596.82, 105.77, 36.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1595.77, 102.35, 36.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1595.03, 98.53, 36.72,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1594.08, 94.09, 36.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1592.54, 91.01, 36.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(1506, 1480.32, -92.76, 24.95,   0.00, 0.00, 310.00);
	CreateDynamicObject(1506, 1479.44, -91.68, 24.95,   0.00, 0.00, 310.00);
	CreateDynamicObject(18783, 1315.63, 35.71, 29.61,   0.00, 0.00, 310.00);
	CreateDynamicObject(18783, 1338.74, 55.15, 29.61,   0.00, 0.00, 310.00);
	CreateDynamicObject(18783, 1327.48, 45.70, 29.60,   0.00, 0.00, 310.00);
	CreateDynamicObject(18275, 1322.48, 48.36, 34.31,   0.00, 0.00, 40.00);
	CreateDynamicObject(18275, 1317.13, 43.93, 34.31,   0.00, 0.00, 40.00);
	CreateDynamicObject(18275, 1327.81, 52.83, 34.31,   0.00, 0.00, 40.00);
	CreateDynamicObject(18275, 1337.85, 52.34, 34.31,   0.00, 0.00, 330.00);
	CreateDynamicObject(18275, 1314.67, 35.02, 34.31,   0.00, 0.00, 99.99);
	CreateDynamicObject(16092, 1330.71, 37.29, 32.65,   0.00, 0.00, 310.00);
	CreateDynamicObject(16132, 1318.66, 49.14, 32.11,   0.00, 0.00, 130.00);
	CreateDynamicObject(18655, 1316.16, 35.91, 32.11,   0.00, 0.00, 170.00);
	CreateDynamicObject(18655, 1317.27, 40.08, 32.11,   0.00, 0.00, 162.00);
	CreateDynamicObject(18655, 1335.87, 51.22, 32.11,   0.00, 0.00, 81.99);
	CreateDynamicObject(18655, 1332.33, 52.44, 32.11,   0.00, 0.00, 81.99);
	CreateDynamicObject(18766, 1310.80, 43.88, 34.61,   0.00, 0.00, 220.00);
	CreateDynamicObject(18766, 1318.46, 50.31, 34.60,   0.00, 0.00, 220.00);
	CreateDynamicObject(18766, 1326.11, 56.73, 34.61,   0.00, 0.00, 220.00);
	CreateDynamicObject(18766, 1333.75, 63.15, 34.61,   0.00, 0.00, 220.00);
	CreateDynamicObject(18766, 1340.70, 61.88, 34.61,   0.00, 0.00, 130.00);
	CreateDynamicObject(18766, 1337.95, 53.81, 34.61,   0.00, 0.00, 150.00);
	CreateDynamicObject(18766, 1313.36, 34.36, 34.61,   0.00, 0.00, 99.99);
	CreateDynamicObject(18766, 1308.02, 36.26, 34.61,   0.00, 0.00, 99.99);
	CreateDynamicObject(18766, 1312.12, 27.87, 34.61,   0.00, 0.00, 131.99);
	CreateDynamicObject(18766, 1345.79, 55.87, 34.61,   0.00, 0.00, 129.98);
	CreateDynamicObject(18766, 1345.51, 54.58, 34.61,   0.00, 0.00, 219.99);
	CreateDynamicObject(2290, 1340.94, 59.20, 32.11,   0.00, 0.00, 310.00);
	CreateDynamicObject(2290, 1338.65, 61.89, 32.11,   0.00, 0.00, 310.00);
	CreateDynamicObject(2290, 1340.31, 53.83, 32.11,   0.00, 0.00, 152.00);
	CreateDynamicObject(2290, 1336.99, 55.66, 32.11,   0.00, 0.00, 151.99);
	CreateDynamicObject(1497, 1343.89, 57.35, 32.11,   0.00, 0.00, 310.00);
	CreateDynamicObject(1497, 1344.70, 57.94, 32.11,   0.00, 0.00, 310.00);
	CreateDynamicObject(8614, 1346.54, 62.74, 30.89,   0.00, 0.00, 130.00);
	CreateDynamicObject(2229, 1326.69, 34.36, 32.10,   0.00, 0.00, 40.00);
	CreateDynamicObject(2229, 1334.99, 41.31, 32.10,   0.00, 0.00, 40.00);
	CreateDynamicObject(3657, 1332.89, 26.34, 31.38,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1334.98, 23.96, 31.39,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1337.09, 21.63, 31.39,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1339.17, 19.24, 31.39,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1340.68, 32.47, 31.38,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1342.49, 30.26, 31.39,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1344.49, 27.72, 31.39,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1346.54, 25.27, 31.39,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1336.63, 29.32, 31.38,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1338.59, 27.03, 31.39,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1340.71, 24.57, 31.39,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1342.84, 22.06, 31.39,   0.00, 0.00, 220.00);
	CreateDynamicObject(3657, 1326.14, 23.50, 31.38,   0.00, 0.00, 190.00);
	CreateDynamicObject(3657, 1328.67, 20.45, 31.38,   0.00, 0.00, 189.99);
	CreateDynamicObject(3657, 1332.27, 16.99, 31.39,   0.00, 0.00, 189.99);
	CreateDynamicObject(3657, 1345.52, 38.33, 31.38,   0.00, 0.00, 247.99);
	CreateDynamicObject(3657, 1348.07, 35.18, 31.39,   0.00, 0.00, 247.99);
	CreateDynamicObject(3657, 1351.22, 31.83, 31.39,   0.00, 0.00, 247.99);
	CreateDynamicObject(994, 1338.54, 76.74, 30.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1343.03, 71.26, 30.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1347.65, 65.74, 30.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1352.35, 60.11, 30.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1357.13, 54.16, 30.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1361.87, 48.80, 30.86,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1366.46, 43.22, 30.87,   0.00, 0.00, 310.25);
	CreateDynamicObject(994, 1371.22, 37.51, 30.87,   0.00, 0.00, 310.24);
	CreateDynamicObject(994, 1292.42, 38.06, 30.86,   0.00, 0.00, 310.24);
	CreateDynamicObject(994, 1296.85, 32.80, 30.86,   0.00, 0.00, 309.99);
	CreateDynamicObject(994, 1301.32, 27.59, 30.86,   0.00, 0.00, 309.99);
	CreateDynamicObject(994, 1305.80, 22.20, 30.86,   0.00, 0.00, 309.99);
	CreateDynamicObject(994, 1310.31, 16.94, 30.86,   0.00, 0.00, 309.99);
	CreateDynamicObject(994, 1314.73, 11.73, 30.86,   0.00, 0.00, 309.99);
	CreateDynamicObject(994, 1319.47, 6.15, 30.87,   0.00, 0.00, 309.99);
	CreateDynamicObject(994, 1324.24, 0.76, 30.87,   0.00, 0.00, 309.99);
	CreateDynamicObject(994, 1328.65, -4.55, 30.87,   0.00, 0.00, 309.99);
	CreateDynamicObject(994, 1333.68, -10.46, 30.87,   0.00, 0.00, 309.99);
	CreateDynamicObject(994, 1319.37, 26.27, 32.11,   0.00, 0.00, 219.99);
	CreateDynamicObject(994, 1325.04, 31.02, 32.11,   0.00, 0.00, 219.99);
	CreateDynamicObject(994, 1342.57, 46.00, 32.11,   0.00, 0.00, 219.99);
	CreateDynamicObject(994, 1348.06, 50.67, 32.11,   0.00, 0.00, 219.99);
	CreateDynamicObject(994, 1375.75, 32.06, 30.87,   0.00, 0.00, 220.24);
	CreateDynamicObject(994, 1370.51, 27.77, 30.87,   0.00, 0.00, 220.24);
	CreateDynamicObject(994, 1365.27, 23.36, 30.87,   0.00, 0.00, 220.24);
	CreateDynamicObject(994, 1360.06, 18.97, 30.87,   0.00, 0.00, 220.24);
	CreateDynamicObject(994, 1354.86, 14.51, 30.87,   0.00, 0.00, 220.24);
	CreateDynamicObject(994, 1349.39, 9.93, 30.87,   0.00, 0.00, 220.24);
	CreateDynamicObject(994, 1343.97, 5.44, 30.87,   0.00, 0.00, 220.24);
	CreateDynamicObject(994, 1338.61, 0.93, 30.87,   0.00, 0.00, 220.24);
	CreateDynamicObject(1237, 1330.70, -4.48, 30.87,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1332.50, -3.04, 30.87,   0.00, 0.00, 0.00);
	CreateDynamicObject(994, 1389.28, -119.62, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1384.15, -123.92, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1379.01, -128.21, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1373.73, -132.59, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1368.62, -136.80, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1363.33, -141.24, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(994, 1358.08, -145.38, 25.36,   0.00, 0.00, 40.00);
	CreateDynamicObject(3472, 1323.72, 14.08, 30.87,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1358.38, 41.02, 30.87,   0.00, 0.00, 0.00);
	CreateDynamicObject(3472, 1348.80, 17.13, 30.87,   0.00, 0.00, 0.00);
	CreateDynamicObject(18888, 1497.17, -32.80, 28.35,   0.00, 0.00, 310.00);
	CreateDynamicObject(18888, 1495.80, -33.76, 28.35,   0.00, 0.00, 310.00);
	CreateDynamicObject(18888, 1494.77, -34.71, 28.35,   0.00, 0.00, 310.00);
	CreateDynamicObject(18888, 1493.64, -35.70, 28.35,   0.00, 0.00, 310.00);
	CreateDynamicObject(18888, 1492.46, -36.36, 28.35,   0.00, 0.00, 310.00);
	CreateDynamicObject(18888, 1316.62, 23.89, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1317.57, 24.70, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1318.51, 25.52, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1319.65, 26.49, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1320.60, 27.31, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1321.54, 28.12, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1322.68, 29.10, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1323.63, 29.92, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1325.14, 31.22, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1326.28, 32.20, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1327.61, 33.34, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1328.36, 33.99, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1329.69, 35.13, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1328.93, 34.48, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1330.26, 35.62, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1331.40, 36.60, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1332.34, 37.41, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1333.48, 38.39, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1334.24, 39.04, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1335.18, 39.85, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1335.94, 40.50, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1337.08, 41.48, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1337.84, 42.13, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1338.78, 42.95, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1339.92, 43.93, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1340.68, 44.58, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1341.63, 45.39, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1342.57, 46.21, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1343.52, 47.02, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1344.47, 47.83, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1345.41, 48.65, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1346.55, 49.63, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1347.88, 50.77, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1348.82, 51.58, 33.76,   0.00, 0.00, 40.00);
	CreateDynamicObject(2773, 1427.59, -72.92, 25.88,   0.00, 0.00, 38.00);
	CreateDynamicObject(2773, 1429.50, -71.19, 25.88,   0.00, 0.00, 38.00);
	CreateDynamicObject(2773, 1429.31, -75.00, 25.87,   0.00, 0.00, 38.00);
	CreateDynamicObject(2773, 1431.28, -75.78, 25.88,   0.00, 0.00, 100.00);
	CreateDynamicObject(2773, 1433.45, -74.52, 25.87,   0.00, 0.00, 127.99);
	CreateDynamicObject(1237, 1244.91, -127.21, 37.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1242.85, -124.57, 37.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1240.35, -121.66, 37.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1200.35, -78.09, 36.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1213.63, -92.78, 38.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1229.86, -108.28, 38.23,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1187.58, -70.39, 33.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 305.68, -369.04, 8.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 308.55, -370.20, 8.46,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 311.36, -370.77, 8.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 314.79, -371.52, 8.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 317.87, -372.31, 9.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 355.31, -338.17, 11.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 343.29, -343.94, 8.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 333.39, -349.97, 7.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 325.51, -355.54, 7.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 321.29, -361.30, 8.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 318.94, -367.75, 8.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 325.72, -343.69, 8.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 337.40, -336.12, 9.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 348.01, -331.09, 10.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 356.95, -326.87, 11.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 463.31, -287.09, 9.17,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 466.52, -283.20, 9.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 468.62, -280.06, 9.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 740.42, -156.95, 18.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 737.54, -159.92, 18.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 731.98, -163.80, 18.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 727.81, -166.54, 19.23,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 760.21, -159.05, 17.52,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 755.55, -162.56, 17.52,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 751.61, -165.76, 17.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(994, 1241.32, -119.23, 37.83,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 1246.21, -124.81, 37.75,   0.00, 0.00, 310.00);
	CreateDynamicObject(994, 759.35, -161.06, 17.52,   0.00, 0.00, 226.00);
	CreateDynamicObject(994, 312.58, -370.02, 8.49,   0.00, 0.00, 145.99);
	CreateDynamicObject(7922, 1458.40, 15.92, 33.94,   0.00, 0.00, 310.00);
	CreateDynamicObject(18888, 1459.13, -20.57, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1458.00, -19.24, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1457.19, -18.28, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1456.22, -17.14, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1455.08, -15.81, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1454.11, -14.67, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1453.30, -13.71, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1452.49, -12.76, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1451.51, -11.62, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1450.70, -10.67, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1449.73, -9.52, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1449.73, -9.52, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1449.08, -8.76, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1448.27, -7.81, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1447.14, -6.48, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1446.17, -5.33, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1445.35, -4.38, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1444.38, -3.24, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1443.41, -2.10, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1442.60, -1.15, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1441.79, -0.19, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1441.30, 0.38, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(18888, 1440.82, 0.95, 33.53,   0.00, 0.00, 40.00);
	CreateDynamicObject(10010, 1236.07, 185.69, 4.35,   0.00, 0.00, 330.00);
	CreateDynamicObject(10184, 1223.12, 231.38, 6.79,   0.00, 0.00, 56.00);
	CreateDynamicObject(10184, 1223.12, 231.38, 11.71,   0.00, 180.00, 236.00);
	CreateDynamicObject(669, 1306.32, -60.30, 35.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1318.51, -49.79, 34.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1338.05, -33.37, 34.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1379.44, 2.95, 32.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1402.71, 22.31, 31.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1434.29, 52.05, 30.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1483.56, 89.87, 29.16,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1456.38, 46.10, 30.17,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1424.25, 18.67, 31.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1399.73, -2.88, 32.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1364.24, -33.67, 33.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1343.66, -55.44, 34.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1316.44, -75.90, 35.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1271.98, -112.36, 36.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 1244.40, -113.54, 37.72,   0.00, 0.00, 0.00);
	CreateDynamicObject(18761, 1226.40, -137.38, 43.40,   0.00, 0.00, 134.00);
	CreateDynamicObject(18761, 1226.40, -137.38, 43.40,   0.00, 0.00, 313.99);
	CreateDynamicObject(18761, 1320.44, -62.22, 39.88,   0.00, 0.00, 313.99);
	CreateDynamicObject(18761, 1354.95, -31.27, 38.45,   0.00, 0.00, 313.99);
	CreateDynamicObject(18761, 1391.80, 0.61, 37.06,   0.00, 0.00, 313.99);
	CreateDynamicObject(18761, 1436.18, 39.35, 35.51,   0.00, 0.00, 313.99);
	CreateDynamicObject(18761, 1486.13, 78.78, 34.11,   0.00, 0.00, 301.99);
	CreateDynamicObject(18761, 1551.99, 117.45, 33.37,   0.00, 0.00, 293.99);
	CreateDynamicObject(18761, 1559.38, 12.56, 28.09,   0.00, 0.00, 15.98);
	CreateDynamicObject(18761, 1559.38, 12.56, 28.09,   0.00, 0.00, 195.98);
	CreateDynamicObject(18761, 1486.13, 78.78, 34.11,   0.00, 0.00, 121.99);
	CreateDynamicObject(18761, 1551.99, 117.45, 33.37,   0.00, 0.00, 113.98);
	CreateDynamicObject(18761, 1436.18, 39.35, 35.51,   0.00, 0.00, 133.99);
	CreateDynamicObject(18761, 1391.80, 0.61, 37.06,   0.00, 0.00, 133.99);
	CreateDynamicObject(18761, 1354.94, -31.27, 38.45,   0.00, 0.00, 133.99);
	CreateDynamicObject(18761, 1320.44, -62.22, 39.88,   0.00, 0.00, 133.99);
	CreateDynamicObject(18761, 1531.96, 95.70, 33.58,   0.00, 0.00, 27.99);
	CreateDynamicObject(18761, 1292.25, -67.06, 39.62,   0.00, 0.00, 39.99);
	CreateDynamicObject(18761, 1439.32, -38.01, 35.07,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1439.31, -38.01, 35.07,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1292.25, -67.06, 39.62,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1531.96, 95.70, 33.58,   0.00, 0.00, 207.99);
	CreateDynamicObject(18761, 1425.16, -49.90, 35.07,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1411.03, -61.80, 35.07,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1396.86, -73.69, 35.07,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1453.53, -26.16, 35.07,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1453.53, -26.16, 35.07,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1425.16, -49.90, 35.07,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1411.03, -61.80, 35.07,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1396.86, -73.69, 35.07,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1466.69, -54.12, 30.36,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1452.48, -66.05, 30.36,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1438.75, -78.06, 29.91,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1424.55, -89.94, 29.91,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1410.12, -101.83, 29.91,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1395.80, -113.80, 30.36,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1381.27, -125.94, 30.36,   0.00, 0.00, 39.98);
	CreateDynamicObject(18761, 1381.27, -125.94, 30.36,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1410.12, -101.83, 29.91,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1424.55, -89.94, 29.91,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1438.75, -78.06, 29.91,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1452.48, -66.05, 30.36,   0.00, 0.00, 219.98);
	CreateDynamicObject(18761, 1466.69, -54.12, 30.36,   0.00, 0.00, 219.98);
	CreateDynamicObject(18766, 1462.95, 11.69, 32.57,   0.00, 0.00, 130.00);
	CreateDynamicObject(18766, 1469.37, 4.04, 32.57,   0.00, 0.00, 130.00);
	CreateDynamicObject(18766, 1474.49, -2.04, 32.57,   0.00, 0.00, 130.00);
	CreateDynamicObject(7922, 1476.79, -6.26, 31.46,   0.00, 0.00, 220.00);
	CreateDynamicObject(7922, 1476.79, -6.26, 34.26,   0.00, 0.00, 219.99);
	CreateDynamicObject(18766, 1454.48, 13.32, 32.57,   0.00, 0.00, 40.00);
	CreateDynamicObject(18766, 1446.83, 6.90, 32.57,   0.00, 0.00, 40.00);
	CreateDynamicObject(18766, 1473.59, -9.59, 32.57,   0.00, 0.00, 40.00);
	CreateDynamicObject(18766, 1465.94, -16.00, 32.57,   0.00, 0.00, 40.00);
	CreateDynamicObject(18762, 1442.62, 3.37, 32.57,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1441.86, 2.73, 32.57,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1461.73, -19.53, 32.57,   0.00, 0.00, 310.00);
	CreateDynamicObject(18762, 1460.97, -20.17, 32.57,   0.00, 0.00, 310.00);
	CreateDynamicObject(1584, 1461.39, 3.45, 30.07,   0.00, 0.00, 130.00);
	CreateDynamicObject(1584, 1464.68, -5.34, 30.07,   0.00, 0.00, 130.00);
	CreateDynamicObject(1583, 1457.53, 9.59, 30.07,   0.00, 0.00, 140.00);
	CreateDynamicObject(1583, 1471.35, -8.48, 30.07,   0.00, 0.00, 112.00);
	CreateDynamicObject(8673, 1450.05, -4.34, 32.69,   90.00, 0.00, 310.00);
	CreateDynamicObject(8673, 1452.30, -2.46, 32.69,   90.00, 0.00, 310.00);
	CreateDynamicObject(8673, 1454.54, -0.59, 32.69,   90.00, 0.00, 310.00);
	CreateDynamicObject(8673, 1456.78, 1.25, 32.69,   90.00, 0.00, 310.00);
	CreateDynamicObject(8673, 1459.02, 3.14, 32.69,   90.00, 0.00, 310.00);
	CreateDynamicObject(8673, 1461.26, 5.02, 32.69,   90.00, 0.00, 310.00);
	CreateDynamicObject(8673, 1463.50, 6.90, 32.69,   90.00, 0.00, 310.00);
	CreateDynamicObject(8673, 1464.63, 7.84, 32.69,   90.00, 0.00, 310.00);
	CreateDynamicObject(8673, 1464.25, -7.36, 32.69,   90.00, 0.00, 40.00);
	CreateDynamicObject(8673, 1466.15, -9.62, 32.69,   90.00, 0.00, 40.00);
	CreateDynamicObject(8673, 1468.02, -11.84, 32.69,   90.00, 0.00, 40.00);
	CreateDynamicObject(8673, 1470.81, 0.44, 32.69,   90.00, 0.00, 310.00);
	CreateDynamicObject(1584, 1443.49, -3.03, 32.44,   0.00, 0.00, 130.00);
	CreateDynamicObject(1583, 1449.79, -10.56, 32.54,   0.00, 0.00, 130.00);
	CreateDynamicObject(1584, 1457.39, -19.68, 32.53,   0.00, 0.00, 130.00);
	CreateDynamicObject(7016, 1522.61, -92.32, 17.84,   0.00, 0.00, 130.00);
	CreateDynamicObject(7016, 1461.30, -143.75, 17.84,   0.00, 0.00, 130.00);
	CreateDynamicObject(7016, 1535.50, -38.15, 17.84,   0.00, 0.00, 40.00);
	CreateDynamicObject(7016, 1390.01, -148.38, 17.84,   0.00, 0.00, 40.00);
	CreateDynamicObject(2357, 1318.89, 35.23, 32.50,   0.00, 0.00, 278.25);
	CreateDynamicObject(1671, 1317.69, 33.40, 32.57,   0.00, 0.00, 100.00);
	CreateDynamicObject(1671, 1317.51, 35.10, 32.57,   0.00, 0.00, 96.00);
	CreateDynamicObject(1671, 1317.31, 36.61, 32.57,   0.00, 0.00, 97.99);
	CreateDynamicObject(2894, 1319.01, 33.82, 32.91,   0.00, 0.00, 286.00);
	CreateDynamicObject(2894, 1318.85, 35.29, 32.91,   0.00, 0.00, 274.00);
	CreateDynamicObject(2894, 1318.69, 36.65, 32.91,   0.00, 0.00, 279.99);
	CreateDynamicObject(1237, 731.98, -163.80, 18.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 534.57, -148.39, 36.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 534.67, -144.12, 36.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 534.88, -140.34, 36.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 535.50, -136.91, 36.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 536.11, -133.50, 36.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 539.45, -149.92, 36.64,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 544.95, -151.15, 36.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 541.59, -134.29, 36.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 547.80, -135.23, 36.06,   0.00, 0.00, 0.00);
	CreateDynamicObject(1228, 537.44, -147.54, 37.17,   0.00, 0.00, 40.00);
	CreateDynamicObject(1228, 538.90, -136.40, 37.09,   0.00, 0.00, 314.00);
	CreateDynamicObject(1228, 537.18, -144.29, 37.17,   0.00, 0.00, 347.99);
	CreateDynamicObject(1228, 537.85, -140.12, 37.15,   0.00, 0.00, 353.99);
	CreateDynamicObject(1228, 547.45, -148.08, 36.40,   0.00, 0.00, 353.99);
	CreateDynamicObject(1228, 547.80, -144.94, 36.30,   0.00, 0.00, 353.99);
	CreateDynamicObject(1228, 548.45, -140.76, 36.28,   0.00, 0.00, 349.99);
	CreateDynamicObject(1228, 549.06, -138.42, 36.27,   0.00, 0.00, 349.99);
	CreateDynamicObject(7191, 1394.13, -122.30, 23.34,   0.00, 0.00, 40.00);
	CreateDynamicObject(7191, 1361.24, -150.05, 23.34,   0.00, 0.00, 38.49);
	CreateDynamicObject(7191, 1391.87, -153.68, 23.74,   0.00, 0.00, 310.00);
	CreateDynamicObject(7191, 1391.87, -153.68, 19.78,   0.00, 0.00, 310.00);
	CreateDynamicObject(7191, 1361.24, -150.05, 19.38,   0.00, 0.00, 38.49);
	CreateDynamicObject(1557, 1404.55, -134.61, 22.33,   0.00, 0.00, 130.25);
	CreateDynamicObject(3113, 1380.86, -124.16, 21.74,   0.00, 285.25, 129.25);
	CreateDynamicObject(3113, 1365.11, -136.91, 21.71,   0.00, 285.25, 128.99);
	CreateDynamicObject(6462, 1413.47, -119.06, 24.23,   0.00, 0.00, 130.00);
	CreateDynamicObject(2773, 1406.15, -127.15, 22.84,   0.00, 0.00, 37.99);
	CreateDynamicObject(2773, 1407.67, -129.21, 22.84,   0.00, 0.00, 37.99);
	CreateDynamicObject(2773, 1408.80, -131.04, 22.84,   0.00, 0.00, 7.99);
	CreateDynamicObject(2773, 1404.45, -131.73, 22.89,   0.00, 0.00, 309.98);
	CreateDynamicObject(2773, 1404.99, -129.72, 22.86,   0.00, 0.00, 13.98);
	CreateDynamicObject(2773, 1403.89, -127.64, 22.89,   0.00, 0.00, 39.97);
	CreateDynamicObject(2773, 1402.73, -125.33, 22.89,   0.00, 0.00, 5.97);
	CreateDynamicObject(2773, 1403.85, -122.75, 22.89,   0.00, 0.00, 311.97);
	CreateDynamicObject(2773, 1406.37, -134.07, 22.89,   0.00, 0.00, 307.98);
	CreateDynamicObject(3113, 1383.54, -127.33, 24.56,   0.00, 285.25, 129.25);
	CreateDynamicObject(3113, 1367.79, -140.20, 24.54,   0.00, 285.25, 129.24);
	CreateDynamicObject(3113, 1381.47, -157.15, 24.54,   0.00, 285.25, 309.99);
	CreateDynamicObject(3113, 1397.39, -143.70, 24.49,   0.00, 285.25, 309.99);
	CreateDynamicObject(1383, 1403.50, -141.35, 29.90,   0.00, 330.00, 40.00);
	CreateDynamicObject(1383, 1377.74, -162.79, 29.90,   0.00, 330.00, 219.75);
	CreateDynamicObject(1383, 1387.96, -123.06, 29.90,   0.00, 330.00, 40.00);
	CreateDynamicObject(1383, 1362.51, -144.33, 29.90,   0.00, 330.00, 219.74);
	CreateDynamicObject(1395, 1534.18, -69.67, 50.83,   0.00, 0.00, 309.00);
	CreateDynamicObject(3502, 1387.04, -147.79, 57.13,   0.00, 0.00, 40.00);
	CreateDynamicObject(3502, 1382.96, -143.02, 57.13,   0.00, 0.00, 40.00);
	CreateDynamicObject(3502, 1378.47, -137.72, 57.13,   0.00, 0.00, 40.00);
	CreateDynamicObject(4100, 1531.97, -50.64, 29.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1521.44, -59.44, 29.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1511.35, -67.85, 29.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1509.06, -22.98, 29.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1503.86, -27.32, 29.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1532.96, -40.69, 29.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(4100, 1526.37, -32.83, 29.61,   0.00, 0.00, 269.99);
	CreateDynamicObject(4100, 1519.06, -24.10, 29.61,   0.00, 0.00, 269.99);
	CreateDynamicObject(4100, 1487.90, -50.44, 29.61,   0.00, 0.00, 269.99);
	CreateDynamicObject(4100, 1494.49, -58.31, 29.61,   0.00, 0.00, 269.99);
	CreateDynamicObject(4100, 1501.69, -66.90, 29.61,   0.00, 0.00, 269.99);
	CreateDynamicObject(997, 1412.20, -137.21, 22.22,   0.00, 0.00, 219.49);
	CreateDynamicObject(16564, 1487.59, 35.37, 29.10,   0.00, 0.00, 39.75);
	CreateDynamicObject(6300, 1466.93, 42.16, 21.07,   0.00, 0.00, 40.00);
	CreateDynamicObject(4100, 1480.26, 3.86, 30.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1490.85, 12.69, 30.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(1536, 1487.92, 21.73, 29.12,   0.00, 0.00, 310.00);
	CreateDynamicObject(1536, 1489.87, 19.45, 29.12,   0.00, 0.00, 129.50);
	CreateDynamicObject(985, 1487.41, -41.46, 28.95,   0.00, 179.99, 219.50);
	CreateDynamicObject(8674, 1590.02, -197.65, 25.36,   330.01, 357.68, 20.82);
	CreateDynamicObject(3502, 1534.21, -69.63, 98.71,   89.75, 90.00, 303.74);
	CreateDynamicObject(3502, 1534.21, -69.63, 89.64,   89.75, 90.00, 303.74);
	CreateDynamicObject(3502, 1534.21, -69.63, 80.51,   89.75, 90.00, 303.74);
	CreateDynamicObject(3502, 1534.21, -69.63, 71.46,   89.75, 90.00, 303.74);
	CreateDynamicObject(3502, 1534.21, -69.63, 62.34,   89.75, 90.00, 303.74);
	CreateDynamicObject(3502, 1534.21, -69.63, 53.21,   89.75, 90.00, 303.74);
	CreateDynamicObject(3502, 1534.21, -69.63, 44.14,   89.75, 90.00, 303.74);
	CreateDynamicObject(3502, 1534.21, -69.63, 35.11,   89.75, 90.00, 303.74);
	CreateDynamicObject(3502, 1534.21, -69.63, 26.11,   89.75, 90.00, 303.74);
	CreateDynamicObject(2639, 1531.94, -69.46, 22.97,   0.00, 0.00, 83.25);
	CreateDynamicObject(2639, 1533.98, -71.92, 22.98,   0.00, 0.00, 174.25);
	CreateDynamicObject(2639, 1536.47, -69.87, 22.98,   0.00, 0.00, 263.75);
	CreateDynamicObject(2639, 1534.37, -67.40, 22.98,   0.00, 0.00, 355.74);
	CreateDynamicObject(11431, 1533.10, -81.42, 23.66,   0.00, 0.00, 39.00);
	CreateDynamicObject(2773, 1524.44, -77.91, 22.73,   0.00, 0.00, 307.99);
	CreateDynamicObject(1395, 1534.18, -69.67, 71.28,   0.00, 180.00, 129.00);
	CreateDynamicObject(3095, 1534.11, -69.73, 103.88,   0.00, 180.00, 219.25);
	CreateDynamicObject(17027, 1435.81, 76.34, 23.68,   320.48, 336.38, 174.45);
	CreateDynamicObject(17027, 1445.26, 80.92, 23.68,   320.48, 336.38, 174.45);
	CreateDynamicObject(17027, 1452.26, 85.02, 23.68,   320.48, 336.38, 174.45);
	CreateDynamicObject(18783, 1506.68, 38.16, 18.89,   0.00, 90.00, 40.00);
	CreateDynamicObject(18783, 1493.82, 53.48, 18.89,   0.00, 90.00, 40.00);
	CreateDynamicObject(18783, 1505.73, 27.56, 18.89,   0.00, 90.00, 310.00);
	CreateDynamicObject(18783, 1490.44, 14.73, 18.89,   0.00, 90.00, 310.00);
	CreateDynamicObject(18783, 1475.13, 1.89, 18.89,   0.00, 90.00, 310.00);
	CreateDynamicObject(18783, 1463.93, 2.32, 18.89,   0.00, 90.00, 220.00);
	CreateDynamicObject(18783, 1451.21, 17.59, 18.89,   0.00, 90.00, 219.99);
	CreateDynamicObject(18783, 1474.50, 1.43, 18.89,   0.00, 90.00, 309.99);
}

public OnObjectMoved(objectid)
{
	if(objectid == gFerrisWheel)
	{
	    SetTimer("RotateWheel",3*1000,0);
	}
	else if(objectid == pirateship[0])
	{
	    if(IsObjectMoving(pirateship[0])) StopObject(pirateship[0]);
	    if(piratestep[3] == 2)
	    {
	    	piratestep[6] = 0; piratestep[5] = 0; piratestep[4] = 0; piratestep[3] = 0; piratestep[2] = 0; piratestep[1] = 0;
	    	for(new i;i<MAX_PLAYERS;i++)
	    	{
	    	    if(IsPlayerConnected(i) && GetPVarType(i, "pPirate"))
	    	    {
		    		DeletePVar(i, "pPirate");
			    	new Float:rand=random(5);
			    	SetPlayerPos(i, 1427.0665+rand,-129.3872+rand,23.2147);
			    	SetPlayerHealth(i, GetPVarFloat(i, "pOldHealth"));
	    			DeletePVar(i, "pOldHealth");
				}
			}
		}
		else
		{
		    new Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ;
		    GetObjectPos(pirateship[0], X, Y, Z); GetObjectRot(pirateship[0], RX, RY, RZ);
		    if(piratestep[1] == 0)
		    {
			    if(RY < 0.0) MoveObject(pirateship[0], X, Y, Z+0.1, 0.1, 0.0, RY-3.0, 40.0);
			    else MoveObject(pirateship[0], X, Y, Z-0.1, 0.1, 0.0, RY+3.0, 40.0);
			    piratestep[1] = 1;
			}
			else
			{
	  			if(RY < 0.0) MoveObject(pirateship[0], X, Y, Z+0.1, 0.01, 0.0, 0.0, 40.0);
	  			else MoveObject(pirateship[0], X, Y, Z-0.1, 0.01, 0.0, 0.0, 40.0);
	      		piratestep[1] = 0;
		    	SetTimer("MovePirateShip", 1000, false);
			}
		}
	}
	return 1;
}

forward MovePirateShip();
public MovePirateShip()
{
	if(IsObjectMoving(pirateship[0])) StopObject(pirateship[0]);
	new Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ;
 	GetObjectPos(pirateship[0], X, Y, Z); GetObjectRot(pirateship[0], RX, RY, RZ);

	if(piratestep[2] == 0)
	{
		MoveObject(pirateship[0], X, Y, Z+0.1, 0.1-(piratestep[0]*0.01), 0.0, 0.0-(10.0*piratestep[0]), 40.0);
		piratestep[2] = 1;
	}
	else
	{
		MoveObject(pirateship[0], X, Y, Z-0.1, 0.1-(piratestep[0]*0.01), 0.0, 0.0+(10.0*piratestep[0]), 40.0);
		piratestep[2] = 0;
	}
	
	if(piratestep[0] >= 6) piratestep[3] = 1;
	
	if(piratestep[4] == 3)
	{
		if(piratestep[3] == 0) piratestep[0]++;
		else
		{
			if(piratestep[6] > 0) piratestep[0]--;
		}
		piratestep[4] = 0;
	}
	else piratestep[4]++;

	if(piratestep[0] < 0 && piratestep[3] == 1)
	{
	    MoveObject(pirateship[0], 1382.96, -143.02, 57.13, 0.1, 0.0, 0.0, 40.0);
	    piratestep[3] = 2;
	}
}

forward RotateWheel();
public RotateWheel()
{
    UpdateWheelTarget();

    new Float:fModifyWheelZPos = 0.0;
    if(gWheelTransAlternate) fModifyWheelZPos = 0.05;

    MoveObject( gFerrisWheel, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2]+fModifyWheelZPos,
				0.01, 0.0, gCurrentTargetYAngle, 218.0 );
}

stock UpdateWheelTarget()
{
    gCurrentTargetYAngle += 36.0; // There are 10 carts, so 360 / 10
    if(gCurrentTargetYAngle >= 360.0) {
		gCurrentTargetYAngle = 0.0;
    }
	if(gWheelTransAlternate) gWheelTransAlternate = 0;
	else gWheelTransAlternate = 1;
}

public OnFilterScriptExit()
{
	for(new x;x<sizeof(gocarts);x++)
	{
	    if(GetVehicleModel(gocarts[x])) DestroyVehicle(gocarts[x]);
	}
	DestroyObject(gFerrisWheel);
	DestroyObject(gFerrisBase);
	DestroyObject(pirateship[0]); DestroyObject(pirateship[1]);
 	for(new x;x<10;x++)
    {
        DestroyObject(gFerrisCages[x]);
	}
}

stock GetPlayerNameEx(playerid) {

	new
		sz_playerName[MAX_PLAYER_NAME],
		i_pos;

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	while ((i_pos = strfind(sz_playerName, "_", false, i_pos)) != -1) sz_playerName[i_pos] = ' ';
	return sz_playerName;
}
