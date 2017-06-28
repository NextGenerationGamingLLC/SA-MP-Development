/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Craftsman System

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)

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

CMD:pc(playerid, params[])
{
	if(PlayerInfo[playerid][pSurveillance] > 0)
	{
		if(GetPVarInt(playerid, "cameraactive") == 1)
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Wait for your other camera to expire.");
			return 1;
		}

		new string[128];
		PlayerInfo[playerid][pSurveillance]--;
		SendClientMessageEx(playerid, COLOR_GRAD1, "You placed your camera, go hide and use /sc. Batteries expire in 2 minutes.");
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);
		SetPVarInt(playerid, "cameraactive", 1);
		DestroyDynamic3DTextLabel(Camera3D[playerid]);
		Camera3D[playerid] = CreateDynamic3DTextLabel("** A small camera. **",0x008080FF,X,Y,Z,4.0,.worldid = GetPlayerVirtualWorld(playerid));
		SetPVarFloat(playerid, "cameraX", X);
		SetPVarFloat(playerid, "cameraY", Y);
		SetPVarFloat(playerid, "cameraZ", Z);
		SetPVarInt(playerid, "cameravw", GetPlayerVirtualWorld(playerid));
		SetPVarInt(playerid, "cameraint", GetPlayerInterior(playerid));
		SetPVarInt(playerid, "cameraexpire", SetTimerEx("cameraexpire", 120000, 0, "d", playerid));
		format(string, sizeof(string), "* %s places something on the ground.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a surveillance camera!");
	}
	return 1;
}

CMD:sc(playerid, params[])
{
	if(GetPVarInt(playerid, "cameraactive") == 1)
	{
		new string[128];
		if(GetPVarInt(playerid, "camerasc") == 1)
		{
			SetCameraBehindPlayer(playerid); //view cam off
			SetPlayerPos(playerid, GetPVarFloat(playerid, "cameraX2"), GetPVarFloat(playerid, "cameraY2"), GetPVarFloat(playerid, "cameraZ2"));
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "cameravw2"));
			SetPlayerInterior(playerid, GetPVarInt(playerid, "cameraint2"));
			TogglePlayerControllable(playerid,1);
			DeletePVar(playerid, "camerasc");
			KillTimer(GetPVarInt(playerid, "cameraexpire"));
		}
		else
		{
			format(string, sizeof(string), "* %s stares into a small screen.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			format(string, sizeof(string), "The camera will expire in a maximum of 2 minutes. (( %s ))", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SetPVarFloat(playerid, "cameraX2", X);
			SetPVarFloat(playerid, "cameraY2", Y);
			SetPVarFloat(playerid, "cameraZ2", Z);
			SetPVarInt(playerid, "cameravw2", GetPlayerVirtualWorld(playerid));
			SetPVarInt(playerid, "cameraint2", GetPlayerInterior(playerid));

			TogglePlayerControllable(playerid,0);
			SetPlayerPos(playerid, GetPVarFloat(playerid, "cameraX"), GetPVarFloat(playerid, "cameraY"), GetPVarFloat(playerid, "cameraZ") - 30.0);
			SetPlayerCameraPos(playerid, GetPVarFloat(playerid, "cameraX"), GetPVarFloat(playerid, "cameraY"), GetPVarFloat(playerid, "cameraZ") + 20.0); //viewcam on
			SetPlayerCameraLookAt(playerid, GetPVarFloat(playerid, "cameraX"), GetPVarFloat(playerid, "cameraY"), GetPVarFloat(playerid, "cameraZ"));
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "cameravw"));
			SetPlayerInterior(playerid, GetPVarInt(playerid, "cameraint"));
			SetPVarInt(playerid, "camerasc", 1);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You have no active camera!");
	}
	return 1;
}

