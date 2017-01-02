/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Advertisements System

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

stock ShowAdMuteFine(playerid)
{
	new string[128];
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));

	new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
	if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSafeMoney];

    new fine = 10*totalwealth/100;
	if(PlayerInfo[playerid][pADMuteTotal] < 4)
	{
		format(string,sizeof(string),"Jail for %d Minutes\nCash Fine ($%d)",PlayerInfo[playerid][pADMuteTotal]*15,fine);
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 4)
	{
	    format(string,sizeof(string),"Prison for 1 Hour");
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 5)
	{
	    format(string,sizeof(string),"Prison for 1 Hour and 15 Minutes)");
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 6)
	{
	    format(string,sizeof(string),"Prison for 1 Hour and 30 Minutes");
	}
	ShowPlayerDialogEx(playerid,ADMUTE,DIALOG_STYLE_LIST,"Advertisements Unmute - Select your Punishment:",string,"Select","Cancel");
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	if(strfind(inputtext, "%", true) != -1)
	{
		SendClientMessage(playerid, COLOR_GREY, "Invalid Character, please try again.");
		return 1;
	}
	switch(dialogid)
	{
		case DIALOG_ADCATEGORY:
		{
			if(!response) return 1;
			szMiscArray[0] = 0;
			new szBuffer[32],
				arrAdverts[MAX_PLAYERS] = INVALID_PLAYER_ID,
				iDialogCount,
				iCount,
				iBreak,
				iRand;
			for(new x; x < 50; ++x) ListItemTrackId[playerid][x] = -1;
			foreach(new i: Player) if(!isnull(szAdvert[i])) arrAdverts[iCount++] = i;

			while(iDialogCount < 50 && iBreak < 500) {
				iRand = random(iCount);
				if(iCount && arrAdverts[iRand] != INVALID_PLAYER_ID) {
					if(AdvertType[arrAdverts[iRand]] == listitem+1)
					{
						strcpy(szBuffer, szAdvert[arrAdverts[iRand]], sizeof(szBuffer));
						if(PlayerInfo[playerid][pAdmin] <= 1) format(szMiscArray, sizeof(szMiscArray), "%s%s... (%i)\r\n", szMiscArray, szBuffer, PlayerInfo[arrAdverts[iRand]][pPnumber]);
						else format(szMiscArray, sizeof(szMiscArray), "%s%s... (%s)\r\n", szMiscArray, szBuffer, GetPlayerNameEx(arrAdverts[iRand]));
						ListItemTrackId[playerid][iDialogCount++] = arrAdverts[iRand];
						arrAdverts[iRand] = INVALID_PLAYER_ID;
					}
				}
				++iBreak;
			}
			if(!isnull(szMiscArray)) return ShowPlayerDialogEx(playerid, DIALOG_ADLIST, DIALOG_STYLE_LIST, "Advertisements - List", szMiscArray, "Select", "Return");
			ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORY, DIALOG_STYLE_LIST, "Advertisements Categories", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
			SendClientMessage(playerid, COLOR_GREY, "No advertisements have been posted.");
		}
		case DIALOG_ADMAIN: if(response) switch(listitem) {
			case 0: ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORY, DIALOG_STYLE_LIST, "Advertisements Categories", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
			case 1: ShowPlayerDialogEx(playerid, DIALOG_ADSEARCH, DIALOG_STYLE_INPUT, "Advertisements - Search", "Enter a search phrase.", "Search", "Return");
			case 2: {
				if(PlayerInfo[playerid][pADMute] == 1) {
					SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
				}
				else if(PlayerInfo[playerid][pPnumber] == 0) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a cell phone.");
				}
				else ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORYPLACE, DIALOG_STYLE_LIST, "Select a category", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
			}
			case 3: {
				if(PlayerInfo[playerid][pADMute] == 1) {
					SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
				}
				else if(PlayerInfo[playerid][pPnumber] == 0) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a cell phone.");
				}
				else if(gettime() < GetPVarInt(playerid, "adT")) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "You may only place one priority advertisement every two minutes.");
				}	
				else if(gettime() < iAdverTimer) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Only one priority advertisement can be placed every 30 seconds.");
				}
				else
				{
					if(PlayerInfo[playerid][pAdvertVoucher] != 0)
					{
						ShowPlayerDialogEx(playerid, DIALOG_ADVERTVOUCHER, DIALOG_STYLE_MSGBOX, "Priority Advertisement Voucher", "We found a Priority Advertisement Voucher on your account, would you like to use it?\n\n{FF0000}Note: You will lose 1 voucher if you choose yes.{FFFFFF}", "Yes", "Nope");
					}
					else if(PlayerInfo[playerid][pAdvertVoucher] == 0)
						return ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORYPLACEP, DIALOG_STYLE_LIST, "Select a category", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
				}
			}
			case 4: cmd_houselistings(playerid, "");
		}
		case DIALOG_ADCATEGORYPLACE: {
			if(response) switch(listitem) {
				case 0: {
					AdvertType[playerid] = 1;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Advertisements",
					"Enter your Real Estate Advertisement! Keep it below 128 characters.", "Submit", "Return");
				}
				case 1: {
					AdvertType[playerid] = 2;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Advertisements",
					"Enter your Automobile Advertisement! Keep it below 128 characters.", "Submit", "Return");
				}	
				case 2: {
					AdvertType[playerid] = 3;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Advertisements",
					"Enter your Buying Advertisement! Keep it below 128 characters.", "Submit", "Return");
				}
				case 3: {
					AdvertType[playerid] = 4;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Advertisements",
					"Enter your Selling Advertisement! Keep it below 128 characters.", "Submit", "Return");
				}
				case 4: {
					AdvertType[playerid] = 5;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Advertisements",
					"Enter your Miscellaneous Advertisement! Keep it below 128 characters.", "Submit", "Return");
				}
			}
		}	
		case DIALOG_ADCATEGORYPLACEP: {
			if(response) switch(listitem) {
				case 0: {
					AdvertType[playerid] = 1;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your Real Estate Priority Advertisement! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}
				case 1: {
					AdvertType[playerid] = 2;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your Automobile Priority Advertisement! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}	
				case 2: {
					AdvertType[playerid] = 3;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your Buying Priority Advertisement! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}
				case 3: {
					AdvertType[playerid] = 4;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your Selling Priority Advertisement! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}
				case 4: {
					AdvertType[playerid] = 5;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your Miscellaneous Priority Advertisement! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}
			}
		}		
		case DIALOG_ADPLACE: {
			if(response) {

				new iLength = strlen(inputtext);
				
				if(GetPVarInt(playerid, "RequestingAdP") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have a priority advertisement pending.");

				if(!(2 <= iLength <= 127)) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Your input was too long or too short.");
				}

				iLength *= 50;
				if(GetPlayerCash(playerid) < iLength) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough cash for this.");
				}
				/*if(Homes[playerid] > 0 && AdvertType[playerid] == 1 && !PlayerInfo[playerid][pShopNotice])
				{
					PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[6]);
					PlayerTextDrawShow(playerid, MicroNotice[playerid]);
					SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
				}*/
				strcpy(szAdvert[playerid], inputtext, 128);
				StripColorEmbedding(szAdvert[playerid]);
				GivePlayerCash(playerid, -iLength);
				SendClientMessageEx(playerid, COLOR_WHITE, "Congratulations, you have placed your advertisement!");
			}
			else ShowMainAdvertMenu(playerid);
		}
		case DIALOG_ADPLACEP: {
			if(response) {
				if(GetPVarInt(playerid, "RequestingAdP") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have a priority advertisement pending.");
			
				if(gettime() < iAdverTimer) {
					SendClientMessageEx(playerid, COLOR_GREY, "Only one priority advertisement can be placed every 30 seconds.");
					return ShowPlayerDialogEx(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your desired advertisement text! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}
				if(!(2 <= strlen(inputtext) <= 79)) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Your input was too long or too short.");
				}				
				if(GetPVarInt(playerid, "AdvertVoucher") > 0)
				{
				}
				else if(PlayerInfo[playerid][pFreeAdsLeft] > 0)
				{
				}
				else if(PlayerInfo[playerid][pDonateRank] == 2 && GetPlayerCash(playerid) < 125000) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough cash for this.");
				}
				else if(PlayerInfo[playerid][pDonateRank] == 3 && GetPlayerCash(playerid) < 100000) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough cash for this.");
				}
				else if(PlayerInfo[playerid][pDonateRank] >= 4 && GetPlayerCash(playerid) < 50000) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough cash for this.");
				}
				else if(PlayerInfo[playerid][pDonateRank] <= 1 && GetPlayerCash(playerid) < 150000) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough cash for this.");
				}
				SetPVarInt(playerid, "adT", gettime()+120);
				strcpy(szAdvert[playerid], inputtext, 128);
				StripColorEmbedding(szAdvert[playerid]);
					
				SetPVarInt(playerid, "RequestingAdP", 1);
				SetPVarString(playerid, "PriorityAdText", szAdvert[playerid]);
				new playername[MAX_PLAYER_NAME];
				GetPlayerName(playerid, playername, sizeof(playername));
				SendReportToQue(playerid, "Priority Advertisement", 2, 4);	
					
				return SendClientMessageEx(playerid, COLOR_WHITE, "You have placed a priority advertisement, please wait until an admin approves/denies your advertisement.");
			}
			else ShowMainAdvertMenu(playerid);
		}
		case DIALOG_ADSEARCH: {
			if(response) {

				if(!(4 <= strlen(inputtext) <= 80)) {
					return ShowPlayerDialogEx(playerid, DIALOG_ADSEARCH, DIALOG_STYLE_INPUT, "Advertisements - Search", "Queries must be between 4\n and 80 characters in length.\n\nEnter a search phrase.", "Search", "Return");
				}
				else for(new x; x < 50; ++x) ListItemTrackId[playerid][x] = -1;

				new
					szDialog[2256],
					szSearch[80],
					szBuffer[32],
					iCount;

				strcat(szSearch, inputtext, sizeof(szSearch)); // strfind is a piece of shit when it comes to non-indexed arrays, maybe this'll help.
				foreach(new i: Player)
				{
					if(!isnull(szAdvert[i])) {
						// printf("[ads] [NAME: %s] [ID: %i] [AD: %s] [SEARCH: %s]", GetPlayerNameEx(i), i, szAdvert[i], szSearch);
						if(strfind(szAdvert[i], szSearch, true) != -1 && iCount < 50) {
							// printf("[ads - MATCH] [NAME: %s] [ID: %i] [AD: %s] [SEARCH: %s] [COUNT: %i] [DIALOG LENGTH: %i] [FINDPOS: %i]", GetPlayerNameEx(i), i, szAdvert[i], szSearch, iCount, strlen(szDialog), strfind(szAdvert[i], szSearch, true));
							strcpy(szBuffer, szAdvert[i], sizeof(szBuffer));
							if(PlayerInfo[playerid][pAdmin] <= 1) format(szDialog, sizeof(szDialog), "%s%s... (%i)\r\n", szDialog, szBuffer, PlayerInfo[i][pPnumber]);
							else format(szDialog, sizeof(szDialog), "%s%s... (%s)\r\n", szDialog, szBuffer, GetPlayerNameEx(i));
							ListItemTrackId[playerid][iCount++] = i;
						}
					}
				}	
				if(!isnull(szDialog)) ShowPlayerDialogEx(playerid, DIALOG_ADSEARCHLIST, DIALOG_STYLE_LIST, "Advertisements - Search Results", szDialog, "Select", "Return");
				else ShowPlayerDialogEx(playerid, DIALOG_ADSEARCH, DIALOG_STYLE_INPUT, "Advertisements - Search", "No results found.\n\nEnter a search phrase.", "Search", "Return");

			}
			else ShowMainAdvertMenu(playerid);
		}
		case DIALOG_ADSEARCHLIST: if(response) {

			new
				i = ListItemTrackId[playerid][listitem],
				szDialog[164];

			if(IsPlayerConnected(i) && !isnull(szAdvert[i])) {
				SetPVarInt(playerid, "advertContact", PlayerInfo[i][pPnumber]);
				format(szDialog, sizeof(szDialog), "%s\r\nContact: %i", szAdvert[i], PlayerInfo[i][pPnumber]);
				ShowPlayerDialogEx(playerid, DIALOG_ADFINAL, DIALOG_STYLE_MSGBOX, "Advertisements - Search Result", szDialog, "Call", "Exit");
			}
			else SendClientMessage(playerid, COLOR_GREY, "This person has either disconnected or withdrawn their advertisement.");
		}
		case DIALOG_ADFINAL: {
			if(response) {
				new params[32];
				format(params, sizeof(params), "%d", GetPVarInt(playerid, "advertContact"));
				DeletePVar(playerid, "adverContact");
				return cmd_call(playerid, params);
			}
		}		
		case DIALOG_ADLIST: {
			if(response) {

				new
					i = ListItemTrackId[playerid][listitem],
					szDialog[164];

				if(IsPlayerConnected(i) && !isnull(szAdvert[i])) {
					SetPVarInt(playerid, "advertContact", PlayerInfo[i][pPnumber]);
					format(szDialog, sizeof(szDialog), "%s\r\nContact: %i", szAdvert[i], PlayerInfo[i][pPnumber]);
					return ShowPlayerDialogEx(playerid, DIALOG_ADFINAL, DIALOG_STYLE_MSGBOX, "Advertisements - Search Result", szDialog, "Call", "Exit");
				}
				else SendClientMessage(playerid, COLOR_GREY, "This person has either disconnected or withdrawn their advertisement.");
			}
			else ShowMainAdvertMenu(playerid);
		}
		case DIALOG_ADVERTVOUCHER:
		{
			if(response) // Clicked Yes
			{
				SetPVarInt(playerid, "AdvertVoucher", 1);
				ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORYPLACEP, DIALOG_STYLE_LIST, "Select a category", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
			}
			else // Clicked No
			{
				ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORYPLACEP, DIALOG_STYLE_LIST, "Select a category", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
			}
		}
	}
	return 0;
}

