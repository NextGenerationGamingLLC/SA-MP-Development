/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//-------------------------[OnDialogResponse.PWN]--------------------------------


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

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new sendername[MAX_PLAYER_NAME];
	new string[128];

	// Crash Bug Fix
 	if(strfind(inputtext, "%", true) != -1)
  	{
  	    SendClientMessageEx(playerid, COLOR_GREY, "Invalid Character, please try again.");
		return 1;
	}

	if(RegistrationStep[playerid] != 0)
	{
	    if(dialogid == REGISTERSEX)
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
					PlayerInfo[playerid][pSex] = 1;
					SendClientMessageEx(playerid, COLOR_YELLOW2, "Alright, so you're a male.");
					ShowPlayerDialog(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
					RegistrationStep[playerid] = 2;
				}
				else
				{
					PlayerInfo[playerid][pSex] = 2;
					SendClientMessageEx(playerid, COLOR_YELLOW2, "Alright, so you're a female.");
					ShowPlayerDialog(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
					RegistrationStep[playerid] = 2;
				}
			}
			else ShowPlayerDialog(playerid, REGISTERSEX, DIALOG_STYLE_LIST, "{FF0000}Is your character male or female?", "Male\nFemale", "Submit", "");
		}
	}
	if(RegistrationStep[playerid] != 0 || strcmp(PlayerInfo[playerid][pBirthDate], "0000-00-00", true) == 0)
	{
		if(dialogid == REGISTERMONTH)
	    {
			if(response)
			{
				new month = listitem+1;
				SetPVarInt(playerid, "RegisterMonth", month);

				new lastdate, stringdiag[410];
				if(listitem == 0 || listitem == 2 || listitem == 4 || listitem == 6 || listitem == 7 || listitem == 9 || listitem == 11) lastdate = 32;
				else if(listitem == 3 || listitem == 5 || listitem == 8 || listitem == 10) lastdate = 31;
				else lastdate = 29;
				for(new x = 1; x < lastdate; x++)
				{
					format(stringdiag, sizeof(stringdiag), "%s%d\n", stringdiag, x);
				}
				ShowPlayerDialog(playerid, REGISTERDAY, DIALOG_STYLE_LIST, "{FF0000}Which day was your character born?", stringdiag, "Submit", "");
			}
			else ShowPlayerDialog(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
		}
		else if(dialogid == REGISTERDAY)
	    {
			if(response)
			{
				new setday = listitem+1;
				SetPVarInt(playerid, "RegisterDay", setday);

				new month, day, year, stringdiag[600];
				getdate(year,month,day);
				new startyear = year-100;
				for(new x = startyear; x < year; x++)
				{
					format(stringdiag, sizeof(stringdiag), "%s%d\n", stringdiag, x);
				}
				ShowPlayerDialog(playerid, REGISTERYEAR, DIALOG_STYLE_LIST, "{FF0000}Which year was your character born?", stringdiag, "Submit", "");
			}
			else ShowPlayerDialog(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
		}
		else if(dialogid == REGISTERYEAR)
	    {
			new month, day, year, stringdiag[600];
			getdate(year,month,day);
			new startyear = year-100;
			if(response)
			{
				new setyear = listitem+startyear;
				format(PlayerInfo[playerid][pBirthDate], 11, "%d-%02d-%02d", setyear, GetPVarInt(playerid, "RegisterMonth"), GetPVarInt(playerid, "RegisterDay"));
				DeletePVar(playerid, "RegisterMonth");
				DeletePVar(playerid, "RegisterDay");
				if(RegistrationStep[playerid] != 0)
				{
					ShowPlayerDialog(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Next Generation Roleplay Referral System", "Have you been referred to our server by one of our players?\nIf so, please enter the player name below.\n\nIf you haven't been referred by anyone, you may press the skip button.\n\n{FF0000}Note: You must enter the player name with a underscore (Example: FirstName_LastName)", "Enter", "Skip");
				}
				else return SendClientMessageEx(playerid, COLOR_LIGHTRED, "Your birthdate has been successfully set.");
			}
			else
			{
				for(new x = startyear; x < year; x++)
				{
					format(stringdiag, sizeof(stringdiag), "%s%d\n", stringdiag, x);
				}
				ShowPlayerDialog(playerid, REGISTERYEAR, DIALOG_STYLE_LIST, "{FF0000}Which year was your character born?", stringdiag, "Submit", "");
			}
		}
		else if(dialogid == REGISTERREF)
		{
		    if(response)
		    {
		        if(IsNumeric(inputtext))
		        {
		            ShowPlayerDialog(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
		            return 1;
				}
				if(strfind(inputtext, "_", true) == -1)
				{
				    ShowPlayerDialog(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
		            return 1;
		        }
		        if(strlen(inputtext) > 20)
		        {
		            ShowPlayerDialog(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That name is too long\nPlease shorten the name.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
		            return 1;
		        }
		        if(strcmp(inputtext, GetPlayerNameExt(playerid), true) == 0)
		        {
		            ShowPlayerDialog(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error", "You can't add yourself as a referrer.\nPlease enter the referrer name or press 'Skip'.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
		            return 1;
		        }
				for(new sz = 0; sz < strlen(inputtext); sz++)
				{
				    if(inputtext[sz] == ' ')
				    {
					    ShowPlayerDialog(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
			            return 1;
			        }
			    }

			    new
			        szQuery[128], szEscape[MAX_PLAYER_NAME];

			    mysql_escape_string(inputtext, szEscape);

                format(PlayerInfo[playerid][pReferredBy], MAX_PLAYER_NAME, "%s", szEscape);

                format(szQuery, sizeof(szQuery), "SELECT `Username` FROM `accounts` WHERE `Username` = '%s'", szEscape);
         		mysql_function_query(MainPipeline, szQuery, true, "OnQueryFinish", "iii", MAIN_REFERRAL_THREAD, playerid, g_arrQueryHandle{playerid});
			}
			else {
			    format(string, sizeof(string), "Nobody");
				strmid(PlayerInfo[playerid][pReferredBy], string, 0, strlen(string), MAX_PLAYER_NAME);
  				SendClientMessageEx(playerid, COLOR_LIGHTRED, "Thanks for filling in all the information, now you can proceed to the tutorial!");
				RegistrationStep[playerid] = 3;
				SetPlayerVirtualWorld(playerid, 0);
				ClearChatbox(playerid);
				ShowTutGUIBox(playerid);
				ShowTutGUIFrame(playerid, 1);
				TutStep[playerid] = 1;

				Streamer_UpdateEx(playerid, 1607.0160,-1510.8218,207.4438);
				SetPlayerPos(playerid, 1607.0160,-1510.8218,-10.0);
				SetPlayerCameraPos(playerid, 1850.1813,-1765.7552,81.9271);
				SetPlayerCameraLookAt(playerid, 1607.0160,-1510.8218,207.4438);
			}
		}
	}
	switch(dialogid)
	{
		// BEGIN DYNAMIC GROUP CODE
		case G_LOCKER_MAIN: if(response)
		{
		    new iGroupID = PlayerInfo[playerid][pMember];
			switch(listitem)
			{
			    case 0:
			    {
				    if(PlayerInfo[playerid][pDuty]==0)
					{
						if (IsAReporter(playerid) || IsATaxiDriver(playerid))
							format(string, sizeof(string), "* %s %s takes a badge from their locker.", arrGroupRanks[iGroupID][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid));
						else
							format(string, sizeof(string), "* %s %s takes a badge and a gun from their locker.", arrGroupRanks[iGroupID][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid));

						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPlayerHealth(playerid, 100.0);
						if(IsAMedic(playerid))
						{
							Medics += 1;
						}
						if(arrGroupData[iGroupID][g_iLockerStock] > 1 && arrGroupData[iGroupID][g_iLockerCostType] == 0)
						{
							SetPlayerArmor(playerid, 100);
							arrGroupData[iGroupID][g_iLockerStock] -= 1;
							new str[128], file[32];
			                format(str, sizeof(str), "%s took a vest out of the %s locker at a cost of 1 HG Material.", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
			                new month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
							Log(file, str);
						}
						else if(arrGroupData[iGroupID][g_iLockerCostType] != 0)
						{
						    SetPlayerArmor(playerid, 100.0);
						}
						else
						{
						    SendClientMessageEx(playerid, COLOR_RED, "The locker doesn't have the stock for your armor vest.");
						    SendClientMessageEx(playerid, COLOR_GRAD2, "Contact your supervisor or the SAAS and organize a crate delivery.");
						}
						PlayerInfo[playerid][pDuty] = 1;
						SetPlayerToTeamColor(playerid);
						SendClientMessageEx(playerid, COLOR_GRAD2, "You may now select your weapons from the equipment locker");
					}
					else if(PlayerInfo[playerid][pDuty]==1)
					{
						format(string, sizeof(string), "* %s %s places their badge and gun in their locker.", arrGroupRanks[iGroupID][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						if(IsAMedic(playerid))
						{
							Medics -= 1;
						}
						SetPlayerHealth(playerid, 100.0);
						RemoveArmor(playerid);
						PlayerInfo[playerid][pDuty] = 0;
						SetPlayerToTeamColor(playerid);
					}
				}
			    case 1:
			    {
           			new
						szDialog[(32 + 8) * (MAX_GROUP_WEAPONS+1)];

					for(new i = 0; i != MAX_GROUP_WEAPONS; ++i) {
						if(arrGroupData[iGroupID][g_iLockerGuns][i]) {
							format(szDialog, sizeof szDialog, "%s\n(%i) %s", szDialog, arrGroupData[iGroupID][g_iLockerGuns][i], Weapon_ReturnName(arrGroupData[iGroupID][g_iLockerGuns][i]));
							if (arrGroupData[iGroupID][g_iLockerCostType] == 2) format(szDialog, sizeof szDialog, "%s    $%d", szDialog, arrGroupData[iGroupID][g_iLockerCost][i]);
						}
						else strcat(szDialog, "\n(empty)");
					}
					strcat(szDialog, "\nAccessories");
			        format(string, sizeof(string), "%s Weapon Locker", arrGroupData[iGroupID][g_szGroupName]);
			    	ShowPlayerDialog(playerid, G_LOCKER_EQUIPMENT, DIALOG_STYLE_LIST, string, szDialog, "Purchase", "Cancel");

			    }
			    case 2:
			    {
			        ShowPlayerDialog(playerid, G_LOCKER_UNIFORM, DIALOG_STYLE_INPUT, "Uniform","Choose a skin (by ID).", "Select", "Cancel");
			    }
			    case 3:
			    {
			        ShowPlayerDialog(playerid, G_LOCKER_CLEARSUSPECT,DIALOG_STYLE_INPUT, arrGroupData[iGroupID][g_szGroupName]," Who would you like to clear?","Clear","Return");
			    }
			    case 4: // LEOs - HP + Armour
			    {
			        if(arrGroupData[iGroupID][g_iLockerStock] > 1 && arrGroupData[iGroupID][g_iLockerCostType] == 0)
					{
						SetPlayerArmor(playerid, 100);
						SetPlayerHealth(playerid, 100.0);
						arrGroupData[iGroupID][g_iLockerStock] -= 1;
						new str[128], file[32];
		                format(str, sizeof(str), "%s took a vest out of the %s locker at a cost of 1 HG Material.", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
		                new month, day, year;
						getdate(year,month,day);
						format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
						Log(file, str);
					}
					else if(arrGroupData[iGroupID][g_iLockerCostType] == 1)
					{
					    if(arrGroupData[iGroupID][g_iBudget] > 2500)
					    {
							SetPlayerArmor(playerid, 100);
							SetPlayerHealth(playerid, 100.0);
							arrGroupData[iGroupID][g_iBudget] -= 2500;
							new str[128], file[32];
			                format(str, sizeof(str), "%s took a vest out of the %s locker at a cost of $2,500.", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
			                new month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
							Log(file, str);
					    }
					    else return SendClientMessageEx(playerid, COLOR_GRAD2, " Your agency cannot afford the vest. ($2,500)");
					}
					else if(arrGroupData[iGroupID][g_iLockerCostType] == 2)
					{
					    if(GetPlayerCash(playerid) > 2500)
					    {
							SetPlayerArmor(playerid, 100);
							SetPlayerHealth(playerid, 100.0);
							GivePlayerCash(playerid, -2500);
							new str[128], file[32];
			                format(str, sizeof(str), "%s took a vest out of the %s locker at a personal cost of $2,500.", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
			                new month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
							Log(file, str);
					    }
					    else return SendClientMessageEx(playerid, COLOR_GRAD2, " You cannot afford the vest. ($2,500)");
					}
					else
					{
					    SendClientMessageEx(playerid, COLOR_RED, "The locker doesn't have the stock for your armor vest.");
					    SendClientMessageEx(playerid, COLOR_GRAD2, "Contact your supervisor or the SAAS and organize a crate delivery.");
					}
			    }
			    case 5: // LEOs - HP + Armour Car Kit
			    {
			        if(GetPVarInt(playerid, "CarVestKit") == 1) {
			            return SendClientMessageEx(playerid, COLOR_GRAD1, "You're already carrying a car kit.");
			        }
			        if(arrGroupData[iGroupID][g_iLockerStock] > 1 && arrGroupData[iGroupID][g_iLockerCostType] == 0)
					{
					    SendClientMessageEx(playerid, COLOR_GRAD1, "You are now carrying a car kit.  Open the trunk of a vehicle and /loadkit to store it.");
						SetPVarInt(playerid, "CarVestKit", 1);
						arrGroupData[iGroupID][g_iLockerStock] -= 1;
						new str[128], file[32];
		                format(str, sizeof(str), "%s took a vest for their car out of the %s locker at a cost of 1 HG Material.", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
		                new month, day, year;
						getdate(year,month,day);
						format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
						Log(file, str);
					}
					else if(arrGroupData[iGroupID][g_iLockerCostType] == 1)
					{
					    if(arrGroupData[iGroupID][g_iBudget] > 3000)
					    {
						    SendClientMessageEx(playerid, COLOR_GRAD1, "You are now carrying a car kit.  Open the trunk of a vehicle and /loadkit to store it.");
							SetPVarInt(playerid, "CarVestKit", 1);
							arrGroupData[iGroupID][g_iBudget] -= 3000;
							new str[128], file[32];
			                format(str, sizeof(str), "%s took a vest for their car out of the %s locker at a cost of $3,000 to the budget fund.", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
			                new month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
							Log(file, str);
					    }
					    else return SendClientMessageEx(playerid, COLOR_GRAD2, " Your agency cannot afford the vest. ($3,000)");
					}
					else if(arrGroupData[iGroupID][g_iLockerCostType] == 2)
					{
					    if(GetPlayerCash(playerid) > 3000)
					    {
						    SendClientMessageEx(playerid, COLOR_GRAD1, "You are now carrying a car kit.  Open the trunk of a vehicle and /loadkit to store it.");
							SetPVarInt(playerid, "CarVestKit", 1);
							GivePlayerCash(playerid, -3000);
							new str[128], file[32];
			                format(str, sizeof(str), "%s took a vest for their car out of the %s locker at a personal cost of $3,000.", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
			                new month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
							Log(file, str);
					    }
					    else return SendClientMessageEx(playerid, COLOR_GRAD2, " You cannot afford the vest. ($3,000)");
					}
					else
					{
					    SendClientMessageEx(playerid, COLOR_RED, "The locker doesn't have the stock for your trunk kit.");
					    SendClientMessageEx(playerid, COLOR_GRAD2, "Contact your supervisor or the SAAS and organize a crate delivery.");
					}
				}
				case 6: //Tazer
				{
				    if(PlayerInfo[playerid][pHasTazer] == 0)
				    {
				        new szMessage[128];
				        format(szMessage, sizeof(szMessage), "%s reaches towards their locker, taking a tazer and cuffs out.", GetPlayerNameEx(playerid));
				        ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                        SendClientMessageEx(playerid, COLOR_WHITE, "You're now carrying a tazer and cuffs on you.");
						PlayerInfo[playerid][pHasTazer] = 1;
						PlayerInfo[playerid][pHasCuff] = 1;
					}
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You're already carrying a tazer and pair of cuffs");
				}
			}
		}
		case G_LOCKER_EQUIPMENT: if(response)
		{
			new	iGroupID = PlayerInfo[playerid][pMember];

			if (listitem == 16)
   			{
				ShowPlayerDialog(playerid, BUYTOYSCOP, DIALOG_STYLE_MSGBOX, "Accessories", "Welcome to the law enforcement accessory locker!\n\n(As with regular toys, VIP unlocks more slots.)","Continue", "Cancel");
			}
			else
			{
			    new iGunID = arrGroupData[iGroupID][g_iLockerGuns][listitem];
				if(arrGroupData[iGroupID][g_iLockerCostType] == 0)
				{
					if(arrGroupData[iGroupID][g_iLockerStock] >= arrGroupData[iGroupID][g_iLockerCost][listitem])
					{
						arrGroupData[iGroupID][g_iLockerStock] -= arrGroupData[iGroupID][g_iLockerCost][listitem];
						new str[128], file[32];
		                format(str, sizeof(str), "%s took a %s out of the %s locker at a cost of %d HG Materials.", GetPlayerNameEx(playerid), GetWeaponNameEx(iGunID), arrGroupData[iGroupID][g_szGroupName], arrGroupData[iGroupID][g_iLockerCost][listitem]);
		                new month, day, year;
						getdate(year,month,day);
						format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
						Log(file, str);
					}
					else
					{
					    SendClientMessageEx(playerid, COLOR_RED, "The locker doesn't have the stock for that weapon.");
					    SendClientMessageEx(playerid, COLOR_GRAD2, "Contact your supervisor or the SAAS and organize a crate delivery.");
					    return 1;
					}
				}
				else if(arrGroupData[iGroupID][g_iLockerCostType] == 1)
				{
					if (arrGroupData[iGroupID][g_iBudget] < arrGroupData[iGroupID][g_iLockerCost][listitem])
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Your group cannot afford that weapon!");
						return 1;
					}
					else
					{
					    arrGroupData[iGroupID][g_iBudget] -= arrGroupData[iGroupID][g_iLockerCost][listitem];
						new str[128], file[32];
		                format(str, sizeof(str), "%s took a %s out of the %s locker at a cost of %$d.", GetPlayerNameEx(playerid), GetWeaponNameEx(iGunID), arrGroupData[iGroupID][g_szGroupName], arrGroupData[iGroupID][g_iLockerCost][listitem]);
		                new month, day, year;
						getdate(year,month,day);
						format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
						Log(file, str);
					}
				}
				else if(arrGroupData[iGroupID][g_iLockerCostType] == 2)
				{
					if (GetPlayerCash(playerid) < arrGroupData[iGroupID][g_iLockerCost][listitem])
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "You can't afford that weapon!");
						return 1;
					}
					else
					{
					    GivePlayerCash(playerid, -arrGroupData[iGroupID][g_iLockerCost][listitem]);
					}
				}
				GivePlayerValidWeapon(playerid, iGunID, 99999);
			}
		}
		case G_LOCKER_UNIFORM: if(response)	{
            new skin = strval(inputtext), iGroupID = PlayerInfo[playerid][pMember];
			if(IsInvalidSkin(skin)) {
				return ShowPlayerDialog(playerid, G_LOCKER_UNIFORM, DIALOG_STYLE_INPUT, arrGroupData[iGroupID][g_szGroupName],"Invalid skin specified. Choose another.", "Select", "Cancel");
			}
			PlayerInfo[playerid][pModel] = skin;
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		}
		case G_LOCKER_CLEARSUSPECT: if(response)
		{
		    if(IsMDCPermitted(playerid))
			{
	            new giveplayerid;
	            new giveplayer[MAX_PLAYER_NAME];
	            new iGroupID = PlayerInfo[playerid][pMember];
				giveplayerid = ReturnUser(inputtext);
				if(IsPlayerConnected(giveplayerid))
				{
					if(giveplayerid != INVALID_PLAYER_ID)
					{
						GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						format(string, sizeof(string), "* You cleared the records and wanted points of %s.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* %s %s has cleared your records and wanted points.", arrGroupRanks[iGroupID][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid));
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* %s %s has cleared %s's records and wanted points.", arrGroupRanks[iGroupID][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					    SendGroupMessage(1, RADIO, string);

						PlayerInfo[giveplayerid][pWantedLevel] = 0;
						SetPlayerToTeamColor(giveplayerid);
					    SetPlayerWantedLevel(giveplayerid, 0);
	    				ClearCrimes(giveplayerid);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
					}
				}
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have sufficient clearance to do this");
		}
		case DIALOG_LISTGROUPS: if(response) {
			if (PlayerInfo[playerid][pAdmin] < 1337 && !PlayerInfo[playerid][pFactionModerator]) return 1;
			SetPVarInt(playerid, "Group_EditID", listitem);
			return Group_DisplayDialog(playerid, listitem);
		}
		case DIALOG_EDITGROUP: {
   			if (PlayerInfo[playerid][pAdmin] < 1337 && !PlayerInfo[playerid][pFactionModerator]) return 1;
			new
				iGroupID = GetPVarInt(playerid, "Group_EditID"),
				szTitle[64 + GROUP_MAX_NAME_LEN];

			if(response) switch(listitem) {
				case 0: {
					format(szTitle, sizeof szTitle, "Edit Group Name {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_NAME, DIALOG_STYLE_INPUT, szTitle, "Specify a name for this group.", "Confirm", "Cancel");
				}
				case 1: {

					new
						szDialog[(32 + 2) * MAX_GROUP_TYPES];

					for(new i = 0; i != MAX_GROUP_TYPES; ++i)
						strcat(szDialog, "\n"), strcat(szDialog, Group_ReturnType(i));

					format(szTitle, sizeof szTitle, "Edit Group Type {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_TYPE, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
				}
				case 2: {

					new
						szDialog[(32 + 2) * MAX_GROUP_TYPES];

					for(new i = 0; i < MAX_GROUP_ALLEGIANCES; ++i)
						strcat(szDialog, "\n"), strcat(szDialog, Group_ReturnAllegiance(i));

					format(szTitle, sizeof szTitle, "Edit Group Allegiance {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_ALLEGIANCE, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
				}
				case 3:
				{
					if(arrGroupData[iGroupID][g_iJCount] == 0)
					{
						format(string, sizeof(string), "%s doesn't have any jurisdiction. Add it via /groupaddjurisdiction", arrGroupData[iGroupID][g_szGroupName]);
						SendClientMessage(playerid, COLOR_GRAD2, string);
						return Group_DisplayDialog(playerid, iGroupID);
					}
					else
					{
						new szDialog[2500];

						for(new i; i < arrGroupData[iGroupID][g_iJCount]; ++i)
						{
							strcat(szDialog, "\n"), strcat(szDialog, arrGroupJurisdictions[iGroupID][i][g_iAreaName]);
						}

						format(szTitle, sizeof szTitle, "Edit Group Jurisdiction {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
						ShowPlayerDialog(playerid, DIALOG_GROUP_JURISDICTION_LIST, DIALOG_STYLE_LIST, szTitle, szDialog, "Remove", "Go Back");
					}
				}
				case 4: {
					format(szTitle, sizeof szTitle, "Edit Group Duty Color {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_DUTYCOL, DIALOG_STYLE_INPUT, szTitle, "Enter a colour in hexadecimal format (for example, BCA3FF). This colour will be used to identify the group (i.e. name tag colour).", "Confirm", "Cancel");
				}
				case 5: {
					format(szTitle, sizeof szTitle, "Edit Group Radio Color {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_RADIOCOL, DIALOG_STYLE_INPUT, szTitle, "Enter a colour in hexadecimal format (for example, BCA3FF). This colour will be used for the group's in-character radio chat.", "Confirm", "Cancel");
				}
				case 6 .. 17: {

					new
						szDialog[((32 + 5) * MAX_GROUP_RANKS) + 24];

					for(new i = 0; i != MAX_GROUP_RANKS; ++i)
						format(szDialog, sizeof szDialog, "%s\n(%i) %s", szDialog, i, ((arrGroupRanks[iGroupID][i][0]) ? (arrGroupRanks[iGroupID][i]) : ("{BBBBBB}(undefined){FFFFFF}")));

					strcat(szDialog, "\nRevoke from Group");

					strmid(szTitle, inputtext, 0, strfind(inputtext, ":", true));
					format(szTitle, sizeof szTitle, "Edit Group %s", szTitle);
					ShowPlayerDialog(playerid, DIALOG_GROUP_RADIOACC + (listitem - 6), DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
				}
				case 18: {
					format(szTitle, sizeof szTitle, "Edit Group Locker Stock {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_EDITSTOCK, DIALOG_STYLE_INPUT, szTitle, "Specify a value. Locker stock is used for weapons, and can be replenished using crates.", "Confirm", "Cancel");
				}
				case 19: {

					new
						szDialog[(32 + 8) * MAX_GROUP_WEAPONS];

					for(new i = 0; i != MAX_GROUP_WEAPONS; ++i) {
						if(arrGroupData[iGroupID][g_iLockerGuns][i]) format(szDialog, sizeof szDialog, "%s\n(%i) %s (cost: %i)", szDialog, arrGroupData[iGroupID][g_iLockerGuns][i], Weapon_ReturnName(arrGroupData[iGroupID][g_iLockerGuns][i]), arrGroupData[iGroupID][g_iLockerCost][i]);
						else strcat(szDialog, "\n(empty)");
					}

					format(szTitle, sizeof szTitle, "Edit Group Weapons {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_EDITWEPS, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
				}
				case 20: {

					new
						szDialog[(GROUP_MAX_RANK_LEN + 8) * MAX_GROUP_RANKS];

					for(new i = 0; i != MAX_GROUP_RANKS; ++i) {
						format(szDialog, sizeof szDialog, "%s\nRank %i (%s):    $%s", szDialog, i, arrGroupRanks[iGroupID][i], number_format(arrGroupData[iGroupID][g_iPaycheck][i]));
					}

					format(szTitle, sizeof szTitle, "Edit Group Paychecks {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_LISTPAY, DIALOG_STYLE_LIST, szTitle, szDialog, "Edit", "Cancel");
				}
				case 21: {

					new
						szDialog[(GROUP_MAX_DIV_LEN + 8) * MAX_GROUP_DIVS];

					for(new i = 0; i != MAX_GROUP_DIVS; ++i) {
						format(szDialog, sizeof szDialog, "%s\n(%i) %s", szDialog, i + 1, ((arrGroupDivisions[iGroupID][i][0]) ? (arrGroupDivisions[iGroupID][i]) : ("{BBBBBB}(undefined){FFFFFF}")));
					}

					format(szTitle, sizeof szTitle, "Edit Group Divisions {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_EDITDIVS, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
				}
				case 22: {

					new
						szDialog[(GROUP_MAX_RANK_LEN + 8) * MAX_GROUP_RANKS];

					for(new i = 0; i != MAX_GROUP_RANKS; ++i) {
						format(szDialog, sizeof szDialog, "%s\n(%i) %s", szDialog, i, ((arrGroupRanks[iGroupID][i][0]) ? (arrGroupRanks[iGroupID][i]) : ("{BBBBBB}(undefined){FFFFFF}")));
					}

					format(szTitle, sizeof szTitle, "Edit Group Ranks {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_EDITRANKS, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
				}
				case 23: {

					new
						szDialog[MAX_GROUP_LOCKERS * 32];

					for(new i = 0; i < MAX_GROUP_LOCKERS; ++i) {
						format(szDialog, sizeof szDialog, "%s%Locker %d %s ID:%d\n", szDialog, i+1, ( arrGroupLockers[iGroupID][i][g_fLockerPos][0] != 0.0 ) ? ("(edit)") : ("(undefined)"), arrGroupLockers[iGroupID][i]);
					}
					strcat(szDialog, "Delete All Lockers");
					format(szTitle, sizeof szTitle, "Edit Group Lockers {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_LOCKERS, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
				}
				case 24: {
					format(szTitle, sizeof szTitle, "Edit Group Crate Delivery Position {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_CRATEPOS, DIALOG_STYLE_MSGBOX, szTitle, "Are you sure you want to move the crate delivery to your position?\n\nIf not, cancel and move to your desired location.", "Cancel", "Confirm");
				}
				case 25: {
					format(szTitle, sizeof szTitle, "Edit Group Locker Cost Type {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_COSTTYPE, DIALOG_STYLE_LIST, szTitle, "Locker Stock\nGroup Budget\nPlayer Money", "OK", "Cancel");
				}
				case 26: {
					format(szTitle, sizeof szTitle, "Edit the Garage Position {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_GARAGEPOS, DIALOG_STYLE_MSGBOX, szTitle, "Please click on 'Confirm' to change the garage location to your current position.\n\nIf you do not wish to move it to your position, click on 'Cancel'.", "Cancel", "Confirm");
				}
				default: {
					format(szTitle, sizeof szTitle, "{FF0000}Disband Group{FFFFFF} {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					ShowPlayerDialog(playerid, DIALOG_GROUP_DISBAND, DIALOG_STYLE_MSGBOX, szTitle, "{FFFFFF}Are you absolutely sure you wish to {FF0000}disband this group?{FFFFFF}\n\n\
					This action will {FF0000}delete all group data and remove all members and leaders{FFFFFF} from the group, whether online or offline.", "Cancel", "Confirm");
				}
			}
			else if(GetPVarType(playerid, "Group_EditID")) { // They've made changes to a group setting - save it on exit!
				SaveGroup(GetPVarInt(playerid, "Group_EditID"));
				DeletePVar(playerid, "Group_EditID");
				return Group_ListGroups(playerid);
			}
		}
		case DIALOG_GROUP_NAME: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) {

				new
					szTitle[32 + GROUP_MAX_NAME_LEN];

				if(!(2 < strlen(inputtext) < GROUP_MAX_NAME_LEN)) {
					format(szTitle, sizeof szTitle, "Edit Group {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					return ShowPlayerDialog(playerid, DIALOG_GROUP_NAME, DIALOG_STYLE_INPUT, szTitle, "The specified name must be between 2 and "#GROUP_MAX_NAME_LEN" characters.\n\nSpecify a name for this group.", "Confirm", "Cancel");
				}
				format(string, sizeof(string), "%s has changed group %d's name from %s to %s", GetPlayerNameEx(playerid), iGroupID+1, arrGroupData[iGroupID][g_szGroupName], inputtext);
				Log("logs/editgroup.log", string);
				strcpy(arrGroupData[iGroupID][g_szGroupName], inputtext, GROUP_MAX_NAME_LEN);
			}
			return Group_DisplayDialog(playerid, GetPVarInt(playerid, "Group_EditID"));
		}
		case DIALOG_GROUP_TYPE: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) {

				arrGroupData[iGroupID][g_iGroupType] = listitem;

				format(string, sizeof(string), "%s has changed group %d's type to %s", GetPlayerNameEx(playerid), iGroupID+1, Group_ReturnType(arrGroupData[iGroupID][g_iGroupType]));
				Log("logs/editgroup.log", string);

			}
			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_ALLEGIANCE: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) arrGroupData[iGroupID][g_iAllegiance] = listitem;

			format(string, sizeof(string), "%s has changed group %d's allegiance to %s", GetPlayerNameEx(playerid), iGroupID+1, Group_ReturnAllegiance(arrGroupData[iGroupID][g_iAllegiance]));
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_JURISDICTION_LIST: {
			new iGroupID = GetPVarInt(playerid, "Group_EditID");
			if(response)
			{
				new szTitle[128], szDialog[128];
				format(szTitle, sizeof(szTitle), "%s's Jurisdiction", arrGroupData[iGroupID][g_szGroupName]);
				format(szDialog, sizeof(szDialog), "Are you sure you want to remove %s from the %s?", arrGroupJurisdictions[iGroupID][listitem][g_iAreaName], arrGroupData[iGroupID][g_szGroupName]);
				SetPVarInt(playerid, "JurisdictionRemoval", listitem);
				return ShowPlayerDialog(playerid, DIALOG_GROUP_JURISDICTION_REMOVE, DIALOG_STYLE_MSGBOX, szTitle, szDialog, "Confirm", "Cancel");
			}
			else return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_JURISDICTION_REMOVE: {
			new iGroupID = GetPVarInt(playerid, "Group_EditID");
			if(response)
			{
				new jurisdictionid = GetPVarInt(playerid, "JurisdictionRemoval");
				format(string, sizeof(string), "DELETE FROM `jurisdictions` WHERE `id` = %i", arrGroupJurisdictions[iGroupID][jurisdictionid][g_iJurisdictionSQLId]);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				mysql_function_query(MainPipeline, "SELECT * FROM `jurisdictions`", true, "Group_QueryFinish", "ii", GROUP_QUERY_JURISDICTIONS, 0);
				format(string, sizeof(string), "You have successfully removed %s from %s.", arrGroupJurisdictions[iGroupID][jurisdictionid][g_iAreaName], arrGroupData[iGroupID][g_szGroupName]);
				SendClientMessage(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "%s has removed %s from group %d's jurisdictions.", GetPlayerNameEx(playerid), arrGroupJurisdictions[iGroupID][jurisdictionid][g_iAreaName], iGroupID+1);
				Log("logs/editgroup.log", string);
			}
			DeletePVar(playerid, "JurisdictionRemoval");
			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_RADIOACC: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iRadioAccess] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iRadioAccess] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for radio (/r) to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iRadioAccess], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iRadioAccess]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_DEPTRADIOACC: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iDeptRadioAccess] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iDeptRadioAccess] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for dept radio (/dept) to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iDeptRadioAccess], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iDeptRadioAccess]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_INTRADIOACC: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iIntRadioAccess] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iIntRadioAccess] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for int radio (/int) to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iIntRadioAccess], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iIntRadioAccess]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_BUGACC: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iBugAccess] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iBugAccess] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for bug access (/bug) to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iBugAccess], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iBugAccess]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_GOVACC: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iGovAccess] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iGovAccess] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for government announcement (/gov) to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iGovAccess], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iGovAccess]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_FREENC: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iFreeNameChange] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iFreeNameChange] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for free name changes to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iFreeNameChange], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iFreeNameChange]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}

		case DIALOG_GROUP_SPIKES: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iSpikeStrips] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iSpikeStrips] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for spikes (/deployspikes) to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iSpikeStrips], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iSpikeStrips]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}

		case DIALOG_GROUP_CADES: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iBarricades] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iBarricades] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for cades (/deploycades) to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iBarricades], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iBarricades]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}

		case DIALOG_GROUP_CONES: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iCones] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iCones] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for cones (/deploycone) to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iCones], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iCones]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}

		case DIALOG_GROUP_FLARES: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iFlares] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iFlares] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for flares (/deployflares) to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iFlares], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iFlares]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}

		case DIALOG_GROUP_BARRELS: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iBarrels] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iBarrels] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for barrels (/deploybarrel) to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iBarrels], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iBarrels]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_CRATE: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) switch(listitem) {
				case MAX_GROUP_RANKS: arrGroupData[iGroupID][g_iCrateIsland] = INVALID_RANK;
				default: arrGroupData[iGroupID][g_iCrateIsland] = listitem;
			}

			format(string, sizeof(string), "%s has set the minimum rank for Crate Island Control to %d (%s) in group %d (%s)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_iCrateIsland], arrGroupRanks[iGroupID][arrGroupData[iGroupID][g_iCrateIsland]], iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/editgroup.log", string);

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_DUTYCOL: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) {

				new
					szTitle[32 + GROUP_MAX_NAME_LEN],
					hColour;

				if(strlen(inputtext) > 6 || !ishex(inputtext)) {
					format(szTitle, sizeof szTitle, "Edit Group Duty Color {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					return ShowPlayerDialog(playerid, DIALOG_GROUP_DUTYCOL, DIALOG_STYLE_INPUT, szTitle, "Invalid value specified.\n\nEnter a colour in hexadecimal format (for example, BCA3FF). This colour will be used to identify the group.", "Confirm", "Cancel");
				}
				sscanf(inputtext, "h", hColour);
				if (hColour == 0xFFFFFF) {
					format(szTitle, sizeof szTitle, "Edit Group Duty Color {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					return ShowPlayerDialog(playerid, DIALOG_GROUP_DUTYCOL, DIALOG_STYLE_INPUT, szTitle, "You cannot use white as the value.\n\nEnter a colour in hexadecimal format (for example, BCA3FF). This colour will be used to identify the group.", "Confirm", "Cancel");
				}
				arrGroupData[iGroupID][g_hDutyColour] = hColour;
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						if (PlayerInfo[i][pMember] == iGroupID) SetPlayerToTeamColor(i);
					}	
				}

				format(string, sizeof(string), "%s has set the duty color to %x in %s (%d)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_hDutyColour], arrGroupData[iGroupID][g_szGroupName], iGroupID+1);
				Log("logs/editgroup.log", string);

			}

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_RADIOCOL: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) {

				new
					szTitle[32 + GROUP_MAX_NAME_LEN],
					hColour;

				if(strlen(inputtext) > 6 || !ishex(inputtext)) {
					format(szTitle, sizeof szTitle, "Edit Group Radio Color {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					return ShowPlayerDialog(playerid, DIALOG_GROUP_RADIOCOL, DIALOG_STYLE_INPUT, szTitle, "Invalid value specified.\n\nEnter a colour in hexadecimal format (for example, BCA3FF). This colour will be used for the group's in-character radio chat.", "Confirm", "Cancel");
				}
				sscanf(inputtext, "h", hColour);
				arrGroupData[iGroupID][g_hRadioColour] = hColour;

				format(string, sizeof(string), "%s has set the radio color to %x in %s (%d)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_hRadioColour], arrGroupData[iGroupID][g_szGroupName], iGroupID+1);
				Log("logs/editgroup.log", string);

			}

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_EDITSTOCK: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) {

				new
					szTitle[32 + GROUP_MAX_NAME_LEN],
					iValue = strval(inputtext);

				if(isnull(inputtext) || iValue <= -1) {
					format(szTitle, sizeof szTitle, "Edit Group Locker Stock {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITSTOCK, DIALOG_STYLE_INPUT, szTitle, "Invalid value specified.\n\nSpecify a value. Locker stock is used for weapons, and can be replenished using crates.", "Confirm", "Cancel");
				}
				arrGroupData[iGroupID][g_iLockerStock] = iValue;

				format(string, sizeof(string), "%s has set the locker stock to %d in %s (%d)", GetPlayerNameEx(playerid), strval(inputtext), arrGroupData[iGroupID][g_szGroupName], iGroupID+1);
				Log("logs/editgroup.log", string);

			}

			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_EDITWEPS: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID"),
				szTitle[32 + GROUP_MAX_NAME_LEN];

			if(response) {
				SetPVarInt(playerid, "Group_EditWep", listitem);
				format(szTitle, sizeof szTitle, "Edit Group Weapon (%i) {%s}(%s)", listitem + 1, Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
				return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITWEPID, DIALOG_STYLE_INPUT, szTitle, "Specify a weapon ID (zero to remove this weapon).", "Select", "Cancel");
			}
			else return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_EDITWEPID: {

			new
				szTitle[32 + GROUP_MAX_NAME_LEN],
				iGroupID = GetPVarInt(playerid, "Group_EditID"),
				iWepID = GetPVarInt(playerid, "Group_EditWep");

			format(szTitle, sizeof szTitle, "Edit Group Weapon (%i) {%s}(%s)", iWepID + 1, Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
			if(response) {

				new
					iValue = strval(inputtext);

				if(isnull(inputtext) || !(0 <= iValue <= 46)) {
					return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITWEPID, DIALOG_STYLE_INPUT, szTitle, "Invalid weapon specified.\n\nSpecify a weapon ID (zero to remove this weapon).", "Select", "Cancel");
				}

				for (new i; i < MAX_GROUP_WEAPONS; i++) {
					if (arrGroupData[iGroupID][g_iLockerGuns][i] == iValue && iValue != 0)
					return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITWEPID, DIALOG_STYLE_INPUT, szTitle, "This weapon already exists in the locker.\n\nSpecify a weapon ID (zero to remove this weapon).", "Select", "Cancel");
				}

				arrGroupData[iGroupID][g_iLockerGuns][iWepID] = iValue;

				format(string, sizeof(string), "%s has changed the locker weapon (slot %d) to %d (%s) in %s (%d)", GetPlayerNameEx(playerid), iWepID, iValue, Weapon_ReturnName(iValue), arrGroupData[iGroupID][g_szGroupName], iGroupID+1);
				Log("logs/editgroup.log", string);

				if(iValue >= 1) {
					return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITCOST, DIALOG_STYLE_INPUT, szTitle, "Specify an (optional) cost for this weapon. This value will be charged in locker stock (or cash, where specified).", "Select", "Back");
				}
			}

			new
				szDialog[(32 + 8) * MAX_GROUP_WEAPONS];

			arrGroupData[iGroupID][g_iLockerCost][iWepID] = 0;
			for(new i = 0; i != MAX_GROUP_WEAPONS; ++i) {
				if(arrGroupData[iGroupID][g_iLockerGuns][i]) format(szDialog, sizeof szDialog, "%s\n(%i) %s (cost: %i)", szDialog, arrGroupData[iGroupID][g_iLockerGuns][i], Weapon_ReturnName(arrGroupData[iGroupID][g_iLockerGuns][i]), arrGroupData[iGroupID][g_iLockerCost][i]);
				else strcat(szDialog, "\n(empty)");
			}
			DeletePVar(playerid, "Group_EditWep");
			format(szTitle, sizeof szTitle, "Edit Group Weapons {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
			return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITWEPS, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
		}
		case DIALOG_GROUP_EDITCOST: {

			new
				szTitle[32 + GROUP_MAX_NAME_LEN],
				iGroupID = GetPVarInt(playerid, "Group_EditID"),
				iWepID = GetPVarInt(playerid, "Group_EditWep");

			DeletePVar(playerid, "Group_EditWep");

			if(response) {

				new
					iValue = strval(inputtext);

				if(isnull(inputtext) || iValue <= -1) {
					format(szTitle, sizeof szTitle, "Edit Group Weapon (%i) {%s}(%s)", iWepID + 1, Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITCOST, DIALOG_STYLE_INPUT, szTitle, "Invalid value specified.\n\nSpecify an (optional) cost for this weapon. This value will be charged in locker stock (or cash, where specified).", "Select", "Back");
				}
				arrGroupData[iGroupID][g_iLockerCost][iWepID] = iValue;

				format(string, sizeof(string), "%s has changed the weapon cost to %d in %s (%d)", GetPlayerNameEx(playerid), strval(inputtext));
				Log("logs/editgroup.log", string);

			}

			new
				szDialog[(32 + 8) * MAX_GROUP_WEAPONS];

			for(new i = 0; i != MAX_GROUP_WEAPONS; ++i) {
				if(arrGroupData[iGroupID][g_iLockerGuns][i]) format(szDialog, sizeof szDialog, "%s\n(%i) %s (cost: %i)", szDialog, arrGroupData[iGroupID][g_iLockerGuns][i], Weapon_ReturnName(arrGroupData[iGroupID][g_iLockerGuns][i]), arrGroupData[iGroupID][g_iLockerCost][i]);
				else strcat(szDialog, "\n(empty)");
			}
			format(szTitle, sizeof szTitle, "Edit Group Weapons {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
			return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITWEPS, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
		}
		case DIALOG_GROUP_EDITDIVS: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) {

				new
					szTitle[32 + GROUP_MAX_NAME_LEN];

				SetPVarInt(playerid, "Group_EditDiv", listitem);
				format(szTitle, sizeof szTitle, "Edit Group Division (%i) {%s}(%s)", listitem + 1, Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
				return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITDIV, DIALOG_STYLE_INPUT, szTitle, "Specify a division name (or none to disable it).", "Confirm", "Cancel");
			}
			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_EDITDIV: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID"),
				iDivID = GetPVarInt(playerid, "Group_EditDiv"),
				szTitle[32 + GROUP_MAX_NAME_LEN];

			if(response) {
				if(strlen(inputtext) >= GROUP_MAX_DIV_LEN) {
					format(szTitle, sizeof szTitle, "Edit Group Division (%i) {%s}(%s)", iDivID + 1, Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITDIV, DIALOG_STYLE_INPUT, szTitle, "The specified name must be less than "#GROUP_MAX_DIV_LEN" characters in length.\n\nSpecify a division name (or none to disable it).", "Confirm", "Cancel");
				}
				arrGroupDivisions[iGroupID][iDivID][0] = 0;
				if(!isnull(inputtext)) mysql_escape_string(inputtext, arrGroupDivisions[iGroupID][iDivID]);
			}

			new
				szDialog[(GROUP_MAX_DIV_LEN + 8) * MAX_GROUP_DIVS];

			for(new i = 0; i != MAX_GROUP_DIVS; ++i) {
				format(szDialog, sizeof szDialog, "%s\n(%i) %s", szDialog, i + 1, ((arrGroupDivisions[iGroupID][i][0]) ? (arrGroupDivisions[iGroupID][i]) : ("{AAAAAA}(undefined){FFFFFF}")));
			}

			format(szTitle, sizeof szTitle, "Edit Group Divisions {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
			ShowPlayerDialog(playerid, DIALOG_GROUP_EDITDIVS, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
			DeletePVar(playerid, "Group_EditDiv");
		}
		case DIALOG_GROUP_LOCKERS: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID"),
				szTitle[32 + GROUP_MAX_NAME_LEN];

			if(response)
			{
				format(szTitle, sizeof szTitle, "Edit Group Locker Position {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
				if (listitem == MAX_GROUP_LOCKERS)
				{
					ShowPlayerDialog(playerid, DIALOG_GROUP_LOCKERDELETECONF, DIALOG_STYLE_MSGBOX, szTitle, "{FFFFFF}Are you sure you want to delete ALL of the lockers for this group?", "Cancel", "Confirm");
					return 1;
				}
				else
				{
					SetPVarInt(playerid, "Group_EditLocker", listitem);
					ShowPlayerDialog(playerid, DIALOG_GROUP_LOCKERACTION, DIALOG_STYLE_LIST, szTitle, "Move Locker (to your current position)\nDelete Locker", "Select", "Cancel");
					return 1;
				}
			}
			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_LOCKERACTION: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID"),
				iLocker = GetPVarInt(playerid, "Group_EditLocker");

			if(response)
			{
				if (listitem == 0)
				{
					GetPlayerPos(playerid, arrGroupLockers[iGroupID][iLocker][g_fLockerPos][0], arrGroupLockers[iGroupID][iLocker][g_fLockerPos][1], arrGroupLockers[iGroupID][iLocker][g_fLockerPos][2]);
					arrGroupLockers[iGroupID][iLocker][g_iLockerVW] = GetPlayerVirtualWorld(playerid);
					DestroyDynamic3DTextLabel(arrGroupLockers[iGroupID][iLocker][g_tLocker3DLabel]);
					new szResult[128];
					format(szResult, sizeof szResult, "%s Locker\n{1FBDFF}/locker{FFFF00} to use\n ID: %i", arrGroupData[iGroupID][g_szGroupName], arrGroupLockers[iGroupID][iLocker]);
					arrGroupLockers[iGroupID][iLocker][g_tLocker3DLabel] = CreateDynamic3DTextLabel(szResult, arrGroupData[iGroupID][g_hDutyColour] * 256 + 0xFF, arrGroupLockers[iGroupID][iLocker][g_fLockerPos][0], arrGroupLockers[iGroupID][iLocker][g_fLockerPos][1], arrGroupLockers[iGroupID][iLocker][g_fLockerPos][2], 15.0, .testlos = 1, .worldid = arrGroupLockers[iGroupID][iLocker][g_iLockerVW]);
				}
				else if (listitem == 1)
				{
					arrGroupLockers[iGroupID][iLocker][g_fLockerPos][0] = 0;
					arrGroupLockers[iGroupID][iLocker][g_fLockerPos][1] = 0;
					arrGroupLockers[iGroupID][iLocker][g_fLockerPos][2] = 0;
					arrGroupLockers[iGroupID][iLocker][g_iLockerVW] = 0;
					DestroyDynamic3DTextLabel(arrGroupLockers[iGroupID][iLocker][g_tLocker3DLabel]);
					format(string, sizeof(string), "You have deleted locker %d of %s", iLocker, arrGroupData[iGroupID][g_szGroupName]);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_LISTPAY: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) {

				new
					szTitle[32 + GROUP_MAX_NAME_LEN];

				SetPVarInt(playerid, "Group_EditRank", listitem);
				format(szTitle, sizeof szTitle, "Edit Group Rank (%i) {%s}(%s)", listitem, Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
				return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITPAY, DIALOG_STYLE_INPUT, szTitle, "Specify a paycheck amount for this rank.", "OK", "Cancel");
			}
			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_EDITPAY: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID"),
				iRankID = GetPVarInt(playerid, "Group_EditRank");

			if(response) {
			    new szTitle[128];
				arrGroupData[iGroupID][g_iPaycheck][iRankID] = strval(inputtext);
				new
						szDialog[(GROUP_MAX_RANK_LEN + 8) * MAX_GROUP_RANKS];

				for(new i = 0; i != MAX_GROUP_RANKS; ++i) {
					format(szDialog, sizeof szDialog, "%s\nRank %i (%s):    $%s", szDialog, i, arrGroupRanks[iGroupID][i], number_format(arrGroupData[iGroupID][g_iPaycheck][i]));
				}

				format(szTitle, sizeof szTitle, "Edit Group Paychecks {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
				ShowPlayerDialog(playerid, DIALOG_GROUP_LISTPAY, DIALOG_STYLE_LIST, szTitle, szDialog, "Edit", "Cancel");
				format(string, sizeof(string), "%s has changed the paycheck for rank %d (%s) to $%d in %s (%d)", GetPlayerNameEx(playerid), iRankID, arrGroupRanks[iGroupID][iRankID], strval(inputtext), iGroupID + 1);
				Log("logs/editgroup.log", string);
				return 1;
			}
			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_EDITRANKS: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) {

				new
					szTitle[32 + GROUP_MAX_NAME_LEN];

				SetPVarInt(playerid, "Group_EditRank", listitem);
				format(szTitle, sizeof szTitle, "Edit Group Rank (%i) {%s}(%s)", listitem + 1, Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
				return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITRANK, DIALOG_STYLE_INPUT, szTitle, "Specify a rank name (or none to disable it).", "Confirm", "Cancel");
			}
			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_EDITRANK: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID"),
				iRankID = GetPVarInt(playerid, "Group_EditRank"),
				szTitle[32 + GROUP_MAX_NAME_LEN];

			if(response) {
				if(strlen(inputtext) >= GROUP_MAX_RANK_LEN) {
					format(szTitle, sizeof szTitle, "Edit Group Rank (%i) {%s}(%s)", iRankID + 1, Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
					return ShowPlayerDialog(playerid, DIALOG_GROUP_EDITRANK, DIALOG_STYLE_INPUT, szTitle, "The specified name must be less than "#GROUP_MAX_RANK_LEN" characters in length.\n\nSpecify a rank name (or none to disable it).", "Confirm", "Cancel");
				}
				arrGroupRanks[iGroupID][iRankID][0] = 0;
				if(!isnull(inputtext)) mysql_escape_string(inputtext, arrGroupRanks[iGroupID][iRankID]);
			}

			new
				szDialog[(GROUP_MAX_RANK_LEN + 8) * MAX_GROUP_RANKS];

			for(new i = 0; i != MAX_GROUP_RANKS; ++i) {
				format(szDialog, sizeof szDialog, "%s\n(%i) %s", szDialog, i + 1, ((arrGroupRanks[iGroupID][i][0]) ? (arrGroupRanks[iGroupID][i]) : ("{BBBBBB}(undefined){FFFFFF}")));
			}

			format(szTitle, sizeof szTitle, "Edit Group Ranks {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
			ShowPlayerDialog(playerid, DIALOG_GROUP_EDITRANKS, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Cancel");
			DeletePVar(playerid, "Group_EditRank");
		}

		case DIALOG_GROUP_CRATEPOS: {
			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(!response) {

				new
					szText[64];

				GetPlayerPos(playerid, arrGroupData[iGroupID][g_fCratePos][0], arrGroupData[iGroupID][g_fCratePos][1], arrGroupData[iGroupID][g_fCratePos][2]);
				DestroyDynamic3DTextLabel(arrGroupData[iGroupID][g_tCrate3DLabel]);

				format(szText, sizeof szText, "%s Crate Delivery Point\n{1FBDFF}/delivercrate", arrGroupData[iGroupID][g_szGroupName]);
				arrGroupData[iGroupID][g_tCrate3DLabel] = CreateDynamic3DTextLabel(szText, arrGroupData[iGroupID][g_hDutyColour] * 256 + 0xFF, arrGroupData[iGroupID][g_fCratePos][0], arrGroupData[iGroupID][g_fCratePos][1], arrGroupData[iGroupID][g_fCratePos][2], 10.0, .testlos = 1, .streamdistance = 20.0);

				format(string, sizeof(string), "%s has changed the crate position to X:%f, Y:%f, Z:%f in %s (%d)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_fCratePos][0], arrGroupData[iGroupID][g_fCratePos][1], arrGroupData[iGroupID][g_fCratePos][2], arrGroupData[iGroupID][g_szGroupName], iGroupID+1);
				Log("logs/editgroup.log", string);
			}
			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_COSTTYPE: {

			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(response) {
				format(string, sizeof(string), "%s has changed the locker cost type to %s in %s (%d)", GetPlayerNameEx(playerid), inputtext, arrGroupData[iGroupID][g_szGroupName], iGroupID+1);
				Log("logs/editgroup.log", string);
				arrGroupData[iGroupID][g_iLockerCostType] = listitem;
			}
			return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_DISBAND: {

			if(!response && PlayerInfo[playerid][pAdmin] >= 1337) {

				new
					iGroupID = GetPVarInt(playerid, "Group_EditID");
				format(string, sizeof(string), "%s has disbanded %s (%d)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName], iGroupID+1);
				Log("logs/editgroup.log", string);
				Group_DisbandGroup(iGroupID);

			}
			return Group_ListGroups(playerid);
		}
		case DIALOG_GROUP_LOCKERDELETECONF: {

			if(!response) {

				new
					iGroupID = GetPVarInt(playerid, "Group_EditID");

			    for (new i; i < MAX_GROUP_LOCKERS; i++)
			    {
    				arrGroupLockers[iGroupID][i][g_fLockerPos][0] = 0;
    				arrGroupLockers[iGroupID][i][g_fLockerPos][1] = 0;
    				arrGroupLockers[iGroupID][i][g_fLockerPos][2] = 0;
    				DestroyDynamic3DTextLabel(arrGroupLockers[iGroupID][i][g_tLocker3DLabel]);
			    }

			    SendClientMessage(playerid, COLOR_WHITE, "You have deleted all lockers of this group.");
			    format(string, sizeof(string), "%s has deleted all lockers of %s", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
				Log("logs/editgroup.log", string);

			}
			return Group_ListGroups(playerid);
		}
		case DIALOG_GROUP_JURISDICTION_ADD: {
			SetPVarInt(playerid, "Group_EditID", listitem);
  			new iGroupID = GetPVarInt(playerid, "Group_EditID");
			if(response)
			{
				if(arrGroupData[iGroupID][g_iJCount] >= MAX_GROUP_JURISDICTIONS) return SendClientMessage(playerid, COLOR_GRAD2, "Error: Cannot add anymore jurisdictions.");
				new szTitle[128], szDialog[2500];

				for(new i = 0; i < 161; ++i)
				{
					strcat(szDialog, "\n"), strcat(szDialog, AreaName[i]);
				}

				format(szTitle, sizeof szTitle, "Add Group Jurisdiction {%s}(%s)", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
				ShowPlayerDialog(playerid, DIALOG_GROUP_JURISDICTION_ADD2, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Go Back");
			}
			else return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_JURISDICTION_ADD2: {
			new iGroupID = GetPVarInt(playerid, "Group_EditID");
			if(response)
			{
				new query[256];
				format(query, sizeof(query), "INSERT INTO `jurisdictions` (`id`, `GroupID`, `JurisdictionID`, `AreaName`) VALUES (NULL, %d, %d, '%s')", iGroupID, listitem,AreaName[listitem]);
				mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				mysql_function_query(MainPipeline, "SELECT * FROM `jurisdictions`", true, "Group_QueryFinish", "ii", GROUP_QUERY_JURISDICTIONS, 0);
				format(string, sizeof(string), "You have successfully assigned %s to %s.", AreaName[listitem], arrGroupData[iGroupID][g_szGroupName]);
				SendClientMessage(playerid, COLOR_WHITE, string);
			    format(string, sizeof(string), "%s has assigned %s to %s", GetPlayerNameEx(playerid), AreaName[listitem], arrGroupData[iGroupID][g_szGroupName]);
				Log("logs/editgroup.log", string);
			}
			else return Group_DisplayDialog(playerid, iGroupID);
		}
		case DIALOG_GROUP_GARAGEPOS: {
			new
				iGroupID = GetPVarInt(playerid, "Group_EditID");

			if(!response) {			
				GetPlayerPos(playerid, arrGroupData[iGroupID][g_fGaragePos][0], arrGroupData[iGroupID][g_fGaragePos][1], arrGroupData[iGroupID][g_fGaragePos][2]);		
				SendClientMessageEx(playerid, COLOR_WHITE, "You've changed the garage position to your current location.");
				format(string, sizeof(string), "%s has changed the garage position to X:%f, Y:%f, Z:%f in %s (%d)", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_fGaragePos][0], arrGroupData[iGroupID][g_fGaragePos][1], arrGroupData[iGroupID][g_fGaragePos][2], arrGroupData[iGroupID][g_szGroupName], iGroupID+1);
				Log("logs/editgroup.log", string);
			}
			return Group_DisplayDialog(playerid, iGroupID);
		}	
		// END DYNAMIC GROUP CODE

	    case BIGEARS3: if(response) {
	        SetPVarInt(playerid, "BigEar", 5);
	        SetPVarInt(playerid, "BigEarFamily", listitem+1);
   			SendClientMessageEx(playerid, COLOR_WHITE, "You will now hear all messages from this family's chat.");
	    }
	    else ShowPlayerDialog(playerid, BIGEARS, DIALOG_STYLE_LIST, "Please choose an item to proceed", "Global Chat\nOOC Chat\nIC Chat\nFaction Chat\nFamily Chat\nPlayer\nPrivate Messages\nDisable Bigears", "Select", "Cancel");
	    case BIGEARS: if(response) switch(listitem) {
			case 0: {
			    SetPVarInt(playerid, "BigEar", 1);
			    SendClientMessage(playerid, COLOR_WHITE, "You have selected the Global Chat, you can now see all the messages server-wide.");
			}
			case 1: {
			    SetPVarInt(playerid, "BigEar", 2);
			    SendClientMessage(playerid, COLOR_WHITE, "You have selected the OOC Chat, you can now see all the OOC(/b) messages server-wide.");
			}
			case 2: {
			    SetPVarInt(playerid, "BigEar", 3);
			    SendClientMessage(playerid, COLOR_WHITE, "You have selected the IC Chat, you can now see all the IC(Includes /me's & /do's) messages server-wide.");
			}
			case 3: {
         		Group_ListGroups(playerid, BIGEARS2);
			}
			case 4: {
				new bigstring[512];
				for(new i = 0; i < sizeof(FamilyInfo); i++)
				{
					format(bigstring, sizeof(bigstring), "%s%s\n",bigstring,FamilyInfo[i][FamilyName]);
				}
			    ShowPlayerDialog(playerid, BIGEARS3, DIALOG_STYLE_LIST, "{3399FF}Please choose an item to proceed", bigstring, "Select", "Back");
			}
			case 5: {
			    ShowPlayerDialog(playerid, BIGEARS4, DIALOG_STYLE_INPUT, "{3399FF}Big Ears Player", "Please type in the name or the Id of the person you want to use the Big Ears function", "Select", "Back");
			}
			case 6: {
				ShowPlayerDialog(playerid, BIGEARS5, DIALOG_STYLE_INPUT, "{3399FF}Big Ears | Private Messages", "Please type in the name or the Id of the person you want to use the Big Ears function", "Select", "Back");
			}	
			case 7: {
			    DeletePVar(playerid, "BigEar");
			    DeletePVar(playerid, "BigEarGroup");
			    DeletePVar(playerid, "BigEarPlayer");
			    DeletePVar(playerid, "BigEarFamily");
				DeletePVar(playerid, "BigEarPM");
				DeletePVar(playerid, "BigEarPlayerPM");
				rBigEarT[playerid] = 0;
			    SendClientMessage(playerid, COLOR_WHITE, "You have disabled the bigears feature, you no longer see anything on your screen.");
			}
		}
		case BIGEARS4: {
			if(response) {
			    new giveplayerid;
			    if(sscanf(inputtext, "u", giveplayerid)) {
			        ShowPlayerDialog(playerid, BIGEARS4, DIALOG_STYLE_INPUT, "{3399FF}Big Ears Player", "Error - Please type in the name or the Id of the person you want to use the Big Ears function", "Select", "Back");
					return 1;
				}
			    SetPVarInt(playerid, "BigEar", 6);
  				SetPVarInt(playerid, "BigEarPlayer", giveplayerid);
				SendClientMessageEx(playerid, COLOR_WHITE, "You can now see all the messages from this player.");
			}
			else ShowPlayerDialog(playerid, BIGEARS, DIALOG_STYLE_LIST, "Please choose an item to proceed", "Global Chat\nOOC Chat\nIC Chat\nFaction Chat\nFamily Chat\nPlayer\nPrivate Messages\nDisable Bigears", "Select", "Cancel");
		}
		case BIGEARS5: {
			if(response) {
				new giveplayerid, szString[128];
				if(sscanf(inputtext, "u", giveplayerid)) {
			        ShowPlayerDialog(playerid, BIGEARS5, DIALOG_STYLE_INPUT, "{3399FF}Big Ears | Private Messages", "Error - Please type in the name or the Id of the person you want to use the Big Ears function", "Select", "Back");
					return 1;
				} 
				SetPVarInt(playerid, "BigEarPM", 1);
				SetPVarInt(playerid, "BigEarPlayerPM", giveplayerid);
				format(szString, sizeof(szString), "You will now receive all private messages from %s", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_WHITE, szString);
			}
			else ShowPlayerDialog(playerid, BIGEARS, DIALOG_STYLE_LIST, "Please choose an item to proceed", "Global Chat\nOOC Chat\nIC Chat\nFaction Chat\nFamily Chat\nPlayer\nPrivate Messages\nDisable Bigears", "Select", "Cancel");
		}	
		case BIGEARS2: {
			if(response) {
				new group = ListItemTrackId[playerid][listitem];
				if (arrGroupData[group][g_iGroupType] == 2 && PlayerInfo[playerid][pAdmin] < 4)
				{
					SendClientMessage(playerid, COLOR_WHITE, "Only Senior Admins+ are allowed to use this feature.");
					return 1;
				}
		    	SetPVarInt(playerid, "BigEar", 4);
	        	SetPVarInt(playerid, "BigEarGroup", group);
			}
			else ShowPlayerDialog(playerid, BIGEARS, DIALOG_STYLE_LIST, "Please choose an item to proceed", "Global Chat\nOOC Chat\nIC Chat\nFaction Chat\nFamily Chat\nPlayer\nPrivate Messages\nDisable Bigears", "Select", "Cancel");
		}
		case DIALOG_DELETECAR:
		{
			if(response)
			{
				if(GetPVarType(playerid, "vDel")) {

					new
						i = GetPVarInt(playerid, "vDel");

					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID && !PlayerVehicleInfo[playerid][i][pvImpounded] && PlayerVehicleInfo[playerid][i][pvSpawned]) {
						DestroyVehicle(PlayerVehicleInfo[playerid][i][pvId]);
						--PlayerCars;
						VehicleSpawned[playerid]--;
					}
					if(PlayerVehicleInfo[playerid][i][pvTicket] != 0)
					{
						GivePlayerCash(playerid, -PlayerVehicleInfo[playerid][i][pvTicket]);
						OnPlayerStatsUpdate(playerid);
						format(string, sizeof(string), "Your vehicle had active tickets on it. You have been charged the amount of the tickets ($%s).", number_format(PlayerVehicleInfo[playerid][i][pvTicket]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
					PlayerVehicleInfo[playerid][i][pvId] = 0;
					PlayerVehicleInfo[playerid][i][pvModelId] = 0;
					PlayerVehicleInfo[playerid][i][pvPosX] = 0.0;
					PlayerVehicleInfo[playerid][i][pvPosY] = 0.0;
					PlayerVehicleInfo[playerid][i][pvPosZ] = 0.0;
					PlayerVehicleInfo[playerid][i][pvPosAngle] = 0.0;
					PlayerVehicleInfo[playerid][i][pvLock] = 0;
					PlayerVehicleInfo[playerid][i][pvLocked] = 0;
					PlayerVehicleInfo[playerid][i][pvPaintJob] = -1;
					PlayerVehicleInfo[playerid][i][pvColor1] = 0;
					PlayerVehicleInfo[playerid][i][pvColor2] = 0;
					PlayerVehicleInfo[playerid][i][pvPrice] = 0;
					PlayerVehicleInfo[playerid][i][pvTicket] = 0;
					for(new j = 0; j < 3; j++)
					{
						PlayerVehicleInfo[playerid][i][pvWeapons][j] = 0;
					}
					PlayerVehicleInfo[playerid][i][pvImpounded] = 0;
					PlayerVehicleInfo[playerid][i][pvSpawned] = 0;
					PlayerVehicleInfo[playerid][i][pvVW] = 0;
					PlayerVehicleInfo[playerid][i][pvInt] = 0;
					DeletePVar(playerid, "vDel");

					new query[128];
					format(query, sizeof(query), "DELETE FROM `vehicles` WHERE `id` = '%d'", PlayerVehicleInfo[playerid][i][pvSlotId]);
					mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
					
					PlayerVehicleInfo[playerid][i][pvSlotId] = 0;

					return SendClientMessageEx(playerid, COLOR_WHITE, "Your vehicle has been permanently deleted.");
				}

				new
					szDialogStr[256];

				SetPVarInt(playerid, "vDel", listitem);
				if(PlayerVehicleInfo[playerid][listitem][pvTicket] != 0) format(szDialogStr, sizeof(szDialogStr), "{FFFFFF}Your {FF0000}%s{FFFFFF} will be {FF0000}permanently deleted{FFFFFF}.\n\n{FF0000}This vehicle currently has active tickets.\n{FFFFFF}You will be fined {FF0000}$%s{FFFFFF} upon vehicle deletion.\n\nYou may now confirm or cancel the deletion.", VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400], number_format(PlayerVehicleInfo[playerid][listitem][pvTicket]));
				else format(szDialogStr, sizeof(szDialogStr), "{FFFFFF}Your {FF0000}%s{FFFFFF} will be {FF0000}permanently deleted{FFFFFF}.\n\nYou may now confirm or cancel the deletion.", VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400]);
				return ShowPlayerDialog(playerid, DIALOG_DELETECAR, DIALOG_STYLE_MSGBOX, "Delete Vehicle", szDialogStr, "Delete", "Cancel");
			}
			else return DeletePVar(playerid, "vDel");
		}
		case DIALOG_ADCATEGORY: if(response) switch(listitem) {
			case 0: {

				new
					szDialog[2256],
					szBuffer[32],
					arrAdverts[MAX_PLAYERS] = INVALID_PLAYER_ID,
					iDialogCount,
					iCount,
					iBreak,
					iRand;

				for(new x; x < 50; ++x) ListItemTrackId[playerid][x] = -1;
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{				
						if(!isnull(szAdvert[i])) arrAdverts[iCount++] = i;
					}
				}

				while(iDialogCount < 50 && iBreak < 500) {
					iRand = random(iCount);
					if(arrAdverts[iRand] != INVALID_PLAYER_ID) {
						if(AdvertType[arrAdverts[iRand]] == 1) //Real Estate
						{
							strcpy(szBuffer, szAdvert[arrAdverts[iRand]], sizeof(szBuffer));
							if(PlayerInfo[playerid][pAdmin] <= 1) format(szDialog, sizeof(szDialog), "%s%s... (%i)\r\n", szDialog, szBuffer, PlayerInfo[arrAdverts[iRand]][pPnumber]);
							else format(szDialog, sizeof(szDialog), "%s%s... (%s)\r\n", szDialog, szBuffer, GetPlayerNameEx(arrAdverts[iRand]));
							ListItemTrackId[playerid][iDialogCount++] = arrAdverts[iRand];
							arrAdverts[iRand] = INVALID_PLAYER_ID;	
						}
					}
					++iBreak;
				}
				if(!isnull(szDialog)) return ShowPlayerDialog(playerid, DIALOG_ADLIST, DIALOG_STYLE_LIST, "Advertisements - List", szDialog, "Select", "Return");
				ShowPlayerDialog(playerid, DIALOG_ADCATEGORY, DIALOG_STYLE_LIST, "Advertisements Categories", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
				SendClientMessage(playerid, COLOR_GREY, "No advertisements have been posted.");
			}
			case 1: {

				new
					szDialog[2256],
					szBuffer[32],
					arrAdverts[MAX_PLAYERS] = INVALID_PLAYER_ID,
					iDialogCount,
					iCount,
					iBreak,
					iRand;

				for(new x; x < 50; ++x) ListItemTrackId[playerid][x] = -1;
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{				
						if(!isnull(szAdvert[i])) arrAdverts[iCount++] = i;
					}
				}

				while(iDialogCount < 50 && iBreak < 500) {
					iRand = random(iCount);
					if(arrAdverts[iRand] != INVALID_PLAYER_ID) {
						if(AdvertType[arrAdverts[iRand]] == 2) //Automobile
						{
							strcpy(szBuffer, szAdvert[arrAdverts[iRand]], sizeof(szBuffer));
							if(PlayerInfo[playerid][pAdmin] <= 1) format(szDialog, sizeof(szDialog), "%s%s... (%i)\r\n", szDialog, szBuffer, PlayerInfo[arrAdverts[iRand]][pPnumber]);
							else format(szDialog, sizeof(szDialog), "%s%s... (%s)\r\n", szDialog, szBuffer, GetPlayerNameEx(arrAdverts[iRand]));
							ListItemTrackId[playerid][iDialogCount++] = arrAdverts[iRand];
							arrAdverts[iRand] = INVALID_PLAYER_ID;
						}
					}
					++iBreak;
				}
				if(!isnull(szDialog)) return ShowPlayerDialog(playerid, DIALOG_ADLIST, DIALOG_STYLE_LIST, "Advertisements - List", szDialog, "Select", "Return");
				ShowPlayerDialog(playerid, DIALOG_ADCATEGORY, DIALOG_STYLE_LIST, "Advertisements Categories", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
				SendClientMessage(playerid, COLOR_GREY, "No advertisements have been posted.");
			}
			case 2: {

				new
					szDialog[2256],
					szBuffer[32],
					arrAdverts[MAX_PLAYERS] = INVALID_PLAYER_ID,
					iDialogCount,
					iCount,
					iBreak,
					iRand;

				for(new x; x < 50; ++x) ListItemTrackId[playerid][x] = -1;
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{				
						if(!isnull(szAdvert[i])) arrAdverts[iCount++] = i;
					}
				}

				while(iDialogCount < 50 && iBreak < 500) {
					iRand = random(iCount);
					if(arrAdverts[iRand] != INVALID_PLAYER_ID) {
						if(AdvertType[arrAdverts[iRand]] == 3) //Buying
						{
							strcpy(szBuffer, szAdvert[arrAdverts[iRand]], sizeof(szBuffer));
							if(PlayerInfo[playerid][pAdmin] <= 1) format(szDialog, sizeof(szDialog), "%s%s... (%i)\r\n", szDialog, szBuffer, PlayerInfo[arrAdverts[iRand]][pPnumber]);
							else format(szDialog, sizeof(szDialog), "%s%s... (%s)\r\n", szDialog, szBuffer, GetPlayerNameEx(arrAdverts[iRand]));
							ListItemTrackId[playerid][iDialogCount++] = arrAdverts[iRand];
							arrAdverts[iRand] = INVALID_PLAYER_ID;
						}
					}
					++iBreak;
				}
				if(!isnull(szDialog)) return ShowPlayerDialog(playerid, DIALOG_ADLIST, DIALOG_STYLE_LIST, "Advertisements - List", szDialog, "Select", "Return");
				ShowPlayerDialog(playerid, DIALOG_ADCATEGORY, DIALOG_STYLE_LIST, "Advertisements Categories", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
				SendClientMessage(playerid, COLOR_GREY, "No advertisements have been posted.");
			}
			case 3: {

				new
					szDialog[2256],
					szBuffer[32],
					arrAdverts[MAX_PLAYERS] = INVALID_PLAYER_ID,
					iDialogCount,
					iCount,
					iBreak,
					iRand;

				for(new x; x < 50; ++x) ListItemTrackId[playerid][x] = -1;
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{				
						if(!isnull(szAdvert[i])) arrAdverts[iCount++] = i;
					}
				}

				while(iDialogCount < 50 && iBreak < 500) {
					iRand = random(iCount);
					if(arrAdverts[iRand] != INVALID_PLAYER_ID) {
						if(AdvertType[arrAdverts[iRand]] == 4) //Selling
						{
							strcpy(szBuffer, szAdvert[arrAdverts[iRand]], sizeof(szBuffer));
							if(PlayerInfo[playerid][pAdmin] <= 1) format(szDialog, sizeof(szDialog), "%s%s... (%i)\r\n", szDialog, szBuffer, PlayerInfo[arrAdverts[iRand]][pPnumber]);
							else format(szDialog, sizeof(szDialog), "%s%s... (%s)\r\n", szDialog, szBuffer, GetPlayerNameEx(arrAdverts[iRand]));
							ListItemTrackId[playerid][iDialogCount++] = arrAdverts[iRand];
							arrAdverts[iRand] = INVALID_PLAYER_ID;	
						}
					}
					++iBreak;
				}
				if(!isnull(szDialog)) return ShowPlayerDialog(playerid, DIALOG_ADLIST, DIALOG_STYLE_LIST, "Advertisements - List", szDialog, "Select", "Return");
				ShowPlayerDialog(playerid, DIALOG_ADCATEGORY, DIALOG_STYLE_LIST, "Advertisements Categories", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
				SendClientMessage(playerid, COLOR_GREY, "No advertisements have been posted.");
			}
			case 4: {

				new
					szDialog[2256],
					szBuffer[32],
					arrAdverts[MAX_PLAYERS] = INVALID_PLAYER_ID,
					iDialogCount,
					iCount,
					iBreak,
					iRand;

				for(new x; x < 50; ++x) ListItemTrackId[playerid][x] = -1;
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{				
						if(!isnull(szAdvert[i])) arrAdverts[iCount++] = i;
					}
				}

				while(iDialogCount < 50 && iBreak < 500) {
					iRand = random(iCount);
					if(arrAdverts[iRand] != INVALID_PLAYER_ID) {
						if(AdvertType[arrAdverts[iRand]] == 5) //Miscellaneous
						{
							strcpy(szBuffer, szAdvert[arrAdverts[iRand]], sizeof(szBuffer));
							if(PlayerInfo[playerid][pAdmin] <= 1) format(szDialog, sizeof(szDialog), "%s%s... (%i)\r\n", szDialog, szBuffer, PlayerInfo[arrAdverts[iRand]][pPnumber]);
							else format(szDialog, sizeof(szDialog), "%s%s... (%s)\r\n", szDialog, szBuffer, GetPlayerNameEx(arrAdverts[iRand]));
							ListItemTrackId[playerid][iDialogCount++] = arrAdverts[iRand];
							arrAdverts[iRand] = INVALID_PLAYER_ID;
						}	
					}
					++iBreak;
				}
				if(!isnull(szDialog)) return ShowPlayerDialog(playerid, DIALOG_ADLIST, DIALOG_STYLE_LIST, "Advertisements - List", szDialog, "Select", "Return");
				ShowPlayerDialog(playerid, DIALOG_ADCATEGORY, DIALOG_STYLE_LIST, "Advertisements Categories", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
				SendClientMessage(playerid, COLOR_GREY, "No advertisements have been posted.");
			}
		}	
		case DIALOG_ADMAIN: if(response) switch(listitem) {
			case 0: ShowPlayerDialog(playerid, DIALOG_ADCATEGORY, DIALOG_STYLE_LIST, "Advertisements Categories", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
			case 1: ShowPlayerDialog(playerid, DIALOG_ADSEARCH, DIALOG_STYLE_INPUT, "Advertisements - Search", "Enter a search phrase.", "Search", "Return");
			case 2: {
				if(PlayerInfo[playerid][pADMute] == 1) {
					SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
				}
				else if(PlayerInfo[playerid][pPnumber] == 0) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a cell phone.");
				}
				else ShowPlayerDialog(playerid, DIALOG_ADCATEGORYPLACE, DIALOG_STYLE_LIST, "Select a category", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
			}
			case 3: {
				if(PlayerInfo[playerid][pADMute] == 1) {
					SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
				}
				else if(PlayerInfo[playerid][pPnumber] == 0) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a cell phone.");
				}
				else if(gettime() < GetPVarInt(playerid, "adT")) {
					ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
					return SendClientMessageEx(playerid, COLOR_GREY, "You may only place one priority advertisement every two minutes.");
				}	
				else if(gettime() < iAdverTimer) {
					ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
					return SendClientMessageEx(playerid, COLOR_GREY, "Only one priority advertisement can be placed every 30 seconds.");
				}
				else
				{
					if(PlayerInfo[playerid][pAdvertVoucher] != 0)
					{
						ShowPlayerDialog(playerid, DIALOG_ADVERTVOUCHER, DIALOG_STYLE_MSGBOX, "Priority Advertisement Voucher", "We found a Priority Advertisement Voucher on your account, would you like to use it?\n\n{FF0000}Note: You will lose 1 voucher if you choose yes.{FFFFFF}", "Yes", "Nope");
					}
					else if(PlayerInfo[playerid][pAdvertVoucher] == 0)
						return ShowPlayerDialog(playerid, DIALOG_ADCATEGORYPLACEP, DIALOG_STYLE_LIST, "Select a category", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
				}
			}
		}
		case DIALOG_ADCATEGORYPLACE: {
			if(response) switch(listitem) {
				case 0: {
					AdvertType[playerid] = 1;
					ShowPlayerDialog(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Advertisements",
					"Enter your Real Estate Advertisement! Keep it below 128 characters.", "Submit", "Return");
				}
				case 1: {
					AdvertType[playerid] = 2;
					ShowPlayerDialog(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Advertisements",
					"Enter your Automobile Advertisement! Keep it below 128 characters.", "Submit", "Return");
				}	
				case 2: {
					AdvertType[playerid] = 3;
					ShowPlayerDialog(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Advertisements",
					"Enter your Buying Advertisement! Keep it below 128 characters.", "Submit", "Return");
				}
				case 3: {
					AdvertType[playerid] = 4;
					ShowPlayerDialog(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Advertisements",
					"Enter your Selling Advertisement! Keep it below 128 characters.", "Submit", "Return");
				}
				case 4: {
					AdvertType[playerid] = 5;
					ShowPlayerDialog(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Advertisements",
					"Enter your Miscellaneous Advertisement! Keep it below 128 characters.", "Submit", "Return");
				}
			}
		}	
		case DIALOG_ADCATEGORYPLACEP: {
			if(response) switch(listitem) {
				case 0: {
					AdvertType[playerid] = 1;
					ShowPlayerDialog(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your Real Estate Priority Advertisement! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}
				case 1: {
					AdvertType[playerid] = 2;
					ShowPlayerDialog(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your Automobile Priority Advertisement! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}	
				case 2: {
					AdvertType[playerid] = 3;
					ShowPlayerDialog(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your Buying Priority Advertisement! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}
				case 3: {
					AdvertType[playerid] = 4;
					ShowPlayerDialog(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your Selling Priority Advertisement! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}
				case 4: {
					AdvertType[playerid] = 5;
					ShowPlayerDialog(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your Miscellaneous Priority Advertisement! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}
			}
		}		
		case DIALOG_ADPLACE: {
			if(response) {

				new iLength = strlen(inputtext);
				
				if(GetPVarInt(playerid, "RequestingAdP") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have a priority advertisement pending.");

				if(!(2 <= iLength <= 127)) {
					ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
					return SendClientMessageEx(playerid, COLOR_GREY, "Your input was too long or too short.");
				}

				iLength *= 50;
				if(GetPlayerCash(playerid) < iLength) {
					ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
					return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough cash for this.");
				}
				strcpy(szAdvert[playerid], inputtext, 128);
				StripColorEmbedding(szAdvert[playerid]);
				GivePlayerCash(playerid, -iLength);
				SendClientMessageEx(playerid, COLOR_WHITE, "Congratulations, you have placed your advertisement!");
			}
			else ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
		}
		case DIALOG_ADPLACEP: {
			if(response) {
				if(GetPVarInt(playerid, "RequestingAdP") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have a priority advertisement pending.");
			
				if(gettime() < iAdverTimer) {
					SendClientMessageEx(playerid, COLOR_GREY, "Only one priority advertisement can be placed every 30 seconds.");
					return ShowPlayerDialog(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Advertisements - Priority Advertisement",
					"Enter your desired advertisement text! Keep it below 128 characters.\nAs this is a priority advertisement, it will be broadcasted, and will cost you $150,000.", "Submit", "Return");
				}
				if(!(2 <= strlen(inputtext) <= 79)) {
					ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
					return SendClientMessageEx(playerid, COLOR_GREY, "Your input was too long or too short.");
				}				
				if(GetPVarInt(playerid, "AdvertVoucher") > 0)
				{
				}
				else if(PlayerInfo[playerid][pFreeAdsLeft] > 0)
				{
				}
				else if(PlayerInfo[playerid][pDonateRank] == 2 && GetPlayerCash(playerid) < 125000) {
					ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
					return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough cash for this.");
				}
				else if(PlayerInfo[playerid][pDonateRank] == 3 && GetPlayerCash(playerid) < 100000) {
					ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
					return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough cash for this.");
				}
				else if(PlayerInfo[playerid][pDonateRank] >= 4 && GetPlayerCash(playerid) < 50000) {
					ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
					return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough cash for this.");
				}
				else if(GetPlayerCash(playerid) < 150000) {
					ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
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
			else ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
		}
		case DIALOG_ADSEARCH: {
			if(response) {

				if(!(4 <= strlen(inputtext) <= 80)) {
					return ShowPlayerDialog(playerid, DIALOG_ADSEARCH, DIALOG_STYLE_INPUT, "Advertisements - Search", "Queries must be between 4\n and 80 characters in length.\n\nEnter a search phrase.", "Search", "Return");
				}
				else for(new x; x < 50; ++x) ListItemTrackId[playerid][x] = -1;

				new
					szDialog[2256],
					szSearch[80],
					szBuffer[32],
					iCount;

				strcat(szSearch, inputtext, sizeof(szSearch)); // strfind is a piece of shit when it comes to non-indexed arrays, maybe this'll help.
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
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
				}
				if(!isnull(szDialog)) ShowPlayerDialog(playerid, DIALOG_ADSEARCHLIST, DIALOG_STYLE_LIST, "Advertisements - Search Results", szDialog, "Select", "Return");
				else ShowPlayerDialog(playerid, DIALOG_ADSEARCH, DIALOG_STYLE_INPUT, "Advertisements - Search", "No results found.\n\nEnter a search phrase.", "Search", "Return");

			}
			else ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
		}
		case DIALOG_ADSEARCHLIST: if(response) {

			new
				i = ListItemTrackId[playerid][listitem],
				szDialog[164];

			if(IsPlayerConnected(i) && !isnull(szAdvert[i])) {
				SetPVarInt(playerid, "advertContact", PlayerInfo[i][pPnumber]);
				format(szDialog, sizeof(szDialog), "%s\r\nContact: %i", szAdvert[i], PlayerInfo[i][pPnumber]);
				ShowPlayerDialog(playerid, DIALOG_ADFINAL, DIALOG_STYLE_MSGBOX, "Advertisements - Search Result", szDialog, "Call", "Exit");
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
					return ShowPlayerDialog(playerid, DIALOG_ADFINAL, DIALOG_STYLE_MSGBOX, "Advertisements - Search Result", szDialog, "Call", "Exit");
				}
				else SendClientMessage(playerid, COLOR_GREY, "This person has either disconnected or withdrawn their advertisement.");
			}
			else ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
		}
		case DIALOG_ADVERTVOUCHER:
		{
			if(response) // Clicked Yes
			{
				SendClientMessageEx(playerid, COLOR_CYAN, "You have use 1 Priority Advertisement.");
				PlayerInfo[playerid][pAdvertVoucher]--;
				SetPVarInt(playerid, "AdvertVoucher", 1);
				ShowPlayerDialog(playerid, DIALOG_ADCATEGORYPLACEP, DIALOG_STYLE_LIST, "Select a category", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
			}
			else // Clicked No
			{
				ShowPlayerDialog(playerid, DIALOG_ADCATEGORYPLACEP, DIALOG_STYLE_LIST, "Select a category", "Real Estate\nAutomobile\nBuying\nSelling\nMiscellaneous", "Select", "Cancel");
			}
		}
	}
    if(dialogid == RCPINTRO)
    {
        if (response)
	    {
	        new msgstring[218];
			format(msgstring,sizeof(msgstring),"\tThere are stages you follow in order to make a checkpoint;\n1.- Adjusting the position of the checkpoint.\n2.- Confirm the position of the checkpoint.\n3.- Set the checkpoint size.\n4.- Set the checkpoint type.");
			ShowPlayerDialog(playerid,RCPINTRO2,DIALOG_STYLE_MSGBOX,"Race Checkpoints Introduction",msgstring,"Start","Cancel");
	    }
	    else
	    {
			format(string,sizeof(string),"Create a checkpoint...\nEdit an existing checkpoint\nRemove checkpoint preview");
			ShowPlayerDialog(playerid,RCPCHOOSE,DIALOG_STYLE_LIST,"Race Checkpoints Configuration",string,"Okay","I'm done!");
            ConfigEventCPId[playerid] = 0;
			ConfigEventCPs[playerid][1] = 0;
	    }
    }
    if(dialogid == RCPINTRO2)
    {
        if (response)
	    {
	        format(string,sizeof(string),"Create a checkpoint...\nEdit an existing checkpoint\nRemove checkpoint preview");
			ShowPlayerDialog(playerid,RCPCHOOSE,DIALOG_STYLE_LIST,"Race Checkpoints Configuration",string,"Okay","I'm done!");
			ConfigEventCPId[playerid] = 0;
			ConfigEventCPs[playerid][1] = 0;
	    }
    }
    if(dialogid == RCPCHOOSE)
    {
        if (response && ConfigEventCPs[playerid][0] == 1)
	    {
	        if(listitem == 0) // Create a checkpoint
	        {
	            if(ConfigEventCPs[playerid][1] != 0) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: You cannot create a new checkpoint since you are editing an existing one.");
	            if(ConfigEventCPId[playerid] >= 20) {
	                ConfigEventCPs[playerid][0] = 0;
	                ConfigEventCPs[playerid][1] = 0;
					ConfigEventCPId[playerid] = 0;
					return SendClientMessageEx(playerid, COLOR_RED, "ERROR: You cannot create a new checkpoint since you have reached the checkpoint limit(20).");
				}
				new i;
				for(i = 0; i < 20; i++)
				{
				    if(EventRCPU[i] == 0) break;
				}
				if(i >= 20) {
	                ConfigEventCPs[playerid][0] = 0;
	                ConfigEventCPs[playerid][1] = 0;
					ConfigEventCPId[playerid] = 0;
					return SendClientMessageEx(playerid, COLOR_RED, "ERROR: You cannot create a new checkpoint since you have reached the checkpoint limit(20).");
				}
				ConfigEventCPId[playerid] = i;
				ConfigEventCPs[playerid][1] = 1;
				ConfigEventCPs[playerid][2] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You are now creating a new checkpoint, you need to choose the position where the checkpoint will be at.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "NOTE: Once you are done and have the right place please press the fire button to save the position.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "NOTE: You can also cancel this action by pressing the AIM button.");
			}
			else if(listitem == 1) // Edit an existing checkpoint IN PROCESS
			{
			    if(ConfigEventCPs[playerid][1] != 0) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: You cannot edit a checkpoint since you are editing an existing one.");
			    new bigstring[798], totalrcps;
			    for(new i = 0; i < 20; i++)
				{
					if(EventRCPU[i] > 0) {
					    switch(EventRCPT[i]) {
							case 1:
							{
					    		format(bigstring, sizeof(bigstring), "%s(RCPID:%i) Start Checkpoint", bigstring, i+1);
								format(bigstring, sizeof(bigstring), "%s\n", bigstring);
							}
							case 2:
							{
					    		format(bigstring, sizeof(bigstring), "%s(RCPID:%i) Normal Checkpoint", bigstring, i+1);
								format(bigstring, sizeof(bigstring), "%s\n", bigstring);
							}
							case 3:
							{
					    		format(bigstring, sizeof(bigstring), "%s(RCPID:%i) Watering Station Checkpoint", bigstring, i+1);
								format(bigstring, sizeof(bigstring), "%s\n", bigstring);
							}
							case 4:
							{
					    		format(bigstring, sizeof(bigstring), "%s(RCPID:%i) Finish Checkpoint", bigstring, i+1);
								format(bigstring, sizeof(bigstring), "%s\n", bigstring);
							}
							default:
							{
							    format(bigstring, sizeof(bigstring), "%s(RCPID:%i) No Checkpoint type", bigstring, i+1);
								format(bigstring, sizeof(bigstring), "%s\n", bigstring);
							}
						}
						ListItemRCPId[playerid][totalrcps] = i;
						totalrcps++;
					}
				}
				if(totalrcps == 0) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: No checkpoints have been created.");
				ShowPlayerDialog(playerid, RCPEDITMENU, DIALOG_STYLE_LIST,"Please choose a checkpoint to edit:", bigstring, "Edit", "Cancel");
			}
			else if(listitem == 2) // Remove view of checkpoint
			{
			    DisablePlayerCheckpoint(playerid);
			    SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled your race checkpoints.");
			}
	    }
    }
    if(dialogid == RCPEDITMENU)
    {
        ConfigEventCPs[playerid][2] = 0;
        ConfigEventCPId[playerid] = ListItemRCPId[playerid][listitem];
        ConfigEventCPs[playerid][1] = 0;
        DisablePlayerCheckpoint(playerid);
	    if(EventRCPT[ConfigEventCPId[playerid]] == 1) {
			SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
		}
		else if(EventRCPT[ConfigEventCPId[playerid]] == 4) {
		    SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
		}
		else {
		    SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
		}
        format(string,sizeof(string),"Checkpoint Edit(ID:%d)", ConfigEventCPId[playerid]);
		ShowPlayerDialog(playerid,RCPEDITMENU2,DIALOG_STYLE_LIST,string,"Edit position\nEdit size\nEdit type\nView checkpoint","Okay","I'm done!");
    }
    if(dialogid == RCPEDITMENU2)
    {
        if (response)
	    {
	        if(listitem == 0) // Edit position
	        {
				ConfigEventCPs[playerid][1] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You are now creating editing this checkpoint's position, you need to choose the position where the checkpoint will be at.");
				SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: Press the FIRE button to save the position. You can cancel this action by pressing the AIM button.");
         	}
			else if(listitem == 1) // edit size
			{
			    ConfigEventCPs[playerid][1] = 3;
                format(string,sizeof(string),"Race Checkpoint %d Size", ConfigEventCPId[playerid]);
				ShowPlayerDialog(playerid,RCPSIZE,DIALOG_STYLE_INPUT,string,"Please choose the size of the checkpoint.\nRecommended size: 5.0","Ok","Cancel");
			}
			else if(listitem == 2) // edit type
			{
                ConfigEventCPs[playerid][1] = 4;
                ShowPlayerDialog(playerid,RCPTYPE,DIALOG_STYLE_LIST,"Race Checkpoints Type List","1.- Start checkpoint\n2.- Normal checkpoint\n3.- Watering Station\n4.- Finish checkpoint","Okay","Cancel");
			}
			else if(listitem == 3) // view checkpoint
			{
	        	if(EventRCPT[ConfigEventCPId[playerid]] == 1) {
					SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
				else if(EventRCPT[ConfigEventCPId[playerid]] == 4) {
				    SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
				else {
				    SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
				SetPlayerPos(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]]);
				SendClientMessageEx(playerid, COLOR_WHITE, "You now have a view of this checkpoint, you are inside of the checkpoint, step outside to see it.");
			}
	    }
    }
    if(dialogid == RCPTYPE)
    {
        if (response && ConfigEventCPs[playerid][0] == 1)
	    {
	        if(listitem == 0) // Start checkpoint
	        {
				EventRCPT[ConfigEventCPId[playerid]] = 1;
				DisablePlayerCheckpoint(playerid);
	    		ConfigEventCPs[playerid][1] = 0;
	    		ConfigEventCPs[playerid][0] = 0;
	    		SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
         	}
			else if(listitem == 1) // Normal Checkpoint
			{
			    EventRCPT[ConfigEventCPId[playerid]] = 2;
			    DisablePlayerCheckpoint(playerid);
	    		ConfigEventCPs[playerid][1] = 0;
	    		ConfigEventCPs[playerid][0] = 0;
	    		SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}
			else if(listitem == 2) // Watering Checkpoint
			{
			    EventRCPT[ConfigEventCPId[playerid]] = 3;
			    DisablePlayerCheckpoint(playerid);
	    		ConfigEventCPs[playerid][1] = 0;
	    		ConfigEventCPs[playerid][0] = 0;
	    		SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}
			else if(listitem == 3) // Finish Checkpoint
			{
			    EventRCPT[ConfigEventCPId[playerid]] = 4;
       			DisablePlayerCheckpoint(playerid);
	    		ConfigEventCPs[playerid][1] = 0;
	    		ConfigEventCPs[playerid][0] = 0;
	    		SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}
	    }
    }
    if(dialogid == RCPSIZE)
    {
        if(response && ConfigEventCPs[playerid][0] == 1)
        {
            if(strlen(inputtext) < 1)
	    	{
	        	format(string,sizeof(string),"Race Checkpoint %d Size", ConfigEventCPId[playerid]);
				ShowPlayerDialog(playerid,RCPSIZE,DIALOG_STYLE_INPUT,string,"Please type a number for the size of the checkpoint","Ok","Cancel");
				return 1;
	    	}
	    	new Float: rcpsize;
	    	rcpsize = floatstr(inputtext);
	    	if(rcpsize < 1.0 && rcpsize > 15.0) return 1;
	    	EventRCPS[ConfigEventCPId[playerid]] = rcpsize;
	    	SendClientMessage(playerid, COLOR_WHITE, "Successfully changed the size, updating preview...");
	        /*if(EventRCPT[ConfigEventCPId[playerid]] == 1) {
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}
			else if(EventRCPT[ConfigEventCPId[playerid]] == 4) {
				DisablePlayerCheckpoint(playerid);
			    SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}*/
			DisablePlayerCheckpoint(playerid);
			if(ConfigEventCPs[playerid][2] == 1) {
				ConfigEventCPs[playerid][1] = 4;
				ShowPlayerDialog(playerid,RCPTYPE,DIALOG_STYLE_LIST,"Race Checkpoints Type List","1.- Start checkpoint\n2.- Normal checkpoint\n3.- Watering Station\n4.- Finish checkpoint","Okay","Cancel");
			}
			else
			{
				 SetTimerEx("RFLCheckpointu", 1000, false, "i", playerid);
				//SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}	
		}
    }
	if(dialogid == UNMODCARMENU)
	{
	    if (response)
	    {
		    new count = GetPVarInt(playerid, "modCount");
			new d;
			for(new z = 0 ; z < MAX_PLAYERVEHICLES; z++)
			{
				if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][z][pvId]))
				{
					d = z;
				    break;
				}
			}
            for (new i = 0; i < count; i++)
			{
				if(listitem == i)
				{
				    format(string, sizeof(string), "partList%i", i);
					new partID = GetPVarInt(playerid, string);
					if (partID == 999)
					{
					    for(new f = 0 ; f < MAX_MODS; f++)
						{
							SetPVarInt(playerid, "unMod", 1);
							RemoveVehicleComponent(PlayerVehicleInfo[playerid][d][pvId], GetVehicleComponentInSlot(PlayerVehicleInfo[playerid][d][pvId], f));
							PlayerVehicleInfo[playerid][d][pvMods][f] = 0;
						}
						SendClientMessageEx(playerid, COLOR_WHITE, "All modifications have been removed from your vehicle.");
						return 1;
					}
					SetPVarInt(playerid, "unMod", 1);
     				RemoveVehicleComponent(GetPlayerVehicleID(playerid), partID);
					if(GetVehicleComponentType(partID) == 3) {
						PlayerVehicleInfo[playerid][d][pvMods][14] = 0;
					}
     				PlayerVehicleInfo[playerid][d][pvMods][GetVehicleComponentType(partID)] = 0;
     				SendClientMessageEx(playerid, COLOR_WHITE, "The modification you requested has been removed.");
     				return 1;
				}
        	}
		}
	}

	if(dialogid == 7954) // Report tips
	{
		ShowPlayerDialog(playerid,7955,DIALOG_STYLE_MSGBOX,"Report tips","Tips when reporting:\n- Report what you need, not who you need.\n- Be specific, report exactly what you need.\n- Do not make false reports.\n- Do not flame admins.\n- Report only for in-game items.\n- For shop orders use the /shoporder command","Close", "");
	}
    #if defined SHOPAUTOMATED
	if(dialogid == DIALOG_SHOPORDER)
	{
		if(response)
		{
	    	if(strlen(inputtext) < 1 || strlen(inputtext) > 6)
	    	{
	        	ShowPlayerDialog(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID must be no longer than 6 characters and no lower than 1 character.", "Retry", "Cancel");
	        	return 1;
	    	}
			if(!IsNumeric(inputtext))
			{
  				ShowPlayerDialog(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID must be a numerical value.", "Retry", "Cancel");
	        	return 1;
			}
			new orderid = strval(inputtext);
			if(orderid == 0)
			{
			    ShowPlayerDialog(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID can not be 0.", "Retry", "Cancel");
			    return 1;
			}
			ShowNoticeGUIFrame(playerid, 6);
			PlayerInfo[playerid][pOrder] = orderid;

            new query[384];
			format(query, sizeof(query), "\
			SELECT p.order_product_id, p.order_id, p.name, p.quantity, p.delivered, h.order_status_id, o.email, o.ip \
			FROM newshoporder_product p \
			LEFT JOIN newshoporder_history h ON h.order_id = p.order_id AND h.order_history_id = (SELECT max(order_history_id) FROM newshoporder_history WHERE p.order_id = order_id) \
			LEFT JOIN newshoporder o ON o.order_id = p.order_id \
			WHERE p.order_id = %d", orderid);
			mysql_function_query(ShopPipeline, query, true, "OnShopOrder", "i", playerid);

			SetPVarInt(playerid, "ShopOrderTimer", 60); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_SHOPORDERTIMER);
		}
	}

	if(dialogid == DIALOG_SHOPORDEREMAIL)
	{
		if(response)
		{
		    new email[256];
		    GetPVarString(playerid, "ShopEmailVerify", email, sizeof(email));
		    if(!isnull(inputtext) && strcmp(inputtext, email, true) == 0)
		    {
		        ShowNoticeGUIFrame(playerid, 6);
	            new query[384];
				format(query, sizeof(query), "\
				SELECT p.order_product_id, p.order_id, p.name, p.quantity, p.delivered, h.order_status_id \
				FROM newshoporder_product p \
				LEFT JOIN newshoporder_history h ON h.order_id = p.order_id AND h.order_history_id = (SELECT max(order_history_id) FROM newshoporder_history WHERE p.order_id = order_id) \
				LEFT JOIN newshoporder o ON o.order_id = p.order_id \
				WHERE p.order_id = %d", PlayerInfo[playerid][pOrder]);
				mysql_function_query(ShopPipeline, query, true, "OnShopOrderEmailVer", "i", playerid);
			}
			else
			{
			    //ERROR ASK FURTHER HELP
			    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "We were unable to verify that e-mail to that order, would you like further assistance from a shop technician?", "Yes", "No");
			}
		}
	}

	if(dialogid == DIALOG_SHOPORDER2)
	{
		if(response)
		{
		    ShowNoticeGUIFrame(playerid, 6);
            new query[256];
			format(query, sizeof(query), "SELECT * FROM `shop` WHERE `order_id`=%d", PlayerInfo[playerid][pOrder]);
			mysql_function_query(ShopPipeline, query, true, "OnShopOrder2", "ii", playerid, listitem);
		}
	}

	if(dialogid == DIALOG_SHOPDELIVER)
	{
		if(response)
		{
            switch(GetPVarInt(playerid, "DShop_product_id"))
            {
                case 69: //Custom car
                {
                    new carstring[5012];
					for(new x;x<sizeof(VehicleNameShop);x++)
					{
					    format(carstring, sizeof(carstring), "%s%d - %s\n", carstring, VehicleNameShop[x][svehicleid], VehicleNameShop[x][svehiclename]);
					}
                    ShowPlayerDialog(playerid, DIALOG_SHOPDELIVERCAR, DIALOG_STYLE_LIST, "Shop Car Delivery", carstring, "Select Car", "Cancel");
                }
            }
		}
	}

	if(dialogid == DIALOG_SHOPDELIVERCAR)
	{
		if(response)
		{
			new dialogstring[256], name[64];
			GetPVarString(playerid, "DShop_name", name, sizeof(name));
			SetPVarInt(playerid, "DShop_listitem", listitem);
   			format(dialogstring, sizeof(dialogstring), "You are about to redeem: %s\nOrder ID: %d\nWith vehicle: %s (ID %d)\n\nAre you sure?", name, GetPVarInt(playerid, "DShop_order_id"), VehicleNameShop[listitem][svehicleid], VehicleNameShop[listitem][svehiclename]);
   			ShowPlayerDialog(playerid, DIALOG_SHOPDELIVERCAR2, DIALOG_STYLE_MSGBOX, "Shop Car Delivery", dialogstring, "Reedem", "Cancel");
		}
	}

	if(dialogid == DIALOG_SHOPDELIVERCAR2)
	{
	    if(response)
	    {
	        if(!vehicleCountCheck(playerid))
			{
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You can't have any more vehicles, you own too many!", "OK", "");
			}
			else if(!vehicleSpawnCountCheck(playerid))
			{
    			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You have too many vehicles spawned, you must store one first.", "OK", "");
			}
			else
			{
				new Float: arr_fPlayerPos[4];
				listitem = GetPVarInt(playerid, "DShop_listitem");

				GetPlayerPos(playerid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
				GetPlayerFacingAngle(playerid, arr_fPlayerPos[3]);
				CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), VehicleNameShop[listitem][svehicleid], arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2], arr_fPlayerPos[3], 0, 0, 2000000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

				format(string, sizeof(string), "[shoporder] created a %s (%d) for %s (invoice %s).", GetVehicleName(VehicleNameShop[listitem][svehicleid]), VehicleNameShop[listitem][svehicleid], GetPlayerNameEx(playerid), GetPVarInt(playerid, "DShop_order_id"));
				Log("logs/shoplog.log", string);
   			}
	    }
	}
	#else
	if(dialogid == DIALOG_SHOPORDER)
	{
		if(response)
		{
	    	if(strlen(inputtext) < 1 || strlen(inputtext) > 6)
	    	{
	        	ShowPlayerDialog(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID must be no longer than 6 characters and no lower than 1 character.", "Retry", "Cancel");
	        	return 1;
	    	}
			if(!IsNumeric(inputtext))
			{
  				ShowPlayerDialog(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID must be a numerical value.", "Retry", "Cancel");
	        	return 1;
			}
			new orderid = strval(inputtext);
			if(orderid == 0)
			{
			    ShowPlayerDialog(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID can not be 0.", "Retry", "Cancel");
			    return 1;
			}
			PlayerInfo[playerid][pOrder] = orderid;

			SetPVarInt(playerid, "ShopOrderTimer", 60); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_SHOPORDERTIMER);

			format(string, sizeof(string), "%s/~nggami/idcheck.php?id=%d", WEB_SERVER, orderid);
			HTTP(playerid, HTTP_GET, string, "", "HttpCallback_ShopIDCheck");
		}
	}
	#endif
	if(dialogid == DIALOG_SHOPERROR)
	{
		if(response)
		{
		    ShowPlayerDialog(playerid, DIALOG_SHOPORDER, DIALOG_STYLE_INPUT, "Shop Order", "This is for shop orders from http://shop.ng-gaming.net\n\nIf you do not have a shop order then please cancel this dialog box now.\n\nWarning: Abuse of this feature may result to an indefinite block from this command.\n\nPlease enter your shop order ID (if you do not know it put 1):", "Submit", "Cancel" );
		}
	}
	if(dialogid == DIALOG_SHOPERROR2)
	{
		if(response)
		{
		    ShowPlayerDialog(playerid, DIALOG_SHOPSENT, DIALOG_STYLE_INPUT, "Shop Order", "", "Submit", "Cancel" );
		}
	}
	if(dialogid == PMOTDNOTICE && 1 <= PlayerInfo[playerid][pDonateRank] <= 3 && (PlayerInfo[playerid][pVIPExpire] - 86400 < gettime()))
	{
		ShowPlayerDialog(playerid, VIP_EXPIRES, DIALOG_STYLE_MSGBOX, "VIP Expiration!", "Your VIP expires in less than a day - renew today at shop.ng-gaming.net!", "OK", "");
	}
	else if(dialogid == PMOTDNOTICE || dialogid == VIP_EXPIRES)
	{
		SetPVarInt(playerid, "ViewedPMOTD", 1);
		if(PlayerInfo[playerid][pReceivedCredits] != 0) ShowLoginDialogs(playerid, 5);
	}
	if(dialogid == NULLEMAIL)
	{
		if(response)
		{
			new email[256];
			mysql_escape_string(inputtext, email);
			InvalidEmailCheck(playerid, email);
		}
		else
		{
			if(PlayerInfo[playerid][pForcePasswordChange] == 1) ShowLoginDialogs(playerid, 0);
			else if(strcmp(PlayerInfo[playerid][pBirthDate], "0000-00-00", true) == 0 && PlayerInfo[playerid][pTut] != 0) ShowLoginDialogs(playerid, 1);
			else if(pMOTD[0] && GetPVarInt(playerid, "ViewedPMOTD") != 1) ShowLoginDialogs(playerid, 4);
			else if(PlayerInfo[playerid][pReceivedCredits] != 0) ShowLoginDialogs(playerid, 5);
		}
	}
	else if(dialogid == EMAIL_VALIDATION)
	{
		DeletePVar(playerid, "NullEmail");
		if(PlayerInfo[playerid][pForcePasswordChange] == 1) ShowLoginDialogs(playerid, 0);
		else if(strcmp(PlayerInfo[playerid][pBirthDate], "0000-00-00", true) == 0 && PlayerInfo[playerid][pTut] != 0) ShowLoginDialogs(playerid, 1);
		else if(pMOTD[0] && GetPVarInt(playerid, "ViewedPMOTD") != 1) ShowLoginDialogs(playerid, 4);
		else if(PlayerInfo[playerid][pReceivedCredits] != 0) ShowLoginDialogs(playerid, 5);
		return 1;
	}

	if(dialogid == DIALOG_LOADTRUCK)
	{
 		if(response)
		{
			new iBusiness = ListItemTrackId[playerid][listitem];
			if (Businesses[iBusiness][bOrderState] != 1) {
				SendClientMessageEx(playerid, COLOR_WHITE, "That order cannot be taken anymore (either taken by another Shipment Contractor or the business has cancelled it)");
				return 1;
			}
			new iTruckModel = GetVehicleModel(GetPlayerVehicleID(playerid));
			if (iTruckModel != 443 && Businesses[iBusiness][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP) {
	            SendClientMessageEx(playerid, COLOR_WHITE, "You need to be driving a Packer in order to accept orders from car dealerships.");
				TogglePlayerControllable(playerid, 1);
				DeletePVar(playerid, "IsFrozen");
	            return 1;
			}
			if (iTruckModel != 514 && Businesses[iBusiness][bType] == BUSINESS_TYPE_GASSTATION) {
	            SendClientMessageEx(playerid, COLOR_WHITE, "You need to be driving a tank truck in order to accept orders from gas stations.");
				TogglePlayerControllable(playerid, 1);
				DeletePVar(playerid, "IsFrozen");
	            return 1;
			}
			if ((iTruckModel == 443 || iTruckModel == 514) && Businesses[iBusiness][bType] != BUSINESS_TYPE_NEWCARDEALERSHIP && Businesses[iBusiness][bType] != BUSINESS_TYPE_GASSTATION)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You need to be driving a regular truck (i.e not packer or tank truck) in order to accept orders from this type of business.");
				TogglePlayerControllable(playerid, 1);
				DeletePVar(playerid, "IsFrozen");
	            return 1;
			}
			Businesses[iBusiness][bOrderState] = 2;
			TruckDeliveringTo[GetPlayerVehicleID(playerid)] = iBusiness;
			SaveBusiness(iBusiness);
			format(string,sizeof(string),"* Please wait a moment while the vehicle is being loaded with %s...", GetInventoryType(iBusiness));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
  			SetPVarInt(playerid, "LoadTruckTime", 10);
			SetTimerEx("LoadTruck", 1000, 0, "d", playerid);
		}
		else
		{
		    DeletePVar(playerid, "IsFrozen");
			TogglePlayerControllable(playerid, 1);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You canceled the loading of the shipment, type /loadshipment to try again.");
		}
	}
	if((dialogid == BUYTOYSCOP) && response)
	{
	    new stringg[4096], icount = GetPlayerToySlots(playerid);
		for(new x;x<icount;x++)
		{
  			new name[24] = "None";

			for(new i;i<sizeof(HoldingObjectsAll);i++)
   			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
    			{
   					format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}
			if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
			{
			    format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
			}
			format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]);
		}
		ShowPlayerDialog(playerid, BUYTOYSCOP2, DIALOG_STYLE_LIST, "Select a Slot", stringg, "Select", "Cancel");
	}

	if((dialogid == BUYTOYSCOP2) && response)
	{
		/*
	    if(listitem >= 5 && PlayerInfo[playerid][pDonateRank] < 1 || listitem >= 5 && PlayerInfo[playerid][pBuddyInvited] == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Bronze VIP + to use that slot!");
	    if(listitem >= 8 && PlayerInfo[playerid][pDonateRank] < 2) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Silver VIP + to use that slot!");
        if(listitem >= 9 && PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Gold VIP + to use that slot!");
		if(listitem >= 10 && PlayerInfo[playerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Platinum VIP + to use that slot!");
		*/
		
		if(!toyCountCheck(playerid)) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You cannot hold anymore toys.");
		
		if(PlayerToyInfo[playerid][listitem][ptModelID] != 0) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You already have something in that slot. Delete it with /toys");

		SetPVarInt(playerid, "ToySlot", listitem);

		new stringg[1024];
		for(new x;x<sizeof(HoldingObjectsCop);x++)
		{
		    format(stringg, sizeof(stringg), "%s%s ($%d)\n", stringg, HoldingObjectsCop[x][holdingmodelname], HoldingObjectsCop[x][holdingprice]);
		}
		ShowPlayerDialog(playerid, BUYTOYSCOP3, DIALOG_STYLE_LIST, "Select an Item", stringg, "Buy", "Cancel");
	}
	if((dialogid == BUYTOYSCOP3) && response)
	{
		if(GetPlayerCash(playerid) < HoldingObjectsCop[listitem][holdingprice])
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "* You can't afford that!");
		}
		else
		{
			GivePlayerCash(playerid, -HoldingObjectsCop[listitem][holdingprice]);
		    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID] = HoldingObjectsCop[listitem][holdingmodelid];

   			new modelid = PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID];
		    if((modelid >= 19006 && modelid <= 19035) || (modelid >= 19138 && modelid <= 19140))
		    {
		        PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.9;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.35;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
		    }
		    else if(modelid >= 18891 && modelid <= 18910)
		    {
		    	PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.15;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid >= 18926 && modelid <= 18935)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18911 && modelid <= 18920)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.035;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid == 19078 || modelid == 19078)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 16;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if((modelid >= 18641 && modelid <= 18644) || (modelid >= 19080 && modelid <= 19084) || modelid == 18890)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 6;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
		    else
		    {
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptTradable] = 0;		
			
			g_mysql_NewToy(playerid, GetPVarInt(playerid, "ToySlot"));

			format(string, sizeof(string), "* You have purchased %s for $%d (Slot: %d)", HoldingObjectsCop[listitem][holdingmodelname], HoldingObjectsCop[listitem][holdingprice], GetPVarInt(playerid, "ToySlot"));
		    SendClientMessageEx(playerid, COLOR_RED, string);
		    SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Use /toys to wear/edit this");
		}
	}
	if((dialogid == BUYTOYSGOLD) && response)
	{
 		if(PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Gold VIP +");
	    new stringg[512], icount = GetPlayerToySlots(playerid);
		for(new x;x<icount;x++)
		{
  			new name[24] = "None";

			for(new i;i<sizeof(HoldingObjectsAll);i++)
   			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
    			{
   					format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}
			if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
			{
			    format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
			}
			format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]);
		}
		ShowPlayerDialog(playerid, BUYTOYSGOLD2, DIALOG_STYLE_LIST, "Select a Slot", stringg, "Select", "Cancel");
	}

	if((dialogid == BUYTOYSGOLD2) && response)
	{
        if(PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Gold VIP +");
		
		if(!toyCountCheck(playerid)) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You cannot hold anymore toys.");

	    if(PlayerToyInfo[playerid][listitem][ptModelID] != 0) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You already have something in that slot. Delete it with /toys");

		SetPVarInt(playerid, "ToySlot", listitem);

		new stringg[5256];
		for(new x;x<sizeof(HoldingObjectsAll);x++)
		{
		    format(stringg, sizeof(stringg), "%s%s ($%d)\n", stringg, HoldingObjectsAll[x][holdingmodelname], HoldingObjectsAll[x][holdingprice]);
		}
		ShowPlayerDialog(playerid, BUYTOYSGOLD3, DIALOG_STYLE_LIST, "Select an Item", stringg, "Buy", "Cancel");
	}
	if((dialogid == BUYTOYSGOLD3) && response)
	{
	    if(PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Gold VIP +");

		if(GetPlayerCash(playerid) < HoldingObjects[listitem][holdingprice])
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "* You can't afford that!");
		}
		else
		{
			GivePlayerCash(playerid, -HoldingObjectsAll[listitem][holdingprice]);
		    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID] = HoldingObjectsAll[listitem][holdingmodelid];

   			new modelid = PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID];
		    if((modelid >= 19006 && modelid <= 19035) || (modelid >= 19138 && modelid <= 19140))
		    {
		        PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.9;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.35;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
		    }
		    else if(modelid >= 18891 && modelid <= 18910)
		    {
		    	PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.15;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid >= 18926 && modelid <= 18935)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18911 && modelid <= 18920)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.035;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid == 19078 || modelid == 19078)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 16;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if((modelid >= 18641 && modelid <= 18644) || (modelid >= 19080 && modelid <= 19084) || modelid == 18890)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 6;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
		    else
		    {
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptTradable] = 0;
			
			g_mysql_NewToy(playerid, GetPVarInt(playerid, "ToySlot"));

			format(string, sizeof(string), "* You have purchased %s for $%d (Slot: %d)", HoldingObjectsAll[listitem][holdingmodelname], HoldingObjectsAll[listitem][holdingprice], GetPVarInt(playerid, "ToySlot"));
		    SendClientMessageEx(playerid, COLOR_RED, string);
		    SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Use /toys to wear/edit this");

		}
	}
	if((dialogid == BUYTOYS) && response)
	{
	    new stringg[4096], icount = GetPlayerToySlots(playerid);
		for(new x;x<icount;x++)
		{
  			new name[24];
	    	format(name, sizeof(name), "None");

			for(new i;i<sizeof(HoldingObjectsAll);i++)
   			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
    			{
   					format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}
			if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
			{
			    format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
			}
			format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]);
		}
		ShowPlayerDialog(playerid, BUYTOYS2, DIALOG_STYLE_LIST, "Select a Slot", stringg, "Select", "Cancel");
	}
	if((dialogid == BUYTOYS2) && response)
	{
		/*
	    if(listitem >= 5 + PlayerInfo[playerid][pToySlot] && PlayerInfo[playerid][pDonateRank] < 1 || listitem >= 5 + PlayerInfo[playerid][pToySlot] && PlayerInfo[playerid][pBuddyInvited] == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Bronze VIP + to use that slot!");
	    if(listitem >= 8 + PlayerInfo[playerid][pToySlot] && PlayerInfo[playerid][pDonateRank] < 2) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Silver VIP + to use that slot!");
        if(listitem >= 9 + PlayerInfo[playerid][pToySlot] && PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Gold VIP + to use that slot!");
		if(listitem >= 10 + PlayerInfo[playerid][pToySlot] && PlayerInfo[playerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Platinum VIP + to use that slot!");
		*/
		
		if(!toyCountCheck(playerid)) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You cannot hold anymore toys.");
		
	    if(PlayerToyInfo[playerid][listitem][ptModelID] != 0) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You already have something in that slot. Delete it with /toys");

		SetPVarInt(playerid, "ToySlot", listitem);
		
		new stringg[5000];
		for(new x;x<sizeof(HoldingObjects);x++)
		{
		    format(stringg, sizeof(stringg), "%s%s ($%d)\n", stringg, HoldingObjects[x][holdingmodelname], HoldingObjects[x][holdingprice]);
		}
		ShowPlayerDialog(playerid, BUYTOYS3, DIALOG_STYLE_LIST, "Select an Item", stringg, "Buy", "Cancel");
	}
	if((dialogid == BUYTOYS3) && response)
	{
		if(GetPlayerCash(playerid) < HoldingObjects[listitem][holdingprice])
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "* You can't afford that!");
		}
		else
		{
			GivePlayerCash(playerid, -HoldingObjects[listitem][holdingprice]);
		    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID] = HoldingObjects[listitem][holdingmodelid];

		    new modelid = PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID];
		    if((modelid >= 19006 && modelid <= 19035) || (modelid >= 19138 && modelid <= 19140))
		    {
		        PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.9;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.35;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
		    }
		    else if(modelid >= 18891 && modelid <= 18910)
		    {
		    	PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.15;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid >= 18926 && modelid <= 18935)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18911 && modelid <= 18920)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.035;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid == 19078 || modelid == 19078)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 16;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if((modelid >= 18641 && modelid <= 18644) || (modelid >= 19080 && modelid <= 19084) || modelid == 18890)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 6;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
		    else
		    {
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptTradable] = 1;
			
			g_mysql_NewToy(playerid, GetPVarInt(playerid, "ToySlot"));
			
			format(string, sizeof(string), "* You have purchased %s for $%d (Slot: %d)", HoldingObjects[listitem][holdingmodelname], HoldingObjects[listitem][holdingprice], GetPVarInt(playerid, "ToySlot"));
		    SendClientMessageEx(playerid, COLOR_RED, string);
		    SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Use /toys to wear/edit this");
		}
	}	
	if((dialogid == TOYS) && response)
	{
		if(listitem == 0)
		{
		    new stringg[4096], icount = GetPlayerToySlots(playerid);
			for(new x;x<icount;x++)
			{
			    new name[24];
			    format(name, sizeof(name), "None");

			    for(new i;i<sizeof(HoldingObjectsAll);i++)
			    {
       				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
			        {
           				format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
					}
				}
				if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
				{
				    format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
				}
				format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]);
			}
			format(stringg, sizeof(stringg), "%s\n{40FFFF}Additional Toy Slot {FFD700}(Credits: %s){A9C4E4}", stringg, number_format(ShopItems[28][sItemPrice]));
   			ShowPlayerDialog(playerid, WEARTOY, DIALOG_STYLE_LIST, "Select a Toy", stringg, "Select", "Cancel");
	    }
		else if(listitem == 1)
		{
		    new stringg[4096], icount = GetPlayerToySlots(playerid);
			for(new x;x<icount;x++)
			{
			    new name[24];
			    format(name, sizeof(name), "None");

			    for(new i;i<sizeof(HoldingObjectsAll);i++)
			    {
       				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
			        {
           				format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
					}
				}
				if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
				{
				    format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
				}
				format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]);
			}
			format(stringg, sizeof(stringg), "%s\n{40FFFF}Additional Toy Slot {FFD700}(Credits: %s){A9C4E4}", stringg, number_format(ShopItems[28][sItemPrice]));
   			ShowPlayerDialog(playerid, EDITTOYS, DIALOG_STYLE_LIST, "Select a Toy", stringg, "Select", "Cancel");
   		}
		else if(listitem == 2)
		{
		    new stringg[4096], icount = GetPlayerToySlots(playerid);
			for(new x;x<icount;x++)
			{
			    new name[24];
			    format(name, sizeof(name), "None");

			    for(new i;i<sizeof(HoldingObjectsAll);i++)
			    {
       				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
			        {
           				format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
					}
				}
				if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
				{
				    format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
				}
				format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]);
			}
			format(stringg, sizeof(stringg), "%s\n{40FFFF}Additional Toy Slot {FFD700}(Credits: %s){A9C4E4}", stringg, number_format(ShopItems[28][sItemPrice]));
   			ShowPlayerDialog(playerid, DELETETOY, DIALOG_STYLE_LIST, "Select a Toy", stringg, "Delete", "Cancel");
		}
	}

	if((dialogid == EDITTOYS) && response)
	{
		/*new toycount = GetFreeToySlot(playerid);
		if(toycount >= 10) return SendClientMessageEx(playerid, COLOR_GRAD1, "You currently have 10 objects attached, please deattach an object.");*/
		
		if(listitem >= GetPlayerToySlots(playerid)) 
	    {
	        new szstring[128];
			SetPVarInt(playerid, "MiscShop", 8);
			format(szstring, sizeof(szstring), "Additional Toy Slot\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[28][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[28][sItemPrice]));
			return ShowPlayerDialog(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Additional Toy Slot", szstring, "Purchase", "Cancel");
		}
		else if(PlayerToyInfo[playerid][listitem][ptModelID] == 0 && listitem < GetPlayerToySlots(playerid))
		{
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Edit your toy", "Woops! You don't have anything to edit in that slot.", "Okay", "");
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "{AA3333}HINT:{FFFF00} Position your camera differently to better see where your editing.");
		    SetPVarInt(playerid, "ToySlot", listitem);
		    ShowEditMenu(playerid);
		}
	}
	if((dialogid == EDITTOYS2)) {
	    if(response) switch(listitem) {
		    case 0: ShowPlayerDialog(playerid, EDITTOYSBONE, DIALOG_STYLE_LIST, "Select a Bone", "Spine\nHead\nLeft upper arm\nRight upper arm\nLeft hand\nRight hand\nLeft thigh\nRight thigh\nLeft foot\nRight foot\nRight calf\nLeft calf\nLeft forearm\nRight forearm\nLeft clavicle\nRight clavicle\nNeck\nJaw", "Select", "Cancel");
		    case 1:
			{		
				for(new i; i < 11; i++)
				{
					if(PlayerHoldingObject[playerid][i] == GetPVarInt(playerid, "ToySlot")+1)
					{
						EditAttachedObject(playerid, i-1);
						break;
					}
				}
			    SendClientMessage(playerid, COLOR_WHITE, "HINT: Hold {8000FF}~k~~PED_SPRINT~ {FFFFAA}to move your camera, press escape to cancel");
			}
		}
		else
		{
		    new stringg[4096], icount = GetPlayerToySlots(playerid);
			for(new x;x<icount;x++)
			{
			    new name[24];
			    format(name, sizeof(name), "None");

			    for(new i;i<sizeof(HoldingObjectsAll);i++)
			    {
       				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
			        {
           				format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
					}
				}
				if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
				{
					format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
				}
				format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]);
			}
			format(stringg, sizeof(stringg), "%s\n{40FFFF}Additional Toy Slot {FFD700}(Credits: %s){A9C4E4}", stringg, number_format(ShopItems[28][sItemPrice]));
   			ShowPlayerDialog(playerid, EDITTOYS, DIALOG_STYLE_LIST, "Select a Toy", stringg, "Select", "Cancel");
		}
	}
	if(dialogid == EDITTOYSBONE)
	{
	    if(response)
	    {
	        PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = listitem+1;

			g_mysql_SaveToys(playerid,GetPVarInt(playerid, "ToySlot"));
		}
	 	ShowEditMenu(playerid);
	}
	if(dialogid == SELLTOY)
	{
		if(response)
		{	
			new buyerid = GetPVarInt(playerid, "ttBuyer"),
				cost = GetPVarInt(playerid, "ttCost");
			if(PlayerToyInfo[playerid][listitem][ptModelID] == 0) {
				SetPVarInt(buyerid, "ttSeller", INVALID_PLAYER_ID);
				SetPVarInt(playerid, "ttCost", 0);
				SetPVarInt(playerid, "ttBuyer", INVALID_PLAYER_ID);
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Sell your toy", "Woops! You don't have anything to sell from that slot.", "Okay", "");
			}	
			if(PlayerToyInfo[playerid][listitem][ptTradable] == 0) {
				SendClientMessageEx(playerid, COLOR_GREY, "This toy isn't tradable.");
				SetPVarInt(buyerid, "ttSeller", INVALID_PLAYER_ID);
				SetPVarInt(playerid, "ttCost", 0);
				return SetPVarInt(playerid, "ttBuyer", INVALID_PLAYER_ID);
			}
			if(!IsPlayerAttachedObjectSlotUsed(playerid, listitem))
			{
				new szmessage[128], name[24],
					toyid = PlayerToyInfo[playerid][listitem][ptModelID];
				format(name, sizeof(name), "None");
				for(new i;i<sizeof(HoldingObjectsAll);i++)
	   			{
					if(HoldingObjectsAll[i][holdingmodelid] == toyid)
					{
						format(name, sizeof(name), "(%s)", HoldingObjectsAll[i][holdingmodelname]);
					}
				}
				if(PlayerToyInfo[playerid][listitem][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
				{
					format(name, sizeof(name), "(ID: %d)", toyid);
				}
				format(szmessage, sizeof(szmessage), "You have offered %s to purchase your toy. %s", GetPlayerNameEx(buyerid), name);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szmessage);
				SetPVarInt(playerid, "ttToy", toyid);
				SetPVarInt(playerid, "ttToySlot", listitem);
				PrepTradeToysGUI(buyerid, playerid, cost, toyid);
			}		
			else {
				SendClientMessageEx(playerid, COLOR_GREY, "You currently have this toy attached, please deattach it and try again.");
				SetPVarInt(buyerid, "ttSeller", INVALID_PLAYER_ID);
				SetPVarInt(playerid, "ttCost", 0);
				SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);
			}	
		}	
	}		
	if(dialogid == CONFIRMSELLTOY)
	{
		if(response)
		{
			CompleteToyTrade(playerid);
		} 
		else {
			new szstring[128];
			format(szstring, sizeof(szstring), "%s has declined the toy offer.", GetPlayerNameEx(playerid));
			SendClientMessageEx(GetPVarInt(playerid, "ttSeller"), COLOR_GREY, szstring);
			SendClientMessageEx(playerid, COLOR_GREY, "You have declined the toy offer.");
			SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttBuyer", INVALID_PLAYER_ID);
			SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttCost", 0);
			SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);
					
			HideTradeToysGUI(playerid);
		}
	}	
	if((dialogid == WEARTOY) && response)
	{
	    //if(PlayerToyInfo[playerid][listitem][ptModelID] == 0)
		if(listitem >= GetPlayerToySlots(playerid)) 
	    {
			new szstring[128];
			SetPVarInt(playerid, "MiscShop", 8);
			format(szstring, sizeof(szstring), "Additional Toy Slot\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[28][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[28][sItemPrice]));
			return ShowPlayerDialog(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Additional Toy Slot", szstring, "Purchase", "Cancel");
		}
		else if(PlayerToyInfo[playerid][listitem][ptModelID] == 0 && listitem < GetPlayerToySlots(playerid))
		{
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Wear your toy", "Woops! You don't have anything to wear from that slot.", "Okay", "");
		}
		else
		{
			new toys = 99999;
			for(new i; i < 11; i++)
			{
				if(PlayerHoldingObject[playerid][i] == listitem+1)
				{
					toys = i;
					break;
				}
			}		
		    if(IsPlayerAttachedObjectSlotUsed(playerid, toys-1))
			{	
			    new name[24];
			    format(name, sizeof(name), "None");

				for(new i;i<sizeof(HoldingObjectsAll);i++)
	   			{
					if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][listitem][ptModelID])
					{
						format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
					}
				}
			    format(string, sizeof(string), "Successfully dettached %s (Bone: %s) (Slot: %d)", name, HoldingBones[PlayerToyInfo[playerid][listitem][ptBone]], listitem);
				SendClientMessageEx(playerid, COLOR_RED, string);
			    RemovePlayerAttachedObject(playerid, toys-1);
				for(new i; i < 11; i++)
				{
					if(PlayerHoldingObject[playerid][i] == listitem+1)
					{
						PlayerHoldingObject[playerid][i] = 0;
						break;
					}
				}	
			}
			else
			{
				new toycount = GetFreeToySlot(playerid);
				if(toycount > 10 || toycount == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot attach more than 10 objects.");
				
				if(PlayerToyInfo[playerid][listitem][ptScaleX] == 0) {
					PlayerToyInfo[playerid][listitem][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][listitem][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][listitem][ptScaleZ] = 1.0;
				}			
			    new name[24];
			    format(name, sizeof(name), "None");

				for(new i;i<sizeof(HoldingObjectsAll);i++)
	   			{
					if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][listitem][ptModelID])
					{
						format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
					}
				}
				format(string, sizeof(string), "Successfully attached %s (Bone: %s) (Slot: %d)", name, HoldingBones[PlayerToyInfo[playerid][listitem][ptBone]], listitem);
				SendClientMessageEx(playerid, COLOR_RED, string);
				PlayerHoldingObject[playerid][toycount] = listitem+1;
				SetPlayerAttachedObject(playerid, toycount-1, PlayerToyInfo[playerid][listitem][ptModelID], PlayerToyInfo[playerid][listitem][ptBone], PlayerToyInfo[playerid][listitem][ptPosX], PlayerToyInfo[playerid][listitem][ptPosY], PlayerToyInfo[playerid][listitem][ptPosZ],
				PlayerToyInfo[playerid][listitem][ptRotX], PlayerToyInfo[playerid][listitem][ptRotY], PlayerToyInfo[playerid][listitem][ptRotZ], PlayerToyInfo[playerid][listitem][ptScaleX], PlayerToyInfo[playerid][listitem][ptScaleY], PlayerToyInfo[playerid][listitem][ptScaleZ]);
			}
		}
	}

	if((dialogid == DELETETOY) && response)
	{
		new toys = 99999;			
		for(new i; i < 11; i++)
		{
			if(PlayerHoldingObject[playerid][i] == listitem+1)
			{
				toys = i;
				if(IsPlayerAttachedObjectSlotUsed(playerid, toys-1))
				{
					PlayerHoldingObject[playerid][i] = 0;
					RemovePlayerAttachedObject(playerid, toys-1);
				}
				break;
			}
		}		
	
		new szQuery[128];
		format(szQuery, sizeof(szQuery), "DELETE FROM `toys` WHERE `id` = '%d'", PlayerToyInfo[playerid][listitem][ptID]);
		mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		PlayerToyInfo[playerid][listitem][ptID] = 0;
		PlayerToyInfo[playerid][listitem][ptModelID] = 0;
		PlayerToyInfo[playerid][listitem][ptBone] = 0;
		if(PlayerToyInfo[playerid][listitem][ptSpecial] != 0)
		{
			PlayerToyInfo[playerid][listitem][ptSpecial] = 0;
		}

		format(string, sizeof(string), "You have deleted your toy in slot %d.", listitem);
	    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Toy Menu", string, "OK", "");
	}

	if((dialogid == LAELEVATORPASS) && response)
	{
        listitem = GetPVarInt(playerid, "ElevatorFloorPick");
		if(FloorRequestedBy[listitem] != INVALID_PLAYER_ID || IsFloorInQueue(listitem))
            GameTextForPlayer(playerid, "~r~The floor is already in the queue", 3500, 4);
		else if(DidPlayerRequestElevator(playerid))
		    GameTextForPlayer(playerid, "~r~You already requested the elevator", 3500, 4);
		else
		{
		    if(strfind(inputtext, "warfloor321", true) == 0)
		    {
		        CallElevator(playerid, 20);
			}
			else if(strfind(inputtext, LAElevatorFloorData[1][listitem], true) == 0)
		    {
	            CallElevator(playerid, listitem);
		    }
		    else
		    {
		        GameTextForPlayer(playerid, "~r~Invalid Password", 3500, 4);
			}
		}
	}
	if((dialogid == LAELEVATOR) && response)
	{
        if(FloorRequestedBy[listitem] != INVALID_PLAYER_ID || IsFloorInQueue(listitem))
            GameTextForPlayer(playerid, "~r~The floor is already in the queue", 3500, 4);
		else if(DidPlayerRequestElevator(playerid))
		    GameTextForPlayer(playerid, "~r~You already requested the elevator", 3500, 4);
		else
		{
		    if(strlen(LAElevatorFloorData[1][listitem]) > 0)
   		    {
   		        SetPVarInt(playerid, "ElevatorFloorPick", listitem);
   		        ShowPlayerDialog(playerid, LAELEVATORPASS, DIALOG_STYLE_INPUT, "Elevator", "Enter the password for this level", "Enter", "Cancel");
			}
			else
			{
	        	CallElevator(playerid, listitem);
			}
		}
		return 1;
	}
	if((dialogid == AUDIO_URL) && response) // /audiourl
	{
	    if(PlayerInfo[playerid][pAdmin] >= 4)
	    {
			new range = GetPVarInt(playerid, "aURLrange");
			new Float:aX, Float:aY, Float:aZ;
			GetPlayerPos(playerid, aX, aY, aZ);
		 	SendAudioURLToRange(inputtext,aX,aY,aZ,range);

			if(range > 100)
			{
				format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has placed url %s - Range: %d.",GetPlayerNameEx(playerid),inputtext,range);
				ABroadCast(COLOR_YELLOW, string, 4);
				format(string, sizeof(string),"Use /audiostopurl to stop playback");
				SendClientMessage(playerid, COLOR_YELLOW, string);
			}
			else
			{
			    format(string,sizeof(string),"You have placed url %s - Range: %d",inputtext,range);
				SendClientMessage(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string),"Use /audiostopurl to stop playback");
				SendClientMessage(playerid, COLOR_YELLOW, string);
			}
		}
	}

	/*if(dialogid == DIALOG_NUMBER_PLATE_CHOSEN) {
	    if(response == 1) {
			for(new i = 0; i < MAX_PLAYERVEHICLES; i++) {
			    if(listitem == i) {
			        if(PlayerInfo[playerid][pDonateRank] > 0) {
			            new
			                tmpSz_NumPlate[32];

			            GetPVarString(playerid, "szNumPS", tmpSz_NumPlate, sizeof(tmpSz_NumPlate));
			            RegisterVehicleNumberPlate(PlayerVehicleInfo[playerid][i][pvId], tmpSz_NumPlate);
			            SetPVarInt(playerid, "Cash", PlayerInfo[playerid][pCash]-80000);
			            strcpy(PlayerVehicleInfo[playerid][i][pvNumberPlate], tmpSz_NumPlate, 32);
			            SendClientMessageEx(playerid, COLOR_WHITE, "Your registration plate has successfully been configured.");
					}
					else {
			            new
			                tmpSz_NumPlate[32];

			            GetPVarString(playerid, "szNumPS", tmpSz_NumPlate, sizeof(tmpSz_NumPlate));
			            RegisterVehicleNumberPlate(PlayerVehicleInfo[playerid][i][pvId], tmpSz_NumPlate);
			            strcpy(PlayerVehicleInfo[playerid][i][pvNumberPlate], tmpSz_NumPlate, 32);
					    SetPVarInt(playerid, "Cash", PlayerInfo[playerid][pCash]-100000);
					    SendClientMessageEx(playerid, COLOR_WHITE, "Your registration plate has successfully been configured.");
					}

					return 1;
			    }
			}
		}
	}*/

	if(dialogid == DIALOG_NUMBER_PLATE) {
	    if(response) {
	        if(strlen(inputtext) < 1 || strlen(inputtext) > 8) {
	            SendClientMessageEx(playerid, COLOR_WHITE, "{AA3333}ERROR:{FFFF00} You can only have a number plate that consists of 1-8 characters.");
	        }
	        else {
	            if(strfind("XMT", inputtext, true) != -1) {
	                SendClientMessageEx(playerid, COLOR_WHITE, "{AA3333}ERROR:{FFFF00} You cannot use the term \"XMT\" in your registration plate.");
					return 1;
				}

			    SetPVarString(playerid, "szNumPS", inputtext);

			    new
					vstring[1024]; // ew, another 4096 bytes of memory down the drain

		 		for(new i = 0; i < MAX_PLAYERVEHICLES; i++)
				{
					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
					{
						format(vstring, sizeof(vstring), "%s\n%s", vstring, GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
					}
					else
					{
						format(vstring, sizeof(vstring), "%s\nEmpty", vstring);
					}
				}

				ShowPlayerDialog(playerid, DIALOG_NUMBER_PLATE_CHOSEN, DIALOG_STYLE_LIST, "Registration plate selection", vstring, "Select", "Cancel");
			}
		}

		/*if(PlayerInfo[playerid][pDonateRank] > 0) {
		    PlayerInfo[playerid][pMoney] -= 80000;
		    SendClientMessageEx(playerid, COLOR_WHITE, "Your new number plate has been configured!");
		    RegisterVehicleNumberPlate();
		}
		else {
		    PlayerInfo[playerid][pMoney] -= 100000;
			SendClientMessageEx(playerid, COLOR_WHITE, "Your new number plate has been configured!");
			RegisterVehicleNumberPlate();
		}*/
	}
	if(dialogid == NMUTE)
	{
	    if(response == 1)
	    {
	        switch(listitem)
	        {
	            case 0: // Jailtime
				{
				    if(PlayerInfo[playerid][pNMuteTotal] < 4)
				    {
				        if(GetPVarInt(playerid, "IsInArena") >= 0)
					    {
					        LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
					    }
					    PlayerInfo[playerid][pNMute] = 0;
				        ResetPlayerWeaponsEx(playerid);
						PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pNMuteTotal]*15*60;
						strcpy(PlayerInfo[playerid][pPrisonReason], "[OOC] NMute Prison", 128);
						PhoneOnline[playerid] = 1;
						SetPlayerInterior(playerid, 1);
						PlayerInfo[playerid][pInt] = 1;
						new rand = random(sizeof(OOCPrisonSpawns));
						Streamer_UpdateEx(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerSkin(playerid, 50);
						SetPlayerColor(playerid, TEAM_APRISON_COLOR);
						Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
				    }
				    else if(PlayerInfo[playerid][pNMuteTotal] >= 4 || PlayerInfo[playerid][pNMuteTotal] < 7)
				    {
				        if(GetPVarInt(playerid, "IsInArena") >= 0)
					    {
					        LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
					    }
					    PlayerInfo[playerid][pNMute] = 0;
						GameTextForPlayer(playerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
						ResetPlayerWeaponsEx(playerid);
						PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pNMuteTotal]*15*60;
						PhoneOnline[playerid] = 1;
						SetPlayerInterior(playerid, 1);
						PlayerInfo[playerid][pInt] = 1;
						new rand = random(sizeof(OOCPrisonSpawns));
						Streamer_UpdateEx(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerSkin(playerid, 50);
						SetPlayerColor(playerid, TEAM_APRISON_COLOR);
						Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
				    }
					strcpy(PlayerInfo[playerid][pPrisonReason], "[OOC][NEWB-UNMUTE]", 128);
					format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s is serving %d Minutes in Jail/Prison for Newbie Unmute.",GetPlayerNameEx(playerid),PlayerInfo[playerid][pNMuteTotal]*15);
					ABroadCast(COLOR_YELLOW,string,2);
	            }
	            case 1: // Fine
	            {
	                new playername[MAX_PLAYER_NAME];
	                GetPlayerName(playerid, playername, sizeof(playername));

	                new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
					if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
					if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];
					if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSafeMoney];

				    new fine = 10*totalwealth/100;
	                format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has paid a $%d fine for Newbie Chat Unmute.",GetPlayerNameEx(playerid),fine);
	                GivePlayerCash(playerid,-fine);
					ABroadCast(COLOR_YELLOW,string,2);
					PlayerInfo[playerid][pNMute] = 0;
	            }
	        }
	    }
		else
		{
		    format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has canceled punishment for Newbie Chat Unmute.",GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW,string,2);
		}
	}
	if(dialogid == ADMUTE)
	{
	    if(response == 1)
	    {
	        switch(listitem)
	        {
	            case 0: // Jailtime
				{
				    if(PlayerInfo[playerid][pADMuteTotal] < 4)
				    {
				        if(GetPVarInt(playerid, "IsInArena") >= 0)
					    {
					        LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
					    }
					    PlayerInfo[playerid][pADMute] = 0;
				        ResetPlayerWeaponsEx(playerid);
						PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pADMuteTotal]*15*60;
						PhoneOnline[playerid] = 1;
						SetPlayerInterior(playerid, 1);
						PlayerInfo[playerid][pInt] = 1;
						new rand = random(sizeof(OOCPrisonSpawns));
						Streamer_UpdateEx(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerSkin(playerid, 50);
						SetPlayerColor(playerid, TEAM_APRISON_COLOR);
						Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
				    }
				    else if(PlayerInfo[playerid][pADMuteTotal] >= 4 || PlayerInfo[playerid][pADMuteTotal] < 7)
				    {
				        if(GetPVarInt(playerid, "IsInArena") >= 0)
					    {
					        LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
					    }
					    PlayerInfo[playerid][pADMute] = 0;
						GameTextForPlayer(playerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
						ResetPlayerWeaponsEx(playerid);
						PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pADMuteTotal]*15*60;
						PhoneOnline[playerid] = 1;
						SetPlayerInterior(playerid, 1);
						PlayerInfo[playerid][pInt] = 1;
						new rand = random(sizeof(OOCPrisonSpawns));
						Streamer_UpdateEx(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerSkin(playerid, 50);
						SetPlayerColor(playerid, TEAM_APRISON_COLOR);
						Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
				    }
					strcpy(PlayerInfo[playerid][pPrisonReason], "[OOC][AD-UNMUTE]", 128);
					format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s is serving %d Minutes in Jail/Prison for Advertisement Unmute.",GetPlayerNameEx(playerid),PlayerInfo[playerid][pADMuteTotal]*15);
					ABroadCast(COLOR_YELLOW,string,2);
	            }
	            case 1: // Fine
	            {
	                new playername[MAX_PLAYER_NAME];
	                GetPlayerName(playerid, playername, sizeof(playername));

	                new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
					if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
					if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];
					if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSafeMoney];
					
                    PlayerInfo[playerid][pADMute] = 0;
				    new fine = 10*totalwealth/100;
	                format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has paid a $%d fine for Advertisement Unmute.",GetPlayerNameEx(playerid),fine);
	                GivePlayerCash(playerid,-fine);
					ABroadCast(COLOR_YELLOW,string,2);
	            }
	        }
	    }
	    else
	    {
	        format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has canceled punishment for Advertisement Unmute.",GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW,string,2);
	    }
	}
	if(dialogid == TWADMINMENU) // Turf Wars System
	{
	    if(response == 1)
	    {
	        switch(listitem)
	        {
				case 0:
				{
					TurfWarsEditTurfsSelection(playerid);
				}
				case 1:
				{
				    TurfWarsEditFColorsSelection(playerid);
				}
	        }
	    }
	}
	if(dialogid == TWEDITTURFSSELECTION)
	{
	    if(response == 1)
	    {
			for(new i = 0; i < MAX_TURFS; i++)
			{
			    if(listitem == i)
				{
				    SetPVarInt(playerid, "EditingTurfs", i);
			        ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
			    }
			}
	    }
	    else
	    {
	        ShowPlayerDialog(playerid,TWADMINMENU,DIALOG_STYLE_LIST,"Turf Wars - Admin Menu:","Edit Turfs...\nEdit Family Colors...","Select","Exit");
	    }
	}
	if(dialogid == TWEDITTURFSMENU)
	{
	    if(response == 1)
	    {
	        new tw = GetPVarInt(playerid, "EditingTurfs");
	        switch(listitem)
	        {
				case 0: // Edit Dim
				{
				    SetPVarInt(playerid, "EditingTurfsStage", 1);
				    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savetwpos) to edit the West Wall.");
				}
				case 1: // Edit Owner
				{
				    ShowPlayerDialog(playerid,TWEDITTURFSOWNER,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Owner Menu:","Please enter a family ID that you wish to assign to this turf:\n\nHint: Enter -1 if you wish to vacant the turf.","Change","Back");
				}
				case 2: // Edit Vulnerablity
				{
				    ShowPlayerDialog(playerid,TWEDITTURFSVUL,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Vulnerable Menu:","Please enter a Vulnerable countdown time for the turf:","Change","Back");
				}
				case 3: // Edit Locks
				{
				    ShowPlayerDialog(playerid,TWEDITTURFSLOCKED,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Locked Menu:","Lock\nUnlock","Change","Back");
				}
				case 4: // Edit Perks
				{
					ShowPlayerDialog(playerid,TWEDITTURFSPERKS,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Perks Menu:","None\nExtortion","Change","Back");
				}
				case 5: // Reset War
				{
				    ResetTurfWarsZone(1, tw);
				    TurfWarsEditTurfsSelection(playerid);
				}
				case 6: // Destroy Turf
				{
				    DestroyTurfWarsZone(tw);
				    TurfWarsEditTurfsSelection(playerid);
				}
	        }
	    }
		else
		{
		    TurfWarsEditTurfsSelection(playerid);
		}
	}
	if(dialogid == TWEDITTURFSOWNER)
	{
	    if(response == 1)
	    {
			new tw = GetPVarInt(playerid, "EditingTurfs");
			if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,TWEDITTURFSOWNER,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Owner Menu:","Please enter a family ID that you wish to assign to this turf:\n\nHint: Enter -1 if you wish to vacant the turf.","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) < -1 || strval(inputtext) > MAX_FAMILY-1)
	        {
	            ShowPlayerDialog(playerid,TWEDITTURFSOWNER,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Owner Menu:","Please enter a family ID that you wish to assign to this turf:\n\nHint: Enter -1 if you wish to vacant the turf.","Change","Back");
	            return 1;
	        }
			SetOwnerTurfWarsZone(1, tw, strval(inputtext));
			SaveTurfWars();
			ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
	    }
	    else
	    {
	        ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
	    }
	}
	if(dialogid == TWEDITTURFSVUL)
	{
	    if(response == 1)
	    {
	        new tw = GetPVarInt(playerid, "EditingTurfs");
	        if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,TWEDITTURFSVUL,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Vulnerable Menu:","Please enter a Vulnerable countdown time for the turf:","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) < 0)
	        {
	            ShowPlayerDialog(playerid,TWEDITTURFSVUL,DIALOG_STYLE_INPUT,"Turf Wars - Edit Turfs Vulnerable Menu:","Please enter a Vulnerable countdown time for the turf:","Change","Back");
	            return 1;
	        }
			TurfWars[tw][twVulnerable] = strval(inputtext);
			SaveTurfWars();
			ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
	    }
	    else
	    {
	        ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
	    }
	}
	if(dialogid == TWEDITTURFSLOCKED)
	{
	    if(response == 1)
	    {
	        new tw = GetPVarInt(playerid, "EditingTurfs");
			switch(listitem)
			{
			    case 0: // Lock
			    {
			        TurfWars[tw][twLocked] = 1;
			        SaveTurfWars();
			        ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
			    }
			    case 1: // Unlock
			    {
			        TurfWars[tw][twLocked] = 0;
			        SaveTurfWars();
			        ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
			    }
			}
	    }
	    else
	    {
	        ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
	    }
	}
	if(dialogid == TWEDITTURFSPERKS)
	{
	    if(response == 1)
	    {
	        new tw = GetPVarInt(playerid, "EditingTurfs");
	        TurfWars[tw][twSpecial] = listitem;
         	SaveTurfWars();
          	ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
	    }
		else
		{
		    ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
		}
	}
	if(dialogid == TWEDITFCOLORSSELECTION)
	{
	    if(response == 1)
	    {
			for(new i = 0; i < MAX_FAMILY-1; i++)
			{
			    if(listitem == i)
			    {
			        SetPVarInt(playerid, "EditingFamC", i+1);
			        ShowPlayerDialog(playerid,TWEDITFCOLORSMENU,DIALOG_STYLE_INPUT,"Turf Wars - Edit Family Colors Menu:","Please enter a family color ID that wish to assign to the family:\n","Select","Back");
			    }
			}
	    }
	    else
	    {
			ShowPlayerDialog(playerid,TWADMINMENU,DIALOG_STYLE_LIST,"Turf Wars - Admin Menu:","Edit Turfs...\nEdit Family Colors...","Select","Exit");
	    }
	}
	if(dialogid == TWEDITFCOLORSMENU)
	{
	    if(response == 1)
	    {
	        new fam = GetPVarInt(playerid, "EditingFamC");
	        if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,TWEDITFCOLORSMENU,DIALOG_STYLE_INPUT,"Turf Wars - Edit Family Colors Menu:","Please enter a family color ID that wish to assign to the family:\n","Select","Back");
	            return 1;
	        }
	        if(strval(inputtext) < 0 || strval(inputtext) > 14)
	        {
	            ShowPlayerDialog(playerid,TWEDITFCOLORSMENU,DIALOG_STYLE_INPUT,"Turf Wars - Edit Family Colors Menu:","Please enter a family color ID that wish to assign to the family:\n","Select","Back");
	            return 1;
	        }
	        FamilyInfo[fam][FamilyColor] = strval(inputtext);
	        SaveFamily(fam);
			TurfWarsEditFColorsSelection(playerid);

   			SyncTurfWarsRadarToAll();
	    }
	    else
	    {
	        TurfWarsEditFColorsSelection(playerid);
	    }
	}
	if(dialogid == RTONEMENU) // Ringtone Menu
	{
		if(response == 1)
		{
			switch(listitem)
			{
				case 0:
				{
					PlayerInfo[playerid][pRingtone] = 1;
					//SendAudioToPlayer(playerid, 51, 100);
				}
				case 1:
				{
					PlayerInfo[playerid][pRingtone] = 2;
					//SendAudioToPlayer(playerid, 52, 100);
				}
				case 2:
				{
					PlayerInfo[playerid][pRingtone] = 3;
					//SendAudioToPlayer(playerid, 53, 100);
				}
				case 3:
				{
					PlayerInfo[playerid][pRingtone] = 4;
					//SendAudioToPlayer(playerid, 54, 100);
				}
				case 4:
				{
					PlayerInfo[playerid][pRingtone] = 5;
					//SendAudioToPlayer(playerid, 55, 100);
				}
				case 5:
				{
					PlayerInfo[playerid][pRingtone] = 6;
					//SendAudioToPlayer(playerid, 56, 100);
				}
				case 6:
				{
					PlayerInfo[playerid][pRingtone] = 7;
					//SendAudioToPlayer(playerid, 57, 100);
				}
				case 7:
				{
					PlayerInfo[playerid][pRingtone] = 8;
					//SendAudioToPlayer(playerid, 58, 100);
				}
				case 8:
				{
					PlayerInfo[playerid][pRingtone] = 9;
					//SendAudioToPlayer(playerid, 59, 100);
				}
				case 9:
				{
					PlayerInfo[playerid][pRingtone] = 0;
				}
			}
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		}
	}
	if(dialogid == PBMAINMENU) // Paintball Arena System
	{
		if(response == 1)
		{
		    switch(listitem)
		    {
		        case 0: // Choose a Arena
		        {
		            PaintballArenaSelection(playerid);
		        }
		        case 1: // Buy Paintball Tokens
		        {
		            PaintballTokenBuyMenu(playerid);
		        }
		        case 2:
		        {
		            if(PlayerInfo[playerid][pAdmin] >= 1337)
		            {
		            	ShowPlayerDialog(playerid,PBADMINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Admin Menu:","Edit Arena...\nLock All Arenas\nUnlock All Arenas\nSave Changes to All Arenas","Select","Back");
					}
					else
					{
					    ShowPlayerDialog(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Choose an Arena\nPaintball Tokens\nAdmin Menu","Select","Leave");
					    SendClientMessageEx(playerid, COLOR_GRAD2, "You do not have authorization to access the admin panel.");
					    return 1;
					}
		        }
		    }
		}
	}
	if(dialogid == PBADMINMENU)
	{
	    if(response == 1)
	    {
			switch(listitem)
			{
			    case 0: // Edit Arena
			    {
			        PaintballEditMenu(playerid);
			    }
			    case 1: // Lock all Arenas
			    {
			        for(new i = 0; i < MAX_ARENAS; i++)
	        		{
						//foreach(new p: Player)
						for(new p = 0; p < MAX_PLAYERS; ++p)
						{
							if(IsPlayerConnected(p))
							{
								new arenaid = GetPVarInt(p, "IsInArena");
								if(arenaid == i)
								{
									if(PaintBallArena[arenaid][pbBidMoney] > 0)
									{
										GivePlayerCash(p,PaintBallArena[arenaid][pbBidMoney]);
										format(string,sizeof(string),"You have been refunded a total of $%d because of premature closure.",PaintBallArena[arenaid][pbBidMoney]);
										SendClientMessageEx(p, COLOR_WHITE, string);
									}
									if(arenaid == GetPVarInt(p, "ArenaNumber"))
									{
										switch(PaintBallArena[arenaid][pbGameType])
										{
											case 1:
											{
												if(PlayerInfo[p][pDonateRank] < 3)
												{
													PlayerInfo[p][pPaintTokens] += 3;
													format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",3);
													SendClientMessageEx(p, COLOR_WHITE, string);
												}
											}
											case 2:
											{
												if(PlayerInfo[p][pDonateRank] < 3)
												{
													PlayerInfo[p][pPaintTokens] += 4;
													format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",4);
													SendClientMessageEx(p, COLOR_WHITE, string);
												}
											}
											case 3:
											{
												if(PlayerInfo[p][pDonateRank] < 3)
												{
													PlayerInfo[p][pPaintTokens] += 5;
													format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
													SendClientMessageEx(p, COLOR_WHITE, string);
												}
											}
											case 4:
											{
												if(PlayerInfo[p][pDonateRank] < 3)
												{
													PlayerInfo[p][pPaintTokens] += 5;
													format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
													SendClientMessageEx(p, COLOR_WHITE, string);
												}
											}
											case 5:
											{
												if(PlayerInfo[p][pDonateRank] < 3)
												{
													PlayerInfo[p][pPaintTokens] += 6;
													format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",6);
													SendClientMessageEx(p, COLOR_WHITE, string);
												}
											}
										}
									}
									LeavePaintballArena(p, arenaid);
								}
							}	
						}
						ResetPaintballArena(i);
						PaintBallArena[i][pbLocked] = 2;
	        		}
           			format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has locked all Arenas.", GetPlayerNameEx(playerid));
					ABroadCast(COLOR_YELLOW, string, 2);
					format(string, sizeof(string), "* Admin %s has locked all Paintball Arenas for some short maintenance.", GetPlayerNameEx(playerid));
            		SendClientMessageToAllEx(COLOR_LIGHTBLUE, string);
            		ShowPlayerDialog(playerid,PBADMINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Admin Menu:","Edit Arena...\nLock All Arenas\nUnlock All Arenas\nSave Changes to All Arenas","Select","Back");
			    }
			    case 2: // Unlock all Arenas
				{
				    for(new i = 0; i < MAX_ARENAS; i++)
	        		{
	            		if(PaintBallArena[i][pbLocked] == 2)
	            		{
							ResetPaintballArena(i);
						}
	        		}
	        		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has unlocked all Arenas.", GetPlayerNameEx(playerid));
					ABroadCast(COLOR_YELLOW, string, 2);
					format(string, sizeof(string), "* Admin %s has unlocked all Paintball Arenas, you may join/create them now.", GetPlayerNameEx(playerid));
            		SendClientMessageToAllEx(COLOR_LIGHTBLUE, string);
            		ShowPlayerDialog(playerid,PBADMINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Admin Menu:","Edit Arena...\nLock All Arenas\nUnlock All Arenas\nSave Changes to All Arenas","Select","Back");
				}
				case 3: // Force Save Arenas
				{
				    SendClientMessageEx(playerid, COLOR_WHITE, "You have forced saved all changes to the Painball Arenas.");
				    SavePaintballArenas();
				    ShowPlayerDialog(playerid,PBADMINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Admin Menu:","Edit Arena...\nLock All Arenas\nUnlock All Arenas\nSave Changes to All Arenas","Select","Back");
				}
			}
	    }
	    else
	    {
	        ShowPlayerDialog(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Choose an Arena\nPaintball Tokens\nAdmin Menu","Select","Leave");
	    }
	}
	if(dialogid == PBARENASCORES)
	{
	    if(response == 1)
	    {
     		new arenaid = GetPVarInt(playerid, "IsInArena");
       		PaintballScoreboard(playerid,arenaid);
	    }
	}
	if(dialogid == PBEDITMENU)
	{
	    if(response == 1)
	    {
	        for(new i = 0; i < MAX_ARENAS; i++)
	        {
	            if(listitem == i)
	            {
	                if(PaintBallArena[i][pbLocked] != 2)
	                {
	                    PaintballEditMenu(playerid);
						SendClientMessageEx(playerid, COLOR_WHITE, "You cannot edit a arena that is not closed.");
						return 1;
	                }
                 	ResetPaintballArena(i);
	                PaintBallArena[i][pbLocked] = 2;

	                new Float:oldX, Float:oldY, Float:oldZ;
					GetPlayerPos(playerid, oldX, oldY, oldZ);

					SetPVarFloat(playerid, "pbOldX", oldX);
					SetPVarFloat(playerid, "pbOldY", oldY);
					SetPVarFloat(playerid, "pbOldZ", oldZ);

					SetPVarInt(playerid, "pbOldInt", GetPlayerInterior(playerid));
					SetPVarInt(playerid, "pbOldVW", GetPlayerVirtualWorld(playerid));

					SetPlayerPos(playerid, PaintBallArena[i][pbDeathmatch1][0],PaintBallArena[i][pbDeathmatch1][1],PaintBallArena[i][pbDeathmatch1][2]);
     				SetPlayerFacingAngle(playerid, PaintBallArena[i][pbDeathmatch1][3]);
         			SetPlayerInterior(playerid, PaintBallArena[i][pbInterior]);
            		SetPlayerVirtualWorld(playerid, PaintBallArena[i][pbVirtual]);
            		SetPVarInt(playerid, "ArenaNumber", i);

            		PaintballEditArenaMenu(playerid);
	            }
	        }
	    }
	    else
	    {
	        ShowPlayerDialog(playerid,PBADMINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Admin Menu:","Edit Arena...\nLock All Arenas\nUnlock All Arenas\nSave Changes to All Arenas","Select","Back");
	    }
	}
	if(dialogid == PBEDITARENAMENU)
	{
	    if(response == 1)
	    {
			switch(listitem)
			{
			    case 0: // Name
			    {
			        PaintballEditArenaName(playerid);
			    }
			    case 1: // Deathmatch Spawn Points
			    {
			        PaintballEditArenaDMSpawns(playerid);
			    }
			    case 2: // Team/CTF Spawn Points
			    {
       				PaintballEditArenaTeamSpawns(playerid);
			    }
			    case 3: // CTF Flag Spawn Points
			    {
			        PaintballEditArenaFlagSpawns(playerid);
			    }
			    case 4: // Hill Position
			    {
			        SetPVarInt(playerid, "EditingHillStage", 1);
				    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savehillpos) to edit the Hill Position.");
			    }
			    case 5: // Hill Radius
			    {
			        PaintballEditArenaHillRadius(playerid);
			    }
			    case 6: // Interior
			    {
			        PaintballEditArenaInt(playerid);
			    }
			    case 7: // Virtual World
			    {
			        PaintballEditArenaVW(playerid);
			    }
				case 8: // War Vehicle 1
				{
					SetPVarInt(playerid, "PBVeh", 1);
					SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
				}
				case 9: // War Vehicle 2
				{
					SetPVarInt(playerid, "PBVeh", 2);
					SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
				}
				case 10: // War Vehicle 3
				{
					SetPVarInt(playerid, "PBVeh", 3);
					SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
				}
				case 11: // War Vehicle 4
				{
					SetPVarInt(playerid, "PBVeh", 4);
					SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
				}
				case 12: // War Vehicle 5
				{
					SetPVarInt(playerid, "PBVeh", 5);
					SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
				}
				case 13: // War Vehicle 6
				{
					SetPVarInt(playerid, "PBVeh", 6);
					SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
				}				
			}
	    }
	    else
	    {
	        if(GetPVarInt(playerid, "ArenaNumber") != -1)
	        {
	            SetPlayerPos(playerid, GetPVarFloat(playerid, "pbOldX"),GetPVarFloat(playerid, "pbOldY"),GetPVarFloat(playerid, "pbOldZ"));
  				SetPlayerInterior(playerid, GetPVarInt(playerid, "pbOldInt"));
    			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "pbOldVW"));
     			SetPVarInt(playerid, "ArenaNumber", -1);
				Player_StreamPrep(playerid, GetPVarFloat(playerid, "pbOldX"),GetPVarFloat(playerid, "pbOldY"),GetPVarFloat(playerid, "pbOldZ"), FREEZE_TIME);
	        }
	        PaintballEditMenu(playerid);
	    }
	}
	if(dialogid == PBEDITARENANAME)
	{
		if(response == 1)
		{
		    new arenaid = GetPVarInt(playerid, "ArenaNumber");
		    if(isnull(inputtext))
		    {
		        PaintballEditArenaName(playerid);
		        return 1;
		    }
		    if(strlen(inputtext) > 11)
		    {
		        SendClientMessageEx(playerid, COLOR_WHITE, "Arena names cannot be bigger than 11 characters.");
		        PaintballEditArenaName(playerid);
		        return 1;
		    }
		    format(string, sizeof(string), inputtext);
   			strmid(PaintBallArena[arenaid][pbArenaName], string, 0, strlen(string), 64);
		    PaintballEditArenaMenu(playerid);
		}
		else
		{
		    PaintballEditArenaMenu(playerid);
		}
	}
	if(dialogid == PBEDITARENADMSPAWNS)
	{
		if(response == 1)
		{
		    new arenaid = GetPVarInt(playerid, "ArenaNumber");
		    switch(listitem)
		    {
		        case 0: // Spawn Positions 1
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "DM Position 1: Move in a position and type (/savedmpos).");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
		            SetPVarInt(playerid, "EditingDMPos", 1);

		            SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch1][0],PaintBallArena[arenaid][pbDeathmatch1][1],PaintBallArena[arenaid][pbDeathmatch1][2]);
		            SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch1][3]);
		            SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
		            SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

					PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
					PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
		        }
		        case 1: // Spawn Positions 2
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "DM Position 2: Move in a position and type (/savedmpos).");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
		            SetPVarInt(playerid, "EditingDMPos", 2);

		            SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch2][0],PaintBallArena[arenaid][pbDeathmatch2][1],PaintBallArena[arenaid][pbDeathmatch2][2]);
		            SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch2][3]);
		            SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
		            SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

					PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
					PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
		        }
		        case 2: // Spawn Positions 3
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "DM Position 3: Move in a position and type (/savedmpos).");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
		            SetPVarInt(playerid, "EditingDMPos", 3);

		            SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch3][0],PaintBallArena[arenaid][pbDeathmatch3][1],PaintBallArena[arenaid][pbDeathmatch3][2]);
		            SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch3][3]);
		            SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
		            SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

					PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
					PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
		        }
		        case 3: // Spawn Positions 4
		        {
		        	SendClientMessageEx(playerid, COLOR_WHITE, "DM Position 4: Move in a position and type (/savedmpos).");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
		            SetPVarInt(playerid, "EditingDMPos", 4);

		            SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch4][0],PaintBallArena[arenaid][pbDeathmatch4][1],PaintBallArena[arenaid][pbDeathmatch4][2]);
		            SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch4][3]);
		            SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
		            SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

					PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
					PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
		        }
		    }
		}
		else
		{
		    PaintballEditArenaMenu(playerid);
		}
	}
	if(dialogid == PBEDITARENATEAMSPAWNS)
	{
		if(response == 1)
		{
		    new arenaid = GetPVarInt(playerid, "ArenaNumber");
		    switch(listitem)
		    {
		        case 0: // Red Spawn Positions 1
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Red Team Position 1: Move in a position and type (/saveteampos).");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
		            SetPVarInt(playerid, "EditingTeamPos", 1);

		            SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed1][0],PaintBallArena[arenaid][pbTeamRed1][1],PaintBallArena[arenaid][pbTeamRed1][2]);
		            SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed1][3]);
		            SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
		            SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

					PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
					PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
				}
				case 1: // Red Spawn Positions 2
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Red Team Position 2: Move in a position and type (/saveteampos).");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
		            SetPVarInt(playerid, "EditingTeamPos", 2);

		            SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed2][0],PaintBallArena[arenaid][pbTeamRed2][1],PaintBallArena[arenaid][pbTeamRed2][2]);
		            SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed2][3]);
		            SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
		            SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

					PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
					PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
				}
				case 2: // Red Spawn Positions 3
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Red Team Position 3: Move in a position and type (/saveteampos).");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
		            SetPVarInt(playerid, "EditingTeamPos", 3);

		            SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed3][0],PaintBallArena[arenaid][pbTeamRed3][1],PaintBallArena[arenaid][pbTeamRed3][2]);
		            SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed3][3]);
		            SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
		            SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

					PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
					PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
				}
				case 3: // Blue Spawn Positions 1
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Blue Team Position 1: Move in a position and type (/saveteampos).");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
		            SetPVarInt(playerid, "EditingTeamPos", 4);

		            SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue1][0],PaintBallArena[arenaid][pbTeamBlue1][1],PaintBallArena[arenaid][pbTeamBlue1][2]);
		            SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue1][3]);
		            SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
		            SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

					PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
					PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
				}
				case 4: // Blue Spawn Positions 2
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Blue Team Position 2: Move in a position and type (/saveteampos).");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
		            SetPVarInt(playerid, "EditingTeamPos", 5);

		            SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue2][0],PaintBallArena[arenaid][pbTeamBlue2][1],PaintBallArena[arenaid][pbTeamBlue2][2]);
		            SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue2][3]);
		            SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
		            SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

					PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
					PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
				}
				case 5: // Blue Spawn Positions 3
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Blue Team Position 3: Move in a position and type (/saveteampos).");
		            SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
		            SetPVarInt(playerid, "EditingTeamPos", 6);

		            SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue3][0],PaintBallArena[arenaid][pbTeamBlue3][1],PaintBallArena[arenaid][pbTeamBlue3][2]);
		            SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue3][3]);
		            SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
		            SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

					PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
					PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
				}
		    }
		}
		else
		{
		    PaintballEditArenaMenu(playerid);
		}
	}
	if(dialogid == PBEDITARENAFLAGSPAWNS)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        switch(listitem)
	        {
	            case 0: // Red Flag
	            {
	                SendClientMessageEx(playerid, COLOR_WHITE, "Red Team Flag Position: Move in a position and type (/saveflagpos).");
	                SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
	                SetPVarInt(playerid, "EditingFlagPos", 1);

					SetPlayerPos(playerid,PaintBallArena[arenaid][pbFlagRedSpawn][0],PaintBallArena[arenaid][pbFlagRedSpawn][1],PaintBallArena[arenaid][pbFlagRedSpawn][2]);
					SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
					SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);
	            }
	            case 1: // Blue Flag
	            {
	                SendClientMessageEx(playerid, COLOR_WHITE, "Blue Team Flag Position: Move in a position and type (/saveflagpos).");
	                SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
	                SetPVarInt(playerid, "EditingFlagPos", 2);

					SetPlayerPos(playerid,PaintBallArena[arenaid][pbFlagBlueSpawn][0],PaintBallArena[arenaid][pbFlagBlueSpawn][1],PaintBallArena[arenaid][pbFlagBlueSpawn][2]);
					SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
					SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);
				}
	        }
	    }
	    else
	    {
	        PaintballEditArenaMenu(playerid);
	    }
	}
	if(dialogid == PBEDITARENAINT)
	{
	    if(response == 1)
		{
		    new arenaid = GetPVarInt(playerid, "ArenaNumber");
		    if(isnull(inputtext))
		    {
		        PaintballEditArenaInt(playerid);
		        return 1;
		    }
		    PaintBallArena[arenaid][pbInterior] = strval(inputtext);
		    PaintballEditArenaMenu(playerid);
		}
		else
		{
		    PaintballEditArenaMenu(playerid);
		}
	}
	if(dialogid == PBEDITARENAVW)
	{
	    if(response == 1)
		{
		    new arenaid = GetPVarInt(playerid, "ArenaNumber");
		    if(isnull(inputtext))
		    {
		        PaintballEditArenaVW(playerid);
		        return 1;
		    }
		    PaintBallArena[arenaid][pbVirtual] = strval(inputtext);
		    PaintballEditArenaMenu(playerid);
		}
		else
		{
		    PaintballEditArenaMenu(playerid);
		}
	}
	if(dialogid == PBEDITARENAHILLRADIUS)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(isnull(inputtext))
	        {
	            PaintballEditArenaHillRadius(playerid);
	            return 1;
	        }
	        if(floatstr(inputtext) < 0.0 || floatstr(inputtext) > 100.0)
	        {
	            PaintballEditArenaHillRadius(playerid);
	            return 1;
	        }
	        PaintBallArena[arenaid][pbHillRadius] = floatstr(inputtext);
	        PaintballEditArenaMenu(playerid);
	    }
	    else
	    {
	        PaintballEditArenaMenu(playerid);
	    }
	}
	if(dialogid == PBARENASELECTION) // Paintball Arena System
	{
	    if(response == 1)
	    {
     		for(new i = 0; i < MAX_ARENAS; i++)
       		{
       		    if(listitem == i)
       		    {
       		        //format(string, sizeof(string), "Debug: You have entered Arena %d.", i+1);
       		        //SendClientMessageEx(playerid, COLOR_WHITE, string);

       		        if(PaintBallArena[i][pbLocked] == 0) // Open
       		        {
       		            if(PlayerInfo[playerid][pPaintTokens] < 3)
						{
						    if(PlayerInfo[playerid][pDonateRank] <= 2)
						    {
								SendClientMessageEx(playerid, COLOR_WHITE, "You need at least 3 tokens to rent a room.");
						    	PaintballArenaSelection(playerid);
						    	return 1;
							}
						}
       		            ResetPaintballArena(i);
       		            PaintBallArena[i][pbPlayers] = 1;
       		            PaintBallArena[i][pbLocked] = 3;

       		            new Float:oldX, Float:oldY, Float:oldZ, Float:oldHealth, Float:oldArmor;
						GetPlayerPos(playerid, oldX, oldY, oldZ);

						SetPVarFloat(playerid, "pbOldX", oldX);
						SetPVarFloat(playerid, "pbOldY", oldY);
						SetPVarFloat(playerid, "pbOldZ", oldZ);

						GetPlayerHealth(playerid,oldHealth);
						GetPlayerArmour(playerid,oldArmor);
						SetPVarInt(playerid, "pbOldInt", GetPlayerInterior(playerid));
						SetPVarInt(playerid, "pbOldVW", GetPlayerVirtualWorld(playerid));
						SetPVarFloat(playerid, "pbOldHealth", oldHealth);
						SetPVarFloat(playerid, "pbOldArmor", oldArmor);

       		            SetPlayerPos(playerid, PaintBallArena[i][pbDeathmatch1][0],PaintBallArena[i][pbDeathmatch1][1],PaintBallArena[i][pbDeathmatch1][2]);
       		            SetPlayerFacingAngle(playerid, PaintBallArena[i][pbDeathmatch1][3]);
       		            SetPlayerInterior(playerid, PaintBallArena[i][pbInterior]);
       		            SetPlayerVirtualWorld(playerid, PaintBallArena[i][pbVirtual]);

       		            PlayerInfo[playerid][pVW] = PaintBallArena[i][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[i][pbInterior];

       		            format(string, sizeof(string), "%s",GetPlayerNameEx(playerid));
						strmid(PaintBallArena[i][pbOwner], string, 0, strlen(string), 64);
       		        	SetPVarInt(playerid, "ArenaNumber", i);
       		        	SetPVarInt(playerid, "IsInArena", i);
						PaintballSetupArena(playerid);
						return 1;
					}
					if(PaintBallArena[i][pbLocked] == 1) // Active
					{
					    if(PaintBallArena[i][pbPlayers] >= PaintBallArena[i][pbLimit])
	    				{
		        			//format(string, sizeof(string), "Debug: Arena %d is currently full, you can not enter it.", i+1);
          					//SendClientMessageEx(playerid, COLOR_WHITE, string);
	    					PaintballArenaSelection(playerid);
		    				return 1;
						}
						if(PaintBallArena[i][pbBidMoney] > GetPlayerCash(playerid))
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough cash to enter the Arena.");
							PaintballArenaSelection(playerid);
							return 1;
						}
						if(PaintBallArena[i][pbTimeLeft] < 180)
						{
						    SendClientMessageEx(playerid, COLOR_WHITE, "That Arena's round is about to end, you cannot join it.");
							PaintballArenaSelection(playerid);
						    return 1;
						}
						if(PaintBallArena[i][pbWar] == 1 && PlayerInfo[playerid][pDonateRank] < 3)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Only Gold VIP+ can enter WAR arenas.");
							PaintballArenaSelection(playerid);
							return 1;
						}
						if(PaintBallArena[i][pbGameType] == 2 || PaintBallArena[i][pbGameType] == 3 || PaintBallArena[i][pbGameType] == 5)
						{
						    SetPVarInt(playerid, "ArenaEnterTeam", i);
						    ShowPlayerDialog(playerid,PBJOINTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Choose a Team:","{FF0000}Red Team\n{0000FF}Blue Team","Enter","Leave");
						    return 1;
						}
						if(strcmp(PaintBallArena[i][pbPassword], "None", false))
						{
	    					SetPVarInt(playerid, "ArenaEnterPass", i);
	    					ShowPlayerDialog(playerid,PBJOINPASSWORD,DIALOG_STYLE_INPUT,"Paintball Arena - Password:","This Arena is currently passworded, please enter the password:","Enter","Leave");
	    					return 1;
						}
						JoinPaintballArena(playerid, i, "None");
					}
					if(PaintBallArena[i][pbLocked] == 2) // Closed
					{
					    PaintballArenaSelection(playerid);
					    return 1;
					}
					if(PaintBallArena[i][pbLocked] == 3) // Setup
					{
					    PaintballArenaSelection(playerid);
					    return 1;
					}
       		    }
	        }
		}
		else
		{
			ShowPlayerDialog(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Choose an Arena\nPaintball Tokens\nAdmin Menu","Select","Leave");
		}
	}
	if(dialogid == PBTOKENBUYMENU)
	{
	    if(response == 1)
	    {
	        if(isnull(inputtext))
	        {
				PaintballTokenBuyMenu(playerid);
				return 1;
	        }
	        if(strval(inputtext) <= 0)
	        {
	            PaintballTokenBuyMenu(playerid);
	            return 1;
	        }
	        if(strval(inputtext) > 1000)
	        {
	            PaintballTokenBuyMenu(playerid);
	            SendClientMessageEx(playerid, COLOR_WHITE, "You can not purchase more than 1000 tokens at a time.");
	            return 1;
	        }
	        if(GetPlayerCash(playerid) < 5000*strval(inputtext))
	        {
				PaintballTokenBuyMenu(playerid);
	        	format(string,sizeof(string), "You can not afford %d tokens for $%d.",strval(inputtext),strval(inputtext)*5000);
	        	SendClientMessageEx(playerid, COLOR_WHITE, string);
	        	return 1;
			}
	        GivePlayerCash(playerid, -5000*strval(inputtext));
			PlayerInfo[playerid][pPaintTokens] += strval(inputtext);
			format(string,sizeof(string), "You have purchased %d tokens for $%d.",strval(inputtext),strval(inputtext)*5000);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
	    }
	    else
	    {
	        ShowPlayerDialog(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Choose an Arena\nPaintball Tokens\nAdmin Menu","Select","Leave");
	    }
	}
	if(dialogid == PBSETUPARENA)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(PaintBallArena[arenaid][pbGameType] == 1 || PaintBallArena[arenaid][pbGameType] == 2 || PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5) // Deathmatch, Team Deathmatch, Single and Team King of the Hill.
	        {
	        	switch(listitem)
	        	{
        			case 0: // Password
	            	{
						ShowPlayerDialog(playerid,PBCHANGEPASSWORD,DIALOG_STYLE_INPUT,"Paintball Arena - Change Password:","Please enter your desired password, leave it empty if you do not want the arena passworded:","Change","Back");
						return 1;
	            	}
	            	case 1: // GameType
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEGAMEMODE,DIALOG_STYLE_LIST,"Paintball Arena - Change Gamemode:","Deathmatch\nTeam Deathmatch\nCapture the Flag\nKing of the Hill\nTeam King of the Hill","Change","Back");
	                	return 1;
	            	}
	            	case 2: // Limit
	            	{
	    				ShowPlayerDialog(playerid,PBCHANGELIMIT,DIALOG_STYLE_INPUT,"Paintball Arena - Change Limit:","Please enter a player limit (2-16):","Change","Back");
	    				return 1;
	            	}
	            	case 3: // Time Limit
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGETIMELEFT,DIALOG_STYLE_INPUT,"Paintball Arena - Change Time Limit:","Please enter a time limit for the round (5-15 minutes):","Change","Back");
	                	return 1;
	            	}
	            	case 4: // Bid Money
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEBIDMONEY,DIALOG_STYLE_INPUT,"Paintball Arena - Change Bid Money:","Please enter a bid amount for each player ($0-$10000):","Change","Back");
	                	return 1;
	            	}
	            	case 5: // Health
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEHEALTH,DIALOG_STYLE_INPUT,"Paintball Arena - Change Health:","Please enter a spawn health amount for each player (1-100):","Change","Back");
	                	return 1;
	            	}
	            	case 6: // Armor
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEARMOR,DIALOG_STYLE_INPUT,"Paintball Arena - Change Armor:","Please enter a spawn armor amount for each player (0-100):","Change","Back");
	                	return 1;
	            	}
	            	case 7: // Weapons 1
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 1):","Please enter a weapon ID for slot 1 for each player (0-34):","Change","Back");
	                	return 1;
	            	}
	            	case 8: // Weapons 2
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEWEAPONS2,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 2):","Please enter a weapon ID for slot 2 for each player (0-34):","Change","Back");
	                	return 1;
	            	}
            		case 9: // Weapons 3
	            	{
	            		ShowPlayerDialog(playerid,PBCHANGEWEAPONS3,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 3):","Please enter a weapon ID for slot 3 for each player (0-34):","Change","Back");
	                	return 1;
	            	}
	            	case 10: // Exploit Perm
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEEXPLOITPERM,DIALOG_STYLE_INPUT,"Paintball Arena - Change Exploit Permissions:","Do you wish to allow QS/CS in the room? (1 = Yes / 0 = No):","Change","Back");
	                	return 1;
	            	}
					case 11: // War
					{
						ShowPlayerDialog(playerid,PBCHANGEWAR,DIALOG_STYLE_MSGBOX,"Paintball Arena - Change War:", "Do you wish to allow War in the room?", "Yes", "No");
						return 1;
					}
	            	case 12: // Begin Arena
	            	{
	            	    if(PaintBallArena[arenaid][pbGameType] == 1)
	            	    {
	            	        if(PlayerInfo[playerid][pDonateRank] <= 2)
	                    	{
	                    		PlayerInfo[playerid][pPaintTokens] -= 3;
	                			format(string,sizeof(string),"You have rented this room for %d minutes at a cost of %d tokens.",PaintBallArena[arenaid][pbTimeLeft]/60,3);
	                			SendClientMessageEx(playerid, COLOR_YELLOW, string);
	                			SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");
	                			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	                			//SendAudioToPlayer(playerid, 27, 100);
							}
							else
							{
						    	format(string,sizeof(string),"You have rented this room for %d minutes at no cost because of Gold+ VIP.",PaintBallArena[arenaid][pbTimeLeft]/60);
	                			SendClientMessageEx(playerid, COLOR_YELLOW, string);
	                			SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");
	                			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	                			//SendAudioToPlayer(playerid, 27, 100);
							}
	            	    }
	            	    if(PaintBallArena[arenaid][pbGameType] == 2)
	            	    {
	            	    	if(PlayerInfo[playerid][pDonateRank] <= 2)
	                    	{
	                    		if(PlayerInfo[playerid][pPaintTokens] >= 4)
								{
    								PlayerInfo[playerid][pPaintTokens] -= 4;
       								format(string,sizeof(string),"You have rented this room for %d minutes at a cost of %d tokens.",PaintBallArena[arenaid][pbTimeLeft]/60,4);
          							SendClientMessageEx(playerid, COLOR_YELLOW, string);
          							SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");
          							PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
          							//SendAudioToPlayer(playerid, 27, 100);
								}
								else
								{
						    		PaintballSetupArena(playerid);
						    		SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough tokens to rent this room for this gametype.");
						    		return 1;
								}
							}
							else
							{
						    	format(string,sizeof(string),"You have rented this room for %d minutes at no cost because of Gold+ VIP.",PaintBallArena[arenaid][pbTimeLeft]/60);
	                			SendClientMessageEx(playerid, COLOR_YELLOW, string);
	                			SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");
	                			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	                			//SendAudioToPlayer(playerid, 41, 100);
							}
							PlayerInfo[playerid][pPaintTeam] = 1;
							PaintBallArena[arenaid][pbTeamRed] = 1;
	            	    }
	            	    if(PaintBallArena[arenaid][pbGameType] == 4)
	            	    {
	            	        if(PlayerInfo[playerid][pDonateRank] <= 2)
	                    	{
	                    		PlayerInfo[playerid][pPaintTokens] -= 5;
	                			format(string,sizeof(string),"You have rented this room for %d minutes at a cost of %d tokens.",PaintBallArena[arenaid][pbTimeLeft]/60,5);
	                			SendClientMessageEx(playerid, COLOR_YELLOW, string);
	                			SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");
	                			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	                			//SendAudioToPlayer(playerid, 27, 100);
							}
							else
							{
						    	format(string,sizeof(string),"You have rented this room for %d minutes at no cost because of Gold+ VIP.",PaintBallArena[arenaid][pbTimeLeft]/60);
	                			SendClientMessageEx(playerid, COLOR_YELLOW, string);
	                			SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");
	                			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	                			//SendAudioToPlayer(playerid, 27, 100);
							}

							CreatePaintballArenaHill(arenaid);
							SetPVarInt(playerid, "TickKOTHID", SetTimerEx("TickKOTH", 1000, true, "d", playerid)); // Room Owner's KOTH Tick Function
							SetPlayerCheckpoint(playerid, PaintBallArena[arenaid][pbHillX], PaintBallArena[arenaid][pbHillY], PaintBallArena[arenaid][pbHillZ], PaintBallArena[arenaid][pbHillRadius]);
	            	    }
	            	    if(PaintBallArena[arenaid][pbGameType] == 5)
	            	    {
	            	    	if(PlayerInfo[playerid][pDonateRank] <= 2)
	                    	{
	                    		if(PlayerInfo[playerid][pPaintTokens] >= 6)
								{
    								PlayerInfo[playerid][pPaintTokens] -= 6;
       								format(string,sizeof(string),"You have rented this room for %d minutes at a cost of %d tokens.",PaintBallArena[arenaid][pbTimeLeft]/60,6);
          							SendClientMessageEx(playerid, COLOR_YELLOW, string);
          							SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");
          							PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
          							//SendAudioToPlayer(playerid, 41, 100);
								}
								else
								{
						    		PaintballSetupArena(playerid);
						    		SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough tokens to rent this room for this gametype.");
						    		return 1;
								}
							}
							else
							{
						    	format(string,sizeof(string),"You have rented this room for %d minutes at no cost because of Gold+ VIP.",PaintBallArena[arenaid][pbTimeLeft]/60);
	                			SendClientMessageEx(playerid, COLOR_YELLOW, string);
	                			SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");
	                			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	                			//SendAudioToPlayer(playerid, 41, 100);
							}

							CreatePaintballArenaHill(arenaid);
							SetPVarInt(playerid, "TickKOTHID", SetTimerEx("TickKOTH", 1000, true, "d", playerid)); // Room Owner's KOTH Tick Function
							SetPlayerCheckpoint(playerid, PaintBallArena[arenaid][pbHillX], PaintBallArena[arenaid][pbHillY], PaintBallArena[arenaid][pbHillZ], PaintBallArena[arenaid][pbHillRadius]);
							PlayerInfo[playerid][pPaintTeam] = 1;
							PaintBallArena[arenaid][pbTeamRed] = 1;
	            	    }
						if(PaintBallArena[arenaid][pbWar] == 1)
						{
							if(PaintBallArena[arenaid][pbVeh1Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh1ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh1Model], PaintBallArena[arenaid][pbVeh1X], PaintBallArena[arenaid][pbVeh1Y], PaintBallArena[arenaid][pbVeh1Z], PaintBallArena[arenaid][pbVeh1A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh1ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh1ID], PaintBallArena[arenaid][pbInterior]);
							}
							if(PaintBallArena[arenaid][pbVeh2Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh2ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh2Model], PaintBallArena[arenaid][pbVeh2X], PaintBallArena[arenaid][pbVeh2Y], PaintBallArena[arenaid][pbVeh2Z], PaintBallArena[arenaid][pbVeh2A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh2ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh2ID], PaintBallArena[arenaid][pbInterior]);
							}
							if(PaintBallArena[arenaid][pbVeh3Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh3ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh3Model], PaintBallArena[arenaid][pbVeh3X], PaintBallArena[arenaid][pbVeh3Y], PaintBallArena[arenaid][pbVeh3Z], PaintBallArena[arenaid][pbVeh3A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh3ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh3ID], PaintBallArena[arenaid][pbInterior]);
							}
							if(PaintBallArena[arenaid][pbVeh4Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh4ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh4Model], PaintBallArena[arenaid][pbVeh4X], PaintBallArena[arenaid][pbVeh4Y], PaintBallArena[arenaid][pbVeh4Z], PaintBallArena[arenaid][pbVeh4A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh4ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh4ID], PaintBallArena[arenaid][pbInterior]);
							}
							if(PaintBallArena[arenaid][pbVeh5Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh5ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh5Model], PaintBallArena[arenaid][pbVeh5X], PaintBallArena[arenaid][pbVeh5Y], PaintBallArena[arenaid][pbVeh5Z], PaintBallArena[arenaid][pbVeh5A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh5ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh5ID], PaintBallArena[arenaid][pbInterior]);
							}
							if(PaintBallArena[arenaid][pbVeh6Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh6ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh6Model], PaintBallArena[arenaid][pbVeh6X], PaintBallArena[arenaid][pbVeh6Y], PaintBallArena[arenaid][pbVeh6Z], PaintBallArena[arenaid][pbVeh6A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh6ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh6ID], PaintBallArena[arenaid][pbInterior]);
							}							
						}	
    					PaintBallArena[arenaid][pbActive] = 1;
	                	PaintBallArena[arenaid][pbLocked] = 1;
	                	GivePlayerCash(playerid,-PaintBallArena[arenaid][pbBidMoney]);
	                	PaintBallArena[arenaid][pbMoneyPool] += PaintBallArena[arenaid][pbBidMoney];
	                	SpawnPaintballArena(playerid, arenaid);
						return 1;
	            	}
				}
			}
			if(PaintBallArena[arenaid][pbGameType] == 3) // Capture the Flag
			{
			    switch(listitem)
	        	{
        			case 0: // Password
	            	{
						ShowPlayerDialog(playerid,PBCHANGEPASSWORD,DIALOG_STYLE_INPUT,"Paintball Arena - Change Password:","Please enter your desired password, leave it empty if you do not want the arena passworded:","Change","Back");
						return 1;
	            	}
	            	case 1: // GameType
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEGAMEMODE,DIALOG_STYLE_LIST,"Paintball Arena - Change Gamemode:","Deathmatch\nTeam Deathmatch\nCapture the Flag\nKing of the Hill\nTeam King of the Hill","Change","Back");
	                	return 1;
	            	}
	            	case 2: // Limit
	            	{
	    				ShowPlayerDialog(playerid,PBCHANGELIMIT,DIALOG_STYLE_INPUT,"Paintball Arena - Change Limit:","Please enter a player limit (2-16):","Change","Back");
	    				return 1;
	            	}
	            	case 3: // Time Limit
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGETIMELEFT,DIALOG_STYLE_INPUT,"Paintball Arena - Change Time Limit:","Please enter a time limit for the round (5-15 minutes):","Change","Back");
	                	return 1;
	            	}
	            	case 4: // Bid Money
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEBIDMONEY,DIALOG_STYLE_INPUT,"Paintball Arena - Change Bid Money:","Please enter a bid amount for each player ($0-$10000):","Change","Back");
	                	return 1;
	            	}
	            	case 5: // Health
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEHEALTH,DIALOG_STYLE_INPUT,"Paintball Arena - Change Health:","Please enter a spawn health amount for each player (1-100):","Change","Back");
	                	return 1;
	            	}
	            	case 6: // Armor
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEARMOR,DIALOG_STYLE_INPUT,"Paintball Arena - Change Armor:","Please enter a spawn armor amount for each player (0-100):","Change","Back");
	                	return 1;
	            	}
	            	case 7: // Weapons 1
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 1):","Please enter a weapon ID for slot 1 for each player (0-34):","Change","Back");
	                	return 1;
	            	}
	            	case 8: // Weapons 2
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEWEAPONS2,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 2):","Please enter a weapon ID for slot 2 for each player (0-34):","Change","Back");
	                	return 1;
	            	}
            		case 9: // Weapons 3
	            	{
	            		ShowPlayerDialog(playerid,PBCHANGEWEAPONS3,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 3):","Please enter a weapon ID for slot 3 for each player (0-34):","Change","Back");
	                	return 1;
	            	}
	            	case 10: // Exploit Perm
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEEXPLOITPERM,DIALOG_STYLE_INPUT,"Paintball Arena - Change Exploit Permissions:","Do you wish to allow QS/CS in the room? (1 = Yes / 0 = No):","Change","Back");
	                	return 1;
	            	}
					case 11: // War
					{
						ShowPlayerDialog(playerid,PBCHANGEWAR,DIALOG_STYLE_MSGBOX,"Paintball Arena - Change War:", "Do you wish to allow War in the room?", "Yes", "No");
						return 1;
					}
	            	case 12: // Flag Instagib
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEFLAGINSTAGIB,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag Instagib:","Do you wish to allow one-shot kills on the flag holder in the room? (1 = Yes / 0 = No):\n\nHint: This set's the flag holder's health to 1 on pickup.","Change","Back");
	                	return 1;
	            	}
	            	case 13: // Flag No Weapons
	            	{
	                	ShowPlayerDialog(playerid,PBCHANGEFLAGNOWEAPONS,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag No Weapons:","Do you wish to have the flag holder's weapons to be disabled in the room? (1 = Yes / 0 = No):\n\nHint: This set's the flag holder's weapons to fists on pickup.","Change","Back");
	                	return 1;
	            	}
	            	case 14: // Begin Arena
	            	{
	            	    if(PlayerInfo[playerid][pDonateRank] <= 2)
	                    {
	                    	if(PlayerInfo[playerid][pPaintTokens] >= 5)
							{
	                    		PlayerInfo[playerid][pPaintTokens] -= 5;
	                			format(string,sizeof(string),"You have rented this room for %d minutes at a cost of %d tokens.",PaintBallArena[arenaid][pbTimeLeft]/60,5);
	                			SendClientMessageEx(playerid, COLOR_YELLOW, string);
	                			SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");
	                			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	                			//SendAudioToPlayer(playerid, 41, 100);
							}
							else
							{
						    	PaintballSetupArena(playerid);
						    	SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough tokens to rent this room for this gametype.");
						    	return 1;
							}
						}
						else
						{
						    format(string,sizeof(string),"You have rented this room for %d minutes at no cost because of Gold+ VIP.",PaintBallArena[arenaid][pbTimeLeft]/60);
	                		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	                		SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");
	                		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	                		//SendAudioToPlayer(playerid, 41, 100);
						}

						SetPVarInt(playerid, "TickCTFID", SetTimerEx("TickCTF", 1000, true, "d", playerid)); // Room Owner's CTF Tick Function
						PlayerInfo[playerid][pPaintTeam] = 1;
						PaintBallArena[arenaid][pbTeamRed] = 1;

						// Spawn Flags
						PaintBallArena[arenaid][pbTeamRedTextID] = Create3DTextLabel("Red Base", COLOR_RED, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 1000.0, PaintBallArena[arenaid][pbVirtual], 0);
						//PaintBallArena[arenaid][pbTeamRedTextID] = CreateDynamic3DTextLabel("Red Base", COLOR_RED, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 1000.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior]);
						PaintBallArena[arenaid][pbTeamBlueTextID] = Create3DTextLabel("Blue Base", COLOR_DBLUE, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 1000.0, PaintBallArena[arenaid][pbVirtual], 0);
                        //PaintBallArena[arenaid][pbTeamBlueTextID] = CreateDynamic3DTextLabel("Blue Base", COLOR_DBLUE, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 1000.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior]);
						PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);
						PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

						// Default Flag Positions
						PaintBallArena[arenaid][pbFlagRedActive] = 0;
						PaintBallArena[arenaid][pbFlagRedPos][0] = PaintBallArena[arenaid][pbFlagRedSpawn][0];
						PaintBallArena[arenaid][pbFlagRedPos][1] = PaintBallArena[arenaid][pbFlagRedSpawn][1];
						PaintBallArena[arenaid][pbFlagRedPos][2] = PaintBallArena[arenaid][pbFlagRedSpawn][2];

						PaintBallArena[arenaid][pbFlagBlueActive] = 0;
						PaintBallArena[arenaid][pbFlagBluePos][0] = PaintBallArena[arenaid][pbFlagBlueSpawn][0];
						PaintBallArena[arenaid][pbFlagBluePos][1] = PaintBallArena[arenaid][pbFlagBlueSpawn][1];
						PaintBallArena[arenaid][pbFlagBluePos][2] = PaintBallArena[arenaid][pbFlagBlueSpawn][2];

						// Start Round, Open Room
						if(PaintBallArena[arenaid][pbWar] == 1)
						{
							if(PaintBallArena[arenaid][pbVeh1Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh1ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh1Model], PaintBallArena[arenaid][pbVeh1X], PaintBallArena[arenaid][pbVeh1Y], PaintBallArena[arenaid][pbVeh1Z], PaintBallArena[arenaid][pbVeh1A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh1ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh1ID], PaintBallArena[arenaid][pbInterior]);
							}
							if(PaintBallArena[arenaid][pbVeh2Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh2ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh2Model], PaintBallArena[arenaid][pbVeh2X], PaintBallArena[arenaid][pbVeh2Y], PaintBallArena[arenaid][pbVeh2Z], PaintBallArena[arenaid][pbVeh2A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh2ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh2ID], PaintBallArena[arenaid][pbInterior]);
							}
							if(PaintBallArena[arenaid][pbVeh3Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh3ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh3Model], PaintBallArena[arenaid][pbVeh3X], PaintBallArena[arenaid][pbVeh3Y], PaintBallArena[arenaid][pbVeh3Z], PaintBallArena[arenaid][pbVeh3A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh3ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh3ID], PaintBallArena[arenaid][pbInterior]);
							}
							if(PaintBallArena[arenaid][pbVeh4Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh4ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh4Model], PaintBallArena[arenaid][pbVeh4X], PaintBallArena[arenaid][pbVeh4Y], PaintBallArena[arenaid][pbVeh4Z], PaintBallArena[arenaid][pbVeh4A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh4ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh4ID], PaintBallArena[arenaid][pbInterior]);
							}
							if(PaintBallArena[arenaid][pbVeh5Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh5ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh5Model], PaintBallArena[arenaid][pbVeh5X], PaintBallArena[arenaid][pbVeh5Y], PaintBallArena[arenaid][pbVeh5Z], PaintBallArena[arenaid][pbVeh5A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh5ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh5ID], PaintBallArena[arenaid][pbInterior]);
							}
							if(PaintBallArena[arenaid][pbVeh6Model] != 0)
							{
								PaintBallArena[arenaid][pbVeh6ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh6Model], PaintBallArena[arenaid][pbVeh6X], PaintBallArena[arenaid][pbVeh6Y], PaintBallArena[arenaid][pbVeh6Z], PaintBallArena[arenaid][pbVeh6A], 0, 0, -1);
								SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh6ID], PaintBallArena[arenaid][pbVirtual]);
								LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh6ID], PaintBallArena[arenaid][pbInterior]);
							}							
						}			
    					PaintBallArena[arenaid][pbActive] = 1;
	                	PaintBallArena[arenaid][pbLocked] = 1;
	                	GivePlayerCash(playerid,-PaintBallArena[arenaid][pbBidMoney]);
	                	PaintBallArena[arenaid][pbMoneyPool] += PaintBallArena[arenaid][pbBidMoney];
	                	SpawnPaintballArena(playerid, arenaid);
						return 1;
	            	}
				}
			}
	        PaintballSetupArena(playerid);
	    }
	    else
	    {
	        LeavePaintballArena(playerid, GetPVarInt(playerid, "ArenaNumber"));
	        PaintballArenaSelection(playerid);
	    }
	}
	if(dialogid == PBCHANGEPASSWORD)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(isnull(inputtext))
	        {
	            format(string, sizeof(string), "None");
				strmid(PaintBallArena[arenaid][pbPassword], string, 0, strlen(string), 64);
				PaintballSetupArena(playerid);
				return 1;
	        }
	        strmid(PaintBallArena[arenaid][pbPassword], inputtext, 0, strlen(inputtext), 64);
			PaintballSetupArena(playerid);
	    }
	    else
	    {
	        PaintballSetupArena(playerid);
	    }
	}
	if(dialogid == PBCHANGEGAMEMODE)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
			switch(listitem)
			{
			    case 0:
			    {
					PaintBallArena[arenaid][pbGameType] = 1;
					PaintballSetupArena(playerid);
			    }
			    case 1:
			    {
			        PaintBallArena[arenaid][pbGameType] = 2;
					PaintballSetupArena(playerid);
			    }
			    case 2:
			    {
			        PaintBallArena[arenaid][pbGameType] = 3;
			        PaintballSetupArena(playerid);
			    }
			    case 3:
			    {
			        PaintBallArena[arenaid][pbGameType] = 4;
			        PaintballSetupArena(playerid);
			    }
			    case 4:
			    {
			        PaintBallArena[arenaid][pbGameType] = 5;
			        PaintballSetupArena(playerid);
			    }
			}
	    }
	    else
	    {
	        PaintballSetupArena(playerid);
	    }
	}
	if(dialogid == PBCHANGELIMIT)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,PBCHANGELIMIT,DIALOG_STYLE_INPUT,"Paintball Arena - Change Limit:","Please enter a player limit (2-16):","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) < 2 || strval(inputtext) > 16)
	        {
	            ShowPlayerDialog(playerid,PBCHANGELIMIT,DIALOG_STYLE_INPUT,"Paintball Arena - Change Limit:","Please enter a player limit (2-16):","Change","Back");
	            return 1;
	        }
			PaintBallArena[arenaid][pbLimit] = strval(inputtext);
			PaintballSetupArena(playerid);
	    }
	    else
	    {
	    	PaintballSetupArena(playerid);
	    }
	}
	if(dialogid == PBCHANGETIMELEFT)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,PBCHANGETIMELEFT,DIALOG_STYLE_INPUT,"Paintball Arena - Change Time Limit:","Please enter a Time Limit for the round (5-15 Minutes):","Change","Back");
	            return 1;
	        }
	        if(strfind(".", inputtext, true) != -1)
	        {
	            ShowPlayerDialog(playerid,PBCHANGETIMELEFT,DIALOG_STYLE_INPUT,"Paintball Arena - Change Time Limit:","Please enter a Time Limit for the round (5-15 Minutes):","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) < 5 || strval(inputtext) > 15)
	        {
	            ShowPlayerDialog(playerid,PBCHANGETIMELEFT,DIALOG_STYLE_INPUT,"Paintball Arena - Change Time Limit:","Please enter a Time Limit for the round (5-15 Minutes):","Change","Back");
	            return 1;
	        }
	        PaintBallArena[arenaid][pbTimeLeft] = strval(inputtext)*60;
	        PaintballSetupArena(playerid);
	    }
	    else
	    {
			PaintballSetupArena(playerid);
	    }
	}
	if(dialogid == PBCHANGEBIDMONEY)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,PBCHANGEBIDMONEY,DIALOG_STYLE_INPUT,"Paintball Arena - Change Bid Money:","Please enter a bid amount for each person ($0-$10000):","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) < 0 || strval(inputtext) > 10000)
	        {
	            ShowPlayerDialog(playerid,PBCHANGEBIDMONEY,DIALOG_STYLE_INPUT,"Paintball Arena - Change Bid Money:","Please enter a bid amount for each person ($0-$10000):","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) > GetPlayerCash(playerid))
	        {
	            ShowPlayerDialog(playerid,PBCHANGEBIDMONEY,DIALOG_STYLE_INPUT,"Paintball Arena - Change Bid Money:","Please enter a bid amount for each person ($0-$10000):","Change","Back");
	            SendClientMessageEx(playerid, COLOR_WHITE, "You can't enter a bid amount greater than your current cash.");
	            return 1;
	        }
	        PaintBallArena[arenaid][pbBidMoney] = strval(inputtext);
	        PaintballSetupArena(playerid);
		}
		else
		{
			PaintballSetupArena(playerid);
		}
	}
	if(dialogid == PBCHANGEHEALTH)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,PBCHANGEHEALTH,DIALOG_STYLE_INPUT,"Paintball Arena - Change Health:","Please enter a spawn health amount for each person (1-100):","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) < 1 || strval(inputtext) > 100)
	        {
	            ShowPlayerDialog(playerid,PBCHANGEHEALTH,DIALOG_STYLE_INPUT,"Paintball Arena - Change Health:","Please enter a spawn health amount for each person (1-100):","Change","Back");
	            return 1;
	        }
	        PaintBallArena[arenaid][pbHealth] = strval(inputtext);
	        PaintballSetupArena(playerid);
		}
		else
		{
			PaintballSetupArena(playerid);
		}
	}
	if(dialogid == PBCHANGEARMOR)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,PBCHANGEARMOR,DIALOG_STYLE_INPUT,"Paintball Arena - Change Armor:","Please enter a spawn armor amount for each person (0-99):","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) < 0 || strval(inputtext) > 99)
	        {
	            ShowPlayerDialog(playerid,PBCHANGEARMOR,DIALOG_STYLE_INPUT,"Paintball Arena - Change Armor:","Please enter a spawn armor amount for each person (0-99):","Change","Back");
	            return 1;
	        }
	        PaintBallArena[arenaid][pbArmor] = strval(inputtext);
	        PaintballSetupArena(playerid);
		}
		else
		{
			PaintballSetupArena(playerid);
		}
	}
	if(dialogid == PBCHANGEWEAPONS1)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 1):","Please enter a weapon ID for slot 1 for each player (0-34):","Change","Back");
	            return 1;
	        }
			if(strval(inputtext) == 16 || strval(inputtext) == 18)
			{
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 1):","Please enter a weapon ID for slot 1 for each player (0-34):","Change","Back");
	            return 1;			
			}
	        if(strval(inputtext) < 0||strval(inputtext) > 34)
	        {
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 1):","Please enter a weapon ID for slot 1 for each player (0-34):","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) >= 19 && strval(inputtext) <= 21)
	        {
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 1):","Please enter a weapon ID for slot 1 for each player (0-34):","Change","Back");
	            return 1;
	        }
	        PaintBallArena[arenaid][pbWeapons][0] = strval(inputtext);
	        PaintballSetupArena(playerid);
		}
		else
		{
			PaintballSetupArena(playerid);
		}
	}
	if(dialogid == PBCHANGEWEAPONS2)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS2,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 2):","Please enter a weapon ID for slot 2 for each player (0-34):","Change","Back");
	            return 1;
	        }
			if(strval(inputtext) == 16 || strval(inputtext) == 18)
			{
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 1):","Please enter a weapon ID for slot 1 for each player (0-34):","Change","Back");
	            return 1;			
			}			
	        if(strval(inputtext) < 0||strval(inputtext) > 34)
	        {
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS2,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 2):","Please enter a weapon ID for slot 2 for each player (0-34):","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) >= 19 && strval(inputtext) <= 21)
	        {
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS2,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 2):","Please enter a weapon ID for slot 2 for each player (0-34):","Change","Back");
	            return 1;
	        }
	        PaintBallArena[arenaid][pbWeapons][1] = strval(inputtext);
	        PaintballSetupArena(playerid);
		}
		else
		{
			PaintballSetupArena(playerid);
		}
	}
	if(dialogid == PBCHANGEWEAPONS3)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
	        if(isnull(inputtext))
	        {
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS3,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 3):","Please enter a weapon ID for slot 3 for each player (0-34):","Change","Back");
	            return 1;
	        }
			if(strval(inputtext) == 16 || strval(inputtext) == 18)
			{
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 1):","Please enter a weapon ID for slot 1 for each player (0-34):","Change","Back");
	            return 1;			
			}			
	        if(strval(inputtext) < 0||strval(inputtext) > 34)
	        {
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS3,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 3):","Please enter a weapon ID for slot 3 for each player (0-34):","Change","Back");
	            return 1;
	        }
	        if(strval(inputtext) >= 19 && strval(inputtext) <= 21)
	        {
	            ShowPlayerDialog(playerid,PBCHANGEWEAPONS3,DIALOG_STYLE_INPUT,"Paintball Arena - Change Weapons (Slot 3):","Please enter a weapon ID for slot 3 for each player (0-34):","Change","Back");
	            return 1;
	        }
	        PaintBallArena[arenaid][pbWeapons][2] = strval(inputtext);
	        PaintballSetupArena(playerid);
		}
		else
		{
			PaintballSetupArena(playerid);
		}
	}
	if(dialogid == PBCHANGEEXPLOITPERM)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
			if(isnull(inputtext))
			{
			    ShowPlayerDialog(playerid,PBCHANGEEXPLOITPERM,DIALOG_STYLE_INPUT,"Paintball Arena - Change Exploit Permissions:","Do you wish to allow QS/CS in the room? (1 = Yes / 0 = No):","Change","Back");
			    return 1;
			}
			if(strval(inputtext) < 0||strval(inputtext) > 1)
			{
			    ShowPlayerDialog(playerid,PBCHANGEEXPLOITPERM,DIALOG_STYLE_INPUT,"Paintball Arena - Change Exploit Permissions:","Do you wish to allow QS/CS in the room? (1 = Yes / 0 = No):","Change","Back");
			    return 1;
			}
			PaintBallArena[arenaid][pbExploitPerm] = strval(inputtext);
			PaintballSetupArena(playerid);
	    }
	    else
	    {
	        PaintballSetupArena(playerid);
	    }
	}
	if(dialogid == PBCHANGEWAR)
	{
		new arenaid = GetPVarInt(playerid, "ArenaNumber");
		if(response == 1)
		{
			if(PlayerInfo[playerid][pDonateRank] >= 3)
			{
				PaintBallArena[arenaid][pbWar] = 1;
			}
			else
			{
				PaintBallArena[arenaid][pbWar] = 0;
				SendClientMessageEx(playerid, COLOR_YELLOW, "Only Gold VIP+ can use this feature.");
			}
			PaintballSetupArena(playerid);
		}
		else
		{
			PaintBallArena[arenaid][pbWar] = 0;
			PaintballSetupArena(playerid);
		}
	}	
	if(dialogid == PBCHANGEFLAGINSTAGIB)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
			if(isnull(inputtext))
			{
			    ShowPlayerDialog(playerid,PBCHANGEFLAGINSTAGIB,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag Instagib:","Do you wish to allow one-shot kills on the flag holder in the room? (1 = Yes / 0 = No):\n\nHint: This set's the flag holder's health to 1 on pickup.","Change","Back");
			    return 1;
			}
			if(strval(inputtext) < 0||strval(inputtext) > 1)
			{
			    ShowPlayerDialog(playerid,PBCHANGEFLAGINSTAGIB,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag Instagib:","Do you wish to allow one-shot kills on the flag holder in the room? (1 = Yes / 0 = No):\n\nHint: This set's the flag holder's health to 1 on pickup.","Change","Back");
			    return 1;
			}
			PaintBallArena[arenaid][pbFlagInstagib] = strval(inputtext);
			PaintballSetupArena(playerid);
	    }
	    else
	    {
	        PaintballSetupArena(playerid);
	    }
	}
	if(dialogid == PBCHANGEFLAGNOWEAPONS)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaNumber");
			if(isnull(inputtext))
			{
			    ShowPlayerDialog(playerid,PBCHANGEFLAGNOWEAPONS,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag No Weapons:","Do you wish to have the flag holder's weapons to be disabled in the room? (1 = Yes / 0 = No):\n\nHint: This set's the flag holder's weapons to fists on pickup.","Change","Back");
			    return 1;
			}
			if(strval(inputtext) < 0||strval(inputtext) > 1)
			{
			    ShowPlayerDialog(playerid,PBCHANGEFLAGNOWEAPONS,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag No Weapons:","Do you wish to have the flag holder's weapons to be disabled in the room? (1 = Yes / 0 = No):\n\nHint: This set's the flag holder's weapons to fists on pickup.","Change","Back");
			    return 1;
			}
			PaintBallArena[arenaid][pbFlagNoWeapons] = strval(inputtext);
			PaintballSetupArena(playerid);
	    }
	    else
	    {
	        PaintballSetupArena(playerid);
	    }
	}
	if(dialogid == PBJOINPASSWORD)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaEnterPass");
	        if(PaintBallArena[arenaid][pbPlayers] >= PaintBallArena[arenaid][pbLimit])
			{
    			PaintballArenaSelection(playerid);
    			SetPVarInt(playerid, "ArenaEnterPass", -1);
    			SetPVarInt(playerid, "pbTeamChoice", 0);
	   			return 1;
			}
			if(isnull(inputtext))
			{
			    PaintballArenaSelection(playerid);
			    SetPVarInt(playerid, "ArenaEnterPass", -1);
			    SetPVarInt(playerid, "pbTeamChoice", 0);
			    return 1;
			}
			if(strcmp(PaintBallArena[arenaid][pbPassword], inputtext, false))
			{
	    		PaintballArenaSelection(playerid);
	    		SetPVarInt(playerid, "ArenaEnterPass", -1);
	    		SetPVarInt(playerid, "pbTeamChoice", 0);
	    		return 1;
			}
	        if(JoinPaintballArena(playerid,arenaid,inputtext))
	        {
	            SetPVarInt(playerid, "ArenaEnterPass", -1);
	        }
	        else
	        {
				PaintballArenaSelection(playerid);
				SetPVarInt(playerid, "pbTeamChoice", 0);
	        }
	    }
	    else
	    {
			PaintballArenaSelection(playerid);
			SetPVarInt(playerid, "pbTeamChoice", 0);
	    }
	}
	if(dialogid == PBSWITCHTEAM)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "IsInArena");
	        switch(listitem)
	        {
	        	case 0: // Red
 				{
 				    new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
 				    if(PlayerInfo[playerid][pPaintTeam] == 1)
 				    {
 				        SendClientMessageEx(playerid, COLOR_WHITE, "You are already on the Red Team!");
 				        PaintballSwitchTeam(playerid);
 				        return 1;
 				    }
 				    if(PaintBallArena[arenaid][pbTimeLeft] < 180)
 				    {
 				        SendClientMessageEx(playerid, COLOR_WHITE, "You can not switch teams now!");
						return 1;
 				    }
 				    if(PaintBallArena[arenaid][pbTeamRed] >= teamlimit)
 				    {
						SendClientMessageEx(playerid, COLOR_WHITE, "Red Team is currently full, please choose another team.");
 				        PaintballSwitchTeam(playerid);
 				        return 1;
 				    }
 				    if(PaintBallArena[arenaid][pbTeamRed] > PaintBallArena[arenaid][pbTeamBlue])
 				    {
 				        SendClientMessageEx(playerid, COLOR_WHITE, "Teams would be un-even, you cannot switch teams right now.");
 				        return 1;
 				    }
 				    PaintBallArena[arenaid][pbTeamBlue]--;
 				    PaintBallArena[arenaid][pbTeamRed]++;
 				    PlayerInfo[playerid][pPaintTeam] = 1;
 				    SetPlayerHealth(playerid, 0);
	        	}
	        	case 1: // Blue
	        	{
	        	    new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
	        	    if(PlayerInfo[playerid][pPaintTeam] == 2)
 				    {
 				        SendClientMessageEx(playerid, COLOR_WHITE, "You are already on the Blue Team!");
 				        PaintballSwitchTeam(playerid);
 				        return 1;
 				    }
 				    if(PaintBallArena[arenaid][pbTimeLeft] < 180)
 				    {
 				        SendClientMessageEx(playerid, COLOR_WHITE, "You can not switch teams now!");
						return 1;
 				    }
 				    if(PaintBallArena[arenaid][pbTeamBlue] >= teamlimit)
 				    {
						SendClientMessageEx(playerid, COLOR_WHITE, "Blue Team is currently full, please choose another team.");
 				        PaintballSwitchTeam(playerid);
 				        return 1;
 				    }
 				    if(PaintBallArena[arenaid][pbTeamBlue] > PaintBallArena[arenaid][pbTeamRed])
 				    {
 				        SendClientMessageEx(playerid, COLOR_WHITE, "Teams would be un-even, you cannot switch teams right now.");
 				        return 1;
 				    }
 				    PaintBallArena[arenaid][pbTeamRed]--;
 				    PaintBallArena[arenaid][pbTeamBlue]++;
 				    PlayerInfo[playerid][pPaintTeam] = 2;
 				    SetPlayerHealth(playerid, 0);
	        	}
			}
	    }
	}
	if(dialogid == PBJOINTEAM)
	{
	    if(response == 1)
	    {
	        new arenaid = GetPVarInt(playerid, "ArenaEnterTeam");
	        if(PaintBallArena[arenaid][pbPlayers] >= PaintBallArena[arenaid][pbLimit])
	        {
	            PaintballArenaSelection(playerid);
	            SetPVarInt(playerid, "ArenaEnterTeam", -1);
	            return 1;
	        }
	        switch(listitem)
	        {
	        	case 0: // Red
 				{
 				    new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
 				    if(PaintBallArena[arenaid][pbTeamRed] >= teamlimit)
 				    {
						SendClientMessageEx(playerid, COLOR_WHITE, "Red Team is currently full, please choose another team.");
 				        ShowPlayerDialog(playerid,PBJOINTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Choose a Team:","{FF0000}Red Team\n{0000FF}Blue Team","Enter","Leave");
 				        return 1;
 				    }
 				    if(PaintBallArena[arenaid][pbTeamRed] > PaintBallArena[arenaid][pbTeamBlue])
 				    {
 				        SendClientMessageEx(playerid, COLOR_WHITE, "Teams are un-even, please choose another team.");
 				        ShowPlayerDialog(playerid,PBJOINTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Choose a Team:","{FF0000}Red Team\n{0000FF}Blue Team","Enter","Leave");
 				        return 1;
 				    }
 				    SetPVarInt(playerid, "pbTeamChoice", 1);
 				    if(strcmp(PaintBallArena[arenaid][pbPassword], "None", false))
					{
						SetPVarInt(playerid, "ArenaEnterPass", arenaid);
						ShowPlayerDialog(playerid,PBJOINPASSWORD,DIALOG_STYLE_INPUT,"Paintball Arena - Password:","This Arena is currently passworded, please enter the password:","Enter","Leave");
						return 1;
					}
					JoinPaintballArena(playerid, arenaid, "None");
	        	}
	        	case 1: // Blue
	        	{
	        	    new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
 				    if(PaintBallArena[arenaid][pbTeamBlue] >= teamlimit)
 				    {
						SendClientMessageEx(playerid, COLOR_WHITE, "Blue Team is currently full, please choose another team.");
 				        ShowPlayerDialog(playerid,PBJOINTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Choose a Team:","{FF0000}Red Team\n{0000FF}Blue Team","Enter","Leave");
 				        return 1;
 				    }
 				    if(PaintBallArena[arenaid][pbTeamBlue] > PaintBallArena[arenaid][pbTeamRed])
 				    {
 				        SendClientMessageEx(playerid, COLOR_WHITE, "Teams are un-even, please choose another team.");
 				        ShowPlayerDialog(playerid,PBJOINTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Choose a Team:","{FF0000}Red Team\n{0000FF}Blue Team","Enter","Leave");
 				        return 1;
 				    }
 				    SetPVarInt(playerid, "pbTeamChoice", 2);
 				    if(strcmp(PaintBallArena[arenaid][pbPassword], "None", false))
					{
						SetPVarInt(playerid, "ArenaEnterPass", arenaid);
						ShowPlayerDialog(playerid,PBJOINPASSWORD,DIALOG_STYLE_INPUT,"Paintball Arena - Password:","This Arena is currently passworded, please enter the password:","Enter","Leave");
						return 1;
					}
					JoinPaintballArena(playerid, arenaid, "None");
	        	}
			}
	    }
	    else
	    {
	        PaintballArenaSelection(playerid);
	    }
	}
	if(dialogid == DOORLOCK)
	{
		if(response == 1)
		{
		    new i = GetPVarInt(playerid, "Door");
		    if(isnull(inputtext))
		    {
		        SendClientMessage(playerid, COLOR_GREY, "You did not enter anything" );
		        return 1;
		    }
		    if(strlen(inputtext) > 24)
		    {
		        SendClientMessageEx(playerid, COLOR_GREY, "The password can not be greater than 24 characters.");
		        return 1;
		    }
		    if(strcmp(inputtext, DDoorsInfo[i][ddPass], true) == 0)
		    {
		        if(DDoorsInfo[i][ddLocked] == 0)
		        {
					DDoorsInfo[i][ddLocked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "Password accepted, doors locked.");
		        }
		        else
		        {
		            DDoorsInfo[i][ddLocked] = 0;
		            SendClientMessageEx(playerid, COLOR_WHITE, "Password accepted, doors unlocked.");
		        }
				SaveDynamicDoor(i);
			}
			else
			{
			    SendClientMessageEx(playerid, COLOR_WHITE, "Password declined.");
			}
		}
		else
		{
		    return 1;
		}
	}
	/*if(dialogid == STORAGEEQUIP)
	{
		if(response == 1)
		{
			if(StorageInfo[playerid][listitem][sAttached] == 0)
			{
				switch(listitem)
				{
					case 0: // Bag
					{
						if(StorageInfo[playerid][0][sStorage] != 1) {
							SendClientMessageEx(playerid, COLOR_WHITE, "You do not own a Bag, you can buy one at a 24/7 Store.");
							ShowStorageEquipDialog(playerid);
							return 1;
						}
						for(new i = 0; i < 3; i++)
						{
							if(StorageInfo[playerid][i][sAttached] == 1)
							{
								StorageInfo[playerid][i][sAttached] = 0;
								if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
							}
						}
						SetPlayerAttachedObject(playerid, 9, 2919, 5, 0.25, 0, 0, 0, 270, 0, 0.2, 0.2, 0.2);
						format(string, sizeof(string), "* %s takes out a Bag.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
					case 1: // Backpack
					{
						if(StorageInfo[playerid][1][sStorage] != 1) {
							SendClientMessageEx(playerid, COLOR_WHITE, "You do not own a Backpack, you can buy one at our E-Store.");
							ShowStorageEquipDialog(playerid);
							return 1;
						}
						for(new i = 0; i < 3; i++)
						{
							if(StorageInfo[playerid][i][sAttached] == 1)
							{
								StorageInfo[playerid][i][sAttached] = 0;
								if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
							}
						}
						SetPlayerAttachedObject(playerid, 9, 371, 1, 0.1, -0.1, 0, 0, 90, 0, 1, 1, 1);
						format(string, sizeof(string), "* %s takes out a Backpack.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
					case 2: // Briefcase
					{
						if(StorageInfo[playerid][2][sStorage] != 1) {
							SendClientMessageEx(playerid, COLOR_WHITE, "You do not own a Briefcase, you can buy one at our E-Store.");
							ShowStorageEquipDialog(playerid);
							return 1;
						}
						for(new i = 0; i < 3; i++)
						{
							if(StorageInfo[playerid][i][sAttached] == 1)
							{
								StorageInfo[playerid][i][sAttached] = 0;
								if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
							}
						}
						SetPlayerAttachedObject(playerid, 9, 1210, 5, 0.3, 0.0, 0.0, 0.0, 270.0, 180.0, 1, 1, 1);
						format(string, sizeof(string), "* %s takes out a Briefcase.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
				}
				StorageInfo[playerid][listitem][sAttached] = 1;
			}
			else
			{
				StorageInfo[playerid][listitem][sAttached] = 0;
				if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
				format(string, sizeof(string), "* %s puts %s away.", GetPlayerNameEx(playerid), storagetype[listitem+1]);
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
			return 1;
		}
	}
	if(dialogid == STORAGESTORE)
	{
		if(response == 0)
		{
			if(GetPVarInt(playerid, "Storage_fromplayerid") != -1) {
				SendClientMessageEx(GetPVarInt(playerid, "Storage_fromplayerid"), COLOR_WHITE, "The transaction has been cancelled.");
			}

			DeletePVar(playerid, "Storage_transaction");
			DeletePVar(playerid, "Storage_fromplayerid");
			DeletePVar(playerid, "Storage_fromstorageid");
			DeletePVar(playerid, "Storage_itemid");
			DeletePVar(playerid, "Storage_amount");
			DeletePVar(playerid, "Storage_price");
			DeletePVar(playerid, "Storage_special");

			SendClientMessageEx(playerid, COLOR_WHITE, "You have cancelled the transaction.");
		}
		else
		{
			new fromplayerid, fromstorageid, itemid, amount, price, special, listitemex;

			fromplayerid = GetPVarInt(playerid, "Storage_fromplayerid");
			fromstorageid = GetPVarInt(playerid, "Storage_fromstorageid");
			itemid = GetPVarInt(playerid, "Storage_itemid");
			amount = GetPVarInt(playerid, "Storage_amount");
			price = GetPVarInt(playerid, "Storage_price");
			special = GetPVarInt(playerid, "Storage_special");

			DeletePVar(playerid, "Storage_transaction");
			DeletePVar(playerid, "Storage_fromplayerid");
			DeletePVar(playerid, "Storage_fromstorageid");
			DeletePVar(playerid, "Storage_itemid");
			DeletePVar(playerid, "Storage_amount");
			DeletePVar(playerid, "Storage_price");
			DeletePVar(playerid, "Storage_special");

			new bool:itemEquipped = false;
			if(listitem != 0) // If not the Pocket, then find the storage device
			{
				// Find the storageid of the storagedevice.
				for(new i = 0; i < 3; i++)
				{
					if(StorageInfo[playerid][i][sAttached] == 1) {
						listitemex = i+1;
						itemEquipped = true;
					}
				}
			}

			if(TransferStorage(playerid, listitemex, fromplayerid, fromstorageid, itemid, amount, price, special) == 0 || (itemEquipped == false && listitem != 0)) // Unsuccessful Transfer
			{
				ShowStorageDialog(playerid, fromplayerid, fromstorageid, itemid, amount, price, special);
			}
			else // Successful Transfer
			{
				if(fromplayerid != -1 && fromstorageid != -1 && price != -1) {
					if(playerid != fromplayerid) {
						PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
						format(string, sizeof(string), "$%s has been transfered to your Pocket ($%s).", number_format(price), number_format(PlayerInfo[fromplayerid][pCash]));
						SendClientMessage(fromplayerid, COLOR_WHITE, string);

						PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
						format(string, sizeof(string), "$%s has been transfered from your Pocket to %s's Pocket.", number_format(price), GetPlayerNameEx(fromplayerid));
						SendClientMessage(playerid, COLOR_WHITE, string);

						format(string, sizeof(string), "* %s takes out some Cash, and hands it to %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(fromplayerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}

					PlayerInfo[playerid][pCash] -= price;
					PlayerInfo[fromplayerid][pCash] += price;
				}

				if(special == 1 && itemid == 2) // Pot Special "Selling"
				{
					ExtortionTurfsWarsZone(PotOffer[playerid], 1, PotPrice[playerid]);

					if(PlayerInfo[PotOffer[playerid]][pDoubleEXP] > 0)
					{
						format(string, sizeof(string), "You have gained 2 drug dealer skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[PotOffer[playerid]][pDoubleEXP]);
						SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, string);
   						PlayerInfo[PotOffer[playerid]][pDrugsSkill] += 2;
					}
					else
					{
  						PlayerInfo[PotOffer[playerid]][pDrugsSkill] += 1;
					}

                    if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 50)
                    { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 2, you can buy more Grams and Cheaper."); }
                    else if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 100)
                    { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 3, you can buy more Grams and Cheaper."); }
                    else if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 200)
                    { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 4, you can buy more Grams and Cheaper."); }
                    else if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 400)
                    { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 5, you can buy more Grams and Cheaper."); }

					PotOffer[playerid] = INVALID_PLAYER_ID;
					PotStorageID[playerid] = -1;
                    PotPrice[playerid] = 0;
                    PotGram[playerid] = 0;
				}
				if(special == 1 && itemid == 3) // Crack Special "Selling"
				{
					ExtortionTurfsWarsZone(CrackOffer[playerid], 1, CrackPrice[playerid]);

					if(PlayerInfo[CrackOffer[playerid]][pDoubleEXP] > 0)
					{
						format(string, sizeof(string), "You have gained 2 drug dealer skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[CrackOffer[playerid]][pDoubleEXP]);
						SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, string);
   						PlayerInfo[CrackOffer[playerid]][pDrugsSkill] += 2;
					}
					else
					{
  						PlayerInfo[CrackOffer[playerid]][pDrugsSkill] += 1;
					}

                    PlayerInfo[playerid][pCrack] += CrackGram[playerid];
                    PlayerInfo[CrackOffer[playerid]][pCrack] -= CrackGram[playerid];
                    if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 50)
                    { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 2, you can buy more Grams and Cheaper."); }
                    else if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 100)
					{ SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 3, you can buy more Grams and Cheaper."); }
                    else if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 200)
                    { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 4, you can buy more Grams and Cheaper."); }
                    else if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 400)
                    { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 5, you can buy more Grams and Cheaper."); }

					CrackOffer[playerid] = INVALID_PLAYER_ID;
					CrackStorageID[playerid] = -1;
                    CrackPrice[playerid] = 0;
                    CrackGram[playerid] = 0;
				}
				if(special == 2 && itemid == 2) // Pot Special "Getting"
				{
					new mypoint = -1;
					for (new i=0; i<MAX_POINTS; i++)
					{
						if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 3)
						{
							mypoint = i;
						}
					}

					if(PlayerInfo[playerid][pDonateRank] < 1)
					{
						Points[mypoint][Stock] -= amount;
						format(string, sizeof(string), " POT AVAILABLE: %d/1000.", Points[mypoint][Stock]);
						UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
					}
					for(new i = 0; i < sizeof(FamilyInfo); i++)
					{
						if(strcmp(Points[mypoint][Owner], FamilyInfo[i][FamilyName], true) == 0)
						{
							FamilyInfo[i][FamilyBank] = FamilyInfo[i][FamilyBank]+price/2;
						}
					}
				}
				if(special == 2 && itemid == 3) // Crack Special "Getting"
				{
					new mypoint = -1;
					for (new i=0; i<MAX_POINTS; i++)
					{
						if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 4)
						{
							mypoint = i;
						}
					}
					if(PlayerInfo[playerid][pDonateRank] < 1)
					{
						Points[mypoint][Stock] -= amount;
						format(string, sizeof(string), " CRACK AVAILABLE: %d/500.", Points[mypoint][Stock]);
						UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
					}
					for(new i = 0; i < sizeof(FamilyInfo); i++)
					{
						if(strcmp(Points[mypoint][Owner], FamilyInfo[i][FamilyName], true) == 0)
						{
							FamilyInfo[i][FamilyBank] = FamilyInfo[i][FamilyBank]+price/2;
						}
					}
				}
				if(special == 2 && itemid == 4) // Materials Special "Getting"
				{
					DeletePVar(playerid, "Packages");
					DeletePVar(playerid, "MatDeliver");
					DisablePlayerCheckpoint(playerid);
				}
				if(special == 3 && itemid == 2) // PickWeed Special
				{

					new id = GetPVarInt(playerid, "Special_PickWeedID");
					DeletePVar(playerid, "Special_PickWeedID");

					new szMessage[52];

					ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_Out", 4.0, 0, 0, 0, 0, 0, 1);
					format(szMessage, sizeof(szMessage), "You picked the plant and gathered %d grams of pot.", PlayerInfo[id][pWeedGrowth]);
					SendClientMessageEx(playerid, COLOR_GREY, szMessage);
					format(szMessage, sizeof(szMessage), "* %s picks the weed plant.", GetPlayerNameEx(playerid));
					ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					DestroyDynamicObject(PlayerInfo[id][pWeedObject]);
					PlayerInfo[id][pWeedObject] = 0;
				}
				if(special == 4 && itemid == 1) // House Withdraw - Cash
				{
					new houseid = GetPVarInt(playerid, "Special_HouseID");
					DeletePVar(playerid, "Special_HouseID");

					HouseInfo[houseid][hSafeMoney] -= amount;
				}
				if(special == 4 && itemid == 2) // House Withdraw - Pot
				{
					new houseid = GetPVarInt(playerid, "Special_HouseID");
					DeletePVar(playerid, "Special_HouseID");

					HouseInfo[houseid][hPot] -= amount;
				}
				if(special == 4 && itemid == 3) // House Withdraw - Crack
				{
					new houseid = GetPVarInt(playerid, "Special_HouseID");
					DeletePVar(playerid, "Special_HouseID");

					HouseInfo[houseid][hCrack] -= amount;
				}
				if(special == 4 && itemid == 4) // House Withdraw - Mats
				{
					new houseid = GetPVarInt(playerid, "Special_HouseID");
					DeletePVar(playerid, "Special_HouseID");

					HouseInfo[houseid][hMaterials] -= amount;
				}
				if(special == 5 && itemid == 1) // Family Safe Withdraw - Cash
				{
					new family = GetPVarInt(playerid, "Special_FamilyID");
					DeletePVar(playerid, "Special_FamilyID");

					FamilyInfo[family][FamilyCash] -= amount;
				}
				if(special == 5 && itemid == 2) // Family Safe Withdraw - Pot
				{
					new family = GetPVarInt(playerid, "Special_FamilyID");
					DeletePVar(playerid, "Special_FamilyID");

					FamilyInfo[family][FamilyPot] -= amount;
				}
				if(special == 5 && itemid == 3) // Family Safe Withdraw - Crack
				{
					new family = GetPVarInt(playerid, "Special_FamilyID");
					DeletePVar(playerid, "Special_FamilyID");

					FamilyInfo[family][FamilyCrack] -= amount;
				}
				if(special == 5 && itemid == 4) // Family Safe Withdraw - Materials
				{
					new family = GetPVarInt(playerid, "Special_FamilyID");
					DeletePVar(playerid, "Special_FamilyID");

					FamilyInfo[family][FamilyMats] -= amount;
				}
			}
		}
		return 1;
	}*/
	if(dialogid == MAINMENU || dialogid == MAINMENU2)
	{
		if(response == 0)
		{
			SendClientMessage(playerid, COLOR_RED, "SERVER: You have been kicked out automatically.");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
		}
		else if(dialogid == MAINMENU)
		{
			if(!isnull(inputtext) && strlen(inputtext) < 64)
			{
				SetPVarString(playerid, "PassAuth", inputtext);
				g_mysql_AccountLoginCheck(playerid);
			}
			else
			{
				ShowMainMenuDialog(playerid, 1);
			}
		}
		else if(dialogid == MAINMENU2)
		{
			if(!isnull(inputtext) && strlen(inputtext) < 64)
			{
				SetPVarString(playerid, "PassAuth", inputtext);
				g_mysql_CreateAccount(playerid, inputtext);
			}
		}
		return 1;
	}
	if(dialogid == MAINMENU3)
	{
		Kick(playerid);
	}
	if (dialogid == ELEVATOR3 && response)
    {
		if (listitem == 0)
		{
			SetPlayerPos(playerid, 1564.8, -1666.2, 28.3);
			SetPlayerInterior(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SetPlayerVirtualWorld(playerid, 0);
		}
		else
		{
			SetPlayerPos(playerid, 1568.6676, -1689.9708, 6.2188);
		 	SetPlayerInterior(playerid, 0);
		 	PlayerInfo[playerid][pVW] = 0;
			SetPlayerVirtualWorld(playerid, 0);
		}
	}
	if (dialogid == ELEVATOR && response)
    {
		if (listitem == 0)
		{
			SetPlayerPos(playerid, 276.0980, 122.1232, 1004.6172);
			SetPlayerInterior(playerid, 10);
			PlayerInfo[playerid][pVW] = 133337;
			SetPlayerVirtualWorld(playerid, 133337);
		}
		else
		{
			SetPlayerPos(playerid, 1568.6676, -1689.9708, 6.2188);
			SetPlayerInterior(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SetPlayerVirtualWorld(playerid, 0);
		}
	}
	if (dialogid == ELEVATOR2 && response)
    {
		if (listitem == 0)
		{
			SetPlayerPos(playerid, 1564.8, -1666.2, 28.3);
			SetPlayerInterior(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SetPlayerVirtualWorld(playerid, 0);
		}
		else
		{
			SetPlayerPos(playerid, 276.0980, 122.1232, 1004.6172);
			SetPlayerInterior(playerid, 10);
			PlayerInfo[playerid][pVW] = 133337;
			SetPlayerVirtualWorld(playerid, 133337);
		}
	}
	if(dialogid == VIPNUMMENU)
    {
		if(response)
		{
			new numberstr = -abs(strval(inputtext));
			if(10 <= strlen(inputtext) >= 2 || strval(inputtext) == 0) { return ShowPlayerDialog(playerid, VIPNUMMENU, DIALOG_STYLE_INPUT, "Error", "The phone number can only be between 2 and 10 digits long. Please input a new number below", "Submit", "Cancel"); }
			new query[128];
			new numb[16];
			format(numb, sizeof(numb), "%d", numberstr);
			new checkmon = GetPlayerCash(playerid);
			if(PlayerInfo[playerid][pPnumber] == numberstr)
			{
				SendClientMessageEx(playerid,COLOR_GREY," Cannot change to your existing number");
				return 1;
			}
			if(strlen(numb) == 2) return ShowPlayerDialog(playerid, VIPNUMMENU, DIALOG_STYLE_INPUT, "Error", "The phone number can only be between 2 and 10 digits long. Please input a new number below", "Submit", "Cancel");
			if(strlen(numb) == 3)
			{
				checkmon = checkmon * 30/100;
				if(GetPlayerCash(playerid) >= 1000000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", checkmon);
					format(query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'", numberstr);
					mysql_function_query(MainPipeline, query, true, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else if(GetPlayerCash(playerid) >= 300000 && GetPlayerCash(playerid) < 1000000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", 300000);
					format(query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",numberstr);
					mysql_function_query(MainPipeline, query, true, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else
				{
					SendClientMessageEx(playerid,COLOR_GREY," You do not have enough money to purchase a negative 2 digit number, try again.");
					return 1;
				}
			}
			else if(strlen(numb) == 4)
			{
				checkmon = checkmon * 20/100;
				if(GetPlayerCash(playerid) >= 1000000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", checkmon);
					format(query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",numberstr);
					mysql_function_query(MainPipeline, query, true, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else if(GetPlayerCash(playerid) >= 200000 && GetPlayerCash(playerid) < 1000000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", 200000);
					format(query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",numberstr);
					mysql_function_query(MainPipeline, query, true, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else
				{
					SendClientMessageEx(playerid,COLOR_GREY," You do not have enough money to purchase a negative 3 digit number, try again.");
					return 1;
				}
			}
			else if(strlen(numb) >= 5 && strlen(numb) <= 11)
			{
				checkmon = checkmon * 10/100;
				if(GetPlayerCash(playerid) >= 500000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", checkmon);
					format(query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",numberstr);
					mysql_function_query(MainPipeline, query, true, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else if(GetPlayerCash(playerid) >= 50000 && GetPlayerCash(playerid) < 500000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", 50000);
					format(query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",numberstr);
					mysql_function_query(MainPipeline, query, true, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else
				{
					SendClientMessageEx(playerid,COLOR_GREY," You do not have enough money to purchase a negative 2 digit number, try again.");
					return 1;
				}
			}
			else return SendClientMessageEx(playerid,COLOR_GREY," Unable to change your number!");
		}
		else
		{
		    SendClientMessageEx(playerid,COLOR_GREY," You chose not to change numbers.");
		}

	}
	if(dialogid == VIPNUMMENU2)
    {
		if(response)
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
			SendClientMessageEx(playerid, COLOR_YELLOW, "Phone number is not being used, updating your phone number.");
			format(string,sizeof(string),"You have changed numbers from %d, to %d, and it cost $%s", GetPVarInt(playerid, "CurrentPh"), GetPVarInt(playerid, "WantedPh"), number_format(GetPVarInt(playerid, "PhChangeCost")));
			SendClientMessageEx(playerid,COLOR_GREY,string);
			PlayerInfo[playerid][pPnumber] = GetPVarInt(playerid, "WantedPh");
			GivePlayerCash(playerid, -GetPVarInt(playerid, "PhChangeCost"));
			format(string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[playerid][pPnumber], GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			DeletePVar(playerid, "PhChangerId");
			DeletePVar(playerid, "WantedPh");
			DeletePVar(playerid, "PhChangeCost");
			DeletePVar(playerid, "CurrentPh");
		}
		else
		{
			SendClientMessageEx(playerid,COLOR_GREY," You chose not to change numbers.");
			DeletePVar(playerid, "PhChangerId");
			DeletePVar(playerid, "WantedPh");
			DeletePVar(playerid, "PhChangeCost");
			DeletePVar(playerid, "CurrentPh");
		}
	}
	/*if(dialogid == RENTMENU)
    {
		if(response)
		    {
		     	switch(listitem)
		        	{
			        case 0://15 Minutes
						{
							if(GetPlayerCash(playerid) < 1000)
								{
								    SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have enough money!");
								    RemovePlayerFromVehicle(playerid);
								    new Float:slx, Float:sly, Float:slz;
									GetPlayerPos(playerid, slx, sly, slz);
									SetPlayerPos(playerid, slx, sly, slz+1.2);
								    TogglePlayerControllable(playerid,1);
								}
							else
								{
								    GivePlayerCash(playerid,-1000);
								    gBike[playerid] = 3;
								    gBikeRenting[playerid] = 1;
								    TogglePlayerControllable(playerid, 1);
								    SendClientMessageEx(playerid,COLOR_GREY," You have rented a bike for 15 minutes, enjoy!");
								    SetPVarInt(playerid, "RentTime", SetTimerEx("RentTimer", (1000*60)*15, true, "d", playerid));
							    }
						}
					case 1: // 30 minutes
						{
						   if(GetPlayerCash(playerid) < 2000)
								{
								    SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have enough money!");
								    RemovePlayerFromVehicle(playerid);
								    new Float:slx, Float:sly, Float:slz;
									GetPlayerPos(playerid, slx, sly, slz);
									SetPlayerPos(playerid, slx, sly, slz+1.2);
								    TogglePlayerControllable(playerid,1);
								}
							else
							{
							    GivePlayerCash(playerid,-2000);
							    gBike[playerid] = 6;
							    gBikeRenting[playerid] = 1;
							    TogglePlayerControllable(playerid, 1);
							    SendClientMessageEx(playerid,COLOR_GREY," You have rented a bike for 30 minutes, enjoy!");
							    SetPVarInt(playerid, "RentTime", SetTimerEx("RentTimer", (1000*60)*30, true, "d", playerid));
						    }
						}
					case 2: // 1 hour
						{
						    if(GetPlayerCash(playerid) < 4000)
								{
								    SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have enough money!");
								    RemovePlayerFromVehicle(playerid);
								    new Float:slx, Float:sly, Float:slz;
									GetPlayerPos(playerid, slx, sly, slz);
									SetPlayerPos(playerid, slx, sly, slz+1.2);
								    TogglePlayerControllable(playerid,1);
								}
							else
							{
							    GivePlayerCash(playerid,-4000);
							    gBike[playerid] = 12;
							    gBikeRenting[playerid] = 1;
							    TogglePlayerControllable(playerid, 1);
							    SendClientMessageEx(playerid,COLOR_GREY," You have rented a bike for an hour, enjoy!");
							    SetPVarInt(playerid, "RentTime", SetTimerEx("RentTimer", (1000*60)*60, true, "d", playerid));
						    }
						}
					}
			}
		if(!response)
		{
		    RemovePlayerFromVehicle(playerid);
		    new Float:slx, Float:sly, Float:slz;
			GetPlayerPos(playerid, slx, sly, slz);
			SetPlayerPos(playerid, slx, sly, slz+1.2);
		    TogglePlayerControllable(playerid,1);
		    SendClientMessageEx(playerid,COLOR_GREY," You may only use these bikes if you rent one.");
		}

	}*/

	if(dialogid == 1348)
	{
	    if(response)
	    {
			new
				Float: carPosF[3],
				miscid = GetPVarInt(playerid, "playeraffectedcarTP"),
				v = ListItemTrackId[playerid][listitem];
	        GetVehiclePos(PlayerVehicleInfo[miscid][v][pvId], carPosF[0], carPosF[1], carPosF[2]);
	        SetPlayerVirtualWorld(playerid,GetVehicleVirtualWorld(PlayerVehicleInfo[miscid][v][pvId]));
	        SetPlayerPos(playerid, carPosF[0], carPosF[1], carPosF[2]);
		}
	}
	if(dialogid == GOTOPLAYERCAR)
	{
	    if(response == 1)
	    {
	        for(new i = 0; i < MAX_PLAYERVEHICLES; i++)
	        {
	            if(listitem == i)
	            {
					new Float: carPos[3], id = GetPVarInt(playerid, "playeraffectedcarTP");
					if(PlayerVehicleInfo[id][i][pvId] > INVALID_PLAYER_VEHICLE_ID)
					{
						GetVehiclePos(PlayerVehicleInfo[id][i][pvId], carPos[0], carPos[1], carPos[2]);
						SetPlayerVirtualWorld(playerid,GetVehicleVirtualWorld(PlayerVehicleInfo[id][i][pvId]));
						SetPlayerInterior(playerid,0);
						SetPlayerPos(playerid, carPos[0], carPos[1], carPos[2]);
					}
					else
					{
					    SendClientMessageEx(playerid, COLOR_WHITE, "You can not teleport to an empty, disabled or impounded slot.");
					}
				}
			}
	    }
	}
	if(dialogid == VEHICLESTORAGE && response) {
	
		//if(!(400 <= PlayerVehicleInfo[playerid][listitem][pvModelId] <= 611))
		//printf("DEBUG: listitem: %d, Vehicle Slots: %d", listitem, GetPlayerVehicleSlots(playerid));
		if(listitem == GetPlayerVehicleSlots(playerid)) {
			new szstring[128];
			SetPVarInt(playerid, "MiscShop", 7);
			format(szstring, sizeof(szstring), "Additional Vehicle Slot\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[23][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[23][sItemPrice]));
			return ShowPlayerDialog(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Purchase a additional vehicle slot", szstring, "Purchase", "Cancel");
		}
		
		if(PlayerVehicleInfo[playerid][listitem][pvSpawned]) {

			new
				iVehicleID = PlayerVehicleInfo[playerid][listitem][pvId];

			if((!IsVehicleOccupied(iVehicleID) || IsPlayerInVehicle(playerid, iVehicleID)) && !IsVehicleInTow(iVehicleID)) {

				new
					Float: vehiclehealth;

				GetVehicleHealth(iVehicleID, vehiclehealth);

				if(vehiclehealth < 800) {
					SendClientMessageEx(playerid, COLOR_WHITE, "This vehicle is too damaged to be stored.");
				}
   				else if (GetPVarInt(playerid, "Refueling") == PlayerVehicleInfo[playerid][listitem][pvId])
					SendClientMessageEx(playerid, COLOR_WHITE, "You can not store a vehicle while it is being refueled.");
				else {
					--PlayerCars;
					VehicleSpawned[playerid]--;
					PlayerVehicleInfo[playerid][listitem][pvSpawned] = 0;
					PlayerVehicleInfo[playerid][listitem][pvFuel] = VehicleFuel[iVehicleID];
					DestroyVehicle(iVehicleID);
					PlayerVehicleInfo[playerid][listitem][pvId] = INVALID_PLAYER_VEHICLE_ID;
					g_mysql_SaveVehicle(playerid, listitem);

					new vstring[128];
					format(vstring, sizeof(vstring), "You have stored your %s. The vehicle has been despawned.", VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400]);
					SendClientMessageEx(playerid, COLOR_WHITE, vstring);
					CheckPlayerVehiclesForDesync(playerid);
				}
			}
			else SendClientMessageEx(playerid, COLOR_WHITE, "This vehicle is currently occupied - it cannot be despawned right now.");
		}
		else if(PlayerVehicleInfo[playerid][listitem][pvImpounded]) {
			SendClientMessageEx(playerid, COLOR_WHITE, "You can not spawn an impounded vehicle. If you wish to reclaim it, do so at the DMV in Dillimore.");
		}
		else if(PlayerVehicleInfo[playerid][listitem][pvDisabled]) {
			SendClientMessageEx(playerid, COLOR_WHITE, "You can not spawn a disabled vehicle. It is disabled due to your VIP level (vehicle restrictions).");
		}
		else if((PlayerInfo[playerid][pRVehRestricted] > gettime() || PlayerVehicleInfo[playerid][listitem][pvRestricted] > gettime()) && IsRestrictedVehicle(PlayerVehicleInfo[playerid][listitem][pvModelId]))
        {
            SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to spawn this restricted vehicle.");
        }
		else if(!PlayerVehicleInfo[playerid][listitem][pvSpawned]) {
			if(PlayerInfo[playerid][pDonateRank] == 0 && VehicleSpawned[playerid] >= 2) {
				SendClientMessageEx(playerid, COLOR_GREY, "As non-VIP you can only have 2 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(PlayerInfo[playerid][pDonateRank] == 1 && VehicleSpawned[playerid] >= 2) {
				SendClientMessageEx(playerid, COLOR_GREY, "As Bronze VIP you can only have 2 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(PlayerInfo[playerid][pDonateRank] == 2 && VehicleSpawned[playerid] >= 2) {
				SendClientMessageEx(playerid, COLOR_GREY, "As Silver VIP you can only have 2 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(PlayerInfo[playerid][pDonateRank] == 3 && VehicleSpawned[playerid] >= 3) {
				SendClientMessageEx(playerid, COLOR_GREY, "As Gold VIP you can only have 3 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(PlayerInfo[playerid][pDonateRank] == 4 && VehicleSpawned[playerid] >= 5) {
				SendClientMessageEx(playerid, COLOR_GREY, "As Platinum VIP you can only have 5 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(PlayerInfo[playerid][pDonateRank] == 5 && VehicleSpawned[playerid] >= 5) {
				SendClientMessageEx(playerid, COLOR_GREY, "As VIP Moderator you can only have 5 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(!(0 <= PlayerInfo[playerid][pDonateRank] <= 5)) {
				SendClientMessageEx(playerid, COLOR_GREY, "You have an invalid VIP level.");
			}
			else if((PlayerVehicleInfo[playerid][listitem][pvModelId]) < 400) {
				SendClientMessageEx(playerid, COLOR_GREY, "The vehicle slot is empty.");
			}
			else {

				new
					iVeh = CreateVehicle(PlayerVehicleInfo[playerid][listitem][pvModelId], PlayerVehicleInfo[playerid][listitem][pvPosX], PlayerVehicleInfo[playerid][listitem][pvPosY], PlayerVehicleInfo[playerid][listitem][pvPosZ], PlayerVehicleInfo[playerid][listitem][pvPosAngle],PlayerVehicleInfo[playerid][listitem][pvColor1], PlayerVehicleInfo[playerid][listitem][pvColor2], -1);

                SetVehicleVirtualWorld(iVeh, PlayerVehicleInfo[playerid][listitem][pvVW]);
                LinkVehicleToInterior(iVeh, PlayerVehicleInfo[playerid][listitem][pvInt]);

				++PlayerCars;
				VehicleSpawned[playerid]++;
				PlayerVehicleInfo[playerid][listitem][pvSpawned] = 1;
				PlayerVehicleInfo[playerid][listitem][pvId] = iVeh;
				if(PlayerVehicleInfo[playerid][listitem][pvLocked] == 1) LockPlayerVehicle(playerid, iVeh, PlayerVehicleInfo[playerid][listitem][pvLock]);
				LoadPlayerVehicleMods(playerid, listitem);
				g_mysql_SaveVehicle(playerid, listitem);

				new vstring[64];
				format(vstring, sizeof(vstring), "You have taken your %s out of storage.", VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400]);
				SendClientMessageEx(playerid, COLOR_WHITE, vstring);
				CheckPlayerVehiclesForDesync(playerid);
				Vehicle_ResetData(iVeh);
				VehicleFuel[iVeh] = PlayerVehicleInfo[playerid][listitem][pvFuel];
				if (VehicleFuel[iVeh] > 100.0) VehicleFuel[iVeh] = 100.0;
				
				if(PlayerVehicleInfo[playerid][listitem][pvCrashFlag] == 1 && PlayerVehicleInfo[playerid][listitem][pvCrashX] != 0.0)
				{
					SetVehiclePos(iVeh, PlayerVehicleInfo[playerid][listitem][pvCrashX], PlayerVehicleInfo[playerid][listitem][pvCrashY], PlayerVehicleInfo[playerid][listitem][pvCrashZ]);
					SetVehicleZAngle(iVeh, PlayerVehicleInfo[playerid][listitem][pvCrashAngle]);
					SetVehicleVirtualWorld(iVeh, PlayerVehicleInfo[playerid][listitem][pvCrashVW]);
					PlayerVehicleInfo[playerid][listitem][pvCrashFlag] = 0;
					PlayerVehicleInfo[playerid][listitem][pvCrashVW] = 0;
					PlayerVehicleInfo[playerid][listitem][pvCrashX] = 0.0;
					PlayerVehicleInfo[playerid][listitem][pvCrashY] = 0.0;
					PlayerVehicleInfo[playerid][listitem][pvCrashZ] = 0.0;
					PlayerVehicleInfo[playerid][listitem][pvCrashAngle] = 0.0;
					SendClientMessageEx(playerid, COLOR_WHITE, "Your vehicle has been restored to it's last known location from your previous timeout.");
				}
			}
		}
		else SendClientMessageEx(playerid, COLOR_WHITE, "You can not spawn a non-existent vehicle.");
	}
	if(dialogid == ADMIN_VEHCHECK && response) {
	    if(PlayerInfo[playerid][pAdmin] < 4) { return SendClientMessage(playerid, COLOR_GRAD2, "You are not authorized");  }
		new giveplayerid = GetPVarInt(playerid, "vehcheck_giveplayerid");
		if(!IsPlayerConnected(giveplayerid)) { return SendClientMessage(playerid, COLOR_GRAD2, "The person has disconnected"); }
		new	iVehicleID = PlayerVehicleInfo[giveplayerid][listitem][pvId];
		new model;
		model = PlayerVehicleInfo[giveplayerid][listitem][pvModelId];
		PlayerVehicleInfo[giveplayerid][listitem][pvId] = 0;
        PlayerVehicleInfo[giveplayerid][listitem][pvModelId] = 0;
        PlayerVehicleInfo[giveplayerid][listitem][pvPosX] = 0.0;
        PlayerVehicleInfo[giveplayerid][listitem][pvPosY] = 0.0;
        PlayerVehicleInfo[giveplayerid][listitem][pvPosZ] = 0.0;
        PlayerVehicleInfo[giveplayerid][listitem][pvPosAngle] = 0.0;
        PlayerVehicleInfo[giveplayerid][listitem][pvLock] = 0;
        PlayerVehicleInfo[giveplayerid][listitem][pvLocked] = 0;
        PlayerVehicleInfo[giveplayerid][listitem][pvPaintJob] = -1;
        PlayerVehicleInfo[giveplayerid][listitem][pvColor1] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvImpounded] = 0;
        PlayerVehicleInfo[giveplayerid][listitem][pvColor2] = 0;
        PlayerVehicleInfo[giveplayerid][listitem][pvAllowedPlayerId] = INVALID_PLAYER_ID;
        PlayerVehicleInfo[giveplayerid][listitem][pvPark] = 0;
        PlayerVehicleInfo[giveplayerid][listitem][pvVW] = 0;
        PlayerVehicleInfo[giveplayerid][listitem][pvInt] = 0;
        if(PlayerVehicleInfo[giveplayerid][listitem][pvSpawned])
		{
	        PlayerVehicleInfo[giveplayerid][iVehicleID][pvSpawned] = 0;
	        DestroyVehicle(iVehicleID);
			PlayerVehicleInfo[playerid][listitem][pvId] = INVALID_PLAYER_VEHICLE_ID;
	        VehicleSpawned[giveplayerid]--;
			
	    }
		DestroyPlayerVehicle(giveplayerid, listitem);
        for(new m = 0; m < MAX_MODS; m++)
		{
            PlayerVehicleInfo[giveplayerid][listitem][pvMods][m] = 0;
		}
		format(string, sizeof(string), "AdmCmd: Admin %s has deleted one of %s's vehicles (VehModel:%d)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), model);
  		Log("logs/admin.log", string);
  		ABroadCast(COLOR_YELLOW, string, 4);

  		format(string, sizeof(string), "* Admin %s has deleted one of your vehicles.", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);

  		format(string, sizeof(string), "* You have deleted one of %s's vehicles.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);

	}
	if(dialogid == TRACKCAR2)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                new Float: carPos[3];
	                GetVehiclePos(GetPVarInt(playerid, "RentedVehicle"), carPos[0], carPos[1], carPos[2]);
					if(CheckPointCheck(playerid))
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
					}
					else
					{
						SetPVarInt(playerid, "TrackCar", 1);
						new zone[MAX_ZONE_NAME];
						Get3DZone(carPos[0], carPos[1], carPos[2], zone, sizeof(zone));
						format(string, sizeof(string), "Your vehicle is located in %s.", zone);
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
						SetPlayerCheckpoint(playerid, carPos[0], carPos[1], carPos[2], 15.0);
						SendClientMessageEx(playerid, COLOR_WHITE, "Hint: Make your way to the checkpoint to find your vehicle!");
					}
	            }
	            case 1:
	            {
	                new vstring[1024];
					for(new i, iModelID; i < MAX_PLAYERVEHICLES; i++) {
						if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0) {
							if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
								format(vstring, sizeof(vstring), "%s\n%s (impounded)", vstring, VehicleName[iModelID]);
							}
							else if(PlayerVehicleInfo[playerid][i][pvDisabled]) {
								format(vstring, sizeof(vstring), "%s\n%s (disabled)", vstring, VehicleName[iModelID]);
							}
							else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) {
								format(vstring, sizeof(vstring), "%s\n%s (stored)", vstring, VehicleName[iModelID]);
							}
							else format(vstring, sizeof(vstring), "%s\n%s", vstring, VehicleName[iModelID]);
						}
						else strcat(vstring, "\nEmpty");
					}
					ShowPlayerDialog(playerid, TRACKCAR, DIALOG_STYLE_LIST, "Vehicle GPS Tracking", vstring, "Track", "Cancel");
	            }
	        }
	    }
	}
	if(dialogid == TRACKCAR && response) {
		new Float: carPos[3];
		if(PlayerVehicleInfo[playerid][listitem][pvId] > INVALID_PLAYER_VEHICLE_ID)
		{
			GetVehiclePos(PlayerVehicleInfo[playerid][listitem][pvId], carPos[0], carPos[1], carPos[2]);
			if(CheckPointCheck(playerid))
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
			}
			else
			{
				SetPVarInt(playerid, "TrackCar", 1);
				new zone[MAX_ZONE_NAME];
				Get3DZone(carPos[0], carPos[1], carPos[2], zone, sizeof(zone));
				format(string, sizeof(string), "Your vehicle is located in %s.", zone);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				SetPlayerCheckpoint(playerid, carPos[0], carPos[1], carPos[2], 15.0);
				SendClientMessageEx(playerid, COLOR_WHITE, "Hint: Make your way to the checkpoint to find your vehicle!");
			}
		}
		else if(PlayerVehicleInfo[playerid][listitem][pvImpounded]) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track an impounded vehicle. If you wish to reclaim it, do so at the DMV in Dillimore.");
		else if(PlayerVehicleInfo[playerid][listitem][pvDisabled] == 1) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a disabled vehicle. It is disabled due to your VIP level (vehicle restrictions).");
		else if(PlayerVehicleInfo[playerid][listitem][pvSpawned] == 0) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a stored vehicle. Use /vstorage to spawn it.");
		else SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a non-existent vehicle.");
	}
	if(dialogid == DV_STORAGE && response) {
		new stpos = strfind(inputtext, "(");
	    new fpos = strfind(inputtext, ")");
	    new caridstr[6], carid;
	    strmid(caridstr, inputtext, stpos+1, fpos);
	    carid = strval(caridstr);
		if(DynVehicleInfo[carid][gv_iSpawnedID] != INVALID_VEHICLE_ID)
		{
			if((!IsVehicleOccupied(DynVehicleInfo[carid][gv_iSpawnedID]) || IsPlayerInVehicle(playerid, DynVehicleInfo[carid][gv_iSpawnedID])) && !IsVehicleInTow(DynVehicleInfo[carid][gv_iSpawnedID])) 
			{
				new Float: vHealth;
				GetVehicleHealth(DynVehicleInfo[carid][gv_iSpawnedID], vHealth);
				
				if(vHealth < 800)
					return SendClientMessageEx(playerid, COLOR_GRAD1, "This vehicle is too damaged to be stored.");
					
				if(!IsPlayerInRangeOfVehicle(playerid, DynVehicleInfo[carid][gv_iSpawnedID], 9.0) && !IsWeaponizedVehicle(DynVehicleInfo[carid][gv_iModel]))
					return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not near the vehicle.");
				
				DestroyVehicle(DynVehicleInfo[carid][gv_iSpawnedID]);
				DynVeh[DynVehicleInfo[carid][gv_iSpawnedID]] = -1;
				DynVehicleInfo[carid][gv_iSpawnedID] = INVALID_VEHICLE_ID;
				for(new i = 0; i != MAX_DV_OBJECTS; i++)
				{
					if(DynVehicleInfo[carid][gv_iAttachedObjectID][i] != INVALID_OBJECT_ID) 
					{
						DestroyDynamicObject(DynVehicleInfo[carid][gv_iAttachedObjectID][i]);
						DynVehicleInfo[carid][gv_iAttachedObjectID][i] = INVALID_OBJECT_ID;
					}
				}
				new szstring[128];
				format(szstring, sizeof(szstring), "You have stored your dynamic group vehicle (%s)", VehicleName[DynVehicleInfo[carid][gv_iModel] - 400]);
				SendClientMessageEx(playerid, COLOR_WHITE, szstring);
			}
			else 
				return SendClientMessageEx(playerid, COLOR_GRAD1, "This vehicle is currently occupied.");
		}
		else {
			DynVeh_Spawn(carid);
			new szstring[128];
			format(szstring, sizeof(szstring), "You have spawned your dynamic group vehicle (%s)", VehicleName[DynVehicleInfo[carid][gv_iModel] - 400]);
			SendClientMessageEx(playerid, COLOR_WHITE, szstring);
		}
	}	
	if(dialogid == DV_TRACKCAR && response) {
	    new stpos = strfind(inputtext, "(");
	    new fpos = strfind(inputtext, ")");
	    new caridstr[6], carid;
	    strmid(caridstr, inputtext, stpos+1, fpos);
	    carid = strval(caridstr);
		new Float: carPos[3];
		GetVehiclePos(DynVehicleInfo[carid][gv_iSpawnedID], carPos[0], carPos[1], carPos[2]);
		if(DynVehicleInfo[carid][gv_iSpawnedID] != INVALID_VEHICLE_ID)
		{
			if(CheckPointCheck(playerid))
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
			}
			else
			{
				SetPVarInt(playerid, "DV_TrackCar", 1);
				new zone[MAX_ZONE_NAME];
				Get3DZone(carPos[0], carPos[1], carPos[2], zone, sizeof(zone));
				format(string, sizeof(string), "Your vehicle is located in %s.", zone);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				SetPlayerCheckpoint(playerid, carPos[0], carPos[1], carPos[2], 15.0);
				SendClientMessageEx(playerid, COLOR_WHITE, "Hint: Make your way to the checkpoint to find your vehicle!");
				if(carPos[2] > 500.0)
				{
				    SendClientMessageEx(playerid, COLOR_WHITE, "Note: This vehicle may be parked in a garage or interior!");
				}
			}
		}
		else if(DynVehicleInfo[carid][gv_iDisabled]) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a repo'd vehicle. Please see /grepocars to buy it back.");
		else SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a non-existent vehicle.");
	}
	// --------------------------------------------------------------------------------------------------
	if(dialogid == VIPWEPSMENU)
	{
	    if(!response) return 1;
	    if(PlayerInfo[playerid][pDonateRank] < 3 && PlayerInfo[playerid][pTokens] == 0)
	    {
	        SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have any tokens!");
	        return 1;
	    }
	    if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this as you are currently restricted from possessing weapons!");
	    switch( listitem )
	    {
	        case 0:
	        {

    			if(PlayerInfo[playerid][pDonateRank] < 3)
			    {
			        if(PlayerInfo[playerid][pTokens] < 3)
			        {
			            SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
			            return 1;
			        }
					PlayerInfo[playerid][pTokens] -= 3;
					format(string, sizeof(string), "VIP: You have traded 3 tokens for a Desert Eagle, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
			        SendClientMessageEx(playerid, COLOR_YELLOW, string);
				}
				GivePlayerValidWeapon(playerid, 24, 60000);
	        }
	        case 1:
	        {

 				if(PlayerInfo[playerid][pDonateRank] < 3)
			    {
			        if(PlayerInfo[playerid][pTokens] < 2)
			        {
			            SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
			            return 1;
			        }
					PlayerInfo[playerid][pTokens] -= 2;
					format(string, sizeof(string), "VIP: You have traded 2 tokens for a shotgun, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
			        SendClientMessageEx(playerid, COLOR_YELLOW, string);
				}
				GivePlayerValidWeapon(playerid, 25, 60000);
	        }
	        case 2:
	        {
 				if(PlayerInfo[playerid][pDonateRank] < 3)
			    {
			        if(PlayerInfo[playerid][pTokens] < 3)
			        {
			            SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
			            return 1;
			        }
					PlayerInfo[playerid][pTokens] -= 3;
					format(string, sizeof(string), "VIP: You have traded 3 tokens for an MP5, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
    				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				}
				GivePlayerValidWeapon(playerid, 29, 60000);
	        }
	        case 3:
	        {
 				if(PlayerInfo[playerid][pDonateRank] < 3)
			    {
   					if(PlayerInfo[playerid][pTokens] > 1)
			        {
						PlayerInfo[playerid][pTokens] -= 2;
						format(string, sizeof(string), "VIP: You have traded 2 tokens for a silenced pistol, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
			        	SendClientMessageEx(playerid, COLOR_YELLOW, string);
  					}
			        else
			        {
			            SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
			            return 1;
			        }
				}
                GivePlayerValidWeapon(playerid, 23, 60000);
	        }
	        case 4:
	        {
 				if(PlayerInfo[playerid][pDonateRank] < 3)
			    {
   					if(PlayerInfo[playerid][pTokens] > 0)
			        {
						PlayerInfo[playerid][pTokens] -= 1;
						format(string, sizeof(string), "VIP: You have traded a token for a golf club, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
			        	SendClientMessageEx(playerid, COLOR_YELLOW, string);
  					}
			        else
			        {
			            SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
			            return 1;
			        }
				}
                GivePlayerValidWeapon(playerid, 2, 60000);
	        }
	        case 5:
	        {
 				if(PlayerInfo[playerid][pDonateRank] < 3)
			    {
   					if(PlayerInfo[playerid][pTokens] > 0)
			        {
						PlayerInfo[playerid][pTokens] -= 1;
						format(string, sizeof(string), "VIP: You have traded a token for a baseball bat, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
			        	SendClientMessageEx(playerid, COLOR_YELLOW, string);
  					}
			        else
			        {
			            SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
			            return 1;
			        }
				}
                GivePlayerValidWeapon(playerid, 5, 60000);
	        }
	        case 6:
	        {
 				if(PlayerInfo[playerid][pDonateRank] < 3)
			    {
   					if(PlayerInfo[playerid][pTokens] > 0)
			        {
						PlayerInfo[playerid][pTokens] -= 1;
						format(string, sizeof(string), "VIP: You have traded a token for a dildo, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
			        	SendClientMessageEx(playerid, COLOR_YELLOW, string);
  					}
			        else
			        {
			            SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
			            return 1;
			        }
				}
                GivePlayerValidWeapon(playerid, 10, 60000);
	        }
	        case 7:
	        {
 				if(PlayerInfo[playerid][pDonateRank] < 3)
			    {
   					if(PlayerInfo[playerid][pTokens] > 0)
			        {
						PlayerInfo[playerid][pTokens] -= 1;
						format(string, sizeof(string), "VIP: You have traded a token for a sword, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
			        	SendClientMessageEx(playerid, COLOR_YELLOW, string);
  					}
			        else
			        {
			            SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
			            return 1;
			        }
				}
                GivePlayerValidWeapon(playerid, 8, 60000);
	        }
	    }
	}
	if( dialogid == 3497) //famed change skin
	{
		new skinid = strval(inputtext);
		if(response)
		{
            if(skinid < 1 || skinid > 299)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "That skin ID is invalid, the range of available skin IDs are 1-299 !");
    			ShowPlayerDialog( playerid, 3497, DIALOG_STYLE_INPUT, "Skin Selection","Please enter a valid Skin ID!", "Wear", "Cancel" );
				return 1;
			}
			if(PlayerInfo[playerid][pFamed] == 1)
			{
				if(GetPlayerCash(playerid) < 3000)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You do not have $3,000 on you.");
					ShowPlayerDialog(playerid, 3497, DIALOG_STYLE_INPUT, "Famed Skin Selection","Please enter a Skin ID!\n\n{FF0000}Note: Skin changes are $3,000 for Old School.", "Change", "Cancel" );
					return 1;
				}
				GivePlayerCash(playerid, -3000);
			}
			if(PlayerInfo[playerid][pFamed] == 2)
			{
				if(GetPlayerCash(playerid) < 1500)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You do not have $1,500 on you.");
					ShowPlayerDialog(playerid, 3497, DIALOG_STYLE_INPUT, "Famed Skin Selection","Please enter a Skin ID!\n\n{FF0000}Note: Skin changes are $1,500 for Chartered Old School.", "Change", "Cancel" );
					return 1;
				}
				GivePlayerCash(playerid, -1500);
			}
			SendClientMessageEx(playerid, COLOR_YELLOW, "Famed Locker: You have changed your clothes.");
			PlayerInfo[playerid][pModel] = skinid;
			SetPlayerSkin(playerid, skinid);
  		}
		else return 0;
		return 1;
	}
	if(dialogid == 3498) //Famed Weapon Locker
	{
	    if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You exited the famed locker.");
	    if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this as you are currently restricted from possessing weapons!");
	    
	    switch(listitem)
	    {
	        case 0: //Deagle
	        {
	            GivePlayerValidWeapon(playerid, 24, 60000);
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Desert Eagle from the famed locker.");
	        }
	        case 1: //MP5
	        {
	            GivePlayerValidWeapon(playerid, 29, 60000);
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Semi-Automatic MP5 from the famed locker.");
	        }
	        case 2: //Shotgun
	        {
	            GivePlayerValidWeapon(playerid, 25, 60000);
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Pump Shotgun from the famed locker.");
	        }
	        case 3: //Rifle
	        {
	            GivePlayerValidWeapon(playerid, 33, 60000);
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a County Rifle from the famed locker.");
	        }
	        case 4: //SD Pistol
	        {
	            GivePlayerValidWeapon(playerid, 23, 60000);
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Silenced Pistol from the famed locker.");
	        }
	        case 5: //Katana
	        {
	            GivePlayerValidWeapon(playerid, 8, 60000);
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Japanese Katana from the famed locker.");
	        }
	        case 6: //Purple Dildo
	        {
	            GivePlayerValidWeapon(playerid, 10, 60000);
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Purple Dildo from the famed locker.");
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Have Fun...");
	        }
	        case 7: //White Dildo
	        {
	            GivePlayerValidWeapon(playerid, 11, 60000);
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a White Dildo from the famed locker.");
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Have Fun...");
	        }
	        case 8: //Big Vibrator
	        {
	            GivePlayerValidWeapon(playerid, 12, 60000);
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Big Vibrator from the famed locker.");
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Have Fun...");
	        }
	        case 9: //Silver Vibrator
	        {
	            GivePlayerValidWeapon(playerid, 13, 60000);
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Silver Vibrator from the famed locker.");
	            SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Have Fun...");
	        }
		}
	}
	else if( dialogid == LOTTOMENU) //lotteryticket
	{
		new lotto = strval(inputtext);
		if(!response)
		{
		}
		else
		{
            if(lotto < 1 || lotto > 300)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   Lottery Number not below 1 or above 300!");
            	ShowPlayerDialog( playerid, LOTTOMENU, DIALOG_STYLE_INPUT, "Lottery Ticket Selection","Please enter a Lotto Number!", "Buy", "Cancel" );
			}
			else
			{
			    if(PlayerInfo[playerid][pLottoNr] >= 5) {
			        SendClientMessageEx(playerid, COLOR_GREY, "You can only buy up to 5 tickets.");
			        return 1;
			    }
				format(string, sizeof(string), "* You bought a Lottery Ticket with number: %d.", lotto);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				AddTicket(playerid, lotto);
				for(new i = 0; i < 5; i++) {
				    if(LottoNumbers[playerid][i] == 0) {
				        LottoNumbers[playerid][i] = lotto;
				        break;
					}
				}
				Jackpot += 800;
				TicketsSold += 1;
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
  		}
		return 1;
	}
	else if(dialogid == DIALOG_CHANGEPASS2)
	{
	    if(response)
	    {
	        if( strlen( inputtext ) >= 64 || strlen(inputtext) == 0)
			{
			    ShowPlayerDialog(playerid, DIALOG_CHANGEPASS2, DIALOG_STYLE_INPUT, "Password Change Required!", "Please enter a new password for your account.", "Change", "Exit" );
	    	    return SendClientMessageEx( playerid, COLOR_GREY, "You can't select a password that's above 64 characters." );
	    	}

	        new
				szBuffer[129],
				szQuery[256];

			WP_Hash(szBuffer, sizeof(szBuffer), inputtext);
			SetPVarString(playerid, "PassChange", inputtext);
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Key` = '%s' WHERE `id` = '%i'", szBuffer, PlayerInfo[playerid][pId]);
			mysql_function_query(MainPipeline, szQuery, false, "OnPlayerChangePass", "i", playerid);
			SendClientMessageEx(playerid, COLOR_YELLOW, "Processing your request...");

			if(strcmp(PlayerInfo[playerid][pBirthDate], "0000-00-00", true) == 0 && PlayerInfo[playerid][pTut] != 0) ShowLoginDialogs(playerid, 1);
			else if(pMOTD[0] && GetPVarInt(playerid, "ViewedPMOTD") != 1) ShowLoginDialogs(playerid, 4);
			else if(PlayerInfo[playerid][pReceivedCredits] != 0) ShowLoginDialogs(playerid, 5);
	    }
		else
		{
		    ShowPlayerDialog(playerid, DIALOG_CHANGEPASS2, DIALOG_STYLE_INPUT, "Password Change Required!", "Please enter a new password for your account.", "Change", "Exit" );
		}
	}
	else if( dialogid == DIALOG_CHANGEPASS )
	{
		if(!response || strlen(inputtext) == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You have prevented yourself from changing your password." );
	    if( strlen( inputtext ) >= 64 )
	    {
	        SendClientMessageEx( playerid, COLOR_WHITE, "You can't select a password that's above 64 characters." );
	    }
	    else
	    {
	        if( strlen( inputtext ) >= 1 )
	        {
	            if(!response)
	            {
	                SendClientMessageEx(playerid, COLOR_WHITE, "You have prevented yourself from changing your password." );
	            }
	            else
	            {
					new
						szBuffer[129],
						szQuery[256];

					WP_Hash(szBuffer, sizeof(szBuffer), inputtext);
					SetPVarString(playerid, "PassChange", inputtext);

					format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Key` = '%s' WHERE `id` = '%i'", szBuffer, PlayerInfo[playerid][pId]);
					mysql_function_query(MainPipeline, szQuery, false, "OnPlayerChangePass", "i", playerid);
					SendClientMessageEx(playerid, COLOR_YELLOW, "Processing your request...");
	            }
	        }
	        else
	        {
	            SendClientMessageEx( playerid, COLOR_WHITE, "Your password must be longer than 1 character." );
	        }
	    }
	}
	else if( dialogid == DIALOG_NAMECHANGE )
	{
	    if(!response || strlen(inputtext) == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You have prevented yourself from changing your name." );
	    if(strlen(inputtext) > 20)
	    {
	        SendClientMessageEx( playerid, COLOR_WHITE, "You can't select a name that's above 20 characters." );
	    }
	    else
	    {
	        if( strlen(inputtext) >= 1 )
	        {
	            if(!response)
	            {
	                SendClientMessageEx(playerid, COLOR_WHITE, "You have prevented yourself from changing your name." );
	            }
	            else
	            {
		            for(new i = 0; i < strlen( inputtext ); i++)
					{
					    if (inputtext[i] == ' ') return SendClientMessageEx(playerid, COLOR_GRAD2, "Please use the '_'(underscore) instead of the ' '(space)");
					}
					if( strfind( inputtext, "_", true) == -1 )
					{
						SendClientMessageEx( playerid, COLOR_WHITE, "Name change rejected. Please choose a name in the correct format: Firstname_Lastname." );
						return 1;
					}
					new namechangecost;
					namechangecost = (PlayerInfo[playerid][pLevel]) * 15000;
					
					if(PlayerInfo[playerid][pDonateRank] >= 3)
					{
						namechangecost = 90*namechangecost/100;
					}

                    new tmpName[MAX_PLAYER_NAME];
					mysql_escape_string(inputtext, tmpName);
					if(strcmp(inputtext, tmpName, false) != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Unacceptable characters used in namechange, try again");
					if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iFreeNameChange])
					{
					    if(GetPVarType(playerid, "HasReport")) {
							SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
							return 1;
						}
	    				new String[128];
						SetPVarInt(playerid, "RequestingNameChange", 1);
						SetPVarString(playerid, "NewNameRequest", inputtext);
						SetPVarInt(playerid, "NameChangeCost", 0);
						new playername[MAX_PLAYER_NAME];
						GetPlayerName(playerid, playername, sizeof(playername));
		            	format( String, sizeof( String ), "You have requested a namechange from %s to %s at no cost, please wait until a General Admin approves it.", playername, inputtext);
		            	SendClientMessageEx( playerid, COLOR_YELLOW, String );
	           	 		SendReportToQue(playerid, "Name Change Request", 2, 4);
		            	return 1;
					}
					if(PlayerInfo[playerid][pAdmin] == 1 && PlayerInfo[playerid][pSMod] > 0)
					{
					    if(GetPVarType(playerid, "HasReport")) {
							SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
							return 1;
						}
	    				new String[128];
						SetPVarInt(playerid, "RequestingNameChange", 1);
						SetPVarString(playerid, "NewNameRequest", inputtext);
						new playername[MAX_PLAYER_NAME];
						GetPlayerName(playerid, playername, sizeof(playername));
		            	format( String, sizeof( String ), "You have requested a namechange from %s to %s at no cost (Senior Mod), please wait until a General Admin approves it.", playername, inputtext, namechangecost);
		            	SendClientMessageEx( playerid, COLOR_YELLOW, String );
		                SendReportToQue(playerid, "Name Change Request", 2, 4);
		            	return 1;
					}

					if(GetPlayerCash(playerid) >= namechangecost)
					{
					    if(GetPVarType(playerid, "HasReport")) {
							SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
							return 1;
						}
					    new String[128];
						SetPVarInt(playerid, "RequestingNameChange", 1);
						SetPVarString(playerid, "NewNameRequest", inputtext);
						SetPVarInt(playerid, "NameChangeCost", namechangecost);
						new playername[MAX_PLAYER_NAME];
						GetPlayerName(playerid, playername, sizeof(playername));
		            	format( String, sizeof( String ), "You have requested a namechange from %s to %s for $%d, please wait until a General Admin approves it.", playername, inputtext, namechangecost);
		            	SendClientMessageEx( playerid, COLOR_YELLOW, String );
		            	SendReportToQue(playerid, "Name Change Request", 2, 4);
					}
					else
					{
					    SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have enough money for the name change.");
					}
	            }
	        }
	        else
	        {
	            SendClientMessageEx( playerid, COLOR_WHITE, "Your name must be longer than 1 character." );
	        }
	    }
	}
	else if( dialogid == DIALOG_NAMECHANGE2 )
	{
	    if(!response || strlen(inputtext) == 0) return Kick(playerid);
	    if(strlen(inputtext) >= 20)
	    {
	        SendClientMessageEx( playerid, COLOR_WHITE, "You can't select a name that's above 20 characters." );
	        ShowPlayerDialog( playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
	    }
	    else
	    {
	        if( strlen(inputtext) >= 1 )
	        {
	            if(!response)
	            {
				    ShowPlayerDialog( playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
				}
	            else
	            {
           			for(new i = 0; i < strlen( inputtext ); i++)
					{
    					if (inputtext[i] == ' ')
    					{
							SendClientMessageEx(playerid, COLOR_WHITE, "Please use the '_'(underscore) instead of the ' '(space)");
							ShowPlayerDialog( playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
							return 1;
						}
					}
					if( strfind( inputtext, "_", true) == -1 )
					{
						SendClientMessageEx( playerid, COLOR_WHITE, "Name change rejected. Please choose a name in the correct format: Firstname_Lastname." );
						ShowPlayerDialog( playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
						return 1;
					}
     				else
					{
					    if(GetPVarType(playerid, "HasReport")) {
							SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
							return 1;
						}
						new String[128];
						SetPVarInt(playerid, "RequestingNameChange", 1);
						SetPVarString(playerid, "NewNameRequest", inputtext);
						SetPVarInt(playerid, "NameChangeCost", 0);
						new playername[MAX_PLAYER_NAME];
						GetPlayerName(playerid, playername, sizeof(playername));
    					format( String, sizeof( String ), "You have requested a namechange from %s to %s please wait until a General Admin approves it.", playername, inputtext);
       					SendClientMessageEx( playerid, COLOR_YELLOW, String );
          //			format( String, sizeof( String ), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) requested a name change to %s for free (non-RP name) - /approvename %d (accept), or /denyname %d (deny).", playername, playerid, inputtext, playerid, playerid);
            //			ABroadCast( COLOR_YELLOW, String, 3 );
						SendReportToQue(playerid, "Name Change Request", 2, 4);
            			return 1;
            		}
				}
	        }
	        else
	        {
	            SendClientMessageEx( playerid, COLOR_WHITE, "Your name must be longer than 1 character." );
	            ShowPlayerDialog( playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
	        }
	    }
	}
	else if(dialogid == HQENTRANCE)
	{
	    if(response)
	    {
	        new Float: x, Float: y, Float: z, Float: a;
	        GetPlayerPos(playerid, x, y, z);
	        GetPlayerFacingAngle(playerid, a);
	        if(GetPVarInt(playerid, "editingfamhqaction") == 5)
	        {
	            DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] );
	            DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] );
	        	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][0] = x;
	        	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][1] = y;
	        	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][2] = z;
	        	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][3] = a;
            	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] = CreateDynamicPickup(1318, 23, x, y, z);
				format(string, sizeof(string), "%s", FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyName]);
            	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.6, 4.0);
            	SendClientMessageEx(playerid, COLOR_GRAD2, "HQ Entrance changed!.");
            	TogglePlayerControllable(playerid, true);
            	SaveFamiliesHQ(GetPVarInt(playerid, "editingfamhq"));
            	return 1;
			}
			FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][0] = x;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][1] = y;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][2] = z;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][3] = a;
         	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] = CreateDynamicPickup(1318, 23, x, y, z);
			format(string, sizeof(string), "%s", FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyName]);
   			FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.6, 4.0);
			SendClientMessageEx(playerid, COLOR_GRAD2, "HQ Entrance saved! Please stand where you want the exit at, once ready press the fire button.");
            SetPVarInt(playerid, "editingfamhqaction", 2);
            TogglePlayerControllable(playerid, true);
	    }
	    else
	    {
	        if(GetPVarInt(playerid, "editingfamhqaction") == 5)
	        {
	            SendClientMessageEx(playerid, COLOR_GRAD2, "You have cancelled the exterior change of this HQ.");
	            SetPVarInt(playerid, "editingfamhqaction", 0);
	        	SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
	        	TogglePlayerControllable(playerid, true);
	            return 1;
	        }
	        SendClientMessageEx(playerid, COLOR_GRAD2, "You have cancelled the creation of this HQ.");
	        DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] );
			DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitPickup] );
			DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] );
			DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitText] );
			FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][0] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][1] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][2] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][3] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][0] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][1] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][2] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][3] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = 0;
	        SetPVarInt(playerid, "editingfamhqaction", 0);
	        SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
	        TogglePlayerControllable(playerid, true);
	    }
	}
	else if(dialogid == HQEXIT)
	{
	    if(response)
	    {
	        new Float: x, Float: y, Float: z, Float: a;
	        GetPlayerPos(playerid, x, y, z);
	        GetPlayerFacingAngle(playerid, a);
	        if(GetPVarInt(playerid, "editingfamhqaction") == 6)
	        {
	            DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitPickup] );
	            FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][0] = x;
	        	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][1] = y;
	        	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][2] = z;
	        	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][3] = a;
	        	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = GetPlayerInterior(playerid);
	        	FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyVirtualWorld] = GetPVarInt(playerid, "editingfamhq")+900000;
            	SendClientMessageEx(playerid, COLOR_GRAD2, "HQ Exit changed!.");
            	TogglePlayerControllable(playerid, true);
            	SaveFamiliesHQ(GetPVarInt(playerid, "editingfamhq"));
            	return 1;
	        }
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][0] = x;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][1] = y;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][2] = z;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][3] = a;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = GetPlayerInterior(playerid);
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyVirtualWorld] = GetPVarInt(playerid, "editingfamhq")+900000;
            format(string,128,"HQ Exit saved!\n\nIs this interior a custom mapped one?");
        	ShowPlayerDialog(playerid,HQCUSTOMINT,DIALOG_STYLE_MSGBOX,"Warning:",string,"Yes","No");
            SetPVarInt(playerid, "editingfamhqaction", 3);
            TogglePlayerControllable(playerid, true);
	    }
	    else
	    {
	        if(GetPVarInt(playerid, "editingfamhqaction") == 6)
	        {
	            SendClientMessageEx(playerid, COLOR_GRAD2, "You have cancelled the interior change of this HQ.");
	            SetPVarInt(playerid, "editingfamhqaction", 0);
	        	SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
	        	TogglePlayerControllable(playerid, true);
	            return 1;
	        }
	        SendClientMessageEx(playerid, COLOR_GRAD2, "You have cancelled the creation of this HQ.");
	       	DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] );
			DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitPickup] );
			DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] );
			DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitText] );
			FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][0] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][1] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][2] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][3] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][0] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][1] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][2] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][3] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = 0;
	        SetPVarInt(playerid, "editingfamhqaction", 0);
	        SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
	        TogglePlayerControllable(playerid, true);
	    }
	}
	else if(dialogid == HQCUSTOMINT)
	{
	    if(response)
	    {
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyCustomMap] = 1;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = 255;
	        if(GetPVarInt(playerid, "editingfamhqaction") == 7)
	        {
	        	SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully changed the custom interior for this HQ.");
   			}
   			else
   			{
   				SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully created this HQ.");
   			}
   			SaveFamiliesHQ(GetPVarInt(playerid, "editingfamhq"));
	        SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
	    }
	    else
	    {
	        if(GetPVarInt(playerid, "editingfamhqaction") == 7)
	        {
	        	SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully changed the custom interior for this HQ.");
   			}
   			else
   			{
   				SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully created this HQ.");
   			}
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyCustomMap] = 0;
	        SaveFamiliesHQ(GetPVarInt(playerid, "editingfamhq"));
	        SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
	    }
	}
	else if(dialogid == HQDELETE)
	{
	    if(!response)
	    {
	    }
	    else
	    {
	        format(string,128,"You have successfully deleted '%s' HQ", FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyName]);
	        SendClientMessageEx(playerid, COLOR_GRAD2, string);
	        DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrancePickup] );
			DestroyDynamicPickup( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitPickup] );
			DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntranceText] );
			DestroyDynamic3DTextLabel( FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExitText] );
			FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][0] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][1] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][2] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyEntrance][3] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][0] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][1] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][2] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyExit][3] = 0.0;
	        FamilyInfo[GetPVarInt(playerid, "editingfamhq")][FamilyInterior] = 0;
	        SaveFamiliesHQ(GetPVarInt(playerid, "editingfamhq"));
	        SetPVarInt(playerid, "editingfamhqaction", 0);
	        SetPVarInt(playerid, "editingfamhq", INVALID_FAMILY_ID);
	        TogglePlayerControllable(playerid, true);
	    }
	}
	if(dialogid == DIALOG_CDLOCKMENU)
	{
		if(response)
		{
			if(GetPVarInt(playerid, "lockmenu") == 1)
			{
	            new pvid;
	            if (IsNumeric(inputtext))
		        {
					pvid = strval(inputtext)-1;
				    if(PlayerVehicleInfo[playerid][pvid][pvId] == INVALID_PLAYER_VEHICLE_ID)
				    {
					    SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You don't have a vehicle in this slot.");
					    SetPVarInt(playerid, "lockmenu", 0);
					    return 1;
				    }
				    if(PlayerVehicleInfo[playerid][pvid][pvLock] == 1)
				    {
					    SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You already have this item installed on this vehicle.");
					    SetPVarInt(playerid, "lockmenu", 0);
					    return 1;
				    }
				    format(string, sizeof(string), "   You have purchased an alarm lock!");
				    SendClientMessageEx(playerid, COLOR_GRAD4, string);
				    SendClientMessageEx(playerid, COLOR_YELLOW, "HINT: You can now use /pvlock to lock your car.");
				    PlayerVehicleInfo[playerid][pvid][pvLock] = 1;
				    g_mysql_SaveVehicle(playerid, pvid);
				    SetPVarInt(playerid, "lockmenu", 0);
					new iBusiness = GetPVarInt(playerid, "businessid");
					new cost = GetPVarInt(playerid, "lockcost");
					new iItem = GetPVarInt(playerid, "item")-1;
			    /*	Businesses[iBusiness][bInventory]-= StoreItemCost[iItem][ItemValue];
					Businesses[iBusiness][bTotalSales]++;
					Businesses[iBusiness][bSafeBalance] += TaxSale(cost);
					if(penalty) Businesses[iBusiness][bSafeBalance] -= floatround(cost * BIZ_PENALTY);
					GivePlayerCash(playerid, -cost);
					if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[iBusiness][bLevelProgress]++; */
					SaveBusiness(iBusiness);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					if (PlayerInfo[playerid][pDonateRank] >= 1)
					{
					    format(string,sizeof(string),"VIP: You have received 20 percent off this product. Instead of paying $%s, you paid $%s.", number_format(Businesses[iBusiness][bItemPrices][iItem]), number_format(cost));
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}
					format(string,sizeof(string),"%s (IP: %s) has bought a Alarm Lock in %s (%d) for $%d.",GetPlayerNameEx(playerid),GetPlayerIpEx(playerid), Businesses[iBusiness][bName], iBusiness, cost);
					Log("logs/business.log", string);
					format(string,sizeof(string),"* You have purchased a Alarm Lock from %s for $%d.", Businesses[iBusiness][bName], cost);
					SendClientMessage(playerid, COLOR_GRAD2, string);
					new playersold = GetPVarInt(playerid, "playersold");
					if(playersold)
					{
						DeletePVar(playerid, "Business_ItemType");
						DeletePVar(playerid, "Business_ItemPrice");
						DeletePVar(playerid, "Business_ItemOfferer");
						DeletePVar(playerid, "Business_ItemOffererSQLId");
					}
			    }
			}
			else if(GetPVarInt(playerid, "lockmenu") == 2)
			{
			    new pvid;
	            if (IsNumeric(inputtext))
		        {
		            pvid = strval(inputtext)-1;
				    if(PlayerVehicleInfo[playerid][pvid][pvId] == INVALID_PLAYER_VEHICLE_ID)
				    {
						SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You don't have a vehicle in this slot.");
						SetPVarInt(playerid, "lockmenu", 0);
						return 1;
					}
					if(PlayerVehicleInfo[playerid][pvid][pvLock] == 2)
					{
						SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You already have this item installed on this vehicle.");
						SetPVarInt(playerid, "lockmenu", 0);
						return 1;
					}
					if(IsABike(PlayerVehicleInfo[playerid][pvid][pvId]))
						return SendClientMessageEx(playerid, COLOR_GRAD4, "You cannot place this type of lock on a bike.");
					format(string, sizeof(string), "   You have purchased an electronic lock!");
					SendClientMessageEx(playerid, COLOR_GRAD4, string);
					SendClientMessageEx(playerid, COLOR_YELLOW, "HINT: You can now use /pvlock to lock your car.");
					PlayerVehicleInfo[playerid][pvid][pvLock] = 2;
					g_mysql_SaveVehicle(playerid, pvid);
					SetPVarInt(playerid, "lockmenu", 0);
					new iBusiness = GetPVarInt(playerid, "businessid");
					new cost = GetPVarInt(playerid, "lockcost");
					new iItem = GetPVarInt(playerid, "item")-1;
			    /*	Businesses[iBusiness][bInventory]-= StoreItemCost[iItem][ItemValue];
					Businesses[iBusiness][bTotalSales]++;
					Businesses[iBusiness][bSafeBalance] += TaxSale(cost);
					if(penalty) Businesses[iBusiness][bSafeBalance] -= floatround(cost * BIZ_PENALTY);
					GivePlayerCash(playerid, -cost);
					if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[iBusiness][bLevelProgress]++; */
					SaveBusiness(iBusiness);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					if (PlayerInfo[playerid][pDonateRank] >= 1)
					{
					    format(string,sizeof(string),"VIP: You have received 20 percent off this product. Instead of paying $%s, you paid $%s.", number_format(Businesses[iBusiness][bItemPrices][iItem]), number_format(cost));
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}
					format(string,sizeof(string),"%s (IP: %s) has bought a Electronic Lock in %s (%d) for $%d.",GetPlayerNameEx(playerid),GetPlayerIpEx(playerid), Businesses[iBusiness][bName], iBusiness, cost);
					Log("logs/business.log", string);
					format(string,sizeof(string),"* You have purchased a Electronic from %s for $%d.", Businesses[iBusiness][bName], cost);
					SendClientMessage(playerid, COLOR_GRAD2, string);
					new playersold = GetPVarInt(playerid, "playersold");
					if(playersold)
					{
						DeletePVar(playerid, "Business_ItemType");
						DeletePVar(playerid, "Business_ItemPrice");
						DeletePVar(playerid, "Business_ItemOfferer");
						DeletePVar(playerid, "Business_ItemOffererSQLId");
					}
				}
			}
			else if(GetPVarInt(playerid, "lockmenu") == 3)
			{
			    new pvid;
	            if (IsNumeric(inputtext))
		        {
	                pvid = strval(inputtext)-1;
				    if(PlayerVehicleInfo[playerid][pvid][pvId] == INVALID_PLAYER_VEHICLE_ID)
				    {
					    SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You don't have a vehicle in this slot.");
					    SetPVarInt(playerid, "lockmenu", 0);
		                return 1;
				    }
				    if(PlayerVehicleInfo[playerid][pvid][pvLock] == 3)
			  	    {
					    SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You already have this item installed on this vehicle.");
					    SetPVarInt(playerid, "lockmenu", 0);
					    return 1;
				    }
					if(IsABike(PlayerVehicleInfo[playerid][pvid][pvId]))
						return SendClientMessageEx(playerid, COLOR_GRAD4, "You cannot place this type of lock on a bike.");
				    format(string, sizeof(string), "   You have Purchased an industrial lock!");
				    SendClientMessageEx(playerid, COLOR_GRAD4, string);
				    SendClientMessageEx(playerid, COLOR_YELLOW, "HINT: You can now use /pvlock to lock your car.");
				    PlayerVehicleInfo[playerid][pvid][pvLock] = 3;
				    g_mysql_SaveVehicle(playerid, pvid);
				    SetPVarInt(playerid, "lockmenu", 0);
					new iBusiness = GetPVarInt(playerid, "businessid");
					new cost = GetPVarInt(playerid, "lockcost");
					new iItem = GetPVarInt(playerid, "item")-1;
			    /*	Businesses[iBusiness][bInventory]-= StoreItemCost[iItem][ItemValue];
					Businesses[iBusiness][bTotalSales]++;
					Businesses[iBusiness][bSafeBalance] += TaxSale(cost);
					if(penalty) Businesses[iBusiness][bSafeBalance] -= floatround(cost * BIZ_PENALTY);
					GivePlayerCash(playerid, -cost);
					if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[iBusiness][bLevelProgress]++; */
					SaveBusiness(iBusiness);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					if (PlayerInfo[playerid][pDonateRank] >= 1)
					{
					    format(string,sizeof(string),"VIP: You have received 20 percent off this product. Instead of paying $%s, you paid $%s.", number_format(Businesses[iBusiness][bItemPrices][iItem]), number_format(cost));
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}
					format(string,sizeof(string),"%s (IP: %s) has bought a Industrial Lock in %s (%d) for $%d.",GetPlayerNameEx(playerid),GetPlayerIpEx(playerid), Businesses[iBusiness][bName], iBusiness, cost);
					Log("logs/business.log", string);
					format(string,sizeof(string),"* You have purchased a Industrial Lock from %s for $%d.",Businesses[iBusiness][bName], cost);
					SendClientMessage(playerid, COLOR_GRAD2, string);
					new playersold = GetPVarInt(playerid, "playersold");
					if(playersold)
					{
						DeletePVar(playerid, "Business_ItemType");
						DeletePVar(playerid, "Business_ItemPrice");
						DeletePVar(playerid, "Business_ItemOfferer");
						DeletePVar(playerid, "Business_ItemOffererSQLId");
					}
			    }
			}
		}
	}
	if(dialogid == DIALOG_LOCKER_OS)
	{
	    if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the locker.");
	    
	    if(listitem == 0)
	    {
            new Float:health;
			GetPlayerHealth(playerid, health);
			new hpint = floatround( health, floatround_round );
  			if( hpint >= 100 )
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
				return 1;
 			}
 			else {
				SetPlayerHealth(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have used a first aid kit, you now have 100.0 HP.");
			}
		}
		if(listitem == 1)
		{
		    new Float:armour;
			GetPlayerArmour(playerid, armour);
			if(armour >= 100)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
				return 1;
			}
			else if(GetPlayerCash(playerid) < 10000)
			{
				SendClientMessageEx(playerid, COLOR_GREY,"You don't have $10000");
  				return 1;
			}
			else {
				GivePlayerCash(playerid, -10000);
				SetPlayerArmor(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You paid $10000 for a kevlar vest.");
			}
		}
		if(listitem == 2)
		{
			ShowPlayerDialog(playerid, 3497, DIALOG_STYLE_INPUT, "Famed Skin Selection","Please enter a Skin ID!\n\nNote: Skin changes are free for famed members.", "Change", "Cancel" );
		}
		if(listitem == 3)
		{
			ShowPlayerDialog(playerid, 7484, DIALOG_STYLE_LIST, "Job Center", "Detective\nLawyer\nWhore\nDrugs Dealer\nBodyguard\nMechanic\nArms Dealer\nBoxer\nDrugs Smuggler\nTaxi Driver\nCraftsman\nBartender\nShipment Contractor\nPizza Boy", "Proceed", "Cancel");
		}
	}
	if(dialogid == DIALOG_LOCKER_COS)
	{
	    if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the locker.");

	    if(listitem == 0)
	    {
            new Float:health;
			GetPlayerHealth(playerid, health);
			new hpint = floatround( health, floatround_round );
  			if( hpint >= 100 )
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
				return 1;
 			}
 			else {
				SetPlayerHealth(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have used a first aid kit, you now have 100.0 HP.");
			}
		}
		if(listitem == 1)
		{
		    new Float:armour;
			GetPlayerArmour(playerid, armour);
			if(armour >= 100)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
				return 1;
			}
			else if(GetPlayerCash(playerid) < 5000)
			{
				SendClientMessageEx(playerid, COLOR_GREY,"You don't have $5000");
  				return 1;
			}
			else {
				GivePlayerCash(playerid, -5000);
				SetPlayerArmor(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You paid $5000 for a kevlar vest.");
			}
		}
		if(listitem == 2)
		{
			ShowPlayerDialog(playerid, 3497, DIALOG_STYLE_INPUT, "Famed Skin Selection","Please enter a Skin ID!\n\nNote: Skin changes are free for famed members.", "Change", "Cancel" );
		}
		if(listitem == 3)
		{
			ShowPlayerDialog(playerid, 7484, DIALOG_STYLE_LIST, "Job Center", "Detective\nLawyer\nWhore\nDrugs Dealer\nBodyguard\nMechanic\nArms Dealer\nBoxer\nDrugs Smuggler\nTaxi Driver\nCraftsman\nBartender\nShipment Contractor\nPizza Boy", "Proceed", "Cancel");
		}
	}
	if(dialogid == DIALOG_LOCKER_FAMED)
	{
	    if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the locker.");

	    if(listitem == 0)
	    {
            new Float:health;
			GetPlayerHealth(playerid, health);
			new hpint = floatround(health, floatround_round);
  			if(hpint >= 100)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
				return 1;
 			}
 			else {
				SetPlayerHealth(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have used a first aid kit, you now have 100.0 HP.");
			}
		}
		if(listitem == 1)
		{
		    new Float:armour;
			GetPlayerArmour(playerid, armour);
			if(armour >= 100)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
				return 1;
			}
			else {
				SetPlayerArmor(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have received a Kevlar Vest free of charge.");
			}
		}
		if(listitem == 2)
		{
		    ShowPlayerDialog(playerid, 3498, DIALOG_STYLE_LIST, "Famed Weapon Inventory", "Desert Eagle (Free)\nSemi-Automatic MP5 (Free)\nPump Shotgun (Free)\nCounty Rifle (Free)\nSilenced Pistol (Free)\nJapanese Katana (Free)\nPurple Dildo (Free)\nWhite Dildo (Free)\nBig Vibrator (Free)\nSilver Vibrator (Free)\n", "Take", "Cancel");
		}
		if(listitem == 3)
		{
			ShowPlayerDialog(playerid, 3497, DIALOG_STYLE_INPUT, "Famed Skin Selection", "Please enter a Skin ID!\n\nNote: Skin changes are free for famed members.", "Change", "Cancel" );
		}
		if(listitem == 4)
		{
			ShowPlayerDialog(playerid, 7484, DIALOG_STYLE_LIST, "Job Center", "Detective\nLawyer\nWhore\nDrugs Dealer\nBodyguard\nMechanic\nArms Dealer\nBoxer\nDrugs Smuggler\nTaxi Driver\nCraftsman\nBartender\nShipment Contractor\nPizza Boy", "Proceed", "Cancel");
		}
		if(listitem == 5)
		{
		    if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the famed locker.");

	        if(PlayerInfo[playerid][pWantedLevel] >= 6)
	            return SendClientMessageEx(playerid, COLOR_YELLOW, "You cannot use this as Most Wanted!");
	            
			if(PlayerInfo[playerid][pJailTime] > 0)
			{
	            SendClientMessageEx(playerid, COLOR_YELLOW, "You cannot do this at this time.");
				format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has attempted to change his name tag color to famed while in jail/prison.", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_YELLOW, string, 2);
	            return 1;
			}
			
			if(GetPVarInt(playerid, "famedTag") == 0)
			{
			    SetPlayerColor(playerid, COLOR_FAMED);
			    SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Your name color will now appear as famed.");
			    SetPVarInt(playerid, "famedTag", 1);
			    return 1;
			}
			else {
			    SetPlayerToTeamColor(playerid);
			    SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Your name color will now appear as normal.");
				SetPVarInt(playerid, "famedTag", 0);
			}
		}
	}
	if(dialogid == 7483) // VIP Locker /viplocker
	{
		if(response)
		{
			if(listitem == 0)
			{
 				new Float:health;
 				GetPlayerHealth(playerid, health);
				new hpint = floatround( health, floatround_round );
		    	if( hpint >= 100 )
				{
  					SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
	 				return 1;
	   			}

			    SetPlayerHealth(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have used a first aid kit, you now have 100.0 HP.");
			}
			if(listitem == 1)
			{
				new Float:armour;
				GetPlayerArmour(playerid, armour);
				if(armour >= 100)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
					return 1;
				}
				if(PlayerInfo[playerid][pDonateRank] == 1)
				{
					if(GetPlayerCash(playerid) < 15000)
			    	{
			        	SendClientMessageEx(playerid, COLOR_GREY,"You can't afford the $15000!");
			        	return 1;
			    	}
					GivePlayerCash(playerid, -15000);
					SetPlayerArmor(playerid, 100);
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You paid $15000 for a kevlar vest.");
				}
				else if(PlayerInfo[playerid][pDonateRank] == 2)
				{
					if(GetPlayerCash(playerid) < 10000)
			    	{
			        	SendClientMessageEx(playerid, COLOR_GREY,"You can't afford the $10000!");
			        	return 1;
			    	}
					GivePlayerCash(playerid, -10000);
					SetPlayerArmor(playerid, 100);
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You paid $10000 for a kevlar vest.");
				}
				if(PlayerInfo[playerid][pDonateRank] >= 3)
				{
					SetPlayerArmor(playerid, 100);
					SetPVarInt(playerid, "Armor", 1);
				}
			}
			if(listitem == 2)
			{
				if(PlayerInfo[playerid][pDonateRank] >= 1)
				{
					switch(PlayerInfo[playerid][pDonateRank])
					{
						case 1, 2: ShowPlayerDialog(playerid, VIPWEPSMENU, DIALOG_STYLE_LIST, "VIP Weapons", "Desert Eagle (3)\nShotgun (2)\nMP5 (3)\nSilenced Pistol (2)\nGolf Club (1)\nBat (1)\nDildo (1)\nSword (1)", "Select", "Cancel");
						default: ShowPlayerDialog(playerid, VIPWEPSMENU, DIALOG_STYLE_LIST, "VIP Weapons", "Desert Eagle\nShotgun\nMP5\nSilenced Pistol\nGolf Club\nBat\nDildo\nSword", "Select", "Cancel");
					}
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You must be a VIP member to access the gun lockers.");
				}
			}
			if(listitem == 3)
			{
            	if(PlayerInfo[playerid][pDonateRank] >= 2)
            	{
			    	ShowModelSelectionMenu(playerid, SkinList, "Change your clothes.");
			    }
			    else
			    {
			    	SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You must be at least Silver VIP to access the clothes corner. In the clothes corner you can get ANY skin.");
			    }
			}
			if(listitem == 4)
			{
  				if(PlayerInfo[playerid][pDonateRank] >= 2)
            	{
			    	ShowPlayerDialog(playerid, 7484, DIALOG_STYLE_LIST, "VIP: Job Center", "Detective\nLawyer\nWhore\nDrugs Dealer\nBodyguard\nMechanic\nArms Dealer\nBoxer\nDrugs Smuggler\nTaxi Driver\nCraftsman\nBartender\nShipment Contractor\nPizza Boy", "Proceed", "Cancel");
		    	}
			    else
			    {
			    	SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You must be at least Silver VIP to access the job center.");
			    }
			}
			if(listitem == 5)
			{
			    ShowPlayerDialog(playerid, 7486, DIALOG_STYLE_LIST, "VIP: VIP Color", "On\nOff", "Proceed", "Cancel");
			}
		}
	}
	if(dialogid == 7484) //This is now the default dialog for job centers in any lockers AKA VIP & Famed
	{
	    if(!response) return 1;
	    switch(listitem)
	    {
	        case 0: // Detective
	        {
	            SetPVarInt(playerid, "jobSelection", 1);
	        }
	        case 1: // Lawyer
	        {
	            SetPVarInt(playerid, "jobSelection", 2);
	        }
	        case 2: // Whore
	        {
	            SetPVarInt(playerid, "jobSelection", 3);
	        }
	        case 3: // Drugs Dealer
	        {
	            SetPVarInt(playerid, "jobSelection", 4);
	        }
	        case 4: // Bodyguard
	        {
	            SetPVarInt(playerid, "jobSelection", 8);
	        }
	        case 5: // Mechanic
	        {
	            SetPVarInt(playerid, "jobSelection", 7);
	        }
	        case 6: // Arms Dealer
	        {
	            SetPVarInt(playerid, "jobSelection", 9);
	        }
	        case 7: // Boxer
	        {
	            SetPVarInt(playerid, "jobSelection", 12);
	        }
	        case 8: // Drugs Smuggler
	        {
	            SetPVarInt(playerid, "jobSelection", 14);
	        }
	        case 9: // Taxi Driver
	        {
	            SetPVarInt(playerid, "jobSelection", 17);
	        }
	        case 10: // Craftsman
	        {
	            SetPVarInt(playerid, "jobSelection", 18);
	        }
	        case 11: // Bartender
	        {
	            SetPVarInt(playerid, "jobSelection", 19);
	        }
	        case 12: // Trucker
	        {
	            SetPVarInt(playerid, "jobSelection", 20);
	        }
	        case 13: // Pizza Boy
	        {
	            SetPVarInt(playerid, "jobSelection", 21);
	        }
	    }
		if(PlayerInfo[playerid][pFamed] > 0 && PlayerInfo[playerid][pDonateRank] < 3)
		{
			ShowPlayerDialog(playerid, 7485, DIALOG_STYLE_LIST, "Locker: Job Center", "Job Slot 1\nJob Slot 2", "Proceed", "Cancel");
		}
		else if(PlayerInfo[playerid][pDonateRank] == 2)
		{
			ShowPlayerDialog(playerid, 7485, DIALOG_STYLE_LIST, "Locker: Job Center", "Job Slot 1\nJob Slot 2", "Proceed", "Cancel");
		}
		else if(PlayerInfo[playerid][pDonateRank] >= 3)
		{
			ShowPlayerDialog(playerid, 7485, DIALOG_STYLE_LIST, "Locker: Job Center", "Job Slot 1\nJob Slot 2\nJob Slot 3", "Proceed", "Cancel");
		}
	}
	if(dialogid == 7485)
	{
	    if(!response) return 1;

	    switch(listitem)
	    {
	        case 0:
	        {
	        	PlayerInfo[playerid][pJob] = GetPVarInt(playerid, "jobSelection");
	        	SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed your first job!");
			}
	        case 1:
			{
		 		PlayerInfo[playerid][pJob2] = GetPVarInt(playerid, "jobSelection");
		 		SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed your second job!");
			}
			case 2:
			{
				PlayerInfo[playerid][pJob3] = GetPVarInt(playerid, "jobSelection");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed your third job!");
			}
	    }
	}
	if(dialogid == 7486)
	{
	    if(!response) return 1;

        if(PlayerInfo[playerid][pWantedLevel] >= 6)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW, "You cannot use this as Most Wanted!");
            return 1;
		}
		if(PlayerInfo[playerid][pJailTime] > 0)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW, "You cannot do this at this time.");
			format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has attempted to change to VIP color while jailed.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW, string, 2);
            return 1;
		}
	    switch(listitem)
	    {
	        case 0:
	        {
				SetPlayerColor(playerid, COLOR_VIP);
	        	SendClientMessageEx(playerid, COLOR_YELLOW, "You have turned on your VIP Name Color!");
			}
	        case 1:
			{
		 		SetPlayerToTeamColor(playerid);
		 		SendClientMessageEx(playerid, COLOR_YELLOW, "You have turned off your VIP Name Color!");
			}
	    }
	}
	if(dialogid == RESTAURANTMENU)
	{
	    new pvar[25];
	    if (response)
	    {
			new iBusiness = InBusiness(playerid);

			format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", listitem);
			new iPrice = GetPVarInt(playerid, pvar);
			format(pvar, sizeof(pvar), "Business_MenuItem%d", listitem);
			new iItem = GetPVarInt(playerid, pvar);
			new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(iPrice * 0.8)) : (iPrice);

			if (!iPrice) {
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Item is not for sale anymore.");
			}
		 	else if (Businesses[iBusiness][bInventory] < 1) {
	   	 		SendClientMessageEx(playerid, COLOR_GRAD2, "Store does not have any items anymore!");
			}
			else if (iPrice != Businesses[iBusiness][bItemPrices][iItem]) {
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Purchase failed because the price for this item has changed.");
			}
			else if (GetPlayerCash(playerid) < cost) {
				SendClientMessageEx(playerid, COLOR_GRAD4, "You can't afford this item!");
			}
			else {
		        format(pvar, sizeof(pvar), "Business_MenuItem%d", listitem);
    			Businesses[iBusiness][bInventory]--;
				Businesses[iBusiness][bTotalSales]++;
				Businesses[iBusiness][bSafeBalance] += TaxSale(cost);
				Businesses[iBusiness][bSafeBalance] -= floatround(cost * BIZ_PENALTY);
				GivePlayerCash(playerid, -cost);
				if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[iBusiness][bLevelProgress]++;
				SaveBusiness(iBusiness);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				if (PlayerInfo[playerid][pDonateRank] >= 1)
				{
					format(string,sizeof(string),"VIP: You have received 20 percent off this product. Instead of paying $%s, you paid $%s.", number_format(Businesses[iBusiness][bItemPrices][listitem]), number_format(cost));
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
				}
				format(string,sizeof(string),"%s (IP: %s) has bought a %s in %s (%d) for $%d.",GetPlayerNameEx(playerid),GetPlayerIpEx(playerid),RestaurantItems[iItem], Businesses[iBusiness][bName], iBusiness, cost);
				Log("logs/business.log", string);
				format(string,sizeof(string),"* You have purchased a %s from %s for $%d.",RestaurantItems[iItem],Businesses[iBusiness][bName], cost);
				SendClientMessage(playerid, COLOR_GRAD2, string);
				SetPlayerHealth(playerid, 100.0);

				printf("%s\n%i", RestaurantItems[iItem], iItem);

				if (strcmp("Starter Meal", RestaurantItems[iItem]) == 0) // starter
				{
					PlayerInfo[playerid][pHunger] += 33;

					if (PlayerInfo[playerid][pFitness] >= 3)
						PlayerInfo[playerid][pFitness] -= 3;
					else
						PlayerInfo[playerid][pFitness] = 0;
				}
				else if (strcmp("Full Meal", RestaurantItems[iItem]) == 0) // full meal
				{
					PlayerInfo[playerid][pHunger] += 83;

					if (PlayerInfo[playerid][pFitness] >= 5)
						PlayerInfo[playerid][pFitness] -= 5;
					else
						PlayerInfo[playerid][pFitness] = 0;
				}

				// reset hunger timers because player has just eaten
				PlayerInfo[playerid][pHungerTimer] = 0;
				PlayerInfo[playerid][pHungerDeathTimer] = 0;

				if (PlayerInfo[playerid][pHunger] > 100) PlayerInfo[playerid][pHunger] = 100;
			}
		}
		for (new i; i <= 13; i++)
		{
			format(pvar,sizeof(pvar),"Business_MenuItem%d", i);
			DeletePVar(playerid, pvar);
			format(pvar,sizeof(pvar),"Business_MenuItemPrice%d", i);
			DeletePVar(playerid, pvar);
		}
	}
	if (dialogid == RESTAURANTMENU2)
	{
		if (response)
		{
			new business = InBusiness(playerid);
			if (GetPlayerCash(playerid) < Businesses[business][bItemPrices][listitem])
		    {
			    return SendClientMessageEx(playerid, COLOR_GRAD4, "You don't have the cash for this item!");
	  		}
	  		GivePlayerCash(playerid, -Businesses[business][bItemPrices][listitem]);
			Businesses[business][bSafeBalance] += TaxSale(Businesses[business][bItemPrices][listitem]);
			Businesses[business][bTotalSales]++;
			Businesses[business][bTotalProfits] += Businesses[business][bItemPrices][listitem];

			if (listitem == 0 || listitem == 1) // food items
			{
				if (listitem == 0) // starter
				{
					PlayerInfo[playerid][pHunger] += 33;

					if (PlayerInfo[playerid][pFitness] >= 3)
						PlayerInfo[playerid][pFitness] -= 3;
					else
						PlayerInfo[playerid][pFitness] = 0;
				}
				else if (listitem == 1) // full meal
				{
					PlayerInfo[playerid][pHunger] += 83;

					if (PlayerInfo[playerid][pFitness] >= 5)
						PlayerInfo[playerid][pFitness] -= 5;
					else
						PlayerInfo[playerid][pFitness] = 0;
				}

				// reset hunger timers because player has just eaten
				PlayerInfo[playerid][pHungerTimer] = 0;
				PlayerInfo[playerid][pHungerDeathTimer] = 0;

				if (PlayerInfo[playerid][pHunger] > 100) PlayerInfo[playerid][pHunger] = 100;
			}

			new buf[128];
			format(buf, sizeof(buf), "You have purchased a '%s'.", RestaurantItems[listitem]);
			SendClientMessageEx(playerid, COLOR_GRAD4, buf);
		}

		return 1;
	}
	if(dialogid == STOREMENU)
	{
		new pvar[25];
	    if (response)
	    {
			new iBusiness = InBusiness(playerid);

			format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", listitem);
			new iPrice = GetPVarInt(playerid, pvar);
			format(pvar, sizeof(pvar), "Business_MenuItem%d", listitem);
			new iItem = GetPVarInt(playerid, pvar);
			new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(iPrice * 0.8)) : (iPrice);

			if (!iPrice) {
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Item is not for sale anymore.");
			}
		 	else if (Businesses[iBusiness][bInventory] < 1) {
	   	 		SendClientMessageEx(playerid, COLOR_GRAD2, "Store does not have any items anymore!");
			}
			else if (iPrice != Businesses[iBusiness][bItemPrices][iItem-1]) {
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Purchase failed because the price for this item has changed.");
			}
			else if (GetPlayerCash(playerid) < cost) {
				SendClientMessageEx(playerid, COLOR_GRAD4, "You can't afford this item!");
			}
			else {
		        format(pvar, sizeof(pvar), "Business_MenuItem%d", listitem);
   				if(iItem == ITEM_ILOCK || iItem == ITEM_ALOCK || iItem == ITEM_ELOCK)
			    {
       				if(Businesses[iBusiness][bInventory] >= StoreItemCost[iItem-1][ItemValue])
		        	{
      					SetPVarInt(playerid, "lockcost", cost);
			        	SetPVarInt(playerid, "businessid", iBusiness);
				        SetPVarInt(playerid, "item", iItem);
				        SetPVarInt(playerid, "penalty", 1);
				        GivePlayerStoreItem(playerid, 0, iBusiness, iItem, cost);
					}
					else return SendClientMessageEx(playerid, COLOR_GRAD2, "The store does not have enough stock for that item!");
	    		}
			    else
			    {
					GivePlayerStoreItem(playerid, 0, iBusiness, iItem, cost);
				}
			}
		}
		for (new i; i <= 13; i++)
		{
			format(pvar,sizeof(pvar),"Business_MenuItem%d", i);
			DeletePVar(playerid, pvar);
			format(pvar,sizeof(pvar),"Business_MenuItemPrice%d", i);
			DeletePVar(playerid, pvar);
		}
	}
	if(dialogid == SHOPMENU)
	{
		if(response)
		{
		    new biz = InBusiness(playerid);
		    if (GetPlayerCash(playerid) < Businesses[biz][bItemPrices][listitem])
		    {
			    return SendClientMessageEx(playerid, COLOR_GRAD4, "You don't have the cash for this item!");
	  		}
			Businesses[biz][bTotalSales]++;
			Businesses[biz][bSafeBalance] += TaxSale(Businesses[biz][bItemPrices][listitem]);
	  		GivePlayerCash(playerid, -Businesses[biz][bItemPrices][listitem]);

	  		switch (listitem)
	  		{
	  		    case 0:
	  		    {
					GivePlayerValidWeapon(playerid, WEAPON_DILDO, 99999);
					SendClientMessageEx(playerid, COLOR_GRAD4, "Purple Dildo purchased, you can now pleasure yourself.");
	  		    }
	  		    case 1:
	  		    {
					GivePlayerValidWeapon(playerid, WEAPON_VIBRATOR, 99999);
					SendClientMessageEx(playerid, COLOR_GRAD4, "Short Vibrator purchased, you can now pleasure yourself.");
	  		    }
	  		    case 2:
	  		    {
				  	GivePlayerValidWeapon(playerid, WEAPON_VIBRATOR2, 99999);
					SendClientMessageEx(playerid, COLOR_GRAD4, "Long Vibrator purchased, you can now pleasure yourself.");
	  		    }
				case 3:
	  		    {
					GivePlayerValidWeapon(playerid, WEAPON_DILDO2, 99999);
					SendClientMessageEx(playerid, COLOR_GRAD4, "White Dildo purchased, you can now pleasure yourself.");
	  		    }
	  		}
		}
		return 1;
	}
	if(dialogid == GIVEKEYS)
	{
	    if(response)
	    {
			if(PlayerVehicleInfo[playerid][listitem][pvId] == INVALID_PLAYER_VEHICLE_ID) {
	            SendClientMessageEx(playerid, COLOR_GRAD2, "You can't give out keys to a non-existent, impounded vehicle or stored vehicle.");
	            GiveKeysTo[playerid] = INVALID_PLAYER_ID;
	            return 1;
			}
	        if(PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId] != INVALID_PLAYER_ID)
	        {
	            SendClientMessageEx(playerid, COLOR_GRAD2, "You already gave someone the keys of this car.");
	            GiveKeysTo[playerid] = INVALID_PLAYER_ID;
	            return 1;
	        }
	        if(PlayerInfo[GiveKeysTo[playerid]][pVehicleKeysFrom] != INVALID_PLAYER_ID)
	        {
	            SendClientMessageEx(playerid, COLOR_GRAD2, "That person already has keys from a different car.");
	            GiveKeysTo[playerid] = INVALID_PLAYER_ID;
	            return 1;
	        }
			PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId] = GiveKeysTo[playerid];
			PlayerInfo[GiveKeysTo[playerid]][pVehicleKeys] = listitem;
			PlayerInfo[GiveKeysTo[playerid]][pVehicleKeysFrom] = playerid;
			format(string, sizeof(string), "%s has given you the keys for their %s.", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][listitem][pvId]));
			SendClientMessageEx(GiveKeysTo[playerid], COLOR_GRAD2, string);
			format(string, sizeof(string), "You gave %s the keys for your %s.", GetPlayerNameEx(GiveKeysTo[playerid]), GetVehicleName(PlayerVehicleInfo[playerid][listitem][pvId]));
			SendClientMessageEx(playerid, COLOR_GRAD2, string);
			GiveKeysTo[playerid] = INVALID_PLAYER_ID;
	    }
	}
	if(dialogid == REMOVEKEYS)
	{
	    if(response)
	    {
	        if(PlayerVehicleInfo[playerid][listitem][pvId] == INVALID_PLAYER_VEHICLE_ID) {
	            SendClientMessageEx(playerid, COLOR_GRAD2, "You can't remove the keys of a non-existent, impounded vehicle or stored vehicle.");
	            return 1;
			}
	        if(PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId] != PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId])
	        {
	            SendClientMessageEx(playerid, COLOR_GRAD2, "This person doesn't have the keys of this car.");
	            return 1;
	        }
	        if(PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId] == INVALID_PLAYER_ID)
	        {
	            SendClientMessageEx(playerid, COLOR_GRAD2, "You have not given anyone the keys for this car.");
	            return 1;
	        }
			PlayerInfo[PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId]][pVehicleKeys] = INVALID_PLAYER_VEHICLE_ID;
			PlayerInfo[PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId]][pVehicleKeysFrom] = INVALID_PLAYER_ID;
			format(string, sizeof(string), "%s has taken the keys of their %s.", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][listitem][pvId]));
			SendClientMessageEx(PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId], COLOR_GRAD2, string);
			format(string, sizeof(string), "You took the keys of your %s from %s.", GetVehicleName(PlayerVehicleInfo[playerid][listitem][pvId]),GetPlayerNameEx(PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId]));
			SendClientMessageEx(playerid, COLOR_GRAD2, string);
			PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId] = INVALID_PLAYER_ID;
	    }
	}
	if(dialogid == MPSPAYTICKETSCOP)
	{
	    if(response)
	    {
			new
				szMessage[128],
				iTargetID = GetPVarInt(playerid, "vRel");

			if(PlayerVehicleInfo[iTargetID][listitem][pvTicket]) {
				format(szMessage, sizeof(szMessage), "You have paid the $%s ticket on %s's %s.", number_format(PlayerVehicleInfo[iTargetID][listitem][pvTicket]), GetPlayerNameEx(iTargetID), VehicleName[PlayerVehicleInfo[iTargetID][listitem][pvModelId] - 400]);
				SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);

				format(szMessage, sizeof(szMessage), "%s has paid all tickets on your %s (%i).", GetPlayerNameEx(playerid), VehicleName[PlayerVehicleInfo[iTargetID][listitem][pvModelId] - 400], PlayerVehicleInfo[iTargetID][listitem][pvTicket]);
				SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szMessage);
				PlayerVehicleInfo[iTargetID][listitem][pvTicket] = 0;
				g_mysql_SaveVehicle(iTargetID, listitem);
			}
			else if(PlayerVehicleInfo[iTargetID][listitem][pvImpounded])
			{
				if(!vehicleSpawnCountCheck(iTargetID))
				{
					SendClientMessageEx(playerid, COLOR_GREY, "That person has too many vehicles out of storage for this vehicle to be released.");
					return 1;
				}

				format(szMessage, sizeof(szMessage), "You have released %s's %s.", GetPlayerNameEx(iTargetID), VehicleName[PlayerVehicleInfo[iTargetID][listitem][pvModelId] - 400]);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

				format(szMessage, sizeof(szMessage), "%s has released your %s from the impound.", GetPlayerNameEx(playerid), VehicleName[PlayerVehicleInfo[iTargetID][listitem][pvModelId] - 400]);
				SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szMessage);

				format(szMessage, sizeof(szMessage), "HQ: %s has released %s's %s from the impound.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID), VehicleName[PlayerVehicleInfo[iTargetID][listitem][pvModelId] - 400]);
				SendGroupMessage(PlayerInfo[playerid][pMember], RADIO, szMessage);

				new rand = random(sizeof(DMVRelease));
				PlayerVehicleInfo[iTargetID][listitem][pvImpounded] = 0;
				PlayerVehicleInfo[playerid][listitem][pvSpawned] = 1;
				PlayerVehicleInfo[iTargetID][listitem][pvPosX] = DMVRelease[rand][0];
				PlayerVehicleInfo[iTargetID][listitem][pvPosY] = DMVRelease[rand][1];
				PlayerVehicleInfo[iTargetID][listitem][pvPosZ] = DMVRelease[rand][2];
				PlayerVehicleInfo[iTargetID][listitem][pvPosAngle] = 180.000;
				PlayerVehicleInfo[iTargetID][listitem][pvTicket] = 0;
				VehicleSpawned[iTargetID]++;
				++PlayerCars;

				PlayerVehicleInfo[iTargetID][listitem][pvId] = CreateVehicle(PlayerVehicleInfo[iTargetID][listitem][pvModelId], PlayerVehicleInfo[iTargetID][listitem][pvPosX], PlayerVehicleInfo[iTargetID][listitem][pvPosY], PlayerVehicleInfo[iTargetID][listitem][pvPosZ], PlayerVehicleInfo[iTargetID][listitem][pvPosAngle],PlayerVehicleInfo[iTargetID][listitem][pvColor1], PlayerVehicleInfo[iTargetID][listitem][pvColor2], -1);
				Vehicle_ResetData(PlayerVehicleInfo[iTargetID][listitem][pvId]);
				VehicleFuel[PlayerVehicleInfo[iTargetID][listitem][pvId]] = PlayerVehicleInfo[iTargetID][listitem][pvFuel];
				if(PlayerVehicleInfo[iTargetID][listitem][pvLocked] == 1) LockPlayerVehicle(iTargetID, PlayerVehicleInfo[iTargetID][listitem][pvId], PlayerVehicleInfo[iTargetID][listitem][pvLock]);
				LoadPlayerVehicleMods(iTargetID, listitem);
				g_mysql_SaveVehicle(iTargetID, listitem);
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle either does not exist, or does not need to be released or have its tickets paid.");
	    }
		return 1;
	}
	if(dialogid == MPSPAYTICKETS)
	{
	    if(response)
	    {
			new
				szMessage[128];

			if(PlayerInfo[playerid][pWantedLevel] != 0)
			{
				format(szMessage, sizeof(szMessage), "%s has attempted to pay/release their vehicles with %i active warrants.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pWantedLevel]);
				SendGroupMessage(1, DEPTRADIO, szMessage);
				return SendClientMessageEx(playerid, COLOR_YELLOW, "The police has been warned that you are wanted, and are on their way.");
			}
			if(PlayerVehicleInfo[playerid][listitem][pvTicket]) {
				if(GetPlayerCash(playerid) < PlayerVehicleInfo[playerid][listitem][pvTicket]) {
					return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have enough money on you to pay the ticket.");
				}
				GivePlayerCash(playerid, -PlayerVehicleInfo[playerid][listitem][pvTicket]);
				Tax += (PlayerVehicleInfo[playerid][listitem][pvTicket] / 100) * 30;
				SpeedingTickets += PlayerVehicleInfo[playerid][listitem][pvTicket];
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							format(str, sizeof(str), "%s has paid some vehicle tickets adding $%s to the vault.", GetPlayerNameEx(playerid), number_format((PlayerVehicleInfo[playerid][listitem][pvTicket] / 100) * 30));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();
				format(szMessage, sizeof(szMessage), "You have paid the $%s ticket on your %s.", number_format(PlayerVehicleInfo[playerid][listitem][pvTicket]), VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400]);
				SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);
				PlayerVehicleInfo[playerid][listitem][pvTicket] = 0;
				g_mysql_SaveVehicle(playerid, listitem);
			}
			else if(PlayerVehicleInfo[playerid][listitem][pvImpounded]) {

				new
					iCost = (PlayerVehicleInfo[playerid][listitem][pvPrice] / 20) + PlayerVehicleInfo[playerid][listitem][pvTicket] + (PlayerInfo[playerid][pLevel] * 3000);

				if(GetPlayerCash(playerid) < iCost) {
					return SendClientMessage(playerid, COLOR_GRAD2, "You don't have enough money on you.");
				}

    			if(!vehicleSpawnCountCheck(playerid)) {
					return SendClientMessage(playerid, COLOR_GRAD2, "You have too many vehicles spawned - store one first.");
				}

				format(szMessage, sizeof(szMessage), "You have released your %s for $%i.", VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400], iCost);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, szMessage);
				GivePlayerCash(playerid, -iCost);
                Tax += (iCost / 100) * 30;
                SpeedingTickets += iCost;
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							format(str, sizeof(str), "%s has paid some vehicle tickets adding $%s to the vault.", GetPlayerNameEx(playerid), number_format((iCost / 100) * 30));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();

				new rand = random(sizeof(DMVRelease));
				PlayerVehicleInfo[playerid][listitem][pvImpounded] = 0;
				PlayerVehicleInfo[playerid][listitem][pvSpawned] = 1;
				PlayerVehicleInfo[playerid][listitem][pvPosX] = DMVRelease[rand][0];
				PlayerVehicleInfo[playerid][listitem][pvPosY] = DMVRelease[rand][1];
				PlayerVehicleInfo[playerid][listitem][pvPosZ] = DMVRelease[rand][2];
				PlayerVehicleInfo[playerid][listitem][pvPosAngle] = 180.000;
				PlayerVehicleInfo[playerid][listitem][pvTicket] = 0;
				VehicleSpawned[playerid]++;
				++PlayerCars;

				PlayerVehicleInfo[playerid][listitem][pvId] = CreateVehicle(PlayerVehicleInfo[playerid][listitem][pvModelId], PlayerVehicleInfo[playerid][listitem][pvPosX], PlayerVehicleInfo[playerid][listitem][pvPosY], PlayerVehicleInfo[playerid][listitem][pvPosZ], PlayerVehicleInfo[playerid][listitem][pvPosAngle],PlayerVehicleInfo[playerid][listitem][pvColor1], PlayerVehicleInfo[playerid][listitem][pvColor2], -1);
				VehicleFuel[PlayerVehicleInfo[playerid][listitem][pvId]] = PlayerVehicleInfo[playerid][listitem][pvFuel];
				if(PlayerVehicleInfo[playerid][listitem][pvLocked] == 1) LockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][listitem][pvId], PlayerVehicleInfo[playerid][listitem][pvLock]);
				LoadPlayerVehicleMods(playerid, listitem);
				Vehicle_ResetData(PlayerVehicleInfo[playerid][listitem][pvId]);
				g_mysql_SaveVehicle(playerid, listitem);
			}
			else SendClientMessage(playerid, COLOR_GRAD2, "This vehicle either does not exist, or does not need to be released or have its tickets paid.");
	    }
		return 1;
	}
	if(dialogid == REPORTSMENU)
	{
	    if(response)
	    {
	        if(CancelReport[playerid] == listitem) return 1;
			new reportid = ListItemReportId[playerid][listitem];
	        if(Reports[reportid][BeingUsed] == 0)
			{
			    SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
			    return 1;
			}
			if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
			{
			    SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
			    Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			    Reports[reportid][BeingUsed] = 0;
			    return 1;
			}
			format(string, sizeof(string), "AdmCmd: %s has accepted the report from %s (ID: %i RID: %i).", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]), Reports[reportid][ReportFrom], reportid);
			ABroadCast(COLOR_ORANGE, string, 2);
			AddReportToken(playerid); // Report Tokens
			if(PlayerInfo[playerid][pAdmin] == 1)
			{
			    SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "An admin has accepted your report and is reviewing it, you can /reply to send messages to the admin reviewing your report.");
			}
			else
			{
			    format(string, sizeof(string), "%s has accepted your report and is reviewing it, you can /reply to send messages to the admin reviewing your report.", GetPlayerNameEx(playerid));
			    SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
			}
			PlayerInfo[playerid][pAcceptReport]++;
			ReportCount[playerid]++;
			ReportHourCount[playerid]++;
			Reports[reportid][ReplyTimerr] = SetTimerEx("ReplyTimer", 30000, 0, "d", reportid);
			Reports[reportid][CheckingReport] = playerid;
			//Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			Reports[reportid][TimeToExpire] = 0;
			//strmid(Reports[reportid][Report], "None", 0, 4, 4);
	    }
	    else
	    {
	        if(CancelReport[playerid] == listitem) return 1;
	        new reportid = ListItemReportId[playerid][listitem];
	        if(Reports[reportid][BeingUsed] == 0)
			{
			    SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
			    return 1;
			}
			if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
			{
			    SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
			    Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			    Reports[reportid][BeingUsed] = 0;
			    return 1;
			}
			format(string, sizeof(string), "AdmCmd: %s has trashed the report from %s (RID: %i).", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]), reportid);
			ABroadCast(COLOR_ORANGE, string, 2);
			if(PlayerInfo[playerid][pAdmin] == 1)
			{
			    SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "An admin has marked your report invalid. It will not be reviewed.");
			}
			else
			{
			    format(string, sizeof(string), "%s has marked your report invalid. It will not be reviewed.", GetPlayerNameEx(playerid));
			    SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
			}
			PlayerInfo[playerid][pTrashReport]++;
			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			Reports[reportid][TimeToExpire] = 0;
			new reportdialog[2048], itemid = 0;
		    for(new i = 0; i < MAX_REPORTS; i++)
			{
				if(Reports[i][BeingUsed] == 1 && itemid < 40)
				{
					ListItemReportId[playerid][itemid] = i;
					itemid++;
					if(strlen((Reports[i][Report])) > 92)
					{
						new firstline[128], secondline[128];
						strmid(firstline, Reports[i][Report], 0, 88);
						strmid(secondline, Reports[i][Report], 88, 128);
						format(reportdialog, sizeof(reportdialog), "%s%s(ID:%i) | Report: %s", reportdialog, GetPlayerNameEx(Reports[i][ReportFrom]), Reports[i][ReportFrom], i, firstline);
						format(reportdialog, sizeof(reportdialog), "%s%s", reportdialog, secondline);
						ListItemReportId[playerid][itemid] = i;
						itemid++;
					}
					else format(reportdialog, sizeof(reportdialog), "%s%s(ID:%i) | Report: %s", reportdialog, GetPlayerNameEx(Reports[i][ReportFrom]), Reports[i][ReportFrom], i, (Reports[i][Report]));

					format(reportdialog, sizeof(reportdialog), "%s\n", reportdialog);
				}
			}
			CancelReport[playerid] = itemid;
			format(reportdialog, sizeof(reportdialog), "%s\n", reportdialog);
			format(reportdialog, sizeof(reportdialog), "%sCancel Reports", reportdialog);
			//SendClientMessageEx(playerid, COLOR_GREEN, "___________________________________________________");
			ShowPlayerDialog(playerid, REPORTSMENU, DIALOG_STYLE_LIST, "Reports", reportdialog, "Accept", "Trash");
			//strmid(Reports[reportid][Report], "None", 0, 4, 4);
	    }
	}
	/*if((dialogid == DUTY_OPTIONS) && (response))
	{
	    if(listitem == 0) // Public Duty
		{
		    if(PlayerInfo[playerid][pDuty] == 0)
		    {
					GetPlayerName(playerid, sendername, sizeof(sendername));
					format(string, sizeof(string), "* Officer %s takes a badge and a gun from their locker.", sendername);
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					SetPlayerColor(playerid, TEAM_BLUE_COLOR);
					SetPlayerSkin(playerid, 280);
					PlayerInfo[playerid][pModel] = 280;
	    			SetPlayerArmor(playerid, 100.0);
					GivePlayerValidWeapon(playerid, 24, 99999);
					GivePlayerValidWeapon(playerid, 41, 99999);
					GivePlayerValidWeapon(playerid, 3, 99999);
					OnDuty[playerid] = 1;
					PlayerInfo[playerid][pDuty] = 1;
			}
			else if(PlayerInfo[playerid][pDuty] == 1)
			{
					GetPlayerName(playerid, sendername, sizeof(sendername));
					format(string, sizeof(string), "* Officer %s places their badge and gun in their locker.", sendername);
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					SetPlayerColor(playerid, TEAM_HIT_COLOR);
					SetPlayerSkin(playerid, 46);
					PlayerInfo[playerid][pModel] = 46;
					SetPlayerArmor(playerid, 0.0);
					ResetPlayerWeaponsEx(playerid);
					OnDuty[playerid] = 0;
					PlayerInfo[playerid][pDuty] = 0;
			}
		}
	    if(listitem == 1) // Undercover Duty
		{
		    if(PlayerInfo[playerid][pDuty] == 0)
		    {
					GetPlayerName(playerid, sendername, sizeof(sendername));
					format(string, sizeof(string), "* Officer %s takes a badge and a gun from their locker.", sendername);
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	    			SetPlayerArmor(playerid, 100.0);
					GivePlayerValidWeapon(playerid, 24, 99999);
					GivePlayerValidWeapon(playerid, 29, 99999);
					OnDuty[playerid] = 1;
					PlayerInfo[playerid][pDuty] = 1;
			}
			else if(PlayerInfo[playerid][pDuty] == 1)
			{
					GetPlayerName(playerid, sendername, sizeof(sendername));
					format(string, sizeof(string), "* Officer %s places their badge and gun in their locker.", sendername);
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					SetPlayerArmor(playerid, 0.0);
					ResetPlayerWeaponsEx(playerid);
					OnDuty[playerid] = 0;
					PlayerInfo[playerid][pDuty] = 0;
			}
		}
	}*/

	if(dialogid == COLORMENU)
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerColor(playerid,COLOR_DBLUE);
				SendClientMessageEx(playerid, COLOR_DBLUE, "Your color has been set to Blue!");
			}
			if(listitem == 1)
			{
				SetPlayerColor(playerid,COLOR_BLACK);
				SendClientMessageEx(playerid, COLOR_BLACK, "Your color has been set to Black!");
			}
			if(listitem == 2)
			{
				SetPlayerColor(playerid,COLOR_RED);
				SendClientMessageEx(playerid, COLOR_RED, "Your color has been set to Red!");
			}
			if(listitem == 3)
			{
				SetPlayerColor(playerid,TEAM_ORANGE_COLOR);
				SendClientMessageEx(playerid, TEAM_ORANGE_COLOR, "Your color has been set to Orange!");
			}
			if(listitem == 4)
			{
				SetPlayerColor(playerid,COLOR_PINK);
				SendClientMessageEx(playerid, COLOR_PINK, "Your color has been set to Pink!");
			}
			if(listitem == 5)
			{
				SetPlayerColor(playerid,COLOR_PURPLE);
				SendClientMessageEx(playerid, COLOR_PURPLE, "Your color has been set to Purple!");
			}
			if(listitem == 6)
			{
				SetPlayerColor(playerid,COLOR_GREEN);
				SendClientMessageEx(playerid, COLOR_GREEN, "Your color has been set to Green!");
			}
			if(listitem == 7)
			{
				SetPlayerColor(playerid,COLOR_YELLOW);
				SendClientMessageEx(playerid, COLOR_YELLOW, "Your color has been set to Yellow!");
			}
			if(listitem == 8)
			{
				SetPlayerColor(playerid,COLOR_WHITE);
				SendClientMessageEx(playerid, COLOR_WHITE, "Your color has been set to White!");
			}
		}
	}
 	if(dialogid == FAQMENU)
  	{
   		if(response)
     	{
           	if(listitem == 0) // Vehicle Locks
            {
            	ShowPlayerDialog(playerid, LOCKSFAQ, DIALOG_STYLE_MSGBOX, "Vehicle Locks", "Information:\n\nLocks can be bought at a 24/7 for $5000 using /buy.\nYou can type /lock to lock your vehicle, and /lock once more to unlock it.\nYou will lose your lock when you log out.", "Thanks", "Cancel");
            }
            else if(listitem == 1) //Skins
            {
           		ShowPlayerDialog(playerid, SKINSFAQ, DIALOG_STYLE_MSGBOX, "Skins & Toys", "Information:\n\nSkins and toys can be bought at a clothes store, such as Binco, by typing /buyclothes and /buytoys.\nIf you are in a family or faction, you can type /clothes to change your skin for free.\nTo change your skin, you must know the SkinID. If you don't know it, then just search for it on Google.", "Thanks", "Cancel");
            }
            else if(listitem == 2) //ATMs
			{
   				ShowPlayerDialog(playerid, ATMFAQ, DIALOG_STYLE_MSGBOX, "ATMs", "Information:\n\nATMs are little machines located around Los Santos, that allows you to deposit, or withdraw money into your bank account.\nInstead of running to the bank, you can simply access your bank account through one of these.\nIf you need help with the ATM commands, just type /help.", "Thanks", "Cancel");
       		}
         	else if(listitem == 3) //Factions
          	{
           		ShowPlayerDialog(playerid, FACTIONSFAQ, DIALOG_STYLE_MSGBOX, "Factions", "Information:\n\nFactions such as the LSPD, FBI, FDSA, etc. are legal organizations.\nYou can apply to join for these factions at www.NG-Gaming.net/forums.", "Thanks", "Cancel");
           	}
           	else if(listitem == 4) //Gangs
            {
            	ShowPlayerDialog(playerid, GANGSFAQ, DIALOG_STYLE_MSGBOX, "Gangs", "Information:\n\nGangs are obviously illegal organizations. To view the list of families, simply type /families.\nDo not use /families to metagame someone's name. You must ICly find them and roleplay with them, in order for you to join.\nMost families also do points, which you can earn money from.", "Thanks", "Cancel");
            }
            else if(listitem == 5) //Hitmen
            {
            	ShowPlayerDialog(playerid, HITMENFAQ, DIALOG_STYLE_MSGBOX, "Hitmen", "Information:\n\nHitmen are pretty much 'hired killers' You can type /contract to put a hit on someone, but it must be for a RP reason.\nIf someone finds out that you put an OOC hit on someone, you will get in trouble and possibly banned.\nYou DO NOT ask to be a hitman, because they ask you, if they want you.\nPlease note that if you EVER release a hitman's name, you WILL BE BANNED.", "Thanks", "Cancel");
            }
            else if(listitem == 6) //Website
            {
           		ShowPlayerDialog(playerid, WEBSITEFAQ, DIALOG_STYLE_MSGBOX, "Ventrilo and Other Information", "Information:\n\nFeedback: www.feedback.NG-Gaming.net\nForums: www.NG-Gaming.net/forums\nTeamspeak: TS.NG-Gaming.net | Port: 9987\nFacebook: www.FaceBook.com/NextGenerationGaming\nXFire Group: www.XFire.com/communities/nextgenerationroleplay", "Thanks", "Cancel");
            }
            else if(listitem == 7) //Further Help
           	{
           		ShowPlayerDialog(playerid, FURTHERHELPFAQ, DIALOG_STYLE_MSGBOX, "Further Help", "Information:\n\nIf you think you still need further help, then please use /newb to ask a question\nIf you need EVEN MORE help, then please use /requesthelp, and a community advisor will be with you shortly.\nAlso, please note that /newb is for script-related questions only.", "Thanks", "Cancel");
			}
		}
 	}
 	if(dialogid == FIGHTMENU)
	{
		if(response)
		{
			if(GetPlayerCash(playerid) >= 50000)
			{
				if(listitem == 0)
				{
			    	PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_BOXING;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);
					SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the boxing fighting style!");

    				if(PlayerInfo[playerid][pDonateRank] >= 1)
				    {
				    	GivePlayerCash(playerid, -40000);
        				SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have received 20 percent off this product. Instead of paying $50000, you paid $40000.");
					}
					else
					{
						GivePlayerCash(playerid, -50000);
					}
				}
				if(listitem == 1)
				{
					PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_ELBOW;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);
					SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the elbow fighting style!");

 					if(PlayerInfo[playerid][pDonateRank] >= 1)
				    {
				    	GivePlayerCash(playerid, -40000);
        				SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have received 20 percent off this product. Instead of paying $50000, you paid $40000.");
					}
					else
					{
						GivePlayerCash(playerid, -50000);
					}
				}
				if(listitem == 2)
				{
			    	PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_KNEEHEAD;
				    SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);
				    SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the kneehead fighting style!");

    				if(PlayerInfo[playerid][pDonateRank] >= 1)
				    {
				    	GivePlayerCash(playerid, -40000);
        				SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have received 20 percent off this product. Instead of paying $50000, you paid $40000.");
					}
					else
					{
						GivePlayerCash(playerid, -50000);
					}
				}
				if(listitem == 3)
				{
   					PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_KUNGFU;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);
					SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the kungfu fighting style!");

 					if(PlayerInfo[playerid][pDonateRank] >= 1)
				    {
				    	GivePlayerCash(playerid, -40000);
        				SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have received 20 percent off this product. Instead of paying $50000, you paid $40000.");
					}
					else
					{
						GivePlayerCash(playerid, -50000);
					}
				}
				if(listitem == 4)
				{
					PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_GRABKICK;
	    			SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);
			  	  	SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the grabkick fighting style!");

    				if(PlayerInfo[playerid][pDonateRank] >= 1)
				    {
				    	GivePlayerCash(playerid, -40000);
        				SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have received 20 percent off this product. Instead of paying $50000, you paid $40000.");
					}
					else
					{
						GivePlayerCash(playerid, -50000);
					}
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, " You do not have the cash for that!");
				return 1;
			}

			if(listitem == 5)
			{
				PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_NORMAL;
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
	  			SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the normal fighting style!");
				return 1;
			}
		}
	}
	if(dialogid == JOBHELPMENU)
	{
 		if(response)
		{
			if(listitem == 0) //Detective
			{
				ShowPlayerDialog(playerid, DETECTIVEJOB, DIALOG_STYLE_MSGBOX, "Detective", "Information:\n\nThis job can be used to locate people anywhere around San Andreas.\nThis is helpful for the Government factions, and can be used to find criminals. It is a legal job and you cannot get busted for doing it.\nIt will tell you the last known location(area) they were found in and give you a beacon.", "Next", "Cancel");
			}
			if(listitem == 1) //Lawyer
			{
				ShowPlayerDialog(playerid, LAWYERJOB, DIALOG_STYLE_MSGBOX, "Lawyer", "Information:\n\nThis job can be used to remove wanted stars, reduce jail time, and list all criminals.\nThis is helpful for criminals and crooks, it is a legal job and you cannot get busted for doing it.\nIt will come in handy for your friends and families who got trouble with the cops.", "Next", "Cancel");
			}
			if(listitem == 2) //Whore
			{
				ShowPlayerDialog(playerid, WHOREJOB, DIALOG_STYLE_MSGBOX, "Whore", "Information:\n\nThis job can be used to bring pleasure to any clients who may be interested in having some fun.\nThis is a job that offers sex to every client who comes along.\nThis is an illegal job and you can get busted for doing it.", "Next", "Cancel");
			}
			if(listitem == 3) //Drug Dealer
            {
				ShowPlayerDialog(playerid, DRUGDEALERJOB, DIALOG_STYLE_MSGBOX, "Drug Dealer", "Information:\n\nThis job can be used to sell pot and crack to any customers you might find.\nIt often comes in handy, when you're a higher level at it.\nThe higher the level, the more drugs you can hold.\nThis is an illegal job and you can get busted for doing it.", "Next", "Cancel");
			}
			if(listitem == 4) //Mechanic
			{
				ShowPlayerDialog(playerid, MECHANICJOB, DIALOG_STYLE_MSGBOX, "Mechanic", "Information:\n\nThis job can be used to repair, add nos, and add hydraulics to vehicles.\nThis job can sometimes be rewarding, but often people do not require assistance.\nThis is a legal job and you cannot get busted for doing it.", "Next", "Cancel");
			}
			if(listitem == 5) //Bodyguard
			{
				ShowPlayerDialog(playerid, BODYGUARDJOB, DIALOG_STYLE_MSGBOX, "Bodyguard", "Information:\n\nThis job can be used to give people half armor.\nThis job is very profitable and the common spot for purchasing off bodyguards is the gym.\nThis is a legal job and you cannot get busted for doing it.", "Next", "Cancel");
			}
			if(listitem == 6) //Arms Dealer
			{
				ShowPlayerDialog(playerid, ARMSDEALERJOB, DIALOG_STYLE_MSGBOX, "Arms Dealer", "Information:\n\nThis job can be used to sell people weapons.\nThis job is very profitable and can earn you big cash at later levels.\nThis is an illegal job and you can get busted for doing it.", "Next", "Cancel");
			}
			if(listitem == 7) //Boxer
			{
				ShowPlayerDialog(playerid, BOXERJOB, DIALOG_STYLE_MSGBOX, "Boxer", "Information:\n\nThis job can be used to box people inside the Ganton Gym.\nThis job is not very money-making, but you can become the boxing champion.\nThis is a legal job and you cannot get busted for doing it.", "Next", "Cancel");
			}
			if(listitem == 8) //Taxi Driver
            {
				ShowPlayerDialog(playerid, TAXIJOB, DIALOG_STYLE_MSGBOX, "Taxi Driver", "Information:\n\nThis job can be used to take passengers around the city for any price you desire($1 - $500 per 16 seconds).\nThis job is not very profitable as people do not usually call taxis, and sometimes they try to steal your taxi vehicle.\nThis is a legal job and you cannot get busted for doing it.", "Next", "Cancel");
			}
			if(listitem == 9) //Drug Smuggling
            {
				ShowPlayerDialog(playerid, SMUGGLEJOB, DIALOG_STYLE_MSGBOX, "Drug Smuggling", "Information:\n\nThis job can be used to keep Crack and Pot filled in the Crack Lab.\nThis job is very profitable as people usually buy crack and pot, and sometimes they try to steal your pot and crack.\nThis is an ilegal job and you can get busted for doing it.", "Next", "Cancel");
			}
			if(listitem == 10) //Craftsman
            {
				ShowPlayerDialog(playerid, CRAFTJOB, DIALOG_STYLE_MSGBOX, "Craftsman", "Information:\nThis job can be used to sell crafts to other players.\nThis job is very profitable as people have a need for many of the things you can make.\nThis is a legal job and you can not get busted for doing it.\n\nCommands:\n/getmats /craft\nLocation of job: This job can be obtained in Willowfield at the junkyard, at the job icon(yellow circle).", "Done", "Cancel");
			}
			if(listitem == 11) //Bartender
            {
				ShowPlayerDialog(playerid, BARTENDERJOB, DIALOG_STYLE_MSGBOX, "Bartender", "Information:\nThis job can be used to sell drinks to other players.\nThis is a legal job and you can not get busted for doing it.\n\nCommands:\n/selldrink\nLocation of job: This job can be obtained in Idlewood inside the Alhambra Club, at the job icon(yellow i).", "Done", "Cancel");
			}
			if(listitem == 12) //Trucker
            {
				ShowPlayerDialog(playerid, TRUCKERJOB, DIALOG_STYLE_MSGBOX, "Shipment Contractor","Information:\nThis job can be used to earn money by making truck deliveries\nThis is a legal job, however you can get busted if you transport illegal goods or hijack trucks. Also Shipment Contractors get a 50 percent bonus for carting illegal goods.\n\nCommands:\n/loadshipment /checkcargo /hijackcargo\nLocation of job: This job can be obtained at the San Fierro Docks, at the job icon(yellow I).", "Done", "Cancel");
			}
			if(listitem == 13) //Pizza Boy
            {
				ShowPlayerDialog(playerid, PIZZAJOB, DIALOG_STYLE_MSGBOX, "Pizza Boy","Information:\nThis job can be used to earn money by grabbing a pizza from the\n SF Pizza Stack and then delivering it to different houses.\n You will get less and less money as time moves on and eventually,\n when the pizza is cold, it will be worthless.\n\nCommands:\n/getpizza\nLocation of job: This job can be obtained at the Pier 69, at the job icon(yellow I).", "Done", "Cancel");
			}
		}
	}
	if(dialogid == SMUGGLEJOB2)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, SMUGGLEJOB3, DIALOG_STYLE_MSGBOX, "Drug Smuggling", "Commands:\n\n/getcrate [name(Pot/Crack)]\n\nLocation of job: This job can be obtained inside the Crack Lab, at the job icon(yellow circle).", "Done", "Cancel");
		}
	}
	if(dialogid == SMUGGLEJOB)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, SMUGGLEJOB2, DIALOG_STYLE_MSGBOX, "Drug Smuggling", "Note: There is no reload time for drug smuggling and you do need to level it up to obtain more money. There are 5 levels for this job.", "Next", "Cancel");
		}
	}
	if(dialogid == TAXIJOB)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, TAXIJOB2, DIALOG_STYLE_MSGBOX, "Taxi Driver", "Note: There is no reload time for taxi fares and there are no levels for this job. In other words, you do not need to level it up to earn the max money you can.", "Next", "Cancel");
		}
	}
	if(dialogid == TAXIJOB2)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, TAXIJOB3, DIALOG_STYLE_MSGBOX, "Taxi Driver", "Commands:\n\n/fare [$1 - $500]\n\nLocation of job: This job can be obtained in front of Unity Station at the job icon(yellow circle).", "Done", "Cancel");
		}
	}
	if(dialogid == BOXERJOB2)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, BOXERJOB3, DIALOG_STYLE_MSGBOX, "Boxer", "Commands:\n\n/fight [PlayerID/Name], /boxstats\n\nLocation of job: This job can be obtained inside the Ganton Gym, at the job icon(yellow circle).", "Done", "Cancel");
		}
	}
	if(dialogid == BOXERJOB)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, BOXERJOB2, DIALOG_STYLE_MSGBOX, "Boxer", "Note: There is no reload time for boxing and you don't need to level it up to box people in the gym. There are 3 levels for this job.\n\nLevel 1: Beginner Boxer.\nLevel 2: Amateur Boxer.\nLevel 3: Professional Boxer.", "Next", "Cancel");
		}
	}
	if(dialogid == ARMSDEALERJOB)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, ARMSDEALERJOB2, DIALOG_STYLE_MSGBOX, "Arms Dealer", "Note: The reload time for selling guns is always 10 seconds, no matter what level.\n\nSkills:\n\nLevel 1 Weapons: Flowers, Knuckles, SDPistol, 9mm, and Shotgun.\nLevel 2 Weapons: Baseball Bat, Cane, MP5, and Rifle.\nLevel 3 Weapons: Shovel and Deagle.\nLevel 4 Weapons: Poolcue and Golf Club.\nLevel 5 Weapons: Katana, Dildo, UZI & TEC9.\nGold+ VIP Feature: AK-47", "Next", "Cancel");
		}
	}
	if(dialogid == ARMSDEALERJOB2)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, ARMSDEALERJOB3, DIALOG_STYLE_MSGBOX, "Arms Dealer", "Commands:\n\n/getmats, /sellgun\n\nLocation of job: This job can be obtained outside the large Ammunation, at the 'gun' icon.", "Done", "Cancel");
		}
	}
	if(dialogid == BODYGUARDJOB2)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, BODYGUARDJOB3, DIALOG_STYLE_MSGBOX, "Bodyguard", "Commands:\n\n/guard [player] [Price $2000 - $10000]\n/frisk [player]\n\nLocation of job: This job can be obtained outside the Ganton Gym, at the job icon(yellow circle).", "Done", "Cancel");
		}
	}
	if(dialogid == BODYGUARDJOB)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, BODYGUARDJOB2, DIALOG_STYLE_MSGBOX, "Bodyguard", "Note: The reload time is always 1 minute. There are no job levels for this job. In other words, you do not need to level it up to earn the max money you can.", "Next", "Cancel");
		}
	}
	if(dialogid == MECHANICJOB)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, MECHANICJOB2, DIALOG_STYLE_MSGBOX, "Mechanic", "Note: The reload time is always 1 minute, no matter what level.", "Next", "Cancel");
		}
	}
	if(dialogid == MECHANICJOB2)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, MECHANICJOB3, DIALOG_STYLE_MSGBOX, "Mechanic", "Commands:\n\n/fix, /repair, /hyd, /nos, /refill, /mechduty\n\nLocation of job: This job can be obtained at blueberry, at the job icon(yellow circle).", "Done", "Cancel");
		}
	}
	if(dialogid == DRUGDEALERJOB)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, DRUGDEALERJOB2, DIALOG_STYLE_MSGBOX, "Drug Dealer", "Note: The reload time is always 1 minute, no matter what level.\n\nSkills:\n\nLevel 1: You can hold 10 pot and 5 crack.\nLevel 2: You can hold 20 pot and 15 crack.\nLevel 3: You can hold 30 pot and 15 crack.\nLevel 4: You can hold 40 pot and 20 crack.\nLevel 5: You can hold 50 pot and 25 crack.", "Next", "Cancel");
		}
	}
	if(dialogid == DRUGDEALERJOB2)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, DRUGDEALERJOB3, DIALOG_STYLE_MSGBOX, "Drug Dealer", "Commands:\n\n/getpot, /sell, /getcrack, /getseeds, /plantpotseeds\n\nLocation of job: This job can be located outside the Drug Den, opposite the Ganton Gym, at the 'D' icon.", "Done", "Cancel");
		}
	}
	if(dialogid == WHOREJOB2)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, WHOREJOB3, DIALOG_STYLE_MSGBOX, "Whore", "Commands:\n\n/sex\n/sex is a command to offer sex to a client, and may only be used in a vehicle.\n\nLocation of job: This job can be obtained inside the Pig Pen, at the job icon(yellow circle).", "Done", "Cancel");
		}
	}
	if(dialogid == LAWYERJOB2)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, LAWYERJOB3, DIALOG_STYLE_MSGBOX, "Lawyer", "Commands:\n\n/defend, /free, /wanted, /lawyerduty, /offerappeal, /finishappeal\n\nLocation of job: This job can be found at the job map icon(yellow circle)near the bank.", "Done", "Cancel");
		}
	}
	if(dialogid == WHOREJOB)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, WHOREJOB2, DIALOG_STYLE_MSGBOX, "Whore", "Note: The reload time is always 1 minute, no matter what level.\n\nSkills:\n\nLevel 1: You have a very high chance of catching/giving STD's.\nLevel 2: You have a high chance of catching/giving STD's.\nLevel 3: You have a medium chance of catching/giving STD's.\nLevel 4: You have a low chance of catching/giving STD's.\nLevel 5: You have a very low chance of catching/giving STD's.", "Next", "Cancel");
		}
	}
	if(dialogid == LAWYERJOB)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, LAWYERJOB2, DIALOG_STYLE_MSGBOX, "Lawyer", "Note: The reload time is always 2 minutes, no matter what level.\n\nSkills:\n\nLevel 1: You can reduce inmates sentences by 1 minute.\nLevel 2: You can reduce inmates sentences by 2 minutes.\nLevel 3: You can reduce inmates sentences by 3 minutes.\nLevel 4: You can reduce inmates sentences by 4 minutes.\nLevel 5: You can reduce inmates sentences by 5 minutes.", "Next", "Cancel");
		}
	}
	if(dialogid == DETECTIVEJOB2)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, DETECTIVEJOB3, DIALOG_STYLE_MSGBOX, "Detective", "Commands:\n\n/find\n/find is a command that can locate a player's position.\n\nLocation of job: This job can be obtained in the Los Santos Police Department.", "Done", "Cancel");
		}
	}
    if(dialogid == DETECTIVEJOB)
	{
   		if(response)
		{
			ShowPlayerDialog(playerid, DETECTIVEJOB2, DIALOG_STYLE_MSGBOX, "Detective", "Skills:\n\nLevel 1: You can find someone for 3 seconds, the reload time is 2 minutes.\nLevel 2: You can find someone for 5 seconds, the reload time is 1 minute, 20 seconds.\nLevel 3: You can find someone for 7 seconds, the reload time is 1 minute.\nLevel 4: You can find someone for 9 seconds, the reload time is 30 seconds.\nLevel 5: You can find someone for 11 seconds, the reload time is 20 seconds.", "Next", "Cancel");
		}
	}
	if(dialogid == DIALOG_LICENSE_BUY && response) // LICENSE BUY DIALOG ~Brian
	{
		switch (listitem)
		{
			case 0:
			{
			    if(PlayerInfo[playerid][pCarLic] == 0)
			    {
			        if(GetPlayerCash(playerid) < 5000)
			        {
			            SendClientMessageEx(playerid, COLOR_GREY, "You can not afford to buy a driver's license.");
			            return 1;
			        }
					GivePlayerCash(playerid,-5000);
					PlayerInfo[playerid][pCarLic] = 1;
					SendClientMessageEx(playerid, COLOR_GREY, "You have successfully acquired a driver's license.");
				}
				else SendClientMessageEx(playerid, COLOR_GREY, "You already have a driver's license.");
			}
			case 1:
			{
			    if(PlayerInfo[playerid][pBoatLic] == 0)
			    {
			        if(GetPlayerCash(playerid) < 5000)
			        {
			            SendClientMessageEx(playerid, COLOR_GREY, "You can not afford to buy a boating license.");
			            return 1;
			        }
					GivePlayerCash(playerid,-5000);
					PlayerInfo[playerid][pBoatLic] = 1;
					SendClientMessageEx(playerid, COLOR_GREY, "You have successfully acquired a boating license.");
				}
				else SendClientMessageEx(playerid, COLOR_GREY, "You already have a boating license.");
			}
			case 2:
			{
			    if(PlayerInfo[playerid][pFlyLic] == 0)
			    {
			    	if(PlayerInfo[playerid][pLevel] >=2)
			    	{
			    	    if(GetPlayerCash(playerid) < 25000)
			        	{
			            	SendClientMessageEx(playerid, COLOR_GREY, "You can not afford to buy a pilot's license.");
			            	return 1;
			        	}
						GivePlayerCash(playerid,-25000);
						PlayerInfo[playerid][pFlyLic] = 1;
      					SendClientMessageEx(playerid, COLOR_GREY, "You have successfully acquired a pilot license; you will now be able to pilot aircraft.");
					}
					else SendClientMessageEx(playerid, COLOR_GREY, "You must be level 2 or above to acquire a pilot license.");
				}
                else SendClientMessageEx(playerid, COLOR_GREY, "You already have a pilot license.");
			}
			case 3:
			{
			    if(PlayerInfo[playerid][pTaxiLicense] == 0)
			    {
			        if(GetPlayerCash(playerid) < 35000)
			        {
			            SendClientMessageEx(playerid, COLOR_GREY, "You can not afford to buy a taxi license.");
			            return 1;
			        }
					GivePlayerCash(playerid,-35000);
					PlayerInfo[playerid][pTaxiLicense] = 1;
					SendClientMessageEx(playerid, COLOR_GREY, "You have successfully acquired a taxi license; you will be able to use /fare in any vehicle, and accept calls for taxis.");
				}
                else SendClientMessageEx(playerid, COLOR_GREY, "You already have a taxi license.");
			}
		}
	}
	if(dialogid == MDC_MAIN && response)
	{//*Find LEO\n*Civilian Information\n*Law Enforcement Agencies\n*Options
 		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
	   	switch( listitem )
	    {
	    	case 0:
	        {
	            ShowPlayerDialog(playerid, MDC_CIVILIANS, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Civilian Options", "*Check Record\n*View Arrest Reports\n*Licenses\n*Warrants\n*Issue Warrant\n*BOLO\n*Create BOLO\n*Delete", "OK", "Cancel");
	        }
	        case 1:
	        {
	            ShowPlayerDialog(playerid, MDC_FIND, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | LEO GPS Location", "Enter the Law Enforcment Official's Name or ID No.", "Enter", "Cancel");
	        }
	        case 2:
	        {
	            new groups[1024], item;
				for (new i; i < MAX_GROUPS; i++)
				{
					if (arrGroupData[i][g_szGroupName][0] && arrGroupData[i][g_iGroupType] == 1 && arrGroupData[i][g_iAllegiance] == 1)
					{
						format(groups, sizeof(groups), "%s*%s\n", groups, arrGroupData[i][g_szGroupName]);
						ListItemTrackId[playerid][item++] = i;
					}
         			ShowPlayerDialog(playerid, MDC_MEMBERS, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Agency List", groups, "OK", "Cancel");
         		}
	        }
	        case 3: ShowPlayerDialog(playerid, MDC_MESSAGE, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | MDC Message", "Enter recipient's Name or ID No.", "OK", "Cancel");
		    case 4: ShowPlayerDialog(playerid, MDC_SMS, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | SMS", "Enter recipient's phone number.", "OK", "Cancel");
		}
	}
	if(dialogid == MDC_FIND && response)
	{
	    new giveplayerid;
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		if(sscanf(inputtext, "u", giveplayerid))
		{
			ShowPlayerDialog(playerid, MDC_FIND, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | LEO GPS Location", "Enter the Law Enforcment Official's Name or ID No.", "Enter", "Cancel");
			return 1;
		}

		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if(giveplayerid == playerid)
				{
				    ShowPlayerDialog(playerid, MDC_FIND, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: You cannot find yourself.\nEnter the Law Enforcment Official's Name or ID No.", "Enter", "Cancel");

					return 1;
				}
				if(IsACop(giveplayerid))
				{
	    			SetPlayerMarkerForPlayer(playerid,giveplayerid,FIND_COLOR);
                    FindingPlayer[playerid] = giveplayerid;
		    		FindTime[playerid] = 1;
		    		FindTimePoints[playerid] = 30;
		    	}
		    	else
		    	{
			    	SendClientMessageEx(playerid, COLOR_GRAD2, " You can only find other cops!");
		    	}
			}
		}
	}
	if(dialogid == MDC_CIVILIANS && response)
	{ //"*Check Record\n*View Arrest Reports\n*Licenses\n*Warrants\n*Issue Warrant\n*BOLO\n*Create BOLO\n*Delete"
		new WarrantString[512];
	 	if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		if(News[hTaken6] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd6], News[hContact6]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken7] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd7], News[hContact7]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken8] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd8], News[hContact8]);
		    strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken9] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd9], News[hContact9]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken10] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd10], News[hContact10]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken11] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd11], News[hContact11]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken12] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd12], News[hContact12]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken13] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd13], News[hContact13]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(strlen(WarrantString) == 0)
		{
		    strcat(WarrantString, "No Warrants at this time.", sizeof(WarrantString));
		}
		switch(listitem)
		{
		    case 0: ShowPlayerDialog(playerid, MDC_CHECK, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | Records Check", "Enter the Person's Name or ID No.", "Enter", "Cancel");
			case 1: ShowPlayerDialog(playerid, MDC_REPORTS, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | Reports Check", "Enter the Person's Name or ID No.", "Enter", "Cancel");
		    case 2: ShowPlayerDialog(playerid, MDC_LICENSES, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | License Check", "Enter the Person's Name or ID No.", "Enter", "Cancel");
			case 3: ShowPlayerDialog(playerid, MDC_WARRANTS, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Warrant List", WarrantString, "Enter", "Cancel");
			case 4: ShowPlayerDialog(playerid, MDC_ISSUE_SLOT, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Which Slot would you like to use?", "1\n2\n3\n4\n5\n6\n7\n8", "Enter", "Cancel");
		    case 5:
		    {
				new BOLOString[512];
				if(News[hTaken14] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd14], News[hContact14]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken15] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd15], News[hContact15]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken16] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd16], News[hContact16]);
				    strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken17] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd17], News[hContact17]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken18] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd18], News[hContact18]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken19] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd19], News[hContact19]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken20] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd20], News[hContact20]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken21] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd21], News[hContact21]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(strlen(BOLOString) == 0)
				{
				    strcat(BOLOString, "No BOLOs at this time.", sizeof(BOLOString));
				}
				ShowPlayerDialog(playerid, MDC_BOLOLIST, DIALOG_STYLE_LIST, "SA-MDC - Logged In | BOLO List", BOLOString, "OK", "Cancel");
		    }
		    case 6:
		    {
		    	ShowPlayerDialog(playerid, MDC_BOLO_SLOT, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Which Slot would you like to use?", "1\n2\n3\n4\n5\n6\n7\n8", "Enter", "Cancel");
		    }
		    case 7:
	        {
	        	ShowPlayerDialog(playerid, MDC_DELETE, DIALOG_STYLE_LIST, "SA-MDC - Logged In | Delete", "*BOLO\n*Warrant", "OK", "Cancel");
	        }
		}

	}
	if(dialogid == MDC_MEMBERS && response)
	{
	    if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new MemberString[1024], giveplayer[MAX_PLAYER_NAME];
		new rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN], employer[GROUP_MAX_NAME_LEN];
		new group = ListItemTrackId[playerid][listitem];
		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pMember] == group)
				{
					GetPlayerGroupInfo(i, rank, division, employer);
					giveplayer = GetPlayerNameEx(i);
					format(string, sizeof(string), "* %s (%s) %s Ph: %d\n", rank, division,  giveplayer, PlayerInfo[i][pPnumber]);
					strcat(MemberString, string, sizeof(MemberString));
				}
			}	
		}
		if(strlen(MemberString) == 0)
		{
		    strcat(MemberString, "No Members online at this time.", sizeof(MemberString));
		}
		format(string, sizeof(string), "SA-MDC - Logged in | %s Members", arrGroupData[group][g_szGroupName]);
		ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_LIST, string, MemberString, "Select", "Cancel");
	}
	if(dialogid == MDC_WARRANTS && response)
	{
	    if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
	    ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Warrants", inputtext, "OK", "Back");
	}
	if(dialogid == MDC_BOLOLIST && response)
	{
	    if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
	    ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | BOLO Hot Sheet", inputtext, "OK", "Back");
	}
/*	if(dialogid == MDC_CHECK && response)
	{
	    if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new giveplayerid = ReturnUser(inputtext);
		new HistoryString[1024];
		new giveplayer[MAX_PLAYER_NAME];
		giveplayer = GetPlayerNameEx(giveplayerid);
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			format(string, sizeof(string), "Name : %s\n", GetPlayerNameEx(giveplayerid));
			strcat(HistoryString, string, sizeof(HistoryString));
			format(string, sizeof(string), "Crime : %s\n", PlayerCrime[giveplayerid][pAccusedof]);
			strcat(HistoryString, string, sizeof(HistoryString));
			format(string, sizeof(string), "Claimant : %s\n", PlayerCrime[giveplayerid][pVictim]);
			strcat(HistoryString, string, sizeof(HistoryString));
			format(string, sizeof(string), "Reported : %s\n", PlayerCrime[giveplayerid][pAccusing]);
			strcat(HistoryString, string, sizeof(HistoryString));
			format(string, sizeof(string), "Accused : %s\n", PlayerCrime[giveplayerid][pBplayer]);
			strcat(HistoryString, string, sizeof(HistoryString));
			if(PlayerInfo[giveplayerid][pProbationTime] != 0)
			{
			    format(string, sizeof(string), "Probation : %d minutes left\n", PlayerInfo[giveplayerid][pProbationTime]);
				strcat(HistoryString, string, sizeof(HistoryString));
			}
			for(new i=0; i<MAX_PLAYERVEHICLES; i++)
        	{
		    	if(PlayerVehicleInfo[giveplayerid][i][pvTicket] != 0)
				{
            	    format(string, sizeof(string), "Vehicle registration: %d | Vehicle Name: %s | Ticket: $%d.\n",PlayerVehicleInfo[giveplayerid][i][pvId],GetVehicleName(PlayerVehicleInfo[giveplayerid][i][pvId]),PlayerVehicleInfo[giveplayerid][i][pvTicket]);
					strcat(HistoryString, string, sizeof(HistoryString));
		    	}
	    	}
	    	ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Criminal History", HistoryString, "OK", "Cancel");
			format(string, sizeof(string), "** DISPATCH: %s has run a check for warrants on %s **", GetPlayerNameEx(playerid), giveplayer);
			SendRadioMessage(1, COLOR_DBLUE, string);
			SendRadioMessage(2, COLOR_DBLUE, string);
			SendRadioMessage(3, COLOR_DBLUE, string);
			return 1;
		}
		else
		{
			ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | ERROR ", "There is no record of that person.", "OK", "Cancel");
			return 1;
		}
	}*/
	if(dialogid == MDC_REPORTS && response)
	{
	    if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new giveplayerid = ReturnUser(inputtext);
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			DisplayReports(playerid, giveplayerid);
			format(string, sizeof(string), "** DISPATCH: %s has run a check for arrest reports on %s **", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
			SendGroupMessage(1, COLOR_DBLUE, string);
			return 1;
		}
		else
		{
			ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | ERROR ", "There is no record of that person.", "OK", "Cancel");
			return 1;
		}
	}
	if(dialogid == MDC_SHOWREPORTS && response)
	{
		new stpos = strfind(inputtext, "(");
	    new fpos = strfind(inputtext, ")");
	    new reportidstr[6], repid;
	    strmid(reportidstr, inputtext, stpos+1, fpos);
	    repid = strval(reportidstr);
		return DisplayReport(playerid, repid);
	}
	if(dialogid == DIALOG_JFINECONFIRM)
	{
		if(response)
		{
			SetPVarInt(playerid, "jGroup", listitem);
			format(string, sizeof(string), "Are you sure you want to send a portion of the fine to %s?", arrGroupData[listitem][g_szGroupName]);
			ShowPlayerDialog(playerid, DIALOG_JFINE, DIALOG_STYLE_MSGBOX, "Judge Fine - Confirm", string, "Confirm", "Cancel"); 
		}
		else {
			DeletePVar(playerid, "jGroup");
			DeletePVar(playerid, "jfined");
			DeletePVar(playerid, "judgefine");
			DeletePVar(playerid, "jreason");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Fine Cancelled - retype the judge fine command to start again.");
		}
	}
	if(dialogid == DIALOG_JFINE)
	{
		if(response)
		{
			new iGroupID = GetPVarInt(playerid, "jGroup");
			new giveplayerid = GetPVarInt(playerid, "jfined");
			new judgefine = GetPVarInt(playerid, "judgefine");
			new reason[64];
			GetPVarString(playerid, "jreason", reason, 64);
			new Judicial, Group, Gov;
			GivePlayerCash(giveplayerid, -judgefine);
			Judicial = floatround( judgefine * 0.10 ); // Judicials cut - 10%
			Group = floatround ( judgefine * 0.6);  // Arresting Groups Cut - 60%
			Gov = floatround ( judgefine * 0.10);  //  Government cut = 10%
			// 20% Deleted from economy
			Tax += Gov;
			arrGroupData[PlayerInfo[playerid][pMember]][g_iBudget] += Judicial;
			arrGroupData[iGroupID][g_iBudget] += Group;
			new str[128], file[32];
			new month, day, year;
			getdate(year,month,day);
			format(str, sizeof(str), "%s has been fined by $%s by Judge %s.  $%s has been sent to the %s Vault.",GetPlayerNameEx(giveplayerid), number_format(judgefine), GetPlayerNameEx(playerid), number_format(Judicial), arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
			format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", PlayerInfo[playerid][pMember], month, day, year);
			Log(file, str);
			format(str, sizeof(str), "%s has been fined by $%s by Judge %s.  $%s has been sent to the %s Vault.",GetPlayerNameEx(giveplayerid), number_format(judgefine), GetPlayerNameEx(playerid), number_format(Judicial), arrGroupData[iGroupID][g_szGroupName]);
			format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
			Log(file, str);
			for(new z; z < MAX_GROUPS; z++)
			{
				if(arrGroupData[z][g_iAllegiance] == 1)
				{
					if(arrGroupData[z][g_iGroupType] == 5)
					{
						format(str, sizeof(str), "%s has been fined by $%s by Judge %s.  $%s has been sent to the SA Government Vault.",GetPlayerNameEx(giveplayerid), number_format(judgefine), GetPlayerNameEx(playerid), number_format(Gov));
						format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
						Log(file, str);
						break;
					}
				}
			}
			format(string, sizeof(string), "You have fined %s $%s, reason: %s", GetPlayerNameEx(giveplayerid), number_format(judgefine), reason);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "You have been fined $%s by %s, reason: %s", number_format(judgefine), GetPlayerNameEx(playerid), reason);
			SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s has been fined $%s by Judge %s.  Commission has been sent to %s.", GetPlayerNameEx(giveplayerid), number_format(judgefine), GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
			ABroadCast( COLOR_YELLOW, string, 2);
			Log("logs/rpspecial.log", string);
		}
	}
	if(dialogid == DIALOG_ARRESTREPORT)
	{
		if(response)
		{
			new moneys = GetPVarInt(playerid, "Arrest_Price"), time = GetPVarInt(playerid, "Arrest_Time"),
			bail = GetPVarInt(playerid, "Arrest_Bail"), bailprice = GetPVarInt(playerid, "Arrest_BailPrice"), 
			suspect = GetPVarInt(playerid, "Arrest_Suspect"), arresttype = GetPVarInt(playerid, "Arrest_Type"),
			query[1100];
			if(strlen(inputtext) < 30 || strlen(inputtext) > 128)
			{
				format(query, sizeof(query), "Please write a brief arrest report on how %s acted during the arrest.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(suspect));
				return ShowPlayerDialog(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", query, "Submit", "");
			}
			switch(arresttype)
			{
				case 0, 1: { //arrest
					if(bail && bailprice > 0)
					{
						format(string, sizeof(string), "You have been given the option to post bail.  Your bail is set at $%s. (/bail)", number_format(bailprice));
						SendClientMessageEx(suspect, COLOR_RED, string);
						JailPrice[suspect] = bailprice;
					}
					format(string, sizeof(string), "* You have sent %s to the Local PD Jail.", GetPlayerNameEx(suspect));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					GivePlayerCash(suspect, -moneys);
					new money = floatround(moneys / 3), iGroupID = PlayerInfo[playerid][pMember];
					arrGroupData[iGroupID][g_iBudget] += money;
					new str[128], file[32];
					format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to %s's budget fund.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money, arrGroupData[iGroupID][g_szGroupName]);
					new month, day, year;
					getdate(year,month,day);
					format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
					Log(file, str);
					for(new z; z < MAX_GROUPS; z++)
					{
						if(arrGroupData[iGroupID][g_iAllegiance] == 1)
						{
							if(arrGroupData[z][g_iAllegiance] == 1)
							{
								if(arrGroupData[z][g_iGroupType] == 5)
								{
									Tax += money;
									format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to the SA Government Vault.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money);
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
						else if(arrGroupData[z][g_iAllegiance] == 2)
						{
							if(arrGroupData[z][g_iAllegiance] == 2)
							{
								if(arrGroupData[z][g_iGroupType] == 5)
								{
									TRTax += money;
									format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to the TR Government Vault.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money);
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
					}
					ResetPlayerWeaponsEx(suspect);
					for(new x; x < MAX_PLAYERVEHICLES; x++) if(PlayerVehicleInfo[suspect][x][pvTicket] >= 1) {
						PlayerVehicleInfo[suspect][x][pvTicket] = 0;
					}
					SetPlayerInterior(suspect, 10);
					new rand = random(sizeof(LSPDJailSpawns));
					SetPlayerFacingAngle(suspect, LSPDJailSpawns[rand][3]);
					SetPlayerPos(suspect, LSPDJailSpawns[rand][0], LSPDJailSpawns[rand][1], LSPDJailSpawns[rand][2]);
					if(PlayerInfo[suspect][pDonateRank] >= 2)
					{
						PlayerInfo[suspect][pJailTime] = ((time*60)*75)/100;
					}
					else
					{
						PlayerInfo[suspect][pJailTime] = time * 60;
					}
					DeletePVar(suspect, "IsFrozen");
					PhoneOnline[suspect] = 1;
					PlayerInfo[suspect][pArrested] += 1;
					SetPlayerFree(suspect,playerid, "was arrested");
					PlayerInfo[suspect][pWantedLevel] = 0;
					SetPlayerToTeamColor(suspect);
					SetPlayerWantedLevel(suspect, 0);
					WantLawyer[suspect] = 1;
					TogglePlayerControllable(suspect, 1);
					ClearAnimations(suspect);
					SetPlayerSpecialAction(suspect, SPECIAL_ACTION_NONE);
					PlayerCuffed[suspect] = 0;
					DeletePVar(suspect, "PlayerCuffed");
					PlayerCuffedTime[suspect] = 0;
					PlayerInfo[suspect][pVW] = 0;
					SetPlayerVirtualWorld(suspect, 0);
					strcpy(PlayerInfo[suspect][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
					strcpy(PlayerInfo[suspect][pPrisonReason], "[IC] Local Arrest", 128);
					SetPlayerToTeamColor(suspect);
					Player_StreamPrep(suspect, LSPDJailSpawns[rand][0], LSPDJailSpawns[rand][1], LSPDJailSpawns[rand][2], FREEZE_TIME);
				}
				case 2: { // /docarrest
					format(string, sizeof(string), "* You have sent %s to DoC.", GetPlayerNameEx(suspect));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					GivePlayerCash(suspect, -moneys);
					new money = floatround(moneys / 3), iGroupID = PlayerInfo[playerid][pMember];
					arrGroupData[iGroupID][g_iBudget] += money;
					new str[128], file[32];
					format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to %s's budget fund.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money, arrGroupData[iGroupID][g_szGroupName]);
					new month, day, year;
					getdate(year,month,day);
					format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
					Log(file, str);
					for(new z; z < MAX_GROUPS; z++)
					{
						if(arrGroupData[iGroupID][g_iAllegiance] == 1)
						{
							if(arrGroupData[z][g_iAllegiance] == 1)
							{
								if(arrGroupData[z][g_iGroupType] == 5)
								{
									Tax += money;
									format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to the SA Government Vault.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money);
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
						else if(arrGroupData[z][g_iAllegiance] == 2)
						{
							if(arrGroupData[z][g_iAllegiance] == 2)
							{
								if(arrGroupData[z][g_iGroupType] == 5)
								{
									TRTax += money;
									format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to the TR Government Vault.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money);
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
					}
					ResetPlayerWeaponsEx(suspect);
					for(new x; x < MAX_PLAYERVEHICLES; x++) if(PlayerVehicleInfo[suspect][x][pvTicket] >= 1) {
						PlayerVehicleInfo[suspect][x][pvTicket] = 0;
					}
					SetPlayerInterior(suspect, 10);
					new rand = random(sizeof(DocPrison));
					SetPlayerFacingAngle(suspect, 0);
					SetPlayerPos(suspect, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
					if(PlayerInfo[suspect][pDonateRank] >= 2)
					{
						PlayerInfo[suspect][pJailTime] = ((time*60)*75)/100;
					}
					else
					{
						PlayerInfo[suspect][pJailTime] = time * 60;
					}
					DeletePVar(suspect, "IsFrozen");
					PhoneOnline[suspect] = 1;
					PlayerInfo[suspect][pArrested] += 1;
					SetPlayerFree(suspect,playerid, "was arrested");
					PlayerInfo[suspect][pWantedLevel] = 0;
					SetPlayerToTeamColor(suspect);
					SetPlayerWantedLevel(suspect, 0);
					WantLawyer[suspect] = 1;
					TogglePlayerControllable(suspect, 1);
					ClearAnimations(suspect);
					SetPlayerSpecialAction(suspect, SPECIAL_ACTION_NONE);
					PlayerCuffed[suspect] = 0;
					DeletePVar(suspect, "PlayerCuffed");
					PlayerCuffedTime[suspect] = 0;
					PlayerInfo[suspect][pVW] = 0;
					SetPlayerVirtualWorld(suspect, 0);
					SetPlayerHealth(suspect, 100);
					strcpy(PlayerInfo[suspect][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
					strcpy(PlayerInfo[suspect][pPrisonReason], "[IC] EBCF Arrest", 128);
					SetPlayerToTeamColor(suspect);
					Player_StreamPrep(suspect, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);
				}
			}
			format(query, sizeof(query), "INSERT INTO `arrestreports` (`copid`, `suspectid`, `shortreport`) VALUES ('%d', '%d', '%s')", GetPlayerSQLId(playerid), GetPlayerSQLId(suspect), g_mysql_ReturnEscaped(inputtext, MainPipeline));
			mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			DeletePVar(playerid, "Arrest_Price");
			DeletePVar(playerid, "Arrest_Time");
			DeletePVar(playerid, "Arrest_Bail");
			DeletePVar(playerid, "Arrest_BailPrice");
			DeletePVar(playerid, "Arrest_Suspect");
		}
	}
	if(dialogid == MDC_CHECK && response)
	{
	    if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new giveplayerid = ReturnUser(inputtext);
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			DisplayCrimes(playerid, giveplayerid);
			format(string, sizeof(string), "** DISPATCH: %s has run a check for warrants on %s **", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
			SendGroupMessage(1, COLOR_DBLUE, string);
			return 1;
		}
		else
		{
			ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | ERROR ", "There is no record of that person.", "OK", "Cancel");
			return 1;
		}
	}
	if(dialogid == MDC_LICENSES && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new giveplayerid;
		if(sscanf(inputtext, "u", giveplayerid))
		{
			ShowPlayerDialog(playerid, MDC_LICENSES, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | License Check", "Enter the Person's Name or ID No.", "Enter", "Cancel");
			return 1;
		}
		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    new LicenseString[256], giveplayer[MAX_PLAYER_NAME];
				GetPlayerName(playerid, sendername, sizeof(sendername));
				GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
				new text1[20];
				new text2[20];
				new text3[20];
				new text4[20];
				if(PlayerInfo[giveplayerid][pCarLic] == 0) { text1 = "Not Passed"; }
				if(PlayerInfo[giveplayerid][pCarLic] == 1) { text1 = "Passed"; }
				if(PlayerInfo[giveplayerid][pCarLic] == 2) { text1 = "Suspended"; }
				if(PlayerInfo[giveplayerid][pCarLic] == 3) { text1 = "Cancelled"; }
				if(PlayerInfo[giveplayerid][pFlyLic]) { text4 = "Passed"; } else { text4 = "Not Passed"; }
				if(PlayerInfo[giveplayerid][pBoatLic]) { text2 = "Passed"; } else { text2 = "Not Passed"; }
	   			if(PlayerInfo[giveplayerid][pGunLic]) { text3 = "Passed"; } else { text3 = "Not Passed"; }
				format(string, sizeof(string), "   Name: %s\n", giveplayer);
				strcat(LicenseString, string, sizeof(LicenseString));
				format(string, sizeof(string), "-Drivers License: %s.\n", text1);
				strcat(LicenseString, string, sizeof(LicenseString));
				format(string, sizeof(string), "-Flying License: %s.\n", text4);
				strcat(LicenseString, string, sizeof(LicenseString));
				format(string, sizeof(string), "-Sailing License: %s.\n", text2);
				strcat(LicenseString, string, sizeof(LicenseString));
				format(string, sizeof(string), "-Weapon License: %s.\n", text3);
				strcat(LicenseString, string, sizeof(LicenseString));
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Criminal History", LicenseString, "OK", "Cancel");
				format(string, sizeof(string), "** DISPATCH: %s has ran a license check on %s **", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				SendGroupMessage(1, COLOR_DBLUE, string);
				return 1;
			}
			else return ShowPlayerDialog(playerid, MDC_LICENSES, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | Error!", "ERROR: Invalid Name or ID No.\nEnter the Person's Name or ID No.", "Enter", "Cancel");
		}
		else return ShowPlayerDialog(playerid, MDC_LICENSES, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | Error!", "ERROR: Invalid Name or ID No.\nEnter the Person's Name or ID No.", "Enter", "Cancel");
	}
	if(dialogid == MDC_MESSAGE && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new giveplayerid;
		if(sscanf(inputtext, "u", giveplayerid))
		{
			return ShowPlayerDialog(playerid, MDC_MESSAGE, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | Error!", "ERROR: Invalid Recipient\nEnter recipient's Name or ID No.", "OK", "Cancel");
		}
		if (IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    format(string, sizeof(string), " Enter your message to %s ", GetPlayerNameEx(giveplayerid));
            	ShowPlayerDialog(playerid, MDC_MESSAGE_2, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | MDC Message", string, "OK", "Cancel");
            	SetPVarInt(playerid, "MDCMessageRecipient", giveplayerid);
			}
			else  return ShowPlayerDialog(playerid, MDC_MESSAGE, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | Error!", "ERROR: Invalid Recipient\nEnter recipient's Name or ID No.", "OK", "Cancel");
		}
		else return ShowPlayerDialog(playerid, MDC_MESSAGE, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | Error!", "ERROR: Invalid Recipient\nEnter recipient's Name or ID No.", "OK", "Cancel");
	}
	if(dialogid == MDC_SMS && response)
	{
		if(isnull(inputtext) || strval(inputtext) == 0)
		{
			return ShowPlayerDialog(playerid, MDC_SMS, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | Error!", "ERROR: Invalid Phone Number\nEnter Recipient's Phone Number", "OK", "Cancel");
		}
		new phonenumb = strval(inputtext);
		format(string, sizeof(string), " Enter your message to %d ", phonenumb);
        ShowPlayerDialog(playerid, MDC_SMS_2, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | SMS Message", string, "OK", "Cancel");
        SetPVarInt(playerid, "SMSMessageRecipient", phonenumb);
	}
	if(dialogid == MDC_MESSAGE_2 && response)
	{
		new giveplayerid = GetPVarInt(playerid, "MDCMessageRecipient");
	    if(giveplayerid == INVALID_PLAYER_ID) return ShowPlayerDialog(playerid, MDC_MESSAGE, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | Error!", "ERROR: Invalid Recipient\nEnter recipient's Name or ID No.", "OK", "Cancel");
		if(giveplayerid == playerid)
		{
			ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | ERROR ", "You cannot send messages to yourself!", "OK", "Cancel");
			return 1;
		}
		if(ConnectedToPC[giveplayerid] == 1337 || IsPlayerInAnyVehicle(giveplayerid))
		{
	 		if(!IsMDCPermitted(giveplayerid))
			{
				return ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | ERROR ", "That person is not logged into the MDC.", "OK", "Cancel");
			}
			if(!strlen(inputtext))
			{
				return ShowPlayerDialog(playerid, MDC_MESSAGE_2, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | Error!", "ERROR: You must type a message!\nEnter Recipient's Name or ID No.", "OK", "Cancel");
			}
			format(string, sizeof(string), "MDC Message sent to %s:\n%s", GetPlayerNameEx(giveplayerid), inputtext);
			ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Message Sent! ", string, "OK", "Cancel");
			if(ConnectedToPC[giveplayerid] == 1337)
			{
				format(string, sizeof(string), "MDC Message from %s:\n%s", GetPlayerNameEx(playerid), inputtext);
				ShowPlayerDialog(giveplayerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | New Message!", string, "OK", "Cancel");
				format(string, sizeof(string), "MDC Message from %s: %s", GetPlayerNameEx(playerid), inputtext);
				SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);
			}
			else
			{
				format(string, sizeof(string), "MDC Message from %s:\n%s", GetPlayerNameEx(playerid), inputtext);
				ShowPlayerDialog(giveplayerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | New Message! ", string, "OK", "Cancel");
			}
		}
		else
		{
			ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | ERROR ", "That officer is not logged into the MDC.", "OK", "Cancel");
			return 1;
		}
		return 1;
	}
	if(dialogid == MDC_SMS_2 && response)
	{
		new phonenumb = GetPVarInt(playerid, "SMSMessageRecipient");
		if(!strlen(inputtext))
		{
			return ShowPlayerDialog(playerid, MDC_SMS_2, DIALOG_STYLE_INPUT, "SA-MDC - Logged In | Error!", "ERROR: You must type a message!\nEnter Recipient's Phone Number", "OK", "Cancel");
		}
		if(phonenumb == 555)
		{
			if(strcmp("yes", inputtext, true) == 0) {
				SendClientMessageEx(playerid, COLOR_WHITE, "Text Message Delivered.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: I have no idea what you're talking about, Sender: MOLE (555)");
				//SendAudioToPlayer(playerid, 47, 100);
				RingTone[playerid] = 20;
				return 0;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: A simple 'yes' will do, Sender: MOLE (555)");
				//SendAudioToPlayer(playerid, 47, 100);
				RingTone[playerid] = 20;
				//ChatLog(string);
				return 0;
			}
		}
		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pPnumber] == phonenumb && phonenumb != 0)
				{
					Mobile[playerid] = i; //caller connecting
					if(PhoneOnline[i] > 0)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "That player's phone is switched off.");
						return 1;
					}
					format(string, sizeof(string), "SMS: %s, Sender: %s (Ph:%d)", inputtext,GetPlayerNameEx(playerid),PlayerInfo[playerid][pPnumber]);
					GetPlayerName(i, sendername, sizeof(sendername));
					RingTone[i] =20;
					ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Message Sent! ", string, "OK", "Cancel");
					SendClientMessageEx(i, COLOR_YELLOW, string);
					//PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					//SendAudioToPlayer(playerid, 47, 100);
					Mobile[playerid] = 255;
					return 1;
				}
			}	
		}
		ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Message Delivery Failed! ", "Message Delivery Failed. Try Again", "OK", "Cancel");
	}
	if(dialogid == MDC_BOLO && response)
	{
		new x_nr = GetPVarInt(playerid, "BOLOISSUESLOT");
		if(x_nr == 1)
		{
			if(News[hTaken14] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd14], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact14], string, 0, strlen(string), 255);
				News[hTaken14] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 1 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 2)
		{
			if(News[hTaken15] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd15], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact15], string, 0, strlen(string), 255);
				News[hTaken15] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 2 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 3)
		{
			if(News[hTaken16] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd16], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact16], string, 0, strlen(string), 255);
				News[hTaken16] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 3 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 4)
		{
			if(News[hTaken17] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd17], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact17], string, 0, strlen(string), 255);
				News[hTaken17] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 4 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 5)
		{
			if(News[hTaken18] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd18], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact18], string, 0, strlen(string), 255);
				News[hTaken18] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 5 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 6)
		{
			if(News[hTaken19] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd19], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact19], string, 0, strlen(string), 255);
				News[hTaken19] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 6 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 7)
		{
			if(News[hTaken20] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd20], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact20], string, 0, strlen(string), 255);
				News[hTaken20] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 7 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 8)
		{
			if(News[hTaken21] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd21], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact21], string, 0, strlen(string), 255);
				News[hTaken21] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 8 is already Taken!", "OK", "Back");
				return 1;
			}
		}
	}
	if(dialogid == MDC_BOLO_SLOT && response)
	{
	    SetPVarInt(playerid, "BOLOISSUESLOT", listitem + 1);
	    ShowPlayerDialog(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | Issue Warrant", "Enter BOLO Details", "Enter", "Cancel");
	}
	if(dialogid == MDC_ISSUE_SLOT && response)
	{
	    SetPVarInt(playerid, "ISSUESLOT", listitem + 1);
	    ShowPlayerDialog(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | Issue Warrant", "Enter Arrest Warrant Details", "Enter", "Cancel");
	}
	if(dialogid == MDC_END_ID && response)
	{
		ShowPlayerDialog(playerid, MDC_MAIN, DIALOG_STYLE_LIST, "SA-MDC - Logged in", "*Civilian Information\n*Find LEO\n*Law Enforcement Agencies\n*MDC Message\n*SMS", "OK", "Cancel");
	}
	if(dialogid == MDC_ISSUE && response)
	{
		new x_nr = GetPVarInt(playerid, "ISSUESLOT");
		if(x_nr == 1)
		{
			if(News[hTaken6] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd6], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact6], string, 0, strlen(string), 255);
				News[hTaken6] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 1 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 2)
		{
			if(News[hTaken7] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd7], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact7], string, 0, strlen(string), 255);
				News[hTaken7] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 2 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 3)
		{
			if(News[hTaken8] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd8], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact8], string, 0, strlen(string), 255);
				News[hTaken8] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 3 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 4)
		{
			if(News[hTaken9] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd9], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact9], string, 0, strlen(string), 255);
				News[hTaken9] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 4 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 5)
		{
			if(News[hTaken10] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd10], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact10], string, 0, strlen(string), 255);
				News[hTaken10] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 5 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 6)
		{
			if(News[hTaken11] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd11], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact11], string, 0, strlen(string), 255);
				News[hTaken11] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 6 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 7)
		{
			if(News[hTaken12] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd12], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact12], string, 0, strlen(string), 255);
				News[hTaken12] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 7 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 8)
		{
			if(News[hTaken13] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialog(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "SA-MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd13], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact13], string, 0, strlen(string), 255);
				News[hTaken13] = 1;
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(1, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialog(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "SA-MDC - Logged in | Error! ", "Spot 8 is already Taken!", "OK", "Back");
				return 1;
			}
		}
	}
	if(dialogid == MDC_DELETE && response)
	{
	    if(listitem == 0)
	    {
	    	ShowPlayerDialog(playerid, MDC_DEL_BOLO, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Which BOLO Slot would you like to delete?", "1\n2\n3\n4\n5\n6\n7\n8\nALL", "Enter", "Cancel");
	    }
		if(listitem == 1)
		{
			ShowPlayerDialog(playerid, MDC_DEL_WARRANT, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Which Warrant Slot would you like to delete?", "1\n2\n3\n4\n5\n6\n7\n8\nALL", "Enter", "Cancel");
		}
	}
	if(dialogid == MDC_DEL_BOLO && response)
	{
		new string1[MAX_PLAYER_NAME];
		if(isnull(inputtext))
		{
			ShowPlayerDialog(playerid, MDC_DEL_WARRANT, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Which Warrant Slot would you like to delete?", "1\n2\n3\n4\n5\n6\n7\n8\nALL", "Enter", "Cancel");
			return 1;
		}
		if(strcmp(inputtext, "1") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd14], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact14], string1, 0, strlen(string1), 255);
			News[hTaken14] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (1) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "2") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd15], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact15], string1, 0, strlen(string1), 255);
			News[hTaken15] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (2) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "3") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd16], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact16], string1, 0, strlen(string1), 255);
			News[hTaken16] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (3) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "4") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd17], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact17], string1, 0, strlen(string1), 255);
			News[hTaken17] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (4) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "5") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd18], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact18], string1, 0, strlen(string1), 255);
			News[hTaken18] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (5) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "6") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd19], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact19], string1, 0, strlen(string1), 255);
			News[hTaken19] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (6) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "7") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd20], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact20], string1, 0, strlen(string1), 255);
			News[hTaken20] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (7) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "8") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd21], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact21], string1, 0, strlen(string1), 255);
			News[hTaken21] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (8) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext,"all",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd14], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact14], string1, 0, strlen(string1), 255);
			News[hTaken14] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd15], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact15], string1, 0, strlen(string1), 255);
			News[hTaken15] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd16], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact16], string1, 0, strlen(string1), 255);
			News[hTaken16] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd17], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact17], string1, 0, strlen(string1), 255);
			News[hTaken17] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd18], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact18], string1, 0, strlen(string1), 255);
			News[hTaken18] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd19], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact19], string1, 0, strlen(string1), 255);
			News[hTaken19] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd20], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact20], string1, 0, strlen(string1), 255);
			News[hTaken20] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd21], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact21], string1, 0, strlen(string1), 255);
			News[hTaken21] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted all the details for Be on the Lookout from the MDC -BOLO.");
			return 1;
		}
	}
	if(dialogid == MDC_DEL_WARRANT && response)
	{
	    new string1[MAX_PLAYER_NAME];
		if(isnull(inputtext))
		{
			ShowPlayerDialog(playerid, MDC_DEL_WARRANT, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Which Warrant Slot would you like to delete?", "1\n2\n3\n4\n5\n6\n7\n8\nALL", "Enter", "Cancel");
			return 1;
		}
		if(strcmp(inputtext,"1",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd6], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact6], string1, 0, strlen(string1), 255);
			News[hTaken6] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (1) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"2",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd7], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact7], string1, 0, strlen(string1), 255);
			News[hTaken7] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (2) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"3",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd8], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact8], string1, 0, strlen(string1), 255);
			News[hTaken8] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (3) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"4",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd9], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact9], string1, 0, strlen(string1), 255);
			News[hTaken9] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (4) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"5",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd10], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact10], string1, 0, strlen(string1), 255);
			News[hTaken10] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (5) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"6",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd11], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact11], string1, 0, strlen(string1), 255);
			News[hTaken11] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (6) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"7",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd12], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact12], string1, 0, strlen(string1), 255);
			News[hTaken12] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (7) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"8",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd13], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact13], string1, 0, strlen(string1), 255);
			News[hTaken13] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (8) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"all",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd6], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact6], string1, 0, strlen(string1), 255);
			News[hTaken6] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd7], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact7], string1, 0, strlen(string1), 255);
			News[hTaken7] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd8], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact8], string1, 0, strlen(string1), 255);
			News[hTaken8] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd9], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact9], string1, 0, strlen(string1), 255);
			News[hTaken9] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd10], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact10], string1, 0, strlen(string1), 255);
			News[hTaken10] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd11], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact11], string1, 0, strlen(string1), 255);
			News[hTaken11] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd12], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact12], string1, 0, strlen(string1), 255);
			News[hTaken12] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd13], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact13], string1, 0, strlen(string1), 255);
			News[hTaken13] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted all the details for Arrest Warrants from the MDC -Warrants.");
			return 1;
		}
	}
	if(dialogid == MDC_LOGOUT && response)
	{
	}
	if(dialogid == MDC_CREATE && response)
	{
	}
	if( (dialogid >= MDC_START_ID && dialogid <= MDC_END_ID) && !response)
	{
	    if(dialogid == MDC_MAIN)
	    {
	        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are now logged off the MDC.");
			ConnectedToPC[playerid] = 0;
	    }
	    else
		{
			ShowPlayerDialog(playerid, MDC_MAIN, DIALOG_STYLE_LIST, "SA-MDC - Logged in", "*Civilian Information\n*Find LEO\n*Law Enforcement Agencies\n*MDC Message\n*SMS", "OK", "Cancel");
		}
	}
	if((dialogid == SELLVIP))
	{
		new
			iTargetID = GetPVarInt(playerid, "VIPSell"),
			iPrice = GetPVarInt(playerid, "VIPCost"),
			logstring[156];

	    if(response)
	    {

	        if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "The other person has disconnected.");
			new iTargetName[MAX_PLAYER_NAME];
			GetPVarString(playerid, "VIPSeller", iTargetName, sizeof(iTargetName));
			if(strcmp(iTargetName, GetPlayerNameEx(iTargetID)) != 0) {
                return SendClientMessageEx(playerid, COLOR_GREY, "The other person has disconnected.");
			}
	        new	viptype[7];
	        if(GetPlayerCash(playerid) >= iPrice)
	        {
	            if(PlayerInfo[iTargetID][pDonateRank] == 3)
	            {
                    PlayerInfo[iTargetID][pGVip] = 0;
                    PlayerInfo[playerid][pGVip] = 1;
	            }
	        	//Player buying the VIP
	        	GivePlayerCash(playerid, -GetPVarInt(playerid, "VIPCost"));
	        	PlayerInfo[playerid][pDonateRank] = PlayerInfo[iTargetID][pDonateRank];
	        	PlayerInfo[playerid][pVIPExpire] = PlayerInfo[iTargetID][pVIPExpire];
                PlayerInfo[playerid][pTempVIP] = 0;
				PlayerInfo[playerid][pBuddyInvited] = 0;
				
				LoadPlayerDisabledVehicles(iTargetID);

	        	if(PlayerInfo[playerid][pVIPM] != 0)
	        	{
	        	    PlayerInfo[playerid][pVIPMO] = PlayerInfo[playerid][pVIPM];
	        	}
	        	PlayerInfo[playerid][pVIPM] = PlayerInfo[iTargetID][pVIPM];

	        	// person selling the vip
	        	GivePlayerCash(iTargetID, GetPVarInt(playerid, "VIPCost"));
	        	PlayerInfo[iTargetID][pDonateRank] = 0;
				PlayerInfo[iTargetID][pVIPExpire] = 0;
				PlayerInfo[iTargetID][pVIPMO] = PlayerInfo[iTargetID][pVIPM];
				PlayerInfo[iTargetID][pVIPM] = 0;
				switch(PlayerInfo[playerid][pDonateRank])
        		{
        		    case 1: viptype = "Bronze";
        		    case 2: viptype = "Silver";
        		    case 3: viptype = "Gold";
  					default: viptype = "Error";
        		}
				format(string, sizeof(string), "You have purchased %s VIP from %s for $%d which will expire on %s.", viptype, GetPlayerNameEx(iTargetID), iPrice, date(PlayerInfo[playerid][pVIPExpire], 2));
				SendClientMessage(playerid, COLOR_WHITE, string);
            	format(string, sizeof(string), "You have sold your %s VIP to %s for $%d.", viptype, GetPlayerNameEx(playerid), iPrice);
				SendClientMessage(iTargetID, COLOR_WHITE, string);
				new iYear, iMonth, iDay, szIP[16], szIP2[16];
				getdate(iYear, iMonth, iDay);
				GetPlayerIp(iTargetID, szIP, sizeof(szIP));
				GetPlayerIp(playerid, szIP2, sizeof(szIP2));
				format(logstring, sizeof(logstring), "[SELLVIP] %s (IP:%s) has sold %s VIP to %s (IP:%s) for $%d. (VIPM: %d) - (%d/%d/%d)", GetPlayerNameEx(iTargetID),szIP, viptype, GetPlayerNameEx(playerid), szIP2, iPrice, PlayerInfo[playerid][pVIPM], iMonth,iDay,iYear);
				Log("logs/shoplog.log", logstring);

				PlayerInfo[playerid][pVIPSold] = gettime() + 7200;
				PlayerInfo[iTargetID][pVIPSold] = gettime() + 7200;
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GREY, "You don't have enough cash to purchase it!");
			    SendClientMessage(iTargetID, COLOR_GREY, "He did not have enough cash to purchase it!");
			}
			DeletePVar(playerid, "VIPSell");
			DeletePVar(playerid, "VIPCost");
	    }
	    else
	    {
	        format(string, sizeof(string), "You have declined the offer to purchase VIP from %s.", GetPlayerNameEx(iTargetID));
	        SendClientMessage(playerid, COLOR_WHITE, string);
	        format(string, sizeof(string), "%s has declined the offer to purchase VIP.", GetPlayerNameEx(playerid));
	        SendClientMessage(iTargetID, COLOR_WHITE, string);
			DeletePVar(playerid, "VIPSell");
			DeletePVar(playerid, "VIPCost");
	    }
	    return 1;
	}
	if((dialogid == DRINKDIALOG))
	{
	    if(response)
	    {
			ShowPlayerDialog(playerid, TIPDIALOG, DIALOG_STYLE_INPUT, "Tipping the Bartender", "How much would you like to tip the bartender for their service?", "OK", "Cancel");
		}
		else
		{
		    DrinkOffer[playerid] = INVALID_PLAYER_ID;
		}
	}
	if((dialogid == TIPDIALOG))
	{
	    if(response)
	    {
			if(GetPlayerCash(playerid) >= strval(inputtext))
			{
			    if(strval(inputtext) < 0 || strval(inputtext) > 10000)
			    {
			    	return ShowPlayerDialog(playerid, TIPDIALOG, DIALOG_STYLE_INPUT, "Tipping the Bartender", "Must be above $0 or below $10,000.\nHow much would you like to tip the bartender for their service?", "OK", "Cancel");
			    }
			    format(string, sizeof(string), "** %s gives %s a tip for their service.", GetPlayerNameEx(playerid), GetPlayerNameEx(DrinkOffer[playerid]));
				ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				format(string, sizeof(string), "* %s has given you a tip of $%d for your service.", GetPlayerNameEx(playerid), strval(inputtext));
				SendClientMessageEx(DrinkOffer[playerid], COLOR_LIGHTBLUE, string);
				GivePlayerCash(DrinkOffer[playerid], strval(inputtext));
				GivePlayerCash(playerid, -strval(inputtext));

				new ip[32], ipex[32];
				GetPlayerIp(playerid, ip, sizeof(ip));
				GetPlayerIp(DrinkOffer[playerid], ipex, sizeof(ipex));

				if(strval(inputtext) >= 25000 && (PlayerInfo[DrinkOffer[playerid]][pLevel] <= 3 || PlayerInfo[playerid][pLevel] <= 3 ))
				{
					format(string, sizeof(string), "%s (IP:%s) has tipped %s (IP:%s) $%s in this session.", GetPlayerNameEx(playerid), ip, GetPlayerNameEx(DrinkOffer[playerid]), ipex, number_format(strval(inputtext)));
					Log("logs/pay.log", string);
					ABroadCast(COLOR_YELLOW, string, 2);
				}

				DrinkOffer[playerid] = INVALID_PLAYER_ID;
			}
		}
		else
		{
		    DrinkOffer[playerid] = INVALID_PLAYER_ID;
		}
	}
	if((dialogid == PANEL))
	{
	    if(response)
	    {
	        switch(listitem)
	        {
				case 0:
				{
    				new
						szPanel[566],
						szPosition[16][23];

					for(new i = 0; i < 16; i++)
					{
				    	if(CellDoors[i])
						{
							szPosition[i]="{00FF00}Opened{FFFFFF}";
						}
						else
						{
						    szPosition[i]="{FF0000}Closed{FFFFFF}";
						}
					}

					format(szPanel, sizeof(szPanel),
					"Cell - 1 (%s)\r\n\
					Cell - 2 (%s)\r\n\
					Cell - 3 (%s)\r\n\
					Cell - 4 (%s)\r\n\
					Cell - 5 (%s)\r\n\
					Cell - 6 (%s)\r\n\
					Cell - 7 (%s)\r\n\
					Cell - 8 (%s)\r\n\
					Cell - 9 (%s)\r\n\
					Cell - 10 (%s)\r\n\
					Cell - 11 (%s)\r\n\
					Cell - 12 (%s)\r\n\
					Block A-1 (%s)\r\n\
					Block A-2 (%s)\r\n\
					Block B-1 (%s)\r\n\
					Block B-2 (%s)", szPosition[0],szPosition[1], szPosition[2], szPosition[3], szPosition[4], szPosition[5], szPosition[6],
					szPosition[7], szPosition[8], szPosition[9], szPosition[10], szPosition[11], szPosition[12], szPosition[13], szPosition[14], szPosition[15]);
            		ShowPlayerDialog(playerid, PANELCONTROLS, DIALOG_STYLE_LIST, "Security Panel", szPanel, "Operate", "Cancel");
				}
				case 1:
				{
				    if(PlayerInfo[playerid][pRank] < 2)
				        return SendClientMessageEx(playerid, COLOR_GREY, "You are to low rank to use this! (Rank 2+)");

    				for(new i = 0; i < 16; i++)
					{
						if(CellDoors[i])
						{
		    				CellDoors[i] = 0;
						}
					}
      				MoveDynamicObject(BlastDoors[5], -2053.92187500,-205.46679688,977.75732422, 1);
          			MoveDynamicObject(BlastDoors[10], -2053.92187500,-207.59570312,977.75732422, 1);
					MoveDynamicObject(BlastDoors[4], -2041.78613281, -211.28515625, 984.02539062, 1);
      				MoveDynamicObject(BlastDoors[9], -2041.78808594,-209.15917969,984.02539062, 1);
      				MoveDynamicObject(BlastDoors[3], -2041.79785156, -195.64550781, 990.45825195, 1);
      				MoveDynamicObject(BlastDoors[8], -2041.79687500,-197.77246094,990.45825195, 1);
      				MoveDynamicObject(BlastDoors[2],-2048.29296875, -205.54394531, 990.45825195, 1);
      				MoveDynamicObject(BlastDoors[7], -2048.29296875,-207.67382812,990.45825195, 1);
      				MoveDynamicObject(CellGates[11], -2084.99902344,-207.03710938,992.19836426, 1);
      				MoveDynamicObject(CellGates[10], -2081.52539062,-205.66894531,992.19836426, 1);
     				MoveDynamicObject(CellGates[9], -2074.00585938,-207.03710938,992.19836426, 1);
 					MoveDynamicObject(CellGates[8], -2069.53710938,-205.66894531,992.19836426, 1);
      				MoveDynamicObject(CellGates[7], -2061.96289062,-207.03710938,992.19836426, 1);
      				MoveDynamicObject(CellGates[6],-2057.59765625,-205.66894531,992.19836426, 1);
      				MoveDynamicObject(CellGates[5], -2052.22460938,-191.64550781,992.19836426, 1);
      				MoveDynamicObject(CellGates[4], -2055.99511719,-193.01757812,992.19836426, 1);
      				MoveDynamicObject(CellGates[3], -2063.56738281,-191.64550781,992.19836426, 1);
			 		MoveDynamicObject(CellGates[2], -2068.00195312,-193.01757812,992.19836426, 1);
      				MoveDynamicObject(CellGates[1], -2075.55273438,-191.64550781,992.19836426, 1);
					MoveDynamicObject(CellGates[0], -2080.28613281,-193.01757812,992.19836426, 1);

      				new
	        			szAlert[128];

					format( szAlert, sizeof(szAlert), "ALERT: The Easter Basin Correctional Facility is now on Lockdown for an emergency (( %s ))", GetPlayerNameEx(playerid));
					SendGroupMessage(1, COLOR_DBLUE, szAlert);
				}
				case 2:
				{
				    if(PlayerInfo[playerid][pRank] < 2)
				        return SendClientMessageEx(playerid, COLOR_GREY, "You are to low rank to use this! (Rank 2+)");

				    for(new i = 0; i < 16; i++)
					{
		    			if(!CellDoors[i])
						{
						    CellDoors[i] = 1;
						}
					}
					MoveDynamicObject(CellGates[0], -2078.6,-193,992.1983, 1);
				 	MoveDynamicObject(CellGates[1], -2077.1,-191.6455 ,992.1983, 1);
				 	MoveDynamicObject(CellGates[2], -2066, -193.0175, 992.1983, 1);
				 	MoveDynamicObject(CellGates[3], -2065.5,-191.6455,992.1983, 1);
				 	MoveDynamicObject(CellGates[4], -2054.2,-193.0175,992.1983, 1);
				 	MoveDynamicObject(CellGates[5], -2054, -191.6455,992.1983, 1);
				 	MoveDynamicObject(CellGates[6], -2059.6,-205.6689, 992.1983, 1);
				 	MoveDynamicObject(CellGates[7], -2059.9 ,-207.037,992.1983, 1);
				 	MoveDynamicObject(BlastDoors[5], -2053.92187500,-205.46679688,980.75732422, 1);
      				MoveDynamicObject(BlastDoors[10], -2053.92187500,-207.59570312,980.75732422, 1);
          			MoveDynamicObject(BlastDoors[4], -2041.78613281, -211.28515625, 987.02539062, 1);
	            	MoveDynamicObject(BlastDoors[9], -2041.78808594,-209.15917969,987.02539062, 1);
		           	MoveDynamicObject(BlastDoors[3],  -2041.79785156, -195.64550781, 993.45825195, 1);
		            MoveDynamicObject(BlastDoors[8], -2041.79687500,-197.77246094,993.45825195, 1);
      				MoveDynamicObject(BlastDoors[2], -2048.29296875, -205.54394531, 993.45825195, 1);
          			MoveDynamicObject(BlastDoors[7], -2048.29296875,-207.67382812,993.45825195, 1);
          			MoveDynamicObject(CellGates[11], -2083.3999, -207.0371,992.1983, 1);
	            	MoveDynamicObject(CellGates[10], -2083.1, -205.6689,992.1983, 1);
		            MoveDynamicObject(CellGates[9], -2071.9, -207.0371,992.1983, 1);
		            MoveDynamicObject(CellGates[8], -2071.6,-205.6689,992.1983, 1);

					new
	        			szAlert[128];

					format( szAlert, sizeof(szAlert), "The Lockdown has been lifted at the Easter Basin Correctional Facility (( %s ))", GetPlayerNameEx(playerid));
					SendGroupMessage(1, COLOR_DBLUE, szAlert);
				}
				case 3:
				{
				    new
				        szAlert[128];

					format( szAlert, sizeof(szAlert), "%s has activated a distress beacon inside Easter Basin Correctional Facility - assistance is required.", GetPlayerNameEx(playerid));
					SendGroupMessage(1, COLOR_DBLUE, szAlert);
				}
			}
	    }
	}
	if((dialogid == PANELCONTROLS))
	{
 		if(response)
	    {
			switch(listitem)
			{
			    case 0:
			    {
			        if(CellDoors[0])
			        {
			            CellDoors[0] = 0;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 1 is closing...");
			            MoveDynamicObject(CellGates[0], -2080.28613281,-193.01757812,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[0] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 1 is opening...");
           				MoveDynamicObject(CellGates[0], -2078.6,-193,992.1983, 1);
			        }
			    }
			    case 1:
			    {
			        if(CellDoors[1])
			        {
						CellDoors[1] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 2 is closing...");
			            MoveDynamicObject(CellGates[1], -2075.55273438,-191.64550781,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[1] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 2 is opening...");
			            MoveDynamicObject(CellGates[1], -2077.1,-191.6455 ,992.1983, 1);
			        }
			    }
			    case 2:
			    {
			        if(CellDoors[2])
			        {
						CellDoors[2] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 3 is closing...");
			            MoveDynamicObject(CellGates[2], -2068.00195312,-193.01757812,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[2] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 3 is opening...");
			            MoveDynamicObject(CellGates[2], -2066, -193.0175, 992.1983, 1);
			        }
			    }
			    case 3:
			    {
			        if(CellDoors[3])
			        {
						CellDoors[3] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 4 is closing...");
			            MoveDynamicObject(CellGates[3], -2063.56738281,-191.64550781,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[3] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 4 is opening...");
			            MoveDynamicObject(CellGates[3], -2065.5,-191.6455,992.1983, 1);
			        }
			    }
			    case 4:
			    {
			        if(CellDoors[4])
			        {
						CellDoors[4] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 5 is closing...");
			            MoveDynamicObject(CellGates[4], -2055.99511719,-193.01757812,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[4] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 5 is opening...");
			            MoveDynamicObject(CellGates[4], -2054.2,-193.0175,992.1983, 1);
			        }
			    }
			    case 5:
			    {
			        if(CellDoors[5])
			        {
						CellDoors[5] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 6 is closing...");
			            MoveDynamicObject(CellGates[5], -2052.22460938,-191.64550781,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[5] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 6 is opening...");
			            MoveDynamicObject(CellGates[5], -2054, -191.6455,992.1983, 1);
			        }
			    }
			    case 6:
			    {
			        if(CellDoors[6])
			        {
						CellDoors[6] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 7 is closing...");
			            MoveDynamicObject(CellGates[6],-2057.59765625,-205.66894531,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[6] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 7 is opening...");
			            MoveDynamicObject(CellGates[6], -2059.6,-205.6689, 992.1983, 1);
			        }
			    }
			    case 7:
			    {
			        if(CellDoors[7])
			        {
						CellDoors[7] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 8 is closing...");
			            MoveDynamicObject(CellGates[7], -2061.96289062,-207.03710938,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[7] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 8 is opening...");
			            MoveDynamicObject(CellGates[7], -2059.9 ,-207.037,992.1983, 1);
			        }
			    }
			    case 8:
			    {
			        if(CellDoors[8])
			        {
						CellDoors[8] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 9 is closing...");
			            MoveDynamicObject(CellGates[8], -2069.53710938,-205.66894531,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[8] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 9 is opening...");
			            MoveDynamicObject(CellGates[8], -2071.6,-205.6689,992.1983, 1);
			        }
			    }
			    case 9:
			    {
			        if(CellDoors[9])
			        {
						CellDoors[9] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 10 is closing...");
			            MoveDynamicObject(CellGates[9], -2074.00585938,-207.03710938,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[9] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 10 is opening...");
			            MoveDynamicObject(CellGates[9], -2071.9, -207.0371,992.1983, 1);
			        }
			    }
			    case 10:
			    {
			        if(CellDoors[10])
			        {
						CellDoors[10] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 11 is closing...");
			            MoveDynamicObject(CellGates[10], -2081.52539062,-205.66894531,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[10] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 11 is opening...");
			            MoveDynamicObject(CellGates[10], -2083.1, -205.6689,992.1983, 1);
			        }
			    }
			    case 11:
			    {
			        if(CellDoors[11])
			        {
						CellDoors[11] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 12 is closing...");
			            MoveDynamicObject(CellGates[11], -2084.99902344,-207.03710938,992.19836426, 1);
			        }
			        else
			        {
			            CellDoors[11] = 1;
			            SendClientMessageEx(playerid, COLOR_WHITE, "Cell - 12 is opening...");
			            MoveDynamicObject(CellGates[11], -2083.3999, -207.0371,992.1983, 1);
			        }
			    }
			    case 12:
			    {
			        if(CellDoors[12])
			        {
			            CellDoors[12] = 0;
			            SendClientMessage(playerid, COLOR_WHITE, "Block A-1 is closing...");
			            MoveDynamicObject(BlastDoors[2],-2048.29296875, -205.54394531, 990.45825195, 1);
			            MoveDynamicObject(BlastDoors[7], -2048.29296875,-207.67382812,990.45825195, 1);
			        }
			        else
			        {
			            CellDoors[12] = 1;
			            SendClientMessage(playerid, COLOR_WHITE, "Block A-1 is opening...");
			            MoveDynamicObject(BlastDoors[2], -2048.29296875, -205.54394531, 993.45825195, 1);
			            MoveDynamicObject(BlastDoors[7], -2048.29296875,-207.67382812,993.45825195, 1);
			        }
				}
				case 13:
			    {
			        if(CellDoors[13])
			        {
			            CellDoors[13] = 0;
			            SendClientMessage(playerid, COLOR_WHITE, "Block A-2 is closing...");
			            MoveDynamicObject(BlastDoors[3], -2041.79785156, -195.64550781, 990.45825195, 1);
			            MoveDynamicObject(BlastDoors[8], -2041.79687500,-197.77246094,990.45825195, 1);
			        }
			        else
			        {
			            CellDoors[13] = 1;
			            SendClientMessage(playerid, COLOR_WHITE, "Block A-2 is opening...");
			            MoveDynamicObject(BlastDoors[3],  -2041.79785156, -195.64550781, 993.45825195, 1);
			            MoveDynamicObject(BlastDoors[8], -2041.79687500,-197.77246094,993.45825195, 1);
			        }
				}
				case 14:
			    {
			        if(CellDoors[14])
			        {
			            CellDoors[14] = 0;
			            SendClientMessage(playerid, COLOR_WHITE, "Block B-1 is closing...");
			            MoveDynamicObject(BlastDoors[4], -2041.78613281, -211.28515625, 984.02539062, 1);
			            MoveDynamicObject(BlastDoors[9], -2041.78808594,-209.15917969,984.02539062, 1);
			        }
			        else
			        {
			            CellDoors[14] = 1;
			            SendClientMessage(playerid, COLOR_WHITE, "Block B-1 is opening...");
			            MoveDynamicObject(BlastDoors[4], -2041.78613281, -211.28515625, 987.02539062, 1);
			            MoveDynamicObject(BlastDoors[9], -2041.78808594,-209.15917969,987.02539062, 1);
			        }
				}
				case 15:
			    {
			        if(CellDoors[15])
			        {
			            CellDoors[15] = 0;
			            SendClientMessage(playerid, COLOR_WHITE, "Block B-2 is closing...");
			            MoveDynamicObject(BlastDoors[5], -2053.92187500,-205.46679688,977.75732422, 1);
			            MoveDynamicObject(BlastDoors[10], -2053.92187500,-207.59570312,977.75732422, 1);
			        }
			        else
			        {
			            CellDoors[15] = 1;
			            SendClientMessage(playerid, COLOR_WHITE, "Block B-2 is opening...");
			            MoveDynamicObject(BlastDoors[5], -2053.92187500,-205.46679688,980.75732422, 1);
			            MoveDynamicObject(BlastDoors[10], -2053.92187500,-207.59570312,980.75732422, 1);
			        }
				}
			}
		}
	}
	else if(dialogid == SETSTATION)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            if(!GetPVarType(playerid, "pHTTPWait"))
	        	{
	        		SetPVarInt(playerid, "pHTTPWait", 1);
					format(string, sizeof(string), "%s/radio/radio.php?listgenres=1", SAMP_WEB);
					HTTP(playerid, HTTP_GET, string, "", "GenreHTTP");
				}
				else
				{
				    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
				}
	        }
	        else if(listitem == 1)
	        {
	            if(!GetPVarType(playerid, "pHTTPWait"))
	        	{
	        		SetPVarInt(playerid, "pHTTPWait", 1);
					format(string, sizeof(string), "%s/radio/radio.php?top50=1", SAMP_WEB);
					HTTP(playerid, HTTP_GET, string, "", "Top50HTTP");
				}
				else
				{
				    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
				}
	        }
	        else if(listitem == 2)
	        {
	            ShowPlayerDialog(playerid,STATIONSEARCH,DIALOG_STYLE_INPUT,"Station Search","Input a search criteria:","Search","Back");
			}
			else if(listitem == 3)
			{
			    if(IsPlayerInAnyVehicle(playerid))
				{
			 	    //foreach(new i: Player)
					for(new i = 0; i < MAX_PLAYERS; ++i)
					{
						if(IsPlayerConnected(i))
						{
							if(GetPlayerVehicleID(i) != 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid)) {
								PlayAudioStreamForPlayerEx(i, "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1");
							}
						}	
				  	}
				  	format(stationidv[GetPlayerVehicleID(playerid)], 64, "%s", "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1");
				  	format(string, sizeof(string), "* %s changes the radio station.", GetPlayerNameEx(playerid), string);
					ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else if(GetPVarType(playerid, "pBoomBox"))
				{
				    //foreach(new i: Player)
					for(new i = 0; i < MAX_PLAYERS; ++i)
					{
						if(IsPlayerConnected(i))
						{
							if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "pBoomBoxArea")))
							{
								PlayAudioStreamForPlayerEx(i, "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1", GetPVarFloat(playerid, "pBoomBoxX"), GetPVarFloat(playerid, "pBoomBoxY"), GetPVarFloat(playerid, "pBoomBoxZ"), 30.0, 1);
							}
						}	
				  	}
			  		SetPVarString(playerid, "pBoomBoxStation", "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1");
				}
				else
				{
				    PlayAudioStreamForPlayerEx(playerid, "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1");
				    SetPVarInt(playerid, "MusicIRadio", 1);
				}
			}
			else if(listitem == 4)
			{
			    if(IsPlayerInAnyVehicle(playerid))
				{
			 	    //foreach(new i: Player)
					for(new i = 0; i < MAX_PLAYERS; ++i)
					{
						if(IsPlayerConnected(i))
						{
							if(GetPlayerVehicleID(i) != 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid)) {
								PlayAudioStreamForPlayerEx(i, "http://nick.ng-gaming.net:8000/listen.pls");
							}
						}	
					}
				  	format(stationidv[GetPlayerVehicleID(playerid)], 64, "%s", "http://nick.ng-gaming.net:8000/listen.pls");
				  	format(string, sizeof(string), "* %s changes the radio station.", GetPlayerNameEx(playerid), string);
					ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else if(GetPVarType(playerid, "pBoomBox"))
				{
				    //foreach(new i: Player)
					for(new i = 0; i < MAX_PLAYERS; ++i)
					{
						if(IsPlayerConnected(i))
						{
							if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "pBoomBoxArea")))
							{
								PlayAudioStreamForPlayerEx(i, "http://nick.ng-gaming.net:8000/listen.pls", GetPVarFloat(playerid, "pBoomBoxX"), GetPVarFloat(playerid, "pBoomBoxY"), GetPVarFloat(playerid, "pBoomBoxZ"), 30.0, 1);
							}
						}	
				  	}
			  		SetPVarString(playerid, "pBoomBoxStation", "http://nick.ng-gaming.net:8000/listen.pls");
				}
				else
				{
				    PlayAudioStreamForPlayerEx(playerid, "http://nick.ng-gaming.net:8000/listen.pls");
				    SetPVarInt(playerid, "MusicIRadio", 1);
				}
			}
			else if(listitem == 5)
			{
				if(GetPVarType(playerid, "pBoomBox"))
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "Sorry, this feature is for the MP3 Player or vehicles only.");
				}
				if(IsPlayerInAnyVehicle(playerid))
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "You must be using your MP3 to use this feature.");
				}
				else 
				{
					ShowPlayerDialog(playerid, CUSTOM_URLCHOICE, DIALOG_STYLE_INPUT, "Custom URL", "Please insert a valid audio url stream.", "Enter", "Back");
				}
			}
			else if(listitem == 6)
			{
			    if(!IsPlayerInAnyVehicle(playerid))
			    {
			        if(GetPVarType(playerid, "pBoomBox"))
			        {
				        SendClientMessage(playerid, COLOR_WHITE, "You have turned off the boom box.");
						//foreach(new i: Player)
						for(new i = 0; i < MAX_PLAYERS; ++i)
						{
							if(IsPlayerConnected(i))
							{						
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "pBoomBoxArea"))) StopAudioStreamForPlayerEx(i);
							}
						}
				  		DeletePVar(playerid, "pBoomBoxStation");
					}
					else
					{
					    StopAudioStreamForPlayerEx(playerid);
					}
			    }
			  	else
	  			{
		  			format(string, sizeof(string), "* %s turns off the radio.", GetPlayerNameEx(playerid), string);
					ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    //foreach(new i: Player)
					for(new i = 0; i < MAX_PLAYERS; ++i)
					{
						if(IsPlayerConnected(i))
						{
							if(GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid)) {
								StopAudioStreamForPlayerEx(i);
							}
						}	
					}
       				stationidv[GetPlayerVehicleID(playerid)][0] = 0;
				}
			}
	    }
	}
	else if(dialogid == CUSTOM_URLCHOICE)
	{
		if(response)
		{
			if(isnull(inputtext) || IsNumeric(inputtext)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You have not entered a valid URL.");
			
			PlayAudioStreamForPlayerEx(playerid, inputtext);
			SetPVarInt(playerid, "MusicIRadio", 1);
			format(string, sizeof(string), "You are now playing %s.", inputtext);
			SendClientMessageEx(playerid, COLOR_GREEN, string);
		}
		else
		{
			ShowPlayerDialog(playerid,SETSTATION,DIALOG_STYLE_LIST,"Radio Menu","Genres\nTop 50 Stations\nSearch\nK-LSR\nNick's Radio\nTurn radio off","Select", "Close");
		}
	}		
	else if(dialogid == GENRES)
	{
		if(response)
		{
		    if(!GetPVarType(playerid, "pHTTPWait"))
		    {
			    format(string, sizeof(string), "%s/radio/radio.php?genre=%d", SAMP_WEB, (listitem+1));
			    SetPVarInt(playerid, "pSelectGenre", (listitem+1));
			    SetPVarInt(playerid, "pHTTPWait", 1);
				HTTP(playerid, HTTP_GET, string, "", "StationListHTTP");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
		else
		{
		    ShowPlayerDialog(playerid,SETSTATION,DIALOG_STYLE_LIST,"Radio Menu","Genres\nTop 50 Stations\nSearch\nK-LSR\nNick's Radio\nTurn radio off","Select", "Close");
        	DeletePVar(playerid, "pSelectGenre");
		}
	}
	else if(dialogid == STATIONLIST)
	{
	    if(response)
		{
		    if(!GetPVarType(playerid, "pHTTPWait"))
		    {
			    format(string, sizeof(string), "%s/radio/radio.php?genre=%d&station=%d", SAMP_WEB, GetPVarInt(playerid, "pSelectGenre"), (listitem+1));
			    SetPVarInt(playerid, "pHTTPWait", 1);
			    SetPVarInt(playerid, "pSelectStation", (listitem+1));
				HTTP(playerid, HTTP_GET, string, "", "StationInfoHTTP");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
	    }
	    else
	    {
	        if(!GetPVarType(playerid, "pHTTPWait"))
		    {
				SetPVarInt(playerid, "pHTTPWait", 1);
				format(string, sizeof(string), "%s/radio/radio.php?listgenres=1", SAMP_WEB);
				HTTP(playerid, HTTP_GET, string, "", "GenreHTTP");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
	}
	else if(dialogid == TOP50LIST)
	{
	    if(!response)
		{
			ShowPlayerDialog(playerid,SETSTATION,DIALOG_STYLE_LIST,"Radio Menu","Genres\nTop 50 Stations\nSearch\nK-LSR\nNick's Radio\nTurn radio off","Select", "Close");
		}
	    else
		{
		    if(!GetPVarType(playerid, "pHTTPWait"))
		    {
			    format(string, sizeof(string), "%s/radio/radio.php?top50=1&station=%d", SAMP_WEB, (listitem+1));
			    SetPVarInt(playerid, "pHTTPWait", 1);
			    SetPVarInt(playerid, "pSelectStation", (listitem+1));
				HTTP(playerid, HTTP_GET, string, "", "Top50InfoHTTP");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
	    }
	}
	else if(dialogid == STATIONLISTEN)
	{
	    if(response)
	    {
	        if(!GetPVarType(playerid, "pHTTPWait"))
		    {
			    format(string, sizeof(string), "%s/radio/radio.php?genre=%d&station=%d&listen=1", SAMP_WEB, GetPVarInt(playerid, "pSelectGenre"), GetPVarInt(playerid, "pSelectStation"));
				SetPVarInt(playerid, "pHTTPWait", 1);
				HTTP(playerid, HTTP_GET, string, "", "StationSelectHTTP");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
	    else
		{
            if(!GetPVarType(playerid, "pHTTPWait"))
		    {
		    	format(string, sizeof(string), "%s/radio/radio.php?genre=%d", SAMP_WEB, GetPVarInt(playerid, "pSelectGenre"));
			   	SetPVarInt(playerid, "pHTTPWait", 1);
				HTTP(playerid, HTTP_GET, string, "", "StationListHTTP");
				DeletePVar(playerid, "pSelectStation");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
	    }
	}
	else if(dialogid == TOP50LISTEN)
	{
	    if(!response)
	    {
	        if(!GetPVarType(playerid, "pHTTPWait"))
        	{
        	    DeletePVar(playerid, "pSelectStation");
	        	SetPVarInt(playerid, "pHTTPWait", 1);
				format(string, sizeof(string), "%s/radio/radio.php?top50=1", SAMP_WEB);
				HTTP(playerid, HTTP_GET, string, "", "Top50HTTP");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
	    else
		{
		    if(!GetPVarType(playerid, "pHTTPWait"))
		    {
			    format(string, sizeof(string), "%s/radio/radio.php?top50=1&station=%d&listen=1", SAMP_WEB, GetPVarInt(playerid, "pSelectStation"));
				SetPVarInt(playerid, "pHTTPWait", 1);
				HTTP(playerid, HTTP_GET, string, "", "StationSelectHTTP");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
	    }
	}
	else if(dialogid == STATIONSEARCH)
	{
	    if(response)
	    {
	        if(strlen(inputtext) < 0 || strlen(inputtext) > 64)
	        {
	            ShowPlayerDialog(playerid,SETSTATION,DIALOG_STYLE_LIST,"Radio Menu","Genres\nTop 50 Stations\nSearch\nK-LSR\nNick's Radio\nTurn radio off","Select", "Close");
			}
			else
			{
		        if(!GetPVarType(playerid, "pHTTPWait"))
			    {
				    format(string, sizeof(string), "%s/radio/radio.php?search=%s", SAMP_WEB, inputtext);
				    SetPVarString(playerid, "pSearchStation", inputtext);
					SetPVarInt(playerid, "pHTTPWait", 1);
					ShowNoticeGUIFrame(playerid, 6);
					HTTP(playerid, HTTP_GET, string, "", "StationSearchHTTP");
				}
				else
				{
				    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
				}
			}
	    }
	    else
	    {
	        ShowPlayerDialog(playerid,SETSTATION,DIALOG_STYLE_LIST,"Radio Menu","Genres\nTop 50 Stations\nSearch\nK-LSR\nNick's Radio\nTurn radio off","Select", "Close");
	    }
	}
	else if(dialogid == STATIONSEARCHLIST)
	{
	    if(response)
		{
		    if(!GetPVarType(playerid, "pHTTPWait"))
		    {
			    GetPVarString(playerid, "pSearchStation", string, sizeof(string));
			    format(string, sizeof(string), "%s/radio/radio.php?search=%s&station=%d", SAMP_WEB, string, (listitem+1));
				SetPVarInt(playerid, "pHTTPWait", 1);
			    ShowNoticeGUIFrame(playerid, 6);
			    SetPVarInt(playerid, "pSelectStation", (listitem+1));
				HTTP(playerid, HTTP_GET, string, "", "StationSearchInfoHTTP");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
	    }
	    else
	    {
	        ShowPlayerDialog(playerid,SETSTATION,DIALOG_STYLE_LIST,"Radio Menu","Genres\nTop 50 Stations\nSearch\nK-LSR\nNick's Radio\nTurn radio off","Select", "Close");
		}
	}
	else if(dialogid == STATIONSEARCHLISTEN)
	{
	    if(response)
	    {
	        if(!GetPVarType(playerid, "pHTTPWait"))
		    {
  			 	GetPVarString(playerid, "pSearchStation", string, sizeof(string));
			    format(string, sizeof(string), "%s/radio/radio.php?search=%s&station=%d&listen=1", SAMP_WEB, string, GetPVarInt(playerid, "pSelectStation"));
				SetPVarInt(playerid, "pHTTPWait", 1);
				ShowNoticeGUIFrame(playerid, 6);
				HTTP(playerid, HTTP_GET, string, "", "StationSelectHTTP");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
	    else
		{
            if(!GetPVarType(playerid, "pHTTPWait"))
		    {
		        GetPVarString(playerid, "pSearchStation", string, sizeof(string));
		    	format(string, sizeof(string), "%s/radio/radio.php?search=%s", SAMP_WEB, string);
			    ShowNoticeGUIFrame(playerid, 6);
				HTTP(playerid, HTTP_GET, string, "", "StationSearchHTTP");
				DeletePVar(playerid, "pSelectStation");
			}
			else
			{
			    SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
	    }
	}
	else if(dialogid == INTERACTMAIN)
	{
	    if(response)
	    {
	        new name[MAX_PLAYER_NAME+8];
	    	GetPVarString(playerid, "pInteractName", name, sizeof(name));
		    if(listitem == 0)
			{
		        ShowPlayerDialog(playerid, INTERACTPAY, DIALOG_STYLE_INPUT, name, "Input an amount to pay", "Pay", "Cancel");
		    }
		    else if(listitem == 1)
		    {
                ShowPlayerDialog(playerid, INTERACTGIVE, DIALOG_STYLE_LIST, name, "Pot\nCrack\nMaterials\nFirework", "Select", "Cancel");
		    }
		}
		else
		{
		    DeletePVar(playerid, "pInteractName");
		    DeletePVar(playerid, "pInteractID");
		}
	}
	else if(dialogid == INTERACTPAY)
	{
	    if(response)
	    {
	        new params[24];
	        format(params, sizeof(params), "%d %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
	        DeletePVar(playerid, "pInteractName");
		    DeletePVar(playerid, "pInteractID");
	        return cmd_pay(playerid, params);
	    }
	    else
		{
		    DeletePVar(playerid, "pInteractName");
		    DeletePVar(playerid, "pInteractID");
		}
	}
	else if(dialogid == INTERACTGIVE)
	{
	    if(response)
	    {
	        new name[MAX_PLAYER_NAME+8];
	       	SetPVarInt(playerid, "pInteractGiveType", listitem);
	    	GetPVarString(playerid, "pInteractName", name, sizeof(name));
	        ShowPlayerDialog(playerid, INTERACTGIVE2, DIALOG_STYLE_INPUT, name, "Input an amount to give", "Give", "Cancel");
	    }
	    else
		{
		    DeletePVar(playerid, "pInteractName");
		    DeletePVar(playerid, "pInteractID");
		}
	}
	else if(dialogid == INTERACTGIVE2)
	{
	    if(response)
	    {
	        new params[24];
	        switch(GetPVarInt(playerid, "pInteractGiveType"))
	        {
	        	case 0: format(params, sizeof(params), "%d pot %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
	        	case 1: format(params, sizeof(params), "%d crack %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
	        	case 2: format(params, sizeof(params), "%d materials %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
	        	case 3: format(params, sizeof(params), "%d firework %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
			}
	        DeletePVar(playerid, "pInteractName");
		    DeletePVar(playerid, "pInteractID");
		    DeletePVar(playerid, "pInteractGive");
	        return cmd_give(playerid, params);
	    }
	    else
		{
		    DeletePVar(playerid, "pInteractName");
		    DeletePVar(playerid, "pInteractID");
		    DeletePVar(playerid, "pInteractGive");
		}
	}
	else if(dialogid == DMRCONFIRM)
	{
	    if(response)
	    {
	        new giveplayerid = GetPVarInt(playerid, "pDMReport");
			SetPVarInt(playerid, "_rAutoM", 5);
			SetPVarInt(playerid, "_rRepID", giveplayerid);			format(string, sizeof(string), "You have successfully reported %s.", GetPlayerNameEx(giveplayerid));
			SendClientMessage(playerid, COLOR_WHITE, string);

   			if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pSMod] == 1) format(string, sizeof(string), "INSERT INTO dm_watchdog (id,reporter,timestamp,superwatch) VALUES (%d,%d,%d,1)", GetPlayerSQLId(giveplayerid), GetPlayerSQLId(playerid), gettime());
      		else format(string, sizeof(string), "INSERT INTO dm_watchdog (id,reporter,timestamp) VALUES (%d,%d,%d)", GetPlayerSQLId(giveplayerid), GetPlayerSQLId(playerid), gettime());
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

			format(string, sizeof(string), "%s(%i) Deathmatching (last shot: %i seconds ago)", GetPlayerNameEx(giveplayerid), giveplayerid, gettime() - ShotPlayer[giveplayerid][playerid]);
			SendReportToQue(playerid, string, 2, 1);

			ShotPlayer[giveplayerid][playerid] = 0;
	    }
	    else
		{
			SendClientMessage(playerid, COLOR_GRAD2, "DM Report Cancelled");
		}
		DeletePVar(playerid, "pDMReport");
	}
	else if(dialogid == SHOPOBJECT_ORDERID)
	{
		if(response)
		{
			SetPVarString(playerid, "shopobject_orderid", inputtext);
			ShowPlayerDialog(playerid, SHOPOBJECT_GIVEPLAYER, DIALOG_STYLE_INPUT, "Shop Objects - player ID", "Please enter the player ID", "OK", "Cancel");
		}
	}
	else if(dialogid == SHOPOBJECT_GIVEPLAYER)
	{
		if(response)
		{
			SetPVarString(playerid, "shopobject_giveplayerid", inputtext);
			new stringg[1024];
			for(new x;x<sizeof(HoldingObjectsShop);x++)
			{
				format(stringg, sizeof(stringg), "%s%s\n", stringg, HoldingObjectsShop[x][holdingmodelname]);
			}
			ShowPlayerDialog(playerid, SHOPOBJECT_OBJECTID, DIALOG_STYLE_LIST, "Shop Objects - Object ID", stringg, "Select", "Cancel");
		}
	}
	else if(dialogid == SHOPOBJECT_OBJECTID)
	{
		if(response)
		{
			new giveplayerid;
			new str[MAX_PLAYER_NAME];
			GetPVarString(playerid, "shopobject_giveplayerid", str, MAX_PLAYER_NAME);
			sscanf(str, "u", giveplayerid);
			new stringg[512], icount = GetPlayerToySlots(giveplayerid);
			if(!IsPlayerConnected(giveplayerid) || giveplayerid == INVALID_PLAYER_ID)
			{
				ShowPlayerDialog(playerid, SHOPOBJECT_GIVEPLAYER, DIALOG_STYLE_INPUT, "Shop Objects - player ID", "ERROR: That person is not connected \nPlease re-enter the player ID", "OK", "Cancel");
				return 1;
			}
			SetPVarInt(playerid, "shopobject_objectid", listitem);
			for(new x;x<icount;x++)
			{
				new name[24] = "None";

				for(new i;i<sizeof(HoldingObjectsAll);i++)
				{
					if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[giveplayerid][x][ptModelID])
					{
						format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
					}
				}

				format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[giveplayerid][x][ptBone]]);
			}
			ShowPlayerDialog(playerid, SHOPOBJECT_TOYSLOT, DIALOG_STYLE_LIST, "Shop Objects - Select a Slot", stringg, "Select", "Cancel");
		}
	}
	else if(dialogid == SHOPOBJECT_TOYSLOT)
	{
		if(response)
		{		
			new stringg[128];
			new giveplayerid;
			new str[MAX_PLAYER_NAME];
			GetPVarString(playerid, "shopobject_giveplayerid", str, MAX_PLAYER_NAME);
			sscanf(str, "u", giveplayerid);
			new object = HoldingObjectsShop[GetPVarInt(playerid, "shopobject_objectid")][holdingmodelid];
			new slot = listitem;
			new invoice[64];
			GetPVarString(playerid, "shopobject_orderid", invoice, sizeof(invoice));
			if(!IsPlayerConnected(giveplayerid) || giveplayerid == INVALID_PLAYER_ID)
			{
				ShowPlayerDialog(playerid, SHOPOBJECT_GIVEPLAYER, DIALOG_STYLE_INPUT, "Shop Objects - player ID", "ERROR: That person is not connected \nPlease re-enter the player ID", "OK", "Cancel");
				return 1;
			}
			if(!toyCountCheck(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "This player does not have enough free slots");
			
			format(stringg, sizeof(stringg), "You have given %s object %d in slot %d", GetPlayerNameEx(giveplayerid), object, slot);
			ShowPlayerDialog(playerid, SHOPOBJECT_SUCCESS, DIALOG_STYLE_MSGBOX, "Shop Objects - Success", stringg, "OK", "");
			SendClientMessageEx(giveplayerid, COLOR_WHITE, "You have received a new /toys from the shop!");
			format(string, sizeof(string), "[SHOPOBJECTS] %s gave %s object %d in slot %d - Invoice %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), object, slot, invoice);
			PlayerToyInfo[giveplayerid][slot][ptModelID] = object;
			PlayerToyInfo[giveplayerid][slot][ptBone] = 1;
			PlayerToyInfo[giveplayerid][slot][ptTradable] = 1;
			g_mysql_NewToy(giveplayerid, slot);
			Log("logs/shoplog.log", string);
		}
	}
	else if(dialogid == LISTTOYS_DELETETOY)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pAdmin] < 4)
			{
				return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorized to do that");
			}
			new giveplayerid = GetPVarInt(playerid, "listtoys_giveplayerid");
			SetPVarInt(playerid, "listitem_toyslot", listitem);
			format(string, sizeof(string), "Are you sure you want to delete %s's toy (Model ID: %d) from slot %d?", GetPlayerNameEx(giveplayerid), PlayerToyInfo[giveplayerid][listitem][ptModelID], listitem);
			ShowPlayerDialog(playerid, LISTTOYS_DELETETOYCONFIRM, DIALOG_STYLE_MSGBOX, "Delete Toy - Are you sure?", string, "Yes", "No");
	    }
	}
	else if(dialogid == LISTTOYS_DELETETOYCONFIRM)
	{
		if(response)
		{
			new stringg[128], szQuery[128], giveplayerid = GetPVarInt(playerid, "listtoys_giveplayerid"), slot = GetPVarInt(playerid, "listitem_toyslot");
			new object =  PlayerToyInfo[giveplayerid][slot][ptModelID];
			if(!IsPlayerConnected(giveplayerid) || giveplayerid == INVALID_PLAYER_ID)
			{
				ShowPlayerDialog(playerid, SHOPOBJECT_GIVEPLAYER, DIALOG_STYLE_MSGBOX, "Delete Toy - Player ID", "ERROR: That player is not connected", "OK", "");
				return 1;
			}
			new toys = 99999;
			for(new i; i < 11; i++)
			{
				if(PlayerHoldingObject[giveplayerid][i] == slot+1)
				{
					toys = i;
					if(IsPlayerAttachedObjectSlotUsed(giveplayerid, toys-1))
					{
						PlayerHoldingObject[giveplayerid][i] = 0;
						RemovePlayerAttachedObject(giveplayerid, toys-1);
					}
					break;
				}
			}
			format(stringg, sizeof(stringg), "You have deleted %s's object %d in slot %d", GetPlayerNameEx(giveplayerid), object, slot);
			ShowPlayerDialog(playerid, SHOPOBJECT_SUCCESS, DIALOG_STYLE_MSGBOX, "Delete Toy - Success", stringg, "OK", "");
			format(stringg, sizeof(stringg), "Admin %s has deleted your toy (obj model: %d) from slot %d.", GetPlayerNameEx(playerid), object, slot);
			SendClientMessageEx(giveplayerid, COLOR_WHITE, stringg);
			format(string, sizeof(string), "[TOYDELETE] %s deleted %s's object %d in slot %d", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), object, slot);
			format(szQuery, sizeof(szQuery), "DELETE FROM `toys` WHERE `id` = %d", PlayerToyInfo[giveplayerid][slot][ptID]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, giveplayerid);
			PlayerToyInfo[giveplayerid][slot][ptModelID] = 0;
			PlayerToyInfo[giveplayerid][slot][ptBone] = 0;
			Log("logs/toydelete.log", string);
		}
	}
	else if(dialogid == MDC_SHOWCRIMES)
	{
	    if(response)
	    {
	        ShowPlayerDialog(playerid, MDC_CIVILIANS, DIALOG_STYLE_LIST, "SA-MDC - Logged in | Civilian Options", "*Check Record\n*View Arrest Reports\n*Licenses\n*Warrants\n*Issue Warrant\n*BOLO\n*Create BOLO\n*Delete", "OK", "Cancel");
	    }
	}
	else if(dialogid == FLAG_LIST)
	{
	    if(response)
	    {
	        ShowPlayerDialog(playerid, FLAG_DELETE, DIALOG_STYLE_INPUT, "FLAG DELETION", "Which flag would you like to delete?", "Delete Flag", "Close");
	    }
	}
	else if(dialogid == FLAG_DELETE)
	{
		if(response)
	    {
			format(string, sizeof(string), "Are you sure you want to delete Flag ID No: %d", strval(inputtext));
	       	ShowPlayerDialog(playerid, FLAG_DELETE2, DIALOG_STYLE_MSGBOX, "FLAG DELETION", string, "Yes", "No");
	       	SetPVarInt(playerid, "Flag_Delete_ID", strval(inputtext));
	    }
	}
	else if(dialogid == FLAG_DELETE2)
	{
		if(response)
	    {
	        new flagid = GetPVarInt(playerid, "Flag_Delete_ID");
	       	DeleteFlag(flagid, playerid);
	       	SendClientMessageEx(playerid, COLOR_YELLOW, " Flag deleted succesfully ");
	    }
	}
	else if(dialogid == SKIN_LIST)
	{
	    if(response)
	    {
			new query[128];
			SetPVarInt(playerid, "closetchoiceid", listitem);
			format(query, sizeof(query), "SELECT `skinid` FROM `house_closet` WHERE playerid = %d ORDER BY `skinid` ASC", GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, query, true, "SkinQueryFinish", "ii", playerid, Skin_Query_ID);
	    }
	}
	else if(dialogid == SKIN_CONFIRM)
	{
	    if(response)
	    {
			PlayerInfo[playerid][pModel] = GetPVarInt(playerid, "closetskinid");
			DeletePVar(playerid, "closetchoiceid");
			DeletePVar(playerid, "closetskinid");
	    }
		else
		{
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			DeletePVar(playerid, "closetchoiceid");
			DeletePVar(playerid, "closetskinid");
			DisplaySkins(playerid);
		}
	}
	else if(dialogid == SKIN_DELETE)
	{
	    if(response)
	    {
			new query[128];
			SetPVarInt(playerid, "closetchoiceid", listitem);
			format(query, sizeof(query), "SELECT `id`, `skinid` FROM `house_closet` WHERE playerid = %d ORDER BY `skinid` ASC", GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, query, true, "SkinQueryFinish", "ii", playerid, Skin_Query_Delete_ID);
	    }
	}
	else if(dialogid == SKIN_DELETE2)
	{
	    if(response)
	    {
			DeleteSkin(GetPVarInt(playerid, "closetskinid"));
			DeletePVar(playerid, "closetchoiceid");
			DeletePVar(playerid, "closetskinid");
			SendClientMessageEx(playerid, COLOR_WHITE, "Clothes removed successfully!");
	    }
		else
		{
			DeletePVar(playerid, "closetchoiceid");
			DeletePVar(playerid, "closetskinid");
			DisplaySkins(playerid);
		}
	}
	else if(dialogid == NATION_APP_LIST)
	{
	    if(response)
	    {
	       	ShowPlayerDialog(playerid, NATION_APP_CHOOSE, DIALOG_STYLE_MSGBOX, "Nation Applications", "What would you like to do with this application?", "Accept", "Deny");
	       	SetPVarInt(playerid, "Nation_App_ID", listitem);
	    }
	}
	else if(dialogid == NATION_APP_CHOOSE)
	{
	    if(response)
		{
			switch(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
			{
				case 1: mysql_function_query(MainPipeline, "SELECT `id`, `playerid`, `name` FROM `nation_queue` WHERE `nation` = 0 AND `status` = 1 ORDER BY `id` ASC", true, "NationAppFinish", "ii", playerid, AcceptApp);
				case 2: mysql_function_query(MainPipeline, "SELECT `id`, `playerid`, `name` FROM `nation_queue` WHERE `nation` = 1 AND `status` = 1 ORDER BY `id` ASC", true, "NationAppFinish", "ii", playerid, AcceptApp);
			}
		}
		else
		{
			switch(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
			{
				case 1: mysql_function_query(MainPipeline, "SELECT `id`, `playerid`, `name` FROM `nation_queue` WHERE `nation` = 0 AND `status` = 1 ORDER BY `id` ASC", true, "NationAppFinish", "ii", playerid, DenyApp);
				case 2: mysql_function_query(MainPipeline, "SELECT `id`, `playerid`, `name` FROM `nation_queue` WHERE `nation` = 1 AND `status` = 1 ORDER BY `id` ASC", true, "NationAppFinish", "ii", playerid, DenyApp);
			}
		}
	}
	else if(dialogid == DIALOG_911MENU)
	{
	    if(response)
		{
			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, DIALOG_911EMERGENCY, DIALOG_STYLE_INPUT, "911 Emergency Services", "Please describe the emergency.", "Enter", "End Call");
				case 1: ShowPlayerDialog(playerid, DIALOG_911MEDICAL, DIALOG_STYLE_INPUT, "911 Emergency Services", "Please describe your medical emergency.", "Enter", "End Call");
				case 2: ShowPlayerDialog(playerid, DIALOG_911POLICE, DIALOG_STYLE_INPUT, "911 Emergency Services", "Please describe why you require police assistance.", "Enter", "End Call");
				case 3: ShowPlayerDialog(playerid, DIALOG_911TOWING, DIALOG_STYLE_INPUT, "911 Emergency Services", "Please describe why you require towing services.", "Enter", "End Call");
			}
		}
	}
	else if(dialogid == DIALOG_911EMERGENCY)
	{
	    if(response)
		{
			new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
			if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid, DIALOG_911EMERGENCY, DIALOG_STYLE_INPUT, "911 Emergency Services", "Sorry, I don't quite understand. What is the emergency you are experiencing?", "Enter", "End Call");
			else
			{
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);
				SendCallToQueue(playerid, inputtext, zone, mainzone, 0);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
			}
		}
	}
	else if(dialogid == DIALOG_911MEDICAL)
	{
	    if(response)
		{
			new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
			if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid, DIALOG_911MEDICAL, DIALOG_STYLE_INPUT, "911 Emergency Services", "Sorry, I don't quite understand. What is the medical emergency you are experiencing?", "Enter", "End Call");
			else
			{
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);
				SendCallToQueue(playerid, inputtext, zone, mainzone, 1);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
			}
		}
	}
	else if(dialogid == DIALOG_911POLICE)
	{
	    if(response)
		{
			new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
			if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid, DIALOG_911POLICE, DIALOG_STYLE_INPUT, "911 Emergency Services", "Sorry, I don't quite understand. Why are you needing police assistance?", "Enter", "End Call");
			else
			{
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);
				SendCallToQueue(playerid, inputtext, zone, mainzone, 2);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
			}
		}
	}
	else if(dialogid == DIALOG_911TOWING)
	{
	    if(response)
		{
			new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
			if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid, DIALOG_911TOWING, DIALOG_STYLE_INPUT, "911 Emergency Services", "Sorry, I don't quite understand. Why do you need towing assistance?", "Enter", "End Call");
			else
			{
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);
				SendCallToQueue(playerid, inputtext, zone, mainzone, 3);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
			}
		}
	}
	else if(dialogid == CRATE_GUNMENU)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this as you are currently restricted from possessing weapons!");
			new CrateID = GetPVarInt(playerid, "CrateGuns_CID");
			switch(listitem)
			{ //Desert Eagle\nSPAS-12\nMP5\nM4A1\nAK-47\nSniper Rifle\nShotgun
			    /*
			    Deagle - 4
				Spas - 8
				AK-47 - 5
				M4    - 6
				Sniper Rifle - 5
				MP5 - 5
			    */
			    case 0: // CRATE GUNS
				{
				    if(CrateInfo[CrateID][GunQuantity] >= 4)
				    {
						GivePlayerValidWeapon(playerid, 24, 99999); // deagle
						CrateInfo[CrateID][GunQuantity] -= 4;
					}
				}
				case 1: // CRATE GUNS
				{
					if(CrateInfo[CrateID][GunQuantity] >= 8)
				    {
						GivePlayerValidWeapon(playerid, 27, 99999); //spas
						CrateInfo[CrateID][GunQuantity] -= 8;
					}
				}
				case 2: // CRATE GUNS
				{
					if(CrateInfo[CrateID][GunQuantity] >= 5)
				    {
						GivePlayerValidWeapon(playerid, 29, 99999);//mp5
						CrateInfo[CrateID][GunQuantity] -= 5;
					}
				}
				case 3: // CRATE GUNS
				{
					if(CrateInfo[CrateID][GunQuantity] >= 6)
				    {
						GivePlayerValidWeapon(playerid, 31, 99999); //m4
						CrateInfo[CrateID][GunQuantity] -= 6;
					}
				}
				case 4: // CRATE GUNS
				{
					if(CrateInfo[CrateID][GunQuantity] >= 5)
				    {
						GivePlayerValidWeapon(playerid, 30, 99999); //ak47
						CrateInfo[CrateID][GunQuantity] -= 5;
					}
				}
				case 5: // CRATE GUNS
				{
					if(CrateInfo[CrateID][GunQuantity] >= 5)
				    {
						GivePlayerValidWeapon(playerid, 34, 99999);//sniper
						CrateInfo[CrateID][GunQuantity] -= 5;
					}
				}
				case 6: // CRATE GUNS
				{
					if(CrateInfo[CrateID][GunQuantity] >= 3)
				    {
						GivePlayerValidWeapon(playerid, 25, 99999);//shotgun
						CrateInfo[CrateID][GunQuantity] -= 3;
					}
				}
				case 7: // CRATE GUNS
				{
					if(CrateInfo[CrateID][GunQuantity] >= 1)
				    {
						GivePlayerValidWeapon(playerid, 22, 99999);//shotgun
						CrateInfo[CrateID][GunQuantity] -= 1;
					}
				}
			}
			format(string, sizeof(string), "Serial Number: #%d\n High Grade Materials: %d/50\n (( Dropped by: %s ))", CrateID, CrateInfo[CrateID][GunQuantity], CrateInfo[CrateID][crPlacedBy]);
			UpdateDynamic3DTextLabelText(CrateInfo[CrateID][crLabel], COLOR_ORANGE, string);
	    }
	}
	else if(dialogid == DIALOG_SUSPECTMENU)
	{
	    if(response)
	    {
	        if(strcmp(inputtext, "Other (Not Listed)", true) == 0)
	        {
	            return ShowPlayerDialog(playerid, DIALOG_SUSPECTMENU, DIALOG_STYLE_INPUT, "Specify a crime", "Please specify a crime", "Submit", "Cancel");
	        }
	        if(strlen(inputtext) <= 3)
	        {
	            return ShowPlayerCrimeDialog(playerid);
	        }
	        if(inputtext[0] == '-')
	        {
	        	return ShowPlayerCrimeDialog(playerid);
	        }
			new iTargetID = GetPVarInt(playerid, "suspect_TargetID");
			new
				szMessage[128];
			++PlayerInfo[iTargetID][pCrimes];
			new crimeid = -1;
			for(new i; i < sizeof(SuspectCrimes); i++)
			{
			    if(strcmp(inputtext, SuspectCrimes[i]) == 0)
			    {
			        crimeid = i;
			        break;
			    }
			}
			if(crimeid != -1)
			{
				PlayerInfo[iTargetID][pWantedLevel] += SuspectCrimeInfo[crimeid][1];
			}
			else PlayerInfo[iTargetID][pWantedLevel] += 1;
			if(PlayerInfo[iTargetID][pWantedLevel] > 6)
			{
			    PlayerInfo[iTargetID][pWantedLevel] = 6;
			}
			SetPlayerWantedLevel(iTargetID, PlayerInfo[iTargetID][pWantedLevel]);
			new szCountry[10], szCrime[128];
			if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 1)
			{
			    format(szCountry, sizeof(szCountry), "[SA] ");
			}
			else if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2)
			{
			    format(szCountry, sizeof(szCountry), "[TR] ");
			}
			strcat(szCrime, szCountry);
			strcat(szCrime, inputtext);
			AddCrime(playerid, iTargetID, szCrime);

			format(szMessage, sizeof(szMessage), "You've commited a crime ( %s ). Reporter: %s.", szCrime, GetPlayerNameEx(playerid));
			SendClientMessageEx(iTargetID, COLOR_LIGHTRED, szMessage);

			format(szMessage, sizeof(szMessage), "Current wanted level: %d", PlayerInfo[iTargetID][pWantedLevel]);
			SendClientMessageEx(iTargetID, COLOR_YELLOW, szMessage);

			//foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(IsACop(i)) {
						format(szMessage, sizeof(szMessage), "HQ: All units APB (reporter: %s)",GetPlayerNameEx(playerid));
						SendClientMessageEx(i, TEAM_BLUE_COLOR, szMessage);
						format(szMessage, sizeof(szMessage), "HQ: Crime: %s, suspect: %s", szCrime, GetPlayerNameEx(iTargetID));
						SendClientMessageEx(i, TEAM_BLUE_COLOR, szMessage);
					}
				}	
			}
			PlayerInfo[iTargetID][pDefendTime] = 60;
	    }
	}
	else if(dialogid == DIALOG_REPORTMENU)
	{
	    if(response)
	    {
	        switch(listitem)
			{
			    case 0: //Deathmatch
			    {
			        if(PlayerInfo[playerid][pJailTime] > 0) {
			            SendClientMessage(playerid, COLOR_GREY, "You can't report while in prison.");
			        }
			        else {
			        	ShowPlayerDialog(playerid, DIALOG_REPORTDM, DIALOG_STYLE_INPUT, "Report player - Deathmatch", "Enter the name or ID of the player.", "Enter", "Cancel");
					}
				}
			    case 1: //Falling
			    {
    				if(gettime() - LastShot[playerid] < 20)
			        {
			            SendClientMessageEx(playerid, COLOR_GREY, "You have been hurt in the last 20 seconds, abusing this system will result in a temporary ban.");
			        }
			        else
			        {
			            new
			                Message[128];

			            TogglePlayerControllable(playerid, 0);
						SetPVarInt(playerid, "IsFrozen", 1);
						SetPVarInt(playerid, "_rAutoM", 5);
						SetPVarInt(playerid, "_rRepID", playerid);
      					format(Message, sizeof(Message), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has been frozen. (Falling Report)", GetPlayerNameEx(playerid), playerid);
						ABroadCast(COLOR_YELLOW, Message, 2);
						SendReportToQue(playerid, "Falling (Player Frozen)", 2, GetPlayerPriority(playerid));
						SendClientMessageEx(playerid, COLOR_WHITE, "A report has been sent to the available admins, you have been frozen.");
			        }
			    }
			    case 2: //Hacking
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTHACK, DIALOG_STYLE_INPUT, "Report player - Hacking", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 3: //Chicken Running
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTCR, DIALOG_STYLE_INPUT, "Report player - Chicken Running", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 4: //Car Ramming
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTCARRAM, DIALOG_STYLE_INPUT, "Report player - Car Ramming", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 5: //Power Gaming
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTPG, DIALOG_STYLE_INPUT, "Report player - Power Gaming", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 6: //Meta Gaming
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTMG, DIALOG_STYLE_INPUT, "Report player - Meta Gaming", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 7: //Gun Discharge Exploits
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTGDE, DIALOG_STYLE_INPUT, "Report player - Gun Discharge Exploits", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 8: //Spamming
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTSPAM, DIALOG_STYLE_INPUT, "Report player - Spamming", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 9: //Money Farming
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTMF, DIALOG_STYLE_INPUT, "Report player - Money Farming", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 10: //Ban Evader
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTBANEVADE, DIALOG_STYLE_INPUT, "Report player - Ban Evader", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 11: //General Exploits
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTGE, DIALOG_STYLE_INPUT, "Report player - General Exploits", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 12: //Releasing Hitman Names
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTRHN, DIALOG_STYLE_INPUT, "Report player - Releasing Hitman Names", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 13: //Running/Swimming Man Exploit
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTRSE, DIALOG_STYLE_INPUT, "Report player - Running/Swimming Man Exploit", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 14: //Car Surfing
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTCARSURF, DIALOG_STYLE_INPUT, "Report player - Car Surfing", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 15: //NonRp Behavior
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTNRPB, DIALOG_STYLE_INPUT, "Report player - NonRP Behavior", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 16: //Next Page
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTMENU2, DIALOG_STYLE_LIST, "Report Menu [2/2]", "Revenge Killing\nOOC Hit\nServer Advertising\nNonRP Name\nOther/Freetext (PVIP Only)\nHouse Move\nAppeal Admin Action\nPrize Claim\nShop Issue\nNot Listed Here\nRequest CA\nRequest Unmute\nPrevious Page","Select", "Exit");
			    }
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTMENU2)
	{
	    if(response)
	    {
	        switch(listitem)
			{
			    case 0: //Revenge Killing
			    {
       				ShowPlayerDialog(playerid, DIALOG_REPORTRK, DIALOG_STYLE_INPUT, "Report player - Revenge Killing", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 1: //OOC Hit
			    {
			        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "OOC Hit", "{FFFFFF}OOC Hits are to be handled on the forums. (Player Complaint)\n\n                 ng-gaming.net/forums", "Close", "");
			    }
			    case 2: //Server Advertising
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTSA, DIALOG_STYLE_INPUT, "Report player - Server Advertising", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 3: //Non RP Name
			    {
			        ShowPlayerDialog(playerid, DIALOG_REPORTNRPN, DIALOG_STYLE_INPUT, "Report player - Non-RP Name", "Enter the name or ID of the player.", "Enter", "Cancel");
			    }
			    case 4: //Other/Freetext (PVip Only!!)
			    {
			        if(PlayerInfo[playerid][pDonateRank] >= 4) {
			        	ShowPlayerDialog(playerid, DIALOG_REPORTFREE, DIALOG_STYLE_INPUT,"Other / Free Text","Enter the message you want to send to the admin team.","Send","Cancel");
					}
					else {
					    SendClientMessageEx(playerid, COLOR_GREY, "This is a Platinum VIP feature only.");
					}
				}
				case 5: //House Move
			    {
			        SendReportToQue(playerid, "House Move", 4, GetPlayerPriority(playerid));
			        SendClientMessageEx(playerid, COLOR_WHITE, "Your house move request has been sent to the current available admins.");
			    }
			    case 6: //Appeal Admin Action
			    {
					if(gettime() < GetPVarInt(playerid, "_rAppeal")) return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait at least 60 seconds before appealing an admin action.");
			        SendReportToQue(playerid,"Appeal Admin Action", 4, GetPlayerPriority(playerid));
			        SendClientMessageEx(playerid, COLOR_WHITE, "Your Appeal Admin Action report has been sent to the current available admins.");
			    }
			    case 7: //Prize Claim
			    {
			        if(PlayerInfo[playerid][pFlagged] == 0) {
			            SendClientMessageEx(playerid, COLOR_GREY, "You do not have any prize claims pending. (Not Flagged)");
			            return 1;
			        }
			        else
			        {
			            SendReportToQue(playerid, "Prize Claim", 4, 5);
			            SendClientMessageEx(playerid, COLOR_WHITE, "Your Prize Claim report has been sent to the current available admins.");
			        }
			    }
			    case 8: //Shop Issue
	            {
	                ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Shop Issue", "{FFFFFF}You can use /shophelp for additional information.", "Close", "");
	            }
	            case 9: //Not Listed Here
	            {
	                ShowPlayerDialog(playerid, DIALOG_REPORTNOTLIST, DIALOG_STYLE_INPUT,"Not Listed","Using this category will receive a slower response from the admin team, please consider using the most appropriate category for a faster response.","Send","Cancel");
				}
				case 10: // Request CA
				{
					if(PlayerInfo[playerid][pRHMutes] >= 4 || PlayerInfo[playerid][pRHMuteTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You are currently banned from requesting help.");
					if(JustReported[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Wait 10 seconds after sending a next request!");
					JustReported[playerid]=10;
					format(string, sizeof(string), "** %s(%i) is requesting help, reason: Report Menu. (type /accepthelp %i)", GetPlayerNameEx(playerid), playerid, playerid);
					SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have requested help from a Community Advisor, wait for a reply.");
					SetPVarInt( playerid, "COMMUNITY_ADVISOR_REQUEST", 1 );
					SetPVarInt( playerid, "HelpTime", 5);
					SetPVarString( playerid, "HelpReason", "Report Menu");
					SetTimerEx( "HelpTimer", 60000, 0, "d", playerid);
				}
				case 11: //Request Unmute
				{
				    if(gettime()-GetPVarInt(playerid, "UnmuteTime") < 300) {
				        SendClientMessageEx(playerid, COLOR_GREY, "You must wait at least 5 minutes before requesting an unmute.");
				        return 1;
				    }
    				ShowPlayerDialog(playerid, DIALOG_UNMUTE, DIALOG_STYLE_LIST, "Requesting Unmute", "Ad Unmute\nNewbie Unmute", "Select", "Exit");
	            }
			    case 12: //Previous Page
			    {
	    			ShowPlayerDialog(playerid, DIALOG_REPORTMENU, DIALOG_STYLE_LIST, "Report Menu [1/2]", "Deathmatch\nHacking\nRevenge Killing\nChicken Running\nCar Ramming\nPower Gaming\nMeta Gaming\nGun Discharge Exploits (QS/CS)\nSpamming\nMoney Farming\nBan Evader\nGeneral Exploits\nReleasing Hitman Names\nRunning Man Exploiter\nCar Surfing\nNonRP Behavior\nNext Page","Select", "Exit");
       			}
			}
		}
	}
	else if(dialogid == DIALOG_UNMUTE)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
					if(PlayerInfo[playerid][pADMute] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You are not muted from /ads.");
					SetPVarInt(playerid, "_rAutoM", 1);
					SendReportToQue(playerid, "Ad Unmute", 2, GetPlayerPriority(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, "Your report has been sent to the current available admins.");		
	            }
	            case 1:
	            {
					if(PlayerInfo[playerid][pNMute] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You are not muted from /newb.");
					SetPVarInt(playerid, "_rAutoM", 2);
					SendReportToQue(playerid, "Newbie Unmute", 2, GetPlayerPriority(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, "Your report has been sent to the current available admins.");
				}
	        }
	    }
	}
	else if(dialogid == DIALOG_REPORTDM)
	{
	    if(response)
	    {
	        new
	            Player;

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTDM, DIALOG_STYLE_INPUT, "Report player - Deathmatch", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTDM, DIALOG_STYLE_INPUT, "Report player - Deathmatch", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			if(PlayerInfo[playerid][pDMRMuted] != 0) return SendClientMessage(playerid, COLOR_GRAD2, "You are blocked from submitting DM reports.");
			if(PlayerInfo[playerid][pLevel] < 2) return SendClientMessage(playerid, COLOR_GRAD2, "You must be level 2 to use this command.");
			if(playerid == Player) return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself!");

			if(PlayerInfo[Player][pAdmin] >= 2 && PlayerInfo[Player][pTogReports] != 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on admins!");
			if(gettime() - ShotPlayer[Player][playerid] < 300)
  			{
				SetPVarInt(playerid, "pDMReport", Player);
				ShowPlayerDialog(playerid, DMRCONFIRM, DIALOG_STYLE_MSGBOX, "DM Report", "You personally witnessed the reported player death matching within the last 60 seconds. Abuse of this command could result in a temporary ban.", "Confirm", "Cancel");
			}
			else
			{
  				SendClientMessage(playerid, COLOR_WHITE, "You have not been shot by that person or have already reported them in the last 5 minutes.");
				SendClientMessage(playerid, COLOR_WHITE, "As a reminder, abuse of this system could lead to punishment up to a temporary ban.");
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTRK)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTRK, DIALOG_STYLE_INPUT, "Report player - Revenge Killing", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTRK, DIALOG_STYLE_INPUT, "Report player - Revenge Killing", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 4);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Revenge Killing", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid, Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Revenge Killing. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTCR)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTCR, DIALOG_STYLE_INPUT, "Report player - Chicken Running", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTCR, DIALOG_STYLE_INPUT, "Report player - Chicken Running", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Chicken Running", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Chicken Running. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTCARRAM)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTCARRAM, DIALOG_STYLE_INPUT, "Report player - Car Ramming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTCARRAM, DIALOG_STYLE_INPUT, "Report player - Car Ramming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Car Ramming", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Car Ramming. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTPG)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTPG, DIALOG_STYLE_INPUT, "Report player - Power Gaming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTPG, DIALOG_STYLE_INPUT, "Report player - Power Gaming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Power Gaming", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Power Gaming. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTMG)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTMG, DIALOG_STYLE_INPUT, "Report player - Meta Gaming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTMG, DIALOG_STYLE_INPUT, "Report player - Meta Gaming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 6);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Meta Gaming", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Meta Gaming. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTSPAM)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTSPAM, DIALOG_STYLE_INPUT, "Report player - Spamming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTSPAM, DIALOG_STYLE_INPUT, "Report player - Spamming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 6);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Spamming", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Spamming. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTGDE)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTGDE, DIALOG_STYLE_INPUT, "Report player - Gun Discharge Exploits", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTGDE, DIALOG_STYLE_INPUT, "Report player - Gun Discharge Exploits", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Gun Discharge Exploits", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Gun Discharge Exploits. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
 	else if(dialogid == DIALOG_REPORTHACK)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTHACK, DIALOG_STYLE_INPUT, "Report player - Hacking", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTHACK, DIALOG_STYLE_INPUT, "Report player - Hacking", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Hacking", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, 2);
				format(Message, sizeof(Message), "You have submitted a report on %s for Hacking. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTMF)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTMF, DIALOG_STYLE_INPUT, "Report player - Money Farming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTMF, DIALOG_STYLE_INPUT, "Report player - Money Farming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				format(Message, sizeof(Message), "%s(%i) Money Farming", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Money Farming. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTSA)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTSA, DIALOG_STYLE_INPUT, "Report player - Server Advertising", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTSA, DIALOG_STYLE_INPUT, "Report player - Server Advertising", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 6);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Server Advertising", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, 2);
				format(Message, sizeof(Message), "You have submitted a report on %s for Server Advertising. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTNRPN)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTNRPN, DIALOG_STYLE_INPUT, "Report player - NonRP Name", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTNRPN, DIALOG_STYLE_INPUT, "Report player - NonRP Name", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 3);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) NonRP Name", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for NonRP Name. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTBANEVADE)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTBANEVADE, DIALOG_STYLE_INPUT, "Report player - Ban Evader", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTBANEVADE, DIALOG_STYLE_INPUT, "Report player - Ban Evader", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				format(Message, sizeof(Message), "%s(%i) Ban Evader", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Ban Evader. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTGE)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTGE, DIALOG_STYLE_INPUT, "Report player - General Exploits", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTGE, DIALOG_STYLE_INPUT, "Report player - General Exploits", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				format(Message, sizeof(Message), "%s(%i) General Exploits", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for General Exploits. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTRHN)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTRHN, DIALOG_STYLE_INPUT, "Report player - Releasing Hitman Names", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTRHN, DIALOG_STYLE_INPUT, "Report player - Releasing Hitman Names", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				format(Message, sizeof(Message), "%s(%i) Releasing Hitman Names", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Releasing Hitman Names. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTRSE)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTRSE, DIALOG_STYLE_INPUT, "Report player - Running/Swimming Man Exploit", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTRSE, DIALOG_STYLE_INPUT, "Report player - Running/Swimming Man Exploit", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				format(Message, sizeof(Message), "%s(%i) Running/Swimming Man Exploit", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Running/Swimming Man Exploit. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTCARSURF)
	{
	    if(response)
	    {
	        new
	            Player,
				Message[128];

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTCARSURF, DIALOG_STYLE_INPUT, "Report player - Car Surfing", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTCARSURF, DIALOG_STYLE_INPUT, "Report player - Car Surfing", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
			    SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Car Surfing", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Car Surfing. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTNRPB)
	{
	    if(response)
	    {
	        new
	            Player;

            if(sscanf(inputtext, "u", Player)) {
        		ShowPlayerDialog(playerid, DIALOG_REPORTNRPB, DIALOG_STYLE_INPUT, "Report player - NonRP Behavior", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialog(playerid, DIALOG_REPORTNRPB, DIALOG_STYLE_INPUT, "Report player - NonRP Behavior", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
		    	SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
			    SetPVarInt(playerid, "NRPB", Player);
			    ShowPlayerDialog(playerid, DIALOG_REPORTNRPB2, DIALOG_STYLE_INPUT,"Report player - NonRP Behavior","Explain what the person is doing.","Send","Cancel");
			}
	    }
	}
	else if(dialogid == DIALOG_REPORTNRPB2)
	{
		if(response == 1)
		{
		    if(isnull(inputtext)) {
		        ShowPlayerDialog(playerid, DIALOG_REPORTNRPB2, DIALOG_STYLE_INPUT,"Report player - NonRP Behavior","Explain what the person is doing.","Send","Cancel");
		    }

			new
			    Message[128],
				Player;

			Player = GetPVarInt(playerid, "NRPB");
			SetPVarInt(playerid, "_rAutoM", 5);
			SetPVarInt(playerid, "_rRepID", Player);
		    format(Message, sizeof(Message), "%s(%i), %s (nonrp behavior)", GetPlayerNameEx(Player), Player, inputtext);
   		    SendReportToQue(playerid, Message, 2, GetPlayerPriority(playerid));
   		    format(Message, sizeof(Message), "You have submitted a report on %s for NonRP Behavior. It has been sent to all available admins.", GetPlayerNameEx(Player));
			SendClientMessageEx(playerid, COLOR_WHITE, Message);
   		    DeletePVar(playerid, "NRPB");
		}
		else {
		    DeletePVar(playerid, "NRPB");
		}
	}
	else if(dialogid == DIALOG_REPORTFREE)
	{
		if(response == 1)
		{
		    if(isnull(inputtext)) {
		        ShowPlayerDialog(playerid, DIALOG_REPORTFREE, DIALOG_STYLE_INPUT,"Other / Free Text","(Error - No Message) Enter the message you want to send to the admin team.","Send","Cancel");
		    }

   		    SendReportToQue(playerid, inputtext, 2, GetPlayerPriority(playerid));
   		    SendClientMessageEx(playerid, COLOR_WHITE, "Your message has been sent to the admin team.");
		}
	}
	else if(dialogid == DIALOG_REPORTNOTLIST)
	{
		if(response == 1)
		{
		    if(isnull(inputtext)) {
		        ShowPlayerDialog(playerid, DIALOG_REPORTNOTLIST, DIALOG_STYLE_INPUT,"Not Listed","(Error - No Message) Using this category will receive a slower response from the admin team, please consider using the most appropriate category for a faster response","Send","Cancel");
		    }

			SetPVarString(playerid, "ReportNotList", inputtext);

			ShowPlayerDialog(playerid, DIALOG_REPORTNOTLIST2, DIALOG_STYLE_MSGBOX, "Not Listed", "Are you sure your report doesn't fit under any other report categories?", "Yes", "No");
		}
	}
	else if(dialogid == DIALOG_REPORTNOTLIST2)
	{
	    if(response == 1)
	    {
			new Message[128];

			GetPVarString(playerid, "ReportNotList", Message, sizeof(Message));
			SendReportToQue(playerid, Message, 2, 5);
			SendClientMessageEx(playerid, COLOR_WHITE, "Your message has been sent to to the admin team.");
	    }
	}
	else if(dialogid == DIALOG_SPEAKTOADMIN)
	{
		if(response == 1)
		{
		    if(isnull(inputtext)) {
		        ShowPlayerDialog(playerid, DIALOG_REPORTNOTLIST, DIALOG_STYLE_INPUT,"Other / Free Text","(Error - No Message) Using this category will receive a slower response from the admin team, please consider using the most appropriate category for a faster response","Send","Cancel");
		    }

			SetPVarString(playerid, "ReportNotList", inputtext);

			ShowPlayerDialog(playerid, DIALOG_REPORTNOTLIST2, DIALOG_STYLE_MSGBOX, "Other / Free Text", "Are you sure you need to contact an admin?", "Yes", "No");
		}
	}
	else if(dialogid == DIALOG_REPORTNAME)
	{
	    new
			Player;

		Player = GetPVarInt(playerid, "NameChange");

        if(GetPVarInt(Player, "RequestingNameChange") == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person isn't requesting a namechange!");
			return 1;
		}
		if(response == 1)
		{
			new newname[MAX_PLAYER_NAME], tmpName[24];
			GetPVarString(Player, "NewNameRequest", newname, MAX_PLAYER_NAME);
			mysql_escape_string(newname, tmpName);
			SetPVarString(Player, "NewNameRequest", tmpName);

			format(string, sizeof(string), "SELECT `Username` FROM `accounts` WHERE `Username`='%s'", tmpName);
			mysql_function_query(MainPipeline, string, true, "OnApproveName", "ii", playerid, Player);

		}
		else
		{
			SendClientMessageEx(Player,COLOR_YELLOW," Your name change request has been denied.");
			format(string, sizeof(string), " You have denied %s's name change request.", GetPlayerNameEx(Player));
			SendClientMessageEx(playerid,COLOR_YELLOW,string);
			format(string, sizeof(string), "%s has denied %s's name change request",GetPlayerNameEx(playerid),GetPlayerNameEx(Player));
			ABroadCast(COLOR_YELLOW, string, 3);
			SetPVarInt(Player, "LastNameChange", gettime());
			DeletePVar(Player, "RequestingNameChange");
		}
	}
	else if(dialogid == DIALOG_REPORTTEAMNAME)
	{
	    new
			Player;

		Player = GetPVarInt(playerid, "RFLNameChange");

        if(GetPVarInt(Player, "RFLNameRequest") == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person isn't requesting a namechange!");
			return 1;
		}
		if(response == 1)
		{
			new newname[25], tmpName[25], query[128];
			GetPVarString(Player, "NewRFLName", newname, MAX_PLAYER_NAME);
			mysql_real_escape_string(newname, tmpName);
			SetPVarString(Player, "NewRFLName", tmpName);
			format(query, sizeof(query), "SELECT `name` FROM `rflteams` WHERE `name` = '%s'", tmpName);
			mysql_function_query(MainPipeline, query, true, "OnCheckRFLName", "ii", playerid, Player);
		}
		else
		{
			SendClientMessageEx(Player,COLOR_YELLOW," Your team name change request has been denied.");
			format(string, sizeof(string), " You have denied %s's team name change request.", GetPlayerNameEx(Player));
			SendClientMessageEx(playerid,COLOR_YELLOW,string);
			format(string, sizeof(string), "%s has denied %s's team name change request",GetPlayerNameEx(playerid),GetPlayerNameEx(Player));
			ABroadCast(COLOR_YELLOW, string, 3);
			DeletePVar(Player, "RFLNameRequest");
			DeletePVar(playerid, "RFLNameChange");
			DeletePVar(Player, "NewRFLName");
		}
	}		
	else if(dialogid == DIALOG_DEDICATEDPLAYER)
	{
	    if(response)
	    {
            new
                szName[MAX_PLAYER_NAME],
				szDialogStr[260],
				szFileStr[32],
				iPos,
				iCount = 0,
				iTime = gettime() - 5184000,
				File: fDedicated = fopen("RewardDedicated.cfg", io_read);

            GetPVarString(playerid, "DedicatedPlayer", szName, sizeof(szName));

			while(fread(fDedicated, szFileStr)) {
    			iPos = strfind(szFileStr, "|");

				if(strval(szFileStr[iPos + 1]) > iTime && iCount == 0 && strcmp(szFileStr, szName, false, strlen(szName))==0 ) {
					szFileStr[iPos] = 0;
					strcat(szDialogStr, szFileStr);
					iCount++;

					strcat(szDialogStr, "\n");
				}
				else if(iCount > 0)
				{
				    szFileStr[iPos] = 0;
					strcat(szDialogStr, szFileStr);
					iCount++;
                    if(iCount == 10) {
						SetPVarString(playerid, "DedicatedPlayer", szFileStr);
						printf("%s - Dedicated Player", szFileStr);
						break;
					}
					strcat(szDialogStr, "\n");
				}
			}
			fclose(fDedicated);
			//szDialogStr[strlen(szDialogStr) - 1] = 0;
			if(iCount == 10)
			{
				ShowPlayerDialog(playerid, DIALOG_DEDICATEDPLAYER, DIALOG_STYLE_LIST, "Dedicated Players (over 150 Reward Hours)", szDialogStr, "Next", "Exit");
			}
			else
			{
			    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "Dedicated Players (over 150 Reward Hours)", szDialogStr, "Exit", "");
			}
	        return 1;
	    }
	}

	else if (dialogid == DIALOG_POSTAMP && response)
	{

	    switch (listitem) {
			case REGULAR_MAIL: {
				SetPVarInt(playerid, "LetterTime", 240);
				SetPVarInt(playerid, "LetterCost", 100);
			}
			case PRIORITY_MAIL: {
				SetPVarInt(playerid, "LetterTime", 120);
				SetPVarInt(playerid, "LetterCost", 250);
			}
			case PREMIUM_MAIL: {
				if (PlayerInfo[playerid][pDonateRank] < 3) {
				    return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least Gold VIP for sending Premium Mail.");
				}
				else {
					SetPVarInt(playerid, "LetterCost", 500);
	        	   	SetPVarInt(playerid, "LetterNotify", 1);
				}
			}
			case GOVERNMENT_MAIL:  {
				if (!IsAGovernment(playerid) && !IsACop(playerid) && !IsAJudge(playerid)) {
		  			return SendClientMessageEx(playerid, COLOR_GREY, " Only Government agencies can use Government Mail! ");
				}
				if (PlayerInfo[playerid][pRank] < 4) {
					return SendClientMessageEx(playerid, COLOR_GREY, " Only rank 4 or higher can do this.");
				}
				SetPVarInt(playerid, "LetterTime", 60);
				SetPVarInt(playerid, "LetterCost", 500);
	       	    SetPVarInt(playerid, "LetterNotify", 1);
				SetPVarInt(playerid, "LetterGov", 1);
			}
			default:
			    return 1;
		}

		if (listitem != GOVERNMENT_MAIL && GetPlayerCash(playerid) < GetPVarInt(playerid, "LetterCost")) {
			DeletePVar(playerid, "LetterTime");
			DeletePVar(playerid, "LetterCost");
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the stamp.");
		}

		ShowPlayerDialog(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FFFFFF}Please type the name of the recipient (online or offline)", "Next", "Cancel");

		return 1;

 	}

 	else if (dialogid == DIALOG_PORECEIVER && response)
	{

		if (!strlen(inputtext)) {
			ShowPlayerDialog(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}Recipient Name Not Entered!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");
			return 1;
		}

		if (strlen(inputtext) > 20) {
			ShowPlayerDialog(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}Recipient Name Too Long!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");
			return 1;
		}

		if (strcmp(inputtext, GetPlayerNameExt(playerid), true) == 0) {
			ShowPlayerDialog(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}Invalid Recipient! - Can't send to yourself!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");
			return 1;
		}

		SetPVarString(playerid, "LetterRecipientName", inputtext);

		new giveplayer = ReturnUser(inputtext);
		if(giveplayer == INVALID_PLAYER_ID)
		{
			new szQuery[256];
			format(szQuery, sizeof(szQuery), "SELECT `id`, `AdminLevel`, `TogReports` FROM `accounts` WHERE `Username` = '%s'", g_mysql_ReturnEscaped(inputtext,MainPipeline));
			mysql_function_query(MainPipeline, szQuery, true, "RecipientLookupFinish", "i", playerid);
		}
		else
		{
			if(PlayerInfo[giveplayer][pAdmin] >= 2 && PlayerInfo[giveplayer][pTogReports] != 1)
			{
				ShowPlayerDialog(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}You can't send a letter to admins!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");
			}
			else
			{
				SetPVarInt(playerid, "LetterRecipient", GetPlayerSQLId(giveplayer));
				ShowPlayerDialog(playerid, DIALOG_POMESSAGE, DIALOG_STYLE_INPUT, "Send Letter", "{FFFFFF}Please type the message.", "Send", "Cancel");
			}
		}
 		return 1;
 	}

	else if (dialogid == DIALOG_POMESSAGE && response)
	{

	    if (PlayerInfo[playerid][pAdmin] < 2 && CheckServerAd(inputtext)) {
		    format(string,sizeof(string),"Warning: %s may be server advertising via mail: '%s'.", GetPlayerNameEx(playerid),inputtext);
			ABroadCast(COLOR_RED, string, 2);
			Log("logs/hack.log", string);
			return 1;
		}

		new query[512], rec[MAX_PLAYER_NAME];

        if (strlen(inputtext) == 0) {
			ShowPlayerDialog(playerid, DIALOG_POMESSAGE, DIALOG_STYLE_INPUT, "Send Letter", "{FF3333}Error: {FFFFFF}Message Not Entered!\n\nPlease type the message.", "Send", "Cancel");
			return 1;
	 	}
		if (strlen(inputtext) > 128) return 1; // Apparently not possible, but just in case

		if (!GetPVarType(playerid, "LetterGov")) {
			if (GetPlayerCash(playerid) < GetPVarInt(playerid, "LetterCost")) {
				return SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the stamp.");
			}
			GivePlayerCash(playerid, -GetPVarInt(playerid, "LetterCost"));
		}
		else {
			DeletePVar(playerid, "LetterGov");
			if (Tax < 500) return SendClientMessageEx(playerid, COLOR_WHITE, "No government funds are available for stamp.");
			Tax -= 500;
			Misc_Save();
		}

		format(query,sizeof(query),	"INSERT INTO `letters` (`Sender_Id`, `Receiver_Id`, `Date`, `Message`, `Delivery_Min`, `Notify`) VALUES (%d, %d, NOW(), '%s', %d, %d)", GetPlayerSQLId(playerid), GetPVarInt(playerid, "LetterRecipient"), g_mysql_ReturnEscaped(inputtext, MainPipeline), GetPVarInt(playerid, "LetterTime"), GetPVarInt(playerid, "LetterNotify"));
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

		if (GetPVarInt(playerid, "LetterTime") == 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Your letter has been sent. It will be delivered immediately.");

			GetPVarString(playerid, "LetterRecipientName", rec, MAX_PLAYER_NAME);
			new xid=ReturnUser(rec);
			if (xid != INVALID_PLAYER_ID)
			{
				if (PlayerInfo[xid][pDonateRank] >= 4 && HasMailbox(xid))
				{
					SendClientMessageEx(xid, COLOR_YELLOW, "A letter has just been delivered to your mailbox.");
					SetPVarInt(xid, "UnreadMails", 1);
				}
			}
		}
		else
		{
			format(string, sizeof(string), "Your letter has been sent. It will be delivered in %d hour(s).", GetPVarInt(playerid, "LetterTime") / 60);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}

		PlayerInfo[playerid][pPaper]--;
		DeletePVar(playerid, "LetterCost");
		DeletePVar(playerid, "LetterTime");
		DeletePVar(playerid, "LetterRecipient");
		DeletePVar(playerid, "LetterNotify");
		SetPVarInt(playerid, "MailTime", 30);

		new szLog[128];
		format(szLog, sizeof(szLog), "%s has sent mail to %s: %s", GetPlayerNameEx(playerid), rec, inputtext);
		Log("logs/mail.log", szLog);

		return 1;

	}

	else if (dialogid == DIALOG_POMAILS && response)
	{
		SetPVarInt(playerid, "ReadingMail", ListItemTrackId[playerid][listitem]);
		DisplayMailDetails(playerid, ListItemTrackId[playerid][listitem]);
	}

	else if (dialogid == DIALOG_PODETAIL)
	{

		if (response) // Back
		{
		    DisplayMails(playerid);
		}
		else // Trash
  		{
    	    new query[64];
		    format(query, sizeof(query), "DELETE FROM `letters` WHERE `ID` = %i", GetPVarInt(playerid, "ReadingMail"));
			mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		    ShowPlayerDialog(playerid, DIALOG_POTRASHED, DIALOG_STYLE_MSGBOX, "Info", "You've trashed your mail.", "Back", "Close");
		}
		DeletePVar(playerid, "ReadingMail");
		return 1;
	}

	else if (dialogid == DIALOG_POTRASHED && response)
	{

		DisplayMails(playerid);
 		return 1;

	}

	else if (dialogid == DIALOG_STOREPRICES)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingBusiness");
		}
		else {
			format(string, sizeof(string), "{FFFFFF}Enter the new sale price for %s\n(Items with the price of $0 will not be for sale)", StoreItems[listitem]);
		    ShowPlayerDialog(playerid, DIALOG_STOREITEMPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
		    SetPVarInt(playerid, "EditingStoreItem", listitem);
	    }
	    return 1;
	}

	else if (dialogid == DIALOG_BARPRICE)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingBusiness");
		}
		else {
			format(string, sizeof(string), "{FFFFFF}Enter the new sale price for %s\n(Items with the price of $0 will not be for sale)", Drinks[listitem]);
		    ShowPlayerDialog(playerid, DIALOG_BARPRICE2, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
		    SetPVarInt(playerid, "EditingStoreItem", listitem);
	    }
	    return 1;
	}
	else if(dialogid == DIALOG_SEXSHOP)
	{
	    if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingBusiness");
		}
		else {
			format(string, sizeof(string), "{FFFFFF}Enter the new sale price for %s\n(Items with the price of $0 will not be for sale)", Drinks[listitem]);
		    ShowPlayerDialog(playerid, DIALOG_SEXSHOP2, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
		    SetPVarInt(playerid, "EditingStoreItem", listitem);
	    }
	    return 1;
	}
	else if (dialogid == DIALOG_RESTAURANT)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5)
		{
			DeletePVar(playerid, "EditingBusiness");
		}
		else
		{
			format(string, sizeof(string), "{FFFFFF}Enter the new sale price for %s\n(Items with the price of $0 will not be for sale)", RestaurantItems[listitem]);
			ShowPlayerDialog(playerid, DIALOG_RESTAURANT2, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
			SetPVarInt(playerid, "EditingStoreItem", listitem);
		}
	}
	else if (dialogid == DIALOG_SEXSHOP2)
	{

		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		new iBusiness = PlayerInfo[playerid][pBusiness];

		if (response) {
			new iPrice = strval(inputtext), item = GetPVarInt(playerid, "EditingStoreItem");

			if (iPrice < 0 || iPrice > 500000) {
				format(string, sizeof(string), "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for %s", Drinks[item]);
			    ShowPlayerDialog(playerid, DIALOG_STOREITEMPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "%s price has been set to $%s!", SexItems[item], number_format(iPrice));
			Businesses[iBusiness][bItemPrices][item] = iPrice;
			SaveBusiness(iBusiness);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s (IP: %s) has set the %s price to %s in %s ($%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), SexItems[item], number_format(iPrice), Businesses[iBusiness][bName], iBusiness);
			new szDialog[302];
			for (new i = 0; i <= 13; i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, SexItems[i], number_format(Businesses[iBusiness][bItemPrices][i]));
	        ShowPlayerDialog(playerid, DIALOG_BARPRICE, DIALOG_STYLE_LIST, "Edit Business Prices", szDialog, "Okay", "Cancel");
			Log("logs/business.log", string);
	    }
	    DeletePVar(playerid, "EditingStoreItem");
	    return 1;
	}
	else if (dialogid == DIALOG_RESTAURANT2)
	{
		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5)
		{
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		new business = PlayerInfo[playerid][pBusiness];

		if (response)
		{
			new price = strval(inputtext), item = GetPVarInt(playerid, "EditingStoreItem");

			if (price < 0 || price > 500000)
			{
				format(string, sizeof(string), "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for %s", RestaurantItems[item]);
			    ShowPlayerDialog(playerid, DIALOG_RESTAURANT2, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "%s price has been set to $%s!", RestaurantItems[item], number_format(price));
			Businesses[business][bItemPrices][item] = price;
			SaveBusiness(business);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s (IP: %s) has set the %s price to %s in %s ($%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), RestaurantItems[item], number_format(price), Businesses[business][bName], business);
			new szDialog[302];
			for (new i = 0; i <= 13; i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, RestaurantItems[i], number_format(Businesses[business][bItemPrices][i]));
	        ShowPlayerDialog(playerid, DIALOG_RESTAURANT, DIALOG_STYLE_LIST, "Edit Business Prices", szDialog, "Okay", "Cancel");
			Log("logs/business.log", string);
		}

		DeletePVar(playerid, "EditingStoreItem");
		return 1;
	}
    else if (dialogid == DIALOG_BARPRICE2)
	{

		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		new iBusiness = PlayerInfo[playerid][pBusiness];

		if (response) {
			new iPrice = strval(inputtext), item = GetPVarInt(playerid, "EditingStoreItem");

			if (iPrice < 0 || iPrice > 500000) {
				format(string, sizeof(string), "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for %s", Drinks[item]);
			    ShowPlayerDialog(playerid, DIALOG_STOREITEMPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "%s price has been set to $%s!", Drinks[item], number_format(iPrice));
			Businesses[iBusiness][bItemPrices][item] = iPrice;
			SaveBusiness(iBusiness);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s (IP: %s) has set the %s price to $%s in %s (%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), Drinks[item], number_format(iPrice), Businesses[iBusiness][bName], iBusiness);
			new szDialog[302];
			for (new i = 0; i <= 13; i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, Drinks[i], number_format(Businesses[iBusiness][bItemPrices][i]));
	        ShowPlayerDialog(playerid, DIALOG_BARPRICE, DIALOG_STYLE_LIST, "Edit Business Prices", szDialog, "Okay", "Cancel");
			Log("logs/business.log", string);
	    }
	    DeletePVar(playerid, "EditingStoreItem");
	    return 1;
	}
	else if (dialogid == DIALOG_STOREITEMPRICE)
	{

		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		new iBusiness = PlayerInfo[playerid][pBusiness];

		if (response) {
			new iPrice = strval(inputtext), item = GetPVarInt(playerid, "EditingStoreItem");

			if (iPrice < 0 || iPrice > 500000) {
				format(string, sizeof(string), "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for %s", StoreItems[item]);
			    ShowPlayerDialog(playerid, DIALOG_STOREITEMPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "OK", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "%s price has been set to $%s!", StoreItems[item], number_format(iPrice));
			Businesses[iBusiness][bItemPrices][item] = iPrice;
			SaveBusiness(iBusiness);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s (IP: %s) has set the %s price to $%s in %s (%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), StoreItems[item], number_format(iPrice), Businesses[iBusiness][bName], iBusiness);
			new szDialog[912];
			for (new i = 0; i <= sizeof(StoreItems); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s) (Cost of Good: $%s)\n", szDialog, StoreItems[i], number_format(Businesses[iBusiness][bItemPrices][i]), number_format(floatround(StoreItemCost[i][ItemValue] * BUSINESS_ITEMS_COST)));
	        ShowPlayerDialog(playerid, DIALOG_STOREPRICES, DIALOG_STYLE_LIST, "Edit 24/7 Prices", szDialog, "OK", "Cancel");
			Log("logs/business.log", string);
	    }
	    DeletePVar(playerid, "EditingStoreItem");
	    return 1;
	}
	else if(dialogid == DIALOG_STORECLOTHINGPRICE)
	{
	    new iBusiness = PlayerInfo[playerid][pBusiness];

        if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		if (response) {
			new iPrice = strval(inputtext);

			if (iPrice < 0 || iPrice > 500000) {
			    ShowPlayerDialog(playerid, DIALOG_STORECLOTHINGPRICE, DIALOG_STYLE_INPUT, "Edit Price", "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for clothing", "Okay", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "Clothing price has been set to $%s!", number_format(iPrice));
			Businesses[iBusiness][bItemPrices][0] = iPrice;
			SaveBusiness(iBusiness);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s (IP: %s) has set the %s price to $%s in %s (%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), "clothing", number_format(iPrice), Businesses[iBusiness][bName], iBusiness);
			Log("logs/business.log", string);
	    }

	    DeletePVar(playerid, "EditingStoreItem");
	}
	else if (dialogid == DIALOG_GUNPRICES)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingBusiness");
		}
		else {
			format(string, sizeof(string), "{FFFFFF}Enter the new sale price for %s\n(Items with the price of $0 will not be for sale)", GetWeaponNameEx(Weapons[listitem][WeaponId]));
		    ShowPlayerDialog(playerid, DIALOG_GUNSHOPPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
		    SetPVarInt(playerid, "EditingStoreItem", listitem);
	    }
	    return 1;
	}
	else if(dialogid == DIALOG_GUNSHOPPRICE)
	{
		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		new iBusiness = PlayerInfo[playerid][pBusiness];

		if (response) {
			new iPrice = strval(inputtext), item = GetPVarInt(playerid, "EditingStoreItem");

			if (iPrice < 0 || iPrice > 500000) {
				format(string, sizeof(string), "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for %s", StoreItems[item]);
			    ShowPlayerDialog(playerid, DIALOG_GUNSHOPPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "OK", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "%s price has been set to $%s!", GetWeaponNameEx(Weapons[item][WeaponId]), number_format(iPrice));
			Businesses[iBusiness][bItemPrices][item] = iPrice;
			SaveBusiness(iBusiness);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s (IP: %s) has set the %s price to $%s in %s (%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetWeaponParam(item, WeaponId), number_format(iPrice), Businesses[iBusiness][bName], iBusiness);
			new szDialog[512];
			for (new i = 0; i < sizeof(Weapons); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, GetWeaponNameEx(Weapons[i][WeaponId]), number_format(Businesses[iBusiness][bItemPrices][i]));
	        ShowPlayerDialog(playerid, DIALOG_GUNPRICES, DIALOG_STYLE_LIST, "Edit Gun Store Prices", szDialog, "OK", "Cancel");
			Log("logs/business.log", string);
	    }
	    DeletePVar(playerid, "EditingStoreItem");
	    return 1;
	}
	else if (dialogid == DIALOG_GASPRICE)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || PlayerInfo[playerid][pBusinessRank] != 5) {
		}
		else {
		    new szSaleText[148], Float:price = floatstr(inputtext);
		    if (price < 1 || price > 500) return SendClientMessageEx(playerid, COLOR_WHITE, "Price can't be lower than $1 or higher than $500");
			Businesses[PlayerInfo[playerid][pBusiness]][bGasPrice] = price;
			for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++)
			{
				format(szSaleText,sizeof(szSaleText),"Price Per Gallon: $%.2f\nThis Sale: $%.2f\nGallons: %.3f\nGas Available: %.2f/%.2f gallons", price, Businesses[PlayerInfo[playerid][pBusiness]][GasPumpSalePrice][i], Businesses[PlayerInfo[playerid][pBusiness]][GasPumpSaleGallons][i], Businesses[PlayerInfo[playerid][pBusiness]][GasPumpGallons][i], Businesses[PlayerInfo[playerid][pBusiness]][GasPumpCapacity][i]);
				UpdateDynamic3DTextLabelText(Businesses[PlayerInfo[playerid][pBusiness]][GasPumpSaleTextID][i], COLOR_YELLOW, szSaleText);
			}
			SaveBusiness(PlayerInfo[playerid][pBusiness]);
			format(string, sizeof(string), "Gallon price has been set to %.2f!", price);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s (IP: %s) has set the gas price to %f in %s", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), price, Businesses[PlayerInfo[playerid][pBusiness]][bName]);
			Log("logs/business.log", string);
	    }
		DeletePVar(playerid, "EditingBusiness");
	    return 1;
	}

	else if (dialogid == DIALOG_SWITCHGROUP && response)
	{

		if (!(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1)) return 1;

		new
			iGroupID = listitem;

		if(arrGroupData[iGroupID][g_iGroupType] == 2) {
			return SendClientMessage(playerid, COLOR_WHITE, "You can't switch to a contract agency with this command.");
		}

		format(string, sizeof(string), "You have switched to group ID %d (%s).", iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		PlayerInfo[playerid][pMember] = iGroupID;
		PlayerInfo[playerid][pRank] = Group_GetMaxRank(iGroupID);
		PlayerInfo[playerid][pFMember] = INVALID_FAMILY_ID;
		PlayerInfo[playerid][pLeader] = -1;
	}

	else if (dialogid == DIALOG_MAKELEADER && response)
	{
		if (PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pFactionModerator] >= 2)
		{
			new
				iGroupID = listitem,
				iTargetID = GetPVarInt(playerid, "MakingLeader");

			if(!arrGroupData[iGroupID][g_szGroupName][0]) { return SendClientMessageEx(playerid, COLOR_GREY, "This group has not been properly set up yet."); }

			PlayerInfo[iTargetID][pLeader] = iGroupID;
			PlayerInfo[iTargetID][pMember] = iGroupID;
			PlayerInfo[iTargetID][pRank] = Group_GetMaxRank(iGroupID);
			PlayerInfo[iTargetID][pDivision] = -1;
			PlayerInfo[iTargetID][pFMember] = INVALID_FAMILY_ID;
			format(string, sizeof(string), "You have been made the leader of the %s by Administrator %s.", arrGroupData[iGroupID][g_szGroupName], GetPlayerNameEx(playerid));
			SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "You have made %s the leader of the %s.", GetPlayerNameEx(iTargetID), arrGroupData[iGroupID][g_szGroupName]);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "%s have made %s the leader of the %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/group.log", string);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "You do not have access to this.");
	}
	else if (dialogid == DIALOG_HBADGE && response)
	{

		if (!IsAHitman(playerid)) return 1;

		new	iGroupID = listitem;

		if(!arrGroupData[iGroupID][g_szGroupName][0]) { return SendClientMessageEx(playerid, COLOR_GREY, "This group has not been properly set up yet."); }

		switch(listitem)
		{
			case 0..20: {
			    format(string, sizeof(string), "You have set your badge to %s", arrGroupData[iGroupID][g_szGroupName]);
			    SendClientMessageEx(playerid, COLOR_WHITE, string);
			    SetPlayerColor(playerid, arrGroupData[iGroupID][g_hDutyColour] * 256);
			    SetPVarInt(playerid, "HitmanBadgeColour", arrGroupData[iGroupID][g_hDutyColour] * 256);
			}
			default: {
				SendClientMessageEx(playerid, COLOR_GREY, "Invalid group specified.");
			}
		}
	}
	else if(dialogid == DIALOG_CDBUY)
	{
	    // Account Eating Bug Fix
	    if(!IsPlayerInAnyVehicle(playerid))
		{
		    TogglePlayerControllable(playerid, 1);
			SendClientMessageEx(playerid,COLOR_GRAD2,"You need to be in the vehicle you wish to purchase.");
			return 1;
		}

		new vehicleid = GetPlayerVehicleID(playerid);
		new playervehicleid = GetPlayerFreeVehicleId(playerid);
		new v = GetBusinessCarSlot(vehicleid);
		new d = GetCarBusiness(vehicleid);
		if(response)
		{
			if(!vehicleCountCheck(playerid))
				return SendClientMessageEx(playerid, COLOR_GREY, "ERROR: You cannot own any additional vehicles. You may purchase additional vehicle slots through /vstorage.");
				
            if(Businesses[d][bPurchaseX] == 0.0 && Businesses[d][bPurchaseY] == 0.0 && Businesses[d][bPurchaseZ] == 0.0)
            {
				SendClientMessageEx(playerid, COLOR_GRAD1, "ERROR: The owner of this Car Dealership hasn't set the purchased vehicles spawn point.");
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz+1.2);
				TogglePlayerControllable(playerid, 1);
				return 1;
            }

		    new randcolor1 = Random(0, 126);
		    new randcolor2 = Random(0, 126);
		    SetPlayerPos(playerid, Businesses[d][bParkPosX][v], Businesses[d][bParkPosY][v], Businesses[d][bParkPosZ][v]+2);
		    TogglePlayerControllable(playerid, 1);
		    new cost;
		    if(PlayerInfo[playerid][pDonateRank] < 1)
            {
                cost = Businesses[d][bPrice][v];
	            if(PlayerInfo[playerid][pCash] < cost)
	            {
					SendClientMessageEx(playerid, COLOR_GRAD1, "ERROR: You don't have enough money to buy this.");
					RemovePlayerFromVehicle(playerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(playerid, slx, sly, slz);
					SetPlayerPos(playerid, slx, sly, slz+1.2);
					return 1;
	            }

                format(string, sizeof(string), " Thank you for buying at %s.", Businesses[d][bName]);
		        SendClientMessageEx(playerid, COLOR_GRAD1, string);
				PlayerInfo[playerid][pCash] -= cost;
				cost = Businesses[d][bPrice][v] / 100 * 15;
		        Businesses[d][bSafeBalance] += TaxSale( cost );
	        }
	        else
	        {
	            cost = Businesses[d][bPrice][v];
	            if(PlayerInfo[playerid][pCash] < cost)
	            {
					SendClientMessageEx(playerid, COLOR_GRAD1, "ERROR: You don't have enough money to buy this.");
					RemovePlayerFromVehicle(playerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(playerid, slx, sly, slz);
					SetPlayerPos(playerid, slx, sly, slz+1.2);
					return 1;
	            }

                format(string, sizeof(string), " Thank you for buying at %s.",Businesses[d][bName]);
		        SendClientMessageEx(playerid, COLOR_GRAD1, string);
		        PlayerInfo[playerid][pCash] -= cost;
		        cost = Businesses[d][bPrice][v] / 100 * 15;
				Businesses[d][bSafeBalance] += TaxSale( cost );
     		}
     		Businesses[d][bInventory]--;
			Businesses[d][bTotalSales]++;
     		IsPlayerEntering{playerid} = true;
            new car = CreatePlayerVehicle(playerid, playervehicleid, Businesses[d][bModel][v], Businesses[d][bPurchaseX], Businesses[d][bPurchaseY], Businesses[d][bPurchaseZ], Businesses[d][bPurchaseAngle], randcolor1, randcolor2, cost, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
            PutPlayerInVehicle(playerid, car, 0);
            SaveBusiness(d);
		}
		else
		{
            RemovePlayerFromVehicle(playerid);
            new Float:slx, Float:sly, Float:slz;
			GetPlayerPos(playerid, slx, sly, slz);
			SetPlayerPos(playerid, slx, sly, slz+1.2);
            TogglePlayerControllable(playerid, 1);
			return 1;
		}
	}
	else if(dialogid == DIALOG_LOADTRUCKOLD) // TRUCKER JOB LOAD TRUCK
	{
 		if(response)
		{
			if(listitem == 0) // Legal goods
			{

			    ShowPlayerDialog(playerid, DIALOG_LOADTRUCKL, DIALOG_STYLE_LIST, "What do you want to transport?","{00F70C}Food & beverages\n{00F70C}Clothing\n{00F70C}Materials\n{00F70C}24/7 Items", "Select", "Cancel");
			}
			if(listitem == 1) // Illegal goods
			{
				new level = PlayerInfo[playerid][pTruckSkill];
				if(level >= 0 && level <= 50)
				{
            		ShowPlayerDialog(playerid, DIALOG_LOADTRUCKI, DIALOG_STYLE_LIST, "What do you want to transport?","{FF0606}Weapons 		{FFFFFF}(Level 1 Bonus: Free 9mm)\n{FF0606}Drugs 			{FFFFFF}(Level 1 Bonus: Free 2 pot, 1 crack)\n{FF0606}Illegal materials  	{FFFFFF}(Level 1 Bonus: Free 25 materials)", "Select", "Cancel");
				}
				else if(level >= 51 && level <= 100)
				{
		    		ShowPlayerDialog(playerid, DIALOG_LOADTRUCKI, DIALOG_STYLE_LIST, "What do you want to transport?","{FF0606}Weapons 		{FFFFFF}(Level 2 Bonus: Free Shotgun)\n{FF0606}Drugs 			{FFFFFF}(Level 2 Bonus: Free 4 pot, 2 crack)\n{FF0606}Illegal materials  	{FFFFFF}(Level 2 Bonus: Free 50 materials)", "Select", "Cancel");
				}
				else if(level >= 101 && level <= 200)
				{
		    		ShowPlayerDialog(playerid, DIALOG_LOADTRUCKI, DIALOG_STYLE_LIST, "What do you want to transport?","{FF0606}Weapons 		{FFFFFF}(Level 3 Bonus: Free MP5)\n{FF0606}Drugs 			{FFFFFF}(Level 3 Bonus: Free 6 pot, 3 crack)\n{FF0606}Illegal materials  	{FFFFFF}(Level 3 Bonus: Free 100 materials)", "Select", "Cancel");
				}
				else if(level >= 201 && level <= 400)
				{
            		ShowPlayerDialog(playerid, DIALOG_LOADTRUCKI, DIALOG_STYLE_LIST, "What do you want to transport?","{FF0606}Weapons 		{FFFFFF}(Level 4 Bonus: Free Deagle)\n{FF0606}Drugs 			{FFFFFF}(Level 4 Bonus: Free 8 pot, 4 crack)\n{FF0606}Illegal materials  	{FFFFFF}(Level 4 Bonus: Free 150 materials)", "Select", "Cancel");
				}
				else if(level >= 401)
				{
 		 			ShowPlayerDialog(playerid, DIALOG_LOADTRUCKI, DIALOG_STYLE_LIST, "What do you want to transport?","{FF0606}Weapons 		{FFFFFF}(Level 5 Bonus: Free AK-47)\n{FF0606}Drugs 			{FFFFFF}(Level 5 Bonus: Free 10 pot, 5 crack)\n{FF0606}Illegal materials  	{FFFFFF}(Level 5 Bonus: Free 200 materials)", "Select", "Cancel");
				}
			}
		}
		else
		{
		    DeletePVar(playerid, "IsFrozen");
			TogglePlayerControllable(playerid, 1);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You canceled the loading of the shipment, type /loadshipment to try again.");
		}
	}

	else if(dialogid == DIALOG_LOADTRUCKL) // TRUCKER JOB LEGAL GOODS
	{
 		if(response)
		{

			if(listitem == 0) // Food & beverages
			{
    			SetPVarInt(playerid, "TruckDeliver", 1);
    			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with food & beverages....");
			}
			if(listitem == 1) // Clothing
			{
    			SetPVarInt(playerid, "TruckDeliver", 2);
                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with clothing....");
			}
			if(listitem == 2) // Materials
			{
				SetPVarInt(playerid, "TruckDeliver", 3);
                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with materials....");
			}
			if(listitem == 3) // 24/7 Items
			{
    			SetPVarInt(playerid, "TruckDeliver", 4);
                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with 24/7 items....");
			}
			SetPVarInt(playerid, "LoadType", 1);
  			SetPVarInt(playerid, "LoadTruckTime", 10);
			SetTimerEx("LoadTruckOld", 1000, 0, "d", playerid);
		}
		else
		{
		    DeletePVar(playerid, "IsFrozen");
			TogglePlayerControllable(playerid, 1);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You canceled the loading of the shipment, type /loadshipment to try again.");
		}
	}

	else if(dialogid == DIALOG_LOADTRUCKI) // TRUCKER JOB ILLEGAL GOODS
	{
 		if(response)
		{
		    // 1 = food and bev
			// 2 = clothing
			// 3 = legal mats
			// 4 = 24/7 items
			// 5 = weapons
			// 6 = illegal drugs
			// 7 = illegal materials
		    //new level = PlayerInfo[playerid][pTruckSkill];
			if(listitem == 0) // Weapons
			{
			    SetPVarInt(playerid, "TruckDeliver", 5);
				/*if(level >= 0 && level <= 50)
				{
                    SetPVarInt(playerid, "TruckDeliver", 11); // Bonus: 9mm
				}
				else if(level >= 51 && level <= 100)
				{
                    SetPVarInt(playerid, "TruckDeliver", 12); // Bonus: MP5
				}
				else if(level >= 101 && level <= 200)
				{
                    SetPVarInt(playerid, "TruckDeliver", 13); // Bonus: Deagle
				}
				else if(level >= 201 && level <= 400)
				{
                    SetPVarInt(playerid, "TruckDeliver", 14); // Bonus: AK-47
				}
				else if(level >= 401)
				{
                    SetPVarInt(playerid, "TruckDeliver", 15); // Bonus: Ak-47 or M4
				}*/
    			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with weapons....");
			}
			if(listitem == 1) // Drugs
			{
			    SetPVarInt(playerid, "TruckDeliver", 6);

				/*if(level >= 0 && level <= 50)
				{
                    SetPVarInt(playerid, "TruckDeliver", 16); // Bonus: 10 pot, 5 crack
				}
				else if(level >= 51 && level <= 100)
				{
                    SetPVarInt(playerid, "TruckDeliver", 17); // Bonus: 20 pot, 10 crack
				}
				else if(level >= 101 && level <= 200)
				{
                    SetPVarInt(playerid, "TruckDeliver", 18); // Bonus: 30 pot, 15 crack
				}
				else if(level >= 201 && level <= 400)
				{
                    SetPVarInt(playerid, "TruckDeliver", 19); // Bonus: 40 pot, 20 crack
				}
				else if(level >= 401)
				{
                    SetPVarInt(playerid, "TruckDeliver", 20); // Bonus: 50 pot, 25 crack
				}*/
                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with drugs....");
			}
			if(listitem == 2) // Illegal materials
			{
			    SetPVarInt(playerid, "TruckDeliver", 7);
				/*if(level >= 0 && level <= 50)
				{
                    SetPVarInt(playerid, "TruckDeliver", 21); // Bonus: 100 materials
				}
				else if(level >= 51 && level <= 100)
				{
                    SetPVarInt(playerid, "TruckDeliver", 22); // Bonus: 300 materials
				}
				else if(level >= 101 && level <= 200)
				{
                    SetPVarInt(playerid, "TruckDeliver", 23); // Bonus: 750 materials
				}
				else if(level >= 201 && level <= 400)
				{
                    SetPVarInt(playerid, "TruckDeliver", 24); // Bonus: 1500 materials
				}
				else if(level >= 401)
				{
                    SetPVarInt(playerid, "TruckDeliver", 25); // Bonus: 2500 materials
				}*/
                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with illegal materials....");
			}
            SetPVarInt(playerid, "LoadType", 1);
  		    SetPVarInt(playerid, "LoadTruckTime", 10);
			SetTimerEx("LoadTruckOld", 1000, 0, "d", playerid);
		}
		else
		{
		    DeletePVar(playerid, "IsFrozen");
			TogglePlayerControllable(playerid, 1);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You canceled the loading of the shipment, type /loadshipment to try again.");
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS)
	{
	    if(response) {
	        SetPVarInt(playerid, "AuctionItem", listitem);
	        ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS2, DIALOG_STYLE_LIST, "Edit Auction", "Auction Enabled\nAuction Item Description\nAuction Expiration\nStarting Bid\nIncease Increment", "Select", "Exit");
	    }
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS2)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS3, DIALOG_STYLE_LIST, "Edit Auction Enabled", "Enabled\nDisabled", "Select", "Exit");
	            }
	            case 1:
	            {
	                ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS4, DIALOG_STYLE_INPUT, "Edit Auction Item Description", "Enter below the item description for the auction.","Change","Exit");
	            }
	            case 2:
	            {
	                ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS5, DIALOG_STYLE_INPUT, "Edit Auction Expiration", "Enter the amount of minutes you want the auction to last for.","Change","Exit");
	            }
	            case 3:
	            {
	                ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS6, DIALOG_STYLE_INPUT, "Edit Auction Starting Bid", "Enter the starting bid amount.","Change","Exit");
	            }
	            case 4:
	            {
	                ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS7, DIALOG_STYLE_INPUT, "Edit Auction Increase Increment", "Enter the increase increment amount.","Change","Exit");
	            }
	        }
	    }
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS3)
	{
	    if(response) {

	    	new
				AuctionItem = GetPVarInt(playerid, "AuctionItem"),
				szMessage[128];

	        if(listitem == 0)
	        {
	            if(Auctions[AuctionItem][Expires] == 0) {
	                SendClientMessageEx(playerid, COLOR_GREY, "Before you can start an auction you must set the expiration time.");
	                return 1;
	            }
	            format(szMessage, sizeof(szMessage), "%s (IP:%s) has edited auction %i enabled to 1 (Enabled)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), AuctionItem);
				Log("logs/adminauction.log", szMessage);
	            Auctions[AuctionItem][InProgress] = 1;
	            Auctions[AuctionItem][Timer] = SetTimerEx("EndAuction", 60000, true, "i", AuctionItem);
	            SendClientMessageEx(playerid, COLOR_WHITE, "Auction has been enabled, people can start biding.");
	        }
	        else
	        {
	            KillTimer(Auctions[AuctionItem][Timer]);
	            format(szMessage, sizeof(szMessage), "%s (IP:%s) has edited auction %i enabled to 0 (disabled)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), AuctionItem);
				Log("logs/adminauction.log", szMessage);
	            Auctions[AuctionItem][InProgress] = 0;
	            SendClientMessageEx(playerid, COLOR_WHITE, "Auction has been disabled.");
	        }
	        SaveAuction(AuctionItem);
	        DeletePVar(playerid, "AuctionItem");
	    }
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS4)
	{
		if(response)
		{
		    new
				AuctionItem = GetPVarInt(playerid, "AuctionItem"),
				szMessage[128];

		    if(isnull(inputtext))
		    {
		        ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS4, DIALOG_STYLE_INPUT, "Edit Auction Item Description", "Enter below the item description for the auction.","Change","Exit");
		        return 1;
		    }
		    if(strlen(inputtext) > 64)
		    {
		        SendClientMessageEx(playerid, COLOR_GREY, "The item description can't be longer then 64 characters.");
                ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS4, DIALOG_STYLE_INPUT, "Edit Auction Item Description", "Enter below the item description for the auction.","Change","Exit");
		        return 1;
		    }
		    format(szMessage, sizeof(szMessage), "%s (IP:%s) has edited auction %i item description to %s", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), AuctionItem, inputtext);
			Log("logs/adminauction.log", szMessage);
		    format(Auctions[AuctionItem][BiddingFor], 64, inputtext);
		    SaveAuction(AuctionItem);
		    DeletePVar(playerid, "AuctionItem");
			SendClientMessageEx(playerid, COLOR_WHITE, "You have adjusted the auction item description.");
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS5)
	{
	    if(response) {
	        new
            	Time = strval(inputtext),
            	AuctionItem = GetPVarInt(playerid, "AuctionItem"),
				szMessage[128];

			if(Time < 0) {
			    ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS5, DIALOG_STYLE_INPUT, "Edit Auction Expiration", "Enter the amount of minutes you want the auction to last for.","Change","Exit");
			    SendClientMessageEx(playerid, COLOR_GREY, "The time can't be below 0.");
			    return 1;
			}
			format(szMessage, sizeof(szMessage), "%s (IP:%s) has edited auction %i expire time to %i", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), AuctionItem, Time);
			Log("logs/adminauction.log", szMessage);
			Auctions[AuctionItem][Expires] = Time;
			SaveAuction(AuctionItem);
			DeletePVar(playerid, "AuctionItem");
			SendClientMessageEx(playerid, COLOR_WHITE, "You have adjusted the auction expiration time.");
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS6)
	{
	    if(response) {
	        new
            	Time = strval(inputtext),
            	AuctionItem = GetPVarInt(playerid, "AuctionItem"),
				szMessage[128];

			if(Time < 0) {
			    ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS6, DIALOG_STYLE_INPUT, "Edit Auction Starting Bid", "Enter the starting bid amount.","Change","Exit");
			    SendClientMessageEx(playerid, COLOR_GREY, "The starting bid can't be below 0.");
			    return 1;
			}
			format(szMessage, sizeof(szMessage), "%s (IP:%s) has edited auction %i starting bid to %i", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), AuctionItem, Time );
			Log("logs/adminauction.log", szMessage);
			Auctions[AuctionItem][Bid] = Time;
			SaveAuction(AuctionItem);
			DeletePVar(playerid, "AuctionItem");
			SendClientMessageEx(playerid, COLOR_WHITE, "You have adjusted the bid starting amount.");
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS7)
	{
	    if(response) {
	        new
            	Time = strval(inputtext),
            	AuctionItem = GetPVarInt(playerid, "AuctionItem"),
				szMessage[128];

			if(Time < 0) {
			    ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS7, DIALOG_STYLE_INPUT, "Edit Auction Increase Increment", "Enter the increase increment amount.","Change","Exit");
			    SendClientMessageEx(playerid, COLOR_GREY, "The increase increment amount can't be below 0.");
			    return 1;
			}
			format(szMessage, sizeof(szMessage), "%s (IP:%s) has edited auction %i increment to %i", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), AuctionItem, Time );
			Log("logs/adminauction.log", szMessage);

			Auctions[AuctionItem][Increment] = Time;
			SaveAuction(AuctionItem);
			DeletePVar(playerid, "AuctionItem");
			SendClientMessageEx(playerid, COLOR_WHITE, "You have adjusted the increase increment amount.");
		}
	}
	else if(dialogid == DIALOG_AUCTIONS)
	{
	    if(response) {

			if(Auctions[listitem][InProgress] == 1) {

				new
				    szInfo[200];

				format(szInfo, sizeof(szInfo), "{00BFFF}Item: {FFFFFF}%s\n\n{00BFFF}Current Bid: {FFFFFF}$%i\n\n{00BFFF}Bidder: {FFFFFF}%s\n\n{00BFFF}Expires: {FFFFFF}%s", Auctions[listitem][BiddingFor], Auctions[listitem][Bid], Auctions[listitem][Wining], Auctions[listitem][Expires]);
				ShowPlayerDialog(playerid, DIALOG_AUCTIONS2, DIALOG_STYLE_MSGBOX, "{00BFFF}Auction Information", szInfo, "Bid", "Exit");
				SetPVarInt(playerid, "AuctionItem", listitem);
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "That auction isn't currently available.");
		}
	}
	else if(dialogid == DIALOG_AUCTIONS2)
	{
	    if(response) {

			new
				AuctionItem = GetPVarInt(playerid, "AuctionItem");
			if(Auctions[AuctionItem][InProgress] == 1) {

			    new
			        szInfo[128];

				format(szInfo, sizeof(szInfo), "You are bidding on %s. The current bid is $%i, to place a bid it must be higher then the current one.", Auctions[AuctionItem][BiddingFor], Auctions[AuctionItem][Bid]);
			    ShowPlayerDialog(playerid, DIALOG_AUCTIONS3, DIALOG_STYLE_INPUT, "Auction - Bidding",szInfo,"Place Bid","Exit");
			}
			else {

				SendClientMessageEx(playerid, COLOR_GREY, "That auction isn't currently available.");
				DeletePVar(playerid, "AuctionItem");
			}
		}
	}
	else if(dialogid == DIALOG_AUCTIONS3)
	{
	    if(response) {

			new
				BidPlaced = strval(inputtext),
				AuctionItem = GetPVarInt(playerid, "AuctionItem");

			if(GetPlayerCash(playerid) < BidPlaced) {
			    SendClientMessageEx(playerid, COLOR_GREY, "You can't bid money you don't have.");
			    return 1;
			}
			if(BidPlaced < 1) {
			    SendClientMessageEx(playerid, COLOR_GREY, "You can't place a bid under $1.");
			    return 1;
			}
			if(BidPlaced < Auctions[AuctionItem][Bid]+Auctions[AuctionItem][Increment]) {
			    new szMessage[128];
			    format(szMessage, sizeof(szMessage), "You need to bid at least %i over the current bid of %i.", Auctions[AuctionItem][Increment], Auctions[AuctionItem][Bid]);
				SendClientMessageEx(playerid, COLOR_GREY, szMessage);
				return 1;
			}

			if(Auctions[AuctionItem][InProgress] == 1) {
				if(BidPlaced > Auctions[AuctionItem][Bid]) {
                    SetPVarInt(playerid, "BidPlaced", BidPlaced);
					HigherBid(playerid);
				}
				else SendClientMessageEx(playerid, COLOR_GREY, "That bid is to low, a higher amount is needed to place the bid.");
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "That auction isn't currently available.");
	    }
	}
	if(dialogid == DIALOG_CGAMESADMINMENU)
	{
		if(response) {
			switch(listitem)
			{
				case 0:
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSELECTPOKER);
				}
				case 1:
				{
				}
				case 2:
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESCREDITS);
				}
			}
		}
	}
	if(dialogid == DIALOG_CGAMESSELECTPOKER)
	{
		if(response) {
			SetPVarInt(playerid, "tmpEditPokerTableID", listitem+1);
			ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPOKER);
		} else {
			ShowCasinoGamesMenu(playerid, DIALOG_CGAMESADMINMENU);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPOKER)
	{
		if(response) {
			new tableid = GetPVarInt(playerid, "tmpEditPokerTableID")-1;

			if(PokerTable[tableid][pkrPlaced] == 0) {
				switch(listitem)
				{
					case 0: // Place Poker Table
					{
						new szString[128];
						format(szString, sizeof(szString), "Press '{3399FF}~k~~PED_SPRINT~{FFFFFF}' to place poker table.");
						SendClientMessage(playerid, COLOR_WHITE, szString);

						SetPVarInt(playerid, "tmpPlacePokerTable", 1);
					}
				}
			} else {
				switch(listitem)
				{
					case 0: // Edit Poker Table
					{
						SetPVarFloat(playerid, "tmpPkrX", PokerTable[tableid][pkrX]);
						SetPVarFloat(playerid, "tmpPkrY", PokerTable[tableid][pkrY]);
						SetPVarFloat(playerid, "tmpPkrZ", PokerTable[tableid][pkrZ]);
						SetPVarFloat(playerid, "tmpPkrRX", PokerTable[tableid][pkrRX]);
						SetPVarFloat(playerid, "tmpPkrRY", PokerTable[tableid][pkrRY]);
						SetPVarFloat(playerid, "tmpPkrRZ", PokerTable[tableid][pkrRZ]);

						EditObject(playerid, PokerTable[tableid][pkrObjectID]);

						new szString[128];
						format(szString, sizeof(szString), "You have selected Poker Table %d, You may now customize it's position/rotation.", tableid);
						SendClientMessage(playerid, COLOR_WHITE, szString);
					}
					case 1: // Destroy Poker Table
					{
						DestroyPokerTable(tableid);

						new szString[64];
						format(szString, sizeof(szString), "You have deleted Poker Table %d.", tableid);
						SendClientMessage(playerid, COLOR_WHITE, szString);

						ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSELECTPOKER);
					}
				}
			}
		} else {
			ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSELECTPOKER);
		}
	}
	if(dialogid == DIALOG_CGAMESCREDITS)
	{
		ShowCasinoGamesMenu(playerid, DIALOG_CGAMESADMINMENU);
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME)
	{
		if(response) {
			switch(listitem)
			{
				case 0: // Buy-In Max
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME2);
				}
				case 1: // Buy-In Min
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME3);
				}
				case 2: // Blind
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME4);
				}
				case 3: // Limit
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME5);
				}
				case 4: // Password
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME6);
				}
				case 5: // Round Delay
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME7);
				}
				case 6: // Start Game
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESBUYINPOKER);
				}
			}
		} else {
			LeavePokerTable(playerid);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME2)
	{
		if(response) {
			if(strval(inputtext) < 1 || strval(inputtext) > 10000) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME2);
			}

			if(strval(inputtext) <= PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMin]) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME2);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMax] = strval(inputtext);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME3)
	{
		if(response) {
			if(strval(inputtext) < 1 || strval(inputtext) > 10000) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME3);
			}

			if(strval(inputtext) >= PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMax]) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME3);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMin] = strval(inputtext);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME4)
	{
		if(response) {
			if(strval(inputtext) < 1 || strval(inputtext) > 10000) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME4);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBlind] = strval(inputtext);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME5)
	{
		if(response) {
			if(strval(inputtext) < 2 || strval(inputtext) > 6) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME5);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrLimit] = strval(inputtext);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME6)
	{
		if(response) {
			new tableid = GetPVarInt(playerid, "pkrTableID")-1;
			strmid(PokerTable[tableid][pkrPass], inputtext, 0, strlen(inputtext), 32);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME7)
	{
		if(response) {
			if(strval(inputtext) < 15 || strval(inputtext) > 120) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME7);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrSetDelay] = strval(inputtext);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESBUYINPOKER)
	{
		if(response) {
			if(strval(inputtext) < PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMin] || strval(inputtext) > PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMax] || strval(inputtext) > GetPlayerCash(playerid)) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESBUYINPOKER);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActivePlayers]++;
			SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")+strval(inputtext));
			//SetPVarInt(playerid, "cgChips", GetPVarInt(playerid, "cgChips")-strval(inputtext));
			GivePlayerCash(playerid, -strval(inputtext));

			format(string, sizeof(string), "%s (IP:%s) has bought in with the amount of $%s (%d)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), number_format(GetPVarInt(playerid, "pkrChips")), GetPVarInt(playerid, "pkrTableID")-1);
			Log("logs/poker.log", string);

			if(PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActive] == 3 && PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrRound] == 0 && PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrDelay] >= 6) {
				SetPVarInt(playerid, "pkrStatus", 1);
			}
			else if(PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActive] < 3) {
				SetPVarInt(playerid, "pkrStatus", 1);
			}

			if(PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActive] == 1 && GetPVarInt(playerid, "pkrRoomLeader")) {
				PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActive] = 2;
				SelectTextDraw(playerid, COLOR_YELLOW);
			}
		} else {
			return LeavePokerTable(playerid);
		}
	}
	if(dialogid == DIALOG_CGAMESCALLPOKER)
	{
		if(response) {
			new tableid = GetPVarInt(playerid, "pkrTableID")-1;

			new actualBet = PokerTable[tableid][pkrActiveBet]-GetPVarInt(playerid, "pkrCurrentBet");

			if(actualBet > GetPVarInt(playerid, "pkrChips")) {
				PokerTable[tableid][pkrPot] += GetPVarInt(playerid, "pkrChips");
				SetPVarInt(playerid, "pkrChips", 0);
				SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrActiveBet]);
			} else {
				PokerTable[tableid][pkrPot] += actualBet;
				SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")-actualBet);
				SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrActiveBet]);
			}

			SetPVarString(playerid, "pkrStatusString", "Call");
			PokerRotateActivePlayer(tableid);

			ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
		}

		DeletePVar(playerid, "pkrActionChoice");
	}
	if(dialogid == DIALOG_CGAMESRAISEPOKER)
	{
		if(response) {
			new tableid = GetPVarInt(playerid, "pkrTableID")-1;

			new actualRaise = strval(inputtext)-GetPVarInt(playerid, "pkrCurrentBet");

			if(strval(inputtext) >= PokerTable[tableid][pkrActiveBet]+PokerTable[tableid][pkrBlind]/2 && strval(inputtext) <= GetPVarInt(playerid, "pkrCurrentBet")+GetPVarInt(playerid, "pkrChips")) {
				PokerTable[tableid][pkrPot] += actualRaise;
				PokerTable[tableid][pkrActiveBet] = strval(inputtext);
				SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")-actualRaise);
				SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrActiveBet]);

				SetPVarString(playerid, "pkrStatusString", "Raise");

				PokerTable[tableid][pkrRotations] = 0;
				PokerRotateActivePlayer(tableid);

				ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
			} else {
				ShowCasinoGamesMenu(playerid, DIALOG_CGAMESRAISEPOKER);
			}
		}

		DeletePVar(playerid, "pkrActionChoice");
	}

	if (dialogid == SPEEDCAM_DIALOG_MAIN)
	{
		if (!response)
			return 1;

		switch (listitem)
		{
			case 0:
			{
				if (SpeedCameras[MAX_SPEEDCAMERAS - 1][_scActive])
					return SendClientMessageEx(playerid, COLOR_GREY, "No more static speed cameras can be created.");

				ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_RANGEC, DIALOG_STYLE_INPUT, "{FFFF00}Create a speed camera", "{FFFFFF}Enter the range of your camera.", "OK", "Back");
			}

			case 1:
			{
				ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to edit.", "OK", "Back");
			}

			case 2:
			{
				ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_DELETE, DIALOG_STYLE_INPUT, "{FFFF00}Delete a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to delete.", "OK", "Back");
			}

			case 3:
			{
				new Float:playerPos[3];
				GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);

				new Float:distances[MAX_SPEEDCAMERAS];

				for (new c = 0; c < MAX_SPEEDCAMERAS; c++)
				{
					distances[c] = -1.000;

					if (SpeedCameras[c][_scActive] == false)
						continue;

					new Float:tmpPos[3];
					tmpPos[0] = SpeedCameras[c][_scPosX];
					tmpPos[1] = SpeedCameras[c][_scPosY];
					tmpPos[2] = SpeedCameras[c][_scPosZ];

					new Float:distance = floatsqroot(((playerPos[0] - tmpPos[0]) * (playerPos[0] - tmpPos[0])) + ((playerPos[1] - tmpPos[1]) * (playerPos[1] - tmpPos[1])) \
						+ ((playerPos[2] - tmpPos[2]) * ((playerPos[2] - tmpPos[2]))));

					distances[c] = distance;
				}

				new lowest_index = -1;

				for (new i = 0; i < MAX_SPEEDCAMERAS; i++)
				{
					if (distances[i] == -1.000)
						continue;

					if (lowest_index == -1.000)
					{
						lowest_index = i;
					}
					else
					{
						if (distances[i] < distances[lowest_index])
							lowest_index = i;
					}
				}

				if (lowest_index == -1) // no cameras exist, the closest cannot be calculated
				{
					ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_GETNEAREST, DIALOG_STYLE_MSGBOX, "{FFFF00}Nearest speed camera", "{FFFFFF}No speed cameras exist, and thus the closest cannot be found.", "OK", "");
				}
				else
				{
					new msg[128];
					format(msg, sizeof(msg), "{FFFFFF}The nearest speed camera is: {FFFF00}%i\n\n{FFFFFF}With a distance of {FFFF00}%f", lowest_index, distances[lowest_index]);
					ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_GETNEAREST, DIALOG_STYLE_MSGBOX, "{FFFF00}Nearest speed camera", msg, "OK", "");
				}
			}
		}
	}

	if (dialogid == SPEEDCAM_DIALOG_RANGEC)
	{
		if (!response)
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", \
					"Create a speed camera\nEdit a speed camera\nDelete a speed camera\nGet nearest speedcamera", "Select", "Cancel");

		new Float:range;
		if (sscanf(inputtext, "f", range))
		{
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_RANGEC, DIALOG_STYLE_INPUT, "{FFFF00}Create a speed camera", "{FFFFFF}Enter the range of your camera.\
					\n\n{FFFF00}Value must be a number (decimal places allowed).", "OK", "Back");
		}

		SetPVarFloat(playerid, "_scCacheRange", range);
		ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_LIMIT, DIALOG_STYLE_INPUT, "{FFFF00}Create a speed camera", "{FFFFFF}Enter the limit of your camera (mph).", "OK", "Back");
	}

	if (dialogid == SPEEDCAM_DIALOG_LIMIT)
	{
		if (!response)
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_RANGEC, DIALOG_STYLE_INPUT, "{FFFF00}Create a speed camera", "{FFFFFF}Enter the range of your camera.", "OK", "Back");

		new Float:limit;
		if (sscanf(inputtext, "f", limit))
		{
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_LIMIT, DIALOG_STYLE_INPUT, "{FFFF00}Create a speed camera", "{FFFFFF}Enter the limit of your camera (mph).\
				\n\n{FFFF00}Value must be a number (decimal places allowed).", "OK", "Back");
		}

		SetPVarFloat(playerid, "_scCacheLimit", limit);

		new Float:range = GetPVarFloat(playerid, "_scCacheRange");
		new content[256];
		format(content, sizeof(content), "{FFFF00}Range: {FFFFFF}%f\n{FFFF00}Limit: {FFFFFF}%f mph\n\nAre you sure you want to create this speed camera?", range, limit);
		ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_OVERVIEW, DIALOG_STYLE_MSGBOX, "{FFFF00}Speed camera overview", content, "Confirm", "Cancel");
	}

	if (dialogid == SPEEDCAM_DIALOG_OVERVIEW)
	{
		if (!response)
		{
			DeletePVar(playerid, "_scCacheRange");
			DeletePVar(playerid, "_scCacheLimit");
			return SendClientMessageEx(playerid, COLOR_RED, "Cancelled creation of speed camera.");
		}

		if (SpeedCameras[MAX_SPEEDCAMERAS - 1][_scActive])
		{
			DeletePVar(playerid, "_scCacheRange");
			DeletePVar(playerid, "_scCacheLimit");
			return SendClientMessageEx(playerid, COLOR_RED, "Error: Limit was reached whilst you were creating this camera.");
		}

		new Float:range = GetPVarFloat(playerid, "_scCacheRange");
		new Float:limit = GetPVarFloat(playerid, "_scCacheLimit");
		DeletePVar(playerid, "_scCacheRange");
		DeletePVar(playerid, "_scCacheLimit");

		new Float:x, Float:y, Float:z, Float:angle;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		z -= 3.00000; // for height issues
		angle += 180; // flip the angle

		new cam = CreateSpeedCamera(x, y, z, angle, range, limit);
		SendClientMessageEx(playerid, COLOR_GREEN, "Speed camera created!");

		new logText[128];
		format(logText, sizeof(logText), "%s has placed speed camera %d at [%f, %f, %f] with limit %f and range %f.",
			GetPlayerNameExt(playerid), SpeedCameras[cam][_scDatabase], SpeedCameras[cam][_scPosX], SpeedCameras[cam][_scPosY], SpeedCameras[cam][_scPosZ], SpeedCameras[cam][_scLimit], SpeedCameras[cam][_scRange]);
		Log("logs/speedcam.log", logText);
	}

	if (dialogid == SPEEDCAM_DIALOG_EDIT)
	{
		if (!response)
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
				Get nearest speedcamera", \
				"Select", "Cancel");

		new id;
		if (sscanf(inputtext, "i", id))
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to edit.\n\n\
				{FFFF00}ID must be a number.", "OK", "Back");

		if (id >= MAX_SPEEDCAMERAS || id < 0)
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to edit.\n\n\
				{FFFF00}ID must not be above the maximum or below 0.", "OK", "Back");

		if (SpeedCameras[id][_scActive] == false)
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to edit.\n\n\
				{FFFF00}No active speed camera with that ID.", "OK", "Back");

		SetPVarInt(playerid, "_scCacheEditId", id);
		ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
	}

	if (dialogid == SPEEDCAM_DIALOG_EDIT_IDX)
	{
		if (!response)
		{
			DeletePVar(playerid, "_scCacheEditId");
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
				Get nearest speedcamera", \
				"Select", "Cancel");
		}

		switch (listitem)
		{
			case 0:
			{
				new Float:x, Float:y, Float:z, Float:angle;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, angle);
				new id = GetPVarInt(playerid, "_scCacheEditId");

				SpeedCameras[id][_scPosX] = x;
				SpeedCameras[id][_scPosY] = y;
				SpeedCameras[id][_scPosZ] = z;
				SpeedCameras[id][_scRotation] = angle - 180;

				SetDynamicObjectPos(SpeedCameras[id][_scObjectId], x, y, z-3.000);
				SetDynamicObjectRot(SpeedCameras[id][_scObjectId], 0, 0, angle - 180);
				SetPlayerPos(playerid, x + 1, y, z);
				SaveSpeedCamera(id);
				SendClientMessageEx(playerid, COLOR_WHITE, "Speed camera moved.");

				new logText[128];
				format(logText, sizeof(logText), "%s has moved speed camera %d to [%f, %f, %f]",
					GetPlayerNameExt(playerid), SpeedCameras[id][_scDatabase], SpeedCameras[id][_scPosX], SpeedCameras[id][_scPosY], SpeedCameras[id][_scPosZ]);
				Log("logs/speedcam.log", logText);

				ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
			}

			case 1:
			{
				ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_ROT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new (Z) angle of the speed camera.", "OK", "Back");
			}

			case 2:
			{
				ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_RANGE, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new range of the speed camera.", "OK", "Back");
			}

			case 3:
			{
				ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_LIMIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new speed limit of the speed camera (mph).", "OK", "Back");
			}
		}
	}

	if (dialogid == SPEEDCAM_DIALOG_EDIT_ROT)
	{
		if (!response)
		{
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
		}

		new Float:angle;
		if (sscanf(inputtext, "f", angle))
		{
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_ROT, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new (Z) angle of the speed camera.\n\n\
				{FFFF00}The angle must be a number (decimals allowed).", "OK", "Back");
		}

		new id = GetPVarInt(playerid, "_scCacheEditId");
		SetDynamicObjectRot(SpeedCameras[id][_scObjectId], 0, 0, angle);
		SpeedCameras[id][_scRotation] = angle;
		SaveSpeedCamera(id);
		SendClientMessageEx(playerid, COLOR_WHITE, "Speed camera's Z-angle changed.");

		new logText[128];
		format(logText, sizeof(logText), "%s has changed speed camera %d's z-angle to %f",
			GetPlayerNameExt(playerid), SpeedCameras[id][_scDatabase], SpeedCameras[id][_scRotation]);
		Log("logs/speedcam.log", logText);

		ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
	}

	if (dialogid == SPEEDCAM_DIALOG_EDIT_RANGE)
	{
		if (!response)
		{
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
		}

		new Float:range;
		if (sscanf(inputtext, "f", range))
		{
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_RANGE, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new range of the speed camera.\n\n\
				{FFFF00}Range must be a number (decimals allowed).", "OK", "Back");
		}

		new id = GetPVarInt(playerid, "_scCacheEditId");
		SpeedCameras[id][_scRange] = range;
		SaveSpeedCamera(id);
		SendClientMessageEx(playerid, COLOR_WHITE, "Speed camera's ranged changed.");

		new logText[128];
		format(logText, sizeof(logText), "%s has changed speed camera %d's range to %f",
			GetPlayerNameExt(playerid), SpeedCameras[id][_scDatabase], SpeedCameras[id][_scRange]);
		Log("logs/speedcam.log", logText);

		ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
	}

	if (dialogid == SPEEDCAM_DIALOG_EDIT_LIMIT)
	{
		if (!response)
		{
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
		}

		new Float:limit;
		if (sscanf(inputtext, "f", limit))
		{
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_LIMIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new speed limit of the speed camera (mph).\n\n\
				{FFFF00}Limit must be a number (decimals allowed).", "OK", "Back");
		}

		new id = GetPVarInt(playerid, "_scCacheEditId");
		SpeedCameras[id][_scLimit] = limit;

		new szLimit[50];
		format(szLimit, sizeof(szLimit), "{FFFFFF}Speed Limit\n{FF0000}%i {FFFFFF}MPH", floatround(SpeedCameras[id][_scLimit], floatround_round));
		UpdateDynamic3DTextLabelText(SpeedCameras[id][_scTextID], COLOR_TWWHITE, szLimit);
		SaveSpeedCamera(id);
		SendClientMessageEx(playerid, COLOR_WHITE, "Speed camera's limit changed.");

		new logText[128];
		format(logText, sizeof(logText), "%s has changed speed camera %d's limit to %f",
			GetPlayerNameExt(playerid), SpeedCameras[id][_scDatabase], SpeedCameras[id][_scLimit]);
		Log("logs/speedcam.log", logText);

		ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
	}

	if (dialogid == SPEEDCAM_DIALOG_DELETE)
	{
		if (!response)
		{
			DeletePVar(playerid, "_scCacheDeleteId");
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
				Get nearest speedcamera (static only)", \
				"Select", "Cancel");
		}

		new id;
		if (sscanf(inputtext, "i", id))
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_DELETE, DIALOG_STYLE_INPUT, "{FFFF00}Delete a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to delete.\n\n\
				{FFFF00}ID must be a number.", "OK", "Back");

		if (id >= MAX_SPEEDCAMERAS || id < 0)
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_DELETE, DIALOG_STYLE_INPUT, "{FFFF00}Delete a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to delete.\n\n\
				{FFFF00}ID must not be above the maximum or below 0.", "OK", "Back");

		if (SpeedCameras[id][_scActive] == false)
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_DELETE, DIALOG_STYLE_INPUT, "{FFFF00}Delete a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to delete.\n\n\
				{FFFF00}No active camera with that ID.", "OK", "Back");

		SetPVarInt(playerid, "_scCacheDeleteId", id);

		new msg[256];
		format(msg, sizeof(msg), "{FFFFFF}Are you sure you want to delete speed camera %i?\n\n{FFFF00}Range: {FFFFFF}%f\n\
			{FFFF00}Limit: {FFFFFF}%f", id, SpeedCameras[id][_scRange], SpeedCameras[id][_scLimit]);
		ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_CONFIRMDEL, DIALOG_STYLE_MSGBOX, "{FFFF00}Delete a speed camera", msg, "Delete", "Cancel");
	}

	if (dialogid == SPEEDCAM_DIALOG_CONFIRMDEL)
	{
		if (!response)
		{
			DeletePVar(playerid, "_scCacheDeleteId");
			return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
				Get nearest speedcamera", \
				"Select", "Cancel");
		}

		new id = GetPVarInt(playerid, "_scCacheDeleteId");
		new db = SpeedCameras[id][_scDatabase];
		DespawnSpeedCamera(id);
		SpeedCameras[id][_scActive] = false;
		new query[256];
		format(query, sizeof(query), "DELETE FROM speed_cameras WHERE id=%i", SpeedCameras[id][_scDatabase]);
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		//SaveSpeedCamera(id); dafuq is this doing here
		SendClientMessageEx(playerid, COLOR_RED, "Speed camera deleted.");
		DeletePVar(playerid, "_scCacheDeleteId");

		new logText[56];
		format(logText, sizeof(logText), "%s has deleted speed camera %d",
			GetPlayerNameExt(playerid), db);
		Log("logs/speedcam.log", logText);
	}

	if (dialogid == SPEEDCAM_DIALOG_GETNEAREST)
	{
		return ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
			Get nearest speedcamera", \
			"Select", "Cancel");
	}
	if(dialogid == DIALOG_CHARGEPLAYER)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < GetPVarInt(playerid, "FineAmount"))
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to be fined.");

			new reason[60];
			GetPVarString(playerid, "FineReason", reason, 60);
	        format(string, sizeof(string), "AdmCmd: %s was fined %s credits by %s, reason: %s", GetPlayerNameEx(playerid), number_format(GetPVarInt(playerid, "FineAmount")), GetPlayerNameEx(GetPVarInt(playerid, "FineBy")), reason);
			Log("logs/admin.log", string);

			format(string, sizeof(string), "[CHARGEPLAYER] [User: %s(%i)] [IP: %s] [Credits: %s] [Charged: %s]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]),  number_format(GetPVarInt(playerid, "FineAmount")));
			Log("logs/credits.log", string);

			GivePlayerCredits(playerid, -GetPVarInt(playerid, "FineAmount"), 1);

			format(string, sizeof(string), "You were charged %s credits for %s by %s.", number_format(GetPVarInt(playerid, "FineAmount")), reason, GetPlayerNameEx(GetPVarInt(playerid, "FineBy")));
			SendClientMessageEx(playerid, COLOR_CYAN, string);

			format(string, sizeof(string), "You charged %s %s credits for %s.", GetPlayerNameEx(playerid), number_format(GetPVarInt(playerid, "FineAmount")), reason);
			SendClientMessageEx(GetPVarInt(playerid, "FineBy"), COLOR_CYAN, string);
		}
	    else
	    {
	        SendClientMessageEx(GetPVarInt(playerid, "FineBy"), COLOR_CYAN, "The player has declined the charge.");
	    }
	    DeletePVar(playerid, "FineAmount");
	    DeletePVar(playerid, "FineBy");
	    DeletePVar(playerid, "FineReason");
	}
	if(dialogid == DIALOG_EDITSHOPMENU)
	{
		if(response)
		{
		    if(listitem == 0)
		    {
		        new szDialog[1000];
       			format(szDialog, sizeof(szDialog),
				"Gold VIP (Credits: %s)\n\
				Gold VIP Renewal (Credits: %s)\n\
				Silver VIP (Credits: %s)\n\
				Bronze VIP (Credits: %s)\n\
				Toys (Credits: %s)\n\
				Vehicles (Credits: %s)\n\
				Poker Table (Credits: %s)\n\
				Boombox (Credits: %s)", number_format(ShopItems[0][sItemPrice]), number_format(ShopItems[1][sItemPrice]), number_format(ShopItems[2][sItemPrice]), number_format(ShopItems[3][sItemPrice]), number_format(ShopItems[4][sItemPrice]),
				 number_format(ShopItems[5][sItemPrice]), number_format(ShopItems[6][sItemPrice]), number_format(ShopItems[7][sItemPrice]));

				format(szDialog, sizeof(szDialog), "%s\n\
				Paintball Tokens (Credits %s)\n\
				EXP Token (Credits: %s)\n\
				Fireworks x5 (Credits: %s)\n\
				Renewal Regular (Credits: %s)\n\
				Renewal Standard (Credits: %s)\n\
				Renewal Premium (Credits: %s)\n\
				House (Credits: %s)\n\
				House Interior Change (Credits: %s)\n\
				House Move (Credits: %s)\n\
				(Micro) Reset Gift Timer (Credits: %s)",szDialog, number_format(ShopItems[8][sItemPrice]), number_format(ShopItems[9][sItemPrice]), number_format(ShopItems[10][sItemPrice]),
				number_format(ShopItems[11][sItemPrice]), number_format(ShopItems[12][sItemPrice]), number_format(ShopItems[13][sItemPrice]), number_format(ShopItems[14][sItemPrice]),
				 number_format(ShopItems[15][sItemPrice]), number_format(ShopItems[16][sItemPrice]), number_format(ShopItems[17][sItemPrice]));
				format(szDialog, sizeof(szDialog),
				"%s\n(Micro) Advanced Healthcare (Credits: %s)\n\
				(Micro) Super Advanced Healthcare (Credits: %s)\n\
				(Micro) Rent a Car (Credits: %s)\n\
				Platinum VIP (Credits: %s)\n\
				Custom License Plate (Credits: %s)\n\
				Additional Vehicle Slot (Credits: %s)",szDialog, number_format(ShopItems[18][sItemPrice]), number_format(ShopItems[19][sItemPrice]), number_format(ShopItems[20][sItemPrice]),
				 number_format(ShopItems[21][sItemPrice]), number_format(ShopItems[22][sItemPrice]), number_format(ShopItems[23][sItemPrice]));
				format(szDialog, sizeof(szDialog),
				"%s\nGarage - Small (Credits: %s)\n\
				Garage - Medium (Credits: %s)\n\
				Garage - Large (Credits: %s)\n\
				Garage - Extra Large (Credits: %s)\n\
				Additional Toy Slot (Credits: %s)\n\
				Hunger Voucher (Credits: %s)\n\
				Spawn at Gold VIP+ room (Credits: %s)", szDialog, number_format(ShopItems[24][sItemPrice]), number_format(ShopItems[25][sItemPrice]), number_format(ShopItems[26][sItemPrice]),
				number_format(ShopItems[27][sItemPrice]), number_format(ShopItems[28][sItemPrice]), number_format(ShopItems[29][sItemPrice]), number_format(ShopItems[30][sItemPrice]));
				ShowPlayerDialog(playerid, DIALOG_EDITSHOP, DIALOG_STYLE_LIST, "Edit Shop Prices", szDialog, "Edit", "Exit");
		    }
		    else
		    {
		        ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
		    }
		}
	}
	if(dialogid == DIALOG_EDITSHOP)
	{
	    if(response) {
	    	new item[30];
	    	SetPVarInt(playerid, "EditingPrice", listitem);
	    	switch(listitem)
	    	{
    			case 0: item = "Gold VIP";
    		 	case 1: item = "Gold VIP Renewal";
	       	 	case 2: item = "Silver VIP";
	        	case 3: item = "Bronze VIP";
	        	case 4: item = "Toys";
	        	case 5: item = "Vehicles";
	        	case 6: item = "Poker Table";
	        	case 7: item = "Boombox";
	        	case 8: item = "Paintball Tokens";
	        	case 9: item = "EXP Token";
	        	case 10: item = "Fireworks x5";
	        	case 11: item = "Renewal Regular";
	        	case 12: item = "Renewal Standard";
				case 13: item = "Renewal Premium";
				case 14: item = "House";
				case 15: item = "House Interior Change";
				case 16: item = "House Move";
				case 17: item = "(Micro) Reset Gift Timer";
				case 18: item = "(Micro) Advanced Health Care";
				case 19: item = "(Micro) Super Health Care";
				case 20: item = "(Micro) Rent a Car";
				case 21: item = "Platinum VIP";
				case 22: item = "License Plate";
				case 23: item = "Additional Vehicle Slot";
				case 24: item = "Garage - Small";
				case 25: item = "Garage - Medium";
				case 26: item = "Garage - Large";
				case 27: item = "Garage - Extra Large";
				case 28: item = "Additional Toy Slot";
				case 29: item = "Hunger Voucher";
				case 30: item = "Spawn at Gold VIP+ room";				
			}
	    	format(string, sizeof(string), "You are currently editing the price of %s. The current credit cost is %d.", item, ShopItems[listitem][sItemPrice]);
	    	ShowPlayerDialog(playerid, DIALOG_EDITSHOP2, DIALOG_STYLE_INPUT, "Editing Price", string, "Change", "Back");
		}
	}
	if(dialogid == DIALOG_EDITSHOP2)
	{
	    if(response) {

			new
				Prices = strval(inputtext),
				item[30];

            switch(GetPVarInt(playerid, "EditingPrice"))
  			{
   				case 0: item = "Gold VIP";
    		 	case 1: item = "Gold VIP Renewal";
	       	 	case 2: item = "Silver VIP";
	        	case 3: item = "Bronze VIP";
	        	case 4: item = "Toys";
	        	case 5: item = "Vehicles";
	        	case 6: item = "Poker Table";
	        	case 7: item = "Boombox";
	        	case 8: item = "Paintball Tokens";
	        	case 9: item = "EXP Token";
	        	case 10: item = "Fireworks x5";
	        	case 11: item = "Renewal Regular";
	        	case 12: item = "Renewal Standard";
				case 13: item = "Renewal Premium";
				case 14: item = "House";
				case 15: item = "House Interior Change";
				case 16: item = "House Move";
				case 17: item = "(Micro) Reset Gift Timer";
				case 18: item = "(Micro) Advanced Health Care";
				case 19: item = "(Micro) Super Health Care";
				case 20: item = "(Micro) Rent a Car";
				case 21: item = "Platinum VIP";
				case 22: item = "License Plate";
				case 23: item = "Additional Vehicle Slot";
				case 24: item = "Garage - Small";
				case 25: item = "Garage - Medium";
				case 26: item = "Garage - Large";
				case 27: item = "Garage - Extra Large";
				case 28: item = "Additional Toy Slot";
				case 29: item = "Hunger Voucher";
				case 30: item = "Spawn at Gold VIP+ room";				
			}

			if(isnull(inputtext) || Prices <= 0) {
			    format(string, sizeof(string), "The price can't be below 0.\n\nYou are currently editing the price of %s. The current credit cost is %d.", item, ShopItems[GetPVarInt(playerid, "EditingPrice")][sItemPrice]);
	    		ShowPlayerDialog(playerid, DIALOG_EDITSHOP2, DIALOG_STYLE_INPUT, "Editing Price", string, "Change", "Back");
			}
			SetPVarInt(playerid, "EditingPriceValue", Prices);

            format(string,sizeof(string),"Are you sure you want to edit the cost of %s?\n\nOld Cost: %d\nNew Cost: %d", item, ShopItems[GetPVarInt(playerid, "EditingPrice")][sItemPrice], Prices);
			ShowPlayerDialog(playerid, DIALOG_EDITSHOP3, DIALOG_STYLE_MSGBOX, "Confirmation", string, "Confirm", "Cancel");
			return 1;
		}
		new szDialog[1000];
	    format(szDialog, sizeof(szDialog),
		"Gold VIP (Credits: %s)\n\
		Gold VIP Renewal (Credits: %s)\n\
		Silver VIP (Credits: %s)\n\
		Bronze VIP (Credits: %s)\n\
		Toys (Credits: %s)\n\
		Vehicles (Credits: %s)\n\
		Poker Table (Credits: %s)\n\
		Boombox (Credits: %s)", number_format(ShopItems[0][sItemPrice]), number_format(ShopItems[1][sItemPrice]), number_format(ShopItems[2][sItemPrice]), number_format(ShopItems[3][sItemPrice]), number_format(ShopItems[4][sItemPrice]),
		 number_format(ShopItems[5][sItemPrice]), number_format(ShopItems[6][sItemPrice]), number_format(ShopItems[7][sItemPrice]));

		format(szDialog, sizeof(szDialog), "%s\n\
		Paintball Tokens (Credits %s)\n\
		EXP Token (Credits: %s)\n\
		Fireworks x5 (Credits: %s)\n\
		Renewal Regular (Credits: %s)\n\
		Renewal Standard (Credits: %s)\n\
		Renewal Premium (Credits: %s)\n\
		House (Credits: %s)\n\
		House Interior Change (Credits: %s)\n\
		House Move (Credits: %s)\n\
		(Micro) Reset Gift Timer (Credits: %s)",szDialog, number_format(ShopItems[8][sItemPrice]), number_format(ShopItems[9][sItemPrice]), number_format(ShopItems[10][sItemPrice]),
		number_format(ShopItems[11][sItemPrice]), number_format(ShopItems[12][sItemPrice]), number_format(ShopItems[13][sItemPrice]), number_format(ShopItems[14][sItemPrice]), number_format(ShopItems[15][sItemPrice]),
		number_format(ShopItems[16][sItemPrice]), number_format(ShopItems[17][sItemPrice]));
		format(szDialog, sizeof(szDialog),
		"%s\n(Micro) Advanced Healthcare (Credits: %s)\n\
		(Micro) Super Advanced Healthcare (Credits: %s)\n\
		(Micro) Rent a Car (Credits: %s)\n\
		Platinum VIP (Credits: %s)\n\
		Custom License Plate (Credits: %s)\n\
		Additional Vehicle Slot (Credits: %s)",szDialog, number_format(ShopItems[18][sItemPrice]), number_format(ShopItems[19][sItemPrice]), number_format(ShopItems[20][sItemPrice]), number_format(ShopItems[21][sItemPrice]),
		 number_format(ShopItems[22][sItemPrice]), number_format(ShopItems[23][sItemPrice]));
		format(szDialog, sizeof(szDialog),
		"%s\nGarage - Small (Credits: %s)\n\
		Garage - Medium (Credits: %s)\n\
		Garage - Large (Credits: %s)\n\
		Garage - Extra Large (Credits: %s)\n\
		Additional Toy Slot (Credits: %s)\n\
		Hunger Voucher (Credits: %s)\n\
		Spawn at Gold VIP+ room (Credits: %s)", szDialog, number_format(ShopItems[24][sItemPrice]), number_format(ShopItems[25][sItemPrice]), number_format(ShopItems[26][sItemPrice]),
		number_format(ShopItems[27][sItemPrice]), number_format(ShopItems[28][sItemPrice]), number_format(ShopItems[29][sItemPrice]), number_format(ShopItems[30][sItemPrice]));
	    ShowPlayerDialog(playerid, DIALOG_EDITSHOP, DIALOG_STYLE_LIST, "Edit Shop Prices", szDialog, "Edit", "Exit");
	}
	if(dialogid == DIALOG_EDITSHOP3)
	{
	    if(response)
	    {
	        new item[30];
	        switch(GetPVarInt(playerid, "EditingPrice"))
  			{
   				case 0: item = "Gold VIP";
    		 	case 1: item = "Gold VIP Renewal";
	       	 	case 2: item = "Silver VIP";
	        	case 3: item = "Bronze VIP";
	        	case 4: item = "Toys";
	        	case 5: item = "Vehicles";
	        	case 6: item = "Poker Table";
	        	case 7: item = "Boombox";
	        	case 8: item = "Paintball Tokens";
	        	case 9: item = "EXP Token";
	        	case 10: item = "Fireworks x5";
	        	case 11: item = "Renewal Regular";
	        	case 12: item = "Renewal Standard";
				case 13: item = "Renewal Premium";
				case 14: item = "House";
				case 15: item = "House Interior Change";
				case 16: item = "House Move";
				case 17: item = "(Micro) Reset Gift Timer";
				case 18: item = "(Micro) Advanced Health Care";
				case 19: item = "(Micro) Super Health Care";
				case 20: item = "(Micro) Rent a Car";
				case 21: item = "Platinum VIP";
				case 22: item = "License Plate";
				case 23: item = "Additional Vehicle Slot";
				case 24: item = "Garage - Small";
				case 25: item = "Garage - Medium";
				case 26: item = "Garage - Large";
				case 27: item = "Garage - Extra Large";
				case 28: item = "Additional Toy Slot";
				case 29: item = "Hunger Voucher";
				case 30: item = "Spawn at Gold VIP+ room";				
			}
			if(GetPVarInt(playerid, "EditingPriceValue") == 0)
			    SetPVarInt(playerid, "EditingPriceValue", 999999);

			Price[GetPVarInt(playerid, "EditingPrice")] = GetPVarInt(playerid, "EditingPriceValue");
	        ShopItems[GetPVarInt(playerid, "EditingPrice")][sItemPrice] = GetPVarInt(playerid, "EditingPriceValue");
	        format(string, sizeof(string), "You have successfully edited the price of %s to %d.", item, GetPVarInt(playerid, "EditingPriceValue"));
	        SendClientMessageEx(playerid, COLOR_WHITE, string);
	        format(string, sizeof(string), "[EDITSHOPPRICES] [User: %s(%i)] [IP: %s] [%s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), item, number_format(ShopItems[GetPVarInt(playerid, "EditingPrice")][sItemPrice]));
			Log("logs/editshop.log", string), print(string);
	        g_mysql_SavePrices();
	        return 1;
	    }
        DeletePVar(playerid, "EditingPrice");
        DeletePVar(playerid, "EditingPriceValue");
	    SendClientMessageEx(playerid, COLOR_GREY, "You have canceled the price change.");
	}
	if(dialogid == DIALOG_ENTERPIN)
	{
	    if(response)
	    {
            if(isnull(inputtext) || strlen(inputtext) > 4 || !IsNumeric(inputtext))
		    {
		        ShowPlayerDialog(playerid, DIALOG_ENTERPIN, DIALOG_STYLE_INPUT, "Pin Number", "Enter your pin number to access credit shops.", "Confirm", "Exit");
		        return 1;
		    }

			SetPVarString(playerid, "PinNumber", inputtext);

    		format(string, sizeof(string), "SELECT `Pin` FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, string, true, "OnPinCheck2", "i", playerid);

		}
	}
	if(dialogid == DIALOG_CREATEPIN)
	{
	    if(response)
	    {

            if(strlen(inputtext) > 4 || !IsNumeric(inputtext))
			    return ShowPlayerDialog(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Error: A pin must be numbers only, and have at least 4 digits. \nCreate a pin number so you can secure your account credits.", "Create", "Exit");

			if(GetPVarType(playerid, "ChangePin"))
			{
			    if(isnull(inputtext))
					return ShowPlayerDialog(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Change Pin Number", "Enter a new pin number to change your current one.", "Change", "Cancel");
			}
			else
			{
				if(isnull(inputtext))
					return ShowPlayerDialog(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Create a pin number so you can secure your account credits.", "Create", "Exit");
			}

			SetPVarString(playerid, "PinConfirm", inputtext);
			ShowPlayerDialog(playerid, DIALOG_CREATEPIN2, DIALOG_STYLE_INPUT, "Pin Number", "Enter your pin number again to confirm it.", "Create", "Exit");
		}
		else if(GetPVarType(playerid, "ChangePin")) DeletePVar(playerid, "ChangePin");
	}
	if(dialogid == DIALOG_VIEWSALE)
	{
	    if(response)
	    {
            format(string, sizeof(string), "SELECT * FROM `sales` WHERE `id` = '%d'", Selected[playerid][listitem]);
            mysql_function_query(MainPipeline, string, true, "CheckSales2", "i", playerid);
	    }
	}
	if(dialogid == DIALOG_CREATEPIN2)
	{
	    if(response)
	    {
			if(isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_CREATEPIN2, DIALOG_STYLE_INPUT, "Pin Number", "Enter your pin number again to confirm it.", "Create", "Exit");

			new confirm[128];
			GetPVarString(playerid, "PinConfirm", confirm, 128);
			if(strcmp(inputtext, confirm, true) != 0)
			{
			    if(GetPVarType(playerid, "ChangePin"))
				{
                    ShowPlayerDialog(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Enter a new pin number to change your current one.", "Change", "Cancel");
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Error: Pin numbers did not match.\n\nCreate a pin number so you can secure your account credits.", "Create", "Exit");
				}
				DeletePVar(playerid, "PinConfirm");
			}
			else
			{
			    format(string, sizeof(string), "Your new pin number is '%s.'", inputtext);
				SendClientMessageEx(playerid, COLOR_CYAN, string);

				new passbuffer[258];
				WP_Hash(passbuffer, sizeof(passbuffer), inputtext);

				new query[256];
				format(query, sizeof(query), "UPDATE `accounts` SET `Pin`='%s' WHERE `id` = %d", passbuffer, GetPlayerSQLId(playerid));
				mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
				DeletePVar(playerid, "PinConfirm");
				DeletePVar(playerid, "ChangePin");
			}
		}
	}
	if(dialogid == DIALOG_MISCSHOP && response)
	{
	    SetPVarInt(playerid, "MiscShop", listitem+1);
	    switch(listitem)
	    {
			case 0:
			{
			    format(string, sizeof(string), "Item: Poker Table\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[6][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[6][sItemPrice]));
	   		 	ShowPlayerDialog(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 1:
			{
			    format(string, sizeof(string), "Item: Boombox\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[7][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[7][sItemPrice]));
        	    ShowPlayerDialog(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 2:
			{
			    format(string, sizeof(string), "Item: 100 Paintball Tokens\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[8][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[8][sItemPrice]));
        	    ShowPlayerDialog(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 3:
			{
			    format(string, sizeof(string), "Item: EXP Token\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[9][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[9][sItemPrice]));
        	    ShowPlayerDialog(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 4:
			{
			    format(string, sizeof(string), "Item: Fireworks x5\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[10][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[10][sItemPrice]));
        	    ShowPlayerDialog(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 5:
			{
			    format(string, sizeof(string), "Item: Custom License Plate\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[22][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[22][sItemPrice]));
        	    ShowPlayerDialog(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
		}
	}
	if(dialogid == DIALOG_MISCSHOP2 && response)
	{
		if(GetPVarInt(playerid, "MiscShop") == 1)
		{
		    if(PlayerInfo[playerid][pCredits] < ShopItems[6][sItemPrice])
		        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			else if(PlayerInfo[playerid][pTable] == 1)
			    return SendClientMessageEx(playerid, COLOR_GREY, "You already own a poker table.");
				
			else
			{
			    AmountSold[6]++;
				AmountMade[6] += ShopItems[6][sItemPrice];
			    //ShopItems[6][sSold]++;
				//ShopItems[6][sMade] += ShopItems[6][sItemPrice];
				new szQuery[128];
				format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold6` = '%d', `AmountMade6` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[6], AmountMade[6]);
    			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			    GivePlayerCredits(playerid, -ShopItems[6][sItemPrice], 1);
			    printf("Price6: %d", 250);
				PlayerInfo[playerid][pTable] = 1;

				format(string, sizeof(string), "[SHOPMISC] [User: %s(%i)] [IP: %s] [Credits: %s] [Pokertable] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[6][sItemPrice]));
				Log("logs/credits.log", string), print(string);

				format(string, sizeof(string), "You have purchased a pokertable for %s credits.", number_format(ShopItems[6][sItemPrice]));
				SendClientMessageEx(playerid, COLOR_CYAN, string);
				DeletePVar(playerid, "MiscShop");
			}
		}
		else if(GetPVarInt(playerid, "MiscShop") == 2)
		{
		    if(PlayerInfo[playerid][pCredits] < ShopItems[7][sItemPrice])
		        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			else if(PlayerInfo[playerid][pBoombox] == 1)
			    return SendClientMessageEx(playerid, COLOR_GREY, "You already own a boombox.");

			else
			{
				AmountSold[7]++;
				AmountMade[7] += ShopItems[7][sItemPrice];
			    //ShopItems[7][sSold]++;
		 		//ShopItems[7][sMade] += ShopItems[7][sItemPrice];
		 		new szQuery[128];
		 		format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold7` = '%d', `AmountMade7` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[7], AmountMade[7]);
    			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			    GivePlayerCredits(playerid, -ShopItems[7][sItemPrice], 1);
			    printf("Price7: %d", ShopItems[7][sItemPrice]);
				PlayerInfo[playerid][pBoombox] = 1;

				format(string, sizeof(string), "[SHOPMISC] [User: %s(%i)] [IP: %s] [Credits: %s] [Boombox] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[7][sItemPrice]));
				Log("logs/credits.log", string), print(string);

				format(string, sizeof(string), "You have purchased a boombox for %s credits.", number_format(ShopItems[7][sItemPrice]));
				SendClientMessageEx(playerid, COLOR_CYAN, string);
				DeletePVar(playerid, "MiscShop");
			}
		}
		else if(GetPVarInt(playerid, "MiscShop") == 3)
		{
		    if(PlayerInfo[playerid][pCredits] < ShopItems[8][sItemPrice])
		        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

            AmountSold[8]++;
			AmountMade[8] += ShopItems[8][sItemPrice];
            //ShopItems[8][sSold]++;
			//ShopItems[8][sMade] += ShopItems[8][sItemPrice];
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold8` = '%d', `AmountMade8` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[8], AmountMade[8]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			GivePlayerCredits(playerid, -ShopItems[8][sItemPrice], 1);
			printf("Price8: %d", ShopItems[8][sItemPrice]);
			PlayerInfo[playerid][pPaintTokens] += 100;

			format(string, sizeof(string), "[SHOPMISC] [User: %s(%i)] [IP: %s] [Credits: %s] [100 Paintball Tokens] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[8][sItemPrice]));
			Log("logs/credits.log", string), print(string);

			format(string, sizeof(string), "You have purchased 100 paintball tokens for %s credits.", number_format(ShopItems[8][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			DeletePVar(playerid, "MiscShop");
		}
		else if(GetPVarInt(playerid, "MiscShop") == 4)
		{
		    if(PlayerInfo[playerid][pCredits] < ShopItems[9][sItemPrice])
		        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			AmountSold[9]++;
			AmountMade[9] += ShopItems[9][sItemPrice];
            //ShopItems[9][sSold]++;
			//ShopItems[9][sMade] += ShopItems[9][sItemPrice];
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold9` = '%d', `AmountMade9` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[9], AmountMade[9]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			GivePlayerCredits(playerid, -ShopItems[9][sItemPrice], 1);
			printf("Price9: %d", ShopItems[9][sItemPrice]);
			PlayerInfo[playerid][pEXPToken] += 1;

			format(string, sizeof(string), "[SHOPMISC] [User: %s(%i)] [IP: %s] [Credits: %s] [EXP Token] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[9][sItemPrice]));
			Log("logs/credits.log", string), print(string);

			format(string, sizeof(string), "You have purchased a EXP Token for %s credits.", number_format(ShopItems[9][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			DeletePVar(playerid, "MiscShop");
		}
		else if(GetPVarInt(playerid, "MiscShop") == 5)
		{
		    if(PlayerInfo[playerid][pCredits] < ShopItems[10][sItemPrice])
		        return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

            AmountSold[10]++;
			AmountMade[10] += ShopItems[10][sItemPrice];
            //ShopItems[10][sSold]++;
			//ShopItems[10][sMade] += ShopItems[10][sItemPrice];
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold10` = '%d', `AmountMade10` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[10], AmountMade[10]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			GivePlayerCredits(playerid, -ShopItems[10][sItemPrice], 1);
			printf("Price10: %d", ShopItems[10][sItemPrice]);
			PlayerInfo[playerid][pFirework] += 5;

			format(string, sizeof(string), "[SHOPMISC] [User: %s(%i)] [IP: %s] [Credits: %s] [Firework X5] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[10][sItemPrice]));
			Log("logs/credits.log", string), print(string);

			format(string, sizeof(string), "You have purchased 5 fireworks for %s credits.", number_format(ShopItems[10][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			DeletePVar(playerid, "MiscShop");
		}
		else if(GetPVarInt(playerid, "MiscShop") == 6)
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[22][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[22][sItemPrice], 1);
			printf("Price22: %d", ShopItems[22][sItemPrice]);

            AmountSold[22]++;
			AmountMade[22] += ShopItems[22][sItemPrice];
			//ShopItems[22][sSold]++;
			//ShopItems[22][sMade] += ShopItems[22][sItemPrice];
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold22` = '%d', `AmountMade22` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[22], AmountMade[22]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased Custom License Plate (Credits)");
			SendReportToQue(playerid, "Custom License Plate (Credits)", 2, 2);
			format(string, sizeof(string), "You have purchased a custom license plate for %s credits.", number_format(ShopItems[22][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the custom license plate issued.");

			format(string, sizeof(string), "[Custom License Plate] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[22][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
		else if(GetPVarInt(playerid, "MiscShop") == 7) // Vehicle Slots
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[23][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[23][sItemPrice], 1);
			printf("Price223: %d", ShopItems[23][sItemPrice]);		
				
            AmountSold[23]++;
			AmountMade[23] += ShopItems[23][sItemPrice];

			
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold23` = '%d', `AmountMade23` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[23], AmountMade[23]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "You have purchased a additional vehicle slot for %s credits.", number_format(ShopItems[23][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			PlayerInfo[playerid][pVehicleSlot] += 1;
			LoadPlayerDisabledVehicles(playerid);

			format(string, sizeof(string), "[Additional Vehicle Slot] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[23][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
		else if(GetPVarInt(playerid, "MiscShop") == 8) // Toy Slots
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[28][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[28][sItemPrice], 1);
			printf("Price223: %d", ShopItems[28][sItemPrice]);		
				
            AmountSold[28]++;
			AmountMade[28] += ShopItems[28][sItemPrice];

			
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold28` = '%d', `AmountMade28` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[28], AmountMade[28]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "You have purchased a additional toy slot for %s credits.", number_format(ShopItems[28][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			PlayerInfo[playerid][pToySlot] += 1;
			LoadPlayerDisabledVehicles(playerid);

			format(string, sizeof(string), "[Additional Toy Slot] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[28][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
		else if(GetPVarInt(playerid, "MiscShop") == 9) // Spawn at Gold VIP+ room
		{
	        if(PlayerInfo[playerid][pCredits] < ShopItems[30][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[30][sItemPrice], 1);
			printf("Price29: %d", ShopItems[30][sItemPrice]);		
				
            AmountSold[30]++;
			AmountMade[30] += ShopItems[30][sItemPrice];

			
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold30` = '%d', `AmountMade30` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[30], AmountMade[30]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "You have purchased a spawn at the Gold VIP+ room, you will be able to use it after your next death.", number_format(ShopItems[30][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			
			PlayerInfo[playerid][pVIPSpawn] = 1;
			OnPlayerStatsUpdate(playerid);

			format(string, sizeof(string), "[Spawn at Gold VIP+ room] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[30][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}		
	    DeletePVar(playerid, "MiscShop");
	}
	if(dialogid == DIALOG_SHOPHELPMENU)
	{
	    if(response)
	    {
	    	switch(listitem)
	    	{
	    	    case 0: //VIP Shop
	    	    {
	    	        SetPVarInt(playerid, "ShopCheckpoint", listitem+1);
	    	        ShowPlayerDialog(playerid, DIALOG_SHOPHELPMENU8, DIALOG_STYLE_MSGBOX, "VIP Shop", "To purchase Bronze VIP, Silver VIP or Gold VIP you use /vipshop at one of the VIP points located outside each VIP Club.\n You can renew your Gold VIP by using /vipshop however you need to make sure that you have renewable Gold VIP.\n You can read the benefits of VIP on the Shop Control Panel or listed within /vipshop.", "Checkpoint", "Exit");
	    	    }
	    	    case 1:
	    	    {
	    	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "House Shop", "To purchase a house, change your house interior, or buy a house move from the shop, you can use /houseshop anywhere. \nYou can read more information regarding houses on the Shop Control Panel.", "Exit", "");
	    	    }
	    	    case 2:
	    	    {
	    	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Business Shop", "Want to buy a business or renew your current one? Use the command /businessshop and this will allow you to purchase a business or renew your current one.\n It is important that you read the business rules on the forums and read more about businesses on the Shop Control Panel. Note: The Purchase Business will list the available businesses for sale at that time.", "Exit", "");
	    	    }
	    	    case 3:
	    	    {
	    	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Toy Shop", "To purchase a custom toy use /toyshop at a clothing shop. This allows you to see the selection of toys available and purchase one by simply clicking on it!\n After purchasing the toy will be put in your toy slot.", "Exit", "");
	     		}
	        	case 4:
				{
				    ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Miscellaneous Shop", "To buy miscellaneous products such as poker tables and EXP tokens, visit any 24/7 business and use the /miscshop command.\n This will pop-up all the available miscellaneous products that are for sale. Keep an eye out as there are always new additions!", "Exit", "");
				}
				case 5:
				{
				    ShowPlayerDialog(playerid, DIALOG_SHOPHELPMENU2, DIALOG_STYLE_MSGBOX, "Car Shop", "To purchase a custom car, you can use /carshop at locations from shipping docks and other locations.\n Using /carshop allows you to see the selection of cars available and purchase one by simply clicking on it!\n The car will be put into your car slot after you purchase.", "Checkpoint", "Exit");
				}
				case 6:
				{
				    ShowPlayerDialog(playerid, DIALOG_SHOPHELPMENU3, DIALOG_STYLE_MSGBOX, "Plane Shop", "To purchase a custom car, you can use /carshop at locations from shipping docks and other locations.\n Using /carshop allows you to see the selection of cars available and purchase one by simply clicking on it!\n The car will be put into your car slot after you purchase.", "Checkpoint", "Exit");
				}
				case 7:
				{
                    ShowPlayerDialog(playerid, DIALOG_SHOPHELPMENU5, DIALOG_STYLE_MSGBOX, "Boat Shop", "To purchase a custom car, you can use /carshop at locations from shipping docks and other locations.\n Using /carshop allows you to see the selection of cars available and purchase one by simply clicking on it!\n The car will be put into your car slot after you purchase.", "Checkpoint", "Exit");
				}
			}
	    }
	}
	if(dialogid == DIALOG_SHOPHELPMENU8)
	{
	    if(response)
	    {
	         ShowPlayerDialog(playerid, DIALOG_SHOPHELPMENU9, DIALOG_STYLE_LIST, "Boat Shop Locater", "Los Santos\nSan Fierro\nLas Venturas", "Locate", "Cancel");
	    }
	}
	if(dialogid == DIALOG_SHOPHELPMENU9)
	{
	    if(response)
	    {
	        if(CheckPointCheck(playerid))
				return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");

	        SetPVarInt(playerid, "ShopCheckpoint", 1);
			switch(listitem)
			{
			    case 0: SetPlayerCheckpoint(playerid, 1811.3344, -1569.4244, 13.4811, 5.0);
			    case 1: SetPlayerCheckpoint(playerid, -2443.6013, 499.7480, 30.0906, 5.0);
			    case 2: SetPlayerCheckpoint(playerid,  1934.1083, 1364.5004, 9.2578, 5.0);
			}
	    }
	}
	if(dialogid == DIALOG_SHOPHELPMENU5)
	{
	    if(response)
	    {
	         ShowPlayerDialog(playerid, DIALOG_SHOPHELPMENU6, DIALOG_STYLE_LIST, "Boat Shop Locater", "Los Santos\nSan Fierro\nBayside", "Locate", "Cancel");
	    }
	}
	if(dialogid == DIALOG_SHOPHELPMENU6)
	{
	    if(response)
	    {
	        if(CheckPointCheck(playerid))
				return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");

	        SetPVarInt(playerid, "ShopCheckpoint", 1);
			switch(listitem)
			{
			    case 0: SetPlayerCheckpoint(playerid, 723.1553, -1494.4547, 1.9343, 5.0);
			    case 1: SetPlayerCheckpoint(playerid, -2975.8950, 505.1325, 2.4297, 5.0);
			    case 2: SetPlayerCheckpoint(playerid, -2214.1636, 2422.4763, 2.496, 5.0);
			}
	    }
	}
	if(dialogid == DIALOG_SHOPHELPMENU3)
	{
	    if(response)
	    {
	         ShowPlayerDialog(playerid, DIALOG_SHOPHELPMENU4, DIALOG_STYLE_LIST, "Plane Shop Locater", "Los Santos Airport\nLas Venturas Airport", "Locate", "Cancel");
	    }
	}
	if(dialogid == DIALOG_SHOPHELPMENU4)
	{
	    if(response)
	    {
	        if(CheckPointCheck(playerid))
				return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");

	        SetPVarInt(playerid, "ShopCheckpoint", 1);
			switch(listitem)
			{
			    case 0: SetPlayerCheckpoint(playerid, 1891.9105, -2279.6174, 13.5469, 5.0);
			    case 1: SetPlayerCheckpoint(playerid, 1632.0836, 1551.7365, 10.8061, 5.0);
			}
	    }
	}
	if(dialogid == DIALOG_SHOPHELPMENU2)
	{
	    if(response)
	    {
	        ShowPlayerDialog(playerid, DIALOG_SHOPHELPMENU7, DIALOG_STYLE_LIST, "Car Shop Locater", "Los Santos\nSan Fierro\nLas Venturas", "Locate", "Cancel");
		}
	}
	if(dialogid == DIALOG_SHOPHELPMENU7)
	{
	    if(response)
	    {
	        if(CheckPointCheck(playerid))
				return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");

	        SetPVarInt(playerid, "ShopCheckpoint", 1);
			switch(listitem)
			{
			    case 0: SetPlayerCheckpoint(playerid, 2280.5720, -2325.2490, 13.5469, 5.0);
			    case 1: SetPlayerCheckpoint(playerid, -1731.1923, 127.4794, 3.2976, 5.0);
				case 2: SetPlayerCheckpoint(playerid, 1663.9569, 1628.5106, 10.8203, 5.0);
			}
	    }
	}
	if(dialogid == DIALOG_RENTACAR)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[20][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

            new
				szQuery[215];

            AmountSold[20]++;
			AmountMade[20] += ShopItems[20][sItemPrice];

            //ShopItems[20][sSold]++;
			//ShopItems[20][sMade] += ShopItems[20][sItemPrice];

			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold20` = '%d', `AmountMade20` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[20], AmountMade[20]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			if(IsPlayerInRangeOfPoint(playerid, 4, 1102.8999, -1440.1669, 15.7969))
            {
                format(szQuery, sizeof(szQuery), "INSERT INTO `rentedcars` (`sqlid`, `modelid`, `posx`, `posy`, `posz`, `posa`, `spawned`, `hours`) VALUES ('%d', '%d', '%f', '%f', '%f', '%f', '1', '180')", GetPlayerSQLId(playerid), GetPVarInt(playerid, "VehicleID"), 1060.4927,-1474.9323,13.1905,345.2816);
            	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

   				SetPVarInt(playerid, "RentedVehicle", CreateVehicle(GetPVarInt(playerid, "VehicleID"), 1060.4927, -1474.9323, 13.1905, 345.2816, random(128), random(128), 2000000));
            }
            else if(IsPlayerInRangeOfPoint(playerid, 4, 1796.0620, -1588.5571, 13.4951))
            {
                format(szQuery, sizeof(szQuery), "INSERT INTO `rentedcars` (`sqlid`, `modelid`, `posx`, `posy`, `posz`, `posa`, `spawned`, `hours`) VALUES ('%d', '%d', '%f', '%f', '%f', '%f', '1', '180')", GetPlayerSQLId(playerid), GetPVarInt(playerid, "VehicleID"), 1787.6924, -1605.8617,13.1750, 76.7439);
            	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

   				SetPVarInt(playerid, "RentedVehicle", CreateVehicle(GetPVarInt(playerid, "VehicleID"), 1787.6924, -1605.8617, 13.1750, 76.7439, random(128), random(128), 2000000));
            }

            GivePlayerCredits(playerid, -ShopItems[20][sItemPrice], 1);
            printf("Price20: %d", ShopItems[20][sItemPrice]);
			IsPlayerEntering{playerid} = true;
			PutPlayerInVehicle(playerid, GetPVarInt(playerid, "RentedVehicle"), 0);

			format(szQuery, sizeof(szQuery), "[RentaCar] [User: %s(%i)] [IP: %s] [Model: %d] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "VehicleID"), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[20][sItemPrice]));
			Log("logs/credits.log", szQuery), print(szQuery);

			format(szQuery, sizeof(szQuery), "[Rent a Car] You have rented a %s for %s credits, the vehicle will last 3 hours.", VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[20][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, szQuery);
			SendClientMessageEx(playerid, COLOR_CYAN, "Commands Available: /park, /stoprentacar, /trackcar");

			SetPVarInt(playerid, "RentedHours", 180);
			VehicleFuel[GetPVarInt(playerid, "RentedVehicle")] = 100;
	    }
	    DeletePVar(playerid, "VehicleID");
	}
	if(dialogid == DIALOG_CARSHOP)
	{
	    if(response)
	    {
	    	if(PlayerInfo[playerid][pCredits] < ShopItems[5][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

	   		else if(!vehicleCountCheck(playerid))
				return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You can't have any more vehicles, you own too many!", "OK", "");

			else if(!vehicleSpawnCountCheck(playerid))
				return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You have too many vehicles spawned, you must store one first.", "OK", "");

			else
			{
			    if(GetPVarType(playerid, "BoatShop"))
			    {
			        new createdcar;
			        if(IsPlayerInRangeOfPoint(playerid, 4, -2214.1636, 2422.4763, 2.4961))
            		{
            		    createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), -2218.4795, 2424.9880, -0.3707, 314.4837, 0, 0, 2000000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
            		}
            		else if(IsPlayerInRangeOfPoint(playerid, 4, -2975.8950, 505.1325, 2.4297))
            		{
            		    createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), -2975.4841, 509.6216, -0.4241, 89.7179, 0, 0, 2000000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
            		}
            		else if(IsPlayerInRangeOfPoint(playerid, 4, 723.1553, -1494.4547, 1.9343))
            		{
            		    createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), 723.4292, -1505.4899, -0.4145, 180.4212, 0, 0, 2000000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
            		}
					else if(IsPlayerInRangeOfPoint(playerid, 4, 2974.7520, -1462.9265, 2.8184))
					{
						createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), 2996.4255, -1467.3026, 2.8184, 0, 0, 0, 2000000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
						DeletePVar(playerid, "ShopTP");
					}

			        GivePlayerCredits(playerid, -ShopItems[5][sItemPrice], 1);
			        printf("Price5: %d", ShopItems[5][sItemPrice]);
			        IsPlayerEntering{playerid} = true;
					PutPlayerInVehicle(playerid, createdcar, 0);
					AmountSold[5]++;
					AmountMade[5] += ShopItems[5][sItemPrice];
			    	//ShopItems[5][sSold]++;
				 	//ShopItems[5][sMade] += ShopItems[5][sItemPrice];
				 	new szQuery[128];
				 	format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold5` = '%d', `AmountMade5` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[5], AmountMade[5]);
    				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

					new Float: arr_fPlayerPos[4];

					GetPlayerPos(playerid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
					GetPlayerFacingAngle(playerid, arr_fPlayerPos[3]);

					format(string, sizeof(string), "[CAR %i] [User: %s(%i)] [IP: %s] [Credits: %s] [Vehicle: %s] [Price: %s]", AmountSold[5], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[5][sItemPrice]));
					Log("logs/credits.log", string), print(string);

					format(string, sizeof(string), "[Car Shop] You have purchased a %s for %s credits.", VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[5][sItemPrice]));
					SendClientMessageEx(playerid, COLOR_CYAN, string);
					DeletePVar(playerid, "BoatShop");
			    }
			    else
			    {
			    	GivePlayerCredits(playerid, -ShopItems[5][sItemPrice], 1);
			    	printf("Price5: %d", ShopItems[5][sItemPrice]);

			    	AmountSold[5]++;
					AmountMade[5] += ShopItems[5][sItemPrice];
			    	//ShopItems[5][sSold]++;
				 	//ShopItems[5][sMade] += ShopItems[5][sItemPrice];

				 	new szQuery[128];
				 	format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold5` = '%d', `AmountMade5` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[5], AmountMade[5]);
    				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

					new Float: arr_fPlayerPos[4], createdcar;

					GetPlayerPos(playerid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
					GetPlayerFacingAngle(playerid, arr_fPlayerPos[3]);
					if(IsPlayerInDynamicArea(playerid, NGGShop))
					{
						arr_fPlayerPos[0] = 2923.3220;
						arr_fPlayerPos[1] = -1276.6011;
						arr_fPlayerPos[2] = 10.9809;
						arr_fPlayerPos[3] = 11.4626;
						if(IsAPlane(GetPVarInt(playerid, "VehicleID"), 1))
						{
							arr_fPlayerPos[0] = 2947.2390;
							arr_fPlayerPos[1] = -1224.1877;
							arr_fPlayerPos[2] = 4.6875;
							arr_fPlayerPos[3] = 0;
						}
						DeletePVar(playerid, "ShopTP");
					}
					createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2], arr_fPlayerPos[3], 0, 0, 2000000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
					format(string, sizeof(string), "[CAR %i] [User: %s(%i)] [IP: %s] [Credits: %s] [Vehicle: %s] [Price: %s]", AmountSold[5], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[5][sItemPrice]));
					Log("logs/credits.log", string), print(string);
                    IsPlayerEntering{playerid} = true;
					PutPlayerInVehicle(playerid, createdcar, 0);
					format(string, sizeof(string), "[Car Shop] You have purchased a %s for %s credits.", VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[5][sItemPrice]));
					SendClientMessageEx(playerid, COLOR_CYAN, string);
				}
			}
		}
		DeletePVar(playerid, "VehicleID");
	}
	if(dialogid == DIALOG_CARSHOP2)
	{
	    if(response)
	    {
	    	if(PlayerInfo[playerid][pCarVoucher] == 0)
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a restricted vehicle voucher. ");

	   		else if(!vehicleCountCheck(playerid))
				return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You can't have any more vehicles, you own too many!", "OK", "");

			else if(!vehicleSpawnCountCheck(playerid))
				return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You have too many vehicles spawned, you must store one first.", "OK", "");

			else
			{
			    PlayerInfo[playerid][pCarVoucher]--;
				new Float: arr_fPlayerPos[4], createdcar;
				GetPlayerPos(playerid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
				GetPlayerFacingAngle(playerid, arr_fPlayerPos[3]);
				createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2], arr_fPlayerPos[3], 0, 0, 2000000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				format(string, sizeof(string), "[CAR %i] [User: %s(%i)] [IP: %s] [Credits: %s] [Vehicle: %s] [Price: %s]", AmountSold[5], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[5][sItemPrice]));
				Log("logs/carvoucher.log", string), print(string);
     			IsPlayerEntering{playerid} = true;
				PutPlayerInVehicle(playerid, createdcar, 0);
				format(string, sizeof(string), "[Car Shop] You have purchased a %s for 1 restricted car voucher.", VehicleName[GetPVarInt(playerid, "VehicleID") - 400]);
				SendClientMessageEx(playerid, COLOR_CYAN, string);
			}
		}
		DeletePVar(playerid, "VehicleID");
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0: // Add Business
	            {
	                for (new i; i < sizeof(BusinessSales); i++)
    				{
    		    		if(BusinessSales[i][bAvailable] == 0)
    		    		{
    		    		    SetPVarInt(playerid, "EditingSale", i);
    		    		    break;
						}
					}
	                ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS2, DIALOG_STYLE_INPUT, "Adding Business [1/4]","Enter the business ID you wish to sell.", "Next", "Cancel");
	            }
	            case 1: // Edit Business
	            {
	                new Count, szDialog[500];
	                for (new i; i < sizeof(BusinessSales); i++)
    				{
    		    		if(BusinessSales[i][bAvailable] == 1 || BusinessSales[i][bAvailable] == 3)
    		    		{
							format(szDialog, sizeof(szDialog), "%s\n(%d) %s | Type: %d | Credits: %s", szDialog, BusinessSales[i][bBusinessID], BusinessSales[i][bText],BusinessSales[i][bType], number_format(BusinessSales[i][bPrice]));
                            Selected[playerid][Count] = i;
    						Count++;
						}
					}
					ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS8, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
	            }
	            case 2: // View Businesses Sold
	            {
	                new Count, szDialog[500];
	                for (new i; i < sizeof(BusinessSales); i++)
    				{
    		    		if(BusinessSales[i][bAvailable] == 2)
    		    		{
							format(szDialog, sizeof(szDialog), "%s\n(Business ID: %d)%s | (Credits: %s) | Purchaser: %d", szDialog, BusinessSales[i][bBusinessID], BusinessSales[i][bText], number_format(BusinessSales[i][bPrice]), BusinessSales[i][bPurchased]);
                            Selected[playerid][Count] = i;
    						Count++;
						}
					}
					ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS7, DIALOG_STYLE_LIST, "Businesses Purchased", szDialog, "Reset", "Exit");
	            }
	        }
	    }
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS8)
	{
	    if(response)
	    {
	        new szDialog[128];
	        SetPVarInt(playerid, "BusinessList", listitem);
	    	format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][listitem]][bBusinessID], BusinessSales[Selected[playerid][listitem]][bText],BusinessSales[Selected[playerid][listitem]][bType],
			number_format(BusinessSales[Selected[playerid][listitem]][bPrice]), BusinessSales[Selected[playerid][listitem]][bAvailable]);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Reset", "Exit");
	    }
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS9)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0: // Business ID
	            {
	                ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS10, DIALOG_STYLE_INPUT, "Editing Business","Enter the business ID you wish to sell.", "Submit", "Back");
	            }
	            case 1: // Text
	            {
	                ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS11, DIALOG_STYLE_INPUT, "Editing Business","Enter the business description.", "Submit", "Back");
	            }
	            case 2: // Type
	            {
	                ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS12, DIALOG_STYLE_INPUT, "Editing Business","Enter the type of the business. (1-3)", "Submit", "Back");
	            }
				case 3: // Credits
				{
				    ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS13, DIALOG_STYLE_INPUT, "Editing Business","Enter the amount of credits needed to purchase the business.", "Submit", "Back");
				}
				case 4: // Available
				{
					if(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable] == 1)
					{
     					BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable] = 3;
     					SendClientMessageEx(playerid, COLOR_CYAN, "That business is now unavailable for purchase.");
					}
					else
					{
     					BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable] = 1;
     					SendClientMessageEx(playerid, COLOR_CYAN, "That business is now available for purchase.");
					}
					new szDialog[128];
					format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
		 			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
            		ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
				}
	        }
	    }
	    else
	    {
	        SaveBusinessSale(Selected[playerid][GetPVarInt(playerid, "BusinessList")]);
	        DeletePVar(playerid, "BusinessList");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS13)
	{
	    if(response)
	    {
	        new BusinessID;
	        if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS13, DIALOG_STYLE_INPUT, "Editing Business","Enter the amount of credits needed to purchase the business.", "Submit", "Back");

			if(BusinessID < 0)
			    return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS13, DIALOG_STYLE_INPUT, "Editing Business","Enter the amount of credits needed to purchase the business.", "Submit", "Back");

			new szDialog[128];
			BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice] = BusinessID;
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
		 	number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
	    }
	    else
	    {
	        new szDialog[128];
	        format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
		 	number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
	    }
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS12)
	{
	    if(response)
	    {
	        new BusinessID;
	        if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS12, DIALOG_STYLE_INPUT, "Editing Business","Enter the type of the business. (1-3)", "Submit", "Back");

			if(BusinessID < 1 || BusinessID > 3)
			    return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS12, DIALOG_STYLE_INPUT, "Editing Business","Enter the type of the business. (1-3)", "Submit", "Back");

			new szDialog[128];
			BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType] = BusinessID;
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
		 	number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
	    }
	    else
	    {
	        new szDialog[128];
	        format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
		 	number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
	    }
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS11)
	{
	    if(response)
	    {
	        if(isnull(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS11, DIALOG_STYLE_INPUT, "Editing Business","Enter the business description.", "Submit", "Back");

		    if(strlen(inputtext) > 128)
                return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS11, DIALOG_STYLE_INPUT, "Editing Business","Enter the business description.", "Submit", "Back");

            new szDialog[128];
            strcpy(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText], inputtext, 128);
            format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
	    }
	    else
	    {
	        new szDialog[128];
	        format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
	    }
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS10)
	{
	    if(response)
	    {
	        new BusinessID;
	        if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS10, DIALOG_STYLE_INPUT, "Editing Business","Enter the business ID you wish to sell.", "Submit", "Back");

			if(!IsValidBusinessID(BusinessID))
			    return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS10, DIALOG_STYLE_INPUT, "Editing Business","Enter the business ID you wish to sell.", "Submit", "Back");

			new szDialog[128];
			BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID] = BusinessID;
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
	    }
	    else
	    {
	        new szDialog[128];
	        format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
		 	number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
	    }
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS7)
	{
	    if(response)
	    {
	        if(BusinessSales[Selected[playerid][listitem]][bAvailable] == 2) {
	        	strcpy(BusinessSales[Selected[playerid][listitem]][bText], "None", 128);
	        	BusinessSales[Selected[playerid][listitem]][bBusinessID] = -1;
	        	BusinessSales[Selected[playerid][listitem]][bType] = 0;
	        	BusinessSales[Selected[playerid][listitem]][bAvailable] = 0;
	        	BusinessSales[Selected[playerid][listitem]][bPrice] = 0;
				SendClientMessageEx(playerid, COLOR_CYAN, "You have reset the business sale.");
			}
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS2)
	{
	    if(response)
	    {
	        new BusinessID;
	        if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS2, DIALOG_STYLE_INPUT, "Adding Business [1/4]","Enter the business ID you wish to sell.", "Next", "Cancel");

			if(!IsValidBusinessID(BusinessID))
			    return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS2, DIALOG_STYLE_INPUT, "Adding Business [1/4]","Enter the business ID you wish to sell.", "Next", "Cancel");

			for (new i; i < sizeof(BusinessSales); i++)
			{
 				if(BusinessSales[i][bBusinessID] == BusinessID)
   				{
					SendClientMessageEx(playerid, COLOR_GREY, "That business ID is already in use.");
					return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS2, DIALOG_STYLE_INPUT, "Adding Business [1/4]","Enter the business ID you wish to sell.", "Next", "Cancel");
				}
			}
			BusinessSales[GetPVarInt(playerid, "EditingSale")][bBusinessID] = BusinessID;
			ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS3, DIALOG_STYLE_INPUT, "Adding Business [2/4]", "Enter a description for the business.", "Next", "Cancel");
	    }
	    else
	    {
	        ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
	    }
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS3)
	{
	    if(response)
	    {
	        if(isnull(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS3, DIALOG_STYLE_INPUT, "Adding Business [2/4]", "Enter a description for the business.", "Next", "Cancel");

		    if(strlen(inputtext) > 128)
                return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS3, DIALOG_STYLE_INPUT, "Adding Business [2/4]", "Enter a description for the business.", "Next", "Cancel");

            strcpy(BusinessSales[GetPVarInt(playerid, "EditingSale")][bText], inputtext, 128);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS4, DIALOG_STYLE_INPUT, "Adding Business [3/4]", "Enter the business type (1-3).", "Next", "Cancel");
	    }
	    else
	    {
	        ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
	    }
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS4)
	{
	    if(response)
	    {
	        new BusinessID;
	        if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS4, DIALOG_STYLE_INPUT, "Adding Business [3/4]", "Enter the business type (1-3).", "Next", "Cancel");

			if(BusinessID < 1 || BusinessID > 3)
				return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS4, DIALOG_STYLE_INPUT, "Adding Business [3/4]", "Enter the business type (1-3).", "Next", "Cancel");

			BusinessSales[GetPVarInt(playerid, "EditingSale")][bType] = BusinessID;
			ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS5, DIALOG_STYLE_INPUT, "Adding Business [4/4]", "Enter the amount of credits needed to purchase this business.", "Next", "Cancel");
	    }
	    else
	    {
	        ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
	    }
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS5)
	{
	    if(response)
	    {
	        new BusinessID;
	        if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS5, DIALOG_STYLE_INPUT, "Adding Business [4/4]", "Enter the amount of credits needed to purchase this business.", "Next", "Cancel");

			if(BusinessID < 0)
			    return ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS5, DIALOG_STYLE_INPUT, "Adding Business [4/4]", "Enter the amount of credits needed to purchase this business.", "Next", "Cancel");

            BusinessSales[GetPVarInt(playerid, "EditingSale")][bPrice] = BusinessID;
            format(string, sizeof(string), "Business ID: %d\nBusiness Description: %s\nBusiness Type: %d\nBusiness Price: %d", BusinessSales[GetPVarInt(playerid, "EditingSale")][bBusinessID], BusinessSales[GetPVarInt(playerid, "EditingSale")][bText], BusinessSales[GetPVarInt(playerid, "EditingSale")][bType], BusinessSales[GetPVarInt(playerid, "EditingSale")][bPrice]);
            ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS6, DIALOG_STYLE_MSGBOX, "Finalize Business Sale", string, "Submit Business", "Cancel");
	    }
	    else
	    {
	        ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
	    }
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS6)
	{
	    if(response)
	    {
	        format(string, sizeof(string), "[EDITBUSINESSSHOP] [User: %s(%i)] [IP: %s] [BusinessID: %d] [Description: %s] [Type: %d] [Price: %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), BusinessSales[GetPVarInt(playerid, "EditingSale")][bBusinessID], BusinessSales[GetPVarInt(playerid, "EditingSale")][bText], BusinessSales[GetPVarInt(playerid, "EditingSale")][bType], BusinessSales[GetPVarInt(playerid, "EditingSale")][bPrice]);
			Log("logs/editshop.log", string), print(string);

	        ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
	        SendClientMessageEx(playerid, COLOR_CYAN, "You have successfully submitted a business sale.");
            BusinessSales[GetPVarInt(playerid, "EditingSale")][bAvailable] = 1;
            SaveBusinessSale(GetPVarInt(playerid, "EditingSale"));
            DeletePVar(playerid, "EditingSale");
	    }
	    else
	    {
	        ShowPlayerDialog(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
	    }
	}
	if(dialogid == DIALOG_SHOPBUSINESS)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                new szDialog[500], Count;
	        		for (new i; i < sizeof(BusinessSales); i++)
    				{
    		    		if(BusinessSales[i][bAvailable] == 1)
    		    		{
    						format(szDialog, sizeof(szDialog), "%s\n%s (Credits: %s)", szDialog, BusinessSales[i][bText], number_format(BusinessSales[i][bPrice]));
    						Selected[playerid][Count] = i;
    						Count++;
						}
					}
					if(Count != 0)
						ShowPlayerDialog(playerid, DIALOG_SHOPBUSINESS2, DIALOG_STYLE_LIST, "Businesses Shop", szDialog, "More Info", "Exit");
					else
					    SendClientMessageEx(playerid, COLOR_GREY, "No businesses are currently available.");
	            }
	            case 1:
	            {
	                if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] < 5)
						return SendClientMessageEx(playerid, COLOR_GREY, "You don't currently own a business.");

					if(Businesses[PlayerInfo[playerid][pBusiness]][bGrade] == 0)
					    return SendClientMessageEx(playerid, COLOR_GREY, "An error has occured please contact the Director of Customer Relations.");

                    ShowPlayerDialog(playerid, DIALOG_SHOPBUSINESS4, DIALOG_STYLE_LIST, "Select how many months you wish to renew for.", "1 Month\n2 Months\n3 Months\n4 Months\n5 Months\n6 Months\n7 Months\n8 Months\n9 Months\n10 Months\n11 Months\n1 Year", "Select", "Cancel");
	            }
	        }
	    }
	}
	if(dialogid == DIALOG_SHOPBUSINESS4)
	{
	    if(response)
	    {
	    	new Prices;
	    	SetPVarInt(playerid, "BusinessMonths", listitem+1);
	    	switch (Businesses[PlayerInfo[playerid][pBusiness]][bGrade])
	    	{
				case 1: Prices = ShopItems[11][sItemPrice];
				case 2: Prices = ShopItems[12][sItemPrice];
				case 3: Prices = ShopItems[13][sItemPrice];
	    	}
	    	SetPVarInt(playerid, "BusinessPrice", (listitem+1)*Prices);
	    	format(string, sizeof(string),"Business Renew\nGrade: %d\nExpires: %d Month\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", Businesses[PlayerInfo[playerid][pBusiness]][bGrade],listitem+1, number_format(PlayerInfo[playerid][pCredits]), number_format(GetPVarInt(playerid, "BusinessPrice")), number_format(PlayerInfo[playerid][pCredits]-GetPVarInt(playerid, "BusinessPrice")));
     		ShowPlayerDialog(playerid, DIALOG_SHOPBUSINESS5, DIALOG_STYLE_MSGBOX, "Purchase Business Renew", string, "Purchase", "Cancel");
		}
	}
	if(dialogid == DIALOG_SHOPBUSINESS5)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] < 5)
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't currently own a business.");

            new Prices;
            Prices = GetPVarInt(playerid, "BusinessPrice");

	    	if(PlayerInfo[playerid][pCredits] < Prices)
	    	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			if(!GetPVarType(playerid, "BusinessMonths"))
			    return SendClientMessageEx(playerid, COLOR_GREY, "An error has occurred please try again.");

			new szQuery[128];
            switch (Businesses[PlayerInfo[playerid][pBusiness]][bGrade])
	    	{
				case 1:
				{
				    AmountSold[11]++;
					AmountMade[11] += Prices;
					//ShopItems[11][sSold]++;
				 	//ShopItems[11][sMade] += Prices;
				 	format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold11` = '%d', `AmountMade11` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[11], AmountMade[11]);
				}
				case 2:
				{
				    AmountSold[12]++;
					AmountMade[12] += Prices;
			 		//ShopItems[12][sSold]++;
			 		//ShopItems[12][sMade] += Prices;
			 		format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold12` = '%d', `AmountMade12` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[12], AmountMade[12]);
				}
				case 3:
				{
				    AmountSold[13]++;
					AmountMade[13] += Prices;
			 		//ShopItems[13][sSold]++;
			 		//ShopItems[13][sMade] += Prices;
			 		format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold13` = '%d', `AmountMade13` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[13], AmountMade[13]);
				}
			}

			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			new Months = GetPVarInt(playerid, "BusinessMonths");
			GivePlayerCredits(playerid, -Prices, 1);
			Businesses[PlayerInfo[playerid][pBusiness]][bMonths] = (2592000*Months)+gettime()+259200;

			format(string, sizeof(string), "[Business Renewal(%i)] [Months: %d] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]",PlayerInfo[playerid][pBusiness], Months, GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(Prices));
			Log("logs/credits.log", string), print(string);

			format(string, sizeof(string), "You have successfully payed %s credits to renew your business for %d months.", number_format(Prices), Months);
			SendClientMessageEx(playerid, COLOR_CYAN, string);
	    }
	    DeletePVar(playerid, "BusinessMonths");
	}
	if(dialogid == DIALOG_SHOPBUSINESS2)
	{
	    if(response)
	    {
	        format(string, sizeof(string),"Business: %s\nType: %d\nExpires: 1 Month\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", BusinessSales[Selected[playerid][listitem]][bText], BusinessSales[Selected[playerid][listitem]][bType], number_format(PlayerInfo[playerid][pCredits]), number_format(BusinessSales[Selected[playerid][listitem]][bPrice]), number_format(PlayerInfo[playerid][pCredits]-BusinessSales[Selected[playerid][listitem]][bPrice]));
	        ShowPlayerDialog(playerid, DIALOG_SHOPBUSINESS3, DIALOG_STYLE_MSGBOX, "Purchase Business", string, "Purchase", "Cancel");
	        SetPVarInt(playerid, "BusinessSaleID", BusinessSales[Selected[playerid][listitem]][bBusinessID]), SetPVarInt(playerid, "BusinessSale", Selected[playerid][listitem]);
	    }
	}
	if(dialogid == DIALOG_SHOPBUSINESS3)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPrice])
	    	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			if (PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID)
			    return SendClientMessageEx(playerid, COLOR_GREY, "You already own a business.");

			if(BusinessSales[GetPVarInt(playerid, "BusinessSale")][bAvailable] != 1)
			    return SendClientMessageEx(playerid, COLOR_GREY, "This business is not for sale anymore.");

            if (!IsValidBusinessID(GetPVarInt(playerid, "BusinessSaleID")))
				return SendClientMessageEx(playerid, COLOR_GRAD2, "An error has occurred.");

            BusinessSales[GetPVarInt(playerid, "BusinessSale")][bAvailable] = 2;
	        GivePlayerCredits(playerid, -BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPrice], 1);
	        BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPurchased] = GetPlayerSQLId(playerid);

			Businesses[GetPVarInt(playerid, "BusinessSaleID")][bOwner] = GetPlayerSQLId(playerid);
			strcpy(Businesses[GetPVarInt(playerid, "BusinessSaleID")][bOwnerName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PlayerInfo[playerid][pBusiness] = GetPVarInt(playerid, "BusinessSaleID");
			PlayerInfo[playerid][pBusinessRank] = 5;
			Businesses[GetPVarInt(playerid, "BusinessSaleID")][bMonths] = (2592000*1)+gettime()+259200;

			format(string, sizeof(string), "You have purchased business %s (1 Month) for %s credits.", BusinessSales[GetPVarInt(playerid, "BusinessSale")][bText], number_format(BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_WHITE, "Type /help to review the business help section!");
			SaveBusiness(GetPVarInt(playerid, "BusinessSaleID"));
			OnPlayerStatsUpdate(playerid);
			RefreshBusinessPickup(GetPVarInt(playerid, "BusinessSaleID"));

			format(string,sizeof(string),"%s (IP: %s) has bought business ID %d for %d.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "BusinessSale"), BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPrice]);
			Log("logs/business.log", string);

			SaveBusinessSale(GetPVarInt(playerid, "BusinessSale"));

			format(string, sizeof(string), "[Business %i] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]",GetPVarInt(playerid, "BusinessSale"), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPrice]));
			Log("logs/credits.log", string), print(string);

			for(new i = 0; i < MAX_BUSINESSSALES; i++) {
     		   Selected[playerid][i] = 0;
			}
	    }
	    DeletePVar(playerid, "BusinessSaleID");
	    DeletePVar(playerid, "BusinessSale");
	}
	if(dialogid == DIALOG_HOUSESHOP)
	{
	    if(response)
	    {
	        new szDialog[180];
	        switch(listitem)
	        {
	            case 0: // Purchase House
	            {
	    			format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: House\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[14][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[14][sItemPrice]));
	    			ShowPlayerDialog( playerid, DIALOG_HOUSESHOP2, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
	            }
	            case 1: // House Interior Change
	            {
	                format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: House Interior Change\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[15][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[15][sItemPrice]));
	    			ShowPlayerDialog( playerid, DIALOG_HOUSESHOP3, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
	            }
	            case 2: // House Move
	            {
	                format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: House Move\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[16][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[16][sItemPrice]));
	    			ShowPlayerDialog( playerid, DIALOG_HOUSESHOP4, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
	            }
				case 3: // Small Garage
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: Garage - Small\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[24][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[24][sItemPrice]));
	    			ShowPlayerDialog( playerid, DIALOG_HOUSESHOP5, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
				case 4: // Medium Garage
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: Garage - Medium\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[25][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[25][sItemPrice]));
	    			ShowPlayerDialog( playerid, DIALOG_HOUSESHOP6, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
				case 5: // Large Garage
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: Garage - Large\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[26][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[26][sItemPrice]));
	    			ShowPlayerDialog( playerid, DIALOG_HOUSESHOP7, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
				case 6: // Large Garage
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: Garage - Extra Large\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[27][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[27][sItemPrice]));
	    			ShowPlayerDialog( playerid, DIALOG_HOUSESHOP8, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
	        }
	    }
	}
	if(dialogid == DIALOG_HOUSESHOP2)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[14][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[14][sItemPrice], 1);
            printf("Price14: %d", ShopItems[14][sItemPrice]);
            AmountSold[14]++;
			AmountMade[14] += ShopItems[14][sItemPrice];
			//ShopItems[14][sSold]++;
			//ShopItems[14][sMade] += ShopItems[14][sItemPrice];
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold14` = '%d', `AmountMade14` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[14], AmountMade[14]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased House (Credits)");
            SendReportToQue(playerid, "House (Credits)", 2, 2);
			format(string, sizeof(string), "You have purchased a house for %s credits.", number_format(ShopItems[14][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the house issued.");

			format(string, sizeof(string), "[House] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[14][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
	}
	if(dialogid == DIALOG_HOUSESHOP3)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[15][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[15][sItemPrice], 1);
            printf("Price15: %d", ShopItems[15][sItemPrice]);
            AmountSold[15]++;
			AmountMade[15] += ShopItems[15][sItemPrice];
			//ShopItems[15][sSold]++;
			//ShopItems[15][sMade] += ShopItems[15][sItemPrice];
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold15` = '%d', `AmountMade15` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[15], AmountMade[15]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased House Interior Change (Credits)");
			SendReportToQue(playerid, "House Interior Change (Credits)", 2, 2);
			format(string, sizeof(string), "You have purchased a house interior change for %s credits.", number_format(ShopItems[15][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the house interior change issued.");

			format(string, sizeof(string), "[House Interior Change] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[15][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
	}
	if(dialogid == DIALOG_HOUSESHOP4)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[16][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[16][sItemPrice], 1);
            printf("Price16: %d", ShopItems[16][sItemPrice]);
            AmountSold[16]++;
			AmountMade[16] += ShopItems[16][sItemPrice];
			//ShopItems[16][sSold]++;
			//ShopItems[16][sMade] += ShopItems[16][sItemPrice];
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold16` = '%d', `AmountMade16` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[16], AmountMade[16]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased House Move (Credits)");
            SendReportToQue(playerid, "House Move (Credits)", 2, 2);
			format(string, sizeof(string), "You have purchased a house move for %s credits.", number_format(ShopItems[16][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the house move issued.");

			format(string, sizeof(string), "[House Move] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[16][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
	}
	if(dialogid == DIALOG_HOUSESHOP5)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[24][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[24][sItemPrice], 1);
            printf("Price24: %d", ShopItems[24][sItemPrice]);
            AmountSold[24]++;
			AmountMade[24] += ShopItems[24][sItemPrice];

			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold24` = '%d', `AmountMade24` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[24], AmountMade[24]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			GarageVW++;
			g_mysql_SaveMOTD();
			format(szQuery, sizeof(szQuery), "Garage - Small (VW: %d)", GarageVW);
			AddFlag(playerid, INVALID_PLAYER_ID, szQuery);
			
            SendReportToQue(playerid, szQuery, 2, 2);
			format(string, sizeof(string), "You have purchased a small garage for %s credits.", number_format(ShopItems[24][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the small garage issued.");

			format(string, sizeof(string), "[Garage - Small] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[24][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
	}
	if(dialogid == DIALOG_HOUSESHOP6)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[25][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[25][sItemPrice], 1);
            printf("Price25: %d", ShopItems[25][sItemPrice]);
            AmountSold[25]++;
			AmountMade[25] += ShopItems[25][sItemPrice];

			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold25` = '%d', `AmountMade25` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[25], AmountMade[25]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			GarageVW++;
			g_mysql_SaveMOTD();
			format(szQuery, sizeof(szQuery), "Garage - Medium (VW: %d)", GarageVW);
			AddFlag(playerid, INVALID_PLAYER_ID, szQuery);
			
            SendReportToQue(playerid, szQuery, 2, 2);
			format(string, sizeof(string), "You have purchased a medium garage for %s credits.", number_format(ShopItems[25][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the medium garage issued.");

			format(string, sizeof(string), "[Garage - Medium] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[25][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
	}
	if(dialogid == DIALOG_HOUSESHOP7)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[26][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[26][sItemPrice], 1);
            printf("Price26: %d", ShopItems[26][sItemPrice]);
            AmountSold[26]++;
			AmountMade[26] += ShopItems[26][sItemPrice];

			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold26` = '%d', `AmountMade26` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[26], AmountMade[26]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			GarageVW++;
			g_mysql_SaveMOTD();
			format(szQuery, sizeof(szQuery), "Garage - Large (VW: %d)", GarageVW);
			AddFlag(playerid, INVALID_PLAYER_ID, szQuery);
			
            SendReportToQue(playerid, szQuery, 2, 2);
			format(string, sizeof(string), "You have purchased a large garage for %s credits.", number_format(ShopItems[26][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the large garage issued.");

			format(string, sizeof(string), "[Garage - Large] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[26][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
	}
	if(dialogid == DIALOG_HOUSESHOP8)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[27][sItemPrice])
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[27][sItemPrice], 1);
            printf("Price27: %d", ShopItems[27][sItemPrice]);
            AmountSold[27]++;
			AmountMade[27] += ShopItems[27][sItemPrice];

			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold27` = '%d', `AmountMade27` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[27], AmountMade[27]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			GarageVW++;
			g_mysql_SaveMOTD();
			format(szQuery, sizeof(szQuery), "Garage - Extra Large (VW: %d)", GarageVW);
			AddFlag(playerid, INVALID_PLAYER_ID, szQuery);
			
            SendReportToQue(playerid, szQuery, 2, 2);
			format(string, sizeof(string), "You have purchased a extra large garage for %s credits.", number_format(ShopItems[27][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the extra large garage issued.");

			format(string, sizeof(string), "[Garage - Extra Large] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[27][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
	}
	if(dialogid == DIALOG_HEALTHCARE)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
				case 0:
				{
				    new szDialog[160];
				    format(szDialog, sizeof(szDialog), "When spawning from the hospital you will spawn with full health, and will be served a full meal.\n\nCost per hospital visit: {FFD700}%s{A9C4E4}", number_format(ShopItems[18][sItemPrice]));
				    ShowPlayerDialog(playerid, DIALOG_HEALTHCARE2, DIALOG_STYLE_MSGBOX, "Advanced Health Care" , szDialog, "Activate", "Exit");
				}
				case 1:
				{
				    new szDialog[160];
				    SetPVarInt(playerid, "HealthCare", 1);
				    format(szDialog, sizeof(szDialog), "When spawning from the hospital you will spawn 80%% faster, with full health, and be served a full meal.\n\nCost per hospital visit: {FFD700}%s{A9C4E4}", number_format(ShopItems[19][sItemPrice]));
				    ShowPlayerDialog(playerid, DIALOG_HEALTHCARE2, DIALOG_STYLE_MSGBOX, "Super Advanced Health Care" , szDialog, "Activate", "Exit");
				}
	        }
		}
	}
	if(dialogid == DIALOG_HEALTHCARE2)
	{
	    if(response)
		{
		    if(!GetPVarType(playerid, "HealthCare")) // Advanced
		    {
		        PlayerInfo[playerid][pHealthCare] = 1;
		        SendClientMessageEx(playerid, COLOR_CYAN, "You have enabled Advanced Health Care, type /togglehealthcare to disable it.");
		    }
		    else // Super Advanced
		    {
		        PlayerInfo[playerid][pHealthCare] = 2;
		        SendClientMessageEx(playerid, COLOR_CYAN, "You have enabled Super Advanced Health Care, type /togglehealthcare to disable it.");
		    }
	    }
	    DeletePVar(playerid, "HealthCare");
	}
	if(dialogid == DIALOG_VIPSHOP && response)
	{
	    if(listitem == 0)
	    {
	        ShowPlayerDialog(playerid, DIALOG_VIPSHOP2, DIALOG_STYLE_LIST, "Select which VIP you want to purchase.", "Bronze\nSilver\nGold", "Select", "Cancel");
	    }
	    else
	    {
	        if(PlayerInfo[playerid][pGVip] == 0) {
		    	SendClientMessageEx(playerid, COLOR_GREY, "You have never purchased Gold VIP, so you can't renew it.");
			}
			else
			{
	        	ShowPlayerDialog(playerid, DIALOG_VIPSHOP3, DIALOG_STYLE_LIST, "Select how many months you wish to renew for.", "1 Month\n2 Months\n3 Months\n4 Months\n5 Months\n6 Months\n7 Months\n8 Months\n9 Months\n10 Months\n11 Months\n1 Year", "Select", "Cancel");
			}
		}
	}
    if(dialogid == DIALOG_VIPSHOP3 && response)
	{
	    new Months = listitem+1;
		SetPVarInt(playerid, "VIPType", 3), SetPVarInt(playerid, "VIPPrice", ShopItems[1][sItemPrice]*Months), SetPVarInt(playerid, "VIPMonths", Months), SetPVarInt(playerid, "GoldRenewal", 1);
		format(string, sizeof(string),"Type: Gold VIP\nExpires: %d Month(s)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", listitem+1, number_format(PlayerInfo[playerid][pCredits]), number_format(GetPVarInt(playerid, "VIPPrice")), number_format(PlayerInfo[playerid][pCredits]-GetPVarInt(playerid, "VIPPrice")));
		ShowPlayerDialog( playerid, DIALOG_PURCHASEVIP, DIALOG_STYLE_MSGBOX, "Gold VIP Renew", string, "Purchase", "Cancel" );
	}
	if(dialogid == DIALOG_VIPSHOP2 && response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
	            new Message[520];
	            Message = "Purple VIP name on the forums.\nVIP Forums Access\
				\nVIP Chat\nVIP Garage with access to all the most select cars on the map.\nVIP Lounge\nFirst Aid Station [HP Refills]\nGun Locker \nAbility to get Pot and Crack using the jobs without having to wait for refills at the Drug House.";
    			strcat(Message, "\nPreferred Pricing on Cars from the Dealership [20% off]\n24/7 VIP Pricing [20% Off]\nFree ATM Use \nFree Checking \nInvites to VIP Only Parties\nMax Hourly Interest Increase: $100k per paycheck");
				ShowPlayerDialog(playerid, DIALOG_VIPBRONZE, DIALOG_STYLE_MSGBOX, "Bronze VIP Features" , Message, "Continue", "Cancel" );
			}
			case 1:
			{
			    new Message[850];
	            Message = "Purple VIP name on the forums. \n\
				VIP Forums Access \n\
				VIP Chat \n\
				VIP Garage with access to all the most select cars on the map. \n\
				VIP Lounge\n\
				First Aid Station [HP Refills] \n\
				Gun Locker \n\
				Ability to get Pot and Crack using the jobs without having to wait for refills at the Drug House. \n\
				Preferred Pricing on Cars from the Dealership [20% off] \n\
				24/7 VIP Pricing [20% Off]";

    			strcat(Message, "\nFree ATM Use \n\
				Free Checking \n\
				Invites to VIP Only Parties \n\
				Caller ID \n\
				Ability to have 2 jobs. \n\
				Ability to own 3 additional cars. \n\
				Unrestricted Access to All Skins \n\
				Increased Interest Rate \n\
				Ability to purchase negative phone numbers. \n\
				Ability to purchase one time spawns at the Gold VIP+ room. \n\
				Auto Reply Text Messages \n\
				Priority Advertisements cost $125,000 \n\
				Weekly VIP Buddy Invites* [ability to invite a friend to use VIP Bronze Features for 3 hours]");

				ShowPlayerDialog(playerid, DIALOG_VIPSILVER, DIALOG_STYLE_MSGBOX, "Silver VIP Features" , Message, "Continue", "Cancel" );
			}
			case 2:
			{
			    new Message[1000];
	            Message = "Purple VIP name on the forums. \n\
				VIP Forums Access \n\
				Gold VIP Tag on TS. \n\
				VIP Chat \n\
				VIP Garage with access to all the most select cars on the map. \n\
				VIP Lounge\n\
				First Aid Station [HP Refills] \n\
				Gun Locker \n\
				Ability to get Pot and Crack using the jobs without having to wait for refills at the Drug House. \n\
				Preferred Pricing on Cars from the Dealership [20% off] \n\
				Full Health and Hunger after death \n\
				24/7 VIP Pricing [20% Off]";

    			strcat(Message, "\nFree ATM Use \n\
				Free Checking \n\
				Invites to VIP Only Parties \n\
				Caller ID \n\
				Ability to have 3 jobs. \n\
				Ability to own 3 additional cars. \n\
				Unrestricted Access to All Skins \n\
				Increased Interest Rate \n\
				Ability to purchase negative phone numbers. \n\
				Priority Advertisements cost $100,000 \n\
				10 percent discount on NameChanges \n\		
				Auto Reply Text Messages \n\
				Daily VIP Buddy Invites* [ability to invite a friend to use VIP Bronze Features for 3 hours]");
				
				strcat(Message, "\nx2 Paycheck on Birthday \n\
				One random Gift on Birthday \n\
				5 Percent discount on House/Gate/Door Moves \n\
				WAR option at Paintball");

				ShowPlayerDialog(playerid, DIALOG_VIPGOLD, DIALOG_STYLE_MSGBOX, "Gold VIP Features" , Message, "Continue", "Cancel" );
			}
	    }
	}
	if(dialogid == DIALOG_VIPBRONZE && response)
	{
	    ShowPlayerDialog(playerid, DIALOG_VIPBRONZE2, DIALOG_STYLE_LIST, "Select how many months you wish to renew for.", "1 Month\n2 Months\n3 Months\n4 Months\n5 Months\n6 Months\n7 Months\n8 Months\n9 Months\n10 Months\n11 Months\n1 Year", "Select", "Cancel");
	}
	if(dialogid == DIALOG_VIPBRONZE2 && response)
	{
		new Months = listitem+1;
		SetPVarInt(playerid, "VIPType", 1), SetPVarInt(playerid, "VIPPrice", ShopItems[3][sItemPrice]*Months), SetPVarInt(playerid, "VIPMonths", Months);
		format(string, sizeof(string),"Type: Bronze VIP\nExpires: %d Month(s)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", listitem+1, number_format(PlayerInfo[playerid][pCredits]), number_format(GetPVarInt(playerid, "VIPPrice")), number_format(PlayerInfo[playerid][pCredits]-GetPVarInt(playerid, "VIPPrice")));
		ShowPlayerDialog( playerid, DIALOG_PURCHASEVIP, DIALOG_STYLE_MSGBOX, "Bronze VIP", string, "Purchase", "Cancel" );
	}
	if(dialogid == DIALOG_VIPSILVER && response)
	{
	    ShowPlayerDialog(playerid, DIALOG_VIPSILVER2, DIALOG_STYLE_LIST, "Select how many months you wish to renew for.", "1 Month\n2 Months\n3 Months\n4 Months\n5 Months\n6 Months\n7 Months\n8 Months\n9 Months\n10 Months\n11 Months\n1 Year", "Select", "Cancel");
	}
	if(dialogid == DIALOG_VIPSILVER2 && response)
	{
	    new Months = listitem+1;
		SetPVarInt(playerid, "VIPType", 2), SetPVarInt(playerid, "VIPPrice", ShopItems[2][sItemPrice]*Months), SetPVarInt(playerid, "VIPMonths", Months);
		format(string, sizeof(string),"Type: Silver VIP\nExpires: %d Month(s)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", listitem+1, number_format(PlayerInfo[playerid][pCredits]), number_format(GetPVarInt(playerid, "VIPPrice")), number_format(PlayerInfo[playerid][pCredits]-GetPVarInt(playerid, "VIPPrice")));
		ShowPlayerDialog( playerid, DIALOG_PURCHASEVIP, DIALOG_STYLE_MSGBOX, "Silver VIP", string, "Purchase", "Cancel" );
	}
	if(dialogid == DIALOG_VIPGOLD && response)
	{
	    SetPVarInt(playerid, "VIPMonths", 1), SetPVarInt(playerid, "VIPType", 3), SetPVarInt(playerid, "VIPPrice", ShopItems[0][sItemPrice]);
	    format(string, sizeof(string),"Type: Gold VIP\nExpires: 1 Month\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(GetPVarInt(playerid, "VIPPrice")), number_format(PlayerInfo[playerid][pCredits]-GetPVarInt(playerid, "VIPPrice")));
	    ShowPlayerDialog( playerid, DIALOG_PURCHASEVIP, DIALOG_STYLE_MSGBOX, "Gold VIP", string, "Purchase", "Cancel" );
	}
	if(dialogid == DIALOG_PURCHASEVIP)
	{
	    if(response)
	    {
	    	if(PlayerInfo[playerid][pCredits] < GetPVarInt(playerid, "VIPPrice"))
	    	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			if(PlayerInfo[playerid][pDonateRank] != 0)
			    return SendClientMessageEx(playerid, COLOR_GREY, "You already have VIP, please wait for it to expire.");

			if(GetPVarType(playerid, "VIPType") != 1)
			    return SendClientMessageEx(playerid, COLOR_GREY, "An error has occured, please try again.");


			PlayerInfo[playerid][pDonateRank] = GetPVarInt(playerid, "VIPType");
			PlayerInfo[playerid][pTempVIP] = 0;
			PlayerInfo[playerid][pBuddyInvited] = 0;

			if(PlayerInfo[playerid][pVIPM] == 0)
			{
				PlayerInfo[playerid][pVIPM] = VIPM;
				VIPM++;
			}

			if(GetPVarType(playerid, "VIPMonths"))
			{
				PlayerInfo[playerid][pVIPExpire] = (2592000*GetPVarInt(playerid, "VIPMonths"))+gettime();
			}
	  		else
	  		{
	            PlayerInfo[playerid][pVIPExpire] = 2592000+gettime();
			}

            GivePlayerCredits(playerid, -GetPVarInt(playerid, "VIPPrice"), 1);

			if(GetPVarInt(playerid, "VIPType") == 3)
				PlayerInfo[playerid][pGVip] = 1;

			new VIPType[7];
			new szQuery[128];
			if(GetPVarType(playerid, "GoldRenewal"))
			{
			    AmountSold[1]++;
				AmountMade[1] += GetPVarInt(playerid, "VIPPrice");
			    VIPType = "Gold";
				//ShopItems[1][sMade] += GetPVarInt(playerid, "VIPPrice");
				format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold1` = '%d', `AmountMade1` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[1], AmountMade[1]);
				DeletePVar(playerid, "GoldRenewal");
			}
			else
			{
				switch(GetPVarInt(playerid, "VIPType")) {
				    case 1:
					{
						VIPType = "Bronze";
						AmountSold[3]++;
						AmountMade[3] += GetPVarInt(playerid, "VIPPrice");
						//ShopItems[3][sSold]++;
						//ShopItems[3][sMade] += GetPVarInt(playerid, "VIPPrice");
						format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold3` = '%d', `AmountMade3` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[3], AmountMade[3]);
					}
					case 2:
					{
					 	VIPType = "Silver";
					 	AmountSold[2]++;
						AmountMade[2] += GetPVarInt(playerid, "VIPPrice");
					  	//ShopItems[2][sSold]++;
				 		//ShopItems[2][sMade] += GetPVarInt(playerid, "VIPPrice");
				 		format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold2` = '%d', `AmountMade2` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[2], AmountMade[2]);
					}
					case 3:
					{
						VIPType = "Gold";
						AmountSold[0]++;
						AmountMade[0] += GetPVarInt(playerid, "VIPPrice");
						//ShopItems[0][sSold]++;
						//ShopItems[0][sMade] += GetPVarInt(playerid, "VIPPrice");
						format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold0` = '%d', `AmountMade0` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[0], AmountMade[0]);
					}
				}
			}

    		mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "You have purchased %s VIP (%d Month(s)) for %s credits.", VIPType,GetPVarInt(playerid, "VIPMonths"), number_format(GetPVarInt(playerid, "VIPPrice")));
	  		SendClientMessageEx(playerid, COLOR_CYAN, string);

			format(string, sizeof(string), "[VIP %i] [User: %s(%i)] [IP: %s] [Credits: %s] [VIP: %s(%d)] [Price: %s]", PlayerInfo[playerid][pVIPM], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), VIPType,GetPVarInt(playerid, "VIPMonths"), number_format(GetPVarInt(playerid, "VIPPrice")));
			Log("logs/credits.log", string), Log("logs/setvip.log", string), print(string);
		}
		DeletePVar(playerid, "VIPPrice");
		DeletePVar(playerid, "VIPMonths");
		DeletePVar(playerid, "VIPType");
	}
	if(dialogid == DIALOG_SHOPGIFTRESET)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < ShopItems[17][sItemPrice])
	    	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			PlayerInfo[playerid][pGiftTime] = 0;

			GivePlayerCredits(playerid, -ShopItems[17][sItemPrice], 1);
            printf("Price18: %d", ShopItems[17][sItemPrice]);
            format(string, sizeof(string), "You have purchased gift timer reset for %s credits.", number_format(ShopItems[17][sItemPrice]));
	  		SendClientMessageEx(playerid, COLOR_CYAN, string);

            AmountSold[17]++;
			AmountMade[17] += ShopItems[17][sItemPrice];
	  		//ShopItems[17][sSold]++;
			//ShopItems[17][sMade] += ShopItems[17][sItemPrice];
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold17` = '%d', `AmountMade17` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[17], AmountMade[17]);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

            format(string, sizeof(string), "[GIFTTIMERRESET] [User: %s(%i)] [IP: %s] [Credits: %s] [Gift Timer Reset] [Price: %s]",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]));
			Log("logs/credits.log", string), print(string);
	    }
	}
	if(dialogid == DIALOG_SHOPTOTRESET)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < 20)
	    	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			PlayerInfo[playerid][pTrickortreat] = 0;

			GivePlayerCredits(playerid, -20, 1);
            format(string, sizeof(string), "You have purchased a Holiday timer reset for %s credits.", number_format(20));
	  		SendClientMessageEx(playerid, COLOR_CYAN, string);

            
            format(string, sizeof(string), "[GIFTTIMERRESET] [User: %s(%i)] [IP: %s] [Credits: %s] [Special Holiday Timer Reset] [Price: %s]",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(20));
			Log("logs/zombiecure.log", string), print(string);
	    }
	}
	if(dialogid == DIALOG_HALLOWEENSHOP)
	{
		if(response)
		{
			if(listitem == 0)
			{
				format(string, sizeof(string),"Item: Limited Edition Pumpkin Toy\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(75), number_format(PlayerInfo[playerid][pCredits]-75));
				ShowPlayerDialog( playerid, DIALOG_HALLOWEENSHOP1, DIALOG_STYLE_MSGBOX, "Halloween Shop", string, "Purchase", "Exit" );
			}
			else
			{
				format(string, sizeof(string),"Item: Spiked Club Toy\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(60), number_format(PlayerInfo[playerid][pCredits]-60));
				ShowPlayerDialog( playerid, DIALOG_HALLOWEENSHOP2, DIALOG_STYLE_MSGBOX, "Halloween Shop", string, "Purchase", "Exit" );
			}
		}
	}
	if(dialogid == DIALOG_HALLOWEENSHOP1)
	{
	    if(response)
	    {
			if(PumpkinStock <= 0)
				return SendClientMessageEx(playerid, COLOR_GREY, "This limited item has sold out!");
	        if(PlayerInfo[playerid][pCredits] < 75)
	    	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -75, 1);
			PumpkinStock--;
            format(string, sizeof(string), "You have purchased the Pumpkin Toy for %s credits.", number_format(75));
	  		SendClientMessageEx(playerid, COLOR_CYAN, string);
			
			g_mysql_SaveAccount(playerid);
			g_mysql_SaveMOTD();
            
            format(string, sizeof(string), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [Pumpkin Toy] [Price: %s]",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(75));
			Log("logs/zombiecure.log", string), print(string);	
			
			new icount = GetPlayerToySlots(playerid);
			for(new v = 0; v < icount; v++)
			{
				if(PlayerToyInfo[playerid][v][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][v][ptModelID] = 19320;
					PlayerToyInfo[playerid][v][ptBone] = 6;
					PlayerToyInfo[playerid][v][ptPosX] = 0.0;
					PlayerToyInfo[playerid][v][ptPosY] = 0.0;
					PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][v][ptRotX] = 0.0;
					PlayerToyInfo[playerid][v][ptRotY] = 0.0;
					PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][v][ptTradable] = 1;
					
					g_mysql_NewToy(playerid, v);
					return 1;
				}
			}
			
			for(new i = 0; i < MAX_PLAYERTOYS; i++)
			{
				if(PlayerToyInfo[playerid][i][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][i][ptModelID] = 19320;
					PlayerToyInfo[playerid][i][ptBone] = 6;
					PlayerToyInfo[playerid][i][ptPosX] = 0.0;
					PlayerToyInfo[playerid][i][ptPosY] = 0.0;
					PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][i][ptRotX] = 0.0;
					PlayerToyInfo[playerid][i][ptRotY] = 0.0;
					PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][i][ptTradable] = 1;
					PlayerToyInfo[playerid][i][ptSpecial] = 1;
					
					g_mysql_NewToy(playerid, i); 
					
					SendClientMessageEx(playerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your toy.");
					SendClientMessageEx(playerid, COLOR_RED, "Note: Please take note that after selling the toy, the temporarily additional toy slot will be removed.");
					break;
				}	
			}

	    }
	}
	if(dialogid == DIALOG_HALLOWEENSHOP2)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pCredits] < 60)
	    	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -60, 1);
            format(string, sizeof(string), "You have purchased the Spiked Club Toy for %s credits.", number_format(120));
	  		SendClientMessageEx(playerid, COLOR_CYAN, string);
			
			g_mysql_SaveAccount(playerid);
			g_mysql_SaveMOTD();
            
            format(string, sizeof(string), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [Club Toy] [Price: %s]",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(60));
			Log("logs/zombiecure.log", string), print(string);
			
			new icount = GetPlayerToySlots(playerid);
			for(new v = 0; v < icount; v++)
			{
				if(PlayerToyInfo[playerid][v][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][v][ptModelID] = 2045;
					PlayerToyInfo[playerid][v][ptBone] = 5;
					PlayerToyInfo[playerid][v][ptPosX] = 0.0;
					PlayerToyInfo[playerid][v][ptPosY] = 0.0;
					PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][v][ptRotX] = 0.0;
					PlayerToyInfo[playerid][v][ptRotY] = 0.0;
					PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][v][ptTradable] = 1;
					
					g_mysql_NewToy(playerid, v);
					return 1;
				}
			}
			
			for(new i = 0; i < MAX_PLAYERTOYS; i++)
			{
				if(PlayerToyInfo[playerid][i][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][i][ptModelID] =  2045;
					PlayerToyInfo[playerid][i][ptBone] = 5;
					PlayerToyInfo[playerid][i][ptPosX] = 0.0;
					PlayerToyInfo[playerid][i][ptPosY] = 0.0;
					PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][i][ptRotX] = 0.0;
					PlayerToyInfo[playerid][i][ptRotY] = 0.0;
					PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][i][ptTradable] = 1;
					PlayerToyInfo[playerid][i][ptSpecial] = 1;
					
					g_mysql_NewToy(playerid, i); 
					
					SendClientMessageEx(playerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your toy.");
					SendClientMessageEx(playerid, COLOR_RED, "Note: Please take note that after selling the toy, the temporarily additional toy slot will be removed.");
					break;
				}	
			}

	    }
	}
	if(dialogid == DIALOG_SHOPNEON && response)
	{
	    switch(listitem)
	    {
	        case 0: SetPVarInt(playerid, "ToyID", 18647);
			case 1: SetPVarInt(playerid, "ToyID", 18648);
			case 2: SetPVarInt(playerid, "ToyID", 18649);
			case 3: SetPVarInt(playerid, "ToyID", 18650);
			case 4: SetPVarInt(playerid, "ToyID", 18651);
			case 5: SetPVarInt(playerid, "ToyID", 18652);
	    }
	    new stringg[512], icount = GetPlayerToySlots(playerid);
		for(new z;z<icount;z++)
		{
			new name[24];
			format(name, sizeof(name), "None");

			for(new i;i<sizeof(HoldingObjectsAll);i++)
			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][z][ptModelID])
				{
					format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}

			format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, z, name, HoldingBones[PlayerToyInfo[playerid][z][ptBone]]);
		}
		ShowPlayerDialog(playerid, DIALOG_SHOPBUYTOYS, DIALOG_STYLE_LIST, "Select a Slot", stringg, "Select", "Cancel");
	}
	if(dialogid == DIALOG_SHOPBUYTOYS && response)
	{
	    new name[24];
	    for(new i;i<sizeof(HoldingObjectsShop);i++)
	    {
			if(HoldingObjectsShop[i][holdingmodelid] == GetPVarInt(playerid, "ToyID"))
       		{
				format(name, sizeof(name), "%s", HoldingObjectsShop[i][holdingmodelname]);
			}
		}
		format(string, sizeof(string), "Item: %s\n\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", name, number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[4][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[4][sItemPrice]));
 		ShowPlayerDialog(playerid, DIALOG_SHOPBUYTOYS2, DIALOG_STYLE_MSGBOX, "Toy Shop", string, "Purchase", "Cancel");
 		SetPVarInt(playerid, "ToySlot", listitem);
	}
	if((dialogid == DIALOG_SHOPBUYTOYS2) && response)
	{
		if(PlayerInfo[playerid][pCredits] < ShopItems[4][sItemPrice])
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits for that item. Purchase some credits at shop.ng-gaming.net");
		}
		else
		{
		    if(!toyCountCheck(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough toy slots, you may purchase more via /toys");

	    	if(PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID] != 0) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You already have something in that slot. Delete it with /toys");

            new name[24];
	    	for(new i;i<sizeof(HoldingObjectsShop);i++)
	    	{
				if(HoldingObjectsShop[i][holdingmodelid] == GetPVarInt(playerid, "ToyID"))
       			{
					format(name, sizeof(name), "%s", HoldingObjectsShop[i][holdingmodelname]);
				}
			}

			GivePlayerCredits(playerid, -ShopItems[4][sItemPrice], 1);
			printf("Price4: %d", ShopItems[4][sItemPrice]);
			AmountSold[4]++;
			AmountMade[4] += ShopItems[4][sItemPrice];
			//ShopItems[4][sSold]++;
			//ShopItems[4][sMade] += ShopItems[4][sItemPrice];
			new szQuery[1024];
			format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold4` = '%d', `AmountMade4` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[4], AmountMade[4]);
    		mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "[TOY %i] [User: %s(%i)] [IP: %s] [Credits: %s] [Toy: %s] [Price: %s]", AmountSold[4], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), name, number_format(ShopItems[4][sItemPrice]));
			Log("logs/credits.log", string), print(string);

		    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID] = GetPVarInt(playerid, "ToyID");

		    new modelid = GetPVarInt(playerid, "ToyID");
		    if((modelid >= 19006 && modelid <= 19035) || (modelid >= 19138 && modelid <= 19140))
		    {
		        PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.9;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.35;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
		    }
		    else if(modelid >= 18891 && modelid <= 18910)
		    {
		    	PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.15;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid >= 18926 && modelid <= 18935)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18911 && modelid <= 18920)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.035;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid == 19078 || modelid == 19078)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 16;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if((modelid >= 18641 && modelid <= 18644) || (modelid >= 19080 && modelid <= 19084) || modelid == 18890)
			{
			    PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 6;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
		    else
		    {
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptTradable] = 1;
			
			g_mysql_NewToy(playerid, GetPVarInt(playerid, "ToySlot"));

			format(string, sizeof(string), "You have purchased %s for %s credits. (Slot: %d)", name, number_format(ShopItems[4][sItemPrice]), GetPVarInt(playerid, "ToySlot"));
		    SendClientMessageEx(playerid, COLOR_CYAN, string);
		    SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Use /toys to wear/edit this");
			DeletePVar(playerid, "ToyID"), DeletePVar(playerid, "ToySlot");
		}
	}
	if(dialogid == DIALOG_SELLCREDITS)
	{
	    if(response)
	    {
			if(GetPVarInt(GetPVarInt(playerid, "CreditsSeller"), "CreditsSeller") != playerid)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "The other player has disconnected please try again.");
				DeletePVar(playerid, "CreditsOffer");
				DeletePVar(playerid, "CreditsAmount");
				DeletePVar(playerid, "CreditsSeller");
				DeletePVar(playerid, "CreditsFirstAmount");
				return 1;
			}
			if(PlayerInfo[GetPVarInt(playerid, "CreditsSeller")][pCredits] < GetPVarInt(playerid, "CreditsAmount"))
			{
			    SendClientMessageEx(playerid, COLOR_GREY, "The seller didn't have enough credits.");
			    SendClientMessageEx(GetPVarInt(playerid, "CreditsSeller"), COLOR_GREY, "You don't have enough credits.");
				DeletePVar(playerid, "CreditsOffer");
				DeletePVar(playerid, "CreditsAmount");
				DeletePVar(playerid, "CreditsSeller");
				DeletePVar(playerid, "CreditsFirstAmount");
				return 1;
			}
			if(GetPlayerCash(playerid) < GetPVarInt(playerid, "CreditsOffer"))
			{
 				SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough money to accept the offer.");
 				SendClientMessageEx(GetPVarInt(playerid, "CreditsSeller"), COLOR_GREY, "That player does not have enough money to accept your offer.");
		 		DeletePVar(playerid, "CreditsOffer");
		 		DeletePVar(playerid, "CreditsAmount");
		 		DeletePVar(playerid, "CreditsSeller");
		 		DeletePVar(playerid, "CreditsFirstAmount");
		 		return 1;
			}
			new szMessage[156];

			GivePlayerCash(playerid, -GetPVarInt(playerid, "CreditsOffer"));
			GivePlayerCash(GetPVarInt(playerid, "CreditsSeller"), GetPVarInt(playerid, "CreditsOffer"));

			GivePlayerCredits(playerid, GetPVarInt(playerid, "CreditsAmount"), 0);
			GivePlayerCredits(GetPVarInt(playerid, "CreditsSeller"), -GetPVarInt(playerid, "CreditsFirstAmount"), 0);

			AmountSold[21]++;
			AmountMade[21] += GetPVarInt(playerid, "CreditsFirstAmount")-GetPVarInt(playerid, "CreditsAmount");
			//ShopItems[21][sSold]++;
			//ShopItems[21][sMade] += GetPVarInt(playerid, "CreditsFirstAmount")-GetPVarInt(playerid, "CreditsAmount");

			format(szMessage, sizeof(szMessage), "UPDATE `sales` SET `TotalSold21` = '%d', `AmountMade21` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[21], AmountMade[21]);
			mysql_function_query(MainPipeline, szMessage, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			print(szMessage);

			format(szMessage, sizeof(szMessage), "You have accepted the offer of %s credits for $%s from %s.", number_format(GetPVarInt(playerid, "CreditsAmount")), number_format(GetPVarInt(playerid, "CreditsOffer")), GetPlayerNameEx(GetPVarInt(playerid, "CreditsSeller")));
			SendClientMessageEx(playerid, COLOR_CYAN, szMessage);

			format(szMessage, sizeof(szMessage), "%s has accepted your offer of %s credits for $%s.", GetPlayerNameEx(playerid), number_format(GetPVarInt(playerid, "CreditsAmount")), number_format(GetPVarInt(playerid, "CreditsOffer")));
			SendClientMessageEx(GetPVarInt(playerid, "CreditsSeller"), COLOR_CYAN, szMessage);

			format(szMessage, sizeof(szMessage), "[S %s(%d)][IP %s][B %s(%d)][IP %s][C %s][P $%s]", GetPlayerNameEx(GetPVarInt(playerid, "CreditsSeller")),GetPlayerSQLId(GetPVarInt(playerid, "CreditsSeller")), GetPlayerIpEx(GetPVarInt(playerid, "CreditsSeller")),
			GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(GetPVarInt(playerid, "CreditsAmount")), number_format(GetPVarInt(playerid, "CreditsOffer")));
			Log("logs/sellcredits.log", szMessage), print(szMessage);
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "You have declined the credits offer.");
		    SendClientMessageEx(GetPVarInt(playerid, "CreditsSeller"), COLOR_GREY, "Your credits offer has been declined.");
		}
	    DeletePVar(playerid, "CreditsOffer");
	    DeletePVar(playerid, "CreditsAmount");
	    DeletePVar(playerid, "CreditsSeller");
	    DeletePVar(playerid, "CreditsFirstAmount");
	}
	if(dialogid == DIALOG_TACKLED)
	{
	    if(response) // complying
	    {
	        SetPVarInt(playerid, "TackledResisting", 1);
	    }
		else // resisting
		{
		    SetPVarInt(playerid, "TackledResisting", 2);
		    format(string, sizeof(string), "** %s struggles with %s, attempting to escape.", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPVarInt(playerid, "IsTackled")));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
	}
	if(dialogid == DIALOG_RIMMOD)
	{
	    if(response)
	    {
	        new szRims[24];
			switch(listitem)
			{
				case 0: SetPVarInt(playerid, "RimMod", 1025), szRims = "Offroad";
				case 1: SetPVarInt(playerid, "RimMod", 1073), szRims = "Shadow";
				case 2: SetPVarInt(playerid, "RimMod", 1074), szRims = "Mega";
				case 3: SetPVarInt(playerid, "RimMod", 1075), szRims = "Rimshine";
				case 4: SetPVarInt(playerid, "RimMod", 1076), szRims = "Wires";
				case 5: SetPVarInt(playerid, "RimMod", 1077), szRims = "Classic";
				case 6: SetPVarInt(playerid, "RimMod", 1078), szRims = "Twist";
				case 7: SetPVarInt(playerid, "RimMod", 1079), szRims = "Cutter";
				case 8: SetPVarInt(playerid, "RimMod", 1080), szRims = "Switch";
				case 9: SetPVarInt(playerid, "RimMod", 1081), szRims = "Grove";
				case 10: SetPVarInt(playerid, "RimMod", 1082), szRims = "Import";
				case 11: SetPVarInt(playerid, "RimMod", 1083), szRims = "Dollar";
				case 12: SetPVarInt(playerid, "RimMod", 1084), szRims = "Trance";
				case 13: SetPVarInt(playerid, "RimMod", 1085), szRims = "Atomic";
				case 14: SetPVarInt(playerid, "RimMod", 1096), szRims = "Ahab";
				case 15: SetPVarInt(playerid, "RimMod", 1097), szRims = "Virtual";
				case 16: SetPVarInt(playerid, "RimMod", 1098), szRims = "Access";
  			}
  			new szMessage[128];
  			format(szMessage, 128, "You are about to place %s rims on this vehicle.", szRims);
			ShowPlayerDialog(playerid, DIALOG_RIMMOD2, DIALOG_STYLE_MSGBOX, "Confirm Rims", szMessage, "Confirm", "Deny");
	    }
	}
	if(dialogid == DIALOG_RIMMOD2)
	{
	    if(response)
	    {
	        if(PlayerInfo[playerid][pRimMod] == 0)
	            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any rim modification kits.");

			if(InvalidModCheck(GetVehicleModel(GetPlayerVehicleID(playerid)), 1025))
			{
                for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
				{
					if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
					{
						new szLog[128];
						format(szLog, sizeof(szLog), "%s has moded his vehicle with rims %d", GetPlayerNameEx(playerid), GetPVarInt(playerid, "RimMod"));
						Log("logs/rimkit.log", szLog);
						SendClientMessageEx(playerid, COLOR_GREEN, "You have successfully installed rims.");
						PlayerInfo[playerid][pRimMod]--;

						AddVehicleComponent(GetPlayerVehicleID(playerid), GetPVarInt(playerid, "RimMod"));
						DeletePVar(playerid, "RimMod");
	        			UpdatePlayerVehicleMods(playerid, d);
						return 1;
					}
				}
				SendClientMessageEx(playerid, COLOR_GREY, "You need to be in your vehicle.");
			}
			else
			{
			    SendClientMessageEx(playerid, COLOR_GREY, "That vehicle can't be modded with rims.");
			}
	    }
	}
	if(dialogid == DIALOG_PVIPVOUCHER)
	{
		if(response)
		{		
			PlayerInfo[playerid][pPVIPVoucher]--;
			PlayerInfo[playerid][pTotalCredits] = ShopItems[21][sItemPrice];
			
		    PlayerInfo[playerid][pDonateRank] = 4;
			PlayerInfo[playerid][pVIPExpire] = gettime()+2592000*1;
			PlayerInfo[playerid][pTempVIP] = 0;
			PlayerInfo[playerid][pBuddyInvited] = 0;
			PlayerInfo[playerid][pVIPSellable] = 1;
			
			LoadPlayerDisabledVehicles(playerid);

			if(PlayerInfo[playerid][pVIPM] == 0)
			{
				PlayerInfo[playerid][pVIPM] = VIPM;
				VIPM++;
			}
			format(string, sizeof(string), "%s (IP: %s) has used a platinum vip voucher.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
			Log("logs/credits.log", string);
			format(string, sizeof(string), "AdmCmd: %s's VIP level to Platinum (4) by the server (1 Month)(voucher).", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, string, 2), Log("logs/setvip.log", string), Log("logs/vouchers.log", string);

			format(string, sizeof(string), "You have been issued your Platinum VIP and have %d PVIP Voucher(s) left.", PlayerInfo[playerid][pPVIPVoucher]);
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "** Your Platinum VIP Voucher will expire in 1 Month.");
			PlayerInfo[playerid][pArmsSkill] = 401;

			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `TotalCredits`=%d WHERE `id` = %d", PlayerInfo[playerid][pTotalCredits], GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		}
	}
	if(dialogid == GIVETOY)
	{
		if(response)
		{
			new giveplayerid = GetPVarInt(playerid, "giveplayeridtoy"),
				toyid = GetPVarInt(playerid, "toyid"),
				stringg[128];
			if(!toyCountCheck(giveplayerid)) return SendClientMessageEx(playerid, COLOR_YELLOW, "* This player cannot hold anymore toys!");		
			if(PlayerToyInfo[giveplayerid][listitem][ptModelID] != 0) return SendClientMessageEx(playerid, COLOR_YELLOW, "* This player already has something in that specified slot!");
			
			PlayerToyInfo[giveplayerid][listitem][ptModelID] = toyid;
			PlayerToyInfo[giveplayerid][listitem][ptBone] = 1;
			PlayerToyInfo[giveplayerid][listitem][ptTradable] = 1;
			format(stringg, sizeof(stringg), "You have given %s object %d", GetPlayerNameEx(giveplayerid), toyid);
			SendClientMessageEx(playerid, COLOR_YELLOW, stringg);
			SendClientMessageEx(giveplayerid, COLOR_WHITE, "You have received a new toy from an administrator!");
			format(stringg, sizeof(stringg), "%s has given %s object %d", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), toyid);
			Log("logs/toys.log", stringg);
			DeletePVar(playerid, "giveplayeridtoy");
			DeletePVar(playerid, "toyid");
			new v = listitem; // lazy
			g_mysql_NewToy(giveplayerid, v);
		}
	}	
	if(dialogid == PBFORCE)
	{
	    new giveplayerid = GetPVarInt(playerid, "tempPBP");
	    DeletePVar(playerid, "tempPSP");
	    if(response)
	    {
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
		        if(IsPlayerConnected(giveplayerid))
		        {
                    if(GetPVarInt(giveplayerid, "IsInArena") >= 0)
			        {
			            LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			            format(string, sizeof(string), "You have forced %s out of paintball. You may now teleport this player.", GetPlayerNameEx(giveplayerid));
			            SendClientMessageEx(playerid, COLOR_WHITE, string);
			            format(string, sizeof(string), "You have been forced out of paintball by %s.", GetPlayerNameEx(playerid));
			            SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
			        }
			        else
			        {
			            SendClientMessageEx(playerid, COLOR_WHITE, "This user is not in an active paintball match.");
			        }
				}
				else
				{
				    SendClientMessageEx(playerid, COLOR_GRAD2, "This user has logged off.");
				}
			}
	    }
	    else
	    {
	        if(PlayerInfo[playerid][pAdmin] >= 2)
	        {
		        if(IsPlayerConnected(giveplayerid))
		        {
			        format(string, sizeof(string), "%s will remain in the paintball match.", GetPlayerNameEx(giveplayerid));
			        SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
				else
				{
				    SendClientMessageEx(playerid, COLOR_GRAD2, "This user has logged off.");
				}
			}
	    }
	}
	if(dialogid == DIALOG_HOUSEINVITE)
	{
		if(response)
		{
			if(IsPlayerConnected(hInviteOfferTo[playerid]))
			{
				new j = 0, zone[MAX_ZONE_NAME];
				for(new i; i < MAX_HOUSES; i++)
				{
					if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID])
					{
						if(listitem == j)
						{
							Get3DZone(HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ], zone, MAX_ZONE_NAME);
							SetPVarInt(playerid, "LastHouseInvite", gettime());
							new istring[128];
							hInviteHouse[hInviteOfferTo[playerid]] = i;
							hInviteOffer[hInviteOfferTo[playerid]] = playerid;
							format(istring, sizeof(istring), "   %s has invited you to their house in %s (type /accept invite).", GetPlayerNameEx(playerid), zone);
							SendClientMessageEx(hInviteOfferTo[playerid], COLOR_LIGHTBLUE, istring);
							format(istring, sizeof(istring), "   You have invited %s to your house in %s.", GetPlayerNameEx(hInviteOfferTo[playerid]), zone);
							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, istring);
							return 1;
						}
						j++;
					}
				}
			}
			else
			{
				hInviteOfferTo[playerid] = INVALID_PLAYER_ID;
				SendClientMessageEx(playerid, COLOR_GRAD2, "The player you attempted to invite to you house disconnected or timed out.");
			}
		}
	}
	if(dialogid == DISPLAY_STATS)
	{
		new targetid = GetPVarInt(playerid, "ShowStats");
		if(IsPlayerConnected(targetid))
		{
			if(response)
			{
				new resultline[1024], header[64], pvtstring[128], adminstring[128], advisorstring[128];
				
				if (PlayerInfo[playerid][pAdmin] >= 2)
				{
					format(pvtstring, sizeof(pvtstring), "House: %d\nHouse 2: %d\nHouse 3: %d\nRenting: %d\nInt: %d\nVW: %d\nReal VW: %d\nJail: %d sec\nWJail: %d sec\nVIPM: %i\nGVIP: %i\nReward Hours: %.2f\n", PlayerInfo[targetid][pPhousekey], PlayerInfo[targetid][pPhousekey2], PlayerInfo[targetid][pPhousekey3], PlayerInfo[targetid][pRenting],
					GetPlayerInterior(targetid), PlayerInfo[targetid][pVW], GetPlayerVirtualWorld(targetid), PlayerInfo[targetid][pJailTime], PlayerInfo[targetid][pBeingSentenced], PlayerInfo[targetid][pVIPM], PlayerInfo[targetid][pGVip], PlayerInfo[targetid][pRewardHours]);
				}
				if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[targetid][pAdmin] >= 2) format(adminstring, sizeof(adminstring), "Accepted Reports: %s\nTrashed Reports: %s\n", number_format(PlayerInfo[targetid][pAcceptReport]), number_format(PlayerInfo[targetid][pTrashReport]));
				if((PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pPR] >= 1) && PlayerInfo[targetid][pHelper] >= 2) format(advisorstring, sizeof(advisorstring), "Hours on Duty: %s\nAccepted Help Requests: %s\n", number_format(PlayerInfo[targetid][pDutyHours]), number_format(PlayerInfo[targetid][pAcceptedHelp]));

				format(header, sizeof(header), "Showing Statistics of %s", GetPlayerNameEx(targetid));
				format(resultline, sizeof(resultline),"{FFFFFF}Wanted Level: %d\n\
				Crimes: %s\n\
				Arrests: %s\n\
				Referrals: %s\n\
				Warnings: %s\n\
				Weapon Restriction: %s hour(s)\n\
				Gang Warnings: %s\n\
				Newbie Chat Mutes: %s\n\
				Advertisement Mutes: %s\n\
				Report Mutes: %s\n\
				%s\
				%s\
				%s",
				PlayerInfo[targetid][pWantedLevel],
				number_format(PlayerInfo[targetid][pCrimes]),
				number_format(PlayerInfo[targetid][pArrested]),
				number_format(PlayerInfo[targetid][pRefers]),
				number_format(PlayerInfo[targetid][pWarns]),
				number_format(PlayerInfo[targetid][pWRestricted]),
				number_format(PlayerInfo[targetid][pGangWarn]),
				number_format(PlayerInfo[targetid][pNMuteTotal]),
				number_format(PlayerInfo[targetid][pADMuteTotal]),
				number_format(PlayerInfo[targetid][pRMutedTotal]),
				pvtstring,
				advisorstring,
				adminstring);
				ShowPlayerDialog(playerid, DISPLAY_STATS2, DIALOG_STYLE_MSGBOX, header, resultline, "First Page", "Close");
			}
			else DeletePVar(playerid, "ShowStats");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "The player you were checking has logged out.");
			DeletePVar(playerid, "ShowStats");
			return 1;
		}
	}
	if(dialogid == DISPLAY_STATS2)
	{
		new targetid = GetPVarInt(playerid, "ShowStats");
		if(IsPlayerConnected(targetid))
		{
			if(response)
			{
				ShowStats(playerid, targetid);
			}
			else DeletePVar(playerid, "ShowStats");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "The player you were checking has logged out.");
			DeletePVar(playerid, "ShowStats");
			return 1;
		}
	}
	if(dialogid == DISPLAY_INV)
	{
		new targetid = GetPVarInt(playerid, "ShowInventory");
		if(IsPlayerConnected(targetid))
		{
			if(response)
			{
				new resultline[1024], header[64], pvtstring[128];
				if(PlayerInfo[playerid][pAdmin] >= 2)
				{
					format(pvtstring, sizeof(pvtstring), "Gift Box Tokens: %s\n", number_format(PlayerInfo[targetid][pGoldBoxTokens]));
				}

				format(header, sizeof(header), "Showing Inventory of %s", GetPlayerNameEx(targetid));
				format(resultline, sizeof(resultline),"Lock: %d\n\
				First Aid Kit: %d\n\
				RC Cam: %d\n\
				Receiver: %d\n\
				GPS: %d\n\
				Bug Sweep: %d\n\
				Firework: %d\n\
				Boombox: %d\n\
				Mailbox: %d\n\
				Metal Detector: %d\n\
				Junk Metal: %d\n\
				New Coin: %d\n\
				Old Coin: %d\n\
				Broken Watch: %d\n\
				Old Key: %d\n\
				Gold Watch: %d\n\
				Gold Nuggets: %d\n\
				Silver Nuggets: %d\n\
				Treasure Chests: %d\n\
				Rim Kits: %d\n\
				Restricted Vehicle Voucher: %d\n\
				Platinum VIP Voucher: %d\n\
				Checks: %s\n\
				Additional Vehicle Slots: %s\n\
				Additional Toy Slots: %s\n\
				%s",
				PlayerInfo[targetid][pLock],
				PlayerInfo[targetid][pFirstaid],
				PlayerInfo[targetid][pRccam],
				PlayerInfo[targetid][pReceiver],
				PlayerInfo[targetid][pGPS],
				PlayerInfo[targetid][pSweep],
				PlayerInfo[targetid][pFirework],
				PlayerInfo[targetid][pBoombox],
				PlayerInfo[targetid][pMailbox],
				PlayerInfo[targetid][pMetalDetector],
				GetPVarInt(targetid, "junkmetal"),
				GetPVarInt(targetid, "newcoin"),
				GetPVarInt(targetid, "oldcoin"),
				GetPVarInt(targetid, "brokenwatch"),
				GetPVarInt(targetid, "oldkey"),
				GetPVarInt(targetid, "goldwatch"),
				GetPVarInt(targetid, "goldnugget"),
				GetPVarInt(targetid, "silvernugget"),
				GetPVarInt(targetid, "treasure"),
				PlayerInfo[targetid][pRimMod],
				PlayerInfo[targetid][pCarVoucher],
				PlayerInfo[targetid][pPVIPVoucher],
				number_format(PlayerInfo[targetid][pChecks]),
				number_format(PlayerInfo[targetid][pVehicleSlot]),
				number_format(PlayerInfo[targetid][pToySlot]),
				pvtstring);
				#if defined zombiemode
				format(resultline, sizeof(resultline), "%s\n\
				Cure Vials: %d", resultline, PlayerInfo[targetid][pVials]);
				ShowPlayerDialog(playerid, DISPLAY_INV2, DIALOG_STYLE_MSGBOX, header, resultline, "First Page", "Close");
			}
			else DeletePVar(playerid, "ShowInventory");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "The player you were checking has logged out.");
			DeletePVar(playerid, "ShowInventory");
			return 1;
		}
	}
	if(dialogid == DISPLAY_INV2)
	{
		new targetid = GetPVarInt(playerid, "ShowInventory");
		if(IsPlayerConnected(targetid))
		{
			if(response)
			{
				ShowInventory(playerid, targetid);
			}
			else DeletePVar(playerid, "ShowInventory");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "The player you were checking has logged out.");
			DeletePVar(playerid, "ShowInventory");
			return 1;
		}
	}
	if(dialogid == DIALOG_RFL_SEL)
	{
		if(response)
		{
			if(listitem == 0) {
				mysql_function_query(MainPipeline, "SELECT * FROM `rflteams` WHERE `used` > 0 ORDER BY `laps` DESC LIMIT 15;", true, "OnRFLPScore", "ii", playerid, 1);
			}
			else if(listitem == 1) {
				mysql_function_query(MainPipeline, "SELECT `Username`, `RacePlayerLaps` FROM `accounts` WHERE `RacePlayerLaps` > 0 ORDER BY `RacePlayerLaps` DESC LIMIT 25;", true, "OnRFLPScore", "ii", playerid, 2);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_RFL_PLAYERS)
	{
		if(response)
		{
			return 1;
		}
		else
		{
			return 1;
		}
	}
	if(dialogid == DIALOG_RFL_TEAMS)
	{
		new temp = GetPVarInt(playerid, "rflTemp");
		if(response)
		{
			if(temp > 0) {
				format(string, sizeof(string), "SELECT * FROM `rflteams` WHERE `used` > 0 ORDER BY `laps` DESC LIMIT %d , 15;", temp);
				mysql_function_query(MainPipeline, string, true, "OnRFLPScore", "ii", playerid, 1);
			}
		}
		else
		{
			DeletePVar(playerid, "rflTemp");
			return 1;
		}	

	}
	if(dialogid == DIALOG_VOUCHER)
	{
		if(response)
		{
			new playeridd = GetPVarInt(playerid, "WhoIsThis");
			if(listitem == 0) // Car Voucher
			{
				if(PlayerInfo[playerid][pAdmin] >= 4)
				{
					SetPVarInt(playerid, "voucherdialog", 1);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
				}
				else if(PlayerInfo[playeridd][pVehVoucher] > 0 && (playerid == playeridd))
				{
					SetPVarInt(playerid, "voucherdialog", 1);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your car voucher?", "Yes", "No");
				}
				else if(PlayerInfo[playeridd][pVehVoucher] < 1)
				{
					if(PlayerInfo[playerid][pAdmin] >= 4)
					{
						SetPVarInt(playerid, "voucherdialog", 1);
						return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
					}
					else 
					{
						new szDialog[128];
						format(szDialog, sizeof(szDialog), "%s does not have any car vouchers.", GetPlayerNameEx(GetPVarInt(playerid, "WhoIsThis")));
						ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
						DeletePVar(playerid, "WhoIsThis");
					}	
				}	
			}
			if(listitem == 1) // SVIP Voucher
			{
				if(PlayerInfo[playerid][pAdmin] >= 4)
				{
					SetPVarInt(playerid, "voucherdialog", 2);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
				}
				else if(PlayerInfo[playeridd][pSVIPVoucher] > 0 && (playerid == playeridd))
				{
					SetPVarInt(playerid, "voucherdialog", 2);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your Silver VIP voucher?", "Yes", "No");
				}
				else if(PlayerInfo[playeridd][pSVIPVoucher] < 1)
				{
					if(PlayerInfo[playerid][pAdmin] >= 4)
					{
						SetPVarInt(playerid, "voucherdialog", 2);
						return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
					}
					else 
					{
						new szDialog[128];
						format(szDialog, sizeof(szDialog), "%s does not have any Silver VIP vouchers.", GetPlayerNameEx(GetPVarInt(playerid, "WhoIsThis")));
						ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
						DeletePVar(playerid, "WhoIsThis");
					}	
				}	
			}
			if(listitem == 2) // GVIP Voucher
			{
				if(PlayerInfo[playerid][pAdmin] >= 4)
				{
					SetPVarInt(playerid, "voucherdialog", 3);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
				}
				else if(PlayerInfo[playeridd][pGVIPVoucher] > 0 && (playerid == playeridd))
				{
					SetPVarInt(playerid, "voucherdialog", 3);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your Gold VIP voucher?", "Yes", "No");
				}
				else if(PlayerInfo[playeridd][pGVIPVoucher] < 1)
				{
					if(PlayerInfo[playerid][pAdmin] >= 4)
					{
						SetPVarInt(playerid, "voucherdialog", 3);
						return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
					}
					else 
					{
						new szDialog[128];
						format(szDialog, sizeof(szDialog), "%s does not have any Gold VIP vouchers.", GetPlayerNameEx(playeridd));
						ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
						DeletePVar(playerid, "WhoIsThis");
					}	
				}	
			}
			if(listitem == 3) // PVIP Voucher
			{
				if(playerid != playeridd) return 1;
				if(PlayerInfo[playeridd][pPVIPVoucher] < 1) 
				{
					new szDialog[128];
					format(szDialog, sizeof(szDialog), "%s does not have any Platinum VIP vouchers.", GetPlayerNameEx(playeridd));
					DeletePVar(playerid, "WhoIsThis");
					return ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
				}
				
				if(PlayerInfo[playerid][pDonateRank] >= 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have Platinum VIP+, you may sell this voucher with /sellvoucher."), DeletePVar(playerid, "WhoIsThis");
				
				ShowPlayerDialog(playerid, DIALOG_PVIPVOUCHER, DIALOG_STYLE_MSGBOX, "Platinum VIP Voucher", "You will be made Platinum VIP after use of this voucher.", "Confirm", "Cancel");	
			}
			if(listitem == 4) // Restricted Car Voucher
			{
				if(playerid != playeridd) return 1;
				
				if(ShopClosed == 1) return SendClientMessageEx(playerid, COLOR_GREY, "The shop is currently closed.");
				
				if(PlayerInfo[playeridd][pCarVoucher] < 1) 
				{
					new szDialog[128];
					format(szDialog, sizeof(szDialog), "%s does not have any Restriced Car vouchers.", GetPlayerNameEx(playeridd));
					DeletePVar(playerid, "WhoIsThis");
					return ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
				}
				
				ShowModelSelectionMenu(playerid, CarList3, "Car Shop");
			}
			if(listitem == 5) // Gift Reset Voucher
			{
				if(PlayerInfo[playerid][pAdmin] >= 1338 || PlayerInfo[playerid][pHR] >= 1)
				{
					SetPVarInt(playerid, "voucherdialog", 4);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
				}
				else if(PlayerInfo[playeridd][pGiftVoucher] > 0 && (playerid == playeridd))
				{
					SetPVarInt(playerid, "voucherdialog", 4);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your Gift Reset Voucher?", "Yes", "No");
				}
				else if(PlayerInfo[playeridd][pGiftVoucher] < 1)
				{
					if(PlayerInfo[playerid][pAdmin] >= 1338 || PlayerInfo[playerid][pHR] >= 1)
					{
						SetPVarInt(playerid, "voucherdialog", 4);
						return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
					}
					else 
					{
						new szDialog[128];
						format(szDialog, sizeof(szDialog), "%s does not have any Gift Reset vouchers.", GetPlayerNameEx(playeridd));
						ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
						DeletePVar(playerid, "WhoIsThis");
					}	
				}	
			}
			if(listitem == 6) // Priority Advertisement Voucher
			{
				if(PlayerInfo[playerid][pAdmin] >= 4)
				{
					SetPVarInt(playerid, "voucherdialog", 5);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
				}
				else if(PlayerInfo[playeridd][pAdvertVoucher] > 0 && (playerid == playeridd))
				{
					return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use your voucher through here, you will be prompt a dialog while in the advertisement menu to use this voucher.");
				}
				else if(PlayerInfo[playeridd][pAdvertVoucher] < 1)
				{
					if(PlayerInfo[playerid][pAdmin] >= 4)
					{
						SetPVarInt(playerid, "voucherdialog", 5);
						return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
					}
					else 
					{
						new szDialog[128];
						format(szDialog, sizeof(szDialog), "%s does not have any Priority Advertisement vouchers.", GetPlayerNameEx(playeridd));
						ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
						DeletePVar(playerid, "WhoIsThis");
					}	
				}	
			}
			if(listitem == 7) // 7 Days Silver VIP
			{
				if(PlayerInfo[playerid][pAdmin] >= 4)
				{
					SetPVarInt(playerid, "voucherdialog", 6);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
				}
				else if(PlayerInfo[playeridd][pSVIPExVoucher] > 0 && (playerid == playeridd))
				{
					SetPVarInt(playerid, "voucherdialog", 5);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days Silver VIP voucher?", "Yes", "No");
				}
				else if(PlayerInfo[playeridd][pSVIPExVoucher] < 1)
				{
					if(PlayerInfo[playerid][pAdmin] >= 4)
					{
						SetPVarInt(playerid, "voucherdialog", 6);
						return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
					}
					else 
					{
						new szDialog[128];
						format(szDialog, sizeof(szDialog), "%s does not have any 7 Days Silver VIP vouchers.", GetPlayerNameEx(playeridd));
						ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
						DeletePVar(playerid, "WhoIsThis");
					}	
				}	
			}
			if(listitem == 8) // 7 Days Gold VIP
			{
				if(PlayerInfo[playerid][pAdmin] >= 4)
				{
					SetPVarInt(playerid, "voucherdialog", 7);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
				}
				else if(PlayerInfo[playeridd][pGVIPExVoucher] > 0 && (playerid == playeridd))
				{
					SetPVarInt(playerid, "voucherdialog", 6);
					return ShowPlayerDialog(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days Gold VIP voucher?", "Yes", "No");
				}
				else if(PlayerInfo[playeridd][pGVIPExVoucher] < 1)
				{
					if(PlayerInfo[playerid][pAdmin] >= 4)
					{
						SetPVarInt(playerid, "voucherdialog", 7);
						return ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
					}
					else 
					{
						new szDialog[128];
						format(szDialog, sizeof(szDialog), "%s does not have any 7 Days Gold VIP vouchers.", GetPlayerNameEx(playeridd));
						ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
						DeletePVar(playerid, "WhoIsThis");
					}	
				}	
			}
		} 
	}		
	if(dialogid == DIALOG_VOUCHERADMIN)
	{
		if(response)
		{
			if(!isnull(inputtext))
			{
				if(IsNumeric(inputtext))
				{
					if(!IsPlayerConnected(GetPVarInt(playerid, "WhoIsThis"))) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player has disconnected from the server.");
					if(strval(inputtext) < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't give less than 1 voucher.");
					if(GetPVarInt(playerid,	"voucherdialog") == 1) // Car Voucher
					{
						new targetid = GetPVarInt(playerid, "WhoIsThis"), 
							amount = strval(inputtext),
							szString[128];
							
						PlayerInfo[targetid][pVehVoucher] += amount;
						format(szString, sizeof(szString), "You have given %s %d car voucher(s).", GetPlayerNameEx(targetid), amount);
						SendClientMessageEx(playerid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "You have been given %d car voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
						SendClientMessageEx(targetid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "%s has given %s %d car voucher(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), amount);
						Log("logs/vouchers.log", szString);
					}
					if(GetPVarInt(playerid,	"voucherdialog") == 2) // SVIP Voucher
					{
						new targetid = GetPVarInt(playerid, "WhoIsThis"), 
							amount = strval(inputtext),
							szString[128];
							
						PlayerInfo[targetid][pSVIPVoucher] += amount;
						format(szString, sizeof(szString), "You have given %s %d Silver VIP voucher(s).", GetPlayerNameEx(targetid), amount);
						SendClientMessageEx(playerid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "You have been given %d Silver VIP voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
						SendClientMessageEx(targetid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "%s has given %s %d Silver VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), amount);
						Log("logs/vouchers.log", szString);
					}
					if(GetPVarInt(playerid,	"voucherdialog") == 3) // GVIP Voucher
					{
						new targetid = GetPVarInt(playerid, "WhoIsThis"), 
							amount = strval(inputtext),
							szString[128];
							
						PlayerInfo[targetid][pGVIPVoucher] += amount;
						format(szString, sizeof(szString), "You have given %s %d Gold VIP voucher(s).", GetPlayerNameEx(targetid), amount);
						SendClientMessageEx(playerid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "You have been given %d Gold VIP voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
						SendClientMessageEx(targetid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "%s has given %s %d Gold VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), amount);
						Log("logs/vouchers.log", szString);
					}
					if(GetPVarInt(playerid, "voucherdialog") == 4) // Gift Reset Voucher
					{
						new targetid = GetPVarInt(playerid, "WhoIsThis"),
							amount = strval(inputtext),
							szString[128];
						PlayerInfo[targetid][pGiftVoucher] += amount;
						format(szString, sizeof(szString), "You have given %s %d Gift Reset voucher(s).", GetPlayerNameEx(targetid), amount);
						SendClientMessageEx(playerid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "You have been given %d Gift Reset voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
						SendClientMessageEx(targetid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "[Admin] %s(IP:%s) has given %s(IP:%s) %d free gift reset voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerIpEx(targetid), amount);
						Log("logs/adminrewards.log", szString);	
					}
					if(GetPVarInt(playerid, "voucherdialog") == 5) // Priority Advertisement Voucher
					{
						new targetid = GetPVarInt(playerid, "WhoIsThis"),
							amount = strval(inputtext),
							szString[128];
						PlayerInfo[targetid][pAdvertVoucher] += amount;
						format(szString, sizeof(szString), "You have given %s %d Priority Advertisement voucher(s).", GetPlayerNameEx(targetid), amount);
						SendClientMessageEx(playerid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "You have been given %d Priority Advertisement voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
						SendClientMessageEx(targetid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "[Admin] %s(IP:%s) has given %s(IP:%s) %d free Priority Advertisement voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerIpEx(targetid), amount);
						Log("logs/vouchers.log", szString);	
					}
					if(GetPVarInt(playerid, "voucherdialog") == 6) // 7 Days Silver VIP Voucher
					{
						new targetid = GetPVarInt(playerid, "WhoIsThis"),
							amount = strval(inputtext),
							szString[128];
						PlayerInfo[targetid][pSVIPExVoucher] += amount;
						format(szString, sizeof(szString), "You have given %s %d 7 Days Silver VIP voucher(s).", GetPlayerNameEx(targetid), amount);
						SendClientMessageEx(playerid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "You have been given %d 7 Days Silver VIP voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
						SendClientMessageEx(targetid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "[Admin] %s(IP:%s) has given %s(IP:%s) %d free 7 Days Silver VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerIpEx(targetid), amount);
						Log("logs/vouchers.log", szString);	
					}
					if(GetPVarInt(playerid, "voucherdialog") == 7) // 7 Days Gold VIP Voucher
					{
						new targetid = GetPVarInt(playerid, "WhoIsThis"),
							amount = strval(inputtext),
							szString[128];
						PlayerInfo[targetid][pGVIPExVoucher] += amount;
						format(szString, sizeof(szString), "You have given %s %d 7 Days Gold VIP voucher(s).", GetPlayerNameEx(targetid), amount);
						SendClientMessageEx(playerid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "You have been given %d 7 Days Gold VIP voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
						SendClientMessageEx(targetid, COLOR_CYAN, szString);
						format(szString, sizeof(szString), "[Admin] %s(IP:%s) has given %s(IP:%s) %d free 7 Days Gold VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerIpEx(targetid), amount);
						Log("logs/vouchers.log", szString);	
					}
				}
				else ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System - {FF0000}That's not a number", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
			}	
			else ShowPlayerDialog(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System ", "Please enter how many would you like to give to this player.", "Enter", "Cancel");	
		}		
		DeletePVar(playerid, "WhoIsThis");
	}										
	if(dialogid == DIALOG_VOUCHER2)
	{
		if(response) // Clicked "Use"
		{	
			if(PlayerInfo[playerid][pJailTime] > 0)
			{
				DeletePVar(playerid, "voucherdialog");
				DeletePVar(playerid, "WhoIsThis");
				return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this command while being in jail/prison.");
			}
			if(GetPVarInt(playerid, "voucherdialog") == 1) // Car Voucher
			{
				if(GetPlayerInterior(playerid) != 0) 
				{
					DeletePVar(playerid, "voucherdialog");
					DeletePVar(playerid, "WhoIsThis");
					return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this while being inside an interior.");
				}
				else
				{
					ShowModelSelectionMenu(playerid, CarList2, "Car Voucher Selection");
				}
			}
			if(GetPVarInt(playerid, "voucherdialog") == 2) // SVIP Voucher
			{
				if(PlayerInfo[playerid][pDonateRank] >= 2)
				{
					DeletePVar(playerid, "voucherdialog");
					DeletePVar(playerid, "WhoIsThis");
					return SendClientMessageEx(playerid, COLOR_GRAD2, "Your VIP Level is already set to Silver+");
				}	
				PlayerInfo[playerid][pSVIPVoucher]--;
				PlayerInfo[playerid][pDonateRank] = 2;
				PlayerInfo[playerid][pTempVIP] = 0;
				PlayerInfo[playerid][pBuddyInvited] = 0;
				PlayerInfo[playerid][pVIPExpire] = gettime()+2592000*1;
				if(PlayerInfo[playerid][pVIPM] == 0)
				{
					PlayerInfo[playerid][pVIPM] = VIPM;
					VIPM++;
				}
				LoadPlayerDisabledVehicles(playerid);
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format(string, sizeof(string), "AdmCmd: Server (Voucher System) has set %s's VIP level to Silver (2).", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, string, 4);
				format(string, sizeof(string), "You have successfully used one of your Silver VIP voucher(s), you have %d Silver VIP voucher(s) left.", PlayerInfo[playerid][pSVIPVoucher]);
				SendClientMessageEx(playerid, COLOR_CYAN, string);
				SendClientMessageEx(playerid, COLOR_GRAD2, "** Note: Your Silver VIP will expire in 30 days.");

				format(string, sizeof(string), "AdmCmd: Server (Voucher System) has set %s's (IP:%s) VIP level to Silver (2) (Voucher Left: %d)", GetPlayerNameEx(playerid), playerip, PlayerInfo[playerid][pSVIPVoucher]);
				Log("logs/vouchers.log", string);
				OnPlayerStatsUpdate(playerid);
			}
			if(GetPVarInt(playerid, "voucherdialog") == 3) // GVIP Voucher - Not renewable
			{
				if(PlayerInfo[playerid][pDonateRank] >= 3)
				{
					DeletePVar(playerid, "voucherdialog");
					DeletePVar(playerid, "WhoIsThis");
					return SendClientMessageEx(playerid, COLOR_GRAD2, "Your VIP Level is already set to Gold+");
				}	
				PlayerInfo[playerid][pGVIPVoucher]--;
				PlayerInfo[playerid][pDonateRank] = 3;
				PlayerInfo[playerid][pTempVIP] = 0;
				PlayerInfo[playerid][pBuddyInvited] = 0;
				PlayerInfo[playerid][pVIPExpire] = gettime()+2592000*1;
				if(PlayerInfo[playerid][pVIPM] == 0)
				{
					PlayerInfo[playerid][pVIPM] = VIPM;
					VIPM++;
				}
				LoadPlayerDisabledVehicles(playerid);
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format(string, sizeof(string), "AdmCmd: Server (Voucher System) has set %s's VIP level to Gold (3).", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, string, 4);
				format(string, sizeof(string), "You have successfully used one of your Gold VIP voucher(s), you have %d Gold VIP voucher(s) left.", PlayerInfo[playerid][pGVIPVoucher]);
				SendClientMessageEx(playerid, COLOR_CYAN, string);
				SendClientMessageEx(playerid, COLOR_GRAD2, "** Note: Your Gold VIP will expire in 30 days.");

				format(string, sizeof(string), "AdmCmd: Server (Voucher System) has set %s's (IP:%s) VIP level to Gold (3) (Voucher Left: %d)", GetPlayerNameEx(playerid), playerip, PlayerInfo[playerid][pGVIPVoucher]);
				Log("logs/vouchers.log", string);
				OnPlayerStatsUpdate(playerid);
			}
			if(GetPVarInt(playerid, "voucherdialog") == 4) // Gift Reset Voucher
			{
				if(PlayerInfo[playerid][pGiftTime] <= 0)
				{
					DeletePVar(playerid, "voucherdialog");
					DeletePVar(playerid, "WhoIsThis");
					return SendClientMessageEx(playerid, COLOR_GRAD2, "You're already able to to receive a gift from the giftbox or the safe.");
				}
				PlayerInfo[playerid][pGiftVoucher]--;
				PlayerInfo[playerid][pGiftTime] = 0;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format(string, sizeof(string), "You have successfully used one of your Gift Reset voucher(s), you have %d Gift Reset voucher(s) left.", PlayerInfo[playerid][pGiftVoucher]);
				SendClientMessageEx(playerid, COLOR_CYAN, string);
				SendClientMessageEx(playerid, COLOR_GRAD2, "** Note: You may now get another gift.");
				format(string, sizeof(string), "%s(IP:%s) has used a Gift Reset Voucher. (Vouchers Left: %d)", GetPlayerNameEx(playerid), playerip, PlayerInfo[playerid][pGiftVoucher]);
				Log("logs/vouchers.log", string);	
				OnPlayerStatsUpdate(playerid);
			}
			if(GetPVarInt(playerid, "voucherdialog") == 5) // 7 Days Silver VIP
			{
				if(PlayerInfo[playerid][pDonateRank] >= 2)
				{
					DeletePVar(playerid, "voucherdialog");
					DeletePVar(playerid, "WhoIsThis");
					return SendClientMessageEx(playerid, COLOR_GRAD2, "Your VIP Level is already set to Silver+");
				}	
				PlayerInfo[playerid][pSVIPExVoucher]--;
				PlayerInfo[playerid][pDonateRank] = 2;
				PlayerInfo[playerid][pTempVIP] = 0;
				PlayerInfo[playerid][pBuddyInvited] = 0;
				PlayerInfo[playerid][pVIPSellable] = 1;
				PlayerInfo[playerid][pVIPExpire] = gettime()+604800*1;
				if(PlayerInfo[playerid][pVIPM] == 0)
				{
					PlayerInfo[playerid][pVIPM] = VIPM;
					VIPM++;
				}
				LoadPlayerDisabledVehicles(playerid);
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format(string, sizeof(string), "AdmCmd: Server (Voucher System) has set %s's VIP level to Silver (7 Days)(3).", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, string, 4);
				format(string, sizeof(string), "You have successfully used one of your 7 Days Silver VIP voucher(s), you have %d 7 Days Silver VIP voucher(s) left.", PlayerInfo[playerid][pSVIPExVoucher]);
				SendClientMessageEx(playerid, COLOR_CYAN, string);
				SendClientMessageEx(playerid, COLOR_GRAD2, "** Note: Your Silver VIP will expire in 7 days.");

				format(string, sizeof(string), "AdmCmd: Server (Voucher System) has set %s's (IP:%s) VIP level to Silver (7 Days)(3) (Voucher Left: %d)", GetPlayerNameEx(playerid), playerip, PlayerInfo[playerid][pSVIPExVoucher]);
				Log("logs/vouchers.log", string);
				OnPlayerStatsUpdate(playerid);
			}
			if(GetPVarInt(playerid, "voucherdialog") == 6) // 7 Days Gold VIP
			{
				if(PlayerInfo[playerid][pDonateRank] >= 3)
				{
					DeletePVar(playerid, "voucherdialog");
					DeletePVar(playerid, "WhoIsThis");
					return SendClientMessageEx(playerid, COLOR_GRAD2, "Your VIP Level is already set to Gold+");
				}	
				PlayerInfo[playerid][pGVIPExVoucher]--;
				PlayerInfo[playerid][pDonateRank] = 3;
				PlayerInfo[playerid][pTempVIP] = 0;
				PlayerInfo[playerid][pBuddyInvited] = 0;
				PlayerInfo[playerid][pVIPSellable] = 1;
				PlayerInfo[playerid][pVIPExpire] = gettime()+604800*1;
				if(PlayerInfo[playerid][pVIPM] == 0)
				{
					PlayerInfo[playerid][pVIPM] = VIPM;
					VIPM++;
				}
				LoadPlayerDisabledVehicles(playerid);
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format(string, sizeof(string), "AdmCmd: Server (Voucher System) has set %s's VIP level to Gold (7 Days)(3).", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, string, 4);
				format(string, sizeof(string), "You have successfully used one of your 7 Days Gold VIP voucher(s), you have %d 7 Days Gold VIP voucher(s) left.", PlayerInfo[playerid][pGVIPExVoucher]);
				SendClientMessageEx(playerid, COLOR_CYAN, string);
				SendClientMessageEx(playerid, COLOR_GRAD2, "** Note: Your Silver VIP will expire in 7 days.");

				format(string, sizeof(string), "AdmCmd: Server (Voucher System) has set %s's (IP:%s) VIP level to Gold (7 Days)(3) (Voucher Left: %d)", GetPlayerNameEx(playerid), playerip, PlayerInfo[playerid][pGVIPExVoucher]);
				Log("logs/vouchers.log", string);
				OnPlayerStatsUpdate(playerid);
			}
		}
		else // Clicked "Cancel"
		{
			DeletePVar(playerid, "voucherdialog");
			DeletePVar(playerid, "WhoIsThis");
		}	
	}
	#if defined event_chancegambler
	if(dialogid == DIALOG_ROLL)
	{
		if(response)
		{
			if(chancegambler == 1)
			{
				new iNumber = Random(1, 11);
				if(iNumber > 4)
				{
					new szMessage[128];
					format(szMessage, sizeof(szMessage), "You have rolled %d and doubled your chances!", iNumber);
					SendClientMessageEx(playerid, COLOR_CYAN, szMessage);
					format(szMessage, sizeof(szMessage), "* %s has rolled %d and doubled his chances!", GetPlayerNameEx(playerid), iNumber);
					ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					PlayerInfo[playerid][pRewardDrawChance] *= 2;
					format(szMessage, sizeof(szMessage), "%s (IP:%s) has doubled their chances. (Chances: %d)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), PlayerInfo[playerid][pRewardDrawChance]);
					Log("logs/gamblechances.log", szMessage);
				}
				else
				{
					new szMessage[128];
					format(szMessage, sizeof(szMessage), "* %s has rolled %d and lost it all!", GetPlayerNameEx(playerid), iNumber);
					ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					format(szMessage, sizeof(szMessage), "You have rolled %d and lost it all!", iNumber);
					SendClientMessageEx(playerid, COLOR_CYAN, szMessage);
					PlayerInfo[playerid][pRewardDrawChance] = 0;
					format(szMessage, sizeof(szMessage), "%s (IP:%s) has lost it all. (Chances: %d)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), PlayerInfo[playerid][pRewardDrawChance]);
					Log("logs/gamblechances.log", szMessage);
				}
			}
		}
	}
	if(dialogid == DIALOG_HUNGERGAMES)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pHungerVoucher] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any Hunger Games Vouchers.");
			SendClientMessageEx(playerid, COLOR_CYAN, "You have used a Hunger Games Voucher and will have 100 HP instead of 50 for the event and will receive a free MP5.");
			PlayerInfo[playerid][pHungerVoucher]--;
			
			SetPVarInt(playerid, "HungerVoucher", 1);
		}
	}
	#endif
	/*if(dialogid == DIALOG_HELP1)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				}
			}
		}
		else return 0;
	}*/
	if(dialogid == DIALOG_GANGTAG_MAIN)
	{
		if(response)
		{
			if(listitem == 0)
			{
				if(GetFreeGangTag() == -1) return SendClientMessageEx(playerid, COLOR_GREY, "There is no free gang tag to use!");
				SetPVarInt(playerid, "CreateGT", 1);
				SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: Press the FIRE button to save the position. You can cancel this action by pressing the AIM button.");
			}
			else if(listitem == 1)
			{
				ShowPlayerDialog(playerid, DIALOG_GANGTAG_ID, DIALOG_STYLE_INPUT, "Gang Tag ID", "Please specify a vaild tag id:", "Select", "Close");
			}
		}
	}
	if(dialogid == DIALOG_GANGTAG_ID)
	{
		if(response == 1)
		{
			new gangtag = strval(inputtext);
			if(gangtag < 0 || gangtag > MAX_GANGTAGS)
			{
				ShowPlayerDialog(playerid, DIALOG_GANGTAG_ID, DIALOG_STYLE_INPUT, "Gang Tag ID", "Please specify a vaild tag id:", "Select", "Close");
				SendClientMessageEx(playerid, COLOR_GREY, "You specified an invalid gang tag id.");
				return 1;				
			}
			if(GangTags[gangtag][gt_Used] == 0)
			{
				ShowPlayerDialog(playerid, DIALOG_GANGTAG_ID, DIALOG_STYLE_INPUT, "Gang Tag ID", "Please specify a vaild tag id:", "Select", "Close");
				SendClientMessageEx(playerid, COLOR_GREY, "You specified an invalid gang tag id.");
				return 1;
			}
			new szMessage[128];
			SetPVarInt(playerid, "gt_ID", gangtag);
			format(szMessage, sizeof(szMessage), "Editing Gang Tag %d", gangtag);
			ShowPlayerDialog(playerid, DIALOG_GANGTAG_EDIT, DIALOG_STYLE_LIST, szMessage, "Set to my position\nEdit position\nDelete", "Choose", "Close");
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GANGTAG_MAIN, DIALOG_STYLE_LIST, "Gang Tags", "Create new gang tag\nEdit gang tag", "Choose", "Close");
		}
	}
	if(dialogid == DIALOG_GANGTAG_EDIT)
	{
		if(response == 1)
		{
			switch(listitem)
			{
				case 0: // Set to my position
				{
					SetPVarInt(playerid, "gt_Edit", 1);
					SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: Press the FIRE button to save the position. You can cancel this action by pressing the AIM button.");
				}
				case 1: // Edit position
				{
					new gangtag = GetPVarInt(playerid, "gt_ID");
					if(IsPlayerInRangeOfPoint(playerid, 10, GangTags[gangtag][gt_PosX], GangTags[gangtag][gt_PosY], GangTags[gangtag][gt_PosZ]))
					{
						SetPVarInt(playerid, "gt_Edit", 2);
						EditDynamicObject(playerid, GangTags[GetPVarInt(playerid, "gt_ID")][gt_Object]);
					}
					else
					{
						new szMessage[64];
						format(szMessage, sizeof(szMessage), "Editing Gang Tag %d", gangtag);
						ShowPlayerDialog(playerid, DIALOG_GANGTAG_EDIT, DIALOG_STYLE_LIST, szMessage, "Set to my position\nEdit position\nDelete", "Choose", "Close");
						SendClientMessageEx(playerid, COLOR_GREY, "You are not in range of this gang tag!");
					}
				}
				case 2: // Delete
				{
					new szMessage[64];
					SetPVarInt(playerid, "gt_Edit", 3);
					format(szMessage, sizeof(szMessage), "Are you sure that you want to delete gang tag %d?", GetPVarInt(playerid, "gt_ID"));
					ShowPlayerDialog(playerid, DIALOG_GANGTAG_EDIT1, DIALOG_STYLE_MSGBOX, "Delete Gang Tag", szMessage, "Yes", "No");
				}
			}
		}
		else
		{
			DeletePVar(playerid, "gt_ID");
			ShowPlayerDialog(playerid, DIALOG_GANGTAG_ID, DIALOG_STYLE_INPUT, "Gang Tag ID", "Please specify a vaild tag id:", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GANGTAG_EDIT1)
	{
		new szMessage[64];
		if(response == 1)
		{
			switch(GetPVarInt(playerid, "gt_Edit"))
			{
				case 3: // Delete
				{
					ClearGangTag(GetPVarInt(playerid, "gt_ID"));
					SaveGangTag(GetPVarInt(playerid, "gt_ID"));
					format(szMessage, sizeof(szMessage), "You successfully deleted gang tag %d!", GetPVarInt(playerid, "gt_ID"));
					SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					format(szMessage, sizeof(szMessage), "%s has deleted gang tag %d.", GetPlayerNameEx(playerid), GetPVarInt(playerid, "gt_ID"));
					Log("Logs/GangTags.log", string);
				}
			}
			DeletePVar(playerid, "gt_Edit");
			DeletePVar(playerid, "gt_ID");
		}
		else
		{
			DeletePVar(playerid, "gt_Edit");
			format(szMessage, sizeof(szMessage), "Editing Gang Tag %d", GetPVarInt(playerid, "gt_ID"));
			ShowPlayerDialog(playerid, DIALOG_GANGTAG_EDIT, DIALOG_STYLE_LIST, szMessage, "Set to my position\nEdit position\nDelete", "Choose", "Close");
		}
	}
	if(dialogid == DIALOG_GANGTAG_FTAG)
	{
		if((PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 1) || (PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID && PlayerInfo[playerid][pRank] >= 6 && GetPVarType(playerid, "gt_Perm")))
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: // Text
					{
						SetPVarInt(playerid, "gt_fEdit", 1);
						ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_INPUT, "Text", "Please enter the text below:", "Set", "Close");
					}
					case 1: // Color
					{
						SetPVarInt(playerid, "gt_fEdit", 2);
						ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_INPUT, "Color", "Please enter a hex color\nExample: 0xFFFFFFFF (aRGB)\nExample: 0xFF and then the RGB HEX", "Set", "Close");
					}
					case 2: // Font
					{
						SetPVarInt(playerid, "gt_fEdit", 3);
						ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_LIST, "Font", "Arial\nArial Black\nComic Sans MS\nImpact\nPalatino Linotype\nVerdana\nTimes New Roman\nLucida Console\nGeorgia", "Set", "Close");
					}
					case 3: // Font Size
					{
						SetPVarInt(playerid, "gt_fEdit", 4);
						ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_INPUT, "Font Size", "Please enter a size below:", "Set", "Close");
					}
					case 4: // Backcolor
					{
						SetPVarInt(playerid, "gt_fEdit", 5);
						ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_INPUT, "Color", "Please enter a hex color\nExample: 0xFFFFFFFF (aRGB)\nExample: 0xFF and then the RGB HEX", "Set", "Close");
					}
					case 5: // Bold
					{
						SetPVarInt(playerid, "gt_fEdit", 6);
						ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_MSGBOX, "Bold", "Would you like to toggle bold?", "Yes", "No");
					}
					case 6: // SP Tags
					{
						SetPVarInt(playerid, "gt_fEdit", 7);
						ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_LIST, "Single-Player Tags", "Frontyard Ballas 1\nFrontyard Ballas 2\nFrontyard Ballas 3\nSan Fierro Rifa\nRollin Heights Ballas\nSeville Blvd\nTemple Drive Ballas\nLos Santos Vagos\nVarrio Los Aztecas\nGrove Street 4Life\nDisable", "Choose", "Close");
					}
				}
			}
			else
			{
				DeletePVar(playerid, "gt_Fam");
			}
		}	
	}
	if(dialogid == DIALOG_GANGTAG_FTAGSEL && (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 1))
	{
		if(response)
		{
			new fam = strval(inputtext);
			if(fam < 1 || fam > MAX_FAMILY)
			{
				ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAGSEL, DIALOG_STYLE_INPUT, "Family ID", "Specify a valid family id:", "Choose", "Close");
				SendClientMessageEx(playerid, COLOR_GREY, "You specified an invalid family id!");
				return 1;
			}
			SetPVarInt(playerid, "gt_Fam", fam);
			new szMessage[32];
			format(szMessage, sizeof(szMessage), "Gang Tag Edit - %s", FamilyInfo[fam][FamilyName]);
			ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAG, DIALOG_STYLE_LIST, szMessage, "Text\nColor\nFont\nFont Size\nBackcolor\nBold\nSP Tags", "Choose", "Close");
		}
	}
	if(dialogid == DIALOG_GANGTAG_FTAGEDIT)
	{
		if((PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 1) || (PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID && PlayerInfo[playerid][pRank] >= 6 && GetPVarType(playerid, "gt_Perm")))
		{
			new szMessage[128];
			new fam = GetPVarInt(playerid, "gt_Fam");
			if(response)
			{
				switch(GetPVarInt(playerid, "gt_fEdit"))
				{
					case 1: // Text
					{
						format(FamilyInfo[fam][gt_Text], 32, "%s", inputtext);
						format(szMessage, sizeof(szMessage), "You have set the text to %s.", inputtext);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						format(szMessage, sizeof(szMessage), "%s has set the gang tag text of family %s to %s.", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName], inputtext);
						Log("Logs/GangTags.log", szMessage);
						ReCreateGangTags(fam);
						SaveFamily(fam);
					}
					case 2: // Color
					{
						if(sscanf(inputtext, "h", FamilyInfo[fam][gt_FontColor]))
						{
							ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAGEDIT, DIALOG_STYLE_INPUT, "Color", "Please enter a hex color (Example: \"0xFFFFFFFF\" ARGB Format)", "Set", "Close");
							SendClientMessageEx(playerid, COLOR_GREY, "You specified an invalid hex color!");
							return 1;
						}
						SendClientMessageEx(playerid, COLOR_WHITE, "You have adjusted the color.");
						format(szMessage, sizeof(szMessage), "%s has adjusted the gang tag text color of family %s", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName]);
						Log("Logs/GangTags.log", szMessage);	
						ReCreateGangTags(fam);
						SaveFamily(fam);
					}
					case 3: // Font
					{
						format(FamilyInfo[fam][gt_FontFace], 32, "%s", inputtext);
						format(szMessage, sizeof(szMessage), "You have set the font to %s.", inputtext);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						format(szMessage, sizeof(szMessage), "%s has set the gang tag font of family %s to %s.", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName], inputtext);
						Log("Logs/GangTags.log", szMessage);	
						ReCreateGangTags(fam);
						SaveFamily(fam);
					}
					case 4: // Font Size
					{
						new size = strval(inputtext);
						FamilyInfo[fam][gt_FontSize] = size;
						format(szMessage, sizeof(szMessage), "You have set the font-size to %d.", size);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						format(szMessage, sizeof(szMessage), "%s has set the gang tag font-size of family %s to %d.", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName], size);
						Log("Logs/GangTags.log", szMessage);	
						ReCreateGangTags(fam);
						SaveFamily(fam);
					}
					case 5: // Backcolor
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "This function has been disabled for now.");
					}
					case 6: // Bold
					{
						if(FamilyInfo[fam][gt_Bold])
						{
							FamilyInfo[fam][gt_Bold] = 0;
							SendClientMessageEx(playerid, COLOR_WHITE, "You have toggled off bold.");
						}
						else
						{
							FamilyInfo[fam][gt_Bold] = 1;
							SendClientMessageEx(playerid, COLOR_WHITE, "You have toggled on bold.");
						}
						format(szMessage, sizeof(szMessage), "%s has toggled the gang tag bold for family %s.", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName]);
						Log("Logs/GangTags.log", szMessage);		
						ReCreateGangTags(fam);
						SaveFamily(fam);
					}
					case 7: // SP Tags
					{
						if(listitem == 0)
						{
							FamilyInfo[fam][gtObject] = 1490;
							FamilyInfo[fam][gt_SPUsed] = 1;
						}
						else if(listitem == 1)
						{
							FamilyInfo[fam][gtObject] = 1524;
							FamilyInfo[fam][gt_SPUsed] = 1;
						}
						else if(listitem == 2)
						{
							FamilyInfo[fam][gtObject] = 1525;
							FamilyInfo[fam][gt_SPUsed] = 1;
						}
						else if(listitem == 3)
						{
							FamilyInfo[fam][gtObject] = 1526;
							FamilyInfo[fam][gt_SPUsed] = 1;
						}
						else if(listitem == 4)
						{
							FamilyInfo[fam][gtObject] = 1527;
							FamilyInfo[fam][gt_SPUsed] = 1;
						}
						else if(listitem == 5)
						{
							FamilyInfo[fam][gtObject] = 1528;
							FamilyInfo[fam][gt_SPUsed] = 1;
						}
						else if(listitem == 6)
						{
							FamilyInfo[fam][gtObject] = 1529;
							FamilyInfo[fam][gt_SPUsed] = 1;
						}
						else if(listitem == 7)
						{
							FamilyInfo[fam][gtObject] = 1530;
							FamilyInfo[fam][gt_SPUsed] = 1;
						}
						else if(listitem == 8)
						{
							FamilyInfo[fam][gtObject] = 1531;
							FamilyInfo[fam][gt_SPUsed] = 1;
						}
						else if(listitem == 9)
						{
							FamilyInfo[fam][gtObject] = 18659;
							FamilyInfo[fam][gt_SPUsed] = 1;
						}
						else if(listitem == 10)
						{
							FamilyInfo[fam][gtObject] = 1490;
							FamilyInfo[fam][gt_SPUsed] = 0;
						}
						format(szMessage, sizeof(szMessage), "You have set the single-player tag to %s.", inputtext);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						format(szMessage, sizeof(szMessage), "%s has set the single-player tag of family %s to %s.", GetPlayerNameEx(playerid), FamilyInfo[fam][FamilyName], inputtext);
						Log("Logs/GangTags.log", szMessage);		
						ReCreateGangTags(fam);
						SaveFamily(fam);
					}
				}
				DeletePVar(playerid, "gt_fEdit");
				DeletePVar(playerid, "gt_Fam");
			}
			else
			{
				DeletePVar(playerid, "gt_fEdit");
				format(szMessage, sizeof(szMessage), "Gang Tag Edit - %s", FamilyInfo[fam][FamilyName]);
				ShowPlayerDialog(playerid, DIALOG_GANGTAG_FTAG, DIALOG_STYLE_LIST, szMessage, "Text\nColor\nFont\nFont Size\nBackcolor\nBold\nSP Tags", "Choose", "Close");	
			}
		}	
	}
	if(dialogid == DIALOG_NRNCONFIRM)
	{
		if(response)
		{
			new playersz[5];
			GetPVarString(playerid, "nrn", playersz, 5);
			DeletePVar(playerid, "nrn");
			cmd_nrn(playerid, playersz);
		}
		else
		{
			DeletePVar(playerid, "nrn");
		}
	}
	if(dialogid == DIALOG_CONFIRMADP)
	{
		if(response)
		{
			new advert[128], reportid = GetPVarInt(playerid, "ReporterID");
			new szString[128];
			GetPVarString(reportid, "PriorityAdText", advert, 128);
			// Do not comment this out! This is needed to re-format the ad with the proper format - Nathan
			format(advert, sizeof(advert), "Advertisement: %s - contact: %s (%d)", advert, GetPlayerNameEx(reportid), PlayerInfo[reportid][pPnumber]);
			SendClientMessageEx(reportid, -1, "Your Priority Advertisement has been approved & published.");
			if(GetPVarInt(reportid, "AdvertVoucher") > 0)
			{
			}
			else if(PlayerInfo[reportid][pFreeAdsLeft] > 0 && PlayerInfo[reportid][pDonateRank] >= 4)
			{
				PlayerInfo[reportid][pFreeAdsLeft]--;
				format(szString, sizeof(szString), "Platinum VIP: You have used a free advertisement, you have %d left for today.", PlayerInfo[reportid][pFreeAdsLeft]);
				SendClientMessageEx(reportid, COLOR_YELLOW, szString);				
			}
			else if(PlayerInfo[reportid][pDonateRank] == 2)
			{
				GivePlayerCash(reportid, -125000);
				SendClientMessageEx(reportid, COLOR_YELLOW, "VIP Discount: You have paid $125,000 for being Silver VIP.");
			}
			else if(PlayerInfo[reportid][pDonateRank] == 3)
			{
				GivePlayerCash(reportid, -100000);
				SendClientMessageEx(reportid, COLOR_YELLOW, "VIP Discount: You have paid $100,000 for being Gold VIP.");
			}
			else if(PlayerInfo[reportid][pDonateRank] >= 4)
			{
				GivePlayerCash(reportid, -50000);
				SendClientMessageEx(reportid, COLOR_YELLOW, "VIP Discount: You have paid $50,000 for being Platinum VIP.");
			}
			else
			{
				GivePlayerCash(reportid, -150000);
			}	
			iAdverTimer = gettime()+30;
			
			//foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{			
					if(!gNews[i] && InsideMainMenu{i} != 1 && InsideTut{i} != 1 && ActiveChatbox[i] != 0) SendClientMessage(i, TEAM_GROVE_COLOR, advert);
				}
			}	
			Log("logs/pads.log", advert);
			
			DeletePVar(reportid, "PriorityAdText");
			DeletePVar(playerid, "ReporterID");
			DeletePVar(reportid, "RequestingAdP");
			DeletePVar(reportid, "AdvertVoucher");
		}
		else
		{
			SendClientMessageEx(GetPVarInt(playerid, "ReporterID"), -1, "Your priority advertisement has been denied.");
			DeletePVar(GetPVarInt(playerid, "ReporterID"), "PriorityAdText");
			DeletePVar(GetPVarInt(playerid, "ReporterID"), "AdvertVoucher");
			DeletePVar(GetPVarInt(playerid, "ReporterID"), "RequestingAdP");
			DeletePVar(playerid, "ReporterID");
		}
	}
	if(dialogid == DIALOG_GIFTBOX_INFO)
	{
		if(response)
		{
			return ShowPlayerDynamicGiftBox(playerid);
		}
	}	
	if(dialogid == DIALOG_GIFTBOX_VIEW)
	{
		if(response)
		{
			switch(listitem) 
			{
				case 1:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgMoney[0], dgMoney[1], dgMoney[2], GetDynamicGiftBoxType(dgMoney[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Money", szString, "Back", "");
				}
				case 2:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgRimKit[0], dgRimKit[1], dgRimKit[2], GetDynamicGiftBoxType(dgRimKit[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Rimkit", szString, "Back", "");
				}
				case 3:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgFirework[0], dgFirework[1], dgFirework[2], GetDynamicGiftBoxType(dgFirework[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Firework", szString, "Back", "");
				}
				case 4:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgGVIP[0], dgGVIP[1], dgGVIP[2], GetDynamicGiftBoxType(dgGVIP[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - 7 Day GVIP", szString, "Back", "");
				}
				case 5:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgGVIPEx[0], dgGVIPEx[1], dgGVIPEx[2], GetDynamicGiftBoxType(dgGVIPEx[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - 1 Month GVIP", szString, "Back", "");
				}
				case 6:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgSVIP[0], dgSVIP[1], dgSVIP[2], GetDynamicGiftBoxType(dgSVIP[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - 1 Day SVIP", szString, "Back", "");
				}
				case 7:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgSVIPEx[0], dgSVIPEx[1], dgSVIPEx[2], GetDynamicGiftBoxType(dgSVIPEx[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - 1 Month SVIP", szString, "Back", "");
				}
				case 8:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgCarSlot[0], dgCarSlot[1], dgCarSlot[2], GetDynamicGiftBoxType(dgCarSlot[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Car Slot", szString, "Back", "");
				}
				case 9:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgToySlot[0], dgToySlot[1], dgToySlot[2], GetDynamicGiftBoxType(dgToySlot[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Toy Slot", szString, "Back", "");
				}
				case 10:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgArmor[0], dgArmor[1], dgArmor[2], GetDynamicGiftBoxType(dgArmor[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Armor", szString, "Back", "");
				}
				case 11:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgFirstaid[0], dgFirstaid[1], dgFirstaid[2], GetDynamicGiftBoxType(dgFirstaid[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Firstaid", szString, "Back", "");
				}
				case 12:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgDDFlag[0], dgDDFlag[1], dgDDFlag[2], GetDynamicGiftBoxType(dgDDFlag[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Dynamic Door Flag", szString, "Back", "");
				}
				case 13:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgGateFlag[0], dgGateFlag[1], dgGateFlag[2], GetDynamicGiftBoxType(dgGateFlag[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Dynamic Gate Flag", szString, "Back", "");
				}
				case 14:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgCredits[0], dgCredits[1], dgCredits[2], GetDynamicGiftBoxType(dgCredits[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Credits", szString, "Back", "");
				}
				case 15:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgPriorityAd[0], dgPriorityAd[1], dgPriorityAd[2], GetDynamicGiftBoxType(dgPriorityAd[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Priority Advertisement", szString, "Back", "");
				}
				case 16:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgHealthNArmor[0], dgHealthNArmor[1], dgHealthNArmor[2], GetDynamicGiftBoxType(dgHealthNArmor[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Health & Armor", szString, "Back", "");
				}
				case 17:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgGiftReset[0], dgGiftReset[1], dgGiftReset[2], GetDynamicGiftBoxType(dgGiftReset[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Gift Reset", szString, "Back", "");
				}
				case 18:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgMaterial[0], dgMaterial[1], dgMaterial[2], GetDynamicGiftBoxType(dgMaterial[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Material", szString, "Back", "");
				}
				case 19:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgWarning[0], dgWarning[1], dgWarning[2], GetDynamicGiftBoxType(dgWarning[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Warning", szString, "Back", "");
				}
				case 20:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgPot[0], dgPot[1], dgPot[2], GetDynamicGiftBoxType(dgPot[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Pot", szString, "Back", "");
				}
				case 21:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgCrack[0], dgCrack[1], dgCrack[2], GetDynamicGiftBoxType(dgCrack[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Crack", szString, "Back", "");
				}
				case 22:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgPaintballToken[0], dgPaintballToken[1], dgPaintballToken[2], GetDynamicGiftBoxType(dgPaintballToken[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Paintball Token", szString, "Back", "");
				}
				case 23:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVIPToken[0], dgVIPToken[1], dgVIPToken[2], GetDynamicGiftBoxType(dgVIPToken[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - VIP Token", szString, "Back", "");
				}
				case 24:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgRespectPoint[0], dgRespectPoint[1], dgRespectPoint[2], GetDynamicGiftBoxType(dgRespectPoint[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Respect Point", szString, "Back", "");
				}
				case 25:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgCarVoucher[0], dgCarVoucher[1], dgCarVoucher[2], GetDynamicGiftBoxType(dgCarVoucher[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Car Voucher", szString, "Back", "");
				}	
				case 26:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgBuddyInvite[0], dgBuddyInvite[1], dgBuddyInvite[2], GetDynamicGiftBoxType(dgBuddyInvite[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Buddy Invite", szString, "Back", "");
				}	
				case 27:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgLaser[0], dgLaser[1], dgLaser[2], GetDynamicGiftBoxType(dgLaser[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Laser", szString, "Back", "");
				}	
				case 28:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nToy ID: %d\nGift Type: %s", dgCustomToy[0], dgCustomToy[1], dgCustomToy[2], GetDynamicGiftBoxType(dgCustomToy[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Custom Toy", szString, "Back", "");
				}	
				case 29:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgAdmuteReset[0], dgAdmuteReset[1], dgAdmuteReset[2], GetDynamicGiftBoxType(dgAdmuteReset[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Advertisement Mute Reset", szString, "Back", "");
				}
				case 30:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgNewbieMuteReset[0], dgNewbieMuteReset[1], dgNewbieMuteReset[2], GetDynamicGiftBoxType(dgNewbieMuteReset[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Newbie Mute Reset", szString, "Back", "");
				}
				case 31:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgRestrictedCarVoucher[0], dgRestrictedCarVoucher[1], dgRestrictedCarVoucher[2], GetDynamicGiftBoxType(dgRestrictedCarVoucher[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Restricted Car Voucher", szString, "Back", "");
				}
				case 32:
				{
					if(PlayerInfo[playerid][pAdmin] != 99999) return true;
					
					new szString[128];
					format(szString, sizeof(szString), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgPlatinumVIPVoucher[0], dgPlatinumVIPVoucher[1], dgPlatinumVIPVoucher[2], GetDynamicGiftBoxType(dgPlatinumVIPVoucher[3]));
					ShowPlayerDialog(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Platinum VIP Voucher", szString, "Back", "");
				}
				default: return true;
			}
		}
	}
	if(dialogid == DIALOG_VIPSPAWN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPVarInt(playerid, "VIPSpawn", 1);
					SendClientMessageEx(playerid, COLOR_CYAN, "You have used your free spawn at the Gold VIP+ room, you will be spawned at Los Santos VIP in 60 seconds.");
				}
				case 1:
				{
					SetPVarInt(playerid, "VIPSpawn", 2);
					SendClientMessageEx(playerid, COLOR_CYAN, "You have used your free spawn at the Gold VIP+ room, you will be spawned at San Fierro VIP in 60 seconds.");
				}
				case 2:
				{
					SetPVarInt(playerid, "VIPSpawn", 3);
					SendClientMessageEx(playerid, COLOR_CYAN, "You have used your free spawn at the Gold VIP+ room, you will be spawned at Las Ventures VIP in 60 seconds.");
				}
				case 3:
				{
					SetPVarInt(playerid, "VIPSpawn", 4);
					SendClientMessageEx(playerid, COLOR_GREY, "You have not used your free spawn at the Gold VIP+ room this time.");
				}
			}
			SetPlayerSpawn(playerid);
		}
		else
		{
			SetPVarInt(playerid, "VIPSpawn", 4);
			SendClientMessageEx(playerid, COLOR_GREY, "You have not used your free spawn at Gold VIP+ room this time.");
			SetPlayerSpawn(playerid);
		}
	}
	if(dialogid == DIALOG_VIPJOB)
	{
		if(response && PlayerInfo[playerid][pDonateRank] >= 4 && PlayerInfo[playerid][pVIPJob] > 0)
		{
			switch(listitem)
			{
				case 0:
				{
					if(PlayerInfo[playerid][pDetSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pDetSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Detective skill level has been set to 5.");
				}
				case 1:
				{
					if(PlayerInfo[playerid][pLawSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pLawSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Lawyer skill level has been set to 5.");
				}
				case 2:
				{
					if(PlayerInfo[playerid][pSexSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}				
					PlayerInfo[playerid][pSexSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Whore skill level has been set to 5.");
				}
				case 3:
				{
					if(PlayerInfo[playerid][pDrugsSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pDrugsSkill] = 400;				
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drugs Dealer skill level has been set to 5.");
				}
				case 4:
				{
					if(PlayerInfo[playerid][pSmugSkill] >= 200)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pSmugSkill] = 200;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drugs Smuggling skill level has been set to 5.");
				}
				case 5:
				{
					if(PlayerInfo[playerid][pArmsSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pArmsSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer skill level has been set to 5.");
				}
				case 6:
				{
					if(PlayerInfo[playerid][pMechSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pMechSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic skill level has been set to 5.");
				}
				case 7:
				{
					if(PlayerInfo[playerid][pBoxSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pBoxSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxer skill level has been set to 5.");
				}
				case 8:
				{
					if(PlayerInfo[playerid][pFishSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pFishSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing skill level has been set to 5.");
				}
				case 9:
				{
					if(PlayerInfo[playerid][pTruckSkill] >= 401)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pTruckSkill] = 401;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor skill level has been set to 5.");
				}
				case 10:
				{
					if(PlayerInfo[playerid][pTreasureSkill] >= 600)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pTreasureSkill] = 600;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunter skill level has been set to 5.");
				}
			}
			PlayerInfo[playerid][pVIPJob] = 0;
			OnPlayerStatsUpdate(playerid);
		}
	}
	if(PlayerInfo[playerid][pVIPSpawn] == 1 && PlayerInfo[playerid][pDonateRank] == 2 && GetPVarInt(playerid, "MedicBill") == 1 && !GetPVarType(playerid, "VIPSpawn"))
	{
		SetPlayerCameraPos(playerid,2787.102050, 2392.162841, 1243.898681);
		SetPlayerCameraLookAt(playerid,2801.281982, 2404.575683, 1240.531127);
		SetPlayerPos(playerid, 2788.561523, 2387.321044, 1227.350219);
		TogglePlayerControllable(playerid, false);
		ShowPlayerDialog(playerid, DIALOG_VIPSPAWN, DIALOG_STYLE_LIST, "Spawn at VIP", "Los Santos VIP\nSan Fierro VIP\nLas Ventures VIP\nDon't spawn at VIP this time", "Select", "Close");
	}	
	return 1;
}