#include <YSI\y_hooks>

#define 			PHONE_NAME					"jPhone"

#define 			DIALOG_PHONE_DIAL			9200
#define 			DIALOG_PHONE_CONTACTS		9201
#define 			DIALOG_PHONE_CAMERA			9202
#define 			DIALOG_PHONE_SETTINGS		9203
#define 			DIALOG_PHONE_RINGTONES		9204
#define 			DIALOG_PHONE_RINGTONES2		9205
#define 			DIALOG_PHONE_WALLPAPERS		9206
#define 			DIALOG_PHONE_CONTACTLIST	9207
#define 			DIALOG_PHONE_ADDCONTACT		9208
#define 			DIALOG_PHONE_CONTACTLISTDEL	9209
#define 			DIALOG_PHONE_YPAGES 		9210
#define 			DIALOG_PHONE_BUSINESSES 	9211
#define 			DIALOG_PHONE_BUSINESSES2	9212
#define 			DIALOG_PHONE_PAYPHONES 		9213
#define 			DIALOG_PHONE_ADDCONTACT1 	9214

#define 			MAX_CONTACTS				10
#define 			MAX_RADIOTOWERS				10

#define 			PVAR_PLAYINGRINGTONE		"PH_PR"
#define 			PVAR_PHONEDELCONTACT		"PH_DC"

enum eRadioTowerData {
	rt_szName[16],
	rt_iObjectID,
	rt_iAreaID
};
new arrRadioTowerData[MAX_RADIOTOWERS][eRadioTowerData];

new szPhoneWP[][] = {
	"LD_DUAL:Health",
	"splash1:splash1",
	"splash2:splash2",
	"NGRP:background",
	"load0uk:load0uk",
	"loadsc1:loadsc1",
	"loadsc2:loadsc2",
	"loadsc3:loadsc3",
	"loadsc4:loadsc4",
	"loadsc5:loadsc5",
	"loadsc6:loadsc6",
	"loadsc7:loadsc7",
	"loadsc8:loadsc8",
	"loadsc9:loadsc9",
	"loadsc10:loadsc10",
	"loadsc11:loadsc11",
	"loadsc12:loadsc12",
	"loadsc13:loadsc13",
	"loadsc14:loadsc14",
	"LD_BUM:bum1",
	"LD_BUM:bum2",
	"LD_DUAL:backgnd",
	"ld_grav:sky"
};

new iPhoneRingTone[] = {
	1062, // SOUND_GOGO_TRACK_START
	1068, // SOUND_DUAL_TRACK_START
	1076, // SOUND_BEE_TRACK_START
	1097, // SOUND_AWARD_TRACK_START
	1183, // SOUND_DRIVING_AWARD_TRACK_START
	1185, // SOUND_BIKE_AWARD_TRACK_START
	1187, // SOUND_PILOT_AWARD_TRAC_START
};

// new Text:PhoneTD[43];

timer Phone_StopRingtone[5000](iPlayerID) {

	PlayerPlaySound(iPlayerID, 1188, 0.0, 0.0, 0.0);
	return 1;
}

hook OnGameModeInit() {

	Phone_InitRadioTowers();
}

hook OnPlayerConnect(playerid) {

	Phone_InitTD(playerid);
}

hook OnPlayerDisconnect(playerid, reason) {

	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][0]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][1]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][2]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][3]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][4]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][5]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][6]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][7]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][8]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][9]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][10]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][11]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][12]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][13]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][14]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][15]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][16]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][17]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][18]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][19]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][20]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][21]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][22]);
	PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][23]);

	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][0]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][1]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][2]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][3]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][4]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][5]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][6]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][7]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][8]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][9]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][10]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][11]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][12]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][13]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][14]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][15]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][16]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][17]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][18]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][19]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][20]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][21]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][22]);
	PlayerTextDrawDestroy(playerid, phone_PTextDraw[playerid][23]);
	return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys == KEY_YES) {

		if(Bit_State(arrPlayerBits[playerid], phone_bitState)) {
			new iPMenuItem = GetPVarInt(playerid, "PMenuItem");
			if(iPMenuItem != 0) {
				SetPVarInt(playerid, "PMenuItem", iPMenuItem-1);
				PlayerTextDrawBoxColor(playerid, phone_PTextDraw[playerid][12 + iPMenuItem-1], 0x22222266);
				PlayerTextDrawBoxColor(playerid, phone_PTextDraw[playerid][12 + iPMenuItem], 0xFFFFFF00);
				PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][12 + iPMenuItem-1]);
				PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][12 + iPMenuItem]);
				PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][12 + iPMenuItem-1]);
				PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][12 + iPMenuItem]);
			}
		}
	}
	if(newkeys == KEY_NO) {

		if(Bit_State(arrPlayerBits[playerid], phone_bitState)) {
			new iPMenuItem = GetPVarInt(playerid, "PMenuItem");
			if(iPMenuItem < 8) { // max menu item
				SetPVarInt(playerid, "PMenuItem", GetPVarInt(playerid, "PMenuItem")+1);
				PlayerTextDrawBoxColor(playerid, phone_PTextDraw[playerid][12 + iPMenuItem+1], 0x22222266);
				PlayerTextDrawBoxColor(playerid, phone_PTextDraw[playerid][12 + iPMenuItem], 0xFFFFFF00);
				PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][12 + iPMenuItem+1]);
				PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][12 + iPMenuItem]);
				PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][12 + iPMenuItem+1]);
				PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][12 + iPMenuItem]);
			}
		}
	}
	if(newkeys & KEY_SPRINT) {
		if(Bit_State(arrPlayerBits[playerid], phone_bitState)) {
			Phone_SelectMenu(playerid);
		}
	}
	if(newkeys & KEY_ANALOG_RIGHT) {

		if(Bit_State(arrPlayerBits[playerid], phone_bitCamState)) {

			new Float:fPos[4],
				Float:fCam[2];

		    GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
		    //GetPlayerFacingAngle(playerid, fPos[3]);

		    if(!GetPVarType(playerid, "Flt")) GetPlayerFacingAngle(playerid, fPos[3]);
		    fPos[3] = GetPVarFloat(playerid, "Flt");
		    if(fPos[3] >= 360) fPos[3] = 0;
		    fPos[3] += 1.25;
		    fCam[0] = fPos[0] + 1.4 * floatcos(fPos[3], degrees);
		    fCam[1] = fPos[1] + 1.4 * floatsin(fPos[3], degrees);
		    SetPlayerCameraPos(playerid, fCam[0], fCam[1], fPos[2] + 0.9);
		    SetPlayerCameraLookAt(playerid, fPos[0], fPos[1], fPos[2] + 0.9);
		    SetPlayerFacingAngle(playerid, fPos[3] - 90.0);
		    SetPVarFloat(playerid, "Flt", fPos[3]);
		}
	}
	if(newkeys & KEY_ANALOG_LEFT)
	{
		if(Bit_State(arrPlayerBits[playerid], phone_bitCamState)) {

			new Float:fPos[4],
				Float:fCam[2];

		    GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
		    GetXYInFrontOfPlayer(playerid, fPos[0], fPos[1], -0.25);
		    // GetPlayerFacingAngle(playerid, fPos[3]);

		    if(!GetPVarType(playerid, "Flt")) GetPlayerFacingAngle(playerid, fPos[3]);
		    fPos[3] = GetPVarFloat(playerid, "Flt");
		    if(fPos[3] >= 360) fPos[3] = 0;

		    fPos[3] -= 1.25;
		    fCam[0] = fPos[0] + 1.4 * floatcos(fPos[3], degrees);
		    fCam[1] = fPos[1] + 1.4 * floatsin(fPos[3], degrees);
		    SetPlayerCameraPos(playerid, fCam[0], fCam[1], fPos[2] + 0.9);
		    SetPlayerCameraLookAt(playerid, fPos[0], fPos[1], fPos[2] + 0.9);
		    SetPlayerFacingAngle(playerid, fPos[3] - 90.0);
		    SetPVarFloat(playerid, "Flt", fPos[3]);
		}
	}
	return 1;
}

