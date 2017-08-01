/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						VIP Core

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
stock IsVIPcar(carid)
{
	for(new i = 0; i < sizeof(VIPVehicles); i++)
	{
		if(carid == VIPVehicles[i]) return 1;
	}
	return 0;
}

stock IsVIPModel(carid)
{
	new Cars[] = { 451, 411, 429, 522, 444, 556, 557 };
	for(new i = 0; i < sizeof(Cars); i++)
	{
		if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}


stock GetVIPRankName(i)
{
	new string[128];
	switch(i)
	{
		case 1:
		{
			format(string, sizeof(string), "Bronze VIP");
		}
		case 2:
		{
			format(string, sizeof(string), "Silver VIP");
		}
		case 3:
		{
			format(string, sizeof(string), "Gold VIP");
		}
		case 4:
		{
			format(string, sizeof(string), "Platinum VIP");
		}
		default:
		{
			format(string, sizeof(string), "VIP Moderator");
		}
	}
	return string;
}

stock SendVIPMessage(color, string[])
{
	foreach(new i: Player)
	{
		if((PlayerInfo[i][pDonateRank] >= 1 || PlayerInfo[i][pAdmin] >= 2 || PlayerInfo[i][pVIPMod]) && PlayerInfo[i][pToggledChats][9] == 0) {
			ChatTrafficProcess(i, color, string, 9);
		}
	}
}

CMD:vipdate(playerid, params[]) {
	new giveplayerid;
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    giveplayerid = playerid;
	}
	else
	{
	    if(sscanf(params, "u", giveplayerid)) giveplayerid = playerid;
	}
	if(1 <= PlayerInfo[giveplayerid][pDonateRank] <= 4 && !PlayerInfo[giveplayerid][pBuddyInvited])
	{
	    new string[128];
	    new drank[20];
		switch(PlayerInfo[giveplayerid][pDonateRank])
		{
			case 1: drank = "Bronze";
			case 2: drank = "Silver";
			case 3: drank = "Gold";
			case 4: drank = "Platinum";
		}
	    new datestring[32];
		datestring = date(PlayerInfo[giveplayerid][pVIPExpire], 4);
		if(PlayerInfo[giveplayerid][pVIPExpire] == 0) format(string, sizeof(string), "* Your %s VIP subscription is not set to expire.", drank);
		else format(string, sizeof(string), "* Your %s VIP subscription expires on %s.", drank, datestring);
	    SendClientMessageEx(playerid, COLOR_VIP, string);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a VIP subscription.");
	return 1;
}

CMD:spawnathome(playerid, params[])
{
    if( PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID )
	{
        if(PlayerInfo[playerid][pDonateRank] >= 4)
		{
            PlayerInfo[playerid][pInsurance] = HOSPITAL_HOMECARE;
            SendClientMessageEx( playerid, COLOR_YELLOW, "Platinum VIP: You will now spawn at your house after deaths." );
        }
        else
		{
            SendClientMessageEx( playerid, COLOR_WHITE, "You are not Platinum VIP!" );
        }
    }
    else
	{
        SendClientMessageEx( playerid, COLOR_WHITE, "You do not own a house." );
    }
    return 1;
}

CMD:vipnum(playerid, params[])
{


    if(!(IsPlayerInRangeOfPoint(playerid, 3.0, 2549.548095, 1404.047729, 7699.584472 ) || IsPlayerInRangeOfPoint(playerid, 3.0, 1832.6000, 1375.1700, 1464.4600)) )
    {
    	SendClientMessageEx(playerid, COLOR_GREY, "You are not at the VIP phone number changing station!");
     	return 1;
   	}

    if(PlayerInfo[playerid][pDonateRank] < 2)
    {
    	SendClientMessageEx(playerid, COLOR_GRAD1, "You must be a Silver VIP or higher to use this function.");
     	return 1;
	}
	ShowPlayerDialogEx(playerid, VIPNUMMENU, DIALOG_STYLE_INPUT, "New Phone Number","New phone number:", "Submit", "Cancel");
	return 1;
}

CMD:buddyinvites(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pShopTech] > 2) {
		if(BuddyInvite == true) {
			BuddyInvite = false;
			format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has disabled the /buddyinvite command.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW, string, 2);
		} else {
			BuddyInvite = true;
			format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has enabled the /buddyinvite command.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW, string, 2);
		}
	} else {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have permission to use this command.");
	}
	return 1;
}

