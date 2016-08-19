/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Licensing System

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
#include <YSI\y_hooks>

#define DMV_MAIN 10026
#define DMVRELEASE_TARGET 10027

new DMVPointArea;

hook OnGameModeInit() {
	CreateDynamic3DTextLabel("To pay your tickets or\nrelease your cars, press Y.",COLOR_YELLOW,833.60, 3.23, 1004.17+0.6,4.0);
	DMVPointArea = CreateDynamicSphere(833.60, 3.23, 1004.17, 3.0);

	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_YES) {

		if(IsPlayerInDynamicArea(playerid, DMVPointArea)) ShowDMVMenu(playerid);
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 833.60, 3.23, 1004.17)) ShowDMVMenu(playerid);
	}
	return 1;
}

CMD:revokelicense(playerid, params[])
{
	if(IsACop(playerid) || (IsAMedic(playerid) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2) || IsAGovernment(playerid) || IsAJudge(playerid))
	{
		new string[128], giveplayerid, type, reason[64], sz_FacInfo[3][64];
		if(sscanf(params, "uds[64]", giveplayerid, type, reason))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /revokelicense [player] [type] [reason]");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Types: 1 = Driving, 2 = Boating, 3 = Flying, 4 = Firearm License");
			return 1;
		}

		if (playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't revoke your own licenses!");

		if((IsPlayerConnected(giveplayerid)) && giveplayerid != INVALID_PLAYER_ID)
		{
			if(GetPVarInt(playerid, "Injured") != 0) return SendClientMessageEx (playerid, COLOR_GRAD2, "You cannot do this at this time.");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx (playerid, COLOR_GRAD2, "You aren't near that person!");
			switch(type)
			{
				case 1:
				{
					if(PlayerInfo[giveplayerid][pCarLic] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "This person has no driver's license to revoke.");

					GetPlayerGroupInfo(playerid, sz_FacInfo[0], sz_FacInfo[1], sz_FacInfo[2]);
					format(string,sizeof(string),"The %s has revoked your driver's license, reason: %s.", sz_FacInfo[2], reason);
					SendClientMessageEx(giveplayerid,COLOR_LIGHTBLUE,string);
					format(string,sizeof(string),"HQ: %s %s %s has revoked %s' driver's license, reason: %s.", sz_FacInfo[2], sz_FacInfo[0], GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
					SendGroupMessage(GROUP_TYPE_LEA,TEAM_BLUE_COLOR,string);
					format(string,sizeof(string),"You have revoked %s' driver's license.",GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid,COLOR_WHITE,string);
					format(string, sizeof(string), "%s(%d) has taken %s'(%d) driver's license. reason: %s.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), reason);
					Log("logs/licenses.log", string);
					PlayerInfo[giveplayerid][pCarLic] = 0;
					return 1;
				}
				case 2:
				{
					if(PlayerInfo[giveplayerid][pBoatLic] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "This person has no boating license to revoke.");

					GetPlayerGroupInfo(playerid, sz_FacInfo[0], sz_FacInfo[1], sz_FacInfo[2]);
					format(string,sizeof(string),"The %s has revoked your boater's license, reason: %s.", sz_FacInfo[2], reason);
					SendClientMessageEx(giveplayerid,COLOR_LIGHTBLUE,string);
					format(string,sizeof(string),"HQ: %s %s %s has revoked %s' boater's license, reason: %s.", sz_FacInfo[2], sz_FacInfo[0], GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
					SendGroupMessage(GROUP_TYPE_LEA,TEAM_BLUE_COLOR,string);
					format(string,sizeof(string),"You have revoked %s' boater's license.",GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid,COLOR_WHITE,string);
					format(string, sizeof(string), "%s(%d) has taken %s'(%d) boater's license. reason: %s.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), reason);
					Log("logs/licenses.log", string);
					PlayerInfo[giveplayerid][pBoatLic] = 0;
					return 1;
				}
				case 3:
				{
					if(PlayerInfo[giveplayerid][pFlyLic] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "This person has no pilot license to revoke.");

					GetPlayerGroupInfo(playerid, sz_FacInfo[0], sz_FacInfo[1], sz_FacInfo[2]);
					format(string,sizeof(string),"The %s has revoked your pilot's license, reason: %s.", sz_FacInfo[2], reason);
					SendClientMessageEx(giveplayerid,COLOR_LIGHTBLUE,string);
					format(string,sizeof(string),"HQ: %s %s %s has revoked %s' pilot's license, reason: %s.", sz_FacInfo[2], sz_FacInfo[0], GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
					SendGroupMessage(GROUP_TYPE_LEA,TEAM_BLUE_COLOR,string);
					format(string,sizeof(string),"You have revoked %s' pilot's license.",GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid,COLOR_WHITE,string);
					format(string, sizeof(string), "%s(%d) has taken %s'(%s) pilot's license. reason: %s.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), reason);
					Log("logs/licenses.log", string);
					PlayerInfo[giveplayerid][pFlyLic] = 0;
					return 1;
				}
				case 4:
				{
					//if((!IsAGovernment(playerid) && PlayerInfo[playerid][pLeader] != 1))) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to revoke this license.");
					if(PlayerInfo[giveplayerid][pGunLic] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "This person has no firearms license to revoke.");

					GetPlayerGroupInfo(playerid, sz_FacInfo[0], sz_FacInfo[1], sz_FacInfo[2]);
					format(string,sizeof(string),"The %s has revoked your firearm's license, reason: %s.", sz_FacInfo[2], reason);
					SendClientMessageEx(giveplayerid,COLOR_LIGHTBLUE,string);
					format(string,sizeof(string),"HQ: %s %s %s has revoked %s' firearm's license, reason: %s.", sz_FacInfo[2], sz_FacInfo[0], GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
					SendGroupMessage(GROUP_TYPE_LEA,TEAM_BLUE_COLOR,string);
					format(string,sizeof(string),"You have revoked %s' firearm's license.",GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid,COLOR_WHITE,string);
					format(string, sizeof(string), "%s(%d) has taken %s'(%s) firearm's license. reason: %s.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), reason);
					Log("logs/licenses.log", string);
					PlayerInfo[giveplayerid][pGunLic] = 0;
					return 1;
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
		return 1;
	}
	SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorised to do this.");
	return 1;
}

CMD:givelicense(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		new string[128], giveplayerid, type;
		if(sscanf(params, "ud", giveplayerid, type))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givelicense [player] [type]");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Types: 1 = Driving, 2 = Boating, 3 = Flying, 4 = Taxi.");
			return 1;
		}

		if(!IsPlayerConnected(giveplayerid))
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
			return 1;
		}

		switch(type)
		{
		case 1:
			{
				if(PlayerInfo[giveplayerid][pCarLic] > 0)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This person already has a driver's license.");
					return 1;
				}
				format(string, sizeof(string), "You have given a driver's license to %s.",GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "Administrator %s has given you a driver's license.",GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
				format(string, sizeof(string), "Administrator %s has given a driver's license to %s(%d)",GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
				Log("logs/licenses.log", string);
				PlayerInfo[giveplayerid][pCarLic] = gettime() + (86400*80);
				return 1;
			}
		case 2:
			{
				if(PlayerInfo[giveplayerid][pBoatLic] == 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This person already has a boating license.");
					return 1;
				}
				format(string, sizeof(string), "You have given a boating license to %s.",GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "Administrator %s has given you a boating license.",GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
				format(string, sizeof(string), "Administrator %s has given a boating license to %s(%d)",GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
				Log("logs/licenses.log", string);
				PlayerInfo[giveplayerid][pBoatLic] = 1;
				return 1;
			}
		case 3:
			{
				if(PlayerInfo[giveplayerid][pFlyLic] == 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This person already has a pilot license.");
					return 1;
				}
				format(string, sizeof(string), "You have given a pilot license to %s.",GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "Administrator %s has given you a pilot license.",GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
				format(string, sizeof(string), "Administrator %s has given a pilot license to %s(%d)",GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
				Log("logs/licenses.log", string);
				PlayerInfo[giveplayerid][pFlyLic] = 1;
				return 1;
			}
		case 4:
			{
				if(PlayerInfo[giveplayerid][pTaxiLicense] == 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This person already has a taxi license.");
					return 1;
				}
				format(string, sizeof(string), "You have given a taxi license to %s.",GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "Administrator %s has given you a taxi license.",GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
				format(string, sizeof(string), "Administrator %s has given a taxi license to %s(%d)",GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
				Log("logs/licenses.log", string);
				PlayerInfo[giveplayerid][pTaxiLicense] = 1;
				return 1;
			}
		default:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Invalid license type! /givelicense [player] [type]");
				SendClientMessageEx(playerid, COLOR_GRAD2, "Types: 1 = Driving, 2 = Boating, 3 = Flying, 4 = Taxi.");
			}
		}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You're not authorised to use this command.");
	return 1;
}

CMD:droplicense(playerid, params[])
{
	new string[128], type;
	if(sscanf(params, "d", type))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /droplicense [type]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "Types: 1 = Driving, 2 = Boating, 3 = Flying, 4 = Taxi.");
		return 1;
	}

	switch(type)
	{
		case 1:
		{
			if(PlayerInfo[playerid][pCarLic] == 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a driver's license to drop.");
				return 1;
			}
			format(string, sizeof(string), "You have dropped your driver's license.");
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pCarLic] = 0;
			return 1;
		}
		case 2:
		{
			if(PlayerInfo[playerid][pBoatLic] == 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a boating license to drop.");
				return 1;
			}
			format(string, sizeof(string), "You have dropped your boating license.");
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pBoatLic] = 0;
			return 1;
		}
		case 3:
		{
			if(PlayerInfo[playerid][pFlyLic] == 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a pilot license to drop.");
				return 1;
			}
			format(string, sizeof(string), "You have dropped your pilot license.");
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pFlyLic] = 0;
			return 1;
		}
		case 4:
		{
			if(PlayerInfo[playerid][pTaxiLicense] == 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a taxi license to drop.");
				return 1;
			}
			format(string, sizeof(string), "You have dropped your taxi license.");
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pTaxiLicense] = 0;
			return 1;
		}
		default:
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Invalid license type! /droplicense [type]");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Types: 1 = Driving, 2 = Boating, 3 = Flying, 4 = Taxi.");
		}
	}
	return 1;
}

CMD:licenses(playerid, params[])
{
	new string[128], text1[40], text2[20], text3[20], text4[20], text5[40];
	if(PlayerInfo[playerid][pCarLic] == 0) { text1 = "Not acquired"; }
	else { text1 = date(PlayerInfo[playerid][pCarLic], 1); }
	if(PlayerInfo[playerid][pFlyLic]) { text4 = "Acquired"; } else { text4 = "Not acquired"; }
	if(PlayerInfo[playerid][pBoatLic]) { text2 = "Acquired"; } else { text2 = "Not acquired"; }
	if(PlayerInfo[playerid][pTaxiLicense]) { text3 = "Acquired"; } else { text3 = "Not acquired"; }
	if(PlayerInfo[playerid][pGunLic] == 0) {text5 = "Not acquired"; }
	else {text5 = date(PlayerInfo[playerid][pGunLic], 1);}
	SendClientMessageEx(playerid, COLOR_WHITE, "Your licenses...");
	format(string, sizeof(string), "** Driver's license: %s.", text1);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** Pilot license: %s.", text4);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** Boating license: %s.", text2);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** Taxi license: %s.", text3);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** SA Firearm license: %s.", text5);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	return 1;
}

CMD:showid(playerid, params[])
{
	return cmd_showlicenses(playerid, params);
}

CMD:showlicenses(playerid, params[])
{
	new string[128], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /showlicenses [player]");

	if(IsPlayerConnected(giveplayerid))
	{
		if (ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You can't show licenses to yourself - use /licenses for that."); return 1; }
			new text1[40], text2[20], text3[20], text4[20], text5[40];
			if(PlayerInfo[playerid][pCarLic] == 0) { text1 = "Not acquired"; }
			else { text1 = date(PlayerInfo[playerid][pCarLic], 1); }
			if(PlayerInfo[playerid][pFlyLic]) { text4 = "Acquired"; } else { text4 = "Not acquired"; }
			if(PlayerInfo[playerid][pBoatLic]) { text2 = "Acquired"; } else { text2 = "Not acquired"; }
			if(PlayerInfo[playerid][pTaxiLicense]) { text3 = "Acquired"; } else { text3 = "Not acquired"; }
			if(PlayerInfo[playerid][pGunLic] == 0) {text5 = "Not acquired"; }
			else {text5 = date(PlayerInfo[playerid][pGunLic], 1);}

			switch(PlayerInfo[playerid][pNation])
			{
				case 0:	SendClientMessageEx(giveplayerid, COLOR_WHITE, "** Citizen of San Andreas **");
				case 1: SendClientMessageEx(giveplayerid, COLOR_TR, "** Citizen of New Robada **");
				default: SendClientMessageEx(giveplayerid, COLOR_TR, "** No citizenship **");
			}
			format(string, sizeof(string), "Listing %s's licenses...", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
			format(string, sizeof(string), "Date of Birth: %s", PlayerInfo[playerid][pBirthDate]);
			SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
			format(string, sizeof(string), "** Driver's license: %s.", text1);
			SendClientMessageEx(giveplayerid, COLOR_GREY, string);
			format(string, sizeof(string), "** Pilot license: %s.", text4);
			SendClientMessageEx(giveplayerid, COLOR_GREY, string);
			format(string, sizeof(string), "** Boating license: %s.", text2);
			SendClientMessageEx(giveplayerid, COLOR_GREY, string);
			format(string, sizeof(string), "** Taxi license: %s.", text3);
			SendClientMessageEx(giveplayerid, COLOR_GREY, string);
			format(string, sizeof(string), "** SA Firearm license: %s.", text5);
			SendClientMessageEx(giveplayerid, COLOR_GREY, string);
			format(string, sizeof(string), "* %s has shown their licenses to you.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* You have shown your licenses to %s.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
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
	return 1;
}

ShowDMVMenu(playerid, menu = 0, iTargetID = INVALID_PLAYER_ID) {

	switch(menu) {

		case 0: { // main DMV menu
			if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && MAX_GROUP_RANKS > PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iDMVAccess]) format(szMiscArray, sizeof(szMiscArray), "Pay Tickets\nRenew License ($10,000)\nOther Licenses\nRelease Vehicles");
			if(PlayerInfo[playerid][pCarLic] == 0 || PlayerInfo[playerid][pLevel] < 2) format(szMiscArray, sizeof(szMiscArray), "Pay Tickets\nDriving Test\nOther Licenses");
			else format(szMiscArray, sizeof(szMiscArray), "Pay Tickets\nRenew Driver License\nPurchase Other License\n[LEO only] Release Impounded Vehicle");
			return ShowPlayerDialogEx(playerid, DMV_MAIN, DIALOG_STYLE_LIST, "DMV Main Menu", szMiscArray, "Select", "Cancel");



		}
		case 1: { // this is the old /dmvmenu migrated to use the new system
			new icount, icountz = GetPlayerVehicleSlots(playerid);

			if(PlayerInfo[playerid][pFreezeCar] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this while having your assets frozen!");
			if(PlayerInfo[playerid][pCarLic] < gettime()) return SendClientMessageEx(playerid, COLOR_GRAD1, "A valid driver's license is required to release your vehicle from the impound, or pay any tickets.");

			for(new i; i < icountz; i++) {
				if(PlayerVehicleInfo[playerid][i][pvPrice] < 1) PlayerVehicleInfo[playerid][i][pvPrice] = 2000000;
				if(400 <= PlayerVehicleInfo[playerid][i][pvModelId] <= 611)
				{
					if(PlayerVehicleInfo[playerid][i][pvId] > INVALID_PLAYER_VEHICLE_ID) {
						if(PlayerVehicleInfo[playerid][i][pvTicket]) {
							format(szMiscArray, sizeof(szMiscArray), "%s\n%s (ticket - $%i)", szMiscArray, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400], PlayerVehicleInfo[playerid][i][pvTicket]);
							++icount;
						}
						else format(szMiscArray, sizeof(szMiscArray), "%s\n%s", szMiscArray, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);
					}
					else if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
						format(szMiscArray, sizeof(szMiscArray), "%s\n%s (impounded - $%i release)", szMiscArray, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400], (PlayerVehicleInfo[playerid][i][pvPrice] / 20) + PlayerVehicleInfo[playerid][i][pvTicket] + (PlayerInfo[playerid][pLevel] * 3000));
						++icount;
					}
					else format(szMiscArray, sizeof(szMiscArray), "%s\nNone", szMiscArray);
				}
			}
			if(icount) {
				return ShowPlayerDialogEx(playerid, MPSPAYTICKETS, DIALOG_STYLE_LIST, "Vehicles", szMiscArray, "Release", "Cancel");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have any tickets to be paid or vehicles to be released.");
		}

		case 2: {
			if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iDMVAccess] && arrGroupData[PlayerInfo[playerid][pMember]][g_iDMVAccess] != INVALID_RANK)
				return ShowPlayerDialogEx(playerid, DMVRELEASE_TARGET, DIALOG_STYLE_INPUT, "DMV Release Menu", "Enter the person's name whom you wish to release the vehicle for.", "Select", "Cancel");
			else
				return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a Law Enforcement Officer!");

		}

		case 3: {

			new
				iCount,
				pVehSlots = GetPlayerVehicleSlots(iTargetID);

			for(new i; i < pVehSlots; i++) {
				if(PlayerVehicleInfo[iTargetID][i][pvPrice] < 1) PlayerVehicleInfo[iTargetID][i][pvPrice] = 2000000;
				if(PlayerVehicleInfo[iTargetID][i][pvId] > INVALID_PLAYER_VEHICLE_ID) {
					if(PlayerVehicleInfo[iTargetID][i][pvTicket]) {
						format(szMiscArray, sizeof(szMiscArray), "%s\n%s (ticket - $%i)", szMiscArray, VehicleName[PlayerVehicleInfo[iTargetID][i][pvModelId] - 400], PlayerVehicleInfo[iTargetID][i][pvTicket]);
						++iCount;
					}
					else format(szMiscArray, sizeof(szMiscArray), "%s\n%s", szMiscArray, VehicleName[PlayerVehicleInfo[iTargetID][i][pvModelId] - 400]);
				}
				else if(PlayerVehicleInfo[iTargetID][i][pvImpounded]) {
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (impounded - $%i release)", szMiscArray, VehicleName[PlayerVehicleInfo[iTargetID][i][pvModelId] - 400], (PlayerVehicleInfo[iTargetID][i][pvPrice] / 20) + PlayerVehicleInfo[iTargetID][i][pvTicket] + (PlayerInfo[iTargetID][pLevel] * 3000));
					++iCount;
				}
				else format(szMiscArray, sizeof(szMiscArray), "%s\nNone", szMiscArray);
			}
			if(iCount) ShowPlayerDialogEx(playerid, MPSPAYTICKETSCOP, DIALOG_STYLE_LIST, "Vehicles", szMiscArray, "Release", "Cancel"), SetPVarInt(playerid, "vRel", iTargetID);
			else SendClientMessageEx(playerid, COLOR_GRAD2, "This person doesn't have any tickets to be paid or vehicles to be released.");
		}

		case 4: {
			if (PlayerInfo[playerid][pWantedLevel] > 0) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "You have an outstanding arrest warrant - acquisition of a license is prohibited.");
			ShowPlayerDialogEx(playerid, DIALOG_LICENSE_BUY, DIALOG_STYLE_LIST, "Select the type of license you wish to acquire.", "Boating License ($5,000)\r\nPilot License ($25,000)\r\nTaxi License ($35,000)", "Purchase", "Cancel");
		}

		case 5: {
			ShowPlayerDialogEx(playerid,
			DIALOG_DSVEH_CAUTION,
			DIALOG_STYLE_MSGBOX,
			"DRIVING TEST",
			"{FE2C2C}READ CAREFULLY\n{FFFFFF}You are about to take the drivers license test.\nOn main roads, the speed limit is {FE2C2C}50{FFFFFF} and on the highway/freeway the speed limit is {FE2C2C}100{FFFFFF}.\nIf you exceed the speed limit you will fail the test however you can take it again.\nIf you are out of the vehicle for more than one minute, you will fail.", "Agree", "Disagree");
		}

	}

	return 1;

}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;

	switch(dialogid) {

		case DMV_MAIN: {

			if(!response) {
				return SendClientMessageEx(playerid, COLOR_WHITE, "You are no longer at the DMV point");
			}

			if(strcmp("Pay Tickets", inputtext) == 0) ShowDMVMenu(playerid, 1);
			if(strcmp("Renew Driver License", inputtext) == 0) {

				if(GetPlayerCash(playerid) < 10000) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough money to renew your license.");
				GivePlayerCash(playerid, -10000);
				PlayerInfo[playerid][pCarLic] = gettime() + (86400*80);
				SendClientMessageEx(playerid, COLOR_WHITE, "Your license has been renewed for 80 days");
			}
			if(strcmp("Other Licenses", inputtext) == 0) ShowDMVMenu(playerid, 4);
			if(strcmp("Purchase Other License", inputtext) == 0) ShowDMVMenu(playerid, 4);
			if(strcmp("[LEO only] Release Impounded Vehicle", inputtext) == 0) ShowDMVMenu(playerid, 2);
			if(strcmp("Driving Test", inputtext) == 0) ShowDMVMenu(playerid, 5);


			/*switch(listitem) {

				case 0: return ShowDMVMenu(playerid, 1); // this is the Pay Tickets option
				case 1: {

					if(PlayerInfo[playerid][pCarLic] == 0 || PlayerInfo[playerid][pLevel] < 2) { // driving test
						return ShowDMVMenu(playerid, 5);
					}
					else if(PlayerInfo[playerid][pCarLic] > 0) {
						if(GetPlayerCash(playerid) < 10000) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough money to renew your license.");
						GivePlayerCash(playerid, -10000);
						PlayerInfo[playerid][pCarLic] = gettime() + (86400*80);
						SendClientMessageEx(playerid, COLOR_WHITE, "Your license has been renewed for 80 days");
					}
				}
				case 2: return ShowDMVMenu(playerid, 4);
				case 3: return ShowDMVMenu(playerid, 2); // LEOs only DMV release
			}*/
		}

		case DMVRELEASE_TARGET: {

			if(!response) return ShowDMVMenu(playerid);

			new id = strval(inputtext);

			if(IsPlayerConnected(id)) return ShowDMVMenu(playerid, 3, id);
		}

	}
	return 0;
}
