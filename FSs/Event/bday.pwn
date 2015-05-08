#include <a_samp>
#include <sscanf2>
#include <streamer>
#include <zcmd>

#undef MAX_PLAYERS
#define MAX_PLAYERS (700)

new musicarea;
new startcount = 3,
	kartlaps = 6;

enum posenum
{
	Float:posx,
	Float:posy,
	Float:posz,
	Float:rot
}

new Float:gFerrisOrigin[4] = {592.7563, -2110.7573, 19.1848, 90.0};
new gFerrisWheel, gFerrisBase;
new gFerrisCages[10];
new Float:gCurrentTargetYAngle = 0.0;
new gWheelTransAlternate = 0;

new Text3D:karttext;
enum krace
{
	count,//Racer Count
	status,// 0 = Waiting for more players | 1 = Starting | 2 = Active/In Progress
	starting,//Countdown for race to start
	left,//Time left till race ends
	place//Used to determine place within race.
}
new kartraceinfo[krace];
new Float:gKartOrigin[3] = {630.558898, -1954.361938, 2.103125};
new kartspawns[20][posenum] = {
{-1408.9274, -256.9805, 1042.9756, -12.0000},
{-1407.3546, -257.3370, 1042.9756, -12.0000},
{-1405.7192, -257.7513, 1042.9756, -12.0000},
{-1404.1395, -258.1555, 1042.9756, -12.0000},
{-1402.5757, -258.5850, 1042.9756, -12.0000},
{-1400.7500, -259.1611, 1042.9756, -12.0000},
{-1409.5157, -259.6704, 1042.9469, 347.7900},
{-1407.9257, -260.0362, 1042.9420, 347.9987},
{-1406.2892, -260.4301, 1042.9402, 348.0003},
{-1404.7195, -260.7973, 1042.9401, 347.7173},
{-1403.1281, -261.1814, 1042.9401, 348.0005},
{-1401.2646, -261.5770, 1042.9401, 348.0003},
{-1408.3922, -262.2319, 1042.9401, 347.9778},
{-1409.9801, -261.8108, 1042.9452, 347.9067},
{-1406.7289, -262.5020, 1042.9402, 348.0008},
{-1405.1556, -262.8064, 1042.9401, 347.7223},
{-1403.6023, -263.4142, 1042.9401, 348.0040},
{-1401.7275, -263.7579, 1042.9399, 348.0006},
{-1408.7980, -264.1048, 1042.9401, 348.0253},
{-1404.0042, -265.3026, 1042.9399, 348.0053}
};
new kartcheckpoints[8][posenum] = {
{-1397.205810, -214.877273, 1043.112792},
{-1439.78906, -130.596008, 1045.408325},
{-1530.023071, -191.30276, 1050.58276},
{-1417.048583, -276.298309, 1050.758300},
{-1382.499755, -140.864669, 1050.701904},
{-1268.074951, -180.060577, 1050.245849},
{-1359.534912, -283.226837, 1045.215942},
{-1397.205322, -214.870254, 1043.112792}
};

new bumpercars;
new Float:gBumperOrigin[3] = {705.361083, -1958.251831, 2.103125};
new bumperspawns[6][posenum] = {
{722.6320, -1961.7069, 0.4044, 91.2988},
{687.9482, -1961.6224, 0.4857, 271.2970},
{687.3447, -1997.3239, 0.4351, 270.8343},
{723.4386, -1997.6876, 0.3873, 87.2896},
{705.4752, -1976.1241, 0.4615, 87.7215},
{705.1586, -1982.2360, 0.3112, 270.5194}
};

public OnFilterScriptInit()
{
	musicarea = CreateDynamicSphere(592.84, -2085, 0, 330.0);
    SetTimer("KartUpdateGlobal", 1000, true);
	CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/bumpercars {FFFF00}to join in!", 0xFFFFFFF, 705.361083, -1958.251831, 2.103125, 10.0);
	karttext = CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/joinkart {FFFF00}to join in!", 0xFFFFFFF, gKartOrigin[0], gKartOrigin[1], gKartOrigin[2], 15.0);
	CreateBDayObjects();
	
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
	gFerrisWheel = CreateObject(18877, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2], 0.0, 0.0, gFerrisOrigin[3], 300.0);
	gFerrisBase = CreateObject(18878, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2], 0.0, 0.0, gFerrisOrigin[3], 300.0);
	for(new x;x<10;x++)
	{
		gFerrisCages[x] = CreateObject(19316, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2], 0.0, 0.0, gFerrisOrigin[3], 300.0);
		AttachObjectToObject(gFerrisCages[x], gFerrisWheel, gFerrisCageOffsets[x][0], gFerrisCageOffsets[x][1], gFerrisCageOffsets[x][2], 0.0, 0.0, gFerrisOrigin[3], 0);
	}
	SetTimer("RotateWheel",3*1000,0);
}