Phone_SelectMenu(playerid) {

	new iPMenuItem = GetPVarInt(playerid, "PMenuItem");
	PlayerTextDrawBoxColor(playerid, phone_PTextDraw[playerid][12 + iPMenuItem], 0x00000000);
	switch(iPMenuItem) {
		case 0: Phone_Call(playerid);
		case 1: Phone_Contacts(playerid);
		case 2: Phone_Events(playerid);
		case 3: Phone_Ads(playerid);
		case 4: Phone_Music(playerid);
		case 5: Phone_SAN(playerid);
		case 6: Phone_Map(playerid);
		case 7: Phone_Camera(playerid);
		case 8: Phone_Settings(playerid);
	}
	Phone_Main(playerid);
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_PHONE_COLOR:
		{
			if(response)
			{
				PlayerInfo[playerid][pPhoneColor] = listitem;
			}
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Use /phone to access your phone. {BBBBBB}(Use /pcl to get the mouse cursor back when accidentally cancelling your interaction.)");
			return 1;
		}
		case DIALOG_PHONE_DIAL:
		{
			if(!response) return 1;
			if(isnull(inputtext)) return 1;
			cmd_call(playerid, inputtext);
			return 1;
		}
		case DIALOG_PHONE_PAYPHONES: {

			cmd_call(playerid, arrPayPhoneData[ListItemTrackId[playerid][listitem]][pp_iNumber]);
			return 1;
		}
		case DIALOG_PHONE_CONTACTS:
		{
			if(!response) return DeletePVar(playerid, PVAR_PHONEDELCONTACT), 1;
			switch(listitem)
			{
				case 0: ShowPlayerDialogEx(playerid, DIALOG_PHONE_YPAGES, DIALOG_STYLE_TABLIST_HEADERS, "Yellow Pages", "Name\tPhone Number\n\
					--> Businesses\tMENU ->\n\
					Government - City Hall/White House\t1-800-4444\n\
					SA News\t1-800-1800\n\
					BubbaGump Fish 'n Shrimps Shipment Service\t1-800-6666\n\
					Frontier Transportation Services\t1-800-8080\n\
					San Andreas Towing and Repossession\t1-800-1111\n\
					San Andreas Prison Service\t18001020\n\
					Farva Car Repair Co.\t1-800-2232 ", "Select", "Cancel");

				case 1: {

					szMiscArray[0] = 0;

					new x,
						szZone[MAX_ZONE_NAME];

					szMiscArray[0] = 0;
					szMiscArray = "Area Code\tNumber\tZone\n";
					for(new i = 0; i < MAX_PAYPHONES; ++i) {

						if(IsValidDynamicArea(arrPayPhoneData[i][pp_iAreaID])) {

							szZone[0] = 0;
							GetPhoneZone(i, szZone, sizeof(szZone));
							format(szMiscArray, sizeof(szMiscArray), "%sArea: %d\tNumber: %d\tZone: %s\n", szMiscArray, GetPhoneAreaCode(i), arrPayPhoneData[i][pp_iNumber], szZone);
							ListItemTrackId[playerid][x] = arrPayPhoneData[i][pp_iNumber];
							x++;
						}
					}
					if(isnull(szMiscArray)) return SendClientMessageEx(playerid, COLOR_GRAD1, "There are no pay phones.");
					ShowPlayerDialogEx(playerid, DIALOG_PHONE_PAYPHONES, DIALOG_STYLE_TABLIST_HEADERS, "Pay Phones", szMiscArray, "Call", "Cancel");
				}
				case 2:	{

					mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `phone_contacts` WHERE id = '%d'", GetPlayerSQLId(playerid));
					mysql_tquery(MainPipeline, szMiscArray, "Phone_OnGetContacts", "i", playerid);
				}
				case 3: ShowPlayerDialogEx(playerid, DIALOG_PHONE_ADDCONTACT, DIALOG_STYLE_INPUT, "Phone | Add Contact", "Please enter the name of the contact you would like to add.\nExample: Sugar Daddy", "Add", "<<");
				case 4: {

					SetPVarInt(playerid, PVAR_PHONEDELCONTACT, 1);
					mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `phone_contacts` WHERE id = '%d'", GetPlayerSQLId(playerid));
					mysql_tquery(MainPipeline, szMiscArray, "Phone_OnGetContacts", "i", playerid);
				}
			}
		}
		case DIALOG_PHONE_YPAGES: {

			if(!response) return Phone_Contacts(playerid), 1;
			switch(listitem) {

				case 0: {

					return ShowPlayerDialogEx(playerid, DIALOG_PHONE_BUSINESSES, DIALOG_STYLE_LIST, "Yellow Pages | Businesses", "\
						24/7\n\
						Clothing Stores\n\
						Restaurants\n\
						Bars\n\
						Gun Stores\n\
						Petrol Stations\n\
						Car Dealerships\n\
						Clubs", "Select", "Back");
				}
				case 1: cmd_call(playerid, "18004444");
				case 2: cmd_call(playerid, "18001800");
				case 3: cmd_call(playerid, "1738");
				case 4: cmd_call(playerid, "18008080");
				case 5: cmd_call(playerid, "18001111");
				case 6: cmd_call(playerid, "18001020");
				case 7: cmd_service(playerid, "mechanic");
			}

		}
		case DIALOG_PHONE_BUSINESSES: {

			if(!response) {

				return ShowPlayerDialogEx(playerid, DIALOG_PHONE_YPAGES, DIALOG_STYLE_TABLIST_HEADERS, "Yellow Pages", "Name\tPhone Number\n\
					--> Businesses\tMENU ->\n\
					SA News\t1-800-1800\n\
					Government - City Hall/White House\t1-800-4444\n\
					BubbaGump Fish 'n Shrimps Shipment Service\t1-800-6666\n\
					Frontier Transportation Services\t1-800-8080\n\
					San Andreas Towing and Repossession\t1-800-1111\n\
					San Andreas Prison Service\t1-800-1020\n\
					Farva Car Repair Co.\t1-800-2232 ", "Select", "Cancel");

			}

			Phone_Businesses(playerid, listitem);
			return 1;
		}
		case DIALOG_PHONE_BUSINESSES2: {

			if(!response) {

				return ShowPlayerDialogEx(playerid, DIALOG_PHONE_BUSINESSES, DIALOG_STYLE_LIST, "Yellow Pages | Businesses", "\
					24/7\n\
					Clothing Stores\n\
					Restaurants\n\
					Bars\n\
					Gun Stores\n\
					Petrol Stations\n\
					Car Dealerships\n\
					Clubs", "Select", "Back");
			}

			new id = ListItemTrackId[playerid][listitem];

			SetPVarInt(playerid, "BUSICALL", id);
			cmd_call(playerid, "000000");
			return 1;
		}
		case DIALOG_PHONE_CONTACTLIST:
		{
			if(!response) return DeletePVar(playerid, PVAR_PHONEDELCONTACT), Phone_Contacts(playerid), 1;
			format(szMiscArray, sizeof(szMiscArray), "%d", ListItemTrackId[playerid][listitem]);
			cmd_call(playerid, szMiscArray);
			return 1;
		}
		case DIALOG_PHONE_ADDCONTACT:
		{
			if(!response) return Phone_Contacts(playerid);
			SetPVarString(playerid, "PHN_CONTACT", inputtext);
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `phone_contacts` WHERE id = '%d'", GetPlayerSQLId(playerid));
			mysql_tquery(MainPipeline, szMiscArray, "Phone_CheckContacts", "is", playerid, inputtext);
			DeletePVar(playerid, PVAR_PHONEDELCONTACT);
		}
		case DIALOG_PHONE_ADDCONTACT1: {

			if(!response) {
				DeletePVar(playerid, "PHN_CONTACT");
				Phone_Contacts(playerid);
				return 1;
			}

			szMiscArray[0] = 0;
			GetPVarString(playerid, "PHN_CONTACT", szMiscArray, sizeof(szMiscArray));
			if(strlen(szMiscArray) > 16) {
				SendClientMessage(playerid, COLOR_YELLOW, "[PHONE] {DDDDDD} The name was too long. Please try again.");
				return ShowPlayerDialogEx(playerid, DIALOG_PHONE_ADDCONTACT1, DIALOG_STYLE_INPUT, "Add Contact | Number", "Please enter the number of the contact you would like to add.", "Add", "Cancel");
			}
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `phone_contacts` (id, `contactname`, `contactnr`) VALUES ('%d', '%e', '%d')", GetPlayerSQLId(playerid), szMiscArray, strval(inputtext));
			mysql_tquery(MainPipeline, szMiscArray, "Phone_OnAddContactFinish", "i", playerid);
			return 1;
		}
		case DIALOG_PHONE_CONTACTLISTDEL:
		{
			if(!response) return DeletePVar(playerid, PVAR_PHONEDELCONTACT), Phone_Contacts(playerid), 1;
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `phone_contacts` WHERE id = '%d' AND `contactnr` = '%d'", GetPlayerSQLId(playerid), ListItemTrackId[playerid][listitem]);
			mysql_tquery(MainPipeline, szMiscArray, "Phone_OnDeleteContact", "i", playerid);

		}
		case DIALOG_PHONE_CAMERA:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0: cmd_picture(playerid, "");
				case 1: cmd_selfie(playerid, "");
				case 2: cmd_selfie(playerid, "");
			}
		}
		case DIALOG_PHONE_SETTINGS:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialogEx(playerid, DIALOG_PHONE_RINGTONES, DIALOG_STYLE_LIST, "Phone | Ringtones", "\
							Go Go Track!\n\
							Dual Dual!\n\
							Bee Bees\n\
							So many awards!\n\
							Drive with me\n\
							While cycling\n\
							I'm a pilot", "Select", "<<");
				}
				case 1:
				{
					Phone_WallPaperMenu(playerid);
				}
			}
		}
		case DIALOG_PHONE_RINGTONES:
		{
			if(!response) Phone_Settings(playerid);
			PlayerPlaySound(playerid, iPhoneRingTone[listitem], 0.0, 0.0, 0.0);
			SetPVarInt(playerid, PVAR_PLAYINGRINGTONE, listitem);
			ShowPlayerDialogEx(playerid, DIALOG_PHONE_RINGTONES2, DIALOG_STYLE_MSGBOX, "Phone | Ringtones | Preview", "Press 'Select' to confirm.\nPress 'Cancel' to cancel.", "Select", "Cancel");
		}
		case DIALOG_PHONE_RINGTONES2:
		{
			PlayerPlaySound(playerid, iPhoneRingTone[GetPVarInt(playerid, PVAR_PLAYINGRINGTONE)]+1, 0.0, 0.0, 0.0);
			if(!response) return DeletePVar(playerid, PVAR_PLAYINGRINGTONE), 1;
			PlayerInfo[playerid][pRingtone] = GetPVarInt(playerid, PVAR_PLAYINGRINGTONE);
			DeletePVar(playerid, PVAR_PLAYINGRINGTONE);
			Phone_Settings(playerid);
		}
		case DIALOG_PHONE_WALLPAPERS:
		{
			if(!response) {
				Phone_Settings(playerid);
				return 1;
			}
			PlayerInfo[playerid][pWallpaper] = listitem;
			Phone_ShowWallPaper(playerid, listitem);
			Phone_Settings(playerid);
		}
	}
	return 0;
}


Phone_Businesses(playerid, btype)
{
	szMiscArray[0] = 0;
	new szStatus[20],
		j;
	switch(btype)
	{
		case 0:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_STORE)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} CLOSED";
						case 1: szStatus = "{00FF00} OPEN";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
		}
		case 1:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_CLOTHING)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} CLOSED";
						case 1: szStatus = "{00FF00} OPEN";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
		}
		case 2:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_RESTAURANT)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} CLOSED";
						case 1: szStatus = "{00FF00} OPEN";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "There are none.");
		}
		case 3:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_BAR)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} CLOSED";
						case 1: szStatus = "{00FF00} OPEN";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "There are none.");
		}
		case 4:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_GUNSHOP)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} CLOSED";
						case 1: szStatus = "{00FF00} OPEN";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "There are none.");
		}
		case 5:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_GASSTATION)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} CLOSED";
						case 1: szStatus = "{00FF00} OPEN";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "There are none.");
		}
		case 6:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} CLOSED";
						case 1: szStatus = "{00FF00} OPEN";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "There are none.");
		}
		case 7:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_CLUB)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} CLOSED";
						case 1: szStatus = "{00FF00} OPEN";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "There are none.");
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_PHONE_BUSINESSES2, DIALOG_STYLE_TABLIST, "San Andreas | Map | Businesses", szMiscArray, "Select", "Back");
	return 1;
}

Phone_InitRadioTowers() {

	strcat(arrRadioTowerData[0][rt_szName], "Flint County", 16);
	arrRadioTowerData[0][rt_iObjectID] = CreateDynamicObject(16335, -908.49377, -984.00830, 126.67799,   0.00000, 0.00000, 200.00000);

	strcat(arrRadioTowerData[1][rt_szName], "Verdant Bluffs", 16);
	arrRadioTowerData[1][rt_iObjectID] = CreateDynamicObject(16335, 1497.64832, -2018.86731, 30.01224,   0.00000, 0.00000, 61.46917);

	strcat(arrRadioTowerData[2][rt_szName], "Red County", 16);
	arrRadioTowerData[2][rt_iObjectID] = CreateDynamicObject(16335, 1518.65039, 343.89783, 17.42963,   0.00000, 0.00000, 358.23730);

	strcat(arrRadioTowerData[3][rt_szName], "Whetstone", 16);
	arrRadioTowerData[3][rt_iObjectID] = CreateDynamicObject(16335, -2216.93042, -2241.66577, 29.16674,   0.00000, 0.00000, 109.12535);

	strcat(arrRadioTowerData[4][rt_szName], "San Fierro", 16);
	arrRadioTowerData[4][rt_iObjectID] = CreateDynamicObject(16335, -2503.39893, -702.40356, 137.81853,   0.00000, 0.00000, 333.25677);

	new Float:fPos[3];
	for(new i; i < MAX_RADIOTOWERS; ++i)
	{
		if(IsValidDynamicObject(arrRadioTowerData[i][rt_iObjectID]))
		{
			GetDynamicObjectPos(arrRadioTowerData[i][rt_iObjectID], fPos[0], fPos[1], fPos[2]);
			arrRadioTowerData[i][rt_iAreaID] = CreateDynamicCircle(fPos[0], fPos[1], 3000.0);
		}
	}
}