CMD:buddyinvite(playerid, params[])
{
	if(PlayerInfo[playerid][pDonateRank] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You need to be Silver VIP+ to use this function!");
	if(BuddyInvite == false) return SendClientMessageEx(playerid, COLOR_GREY, "Buddy invites has been disabled by an adminstrator.");
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /buddyinvite [player]");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "That person is not connected!");
	if(PlayerInfo[giveplayerid][pDonateRank] > 0) return SendClientMessageEx(playerid, COLOR_WHITE, "Unable to invite: That person is already a VIP.");
	if(PlayerInfo[giveplayerid][pAdmin] >= 2 && !PlayerInfo[giveplayerid][pTogReports]) return SendClientMessageEx(playerid, COLOR_WHITE, "Unable to invite: That person is already a VIP.");
	new days, daytime, string[128];
	if(PlayerInfo[playerid][pDonateRank] == 2)
	{
		daytime = 7;
	}
	else if(PlayerInfo[playerid][pDonateRank] == 3)
	{
		daytime = 1;
	}
	else if(PlayerInfo[playerid][pDonateRank] >= 4)
	{
		daytime = 0;
	}
	ConvertTime(gettime() - PlayerInfo[playerid][pVIPInviteDay], .ctd=days);
	if(days >= 1 && PlayerInfo[playerid][pDonateRank] >= 4)
	{
		PlayerInfo[playerid][pVIPInviteDay] = gettime();
		PlayerInfo[playerid][pBuddyInvites] = 3;
	}
	if(days < daytime && PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessageEx(playerid, COLOR_WHITE, "You must wait 7 days as silver or 1 day as gold, before inviting another person to become a VIP.");
	if(PlayerInfo[playerid][pDonateRank] >= 4 && PlayerInfo[playerid][pBuddyInvites] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You must wait 7 days as silver or 1 day as gold, before inviting another person to become a VIP.");
	PlayerInfo[giveplayerid][pDonateRank] = 1;
	PlayerInfo[giveplayerid][pTempVIP] = 180;
	PlayerInfo[giveplayerid][pBuddyInvited] = 1;
	format(string, sizeof(string), "You have invited %s to become a Bronze VIP for 3 hours.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "You have been invited by %s to become a Bronze VIP for 3 hours. Enjoy!", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "BUDDY INVITE: %s(%d) has invited %s(%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
	Log("logs/setvip.log", string);
	if(PlayerInfo[playerid][pDonateRank] >= 4)
	{
		PlayerInfo[playerid][pBuddyInvites]--;
		format(string, sizeof(string), "Platinum VIP: You have %d invites left for today.", PlayerInfo[playerid][pBuddyInvites]);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	else
	{
		PlayerInfo[playerid][pVIPInviteDay] = gettime();
	}
	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `VIPInviteDay` = %d, `BuddyInvites` = %d WHERE `id` = '%d'",
	PlayerInfo[playerid][pVIPInviteDay], PlayerInfo[playerid][pBuddyInvites], GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	return 1;
}

CMD:travel(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 13.0, 2491.7783,2397.6230,4.2109))
	{
	    if(PlayerInfo[playerid][pFamed] >= 1)
	    {
	        if(isnull(params))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /travel [famed, sffamed, trfamed]");
				return 1;
			}
            if(strcmp(params,"famed",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 1010.7523, -1121.7469, 24.1332);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					SetVehicleZAngle(tmpcar, 180.0373);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Famed: You have traveled to the front of the famed lounge.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "You're not inside a vehicle!");
				}
			}
			else if(strcmp(params,"trfamed",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -2419.3953,2328.9312,4.9921);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					SetVehicleZAngle(tmpcar, 14.1091);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Famed: You have traveled to the front of the New Robada famed lounge.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "You're not inside a vehicle!");
				}
			}
			else if(strcmp(params,"sffamed",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -2484.3599,59.7974,26.0415);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					SetVehicleZAngle(tmpcar, 357.5536);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Famed: You have traveled to the front of the San Fierro famed lounge.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "You're not inside a vehicle!");
				}
			}
		}
		else
		    return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not part of famed!");
	}
	else if(IsPlayerInRangeOfPoint(playerid, 13.0, -4429.944824, 905.032470, 987.078186))
	{
		if(PlayerInfo[playerid][pDonateRank] > 0)
		{
			if(isnull(params))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /travel [location]");
				SendClientMessageEx(playerid, COLOR_GRAD1, "Locations: LS, SF, RC, LSVIP, SFVIP, LVVIP, APVIP, FC, BAYSIDE, FLINT");
				return 1;
			}

			if(strcmp(params,"ls",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 1529.6,-1691.2,13.3);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have traveled to Los Santos with your vehicle.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not in a vehicle!");
				}
			}

			if(strcmp(params,"sf",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -1605.0,720.0,12.0);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have traveled to San Fierro with your vehicle.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;

				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not in a vehicle!");
				}
			}
			if(strcmp(params,"rc",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 1253.70, 343.73, 19.41);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have traveled to Red County with your vehicle.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;

				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not in a vehicle!");
				}
			}
			if(strcmp(params,"lsvip",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 1826.76, -1538.57, 13.25);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					SetPlayerFacingAngle(playerid, 255.08);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have traveled to the VIP Lounge with your vehicle.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;

				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not in a vehicle!");
				}
			}
			if(strcmp(params,"sfvip",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -2441.009521, 522.708923, 29.785852);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					SetPlayerFacingAngle(playerid, 181.54);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have traveled to the VIP Lounge with your vehicle.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;

				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not in a vehicle!");
				}
			}
			if(strcmp(params,"apvip",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -2106.056396, -2403.133056, 31.089097);
					SetVehicleZAngle(tmpcar, 232.05); // Sets the direction in which the vehicle faces
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					SetPlayerFacingAngle(playerid, 232.05);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have traveled to the VIP Lounge with your vehicle.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;

				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not in a vehicle!");
				}
			}
			if(strcmp(params,"lvvip",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 1875.7731, 1366.0796, 16.8998);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					SetPlayerFacingAngle(playerid, 255.08);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have traveled to the VIP Lounge with your vehicle.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;

				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not in a vehicle!");
				}
			}
			if(strcmp(params,"fc",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 162.7059, 1180.0232, 14.6859);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					SetPlayerFacingAngle(playerid, 255.08);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have traveled to the VIP Lounge with your vehicle.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not in a vehicle!");
				}
			}
			if(strcmp(params,"bayside",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -2465.7285, 2238.6355, 4.6803);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					SetPlayerFacingAngle(playerid, 255.08);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have traveled to the VIP Lounge with your vehicle.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;

				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not in a vehicle!");
				}
			}
			if(strcmp(params,"flint",true) == 0)
			{
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -79.608451, -1192.061157, 1.463104);
					SetVehicleZAngle(tmpcar, 73.97);
					if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
						SetPVarInt(playerid, "tpJustEntered", 1);
					SetPlayerFacingAngle(playerid, 73.97);
					fVehSpeed[playerid] = 0.0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have traveled to Flint County with your vehicle.");
					SetPlayerInterior(playerid,0);
					PlayerInfo[playerid][pInt] = 0;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;

				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not in a vehicle!");
				}
			}			
		}
	}
	return 1;
}

