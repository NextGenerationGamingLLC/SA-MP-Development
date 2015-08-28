/* Registeration by Jingles */

#define 		REGISTER_MAX_TOYS				(3)

#define 		REGISTER_TOYS					(1339)

#define 		CHECKPOINT_REGISTER_PLANE		(1500)
#define 		CHECKPOINT_TUTORIAL_CAR			(1501)
#define 		CHECKPOINT_TUTORIAL_PHONE		(1502)
#define 		CHECKPOINT_TUTORIAL_BANK		(1503)
#define 		CHECKPOINT_TUTORIAL_JOB			(1504)

#define 		PVAR_REGISTERING				"_REG"

new g_aMaleSkins[185] = {
	1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	30, 32, 33, 34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60,
	61, 62, 66, 68, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102,
	103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
	121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146,
	147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 167, 168, 170, 171, 173, 174, 175, 176,
	177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 200, 202, 203, 204, 206,
	208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 228, 229, 230, 234, 235, 236, 239, 240,
	241, 242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289,
	290, 291, 292, 293, 294, 295, 296, 297, 299
};

new g_aFemaleSkins[77] = {
    9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69,
    75, 76, 77, 85, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 141,
    145, 148, 150, 151, 152, 157, 169, 178, 190, 191, 192, 193, 194, 195,
    196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 219, 224, 225,
    226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263,
    298
};

