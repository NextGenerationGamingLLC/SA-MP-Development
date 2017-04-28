#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS (700)
#include <sscanf2>
#include <streamer>
#include <zcmd>

//new musicarea;
new festivalarea;
new mazearea;
new piratearea;
new startcount = 3;

enum posenum
{
	Float:posx,
	Float:posy,
	Float:posz,
	Float:rot
}

//Maze
new
	Text3D:mazetext,
	mazecount = 0;

//Pirate
new Text3D:piratetext;
new pirateship[2],
	Float:PirateShipOrigin[2][4] = 
	{
		{1384.0331, -142.1840, 57.1300, 40.0},
		{1390.5167, -136.2200, 42.7034, -50.0}
	},
	piratestep[8],
	Float:piratejoin[4] = {1376.6722,-128.7566,26.4127,214.9392},
	Float:pirateexit[4] = {1374.6167,-129.0237,26.4127,36.3936};
new pirateshipspawn[51][posenum] = {
{1368.3156,-157.4080,41.0},
{1367.7076,-156.7162,41.0},
{1367.0004,-156.1516,41.0},
{1366.5372,-155.3416,41.0},
{1365.8599,-154.7898,41.0},
{1366.0726,-153.8185,38.8073},
{1366.2477,-154.5297,41.0},
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
{1377.4641,-149.3647,38.8073},
{1377.2501,-148.4664,38.8073},
{1376.4216,-147.5100,38.8073},
{1375.4967,-147.0543,38.8073},
{1375.6320,-145.8949,37.7709},
{1376.4155,-146.4493,37.7709},
{1376.9457,-147.3245,37.7709},
{1377.2776,-148.1663,38.8073},
{1378.1124,-148.4439,37.7709},
{1378.6742,-148.0090,37.7709},
{1378.3854,-147.0647,37.7709},
{1377.7249,-146.2822,37.7709},
{1377.0049,-145.7251,37.7709},
{1376.3148,-145.1906,37.7709}
};
//Pirate

new Float:gFerrisOrigin[4] = {1449.5245, -35.6684, 40.5702, 220.0};
new gFerrisWheel, gFerrisBase;
new gFerrisCages[10];
new Float:gCurrentTargetYAngle = 0.0;
new gWheelTransAlternate = 0;

enum krace
{
	count,//Racer Count
	status,// 0 = Waiting for more players | 1 = Starting | 2 = Active/In Progress
	starting,//Countdown for race to start
	left,//Time left till race ends
	place//Used to determine place within race.
}

new oTower[5],
	oTowerobjs[8],
	Text3D:oTowerText,
	oTowerInfo[2][krace];

new dTower[2],
	Text3D:dTowerText,
	Float:dTowerJoin[4] = {1420.0839, -79.6418, 26.4147, 40.2862},
	Float:dTowerExit[4] = {1421.8177, -78.2212, 26.4147, 212.9111},
	Float:dTowerOrigin[2][4] = 
	{
		{1413.34216, -76.74107, 27.49859, 40.0},
		{1419.97156, -71.32480, 27.49860, 40.0}
	},
	dTowerInfo[2][krace];

//Kart
new Text3D:karttext;
new kartraceinfo[krace];
new Float:gKartOrigin[3] = {1550.7883, 17.4276, 24.1364};
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
//Kart

//Bumper
new bumpercars;
new Float:gBumperOrigin[3] = {1493.4615,-33.9362,27.5266},
	Float:gBumperExit[4] = {1495.0763,-32.5579,27.5244,305.1577};
new bumperspawns[10][posenum] = {
{1509.0797,-64.9944,26.9080,329.6529},
{1516.2323,-55.0962,26.9271,345.0430},
{1520.049682, -41.101760, 27.553333,13.7316},
{1508.8268,-29.9964,26.9196,123.8321},
{1503.8162,-37.9906,26.9408,171.2591},
{1497.4014,-48.4876,26.9138,76.2519},
{1492.9607,-40.7950,26.9149,269.7835},
{1505.6836,-32.8667,26.9330,275.1056},
{1515.4636,-35.6011,26.9223,196.8903},
{1514.7443,-48.7944,26.9353,136.1681}
};
//Bumper

new balloon[2],
	BalloonInfo[2][krace],
	Float:BalloonOrigin[2][4] = 
	{
		{1488.7391, 2.3967, 25.3880, 310.5066},
		{1504.3217, -17.2454, 25.2946, 40.3796}
	},
	Float:bCoor[2][3][3] =
	{
		{
			{1488.8054,3.1436,26.5342},
			{1489.4617,2.3942,26.5342},
			{1488.2523,2.0228,26.5342}
		},
		{
			{1504.1639,-16.4742,26.4408},
			{1505.0876,-17.3473,26.4408},
			{1503.9115,-17.5536,26.4408}
		}
	},
	Float:move_balloon[][3] =
	{
		{1554.0,8.0,100.0},
		{1574.0,-40.0,115.0},
		{1569.0,-94.0,115.0},
		{1558.0,-134.0,115.0},
		{1501.0,-195.0,115.0},
		{1457.0,-208.0,115.0},
		{1402.0,-208.0,115.0},
		{1360.0,-169.0,115.0},
		{1340.0,-129.0,115.0},
		{1342.0,-84.0,115.0},
		{1356.0,-52.0,115.0},
		{1397.0,-18.0,100.0},
		{1431.0,9.0,75.0},
		{1463.0,14.0,60.0}
	},
	bActive;