CMD:viplocker(playerid, params[]) {
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	if(IsPlayerInRangeOfPoint(playerid, 7.0, 2555.747314, 1404.106079, 7699.584472) /*LS Main*/
	|| IsPlayerInRangeOfPoint(playerid, 7.0, 1832.0533, 1380.7281, 1464.3822) /*LV Main*/
	|| IsPlayerInRangeOfPoint(playerid, 7.0, 772.4844, 1715.7213, 1938.0391) /*LV Plat*/
	|| IsPlayerInRangeOfPoint(playerid, 7.0, 1378.0017, 1747.4668, 927.3564) /*Olympics*/)
	switch(PlayerInfo[playerid][pDonateRank]) {
		case 0: SendClientMessageEx(playerid, COLOR_GRAD2, "You're not a VIP.");
		case 1: ShowPlayerDialogEx(playerid, 7483, DIALOG_STYLE_LIST, "VIP Locker", "First Aid Kit (Free)\nKevlar Vest ($15000)\nWeapons\nClothes Corner\nJob Center\nVIP Color", "Select", "Cancel");
		case 2: ShowPlayerDialogEx(playerid, 7483, DIALOG_STYLE_LIST, "VIP Locker", "First Aid Kit (Free)\nKevlar Vest ($10000)\nWeapons\nClothes Corner\nJob Center\nVIP Color", "Select", "Cancel");
		default: ShowPlayerDialogEx(playerid, 7483, DIALOG_STYLE_LIST, "VIP Locker", "First Aid Kit (Free)\nKevlar Vest (Free)\nWeapons\nClothes Corner\nJob Center\nVIP Color", "Select", "Cancel");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You're not at the VIP locker.");
	return 1;
}

CMD:v(playerid, params[]) {
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(PlayerInfo[playerid][pDonateRank] >= 1 || PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pVIPMod]) {
		if(isnull(params)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /v [message]");
		}
		else if(gettime() < GetPVarInt(playerid, "timeVIP")) {

			new
				szMessage[64];

			format(szMessage, sizeof(szMessage), "You must wait %d seconds before speaking again in this channel.", GetPVarInt(playerid, "timeVIP") - gettime());
			SendClientMessageEx(playerid, COLOR_GREY, szMessage);
		}
		else if(PlayerInfo[playerid][pToggledChats][9]) {
		    SendClientMessageEx(playerid, COLOR_GREY, "You have VIP chat toggled - /tog vip to enable it.");
		}
		else if(PlayerInfo[playerid][pVMuted] > 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "You are muted from the VIP chat channel.");
		}
		else {
			if(novip && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "The VIP chat has been disabled by an administrator.");
			new szMessage[128];

			if(PlayerInfo[playerid][pAdmin] >= 2 && !GetPVarType(playerid, "Undercover"))
			{
				format(szMessage, sizeof(szMessage), "** %s %s: %s", GetAdminRankName(PlayerInfo[playerid][pAdmin]), GetPlayerNameEx(playerid), params);
			}
			else if(GetPVarType(playerid, "Undercover") || PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pVIPMod])
			{
				if(PlayerInfo[playerid][pVIPMod] == 1) format(szMessage, sizeof(szMessage), "-- VIP Moderator %s: %s", GetPlayerNameEx(playerid), params);
				else if(PlayerInfo[playerid][pVIPMod] == 2) format(szMessage, sizeof(szMessage), "-- Senior VIP Moderator %s: %s", GetPlayerNameEx(playerid), params);
				else format(szMessage, sizeof(szMessage), "-- %s %s: %s", GetVIPRankName(PlayerInfo[playerid][pDonateRank]), GetPlayerNameEx(playerid), params);
				SetPVarInt(playerid, "timeVIP", gettime()+5);
			}

			SendVIPMessage(COLOR_VIP, szMessage);
		}
	}
	return 1;
}

CMD:searchvipm(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pShopTech] >= 1)
	{
	    new
	        count,
	        vipm,
	        string[128];

 		if(sscanf(params, "d", vipm)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /searchvipm [vipm]");

  		foreach(new i: Player)
		{
			if(PlayerInfo[i][pVIPM] == vipm)
			{
				format(string, sizeof(string), "%s (%d) | VIPM: %d", GetPlayerNameEx(i), i, vipm);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				count++;
			}
			if(PlayerInfo[i][pVIPMO] == vipm)
			{
				format(string, sizeof(string), "%s (%d) | VIPM Old: %d", GetPlayerNameEx(i), i, vipm);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				count++;
			}
			else if(count == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "No person online matched that VIPM number.");
		}
	}
	return 1;
}

CMD:sellvip(playerid, params[]) {
	if(!(1 <= PlayerInfo[playerid][pDonateRank] <= 3)) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can only sell Bronze, Silver, and Gold VIP.");
	}
	else if(PlayerInfo[playerid][pVIPM] == 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "You currently don't have a VIP ID assigned. Contact a Shop Tech.");
	}
	else if(PlayerInfo[playerid][pVIPSellable] == 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Your VIP is not sellable.");
	}
  	else if(PlayerInfo[playerid][pVIPExpire] - 604800 < gettime()) {
		SendClientMessageEx(playerid, COLOR_GREY, "Your VIP expires in less than a week - you can't sell it.");
	}
	else if(PlayerInfo[playerid][pVIPSold] > gettime()) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can only sell your VIP once every two hours.");
	}
	else {

		new
			player,
			price,
			string[128],
			viptype[7];

		if(sscanf(params, "ud", player, price)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellvip [player] [price]");
		}
		else if(price < 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "The price can't be below zero.");
		}
		else if(player == playerid) {
			SendClientMessageEx(playerid, COLOR_WHITE, "You can't sell VIP to yourself.");
		}
		else if(!IsPlayerConnected(player)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		}
		else if(PlayerInfo[player][pVIPSold] > gettime()) {
			SendClientMessageEx(playerid, COLOR_GREY, "That person can only buy VIP once every two hours.");
		}
		else if (ProxDetectorS(10.0, playerid, player))
		{
			switch(PlayerInfo[playerid][pDonateRank])
			{
				case 1: viptype = "Bronze";
				case 2: viptype = "Silver";
				case 3: viptype = "Gold";
				default: viptype = "Error";
			}
			SetPVarInt(player, "VIPSell", playerid);
			SetPVarInt(player, "VIPCost", price);
			SetPVarString(player, "VIPSeller", GetPlayerNameEx(playerid));
			format(string, sizeof(string), "Seller: %s\nVIP level: %s \nPrice: %d \nVIP ID: %d\nExpires: %s\n\nDo you wish to purchase %s VIP from %s for $%d?", GetPlayerNameEx(playerid), viptype, price, PlayerInfo[playerid][pVIPM], date(PlayerInfo[playerid][pVIPExpire], 2), viptype, GetPlayerNameEx(playerid), price);
			ShowPlayerDialogEx(player, SELLVIP, DIALOG_STYLE_MSGBOX, "Purchase VIP", string, "Purchase", "Decline");
			format(string, sizeof(string), "You offered %s $%d for your %s VIP.", GetPlayerNameEx(player), price, viptype);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "That person is not near you.");
	}
    return 1;
}