CMD:ads(playerid, params[]) {
	return cmd_advertisements(playerid, params);
}

CMD:advertisements(playerid, params[]) {
	if(gPlayerLogged{playerid} == 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
	}
	else if(GetPVarType(playerid, "Injured")) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can't use advertisements while injured.");
	}
	else if(PlayerCuffed[playerid] != 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can't use advertisements right now.");
	}
	else if(PlayerInfo[playerid][pJailTime] > 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can't use advertisements while in jail.");
	}
	else ShowMainAdvertMenu(playerid);
	return 1;
}

CMD:adunmute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pWatchdog] >= 2)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adunmute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pADMute] == 1)
			{
				if(PlayerInfo[giveplayerid][pJailTime] != 0)
				{
					SendClientMessageEx(playerid, COLOR_LIGHTRED, "You cannot offer someone in jail/prison an unmute!");
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "Sorry, you cannot be unmuted from /ad while you are in jail/prison.");
					return 1;
				}
				format(string, sizeof(string), "AdmCmd: %s(%d) was unmuted from /ad by %s.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
				Log("logs/admin.log", string);
				format(string, sizeof(string), "AdmCmd: %s was unmuted from /ad by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED,string,2);
				PlayerInfo[giveplayerid][pADMute] = 0;
				PlayerInfo[giveplayerid][pADMuteTotal]--;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED,"That person is not muted from /newb!");
			}

		}
	}
	return 1;
}