new Float:festival_vertices[] = 
{
	1589.0,118.0,
	1596.0,-6.0,
	1577.0,-52.0,
	1573.0,-127.0,
	1529.0,-180.0,
	1514.0,-202.0,
	1460.0,-220.0,
	1384.0,-222.0,
	1299.0,-94.0,
	1421.0,20.0,
	1504.0,85.0,
	1551.0,108.0,
	1589.0,118.0
};

public OnFilterScriptInit()
{
	//musicarea = CreateDynamicSphere(592.84, -2085, 0, 330.0);
	festivalarea = CreateDynamicPolygon(festival_vertices, .worldid = 0);
	mazearea = CreateDynamicRectangle(1567, 1260, 1311, 1508, .worldid = 333);
	piratearea = CreateDynamicRectangle(1323.112670, -183.252929, 1448.739501, -90.425178);
	SetTimer("KartUpdateGlobal", 1000, true);
	CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/bumpercars {FFFF00}to join in!", 0xFFFFFFF, gBumperOrigin[0], gBumperOrigin[1], gBumperOrigin[2], 10.0);
	CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/balloon {FFFF00}to join in!\nCost: 5 credits", 0xFFFFFFF, 1488.9030, -15.1005, 26.3947, 10.0);
	karttext = CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/joinkart {FFFF00}to join in!", 0xFFFFFFF, gKartOrigin[0], gKartOrigin[1], gKartOrigin[2], 15.0);
	dTowerText = CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/jointower {FFFF00}to join in!", 0xFFFFFFF, dTowerJoin[0], dTowerJoin[1], dTowerJoin[2], 15.0);
	oTowerText = CreateDynamic3DTextLabel("{FFFF00}Type {FF0000}/otower {FFFF00}to join in!", 0xFFFFFFF, 1525.3893,-83.8848,23.2147, 15.0);
	piratetext = CreateDynamic3DTextLabel("", 0xFFFFFFF, piratejoin[0], piratejoin[1], piratejoin[2], 15.0);
	mazetext = CreateDynamic3DTextLabel("", 0xFFFFFFF, 1380.188598, -75.701736, 31.074687, 15.0);
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
	dTower[0] = CreateObject(19075, dTowerOrigin[0][0], dTowerOrigin[0][1], dTowerOrigin[0][2],   0.00000, 0.00000, dTowerOrigin[0][3]);
	dTower[1] = CreateObject(19075, dTowerOrigin[1][0], dTowerOrigin[1][1], dTowerOrigin[1][2],   0.00000, 0.00000, dTowerOrigin[1][3]);
	pirateship[0] = CreateObject(3502, PirateShipOrigin[0][0], PirateShipOrigin[0][1], PirateShipOrigin[0][2],   0.00, 0.00, PirateShipOrigin[0][3]);
 	pirateship[1] = CreateObject(8493, PirateShipOrigin[1][0], PirateShipOrigin[1][1], PirateShipOrigin[1][2],   0.00, 0.00, PirateShipOrigin[1][3]);
 	AttachObjectToObject(pirateship[1], pirateship[0], 9.33, 0.0, -8.07, 0.0, 0.0, 270.0);
	
	new Float:oTowerCoor[8][4] = 
	{
		{1532.60547, -74.62054, 25.76330, 70.00000},
		{1536.41064, -74.45510, 25.76330, 115.00000},
		{1539.18335, -71.73110, 25.76330, 154.00000},
		{1539.45105, -67.91582, 25.76330, 18.00000},
		{1537.02881, -64.92320, 25.76330, 60.00000},
		{1533.22607, -64.31990, 25.76330, 102.00000},
		{1529.99792, -66.41510, 25.76330, 144.00000},
		{1529.00085, -70.13410, 25.76330, 6.00000}
	};
	oTower[0] = CreateObject(19278, 1534.34131, -69.60560, -20.48360, 0.0, 0.0, 0.0, 300.0);
	oTower[1] = CreateObject(19278, 1534.34131, -69.60560, -26.92160, 0.0, 0.0, 0.0, 300.0);
	AttachObjectToObject(oTower[1], oTower[0], 1534.34131-1534.34131, -69.60560-(-69.60560), -26.92160-(-20.48360), 0.0, 0.0, 0.0, 0);
	oTower[2] = CreateObject(19278, 1534.34131, -69.60560, -23.61560, 0.0, 0.0, 0.0, 300.0);
	AttachObjectToObject(oTower[2], oTower[0], 1534.34131-1534.34131, -69.60560-(-69.60560), -23.61560-(-20.48360), 0.0, 0.0, 0.0, 0);
	oTower[3] = CreateObject(970, 1530.04, -72.88, 26.50,   0.00, 0.00, -53.00);
	AttachObjectToObject(oTower[3], oTower[0], 1530.04-1534.34131, -72.88-(-69.60560), 26.50-(-20.48360), 0.0, 0.0, -53.0, 0);
	oTower[4] = CreateObject(970, 1530.04, -72.88, 23.19,   0.00, 0.00, -53.00);
	AttachObjectToObject(oTower[4], oTower[0], 1530.04-1534.34131, -72.88-(-69.60560), 23.19-(-20.48360), 0.0, 0.0, -53.0, 0);
	for(new x;x<8;x++)
	{
		oTowerobjs[x] = CreateObject(19325, oTowerCoor[x][0], oTowerCoor[x][1], oTowerCoor[x][2], 90.0, 0.0, oTowerCoor[x][3], 300.0);
		AttachObjectToObject(oTowerobjs[x], oTower[0], oTowerCoor[x][0]-1534.34131, oTowerCoor[x][1]-(-69.60560), oTowerCoor[x][2]-(-20.48360), 90.0, oTowerCoor[x][3], 0.0, 0);
	}

	balloon[0] = CreateObject(19335, BalloonOrigin[0][0], BalloonOrigin[0][1], BalloonOrigin[0][2], 0.0, 0.0,  BalloonOrigin[0][3]);
	balloon[1] = CreateObject(19336, BalloonOrigin[1][0], BalloonOrigin[1][1], BalloonOrigin[1][2], 0.0, 0.0,  BalloonOrigin[0][3]);

	CreateDynamicPickup(1239, 23, 1468.1566,-76.7717,23.2247);
	CreateDynamic3DTextLabel("Corn Dogs\n/corndog", 0xFFFF00AA, 1468.1566,-76.7717,23.2247+0.6, 10.0);
	CreateDynamicPickup(1239, 23, 1477.4579,-70.6260,23.2188);
	CreateDynamic3DTextLabel("Pizza\n/pizza", 0xFFFF00AA, 1477.4579,-70.6260,23.2188+0.6, 10.0);
	CreateDynamicPickup(1239, 23, 1465.0697,-86.3609,23.2247);
	CreateDynamic3DTextLabel("Fried Dough\n/frieddough", 0xFFFF00AA, 1465.0697,-86.3609,23.2247+0.6, 10.0);

	//Maze Exit Point
	CreateDynamicPickup(1318, 23, 1473.045898+0.1, 1429.182617+0.1, 11.050000, .worldid = 333);
	CreateDynamic3DTextLabel("Maze Exit Point\n{FF0000}/exitmaze", 0xFFFF00AA, 1473.045898+0.06, 1429.182617+0.06, 11.050000+0.8, 10.0, .worldid = 333);

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
		if(GetPVarType(i, "pTower"))
		{
			LeaveTower(i);
		}
		if(GetPVarType(i, "oTower"))
		{
			LeaveOTower(i);
		}
		if(GetPVarType(i, "pPirate"))
		{
			LeavePirateShip(i);
		}
		if(GetPVarType(i, "pBalloon"))
		{
			LeaveBalloon(i);
		}
	}
	DestroyObject(gFerrisWheel);
	DestroyObject(gFerrisBase);
	for(new x;x<10;x++)
	{
		DestroyObject(gFerrisCages[x]);
	}
	DestroyObject(dTower[0]);
	DestroyObject(dTower[1]);
	DestroyObject(pirateship[0]);
	DestroyObject(pirateship[1]);
	
	DestroyObject(oTower[0]);
	DestroyObject(oTower[1]);
	DestroyObject(oTower[2]);
	DestroyObject(oTower[3]);
	DestroyObject(oTower[4]);
	for(new x;x<8;x++)
	{
		DestroyObject(oTowerobjs[x]);
	}
	DestroyObject(balloon[0]);
	DestroyObject(balloon[1]);
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
	if(GetPVarType(playerid, "pTower"))
	{
		LeaveTower(playerid);
	}
	if(GetPVarType(playerid, "oTower"))
	{
		LeaveOTower(playerid);
	}
	if(GetPVarType(playerid, "pPirate"))
	{
		LeavePirateShip(playerid);
	}
	if(GetPVarType(playerid, "pBalloon"))
	{
		LeaveBalloon(playerid);
	}
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	/*if(areaid == musicarea)
	{
		StopAudioStreamForPlayer(playerid);
		PlayAudioStreamForPlayer(playerid, "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1", 1431, -74, 0, 400, 1);
	}*/
	if(areaid == festivalarea || areaid == mazearea)
	{
		ResetPlayerWeapons(playerid);
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			SetVehicleToRespawn(GetPlayerVehicleID(playerid));
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	/*if(areaid == musicarea)
	{
		StopAudioStreamForPlayer(playerid);
	}*/
	if(areaid == festivalarea || areaid == mazearea) CallRemoteFunction("SetPlayerWeapons", "i", playerid);
	if(areaid == piratearea && GetPVarType(playerid, "pPirate")) LeavePirateShip(playerid);
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
			SetPVarInt(playerid, "pKartLap", 4);
		    if(GetPVarInt(playerid, "pKartLap") == 3) GameTextForPlayer(playerid, "~r~Final Lap!", 1100, 3);
			if(GetPVarInt(playerid, "pKartLap") == 4)
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

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) if(IsPlayerInDynamicArea(playerid, festivalarea) || IsPlayerInDynamicArea(playerid, mazearea)) ResetPlayerWeapons(playerid);

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