CMD:newgvip(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pShopTech] >= 2)
	{
	    new
	        iOrderID,
	        iTargetID,
	        szIP[16],
			szMessage[128];

		if(sscanf(params, "ud", iTargetID, iOrderID)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /newgvip [Player] [OrderID]");
		}
		else if(!IsPlayerConnected(iTargetID)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		}
		else {
			if(PlayerInfo[iTargetID][pGVip] != 0 && GetPVarInt(playerid, "ConfirmGVip") == 0) {
	    	    SetPVarInt(playerid, "ConfirmGVip", 1);
	    	    SendClientMessageEx(playerid, COLOR_WHITE, "That person has been issued gold vip before, if you are sure you want to issue him gold vip again");
	    	    SendClientMessageEx(playerid, COLOR_WHITE, "re-type this command (/newgvip). If he ordered a gold vip renewal use the other command (/renewgvip).");
	    	}
	    	else
	    	{
	        	DeletePVar(playerid, "ConfirmGVip");
		    	if(PlayerInfo[iTargetID][pVIPM] != 0) {
		    	    PlayerInfo[iTargetID][pVIPMO] = PlayerInfo[iTargetID][pVIPM];
					PlayerInfo[iTargetID][pVIPM] = VIPM;
					VIPM++;
				} else {
				    PlayerInfo[iTargetID][pVIPM] = VIPM;
					VIPM++;
				}
				PlayerInfo[iTargetID][pVIPExpire] = gettime()+2592000;
				format(szMessage, sizeof(szMessage), "AdmCmd: %s has set %s's VIP level to Gold (3).", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));
				ABroadCast(COLOR_LIGHTRED,szMessage, 1337);
				format(szMessage, sizeof(szMessage), "Your VIP level has been set to Gold by Admin %s.", GetPlayerNameEx(playerid));
				SendClientMessageEx(iTargetID, COLOR_WHITE, szMessage);
				if (PlayerInfo[playerid][pAdmin] < 1337) {
					format(szMessage, sizeof(szMessage), "AdmCmd: %s has set %s's VIP level to Gold (3).", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));
					SendClientMessageEx(playerid, COLOR_LIGHTRED, szMessage);
				}
        	    PlayerInfo[iTargetID][pDonateRank] = 3;
				PlayerInfo[iTargetID][pTempVIP] = 0;
				PlayerInfo[iTargetID][pBuddyInvited] = 0;
				PlayerInfo[iTargetID][pGVip] = 1;
				LoadPlayerDisabledVehicles(iTargetID);
				GetPlayerIp(iTargetID, szIP, sizeof(szIP));
				format(szMessage, sizeof(szMessage), "[GVIP] %s has set %s's(%d) (IP:%s) VIP level to Gold (3). (VIPM - %d | OrderID - %d)", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), szIP, PlayerInfo[iTargetID][pVIPM], iOrderID);
				Log("logs/setvip.log", szMessage);
			}
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:renewgvip(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
	    new
	        iOrderID,
	        iTargetID,
	        szIP[16],
			szMessage[128],
			months;

		if(sscanf(params, "udd", iTargetID, iOrderID, months)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /renewgvip [player] [order ID] [months]");
		}
		else if(!IsPlayerConnected(iTargetID)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		}
		else if(PlayerInfo[iTargetID][pGVip] == 0) {
		    SendClientMessageEx(playerid, COLOR_GREY, "That person has never purchased Gold VIP.");
		}
		else {
			if(PlayerInfo[iTargetID][pVIPM] != 0) {
    			PlayerInfo[iTargetID][pVIPMO] = PlayerInfo[iTargetID][pVIPM];
				PlayerInfo[iTargetID][pVIPM] = VIPM;
				VIPM++;
			} else {
				PlayerInfo[iTargetID][pVIPM] = VIPM;
				VIPM++;
			}
			PlayerInfo[iTargetID][pVIPExpire] = gettime()+(2592000*months);
			format(szMessage, sizeof(szMessage), "AdmCmd: %s has set %s's VIP level to Gold (3).", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));
			ABroadCast(COLOR_LIGHTRED,szMessage, 1337);
			format(szMessage, sizeof(szMessage), "Your VIP level has been set to Gold by Admin %s.", GetPlayerNameEx(playerid));
			SendClientMessageEx(iTargetID, COLOR_WHITE, szMessage);
			if (PlayerInfo[playerid][pAdmin] < 1337) {
				format(szMessage, sizeof(szMessage), "AdmCmd: %s has set %s's VIP level to Gold (3).", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));
				SendClientMessageEx(playerid, COLOR_LIGHTRED, szMessage);
			}
   			PlayerInfo[iTargetID][pDonateRank] = 3;
			PlayerInfo[iTargetID][pTempVIP] = 0;
			PlayerInfo[iTargetID][pBuddyInvited] = 0;
			GetPlayerIp(iTargetID, szIP, sizeof(szIP));
			format(szMessage, sizeof(szMessage), "[GVIP RENEWAL] %s has set %s's(%d) (IP:%s) VIP level to Gold (3). (VIPM - %d | OrderID - %d | Months: %d)", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), szIP, PlayerInfo[iTargetID][pVIPM], iOrderID, months);
			Log("logs/setvip.log", szMessage);
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:setvip(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[128], giveplayerid, level, months, orderid[32];
		if(sscanf(params, "udds[32]", giveplayerid, level, months, orderid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setvip [player] [level] [months] [orderID]");
			SendClientMessageEx(playerid, COLOR_GRAD3, "Available Levels: |0| None |1| Bronze |2| Silver |4| Platinum");
			return 1;
		}

		if(IsPlayerConnected(giveplayerid))
		{
   			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if(level < 0 || level > 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "VIP Level can not be below 0 or above 4!");
				if(level == 3) return SendClientMessage(playerid, COLOR_GRAD1, "VIP Level can not be set to 3 through this command");
				new playerip[32];
				GetPlayerIp(giveplayerid, playerip, sizeof(playerip));
				if(level == 0)
				{
					if (PlayerInfo[playerid][pAdmin] < 1337)
					{
						format(string, sizeof(string), "AdmCmd: %s has set %s's VIP level to None (%d).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), level);
						SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					}
					format(string, sizeof(string), "AdmCmd: %s has set %s's VIP level to None (%d).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), level);
					ABroadCast(COLOR_LIGHTRED,string, 1337);
					format(string, sizeof(string), "Your VIP level has been set to None by Admin %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
					PlayerInfo[giveplayerid][pTokens] = 0;

					format(string, sizeof(string), "AdmCmd: %s has set %s's(%d) (IP:%s) VIP level to None (%d) (order #%s)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), playerip, level, orderid);
					Log("logs/setvip.log", string);
				}
				if(level == 1)
				{
					if (PlayerInfo[playerid][pAdmin] < 1337)
					{
						format(string, sizeof(string), "AdmCmd: %s has set %s's VIP level to Bronze (%d)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), level, orderid);
						SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					}
					if(PlayerInfo[giveplayerid][pVIPM] == 0)
					{
						PlayerInfo[giveplayerid][pVIPM] = VIPM;
						VIPM++;
					}
					format(string, sizeof(string), "AdmCmd: %s has set %s's VIP level to Bronze (%d).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), level);
					ABroadCast(COLOR_LIGHTRED,string, 1337);
					format(string, sizeof(string), "Your VIP level has been set to Bronze by Admin %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_WHITE, string);

					format(string, sizeof(string), "AdmCmd: %s has set %s's(%d) (IP:%s) VIP level to Bronze (%d) (order #%s)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), playerip, level, orderid);
					Log("logs/setvip.log", string);
				}
				if(level == 2)
				{
					if (PlayerInfo[playerid][pAdmin] < 1337)
					{
						format(string, sizeof(string), "AdmCmd: %s has set %s's VIP level to Silver (%d).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), level);
						SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					}
					if(PlayerInfo[giveplayerid][pVIPM] == 0)
					{
						PlayerInfo[giveplayerid][pVIPM] = VIPM;
						VIPM++;
					}
					format(string, sizeof(string), "AdmCmd: %s has set %s's VIP level to Silver (%d).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), level);
					ABroadCast(COLOR_LIGHTRED,string, 1337);
					format(string, sizeof(string), "Your VIP level has been set to Silver by Admin %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_WHITE, string);

					format(string, sizeof(string), "AdmCmd: %s has set %s's(%d) (IP:%s) VIP level to Silver (%d) (order #%s)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), playerip, level, orderid);
					Log("logs/setvip.log", string);
				}
				if(level == 3)
				{
					if(!GetPVarType(playerid, "ConfirmGold")) {
						SendClientMessageEx(playerid, COLOR_WHITE, "You are about to set someone's vip level to gold. If this is a gold vip order please use the new system.");
						SendClientMessageEx(playerid, COLOR_WHITE, "For a new purchase of Gold Vip use(/newgvip). For renewals use(/renewgvip). If you wish to continue using this command type it again(/setvip)");
						SetPVarInt(playerid, "ConfirmGold", 1);
						return 1;
					}
					else {
						DeletePVar(playerid, "ConfirmGold");
						if (PlayerInfo[playerid][pAdmin] < 1337)
						{
							format(string, sizeof(string), "AdmCmd: %s has set %s's VIP level to Gold (%d).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), level);
							SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
						}
						if(PlayerInfo[giveplayerid][pVIPM] == 0)
						{
							PlayerInfo[giveplayerid][pVIPM] = VIPM;
							VIPM++;
						}
						
						format(string, sizeof(string), "AdmCmd: %s has set %s's VIP level to Gold (%d).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), level);
						ABroadCast(COLOR_LIGHTRED,string, 1337);
						format(string, sizeof(string), "Your VIP level has been set to Gold by Admin %s.", GetPlayerNameEx(playerid));
						SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
						format(string, sizeof(string), "AdmCmd: %s has set %s's(%d) (IP:%s) VIP level to Gold (%d) (order #%s)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), playerip, level, orderid);
						Log("logs/setvip.log", string);
					}
				}
				if(level == 4)
				{
					if (PlayerInfo[giveplayerid][pAdmin] < 1337)
					{
						format(string, sizeof(string), "AdmCmd: %s has set %s's VIP level to Platinum (%d).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), level);
						SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					}
					if(PlayerInfo[giveplayerid][pVIPM] == 0)
					{
						PlayerInfo[giveplayerid][pVIPM] = VIPM;
						VIPM++;
					}
					format(string, sizeof(string), "AdmCmd: %s has set %s's VIP level to Platinum (%d).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), level);
					ABroadCast(COLOR_LIGHTRED,string, 1337);
					format(string, sizeof(string), "Your VIP level has been set to Platinum by Admin %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_WHITE, string);

					PlayerInfo[giveplayerid][pVIPExpire] = gettime()+2592000*months;

					// Level 5 Arms Job - Platinum VIP
					PlayerInfo[giveplayerid][pArmsSkill] = 1200;

					format(string, sizeof(string), "AdmCmd: %s has set %s's(%d) (IP:%s) VIP level to Platinum (%d) (order #%s)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), playerip, level, orderid);
					Log("logs/setvip.log", string);
				}
				PlayerInfo[giveplayerid][pDonateRank] = level;
				if(months > 0) PlayerInfo[giveplayerid][pVIPExpire] = gettime()+2592000*months;
				else PlayerInfo[giveplayerid][pVIPExpire] = 0;
				PlayerInfo[giveplayerid][pTempVIP] = 0;
				PlayerInfo[giveplayerid][pBuddyInvited] = 0;
				PlayerInfo[giveplayerid][pVIPSellable] = 0;
				LoadPlayerDisabledVehicles(giveplayerid);
			}
			Misc_Save();
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:giftgvip(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[128], giveplayerid, days,reason[32];
		if(sscanf(params, "uds[32]", giveplayerid, days, reason))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /giftgvip [player] [days] [reason]");
			return 1;
		}

		if(IsPlayerConnected(giveplayerid))
		{
			PlayerInfo[giveplayerid][pDonateRank] = 3;
			PlayerInfo[giveplayerid][pTempVIP] = 0;
			PlayerInfo[giveplayerid][pBuddyInvited] = 0;
			new playerip[32];
			GetPlayerIp(giveplayerid, playerip, sizeof(playerip));
			PlayerInfo[giveplayerid][pVIPExpire] = gettime()+86400*days;
			format(string, sizeof(string), "AdmCmd: %s has gifted %s Gold VIP for %d days (%s)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), days, reason);
			ABroadCast(COLOR_LIGHTRED,string, 1337);
			format(string, sizeof(string), "Your VIP level has been set to Gold by Admin %s.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
			format(string, sizeof(string), "AdmCmd: %s has gifted %s(%d) Gold VIP for %d days (%s)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), days, reason);
			Log("logs/setvip.log", string);
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:vsuspend(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /vsuspend [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			format(string, sizeof(string), "AdmCmd: %s(%d) has been VIP suspended by %s.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been VIP suspended by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, string, 2);
			if(PlayerInfo[playerid][pAdmin] == 0)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
			}
			PlayerInfo[giveplayerid][pDonateRank] = 0;
			format(string, sizeof(string), "Your VIP has been suspended by %s. You may appeal this on the forums (admin complaint).", GetPlayerNameEx(playerid));
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:respawnvipcars(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		for(new i = 0; i < sizeof(VIPVehicles); i++)
		{
			if(!IsVehicleOccupied(VIPVehicles[i]))
			{
				SetVehicleVirtualWorld(VIPVehicles[i], 0);
				LinkVehicleToInterior(VIPVehicles[i], 0);
				SetVehicleToRespawn(VIPVehicles[i]);
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You have respawned all unoccupied VIP Vehicles.");
	}
	return 1;
}

CMD:vmute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pVIPMod])
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /vmute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot mute admins from VIP Chat!");
			if(PlayerInfo[giveplayerid][pVMuted] == 0)
			{
				PlayerInfo[giveplayerid][pVMuted] = 1;
				format(string, sizeof(string), "AdmCmd: %s has indefinitely blocked %s from using VIP Chat.",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				if(PlayerInfo[playerid][pAdmin] < 2)
				{
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
				}
				ABroadCast(COLOR_LIGHTRED,string,2);
				format(string, sizeof(string), "You have been indefinitely muted from VIP Chat for abuse by %s. You may appeal this on the forums (admin complaint)", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
				format(string, sizeof(string), "AdmCmd: %s(%d) was blocked from /v by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
				Log("logs/mute.log", string);
			}
			else
			{
				PlayerInfo[giveplayerid][pVMuted] = 0;
				format(string, sizeof(string), "AdmCmd: %s has been re-allowed to use VIP Chat by %s.",GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				if(PlayerInfo[playerid][pAdmin] < 2)
				{
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
				}
				ABroadCast(COLOR_LIGHTRED,string,2);
				format(string, sizeof(string), "You have been re-allowed to use VIP Chat by %s.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
				format(string, sizeof(string), "AdmCmd: %s(%d) was unblocked from /v by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
				Log("logs/mute.log", string);
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:vto(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pVIPMod])
	{
		new string[128], giveplayerid, reason[64];
		if(sscanf(params, "us[64]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /vto [player] [reason]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pVMuted] == 0)
			{
				PlayerInfo[giveplayerid][pVMuted] = 2;
				PlayerInfo[giveplayerid][pVMutedTime] = 15*60;
				format(string, sizeof(string), "AdmCmd: %s has temporarily blocked %s from using VIP Chat, reason: %s",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
				ABroadCast(COLOR_LIGHTRED,string,2);
				if(PlayerInfo[playerid][pAdmin] < 2)
				{
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
				}
				format(string, sizeof(string), "You have been temporarily blocked from using VIP Chat by %s, reason: %s.", GetPlayerNameEx(playerid), reason);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, "You will not be able to use VIP Chat for 15 minutes.");
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Note the future abuse of VIP Chat could result in loss of that privilege altogether or being banned from the server.");
				format(string, sizeof(string), "AdmCmd: %s(%d) was temporarily blocked from VIP Chat by %s(%d), reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), reason);
				Log("logs/mute.log", string);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That person is already disabled from VIP Chat.");
			}

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:vtoreset(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pVIPMod])
	{
		new string[128], giveplayerid, reason[64];
		if(sscanf(params, "us[64]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /vtoreset [player] [reason]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pVMuted] == 2)
			{
				PlayerInfo[giveplayerid][pVMuted] = 0;
				PlayerInfo[giveplayerid][pVMutedTime] = 0;
				format(string, sizeof(string), "AdmCmd: %s has unblocked %s from using VIP Chat, reason: %s",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
				if(PlayerInfo[playerid][pAdmin] < 2)
				{
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
				}
				ABroadCast(COLOR_LIGHTRED,string,2);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, "You have been unblocked from using VIP Chat. You may now use the VIP Chat system again.");
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Please accept our apologies for any error and inconvenience this may have caused.");
				format(string, sizeof(string), "AdmCmd: %s(%d) was unblocked from VIP Chat by %s(%d), reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), reason);
				Log("logs/mute.log", string);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That person is not temporarily disabled from VIP Chat.");
			}

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:vipplate(playerid, params[])
{
	if(PlayerInfo[playerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a Platinum VIP+");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /vipplate [use/remove]");
	for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	{
     	if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
       	{
			new Float: vHealth;
			GetVehicleHealth(PlayerVehicleInfo[playerid][d][pvId], vHealth);
    		if(vHealth < 800) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "Please repair your vehicle before replacing your plate.");
			new string[64];
			if(strcmp(params, "remove", true) == 0)
			{
				PlayerVehicleInfo[playerid][d][pvPlate] = 0;
				SendClientMessageEx(playerid, COLOR_YELLOW, "Your vehicle will now appear with the default plate, parking your vehicle momentarily...");
				cmd_park(playerid, params); //Save a few lines of code here xD
			}
			else if(strcmp(params, "use", true) == 0)
			{
				format(string, sizeof(string), "{800080}PVIP");
				format(PlayerVehicleInfo[playerid][d][pvPlate], 32, "%s", string);
				SendClientMessageEx(playerid, COLOR_YELLOW, "Your vehicle will now appear with the PVIP Plate, parking your vehicle momentarily...");
				cmd_park(playerid, params); //Save a few lines of code here xD
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /vipplate [use/remove]");
			}
			return 1;
		}
	}
	SendClientMessageEx(playerid, COLOR_GRAD2, "You're not inside a vehicle that you own!");
	return 1;
}

CMD:spawnatvip(playerid, params[])
{
	if(PlayerInfo[playerid][pDonateRank] > 2) return SendClientMessageEx(playerid, COLOR_GREY, "You are already able to get an insurance inside the Gold VIP+ room.");
	if(PlayerInfo[playerid][pDonateRank] != 2) return SendClientMessageEx(playerid, COLOR_GREY, "You are not a Silver VIP+!");
	if(PlayerInfo[playerid][pVIPSpawn] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You already bought a spawn at the Gold VIP+ room, you will be able to use it after your next death.");
	if(!GetPVarType(playerid, "PinConfirmed")) return PinLogin(playerid);
	if(PlayerInfo[playerid][pCredits] < 10) return SendClientMessageEx(playerid, COLOR_GREY, "You need 10 credits to buy a spawn at the Gold VIP+ room. Visit shop.ng-gaming.net to purchase credits.");
	new string[128];
	SetPVarInt(playerid, "MiscShop", 9);
	format(string, sizeof(string), "Spawn at Gold VIP+ room\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[30][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[30][sItemPrice]));
	ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Purchase a spawn at Gold VIP+ room", string, "Purchase", "Cancel");
	return 1;
}

CMD:pvipjob(playerid, params[])
{
	if(PlayerInfo[playerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "You are not a Platinum VIP+");
	if(PlayerInfo[playerid][pVIPJob] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You have already used this feature.");
	SendClientMessageEx(playerid, COLOR_YELLOW, "You can select one job to be set to level 5 as a Platinum VIP+");
	ShowPlayerDialogEx(playerid, DIALOG_VIPJOB, DIALOG_STYLE_LIST, "Job List", "Detective\nLawyer\nWhore\nDrugs Dealer\nDrug Smuggling\nArms Dealer\nCar Mechanic\nBoxer\nFishing\nShipment Contractor\nLock Picking", "Select", "Close");
	return 1;
}

CMD:ovmute(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pShopTech] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
	new query[256], tmpName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", tmpName)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /ovmute [player name]");
	new giveplayerid = ReturnUser(tmpName);
	if(IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "This player is currently connected, please use /vmute.");

	mysql_escape_string(params, tmpName);
	SetPVarString(playerid, "OnSetVMute", tmpName);

	mysql_format(MainPipeline, query,sizeof(query),"UPDATE `accounts` SET `VIPMuted` = 1 WHERE `Username`= '%s' AND `AdminLevel` < 4", tmpName);
	mysql_tquery(MainPipeline, query, "OnSetVMute", "ii", playerid, 1);

	format(query, sizeof(query), "Attempting to vip mute %s's account.", tmpName);
	SendClientMessageEx(playerid, COLOR_YELLOW, query);
	return 1;
}

CMD:ovunmute(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pShopTech] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
	new query[256], tmpName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", tmpName)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /ovunmute [player name]");
	new giveplayerid = ReturnUser(tmpName);
	if(IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "This player is currently connected, please use /vmute.");

	mysql_escape_string(params, tmpName);
	SetPVarString(playerid, "OnSetVMute", tmpName);

	mysql_format(MainPipeline, query,sizeof(query),"UPDATE `accounts` SET `VIPMuted` = 0 WHERE `Username`= '%s' AND `AdminLevel` < 4", tmpName);
	mysql_tquery(MainPipeline, query, "OnSetVMute", "ii", playerid, 2);

	format(query, sizeof(query), "Attempting to vip unmute %s's account.", tmpName);
	SendClientMessageEx(playerid, COLOR_YELLOW, query);
	return 1;
}

CMD:togvipm(playerid, params[])
{
	if(!PlayerInfo[playerid][pVIPMod] && PlayerInfo[playerid][pShopTech] < 3 && PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	if(GetPVarInt(playerid, "vStaffChat") == 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "** You have disabled VIP staff chat.");
		return SetPVarInt(playerid, "vStaffChat", 0);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "** You have enabled VIP staff chat.");
		return SetPVarInt(playerid, "vStaffChat", 1);
	}
}

CMD:vipm(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(!PlayerInfo[playerid][pVIPMod] && PlayerInfo[playerid][pShopTech] < 3 && PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	if(GetPVarInt(playerid, "vStaffChat") == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You have VIP staff chat disabled - /togvipm to enable it.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /vipm [text]");
	new szMessage[128];
	if(PlayerInfo[playerid][pVIPMod] == 1) format(szMessage, sizeof(szMessage), "* VIP Moderator %s: %s", GetPlayerNameEx(playerid), params);
	else if(PlayerInfo[playerid][pVIPMod] == 2) format(szMessage, sizeof(szMessage), "* Senior VIP Moderator %s: %s", GetPlayerNameEx(playerid), params);
	else if(PlayerInfo[playerid][pShopTech] >= 3) format(szMessage, sizeof(szMessage), "* DoCR %s: %s", GetPlayerNameEx(playerid), params);
	else if(PlayerInfo[playerid][pAdmin] == 99999) format(szMessage, sizeof(szMessage), "* Executive Admin %s: %s", GetPlayerNameEx(playerid), params);
	else format(szMessage, sizeof(szMessage), "* Undefined Rank %s: %s", GetPlayerNameEx(playerid), params);
	foreach(new i: Player)
	{
		if((PlayerInfo[i][pVIPMod] || PlayerInfo[i][pShopTech] >= 3 || PlayerInfo[i][pAdmin] >= 1338) && GetPVarInt(i, "vStaffChat") == 1)
		{
			SendClientMessageEx(i, 0xff0066FF, szMessage);
		}
	}
	return 1;
}

CMD:makevipmod(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] < 3 && PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	new target, level;
	szMiscArray[0] = 0;
	if(sscanf(params, "ud", target, level)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /makevipmod [player] [level(0-2)])");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
	if(!(0 <= level <= 2)) return SendClientMessageEx(playerid, COLOR_GREY, "Valid levels are 0 - 2");
	if(PlayerInfo[target][pVIPMod] == level) return SendClientMessageEx(playerid, COLOR_GREY, "This person already has this level.");
	if(PlayerInfo[target][pStaffBanned] >= 1) return SendClientMessage(playerid, COLOR_WHITE, "That player is currently staff banned.");
	switch(level)
	{
		case 0: format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s has removed %s's VIP Moderator rank.", GetPlayerNameEx(playerid), GetPlayerNameEx(target));
		case 1: format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s has made %s a VIP Moderator.", GetPlayerNameEx(playerid), GetPlayerNameEx(target));
		case 2: format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s has made %s a Senior VIP Moderator.", GetPlayerNameEx(playerid), GetPlayerNameEx(target));
	}
	Log("logs/admin.log", szMiscArray);
	switch(level)
	{
		case 0: format(szMiscArray, sizeof(szMiscArray), "Your VIP Moderator rank has been removed by %s.", GetPlayerNameEx(playerid));
		case 1: format(szMiscArray, sizeof(szMiscArray), "You have been made a VIP Moderator by %s.", GetPlayerNameEx(playerid));
		case 2: format(szMiscArray, sizeof(szMiscArray), "You have been made a Senior VIP Moderator by %s.", GetPlayerNameEx(playerid));
	}
	SendClientMessageEx(target, COLOR_LIGHTBLUE, szMiscArray);
	switch(level)
	{
		case 0: format(szMiscArray, sizeof(szMiscArray), "You have removed %s's VIP Moderator rank.", GetPlayerNameEx(target));
		case 1: format(szMiscArray, sizeof(szMiscArray), "You have made %s a VIP Moderator.", GetPlayerNameEx(target));
		case 2: format(szMiscArray, sizeof(szMiscArray), "You have made %s a Senior VIP Moderator.", GetPlayerNameEx(target));
	}
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	PlayerInfo[target][pVIPMod] = level;
	return 1;
}

CMD:vipmods(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] < 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	SendClientMessageEx(playerid, -1, "VIP Moderators Online:");
	foreach(Player, i)
	{
		if(PlayerInfo[i][pVIPMod])
		{
			format(szMiscArray, sizeof(szMiscArray), "%s %s - VIP Chat %s", PlayerInfo[i][pVIPMod] == 1 ? ("VIP Moderator"):("Senior VIP Moderator"), GetPlayerNameEx(i), PlayerInfo[playerid][pToggledChats][9] == 0 ? ("On"):("Off"));
			SendClientMessageEx(playerid, -1, szMiscArray);
		}
	}
	return 1;
}

CMD:novip(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		if (!novip)
		{
			novip = 1;
			foreach(new p: Player) {
				if(PlayerInfo[p][pDonateRank] > 0 || PlayerInfo[p][pVIPMod] || PlayerInfo[p][pAdmin] > 1) {
					SendClientMessageEx(p, COLOR_VIP, "** System: VIP chat channel has been disabled by an Admin!");
				}
			}
		}
		else
		{
			novip = 0;
			foreach(new p: Player) {
				if(PlayerInfo[p][pDonateRank] > 0 || PlayerInfo[p][pVIPMod] || PlayerInfo[p][pAdmin] > 1) {
					SendClientMessageEx(p, COLOR_VIP, "** System: VIP chat channel has been enabled by an Admin!");
				}
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}