public OnFilterScriptExit()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(GetPVarType(i, "pBumperCar"))
		{
			LeaveBumper(i);
		}
		if(GetPVarType(i, "pKartCar"))
		{
			LeaveKart(i);
		}
	}
	DestroyObject(gFerrisWheel);
	DestroyObject(gFerrisBase);
	for(new x;x<10;x++)
	{
		DestroyObject(gFerrisCages[x]);
	}
}

public OnPlayerDisconnect(playerid, reason)
{
	if(GetPVarType(playerid, "pBumperCar"))
	{
		LeaveBumper(playerid);
	}
	if(GetPVarType(playerid, "pKartCar"))
	{
		LeaveKart(playerid);
	}
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == musicarea)
	{
		StopAudioStreamForPlayer(playerid);
		PlayAudioStreamForPlayer(playerid, "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1", 592.84, -2085, 0, 400, 1);
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

public OnPlayerEnterCheckpoint(playerid)
{
	if(GetPVarType(playerid, "pKartCar"))
	{
		new checkpoint = GetPVarInt(playerid, "pKartCheckpoint"), string[128];
		if(!IsPlayerInRangeOfPoint(playerid, 10.0, kartcheckpoints[checkpoint][posx], kartcheckpoints[checkpoint][posy], kartcheckpoints[checkpoint][posz])) return 1;
		if(checkpoint == (sizeof(kartcheckpoints)-1))
		{
			SetPlayerCheckpoint(playerid, kartcheckpoints[0][posx], kartcheckpoints[0][posy], kartcheckpoints[0][posz], 5.0);
			SetPVarInt(playerid, "pKartCheckpoint", 0);
			SetPVarInt(playerid, "pKartLap", GetPVarInt(playerid, "pKartLap")+1);
		    if(GetPVarInt(playerid, "pKartLap") == kartlaps-1) GameTextForPlayer(playerid, "~r~Final Lap!", 1100, 3);
			if(GetPVarInt(playerid, "pKartLap") == kartlaps)
			{
				kartraceinfo[place]++;
				if(kartraceinfo[place] > 3)
				{
				    format(string, sizeof(string), "You came in %dth place, better luck next time!", kartraceinfo[place]);
					SendClientMessage(playerid, -1, string);
				}
				if(kartraceinfo[place] < 4)
				{
					for(new x; x < MAX_PLAYERS; x++)
					{
						if(IsPlayerConnected(x) && (GetPVarInt(x, "pKartCar") || IsPlayerInRangeOfPoint(x, 15.0, gKartOrigin[0], gKartOrigin[1], gKartOrigin[2])))
						{
							format(string, sizeof(string), "** [KARTRACE] %s has come in", GetPlayerNameEx(playerid), kartraceinfo[place]);
							if(kartraceinfo[place] == 1) strcat(string, " 1st place!");
							if(kartraceinfo[place] == 2) strcat(string, " 2nd place!");
							if(kartraceinfo[place] == 3) strcat(string, " 3rd place!");
							SendClientMessage(x, -1, string);
						}
					}
				}
				//SetPVarInt(playerid, "kartCooldown", gettime()+60);
				LeaveKart(playerid);
			}
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
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if(GetPVarType(playerid, "pBumperCar") || GetPVarType(playerid, "pKartCar"))
		{
			SetPVarInt(playerid, "TeleportWarnings", -1);
		}
	}
	if(newstate == PLAYER_STATE_ONFOOT)
	{
		if(GetPVarType(playerid, "pBumperCar"))
		{
			LeaveBumper(playerid);
		}
		if(GetPVarType(playerid, "pKartCar"))
		{
			LeaveKart(playerid);
		}
	}
	return 1;
}

//Bumper
CMD:bumpercars(playerid, params[])
{
	if(GetPVarType(playerid, "pBumperCar")) return LeaveBumper(playerid);
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, gBumperOrigin[0], gBumperOrigin[1], gBumperOrigin[2])) return SendClientMessage(playerid, 0xFFFFFFFF, "You are not near the bumper cars area!");
	if(bumpercars > 15) return SendClientMessage(playerid, 0xFFFFFFFF, "The arena is full, please wait your turn!");
	
	new rand=random(sizeof(bumperspawns));
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
		SetPlayerPos(playerid, gBumperOrigin[0], gBumperOrigin[1], gBumperOrigin[2]);
		SendClientMessage(playerid, 0xFFFFFFFF, "Too damaged to continue, thanks for playing!");
		if(bumpercars > 0) bumpercars--;
	}
	else
	{
		SetPVarInt(playerid, "pBumperTimer", SetTimerEx("BumperCars", 1000, false, "i", playerid));
	}
}

LeaveBumper(playerid)
{
	if(GetPVarType(playerid, "pBumperCar"))
	{
		new veh = GetPVarInt(playerid, "pBumperCar");
		if(GetVehicleModel(veh)) DestroyVehicle(veh);
		DeletePVar(playerid, "pBumperCar");
		KillTimer(GetPVarInt(playerid, "pBumperTimer"));
		DeletePVar(playerid, "pBumperTimer");
		if(bumpercars > 0) bumpercars--;
		CallRemoteFunction("Player_StreamPrep", "ifffi", playerid, gBumperOrigin[0], gBumperOrigin[1], gBumperOrigin[2], 2000);
		SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
	}
	return 1;
}
//Bumper