CMD:balloon(playerid, params[])
{
	if(GetPVarType(playerid, "pBalloon")) return LeaveBalloon(playerid);
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1488.9030,-15.1005,26.394)) return SendClientMessage(playerid, -1, "You are not near the Balloon Ride area!");
	if(CallRemoteFunction("cmd_@@balloon@@", "is", playerid, params) == 0) return 1;
	if(BalloonInfo[0][status] != 2 && BalloonInfo[0][count] <= 5)
	{
		SetPVarInt(playerid, "pBalloon", 0);
		SetPlayerPos(playerid, bCoor[0][BalloonInfo[0][count]][0], bCoor[0][BalloonInfo[0][count]][1], bCoor[0][BalloonInfo[0][count]][2]);
		BalloonInfo[0][count]++;
	}
	else if(BalloonInfo[1][status] != 2 && BalloonInfo[1][count] <= 5)
	{
		SetPVarInt(playerid, "pBalloon", 1);
		SetPlayerPos(playerid, bCoor[1][BalloonInfo[1][count]][0], bCoor[1][BalloonInfo[1][count]][1], bCoor[1][BalloonInfo[0][count]][2]);
		BalloonInfo[1][count]++;
	}
	else return SendClientMessage(playerid, -1, "Balloon Rides are currently full, please try again later!");
	new Float:HP;
	GetPlayerHealth(playerid, HP);
	SetPVarFloat(playerid, "pOldHealth", HP);
	SetPlayerHealth(playerid, 1000.0);
	new bRide = GetPVarInt(playerid, "pBalloon");
	if(BalloonInfo[bRide][status] == 0)
	{
		if(!bActive) BalloonInfo[bRide][status] = 1, BalloonInfo[bRide][starting] = 30, bActive = 1, SetTimerEx("StartBalloon", 1000, false, "d", bRide);
		else BalloonInfo[bRide][status] = 3, SendClientMessage(playerid, -1, "There is currently a active balloon, this ride will begin once the other is done.");
	}
	SendClientMessage(playerid, -1, "Please stay inside the balloon or you and your ticket will be removed.");
	return 1;
}

