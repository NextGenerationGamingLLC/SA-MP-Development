#include <a_samp>
#include <streamer>
#include <zcmd>

#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA

#undef MAX_PLAYERS
#define MAX_PLAYERS 600

#define STATS 100

forward FinalTime();
forward Count();
forward Count2();
forward Count3();
forward Count4();

new Float:RandSpawns[10][3] = {
{1368.6777,-15.4862,33.8990},
{1371.0537,-17.4600,33.8313},
{1373.3427,-19.3955,33.9005},
{1375.2017,-20.8951,33.9141},
{1371.0170,-21.7205,33.9920},
{1369.2084,-19.0554,33.8998},
{1367.6494,-16.6513,33.9402},
{1366.2527,-18.7893,34.0003},
{1368.3834,-21.3142,33.9923},
{1375.0396,-13.5648,33.6829}
};

enum cInfo
{
	cPoint,
	cVehicle,
	cFinals,
	cFinalist,
	cJoined
};
new Check[MAX_PLAYERS][cInfo];
enum eInfo
{
	ePlayers,
	eWinner,
	eWinner2,
	eWinner3,
	eGrandWinner,
	eTopTen,
	eTopTen2,
	eTopTen3,
	eFinalsStarted,
	eFinalPlayers,
	eStarted
};
new Event[eInfo];

public OnFilterScriptInit()
{
	SetTimer("FinalTimer", 1000, true);
    Event[ePlayers] = 0;
    Event[eWinner] = 0;
    Event[eWinner2] = 0;
    Event[eWinner3] = 0;
    Event[eGrandWinner] = 0;
    Event[eTopTen] = 0;
    Event[eTopTen2] = 0;
    Event[eTopTen3] = 0;
    Event[eFinalsStarted] = 0;
    Event[eFinalPlayers] = 0;
	SpawnObjects();
}
CMD:startfinal(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
	    Event[eTopTen] = 0;
	    Event[eWinner] = 0;
	    SendClientMessage(playerid, COLOR_YELLOW, " ** You have started the finals");
    	for(new i;i<MAX_PLAYERS;i++)
		{
		    if(IsPlayerConnected(i))
		    {
     			if(Check[i][cFinalist] == 1)
       			{
       			    SendClientMessage(i, COLOR_YELLOW, " ** Finals have started! Follow the checkpoints, go go go!");
                    new rand = random(sizeof(RandSpawns));
     				SetPlayerPos(i, RandSpawns[rand][0], RandSpawns[rand][1], RandSpawns[rand][2]);
		        	SetPlayerCheckpoint(i, 1499.1532,88.4937,29.4708, 10.0);
		           	Check[i][cPoint] = 1;
        		}
        		else
        		{
        		    if(Check[i][cJoined] == 1)
					{
					    SendClientMessage(i, COLOR_YELLOW, " ** Thanks for playing! **");
					    SetPlayerPos(i, 1368.6777,-15.4862,33.8990);
						DisablePlayerCheckpoint(i);
					    DestroyVehicle(Check[i][cVehicle]);
					    Check[i][cFinals] = 0;
					    Check[i][cFinalist] = 0;
				        Event[ePlayers] -= 1;
				        Check[i][cJoined] = 0;
				        SetPlayerColor(i, 0xFFFFFF00);
				    }
        		}
			}
		}
	}
	return 1;
}
CMD:triathleave(playerid, params[])
{
    if(Check[playerid][cJoined] == 1)
	{
    	SetPlayerPos(playerid, 1368.6777,-15.4862,33.8990);
        DestroyVehicle(Check[playerid][cVehicle]);
        Check[playerid][cJoined] = 0;
        Event[ePlayers] -= 1;
        SetPlayerColor(playerid, 0xFFFFFF00);
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, " ** You are not currently in the event !");
    }
	return 1;
}
CMD:thelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, " ** /startfinal /triathstart /triathcount /triathleave /triathend /triathjoin /info");
	return 1;
}
CMD:triathstart(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		if(Event[eStarted] == 0)
		{
    		Event[eStarted] = 1;
    		SendClientMessageToAll(COLOR_YELLOW, " ** The Triathlon Event has Started ! (/triathjoin) ");
    	}
    	else
    	{
			SendClientMessage(playerid, COLOR_WHITE, " ** The event is already started. ");
		}
	}
	return 1;
}
CMD:triathcount(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
    	SetTimer("Count", 1000, false);
		SetTimer("Count2", 2000, false);
		SetTimer("Count3", 3000, false);
		SetTimer("Count4", 4000, false);
	}
	return 1;
}
CMD:triathend(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		if(Event[eStarted] == 1)
		{
    		Event[eStarted] = 0;
    		Event[ePlayers] = 0;
			Event[eTopTen] = 0;
			Event[eTopTen2] = 0;
			Event[eTopTen3] = 0;
			Event[eFinalPlayers] = 0;
    		SendClientMessageToAll(COLOR_YELLOW, " ** The Triathlon Event has ended. ");
    		EventEnd();
    	}
    	else
    	{
    	    SendClientMessage(playerid, COLOR_WHITE, " ** The Event is not currently active.");
    	}
    }
	return 1;
}
CMD:triathjoin(playerid, params[])
{
	if(Event[eStarted] == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 100.00, 1387.9923,-1.9898,33.1867))
		{
			if(Check[playerid][cJoined] == 0)
			{
				if(Event[ePlayers] <= 99)// Allows it to cap at 100
				{
                    SendClientMessage(playerid, COLOR_YELLOW, " ** You have joined the Triathlon Event (/triathleave) to leave. ");
                    Check[playerid][cJoined] = 1;
    				Event[ePlayers] += 1;
    				new rand = random(sizeof(RandSpawns));
            		SetPlayerPos(playerid, RandSpawns[rand][0], RandSpawns[rand][1], RandSpawns[rand][2]); //
            		SetPlayerFacingAngle(playerid, 312.0006);
    				SetPlayerVirtualWorld(playerid, 0);
    				Check[playerid][cPoint] = 1;
    				SetPlayerHealth(playerid, 100);
    				SetPlayerColor(playerid, 0xFB333300);
    			}
    			else if(Event[ePlayers] >= 100 && Event[ePlayers] <= 199)// Allows it to cap at 200
				{
                    SendClientMessage(playerid, COLOR_YELLOW, " ** You have joined the Triathlon Event (/triathleave) to leave. ");
                    Check[playerid][cJoined] = 1;
    				Event[ePlayers] += 1;
    				new rand = random(sizeof(RandSpawns));
            		SetPlayerPos(playerid, RandSpawns[rand][0], RandSpawns[rand][1], RandSpawns[rand][2]); //
            		SetPlayerFacingAngle(playerid, 312.0006);
    				SetPlayerVirtualWorld(playerid, 1);
    				Check[playerid][cPoint] = 1;
    				SetPlayerHealth(playerid, 100);
    				SetPlayerColor(playerid, 0xFB333300);
    			}
    			else if(Event[ePlayers] >= 200 && Event[ePlayers] <= 299)// Allows it to cap at 300
				{
                    SendClientMessage(playerid, COLOR_YELLOW, " ** You have joined the Triathlon Event (/triathleave) to leave. ");
                    Check[playerid][cJoined] = 1;
    				Event[ePlayers] += 1;
    				new rand = random(sizeof(RandSpawns));
            		SetPlayerPos(playerid, RandSpawns[rand][0], RandSpawns[rand][1], RandSpawns[rand][2]); //
            		SetPlayerFacingAngle(playerid, 312.0006);
    				SetPlayerVirtualWorld(playerid, 2);
    				Check[playerid][cPoint] = 1;
    				SetPlayerHealth(playerid, 100);
    				SetPlayerColor(playerid, 0xFB333300);
    			}
    			else
    			{
    	    		SendClientMessage(playerid, COLOR_WHITE, " ** All Virtual Worlds are full.");
    			}
			}
			else
			{
    			SendClientMessage(playerid, COLOR_WHITE, " ** Your already in the event !");
			}
		}
		else
		{
            SendClientMessage(playerid, COLOR_WHITE, " ** You are not near the fair grounds !");
		}
	}
	else
	{
   		SendClientMessage(playerid, COLOR_WHITE, " ** You may not do that at this time.");
	}
	return 1;
}
CMD:info(playerid, params[])
{
	new string[164];
	format(string,sizeof(string),"{FFFFFF}Event Amount: {00C0FF}%d\n{FFFFFF}Top 10(VW0): {00C0FF}%d\n{FFFFFF}Top 10(VW1): {00C0FF}%d\n{FFFFFF}Top 10(VW2): {00C0FF}%d\n{FFFFFF}Final Players: {00C0FF}%d", Event[ePlayers], Event[eTopTen], Event[eTopTen2], Event[eTopTen3], Event[eFinalPlayers]);
	ShowPlayerDialog(playerid, STATS, DIALOG_STYLE_MSGBOX, "{00C0FF}Race Information ", string, "Okay", "");
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(Check[playerid][cPoint] > 19 && (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER))
    {
        if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 510)
        {
            new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SetPlayerPos(playerid, X, Y, Z+5);
			SendClientMessage(playerid, 0xFFFFFFF, "Vehicles are not allowed in the triathalon.");
        }
    }
	if((Check[playerid][cPoint] >= 1 && Check[playerid][cPoint] < 19) && (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER))
	{
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);
		SetPlayerPos(playerid, X, Y, Z+5);
		SendClientMessage(playerid, 0xFFFFFFF, "Vehicles are not allowed in the triathalon.");
	}
}

