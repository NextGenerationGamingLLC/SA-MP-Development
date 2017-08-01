/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Help Commands

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

	Types/Subtypes
	1) Administrator
		0) All/undefined
		1) Retired Administrator/SSM
		2) Server Moderator
		3) Watchdog
		4) Junior Administrator
		5) General Administrator
		6) Assistant Shift Manager
		7) Senior Administrator
		8) Head Administrator
		9) Executive Administrator
		10) SA-MP Operations
		11) Human Resources
		12) Faction Moderator
		13) Gang Moderator
		14) Business Moderator
		15) Special Operations
		16) Shop Technician
		17) Public Relations
		18) Ban Appealer
	2) Advisor
		0) All/undefined
		1) Helper
		2) Community Advisor
		3) Senior Advisor
		4) Chief Advisor
	3) Famed
		0) All/undefined
		1) Old-School
		2) Chartered Old-School
		3) Famed
		4) Famed Commissioner
		6) Famed Vice-Chairman
	4) Newbie
	5) General
	6) Account
	7) Chat
	8) Shop
	9) Job
		1) Detective
		2) Lawyer
		3) Whore
		4) Drug Dealer
		5) [UNDEFINED]
		6) [UNDEFINED]
		7) Mechanic
		8) Bodyguard
		9) Arms Dealer
		10) Car Dealer
		11) [UNDEFINED]
		12) Boxer
		13) [UNDEFINED]
		14) Drug Smuggler
		15) Paper Boy
		16) Trucker
		17) Taxi Driver
		18) Craftsman
		19) Bartender
		20) Shipment Contractor
		21) Pizza Boy
	10) Group
		1) LEA/Cops
		2) Hitman
		3) Medic
		4) News
		5) Government
		6) Judicial
		7) Transportation
		8) Towing
		9) Criminal/Gang
		10) Racing
	11) Group Leader
		1) LEA/Cops
		2) Hitman
		3) Medic
		4) News
		5) Government
		6) Judicial
		7) Transportation
		8) Towing
		9) Criminal/Gang
		10) Racing
	11) Business
		1) Gas Station
		2) Clothing
		3) Restaurant
		4) Gun Shop
		5) New Car Dealership
		6) Used Car Dealership
		7) Mechanic
		8) Store
		9) Bar
		10) Club
		11) Sex Shop
		12) Gym
		13) Casino
	12) VIP
		2) Silver VIP
		3) Gold VIP
		4) Platinum VIP
		5) VIP Moderator
	13) Other
		1) Animation
		2) Backpack
		3) Car
		4) Cellphone
		5) Fish
		6) House
		7) Mail
		8) Rent
		9) Toy
		10) Voucher
*/

#include <YSI\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[128];
	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_HELPCATMAIN:
		{
			if(response)
			{
				format(string, sizeof(string), "HelpResultMainCat%i", listitem);
				if(GetPVarType(playerid, string))
				{
					switch(GetPVarInt(playerid, string))
					{
						case 0: Help_ListCat(playerid, DIALOG_HELPSEARCH0, response, listitem);
						case 1: Help_ListCat(playerid, DIALOG_HELPCATADMIN, response, listitem);
						case 2: Help_ListCat(playerid, DIALOG_HELPCATADVISOR, response, listitem);
						case 3: Help_ListCat(playerid, DIALOG_HELPCATFAMED, response, listitem);
						case 4: Help_ListCat(playerid, DIALOG_HELPCATNEWB, response, listitem);
						case 5: Help_ListCat(playerid, DIALOG_HELPCATGENERAL, response, listitem);
						case 6: Help_ListCat(playerid, DIALOG_HELPCATACCOUNT, response, listitem);
						case 7: Help_ListCat(playerid, DIALOG_HELPCATCHAT, response, listitem);
						case 8: Help_ListCat(playerid, DIALOG_HELPCATSHOP, response, listitem);
						case 9: Help_ListCat(playerid, DIALOG_HELPCATJOB, response, listitem);
						case 10: Help_ListCat(playerid, DIALOG_HELPCATGROUP, response, listitem);
						case 11: Help_ListCat(playerid, DIALOG_HELPCATBUSINESS, response, listitem);
						case 12: Help_ListCat(playerid, DIALOG_HELPCATVIP, response, listitem);
						case 13: Help_ListCat(playerid, DIALOG_HELPCATOTHER, response, listitem);
						default: Help_ListCat(playerid, DIALOG_HELPCATMAIN);
					}
					DeletePVar(playerid, string);
				}
			}
		}
		case DIALOG_HELPSEARCH0:
		{
			Help_ListCat(playerid, DIALOG_HELPSEARCH0, response, listitem);
		}
		case DIALOG_HELPSEARCH1:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPSEARCH1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPSEARCH2:
		{
			if(strlen(inputtext) < 2) return Help_ListCat(playerid, DIALOG_HELPSEARCH_INPUTLIMIT, response, listitem);
			if(response) Help_ListCat(playerid, DIALOG_HELPSEARCH2, response, listitem, inputtext);
			else Help_ListCat(playerid, DIALOG_HELPSEARCH0, response, listitem);
		}
		case DIALOG_HELPSEARCH3:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPSEARCH3, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPSEARCH0, response, listitem);
		}
		case DIALOG_HELPSEARCH4:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPSEARCH4, response, listitem);
			else
			{
				switch(GetPVarInt(playerid, "HelpCancelCopy"))
				{
					case 0: Help_ListCat(playerid, DIALOG_HELPSEARCH0, response, listitem);
					case 1: Help_ListCat(playerid, DIALOG_HELPCATADMIN, response, listitem);
					case 2: Help_ListCat(playerid, DIALOG_HELPCATADVISOR, response, listitem);
					case 3: Help_ListCat(playerid, DIALOG_HELPCATFAMED, response, listitem);
					case 4: Help_ListCat(playerid, DIALOG_HELPCATNEWB, response, listitem);
					case 5: Help_ListCat(playerid, DIALOG_HELPCATGENERAL, response, listitem);
					case 6: Help_ListCat(playerid, DIALOG_HELPCATACCOUNT, response, listitem);
					case 7: Help_ListCat(playerid, DIALOG_HELPCATCHAT, response, listitem);
					case 8: Help_ListCat(playerid, DIALOG_HELPCATSHOP, response, listitem);
					case 9: Help_ListCat(playerid, DIALOG_HELPCATJOB, response, listitem);
					case 10: Help_ListCat(playerid, DIALOG_HELPCATGROUP, response, listitem);
					case 12: Help_ListCat(playerid, DIALOG_HELPCATBUSINESS, response, listitem);
					case 13: Help_ListCat(playerid, DIALOG_HELPCATVIP, response, listitem);
					case 14: Help_ListCat(playerid, DIALOG_HELPCATOTHER, response, listitem);
				}
				DeletePVar(playerid, "HelpCancelCopy");
			}
		}
		case DIALOG_HELPCATADMIN:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATADMIN1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATADVISOR:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATADVISOR1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATFAMED:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATFAMED1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATNEWB:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATNEWB1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATGENERAL:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATGENERAL1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATACCOUNT:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATACCOUNT1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATCHAT:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATCHAT1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATSHOP:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATSHOP1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATJOB:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATJOB1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATGROUP:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATGROUP1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATBUSINESS:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATBUSINESS1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATVIP:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATVIP1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPCATOTHER:
		{
			if(response) Help_ListCat(playerid, DIALOG_HELPCATOTHER1, response, listitem);
			else Help_ListCat(playerid, DIALOG_HELPCATMAIN, response, listitem);
		}
		case DIALOG_HELPSEARCH_INPUTLIMIT:
		{
			Help_ListCat(playerid, DIALOG_HELPSEARCH0, response, listitem);
		}
	}
	return 0;
}