LeaveBalloon(playerid)
{
	if(GetPVarType(playerid, "pBalloon"))
	{
		new bRide = GetPVarInt(playerid, "pBalloon");
		DeletePVar(playerid, "pBalloon");
		if(BalloonInfo[bRide][count] > 0) BalloonInfo[bRide][count]--;
		SetPlayerPos(playerid, 1490.7323+random(2),-17.8974,26.3888);
		SetPlayerHealth(playerid, GetPVarFloat(playerid, "pOldHealth"));
		DeletePVar(playerid, "pOldHealth");
		SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for riding!");
	}
	return 1;
}

forward StartBalloon(bRide);
public StartBalloon(bRide)
{
	if(--BalloonInfo[bRide][starting] == 0)
	{
		BalloonInfo[bRide][status] = 2;
		BalloonInfo[bRide][place] = 0;
		MoveObject(balloon[bRide],  move_balloon[BalloonInfo[bRide][place]][0], move_balloon[BalloonInfo[bRide][place]][1], move_balloon[BalloonInfo[bRide][place]][2], 5);
		for(new x; x < MAX_PLAYERS; x++)
		{
			if(IsPlayerConnected(x) && GetPVarType(x, "pBalloon") && GetPVarInt(x, "pBalloon") == bRide)
			{
				CallRemoteFunction("RemoveTicket", "d", x);
			}
		}
	}
	else
	{
		new string[69];
		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Balloon Ride~n~starting in %d seconds", BalloonInfo[bRide][starting]);
		for(new x; x < MAX_PLAYERS; x++)
		{
			if(IsPlayerConnected(x) && GetPVarType(x, "pBalloon") && GetPVarInt(x, "pBalloon") == bRide)
			{
				if(BalloonInfo[bRide][starting] <= 3)
				{
					PlayerPlaySound(x, 1056, 0.0, 0.0, 0.0);
				}
				GameTextForPlayer(x, string, 1100, 3);
			}
		}
		if(BalloonInfo[bRide][count]) SetTimerEx("StartBalloon", 1000, false, "d", bRide);
		else
		{
			BalloonInfo[bRide][place] = 0, BalloonInfo[bRide][status] = 0, bActive = 0;
			if(BalloonInfo[0][status] == 3) BalloonInfo[0][status] = 1, BalloonInfo[0][starting] = 30, bActive = 1,  SetTimerEx("StartBalloon", 1000, false, "d", 0);
			if(BalloonInfo[1][status] == 3) BalloonInfo[1][status] = 1, BalloonInfo[1][starting] = 30, bActive = 1,  SetTimerEx("StartBalloon", 1000, false, "d", 1);
		}
	}
}

//Towers
new Float:otowercoor[5][2] =
{
	{1531.2751,-72.3726},
	{1536.2238,-72.3415},
	{1536.7957,-67.4150},
	{1532.5234,-66.6518},
	{1530.5852,-69.1646}
};

