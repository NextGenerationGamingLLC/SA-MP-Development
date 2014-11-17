/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						News Group Type

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

CMD:tognews(playerid, params[])
{
	if (!gNews[playerid])
	{
		gNews[playerid] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have disabled news chat.");
	}
	else
	{
		gNews[playerid] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have enabled news chat.");
	}
	return 1;
}

CMD:news(playerid, params[])
{
	if (IsAReporter(playerid))
	{
		new string[128];
		if(shutdown == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "The news system is currently shut down." );
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /news [text]");

		new newcar = GetPlayerVehicleID(playerid);
		if(IsANewsCar(newcar) || IsPlayerInRangeOfPoint(playerid,15.0, 647.5820,1.6036,1101.2821) || IsPlayerInRangeOfPoint(playerid,6.0, 660.2643,-1.8796,1101.2395) || IsPlayerInRangeOfPoint(playerid,15.0, 650.5955,-28.9854,1101.2126))
		{
			if(PlayerInfo[playerid][pRank] < 1)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You must be at least rank 1.");
			}
			else
			{
				format(string, sizeof(string), "NR %s: %s", GetPlayerNameEx(playerid), params);
				OOCNews(COLOR_NEWS,string);
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You're not in a news van or chopper or in the studio.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not a News Reporter!");
	}
	return 1;
}

CMD:watchtv(playerid, params[])
{
	for(new i; i < MAX_HOUSES; i++)
	{
		if(WatchingTV[playerid] != 0 || (IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW]))
		{
			if(broadcasting == 0) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Nothings on TV!");

			new string[128];
			if(WatchingTV[playerid] == 0)
			{
				format(string, sizeof(string), "* %s starts watching TV", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /watchtv again to stop watching TV");
				BroadcastLastVW[playerid] = GetPlayerVirtualWorld(playerid);
				BroadcastLastInt[playerid] = GetPlayerInterior(playerid);
				GetPlayerPos(playerid, BroadcastFloats[playerid][1], BroadcastFloats[playerid][2], BroadcastFloats[playerid][3]);
				GetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);

				WatchingTV[playerid] = 1;
				viewers++;
				UpdateSANewsBroadcast();

				TogglePlayerControllable(playerid, false);
				SetPlayerInterior(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid, 648.9558,7.4022,1104.8258);

				switch(broadcaststudio)
				{
					case 1:
					{
						switch(cameraangle)
						{
							case 0:
							{
								SetPlayerCameraPos(playerid, 651.7099, -23.5688, 1101.6589);
								SetPlayerCameraLookAt(playerid, 651.6790, -24.5670, 1101.5894);
							}
							case 1:
							{
								SetPlayerCameraPos(playerid, 647.0847, -24.2731, 1101.7302);
								SetPlayerCameraLookAt(playerid, 647.7896, -24.9810, 1101.6757);
							}
							case 2:
							{
								SetPlayerCameraPos(playerid, 653.3759, -24.5380, 1101.6094);
								SetPlayerCameraLookAt(playerid, 652.9409, -25.4370, 1101.5249);
							}
						}
					}
					case 2:
					{
						switch(cameraangle)
						{
							case 0:
							{
								SetPlayerCameraPos(playerid, 647.3672, -3.6455, 1102.5767);
								SetPlayerCameraLookAt(playerid, 647.4997, -2.6562, 1102.3917);
							}
							case 1:
							{
								SetPlayerCameraPos(playerid, 651.5222, -2.8707, 1102.1970);
								SetPlayerCameraLookAt(playerid, 650.9796, -2.0328, 1102.0521);
							}
							case 2:
							{
								SetPlayerCameraPos(playerid, 642.5612, -2.0504, 1102.3726);
								SetPlayerCameraLookAt(playerid, 643.2610, -1.3387, 1102.2280);
							}
						}
					}
					case 3:
					{
						switch(cameraangle)
						{
							case 0:
							{
								SetPlayerCameraPos(playerid, 661.6169, -1.8129, 1103.3221);
								SetPlayerCameraLookAt(playerid, 660.6224, -1.9017, 1102.5270);
							}
							case 1:
							{
								SetPlayerCameraPos(playerid, 660.9686, 0.9339, 1103.2574);
								SetPlayerCameraLookAt(playerid, 660.5128, 0.0453, 1102.8682);
							}
							case 2:
							{
								SetPlayerCameraPos(playerid, 660.8921, -4.4156, 1103.3365);
								SetPlayerCameraLookAt(playerid, 660.3720, -3.5629, 1102.8322);
							}
						}
					}
				}
				return 1;
			}
			else
			{
				SetPlayerPos(playerid,BroadcastFloats[playerid][1],BroadcastFloats[playerid][2],BroadcastFloats[playerid][3]);
				SetPlayerVirtualWorld(playerid, BroadcastLastVW[playerid]);
				PlayerInfo[playerid][pVW] = BroadcastLastVW[playerid];
				SetPlayerInterior(playerid, BroadcastLastInt[playerid]);
				PlayerInfo[playerid][pInt] = BroadcastLastInt[playerid];
				SetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);
				SetCameraBehindPlayer(playerid);
				Player_StreamPrep(playerid, BroadcastFloats[playerid][1],BroadcastFloats[playerid][2],BroadcastFloats[playerid][3], FREEZE_TIME);

				WatchingTV[playerid] = 0;
				viewers--;
				UpdateSANewsBroadcast();

				format(string, sizeof(string), "* %s stops watching TV", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				return 1;
			}
		}
	}
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You must be in a house!");
	return 1;
}