CMD:trace(playerid, params[]) {

	if(Bit_State(arrPlayerBits[playerid], phone_bitTraceState)) {

		DisablePlayerCheckpoint(playerid);
		GangZoneDestroy(GetPVarInt(playerid, "PTR_GZ"));
		DeletePVar(playerid, "PTR_GZ");
		Bit_Off(arrPlayerBits[playerid], phone_bitTraceState);
		return SendClientMessageEx(playerid, COLOR_GRAD1, "[Phone]: Quit GPS traceroute process. All geographical data has been deleted.");
	}

	if(PlayerInfo[playerid][pJob] != 1 && PlayerInfo[playerid][pJob2] != 1 && PlayerInfo[playerid][pJob3] != 1) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You're not a detective.");
	}
	if(gettime() < UsedFind[playerid]) { // || FindTimePoints[playerid] == 0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You've already searched for someone - wait a little.");
	}

	new iNumber;

	if(sscanf(params, "d", iNumber)) return SendClientMessage(playerid, COLOR_GRAD1, "Usage: /trace [player's phone number]");

	if(iNumber == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid number.");

	foreach(new i : Player)	{

		if(PlayerInfo[i][pPnumber] == iNumber) {

			if(GetPlayerInterior(i) != 0)
				return SendClientMessageEx(playerid, COLOR_GREY, "That person is inside an interior.");

			if((PlayerInfo[i][pAdmin] >= 2 || PlayerInfo[i][pWatchdog] >= 2) && PlayerInfo[i][pTogReports] != 1)
				return SendClientMessageEx(playerid, COLOR_GREY, "You are unable to find this person.");

			if(GetPVarInt(playerid, "_SwimmingActivity") >= 1)
				return SendClientMessageEx(playerid, COLOR_GRAD2, "You are unable to find people while swimming.");

			if(PhoneOnline[i] == 0) {

				switch(PlayerInfo[playerid][pDetSkill]) {

					case 0 .. 50: {
						FindTimePoints[playerid] = 4;
						UsedFind[playerid] = gettime()+120;
					}
					case 51 .. 100: {
						FindTimePoints[playerid] = 6;
						UsedFind[playerid] = gettime()+90;
					}
					case 101 .. 200: {
						FindTimePoints[playerid] = 8;
						UsedFind[playerid] = gettime()+60;
					}
					case 201 .. 400: {
						FindTimePoints[playerid] = 10;
						UsedFind[playerid] = gettime()+30;
					}
					default: {
						FindTimePoints[playerid] = 12;
						UsedFind[playerid] = gettime()+15;
					}
				}
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot get a trace on this person.");

			Bit_On(arrPlayerBits[playerid], phone_bitTraceState);
			SetPVarInt(playerid, "TRC_STP", 0);
			Phone_Trace(playerid, i);
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_GRAD1, "No active phone was detected with this number.");
	return 1;
}

forward Phone_Trace(playerid, i);
public Phone_Trace(playerid, i)
{
	if(!GetPVarType(playerid, "TRC_STP")) return 1;

	new x = GetPVarInt(playerid, "TRC_STP"),
		szStrength[16],
		Float:fPos[2][3];

	GetPVarString(playerid, "TRC_STR", szMiscArray, sizeof(szMiscArray));

	GetPlayerPos(i, fPos[0][0], fPos[0][1], fPos[0][2]);

	if(x == 0) format(szMiscArray, sizeof(szMiscArray), "{DDDDDD}Target specified: %d\nGPS Traceroute in progress...\n______________________________________\n\n", PlayerInfo[i][pPnumber]);

	if(IsPlayerInDynamicArea(x, arrRadioTowerData[x][rt_iAreaID]))
	{
		GetDynamicObjectPos(arrRadioTowerData[x][rt_iObjectID], fPos[1][0], fPos[1][1], fPos[1][2]);

		new fDistance = floatround(GetDistanceBetweenPoints(fPos[0][0], fPos[0][1], fPos[0][2], fPos[1][0], fPos[1][1], fPos[1][2]), floatround_round);

		switch(fDistance)
		{
			case 2501 .. 3000: szStrength = "{FF0000}Weak";
			case 1501 .. 2500: szStrength = "{FFFF00}Average";
			case 0 .. 1500: szStrength = "{00FF00}Good";
		}
	}
	else szStrength = "{FF0000}NONE";

	if(!IsValidDynamicObject(arrRadioTowerData[x][rt_iObjectID]))
	{
		new szZone[MAX_ZONE_NAME],
			iGZID = GangZoneCreate(fPos[0][0] - 100.0, fPos[0][1] - 100.0, fPos[0][0] + 100.0, fPos[0][1] + 100.0);

		GetPlayer3DZone(i, szZone, MAX_ZONE_NAME);
		SetPVarInt(playerid, "PTR_GZ", iGZID);

		GangZoneShowForPlayer(playerid, iGZID, COLOR_RED);
		GangZoneFlashForPlayer(playerid, iGZID, COLOR_YELLOW);


		format(szMiscArray, sizeof(szMiscArray), "%s\n\
			\n_____________________________________\n\n\
			{FFFFFF}%d's position has been determined: {FFFF00}%s.", szMiscArray, PlayerInfo[i][pPnumber], arrRadioTowerData[x][rt_szName]);
		ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Trace Number", szMiscArray, "-----", "");
		SendClientMessage(playerid, COLOR_YELLOW, "Use /trace again to stop tracing the number.");
		DeletePVar(playerid, "TRC_STP");
		DeletePVar(playerid, "TRC_STR");

		SetPlayerMarkerForPlayer(playerid, i, FIND_COLOR);
		GetPlayer3DZone(i, szZone, sizeof(szZone));
		format(szMiscArray, sizeof(szMiscArray), "%s has been last seen at %s.", GetPlayerNameEx(i), szZone);
		SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
		FindingPlayer[playerid] = i;
		FindTime[playerid] = 1;

		if(PlayerInfo[playerid][pDoubleEXP] > 0) {

			format(szMiscArray, sizeof(szMiscArray), "You have gained 2 detective skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			PlayerInfo[playerid][pDetSkill] += 2;
		}
		else ++PlayerInfo[playerid][pDetSkill];

		switch(PlayerInfo[playerid][pDetSkill]) {
			case 50: SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Detective Skill is now Level 2, you can find a little faster.");
			case 100: SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Detective Skill is now Level 3, you can find a little faster.");
			case 200: SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Detective Skill is now Level 4, you can find a little faster.");
			case 400: SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Detective Skill is now Level 5, you can find a little faster.");
		}

		return 1;
	}
	else
	{
		format(szMiscArray, sizeof(szMiscArray), "%sRetrieving %d's cellular data from the %s tower \t|\t Signal: %s.{DDDDDD}\n\n", szMiscArray, PlayerInfo[playerid][pPnumber], arrRadioTowerData[x][rt_szName], szStrength);
		ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Trace Number", szMiscArray, "Tracing...", "");
	}
	SetPVarString(playerid, "TRC_STR", szMiscArray);
	SetPVarInt(playerid, "TRC_STP", x + 1);
	SetTimerEx("Phone_Trace", 1000, false, "ii", playerid, i);
	return 1;
}


forward Phone_OnGetContacts(iPlayerID);
public Phone_OnGetContacts(iPlayerID)
{
	new iRows;
	cache_get_row_count(iRows);
	if(!iRows) return SendClientMessage(iPlayerID, COLOR_GRAD1, "You do not have any contacts.");

	new idx,
		iNumber,
		szResult[64];
	szMiscArray[0] = 0;
	szMiscArray = "Name\tNumber";

	while(idx < iRows)
	{
		cache_get_value_name_int(idx, "contactnr", iNumber);
		if(iNumber != 0) {

			cache_get_value_name(idx, "contactname", szResult);
			/*
			foreach(new i : Player) {

				if(PlayerInfo[i][pPnumber] == iNumber) format(szResult, sizeof(szResult), "{00FF00}[O] {FFFFFF}%s", szResult);
				else format(szResult, sizeof(szResult), "{FF0000}[O] {FFFFFF}%s", szResult);
			}
			*/
			ListItemTrackId[iPlayerID][idx] = iNumber;
			format(szMiscArray, sizeof(szMiscArray), "%s\n%s\t%d", szMiscArray, szResult, iNumber);
		}
		idx++;
	}
	if(GetPVarType(iPlayerID, PVAR_PHONEDELCONTACT)) return ShowPlayerDialogEx(iPlayerID, DIALOG_PHONE_CONTACTLISTDEL, DIALOG_STYLE_TABLIST_HEADERS, "Phone | Delete Contact", szMiscArray, "Delete", "<<");
	ShowPlayerDialogEx(iPlayerID, DIALOG_PHONE_CONTACTLIST, DIALOG_STYLE_TABLIST_HEADERS, "Phone | Contact List", szMiscArray, "Call", "<<");
	return 1;
}

forward Phone_OnAddContactFinish(iPlayerID);
public Phone_OnAddContactFinish(iPlayerID)
{
	if(mysql_errno()) return Phone_Contacts(iPlayerID), SendClientMessage(iPlayerID, COLOR_GRAD1, "Something went wrong. Please try again later.");
	SendClientMessage(iPlayerID, COLOR_YELLOW, "[PHONE] {DDDDDD} You have successfully added a new contact.");
	Phone_Contacts(iPlayerID);
	return 1;
}

forward Phone_OnDeleteContact(iPlayerID);
public Phone_OnDeleteContact(iPlayerID)
{
	if(mysql_errno()) return SendClientMessage(iPlayerID, COLOR_GRAD1, "Something went wrong. Please try again later.");
	SendClientMessage(iPlayerID, COLOR_YELLOW, "[PHONE] {DDDDDD} You have successfully deleted the contact.");
	DeletePVar(iPlayerID, PVAR_PHONEDELCONTACT);
	Phone_Contacts(iPlayerID);
	return 1;
}

forward Phone_CheckContacts(iPlayerID, name[]);
public Phone_CheckContacts(iPlayerID, name[])
{
	new iRows;
	cache_get_row_count(iRows);

	if(iRows > MAX_CONTACTS) {
		SendClientMessage(iPlayerID, COLOR_GRAD1, "You cannot have more contacts stored in your phone.");
		DeletePVar(iPlayerID, "PHN_CONTACT");
	}
	ShowPlayerDialogEx(iPlayerID, DIALOG_PHONE_ADDCONTACT1, DIALOG_STYLE_INPUT, "Add Contact | Number", "Please enter the number of the contact you would like to add.", "Add", "Cancel");
	return 1;
}

Phone_Calling(iPlayerID, iCallerID)
{
	if(GetPVarType(iPlayerID, "PayPhone") || GetPVarType(iCallerID, "PayPhone")) return 1;
	Phone_ReceiveCall(iCallerID);
	return 1;
}

Phone_ReceiveCall(iPlayerID)
{
	new Float:fPos[3];

	GetPlayerPos(iPlayerID, fPos[0], fPos[1], fPos[2]);
	PlayerPlaySound(iPlayerID, iPhoneRingTone[PlayerInfo[iPlayerID][pRingtone]], 0.0, 0.0, 0.0);

	foreach(new i : Player)	{

		if(IsPlayerInRangeOfPoint(i, 10.0, fPos[0], fPos[1], fPos[2])) {

			PlayerPlaySound(i, iPhoneRingTone[PlayerInfo[iPlayerID][pRingtone]], fPos[0], fPos[1], fPos[2]);
			defer Phone_StopRingtone(i);
		}
	}
}

Phone_PickupCall(iPlayerID, iCallerID) {

	/*
	PlayerPlaySound(iPlayerID, iPhoneRingTone[PlayerInfo[iPlayerID][pRingtone]] + 1, 0.0, 0.0, 0.0);
	PlayerPlaySound(iCallerID, iPhoneRingTone[PlayerInfo[iCallerID][pRingtone]] + 1, 0.0, 0.0, 0.0);
	*/

	PlayerPlaySound(iPlayerID, 1188, 0.0, 0.0, 0.0);
	PlayerPlaySound(iCallerID, 1188, 0.0, 0.0, 0.0);
}

Phone_HangupCall(iPlayerID, iCallerID) {

	/*
	PlayerPlaySound(iPlayerID, iPhoneRingTone[PlayerInfo[iPlayerID][pRingtone]] + 1, 0.0, 0.0, 0.0);
	PlayerPlaySound(iCallerID, iPhoneRingTone[PlayerInfo[iPlayerID][pRingtone]] + 1, 0.0, 0.0, 0.0);
	*/

	PlayerPlaySound(iPlayerID, 1188, 0.0, 0.0, 0.0);
	PlayerPlaySound(iCallerID, 1188, 0.0, 0.0, 0.0);

	/*
	for(new i = 32; i < 37; ++i)
	{
		TextDrawHideForPlayer(iPlayerID, PhoneTD[i]);
		TextDrawHideForPlayer(iCallerID, PhoneTD[i]);
	}
	*/
}

Phone_Call(iPlayerID)
{
	ShowPlayerDialogEx(iPlayerID, DIALOG_PHONE_DIAL, DIALOG_STYLE_INPUT, "Phone | Dial Number", "Please insert the number you would like to dial.", "Dial", "<<");
}

Phone_Contacts(iPlayerID)
{
	ShowPlayerDialogEx(iPlayerID, DIALOG_PHONE_CONTACTS, DIALOG_STYLE_LIST, "Phone | Address Book", "\
		Yellow Pages\n\
		Pay Phones\n\
		List contacts\n\
		Add contact\n\
		Remove contact",
		"Dial", "<<");
	return 1;
}

Phone_Ads(iPlayerID)
{
	cmd_ads(iPlayerID, "");
}

Phone_Camera(iPlayerID)
{
	ShowPlayerDialogEx(iPlayerID, DIALOG_PHONE_CAMERA, DIALOG_STYLE_LIST, "Phone | Camera", "Back camera\nFront camera\nReset", "Select", "<<");
}

Phone_Settings(iPlayerID)
{
	ShowPlayerDialogEx(iPlayerID, DIALOG_PHONE_SETTINGS, DIALOG_STYLE_LIST, "Phone | Settings", "Ringtone\nWallpaper", "Select", "<<");
}

Phone_Music(iPlayerID)
{
	cmd_mp3(iPlayerID, "");
}

Phone_Map(iPlayerID)
{
	
	DisablePlayerCheckpoint(iPlayerID);
	cmd_mygps(iPlayerID, "");
}

Phone_SAN(iPlayerID)
{
	cmd_shows(iPlayerID, "");
}

/*
Phone_House(iPlayerID) {

	cmd_houselistings(iPlayerID, "");
}

Phone_Medic(iPlayerID)
{
	cmd_call(iPlayerID, "911");
}

Phone_MDC(iPlayerID)
{
	cmd_mdc(iPlayerID, "");
}
*/

Phone_Events(iPlayerID) {
	SendClientMessageEx(iPlayerID, COLOR_GRAD1, "This will be a feature soon!");
}


Phone_ShowWallPaper(iPlayerID, i) {

	PlayerTextDrawSetString(iPlayerID, phone_PTextDraw[iPlayerID][2], szPhoneWP[i]);

	/*
	TextDrawHideForPlayer(iPlayerID, PhoneTD[17]);
	TextDrawSetString(PhoneTD[17], szPhoneWP[i]);
	TextDrawShowForPlayer(iPlayerID, PhoneTD[17]);

	if(PlayerInfo[iPlayerID][pToggledChats][20] == 1) {

		TextDrawHideForPlayer(iPlayerID, PhoneTD[29]);
		TextDrawSetString(PhoneTD[29], szPhoneWP[i]);
		TextDrawShowForPlayer(iPlayerID, PhoneTD[29]);
	}
	*/
}

Phone_WallPaperMenu(iPlayerID)
{
	ShowPlayerDialogEx(iPlayerID, DIALOG_PHONE_WALLPAPERS, DIALOG_STYLE_LIST, "Phone | WallPapers", "\
		Standard\n\
		Vice City 1\n\
		Vice City 2\n\
		Cop Art 1\n\
		GTA:SA\n\
		Gangster\n\
		Ganster Car\n\
		Cop\n\
		Truth\n\
		Bikey Bike\n\
		Hot Lady\n\
		Gangster Swag\n\
		Blonde Babe\n\
		Mechanic\n\
		Chinatown\n\
		Orange is the new Black\n\
		Mafia\n\
		Huang Huang\n\
		Big Daddy\n\
		Don't drop the soap\n\
		Black Head\n\
		Stars\n\
		Clouds",
		"Select", "<<");
}

/*
CMD:togphone(playerid, params[]) {

	if(PlayerInfo[playerid][pChatbox][7]) {
		PlayerInfo[playerid][pChatbox][7] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD1, "You toggled your phone off.");
	}
	else {
		PlayerInfo[playerid][pChatbox][7] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD1, "You toggled your phone on.");
	}
	return 1;
}
*/

CMD:mouse(playerid, params[]) {
	SelectTextDraw(playerid, 0xF6FBFCFF);
	return 1;
}

CMD:contacts(playerid, params[]) {

	Phone_Contacts(playerid);
	return 1;
}

Phone_PhoneColorMenu(playerid) {

	ShowPlayerDialogEx(playerid, DIALOG_PHONE_COLOR, DIALOG_STYLE_LIST, "Phone - Select color", "Black\nWhite\nRed\nPink\nOrange\nBrown\nYellow\nGreen\nBlue\nLight Baby Blue", "Choose", "");
}

Phone_PhoneColor(playerid)
{
	new color;
	switch(PlayerInfo[playerid][pPhoneColor]) {
		case 0:	color = 0x000000FF;
		case 1:	color = 0xFFFFFFFF;
		case 2:	color = 0xCD0000FF;
		case 3:	color = 0xE6A2B1FF;
		case 4: color = 0xFFA500FF;
		case 5: color = 0x664200FF;
		case 6: color = 0xFFFF00FF;
		case 7: color = 0x008000FF;
		case 8: color = 0x4C4CFFFF;
		case 9: color = 0xC2E0FFFF;
	}
	PlayerTextDrawColor(playerid, phone_PTextDraw[playerid][1], color);
	/*
	for(new i = 6; i < 13; ++i)	{

		TextDrawColor(PhoneTD[i], color);
		TextDrawBoxColor(PhoneTD[i], color);
		TextDrawBackgroundColor(PhoneTD[i], color);
	}
	TextDrawColor(PhoneTD[16], color);
	TextDrawBoxColor(PhoneTD[16], color);
	TextDrawBackgroundColor(PhoneTD[16], color);
	*/
}

CMD:phone(playerid, params[]) {

	Phone_Main(playerid);
	return 1;
}

Phone_GetTime() {

	new thour,
		suffix[3];

	if(hour > 12 && hour < 24) {
		thour = hour - 12;
		suffix = "PM";
	}
	else if(hour == 12) {
		thour = 12;
		suffix = "PM";
	}
	else if(hour > 0 && hour < 12) {
		thour = hour;
		suffix = "AM";
	}
	else if(hour == 0) {
		thour = 12;
		suffix = "AM";
	}
	format(szMiscArray, sizeof(szMiscArray), "%d:%02d%s", thour, minuite, suffix);
	return szMiscArray;
}

Phone_Main(playerid) {
	if(GetPVarInt(playerid, "EventToken")) {
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this while in an event.");
	}
	else if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) {
		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	}
	else if(GetPVarType(playerid, "FixVehicleTimer")) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You are fixing a vehicle!");
	}
	if(PlayerCuffed[playerid] != 0 || GetPVarInt(playerid, "pBagged") >= 1 || PlayerInfo[playerid][pHospital] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use the phone right now.");
	if(PlayerInfo[playerid][pPnumber] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have a cell phone.");
	if(!Bit_State(arrPlayerBits[playerid], phone_bitState)) {
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {

			ApplyAnimation(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0, 1);
		}

		SendClientMessageEx(playerid, COLOR_WHITE, "[PHONE HELP]: Use ~k~~GO_FORWARD~ to go up, ~k~~GO_BACK~ to go down and ~k~~PED_SPRINT~ to select the item.");
		Bit_On(arrPlayerBits[playerid], phone_bitState);
		Phone_PhoneColor(playerid);
		SetPVarInt(playerid, "PMenuItem", 0);

		PlayerTextDrawSetString(playerid, phone_PTextDraw[playerid][7], Phone_GetTime());
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][0]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][1]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][2]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][3]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][4]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][5]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][6]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][7]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][8]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][9]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][10]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][11]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][12]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][13]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][14]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][15]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][16]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][17]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][18]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][19]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][20]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][21]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][22]);
		PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][23]);

		/*
		if(click) SelectTextDraw(playerid, 0xF6FBFCFF);
		switch(PlayerInfo[playerid][pToggledChats][20]) {

			case 0: for(new i; i < 29; ++i) TextDrawShowForPlayer(playerid, PhoneTD[i]);
			case 1: {
				for(new i; i < 18; ++i) TextDrawShowForPlayer(playerid, PhoneTD[i]);
				for(new i = 29; i < sizeof(PhoneTD); ++i) TextDrawShowForPlayer(playerid, PhoneTD[i]);
			}
		}
		*/
		Phone_ShowWallPaper(playerid, PlayerInfo[playerid][pWallpaper]);
	}
	else {
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) ClearAnimationsEx(playerid);
		Bit_Off(arrPlayerBits[playerid], phone_bitState);
		// if(click) CancelSelectTextDraw(playerid);
		DeletePVar(playerid, "PMenuItem");
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][0]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][1]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][2]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][3]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][4]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][5]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][6]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][7]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][8]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][9]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][10]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][11]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][12]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][13]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][14]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][15]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][16]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][17]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][18]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][19]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][20]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][21]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][22]);
		PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][23]);
	}
	return 1;
}