CMD:otower(playerid, params[])
{
	if(GetPVarType(playerid, "oTower")) return LeaveOTower(playerid);
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1525.3893,-83.8848,23.2147)) return SendClientMessage(playerid, 0xFFFFFFFF, "You are not near the Observation Tower area!");
	if(oTowerInfo[0][status] != 2 && oTowerInfo[0][count] <= 5)
	{
		SetPVarInt(playerid, "oTower", 0);
		SetPlayerPos(playerid, otowercoor[oTowerInfo[0][count]][0], otowercoor[oTowerInfo[0][count]][1], 23.6487);
		oTowerInfo[0][count]++;
	}
	else if(oTowerInfo[0][status] != 2 && oTowerInfo[1][count] <= 5)
	{
		SetPVarInt(playerid, "oTower", 1);
		SetPlayerPos(playerid, otowercoor[oTowerInfo[0][count]][0], otowercoor[oTowerInfo[0][count]][1], 26.9547);
		oTowerInfo[1][count]++;
	}
	else return SendClientMessage(playerid, -1, "The Observation Tower is either full or in progress, please try again later!");
	if(oTowerInfo[0][status] == 0) oTowerInfo[0][status] = 1, oTowerInfo[0][starting] = 30, SetTimer("StartOTower", 1000, false);
	UpdateTowerLabels();
	return 1;
}

LeaveMaze(playerid)
{
	if(GetPVarInt(playerid, "pMaze"))
	{
		DeletePVar(playerid, "pMaze");
		mazecount--;
	}
	SetPlayerPos(playerid, 1389.463012, -81.734130, 31.068840);
	SetPlayerFacingAngle(playerid, 311.76);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	CallRemoteFunction("Player_StreamPrep", "ifffi", playerid, 1389.463012, -81.734130, 31.068840, 2000);
	if(GetPVarInt(playerid, "pOldHealth"))
	{
		SetPlayerHealth(playerid, GetPVarFloat(playerid, "pOldHealth"));
		DeletePVar(playerid, "pOldHealth");
	}
}

CMD:exitmaze(playerid, params[])
{
	if(GetPVarInt(playerid, "pMaze"))
	{
		return cmd_joinmaze(playerid, params);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 10, 1473.045898, 1429.182617, 11.050000) || IsPlayerInRangeOfPoint(playerid, 10, 1546.592828, 1261.259155, 11.069601))
	{
		LeaveMaze(playerid);
		return 1;
	}
	else
	{
		SendClientMessage(playerid, 0xFFFFFFFF, "You are not inside of the Maze!");
	}
	return 1;
}

CMD:joinmaze(playerid, params[])
{
	if(!GetPVarType(playerid, "pMaze"))
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, 1380.188598, -75.701736, 31.074687))
		{
			SetPVarInt(playerid, "pMaze", 1);
			new Float:HP; GetPlayerHealth(playerid, HP);
			SetPVarFloat(playerid, "pOldHealth", HP);
			SetPlayerVirtualWorld(playerid, 333);
			SetPlayerInterior(playerid, 1);
			SetPlayerPos(playerid, 1546.592828, 1261.259155, 11.069601);
			SetPlayerHealth(playerid, 1000.0);
			SetPlayerFacingAngle(playerid, 0.39);
			CallRemoteFunction("Player_StreamPrep", "ifffi", playerid, 1546.592828, 1261.259155, 11.069601, 2000);
			SendClientMessage(playerid, 0xFFFFFFFF, "If you get lost type /exitmaze to leave, There may be a mystical giftbox hidden at the end of the maze.");
			mazecount++;
		}
		else
		{
			SendClientMessage(playerid, 0xFFFFFFFF, "You are not at the Maze entrance");
		}
	}
	else
	{
		LeaveMaze(playerid);
	}
	return 1;
}

stock UpdateMazeLabel()
{
	new string[256];
	format(string, sizeof(string), "{FFFF00}Type {FF0000}/joinmaze {FFFF00}to join in!\nParticipants: {FF0000}%d", mazecount);
	UpdateDynamic3DTextLabelText(mazetext, 0xFFFFFFFF, string);
}

forward StartOTower();
public StartOTower()
{
	if(--oTowerInfo[0][starting] == 0)
	{
		oTowerInfo[0][status] = 2;
		MoveObject(oTower[0], 1534.34131, -69.60560, 78.8610, 2);
		oTowerInfo[0][place] = 0;
	}
	else
	{
		new string[75];
		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Observation Tower~n~starting in %d seconds", oTowerInfo[0][starting]);
		for(new x; x < MAX_PLAYERS; x++)
		{
			if(IsPlayerConnected(x) && GetPVarType(x, "oTower"))
			{
				if(oTowerInfo[0][starting] <= 3)
				{
					PlayerPlaySound(x, 1056, 0.0, 0.0, 0.0);
				}
				GameTextForPlayer(x, string, 1100, 3);
			}
		}
		if(oTowerInfo[0][count] || oTowerInfo[1][count]) SetTimer("StartOTower", 1000, false);
		else oTowerInfo[0][place] = 0, oTowerInfo[0][status] = 0;
	}
}