//Kart
CMD:kartlaps(playerid, params[])
{
	if(GetPVarInt(playerid, "aLvl") < 1337) return 1;
	new laps, string[22];
	if(sscanf(params, "d", laps)) return SendClientMessage(playerid, -1, "USAGE: /kartlaps [laps]");
	kartlaps = laps;
	format(string, sizeof(string), "Kart Laps set to: %d", kartlaps);
	SendClientMessage(playerid, -1, string);
	return 1;
}

CMD:startcount(playerid, params[])
{
	if(GetPVarInt(playerid, "aLvl") < 1337) return 1;
	new countt, string[22];
	if(sscanf(params, "d", countt)) return SendClientMessage(playerid, -1, "USAGE: /startcount [count]");
	startcount = countt;
	format(string, sizeof(string), "Kart Count set to: %d", startcount);
	SendClientMessage(playerid, -1, string);
	return 1;
}

CMD:joinkart(playerid, params[])
{
	if(GetPVarType(playerid, "pKartCar")) return LeaveKart(playerid);
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, gKartOrigin[0], gKartOrigin[1], gKartOrigin[2])) return SendClientMessage(playerid, 0xFFFFFFFF, "You are not near the Kart entrance!");
	if(kartraceinfo[status] == 2) return SendClientMessage(playerid, 0xFFFFFFFF, "The race has already started");
	if(kartraceinfo[count] == 20) return SendClientMessage(playerid, 0xFFFFFFFF, "The race is full, try again next time!");
	if(gettime() < GetPVarInt(playerid, "kartCooldown"))
	{
		new str[53];
		format(str, sizeof(str), "Please wait %d seconds before joining another race!", GetPVarInt(playerid, "kartCooldown")-gettime());
		return SendClientMessage(playerid, -1, str);
	}
	
	new engine,lights,alarm,doors,bonnet,boot,objective;
	SetPVarInt(playerid, "pKartCar", CreateVehicle(571, kartspawns[kartraceinfo[count]][posx], kartspawns[kartraceinfo[count]][posy], kartspawns[kartraceinfo[count]][posz], kartspawns[kartraceinfo[count]][rot], random(10), random(10), 15));
	new veh = GetPVarInt(playerid, "pKartCar");
	GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
	SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights,alarm,VEHICLE_PARAMS_ON,bonnet,boot,objective);
	LinkVehicleToInterior(veh, 7);
	SetVehicleVirtualWorld(veh, 7);

	SetPVarInt(playerid, "pSkin", GetPlayerSkin(playerid));
	SetPlayerSkin(playerid, 22);
	SetPlayerVirtualWorld(playerid, 7);
	SetPlayerInterior(playerid, 7);
	PutPlayerInVehicle(playerid, veh, 0);
	TogglePlayerControllable(playerid, 0);
    
	SetTimerEx("KartUpdate", 1000, false, "i", playerid);
	kartraceinfo[count]++;
	UpdateKartLabel();
	SendClientMessage(playerid, 0xFFFFFFFF, "Type /joinkart again to leave the race");
	return 1;
}

LeaveKart(playerid)
{
	if(GetPVarType(playerid, "pKartCar"))
	{
		new veh = GetPVarInt(playerid, "pKartCar");
		if(GetVehicleModel(veh)) DestroyVehicle(veh);
		DeletePVar(playerid, "pKartCar");
		DeletePVar(playerid, "pKartCheckpoint");
		DeletePVar(playerid, "pKartLap");
		CallRemoteFunction("Player_StreamPrep", "ifffi", playerid, gKartOrigin[0], gKartOrigin[1], gKartOrigin[2]+3, 2500);
		if(kartraceinfo[count] > 0) kartraceinfo[count]--;
		UpdateKartLabel();
		TogglePlayerControllable(playerid, 1);
		DisablePlayerCheckpoint(playerid);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerSkin(playerid, GetPVarInt(playerid, "pSkin"));
		DeletePVar(playerid, "pSkin");
		SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
	}
	return 1;
}

stock UpdateKartLabel()
{
	new string[256];
	if(kartraceinfo[status] == 2) format(string, sizeof(string), "{FFFF00}Race in progress!\nRacers: {FF0000}%d\nTime left: %d seconds", kartraceinfo[count], kartraceinfo[left]-gettime());
	else format(string, sizeof(string), "{FFFF00}Type {FF0000}/joinkart {FFFF00}to join in!\nRacers: {FF0000}%d", kartraceinfo[count]);
	UpdateDynamic3DTextLabelText(karttext, 0xFFFFFFFF, string);
}

