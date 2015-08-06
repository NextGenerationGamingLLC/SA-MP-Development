/* Tutorial by Jingles */

#include <YSI\y_hooks>


#define 		TUTORIAL_STEPS_TIME				30 // in seconds

new Text:TutTextDraw[24];

Tutorial_Start(playerid) {
	IsSpawned[playerid] = 1;
	PlayAudioStreamForPlayer(playerid, "http://jingles.ml/audio/hopereturns.mp3");
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
			ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "NG:RP Tutorial", szMiscArray, szCount, "");
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
			ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "NG:RP - Server Offenses", szMiscArray, szCount, "");
		}
		case 2: {
			szMiscArray = "_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "{FF0000}Entering / Exiting Doors{FFFFFF}: To enter or exit a door, walk up and immediately press F or ENTER.\n\n");
			strcat(szMiscArray, "{FF0000}Item Interaction{FFFFFF}: To interact with a server item such as an ATM, walk up to it and press Y.\n\n");
			strcat(szMiscArray, "{FF0000}Player Interaction{FFFFFF}: Right click whilst looking at a player and press Y.\nYou can also use /interact to interact with players in vehicles.\n");
			strcat(szMiscArray, "{FF0000}Seeking Help{FFFFFF}: You can ask for help over /newb or /requesthelp\nYou can also report for an admin using /report.\n\n");
			strcat(szMiscArray, "A full list of commands is available using /help.");
			strcat(szMiscArray, "\n\n\n_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "NG:RP - Basic Commands", szMiscArray, szCount, "");
		}
		case 3:	{
			szMiscArray = "_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "We wish you a great time here at Next Generation Role Play. You will be taken to the character creation menu now.\n\n");
			strcat(szMiscArray, "\t{F69521}Developers\n");
			strcat(szMiscArray, "\t\t{F69521}Director of Development{FFFFFF}:\n\t\t\tDom\n\n");
			strcat(szMiscArray, "\t\t{F69521}Developers{FFFFFF}:\n\
				\t\t\tMiguel\n\
				\t\t\tJingles\n\
				\t\t\tAlexR\n\
				\t\t\tAustin\n\n\
				\t\t\t{F69500}Past Developers{FFFFFF}:\n\
				\t\t\tAkatony\t\tJohn\t\tBrendan\n\
				\t\t\tBrian\t\tScott\t\tGhoulSlayer\n\
				\t\t\tZhao\t\tDonuts\t\tMo Cena\n\
				\t\t\tCalgon\t\tNeo\t\tThomasJWhite\n\
				\t\t\tBeren\t\tKareemtastic\tSew Sumi\n\
				\t\t\tRazbit\t\tFarva");
			strcat(szMiscArray, "\n\n_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "NG:RP - Server Offenses", szMiscArray, szCount, "");
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

	TutTextDraw[18] = TextDrawCreate(379.000000, 76.000000, "v3.01");
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