stock LoadHelp()
{
	printf("[LoadHelp] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `help` ORDER BY `Type` ASC, `Subtype` ASC, `Name` ASC", true, "OnLoadHelp", "");
}

stock RehashHelp()
{
	printf("[RehashHelp] Clearing in-game help data...");
	for(new i = 0; i < sizeof(Help); i++)
	{
		Help[i][HelpID] = -1;
		Help[i][HelpName] = EOS;
		Help[i][HelpParam] = EOS;
		Help[i][HelpDesc] = EOS;
		Help[i][HelpType] = -1;
		Help[i][HelpSubtype] = -1;
		Help[i][HelpLevel] = -1;
	}
	LoadHelp();
	return 1;
}

forward OnLoadHelp();
public OnLoadHelp()
{
	new i, rows, fields;
	szMiscArray[0] = 0;
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		Help[i][HelpID] = cache_get_field_content_int(i, "id", MainPipeline);
		cache_get_field_content(i, "Name", Help[i][HelpName], MainPipeline, 128);
		cache_get_field_content(i, "Parameters", Help[i][HelpParam], MainPipeline, 128);
		cache_get_field_content(i, "Description", Help[i][HelpDesc], MainPipeline, 128);
		Help[i][HelpType] = cache_get_field_content_int(i, "Type", MainPipeline);
		Help[i][HelpSubtype] = cache_get_field_content_int(i, "Subtype", MainPipeline);
		Help[i][HelpLevel] = cache_get_field_content_int(i, "Level", MainPipeline);
		i++;
	}
	if(i > 0) printf("[LoadHelp] %d help entries rehashed/loaded.", i);
	else printf("[LoadHelp] Failed to load any help entries.");
}