CMD:dc(playerid, params[])
{
	if(GetPVarInt(playerid, "cameraactive") == 1)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, GetPVarFloat(playerid, "cameraX"), GetPVarFloat(playerid, "cameraY"), GetPVarFloat(playerid, "cameraZ"))) {
			SendClientMessageEx(playerid, COLOR_WHITE, "You are not near your camera.");
			return 1;
		}

		if(GetPVarInt(playerid, "camerasc") == 1)
		{
			SetCameraBehindPlayer(playerid);
			SetPlayerPos(playerid, GetPVarFloat(playerid, "cameraX2"), GetPVarFloat(playerid, "cameraY2"), GetPVarFloat(playerid, "cameraZ2"));
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "cameravw2"));
			SetPlayerInterior(playerid, GetPVarInt(playerid, "cameraint2"));
			TogglePlayerControllable(playerid,1);
		}

		DestroyDynamic3DTextLabel(Camera3D[playerid]);
		SendClientMessageEx(playerid, COLOR_GRAD1, "Camera Destroyed!");
		KillTimer(GetPVarInt(playerid, "cameraexpire"));
		DeletePVar(playerid, "cameraexpire");
		DeletePVar(playerid, "cameraactive");
		DeletePVar(playerid, "camerasc");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "There is nothing to destroy!");
	}
	return 1;
}