public OnPlayerEnterCheckpoint(playerid)
{
    PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	if(Check[playerid][cPoint] == 1)
	{
		SetPlayerCheckpoint(playerid, 1741.8051,103.0313,32.7262, 10.0);
		Check[playerid][cPoint] = 2;
	}
	else if(Check[playerid][cPoint] == 2)
	{
		SetPlayerCheckpoint(playerid, 1947.8402,41.0180,32.8339, 10.0);
		Check[playerid][cPoint] = 3;
	}
	else if(Check[playerid][cPoint] == 3)
	{
		SetPlayerCheckpoint(playerid, 2218.5305,39.0527,25.9439, 10.0);
		Check[playerid][cPoint] = 4;
	}
	else if(Check[playerid][cPoint] == 4)
	{
		SetPlayerCheckpoint(playerid, 2294.3740,45.2020,25.9425, 10.0);
		Check[playerid][cPoint] = 5;
	}
	else if(Check[playerid][cPoint] == 5)
	{
		SetPlayerCheckpoint(playerid, 2295.7424,89.7945,25.9439, 10.0);
		Check[playerid][cPoint] = 6;
	}
	else if(Check[playerid][cPoint] == 6)
	{
		SetPlayerCheckpoint(playerid, 2339.7527,90.7219,25.9381, 10.0);
		Check[playerid][cPoint] = 7;
	}
	else if(Check[playerid][cPoint] == 7)
	{
		SetPlayerCheckpoint(playerid, 2340.7100,209.4803,25.9435, 10.0);
		Check[playerid][cPoint] = 8;
	}
	else if(Check[playerid][cPoint] == 8)
	{
		SetPlayerCheckpoint(playerid, 2183.1121,233.9390,14.1485, 10.0);
		Check[playerid][cPoint] = 9;
	}
	else if(Check[playerid][cPoint] == 9)
	{
		SetPlayerCheckpoint(playerid, 1859.2255,364.1655,19.6282, 10.0);
		Check[playerid][cPoint] = 10;
	}
	else if(Check[playerid][cPoint] == 10)
	{
		SetPlayerCheckpoint(playerid, 1627.4449,380.5849,19.8536, 10.0);
		Check[playerid][cPoint] = 11;
	}
	else if(Check[playerid][cPoint] == 11)
	{
		SetPlayerCheckpoint(playerid, 1635.3680,541.5301,-0.4650, 10.0);
		Check[playerid][cPoint] = 12;
		SendClientMessage(playerid, COLOR_WHITE, " ** You've reached the water! Start Swimming !");
	}
	else if(Check[playerid][cPoint] == 12)
	{
		SetPlayerCheckpoint(playerid, 1459.7528,575.5743,-0.6064, 10.0);
		Check[playerid][cPoint] = 13;
	}
	else if(Check[playerid][cPoint] == 13)
	{
		SetPlayerCheckpoint(playerid, 1215.7406,622.8767,-0.3497, 10.0);
		Check[playerid][cPoint] = 14;
	}
	else if(Check[playerid][cPoint] == 14)
	{
		SetPlayerCheckpoint(playerid, 1002.9628,624.5873,-0.4021, 10.0);
		Check[playerid][cPoint] = 15;
	}
	else if(Check[playerid][cPoint] == 15)
	{
		SetPlayerCheckpoint(playerid, 797.2114,557.0652,-0.7513, 10.0);
		Check[playerid][cPoint] = 16;
	}
	else if(Check[playerid][cPoint] == 16)
	{
		SetPlayerCheckpoint(playerid, 677.2833,575.5888,-0.5745, 10.0);
		Check[playerid][cPoint] = 17;
	}
	else if(Check[playerid][cPoint] == 17)
	{
		SetPlayerCheckpoint(playerid, 588.7811,603.7844,-0.5786, 10.0);
		Check[playerid][cPoint] = 18;
	}
	else if(Check[playerid][cPoint] == 18)
	{
		SetPlayerCheckpoint(playerid, 506.1274,639.9700,4.5897, 10.0);
		Check[playerid][cPoint] = 19;
	}
	else if(Check[playerid][cPoint] == 19)// Bike Start
	{
		SetPlayerCheckpoint(playerid, 451.3434,728.3683,5.7113, 10.0);
		new Float:pX, Float:pY, Float:pZ, Float:pA, world;
		GetPlayerPos(playerid, pX, pY, pZ);
		GetPlayerFacingAngle(playerid, pA);
        world = GetPlayerVirtualWorld(playerid);
		Check[playerid][cVehicle] = CreateVehicle(510, pX, pY, pZ, pA, -1, -1, 600000);
        SetVehicleVirtualWorld(Check[playerid][cVehicle], world);
		PutPlayerInVehicle(playerid, Check[playerid][cVehicle], 0);
		new engine,lights,alarm,doors,bonnet,boot,objective;
		GetVehicleParamsEx(Check[playerid][cVehicle],engine,lights,alarm,doors,bonnet,boot,objective);
		SetVehicleParamsEx(Check[playerid][cVehicle],VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
		SendClientMessage(playerid, COLOR_WHITE, " ** You have reached the bikes! Start Cycling !");
		Check[playerid][cPoint] = 20;
	}
	else if(Check[playerid][cPoint] == 20)
	{
		SetPlayerCheckpoint(playerid, 436.0333,590.8746,18.6277, 10.0);
		Check[playerid][cPoint] = 21;
	}
	else if(Check[playerid][cPoint] == 21)
	{
		SetPlayerCheckpoint(playerid, 616.3361,312.7630,19.3701, 10.0);
		Check[playerid][cPoint] = 22;
	}
	else if(Check[playerid][cPoint] == 22)
	{
		SetPlayerCheckpoint(playerid, 520.0988,148.9618,23.5657, 10.0);
		Check[playerid][cPoint] = 23;
	}
	else if(Check[playerid][cPoint] == 23)
	{
		SetPlayerCheckpoint(playerid, 524.8806,-136.6934,37.5619, 10.0);
		Check[playerid][cPoint] = 24;
	}
	else if(Check[playerid][cPoint] == 24)
	{
		SetPlayerCheckpoint(playerid, 803.8380,-168.4362,18.2193, 10.0);
		Check[playerid][cPoint] = 25;
	}
	else if(Check[playerid][cPoint] == 25)
	{
		SetPlayerCheckpoint(playerid, 1018.6838,-185.1656,24.7855, 10.0);
		Check[playerid][cPoint] = 26;
	}
	else if(Check[playerid][cPoint] == 26)
	{
		SetPlayerCheckpoint(playerid, 1160.9331,-173.8525,40.8081, 10.0);
		Check[playerid][cPoint] = 27;
	}
	else if(Check[playerid][cPoint] == 27)
	{
		SetPlayerCheckpoint(playerid, 1298.6567,-80.0261,36.1955, 10.0);
		Check[playerid][cPoint] = 28;
	}
	else if(Check[playerid][cPoint] == 28)
	{
		SetPlayerCheckpoint(playerid, 1377.4449,-11.0428,33.3127, 10.0);
		Check[playerid][cPoint] = 29;
	}
	else if(Check[playerid][cPoint] == 29)// Race End
	{
		new string[128];
		SendClientMessage(playerid, COLOR_WHITE, " ** You have finished the race !" );
		Check[playerid][cPoint] = 0;
		Check[playerid][cJoined] = 0;
		DisablePlayerCheckpoint(playerid);
		DestroyVehicle(Check[playerid][cVehicle]);
		SetPlayerColor(playerid, 0xFFFFFF00);
		new World;
		World = GetPlayerVirtualWorld(playerid);
		if(Event[eTopTen] <= 9 && World == 0)
        {
    		if(Event[eWinner] == 0)
			{
			    if(Check[playerid][cFinalist] == 1)
			    {
			        format(string,sizeof(string)," ** %s has placed 1st in the final triathlon race!", PlayerName(playerid));
	            	SendClientMessageToAll(COLOR_YELLOW, string);

			        SendClientMessage(playerid, COLOR_YELLOW, " ** Thanks for playing! **");
	    			SetPlayerPos(playerid, 1368.6777,-15.4862,33.8990);
					DisablePlayerCheckpoint(Check[playerid][cPoint]);
		   			DestroyVehicle(Check[playerid][cVehicle]);
			    	Check[playerid][cFinals] = 0;
				    Check[playerid][cFinalist] = 0;
    				Event[ePlayers] -= 1;
        			Check[playerid][cJoined] = 0;
		        	SetPlayerColor(playerid, 0xFFFFFF00);
		        	Event[eWinner] = 1;
	            	Event[eTopTen] += 1;
			    }
			    else
			    {
	            	format(string,sizeof(string)," ** %s has placed first in the triathlon race! (World 0)", PlayerName(playerid));
	            	SendClientMessageToAll(COLOR_YELLOW, string);
	            	Event[eWinner] = 1;
	            	Event[eTopTen] += 1;
	            	Check[playerid][cFinals] = 1;
	                SetPlayerPos(playerid, 1378.6199,-17.3583,33.7817); //
	                SetPlayerFacingAngle(playerid, 312.0006);
	            	SetPlayerVirtualWorld(playerid, 0);
	            	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
	            	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
	               	Check[playerid][cFinalist] = 1;
	               	SetCameraBehindPlayer(playerid);
	               	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
				}
			}
			else
			{
			    if(Check[playerid][cFinalist] == 1)
			    {
			        format(string,sizeof(string)," ** %s has placed in %d place in the final triathlon race!", PlayerName(playerid), Event[eTopTen]+1);
	            	SendClientMessageToAll(COLOR_YELLOW, string);

			        SendClientMessage(playerid, COLOR_YELLOW, " ** Thanks for playing! **");
	    			SetPlayerPos(playerid, 1368.6777,-15.4862,33.8990);
					DisablePlayerCheckpoint(Check[playerid][cPoint]);
		   			DestroyVehicle(Check[playerid][cVehicle]);
			    	Check[playerid][cFinals] = 0;
				    Check[playerid][cFinalist] = 0;
    				Event[ePlayers] -= 1;
        			Check[playerid][cJoined] = 0;
		        	SetPlayerColor(playerid, 0xFFFFFF00);
		        	Event[eTopTen] += 1;
			    }
			    else
			    {
				    Event[eTopTen] += 1;
				    Check[playerid][cFinals] = 1;
				    if(Event[eTopTen] == 2)
					{

	                    SetPlayerPos(playerid, 1376.9570,-18.7578,33.8463); //
	                    SetPlayerFacingAngle(playerid, 312.0006);
	                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
	                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
	                	Check[playerid][cFinalist] = 1;
	                	SetCameraBehindPlayer(playerid);
	                	Event[eFinalPlayers] += 1;
		               	Check[playerid][cJoined] = 1;
						SetPlayerColor(playerid, 0xC2A2DA00);
	    			}
	    			else if(Event[eTopTen] == 3)
					{

	                    SetPlayerPos(playerid, 1375.0167,-20.0327,33.9030); //
	                    SetPlayerFacingAngle(playerid, 312.0006);
	                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
	                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
	                	Check[playerid][cFinalist] = 1;
	                	SetCameraBehindPlayer(playerid);
	                	Event[eFinalPlayers] += 1;
		               	Check[playerid][cJoined] = 1;
						SetPlayerColor(playerid, 0xC2A2DA00);
	    			}
	    			else if(Event[eTopTen] == 4)
					{

	                    SetPlayerPos(playerid, 1372.7197,-21.9141,33.9810); //
	                    SetPlayerFacingAngle(playerid, 312.0006);
	                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
	                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
	                	Check[playerid][cFinalist] = 1;
	                	SetCameraBehindPlayer(playerid);
	                	Event[eFinalPlayers] += 1;
		               	Check[playerid][cJoined] = 1;
						SetPlayerColor(playerid, 0xC2A2DA00);
	    			}
	    			else if(Event[eTopTen] == 5)
					{

	                    SetPlayerPos(playerid, 1371.1647,-21.3493,33.9795); //
	                    SetPlayerFacingAngle(playerid, 312.0006);
	                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
	                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
	                	Check[playerid][cFinalist] = 1;
	                	SetCameraBehindPlayer(playerid);
	                	Event[eFinalPlayers] += 1;
		               	Check[playerid][cJoined] = 1;
						SetPlayerColor(playerid, 0xC2A2DA00);
	    			}
	    			else if(Event[eTopTen] == 6)
					{

	                    SetPlayerPos(playerid, 1373.4471,-19.2163,33.8942); //
	                    SetPlayerFacingAngle(playerid, 312.0006);
	                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
	                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
	                	Check[playerid][cFinalist] = 1;
	                	SetCameraBehindPlayer(playerid);
	                	Event[eFinalPlayers] += 1;
		               	Check[playerid][cJoined] = 1;
						SetPlayerColor(playerid, 0xC2A2DA00);
	    			}
	    			else if(Event[eTopTen] == 7)
					{

	                    SetPlayerPos(playerid, 1375.5750,-17.2278,33.8146); //
	                    SetPlayerFacingAngle(playerid, 312.0006);
	                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
	                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
	                	Check[playerid][cFinalist] = 1;
	                	SetCameraBehindPlayer(playerid);
	                	Event[eFinalPlayers] += 1;
		               	Check[playerid][cJoined] = 1;
						SetPlayerColor(playerid, 0xC2A2DA00);
	    			}
	    			else if(Event[eTopTen] == 8)
					{

	                    SetPlayerPos(playerid, 1377.2094,-15.7003,33.7535); //
	                    SetPlayerFacingAngle(playerid, 312.0006);
	                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
	                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
	                	Check[playerid][cFinalist] = 1;
	                	SetCameraBehindPlayer(playerid);
	                	Event[eFinalPlayers] += 1;
		               	Check[playerid][cJoined] = 1;
						SetPlayerColor(playerid, 0xC2A2DA00);
	    			}
	    			else if(Event[eTopTen] == 9)
					{

	                    SetPlayerPos(playerid, 1378.6268,-14.3757,33.6892); //
	                    SetPlayerFacingAngle(playerid, 312.0006);
	                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
	                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
	                	Check[playerid][cFinalist] = 1;
	                	SetCameraBehindPlayer(playerid);
	                	Event[eFinalPlayers] += 1;
		               	Check[playerid][cJoined] = 1;
						SetPlayerColor(playerid, 0xC2A2DA00);
	    			}
	    			else if(Event[eTopTen] == 10)
					{

	                    SetPlayerPos(playerid, 1377.6050,-12.7168,33.6252); //
	                    SetPlayerFacingAngle(playerid, 312.0006);
	                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
	                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
	                	Check[playerid][cFinalist] = 1;
	                	SetCameraBehindPlayer(playerid);
	                	Event[eFinalPlayers] += 1;
		               	Check[playerid][cJoined] = 1;
						SetPlayerColor(playerid, 0xC2A2DA00);
	                	SendClientMessageToAll(COLOR_YELLOW, " ** The Top Ten have finished in world 2 !");

	    			}
				}
    			SetPlayerVirtualWorld(playerid,0);
			}
		}
		else if(Event[eTopTen2] <= 9 && World == 1)
        {
			if(Event[eWinner2] == 0)
			{
            	format(string,sizeof(string)," ** %s has placed first in the triathlon race! (World 1) ", PlayerName(playerid));
            	SendClientMessageToAll(COLOR_YELLOW, string);
            	Event[eWinner2] = 1;
            	Event[eTopTen2] += 1;
            	Check[playerid][cFinals] = 1;

                SetPlayerPos(playerid, 1376.4937,-13.7607,33.6698); //
                SetPlayerFacingAngle(playerid, 312.0006);
            	SetPlayerVirtualWorld(playerid, 0);
            	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
               	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
               	Check[playerid][cFinalist] = 1;
                SetCameraBehindPlayer(playerid);
               	Event[eFinalPlayers] += 1;
               	Check[playerid][cJoined] = 1;
               	
				SetPlayerColor(playerid, 0xC2A2DA00);
 			}
 			else
			{
			    SendClientMessage(playerid, COLOR_YELLOW, " ** You have made it to the finals !");
			    Event[eTopTen2] += 1;
			    Check[playerid][cFinals] = 1;
			    if(Event[eTopTen2] == 2)
				{

                    SetPlayerPos(playerid, 1375.2175,-14.8114,33.7150); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen2] == 3)
				{

                    SetPlayerPos(playerid, 1373.8109,-16.2772,33.7772); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen2] == 4)
				{

                    SetPlayerPos(playerid, 1372.2452,-17.2904,33.8216); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen2] == 5)
				{

                    SetPlayerPos(playerid, 1371.4664,-15.8160,33.8129); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen2] == 6)
				{

                    SetPlayerPos(playerid, 1372.6976,-14.6656,33.7653); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen2] == 7)
				{

                    SetPlayerPos(playerid, 1374.0262,-13.4242,33.7140); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen2] == 8)
				{

                    SetPlayerPos(playerid, 1375.1516,-12.3724,33.6706); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen2] == 9)
				{

                    SetPlayerPos(playerid, 1376.1416,-11.4472,33.6324); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen2] == 10)
				{

                    SetPlayerPos(playerid, 1375.3090,-10.0130,33.6482); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                    Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
                	SendClientMessageToAll(COLOR_YELLOW, " ** The Top Ten have finished in world 3 !");
    			}
    			SetPlayerVirtualWorld(playerid, 0);
			}
 		}
 		else if(Event[eTopTen3] <= 9 && World == 2)
        {
		    if(Event[eWinner3] == 0)
			{
            	format(string,sizeof(string)," ** %s has placed first in the triathlon race! (World 2) ", PlayerName(playerid));
            	SendClientMessageToAll(COLOR_YELLOW, string);
            	Event[eWinner3] = 3;
            	Event[eTopTen3] += 1;
            	Check[playerid][cFinals] = 1;

                SetPlayerPos(playerid, 1373.9121,-11.2033,33.6995); //
                SetPlayerFacingAngle(playerid, 312.0006);
            	SetPlayerVirtualWorld(playerid, 0);
            	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
               	Check[playerid][cFinalist] = 1;
                SetCameraBehindPlayer(playerid);
               	Event[eFinalPlayers] += 1;
               	Check[playerid][cJoined] = 1;
				SetPlayerColor(playerid, 0xC2A2DA00);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_YELLOW, " ** You have made it to the finals !");
			    Event[eTopTen3] += 1;
			    Check[playerid][cFinals] = 1;
			    if(Event[eTopTen3] == 2)
				{

                    SetPlayerPos(playerid, 1372.7495,-12.0258,33.7429); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen3] == 3)
				{

                    SetPlayerPos(playerid, 1371.4868,-12.9587,33.7899); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                    Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen3] == 4)
				{

                    SetPlayerPos(playerid, 1370.2292,-14.5464,33.8429); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen3] == 5)
				{

                    SetPlayerPos(playerid, 1368.0095,-14.4614,33.9233); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen3] == 6)
				{

                    SetPlayerPos(playerid, 1369.1237,-13.4426,33.8827); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen3] == 7)
				{
                    SetPlayerPos(playerid, 1370.3534,-12.3183,33.8378); //
                    SetPlayerFacingAngle(playerid, 312.0006);
                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen3] == 8)
				{
                    SetPlayerPos(playerid, 1371.5422,-11.2314,33.7944); //
                    SetPlayerFacingAngle(playerid, 312.0006);

                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen3] == 9)
				{
                    SetPlayerPos(playerid, 1373.0571,-9.4526,33.7406); //
                    SetPlayerFacingAngle(playerid, 312.0006);

                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
    			}
    			else if(Event[eTopTen3] == 10)
				{
                    SetPlayerPos(playerid, 1369.1237,-13.4426,33.8827); //
                    SetPlayerFacingAngle(playerid, 312.0006);

                	SendClientMessage(playerid, COLOR_WHITE, " ** Waiting for other contenders to finish.");
                	SendClientMessage(playerid, COLOR_YELLOW, " ** You're a finalist! You will be in the Championship round, please wait here!");
                	Check[playerid][cFinalist] = 1;
                	SetCameraBehindPlayer(playerid);
                	Event[eFinalPlayers] += 1;
	               	Check[playerid][cJoined] = 1;
					SetPlayerColor(playerid, 0xC2A2DA00);
                	SendClientMessageToAll(COLOR_YELLOW, " ** The Top Ten have finished in world 4 !");
    			}
			    SetPlayerVirtualWorld(playerid, 0);
			}
		}
		else if(Event[eFinalsStarted] == 1)
		{
			if(Event[eGrandWinner] == 0 && World == 0)
        	{
	         	format(string,sizeof(string)," ** %s has placed first in the triathlon race ! They've won the grand prize ! ", PlayerName(playerid));
   	        	SendClientMessageToAll(COLOR_YELLOW, string);
       	    	Event[eGrandWinner] += 1;
       	    }
			else if(Event[eGrandWinner] == 1)
			{
	         	format(string,sizeof(string)," ** %s has placed third in the triathlon race ! They've won the secondary prize ! ", PlayerName(playerid));
   	        	SendClientMessageToAll(COLOR_YELLOW, string);
       	    	Event[eGrandWinner] += 1;
			}
			else if(Event[eGrandWinner] == 2)
			{
	         	format(string,sizeof(string)," ** %s has placed first in the triathlon race ! They've won the third prize ! ", PlayerName(playerid));
  	        	SendClientMessageToAll(COLOR_YELLOW, string);
			}
		}
	}
	return 1;
}
forward FinalTimer();
public FinalTimer()
{
	for(new i;i<MAX_PLAYERS;i++)
	{
	    if(Check[i][cPoint] >= 19 && GetVehicleModel(GetPlayerVehicleID(i)) == 510)
	    {
	        new engine,lights,alarm,doors,bonnet,boot,objective;
			GetVehicleParamsEx(GetPlayerVehicleID(i),engine,lights,alarm,doors,bonnet,boot,objective);
			SetVehicleParamsEx(GetPlayerVehicleID(i),VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
	    }
	}
 	if(Event[eFinalsStarted] == 0 && Event[eFinalPlayers] >= 30)
	{
		for(new i;i<MAX_PLAYERS;i++)
		{
		    if(IsPlayerConnected(i))
		    {
     			if(Check[i][cFinalist] == 1)
       			{
		        	SendClientMessage(i, COLOR_YELLOW, " ** Finals have started! Follow the checkpoints, go go go!");
		        	SetPlayerCheckpoint(i, 1499.1532,88.4937,29.4708, 10.0);
		        	new rand = random(sizeof(RandSpawns));
     				SetPlayerPos(i, RandSpawns[rand][0], RandSpawns[rand][1], RandSpawns[rand][2]);
		           	Check[i][cPoint] = 1;
        		}
        		else
        		{
        		    if(Check[i][cJoined] == 1)
					{
					    SendClientMessage(i, COLOR_YELLOW, " ** Thanks for playing! **");
					    SetPlayerPos(i, 1368.6777,-15.4862,33.8990);
						DisablePlayerCheckpoint(Check[i][cPoint]);
					    DestroyVehicle(Check[i][cVehicle]);
					    Check[i][cFinals] = 0;
					    Check[i][cFinalist] = 0;
				        Event[ePlayers] -= 1;
				        Check[i][cJoined] = 0;
				        SetPlayerColor(i, 0xFFFFFF00);
				    }
        		}
			}
		}
		Event[eFinalsStarted] = 1;
	}
	return 1;
}


public OnPlayerDisconnect(playerid, reason)
{
    if(Check[playerid][cJoined] == 1)
	{
		DisablePlayerCheckpoint(Check[playerid][cPoint]);
	    DestroyVehicle(Check[playerid][cVehicle]);
	    Check[playerid][cFinals] = 0;
	    Check[playerid][cFinalist] = 0;
        Event[ePlayers] -= 1;
        Check[playerid][cJoined] = 0;
    }
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
    if(Check[playerid][cJoined] == 1)
	{
		DisablePlayerCheckpoint(playerid);
	    DestroyVehicle(Check[playerid][cVehicle]);
	    Check[playerid][cFinals] = 0;
	    Check[playerid][cFinalist] = 0;
        Event[ePlayers] -= 1;
        Check[playerid][cJoined] = 0;
        SetPlayerColor(playerid, 0xFFFFFF00);
    }
	return 1;
}

public Count()
{
 	for(new i;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i))
	    {
            if(Check[i][cJoined] == 1 || IsPlayerInRangeOfPoint(i, 50.00, 1387.9923,-1.9898,33.1867))
			{
               	SendClientMessage(i, COLOR_YELLOW, " ** 3 **");
            }
        }
    }
 	return 1;
}