stock Help_ListCat(playerid, dialogid = DIALOG_HELPCATMAIN, response = 0, listitem = 0, inputtext[] = 0)
{
	new string[256];
	switch(dialogid)
	{
		case DIALOG_HELPCATMAIN:
		{
			new iGroupID = PlayerInfo[playerid][pMember], j = 0;
			format(szMiscArray, sizeof(szMiscArray), "Search\n");
			format(string, sizeof(string), "HelpResultMainCat%i", j);
			SetPVarInt(playerid, string, 0);
			j++;
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
				format(szMiscArray, sizeof(szMiscArray), "%sAdministrator\n", szMiscArray);
				format(string, sizeof(string), "HelpResultMainCat%i", j);
				SetPVarInt(playerid, string, 1);
				j++;
			}
			if(PlayerInfo[playerid][pHelper] >= 1)
			{
				format(szMiscArray, sizeof(szMiscArray), "%sAdvisor\n", szMiscArray);
				format(string, sizeof(string), "HelpResultMainCat%i", j);
				SetPVarInt(playerid, string, 2);
				j++;
			}
			if(PlayerInfo[playerid][pFamed] >= 1)
			{
				format(szMiscArray, sizeof(szMiscArray), "%sFamed\n", szMiscArray);
				format(string, sizeof(string), "HelpResultMainCat%i", j);
				SetPVarInt(playerid, string, 3);
				j++;
			}
			if(PlayerInfo[playerid][pLevel] <= 3)
			{
				format(szMiscArray, sizeof(szMiscArray), "%sNewbie Help\n", szMiscArray);
				format(string, sizeof(string), "HelpResultMainCat%i", j);
				SetPVarInt(playerid, string, 4);
				j++;
			}
			format(szMiscArray, sizeof(szMiscArray), "%sGeneral\n", szMiscArray);
			format(string, sizeof(string), "HelpResultMainCat%i", j);
			SetPVarInt(playerid, string, 5);
			j++;
			format(szMiscArray, sizeof(szMiscArray), "%sAccount\n", szMiscArray);
			format(string, sizeof(string), "HelpResultMainCat%i", j);
			SetPVarInt(playerid, string, 6);
			j++;
			format(szMiscArray, sizeof(szMiscArray), "%sChat\n", szMiscArray);
			format(string, sizeof(string), "HelpResultMainCat%i", j);
			SetPVarInt(playerid, string, 7);
			j++;
			format(szMiscArray, sizeof(szMiscArray), "%sShop\n", szMiscArray);
			format(string, sizeof(string), "HelpResultMainCat%i", j);
			SetPVarInt(playerid, string, 8);
			j++;
			format(szMiscArray, sizeof(szMiscArray), "%sJob\n", szMiscArray);
			format(string, sizeof(string), "HelpResultMainCat%i", j);
			SetPVarInt(playerid, string, 9);
			j++;
			if(iGroupID != INVALID_GROUP_ID)
			{
				format(szMiscArray, sizeof(szMiscArray), "%sGroup\n", szMiscArray);
				format(string, sizeof(string), "HelpResultMainCat%i", j);
				SetPVarInt(playerid, string, 10);
				j++;
			}
			if(IsValidBusinessID(PlayerInfo[playerid][pBusiness]))
			{
				format(szMiscArray, sizeof(szMiscArray), "%sBusiness\n", szMiscArray);
				format(string, sizeof(string), "HelpResultMainCat%i", j);
				SetPVarInt(playerid, string, 11);
				j++;
			}
			if(PlayerInfo[playerid][pDonateRank] || PlayerInfo[playerid][pVIPMod])
			{
				format(szMiscArray, sizeof(szMiscArray), "%sVIP\n", szMiscArray);
				format(string, sizeof(string), "HelpResultMainCat%i", j);
				SetPVarInt(playerid, string, 12);
				j++;
			}
			format(szMiscArray, sizeof(szMiscArray), "%sOther", szMiscArray);
			format(string, sizeof(string), "HelpResultMainCat%i", j);
			SetPVarInt(playerid, string, 13);
			ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
		}
		case DIALOG_HELPSEARCH0: ShowPlayerDialogEx(playerid, DIALOG_HELPSEARCH1, DIALOG_STYLE_LIST, "Help System - Search", "Search by Command & Description\nSearch by Command Only\nSearch by Description Only", "Select", "Go Back");
		case DIALOG_HELPSEARCH1:
		{
			SetPVarInt(playerid, "HelpSearchType", listitem);
			switch(listitem)
			{
				case 0: ShowPlayerDialogEx(playerid, DIALOG_HELPSEARCH2, DIALOG_STYLE_INPUT, "Help System - Search (Command & Description)", "Search:", "Search", "Go Back");
				case 1: ShowPlayerDialogEx(playerid, DIALOG_HELPSEARCH2, DIALOG_STYLE_INPUT, "Help System - Search (Command)", "Search:", "Search", "Go Back");
				case 2: ShowPlayerDialogEx(playerid, DIALOG_HELPSEARCH2, DIALOG_STYLE_INPUT, "Help System - Search (Description)", "Search:", "Search", "Go Back");
			}
		}
		case DIALOG_HELPSEARCH2:
		{
			Help_GenerateCMDList(playerid, GetPVarInt(playerid, "HelpSearchType"), -1, 0, 0, inputtext);
			DeletePVar(playerid, "HelpSearchType");
			format(string, sizeof(string), "Help System - Search Results for '%s'", inputtext);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPSEARCH3, DIALOG_STYLE_LIST, string, szMiscArray, "Select", "Go Back");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPSEARCH0, DIALOG_STYLE_MSGBOX, string, "No results found! Please try another search term.", "Go Back", "");
		}
		case DIALOG_HELPSEARCH3:
		{
			format(string, sizeof(string), "HelpResult%i", listitem);
			SetPVarInt(playerid, "HelpCancelCopy", 0);
			Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
		}
		case DIALOG_HELPSEARCH4:
		{
			Help_SendToChat(playerid, response, GetPVarInt(playerid, "TmpCMD"));
			DeletePVar(playerid, "TmpCMD");
		}
		case DIALOG_HELPSEARCH_INPUTLIMIT:
		{
			ShowPlayerDialogEx(playerid, DIALOG_HELPSEARCH_INPUTLIMIT, DIALOG_STYLE_MSGBOX, "Help System - Search", "Minimum of 2 characters required to search!", "Go Back", "");
		}
		case DIALOG_HELPCATADMIN:
		{
			new j = 0;
			if(Help_Perm(playerid, 1, 1, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 1);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "Retired Administrator\n");
			}
			if(Help_Perm(playerid, 1, 2, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 2);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sServer Moderator\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 3, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 3);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sWatchdog\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 4, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 4);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sJunior Administrator\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 5, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 5);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sGeneral Administrator\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 6, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 6);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sAssistant Shift Manager\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 7, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 7);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sSenior Administrator\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 8, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 8);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sHead Administrator\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 9, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 9);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sExecutive Administrator\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 10, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 10);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sSA-MP Operations\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 11, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 11);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sHuman Resources\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 12, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 12);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sFaction Moderator\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 13, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 13);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sGang Moderator\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 14, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 14);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sBusiness Moderator\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 15, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 15);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sSpecial Operations\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 16, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 16);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sShop Technician\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 17, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 17);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sPublic Relations\n", szMiscArray);
			}
			if(Help_Perm(playerid, 1, 18, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 18);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sBan Appealer\n", szMiscArray);
			}
			Help_GenerateCMDList(playerid, 3, j, 1, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATADMIN, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATADMIN1:
		{
			format(string, sizeof(string), "HelpResultCat%i", listitem);
			if(GetPVarInt(playerid, string))
			{
				Help_GenerateCMDList(playerid, 3, -1, 1, GetPVarInt(playerid, string));
				ClearHelpSearch(playerid, 0, 1);
				if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATADMIN, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
				else
				{
					SetPVarInt(playerid, "HelpResultMainCat0", 1);
					ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
				}
			}
			else
			{
				format(string, sizeof(string), "HelpResult%i", listitem);
				SetPVarInt(playerid, "HelpCancelCopy", 1);
				Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
				ClearHelpSearch(playerid);
			}
		}
		case DIALOG_HELPCATADVISOR:
		{
			new j = 0;
			if(Help_Perm(playerid, 2, 1, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 1);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "Helper\n");
			}
			if(Help_Perm(playerid, 2, 2, 2))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 2);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%Community Advisor\n", szMiscArray);
			}
			if(Help_Perm(playerid, 2, 3, 3))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 3);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%Senior Advisor\n", szMiscArray);
			}
			if(Help_Perm(playerid, 2, 4, 4))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 4);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sChief Advisor\n", szMiscArray);
			}
			Help_GenerateCMDList(playerid, 3, j, 2, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATADVISOR, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATADVISOR1:
		{
			format(string, sizeof(string), "HelpResultCat%i", listitem);
			if(GetPVarInt(playerid, string))
			{
				Help_GenerateCMDList(playerid, 3, -1, 2, GetPVarInt(playerid, string));
				ClearHelpSearch(playerid, 0, 1);
				if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATADVISOR, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
				else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
			}
			else
			{
				format(string, sizeof(string), "HelpResult%i", listitem);
				SetPVarInt(playerid, "HelpCancelCopy", 2);
				Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
				ClearHelpSearch(playerid);
			}
		}
		case DIALOG_HELPCATFAMED:
		{
			new j = 0;
			if(Help_Perm(playerid, 3, 1, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 1);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "Old-School\n");
			}
			if(Help_Perm(playerid, 3, 2, 2))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 2);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sChartered Old-School\n", szMiscArray);
			}
			if(Help_Perm(playerid, 3, 3, 3))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 3);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%Famed\n", szMiscArray);
			}
			if(Help_Perm(playerid, 3, 4, 4))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 4);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sFamed Commissioner\n", szMiscArray);
			}
			if(Help_Perm(playerid, 3, 6, 6))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 6);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sFamed Vice-Chairman\n", szMiscArray);
			}
			Help_GenerateCMDList(playerid, 3, j, 3, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATFAMED, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATFAMED1:
		{
			format(string, sizeof(string), "HelpResultCat%i", listitem);
			if(GetPVarInt(playerid, string))
			{
				Help_GenerateCMDList(playerid, 3, -1, 3, GetPVarInt(playerid, string));
				ClearHelpSearch(playerid, 0, 1);
				if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATFAMED, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
				else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
			}
			else
			{
				format(string, sizeof(string), "HelpResult%i", listitem);
				SetPVarInt(playerid, "HelpCancelCopy", 3);
				Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
				ClearHelpSearch(playerid);
			}
		}
		case DIALOG_HELPCATNEWB:
		{
			Help_GenerateCMDList(playerid, 3, -1, 4, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATNEWB, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATNEWB1:
		{
			format(string, sizeof(string), "HelpResult%i", listitem);
			SetPVarInt(playerid, "HelpCancelCopy", 4);
			Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
			ClearHelpSearch(playerid);
		}
		case DIALOG_HELPCATGENERAL:
		{
			Help_GenerateCMDList(playerid, 3, -1, 5, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATGENERAL, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATGENERAL1:
		{
			format(string, sizeof(string), "HelpResult%i", listitem);
			SetPVarInt(playerid, "HelpCancelCopy", 5);
			Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
			ClearHelpSearch(playerid);
		}
		case DIALOG_HELPCATACCOUNT:
		{
			Help_GenerateCMDList(playerid, 3, -1, 6, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATACCOUNT, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATACCOUNT1:
		{
			format(string, sizeof(string), "HelpResult%i", listitem);
			SetPVarInt(playerid, "HelpCancelCopy", 6);
			Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
			ClearHelpSearch(playerid);
		}
		case DIALOG_HELPCATCHAT:
		{
			Help_GenerateCMDList(playerid, 3, -1, 7, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATCHAT, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATCHAT1:
		{
			format(string, sizeof(string), "HelpResult%i", listitem);
			SetPVarInt(playerid, "HelpCancelCopy", 7);
			Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
			ClearHelpSearch(playerid);
		}
		case DIALOG_HELPCATSHOP:
		{
			Help_GenerateCMDList(playerid, 3, -1, 8, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATSHOP, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATSHOP1:
		{
			format(string, sizeof(string), "HelpResult%i", listitem);
			SetPVarInt(playerid, "HelpCancelCopy", 8);
			Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
			ClearHelpSearch(playerid);
		}
		case DIALOG_HELPCATJOB:
		{
			new j = 0;
			if(Help_Perm(playerid, 9, 1, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 1);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "Detective\n");
			}
			if(Help_Perm(playerid, 9, 2, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 2);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sLawyer\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 3, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 3);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sWhore\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 4, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 4);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sDrug Dealer\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 5, 0))
			{
				// Job 5 is undefined; Modify if one is added!
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 5);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%s[PLACEHOLDER]\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 6, 0))
			{
				// Job 6 is undefined; Modify if one is added!
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 6);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%s[PLACEHOLDER]\n");
			}
			if(Help_Perm(playerid, 9, 7, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 7);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sMechanic\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 8, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 8);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sBodyguard\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 9, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 9);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sArms Dealer\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 10, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 10);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sCar Dealer\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 11, 0))
			{
				// Job 11 is undefined; Modify if one is added!
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 11);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%s[PLACEHOLDER]\n");
			}
			if(Help_Perm(playerid, 9, 12, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 12);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sBoxer\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 13, 0))
			{
				// Job 13 is undefined; Modify if one is added!
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 13);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%s[PLACEHOLDER]\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 14, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 14);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sDrug Smuggler\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 15, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 15);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sPaper Boy\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 16, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 16);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sTrucker\n");
			}
			if(Help_Perm(playerid, 9, 17, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 17);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sTaxi Driver\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 18, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 18);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sCraftsman\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 19, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 19);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sBartender\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 20, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 20);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sShipment Contractor\n", szMiscArray);
			}
			if(Help_Perm(playerid, 9, 21, 0))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 21);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sPizza Boy\n", szMiscArray);
			}
			Help_GenerateCMDList(playerid, 3, -1, 9, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATJOB, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATJOB1:
		{			
			format(string, sizeof(string), "HelpResultCat%i", listitem);
			if(GetPVarInt(playerid, string))
			{
				Help_GenerateCMDList(playerid, 3, -1, 9, GetPVarInt(playerid, string));
				ClearHelpSearch(playerid, 0, 1);
				if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATJOB, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
				else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
			}
			else
			{
				format(string, sizeof(string), "HelpResult%i", listitem);
				SetPVarInt(playerid, "HelpCancelCopy", 9);
				Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
				ClearHelpSearch(playerid);
			}
		}
		case DIALOG_HELPCATGROUP:
		{
			new j = 0;
			if(Help_Perm(playerid, 11, arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType], 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 1);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "Leadership\n");
			}
			Help_GenerateCMDList(playerid, 3, j, 10, arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType]);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATGROUP, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATGROUP1:
		{
			format(string, sizeof(string), "HelpResultCat%i", listitem);
			if(GetPVarInt(playerid, string))
			{
				Help_GenerateCMDList(playerid, 3, -1, 11, arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType]);
				ClearHelpSearch(playerid, 0, 1);
				if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATGROUP, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
				else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
			}
			else
			{
				format(string, sizeof(string), "HelpResult%i", listitem);
				SetPVarInt(playerid, "HelpCancelCopy", 10);
				Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
				ClearHelpSearch(playerid);
			}
		}
		case DIALOG_HELPCATBUSINESS:
		{
			Help_GenerateCMDList(playerid, 3, -1, 12, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATBUSINESS, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATBUSINESS1:
		{
			format(string, sizeof(string), "HelpResult%i", listitem);
			SetPVarInt(playerid, "HelpCancelCopy", 12);
			Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
			ClearHelpSearch(playerid);
		}
		case DIALOG_HELPCATVIP:
		{
			new j = 0;
			if(Help_Perm(playerid, 13, 5, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 5);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "VIP Moderator\n");
			}
			if(Help_Perm(playerid, 13, 2, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 2);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sSilver VIP\n", szMiscArray);
			}
			if(Help_Perm(playerid, 13, 3, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 3);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sGold VIP\n", szMiscArray);
			}
			if(Help_Perm(playerid, 13, 4, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 4);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sPlatinum VIP\n", szMiscArray);
			}
			Help_GenerateCMDList(playerid, 3, -1, 13, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATVIP, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATVIP1:
		{
			format(string, sizeof(string), "HelpResultCat%i", listitem);
			if(GetPVarInt(playerid, string))
			{
				Help_GenerateCMDList(playerid, 3, -1, 13, GetPVarInt(playerid, string));
				ClearHelpSearch(playerid, 0, 1);
				if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATVIP, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
				else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
			}
			else
			{
				format(string, sizeof(string), "HelpResult%i", listitem);
				SetPVarInt(playerid, "HelpCancelCopy", 13);
				Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
				ClearHelpSearch(playerid);
			}
		}
		case DIALOG_HELPCATOTHER:
		{
			new j = 0;
			if(Help_Perm(playerid, 14, 1, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 1);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "Animation\n");
			}
			if(Help_Perm(playerid, 14, 2, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 2);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sBackpack\n", szMiscArray);
			}
			if(Help_Perm(playerid, 14, 3, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 3);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sCar\n", szMiscArray);
			}
			if(Help_Perm(playerid, 14, 4, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 4);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sCellphone\n", szMiscArray);
			}
			if(Help_Perm(playerid, 14, 5, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 5);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sFish\n", szMiscArray);
			}
			if(Help_Perm(playerid, 14, 6, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 6);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sHouse\n", szMiscArray);
			}
			if(Help_Perm(playerid, 14, 7, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 7);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sMail\n", szMiscArray);
			}
			if(Help_Perm(playerid, 14, 8, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 8);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sRent\n", szMiscArray);
			}
			if(Help_Perm(playerid, 14, 9, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 9);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sToy\n", szMiscArray);
			}
			if(Help_Perm(playerid, 14, 10, 1))
			{
				format(string, sizeof(string), "HelpResultCat%i", j);
				SetPVarInt(playerid, string, 10);
				j++;
				format(szMiscArray, sizeof(szMiscArray), "%sVoucher\n", szMiscArray);
			}
			Help_GenerateCMDList(playerid, 3, -1, 14, 0);
			if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATOTHER, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
		}
		case DIALOG_HELPCATOTHER1:
		{
			format(string, sizeof(string), "HelpResultCat%i", listitem);
			if(GetPVarInt(playerid, string))
			{
				Help_GenerateCMDList(playerid, 3, -1, 14, GetPVarInt(playerid, string));
				ClearHelpSearch(playerid, 0, 1);
				if(!isnull(szMiscArray)) ShowPlayerDialogEx(playerid, DIALOG_HELPCATOTHER, DIALOG_STYLE_LIST, "Help System", szMiscArray, "Select", "Cancel");
				else ShowPlayerDialogEx(playerid, DIALOG_HELPCATMAIN, DIALOG_STYLE_MSGBOX, "Help System", "No commands found for this category.", "Go Back", "");
			}
			else
			{
				format(string, sizeof(string), "HelpResult%i", listitem);
				SetPVarInt(playerid, "HelpCancelCopy", 13);
				Help_ShowCMD(playerid, GetPVarInt(playerid, string), DIALOG_HELPSEARCH4);
				ClearHelpSearch(playerid);
			}
		}
	}
	return 1;
}