CMD:cameraangle(playerid, params[])
{
	if (IsAReporter(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid,15.0, 647.5820,1.6036,1101.2821) || IsPlayerInRangeOfPoint(playerid,6.0, 660.2643,-1.8796,1101.2395) || IsPlayerInRangeOfPoint(playerid,15.0, 650.5955,-28.9854,1101.2126))
		{
			if(broadcasting == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Not currently broadcasting!");
				return 1;
			}

			new string[128], choice[32];
			if(sscanf(params, "s[32]", choice))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /cameraangle [location]");
				SendClientMessageEx(playerid, COLOR_GRAD1, "Locations: Center,Left,Right");
				return 1;
			}

			if(strcmp(choice,"center",true) == 0)
			{
				format(string, sizeof(string), "** %s changes the camera angle to the center **", GetPlayerNameEx(playerid));
				SendGroupMessage(4, RADIO, string);
				cameraangle = 0;
				//DestroyDynamic3DTextLabel(camera);
				//camera = CreateDynamic3DTextLabel("*The Camera*",COLOR_RED,635.6883,-11.1890,1108.6041,13.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
			}
			else if(strcmp(choice,"left",true) == 0)
			{
				format(string, sizeof(string), "** %s changes the camera angle to the left **", GetPlayerNameEx(playerid));
				SendGroupMessage(4, RADIO, string);
				cameraangle = 2;
				//DestroyDynamic3DTextLabel(camera);
				//camera = CreateDynamic3DTextLabel("*The Camera*",COLOR_RED,637.9041,-8.3097,1107.9656,13.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
			}
			else if(strcmp(choice,"right",true) == 0)
			{
				format(string, sizeof(string), "** %s changes the camera angle to the right **", GetPlayerNameEx(playerid));
				SendGroupMessage(4, RADIO, string);
				cameraangle = 1;
				//DestroyDynamic3DTextLabel(camera);
				//camera = CreateDynamic3DTextLabel("*The Camera*",COLOR_RED,638.6522,-15.6267,1107.9656,13.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Unrecognized camera angle");
				return 1;
			}
			//foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(WatchingTV[i] == 1)
					{
						switch(broadcaststudio)
						{
							case 1:
							{
								switch(cameraangle)
								{
									case 0:
									{
										SetPlayerCameraPos(i, 651.7099, -23.5688, 1101.6589);
										SetPlayerCameraLookAt(i, 651.6790, -24.5670, 1101.5894);
									}
									case 1:
									{
										SetPlayerCameraPos(i, 647.0847, -24.2731, 1101.7302);
										SetPlayerCameraLookAt(i, 647.7896, -24.9810, 1101.6757);
									}
									case 2:
									{
										SetPlayerCameraPos(i, 653.3759, -24.5380, 1101.6094);
										SetPlayerCameraLookAt(i, 652.9409, -25.4370, 1101.5249);
									}
								}
							}
							case 2:
							{
								switch(cameraangle)
								{
									case 0:
									{
										SetPlayerCameraPos(i, 647.3672, -3.6455, 1102.5767);
										SetPlayerCameraLookAt(i, 647.4997, -2.6562, 1102.3917);
									}
									case 1:
									{
										SetPlayerCameraPos(i, 651.5222, -2.8707, 1102.1970);
										SetPlayerCameraLookAt(i, 650.9796, -2.0328, 1102.0521);
									}
									case 2:
									{
										SetPlayerCameraPos(i, 642.5612, -2.0504, 1102.3726);
										SetPlayerCameraLookAt(i, 643.2610, -1.3387, 1102.2280);
									}
								}
							}
							case 3:
							{
								switch(cameraangle)
								{
									case 0:
									{
										SetPlayerCameraPos(i, 661.6169, -1.8129, 1103.3221);
										SetPlayerCameraLookAt(i, 660.6224, -1.9017, 1102.5270);
									}
									case 1:
									{
										SetPlayerCameraPos(i, 660.9686, 0.9339, 1103.2574);
										SetPlayerCameraLookAt(i, 660.5128, 0.0453, 1102.8682);
									}
									case 2:
									{
										SetPlayerCameraPos(i, 660.8921, -4.4156, 1103.3365);
										SetPlayerCameraLookAt(i, 660.3720, -3.5629, 1102.8322);
									}
								}
							}
						}
					}
				}	
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Not in the studio!");
		}
	}
	return 1;
}