forward MoveOTower();
public MoveOTower()
{
	if(oTowerInfo[0][place] == 1)
	{
		if(--oTowerInfo[0][starting] == 0)
		{
			MoveObject(oTower[0], 1534.34131, -69.60560, -20.48360, 2);
			oTowerInfo[0][place] = 0;
			oTowerInfo[0][status] = 0;
		}
		else SetTimer("MoveOTower", 1*1000, false);
		return 1;
	}
	return 1;
}

LeaveOTower(playerid)
{
	if(GetPVarType(playerid, "oTower"))
	{
		new tower = GetPVarInt(playerid, "oTower");
		DeletePVar(playerid, "oTower");
		if(oTowerInfo[tower][count] > 0) oTowerInfo[tower][count]--;
		SetPlayerPos(playerid, 1520.7633+random(2),-74.5014,23.2147);
		UpdateTowerLabels();
		SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for riding!");
	}
	return 1;
}

CMD:jointower(playerid, params[])
{
	if(GetPVarType(playerid, "pTower")) return LeaveTower(playerid);
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, dTowerJoin[0], dTowerJoin[1], dTowerJoin[2])) return SendClientMessage(playerid, 0xFFFFFFFF, "You are not near the Drop Tower area!");
	if(dTowerInfo[0][status] != 2 && dTowerInfo[0][count] <= 5)
	{
		SetPVarInt(playerid, "pTower", 0);
		SetPlayerPos(playerid, 1413.2607+Random(1, 4),-76.6478,27.0455);
		dTowerInfo[0][count]++;
		if(dTowerInfo[0][status] == 0) dTowerInfo[0][status] = 1, dTowerInfo[0][starting] = 30, SetTimerEx("StartTower", 1000, false, "i", 0);
	}
	else if(dTowerInfo[1][status] != 2 && dTowerInfo[1][count] <= 5)
	{
		SetPVarInt(playerid, "pTower", 1);
		SetPlayerPos(playerid, 1419.8135+Random(1, 4),-71.2771,27.0455);
		dTowerInfo[1][count]++;
		if(dTowerInfo[1][status] == 0) dTowerInfo[1][status] = 1, dTowerInfo[1][starting] = 30, SetTimerEx("StartTower", 1000, false, "i", 1);
	}
	else return SendClientMessage(playerid, -1, "The Drop Towers are full, please try again later!");
	new Float:HP;
	GetPlayerHealth(playerid, HP);
	SetPVarFloat(playerid, "pOldHealth", HP);
	SetPlayerHealth(playerid, 1000.0);
	UpdateTowerLabels();
	return 1;
}

forward StartTower(tower);
public StartTower(tower)
{
	if(--dTowerInfo[tower][starting] == 0)
	{
		dTowerInfo[tower][status] = 2;
		MoveObject(dTower[tower], dTowerOrigin[tower][0], dTowerOrigin[tower][1], 126.9711, 3);
		dTowerInfo[tower][place] = 0;
	}
	else
	{
		new string[66];
		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Drop Tower~n~starting in %d seconds", dTowerInfo[tower][starting]);
		for(new x; x < MAX_PLAYERS; x++)
		{
			if(IsPlayerConnected(x) && GetPVarType(x, "pTower") && GetPVarInt(x, "pTower") == tower)
			{
				if(dTowerInfo[tower][starting] <= 3)
				{
					PlayerPlaySound(x, 1056, 0.0, 0.0, 0.0);
				}
				GameTextForPlayer(x, string, 1100, 3);
			}
		}
		if(dTowerInfo[tower][count]) SetTimerEx("StartTower", 1000, false, "i", tower);
		else dTowerInfo[tower][place] = 0, dTowerInfo[tower][status] = 0;
	}
}

