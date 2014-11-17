/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Hospital System

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

CMD:insurehelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** INSURANCE HELP *** - type a command for more infomation.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** INSURANCE *** /buyinsurance");
    SendClientMessageEx(playerid, COLOR_LIGHTRED,"*** INSURANCE *** ALL SAINTS: $1,500 + Transfer (One Time) Fee of $2,500");
    SendClientMessageEx(playerid, COLOR_LIGHTRED,"*** INSURANCE *** COUNTY: $1,500 + Transfer (One Time) Fee of $2,500");
    SendClientMessageEx(playerid, COLOR_LIGHTRED,"*** INSURANCE *** RED COUNTY: $500 + Transfer (One Time) Fee of $2,500");
    SendClientMessageEx(playerid, COLOR_LIGHTRED,"*** INSURANCE *** SAN FIERRO: $500 + Transfer (One Time) Fee of $2,500");
    SendClientMessageEx(playerid, COLOR_LIGHTRED,"*** INSURANCE *** FORT CARSON: $250");
    return 1;
}

CMD:setinsurance(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 4)
	{
		new string[128], giveplayerid, insurance;
		if(sscanf(params, "ud", giveplayerid, insurance))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setinsurance [player] [insurance]");
			format(string, sizeof(string), "Available Insurances: 0 - %d", MAX_HOSPITALS-1);
			SendClientMessageEx(playerid, COLOR_GRAD2, string);
			return 1;
		}

		if(insurance >= 0 && insurance <= MAX_HOSPITALS-1)
		{
			format(string, sizeof(string), " Your insurance has been changed to %s.", GetHospitalName(insurance));
			SendClientMessageEx(giveplayerid,COLOR_YELLOW,string);
			format(string, sizeof(string), " You have changed %s's insurance to %s.", GetPlayerNameEx(giveplayerid), GetHospitalName(insurance));
			SendClientMessageEx(playerid,COLOR_YELLOW,string);
			PlayerInfo[giveplayerid][pInsurance] = insurance;
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:healme(playerid, params[])
{
	if (IsPlayerInRangeOfPoint(playerid, 2.0, 1179.4012451172,-1331.5632324219,2423.0461425781))//2103.3252,2824.2102,-16.1672
	{
		if(GetPVarType(playerid, "STD"))
		{
			DeletePVar(playerid, "STD");
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are no longer infected with a STD anymore because of the Hospital's help!");
			GivePlayerCash(playerid, -1000);
			SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Doc: Your medical bill contained $1000,-. Have a nice day!");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   You Don't have a STD to heal!");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not at a Hospital!");
	}
	return 1;
}

CMD:buyinsurance(playerid, params[])
{
	new string[128],
		iHospitalVW = GetPlayerVirtualWorld(playerid),
		file[32], 
		month, 
		day, 
		year;
		
	getdate(year,month,day);
	
	if(IsPlayerInRangeOfPoint(playerid, 2.00, 2383.0728,2662.0520,8001.1479)) // all regular hospital points
	{
		if(iHospitalVW >= MAX_HOSPITALS) return SendClientMessageEx(playerid, -1, "No hospital has been setup for this Virtual World!");
		if(PlayerInfo[playerid][pInsurance] == iHospitalVW) return SendClientMessageEx(playerid, -1, "You already have insurance at this hospital!");
		PlayerInfo[playerid][pInsurance] = iHospitalVW;
		format(string, sizeof(string), "Medical: You have purchased insurance at %s for $%d.", GetHospitalName(iHospitalVW), HospitalSpawnInfo[iHospitalVW][1]);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		GivePlayerCash(playerid, - HospitalSpawnInfo[iHospitalVW][1]);
		Tax += HospitalSpawnInfo[iHospitalVW][1];
		format(string, sizeof(string), "%s has purchased their medical insurance for $%d", GetPlayerNameEx(playerid), HospitalSpawnInfo[iHospitalVW][0]);
		format(file, sizeof(file), "grouppay/0/%d-%d-%d.log", month, day, year);
		Log(file, string);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 2.00, 555.8644,1485.1359,6000.4258)) // doc hospital purchase point
	{
		PlayerInfo[playerid][pInsurance] = HOSPITAL_DOCJAIL;
		format(string, sizeof(string), "Medical: You have purchased insurance at %s for $%d.", GetHospitalName(HOSPITAL_DOCJAIL), HospitalSpawnInfo[HOSPITAL_DOCJAIL][1]);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		GivePlayerCash(playerid, - HospitalSpawnInfo[HOSPITAL_DOCJAIL][1]);
		Tax += HospitalSpawnInfo[HOSPITAL_DOCJAIL][1];
		format(string, sizeof(string), "%s has purchased their medical insurance for $%d", GetPlayerNameEx(playerid), HospitalSpawnInfo[iHospitalVW][0]);
		format(file, sizeof(file), "grouppay/0/%d-%d-%d.log", month, day, year);
		Log(file, string);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "ERROR: You are not in range of a hospital counter.");
	return 1;
}

CMD:kill(playerid, params[])
{
	if(!IsPlayerConnected(playerid)) return SendClientMessageEx (playerid, COLOR_GRAD2, "You cannot do this at this time.");
	else if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
    else if(GetPVarInt( playerid, "EventToken" ) == 1 || PlayerInfo[playerid][pBeingSentenced] != 0 || GetPVarInt(playerid, "Injured") != 0 || GetPVarInt(playerid, "IsFrozen") != 0 || PlayerCuffed[playerid] != 0 || PlayerTied[playerid] != 0 || PlayerInfo[playerid][pHospital] != 0 || PlayerInfo[playerid][pJailTime] != 0) return SendClientMessageEx (playerid, COLOR_GRAD2, "You cannot do this at this time.");
	else
	{
		if(GetPVarInt(playerid, "EventToken") >= 1 || GetPVarInt(playerid, "IsInArena") >= 0)
		{
		    if(GetPVarInt(playerid, "IsInArena") >= 0)
		    {
				if(PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbGameType] == 3)
				{
				    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
				    {
				        SendClientMessageEx(playerid, COLOR_WHITE, "You can not kill yourself while holding a flag.");
				        return 1;
				    }
				}
		    }
			ResetPlayerWeapons(playerid);
		}
		
		if(GetPVarInt(playerid, "commitSuicide") == 1) {
		    return SendClientMessageEx(playerid, COLOR_GRAD2, "You have already requested to commit suicide.");
		}
		else {
			SetTimerEx("killPlayer", 10000, false, "i", playerid);
			SetPVarInt(playerid, "commitSuicide", 1);
			SendClientMessageEx(playerid, COLOR_YELLOW, "You requested to commit suicide, please wait 10 seconds...");
		}
	}
	return 1;
}