stock Help_GenerateCMDList(playerid, listtype, listitem = -1, type = 0, subtype = 0, param[] = 0)
{
	new string[256], j = 0;
	for(new i = 0; i < sizeof(Help); i++)
	{
		switch(listtype)
		{
			case 0:
			{
				if((strfind(Help[i][HelpName], param, true) != -1 || strfind(Help[i][HelpDesc], param, true) != -1) && Help_Perm(playerid, Help[i][HelpType], Help[i][HelpSubtype], Help[i][HelpLevel]))
				{
					if(listitem >= 0)
					{
						format(string, sizeof(string), "HelpResult%i", listitem);
						listitem++;
					}
					else
					{
						format(string, sizeof(string), "HelpResult%i", j);
						j++;
					}
					SetPVarInt(playerid, string, i);
					format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, Help[i][HelpName]);
				}
			}
			case 1:
			{
				if(strfind(Help[i][HelpName], param, true) != -1 && Help_Perm(playerid, Help[i][HelpType], Help[i][HelpSubtype], Help[i][HelpLevel]))
				{
					if(listitem >= 0)
					{
						format(string, sizeof(string), "HelpResult%i", listitem);
						listitem++;
					}
					else
					{
						format(string, sizeof(string), "HelpResult%i", j);
						j++;
					}
					SetPVarInt(playerid, string, i);
					format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, Help[i][HelpName]);
				}
			}
			case 2:
			{
				if(strfind(Help[i][HelpDesc], param, true) != -1 && Help_Perm(playerid, Help[i][HelpType], Help[i][HelpSubtype], Help[i][HelpLevel]))
				{
					if(listitem >= 0)
					{
						format(string, sizeof(string), "HelpResult%i", listitem);
						listitem++;
					}
					else
					{
						format(string, sizeof(string), "HelpResult%i", j);
						j++;
					}
					SetPVarInt(playerid, string, i);
					format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, Help[i][HelpName]);
				}
			}
			case 3:
			{
				if(Help[i][HelpType] == type && Help[i][HelpSubtype] == subtype && Help_Perm(playerid, Help[i][HelpType], Help[i][HelpSubtype], Help[i][HelpLevel]))
				{
					if(listitem >= 0)
					{
						format(string, sizeof(string), "HelpResult%i", listitem);
						listitem++;
					}
					else
					{
						format(string, sizeof(string), "HelpResult%i", j);
						j++;
					}
					SetPVarInt(playerid, string, i);
					format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, Help[i][HelpName]);
				}
			}
		}
	}
	return 1;
}