CMD:stopnews(playerid, params[])
{
	if(IsAReporter(playerid) && (PlayerInfo[playerid][pRank] >= 5 || arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == 4))
	{
	    if(shutdown == 0)
	    {
	        shutdown = 1;
	        SendClientMessageEx(playerid, COLOR_WHITE, "You have just shutdown the whole news system and are ending anything in progres..." );
	        if(broadcasting == 1)
	        {
	            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Broadcasting has just been shutdown..");
				broadcasting = 0;
				UpdateSANewsBroadcast();
				DestroyDynamic3DTextLabel(camera);
	            //foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						if(WatchingTV[i] == 1)
						{
							SetPlayerPos(i,BroadcastFloats[i][1],BroadcastFloats[i][2],BroadcastFloats[i][3]);
							SetPlayerVirtualWorld(i, BroadcastLastVW[i]);
							PlayerInfo[i][pInt] = BroadcastLastVW[i];
							SetPlayerInterior(i, BroadcastLastInt[i]);
							PlayerInfo[i][pInt] = BroadcastLastInt[i];
							SetPlayerFacingAngle(i, BroadcastFloats[i][0]);
							SetCameraBehindPlayer(i);
							WatchingTV[i] = 0;
							viewers = 0;
							UpdateSANewsBroadcast();
							Player_StreamPrep(i, BroadcastFloats[i][1],BroadcastFloats[i][2],BroadcastFloats[i][3], FREEZE_TIME);
						}
					}	
				}
	        }
	        //foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(TalkingLive[i] != INVALID_PLAYER_ID)
					{
						SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Live conversation ended.");
						SendClientMessageEx(TalkingLive[i], COLOR_LIGHTBLUE, "* Live conversation ended.");
						TogglePlayerControllable(i, 1);
						TogglePlayerControllable(TalkingLive[i], 1);
						TalkingLive[TalkingLive[i]] = INVALID_PLAYER_ID;
						TalkingLive[i] = INVALID_PLAYER_ID;
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Live has just been shutdown..");
						return 1;
					}
				}	
	        }
	    }
	    else
	    {
	        shutdown = 0;
	        SendClientMessageEx(playerid, COLOR_WHITE, "You have just turned on the news system. " );
	    }
	}
	return 1;
}

CMD:liveban(playerid, params[])
{
	if (IsAReporter(playerid))
	{
	    new giveplayerid,
	        string[128];

	    if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /liveban [player]");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected.");
	    if(PlayerInfo[giveplayerid][pLiveBanned] == 0)
	    {
	        PlayerInfo[giveplayerid][pLiveBanned] = 1;
	        format(string, sizeof(string), "%s has interview banned %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	        SendGroupMessage(4, RADIO, string);
	        return 1;
	    }
	    else SendClientMessageEx(playerid, COLOR_WHITE, "That player is already live banned.");
	}
	return 1;
}