forward MoveTower(tower);
public MoveTower(tower)
{
	if(dTowerInfo[tower][place] == 0)
	{
		if(--dTowerInfo[tower][starting] == 0)
		{
			MoveObject(dTower[tower], dTowerOrigin[tower][0], dTowerOrigin[tower][1], 35.8, 30);
			dTowerInfo[tower][place] = 1;
			for(new x; x < MAX_PLAYERS; x++)
			{
				if(IsPlayerConnected(x) && GetPVarType(x, "pTower") && GetPVarInt(x, "pTower") == tower) GameTextForPlayer(x, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~GO!", 2000, 3);
			}
		}
		else SetTimerEx("MoveTower", 1*1000, false, "i", tower);
		return 1;
	}
	if(dTowerInfo[tower][place] == 1)
	{
		MoveObject(dTower[tower], dTowerOrigin[tower][0], dTowerOrigin[tower][1], dTowerOrigin[tower][2], 5);
		dTowerInfo[tower][place] = 0;
		dTowerInfo[tower][status] = 0;
		return 1;
	}
	return 1;
}

LeaveTower(playerid)
{
	if(GetPVarType(playerid, "pTower"))
	{
		new tower = GetPVarInt(playerid, "pTower");
		DeletePVar(playerid, "pTower");
		if(dTowerInfo[tower][count] > 0) dTowerInfo[tower][count]--;
		SetPlayerPos(playerid, dTowerExit[0]+random(5), dTowerExit[1], dTowerExit[2]);
		SetPlayerFacingAngle(playerid, dTowerExit[3]);
		UpdateTowerLabels();
		SetPlayerHealth(playerid, GetPVarFloat(playerid, "pOldHealth"));
		DeletePVar(playerid, "pOldHealth");
		SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for riding!");
	}
	return 1;
}

forward RemovePlayersFromRide(ride, slot);
public RemovePlayersFromRide(ride, slot)
{
	for(new x; x < MAX_PLAYERS; x++)
	{
		if(IsPlayerConnected(x))
		{
			if(ride == 0 && GetPVarType(x, "pTower") && GetPVarInt(x, "pTower") == slot) LeaveTower(x);
			if(ride == 1 && GetPVarType(x, "oTower")) LeaveOTower(x);
			if(ride == 2 && GetPVarType(x, "pBalloon") && GetPVarInt(x, "pBalloon") == slot) LeaveBalloon(x);
		}
	}
	return 1;
}

stock UpdateTowerLabels()
{
	new string[256];
	format(string, sizeof(string), "{FFFF00}Type {FF0000}/jointower {FFFF00}to join in!\n\
	Participants\n\
	Tower 1: %d\nTower 2: %d", dTowerInfo[0][count], dTowerInfo[1][count]);
	UpdateDynamic3DTextLabelText(dTowerText, 0xFFFFFFFF, string);
	format(string, sizeof(string), "{FFFF00}Type {FF0000}/otower {FFFF00}to join in!\n\
	Participants\n\
	Upper Deck: %d\nLower Deck: %d", oTowerInfo[0][count], oTowerInfo[1][count]);
	UpdateDynamic3DTextLabelText(oTowerText, 0xFFFFFFFF, string);
}
//Towers

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
		SetPlayerPos(playerid, gBumperExit[0], gBumperExit[1], gBumperExit[2]);
		SetPlayerFacingAngle(playerid, gBumperExit[3]);
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
		//CallRemoteFunction("Player_StreamPrep", "ifffi", playerid, gBumperOrigin[0], gBumperOrigin[1], gBumperOrigin[2], 2000);
		SetPlayerPos(playerid, gBumperExit[0], gBumperExit[1], gBumperExit[2]);
		SetPlayerFacingAngle(playerid, gBumperExit[3]);
		SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
		ResetPlayerWeapons(playerid);
	}
	return 1;
}
//Bumper

//Kart
CMD:startcount(playerid, params[])
{
	if(!(GetPVarInt(playerid, "aLvl") >= 1337 || IsPlayerAdmin(playerid))) return 1;
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
	//LinkVehicleToInterior(veh, 7);
	SetVehicleVirtualWorld(veh, 7);

	SetPVarInt(playerid, "pSkin", GetPlayerSkin(playerid));
	SetPlayerSkin(playerid, 22);
	SetPlayerVirtualWorld(playerid, 7);
	//SetPlayerInterior(playerid, 7);
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
		//CallRemoteFunction("Player_StreamPrep", "ifffi", playerid, gKartOrigin[0], gKartOrigin[1], gKartOrigin[2]+3, 2500);
		SetPlayerPos(playerid, gKartOrigin[0], gKartOrigin[1], gKartOrigin[2]);
		if(kartraceinfo[count] > 0) kartraceinfo[count]--;
		UpdateKartLabel();
		TogglePlayerControllable(playerid, 1);
		DisablePlayerCheckpoint(playerid);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerSkin(playerid, GetPVarInt(playerid, "pSkin"));
		DeletePVar(playerid, "pSkin");
		SendClientMessage(playerid, 0xFFFFFFFF, "Thanks for playing!");
		ResetPlayerWeapons(playerid);
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
	UpdateMazeLabel();
	UpdatePirateLabel();
	if(piratestep[5] == 0 && piratestep[6] > 0 && (piratestep[7]-gettime()) <= 0)
	{
	    piratestep[5] = 1;
		SetTimer("MovePirateShip", 1000, false);
	}
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

//Pirate
CMD:pirateshipreset(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || GetPVarInt(playerid, "aLvl") > 1337)
	{
		if(IsObjectMoving(pirateship[0])) StopObject(pirateship[0]);
	    MoveObject(pirateship[0], PirateShipOrigin[0][0], PirateShipOrigin[0][1], PirateShipOrigin[0][2], 0.1, 0.0, 0.0, 40.0);
		piratestep[3] = 2;
	}
	return 1;
}

