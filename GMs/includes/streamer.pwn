/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[STREAMER.PWN]--------------------------------


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

 /* Streamer Error Log fixes by Jingles
 	("Streamer_GetIntData: Invalid ID specified" spam)
 */

/*public Streamer_OnPluginError(error[]) {

 	if(strfind(error, "Streamer_GetIntData: Invalid", true) != -1) return 0;
 	return 1;
}*/


forward DoorOpen(playerid);
public DoorOpen(playerid)
{
	  MoveDynamicObject(lspddoor1, 247.2763671875,72.536186218262,1002.640625, 3.5000);
	  MoveDynamicObject(lspddoor2, 244.0330657959,72.580932617188,1002.640625, 3.5000);
	  return 1;
}
forward DoorClose(playerid);
public DoorClose(playerid)
{
	  MoveDynamicObject(lspddoor1, 246.35150146484,72.547714233398,1002.640625, 3.5000);
	  MoveDynamicObject(lspddoor2, 245.03300476074,72.568511962891,1002.640625, 3.5000);
	  return 1;
}

forward CloseWestLobby();
public CloseWestLobby()
{
	MoveDynamicObject(westlobby1,239.71582031,116.09179688,1002.21502686,4);
	MoveDynamicObject(westlobby2,239.67968750,119.09960938,1002.21502686,4);
	return 1;
}

forward CloseEastLobby();
public CloseEastLobby()
{
	MoveDynamicObject(eastlobby1,253.14941406,110.59960938,1002.21502686,4);
	MoveDynamicObject(eastlobby2,253.18457031,107.59960938,1002.21502686,4);
	return 1;
}

forward CloseCage();
public CloseCage()
{
   	MoveDynamicObject(cage,-773.52050781,2545.62109375,10022.29492188,2);
	return 1;
}

forward CloseLocker();
public CloseLocker()
{
	MoveDynamicObject(locker1,267.29980469,112.56640625,1003.61718750,4);
	MoveDynamicObject(locker2,264.29980469,112.52929688,1003.61718750,4);
	return 1;
}

forward CloseEntranceDoor();
public CloseEntranceDoor()
{
    MoveDynamicObject(entrancedoor,-766.27539062,2536.58691406,10019.5,2);
	return 1;
}

forward CloseCCTV();
public CloseCCTV()
{
	MoveDynamicObject(cctv1,264.44921875,115.79980469,1003.61718750,4);
	MoveDynamicObject(cctv2,267.46875000,115.83691406,1003.61718750,4);
	return 1;
}

forward CloseChief();
public CloseChief()
{
	MoveDynamicObject(chief1,229.59960938,119.50000000,1009.21875000,4);
	MoveDynamicObject(chief2,232.59960938,119.53515625,1009.21875000,4);
	return 1;
}

forward CloseSASDNew1();
public CloseSASDNew1()
{
	MoveDynamicObject(SASDDoors[0], 14.92530, 53.51950, 996.84857, 4, 0.00000, 0.00000, 90.00000);
	return 1;
}

forward CloseSASDNew2();
public CloseSASDNew2()
{
	MoveDynamicObject(SASDDoors[1], 8.70370, 57.32530, 991.03699, 4, 0.00000, 0.00000, 270.00000);
	return 1;
}

forward CloseSASD1();
public CloseSASD1()
{
	MoveDynamicObject(sasd1A,2511.65332031,-1697.00976562,561.79223633,4);
	MoveDynamicObject(sasd1B,2514.67211914,-1696.97485352,561.79223633,4);
	return 1;
}

forward CloseSASD2();
public CloseSASD2()
{
	MoveDynamicObject(sasd2A,2516.87548828,-1697.01525879,561.79223633,4);
	MoveDynamicObject(sasd2B,2519.89257812,-1696.97509766,561.79223633,4);
	return 1;
}

forward CloseSASD3();
public CloseSASD3()
{
	MoveDynamicObject(sasd3A,2522.15600586,-1697.01550293,561.79223633,4);
	MoveDynamicObject(sasd3B,2525.15893555,-1696.98010254,561.79223633,4);
	return 1;
}

forward CloseSASD4();
public CloseSASD4()
{
	MoveDynamicObject(sasd4A,2511.84130859,-1660.08081055,561.79528809,4);
	MoveDynamicObject(sasd4B,2514.81982422,-1660.04650879,561.80004883,4);
	return 1;
}

forward CloseSASD5();
public CloseSASD5()
{
	MoveDynamicObject(sasd5A,2522.86059570,-1660.07177734,561.80206299,4);
	MoveDynamicObject(sasd5B,2519.84228516,-1660.10888672,561.80004883,4);
	return 1;
}

forward CloseFBILobbyLeft();
public CloseFBILobbyLeft()
{
	MoveDynamicObject(FBILobbyLeft,295.40136719,-1498.43457031,-46.13965225,4);
	return 1;
}

forward CloseFBILobbyRight();
public CloseFBILobbyRight()
{
	MoveDynamicObject(FBILobbyRight,302.39355469,-1521.62988281,-46.13965225,4);
	return 1;
}

forward CloseFBIPrivate();
public CloseFBIPrivate()
{
	MoveDynamicObject(FBIPrivate[0],299.29986572,-1492.82666016,-28.73300552,4);
	MoveDynamicObject(FBIPrivate[1],299.33737183,-1495.83911133,-28.73300552,4);
	return 1;
}

forward SFPDDoors(doorid, status);
public SFPDDoors(doorid, status)
{
	if(doorid == 0) // Chief
	{
		if(status == 0) MoveDynamicObject(SFPDHighCMDDoor[0], -1578.19397, 702.29370, 18.64510, 0.9);
		if(status == 1) MoveDynamicObject(SFPDHighCMDDoor[0], -1579.6340, 702.2937, 18.6451, 0.9);
	}
	if(doorid == 1) // Deputy Chief
	{
		if(status == 0) MoveDynamicObject(SFPDHighCMDDoor[1], -1578.26196, 696.84729, 18.64510, 0.9);
		if(status == 1) MoveDynamicObject(SFPDHighCMDDoor[1], -1579.7220, 696.8473, 18.6451, 0.9);
	}
	if(doorid == 2) // Commander
	{
		if(status == 0) MoveDynamicObject(SFPDHighCMDDoor[2], -1587.77795, 697.84589, 18.64510, 0.9);
		if(status == 1) MoveDynamicObject(SFPDHighCMDDoor[2], -1589.2380, 697.8459, 18.6451, 0.9);
	}
	if(doorid == 3) // Lobby 1
	{
		if(status == 0) MoveDynamicObject(SFPDLobbyDoor[0], -1602.26709, 704.99298, 12.85020, 0.9);
		if(status == 1) MoveDynamicObject(SFPDLobbyDoor[0], -1602.2671, 706.3130, 12.8502, 0.9);
	}
	if(doorid == 4) // Lobby 2
	{
		if(status == 0) MoveDynamicObject(SFPDLobbyDoor[1], -1598.17004, 702.68219, 12.85020, 0.9);
		if(status == 1) MoveDynamicObject(SFPDLobbyDoor[1], -1599.4900, 702.6822, 12.8502, 0.9);
	}
	return 1;
}