CMD:fpm(playerid, params[]) {

	if(!Bit_State(arrPlayerBits[playerid], phone_bitCamState))
	{
		Bit_On(arrPlayerBits[playerid], phone_bitCamState);
		new iObjectID = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		SetPVarInt(playerid, "FP_OBJ", iObjectID);
        AttachObjectToPlayer(iObjectID, playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
        AttachCameraToObject(playerid, iObjectID);
	}
	else {

		Bit_Off(arrPlayerBits[playerid], phone_bitCamState);
		DestroyObject(GetPVarInt(playerid, "FP_OBJ"));
		DeletePVar(playerid, "FP_OBJ");
		SetCameraBehindPlayer(playerid);
	}
	return 1;
}
/*
hook OnPlayerStateChange(playerid, newstate, oldstate) {

    if(oldstate == PLAYER_STATE_ONFOOT && (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)) {
    	new iVehicleID = GetPlayerVehicleID(playerid);
        if(GetPVarType(playerid, "FP_OBJ")) {
			new iObjectID = GetPVarInt(playerid, "FP_OBJ");
			SetCameraBehindPlayer(playerid);
			AttachPlayerObjectToVehicle(playerid, iObjectID, iVehicleID,-0.6, -0.3, 0.490000, 0.000000, 0.000000, 0.000000);
			AttachCameraToPlayerObject(playerid, iObjectID);
		}
    }
    if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) {
    	new iVehicleID = GetPlayerVehicleID(playerid);
    	if(GetPVarType(playerid, "FP_OBJ")) {
			new iObjectID = GetPVarInt(playerid, "FP_OBJ");
			SetCameraBehindPlayer(playerid);
			AttachObjectToPlayer(iObjectID, playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
			AttachCameraToPlayerObject(playerid, iVehicleID);
		}
    }
    return 1;
}
*/

CMD:firstperson(playerid, params[]) {
	return cmd_fpm(playerid, "");
}

CMD:picture(playerid, params[]) {

	return cmd_fpm(playerid, "");
}


CMD:selfie(playerid, params[]) {

	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this inside a vehicle.");
	if(GetPVarInt(playerid, "EventToken")) {
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this while in an event.");
	}
	else if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarInt(playerid, "pDoingPJob") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital]) {
		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	}
	else if(GetPVarType(playerid, "FixVehicleTimer")) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You are fixing a vehicle!");
	}

	if(!Bit_State(arrPlayerBits[playerid], phone_bitCamState))
	{
		new Float:fPos[4],
			Float:fCam[2];

	    GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	    GetPlayerFacingAngle(playerid, fPos[3]);

	    fPos[3] += 1.25;
	    fCam[0] = fPos[0] + 1.4 * floatcos(fPos[3], degrees);
	    fCam[1] = fPos[1] + 1.4 * floatsin(fPos[3], degrees);

	    SetPlayerCameraPos(playerid, fCam[0], fCam[1], fPos[2] + 0.9);
	    SetPlayerCameraLookAt(playerid, fPos[0], fPos[1], fPos[2] + 0.9);
	    SetPlayerFacingAngle(playerid, fPos[3] - 90.0);

	    TogglePlayerControllable(playerid, false);
	    PlayAnimEx(playerid, "PED", "gang_gunstand", 4.1, 1, 1, 1, 1, 1, 1);
	    SendClientMessage(playerid, COLOR_GRAD1, "{DDDDDD}Select the camera app or use /selfie to go back. Use {FFFF00}/headmove {DDDDDD}to disable your head movement (look straight).");
	    Bit_On(arrPlayerBits[playerid], phone_bitCamState);
	}
	else
	{
		DeletePVar(playerid, "Flt");
		Bit_Off(arrPlayerBits[playerid], phone_bitCamState);
		ClearAnimationsEx(playerid, 1);
		TogglePlayerControllable(playerid, true);
		SetCameraBehindPlayer(playerid);
	}
	return 1;
}