CMD:admute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pSMod] == 1)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /admute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
				if(PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "You can't /admute admins");
				if(PlayerInfo[giveplayerid][pADMute] == 0)
				{
				    SetPVarInt(giveplayerid, "UnmuteTime", gettime());
					PlayerInfo[giveplayerid][pADMute] = 1;
					PlayerInfo[giveplayerid][pADMuteTotal] += 1;
					format(string, sizeof(string), "AdmCmd: %s(%d) was muted from placing /ad's by %s(%d).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/admin.log", string);
					format(string, sizeof(string), "AdmCmd: %s was muted from placing /ad's by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
					ABroadCast(COLOR_LIGHTRED,string,2);

					if(PlayerInfo[giveplayerid][pADMuteTotal] > 6)
					{
						PlayerInfo[giveplayerid][pADMuteTotal] = 0; 
						CreateBan(playerid, PlayerInfo[giveplayerid][pId], giveplayerid, PlayerInfo[giveplayerid][pIP], "Excessive Ad-mutes", 14);
					}

					if(PlayerInfo[playerid][pAdmin] == 1)
					{
						format(string, sizeof(string), "AdmCmd: %s was muted from placing /ad's by Admin.", GetPlayerNameEx(giveplayerid));
						SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
						SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "You were just muted from Advertisements [/ads] by an Admin.");
					}
					else
					{
						format(string, sizeof(string), "AdmCmd: %s was muted from placing /ad's by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
						SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
						format(string, sizeof(string), "You were just muted from the Advertisements (/ads) by %s.", GetPlayerNameEx(playerid));
						SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
					}

					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "Remember, advertisements may only be used for IC purposes and may not be used for any other purpose, unless stated otherwise by an admin.");
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "If you wish to be unmuted, you will be fined or jailed. Future abuse could result in increased punishment. If you feel this was in error, contact a senior administrator.");

					format(string, sizeof(string), "AdmCmd: %s was just muted from using Advertisements [/ads] due to misuse.", GetPlayerNameEx(giveplayerid));
					SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				}
				else
				{
					if(PlayerInfo[playerid][pAdmin] >= 2)
					{
						ShowAdMuteFine(giveplayerid);
						format(string, sizeof(string), "You offered %s an unmute from /ads.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "That person is currently muted. You are unable to unmute players from advertisements as a Advisor.");
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

CMD:freeads(playerid, params[])
{
	if(PlayerInfo[playerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "You are not a Platinum VIP+");
	new string[128], days;
	ConvertTime(gettime() - PlayerInfo[playerid][pFreeAdsDay], .ctd=days);
	if(days >= 1)
	{
		PlayerInfo[playerid][pFreeAdsDay] = gettime();
		PlayerInfo[playerid][pFreeAdsLeft] = 3;
		SendClientMessageEx(playerid, COLOR_YELLOW, "* You still have 3 free ads left for today.");
	}	
	else if(PlayerInfo[playerid][pFreeAdsLeft] > 0)
	{
		format(string, sizeof(string), "* You still have %d free ads left for today.", PlayerInfo[playerid][pFreeAdsLeft]);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	else
	{
		new datestring[32];
		datestring = date(PlayerInfo[playerid][pFreeAdsDay]+86400, 3);
		format(string, sizeof(string), "* You have used all your free ads, you will need to wait until %s.", datestring);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	return 1;
}

ShowMainAdvertMenu(playerid)
	return ShowPlayerDialogEx(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement\nHouse Listings", "Select", "Cancel");