CMD:liveunban(playerid, params[])
{
	new string[128],
		giveplayerid;
		
	if(IsAReporter(playerid) && PlayerInfo[playerid][pRank] >= 7)
	{
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /liveban [player]");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected.");
		if(PlayerInfo[giveplayerid][pLiveBanned] == 1)
		{
			PlayerInfo[giveplayerid][pLiveBanned] = 0;
			format(string, sizeof(string), "%s has unbanned %s from interviews", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
			SendGroupMessage(4, RADIO, string);
		}
		else SendClientMessageEx(playerid, COLOR_WHITE, "That player is currently not live banned");
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You must be at least Rank 7 to use this command");
	
	return 1;
}

CMD:broadcast(playerid, params[])
{
	if (IsAReporter(playerid))
	{
	    if(shutdown == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "The news system is currently shut down." );
		if(IsPlayerInRangeOfPoint(playerid,15.0, 647.5820,1.6036,1101.2821) || IsPlayerInRangeOfPoint(playerid,6.0, 660.2643,-1.8796,1101.2395) || IsPlayerInRangeOfPoint(playerid,15.0, 650.5955,-28.9854,1101.2126))
		{
			new string[128];
			if(broadcasting == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Now broadcasting LIVE");
				broadcasting = 1;
				cameraangle = 0;
				
				if(IsPlayerInRangeOfPoint(playerid,15.0, 647.5820,1.6036,1101.2821)) broadcaststudio = 2;
				else if(IsPlayerInRangeOfPoint(playerid,6.0, 660.2643,-1.8796,1101.2395)) broadcaststudio = 3;
				else if(IsPlayerInRangeOfPoint(playerid,15.0, 650.5955,-28.9854,1101.2126)) broadcaststudio = 1;
				
				UpdateSANewsBroadcast();
				format(string, sizeof(string), "%s will now broadcast LIVE from the studio! /watchtv to tune in!", GetPlayerNameEx(playerid));
				OOCNews(COLOR_NEWS,string);
				//camera = CreateDynamic3DTextLabel("*The Camera*",COLOR_RED,635.6883,-11.1890,1108.6041,13.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
				return 1;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* No longer broadcasting");
				broadcasting = 0;
				broadcaststudio = 0;
				UpdateSANewsBroadcast();
				//DestroyDynamic3DTextLabel(camera);
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						if(WatchingTV[i] == 1)
						{
							SetPlayerPos(i,BroadcastFloats[i][1],BroadcastFloats[i][2],BroadcastFloats[i][3]);
							SetPlayerVirtualWorld(i, BroadcastLastVW[i]);
							PlayerInfo[i][pInt] = BroadcastLastVW[i];
							SetPlayerInterior(i, BroadcastLastInt[i]);
							PlayerInfo[i][pInt] = BroadcastLastInt[i];
							SetPlayerFacingAngle(i, BroadcastFloats[i][0]);
							SetCameraBehindPlayer(i);
							WatchingTV[i] = 0;
							viewers = 0;
							UpdateSANewsBroadcast();
							Player_StreamPrep(i, BroadcastFloats[i][1],BroadcastFloats[i][2],BroadcastFloats[i][3], FREEZE_TIME);
						}
					}	
				}
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You aren't in the studio!");
		}
	}
	return 1;
}

CMD:live(playerid, params[])
{
	if(IsAReporter(playerid) && PlayerInfo[playerid][pRank] > 0)
	{
	    if(shutdown == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "The news system is currently shut down." );
		if(TalkingLive[playerid] != INVALID_PLAYER_ID)
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Live conversation ended.");
			SendClientMessageEx(TalkingLive[playerid], COLOR_LIGHTBLUE, "* Live conversation ended.");
			TogglePlayerControllable(playerid, 1);
			TogglePlayerControllable(TalkingLive[playerid], 1);
			DeletePVar(playerid, "IsLive");
			DeletePVar(TalkingLive[playerid], "IsLive");
			TalkingLive[TalkingLive[playerid]] = INVALID_PLAYER_ID;
			TalkingLive[playerid] = INVALID_PLAYER_ID;
			return 1;
		}

		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /live [player]");

		if (IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(5.0, playerid, giveplayerid))
			{
			    if(PlayerInfo[giveplayerid][pLiveBanned] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "That person is interview banned.");
				if(PlayerCuffed[giveplayerid] >= 1 || PlayerCuffed[playerid] >= 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "You are unable to do this right now.");
				}
				else
				{
					if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot talk live with yourself!"); return 1; }
					format(string, sizeof(string), "* You offered %s to have a live conversation.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* %s offered you to have a live conversation, type /accept live to accept.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					LiveOffer[giveplayerid] = playerid;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
				return 1;
			}

		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not a News Reporter!");
	}
	return 1;
}