forward KartUpdate(playerid);
public KartUpdate(playerid)
{
	if(GetPVarType(playerid, "pKartCar"))
	{
		if(kartraceinfo[status] == 0)
		{
			GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Waiting for more racers..", 1100, 3);
		}
		else if(kartraceinfo[status] == 1)
		{
			new string[64];
			format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Race starting in %d seconds", kartraceinfo[starting]);
			if(kartraceinfo[starting] <= 3)
			{
			    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
			}
			GameTextForPlayer(playerid, string, 1100, 3);
		}
		else if(kartraceinfo[status] == 2)
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
	if(kartraceinfo[status] == 1)
	{
		if(--kartraceinfo[starting] <= 0)
		{
			kartraceinfo[status] = 2;
			kartraceinfo[left] = gettime()+240;
			for(new x; x < MAX_PLAYERS; x++)
			{
				if(IsPlayerConnected(x) && GetPVarType(x, "pKartCar"))
				{
					new engine,lights,alarm,doors,bonnet,boot,objective;
					new veh=GetPVarInt(x, "pKartCar");
					GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
					GameTextForPlayer(x, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~GO!", 2000, 3);
					PlayerPlaySound(x, 1057, 0.0, 0.0, 0.0);
					SetPlayerCheckpoint(x, kartcheckpoints[0][posx], kartcheckpoints[0][posy], kartcheckpoints[0][posz], 5.0);
					SetPVarInt(x, "pKartCheckpoint", 0);
					TogglePlayerControllable(x, 1);
				}
			}
		}
	    return 1;
	}
	else if(kartraceinfo[status] == 2)
	{
		if(kartraceinfo[left]-gettime() <= 0 || kartraceinfo[count] == 0)
		{
			for(new i; i < sizeof(kartraceinfo); i++)
			{
				kartraceinfo[krace:i] = 0;
			}
			UpdateKartLabel();
			for(new x; x < MAX_PLAYERS; x++)
			{
				if(IsPlayerConnected(x) && GetPVarType(x, "pKartCar"))
				{
					LeaveKart(x);
				}
			}
		}
		else
		{
			UpdateKartLabel();
		}
	}
	if(kartraceinfo[count] >= startcount && kartraceinfo[status] == 0)
	{
		kartraceinfo[status] = 1;
		kartraceinfo[starting] = 15;
		return 1;
	}
	if(kartraceinfo[count] < 1 && kartraceinfo[status] == 1)
	{
		kartraceinfo[status] = 0;
		return 1;
	}
	for(new i; i < MAX_PLAYERS; i++)
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
//Kart

public OnObjectMoved(objectid)
{
	if(objectid == gFerrisWheel)
	{
		SetTimer("RotateWheel",3*1000,0);
	}
}

forward RotateWheel();
public RotateWheel()
{
	UpdateWheelTarget();
	new Float:fModifyWheelZPos = 0.0;
	if(gWheelTransAlternate) fModifyWheelZPos = 0.05;
	MoveObject(gFerrisWheel, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2]+fModifyWheelZPos, 0.01, 0.0, gCurrentTargetYAngle, gFerrisOrigin[3]);
}

stock UpdateWheelTarget()
{
	gCurrentTargetYAngle += 36.0;
	if(gCurrentTargetYAngle >= 360.0) gCurrentTargetYAngle = 0.0;
	if(gWheelTransAlternate) gWheelTransAlternate = 0; else gWheelTransAlternate = 1;
}

CreateBDayObjects()
{
	CreateDynamicObject(3578, 737.58, -1792.50, 12.80,   0.00, 1.00, -13.00);
	CreateDynamicObject(10831, 630.70, -1968.90, 4.50,   0.00, 0.00, 180.25);
	CreateDynamicObject(11495, 706.10, -1924.20, 0.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(11495, 706.10, -1946.20, 0.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(11495, 704.30, -1924.20, 0.90,   0.00, 0.00, 180.00);
	CreateDynamicObject(11495, 704.30, -1946.20, 0.90,   0.00, 0.00, 179.99);
	CreateDynamicObject(3578, 700.20, -1959.30, 0.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(11495, 705.60, -1958.10, 0.90,   0.00, 0.00, 270.00);
	CreateDynamicObject(3578, 710.50, -1959.30, 0.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3499, 684.48, -1959.20, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 785.80, -1797.30, 12.40,   0.00, 0.00, 360.00);
	CreateDynamicObject(3578, 813.40, -1797.12, 12.80,   0.00, 0.00, 359.99);
	CreateDynamicObject(3578, 823.40, -1797.12, 13.40,   0.00, 0.00, 359.99);
	CreateDynamicObject(3578, 830.30, -1799.66, 13.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 837.28, -1797.12, 13.50,   0.00, 0.00, 359.99);
	CreateDynamicObject(3578, 847.40, -1798.20, 13.50,   0.00, 0.00, 347.99);
	CreateDynamicObject(3578, 942.80, -1808.00, 13.40,   0.00, 0.00, 351.99);
	CreateDynamicObject(3578, 990.80, -1841.40, 12.50,   0.00, 0.00, 76.00);
	CreateDynamicObject(3578, 986.10, -1854.70, 12.50,   0.00, 0.00, 76.00);
	CreateDynamicObject(3578, 983.50, -1864.90, 11.40,   0.00, 350.00, 76.00);
	CreateDynamicObject(3578, 981.20, -1874.50, 10.00,   0.00, 356.00, 76.75);
	CreateDynamicObject(3578, 978.90, -1883.90, 9.60,   0.00, 0.00, 76.75);
	CreateDynamicObject(3578, 976.60, -1894.00, 9.00,   0.00, 355.00, 76.75);
	CreateDynamicObject(3578, 972.70, -1903.00, 7.70,   0.00, 351.00, 56.74);
	CreateDynamicObject(3578, 965.60, -1908.30, 4.60,   0.00, 335.00, 16.74);
	CreateDynamicObject(3578, 956.70, -1911.00, 0.20,   0.00, 334.99, 16.74);
	CreateDynamicObject(3578, 651.63, -1766.54, 13.10,   0.00, 0.00, 343.99);
	CreateDynamicObject(3578, 472.55, -1733.50, 10.50,   0.00, -2.00, -4.00);
	CreateDynamicObject(3578, 458.75, -1731.68, 10.02,   0.00, -2.00, -9.00);
	CreateDynamicObject(3578, 445.57, -1730.09, 9.81,   0.00, -2.00, -6.00);
	CreateDynamicObject(3578, 435.48, -1730.25, 9.17,   0.00, -5.00, 8.00);
	CreateDynamicObject(3578, 382.60, -1741.10, 8.10,   0.00, 345.00, 357.99);
	CreateDynamicObject(3578, 362.50, -1769.00, 5.10,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 362.48, -1779.30, 5.10,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 362.48, -1789.54, 4.83,   0.00, -3.00, 90.00);
	CreateDynamicObject(3578, 362.47, -1799.83, 4.56,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 364.00, -1886.10, 1.90,   0.00, -4.00, 90.00);
	CreateDynamicObject(11495, 631.50, -1922.20, 0.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(11495, 629.70, -1922.20, 0.90,   0.00, 0.00, 180.00);
	CreateDynamicObject(11495, 629.70, -1944.20, 0.90,   0.00, 0.00, 179.99);
	CreateDynamicObject(11495, 631.50, -1944.20, 0.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(10184, 630.10, -1955.30, 3.50,   0.00, 0.00, 270.00);
	CreateDynamicObject(8674, 630.20, -1955.16, -0.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(901, 645.70, -1956.60, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(901, 618.50, -1956.70, 0.00,   0.00, 0.00, 78.00);
	CreateDynamicObject(901, 647.30, -1964.20, 0.00,   0.00, 0.00, 78.00);
	CreateDynamicObject(905, 626.50, -1948.30, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(905, 639.00, -1939.20, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(905, 618.80, -1926.80, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(901, 646.10, -1982.90, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(905, 660.70, -1982.00, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(900, 647.00, -1975.30, -3.00,   0.00, 0.00, 18.00);
	CreateDynamicObject(900, 632.80, -1984.00, -1.00,   15.00, 0.00, 358.00);
	CreateDynamicObject(905, 631.40, -1983.00, 4.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(905, 630.90, -1982.80, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(905, 631.50, -1982.70, 5.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(905, 631.00, -1982.60, 5.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(901, 620.10, -1965.60, 0.00,   0.00, 0.00, 42.00);
	CreateDynamicObject(900, 628.00, -1983.40, -1.00,   15.00, 0.00, 315.99);
	CreateDynamicObject(1497, 629.10, -1955.20, 1.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(1497, 632.11, -1955.17, 1.10,   0.00, 0.00, 180.00);
	CreateDynamicObject(12814, 511.40, -1988.40, 1.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(11495, 507.60, -1909.90, 0.40,   0.00, 0.00, 179.99);
	CreateDynamicObject(11495, 509.40, -1909.90, 0.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(11495, 507.6000, -1952.6000, 0.6500, 1.0000, 0.0000, 179.9950);
	CreateDynamicObject(11495, 507.58, -1931.90, 0.40,   0.00, 0.00, 179.99);
	CreateDynamicObject(11495, 509.40, -1931.90, 0.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(11495, 509.40, -1952.60, 0.65,   359.00, 0.00, 0.00);
	CreateDynamicObject(3578, 526.70, -1987.60, 0.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 501.50, -1963.60, 0.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 515.50, -1963.50, 0.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 496.50, -1968.50, 0.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 496.50, -1978.80, 0.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 496.50, -1989.10, 0.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 496.50, -1999.40, 0.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 496.50, -2008.50, 0.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 501.50, -2013.50, 0.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 511.80, -2013.50, 0.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 522.10, -2013.50, 0.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 526.70, -2008.20, 0.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 526.70, -1997.90, 0.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 526.70, -1977.30, 0.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 526.70, -1968.00, 0.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 522.10, -1963.60, 0.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(617, 525.68, -1966.00, 0.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(617, 497.40, -1964.70, 0.80,   0.00, 0.00, 338.00);
	CreateDynamicObject(655, 511.10, -1964.40, 1.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(655, 505.80, -1964.50, 1.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(8674, 515.50, -1963.62, 2.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(8674, 501.50, -1963.70, 2.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(8674, 521.90, -1963.60, 2.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(8674, 526.70, -1968.80, 2.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8674, 526.70, -1979.20, 2.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8674, 526.70, -1989.60, 2.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8674, 526.70, -2000.00, 2.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8674, 526.70, -2008.30, 2.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8674, 496.40, -1968.90, 2.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8674, 496.40, -1979.20, 2.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8674, 496.40, -1989.50, 2.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8674, 496.40, -1999.80, 2.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8674, 496.40, -2008.50, 2.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8674, 501.60, -2013.60, 2.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(8674, 511.90, -2013.60, 2.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(8674, 521.89, -2013.58, 2.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(658, 498.50, -2011.30, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(661, 523.00, -2010.20, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(669, 519.20, -1965.60, 0.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(671, 502.20, -1966.70, 0.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(683, 506.10, -1974.40, 0.00,   0.00, 0.00, 338.00);
	CreateDynamicObject(683, 514.70, -1971.60, -0.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(683, 523.20, -1986.30, 1.00,   0.00, 0.00, 338.00);
	CreateDynamicObject(686, 501.30, -1984.00, 1.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(687, 502.50, -2000.10, 1.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(688, 509.70, -1988.20, 0.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(698, 515.98, -2005.79, 5.21,   0.00, 0.00, 18.00);
	CreateDynamicObject(617, 519.90, -2003.20, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 592.40, -2095.16, 1.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 587.73, -2075.23, 0.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(19054, 597.50, -1901.02, 2.54,   0.00, 11.00, 22.00);
	CreateDynamicObject(19054, 511.85, -1898.48, 0.71,   -6.00, 19.00, 55.00);
	CreateDynamicObject(19129, 607.77, -2075.20, 2.63,   0.00, 0.00, 0.00);
	CreateDynamicObject(19332, 638.21, -1851.31, 39.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(19333, 479.83, -1886.54, 28.91,   0.00, 0.00, 0.00);
	CreateDynamicObject(19337, 736.53, -1869.08, 50.05,   0.00, 0.00, 0.00);
	CreateDynamicObject(19338, 495.84, -2012.09, 65.52,   0.00, 0.00, 0.00);
	CreateDynamicObject(19337, 677.49, -2053.15, 43.23,   0.00, 0.00, -4.00);
	CreateDynamicObject(19129, 587.77, -2075.20, 2.63,   0.00, 0.00, 0.00);
	CreateDynamicObject(19054, 505.11, -1899.58, 0.74,   0.00, 17.00, 0.00);
	CreateDynamicObject(19054, 547.91, -1827.12, 1.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(19054, 547.91, -1827.12, 1.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 607.72, -2075.23, 0.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 587.80, -2095.15, 0.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 607.81, -2095.15, 0.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(14537, 609.80, -2095.90, 4.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(8572, 618.67, -2068.26, 1.45,   0.00, 0.00, 90.00);
	CreateDynamicObject(8572, 577.02, -2081.87, 1.39,   0.00, 0.00, -90.00);
	CreateDynamicObject(3406, 577.10, -2075.89, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 573.87, -2070.99, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 565.11, -2071.00, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 561.18, -2065.08, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 561.18, -2056.28, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(11495, 561.20, -2034.67, 6.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 561.18, -2047.38, 2.36,   0.00, -39.00, 90.00);
	CreateDynamicObject(3406, 561.19, -2021.14, 1.69,   0.00, 39.00, 90.00);
	CreateDynamicObject(3406, 561.17, -2011.90, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 561.17, -2003.10, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 561.17, -1994.30, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 561.17, -1985.50, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 561.18, -1976.71, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 561.17, -1967.91, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 561.17, -1958.93, 2.36,   0.00, -39.00, 90.00);
	CreateDynamicObject(11495, 561.12, -1946.23, 6.23,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 561.11, -1932.70, 1.72,   0.00, 39.00, 90.00);
	CreateDynamicObject(3406, 561.12, -1923.47, -1.19,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 561.12, -1914.67, -1.19,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 561.12, -1906.27, -1.94,   0.00, 9.00, 90.00);
	CreateDynamicObject(1607, 585.65, -1941.91, -0.09,   15.00, 4.00, 60.00);
	CreateDynamicObject(1608, 523.48, -1957.19, -0.50,   9.00, -1.00, 47.00);
	CreateDynamicObject(1608, 498.81, -1947.70, -0.76,   9.00, -1.00, -164.00);
	CreateDynamicObject(1607, 685.75, -1946.98, -0.24,   15.00, 4.00, -62.00);
	CreateDynamicObject(970, 615.67, -2085.23, 3.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 610.08, -2085.22, 3.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 604.60, -2085.21, 3.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 617.78, -2087.33, 3.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(970, 617.79, -2091.55, 3.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(970, 617.79, -2091.55, 3.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(970, 617.79, -2095.77, 3.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(970, 617.78, -2099.96, 3.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(970, 616.44, -2103.56, 3.21,   0.00, 0.00, 229.00);
	CreateDynamicObject(970, 612.94, -2105.17, 3.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 608.72, -2105.18, 3.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 604.52, -2105.14, 3.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(19054, 609.66, -2093.18, 7.20,   0.00, 0.00, -21.00);
	CreateDynamicObject(19054, 606.96, -2095.82, 7.20,   0.00, 0.00, 34.00);
	CreateDynamicObject(19056, 535.38, -1939.94, 0.17,   0.00, -14.00, -15.00);
	CreateDynamicObject(19056, 542.78, -1884.10, 2.70,   0.00, -14.00, -15.00);
	CreateDynamicObject(2232, 601.98, -2085.66, 4.71,   0.00, 0.00, 180.00);
	CreateDynamicObject(2232, 599.01, -2085.62, 4.71,   0.00, 0.00, 180.00);
	CreateDynamicObject(2232, 596.27, -2085.65, 4.71,   0.00, 0.00, 180.00);
	CreateDynamicObject(2232, 589.64, -2085.63, 4.71,   0.00, 0.00, 180.00);
	CreateDynamicObject(2232, 586.64, -2085.62, 4.71,   0.00, 0.00, 180.00);
	CreateDynamicObject(2232, 583.62, -2085.68, 4.71,   0.00, 0.00, 180.00);
	CreateDynamicObject(2232, 616.44, -2065.96, 3.27,   0.00, 0.00, 327.00);
	CreateDynamicObject(2232, 578.50, -2065.94, 3.27,   0.00, 0.00, 35.00);
	CreateDynamicObject(2232, 617.06, -2084.50, 3.27,   0.00, 0.00, 222.00);
	CreateDynamicObject(3406, 556.32, -2071.00, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 580.09, -2093.46, 3.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 550.40, -2073.91, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 550.40, -2082.71, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 550.40, -2091.51, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 556.33, -2077.48, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 556.36, -2083.48, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 556.34, -2089.62, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 556.33, -2095.44, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 545.51, -2071.03, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 541.61, -2075.90, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 532.94, -2075.89, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 536.72, -2071.03, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 527.94, -2071.02, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 519.14, -2071.01, -1.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(3406, 524.44, -2075.94, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(3406, 515.26, -2075.90, -1.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(19054, 700.05, -1958.01, 1.74,   0.00, 0.00, -21.00);
	CreateDynamicObject(2125, 613.80, -2090.49, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 611.78, -2090.51, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 607.88, -2090.51, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 606.10, -2090.50, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 604.41, -2091.94, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 604.32, -2093.70, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 604.42, -2098.20, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 604.45, -2099.78, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 605.82, -2101.27, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 607.70, -2101.25, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 611.94, -2101.35, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 613.53, -2101.32, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 615.22, -2099.85, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 615.18, -2098.13, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 615.13, -2093.73, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(2125, 615.13, -2092.12, 2.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(1243, 601.10, -2021.39, -2.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 577.85, -2065.34, 4.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 617.62, -2065.29, 4.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 617.63, -2084.91, 4.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 577.98, -2085.04, 4.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 628.64, -1911.02, 2.64,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 632.48, -1910.96, 2.64,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 703.33, -1913.20, 2.64,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 707.03, -1913.17, 2.64,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 560.08, -1907.29, 1.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 562.18, -1907.33, 1.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 562.06, -1935.26, 7.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 562.04, -1957.21, 7.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 562.14, -2023.68, 7.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 562.11, -2045.63, 7.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 562.10, -2070.00, 2.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 506.69, -1898.93, 1.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 510.33, -1898.92, 1.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(18653, 602.45, -2085.17, 2.69,   0.00, 0.00, -55.00);
	CreateDynamicObject(18653, 582.34, -2085.17, 2.69,   0.00, 0.00, -125.00);
	CreateDynamicObject(18647, 600.45, -2085.16, 4.03,   0.00, 0.00, 90.00);
	CreateDynamicObject(18647, 594.35, -2085.16, 4.03,   0.00, 0.00, 90.00);
	CreateDynamicObject(18647, 589.92, -2085.16, 4.03,   0.00, 0.00, 90.00);
	CreateDynamicObject(18647, 584.76, -2085.15, 4.03,   0.00, 0.00, 90.00);
	CreateDynamicObject(18771, 676.01, -2054.44, -5.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(2180, 595.39, -2085.93, 4.06,   0.00, 0.00, 180.00);
	CreateDynamicObject(2180, 593.43, -2085.94, 4.06,   0.00, 0.00, 180.00);
	CreateDynamicObject(2180, 591.49, -2085.94, 4.06,   0.00, 0.00, 180.00);
	CreateDynamicObject(18647, 594.90, -2085.46, 4.86,   0.00, 0.00, 90.00);
	CreateDynamicObject(18647, 592.92, -2085.46, 4.86,   0.00, 0.00, 90.00);
	CreateDynamicObject(18647, 590.93, -2085.45, 4.86,   0.00, 0.00, 90.00);
	CreateDynamicObject(14820, 593.88, -2085.92, 4.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(14820, 591.88, -2085.92, 4.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(18653, 595.83, -2085.54, 4.09,   0.00, 0.00, -55.00);
	CreateDynamicObject(18653, 590.06, -2085.57, 4.09,   0.00, 0.00, -125.00);
	CreateDynamicObject(18275, 592.83, -2086.86, 6.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 600.47, -2089.90, 4.67,   0.00, 0.00, 25.00);
	CreateDynamicObject(970, 596.53, -2090.76, 4.67,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 592.43, -2090.76, 4.67,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 588.29, -2090.77, 4.67,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 584.32, -2089.88, 4.67,   0.00, 0.00, -25.00);
	CreateDynamicObject(970, 582.47, -2087.19, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 602.38, -2087.28, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 602.39, -2091.48, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 602.37, -2095.67, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 602.38, -2099.76, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 600.47, -2123.88, 4.67,   0.00, 0.00, 33.00);
	CreateDynamicObject(970, 588.15, -2125.01, 4.67,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 584.24, -2123.87, 4.67,   0.00, 0.00, -33.00);
	CreateDynamicObject(970, 582.54, -2099.59, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 582.53, -2095.34, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 584.41, -2094.15, 4.67,   0.00, 0.00, -25.00);
	CreateDynamicObject(970, 577.86, -2087.24, 3.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(970, 577.89, -2091.41, 3.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(14394, 581.32, -2089.27, 3.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 582.23, -2085.24, 3.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(18783, 592.39, -2115.16, 1.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 582.54, -2103.80, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 582.53, -2107.98, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 582.52, -2112.21, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 582.50, -2116.42, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 582.49, -2120.59, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 592.35, -2125.02, 4.67,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 596.57, -2125.02, 4.67,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 602.37, -2103.98, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 602.38, -2108.14, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 602.38, -2112.26, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 602.39, -2116.43, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(970, 602.39, -2120.61, 4.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 689.90, -1959.30, 0.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 720.78, -1959.30, 0.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 726.19, -1964.20, 0.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 684.52, -1964.20, 0.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 684.52, -1974.50, 0.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 684.52, -1984.80, 0.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 684.52, -1995.10, 0.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 726.19, -1974.50, 0.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 726.19, -1984.80, 0.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 726.19, -1995.10, 0.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 689.90, -1999.98, 0.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 700.20, -1999.98, 0.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 710.50, -1999.98, 0.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 720.78, -1999.98, 0.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3499, 726.21, -1959.20, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3499, 726.21, -2000.05, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3499, 684.48, -2000.05, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(19313, 718.66, -1999.96, 4.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(19313, 704.58, -1999.96, 4.59,   0.00, 0.00, 180.00);
	CreateDynamicObject(19313, 690.90, -1999.96, 4.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(19313, 718.66, -1959.28, 4.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(19313, 704.58, -1959.28, 4.59,   0.00, 0.00, 180.00);
	CreateDynamicObject(19313, 690.90, -1959.28, 4.59,   0.00, 0.00, 180.00);
	CreateDynamicObject(19313, 726.18, -1992.48, 4.59,   0.00, 0.00, 90.00);
	CreateDynamicObject(19313, 726.18, -1978.41, 4.59,   0.00, 0.00, -90.00);
	CreateDynamicObject(19313, 726.18, -1965.63, 4.59,   0.00, 0.00, -90.00);
	CreateDynamicObject(19313, 684.48, -1966.36, 4.59,   0.00, 0.00, -90.00);
	CreateDynamicObject(19313, 684.48, -1978.41, 4.59,   0.00, 0.00, -90.00);
	CreateDynamicObject(19313, 684.48, -1992.48, 4.59,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 705.25, -1979.18, 0.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3499, 699.46, -1979.17, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3499, 711.03, -1979.17, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(12814, 690.21, -1980.05, 8.65,   0.00, 180.00, 0.00);
	CreateDynamicObject(12814, 720.20, -1980.05, 8.65,   0.00, 180.00, 0.00);
}

stock GetPlayerNameEx(playerid) {
	new
		sz_playerName[MAX_PLAYER_NAME],
		i_pos;
	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	while ((i_pos = strfind(sz_playerName, "_", false, i_pos)) != -1) sz_playerName[i_pos] = ' ';
	return sz_playerName;
}