Phone_InitTD(playerid) {

	/*
	Phone V1 - Jingles
	// Create the textdraws:
	PhoneTD[0] = TextDrawCreate(498.000000, 188.000000, "LD_SPAC:white");
	TextDrawBackgroundColor(PhoneTD[0], 255);
	TextDrawFont(PhoneTD[0], 4);
	TextDrawLetterSize(PhoneTD[0], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[0], -1768515841);
	TextDrawSetOutline(PhoneTD[0], 0);
	TextDrawSetProportional(PhoneTD[0], 1);
	TextDrawSetShadow(PhoneTD[0], 2);
	TextDrawUseBox(PhoneTD[0], 1);
	TextDrawBoxColor(PhoneTD[0], 255);
	TextDrawTextSize(PhoneTD[0], 117.000000, 206.000000);
	TextDrawSetSelectable(PhoneTD[0], 0);

	PhoneTD[1] = TextDrawCreate(507.000000, 178.000000, "LD_SPAC:white");
	TextDrawBackgroundColor(PhoneTD[1], 255);
	TextDrawFont(PhoneTD[1], 4);
	TextDrawLetterSize(PhoneTD[1], 0.500000, 2.299998);
	TextDrawColor(PhoneTD[1], -1768515841);
	TextDrawSetOutline(PhoneTD[1], 0);
	TextDrawSetProportional(PhoneTD[1], 1);
	TextDrawSetShadow(PhoneTD[1], 2);
	TextDrawUseBox(PhoneTD[1], 1);
	TextDrawBoxColor(PhoneTD[1], 255);
	TextDrawTextSize(PhoneTD[1], 100.000000, 225.000000);
	TextDrawSetSelectable(PhoneTD[1], 0);

	PhoneTD[2] = TextDrawCreate(498.000000, 380.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[2], 2);
	TextDrawBackgroundColor(PhoneTD[2], 255);
	TextDrawFont(PhoneTD[2], 4);
	TextDrawLetterSize(PhoneTD[2], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[2], -1768515841);
	TextDrawSetOutline(PhoneTD[2], 0);
	TextDrawSetProportional(PhoneTD[2], 1);
	TextDrawSetShadow(PhoneTD[2], 1);
	TextDrawUseBox(PhoneTD[2], 1);
	TextDrawBoxColor(PhoneTD[2], 255);
	TextDrawTextSize(PhoneTD[2], 15.000000, 23.000000);
	TextDrawSetSelectable(PhoneTD[2], 0);

	PhoneTD[3] = TextDrawCreate(600.000000, 380.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[3], 2);
	TextDrawBackgroundColor(PhoneTD[3], 255);
	TextDrawFont(PhoneTD[3], 4);
	TextDrawLetterSize(PhoneTD[3], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[3], -1768515841);
	TextDrawSetOutline(PhoneTD[3], 0);
	TextDrawSetProportional(PhoneTD[3], 1);
	TextDrawSetShadow(PhoneTD[3], 1);
	TextDrawUseBox(PhoneTD[3], 1);
	TextDrawBoxColor(PhoneTD[3], 255);
	TextDrawTextSize(PhoneTD[3], 15.000000, 23.000000);
	TextDrawSetSelectable(PhoneTD[3], 0);

	PhoneTD[4] = TextDrawCreate(600.000000, 178.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[4], 2);
	TextDrawBackgroundColor(PhoneTD[4], 255);
	TextDrawFont(PhoneTD[4], 4);
	TextDrawLetterSize(PhoneTD[4], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[4], -1768515841);
	TextDrawSetOutline(PhoneTD[4], 0);
	TextDrawSetProportional(PhoneTD[4], 1);
	TextDrawSetShadow(PhoneTD[4], 1);
	TextDrawUseBox(PhoneTD[4], 1);
	TextDrawBoxColor(PhoneTD[4], 255);
	TextDrawTextSize(PhoneTD[4], 15.000000, 23.000000);
	TextDrawSetSelectable(PhoneTD[4], 0);

	PhoneTD[5] = TextDrawCreate(498.500000, 178.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[5], 2);
	TextDrawBackgroundColor(PhoneTD[5], 255);
	TextDrawFont(PhoneTD[5], 4);
	TextDrawLetterSize(PhoneTD[5], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[5], -1768515841);
	TextDrawSetOutline(PhoneTD[5], 0);
	TextDrawSetProportional(PhoneTD[5], 1);
	TextDrawSetShadow(PhoneTD[5], 1);
	TextDrawUseBox(PhoneTD[5], 1);
	TextDrawBoxColor(PhoneTD[5], 255);
	TextDrawTextSize(PhoneTD[5], 15.000000, 23.000000);
	TextDrawSetSelectable(PhoneTD[5], 0);

	PhoneTD[6] = TextDrawCreate(498.000000, 179.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[6], 2);
	TextDrawBackgroundColor(PhoneTD[6], 255);
	TextDrawFont(PhoneTD[6], 4);
	TextDrawLetterSize(PhoneTD[6], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[6], 255);
	TextDrawSetOutline(PhoneTD[6], 0);
	TextDrawSetProportional(PhoneTD[6], 1);
	TextDrawSetShadow(PhoneTD[6], 1);
	TextDrawUseBox(PhoneTD[6], 1);
	TextDrawBoxColor(PhoneTD[6], 255);
	TextDrawTextSize(PhoneTD[6], 15.000000, 23.000000);
	TextDrawSetSelectable(PhoneTD[6], 0);

	PhoneTD[7] = TextDrawCreate(499.000000, 379.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[7], 2);
	TextDrawBackgroundColor(PhoneTD[7], 255);
	TextDrawFont(PhoneTD[7], 4);
	TextDrawLetterSize(PhoneTD[7], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[7], 255);
	TextDrawSetOutline(PhoneTD[7], 0);
	TextDrawSetProportional(PhoneTD[7], 1);
	TextDrawSetShadow(PhoneTD[7], 1);
	TextDrawUseBox(PhoneTD[7], 1);
	TextDrawBoxColor(PhoneTD[7], 255);
	TextDrawTextSize(PhoneTD[7], 15.000000, 23.000000);
	TextDrawSetSelectable(PhoneTD[7], 0);

	PhoneTD[8] = TextDrawCreate(599.000000, 379.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[8], 2);
	TextDrawBackgroundColor(PhoneTD[8], 255);
	TextDrawFont(PhoneTD[8], 4);
	TextDrawLetterSize(PhoneTD[8], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[8], 255);
	TextDrawSetOutline(PhoneTD[8], 0);
	TextDrawSetProportional(PhoneTD[8], 1);
	TextDrawSetShadow(PhoneTD[8], 1);
	TextDrawUseBox(PhoneTD[8], 1);
	TextDrawBoxColor(PhoneTD[8], 255);
	TextDrawTextSize(PhoneTD[8], 15.000000, 23.000000);
	TextDrawSetSelectable(PhoneTD[8], 0);

	PhoneTD[9] = TextDrawCreate(599.000000, 179.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[9], 2);
	TextDrawBackgroundColor(PhoneTD[9], 255);
	TextDrawFont(PhoneTD[9], 4);
	TextDrawLetterSize(PhoneTD[9], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[9], 255);
	TextDrawSetOutline(PhoneTD[9], 0);
	TextDrawSetProportional(PhoneTD[9], 1);
	TextDrawSetShadow(PhoneTD[9], 1);
	TextDrawUseBox(PhoneTD[9], 1);
	TextDrawBoxColor(PhoneTD[9], 255);
	TextDrawTextSize(PhoneTD[9], 15.000000, 23.000000);
	TextDrawSetSelectable(PhoneTD[9], 0);

	PhoneTD[10] = TextDrawCreate(506.000000, 179.000000, "LD_SPAC:White");
	TextDrawAlignment(PhoneTD[10], 2);
	TextDrawBackgroundColor(PhoneTD[10], 255);
	TextDrawFont(PhoneTD[10], 4);
	TextDrawLetterSize(PhoneTD[10], 0.300000, 22.400001);
	TextDrawColor(PhoneTD[10], 0);
	TextDrawSetOutline(PhoneTD[10], 0);
	TextDrawSetProportional(PhoneTD[10], 1);
	TextDrawSetShadow(PhoneTD[10], 1);
	TextDrawUseBox(PhoneTD[10], 1);
	TextDrawBoxColor(PhoneTD[10], 255);
	TextDrawTextSize(PhoneTD[10], 101.000000, 223.000000);
	TextDrawSetSelectable(PhoneTD[10], 0);

	PhoneTD[11] = TextDrawCreate(499.000000, 194.000000, "LD_SPAC:White");
	TextDrawAlignment(PhoneTD[11], 2);
	TextDrawBackgroundColor(PhoneTD[11], 255);
	TextDrawFont(PhoneTD[11], 4);
	TextDrawLetterSize(PhoneTD[11], 0.300000, 19.699998);
	TextDrawColor(PhoneTD[11], 0);
	TextDrawSetOutline(PhoneTD[11], 0);
	TextDrawSetProportional(PhoneTD[11], 1);
	TextDrawSetShadow(PhoneTD[11], 1);
	TextDrawUseBox(PhoneTD[11], 1);
	TextDrawBoxColor(PhoneTD[11], 255);
	TextDrawTextSize(PhoneTD[11], 115.000000, 196.000000);
	TextDrawSetSelectable(PhoneTD[11], 0);

	PhoneTD[12] = TextDrawCreate(538.000000, 194.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[12], 2);
	TextDrawBackgroundColor(PhoneTD[12], 255);
	TextDrawFont(PhoneTD[12], 4);
	TextDrawLetterSize(PhoneTD[12], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[12], 505290495);
	TextDrawSetOutline(PhoneTD[12], 0);
	TextDrawSetProportional(PhoneTD[12], 1);
	TextDrawSetShadow(PhoneTD[12], 1);
	TextDrawUseBox(PhoneTD[12], 1);
	TextDrawBoxColor(PhoneTD[12], 255);
	TextDrawTextSize(PhoneTD[12], 4.000000, 4.000000);
	TextDrawSetSelectable(PhoneTD[12], 0);

	PhoneTD[13] = TextDrawCreate(547.000000, 195.000000, "LD_SPAC:White");
	TextDrawBackgroundColor(PhoneTD[13], 255);
	TextDrawFont(PhoneTD[13], 4);
	TextDrawLetterSize(PhoneTD[13], 0.500000, 2.299998);
	TextDrawColor(PhoneTD[13], 505290495);
	TextDrawSetOutline(PhoneTD[13], 0);
	TextDrawSetProportional(PhoneTD[13], 1);
	TextDrawSetShadow(PhoneTD[13], 2);
	TextDrawUseBox(PhoneTD[13], 1);
	TextDrawBoxColor(PhoneTD[13], 255);
	TextDrawTextSize(PhoneTD[13], 22.000000, 2.000000);
	TextDrawSetSelectable(PhoneTD[13], 0);

	PhoneTD[14] = TextDrawCreate(539.000000, 195.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[14], 2);
	TextDrawBackgroundColor(PhoneTD[14], 255);
	TextDrawFont(PhoneTD[14], 4);
	TextDrawLetterSize(PhoneTD[14], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[14], 336870655);
	TextDrawSetOutline(PhoneTD[14], 0);
	TextDrawSetProportional(PhoneTD[14], 1);
	TextDrawSetShadow(PhoneTD[14], 1);
	TextDrawUseBox(PhoneTD[14], 1);
	TextDrawBoxColor(PhoneTD[14], 255);
	TextDrawTextSize(PhoneTD[14], 2.000000, 2.000000);
	TextDrawSetSelectable(PhoneTD[14], 0);

	PhoneTD[15] = TextDrawCreate(549.000000, 380.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[15], 2);
	TextDrawBackgroundColor(PhoneTD[15], 255);
	TextDrawFont(PhoneTD[15], 4);
	TextDrawLetterSize(PhoneTD[15], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[15], 673720575);
	TextDrawSetOutline(PhoneTD[15], 0);
	TextDrawSetProportional(PhoneTD[15], 1);
	TextDrawSetShadow(PhoneTD[15], 1);
	TextDrawUseBox(PhoneTD[15], 1);
	TextDrawBoxColor(PhoneTD[15], 255);
	TextDrawTextSize(PhoneTD[15], 16.000000, 17.000000);
	TextDrawSetSelectable(PhoneTD[15], 0);

	PhoneTD[16] = TextDrawCreate(550.000000, 381.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[16], 2);
	TextDrawBackgroundColor(PhoneTD[16], 255);
	TextDrawFont(PhoneTD[16], 4);
	TextDrawLetterSize(PhoneTD[16], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[16], 255);
	TextDrawSetOutline(PhoneTD[16], 0);
	TextDrawSetProportional(PhoneTD[16], 1);
	TextDrawSetShadow(PhoneTD[16], 1);
	TextDrawUseBox(PhoneTD[16], 1);
	TextDrawBoxColor(PhoneTD[16], 255);
	TextDrawTextSize(PhoneTD[16], 14.000000, 15.000000);
	TextDrawSetSelectable(PhoneTD[16], 0);

	PhoneTD[17] = TextDrawCreate(505.000000, 208.000000, "NGRP:background");
	TextDrawBackgroundColor(PhoneTD[17], 255);
	TextDrawFont(PhoneTD[17], 4);
	TextDrawLetterSize(PhoneTD[17], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[17], -1768515841);
	TextDrawSetOutline(PhoneTD[17], 0);
	TextDrawSetProportional(PhoneTD[17], 1);
	TextDrawSetShadow(PhoneTD[17], 2);
	TextDrawUseBox(PhoneTD[17], 1);
	TextDrawBoxColor(PhoneTD[17], 255);
	TextDrawTextSize(PhoneTD[17], 102.000000, 165.000000);
	TextDrawSetSelectable(PhoneTD[17], 0);

	PhoneTD[18] = TextDrawCreate(556.000000, 186.000000, "ld_pool:ball");
	TextDrawAlignment(PhoneTD[18], 2);
	TextDrawBackgroundColor(PhoneTD[18], 255);
	TextDrawFont(PhoneTD[18], 4);
	TextDrawLetterSize(PhoneTD[18], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[18], 505290495);
	TextDrawSetOutline(PhoneTD[18], 0);
	TextDrawSetProportional(PhoneTD[18], 1);
	TextDrawSetShadow(PhoneTD[18], 1);
	TextDrawUseBox(PhoneTD[18], 1);
	TextDrawBoxColor(PhoneTD[18], 255);
	TextDrawTextSize(PhoneTD[18], 2.000000, 2.000000);
	TextDrawSetSelectable(PhoneTD[18], 0);

	PhoneTD[19] = TextDrawCreate(513.000000, 218.000000, "Call");
	TextDrawBackgroundColor(PhoneTD[19], 255);
	TextDrawFont(PhoneTD[19], 2);
	TextDrawLetterSize(PhoneTD[19], 0.260000, 1.000000);
	TextDrawColor(PhoneTD[19], -1);
	TextDrawSetOutline(PhoneTD[19], 0);
	TextDrawSetProportional(PhoneTD[19], 1);
	TextDrawSetShadow(PhoneTD[19], 1);
	TextDrawSetSelectable(PhoneTD[19], 1);

	PhoneTD[20] = TextDrawCreate(513.000000, 233.000000, "Address Book");
	TextDrawBackgroundColor(PhoneTD[20], 255);
	TextDrawFont(PhoneTD[20], 2);
	TextDrawLetterSize(PhoneTD[20], 0.260000, 1.000000);
	TextDrawColor(PhoneTD[20], -1);
	TextDrawSetOutline(PhoneTD[20], 0);
	TextDrawSetProportional(PhoneTD[20], 1);
	TextDrawSetShadow(PhoneTD[20], 1);
	TextDrawSetSelectable(PhoneTD[20], 1);

	PhoneTD[21] = TextDrawCreate(513.000000, 246.000000, "Advertisements");
	TextDrawBackgroundColor(PhoneTD[21], 255);
	TextDrawFont(PhoneTD[21], 2);
	TextDrawLetterSize(PhoneTD[21], 0.260000, 1.000000);
	TextDrawColor(PhoneTD[21], -1);
	TextDrawSetOutline(PhoneTD[21], 0);
	TextDrawSetProportional(PhoneTD[21], 1);
	TextDrawSetShadow(PhoneTD[21], 1);
	TextDrawSetSelectable(PhoneTD[21], 1);

	PhoneTD[22] = TextDrawCreate(513.000000, 262.000000, "Music");
	TextDrawBackgroundColor(PhoneTD[22], 255);
	TextDrawFont(PhoneTD[22], 2);
	TextDrawLetterSize(PhoneTD[22], 0.260000, 1.000000);
	TextDrawColor(PhoneTD[22], -1);
	TextDrawSetOutline(PhoneTD[22], 0);
	TextDrawSetProportional(PhoneTD[22], 1);
	TextDrawSetShadow(PhoneTD[22], 1);
	TextDrawSetSelectable(PhoneTD[22], 1);

	PhoneTD[23] = TextDrawCreate(513.000000, 276.000000, "MeTube");
	TextDrawBackgroundColor(PhoneTD[23], 255);
	TextDrawFont(PhoneTD[23], 2);
	TextDrawLetterSize(PhoneTD[23], 0.260000, 1.000000);
	TextDrawColor(PhoneTD[23], -1);
	TextDrawSetOutline(PhoneTD[23], 0);
	TextDrawSetProportional(PhoneTD[23], 1);
	TextDrawSetShadow(PhoneTD[23], 1);
	TextDrawSetSelectable(PhoneTD[23], 1);

	PhoneTD[24] = TextDrawCreate(513.000000, 292.000000, "Doodle Maps");
	TextDrawBackgroundColor(PhoneTD[24], 255);
	TextDrawFont(PhoneTD[24], 2);
	TextDrawLetterSize(PhoneTD[24], 0.260000, 1.000000);
	TextDrawColor(PhoneTD[24], -1);
	TextDrawSetOutline(PhoneTD[24], 0);
	TextDrawSetProportional(PhoneTD[24], 1);
	TextDrawSetShadow(PhoneTD[24], 1);
	TextDrawSetSelectable(PhoneTD[24], 1);

	PhoneTD[25] = TextDrawCreate(513.000000, 309.000000, "Emergency");
	TextDrawBackgroundColor(PhoneTD[25], 255);
	TextDrawFont(PhoneTD[25], 2);
	TextDrawLetterSize(PhoneTD[25], 0.260000, 1.000000);
	TextDrawColor(PhoneTD[25], -1);
	TextDrawSetOutline(PhoneTD[25], 0);
	TextDrawSetProportional(PhoneTD[25], 1);
	TextDrawSetShadow(PhoneTD[25], 1);
	TextDrawSetSelectable(PhoneTD[25], 1);

	PhoneTD[26] = TextDrawCreate(513.000000, 324.000000, "MDC");
	TextDrawBackgroundColor(PhoneTD[26], 255);
	TextDrawFont(PhoneTD[26], 2);
	TextDrawLetterSize(PhoneTD[26], 0.260000, 1.000000);
	TextDrawColor(PhoneTD[26], -1);
	TextDrawSetOutline(PhoneTD[26], 0);
	TextDrawSetProportional(PhoneTD[26], 1);
	TextDrawSetShadow(PhoneTD[26], 1);
	TextDrawSetSelectable(PhoneTD[26], 1);

	PhoneTD[27] = TextDrawCreate(513.000000, 339.000000, "Camera");
	TextDrawBackgroundColor(PhoneTD[27], 255);
	TextDrawFont(PhoneTD[27], 2);
	TextDrawLetterSize(PhoneTD[27], 0.260000, 1.000000);
	TextDrawColor(PhoneTD[27], -1);
	TextDrawSetOutline(PhoneTD[27], 0);
	TextDrawSetProportional(PhoneTD[27], 1);
	TextDrawSetShadow(PhoneTD[27], 1);
	TextDrawSetSelectable(PhoneTD[27], 1);

	PhoneTD[28] = TextDrawCreate(513.000000, 355.000000, "Settings");
	TextDrawBackgroundColor(PhoneTD[28], 255);
	TextDrawFont(PhoneTD[28], 2);
	TextDrawLetterSize(PhoneTD[28], 0.260000, 1.000000);
	TextDrawColor(PhoneTD[28], -1);
	TextDrawSetOutline(PhoneTD[28], 0);
	TextDrawSetProportional(PhoneTD[28], 1);
	TextDrawSetShadow(PhoneTD[28], 1);
	TextDrawSetSelectable(PhoneTD[28], 1);

	PhoneTD[29] = TextDrawCreate(505.000000, 208.000000, "NGRP:background");
	TextDrawBackgroundColor(PhoneTD[29], 255);
	TextDrawFont(PhoneTD[29], 4);
	TextDrawLetterSize(PhoneTD[29], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[29], -1768515841);
	TextDrawSetOutline(PhoneTD[29], 0);
	TextDrawSetProportional(PhoneTD[29], 1);
	TextDrawSetShadow(PhoneTD[29], 2);
	TextDrawUseBox(PhoneTD[29], 1);
	TextDrawBoxColor(PhoneTD[29], 255);
	TextDrawTextSize(PhoneTD[29], 102.000000, 165.000000);
	TextDrawSetSelectable(PhoneTD[29], 0);

	PhoneTD[30] = TextDrawCreate(496.000000, 344.000000, "NGRP:blur");
	TextDrawAlignment(PhoneTD[30], 2);
	TextDrawBackgroundColor(PhoneTD[30], 255);
	TextDrawFont(PhoneTD[30], 4);
	TextDrawLetterSize(PhoneTD[30], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[30], -216);
	TextDrawSetOutline(PhoneTD[30], 0);
	TextDrawSetProportional(PhoneTD[30], 1);
	TextDrawSetShadow(PhoneTD[30], 1);
	TextDrawUseBox(PhoneTD[30], 1);
	TextDrawBoxColor(PhoneTD[30], 255);
	TextDrawTextSize(PhoneTD[30], 124.000000, 31.000000);
	TextDrawSetSelectable(PhoneTD[30], 0);

	PhoneTD[31] = TextDrawCreate(507.000000, 349.000000, "NGRP:phone");
	TextDrawAlignment(PhoneTD[31], 2);
	TextDrawBackgroundColor(PhoneTD[31], 255);
	TextDrawFont(PhoneTD[31], 4);
	TextDrawLetterSize(PhoneTD[31], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[31], -1);
	TextDrawSetOutline(PhoneTD[31], 0);
	TextDrawSetProportional(PhoneTD[31], 1);
	TextDrawSetShadow(PhoneTD[31], 1);
	TextDrawUseBox(PhoneTD[31], 1);
	TextDrawBoxColor(PhoneTD[31], 255);
	TextDrawTextSize(PhoneTD[31], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[31], 1);

	PhoneTD[32] = TextDrawCreate(581.000000, 349.000000, "NGRP:Music");
	TextDrawAlignment(PhoneTD[32], 2);
	TextDrawBackgroundColor(PhoneTD[32], 255);
	TextDrawFont(PhoneTD[32], 4);
	TextDrawLetterSize(PhoneTD[32], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[32], -1);
	TextDrawSetOutline(PhoneTD[32], 0);
	TextDrawSetProportional(PhoneTD[32], 1);
	TextDrawSetShadow(PhoneTD[32], 1);
	TextDrawUseBox(PhoneTD[32], 1);
	TextDrawBoxColor(PhoneTD[32], 255);
	TextDrawTextSize(PhoneTD[32], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[32], 1);

	PhoneTD[33] = TextDrawCreate(531.000000, 210.000000, "NGRP:contacts");
	TextDrawAlignment(PhoneTD[33], 2);
	TextDrawBackgroundColor(PhoneTD[33], 255);
	TextDrawFont(PhoneTD[33], 4);
	TextDrawLetterSize(PhoneTD[33], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[33], -1);
	TextDrawSetOutline(PhoneTD[33], 0);
	TextDrawSetProportional(PhoneTD[33], 1);
	TextDrawSetShadow(PhoneTD[33], 1);
	TextDrawUseBox(PhoneTD[33], 1);
	TextDrawBoxColor(PhoneTD[33], 255);
	TextDrawTextSize(PhoneTD[33], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[33], 1);

	PhoneTD[34] = TextDrawCreate(531.000000, 349.000000, "NGRP:camera");
	TextDrawAlignment(PhoneTD[34], 2);
	TextDrawBackgroundColor(PhoneTD[34], 255);
	TextDrawFont(PhoneTD[34], 4);
	TextDrawLetterSize(PhoneTD[34], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[34], -1);
	TextDrawSetOutline(PhoneTD[34], 0);
	TextDrawSetProportional(PhoneTD[34], 1);
	TextDrawSetShadow(PhoneTD[34], 1);
	TextDrawUseBox(PhoneTD[34], 1);
	TextDrawBoxColor(PhoneTD[34], 255);
	TextDrawTextSize(PhoneTD[34], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[34], 1);

	PhoneTD[35] = TextDrawCreate(506.000000, 210.000000, "NGRP:message");
	TextDrawAlignment(PhoneTD[35], 2);
	TextDrawBackgroundColor(PhoneTD[35], 255);
	TextDrawFont(PhoneTD[35], 4);
	TextDrawLetterSize(PhoneTD[35], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[35], -1);
	TextDrawSetOutline(PhoneTD[35], 0);
	TextDrawSetProportional(PhoneTD[35], 1);
	TextDrawSetShadow(PhoneTD[35], 1);
	TextDrawUseBox(PhoneTD[35], 1);
	TextDrawBoxColor(PhoneTD[35], 255);
	TextDrawTextSize(PhoneTD[35], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[35], 1);

	PhoneTD[36] = TextDrawCreate(556.000000, 210.000000, "NGRP:ads");
	TextDrawAlignment(PhoneTD[36], 2);
	TextDrawBackgroundColor(PhoneTD[36], 255);
	TextDrawFont(PhoneTD[36], 4);
	TextDrawLetterSize(PhoneTD[36], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[36], -1);
	TextDrawSetOutline(PhoneTD[36], 0);
	TextDrawSetProportional(PhoneTD[36], 1);
	TextDrawSetShadow(PhoneTD[36], 1);
	TextDrawUseBox(PhoneTD[36], 1);
	TextDrawBoxColor(PhoneTD[36], 255);
	TextDrawTextSize(PhoneTD[36], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[36], 1);

	PhoneTD[37] = TextDrawCreate(581.000000, 210.000000, "NGRP:home");
	TextDrawAlignment(PhoneTD[37], 2);
	TextDrawBackgroundColor(PhoneTD[37], 255);
	TextDrawFont(PhoneTD[37], 4);
	TextDrawLetterSize(PhoneTD[37], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[37], -1);
	TextDrawSetOutline(PhoneTD[37], 0);
	TextDrawSetProportional(PhoneTD[37], 1);
	TextDrawSetShadow(PhoneTD[37], 1);
	TextDrawUseBox(PhoneTD[37], 1);
	TextDrawBoxColor(PhoneTD[37], 255);
	TextDrawTextSize(PhoneTD[37], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[37], 1);

	PhoneTD[38] = TextDrawCreate(531.000000, 234.000000, "NGRP:Maps");
	TextDrawAlignment(PhoneTD[38], 2);
	TextDrawBackgroundColor(PhoneTD[38], 255);
	TextDrawFont(PhoneTD[38], 4);
	TextDrawLetterSize(PhoneTD[38], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[38], -1);
	TextDrawSetOutline(PhoneTD[38], 0);
	TextDrawSetProportional(PhoneTD[38], 1);
	TextDrawSetShadow(PhoneTD[38], 1);
	TextDrawUseBox(PhoneTD[38], 1);
	TextDrawBoxColor(PhoneTD[38], 255);
	TextDrawTextSize(PhoneTD[38], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[38], 1);

	PhoneTD[39] = TextDrawCreate(506.000000, 234.000000, "NGRP:shows");
	TextDrawAlignment(PhoneTD[39], 2);
	TextDrawBackgroundColor(PhoneTD[39], 255);
	TextDrawFont(PhoneTD[39], 4);
	TextDrawLetterSize(PhoneTD[39], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[39], -1);
	TextDrawSetOutline(PhoneTD[39], 0);
	TextDrawSetProportional(PhoneTD[39], 1);
	TextDrawSetShadow(PhoneTD[39], 1);
	TextDrawUseBox(PhoneTD[39], 1);
	TextDrawBoxColor(PhoneTD[39], 255);
	TextDrawTextSize(PhoneTD[39], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[39], 1);

	PhoneTD[40] = TextDrawCreate(556.000000, 234.000000, "NGRP:Health");
	TextDrawAlignment(PhoneTD[40], 2);
	TextDrawBackgroundColor(PhoneTD[40], 255);
	TextDrawFont(PhoneTD[40], 4);
	TextDrawLetterSize(PhoneTD[40], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[40], -1);
	TextDrawSetOutline(PhoneTD[40], 0);
	TextDrawSetProportional(PhoneTD[40], 1);
	TextDrawSetShadow(PhoneTD[40], 1);
	TextDrawUseBox(PhoneTD[40], 1);
	TextDrawBoxColor(PhoneTD[40], 255);
	TextDrawTextSize(PhoneTD[40], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[40], 1);

	PhoneTD[41] = TextDrawCreate(581.000000, 234.000000, "NGRP:mdc");
	TextDrawAlignment(PhoneTD[41], 2);
	TextDrawBackgroundColor(PhoneTD[41], 255);
	TextDrawFont(PhoneTD[41], 4);
	TextDrawLetterSize(PhoneTD[41], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[41], -1);
	TextDrawSetOutline(PhoneTD[41], 0);
	TextDrawSetProportional(PhoneTD[41], 1);
	TextDrawSetShadow(PhoneTD[41], 1);
	TextDrawUseBox(PhoneTD[41], 1);
	TextDrawBoxColor(PhoneTD[41], 255);
	TextDrawTextSize(PhoneTD[41], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[41], 1);

	PhoneTD[42] = TextDrawCreate(506.000000, 258.000000, "NGRP:settings");
	TextDrawAlignment(PhoneTD[42], 2);
	TextDrawBackgroundColor(PhoneTD[42], 255);
	TextDrawFont(PhoneTD[42], 4);
	TextDrawLetterSize(PhoneTD[42], 0.500000, 1.000000);
	TextDrawColor(PhoneTD[42], -1);
	TextDrawSetOutline(PhoneTD[42], 0);
	TextDrawSetProportional(PhoneTD[42], 1);
	TextDrawSetShadow(PhoneTD[42], 1);
	TextDrawUseBox(PhoneTD[42], 1);
	TextDrawBoxColor(PhoneTD[42], 255);
	TextDrawTextSize(PhoneTD[42], 25.000000, 22.000000);
	TextDrawSetSelectable(PhoneTD[42], 1);
	*/

	phone_PTextDraw[playerid][0] = CreatePlayerTextDraw(playerid,501.000000, 243.000000, "LD_DUAL:white");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][0], 100);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][0], 673720575);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][0], 0);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][0], 100);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][0], 87.000000, 164.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][0], 0);

	phone_PTextDraw[playerid][1] = CreatePlayerTextDraw(playerid,502.000000, 245.000000, "LD_DUAL:white");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][1], 100);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][1], 100);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][1], 0);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][1], 100);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][1], 84.000000, 159.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][1], 0);

	phone_PTextDraw[playerid][2] = CreatePlayerTextDraw(playerid,507.000000, 252.000000, "LD_DUAL:Health");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][2], 100);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][2], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][2], 0);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][2], 1684301055);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][2], 75.000000, 134.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][2], 0);

	phone_PTextDraw[playerid][3] = CreatePlayerTextDraw(playerid,508.000000, 394.000000, "LD_DUAL:white");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][3], 255);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][3], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][3], 182848000);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][3], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][3], 255);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][3], 20.000000, 4.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][3], 0);

	phone_PTextDraw[playerid][4] = CreatePlayerTextDraw(playerid,562.000000, 394.000000, "LD_DUAL:white");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][4], 255);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][4], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][4], -938863361);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][4], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][4], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][4], 255);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][4], 20.000000, 4.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][4], 0);

	phone_PTextDraw[playerid][5] = CreatePlayerTextDraw(playerid,537.000000, 395.000000, "LD_DUAL:white"); // background
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][5], 255);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][5], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][5], 1684306175);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][5], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][5], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][5], 255);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][5], 17.000000, 3.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][5], 0);


	phone_PTextDraw[playerid][6] = CreatePlayerTextDraw(playerid,571.000000, 376.000000, "cancel");
	PlayerTextDrawAlignment(playerid,phone_PTextDraw[playerid][6], 2);
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][6], 673720520);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][6], 0.150000, 0.899999);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][6], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][6], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][6], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][6], 673720470);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][6], 578.000000, -25.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][6], 0);

	phone_PTextDraw[playerid][7] = CreatePlayerTextDraw(playerid,544.000000, 253.000000, "09:10");
	PlayerTextDrawAlignment(playerid,phone_PTextDraw[playerid][7], 2);
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][7], 20);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][7], 0.189999, 0.599999);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][7], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][7], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][7], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][7], 336860370);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][7], 250.000000, -82.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][7], 0);

	phone_PTextDraw[playerid][8] = CreatePlayerTextDraw(playerid,567.000000, 255.000000, "LD_DUAL:white");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][8], 255);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][8], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][8], 184489215);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][8], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][8], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][8], 255);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][8], 10.000000, 2.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][8], 0);

	phone_PTextDraw[playerid][9] = CreatePlayerTextDraw(playerid,575.000000, 255.000000, "LD_DUAL:white");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][9], 255);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][9], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][9], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][9], 255);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][9], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][9], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][9], 1010580735);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][9], 2.000000, 2.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][9], 0);

	phone_PTextDraw[playerid][10] = CreatePlayerTextDraw(playerid,511.000000, 252.000000, "T");
	PlayerTextDrawAlignment(playerid,phone_PTextDraw[playerid][10], 2);
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][10], 20);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][10], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][10], 0.239999, 0.799998);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][10], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][10], 0);

	phone_PTextDraw[playerid][11] = CreatePlayerTextDraw(playerid,518.000000, 376.000000, "select");
	PlayerTextDrawAlignment(playerid,phone_PTextDraw[playerid][11], 2);
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][11], 673720520);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][11], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][11], 0.150000, 0.899999);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][11], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][11], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][11], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][11], 673720470);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][11], 578.000000, -25.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][11], 0);

	phone_PTextDraw[playerid][12] = CreatePlayerTextDraw(playerid,510.000000, 266.000000, "Call");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][12], 0x00000000);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][12], 0.170000, 0.999998);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][12], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][12], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][12], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][12], 0x00000000);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][12], 578.000000, -61.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][12], 0);

	phone_PTextDraw[playerid][13] = CreatePlayerTextDraw(playerid,510.000000, 278.000000, "Contacts");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][13], 0x00000000);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][13], 0.170000, 0.999998);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][13], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][13], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][13], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][13], 0x00000000);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][13], 578.000000, -61.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][13], 0);

	phone_PTextDraw[playerid][14] = CreatePlayerTextDraw(playerid,510.000000, 290.000000, "Events");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][14], 0x00000000);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][14], 0.170000, 0.999998);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][14], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][14], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][14], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][14], 0x00000000);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][14], 578.000000, -61.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][14], 0);

	phone_PTextDraw[playerid][15] = CreatePlayerTextDraw(playerid,510.000000, 302.000000, "Advertisements");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][15], 0x00000000);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][15], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][15], 0.170000, 0.999998);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][15], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][15], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][15], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][15], 0x00000000);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][15], 578.000000, -61.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][15], 0);

	phone_PTextDraw[playerid][16] = CreatePlayerTextDraw(playerid,510.000000, 314.000000, "Music");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][16], 0x00000000);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][16], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][16], 0.170000, 0.999998);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][16], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][16], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][16], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][16], 0x00000000);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][16], 578.000000, -61.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][16], 0);

	phone_PTextDraw[playerid][17] = CreatePlayerTextDraw(playerid,510.000000, 326.000000, "Videos");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][17], 0x00000000);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][17], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][17], 0.170000, 0.999997);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][17], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][17], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][17], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][17], 0x00000000);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][17], 578.000000, -61.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][17], 0);

	phone_PTextDraw[playerid][18] = CreatePlayerTextDraw(playerid,510.000000, 338.000000, "Doogle Maps");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][18], 0x00000000);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][18], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][18], 0.170000, 0.999997);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][18], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][18], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][18], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][18], 0x00000000);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][18], 578.000000, -61.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][18], 0);

	phone_PTextDraw[playerid][19] = CreatePlayerTextDraw(playerid,510.000000, 350.000000, "Camera");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][19], 0x00000000);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][19], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][19], 0.170000, 0.999997);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][19], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][19], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][19], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][19], 0x00000000);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][19], 578.000000, -61.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][19], 0);

	phone_PTextDraw[playerid][20] = CreatePlayerTextDraw(playerid,510.000000, 362.000000, "Settings");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][20], 0x00000000);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][20], 1);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][20], 0.170000, 0.999997);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][20], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][20], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][20], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][20], 0x00000000);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][20], 578.000000, -61.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][20], 0);

	phone_PTextDraw[playerid][21] = CreatePlayerTextDraw(playerid,514.000000, 258.000000, "LD_DUAL:white");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][21], 255);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][21], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][21], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][21], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][21], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][21], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][21], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][21], 255);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][21], 1.000000, -2.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][21], 0);

	phone_PTextDraw[playerid][22] = CreatePlayerTextDraw(playerid,516.000000, 258.000000, "LD_DUAL:white");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][22], 255);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][22], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][22], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][22], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][22], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][22], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][22], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][22], 255);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][22], 1.000000, -3.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][22], 0);

	phone_PTextDraw[playerid][23] = CreatePlayerTextDraw(playerid,518.000000, 258.000000, "LD_DUAL:white");
	PlayerTextDrawBackgroundColor(playerid,phone_PTextDraw[playerid][23], 255);
	PlayerTextDrawFont(playerid,phone_PTextDraw[playerid][23], 4);
	PlayerTextDrawLetterSize(playerid,phone_PTextDraw[playerid][23], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,phone_PTextDraw[playerid][23], -1);
	PlayerTextDrawSetOutline(playerid,phone_PTextDraw[playerid][23], 0);
	PlayerTextDrawSetProportional(playerid,phone_PTextDraw[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid,phone_PTextDraw[playerid][23], 1);
	PlayerTextDrawUseBox(playerid,phone_PTextDraw[playerid][23], 1);
	PlayerTextDrawBoxColor(playerid,phone_PTextDraw[playerid][23], 255);
	PlayerTextDrawTextSize(playerid,phone_PTextDraw[playerid][23], 1.000000, -5.000000);
	PlayerTextDrawSetSelectable(playerid,phone_PTextDraw[playerid][23], 0);
}