// new cam_CamShakeTimer[MAX_PLAYERS];
new NewbieVehicles[6];


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
	for(new i; i < sizeof(NewbieVehicles); ++i) DestroyVehicle(NewbieVehicles[i]);
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
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Press ~k~~CONVERSATION_YES~ to use any ATM.");
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Walk up to the banker and press ~k~~CONVERSATION_YES~ to manage your funds.");
			DisablePlayerCheckpoint(playerid);
			SetPVarInt(playerid, "pTut", GetPVarInt(playerid, "pTut") + 1);
			Tutorial_Objectives(playerid);
			return 1;
		}
		case CHECKPOINT_TUTORIAL_JOB:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Use '/getjob' and '/accept job' at the job point to get a job.");
			DisablePlayerCheckpoint(playerid);
			return 1;
		}
	}
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
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
			if(!response) return ShowPlayerDialog(playerid, DIALOG_REGISTER_EXIT, DIALOG_STYLE_MSGBOX, "NG:RP Character Creation | Exit", "Are you sure you would like to exit the character creation menu?\nNote: This will {FF0000}delete {FFFFFF}your data!", "Continue", "Quit");
			switch(listitem)
			{
				case 0: return Register_MainMenu(playerid);
				case 1: return ShowPlayerDialog(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "NG:RP Character Creation | Skin Model", "Male\nFemale", "Select", "<<");
				case 2: return ShowPlayerDialog(playerid, DIALOG_REGISTER_MONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "<<", "Select");
				case 3:
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
					return ShowPlayerDialog(playerid, DIALOG_REGISTER_ACCENT, DIALOG_STYLE_LIST, "NG:RP Character Creation | Accent", szMiscArray, "Select", "<<");
				}
				case 4: return Register_MainMenu(playerid);
				case 5: 
				{
					if(PlayerInfo[playerid][pSex] == 0) { SendClientMessage(playerid, COLOR_YELLOW, "Please select your gender first."); return ShowPlayerDialog(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "NG:RP Character Creation | Skin Model", "Male\nFemale", "Select", "<<"); }
					switch(PlayerInfo[playerid][pSex]) 
					{
	                    case 1: return ShowModelSelectionMenuEx(playerid, g_aMaleSkins, sizeof(g_aMaleSkins), "Skin Model", REGISTER_SKINMODEL, -16.0, 0.0, -55.0);
						case 2: return ShowModelSelectionMenuEx(playerid, g_aFemaleSkins, sizeof(g_aFemaleSkins), "Skin Model", REGISTER_SKINMODEL, -16.0, 0.0, -55.0);
               		}
               	}	
				case 6: return Register_MainMenu(playerid);
				case 7: 
				{
					if(PlayerInfo[playerid][pSex] == 0)
					{
						SendClientMessage(playerid, COLOR_YELLOW, "Please pick a gender.");
						return ShowPlayerDialog(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "NG:RP Character Creation | Skin Model", "Male\nFemale", "Select", "<<");

					}
					if(strcmp(PlayerInfo[playerid][pBirthDate], "0000-00-00") == 0)
					{
						SendClientMessage(playerid, COLOR_YELLOW, "Please specify your birthdate.");
						return ShowPlayerDialog(playerid, DIALOG_REGISTER_MONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Select", "<<");
					}
					else return Register_FinishSetup(playerid);
				}
			}
		}
		case DIALOG_REGISTER_SEX:
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
					PlayerInfo[playerid][pSex] = 1;
					Register_CreatePlayer(playerid, 2);
					SendClientMessage(playerid, COLOR_YELLOW2, "Alright, so you're a male!");
					Register_MainMenu(playerid);
				}
				else if(listitem == 1)
				{
					PlayerInfo[playerid][pSex] = 2;
					SendClientMessage(playerid, COLOR_YELLOW2, "Alright, so you're a female!");
					Register_CreatePlayer(playerid, 91);
					Register_MainMenu(playerid);
				}
			}
			else ShowPlayerDialog(playerid, REGISTERSEX, DIALOG_STYLE_LIST, "{FF0000}Is your character male or female?", "Male\nFemale", "Submit", "");
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
				ShowPlayerDialog(playerid, DIALOG_REGISTER_DAY, DIALOG_STYLE_LIST, "{FF0000}Which day was your character born?", szMiscArray, "Submit", "");
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
				ShowPlayerDialog(playerid, DIALOG_REGISTER_YEAR, DIALOG_STYLE_LIST, "{FF0000}Which year was your character born?", szMiscArray, "Submit", "");
			}
			else ShowPlayerDialog(playerid, DIALOG_REGISTER_MONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
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
				ShowPlayerDialog(playerid, DIALOG_REGISTER_YEAR, DIALOG_STYLE_LIST, "{FF0000}Which year was your character born?", szMiscArray, "Submit", "");
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
		            ShowPlayerDialog(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
		            return 1;
				}
				if(strfind(inputtext, "_", true) == -1)
				{
				    ShowPlayerDialog(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
		            return 1;
		        }
		        if(strlen(inputtext) > 20)
		        {
		            ShowPlayerDialog(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That name is too long\nPlease shorten the name.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
		            return 1;
		        }
		        if(strcmp(inputtext, GetPlayerNameExt(playerid), true) == 0)
		        {
		            ShowPlayerDialog(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error", "You can't add yourself as a referrer.\nPlease enter the referrer name or press 'Skip'.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
		            return 1;
		        }
				for(new sz = 0; sz < strlen(inputtext); sz++)
				{
				    if(inputtext[sz] == ' ')
				    {
					    ShowPlayerDialog(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
			            return 1;
			        }
			    }
			  	mysql_escape_string(inputtext, szMiscArray);
                format(PlayerInfo[playerid][pReferredBy], MAX_PLAYER_NAME, "%s", szMiscArray);
                mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `Username` FROM `accounts` WHERE `Username` = '%e'", inputtext);
         		mysql_function_query(MainPipeline, szMiscArray, true, "OnQueryFinish", "iii", MAIN_REFERRAL_THREAD, playerid, g_arrQueryHandle{playerid});				
			}
			else
			{
			    format(szMiscArray, sizeof(szMiscArray), "Nobody");
				strmid(PlayerInfo[playerid][pReferredBy], szMiscArray, 0, strlen(szMiscArray), MAX_PLAYER_NAME);
				TogglePlayerSpectating(playerid, false);
				SetPlayerHealth(playerid, 1000.0);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Thanks for filling in all the information! Enjoy your time and trip to San Andreas!");
				SetTimerEx("Register_FinishSetup2", 250, false, "i", playerid);
			}
		}
	}
	return 0;
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
	ShowPlayerDialog(playerid, DIALOG_REGISTER_QUESTIONMAIN, DIALOG_STYLE_MSGBOX, "NG:RP | RolePlay Questions", "\
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
	ShowPlayerDialog(playerid, DIALOG_REGISTER_QUESTIONMAIN+number, DIALOG_STYLE_LIST, "NG:RP | RolePlay Questions", szMiscArray, "Select", "");
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
	szMiscArray[0] = 0;
	SetPVarInt(iPlayerID, PVAR_REGISTERING, 1);
	switch(PlayerInfo[iPlayerID][pSex]) 
	{
		case 1: szMiscArray = "Male";
		case 2: szMiscArray = "Female";
		default: szMiscArray = "Unspecified";
	}

	format(szMiscArray, sizeof(szMiscArray), "Name:\t%s\n\
		Gender:\t%s\n\
		Date of Birth\t%s\n\
		Accent:\t%s\n\
		----------------------\n\
		Skin ID:\t%i\n\
		----------------------\n\
		Finish character creation", // Setup accessories (3)\n\ (case 6)
		GetPlayerNameEx(iPlayerID),
		szMiscArray,
		PlayerInfo[iPlayerID][pBirthDate],
		GetPlayerAccent(iPlayerID),
		PlayerInfo[iPlayerID][pModel]);
	return ShowPlayerDialog(iPlayerID, DIALOG_REGISTER_MENU, DIALOG_STYLE_TABLIST, "NG:RP | Character Creation Menu", szMiscArray, "Select", "");
}

Register_FinishSetup(iPlayerID)
{
	SendClientMessage(iPlayerID, COLOR_LIGHTBLUE, "Congratulations! You finished your character!");
	InterpolateCameraPos(iPlayerID, 9.3954, 14.1742, 1629.3542, 2.1713, 15.4610, 1629.0417, 7000, CAMERA_MOVE);
	InterpolateCameraLookAt(iPlayerID, 8.4057, 14.3070, 1629.2850, 1.1728, 15.4484, 1628.9325, 7000, CAMERA_MOVE);
	ShowPlayerDialog(iPlayerID, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Referral System", "Have you been referred to our server by one of our players?\nIf so, please enter the player name below.\n\nIf you haven't been referred by anyone, you may press the skip button.\n\n{FF0000}Note: You must enter the player name with a underscore (Example: FirstName_LastName)", "Enter", "Skip");
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
	iActorID = CreateActor(iSkinID, 6.8941, 15.6016, 1628.8184, 270.0);
	SetPVarInt(iPlayerID, "_REGisterActor", iActorID);
	SetActorVirtualWorld(iActorID, GetPlayerVirtualWorld(iPlayerID));
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
	SetPlayerHealth(playerid, 500.0); // just in case.
	TogglePlayerControllable(playerid, false);
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
			ClearAnimations(playerid);
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
			SetPlayerHealth(playerid, 100.0);
			GivePlayerValidWeapon(playerid, 46, 1);
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
					SetPlayerCheckpoint(playerid, 2128.5925, -1134.7074, 25.1630, 7.0);
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
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Enter the bank and walk up to the banker and press ~k~~CONVERSATION_YES~ to manage your funds.");
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} You can also withdraw funds from an ATM for an extra charge.");
			SendClientMessage(playerid, COLOR_YELLOW, "[Tutorial Objective] - {FFFFFF} Press ~k~~CONVERSATION_YES~ to use any ATM.");
			SendClientMessage(playerid, COLOR_GRAD1, "You have completed the tutorial!");
			SendClientMessage(playerid, 0, "");
			SendClientMessage(playerid, COLOR_GRAD2, "");
			DeletePVar(playerid, "pTut");
		}
		/*case 7:
		{
			SendClientMessage(playerid, COLOR_YELLOW, "___________ - {FFFFFF}Objective {FFFF00}- ___________");
			SendClientMessage(playerid, COLOR_GRAD1, "Objective 4: Get a job.");
			SendClientMessage(playerid, 0, "");
			SendClientMessage(playerid, COLOR_GRAD2, "Head to the checkpoint to get a job.");
			SendClientMessage(playerid, COLOR_YELLOW, "_______________________________");
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_TUTORIAL_JOB;
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
		*/
	}
	SendClientMessage(playerid, COLOR_YELLOW, "__________________________________");	
	return 1;	
}

/*new g_arrNewbieCars[3] = {
	401, 413, 478
};*/

/*CMD:buyfirstcar(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 15.0, 886.0778, -1665.6047, 14.5298) || IsPlayerInRangeOfPoint(playerid, 15.0, 2155.5925, -1193.7074, 25.1630))
	{
		ShowModelSelectionMenuEx(playerid, g_arrNewbieCars, sizeof(g_arrNewbieCars), "Your first car", REGISTER_NEWBIECAR, -16.0, 0.0, -55.0);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not near the cars.");
	return 1;
}*/