CMD:rccam(playerid, params[])
{
	if(PlayerInfo[playerid][pRccam] > 0)
	{
		new string[128];
		if(GetPVarInt(playerid, "rccam") == 0)
		{
			if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
			if(GetPVarInt(playerid, "WatchingTV")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
			if(GetPVarInt(playerid, "Injured") == 1 || PlayerInfo[playerid][pHospital] > 0 || IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
			if(PlayerInfo[playerid][pVW] != 0 || PlayerInfo[playerid][pInt] != 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
			if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must be on foot to place an RCCam!");
			if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot use this while in prison.");

			PlayerInfo[playerid][pRccam]--;
			SetPVarInt(playerid, "rccam", 1);
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SetPVarFloat(playerid, "rcX", X);
			SetPVarFloat(playerid, "rcY", Y);
			SetPVarFloat(playerid, "rcZ", Z);
			if(GetPVarInt(playerid, "rcveh") != 0)
			{
				DestroyVehicle(GetPVarInt(playerid, "rcveh"));
			}
			SetPVarInt(playerid, "rcveh", AddStaticVehicle(594, X, Y, Z, 0, 0, 0));
			IsPlayerEntering{playerid} = true;
			PutPlayerInVehicle(playerid, GetPVarInt(playerid, "rcveh"), 0);
			SetPVarInt(playerid, "rccamtimer", SetTimerEx("rccam", 60000, 0, "d", playerid));
			format(string, sizeof(string), "* %s places something on the ground.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			DestroyVehicle(GetPVarInt(playerid, "rcveh"));
			SetPlayerPos(playerid, GetPVarFloat(playerid, "rcX"), GetPVarFloat(playerid, "rcY"), GetPVarFloat(playerid, "rcZ"));
			DeletePVar(playerid, "rccam");
			KillTimer(GetPVarInt(playerid, "rccamtimer"));
		}
	}
	else
	{
		if(GetPVarInt(playerid, "rccam") == 1)
		{
			DestroyVehicle(GetPVarInt(playerid, "rcveh"));
			SetPlayerPos(playerid, GetPVarFloat(playerid, "rcX"), GetPVarFloat(playerid, "rcY"), GetPVarFloat(playerid, "rcZ"));
			DeletePVar(playerid, "rccam");
			KillTimer(GetPVarInt(playerid, "rccamtimer"));
			return 1;
		}
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have an RC Cam!");
	}
	return 1;
}

CMD:firstaid(playerid, params[])
{
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
	if(GetPVarType(playerid, "IsInArena"))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
		return 1;
	}
	if(GetPVarInt(playerid, "Injured") == 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
		return 1;
	}
	if(PlayerInfo[playerid][pFirstaid] > 0)
	{
		if(GetPVarInt(playerid, "usingfirstaid") == 0)
		{
			new string[128];
			PlayerInfo[playerid][pFirstaid]--;
			SetPVarInt(playerid, "firstaid5", SetTimerEx("firstaid5", 5000, 1, "d", playerid));
			SetPVarInt(playerid, "firstaidexpire", SetTimerEx("firstaidexpire",10*60000, 0, "d", playerid));
			SetPVarInt(playerid, "usingfirstaid", 1);
			format(string, sizeof(string), "* %s uses a first aid kit.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "You're already using first aid!");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a first aid kit!");
	}
	return 1;
}

CMD:sweep(playerid, params[])
{
	if(PlayerInfo[playerid][pSweep] > 0)
	{
		if(PlayerInfo[playerid][pSweepLeft] > 0)
		{
			new string[128], giveplayerid;
			if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sweep [player]");

			if(!ProxDetectorS(4.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be close to the person.");
			PlayerInfo[playerid][pSweepLeft]--;
			format(string, sizeof(string), "* %s sweeps a large wand around %s's body...", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			if(PlayerInfo[giveplayerid][pBugged] != INVALID_GROUP_ID)
			{
				format(string, sizeof(string), "* A small spark is seen as the bug on %s shorts out.", GetPlayerNameEx(giveplayerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				format(string, sizeof(string), "(bug) %s: *static*", GetPlayerNameEx(giveplayerid));
				SendBugMessage(giveplayerid, PlayerInfo[giveplayerid][pBugged], string);
				PlayerInfo[giveplayerid][pBugged] = INVALID_GROUP_ID;
			}
			else
			{
				ProxDetector(30.0, playerid, "Nothing happens.", COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Your Bug Sweeper has ran out of batteries!");
			PlayerInfo[playerid][pSweep]--;
			PlayerInfo[playerid][pSweepLeft] = 3;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a bug sweep!");
	}
	return 1;
}

CMD:gps(playerid, params[])
{
	if(PlayerInfo[playerid][pGPS] > 0)
	{
		new string[128];
		if(GetPVarInt(playerid, "gpsonoff") == 0)
		{
			format(string, sizeof(string), "* %s turns on their GPS.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "gpsonoff", 1);
			PlayerTextDrawSetString(playerid, GPS[playerid], "Loading...");
			PlayerTextDrawShow(playerid, GPS[playerid]);
		}
		else
		{
			format(string, sizeof(string), "* %s turns off their GPS.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			DeletePVar(playerid, "gpsonoff");
			PlayerTextDrawHide(playerid, GPS[playerid]);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a GPS!");
	}
	return 1;
}

CMD:ww(playerid, params[])
{
	return cmd_wristwatch(playerid, params);
}

CMD:wristwatch(playerid, params[])
{
	if(PlayerInfo[playerid][pWristwatch] > 0)
	{
		new string[128];
		if(GetPVarInt(playerid, "wristwatchonoff") == 0)
		{
			SetPVarInt(playerid, "wristwatchonoff", 1);
			TextDrawShowForPlayer(playerid, WristWatch);
			format(string, sizeof(string), "* %s turns on their wristwatch.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			KillTimer(GetPVarInt(playerid, "wristwatchtimer"));
			TextDrawHideForPlayer(playerid, WristWatch);
			DeletePVar(playerid, "wristwatchonoff");
			format(string, sizeof(string), "* %s turns off their wristwatch.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a wristwatch!");
	}
	return 1;
}

CMD:receiver(playerid, params[])
{
	if(PlayerInfo[playerid][pReceiver] > 0)
	{
		if(!GetPVarType(playerid, "pReceiverOn"))
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "You've turned on your receiver.");
			SetPVarInt(playerid, "pReceiverOn", 1);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "You've turned off your receiver.");
			DeletePVar(playerid, "pReceiverOn");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a receiver.");
	}
	return 1;
}

CMD:smslog(playerid, params[])
{
	if(PlayerInfo[playerid][pSmslog] > 0) GetSMSLog(playerid);
	else return SendClientMessageEx(playerid, COLOR_YELLOW, "    You don't have a SMS log!");
	return 1;
}

CMD:craft(playerid, params[])
{
	if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
	if (PlayerInfo[playerid][pJob] != 18 && PlayerInfo[playerid][pJob2] != 18 && PlayerInfo[playerid][pJob3] != 18)
	{
		SendClientMessageEx(playerid,COLOR_GREY,"   You are not a Craftsman!");
		return 1;
	}
	if (PlayerInfo[playerid][pJailTime] > 0)
	{
		SendClientMessageEx(playerid,COLOR_GREY,"   You can not make things while in jail or prison!");
		return 1;
	}
	new string[128];
	if (GetPVarInt(playerid, "ArmsTimer") > 0)
	{
		format(string, sizeof(string), "   You must wait %d seconds before crafting again.", GetPVarInt(playerid, "ArmsTimer"));
		SendClientMessageEx(playerid,COLOR_GREY,string);
		return 1;
	}
	if(PlayerInfo[playerid][pHospital] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You can't craft while in the Hospital.");
		return 1;
	}
	new giveplayerid, choice[32], weapon, price;
	if(sscanf(params, "us[32]", giveplayerid, choice))
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
		SendClientMessageEx(playerid, COLOR_YELLOW, "<< Available crafts >>");
		SendClientMessageEx(playerid, COLOR_GRAD1, "screwdriver(1,000)	 smslog(2,000)");
		SendClientMessageEx(playerid, COLOR_GRAD2, "wristwatch(500)	 surveillance(8,000)");
		SendClientMessageEx(playerid, COLOR_GRAD1, "tire(250)	         lock(500)");
		SendClientMessageEx(playerid, COLOR_GRAD2, "firstaid(1,000)	 camera(250)");
		SendClientMessageEx(playerid, COLOR_GRAD1, "rccam(8,000)	     receiver(5,000)");
		SendClientMessageEx(playerid, COLOR_GRAD2, "gps(1,000)          bugsweep(10,000)");
		//SendClientMessageEx(playerid, COLOR_GRAD1, "parachute(50)          bag(6000)");
		SendClientMessageEx(playerid, COLOR_GRAD1, "parachute(50)		mailbox(15,000)");
		SendClientMessageEx(playerid, COLOR_GRAD2, "metaldetector(12,500) syringe(500)");
		SendClientMessageEx(playerid, COLOR_GRAD1, "closet(3,000)		toolbox(12,000)");
		SendClientMessageEx(playerid, COLOR_GRAD2, "crowbar(7,000)      flowers(25)");
		SendClientMessageEx(playerid, COLOR_GRAD1, "knuckles(100)        baseballbat(100)");
		SendClientMessageEx(playerid, COLOR_GRAD2, "cane (100)           shovel(100)");
		SendClientMessageEx(playerid, COLOR_GRAD1, "poolcue (100)        katana(300)");
		SendClientMessageEx(playerid, COLOR_GRAD2, "dildo (300)          spraycan(2000)");
		SendClientMessageEx(playerid, COLOR_GRAD2, "rimkit (400000)");
		SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /craft [player] [craftname]");
		return 1;
	}
	if(IsPlayerConnected(giveplayerid))
	{
		if(HungerPlayerInfo[giveplayerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   This person is not able to receive anything at the moment.");
		if(isnull(choice))
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
			SendClientMessageEx(playerid, COLOR_YELLOW, "<< Available crafts >>");
			SendClientMessageEx(playerid, COLOR_GRAD1, "screwdriver(1,000)	 smslog(2,000)");
			SendClientMessageEx(playerid, COLOR_GRAD2, "wristwatch(500)	 surveillance(8,000)");
			SendClientMessageEx(playerid, COLOR_GRAD1, "tire(250)	         lock(500)");
			SendClientMessageEx(playerid, COLOR_GRAD2, "firstaid(1,000)	 camera(250)");
			SendClientMessageEx(playerid, COLOR_GRAD1, "rccam(8,000)	     receiver(5,000)");
			SendClientMessageEx(playerid, COLOR_GRAD2, "gps(1,000)          bugsweep(10,000)");
			//SendClientMessageEx(playerid, COLOR_GRAD1, "parachute(50)          bag(6000)");
			SendClientMessageEx(playerid, COLOR_GRAD1, "parachute(50)		mailbox(15,000)");
			SendClientMessageEx(playerid, COLOR_GRAD2, "metaldetector(12,500) syringe(500)");
			SendClientMessageEx(playerid, COLOR_GRAD1, "closet(3,000)		toolbox(12,000)");
			SendClientMessageEx(playerid, COLOR_GRAD2, "crowbar(7,000)      flowers(25)");
			SendClientMessageEx(playerid, COLOR_GRAD1, "knuckles(100)        baseballbat(100)");
			SendClientMessageEx(playerid, COLOR_GRAD2, "cane (100)           shovel(100)");
			SendClientMessageEx(playerid, COLOR_GRAD1, "poolcue (100)        katana(300)");
			SendClientMessageEx(playerid, COLOR_GRAD2, "dildo (300)          spraycan(2000)");
			SendClientMessageEx(playerid, COLOR_GRAD2, "rimkit (400000)");
			SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /craft [player] [craftname]");
			return 1;
		}
		/*if(strcmp(choice,"bag",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 6000)
			{
				price = 6000;
				weapon = 14;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}*/
		if(strcmp(choice, "screwdriver", true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 1000)
			{
				price = 1000;
				weapon = 1;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "smslog", true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 2000)
			{
				price = 2000;
				weapon = 2;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "wristwatch", true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 500)
			{
				price = 500;
				weapon = 3;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "surveillance", true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 8000)
			{
				price = 8000;
				weapon = 4;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "tire", true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 250)
			{
				price = 250;
				weapon = 5;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "lock", true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 500)
			{
				price = 500;
				weapon = 6;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "firstaid", true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 1000)
			{
				price = 1000;
				weapon = 7;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice,"camera",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 250)
			{
				price = 250;
				weapon = 8;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice,"rccam",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 8000)
			{
				price = 8000;
				weapon = 9;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice,"receiver",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 5000)
			{
				price = 5000;
				weapon = 10;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice,"gps",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 1000)
			{
				price = 1000;
				weapon = 11;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}

		else if(strcmp(choice,"bugsweep",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 10000)
			{
				price = 10000;
				weapon = 12;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}

		else if(strcmp(choice,"parachute",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 50)
			{
				price = 50;
				weapon = 13;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}

        else if(strcmp(choice,"metaldetector",true) == 0)
		{
			/*if(PlayerInfo[playerid][pMats] >= 12500)
			{
				price = 12500;
				weapon = 14;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}*/
			return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot craft this right now!");
		}

		else if(strcmp(choice,"mailbox",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 15000)
			{
				price = 15000;
				weapon = 15;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
        else if(strcmp(choice,"syringe",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 500)
			{
				price = 500;
				weapon = 16;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice,"closet",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 3000)
			{
				price = 3000;
				weapon = 17;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice,"toolbox",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 12000)
			{
				price = 12000;
				weapon = 18;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice,"crowbar",true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 7000)
			{
				price = 7000;
				weapon = 19;
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that!");
				return 1;
			}
		}
		/*     
				// added post ammo release
				flowers (25)
				knuckles (100)
				baseballbat (100)
				cane (100)
				shovel (100)
				poolcue (100)
				katana (300)
				dildo (300)
		*/

		else if(strcmp(choice, "flowers", true) == 0) {
			if(PlayerInfo[playerid][pMats] >= 25) {
				price = 25;
				weapon = 20;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "   Not enough materials for that!");
		}
		else if(strcmp(choice, "knuckles", true) == 0) {
			if(PlayerInfo[playerid][pMats] >= 100) {
				price = 100;
				weapon = 21;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "   Not enough materials for that!");
		}
		else if(strcmp(choice, "baseballbat", true) == 0) {
			if(PlayerInfo[playerid][pMats] >= 100) {
				price = 100;
				weapon = 22;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "   Not enough materials for that!");
		}
		else if(strcmp(choice, "cane", true) == 0) {
			if(PlayerInfo[playerid][pMats] >= 100) {
				price = 100;
				weapon = 23;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "   Not enough materials for that!");
		}
		else if(strcmp(choice, "shovel", true) == 0) {
			if(PlayerInfo[playerid][pMats] >= 100) {
				price = 100;
				weapon = 24;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "   Not enough materials for that!");
		}
		else if(strcmp(choice, "poolcue", true) == 0) {
			if(PlayerInfo[playerid][pMats] >= 100) {
				price = 100;
				weapon = 25;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "   Not enough materials for that!");
		}
		else if(strcmp(choice, "katana", true) == 0) {
			if(PlayerInfo[playerid][pMats] >= 300) {
				price = 300;
				weapon = 26;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "   Not enough materials for that!");
		}
		else if(strcmp(choice, "dildo", true) == 0) {
			if(PlayerInfo[playerid][pMats] >= 300) {
				price = 300;
				weapon = 27;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "   Not enough materials for that!");
		}
		else if(strcmp(choice, "spraycan", true) == 0) {
			if(PlayerInfo[playerid][pMats] >= 2000) {
				price = 2000;
				weapon = 28;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "   Not enough materials for that!");
		}

		else if(strcmp(choice, "rimkit", true) == 0) {
			if(PlayerInfo[playerid][pMats] >= 400000) {
				price = 400000;
				weapon = 29;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "   Not enough materials for that!");
		}

		else { SendClientMessageEx(playerid,COLOR_GREY,"   Invalid Craft name!"); return 1; }
		if (ProxDetectorS(5.0, playerid, giveplayerid))
		{
			if(weapon == 17)
			{
				if(PlayerInfo[giveplayerid][pPhousekey] == INVALID_HOUSE_ID && PlayerInfo[giveplayerid][pPhousekey2] == INVALID_HOUSE_ID && PlayerInfo[giveplayerid][pPhousekey3] == INVALID_HOUSE_ID)
				{
					if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house!");
					else
					{
						SendClientMessageEx(playerid, COLOR_GREY, "They don't own a house!");
						SendClientMessageEx(giveplayerid, COLOR_GREY, "You don't own a house!");
					}
				}
			}
			if(giveplayerid == playerid)
			{
				if(weapon != 16 && weapon != 17)
				{
					PlayerInfo[playerid][pMats] -= price;
				}

				switch(weapon)
				{
				case 1:
					{
						PlayerInfo[playerid][pScrewdriver]++;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/sellgun");
					}
				case 2:
					{
						PlayerInfo[playerid][pSmslog]++;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/smslog");
					}
				case 3:
					{
						PlayerInfo[playerid][pWristwatch]++;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/wristwatch");
					}
				case 4:
					{
						PlayerInfo[playerid][pSurveillance]++;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/(p)lace(c)amera /(s)ee(c)amera /(d)estroy(c)amera");
					}
				case 5:
					{
						PlayerInfo[playerid][pTire]++;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/repair");
					}
				case 6:
					{
						PlayerInfo[playerid][pLock]=1;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/lock");
					}
				case 7:
					{
						PlayerInfo[playerid][pFirstaid]++;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/firstaid");
					}
				case 8:
					{
						GivePlayerValidWeapon(playerid, 43);
					}
				case 9:
					{
						PlayerInfo[playerid][pRccam]++;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/rccam");
					}
				case 10:
					{
						PlayerInfo[playerid][pReceiver]++;
						SetPVarInt(playerid, "pReceiverMLeft", 4);
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "You will receive the next four department radio messages.");
					}
				case 11:
					{
						PlayerInfo[playerid][pGPS] = 1;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/gps");
					}
				case 12:
					{
						PlayerInfo[playerid][pSweep]++;
						PlayerInfo[playerid][pSweepLeft] = 3;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/sweep");
					}
				case 13:
					{
						GivePlayerValidWeapon(playerid, 46);
					}
				case 14:
					{
						if(PlayerInfo[playerid][pTreasureSkill] >=0 && PlayerInfo[playerid][pTreasureSkill] <= 24) PlayerInfo[playerid][pMetalDetector] += 25;
						else if(PlayerInfo[playerid][pTreasureSkill] >=25 && PlayerInfo[playerid][pTreasureSkill] <= 149) PlayerInfo[playerid][pMetalDetector] += 50;
						else if(PlayerInfo[playerid][pTreasureSkill] >=150 && PlayerInfo[playerid][pTreasureSkill] <= 299) PlayerInfo[playerid][pMetalDetector] += 75;
						else if(PlayerInfo[playerid][pTreasureSkill] >=300 && PlayerInfo[playerid][pTreasureSkill] <= 599) PlayerInfo[playerid][pMetalDetector] += 100;
						else if(PlayerInfo[playerid][pTreasureSkill] >=600) PlayerInfo[playerid][pMetalDetector] += 125;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/search");
					}
				case 15:
					{
						PlayerInfo[playerid][pMailbox]++;
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "Type /placemailbox where you want mailbox to be at.");
					}
				case 16:
					{
						if(PlayerInfo[playerid][pSyringes] < 3)
						{
							PlayerInfo[playerid][pMats] -= price;
							PlayerInfo[playerid][pSyringes]++;
							SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/usedrug heroin");
						}
						else
						{
							return SendClientMessageEx(playerid, COLOR_GREY, "You can't hold anymore syringes.");
						}
					}
				case 17:
					{
						if(GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntIW])
						{
							if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorZ]))
							{
								GetPlayerPos(playerid, HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetZ]);
								if(IsValidDynamic3DTextLabel(HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetTextID])) DestroyDynamic3DTextLabel(Text3D:HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetTextID]);
								HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntVW], .interiorid = HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntIW], .streamdistance = 10.0);
								SaveHouse(PlayerInfo[playerid][pPhousekey]);
								PlayerInfo[playerid][pMats] -= price;
								SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/closet(add/remove)");

								szMiscArray[0] = 0;
								format(szMiscArray, sizeof(szMiscArray), "%s(%d) has placed a closet for their house (House ID: %d) at X: %f | Y: %f | Z: %f", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pPhousekey], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetZ]);
  								Log("logs/house.log", szMiscArray);
							}
							else return SendClientMessageEx(playerid, COLOR_GREY, "You aren't inside of your house!");
						}
						else if(GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntIW])
						{
							if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorZ]))
							{
								GetPlayerPos(playerid, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetZ]);
								if(IsValidDynamic3DTextLabel(HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetTextID])) DestroyDynamic3DTextLabel(Text3D:HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetTextID]);
								HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntVW], .interiorid = HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntIW], .streamdistance = 10.0);
								SaveHouse(PlayerInfo[playerid][pPhousekey2]);
								PlayerInfo[playerid][pMats] -= price;
								SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/closet(add/remove)");

								szMiscArray[0] = 0;
								format(szMiscArray, sizeof(szMiscArray), "%s(%d) has placed a closet for their house (House ID: %d) at X: %f | Y: %f | Z: %f", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pPhousekey2], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetZ]);
  								Log("logs/house.log", szMiscArray);
							}
							else return SendClientMessageEx(playerid, COLOR_GREY, "You aren't inside of your house!");
						}
						else if(GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntIW])
						{
							if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorZ]))
							{
								GetPlayerPos(playerid, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetZ]);
								if(IsValidDynamic3DTextLabel(HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetTextID])) DestroyDynamic3DTextLabel(Text3D:HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetTextID]);
								HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntVW], .interiorid = HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntIW], .streamdistance = 10.0);
								SaveHouse(PlayerInfo[playerid][pPhousekey3]);
								PlayerInfo[playerid][pMats] -= price;
								SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "/closet(add/remove)");

								szMiscArray[0] = 0;
								format(szMiscArray, sizeof(szMiscArray), "%s(%d) has placed a closet for their house (House ID: %d) at X: %f | Y: %f | Z: %f", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pPhousekey3], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetZ]);
  								Log("logs/house.log", szMiscArray);
							}
							else return SendClientMessageEx(playerid, COLOR_GREY, "You aren't inside of your house!");
						}
						else return SendClientMessageEx(playerid, COLOR_GREY, "You aren't inside of your house!");
					}
				case 18:
					{
						PlayerInfo[playerid][pToolBox] += 15;
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /pickveh(icle) in any car to attempt to lock pick it.");
					}
				case 19:
					{
						PlayerInfo[playerid][pCrowBar] += 25;
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /cracktrunk in any car that you already lock picked to attempt to open the trunk.");
					}
				case 20: GivePlayerValidWeapon(playerid, WEAPON_FLOWER);
				case 21: GivePlayerValidWeapon(playerid, WEAPON_BRASSKNUCKLE);
				case 22: GivePlayerValidWeapon(playerid, WEAPON_BAT);
				case 23: GivePlayerValidWeapon(playerid, WEAPON_CANE);
				case 24: GivePlayerValidWeapon(playerid, WEAPON_SHOVEL);	
				case 25: GivePlayerValidWeapon(playerid, WEAPON_POOLSTICK);
				case 26: GivePlayerValidWeapon(playerid, WEAPON_KATANA);
				case 27: GivePlayerValidWeapon(playerid, WEAPON_DILDO);
				case 28: GivePlayerValidWeapon(playerid, WEAPON_SPRAYCAN);
				case 29: {
					PlayerInfo[playerid][pRimMod]++;
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /userimkit as a mechanic in any car to modify your rims.");
				}
				
				}
				format(string, sizeof(string), "   You have given yourself a %s.", choice);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				SendClientMessageEx(playerid, COLOR_GRAD1, string);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				switch( PlayerInfo[playerid][pSex] )
				{
					case 1: format(string, sizeof(string), "* %s created something from Materials, and hands it to himself.", GetPlayerNameEx(playerid));
					case 2: format(string, sizeof(string), "* %s created something from Materials, and hands it to herself.", GetPlayerNameEx(playerid));
				}
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
			format(string, sizeof(string), "* You offered %s to buy a %s.", GetPlayerNameEx(giveplayerid), choice);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* Craftsman %s wants to sell you a %s, (type /accept craft) to buy.", GetPlayerNameEx(playerid), choice);
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			CraftOffer[giveplayerid] = playerid;
			CraftId[giveplayerid] = weapon;
			CraftMats[giveplayerid] = price;
			format(CraftName[giveplayerid], 50, "%s", choice);
			if(PlayerInfo[playerid][pAdmin] < 3)
			{
				SetPVarInt(playerid, "ArmsTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_ARMSTIMER);
			}
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
		return 1;
	}
}