public Count2()
{
	for(new i;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i))
	    {
            if(Check[i][cJoined] == 1 || IsPlayerInRangeOfPoint(i, 50.00, 1387.9923,-1.9898,33.1867))
			{
  				SendClientMessage(i, COLOR_YELLOW, " ** 2 ** ");
            }
        }
    }
 	return 1;
}

public Count3()
{
	for(new i;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i))
	    {
            if(Check[i][cJoined] == 1 || IsPlayerInRangeOfPoint(i, 50.00, 1387.9923,-1.9898,33.1867))
			{
  				SendClientMessage(i, COLOR_YELLOW, " ** 1 **");
			}
		}
    }
 	return 1;
}

public Count4()
{
    for(new i;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i))
	    {
            if(Check[i][cJoined] == 1 || IsPlayerInRangeOfPoint(i, 50.00, 1387.9923,-1.9898,33.1867))
			{
  				SendClientMessage(i, COLOR_YELLOW, " ** Start, Go Go Go !");
   				new rand = random(sizeof(RandSpawns));
     			SetPlayerPos(i, RandSpawns[rand][0], RandSpawns[rand][1], RandSpawns[rand][2]); //
      			SetPlayerFacingAngle(i, 312.0006);
      			SetPlayerCheckpoint(i, 1499.1532,88.4937,29.4708, 10.0);
            }
        }
    }
 	return 1;
}