stock Help_ShowCMD(playerid, cmd, dialog)
{
	new string[256];
	SetPVarInt(playerid, "TmpCMD", cmd);
	format(string, sizeof(string), "Command Help for %s", Help[cmd][HelpName]);
	format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}Usage: {AFAFAF}%s %s\n\n{FFFFFF}Description: {AFAFAF}%s\n\t\t\t\t\t", Help[cmd][HelpName], Help[cmd][HelpParam], Help[cmd][HelpDesc]);
	return ShowPlayerDialogEx(playerid, dialog, DIALOG_STYLE_MSGBOX, string, szMiscArray, "Copy", "Exit");
}

stock Help_SendToChat(playerid, response, cmd)
{
	if(response)
	{
		format(szMiscArray, sizeof(szMiscArray), "USAGE: %s %s", Help[cmd][HelpName], Help[cmd][HelpParam]);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
}

// Function to determine if player has permission to view/use command
stock Help_Perm(playerid, type, subtype, level)
{
	// Administrator
	if(type == 1 && PlayerInfo[playerid][pAdmin] >= 1)
	{
		// Undefined Admin Commands? (May Remove Later)
		if(subtype == 0 && PlayerInfo[playerid][pAdmin] >= level) return 1;
		// Retired Administrator/Senior Server Moderator
		if(subtype == 1 && PlayerInfo[playerid][pSMod] > 0) return 1;
		// Server Moderator
		else if(subtype == 2 && PlayerInfo[playerid][pSMod] == 0) return 1;
		// Watchdog
		else if(subtype == 3 && PlayerInfo[playerid][pWatchdog] >= level) return 1;
		// Junior Administrator
		else if(subtype == 4 && PlayerInfo[playerid][pAdmin] >= level) return 1;
		// General Administrator
		else if(subtype == 5 && PlayerInfo[playerid][pAdmin] >= level) return 1;
		// Assistant Shift Manager
		else if(subtype == 6 && PlayerInfo[playerid][pASM] >= level) return 1;
		// Senior Administrator
		else if(subtype == 7 && PlayerInfo[playerid][pAdmin] >= level) return 1;
		// Head Administrator
		else if(subtype == 8 && PlayerInfo[playerid][pAdmin] >= level) return 1;
		// Executive Administrator
		else if(subtype == 9 && PlayerInfo[playerid][pAdmin] >= level) return 1;
		// SA-MP Operations
		else if(subtype == 10 && PlayerInfo[playerid][pAP] >= level) return 1;
		// Human Resources
		else if(subtype == 11 && PlayerInfo[playerid][pHR] >= level) return 1;
		// Faction Moderator
		else if(subtype == 12 && PlayerInfo[playerid][pFactionModerator] >= level) return 1;
		// Gang Moderator
		else if(subtype == 13 && PlayerInfo[playerid][pGangModerator] >= level) return 1;
		// Business Moderator
		else if(subtype == 14 && PlayerInfo[playerid][pBM] >= level) return 1;
		// Special Operations
		else if(subtype == 15 && PlayerInfo[playerid][pUndercover] >= level) return 1;
		// Shop Technician
		else if(subtype == 16 && PlayerInfo[playerid][pShopTech] >= level) return 1;
		// Public Relations
		else if(subtype == 17 && PlayerInfo[playerid][pPR] >= level) return 1;
		// Ban Appealer
		else if(subtype == 18 && PlayerInfo[playerid][pBanAppealer] >= level) return 1;
	}
	// Player Advisor
	else if(type == 2 && PlayerInfo[playerid][pHelper] >= 1)
	{
		if(subtype == 0 && PlayerInfo[playerid][pHelper] >= level) return 1;
		// Helper
		else if(subtype == 1 && PlayerInfo[playerid][pHelper] >= level) return 1;
		// Community Advisor
		else if(subtype == 2 && PlayerInfo[playerid][pHelper] >= level) return 1;
		// Senior Advisor
		else if(subtype == 3 && PlayerInfo[playerid][pHelper] >= level) return 1;
		// Chief Advisor
		else if(subtype == 4 && PlayerInfo[playerid][pHelper] >= level) return 1;
	}
	// Famed
	else if(type == 3 && PlayerInfo[playerid][pFamed] >= 1)
	{
		if(subtype == 0 && PlayerInfo[playerid][pFamed] >= level) return 1;
		// Old-School
		else if(subtype == 1 && PlayerInfo[playerid][pFamed] >= level) return 1;
		// Chartered Old-School
		else if(subtype == 2 && PlayerInfo[playerid][pFamed] >= level) return 1;
		// Famed
		else if(subtype == 3 && PlayerInfo[playerid][pFamed] >= level) return 1;
		// Famed Commissioner
		else if(subtype == 4 && PlayerInfo[playerid][pFamed] >= level) return 1;
		// Famed Vice-Chairman
		else if(subtype == 6 && PlayerInfo[playerid][pFamed] >= level) return 1;
	}
	// Newbie
	else if(type == 4)
	{
		if(subtype == 0 && PlayerInfo[playerid][pLevel] <= level) return 1;
	}
	// General
	else if(type == 5)
	{
		return 1;
	}
	// Account
	else if(type == 6)
	{
		return 1;
	}
	// Chat
	else if(type == 7)
	{
		return 1;
	}
	// Shop
	else if(type == 8)
	{
		return 1;
	}
	// Job
	else if(type == 9)
	{
		if(PlayerInfo[playerid][pJob] == subtype || PlayerInfo[playerid][pJob2] == subtype || PlayerInfo[playerid][pJob3] == subtype) return 1;
	}
	// Group
	else if(type == 10)
	{
		if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
		{
			if(subtype > 0)
			{
				if(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == subtype) return 1;
				else return 0;
			}
			return 1;
		}
	}
	// Group Leader
	else if(type == 11)
	{
		if(0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS)
		{
			if(subtype > 0)
			{
				if(PlayerInfo[playerid][pLeader] == subtype) return 1;
				else return 0;
			}
			return 1;
		}
	}
	// Business
	else if(type == 12)
	{
		if(subtype > 0)
		{
			if(Businesses[PlayerInfo[playerid][pBusiness]][bType] == subtype) return 1;
			else return 0;
		}
		return 1;
	}
	// VIP
	else if(type == 13)
	{
		if(subtype == 0 && PlayerInfo[playerid][pDonateRank] >= level) return 1;
		// Bronze VIP
		else if(subtype == 1 && PlayerInfo[playerid][pDonateRank] >= level) return 1;
		// Silver VIP
		else if(subtype == 2 && PlayerInfo[playerid][pDonateRank] >= level) return 1;
		// Gold VIP
		else if(subtype == 3 && PlayerInfo[playerid][pDonateRank] >= level) return 1;
		// Platinum VIP
		else if(subtype == 4 && PlayerInfo[playerid][pDonateRank] >= level) return 1;
		// VIP Moderator
		else if(subtype == 5 && PlayerInfo[playerid][pVIPMod] >= level) return 1;
	}
	// Other
	else if(type == 14)
	{
		return 1;
	}
	return 0;
}

// Function to clear search list
stock ClearHelpSearch(playerid, Clear1 = 1, Clear2 = 1)
{
	new string[16];
	for(new i = 0; i < sizeof(Help); i++)
	{
		if(Clear1)
		{
			format(string, sizeof(string), "HelpResult%i", i);
			if(GetPVarType(playerid, string))
			{
				DeletePVar(playerid, string);
			}
		}
		if(Clear2)
		{
			format(string, sizeof(string), "HelpResultCat%i", i);
			if(GetPVarType(playerid, string))
			{
				DeletePVar(playerid, string);
			}
		}
	}
	return 1;
}

CMD:rules(playerid, params[])
{
	format(szMiscArray, sizeof(szMiscArray), "Death Matching: Attacking a player in any way without a proper in character reason.");
	format(szMiscArray, sizeof(szMiscArray), "%s\n\nKilling on Sight: Attacking a player in any way with little/insufficient/no roleplay, even if you have RP reason to attack the player.", szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%s\n\nRevenge Killing: Attempting to kill the person who killed you or returning to the situation in which you died.", szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%s\n\nPowergaming: Forcing roleplay on another player or roleplaying impossible god-like/superhero abilities or the use of futuristic technologies.", szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%s\n\nMetagaming: Mixing of out of character and in character information. Using IC info oocly or using OOC info icly. Use of acronyms or smilies. (ex. 'wtf' or :)", szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%s\n\nNon-roleplay behavior: Acting in a manner that is deemed unrealstic or non-roleplay, including but not limited to: improper use of toys,\n ramming vehicles into players excessively, car surfing etc", szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%s\n\nAvoiding Roleplay: Disconnecting or using /kill to avoid roleplay/arrest etc.", szMiscArray);
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "NG-RP: Server Offences", szMiscArray, "Okay", "");
	return 1;
}

CMD:help(playerid, params[])
{
	return Help_ListCat(playerid, DIALOG_HELPCATMAIN);
}

CMD:reloadhelp(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	SendClientMessageEx(playerid, COLOR_WHITE, "Reloading all help entries...");
	return RehashHelp();
}

CMD:ohelp(playerid, params[])
{
	new string[512];
	if(PlayerInfo[playerid][pLevel] <= 3)
	{
		SendClientMessageEx(playerid, TEAM_AZTECAS_COLOR,"*** HELP *** /report /requesthelp (/newb)ie /tog newbie");
	}
	SendClientMessageEx(playerid, COLOR_WHITE,"*** ACCOUNT *** /(net)stats /inventory /quickstats /myguns /buylevel /upgrade /changepass /killcheckpoint /resetupgrades(100k)");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** CHAT *** /w(hisper) /o(oc) /s(hout) /l(ow) /b /ad(vertisement)s /f(amily) /togooc /tognews /togfam /cancelcall");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** CHAT *** /me /ame /lme /do /ldo /se(texamine) /examine");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** GENERAL *** /pay /writecheck /charity /time /buy /(check)id /music /showlicenses /clothes /mywarrants");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** GENERAL *** /apply /skill /stopani /kill /buyclothes /droplicense /calculate /refuel /car /seatbelt /checkbelt, /defendtime");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** GENERAL *** /cancel /accept /eject /contract /service /families /joinevent /nextpaycheck, /nextgift, /pointtime");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** GENERAL *** /speedo /speedopos /viewmotd /pickveh /cracktrunk /backpackhelp /nextnamechange");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** SHOP *** /shophelp /credits /sellcredits /microshop /activeitems /cooldowns");

	switch(PlayerInfo[playerid][pJob])
	{
		case 1: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /trace");
		case 2: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /lawyerduty /free /defend /wanted /offerappeal /finishappeal");
		case 3: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sex");
		case 4: cmd_odrughelp(playerid, "");
		case 5: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /dropcar");
		case 7: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fix /nos /hyd /repair /refill /mechduty");
		case 8: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /guard /frisk");
		case 9: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /sellgun");
		case 10: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sellnewcar");
		case 12: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fight");
		case 14: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getcrate");
		// case 15: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /papers /bring /deliver");
		case 17: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fare");
		case 18: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /craft");
		case 19: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /selldrink");
		case 20: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /loadshipment /checkcargo /hijackcargo");
		case 21: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getpizza*");
		case 27: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /garbagerun");
	}
	switch(PlayerInfo[playerid][pJob2])
	{
		case 1: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /trace");
		case 2: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /lawyerduty /free /defend /wanted");
		case 3: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sex");
		case 4: cmd_odrughelp(playerid, "");
		case 5: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /dropcar");
		case 7: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fix /nos /hyd /repair /refill /mechduty");
		case 8: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /guard /frisk");
		case 9: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /sellgun");
		case 10: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sellnewcar");
		case 12: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fight");
		case 14: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getcrate");
		// case 15: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /papers /bring /deliver");
		case 17: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fare");
		case 18: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /craft");
		case 19: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /selldrink");
		case 20: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /loadshipment /checkcargo /hijackcargo");
		case 21: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getpizza");
		case 27: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /garbagerun");
	}
	switch(PlayerInfo[playerid][pJob3])
	{
		case 1: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /trace");
		case 2: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /lawyerduty /free /defend /wanted");
		case 3: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sex");
		case 4: cmd_odrughelp(playerid, "");
		case 5: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /dropcar");
		case 7: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fix /nos /hyd /repair /refill /mechduty");
		case 8: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /guard /frisk");
		case 9: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /sellgun");
		case 10: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sellnewcar");
		case 12: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fight");
		case 14: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getcrate");
		// case 15: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /papers /bring /deliver");
		case 17: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fare");
		case 18: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /craft");
		case 19: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /selldrink");
		case 20: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /loadshipment /checkcargo /hijackcargo");
		case 21: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getpizza");
		case 27: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /garbagerun");
	}
	new iGroupID = PlayerInfo[playerid][pMember];
	if(iGroupID != INVALID_GROUP_ID)
	{
	    switch(arrGroupData[iGroupID][g_iGroupType])
	    {
			case 1:
			{
			    format(string, sizeof(string), "*** %s *** (/r)adio /dept (/m)egaphone (/su)spect /locker /mdc /detain /arrest /warrantarrest /wanted /cuff /tazer", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "*** %s ***  /frisk /take /ticket (/gov)ernment /clothes /ram /invite /giverank /deploy /destroy", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "*** %s ***  /spikes /revokelicense /vcheck /vmdc /vticket /tow /untow /impound /gdonate /togradio /togdept", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "*** %s ***  /flares /cones /wants /docarrest /siren /destroyplant /radargun /searchcar /vradar /copdestroy (furniture)", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
				if(PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iBugAccess]) format(string, sizeof(string), "%s /bug /listbugs /clearbugs",string);
				if(PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iFindAccess]) format(string, sizeof(string), "%s /hfind",string);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				if(arrGroupData[PlayerInfo[playerid][pMember]][g_iCrateIsland] != INVALID_RANK) {
                    format(string, sizeof(string), "*** %s ***  /cratelimit /viewcrateorders", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
				format(string, sizeof(string), "*** %s ***  /placekit /usekit /backup (code2) /backupall /backupint /calls /a(ccept)c(all) /i(gnore)c(all) /wheelclamp", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);

			}
			case 2:
			{
				format(string, sizeof(string), "*** %s *** (/f)amily /r /contracts /givemehit /order /ranks /profile /h(show)badge /hfind /togbr /execute", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "*** %s *** /plantbomb /plantcarbomb /pickupbomb /myc4 /invite /giverank /showmehq /showmehq2 /showmehq3", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			case 3:
			{
				format(string, sizeof(string), "*** %s ***  (/r)adio /dept (/m)egaphone /heal /clothes /invite /giverank /locker /gdonate", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "*** %s ***  /getpt /movept /loadpt /deliverpt /destroyplant /calls /a(ccept)c(all) /i(gnore)c(all)", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			case 4:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "*** NEWS AGENCY *** /live /news [text] /broadcast /cameraangle /clothes /invite /giverank /liveban");
   			}
			case 5:
			{
				if(PlayerInfo[playerid][pRank] < 3)
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "*** GOVERNMENT *** (/r)adio /dept /locker /mdc /deploy /destroy /spikes /tazer /frisk /cuff");
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "*** GOVERNMENT *** (/r)adio /dept /locker /settax /checktax /taxwithdraw /invite /giverank (/gov)ernment (/su)spect");
					SendClientMessageEx(playerid, COLOR_WHITE, "*** GOVERNMENT *** /mdc /detain /arrest /wanted /cuff /tazer /frisk /take /ticket /clothes /ram /invite /giverank /setbudget");
					SendClientMessageEx(playerid, COLOR_WHITE, "*** GOVERNMENT *** /spikes /destroyplant /radargun /warrantarrest /pardon /commute /wants /deploy /destroy");
				}
			}
			case 6:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "*** JUDICIAL SYSTEM *** (/r)adio /dept /warrant /warrantwd /judgefine /judgejail /judgeprison /probation /wants /subpoena");
				SendClientMessageEx(playerid, COLOR_WHITE, "*** JUDICIAL SYSTEM *** /invite /uninvite /giverank /trial /adjourn /sentence /reward /checkjudgements /reversejudgement");
				SendClientMessageEx(playerid, COLOR_WHITE, "*** JUDICIAL SYSTEM *** /present /freezebank /freezeassets /probation /gdonate /viewassets");
			}
			case 7:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "*** TRANSPORT *** /fare /ataxi /r /invite /giverank /eba /gdonate");
			}
			case 8:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "*** TOWING *** (/r)adio /dept /locker /(un)tow /impound /vcheck /vmdc /vticket /gdonate /calls /a(ccept)c(all) /i(gnore)c(all)");
			}
			case 9:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "*** FAMILY *** (/f)amily /locker /gate /clothes /repfam /repcheck /myrivals /grouptoy /drughelp");
			}
		}
		if(arrGroupData[iGroupID][g_iCrimeType] == GROUP_CRIMINAL_TYPE_RACE) SendClientMessageEx(playerid, COLOR_WHITE, "*** URL *** /countdown");
		if (0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "*** GROUP LEADER *** /invite /uninvite /ouninvite /setdiv /giverank /online /setbadge /setdivname /dvadjust");
			if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_MEDIC || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_JUDICIAL || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_TAXI || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_NEWS || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_TOWING)
			{
			    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "*** GROUP LEADER *** /viewbudget /grepocars /gvbuyback /gdonate /ordercrates /dvtrackcar /gwithdraw /dvstorage");
			}
			else if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV)
			{
			    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "*** GROUP LEADER *** /checkapps /deport");
			}
			else if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_CRIMINAL)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "*** GROUP LEADER *** /adjustwithdrawrank /myrivals");
			}
		}
	}
	if (PlayerInfo[playerid][pAdmin] >= 1 || PlayerInfo[playerid][pHelper] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "*** ADMIN *** (/a)dmin (/ah)elp");
	}
	if(PlayerInfo[playerid][pDonateRank] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_PURPLE, "*** VIP *** /travel /viplocker /tokenhelp /buddyinvite /phoneprivacy /setautoreply");
	}
	if(PlayerInfo[playerid][pDonateRank] >= 2)
	{
		format(string, sizeof(string), "*** VIP *** /spawnatvip (%s credits) /vipgunsleft", number_format(ShopItems[30][sItemPrice]));
		SendClientMessageEx(playerid, COLOR_PURPLE, string);
	}
	if(PlayerInfo[playerid][pDonateRank] >= 4)
	{
		SendClientMessageEx(playerid, COLOR_PURPLE, "*** VIP *** /freeads /pvipjob /vipplate");
	}
	if(PlayerInfo[playerid][pVIPMod])
	{
		SendClientMessageEx(playerid, COLOR_PURPLE, "*** VIP Moderator *** /vipparty /vto /vtoreset /vmute /vsuspend /vipm");
	}
	SendClientMessageEx(playerid, COLOR_WHITE,"*** OTHER *** /cellphonehelp /carhelp /househelp /toyhelp /renthelp /jobhelp /animhelp /fishhelp");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** OTHER *** /mailhelp /businesshelp /voucherhelp /backpackhelp");

	//Start of Famed Commands
	if(PlayerInfo[playerid][pFamed] >= 1)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "*** Old-School *** /fc /famedlocker /togfamed /famedplate [os/removed] /travel famed");
	}
	if(PlayerInfo[playerid][pFamed] >= 2)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "*** Chartered Old-School *** /famedplate [os/cos/removed]");
	}
    if(PlayerInfo[playerid][pFamed] >= 3)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "*** Famed *** /buyinsurance /famedplate [os/cos/famed/removed]");
	}
	if(PlayerInfo[playerid][pFamed] >= 4)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "*** Famed Commissioner *** /fmute /funmute, /fmembers");
	}
	if(PlayerInfo[playerid][pFamed] >= 6)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "*** Famed Vice-Chairman *** /osetfamed /setfamed");
	}
	//end of famed commands
	return 1;
}