CMD:pirateship(playerid, params[])
{
	if(!GetPVarType(playerid, "pPirate"))
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, piratejoin[0], piratejoin[1], piratejoin[2]))
		{
			if(piratestep[5] == 0)
			{
				if(piratestep[6] < 51)
				{
					if(piratestep[6] == 0)
					{
						piratestep[7] = gettime()+30;
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
		LeavePirateShip(playerid);
	}
	return 1;
}

LeavePirateShip(playerid)
{
	DeletePVar(playerid, "pPirate");
	if(piratestep[6] > 0) piratestep[6]--;
	SetPlayerPos(playerid, pirateexit[0], pirateexit[1], pirateexit[2]);
	SetPlayerHealth(playerid, GetPVarFloat(playerid, "pOldHealth"));
	DeletePVar(playerid, "pOldHealth");
}

stock UpdatePirateLabel()
{
	new string[256];
	if(piratestep[6] == 0 && piratestep[5] == 0) format(string, sizeof(string), "{FFFF00}Type {FF0000}/pirateship {FFFF00}to join in!\nWaiting for at least 1 participant");
	else
	{
		if(piratestep[5] == 1) format(string, sizeof(string), "{FFFF00}Ride in progress!\nParticipants: {FF0000}%d", piratestep[6]);
		else format(string, sizeof(string), "{FFFF00}Type {FF0000}/pirateship {FFFF00}to join in!\nParticipants: {FF0000}%d\nRide Starts: %d", piratestep[6], piratestep[7]-gettime());
	}
	UpdateDynamic3DTextLabelText(piratetext, 0xFFFFFFFF, string);
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
		MoveObject(pirateship[0], PirateShipOrigin[0][0], PirateShipOrigin[0][1], PirateShipOrigin[0][2], 0.1, 0.0, 0.0, 40.0);
	    piratestep[3] = 2;
	}
}
//Pirate

public OnObjectMoved(objectid)
{
	if(objectid == gFerrisWheel)
	{
		SetTimer("RotateWheel",3*1000,0);
	}
	if(objectid == balloon[0] || objectid == balloon[1])
	{
		new bRide;
		if(objectid == balloon[1]) bRide = 1;
		if(BalloonInfo[bRide][status] == 0)
		{
			SetTimerEx("RemovePlayersFromRide", 1000, 0, "dd", 2, bRide);
			return 1;
		}
		if(BalloonInfo[bRide][place] == sizeof(move_balloon))
		{
			MoveObject(balloon[bRide], BalloonOrigin[bRide][0], BalloonOrigin[bRide][1], BalloonOrigin[bRide][2], 5);
			BalloonInfo[bRide][status] = 0;
			bActive = 0;
			if(BalloonInfo[0][status] == 3) BalloonInfo[0][status] = 1, BalloonInfo[0][starting] = 30, bActive = 1, SetTimerEx("StartBalloon", 1000, false, "d", 0);
			if(BalloonInfo[1][status] == 3) BalloonInfo[1][status] = 1, BalloonInfo[1][starting] = 30, bActive = 1, SetTimerEx("StartBalloon", 1000, false, "d", 1);
		}
		else MoveObject(balloon[bRide], move_balloon[BalloonInfo[bRide][place]][0], move_balloon[BalloonInfo[bRide][place]][1], move_balloon[BalloonInfo[bRide][place]][2], 7);
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) && GetPVarType(i, "pBalloon") && GetPVarInt(i, "pBalloon") == bRide)
			{
				if(!BalloonInfo[bRide][place]) 
				{
					if(!IsPlayerInRangeOfPoint(i, 10, move_balloon[BalloonInfo[bRide][place]][0], move_balloon[BalloonInfo[bRide][place]][1], move_balloon[BalloonInfo[bRide][place]][2])) LeaveBalloon(i);
				}
				else
				{
					if(!IsPlayerInRangeOfPoint(i, 10, move_balloon[BalloonInfo[bRide][place]-1][0], move_balloon[BalloonInfo[bRide][place]-1][1], move_balloon[BalloonInfo[bRide][place]-1][2])) LeaveBalloon(i);
				}
			}
		}
		BalloonInfo[bRide][place]++;
	}
	if(objectid == oTower[0])
	{
		if(oTowerInfo[0][status] == 0)
		{
			SetTimerEx("RemovePlayersFromRide", 1000, 0, "dd", 1, 0);
			return 1;
		}
		if(oTowerInfo[0][place] == 0) oTowerInfo[0][place] = 1, oTowerInfo[0][starting] = 10, SetTimer("MoveOTower", 1*1000, false);
	}
	if(objectid == dTower[0] || objectid == dTower[1])
	{
		new bRide;
		if(objectid == dTower[1]) bRide = 1;
		if(dTowerInfo[bRide][status] == 0)
		{
			SetTimerEx("RemovePlayersFromRide", 1000, 0, "dd", 0, bRide);
			return 1;
		}
		if(dTowerInfo[bRide][place] == 0) dTowerInfo[bRide][starting] = 3, SetTimerEx("MoveTower", 3*1000, false, "i", bRide);
		if(dTowerInfo[bRide][place] == 1) MoveTower(bRide);
	}
	if(objectid == pirateship[0])
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
					SetPlayerPos(i, pirateexit[0],pirateexit[1],pirateexit[2]);
					SetPlayerFacingAngle(i, pirateexit[3]);
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

stock GetPlayerNameEx(playerid) {
	new
		sz_playerName[MAX_PLAYER_NAME],
		i_pos;
	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	while ((i_pos = strfind(sz_playerName, "_", false, i_pos)) != -1) sz_playerName[i_pos] = ' ';
	return sz_playerName;
}

stock Random(min, max)
{
    new a = random(max - min) + min;
    return a;
}