EventEnd()
{
	for(new i;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i))
	    {
			if(Check[i][cJoined] == 1)
			{
				DestroyVehicle(Check[i][cVehicle]);
			    SetPlayerPos(i, 1368.6777,-15.4862,33.8990);
	            DisablePlayerCheckpoint(i);
			    SendClientMessage(i, COLOR_WHITE, " ** The Event has ended, you've been respawned.");
			    Check[i][cJoined] = 0;
			    Event[ePlayers] = 0;
			    Event[eTopTen] = 0;
			    Event[eTopTen2] = 0;
			    Event[eTopTen3] = 0;
			    Event[eFinalPlayers] = 0;
			    SetPlayerColor(i, 0xFFFFFF00);
			}
		}
	}
	return 1;
}

PlayerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	return name;
}

stock SpawnObjects()
{
	CreateDynamicObject(1238,185.61500549,710.33001709,5.41200018,0.00000000,0.00000000,0.00000000); //object(trafficcone) (1)
    CreateDynamicObject(1238,177.85800171,706.95501709,5.41200018,0.00000000,0.00000000,0.00000000); //object(trafficcone) (2)
    CreateDynamicObject(1238,170.96699524,703.29498291,5.42999983,0.00000000,0.00000000,0.00000000); //object(trafficcone) (3)
    CreateDynamicObject(1238,162.42300415,698.70898438,5.44799995,0.00000000,0.00000000,0.00000000); //object(trafficcone) (4)
    CreateDynamicObject(1238,153.19500732,693.10400391,5.44799995,0.00000000,0.00000000,0.00000000); //object(trafficcone) (5)
    CreateDynamicObject(1238,144.65800476,686.97100830,5.44799995,0.00000000,0.00000000,0.00000000); //object(trafficcone) (6)
    CreateDynamicObject(1238,136.56799316,681.19299316,5.44799995,0.00000000,0.00000000,0.00000000); //object(trafficcone) (7)
    CreateDynamicObject(4514,297.60000610,809.50000000,16.60000038,3.99902344,0.00000000,22.74719238); //object(cn2_roadblock01ld) (1)
    CreateDynamicObject(4514,640.46777344,309.73144531,20.67000008,0.00000000,0.00000000,271.99951172); //object(cn2_roadblock01ld) (2)
    CreateDynamicObject(4514,490.76998901,215.72500610,12.91699982,356.00000000,0.00000000,130.50003052); //object(cn2_roadblock01ld) (3)
    CreateDynamicObject(979,528.83099365,154.47599792,23.46800041,0.00000000,1.50000000,95.00000000); //object(sub_roadleft) (1)
    CreateDynamicObject(978,517.29199219,54.53320312,21.33399963,0.00000000,1.99951172,273.24645996); //object(sub_roadright) (1)
    CreateDynamicObject(4514,507.92800903,-138.47999573,37.51699829,351.99548340,0.00000000,86.49560547); //object(cn2_roadblock01ld) (4)
    CreateDynamicObject(4514,517.40002441,-200.39999390,37.70000076,1.99981689,359.24954224,168.51745605); //object(cn2_roadblock01ld) (5)
    CreateDynamicObject(4514,1188.31933594,-181.38964844,40.75400162,355.99548340,0.00000000,203.99414062); //object(cn2_roadblock01ld) (6)
    CreateDynamicObject(4514,1286.15795898,-60.66299820,35.44800186,352.26800537,2.77523804,36.06323242); //object(cn2_roadblock01ld) (7)
    CreateDynamicObject(4514,1519.24414062,125.08105469,31.24600029,3.99353027,0.00000000,25.44433594); //object(cn2_roadblock01ld) (8)
    CreateDynamicObject(979,1531.61621094,95.73828125,29.40800095,0.00000000,0.49438477,27.49328613); //object(sub_roadleft) (6)
    CreateDynamicObject(982,2189.16601562,47.99499893,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (2)
    CreateDynamicObject(982,2214.78198242,47.99900055,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (3)
    CreateDynamicObject(982,2240.39306641,48.00000000,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (4)
    CreateDynamicObject(982,2266.00805664,48.00000000,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (5)
    CreateDynamicObject(982,2189.26000977,35.33100128,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (6)
    CreateDynamicObject(982,2214.87500000,35.33100128,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (7)
    CreateDynamicObject(982,2240.49291992,35.33200073,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (8)
    CreateDynamicObject(982,2266.11303711,35.32899857,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (9)
    CreateDynamicObject(982,2286.89599609,35.33000183,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (10)
    CreateDynamicObject(982,2299.70996094,48.15599823,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (11)
    CreateDynamicObject(982,2299.70996094,70.54100037,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (12)
    CreateDynamicObject(983,2280.40405273,47.99900055,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit3) (2)
    CreateDynamicObject(983,2285.47290039,50.57300186,25.96500015,0.00000000,0.00000000,144.00000000); //object(fenceshit3) (3)
    CreateDynamicObject(983,2302.81811523,84.11299896,25.96500015,0.00000000,0.00000000,103.99780273); //object(fenceshit3) (4)
    CreateDynamicObject(982,2287.35400391,65.98000336,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (13)
    CreateDynamicObject(982,2287.36108398,85.90599823,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (14)
    CreateDynamicObject(982,2300.15893555,98.69999695,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (15)
    CreateDynamicObject(982,2324.62011719,98.69499969,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (16)
    CreateDynamicObject(982,2318.70190430,84.90299988,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (17)
    CreateDynamicObject(982,2337.89404297,84.89700317,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (18)
    CreateDynamicObject(982,2350.72802734,97.72899628,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (19)
    CreateDynamicObject(982,2337.45092773,111.51499939,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (20)
    CreateDynamicObject(982,2350.73193359,123.34300232,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (21)
    CreateDynamicObject(982,2337.45092773,137.13200378,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (22)
    CreateDynamicObject(982,2350.73193359,148.96000671,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (23)
    CreateDynamicObject(982,2350.73901367,174.58599854,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (24)
    CreateDynamicObject(982,2350.73706055,200.20100403,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (25)
    CreateDynamicObject(982,2337.45092773,162.74699402,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (26)
    CreateDynamicObject(982,2337.44995117,188.36399841,25.96500015,0.00000000,0.00000000,0.00000000); //object(fenceshit) (27)
    CreateDynamicObject(984,2350.70703125,212.73899841,25.92099953,0.00000000,0.00000000,0.00000000); //object(fenceshit2) (3)
    CreateDynamicObject(982,2337.88891602,219.12399292,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit) (28)
    CreateDynamicObject(983,2335.84497070,203.95100403,25.96500015,0.00000000,0.00000000,30.00000000); //object(fenceshit3) (5)
    CreateDynamicObject(983,2331.01611328,206.71400452,25.96500015,0.00000000,0.00000000,90.00000000); //object(fenceshit3) (6)
    CreateDynamicObject(978,2237.61108398,211.73899841,14.80000019,0.00000000,355.75000000,342.00000000); //object(sub_roadright) (7)
    CreateDynamicObject(978,2222.47998047,216.80700684,14.59200001,0.00000000,357.74829102,346.49890137); //object(sub_roadright) (8)
    CreateDynamicObject(4514,1895.09997559,-6.09999990,35.50000000,1.99401855,0.00000000,161.44165039); //object(cn2_roadblock01ld) (9)
    CreateDynamicObject(972,2193.05810547,232.15899658,0.00000000,0.00000000,0.00000000,264.00000000); //object(tunnelentrance) (1)
    CreateDynamicObject(972,2168.30590820,234.76199341,0.00000000,0.00000000,0.00000000,263.99597168); //object(tunnelentrance) (2)
    CreateDynamicObject(972,2145.92797852,237.11000061,0.00000000,0.00000000,0.00000000,263.99597168); //object(tunnelentrance) (3)
    CreateDynamicObject(972,2296.88110352,506.83499146,0.00000000,0.00000000,0.00000000,0.00000000); //object(tunnelentrance) (4)
    CreateDynamicObject(972,2296.88110352,481.94299316,0.00000000,0.00000000,0.00000000,0.00000000); //object(tunnelentrance) (5)
    CreateDynamicObject(972,2296.88208008,457.05099487,0.00000000,0.00000000,0.00000000,0.00000000); //object(tunnelentrance) (6)
    CreateDynamicObject(972,2296.88208008,432.16000366,0.00000000,0.00000000,0.00000000,0.00000000); //object(tunnelentrance) (7)
    CreateDynamicObject(972,2296.87890625,407.26901245,0.00000000,0.00000000,0.00000000,0.00000000); //object(tunnelentrance) (8)
    CreateDynamicObject(972,441.38101196,595.23699951,0.00000000,0.00000000,0.00000000,214.75000000); //object(tunnelentrance) (9)
    CreateDynamicObject(972,455.57000732,574.77801514,0.00000000,0.00000000,0.00000000,214.74975586); //object(tunnelentrance) (11)
    CreateDynamicObject(972,469.75601196,554.33099365,0.00000000,0.00000000,0.00000000,214.74975586); //object(tunnelentrance) (12)
    CreateDynamicObject(972,486.40301514,529.31597900,0.00000000,0.00000000,0.00000000,214.74975586); //object(tunnelentrance) (13)
    CreateDynamicObject(972,500.58898926,508.86700439,0.00000000,0.00000000,0.00000000,214.74975586); //object(tunnelentrance) (14)
    CreateDynamicObject(972,514.77502441,488.41699219,0.00000000,0.00000000,0.00000000,214.74975586); //object(tunnelentrance) (15)
    CreateDynamicObject(972,531.97698975,463.57199097,0.00000000,0.00000000,0.00000000,214.74975586); //object(tunnelentrance) (16)
    CreateDynamicObject(972,546.16400146,443.11801147,0.00000000,0.00000000,0.00000000,214.74975586); //object(tunnelentrance) (17)
    CreateDynamicObject(972,560.34997559,422.66900635,0.00000000,0.00000000,0.00000000,214.74975586); //object(tunnelentrance) (18)
    CreateDynamicObject(972,577.25598145,398.21200562,0.00000000,0.00000000,0.00000000,214.74975586); //object(tunnelentrance) (19)
    CreateDynamicObject(1243,428.32000732,552.40301514,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (2)
    CreateDynamicObject(1243,472.99499512,487.75399780,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (11)
    CreateDynamicObject(1243,518.80297852,423.69799805,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (12)
    CreateDynamicObject(1243,2324.70092773,447.94500732,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (13)
    CreateDynamicObject(1243,2323.76489258,495.83599854,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (14)
    CreateDynamicObject(1243,1514.64855957,516.04803467,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (20)
    CreateDynamicObject(1243,1401.94299316,570.58502197,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (21)
    CreateDynamicObject(1243,1225.96496582,616.84600830,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (22)
    CreateDynamicObject(1243,999.72753906,629.68554688,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (23)
    CreateDynamicObject(1243,791.13800049,544.36901855,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (24)
    CreateDynamicObject(1243,662.84399414,556.36798096,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (25)
    CreateDynamicObject(1243,568.46398926,584.56597900,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (26)
    CreateDynamicObject(1238,385.87500000,665.95312500,12.53999996,0.00000000,0.00000000,0.00000000); //object(trafficcone) (8)
    CreateDynamicObject(1238,388.60000610,659.50000000,13.39999962,0.00000000,0.00000000,0.00000000); //object(trafficcone) (9)
    CreateDynamicObject(1238,395.20001221,645.90002441,15.00000000,0.00000000,0.00000000,0.00000000); //object(trafficcone) (10)
    CreateDynamicObject(1238,391.89999390,652.59997559,14.19999981,0.00000000,0.00000000,0.00000000); //object(trafficcone) (11)
    CreateDynamicObject(1238,444.15100098,725.82702637,6.03399992,0.00000000,0.00000000,0.00000000); //object(trafficcone) (12)
    CreateDynamicObject(1238,450.39001465,724.28302002,5.97200012,0.00000000,0.00000000,0.00000000); //object(trafficcone) (13)
    CreateDynamicObject(1238,457.40200806,722.05700684,5.24399996,0.00000000,0.00000000,359.75000000); //object(trafficcone) (14)
    CreateDynamicObject(1238,466.95117188,719.33105469,4.94399977,0.00000000,0.00000000,0.00000000); //object(trafficcone) (15)
    CreateDynamicObject(1237,428.39999390,734.50000000,5.19999981,0.00000000,0.00000000,356.00000000); //object(strtbarrier01) (8)
    CreateDynamicObject(1237,432.00000000,735.29980469,5.09999990,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(1237,1652.50000000,276.89999390,29.20000076,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (10)
    CreateDynamicObject(1237,1658.89941406,292.19921875,29.20000076,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (11)
    CreateDynamicObject(1237,1655.59997559,284.79998779,29.20000076,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (12)
    CreateDynamicObject(1237,1650.09997559,271.10000610,29.10000038,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (13)
    CreateDynamicObject(1237,1648.59997559,266.00000000,29.10000038,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (14)
    CreateDynamicObject(1237,1646.90002441,260.50000000,29.10000038,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (15)
    CreateDynamicObject(1237,1645.59997559,255.89999390,29.00000000,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (16)
    CreateDynamicObject(1237,1643.89941406,249.69921875,29.00000000,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (17)
    CreateDynamicObject(1237,1642.09997559,242.89999390,29.00000000,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (18)
    CreateDynamicObject(1237,1640.19995117,238.10000610,29.00000000,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (19)
    CreateDynamicObject(1237,1637.00000000,235.19999695,29.39999962,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (20)
    CreateDynamicObject(1237,1633.59997559,232.30000305,29.50000000,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (21)
    CreateDynamicObject(1237,1629.30004883,230.30000305,29.60000038,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (22)
    CreateDynamicObject(6458,1377.21801758,0.06834352,35.90000153,1.50000000,0.00000000,131.60815430); //object(pier03tr_law2) (1)
    CreateDynamicObject(978,1631.09997559,229.50000000,30.29999924,0.00000000,0.00000000,30.00000000); //object(sub_roadright) (6)
    CreateDynamicObject(978,1638.80004883,234.80000305,30.29999924,0.00000000,0.00000000,39.99816895); //object(sub_roadright) (9)
    CreateDynamicObject(19294,1311.69995117,-69.90000153,35.40000153,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (1)
    CreateDynamicObject(19294,1264.40002441,-109.00000000,37.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (2)
    CreateDynamicObject(19294,1225.69995117,-137.60000610,38.40000153,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (3)
    CreateDynamicObject(19294,1178.09997559,-166.19999695,39.59999847,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (4)
    CreateDynamicObject(19294,1159.40002441,-174.60000610,40.20000076,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (5)
    CreateDynamicObject(19294,1123.59997559,-185.50000000,40.90000153,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (6)
    CreateDynamicObject(19294,1092.19995117,-187.89999390,39.59999847,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (7)
    CreateDynamicObject(19294,1032.09997559,-184.60000610,27.29999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (8)
    CreateDynamicObject(19294,955.59997559,-179.39999390,10.50000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (9)
    CreateDynamicObject(19294,865.59997559,-172.50000000,15.10000038,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (10)
    CreateDynamicObject(1263,1372.08410645,-6.92360878,36.47158813,0.00000000,0.00000000,40.00000000); //object(mtraffic3) (1)
    CreateDynamicObject(19294,772.90002441,-164.89999390,17.50000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (11)
    CreateDynamicObject(19294,701.40002441,-158.89999390,21.29999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (12)
    CreateDynamicObject(3440,1372.44335938,-6.60336304,34.98579025,0.00000000,0.00000000,0.00000000); //object(arptpillar01_lvs) (1)
    CreateDynamicObject(19294,551.90002441,-143.50000000,35.59999847,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (13)
    CreateDynamicObject(19294,536.70001221,-141.00000000,36.79999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (14)
    CreateDynamicObject(19290,531.40002441,-150.69999695,36.90000153,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (1)
    CreateDynamicObject(19290,527.79998779,-150.30000305,36.90000153,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (2)
    CreateDynamicObject(19282,1372.07348633,-6.92550564,37.02200317,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_05) (2)
    CreateDynamicObject(19290,524.20001221,-149.69999695,36.79999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (4)
    CreateDynamicObject(19290,520.90002441,-149.39999390,36.90000153,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (5)	YellowLight[0] = CreateDynamicObject(19294,1371.87915039,-6.65784931,36.45655060,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (15)
    CreateDynamicObject(19294,1372.27380371,-7.14532137,36.44628906,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (16)
    CreateDynamicObject(19283,1371.89123535,-6.64106083,35.93982315,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_06) (1)
    CreateDynamicObject(19283,1372.26110840,-7.16716528,35.95397186,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_06) (2)
    CreateDynamicObject(19294,527.50000000,-130.30000305,36.79999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (17)
    CreateDynamicObject(19294,526.70001221,-139.60000610,36.90000153,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (18)
    CreateDynamicObject(19294,531.20001221,-72.30000305,33.59999847,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (19)
    CreateDynamicObject(19294,530.70001221,6.19999981,23.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (20)
    CreateDynamicObject(19294,527.50000000,68.09999847,19.89999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (21)
    CreateDynamicObject(19294,519.40002441,162.50000000,22.10000038,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (22)
    CreateDynamicObject(19294,513.40002441,222.80000305,12.69999981,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (23)
    CreateDynamicObject(19294,511.60000610,233.80000305,12.89999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (24)
    CreateDynamicObject(19294,524.79998779,245.39999390,13.50000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (25)
    CreateDynamicObject(19294,522.70001221,130.10000610,22.79999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (26)
    CreateDynamicObject(19290,506.89999390,237.60000610,12.80000019,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (6)
    CreateDynamicObject(19290,505.89999390,232.60000610,12.50000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (7)
    CreateDynamicObject(19290,504.39999390,225.89999390,12.19999981,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (8)
    CreateDynamicObject(19290,503.29998779,221.00000000,12.10000038,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (9)
    CreateDynamicObject(19294,557.09997559,271.79998779,15.69999981,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (27)
    CreateDynamicObject(19294,601.90002441,302.79998779,18.29999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (28)
    CreateDynamicObject(19294,620.29998779,308.70001221,18.89999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (29)
    CreateDynamicObject(19294,612.79998779,340.89999390,18.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (30)
    CreateDynamicObject(19294,592.90002441,369.29998779,18.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (31)
    CreateDynamicObject(19294,550.20001221,430.29998779,18.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (32)
    CreateDynamicObject(19294,509.50000000,488.39999390,18.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (33)
    CreateDynamicObject(19294,470.20001221,544.50000000,18.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (34)
    CreateDynamicObject(19294,429.79998779,602.09997559,17.89999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (35)
    CreateDynamicObject(19294,415.79998779,621.50000000,17.60000038,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (36)
    CreateDynamicObject(19294,406.39999390,633.40002441,16.50000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (37)
    CreateDynamicObject(19294,399.70001221,647.09997559,15.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (38)
    CreateDynamicObject(19294,391.20001221,663.29998779,12.89999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (39)
    CreateDynamicObject(19294,384.29998779,683.79998779,9.80000019,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (40)
    CreateDynamicObject(19294,387.79998779,704.90002441,7.09999990,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (41)
    CreateDynamicObject(19294,399.70001221,719.29998779,6.09999990,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (42)
    CreateDynamicObject(19294,423.39999390,725.79998779,6.09999990,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (43)
    CreateDynamicObject(19294,447.70001221,721.40002441,6.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (44)
    CreateDynamicObject(19294,466.39999390,714.90002441,4.90000010,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (45)
    CreateDynamicObject(1238,474.89999390,714.59997559,4.80000019,0.00000000,0.00000000,0.00000000); //object(trafficcone) (15)
    CreateDynamicObject(1238,480.10000610,711.40002441,4.80000019,0.00000000,0.00000000,0.00000000); //object(trafficcone) (15)
    CreateDynamicObject(1238,483.89999390,707.40002441,4.00000000,0.00000000,0.00000000,0.00000000); //object(trafficcone) (15)
    CreateDynamicObject(1238,486.20001221,702.50000000,4.00000000,0.00000000,0.00000000,0.00000000); //object(trafficcone) (15)
    CreateDynamicObject(19294,477.60000610,708.29998779,4.19999981,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (46)
    CreateDynamicObject(19296,490.29998779,695.20001221,3.70000005,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (2)
    CreateDynamicObject(19296,493.39941406,683.79980469,3.79999995,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (3)
    CreateDynamicObject(19296,502.79998779,672.50000000,2.29999995,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (4)
    CreateDynamicObject(19296,513.20001221,661.40002441,2.09999990,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (5)
    CreateDynamicObject(19296,527.79998779,649.59997559,1.39999998,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (6)
    CreateDynamicObject(19296,543.70001221,635.90002441,1.89999998,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (7)
    CreateDynamicObject(19296,503.70001221,621.70001221,2.40000010,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (8)
    CreateDynamicObject(19296,493.60000610,635.20001221,4.50000000,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (9)
    CreateDynamicObject(19296,479.50000000,653.70001221,7.80000019,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (10)
    CreateDynamicObject(10972,1314.98095703,-26.09948540,29.79182816,2.00000000,0.00000000,130.00000000); //object(landbit06_sfs) (1)
    CreateDynamicObject(19296,475.29998779,666.40002441,9.19999981,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (12)
    CreateDynamicObject(19296,472.79998779,680.79998779,9.10000038,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (13)
    CreateDynamicObject(19296,469.29998779,699.29998779,7.30000019,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (14)
    CreateDynamicObject(19291,2270.26855469,214.71336365,18.43461800,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (1)
    CreateDynamicObject(19291,2202.83374023,227.98321533,13.50797367,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (2)
    CreateDynamicObject(19291,2126.99658203,245.74011230,13.90760231,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (3)
    CreateDynamicObject(19291,2063.27758789,254.96353149,24.10000038,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (4)
    CreateDynamicObject(19291,2027.18237305,309.24411011,26.05913925,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (5)
    CreateDynamicObject(19291,1992.80725098,349.43795776,26.14269829,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (6)
    CreateDynamicObject(3819,1358.08203125,-10.55032253,33.90837479,0.00000000,0.00000000,131.00000000); //object(bleacher_sfsx) (1)
    CreateDynamicObject(19291,1920.46154785,354.48187256,19.54552078,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,2286.00000000,214.30000305,20.89999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (8)
    CreateDynamicObject(19296,1620.49755859,378.47500610,18.87889671,0.00000000,0.00000000,2.00000000); //object(dam_trellis01) (19)
    CreateDynamicObject(3819,1343.76538086,-22.82412148,34.17485428,0.00000000,0.00000000,130.99545288); //object(bleacher_sfsx) (2)
    CreateDynamicObject(19296,1617.42773438,384.95248413,18.94989586,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (20)
    CreateDynamicObject(19291,2301.60009766,213.89999390,23.20000076,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (9)
    CreateDynamicObject(19291,2322.50000000,213.80000305,25.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (10)
    CreateDynamicObject(19291,2333.69995117,213.80000305,25.50000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (11)
    CreateDynamicObject(19291,2333.69995117,91.69999695,25.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (12)
    CreateDynamicObject(19291,2343.89990234,100.09999847,25.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (13)
    CreateDynamicObject(19291,2343.89990234,204.19999695,25.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (14)
    CreateDynamicObject(19291,2304.10009766,91.80000305,25.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (15)
    CreateDynamicObject(19291,2294.00000000,82.59999847,25.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (16)
    CreateDynamicObject(19291,2293.89990234,41.59999847,25.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (17)
    CreateDynamicObject(19291,2283.39990234,41.70000076,25.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (18)
    CreateDynamicObject(19291,2176.50000000,41.70000076,25.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (19)
    CreateDynamicObject(19291,2126.39990234,41.70000076,25.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (20)
    CreateDynamicObject(19291,2044.90002441,40.50000000,27.10000038,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (21)
    CreateDynamicObject(19291,1969.30004883,40.00000000,31.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (22)
    CreateDynamicObject(19291,1907.09960938,43.29980469,33.59999847,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (23)
    CreateDynamicObject(19296,1901.09997559,36.09999847,33.70000076,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (21)
    CreateDynamicObject(19296,1906.79980469,35.59960938,33.59999847,0.00000000,0.00000000,0.00000000); //object(dam_trellis01) (22)
    CreateDynamicObject(19291,1850.09997559,54.20000076,34.70000076,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (24)
    CreateDynamicObject(19291,1783.00000000,88.19999695,33.29999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (25)
    CreateDynamicObject(19291,1716.80004883,117.59999847,31.20000076,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (26)
    CreateDynamicObject(19291,1657.09997559,131.60000610,29.60000038,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (27)
    CreateDynamicObject(19291,1614.40002441,131.80000305,28.89999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (28)
    CreateDynamicObject(19291,1550.09997559,116.50000000,28.39999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (29)
    CreateDynamicObject(19291,1489.30004883,81.69999695,29.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (30)
    CreateDynamicObject(19291,1445.40002441,47.40000153,30.20000076,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (31)
    CreateDynamicObject(19291,1421.09997559,27.00000000,31.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (32)
    CreateDynamicObject(3440,1382.39770508,-17.15348434,34.98579025,0.00000000,0.00000000,0.00000000); //object(arptpillar01_lvs) (2)
    CreateDynamicObject(1263,1381.91894531,-17.57171822,36.47158813,0.00000000,0.00000000,39.99572754); //object(mtraffic3) (2)
    CreateDynamicObject(19291,1411.40002441,18.50000000,31.29999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (37)
    CreateDynamicObject(19291,1399.09997559,7.80000019,31.79999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (38)
    CreateDynamicObject(19291,1390.40002441,0.10000000,32.09999847,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (39)
    CreateDynamicObject(19291,1384.40002441,-5.30000019,32.40000153,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_08) (40)
    CreateDynamicObject(19282,1381.86303711,-17.59430695,37.02560425,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_05) (3)
    CreateDynamicObject(19294,1363.69995117,-23.89999962,33.09999847,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (49)
    CreateDynamicObject(19294,1341.90002441,-43.40000153,34.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (50)
    CreateDynamicObject(19290,1244.52246094,-132.12191772,38.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (10)
    CreateDynamicObject(19290,1237.77294922,-136.97042847,38.20000076,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (11)
    CreateDynamicObject(19290,1228.21166992,-127.73475647,38.29999924,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (12)
    CreateDynamicObject(19290,1235.96557617,-122.14707184,38.09999847,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (13)
    CreateDynamicObject(19290,1187.50000000,-167.89941406,39.70000076,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (15)
    CreateDynamicObject(19290,1177.50000000,-173.30000305,39.59999847,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (16)
    CreateDynamicObject(19294,1381.68457031,-17.34179688,36.45655060,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (51)
    CreateDynamicObject(19294,1382.07299805,-17.80952454,36.45655060,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (52)
    CreateDynamicObject(19283,1381.70520020,-17.34021759,35.93982315,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_06) (3)
    CreateDynamicObject(19283,1382.10974121,-17.81896019,35.93982315,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_06) (4)
    CreateDynamicObject(19290,628.70001221,314.79998779,19.00000000,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (17)
    CreateDynamicObject(19290,628.40002441,305.50000000,18.89999962,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (18)
    CreateDynamicObject(1238,397.20001221,638.90002441,15.80000019,0.00000000,0.00000000,0.00000000); //object(trafficcone) (10)
    CreateDynamicObject(1237,446.20001221,741.50000000,4.59999990,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(1237,457.00000000,736.09997559,4.40000010,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(1237,465.79998779,731.40002441,4.30000019,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(1237,477.70001221,725.00000000,4.09999990,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(1237,489.10000610,718.59997559,3.59999990,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(1237,500.00000000,712.50000000,3.00000000,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(1237,508.89999390,707.90002441,2.70000005,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(1237,519.29998779,702.50000000,2.50000000,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(3819,1341.11376953,-19.77261734,35.35283279,0.00000000,0.00000000,130.99548340); //object(bleacher_sfsx) (4)
    CreateDynamicObject(1237,528.09997559,697.70001221,2.40000010,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(1237,436.10000610,746.09997559,4.59999990,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (9)
    CreateDynamicObject(3819,1355.43591309,-7.49881935,35.09508133,0.00000000,0.00000000,130.99548340); //object(bleacher_sfsx) (5)
    CreateDynamicObject(982,1357.07104492,-17.25417900,33.56475830,358.50000000,0.00000000,312.09967041); //object(fenceshit) (30)
    CreateDynamicObject(6299,1325.30004883,-22.60000038,35.47867584,0.25000000,0.00000000,312.00000000); //object(pier03c_law2) (3)
    CreateDynamicObject(982,1338.07177734,-34.41382980,34.22473145,358.49487305,0.00000000,312.09960938); //object(fenceshit) (31)
    CreateDynamicObject(1340,1352.68176270,-14.85619926,34.48946381,0.00000000,0.00000000,310.00000000); //object(chillidogcart) (1)
    CreateDynamicObject(1341,1348.98779297,-17.50388336,34.37113190,0.00000000,0.00000000,312.00000000); //object(icescart_prop) (1)
    CreateDynamicObject(1238,2226.69995117,52.70000076,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (21)
    CreateDynamicObject(1238,2221.19995117,52.70000076,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (22)
    CreateDynamicObject(983,1352.96362305,-6.73049688,33.52704239,0.00000000,0.00000000,311.24414062); //object(fenceshit3) (1)
    CreateDynamicObject(1238,2291.30004883,31.39999962,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (23)
    CreateDynamicObject(1238,2296.69995117,31.00000000,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (24)
    CreateDynamicObject(1238,2296.80004883,101.80000305,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (25)
    CreateDynamicObject(1238,2291.10009766,101.69999695,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (26)
    CreateDynamicObject(1238,2282.50000000,94.19999695,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (27)
    CreateDynamicObject(1238,2282.39990234,89.09999847,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (28)
    CreateDynamicObject(1238,2346.50000000,81.90000153,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (29)
    CreateDynamicObject(1238,2341.69995117,81.80000305,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (30)
    CreateDynamicObject(1238,2355.89990234,89.00000000,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (31)
    CreateDynamicObject(983,1354.81616211,-5.11696386,33.52704239,0.00000000,0.00000000,311.24267578); //object(fenceshit3) (7)
    CreateDynamicObject(1238,2356.00000000,94.40000153,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (32)
    CreateDynamicObject(1238,2351.60009766,221.80000305,25.79999924,0.00000000,0.00000000,0.00000000); //object(trafficcone) (33)
    CreateDynamicObject(1238,2346.60009766,221.80000305,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (34)
    CreateDynamicObject(1238,2341.39990234,221.69999695,25.70000076,0.00000000,0.00000000,0.00000000); //object(trafficcone) (35)
    CreateDynamicObject(1238,2336.10009766,221.60000610,25.79999924,0.00000000,0.00000000,0.00000000); //object(trafficcone) (36)
    CreateDynamicObject(3578,1635.09997559,204.30000305,31.60000038,0.00000000,356.00000000,256.00000000); //object(dockbarr1_la) (1)
    CreateDynamicObject(983,1340.50195312,-17.40074539,33.77911758,0.00000000,0.00000000,311.24267578); //object(fenceshit3) (8)
    CreateDynamicObject(983,1338.74194336,-18.93903542,33.77911758,0.00000000,0.00000000,311.24267578); //object(fenceshit3) (9)
    CreateDynamicObject(3578,1628.40002441,177.60000610,33.50000000,0.00000000,355.99548340,255.99792480); //object(dockbarr1_la) (3)
    CreateDynamicObject(3578,1622.09997559,150.10000610,35.29999924,0.00000000,357.24548340,255.99792480); //object(dockbarr1_la) (4)
    CreateDynamicObject(3578,1616.19995117,125.09999847,36.50000000,0.00000000,357.74548340,256.24792480); //object(dockbarr1_la) (5)
    CreateDynamicObject(3578,1611.09997559,102.80000305,37.20000076,0.00000000,358.99230957,259.24511719); //object(dockbarr1_la) (6)
    CreateDynamicObject(19281,1379.17272949,-13.77008438,32.60804367,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_04) (1)
    CreateDynamicObject(19281,1381.14025879,-15.87566471,32.67374039,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_04) (2)
    CreateDynamicObject(19281,1377.27941895,-11.72511292,32.59363937,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_04) (3)
    CreateDynamicObject(19281,1375.37219238,-9.69850445,32.60804367,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_04) (4)
    CreateDynamicObject(19281,1373.45947266,-7.65010881,32.68366623,0.00000000,0.00000000,0.00000000); //object(des_rockgp1_04) (5)
    CreateDynamicObject(13593,1226.96386719,-131.56047058,39.18489075,0.00000000,0.00000000,304.00000000); //object(kickramp03) (1)
    CreateDynamicObject(13593,1228.59558105,-133.84838867,39.18489075,0.00000000,0.00000000,304.00000000); //object(kickramp03) (2)
    CreateDynamicObject(13593,1230.22753906,-136.13740540,39.18489075,0.00000000,0.00000000,304.00000000); //object(kickramp03) (3)
    CreateDynamicObject(13593,1231.86279297,-138.43162537,39.18489075,0.00000000,0.00000000,304.00000000); //object(kickramp03) (8)
    CreateDynamicObject(2395,1234.64379883,-138.18786621,39.98243713,270.00000000,0.00000000,35.50000000); //object(cj_sports_wall) (1)
    CreateDynamicObject(2395,1237.68395996,-136.02029419,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (4)
    CreateDynamicObject(2395,1240.71142578,-133.86128235,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (5)
    CreateDynamicObject(2395,1243.74279785,-131.69804382,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (6)
    CreateDynamicObject(2395,1233.05676270,-135.95523071,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (7)
    CreateDynamicObject(2395,1231.46374512,-133.72789001,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (8)
    CreateDynamicObject(2395,1229.87573242,-131.50091553,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (9)
    CreateDynamicObject(2395,1236.09130859,-133.79112244,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (10)
    CreateDynamicObject(2395,1239.12597656,-131.62580872,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (11)
    CreateDynamicObject(2395,1242.16442871,-129.45945740,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (12)
    CreateDynamicObject(2395,1234.48950195,-131.57180786,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (13)
    CreateDynamicObject(2395,1237.52282715,-129.40554810,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (14)
    CreateDynamicObject(2395,1240.56054688,-127.23896027,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (15)
    CreateDynamicObject(2395,1232.91418457,-129.33605957,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (16)
    CreateDynamicObject(2395,1235.94848633,-127.17054749,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (17)
    CreateDynamicObject(2395,1238.97155762,-125.01242828,39.98243713,270.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (18)
    CreateDynamicObject(2395,1228.27050781,-129.26676941,39.82759094,90.00000000,0.00000000,35.49682617); //object(cj_sports_wall) (19)
    CreateDynamicObject(2395,1229.86291504,-131.49403381,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (20)
    CreateDynamicObject(2395,1231.44104004,-133.72525024,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (21)
    CreateDynamicObject(2395,1233.04370117,-135.94320679,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (22)
    CreateDynamicObject(2395,1236.08105469,-133.77931213,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (23)
    CreateDynamicObject(2395,1234.48413086,-131.55477905,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (24)
    CreateDynamicObject(2395,1232.88232422,-129.34120178,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (25)
    CreateDynamicObject(2395,1231.31030273,-127.09860229,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (26)
    CreateDynamicObject(2395,1239.11987305,-131.61271667,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (27)
    CreateDynamicObject(2395,1237.51843262,-129.38934326,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (28)
    CreateDynamicObject(2395,1235.91772461,-127.17696381,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (29)
    CreateDynamicObject(2395,1234.34838867,-124.93498993,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (30)
    CreateDynamicObject(2395,1242.15966797,-129.44618225,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (31)
    CreateDynamicObject(2395,1240.54821777,-127.22901154,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (32)
    CreateDynamicObject(2395,1238.95349121,-125.01226044,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (33)
    CreateDynamicObject(2395,1237.38659668,-122.76941681,39.82759094,90.00000000,0.00000000,35.49133301); //object(cj_sports_wall) (34)
    CreateDynamicObject(13593,1247.12622070,-127.55130768,39.18489075,0.00000000,0.00000000,124.08117676); //object(kickramp03) (9)
    CreateDynamicObject(13593,1245.48852539,-125.25905609,39.18489075,0.00000000,0.00000000,124.07958984); //object(kickramp03) (10)
    CreateDynamicObject(13593,1243.84863281,-122.96822357,39.18489075,0.00000000,0.00000000,124.07958984); //object(kickramp03) (11)
    CreateDynamicObject(13593,1242.21081543,-120.68141937,39.18489075,0.00000000,0.00000000,124.07958984); //object(kickramp03) (12)
    CreateDynamicObject(13593,1250.23327637,-125.32739258,37.68794250,0.00000000,0.00000000,124.07958984); //object(kickramp03) (13)
    CreateDynamicObject(13593,1248.60021973,-123.02887726,37.68794250,0.00000000,0.00000000,124.07958984); //object(kickramp03) (14)
    CreateDynamicObject(13593,1246.96215820,-120.74058533,37.68794250,0.00000000,0.00000000,124.07958984); //object(kickramp03) (15)
    CreateDynamicObject(13593,1245.31970215,-118.45389557,37.68794250,0.00000000,0.00000000,124.07958984); //object(kickramp03) (16)
    CreateDynamicObject(1243,1580.72167969,463.60757446,-3.03999996,0.00000000,0.00000000,0.00000000); //object(bouy) (20)
    CreateDynamicObject(19291,1865.65686035,362.96926880,18.82431412,0.00000000,0.00000000,0.03598022); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1818.66699219,378.43087769,17.85864830,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1761.18579102,386.35049438,18.47410583,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1690.43566895,383.41589355,18.82682419,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1643.70422363,381.48718262,18.82682419,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1637.87426758,381.53488159,18.82682419,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1632.38757324,387.55447388,18.98158836,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1628.65234375,392.25024414,19.24072838,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1622.05908203,400.48059082,18.32905006,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1617.23034668,408.30358887,17.09870338,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1610.45092773,417.59417725,11.86670399,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(19291,1602.63073730,428.42898560,5.28950977,0.00000000,0.00000000,0.03295898); //object(des_rockgp1_08) (7)
    CreateDynamicObject(4514,1603.46447754,382.51486206,20.70309448,0.00000000,0.00000000,90.00000000); //object(cn2_roadblock01ld) (8)
    CreateDynamicObject(978,542.46954346,-18.04142952,27.50287628,0.00000000,6.71554565,92.27474976); //object(sub_roadright) (1)
    CreateDynamicObject(13593,759.37060547,-159.90351868,18.23757172,0.00000000,0.00000000,83.50000000); //object(kickramp03) (17)
    CreateDynamicObject(13593,759.11865234,-162.70718384,18.23757172,0.00000000,0.00000000,83.49609375); //object(kickramp03) (18)
    CreateDynamicObject(13593,758.87396240,-165.51321411,18.23757172,0.00000000,0.00000000,83.49609375); //object(kickramp03) (19)
    CreateDynamicObject(13593,758.62786865,-168.31132507,18.23757172,0.00000000,0.00000000,83.49609375); //object(kickramp03) (20)
    CreateDynamicObject(2395,753.40679932,-168.97236633,19.31986237,275.00000000,90.00000000,84.99575806); //object(cj_sports_wall) (38)
    CreateDynamicObject(2395,753.64447021,-166.24247742,19.31986237,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (44)
    CreateDynamicObject(2395,753.88250732,-163.51423645,19.31986237,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (45)
    CreateDynamicObject(2395,754.11944580,-160.79084778,19.31986237,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (46)
    CreateDynamicObject(2395,750.41284180,-160.47082520,19.64378738,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (47)
    CreateDynamicObject(2395,750.17724609,-163.19024658,19.64378738,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (48)
    CreateDynamicObject(2395,749.94140625,-165.91787720,19.64378738,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (49)
    CreateDynamicObject(2395,749.70404053,-168.64562988,19.64378738,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (50)
    CreateDynamicObject(2395,746.00347900,-168.31997681,19.96771240,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (51)
    CreateDynamicObject(2395,742.30029297,-168.00073242,20.29163742,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (52)
    CreateDynamicObject(2395,738.60058594,-167.67472839,20.61750412,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (53)
    CreateDynamicObject(2395,734.89617920,-167.34950256,20.94142914,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (54)
    CreateDynamicObject(2395,731.19799805,-167.02210999,21.26895332,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (55)
    CreateDynamicObject(2395,746.24896240,-165.59417725,19.96771240,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (56)
    CreateDynamicObject(2395,746.47814941,-162.86547852,19.96771240,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (57)
    CreateDynamicObject(2395,746.71136475,-160.14460754,19.96771240,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (58)
    CreateDynamicObject(2395,742.55096436,-165.26969910,20.29163742,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (59)
    CreateDynamicObject(2395,742.78540039,-162.54159546,20.29163742,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (60)
    CreateDynamicObject(2395,743.01824951,-159.82035828,20.29163742,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (61)
    CreateDynamicObject(2395,738.84826660,-164.94473267,20.61750412,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (62)
    CreateDynamicObject(2395,739.09210205,-162.21798706,20.61750412,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (63)
    CreateDynamicObject(2395,739.31292725,-159.49699402,20.61750412,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (64)
    CreateDynamicObject(2395,735.15301514,-164.62036133,20.94142914,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (65)
    CreateDynamicObject(2395,735.39471436,-161.89471436,20.94142914,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (66)
    CreateDynamicObject(2395,735.61492920,-159.17164612,20.94142914,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (67)
    CreateDynamicObject(2395,731.45959473,-164.29637146,21.26895332,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (68)
    CreateDynamicObject(2395,731.70330811,-161.57127380,21.26895332,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (69)
    CreateDynamicObject(2395,731.92626953,-158.84843445,21.26895332,274.99877930,90.00000000,84.99023438); //object(cj_sports_wall) (70)
    CreateDynamicObject(13593,728.92053223,-165.40640259,20.51248169,0.00000000,0.00000000,263.50000000); //object(kickramp03) (21)
    CreateDynamicObject(13593,729.16534424,-162.60049438,20.51248169,0.00000000,0.00000000,263.49609375); //object(kickramp03) (22)
    CreateDynamicObject(13593,729.40979004,-159.79277039,20.51248169,0.00000000,0.00000000,263.49609375); //object(kickramp03) (23)
    CreateDynamicObject(13593,729.65466309,-156.98504639,20.51248169,0.00000000,0.00000000,263.49609375); //object(kickramp03) (24)
    CreateDynamicObject(13593,725.09997559,-165.07157898,19.01939583,0.00000000,0.00000000,263.49609375); //object(kickramp03) (25)
    CreateDynamicObject(13593,725.34753418,-162.26496887,19.01939583,0.00000000,0.00000000,263.49609375); //object(kickramp03) (26)
    CreateDynamicObject(13593,725.59570312,-159.45715332,19.01939583,0.00000000,0.00000000,263.49609375); //object(kickramp03) (27)
    CreateDynamicObject(13593,725.84002686,-156.65565491,19.01939583,0.00000000,0.00000000,263.49609375); //object(kickramp03) (28)
    CreateDynamicObject(19290,731.21258545,-167.67280579,19.04887581,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (3)
    CreateDynamicObject(19290,740.65850830,-168.47946167,18.47329330,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (14)
    CreateDynamicObject(19290,754.35333252,-157.36750793,17.79305077,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (19)
    CreateDynamicObject(19290,746.85742188,-156.68003845,18.12417412,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_15) (20)
    CreateDynamicObject(979,1192.88769531,-167.03207397,40.40443039,0.00000000,0.49438477,29.55325317); //object(sub_roadleft) (6)
    CreateDynamicObject(979,1201.18444824,-162.15435791,40.17036057,0.00000000,0.49438477,29.55322266); //object(sub_roadleft) (6)
    CreateDynamicObject(979,1172.42773438,-179.72413635,40.54487228,0.00000000,0.49438477,23.55322266); //object(sub_roadleft) (6)
    CreateDynamicObject(979,1164.40002441,-185.10000610,41.00000000,0.00000000,3.99438477,45.54919434); //object(sub_roadleft) (6)
    CreateDynamicObject(979,529.70001221,-151.50000000,37.59999847,0.00000000,0.00000000,354.00000000); //object(sub_roadleft) (6)
    CreateDynamicObject(979,520.09997559,-150.60000610,37.59999847,0.00000000,0.00000000,354.00000000); //object(sub_roadleft) (6)
    CreateDynamicObject(3380,522.29022217,-84.51228333,35.06051636,0.00000000,0.00000000,180.00000000); //object(ce_hairpinl) (1)
    CreateDynamicObject(3380,539.48345947,-84.78335571,34.75442505,0.00000000,0.00000000,179.99450684); //object(ce_hairpinl) (2)
    CreateDynamicObject(19294,539.47601318,-84.78713226,37.64322281,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (47)
    CreateDynamicObject(19294,522.28625488,-84.52374268,37.97215271,0.00000000,0.00000000,0.00000000); //object(des_rockgp2_16) (48)
    CreateDynamicObject(1238,468.29418945,718.14990234,4.82880116,0.00000000,0.00000000,0.00000000); //object(trafficcone) (15)
}
