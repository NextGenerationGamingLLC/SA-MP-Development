/* Tutorial by Jingles */

#include <YSI\y_hooks>


#define 		TUTORIAL_STEPS_TIME				30 // in seconds

#define 		REGISTER_MAX_TOYS				(3)
#define 		REGISTER_TOYS					(1339)

#define 		CHECKPOINT_REGISTER_PLANE		(1500)
#define 		CHECKPOINT_TUTORIAL_CAR			(1501)
#define 		CHECKPOINT_TUTORIAL_PHONE		(1502)
#define 		CHECKPOINT_TUTORIAL_BANK		(1503)
#define 		CHECKPOINT_TUTORIAL_JOB			(1504)

#define 		PVAR_REGISTERING				"_REG"

new Text:TutTextDraw[24];

    /*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Dynamic Group Core

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

// new cam_CamShakeTimer[MAX_PLAYERS];

hook OnGameModeInit()
{
	Tutorial_InitTextDraws();
	CreateDynamicObject(10166, 731.44012, -2054.97632, -26.64376,   15.00000, 350.00000, 0.00000);
	/* PLANE */
	// Red County / West LS
	CreateDynamicObject(14548,-65.21631,-1477.94287,1492.05649,   355.00000, 10.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(14549,-68.62537,-1494.48889,1031.76279,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(14550,-65.21631,-1477.94287,1491.53549,   355.00000, 10.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(14552,-68.48389,-1482.36133,1493.48517,   355.00000, 10.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(18692,-65.15027,-1491.10278,1494.22479,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(18692,-62.05823,-1476.61145,1488.90167,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(18692,-69.18896,-1472.19641,1489.19601,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(18692,-63.87793,-1457.0387,1482.78467,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(14553,-65.21631,-1477.94287,1492.05649,   355.00000, 10.00000, 0.00000, .worldid = 100);

	// Central LS
	CreateDynamicObject(14548,1434.78369,-1077.94287,1492.05649,   355.00000, 10.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(14549,1431.37463,-1094.48889,1031.76279,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(14550,1434.78369,-1077.94287,1491.53549,   355.00000, 10.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(14552,1431.51611,-1082.36133,1493.48517,   355.00000, 10.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(18692,1434.84973,-1091.10278,1494.22479,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(18692,1437.94177,-1076.61145,1488.90167,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(18692,1430.81104,-1072.19641,1489.19601,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(18692,1436.12207,-1057.0387,1482.78467,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(14553,1434.78369,-1077.94287,1492.05649,   355.00000, 10.00000, 0.00000, .worldid = 100);


	new reghall = CreateDynamicObject(16665, 9.71753, 15.34075, 1627.65430,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(reghall, 0, 14799, "gen_offtrackint", "barbersmir1", 0xAAFFFFFF);
	SetDynamicObjectMaterial(reghall, 2, 14799, "gen_offtrackint", "barbersmir1", 0xAAFFFFFF); // floor/roof
	SetDynamicObjectMaterial(reghall, 3, 0, "none", "none", 0); // forward
	CreateDynamicObject(16663, 7.11402, 15.93656, 1631.24438,   0.00000, 0.00000, 315.00000);
	CreateDynamicObject(16662, -1.62093, 15.88998, 1627.91516,   0.00000, 0.00000, 65.00000);
	CreateDynamicObject(16663, 7.11402, 15.93656, 1630.73438,   0.00000, 0.00000, 315.00000);
	CreateDynamicObject(7264, 116.27835, 1.74710, 1711.33838,   0.00000, 0.00000, 180.53903);
	CreateDynamicObject(7264, -10.72266, -38.07650, 1626.95056,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(7264, -25.11639, -35.55965, 1626.95056,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(7264, -40.73242, -33.36256, 1626.95056,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(7264, -70.74297, -27.61604, 1650.05579,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(7264, -7.80112, 67.04976, 1629.71777,   180.00000, 90.00000, 358.03851);
	CreateDynamicObject(7264, -23.19312, 65.36996, 1629.71777,   180.00000, 90.00000, 358.03851);
	CreateDynamicObject(7264, -38.59340, 63.93069, 1629.71777,   180.00000, 90.00000, 358.03851);
	CreateDynamicObject(7264, -51.25368, 62.49588, 1634.92529,   180.00000, 90.00000, 358.03851);
	CreateDynamicObject(18001, -1.31434, 8.59676, 1629.40283,   0.00000, 0.00000, 116.13078);
	CreateDynamicObject(18001, -2.04087, 23.79757, 1629.40283,   0.00000, 0.00000, 62.04355);
	CreateDynamicObject(18001, -1.31434, 8.59676, 1628.01489,   0.00000, 0.00000, 116.13078);
	CreateDynamicObject(18001, -2.04090, 23.79760, 1628.00293,   0.00000, 0.00000, 62.04360);
	CreateDynamicObject(7264, -53.53544, -31.12281, 1627.36169,   0.00000, 90.00000, 0.00000);
	return 1;
}

hook OnGameModeExit()
{
	for(new i; i < MAX_ACTORS; ++i) DestroyActor(i);
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	switch(gPlayerCheckpointStatus[playerid])
	{
		case CHECKPOINT_REGISTER_PLANE:
		{
			DeletePVar(playerid, PVAR_REGISTERING);
			PlayerInfo[playerid][pTut] = 2;
			PlayAudioStreamForPlayer(playerid, "http://sampweb.ng-gaming.net/dom/ngg_tutend.mp3");
			CreateExplosionForPlayer(playerid, -66.5676, -1890.1495, 1490.7732, 13, 1.0);
			ClearChatbox(playerid);
			SetPVarInt(playerid, "pTut", 4);
			SetTimerEx("Register_Finalize", 8000, false, "i", playerid);
			DisablePlayerCheckpoint(playerid);
			return 1;
		}
		case CHECKPOINT_TUTORIAL_CAR:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Enter any dealership car to buy it.");
			DisablePlayerCheckpoint(playerid);
			return 1;
		}
		case CHECKPOINT_TUTORIAL_PHONE:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Press ~k~~VEHICLE_ENTER_EXIT~ to enter/exit buildings.");
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Enter the store and ~k~~CONVERSATION_YES~ to buy a phone.");
			DisablePlayerCheckpoint(playerid);
			return 1;
		}
		case CHECKPOINT_TUTORIAL_BANK:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Enter the bank and walk up to the banker and press ~k~~CONVERSATION_YES~ to manage your funds.");
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} You can also withdraw funds from an ATM for an extra charge.");
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Press ~k~~CONVERSATION_YES~ to use any ATM.");

			DisablePlayerCheckpoint(playerid);
			SetPVarInt(playerid, "pTut", GetPVarInt(playerid, "pTut") + 1);
			Tutorial_Objectives(playerid);
			return 1;
		}
		case CHECKPOINT_TUTORIAL_JOB:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Aim at the actor and use ~k~~CONVERSATION_YES~ to interact with them.");
			DisablePlayerCheckpoint(playerid);
			return 1;
		}
	}
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_TUTORIAL:
		{
			if(!GetPVarType(playerid, "TUT_CNT")) {
				if(GetPVarInt(playerid, "pTut") < 2) SetPVarInt(playerid, "TUT_CNT", TUTORIAL_STEPS_TIME);
				else SetPVarInt(playerid, "TUT_CNT", 15);
				Tutorial_CountDown(playerid);
			}
			else Tutorial_Stage(playerid);
			return 1;
		}
		case DIALOG_REGISTER_QUESTIONMAIN:
		{
			ClearChatbox(playerid);
			return Register_ShowQuestion(playerid, 1);
		}
		case DIALOG_REGISTER_QUESTION1:
		{
			ClearChatbox(playerid);
			if(listitem  == (GetPVarInt(playerid, "_AnswerKey") - 1)) SetPVarInt(playerid, "_CorrectAnswers", GetPVarInt(playerid, "_CorrectAnswers") + 1);
			return Register_ShowQuestion(playerid, 2);
		}
		case DIALOG_REGISTER_QUESTION2:
		{
			ClearChatbox(playerid);
			if(listitem  == (GetPVarInt(playerid, "_AnswerKey") - 1)) SetPVarInt(playerid, "_CorrectAnswers", GetPVarInt(playerid, "_CorrectAnswers") + 1);
			return Register_ShowQuestion(playerid, 3);
		}
		case DIALOG_REGISTER_QUESTION3:
		{
			ClearChatbox(playerid);
			if(listitem  == (GetPVarInt(playerid, "_AnswerKey") - 1)) SetPVarInt(playerid, "_CorrectAnswers", GetPVarInt(playerid, "_CorrectAnswers") + 1);
			return Register_ShowQuestion(playerid, 999); // final
		}
		case DIALOG_REGISTER_EXIT:
		{
			if(!response) SetTimerEx("KickEx", 1000, 0, "i", playerid);
			else Register_MainMenu(playerid);
		}
		case DIALOG_REGISTER_MENU:
		{
			if(!response) return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_EXIT, DIALOG_STYLE_MSGBOX, "NG:RP Character Creation | Exit", "Are you sure you would like to exit the character creation menu?\nNote: This will {FF0000}delete {FFFFFF}your data!", "Continue", "Quit");
			switch(listitem)
			{
				case 0: return Register_MainMenu(playerid);
				case 1: return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "NG:RP Character Creation | Skin Model", "Male\nFemale", "Select", "<<");
				case 2: return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_MONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Select", "<<");
				case 3: return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_NATION, DIALOG_STYLE_LIST, "NG:RP Character Creation | Nation", "San Andreas\nNew Robada", "Select", "<<");
				case 4:
				{
					szMiscArray[0] = 0;
					szMiscArray = "No accent\n\
					British accent\n\
					Japanese accent\n\
					Chinese accent\n\
					Korean accent\n\
					Scottish accent\n\
					Irish accent\n\
					Russian accent\n\
					American accent\n\
					Spanish accent\n\
					Southern accent\n\
					Italian accent\n\
					Southern accent\n\
					Gangster accent\n\
					Australian accent\n\
					Arabic accent\n\
					Balkan accent\n\
					Canadian accent\n\
					Jamaican accent\n\
					Israeli accent\n\
					Dutch accent\n\
					Brazilian accent\n\
					German accent\n\
					Turkish accent\n\
					Kiwi accent\n\
					French accent\n\
					Korean accent\n\
					Thai accent";
					return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_ACCENT, DIALOG_STYLE_LIST, "NG:RP Character Creation | Accent", szMiscArray, "Select", "<<");
				}
				case 5: return Register_MainMenu(playerid);
				case 6:
				{
					if(PlayerInfo[playerid][pSex] == 0) { 
						SendClientMessage(playerid, COLOR_YELLOW, "Please select your gender first.");
						return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "NG:RP Character Creation | Skin Model", "Male\nFemale", "Select", "<<");
					}
					
					/*
					Caused issues with modded games.
					switch(PlayerInfo[playerid][pSex])
					{
	                    case 1: return ShowModelSelectionMenuEx(playerid, g_aMaleSkins, sizeof(g_aMaleSkins), "Skin Model", REGISTER_SKINMODEL, -16.0, 0.0, -55.0);
						case 2: return ShowModelSelectionMenuEx(playerid, g_aFemaleSkins, sizeof(g_aFemaleSkins), "Skin Model", REGISTER_SKINMODEL, -16.0, 0.0, -55.0);
               		}
               		*/

               		ShowPlayerDialogEx(playerid, DIALOG_REGISTER_SKIN, DIALOG_STYLE_INPUT, "NG:RP Character Creation | Skin Model", "Please enter a skin ID for your character.", "Select", "<<");
               	}
				case 7: return Register_MainMenu(playerid);
				case 8:
				{
					if(PlayerInfo[playerid][pSex] == 0)
					{
						SendClientMessage(playerid, COLOR_YELLOW, "Please pick a gender.");
						return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "NG:RP Character Creation | Skin Model", "Male\nFemale", "Select", "<<");

					}
					if(strcmp(PlayerInfo[playerid][pBirthDate], "0000-00-00") == 0)
					{
						SendClientMessage(playerid, COLOR_YELLOW, "Please specify your birthdate.");
						return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_MONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Select", "<<");
					}
					else return Register_FinishSetup(playerid);
				}
			}
		}
		case DIALOG_REGISTER_SKIN: {

			if(response && !isnull(inputtext) && IsNumeric(inputtext) && IsValidSkin(strval(inputtext))) {

			    PlayerInfo[playerid][pModel] = strval(inputtext);
				Register_CreatePlayer(playerid, strval(inputtext));
			}
			Register_MainMenu(playerid);
		}
		case DIALOG_REGISTER_SEX:
	    {
		    if(response)
		    {
			    if(listitem == 0) {
					PlayerInfo[playerid][pSex] = 1;
					PlayerInfo[playerid][pModel] = 2;
					Register_CreatePlayer(playerid, 2);
					SendClientMessage(playerid, COLOR_YELLOW2, "Alright, so you're a male!");
					Register_MainMenu(playerid);
				}
				else if(listitem == 1) {
					PlayerInfo[playerid][pSex] = 2;
					PlayerInfo[playerid][pModel] = 91;
					Register_CreatePlayer(playerid, 91);
					SendClientMessage(playerid, COLOR_YELLOW2, "Alright, so you're a female!");
					Register_MainMenu(playerid);
				}
			}
			else ShowPlayerDialogEx(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "{FF0000}Is your character male or female?", "Male\nFemale", "Submit", "");
		}
		case DIALOG_REGISTER_NATION: {
			if(response) {
				PlayerInfo[playerid][pNation] = listitem;
				switch(listitem) {
					case 0: SendClientMessageEx(playerid, COLOR_GRAD1, "You are now a citizen of San Andreas.");
					case 1: SendClientMessageEx(playerid, COLOR_GRAD1, "You are now a citizen of New Robada.");
				}
			}
			Register_MainMenu(playerid);
		}
		case DIALOG_REGISTER_MONTH:
	    {
			if(response)
			{
				szMiscArray[0] = 0;
				new month = listitem+1;
				SetPVarInt(playerid, "RegisterMonth", month);

				new lastdate;
				if(listitem == 0 || listitem == 2 || listitem == 4 || listitem == 6 || listitem == 7 || listitem == 9 || listitem == 11) lastdate = 32;
				else if(listitem == 3 || listitem == 5 || listitem == 8 || listitem == 10) lastdate = 31;
				else lastdate = 29;
				for(new x = 1; x < lastdate; x++)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s%d\n", szMiscArray, x);
				}
				ShowPlayerDialogEx(playerid, DIALOG_REGISTER_DAY, DIALOG_STYLE_LIST, "{FF0000}Which day was your character born?", szMiscArray, "Submit", "");
			}
			else return Register_MainMenu(playerid);
		}
		case DIALOG_REGISTER_DAY:
	    {
	    	szMiscArray[0] = 0;
			if(response)
			{
				new setday = listitem+1;
				SetPVarInt(playerid, "RegisterDay", setday);

				new month, day, year;
				getdate(year,month,day);
				new startyear = year-100;
				for(new x = startyear; x < year; x++)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s%d\n", szMiscArray, x);
				}
				ShowPlayerDialogEx(playerid, DIALOG_REGISTER_YEAR, DIALOG_STYLE_LIST, "{FF0000}Which year was your character born?", szMiscArray, "Submit", "");
			}
			else ShowPlayerDialogEx(playerid, DIALOG_REGISTER_MONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
		}
		case DIALOG_REGISTER_YEAR:
	    {
	    	szMiscArray[0] = 0;
			new month, day, year;
			getdate(year,month,day);
			new startyear = year-100;
			if(response)
			{
				new setyear = listitem+startyear;
				format(PlayerInfo[playerid][pBirthDate], 11, "%d-%02d-%02d", setyear, GetPVarInt(playerid, "RegisterMonth"), GetPVarInt(playerid, "RegisterDay"));
				DeletePVar(playerid, "RegisterMonth");
				DeletePVar(playerid, "RegisterDay");
				SendClientMessage(playerid, COLOR_LIGHTRED, "Your birthdate has been successfully set.");
				return Register_MainMenu(playerid);
			}
			else
			{
				for(new x = startyear; x < year; x++)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s%d\n", szMiscArray, x);
				}
				ShowPlayerDialogEx(playerid, DIALOG_REGISTER_YEAR, DIALOG_STYLE_LIST, "{FF0000}Which year was your character born?", szMiscArray, "Submit", "");
			}
		}
		case DIALOG_REGISTER_ACCENT:
		{
			if(response)
			{
				if(listitem == 0) PlayerInfo[playerid][pAccent] = listitem;
				if(listitem > 0) PlayerInfo[playerid][pAccent] = listitem+1;
			}
			return Register_MainMenu(playerid);
		}
		case DIALOG_REGISTER_REFERRED:
		{
		    if(response)
		    {
		        if(IsNumeric(inputtext))
		        {
		            ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
		            return 1;
				}
				if(strfind(inputtext, "_", true) == -1)
				{
				    ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
		            return 1;
		        }
		        if(strlen(inputtext) > 20)
		        {
		            ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That name is too long\nPlease shorten the name.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
		            return 1;
		        }
		        if(strcmp(inputtext, GetPlayerNameExt(playerid), true) == 0)
		        {
		            ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error", "You can't add yourself as a referrer.\nPlease enter the referrer name or press 'Skip'.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
		            return 1;
		        }
				for(new sz = 0; sz < strlen(inputtext); sz++)
				{
				    if(inputtext[sz] == ' ')
				    {
					    ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
			            return 1;
			        }
			    }
			  	mysql_escape_string(inputtext, szMiscArray);
                format(PlayerInfo[playerid][pReferredBy], MAX_PLAYER_NAME, "%s", szMiscArray);
                mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `Username` FROM `accounts` WHERE `Username` = '%e'", inputtext);
         		mysql_tquery(MainPipeline, szMiscArray, true, "OnQueryFinish", "iii", MAIN_REFERRAL_THREAD, playerid, g_arrQueryHandle{playerid});
			}
			else
			{
			    format(szMiscArray, sizeof(szMiscArray), "Nobody");
				strmid(PlayerInfo[playerid][pReferredBy], szMiscArray, 0, strlen(szMiscArray), MAX_PLAYER_NAME);
				TogglePlayerSpectating(playerid, false);
				SetHealth(playerid, 100.0);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Thanks for filling in all the information! Enjoy your time and trip to San Andreas!");
				SetTimerEx("Register_FinishSetup2", 250, false, "i", playerid);
			}
		}
		case DIALOG_SPAWNINPRISON:
		{
			if(response)
			{
				format(szMiscArray, sizeof(szMiscArray), "Nobody");
				strmid(PlayerInfo[playerid][pReferredBy], szMiscArray, 0, strlen(szMiscArray), MAX_PLAYER_NAME);
				TogglePlayerSpectating(playerid, false);
				SetPlayerColor(playerid,TEAM_ORANGE_COLOR);
				for(new i = 0; i < 3; i++)
				{
					SendClientMessageEx(playerid, COLOR_ORANGE, prisonerMOTD[i]);
				}
				SetHealth(playerid, 100.0);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Thanks for filling in all the information! Enjoy your time and trip to San Andreas!");
				SetTimerEx("Register_FinishSetup2", 250, false, "i", playerid);
			}
			else
			{
				TogglePlayerSpectating(playerid, false);
				SetTimerEx("Register_FinishSetup4", 250, false, "i", playerid);
			}
		}
	}
	return 0;
}


Tutorial_Start(playerid) {
	IsSpawned[playerid] = 1;
	PlayAudioStreamForPlayer(playerid, "http://sampweb.ng-gaming.net/dom/hopereturns.mp3");
	ClearChatbox(playerid);
	for(new i; i < sizeof(TutTextDraw); ++i) TextDrawShowForPlayer(playerid, TutTextDraw[i]);
	SetPVarInt(playerid, "TUT_CNT", TUTORIAL_STEPS_TIME);
	TogglePlayerSpectating(playerid, 1);
	SetPVarInt(playerid, "pTut", 0);
	Tutorial_CountDown(playerid);
	SetTimerEx("Tutorial_Camera", 250, false, "i",playerid);
}

Tutorial_End(playerid) {
	DeletePVar(playerid, "TUT_CNT");
	SetPVarInt(playerid, "pTut", 1);
	for(new i; i < sizeof(TutTextDraw); ++i) TextDrawHideForPlayer(playerid, TutTextDraw[i]);

}

forward Tutorial_Camera(playerid);
public Tutorial_Camera(playerid)
{
	InterpolateCameraPos(playerid, 739.6243, -2035.5354, -18.0360, 759.7548, -2046.5575, -14.9280, TUTORIAL_STEPS_TIME * 1000, CAMERA_MOVE);
	InterpolateCameraLookAt(playerid, 740.5797, -2035.8429, -17.8513, 760.7530, -2046.4546, -14.6232, TUTORIAL_STEPS_TIME * 1000, CAMERA_MOVE);
}

forward Tutorial_CountDown(playerid);
public Tutorial_CountDown(playerid) {
	if(!GetPVarType(playerid, "TUT_CNT")) return 1;
	new time = GetPVarInt(playerid, "TUT_CNT");
	SetPVarInt(playerid, "TUT_CNT", time -  1);
	if(time == 0) {
		new plTut = GetPVarInt(playerid, "pTut");
		plTut += 1;
		SetPVarInt(playerid, "pTut", plTut);
		DeletePVar(playerid, "TUT_CNT");
		switch(plTut)
		{
			case 1:
			{
				InterpolateCameraPos(playerid, 759.7548, -2046.5575, -14.9280, 717.2562, -2042.1526, 5.5982, TUTORIAL_STEPS_TIME * 1000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 760.7530, -2046.4546, -14.6232, 717.2706, -2041.1542, 5.5032, TUTORIAL_STEPS_TIME * 1000, CAMERA_MOVE);
			}
			case 2:
			{
				InterpolateCameraPos(playerid, 717.2562, -2042.1526, 5.5982, 725.6536, -1665.1573, 3.9847, TUTORIAL_STEPS_TIME * 1000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 717.2706, -2041.1542, 5.5032, 725.6084, -1664.1599, 3.9547, TUTORIAL_STEPS_TIME * 1000, CAMERA_MOVE);
			}
		}
		return 1;
	}
	Tutorial_Stage(playerid);
	SetTimerEx("Tutorial_CountDown", 1000, false, "i", playerid);
	return 1;
}

Tutorial_Stage(playerid) {
	new szCount[9];
	format(szCount, sizeof(szCount), "%d", GetPVarInt(playerid, "TUT_CNT"));
	if(strval(szCount) == 0) szCount = "Continue";
	switch(GetPVarInt(playerid, "pTut")) {
		case 0:	{
			szMiscArray = "_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "Welcome to NG:RP, an immersive roleplay community that allows you to act out whatever you like.\n");
			strcat(szMiscArray, "Roleplaying can be confusing at first, but is actually very easy!\n");
			strcat(szMiscArray, "To accomplish successful roleplay, act as if your character is living in the real world; restricted to only the possibilities of the real world.\n");
			strcat(szMiscArray, "You can do anything you want, as long as it is possible in real life!\n\n");
			strcat(szMiscArray, "To accomplish proper roleplay, this server utilizes 3 simple commands: {FFFF00}/me, /b and /do{FFFFFF}.\n\n");
			strcat(szMiscArray, "/me allows you to explain an action of your character in third person.\n");
			strcat(szMiscArray, "Proper use would be: {FFF000}/me leans down and grabs a stick.{FFFFFF}\n\n");
			strcat(szMiscArray, "/do allows you to define objects and actions.\n");
			strcat(szMiscArray, "Proper use would be: {FFF000}/do The stick is brown.{FFFFFF}\n\n");
			strcat(szMiscArray, "/b allows you to speak out of character, as if you were talking in real life\n");
			strcat(szMiscArray, "and no longer acting as your in-game character.");
			strcat(szMiscArray, "\n\n\n_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "NG:RP Tutorial", szMiscArray, szCount, "");
		}
		case 1: {
			szMiscArray = "_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "{FF0000}Hacking{FFFFFF}: Using 3rd party modifications to get an advantage above others in-game.\n\n");
			strcat(szMiscArray, "{FF0000}Deathmatching{FFFFFF}: Killing a player(s) without an in-character/roleplay reason.\n\n");
			strcat(szMiscArray, "{FF0000}Killing on Sight (KOS){FFFFFF}: Killing a player without roleplay interaction beforehand.\n\n");
			strcat(szMiscArray, "{FF0000}Metagaming{FFFFFF}: Using out of character information in-character.\n(Ex. character names that haven't been told to you yet.)\n\n");
			strcat(szMiscArray, "{FF0000}Powergaming{FFFFFF}: Performing an action which your character is incapable of performing.\n(Ex. Having god-like abilities or forcing roleplay upon others.)");
			strcat(szMiscArray, "A full list of server offences with their detailed explanation is available at ng-gaming.net\nHere you will also find a full list of In-Character laws.");
			strcat(szMiscArray, "\n\n\n_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "NG:RP - Server Offenses", szMiscArray, szCount, "");
		}
		case 2: {
			szMiscArray = "_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "{FF0000}Entering / Exiting Doors{FFFFFF}: To enter or exit a door, walk up and immediately press N.\n\n");
			strcat(szMiscArray, "{FF0000}Item Interaction{FFFFFF}: To interact with a server item such as an ATM, walk up to it and press Y.\n\n");
			strcat(szMiscArray, "{FF0000}Player Interaction{FFFFFF}: Right click whilst looking at a player and press Y.\nYou can also use /interact to interact with players in vehicles.\n\n");
			strcat(szMiscArray, "{FF0000}Seeking Help{FFFFFF}: You can ask for help over /newb or /requesthelp\nYou can also report for an admin using /report.\n\n");
			strcat(szMiscArray, "A full list of commands is available using /help.");
			strcat(szMiscArray, "\n\n\n_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "NG:RP - Basic Commands", szMiscArray, szCount, "");
		}
		case 3:	{
			szMiscArray = "_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "We wish you a great time here at Next Generation Role Play. You will be taken to the character creation menu now.\n\n");
			strcat(szMiscArray, "\t{F69521}Developers\n");
			strcat(szMiscArray, "\t\t{F69521}Director of Development{FFFFFF}:\n\t\t\tWinterfield\n\n");
			strcat(szMiscArray, "\t\t{F69521}Developers{FFFFFF}:\n\
				\t\t\tMiguel\n\
				\t\t\tJingles\n\
				\t\t\tFarva\n\
				\t\t\t{F69500}Past Developers{FFFFFF}:\n\
				\t\t\tAkatony\tJohn\t\tBrendan\n\
				\t\t\tBrian\t\tScott\t\tGhoulSlayer\n\
				\t\t\tZhao\t\tDonuts\t\tMo Cena\n\
				\t\t\tCalgon\t\tNeo\t\tThomasJWhite\n\
				\t\t\tBeren\t\tKareemtastic\tSew Sumi\n\
				\t\t\tRazbit\t\tAlexR\t\tAustin\n\
				\t\t\tDom\t\tRothschild\n");
			strcat(szMiscArray, "\n\n_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "NG:RP - Server Offenses", szMiscArray, szCount, "");
		}
		case 4:	{
			Tutorial_End(playerid);
			Register_Character(playerid);
		}
	}
}

Tutorial_InitTextDraws()
{
	TutTextDraw[0] = TextDrawCreate(303.000000, 83.000000, "G");
	TextDrawBackgroundColor(TutTextDraw[0], 255);
	TextDrawFont(TutTextDraw[0], 2);
	TextDrawLetterSize(TutTextDraw[0], 0.480000, 1.900000);
	TextDrawColor(TutTextDraw[0], 865730559);
	TextDrawSetOutline(TutTextDraw[0], 1);
	TextDrawSetProportional(TutTextDraw[0], 1);
	TextDrawSetSelectable(TutTextDraw[0], 0);

	TutTextDraw[1] = TextDrawCreate(258.000000, 83.000000, "N");
	TextDrawBackgroundColor(TutTextDraw[1], 255);
	TextDrawFont(TutTextDraw[1], 2);
	TextDrawLetterSize(TutTextDraw[1], 0.399999, 2.000000);
	TextDrawColor(TutTextDraw[1], 865730559);
	TextDrawSetOutline(TutTextDraw[1], 1);
	TextDrawSetProportional(TutTextDraw[1], 1);
	TextDrawSetSelectable(TutTextDraw[1], 0);

	TutTextDraw[2] = TextDrawCreate(271.000000, 86.000000, "ext");
	TextDrawBackgroundColor(TutTextDraw[2], 255);
	TextDrawFont(TutTextDraw[2], 2);
	TextDrawLetterSize(TutTextDraw[2], 0.350000, 1.599999);
	TextDrawColor(TutTextDraw[2], -1);
	TextDrawSetOutline(TutTextDraw[2], 1);
	TextDrawSetProportional(TutTextDraw[2], 1);
	TextDrawSetSelectable(TutTextDraw[2], 0);

	TutTextDraw[3] = TextDrawCreate(317.000000, 86.000000, "eneration");
	TextDrawBackgroundColor(TutTextDraw[3], 255);
	TextDrawFont(TutTextDraw[3], 2);
	TextDrawLetterSize(TutTextDraw[3], 0.299999, 1.500000);
	TextDrawColor(TutTextDraw[3], -1);
	TextDrawSetOutline(TutTextDraw[3], 1);
	TextDrawSetProportional(TutTextDraw[3], 1);
	TextDrawSetSelectable(TutTextDraw[3], 0);

	TutTextDraw[4] = TextDrawCreate(303.000000, 81.000000, "G");
	TextDrawBackgroundColor(TutTextDraw[4], 255);
	TextDrawFont(TutTextDraw[4], 2);
	TextDrawLetterSize(TutTextDraw[4], 0.480000, 1.900000);
	TextDrawColor(TutTextDraw[4], 865730559);
	TextDrawSetOutline(TutTextDraw[4], 1);
	TextDrawSetProportional(TutTextDraw[4], 1);
	TextDrawSetSelectable(TutTextDraw[4], 0);

	TutTextDraw[5] = TextDrawCreate(258.000000, 81.000000, "N");
	TextDrawBackgroundColor(TutTextDraw[5], 255);
	TextDrawFont(TutTextDraw[5], 2);
	TextDrawLetterSize(TutTextDraw[5], 0.399999, 2.000000);
	TextDrawColor(TutTextDraw[5], 865730559);
	TextDrawSetOutline(TutTextDraw[5], 1);
	TextDrawSetProportional(TutTextDraw[5], 1);
	TextDrawSetSelectable(TutTextDraw[5], 0);

	TutTextDraw[6] = TextDrawCreate(271.000000, 84.000000, "ext");
	TextDrawBackgroundColor(TutTextDraw[6], 255);
	TextDrawFont(TutTextDraw[6], 2);
	TextDrawLetterSize(TutTextDraw[6], 0.350000, 1.599999);
	TextDrawColor(TutTextDraw[6], -1);
	TextDrawSetOutline(TutTextDraw[6], 1);
	TextDrawSetProportional(TutTextDraw[6], 1);
	TextDrawSetSelectable(TutTextDraw[6], 0);

	TutTextDraw[7] = TextDrawCreate(317.000000, 84.000000, "eneration");
	TextDrawBackgroundColor(TutTextDraw[7], 255);
	TextDrawFont(TutTextDraw[7], 2);
	TextDrawLetterSize(TutTextDraw[7], 0.299999, 1.500000);
	TextDrawColor(TutTextDraw[7], -1);
	TextDrawSetOutline(TutTextDraw[7], 1);
	TextDrawSetProportional(TutTextDraw[7], 1);
	TextDrawSetSelectable(TutTextDraw[7], 0);

	TutTextDraw[8] = TextDrawCreate(265.000000, 95.000000, "R");
	TextDrawBackgroundColor(TutTextDraw[8], 255);
	TextDrawFont(TutTextDraw[8], 2);
	TextDrawLetterSize(TutTextDraw[8], 0.589999, 3.099999);
	TextDrawColor(TutTextDraw[8], 255);
	TextDrawSetOutline(TutTextDraw[8], 1);
	TextDrawSetProportional(TutTextDraw[8], 1);
	TextDrawSetSelectable(TutTextDraw[8], 0);

	TutTextDraw[9] = TextDrawCreate(265.000000, 96.000000, "R");
	TextDrawBackgroundColor(TutTextDraw[9], 255);
	TextDrawFont(TutTextDraw[9], 2);
	TextDrawLetterSize(TutTextDraw[9], 0.609999, 2.900000);
	TextDrawColor(TutTextDraw[9], 1721368575);
	TextDrawSetOutline(TutTextDraw[9], 1);
	TextDrawSetProportional(TutTextDraw[9], 1);
	TextDrawSetSelectable(TutTextDraw[9], 0);

	TutTextDraw[10] = TextDrawCreate(283.000000, 103.000000, "ole");
	TextDrawBackgroundColor(TutTextDraw[10], 255);
	TextDrawFont(TutTextDraw[10], 2);
	TextDrawLetterSize(TutTextDraw[10], 0.399999, 2.000000);
	TextDrawColor(TutTextDraw[10], -1);
	TextDrawSetOutline(TutTextDraw[10], 1);
	TextDrawSetProportional(TutTextDraw[10], 1);
	TextDrawSetSelectable(TutTextDraw[10], 0);

	TutTextDraw[11] = TextDrawCreate(283.000000, 101.000000, "ole");
	TextDrawBackgroundColor(TutTextDraw[11], 255);
	TextDrawFont(TutTextDraw[11], 2);
	TextDrawLetterSize(TutTextDraw[11], 0.399999, 2.000000);
	TextDrawColor(TutTextDraw[11], -1);
	TextDrawSetOutline(TutTextDraw[11], 1);
	TextDrawSetProportional(TutTextDraw[11], 1);
	TextDrawSetSelectable(TutTextDraw[11], 0);

	TutTextDraw[12] = TextDrawCreate(348.000000, 103.000000, "lay");
	TextDrawBackgroundColor(TutTextDraw[12], 255);
	TextDrawFont(TutTextDraw[12], 2);
	TextDrawLetterSize(TutTextDraw[12], 0.399999, 2.000000);
	TextDrawColor(TutTextDraw[12], -1);
	TextDrawSetOutline(TutTextDraw[12], 1);
	TextDrawSetProportional(TutTextDraw[12], 1);
	TextDrawSetSelectable(TutTextDraw[12], 0);

	TutTextDraw[13] = TextDrawCreate(348.000000, 101.000000, "lay");
	TextDrawBackgroundColor(TutTextDraw[13], 255);
	TextDrawFont(TutTextDraw[13], 2);
	TextDrawLetterSize(TutTextDraw[13], 0.399999, 2.000000);
	TextDrawColor(TutTextDraw[13], -1);
	TextDrawSetOutline(TutTextDraw[13], 1);
	TextDrawSetProportional(TutTextDraw[13], 1);
	TextDrawSetSelectable(TutTextDraw[13], 0);

	TutTextDraw[14] = TextDrawCreate(330.000000, 97.000000, "P");
	TextDrawBackgroundColor(TutTextDraw[14], 255);
	TextDrawFont(TutTextDraw[14], 2);
	TextDrawLetterSize(TutTextDraw[14], 0.609999, 2.900000);
	TextDrawColor(TutTextDraw[14], 255);
	TextDrawSetOutline(TutTextDraw[14], 1);
	TextDrawSetProportional(TutTextDraw[14], 1);
	TextDrawSetSelectable(TutTextDraw[14], 0);

	TutTextDraw[15] = TextDrawCreate(315.000000, 423.000000, "transboxdwn");
	TextDrawAlignment(TutTextDraw[15], 2);
	TextDrawBackgroundColor(TutTextDraw[15], -1);
	TextDrawFont(TutTextDraw[15], 1);
	TextDrawLetterSize(TutTextDraw[15], 0.119998, 3.499999);
	TextDrawColor(TutTextDraw[15], -84215296);
	TextDrawSetOutline(TutTextDraw[15], 0);
	TextDrawSetProportional(TutTextDraw[15], 1);
	TextDrawSetShadow(TutTextDraw[15], 0);
	TextDrawUseBox(TutTextDraw[15], 1);
	TextDrawBoxColor(TutTextDraw[15], 169098265);
	TextDrawTextSize(TutTextDraw[15], 1116.000000, 75.000000);
	TextDrawSetSelectable(TutTextDraw[15], 0);

	TutTextDraw[16] = TextDrawCreate(298.000000, 73.000000, "Welcome to");
	TextDrawBackgroundColor(TutTextDraw[16], 255);
	TextDrawFont(TutTextDraw[16], 2);
	TextDrawLetterSize(TutTextDraw[16], 0.179998, 0.899998);
	TextDrawColor(TutTextDraw[16], -1431655681);
	TextDrawSetOutline(TutTextDraw[16], 0);
	TextDrawSetProportional(TutTextDraw[16], 1);
	TextDrawSetShadow(TutTextDraw[16], 1);
	TextDrawSetSelectable(TutTextDraw[16], 0);

	TutTextDraw[17] = TextDrawCreate(330.000000, 96.000000, "P");
	TextDrawBackgroundColor(TutTextDraw[17], 255);
	TextDrawFont(TutTextDraw[17], 2);
	TextDrawLetterSize(TutTextDraw[17], 0.609999, 2.900000);
	TextDrawColor(TutTextDraw[17], 1721368575);
	TextDrawSetOutline(TutTextDraw[17], 1);
	TextDrawSetProportional(TutTextDraw[17], 1);
	TextDrawSetSelectable(TutTextDraw[17], 0);

	TutTextDraw[18] = TextDrawCreate(379.000000, 76.000000, SERVER_GM_TEXT);
	TextDrawAlignment(TutTextDraw[18], 2);
	TextDrawBackgroundColor(TutTextDraw[18], 255);
	TextDrawFont(TutTextDraw[18], 2);
	TextDrawLetterSize(TutTextDraw[18], 0.179999, 0.899999);
	TextDrawColor(TutTextDraw[18], -65281);
	TextDrawSetOutline(TutTextDraw[18], 0);
	TextDrawSetProportional(TutTextDraw[18], 1);
	TextDrawSetShadow(TutTextDraw[18], 1);
	TextDrawSetSelectable(TutTextDraw[18], 0);

	TutTextDraw[20] = TextDrawCreate(280.000000, 440.000000, "www.ng-gaming.net");
	TextDrawBackgroundColor(TutTextDraw[20], 255);
	TextDrawFont(TutTextDraw[20], 2);
	TextDrawLetterSize(TutTextDraw[20], 0.159999, 0.699998);
	TextDrawColor(TutTextDraw[20], 1150943231);
	TextDrawSetOutline(TutTextDraw[20], 1);
	TextDrawSetProportional(TutTextDraw[20], 1);
	TextDrawSetSelectable(TutTextDraw[20], 0);

	TutTextDraw[21] = TextDrawCreate(292.000000, 423.000000, "NGG");
	TextDrawBackgroundColor(TutTextDraw[21], 255);
	TextDrawFont(TutTextDraw[21], 2);
	TextDrawLetterSize(TutTextDraw[21], 0.539999, 1.899999);
	TextDrawColor(TutTextDraw[21], -1);
	TextDrawSetOutline(TutTextDraw[21], 1);
	TextDrawSetProportional(TutTextDraw[21], 0);
	TextDrawSetSelectable(TutTextDraw[21], 0);

	TutTextDraw[22] = TextDrawCreate(292.000000, 421.000000, "NGG");
	TextDrawBackgroundColor(TutTextDraw[22], 255);
	TextDrawFont(TutTextDraw[22], 2);
	TextDrawLetterSize(TutTextDraw[22], 0.539999, 1.899999);
	TextDrawColor(TutTextDraw[22], 1150943231);
	TextDrawSetOutline(TutTextDraw[22], 1);
	TextDrawSetProportional(TutTextDraw[22], 0);
	TextDrawSetSelectable(TutTextDraw[22], 0);

	TutTextDraw[23] = TextDrawCreate(280.000000, 439.000000, "www.ng-gaming.net");
	TextDrawBackgroundColor(TutTextDraw[23], 255);
	TextDrawFont(TutTextDraw[23], 2);
	TextDrawLetterSize(TutTextDraw[23], 0.159999, 0.699998);
	TextDrawColor(TutTextDraw[23], -1);
	TextDrawSetOutline(TutTextDraw[23], 1);
	TextDrawSetProportional(TutTextDraw[23], 1);
	TextDrawSetSelectable(TutTextDraw[23], 0);
}




/*CMD:register(playerid, params[])
{
	Register_Questions(playerid);
	return 1;
}

Register_Questions(playerid)
{
	SetPlayerPos(playerid, 13.7324, 8.2450, 1620.9706);
	TogglePlayerControllable(playerid, false);
	SetPlayerCameraPos(playerid, 13.7324, 8.2450, 1631.9706);
	SetPlayerCameraLookAt(playerid, 12.9696, 8.8893, 1631.6460);
	ShowPlayerDialogEx(playerid, DIALOG_REGISTER_QUESTIONMAIN, DIALOG_STYLE_MSGBOX, "NG:RP | RolePlay Questions", "\
		\n---------- Next Generation RolePlay | Questions ----------\n\
		\n\
		\n\
		You wil be asked a series of multiple-choice questions. You will be given {FFFF00}three options{FFFFFF}.\n\
		Only one of them is correct.\n\
		\n\
		{FFFF00}Good luck{FFFFFF}!", "Continue", "");
	return 1;
}*/

Register_Character(playerid)
{
	IsSpawned[playerid] = 1;
	PlayAudioStreamForPlayer(playerid, "http://sampweb.ng-gaming.net/dom/fanfare.mp3", 0.0, 0.0, 0.0, 10.0, 0);
	ClearChatbox(playerid);
	SetPlayerPos(playerid, 10.2872, 15.2056, 1620.9647);
	TogglePlayerControllable(playerid, false);
	SetPlayerTime(playerid, 0, 0);
	SetPlayerVirtualWorld(playerid, playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerWeather(playerid, 0);
	SetTimerEx("Register_StartCam", 100, false, "i", playerid);
	SetTimerEx("Register_CreatePlayer", FREEZE_TIME, false, "ii", playerid, 299);
	return 1;
}

Register_GetQuestion(playerid, number)
{
	format(szMiscArray, sizeof(szMiscArray), "Question %d: ", number);
	switch(number)
	{
		case 1:
		{
			strcat(szMiscArray, "What is the correct definition of MetaGaming?", sizeof(szMiscArray));
			SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
			szMiscArray = "\
			1. Mixing in-character and out-of-character chat/information.\n\
			2. A term used to define a character's metadata.\n\
			3. A type of gameplay in this server.";
			SetPVarInt(playerid, "_AnswerKey", 1);
		}
		case 2:
		{
			strcat(szMiscArray, "What is the correct definition of PowerGaming?", sizeof(szMiscArray));
			SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
			szMiscArray = "\
			1. Showing your powers in the '/me' command.\n\
			2. Any action that cannot be done in real life.\n\
			3. I am the Superman.";
			SetPVarInt(playerid, "_AnswerKey", 2);
		}
		case 3:
		{
			strcat(szMiscArray, "What is the correct definition of KOS?", sizeof(szMiscArray));
			SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
			szMiscArray = "\
			1. Killing On Spree.\n\
			2. Killing someone with the '/me' command.\n\
			3. Killing On Sight.";
			SetPVarInt(playerid, "_AnswerKey", 3);
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_REGISTER_QUESTIONMAIN+number, DIALOG_STYLE_LIST, "NG:RP | RolePlay Questions", szMiscArray, "Select", "");
	return 1;
}

Register_ShowQuestion(playerid, number)
{
	switch(number)
	{
		case 999:
		{
			if(GetPVarInt(playerid, "_CorrectAnswers") > 2)
			{
				return Register_Character(playerid);
			}
			else return SendClientMessage(playerid, COLOR_LIGHTRED, "You did not pass the test. Please try again.");
		}
	}
	szMiscArray[0] = 0;
	SendClientMessage(playerid, COLOR_GRAD1, "___________________________________________________");
	format(szMiscArray, sizeof(szMiscArray), "------------- {FFFF00}QUESTION %d/5 {B4B5B7}-------------", number);
	SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
	SendClientMessage(playerid, COLOR_GRAD1, "");
	Register_GetQuestion(playerid, number);
	SendClientMessage(playerid, COLOR_GRAD1, "");
	SendClientMessage(playerid, COLOR_GRAD1, "___________________________________________________");
	return 1;
}

Register_MainMenu(iPlayerID)
{
	new szGender[12];
	SetPVarInt(iPlayerID, PVAR_REGISTERING, 1);
	switch(PlayerInfo[iPlayerID][pSex])
	{
		case 1: szGender = "Male";
		case 2: szGender = "Female";
		default: szGender = "Unspecified";
	}

	format(szMiscArray, sizeof(szMiscArray), "Name:\t%s\n\
		Gender:\t%s\n\
		Date of Birth\t%s\n\
		Nation\t%s\n\
		Accent:\t%s\n\
		----------------------\n\
		Skin ID:\t%i\n\
		----------------------\n\
		Finish character creation", // Setup accessories (3)\n\ (case 6)
		GetPlayerNameEx(iPlayerID),
		szGender,
		PlayerInfo[iPlayerID][pBirthDate],
		GetPlayerNation(iPlayerID),
		GetPlayerAccent(iPlayerID),
		PlayerInfo[iPlayerID][pModel]);
	return ShowPlayerDialogEx(iPlayerID, DIALOG_REGISTER_MENU, DIALOG_STYLE_TABLIST, "NG:RP | Character Creation Menu", szMiscArray, "Select", "");
}

Register_FinishSetup(iPlayerID)
{
	SendClientMessage(iPlayerID, COLOR_LIGHTBLUE, "Congratulations! You finished your character!");
	InterpolateCameraPos(iPlayerID, 9.3954, 14.1742, 1629.3542, 2.1713, 15.4610, 1629.0417, 7000, CAMERA_MOVE);
	InterpolateCameraLookAt(iPlayerID, 8.4057, 14.3070, 1629.2850, 1.1728, 15.4484, 1628.9325, 7000, CAMERA_MOVE);
	ShowPlayerDialogEx(iPlayerID, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Referral System", "Have you been referred to our server by one of our players?\nIf so, please enter the player name below.\n\nIf you haven't been referred by anyone, you may press the skip button.\n\n{FF0000}Note: You must enter the player name with a underscore (Example: FirstName_LastName)", "Enter", "Skip");
	return 1;
}

forward Register_FinishSetup2(iPlayerID);
public Register_FinishSetup2(iPlayerID) {
	PlayerInfo[iPlayerID][pTut] = 1;
	TogglePlayerControllable(iPlayerID, false);
	InterpolateCameraPos(iPlayerID, 2.1713, 15.4610, 1629.0417, -41.5996, 15.2204, 1628.3068, 9000, CAMERA_MOVE);
	InterpolateCameraLookAt(iPlayerID, 1.1728, 15.4484, 1628.9325, -42.5981, 15.2298, 1628.2776, 9000, CAMERA_MOVE);
	SetTimerEx("Register_FinishSetup3", 6000, false, "i", iPlayerID);
	return 1;
}

forward Register_FinishSetup3(iPlayerID);
public Register_FinishSetup3(iPlayerID) {
	new iActorID = GetPVarInt(iPlayerID, "_REGisterActor");
	if(IsValidActor(iActorID)) DestroyActor(iActorID);
	ClearChatbox(iPlayerID);
	Register_Plane(iPlayerID);
	return 1;
}

forward Register_FinishSetup4(playerid);
public Register_FinishSetup4(playerid) 
{
	new iActorID = GetPVarInt(playerid, "_REGisterActor");
	if(IsValidActor(iActorID)) DestroyActor(iActorID);
	ClearChatbox(playerid);
	Register_Prison(playerid);
}


GetPlayerAccent(iPlayerID) {
	new accent[26];
	switch(PlayerInfo[iPlayerID][pAccent]) 	{
		case 0, 1: accent = "";
		case 2: accent = "British accent";
		case 3: accent = "Japanese accent";
		case 4: accent = "Chinese accent";
		case 5: accent = "Korean accent";
		case 6: accent = "Scottish accent";
		case 7: accent = "Irish accent";
		case 8: accent = "Russian accent";
		case 9: accent = "American accent";
		case 10, 12: accent = "Spanish accent";
		case 11: accent = "Southern accent";
		case 13: accent = "Italian accent";
		case 14: accent = "Gangster accent";
		case 15: accent = "Australian accent";
		case 16: accent = "Arabic accent";
		case 17: accent = "Balkan accent";
		case 18: accent = "Canadian accent";
		case 19: accent = "Jamaican accent";
		case 20: accent = "Israeli accent";
		case 21: accent = "Dutch accent";
		case 22: accent = "Brazilian accent";
		case 23: accent = "German accent";
		case 24: accent = "Turkish accent";
		case 25: accent = "Kiwi accent";
		case 26: accent = "French accent";
		case 27: accent = "Korean accent";
		case 28: accent = "Thai accent";
	}
	return accent;
}

forward Register_StartCam(iPlayerID);
public Register_StartCam(iPlayerID) {
	InterpolateCameraPos(iPlayerID, 13.7324, 8.2450, 1631.9706, 9.3954, 14.1742, 1629.3542, 5000, CAMERA_MOVE);
	InterpolateCameraLookAt(iPlayerID, 12.9696, 8.8893, 1631.6460, 8.4057, 14.3070, 1629.2850, 5000, CAMERA_MOVE);
	return 1;
}

forward Register_CreatePlayer(iPlayerID, iSkinID);
public Register_CreatePlayer(iPlayerID, iSkinID) {

	new iActorID;
	if(GetPVarType(iPlayerID, "_REGisterActor")) {

		iActorID = GetPVarInt(iPlayerID, "_REGisterActor");
		if(IsValidActor(iActorID)) DestroyActor(iActorID);
	}
	iActorID = CreateActor(iSkinID, 219.7106,1822.7386,7.5282, 90.0);
	SetPVarInt(iPlayerID, "_REGisterActor", iActorID);
	SetActorVirtualWorld(iActorID, GetPlayerVirtualWorld(iPlayerID));
	SetPlayerSkin(iPlayerID, iSkinID);
	Register_MainMenu(iPlayerID);
	return 1;
}

Register_PlaneStart(playerid)
{
	SetPVarInt(playerid, "pTut", 1);
	Register_Plane(playerid);
	return 1;
}

forward Plane_TogglePlayerControllable(playerid);
public Plane_TogglePlayerControllable(playerid)
{
	SetHealth(playerid, 500.0); // just in case.
	TogglePlayerControllable(playerid, false);
	return 1;
}

Register_Prison(playerid)
{
	Prison_SetPlayerSkin(playerid);
	strcpy(PlayerInfo[playerid][pPrisonReason], "[IC] [DNRL] Prison Gang", 128);
	strcpy(PlayerInfo[playerid][pPrisonedBy], "Winterfield (Script Prison) SIP", 128);
	SendClientMessageEx(playerid, COLOR_GRAD1, "You have chosen to spawn in prison. Use /prisonhelp to view a list of the commands.");
	DeletePVar(playerid, "pTut");
	PlayerInfo[playerid][pJailTime] = 9999999;

	PlayerInfo[playerid][pTut] = 2;
	DeletePVar(playerid, "pTut");

	SetPlayerInterior(playerid, 1);
	PlayerInfo[playerid][pInt] = 1;
	SetPlayerFacingAngle(playerid, 0);
	SendClientMessage(playerid, 0, "");

	PlayerInfo[playerid][pVW] = 0;
	SetPlayerVirtualWorld(playerid, 0);
	SetHealth(playerid, 100);

	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);

	new randcell = random(29);
	PlayerInfo[playerid][pPrisonCell] = randcell;
	SpawnPlayerInPrisonCell(playerid, randcell);
	return 1;
}

forward Register_Plane(playerid);
public Register_Plane(playerid)
{
	switch(GetPVarInt(playerid, "pTut"))
	{
		case 1:	{
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			SetPlayerVirtualWorld(playerid, playerid+1);
			TogglePlayerControllable(playerid, false);
			SetPlayerPos(playerid, 0.6985, 27.5042, 1199.5938);
			SetPlayerInterior(playerid, 1);
			SetPlayerFacingAngle(playerid,354.8517);
			SetPlayerCameraPos(playerid,2.0753,31.0642,1199.6012);
			SetPlayerCameraLookAt(playerid,1.8925,30.6527,1199.5938);
			SetTimerEx("Plane_TogglePlayerControllable", 1000, false, "i", playerid); // just in case
			ApplyAnimation(playerid, "PED","SEAT_down", 4.0, 0, 1, 1, 1, 0, 0);
			ClearChatbox(playerid);
			SendClientMessage(playerid,COLOR_YELLOW,"[INTERCOM] Dear guest,");
			SendClientMessage(playerid,COLOR_YELLOW,"[INTERCOM] We will soon arrive at Los Santos Airport.");
			SendClientMessage(playerid,COLOR_YELLOW,"[INTERCOM] Please fasten your seatbelts, as we will be landing shortly.");
			SendClientMessage(playerid,COLOR_YELLOW,"[INTERCOM] Thank you for travelling with Juank Airlines, and we wish you a pleasant stay in San Andreas.");
			SetPVarInt(playerid, "pTut", 2);
			SetTimerEx("Register_Plane", 15000, false, "i", playerid);
		}
		case 2:	{
			StopAudioStreamForPlayer(playerid);
			PlayAudioStreamForPlayer(playerid, "http://sampweb.ng-gaming.net/dom/plane_part1.mp3", 0.0, 0.0, 0.0, 10.0, 0);
			CreateExplosion(0.6985, 27.5042+10.0, 1199.5938-10.0, 2, 0.1);
			ClearAnimationsEx(playerid);
			ClearChatbox(playerid);
			SendClientMessage(playerid, COLOR_RED,"** ALARMS ARE RINGING **!");
			SendClientMessage(playerid, COLOR_YELLOW,"[INTERCOM] Dear passenger,");
			SendClientMessage(playerid, COLOR_YELLOW,"[INTERCOM] Please do not panic, one of the engines has broken!");
			SendClientMessage(playerid, COLOR_YELLOW,"[INTERCOM] Our pilot has turned on the auto pilot, which gives us a few more minutes in the air!");
			SendClientMessage(playerid, COLOR_YELLOW,"[INTERCOM] Please get out of your seat and walk to the back of the plane.");
			SendClientMessage(playerid, COLOR_RED,"** ALARMS ARE RINGING **!");
			SetPVarInt(playerid, "pTut", 3);
			SetTimerEx("Register_Plane", 8000, false, "i", playerid);
			// cam_CamShakeTimer[playerid] = SetTimerEx("CamShaker", 100, true, "i", playerid);
		}
		case 3: {
			PlayAudioStreamForPlayer(playerid, "http://sampweb.ng-gaming.net/dom/plane_part2.mp3");
		    TogglePlayerControllable(playerid, 1);
			SetCameraBehindPlayer(playerid);
			SetPlayerFacingAngle(playerid, 0.0);
			SetPlayerVirtualWorld(playerid, 100);
			SetPlayerInterior(playerid, 0);
			SetHealth(playerid, 100.0);
			GivePlayerValidWeapon(playerid, 46);
			ClearChatbox(playerid);
		    SendClientMessage(playerid, COLOR_YELLOW,"[INTERCOM] The plane won't be flying for much longer! Jump, quick!!");
		    gPlayerCheckpointStatus[playerid] = CHECKPOINT_REGISTER_PLANE;
			SetPVarInt(playerid, "pTut", -1);
			new h, m, s;
			gettime(h, m, s);
			SetPlayerTime(playerid, h, m);
			SetTimerEx("Tutorial_Checker", 30000, false, "i", playerid);
			h = random(2);
			switch(h) {
				case 0:	{
					SetPVarInt(playerid, "REG_CH", 0);
					SetPlayerPos(playerid, -64.0691, -1502.6654, 1500.7435);
					Player_StreamPrep(playerid, -64.0691, -1502.6654, 1500.7435, FREEZE_TIME);
		 			SetPlayerCheckpoint(playerid, -66.9533, -1452.7920, 1482.3934, 15.0);
				}
				case 1:	{
					SetPVarInt(playerid, "REG_CH", 1);
					SetPlayerPos(playerid,1435.9309,-1102.6654,1500.7435);
					Player_StreamPrep(playerid,1435.9309,-1102.6654,1500.7435, FREEZE_TIME);
		 			SetPlayerCheckpoint(playerid,1433.0467,-1052.792,1482.3934, 15.0);
				}
			}
		}
	}
	return 1;
}

forward Tutorial_Checker(playerid);
public Tutorial_Checker(playerid)
{
	if(!GetPVarType(playerid, PVAR_REGISTERING)) return 1;
	new h = GetPVarInt(playerid, "REG_CH");
	switch(h)
	{
		case 0:
		{
			if(!IsPlayerInRangeOfPoint(playerid, 100.0, -64.0691, -1502.6654, 1500.7435))
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "You have been kicked for tabbing inside the registration process.");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
 			}
		}
		case 1:
		{
			if(!IsPlayerInRangeOfPoint(playerid, 100.0, 1435.9309,-1102.6654,1500.743))
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "You have been kicked for tabbing inside the registration process.");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
	 		}
		}
	}
	SetTimerEx("Tutorial_Checker", 30000, false, "i", playerid);
	return 1;
}

forward CamShaker(playerid);
public CamShaker(playerid) {
	SetPlayerDrunkLevel(playerid, 2001);
	return 1;
}

forward ResetCameraShake(playerid);
public ResetCameraShake(playerid) {
	// KillTimer(cam_CamShakeTimer[playerid]);
	SetPlayerDrunkLevel(playerid, 0);
	return 1;
}

forward Register_Finalize(playerid);
public Register_Finalize(playerid) {
	ResetCameraShake(playerid);
	StopAudioStreamForPlayer(playerid);
	PlayAudioStreamForPlayer(playerid, "http://sampweb.ng-gaming.net/dom/login.mp3");
	ClearChatbox(playerid);
	SetPlayerVirtualWorld(playerid, 0);
	Tutorial_Objectives(playerid);
	return 1;
}

CMD:forcetut(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;
	new uPlayer;
	if(sscanf(params, "u", uPlayer)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /forcetut [playerid / name]");
	SetPVarInt(uPlayer, "pTut", 8);
	Tutorial_Objectives(uPlayer);
	format(szMiscArray, sizeof(szMiscArray),  "You forced %s out of the tutorial.", GetPlayerNameEx(uPlayer));
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	return 1;
}

forward Tutorial_Objectives(playerid);
public Tutorial_Objectives(playerid) {

	PlayerPlaySound(playerid, 2600, 0, 0, 0);
	ClearChatbox(playerid);
	SendClientMessage(playerid, COLOR_YELLOW, "___________ - {FFFFFF}Objective {FFFF00}- ___________");

	switch(GetPVarInt(playerid, "pTut"))
	{
		case 4:
		{
			PlayAudioStreamForPlayer(playerid, "http://sampweb.ng-gaming.net/dom/inception.mp3", 0.0, 0.0, 0.0, 10.0, 0);
			ClearChatbox(playerid);
			SendClientMessage(playerid, COLOR_YELLOW, "___________ - {FFFFFF}Objective {FFFF00}- ___________");
			SendClientMessage(playerid, COLOR_GRAD1, "Objective 1: Buy a car.");
			SendClientMessage(playerid, 0, "");
			SendClientMessage(playerid, COLOR_GRAD2, "Head to the checkpoint to buy your first car.");
			SendClientMessage(playerid, COLOR_GRAD2, "You will be given a temp permit that will last you one day.");
			SendClientMessage(playerid, COLOR_GRAD2, "You will be required to take a driving test later on!");
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_TUTORIAL_CAR;
			switch(GetPVarInt(playerid, "REG_CH"))
			{
				case 0:
				{
					SetPlayerCheckpoint(playerid, 886.0778, -1665.6047, 14.5298, 7.0);
				}
				case 1:
				{
					SetPlayerCheckpoint(playerid, 2155.5925, -1193.7074, 25.1630, 7.0);
				}
			}
		}
		case 5:
		{
			SendClientMessage(playerid, COLOR_GRAD1, "Objective 2: Buy a phone.");
			SendClientMessage(playerid, 0, "");
			SendClientMessage(playerid, COLOR_GRAD2, "Head to the checkpoint to buy your first phone.");
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_TUTORIAL_PHONE;
			for(new businessid; businessid < MAX_BUSINESSES; ++businessid)
			{
				if(Businesses[businessid][bType] == BUSINESS_TYPE_STORE || Businesses[businessid][bType] == BUSINESS_TYPE_GASSTATION)
				{
					if(IsPlayerInRangeOfPoint(playerid, 200.0, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1], Businesses[businessid][bExtPos][2]))
					{
						SetPlayerCheckpoint(playerid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1], Businesses[businessid][bExtPos][2], 7.0);
						return 1;
					}
				}
			}
			SetPlayerCheckpoint(playerid, 1355.1616, -1750.5642, 13.0842, 7.0);
		}
		case 6:
		{
			SendClientMessage(playerid, COLOR_GRAD1, "Objective 3: Visit the bank.");
			SendClientMessage(playerid, 0, "");
			SendClientMessage(playerid, COLOR_GRAD2, "Head to the checkpoint to visit the bank.");
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_TUTORIAL_BANK;
			switch(GetPVarInt(playerid, "REG_CH"))
			{
				case 0:
				{
					SetPlayerCheckpoint(playerid, 1466.3914, -1026.8033, 24.2762, 7.0);
				}
				case 1:
				{
					SetPlayerCheckpoint(playerid, 592.5290, -1237.7844, 18.2457, 7.0);
				}
			}
		}
		case 7:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "___________ - {FFFFFF}Objective {FFFF00}- ___________");
			SendClientMessage(playerid, COLOR_GRAD1, "Objective 4: Get a job.");
			SendClientMessage(playerid, 0, "");
			SendClientMessage(playerid, COLOR_GRAD2, "Select the nearest job and drive there to obtain the job.");
			SendClientMessage(playerid, COLOR_YELLOW, "_______________________________");
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_TUTORIAL_JOB;

			new Float:fPos[6];

			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);

			new j;

			for(new i; i < MAX_JOBPOINTS; ++i) {

				/*
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrJobData[i][job_iTextID][0], E_STREAMER_X, fPos[3]);
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrJobData[i][job_iTextID][0], E_STREAMER_Y, fPos[4]);
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrJobData[i][job_iTextID][0], E_STREAMER_Z, fPos[5]);

				if(GetDistanceBetweenPoints(fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5]) < iRange) smallest = i;
				strcat(szMiscArray, GetJobName(arrJobData[smallest][job_iType]), sizeof(szMiscArray));
				*/

				format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, GetJobName(arrJobData[i][job_iType]));
				ListItemTrackId[playerid][j++] = i;
			}

			ShowPlayerDialogEx(playerid, DIALOG_JOBS_NEAREST, DIALOG_STYLE_LIST, "All Jobs", szMiscArray, "Select", "Cancel");
			return 1;
		}
		case 8:
		{
			SendClientMessage(playerid, COLOR_GRAD1, "You have completed the tutorial!");
			SendClientMessage(playerid, 0, "");
			SendClientMessage(playerid, COLOR_GRAD2, "");
			DeletePVar(playerid, "pTut");
		}
	}
	SendClientMessage(playerid, COLOR_YELLOW, "__________________________________");
	return 1;
}
