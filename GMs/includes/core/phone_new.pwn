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
	"splash1:splash1",
	"splash2:splash2",
	"cityhall_sfs:ws_copart1",
	"cityhall_sfs:ws_copart2",
	"cityhall_sfs:ws_copart3",
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

new Text:PhoneWP[sizeof(szPhoneWP)],
	Text:PhoneTD[56];


timer Phone_StopRingtone[10000](iPlayerID) {

	PlayerPlaySound(iPlayerID, 1188, 0.0, 0.0, 0.0);
	return 1;
}

hook OnGameModeInit()
{
	Phone_InitTD();
	Phone_InitRadioTowers();
}


hook OnGameModeExit()
{
	for(new i; i < sizeof(PhoneWP); ++i) TextDrawHideForAll(PhoneWP[i]), TextDrawDestroy(PhoneWP[i]);
	for(new i; i < sizeof(PhoneTD); ++i) TextDrawHideForAll(PhoneTD[i]), TextDrawDestroy(PhoneTD[i]);
	return 1;
}

hook OnPlayerConnect(playerid)
{
	Bit_Off(g_PlayerBits[playerid], phone_bitState);
	return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_ANALOG_RIGHT)
	{
		if(Bit_State(g_PlayerBits[playerid], phone_bitCamState)) {

			new Float:fPos[4],
				Float:fCam[2];

		    GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
		    GetPlayerFacingAngle(playerid, fPos[3]);

		    if(fPos[3] >= 360) fPos[3] = 0;
		    fPos[3] += 1.25;
		    fCam[0] = fPos[0] + 1.4 * floatcos(fPos[3], degrees);
		    fCam[1] = fPos[1] + 1.4 * floatsin(fPos[3], degrees);
		    SetPlayerCameraPos(playerid, fCam[0], fCam[1], fPos[2] + 1);
		    SetPlayerCameraLookAt(playerid, fPos[0], fPos[1], fPos[2] + 1);
		    SetPlayerFacingAngle(playerid, fPos[3] - 90.0);
		}
	}
	if(newkeys & KEY_ANALOG_LEFT)
	{
		if(Bit_State(g_PlayerBits[playerid], phone_bitCamState)) {

			new Float:fPos[4],
				Float:fCam[2];

		    GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
		    GetPlayerFacingAngle(playerid, fPos[3]);

		    if(fPos[3] >= 360) fPos[3] = 0;

		    fPos[3] -= 1.25;
		    fCam[0] = fPos[0] + 1.4 * floatcos(fPos[3], degrees);
		    fCam[1] = fPos[1] + 1.4 * floatsin(fPos[3], degrees);
		    SetPlayerCameraPos(playerid, fCam[0], fCam[1], fPos[2] + 1);
		    SetPlayerCameraLookAt(playerid, fPos[0], fPos[1], fPos[2] + 1);
		    SetPlayerFacingAngle(playerid, fPos[3] - 90.0);
		}
	}
	return 1;
}

/*
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_CROUCH) {

		if(Bit_State(g_PlayerBits[playerid], phone_bitCamState)) {

			new step = GetPVarInt(playerid, "SELF_CAM");
			if(step > 10) cmd_selfie(playerid, "");
			SetPVarInt(playerid, "SELF_CAM", step++);
			new Float:fPos[3];
			GetPlayerCameraPos(playerid, fPos[0], fPos[1], fPos[2]);
			SetPlayerCameraLookAt(playerid, fPos[0], fPos[1], fPos[2] + 0.70);
			GetXYInFrontOfPlayer(playerid, fPos[0], fPos[1], 1.0);
			fPos[0] += 0.25;
			SetPlayerCameraPos(playerid, fPos[0], fPos[1], fPos[2] + 0.70);
		}
	}
	if(newkeys & KEY_SPRINT) {

		if(Bit_State(g_PlayerBits[playerid], phone_bitCamState)) {
			
			new step = GetPVarInt(playerid, "SELF_CAM");
			if(step > 10) cmd_selfie(playerid, "");
			SetPVarInt(playerid, "SELF_CAM", step--);

			new Float:fPos[3];
			GetPlayerCameraPos(playerid, fPos[0], fPos[1], fPos[2]);
			SetPlayerCameraLookAt(playerid, fPos[0], fPos[1], fPos[2] + 0.70);
			GetXYInFrontOfPlayer(playerid, fPos[0], fPos[1], 1.0);
			fPos[0] -= 0.25;
			SetPlayerCameraPos(playerid, fPos[0], fPos[1], fPos[2] + 0.70);
		}
	}

}
*/
hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == PhoneTD[21]) Phone_Call(playerid);
	if(clickedid == PhoneTD[22] || clickedid == PhoneTD[23]) Phone_Contacts(playerid);
	if(clickedid == PhoneTD[24]) Phone_Ads(playerid);
	if(clickedid == PhoneTD[27]) Phone_House(playerid);
	if(clickedid == PhoneTD[20] || clickedid == PhoneTD[25] || clickedid == PhoneTD[26]) Phone_Settings(playerid);
	if(clickedid == PhoneTD[30]) Phone_Camera(playerid);
	if(clickedid == PhoneTD[38]) Phone_Music(playerid);
	if(clickedid == PhoneTD[43]) Phone_Map(playerid);
	if(clickedid == PhoneTD[50] || clickedid == PhoneTD[51]) Phone_SAN(playerid);
	if(clickedid == PhoneTD[53]) Phone_Medic(playerid);
	if(clickedid == PhoneTD[55]) Phone_MDC(playerid);
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
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
				case 0: ShowPlayerDialog(playerid, DIALOG_PHONE_YPAGES, DIALOG_STYLE_TABLIST_HEADERS, "Yellow Pages", "Name\tPhone Number\n\
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

					for(new i = 0; i < MAX_PAYPHONES; ++i) {

						if(IsValidDynamicArea(arrPayPhoneData[i][pp_iAreaID])) {

							GetPhoneZone(i, szZone, sizeof(szZone));
							format(szMiscArray, sizeof(szMiscArray), "%sArea: %d | Number: %d | Zone: %s\n", szMiscArray, GetPhoneAreaCode(i), arrPayPhoneData[i][pp_iNumber], szZone);
							ListItemTrackId[playerid][x++] = i;
						}
					}
					if(isnull(szMiscArray)) return SendClientMessageEx(playerid, COLOR_GRAD1, "There are no pay phones.");
					ShowPlayerDialog(playerid, DIALOG_PHONE_PAYPHONES, DIALOG_STYLE_LIST, "Pay Phones", szMiscArray, "Call", "Cancel");
				}
				case 2:	{

					format(szMiscArray, sizeof(szMiscArray), "SELECT `contactid` FROM `phone_contacts` WHERE `id` = '%d'", GetPlayerSQLId(playerid));
					mysql_function_query(MainPipeline, szMiscArray, true, "Phone_OnGetContacts", "i", playerid);
				}
				case 3: ShowPlayerDialog(playerid, DIALOG_PHONE_ADDCONTACT, DIALOG_STYLE_INPUT, "Phone | Add Contact", "Please enter the name of the contact you would like to add.\nExample: John_Doe", "Add", "<<");
				case 4: {

					SetPVarInt(playerid, PVAR_PHONEDELCONTACT, 1);
					format(szMiscArray, sizeof(szMiscArray), "SELECT `contactid` FROM `phone_contacts` WHERE `id` = '%d'", GetPlayerSQLId(playerid));
					mysql_function_query(MainPipeline, szMiscArray, true, "Phone_OnGetContacts", "i", playerid);
				}
			}
		}
		case DIALOG_PHONE_YPAGES: {

			if(!response) return Phone_Contacts(playerid), 1;
			switch(listitem) {

				case 0: {

					return ShowPlayerDialog(playerid, DIALOG_PHONE_BUSINESSES, DIALOG_STYLE_LIST, "Yellow Pages | Businesses", "\
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

				return ShowPlayerDialog(playerid, DIALOG_PHONE_YPAGES, DIALOG_STYLE_TABLIST_HEADERS, "Yellow Pages", "Name\tPhone Number\n\
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

				return ShowPlayerDialog(playerid, DIALOG_PHONE_BUSINESSES, DIALOG_STYLE_LIST, "Yellow Pages | Businesses", "\
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
			if(!response) return Phone_Contacts(playerid), 1;
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `contactid` FROM `phone_contacts` WHERE `id` = '%d'", GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, szMiscArray, true, "Phone_CheckContact", "is", playerid, inputtext);
			DeletePVar(playerid, PVAR_PHONEDELCONTACT);	
		}
		case DIALOG_PHONE_CONTACTLISTDEL:
		{
			if(!response) return DeletePVar(playerid, PVAR_PHONEDELCONTACT), Phone_Contacts(playerid), 1;
			format(szMiscArray, sizeof(szMiscArray), "SELECT `id` FROM `accounts` WHERE `PhoneNr` = '%d'", ListItemTrackId[playerid][listitem]);
			mysql_function_query(MainPipeline, szMiscArray, true, "Phone_OnDeleteContact", "i", playerid);
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
					ShowPlayerDialog(playerid, DIALOG_PHONE_RINGTONES, DIALOG_STYLE_LIST, "Phone | Ringtones", "\
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
					Phone_ShowRingTones(playerid);
				}
			}
		}
		case DIALOG_PHONE_RINGTONES:
		{
			if(!response) Phone_Settings(playerid);
			PlayerPlaySound(playerid, iPhoneRingTone[listitem], 0.0, 0.0, 0.0);
			SetPVarInt(playerid, PVAR_PLAYINGRINGTONE, listitem);
			ShowPlayerDialog(playerid, DIALOG_PHONE_RINGTONES2, DIALOG_STYLE_MSGBOX, "Phone | Ringtones | Preview", "Press 'Select' to confirm.\nPress 'Cancel' to cancel.", "Select", "Cancel");
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
			if(!response) Phone_Settings(playerid);
			Phone_ShowWallPaper(playerid, listitem);
			Phone_Settings(playerid);
		}
	}
	return 1;
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
	ShowPlayerDialog(playerid, DIALOG_PHONE_BUSINESSES2, DIALOG_STYLE_TABLIST, "San Andreas | Map | Businesses", szMiscArray, "Select", "Back");
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

	if(Bit_State(g_PlayerBits[playerid], phone_bitTraceState)) {

		DisablePlayerCheckpoint(playerid);
		GangZoneDestroy(GetPVarInt(playerid, "PTR_GZ"));
		DeletePVar(playerid, "PTR_GZ");
		Bit_Off(g_PlayerBits[playerid], phone_bitTraceState);
		return SendClientMessageEx(playerid, COLOR_GRAD1, "[Phone]: Quit GPS traceroute process. All geographical data has been deleted.");
	}

	if(PlayerInfo[playerid][pJob] != 1 && PlayerInfo[playerid][pJob2] != 1 && PlayerInfo[playerid][pJob3] != 1) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You're not a detective.");
	}
	if(gettime() < UsedFind[playerid]) {
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

			Bit_On(g_PlayerBits[playerid], phone_bitTraceState);
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

	GetPlayerPos(playerid, fPos[0][0], fPos[0][1], fPos[0][2]);

	if(x == 0) format(szMiscArray, sizeof(szMiscArray), "{DDDDDD}Target specified: %d\nGPS Traceroute in progress...\n______________________________________\n\n", PlayerInfo[playerid][pPnumber]);

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


		// SetPlayerCheckpoint(playerid, fPos[0][0], fPos[0][1], fPos[0][2], 2.0);

		format(szMiscArray, sizeof(szMiscArray), "%s\n\
			\n_____________________________________\n\n\
			{FFFFFF}%d's position has been determined: {FFFF00}%s.", szMiscArray, PlayerInfo[playerid][pPnumber], arrRadioTowerData[x][rt_szName], szStrength, PlayerInfo[playerid][pPnumber], szZone);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Trace Number", szMiscArray, "-----", "");
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
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Trace Number", szMiscArray, "Tracing...", "");
	}
	SetPVarString(playerid, "TRC_STR", szMiscArray);
	SetPVarInt(playerid, "TRC_STP", x + 1);
	SetTimerEx("Phone_Trace", 1000, false, "ii", playerid, i);
	return 1;
}


forward Phone_OnGetContacts(iPlayerID);
public Phone_OnGetContacts(iPlayerID)
{
	new iRows = cache_get_row_count();
	if(!iRows) return SendClientMessage(iPlayerID, COLOR_GRAD1, "You do not have any contacts.");
	if(iRows >= MAX_CONTACTS) return SendClientMessage(iPlayerID, COLOR_GRAD1, "You cannot have more contacts stored in your phone.");
	new iFields,
		idx;
	cache_get_data(iRows, iFields, MainPipeline);
	while(idx < iRows)
	{
		format(szMiscArray, sizeof(szMiscArray), "SELECT `Username`, `PhoneNr` FROM `accounts` WHERE `id` = '%d'", cache_get_field_content_int(idx, "contactid", MainPipeline));
		mysql_function_query(MainPipeline, szMiscArray, true, "Phone_OnGetContactName", "i", iPlayerID);
		idx++;
	}
	return 1;
}

forward Phone_OnGetContactName(iPlayerID);
public Phone_OnGetContactName(iPlayerID)
{
	new iRows = cache_get_row_count(),
		iFields,
		idx,
		szResult[MAX_PLAYER_NAME + 48];

	cache_get_data(iRows, iFields, MainPipeline);
	szMiscArray = "Name\tNumber\n";
	while(idx < iRows)
	{
		new iNumber = cache_get_field_content_int(idx, "PhoneNr", MainPipeline);
		if(iNumber != 0) {

			//foreach(new i : Player) {

			//if(PlayerInfo[i][pPnumber] == iNumber) format(szResult, sizeof(szResult), "{00FF00}[O] {FFFFFF}%s", szResult);
			//else format(szResult, sizeof(szResult), "{FF0000}[O] {FFFFFF}%s", szResult);
			cache_get_field_content(idx, "Username", szResult, MainPipeline);
		}
		
		format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d\n", szMiscArray, szResult, iNumber);
		ListItemTrackId[iPlayerID][idx] = iNumber;
		idx++;
	}
	if(GetPVarType(iPlayerID, PVAR_PHONEDELCONTACT)) return ShowPlayerDialog(iPlayerID, DIALOG_PHONE_CONTACTLISTDEL, DIALOG_STYLE_TABLIST_HEADERS, "Phone | Delete Contact", szMiscArray, "Delete", "<<");
	ShowPlayerDialog(iPlayerID, DIALOG_PHONE_CONTACTLIST, DIALOG_STYLE_TABLIST_HEADERS, "Phone | Contact List", szMiscArray, "Call", "<<");
	return 1;	
}

forward Phone_OnAddContact(iPlayerID);
public Phone_OnAddContact(iPlayerID)
{
	new iRows = cache_get_row_count();
	if(!iRows) return SendClientMessage(iPlayerID, COLOR_GRAD1, "That name does not exist in the phonebook.");
	new iFields;
	cache_get_data(iRows, iFields, MainPipeline);
	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `phone_contacts` (`id`, `contactid`) VALUES ('%d', '%d')", GetPlayerSQLId(iPlayerID), cache_get_field_content_int(0, "id", MainPipeline));
	mysql_function_query(MainPipeline, szMiscArray, false, "Phone_OnAddContactFinish", "i", iPlayerID);
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
	new iRows = cache_get_row_count();
	DeletePVar(iPlayerID, PVAR_PHONEDELCONTACT);
	if(!iRows) return SendClientMessage(iPlayerID, COLOR_GRAD1, "Something went wrong. Please try again later.");
	new iFields;
	cache_get_data(iRows, iFields, MainPipeline);
	format(szMiscArray, sizeof(szMiscArray), "DELETE FROM `phone_contacts` WHERE `id` = '%d' AND `contactid` = '%d'", GetPlayerSQLId(iPlayerID), cache_get_field_content_int(0, "id", MainPipeline));
	mysql_function_query(MainPipeline, szMiscArray, false, "Phone_OnDeleteContactFinish", "i", iPlayerID);
	return 1;
}

forward Phone_OnDeleteContactFinish(iPlayerID);
public Phone_OnDeleteContactFinish(iPlayerID)
{
	if(mysql_errno()) return SendClientMessage(iPlayerID, COLOR_GRAD1, "Something went wrong. Please try again later.");
	SendClientMessage(iPlayerID, COLOR_YELLOW, "[PHONE] {DDDDDD} You have successfully deleted the contact.");
	Phone_Contacts(iPlayerID);
	return 1;
}

forward Phone_CheckContact(iPlayerID, name[]);
public Phone_CheckContact(iPlayerID, name[])
{
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `id`, `PhoneNr` FROM `accounts` WHERE `Username` = '%e' AND `PhoneNr` != 0", name);
	mysql_function_query(MainPipeline, szMiscArray, true, "Phone_OnAddContact", "i", iPlayerID);
	return 1;	
}

Phone_Calling(iPlayerID, iCallerID)
{
	if(GetPVarType(iPlayerID, "PayPhone") || GetPVarType(iCallerID, "PayPhone")) return 1;
	/*
	Phone_Main(iPlayerID);
	TextDrawSetString(PhoneTD[33], "Calling");
	TextDrawSetString(PhoneTD[34], GetPlayerNameEx(iCallerID));
	format(szMiscArray, sizeof(szMiscArray), "%d", PlayerInfo[iCallerID][pPnumber]);
	TextDrawSetString(PhoneTD[36], szMiscArray);
	for(new i = 32; i < 37; ++i)
	{
		TextDrawShowForPlayer(iPlayerID, PhoneTD[i]);
	}
	*/
	Phone_ReceiveCall(iCallerID, iPlayerID);
	return 1;
}

Phone_ReceiveCall(iPlayerID, iCallerID)
{
	new Float:fPos[3];
	
	if(!Bit_State(g_PlayerBits[iPlayerID], phone_bitState))
	{
		Bit_On(g_PlayerBits[iPlayerID], phone_bitState);
		TextDrawShowForPlayer(iPlayerID, PhoneWP[PlayerInfo[iPlayerID][pWallpaper]]);
		for(new i; i < 32; ++i) TextDrawShowForPlayer(iPlayerID, PhoneTD[i]);
		Phone_PhoneColor(iPlayerID);
		for(new i = 37; i < sizeof(PhoneTD); ++i) TextDrawShowForPlayer(iPlayerID, PhoneTD[i]);
	}

	GetPlayerPos(iPlayerID, fPos[0], fPos[1], fPos[2]);
	PlayerPlaySound(iPlayerID, iPhoneRingTone[PlayerInfo[iPlayerID][pRingtone]], 0.0, 0.0, 0.0);
	
	foreach(new i : Player)	{

		if(IsPlayerInRangeOfPoint(i, 10.0, fPos[0], fPos[1], fPos[2])) {

			PlayerPlaySound(i, iPhoneRingTone[PlayerInfo[iPlayerID][pRingtone]], fPos[0], fPos[1], fPos[2]);
			defer Phone_StopRingtone(iPlayerID);
		}
	}

	TextDrawSetString(PhoneTD[33], "Caller");
	TextDrawSetString(PhoneTD[34], GetPlayerNameEx(iCallerID));
	format(szMiscArray, sizeof(szMiscArray), PlayerInfo[iCallerID][pPnumber]);
	TextDrawSetString(PhoneTD[36], szMiscArray);

	for(new i = 32; i < 37; ++i)
	{
		TextDrawShowForPlayer(iPlayerID, PhoneTD[i]);
	}
}

Phone_PickupCall(iPlayerID, iCallerID)
{
	PlayerPlaySound(iPlayerID, iPhoneRingTone[PlayerInfo[iPlayerID][pRingtone]] + 1, 0.0, 0.0, 0.0);
	PlayerPlaySound(iCallerID, iPhoneRingTone[PlayerInfo[iCallerID][pRingtone]] + 1, 0.0, 0.0, 0.0);
}

Phone_HangupCall(iPlayerID, iCallerID)
{
	PlayerPlaySound(iPlayerID, iPhoneRingTone[PlayerInfo[iPlayerID][pRingtone]] + 1, 0.0, 0.0, 0.0);
	PlayerPlaySound(iCallerID, iPhoneRingTone[PlayerInfo[iPlayerID][pRingtone]] + 1, 0.0, 0.0, 0.0);
	for(new i = 32; i < 37; ++i)
	{
		TextDrawHideForPlayer(iPlayerID, PhoneTD[i]);
		TextDrawHideForPlayer(iCallerID, PhoneTD[i]);
	}	
}

Phone_Call(iPlayerID)
{
	ShowPlayerDialog(iPlayerID, DIALOG_PHONE_DIAL, DIALOG_STYLE_INPUT, "Phone | Dial Number", "Please insert the number you would like to dial.", "Dial", "<<");
}

Phone_Contacts(iPlayerID)
{
	ShowPlayerDialog(iPlayerID, DIALOG_PHONE_CONTACTS, DIALOG_STYLE_LIST, "Phone | Address Book", "\
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

Phone_House(iPlayerID) {

	cmd_houselistings(iPlayerID, "");
}

Phone_Camera(iPlayerID)
{
	ShowPlayerDialog(iPlayerID, DIALOG_PHONE_CAMERA, DIALOG_STYLE_LIST, "Phone | Camera", "Back camera\nFront camera\nReset", "Select", "<<");
}

Phone_Settings(iPlayerID)
{
	ShowPlayerDialog(iPlayerID, DIALOG_PHONE_SETTINGS, DIALOG_STYLE_LIST, "Phone | Settings", "Ringtone\nWallpaper", "Select", "<<");
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

Phone_Medic(iPlayerID)
{
	cmd_call(iPlayerID, "911");	
}

Phone_MDC(iPlayerID)
{
	cmd_mdc(iPlayerID, "");	
}

Phone_LoadWallPapers()
{
	for(new i; i < sizeof(PhoneWP); ++i)
	{
		PhoneWP[i] = TextDrawCreate(491.500, 214.000, szPhoneWP[i]);
		TextDrawFont(PhoneWP[i], 4);
		TextDrawTextSize(PhoneWP[i], 103.000, 182.500);
		TextDrawColor(PhoneWP[i], -1);
		printf("%d | %s", i, szPhoneWP[i]);
	}
}

Phone_ShowWallPaper(iPlayerID, i)
{
	TextDrawHideForPlayer(iPlayerID, PhoneWP[PlayerInfo[iPlayerID][pWallpaper]]);
	PlayerInfo[iPlayerID][pWallpaper] = i;
	TextDrawShowForPlayer(iPlayerID, PhoneWP[i]);
}

Phone_ShowRingTones(iPlayerID)
{
	ShowPlayerDialog(iPlayerID, DIALOG_PHONE_WALLPAPERS, DIALOG_STYLE_LIST, "Phone | WallPapers", "\
		Vice City 1\n\
		Vice City 2\n\
		Cop Art 1\n\
		Cop Art 2\n\
		Cop Art 3\n\
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

CMD:pcl(playerid)
{
	SelectTextDraw(playerid, 0xF6FBFCFF);
	return 1;
}

Phone_PhoneColorMenu(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_PHONE_COLOR, DIALOG_STYLE_LIST, "Phone - Select color", "Black\nWhite\nRed\nPink\nOrange\nBrown\nYellow\nGreen\nBlue\nLight Baby Blue", "Choose", "");
}

Phone_PhoneColor(playerid)
{
	new color;
	switch(PlayerInfo[playerid][pPhoneColor])
	{
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
	for(new i; i < 7; ++i)
	{
		if(1 <= i <= 4) TextDrawColor(PhoneTD[i], color);
		TextDrawBoxColor(PhoneTD[i], color);
		TextDrawBackgroundColor(PhoneTD[i], color);
		TextDrawShowForPlayer(playerid, PhoneTD[i]);
	}
}

CMD:phone(playerid, params[])
{
	Phone_Main(playerid, 1);
	return 1;
}

Phone_Main(playerid, click = 0) {

	if(PlayerInfo[playerid][pPnumber] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have a cell phone.");
	if(!Bit_State(g_PlayerBits[playerid], phone_bitState))
	{
		Bit_On(g_PlayerBits[playerid], phone_bitState);
		if(click) SelectTextDraw(playerid, 0xF6FBFCFF);
		TextDrawShowForPlayer(playerid, PhoneWP[PlayerInfo[playerid][pWallpaper]]);
		for(new i; i < 32; ++i) TextDrawShowForPlayer(playerid, PhoneTD[i]);
		Phone_PhoneColor(playerid);
		for(new i = 37; i < sizeof(PhoneTD); ++i) TextDrawShowForPlayer(playerid, PhoneTD[i]);
	}
	else
	{
		Bit_Off(g_PlayerBits[playerid], phone_bitState);
		if(click) CancelSelectTextDraw(playerid);
		TextDrawHideForPlayer(playerid, PhoneWP[PlayerInfo[playerid][pWallpaper]]);
		for(new i; i < sizeof(PhoneTD); ++i) TextDrawHideForPlayer(playerid, PhoneTD[i]);
		for(new i = 37; i < sizeof(PhoneTD); ++i) TextDrawHideForPlayer(playerid, PhoneTD[i]);
	}
	return 1;
}

CMD:picture(playerid, params[]) {

	if(!Bit_State(g_PlayerBits[playerid], phone_bitCamState))
	{
		Bit_On(g_PlayerBits[playerid], phone_bitCamState);
		new Float:fPos[3],
			Float:fPos2[3];
		
		GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
		GetPlayerCameraFrontVector(playerid, fPos2[0], fPos2[1], fPos2[2]);
		SetPlayerCameraPos(playerid, fPos[0], fPos[1], fPos[2]);
		SetPlayerCameraLookAt(playerid, fPos[0]+fPos2[0], fPos[1]+fPos2[1], fPos[2]+fPos2[2]);
		TogglePlayerControllable(playerid, 0);
	}
	else
	{
		Bit_Off(g_PlayerBits[playerid], phone_bitCamState);
		TogglePlayerControllable(playerid, 1);
		SetCameraBehindPlayer(playerid);
	}
	return 1;
}

CMD:selfie(playerid, params[]) {

	if(!Bit_State(g_PlayerBits[playerid], phone_bitCamState))
	{
		new Float:fPos[4],
			Float:fCam[2];

	    GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	    GetPlayerFacingAngle(playerid, fPos[3]);

	    fPos[3] += 1.25;
	    fCam[0] = fPos[0] + 1.4 * floatcos(fPos[3], degrees);
	    fCam[1] = fPos[1] + 1.4 * floatsin(fPos[3], degrees);
	    SetPlayerCameraPos(playerid, fCam[0], fCam[1], fPos[2] + 1);
	    SetPlayerCameraLookAt(playerid, fPos[0], fPos[1], fPos[2] + 1);
	    SetPlayerFacingAngle(playerid, fPos[3] - 90.0);

	    TogglePlayerControllable(playerid, false);
	    PlayAnimEx(playerid, "PED", "gang_gunstand", 4.1, 1, 1, 1, 1, 1, 1);
	    SendClientMessage(playerid, COLOR_GRAD1, "{DDDDDD}Select the camera app or use /selfie to go back. Use {FFFF00}/headmove {DDDDDD}to disable your head movement (look straight).");
	    Bit_On(g_PlayerBits[playerid], phone_bitCamState);
	  

	}
	else
	{
		Bit_Off(g_PlayerBits[playerid], phone_bitCamState);
		ClearAnimations(playerid, 1);
		TogglePlayerControllable(playerid, true);
		SetCameraBehindPlayer(playerid);
	}
	return 1;
}

Phone_InitTD()
{
	PhoneTD[0] = TextDrawCreate(543.000000, 206.000000, "back");
	TextDrawAlignment(PhoneTD[0], 2);
	TextDrawBackgroundColor(PhoneTD[0], 255);
	TextDrawFont(PhoneTD[0], 1);
	TextDrawLetterSize(PhoneTD[0], 0.300000, 22.100000);
	TextDrawColor(PhoneTD[0], 0);
	TextDrawSetOutline(PhoneTD[0], 0);
	TextDrawSetProportional(PhoneTD[0], 1);
	TextDrawSetShadow(PhoneTD[0], 1);
	TextDrawUseBox(PhoneTD[0], 1);
	TextDrawBoxColor(PhoneTD[0], 255);
	TextDrawTextSize(PhoneTD[0], 132.000000, 114.000000);
	TextDrawSetSelectable(PhoneTD[0], 0);

	PhoneTD[1] = TextDrawCreate(498.000000, 187.000000, "0");
	TextDrawAlignment(PhoneTD[1], 2);
	TextDrawBackgroundColor(PhoneTD[1], 255);
	TextDrawFont(PhoneTD[1], 1);
	TextDrawLetterSize(PhoneTD[1], 1.259999, 4.299997);
	TextDrawColor(PhoneTD[1], 255);
	TextDrawSetOutline(PhoneTD[1], 0);
	TextDrawSetProportional(PhoneTD[1], 1);
	TextDrawSetShadow(PhoneTD[1], 1);
	TextDrawSetSelectable(PhoneTD[1], 0);

	PhoneTD[2] = TextDrawCreate(588.000000, 187.000000, "0");
	TextDrawAlignment(PhoneTD[2], 2);
	TextDrawBackgroundColor(PhoneTD[2], 255);
	TextDrawFont(PhoneTD[2], 1);
	TextDrawLetterSize(PhoneTD[2], 1.259999, 4.299997);
	TextDrawColor(PhoneTD[2], 255);
	TextDrawSetOutline(PhoneTD[2], 0);
	TextDrawSetProportional(PhoneTD[2], 1);
	TextDrawSetShadow(PhoneTD[2], 1);
	TextDrawSetSelectable(PhoneTD[2], 0);

	PhoneTD[3] = TextDrawCreate(588.000000, 386.000000, "0");
	TextDrawAlignment(PhoneTD[3], 2);
	TextDrawBackgroundColor(PhoneTD[3], 255);
	TextDrawFont(PhoneTD[3], 1);
	TextDrawLetterSize(PhoneTD[3], 1.259999, 4.299997);
	TextDrawColor(PhoneTD[3], 255);
	TextDrawSetOutline(PhoneTD[3], 0);
	TextDrawSetProportional(PhoneTD[3], 1);
	TextDrawSetShadow(PhoneTD[3], 1);
	TextDrawSetSelectable(PhoneTD[3], 0);

	PhoneTD[4] = TextDrawCreate(498.000000, 389.000000, "0");
	TextDrawAlignment(PhoneTD[4], 2);
	TextDrawBackgroundColor(PhoneTD[4], 255);
	TextDrawFont(PhoneTD[4], 1);
	TextDrawLetterSize(PhoneTD[4], 1.259999, 3.899998);
	TextDrawColor(PhoneTD[4], 255);
	TextDrawSetOutline(PhoneTD[4], 0);
	TextDrawSetProportional(PhoneTD[4], 1);
	TextDrawSetShadow(PhoneTD[4], 1);
	TextDrawSetSelectable(PhoneTD[4], 0);

	PhoneTD[5] = TextDrawCreate(543.000000, 197.000000, "up");
	TextDrawAlignment(PhoneTD[5], 2);
	TextDrawBackgroundColor(PhoneTD[5], 255);
	TextDrawFont(PhoneTD[5], 1);
	TextDrawLetterSize(PhoneTD[5], 0.300000, 2.099999);
	TextDrawColor(PhoneTD[5], 0);
	TextDrawSetOutline(PhoneTD[5], 0);
	TextDrawSetProportional(PhoneTD[5], 1);
	TextDrawSetShadow(PhoneTD[5], 0);
	TextDrawUseBox(PhoneTD[5], 1);
	TextDrawBoxColor(PhoneTD[5], 255);
	TextDrawTextSize(PhoneTD[5], 132.000000, 98.000000);
	TextDrawSetSelectable(PhoneTD[5], 0);

	PhoneTD[6] = TextDrawCreate(543.000000, 400.000000, "below");
	TextDrawAlignment(PhoneTD[6], 2);
	TextDrawBackgroundColor(PhoneTD[6], 255);
	TextDrawFont(PhoneTD[6], 1);
	TextDrawLetterSize(PhoneTD[6], 0.300000, 2.099999);
	TextDrawColor(PhoneTD[6], 0);
	TextDrawSetOutline(PhoneTD[6], 0);
	TextDrawSetProportional(PhoneTD[6], 1);
	TextDrawSetShadow(PhoneTD[6], 0);
	TextDrawUseBox(PhoneTD[6], 1);
	TextDrawBoxColor(PhoneTD[6], 255);
	TextDrawTextSize(PhoneTD[6], 132.000000, 98.000000);
	TextDrawSetSelectable(PhoneTD[6], 0);

	PhoneTD[7] = TextDrawCreate(543.000000, 216.000000, "screen");
	TextDrawAlignment(PhoneTD[7], 2);
	TextDrawBackgroundColor(PhoneTD[7], 255);
	TextDrawFont(PhoneTD[7], 1);
	TextDrawLetterSize(PhoneTD[7], 0.300000, 19.799995);
	TextDrawColor(PhoneTD[7], 505290240);
	TextDrawSetOutline(PhoneTD[7], 0);
	TextDrawSetProportional(PhoneTD[7], 1);
	TextDrawSetShadow(PhoneTD[7], 0);
	TextDrawUseBox(PhoneTD[7], 1);
	TextDrawBoxColor(PhoneTD[7], 505290495);
	TextDrawTextSize(PhoneTD[7], 172.000000, 101.000000);
	TextDrawSetSelectable(PhoneTD[7], 0);

	Phone_LoadWallPapers();

	PhoneTD[8] = TextDrawCreate(528.000000, 200.000000, PHONE_NAME);
	TextDrawAlignment(PhoneTD[7], 2);
	TextDrawBackgroundColor(PhoneTD[8], 255);
	TextDrawFont(PhoneTD[8], 2);
	TextDrawLetterSize(PhoneTD[8], 0.209999, 0.999998);
	TextDrawColor(PhoneTD[8], -926365496);
	TextDrawSetOutline(PhoneTD[8], 0);
	TextDrawSetProportional(PhoneTD[8], 1);
	TextDrawSetShadow(PhoneTD[8], 0);
	TextDrawSetSelectable(PhoneTD[8], 0);

	PhoneTD[9] = TextDrawCreate(507.000000, 408.000000, "below");
	TextDrawAlignment(PhoneTD[9], 2);
	TextDrawBackgroundColor(PhoneTD[9], 255);
	TextDrawFont(PhoneTD[9], 1);
	TextDrawLetterSize(PhoneTD[9], 0.270000, -0.299998);
	TextDrawColor(PhoneTD[9], 0);
	TextDrawSetOutline(PhoneTD[9], 0);
	TextDrawSetProportional(PhoneTD[9], 1);
	TextDrawSetShadow(PhoneTD[9], 0);
	TextDrawUseBox(PhoneTD[9], 1);
	TextDrawBoxColor(PhoneTD[9], -1);
	TextDrawTextSize(PhoneTD[9], 98.000000, 7.000000);
	TextDrawSetSelectable(PhoneTD[9], 0);

	PhoneTD[10] = TextDrawCreate(507.000000, 411.000000, "dashleft-2");
	TextDrawAlignment(PhoneTD[10], 2);
	TextDrawBackgroundColor(PhoneTD[10], 255);
	TextDrawFont(PhoneTD[10], 1);
	TextDrawLetterSize(PhoneTD[10], 0.270000, -0.299998);
	TextDrawColor(PhoneTD[10], 0);
	TextDrawSetOutline(PhoneTD[10], 0);
	TextDrawSetProportional(PhoneTD[10], 1);
	TextDrawSetShadow(PhoneTD[10], 0);
	TextDrawUseBox(PhoneTD[10], 1);
	TextDrawBoxColor(PhoneTD[10], -1);
	TextDrawTextSize(PhoneTD[10], 98.000000, 7.000000);
	TextDrawSetSelectable(PhoneTD[10], 0);

	PhoneTD[11] = TextDrawCreate(577.000000, 412.000000, "arrow");
	TextDrawAlignment(PhoneTD[11], 2);
	TextDrawBackgroundColor(PhoneTD[11], 255);
	TextDrawFont(PhoneTD[11], 1);
	TextDrawLetterSize(PhoneTD[11], 0.270000, -0.299998);
	TextDrawColor(PhoneTD[11], 0);
	TextDrawSetOutline(PhoneTD[11], 0);
	TextDrawSetProportional(PhoneTD[11], 1);
	TextDrawSetShadow(PhoneTD[11], 0);
	TextDrawUseBox(PhoneTD[11], 1);
	TextDrawBoxColor(PhoneTD[11], -1);
	TextDrawTextSize(PhoneTD[11], 98.000000, 7.000000);
	TextDrawSetSelectable(PhoneTD[11], 0);

	PhoneTD[12] = TextDrawCreate(582.000000, 408.000000, "arrow-2");
	TextDrawAlignment(PhoneTD[12], 2);
	TextDrawBackgroundColor(PhoneTD[12], 255);
	TextDrawFont(PhoneTD[12], 1);
	TextDrawLetterSize(PhoneTD[12], 0.270000, 0.100000);
	TextDrawColor(PhoneTD[12], 0);
	TextDrawSetOutline(PhoneTD[12], 0);
	TextDrawSetProportional(PhoneTD[12], 1);
	TextDrawSetShadow(PhoneTD[12], 0);
	TextDrawUseBox(PhoneTD[12], 1);
	TextDrawBoxColor(PhoneTD[12], -1);
	TextDrawTextSize(PhoneTD[12], 98.000000, -2.000000);
	TextDrawSetSelectable(PhoneTD[12], 0);

	PhoneTD[13] = TextDrawCreate(545.000000, 407.000000, "midbut");
	TextDrawAlignment(PhoneTD[13], 2);
	TextDrawBackgroundColor(PhoneTD[13], 255);
	TextDrawFont(PhoneTD[13], 1);
	TextDrawLetterSize(PhoneTD[13], 0.270000, 0.200000);
	TextDrawColor(PhoneTD[13], 0);
	TextDrawSetOutline(PhoneTD[13], 0);
	TextDrawSetProportional(PhoneTD[13], 1);
	TextDrawSetShadow(PhoneTD[13], 0);
	TextDrawUseBox(PhoneTD[13], 1);
	TextDrawBoxColor(PhoneTD[13], 842150600);
	TextDrawTextSize(PhoneTD[13], 98.000000, -19.000000);
	TextDrawSetSelectable(PhoneTD[13], 0);

	PhoneTD[14] = TextDrawCreate(545.000000, 408.000000, "midbut2");
	TextDrawAlignment(PhoneTD[14], 2);
	TextDrawBackgroundColor(PhoneTD[14], 255);
	TextDrawFont(PhoneTD[14], 1);
	TextDrawLetterSize(PhoneTD[14], 0.270000, 0.000000);
	TextDrawColor(PhoneTD[14], 0);
	TextDrawSetOutline(PhoneTD[14], 0);
	TextDrawSetProportional(PhoneTD[14], 1);
	TextDrawSetShadow(PhoneTD[14], 0);
	TextDrawUseBox(PhoneTD[14], 1);
	TextDrawBoxColor(PhoneTD[14], -1);
	TextDrawTextSize(PhoneTD[14], 98.000000, -13.000000);
	TextDrawSetSelectable(PhoneTD[14], 0);

	PhoneTD[15] = TextDrawCreate(577.000000, 408.000000, "arrow-3");
	TextDrawAlignment(PhoneTD[15], 2);
	TextDrawBackgroundColor(PhoneTD[15], 255);
	TextDrawFont(PhoneTD[15], 1);
	TextDrawLetterSize(PhoneTD[15], 0.270000, -0.299998);
	TextDrawColor(PhoneTD[15], 0);
	TextDrawSetOutline(PhoneTD[15], 0);
	TextDrawSetProportional(PhoneTD[15], 1);
	TextDrawSetShadow(PhoneTD[15], 0);
	TextDrawUseBox(PhoneTD[15], 1);
	TextDrawBoxColor(PhoneTD[15], -1);
	TextDrawTextSize(PhoneTD[15], 97.000000, -13.000000);
	TextDrawSetSelectable(PhoneTD[15], 0);

	PhoneTD[16] = TextDrawCreate(507.000000, 230.000000, "call-app");
	TextDrawAlignment(PhoneTD[16], 2);
	TextDrawBackgroundColor(PhoneTD[16], 255);
	TextDrawFont(PhoneTD[16], 1);
	TextDrawLetterSize(PhoneTD[16], 0.319999, 1.899999);
	TextDrawColor(PhoneTD[16], 0);
	TextDrawSetOutline(PhoneTD[16], 0);
	TextDrawSetProportional(PhoneTD[16], 1);
	TextDrawSetShadow(PhoneTD[16], 0);
	TextDrawUseBox(PhoneTD[16], 1);
	TextDrawBoxColor(PhoneTD[16], 515781375);
	TextDrawTextSize(PhoneTD[16], 97.000000, -23.000000);
	TextDrawSetSelectable(PhoneTD[16], 1);

	PhoneTD[17] = TextDrawCreate(532.000000, 230.000000, "contacts-app");
	TextDrawAlignment(PhoneTD[17], 2);
	TextDrawBackgroundColor(PhoneTD[17], 255);
	TextDrawFont(PhoneTD[17], 1);
	TextDrawLetterSize(PhoneTD[17], 0.289999, 2.000000);
	TextDrawColor(PhoneTD[17], 0);
	TextDrawSetOutline(PhoneTD[17], 0);
	TextDrawSetProportional(PhoneTD[17], 1);
	TextDrawSetShadow(PhoneTD[17], 0);
	TextDrawUseBox(PhoneTD[17], 1);
	TextDrawBoxColor(PhoneTD[17], -847158529);
	TextDrawTextSize(PhoneTD[17], 97.000000, -23.000000);
	TextDrawSetSelectable(PhoneTD[17], 1);

	PhoneTD[18] = TextDrawCreate(557.000000, 230.000000, "adds-app");
	TextDrawAlignment(PhoneTD[18], 2);
	TextDrawBackgroundColor(PhoneTD[18], 255);
	TextDrawFont(PhoneTD[18], 1);
	TextDrawLetterSize(PhoneTD[18], 0.289999, 2.000000);
	TextDrawColor(PhoneTD[18], 0);
	TextDrawSetOutline(PhoneTD[18], 0);
	TextDrawSetProportional(PhoneTD[18], 1);
	TextDrawSetShadow(PhoneTD[18], 0);
	TextDrawUseBox(PhoneTD[18], 1);
	TextDrawBoxColor(PhoneTD[18], 506596095);
	TextDrawTextSize(PhoneTD[18], 97.000000, -23.000000);
	TextDrawSetSelectable(PhoneTD[18], 1);

	PhoneTD[19] = TextDrawCreate(582.000000, 230.000000, "house-app");
	TextDrawAlignment(PhoneTD[19], 2);
	TextDrawBackgroundColor(PhoneTD[19], 255);
	TextDrawFont(PhoneTD[19], 1);
	TextDrawLetterSize(PhoneTD[19], 0.289999, 2.000000);
	TextDrawColor(PhoneTD[19], 0);
	TextDrawSetOutline(PhoneTD[19], 0);
	TextDrawSetProportional(PhoneTD[19], 1);
	TextDrawSetShadow(PhoneTD[19], 0);
	TextDrawUseBox(PhoneTD[19], 1);
	TextDrawBoxColor(PhoneTD[19], 339492095);
	TextDrawTextSize(PhoneTD[19], 97.000000, -23.000000);
	TextDrawSetSelectable(PhoneTD[19], 1);

	PhoneTD[20] = TextDrawCreate(582.000000, 371.000000, "settings-app");
	TextDrawAlignment(PhoneTD[20], 2);
	TextDrawBackgroundColor(PhoneTD[20], 255);
	TextDrawFont(PhoneTD[20], 1);
	TextDrawLetterSize(PhoneTD[20], 0.289999, 2.000000);
	TextDrawColor(PhoneTD[20], 0);
	TextDrawSetOutline(PhoneTD[20], 0);
	TextDrawSetProportional(PhoneTD[20], 1);
	TextDrawSetShadow(PhoneTD[20], 0);
	TextDrawUseBox(PhoneTD[20], 1);
	TextDrawBoxColor(PhoneTD[20], 1010580735);
	TextDrawTextSize(PhoneTD[20], 97.000000, -23.000000);
	TextDrawSetSelectable(PhoneTD[20], 1);

	PhoneTD[21] = TextDrawCreate(515.000000, 227.000000, "]");
	TextDrawAlignment(PhoneTD[21], 2);
	TextDrawBackgroundColor(PhoneTD[21], 255);
	TextDrawFont(PhoneTD[21], 1);
	TextDrawLetterSize(PhoneTD[21], 0.730000, 2.099999);
	TextDrawColor(PhoneTD[21], -1);
	TextDrawSetOutline(PhoneTD[21], 0);
	TextDrawSetProportional(PhoneTD[21], 1);
	TextDrawSetShadow(PhoneTD[21], 0);
	TextDrawSetSelectable(PhoneTD[21], 1);
	TextDrawTextSize(PhoneTD[21], 15.000000, 15.000000);

	PhoneTD[22] = TextDrawCreate(528.000000, 227.000000, "l");
	TextDrawAlignment(PhoneTD[22], 2);
	TextDrawBackgroundColor(PhoneTD[22], 255);
	TextDrawFont(PhoneTD[22], 1);
	TextDrawLetterSize(PhoneTD[22], 1.579999, 2.499997);
	TextDrawColor(PhoneTD[22], -1);
	TextDrawSetOutline(PhoneTD[22], 0);
	TextDrawSetProportional(PhoneTD[22], 1);
	TextDrawSetShadow(PhoneTD[22], 0);
	TextDrawSetSelectable(PhoneTD[22], 1);
	TextDrawTextSize(PhoneTD[22], 15.000000, 15.000000);

	PhoneTD[23] = TextDrawCreate(537.000000, 227.000000, "l");
	TextDrawAlignment(PhoneTD[23], 2);
	TextDrawBackgroundColor(PhoneTD[23], 255);
	TextDrawFont(PhoneTD[23], 1);
	TextDrawLetterSize(PhoneTD[23], 1.579999, 2.499997);
	TextDrawColor(PhoneTD[23], -1);
	TextDrawSetOutline(PhoneTD[23], 0);
	TextDrawSetProportional(PhoneTD[23], 1);
	TextDrawSetShadow(PhoneTD[23], 0);
	TextDrawSetSelectable(PhoneTD[23], 1);
	TextDrawTextSize(PhoneTD[23], 15.000000, 15.000000);

	PhoneTD[24] = TextDrawCreate(557.000000, 227.000000, "$");
	TextDrawAlignment(PhoneTD[24], 2);
	TextDrawBackgroundColor(PhoneTD[24], 255);
	TextDrawFont(PhoneTD[24], 1);
	TextDrawLetterSize(PhoneTD[24], 0.649999, 2.400000);
	TextDrawColor(PhoneTD[24], -1);
	TextDrawSetOutline(PhoneTD[24], 0);
	TextDrawSetProportional(PhoneTD[24], 1);
	TextDrawSetShadow(PhoneTD[24], 0);
	TextDrawSetSelectable(PhoneTD[24], 1);
	TextDrawTextSize(PhoneTD[24], 15.000000, 15.000000);

	PhoneTD[25] = TextDrawCreate(581.500000, 363.500000, "x");
	TextDrawAlignment(PhoneTD[25], 2);
	TextDrawBackgroundColor(PhoneTD[25], 255);
	TextDrawFont(PhoneTD[25], 1);
	TextDrawLetterSize(PhoneTD[25], 0.719999, 2.699999);
	TextDrawColor(PhoneTD[25], -1);
	TextDrawSetOutline(PhoneTD[25], 0);
	TextDrawSetProportional(PhoneTD[25], 1);
	TextDrawSetShadow(PhoneTD[25], 0);
	TextDrawSetSelectable(PhoneTD[25], 1);
	TextDrawTextSize(PhoneTD[25], 15.000000, 15.000000);


	PhoneTD[26] = TextDrawCreate(581.500000, 363.500000, "+");
	TextDrawAlignment(PhoneTD[26], 2);
	TextDrawBackgroundColor(PhoneTD[26], 255);
	TextDrawFont(PhoneTD[26], 1);
	TextDrawLetterSize(PhoneTD[26], 0.819998, 3.199999);
	TextDrawColor(PhoneTD[26], -1);
	TextDrawSetOutline(PhoneTD[26], 0);
	TextDrawSetProportional(PhoneTD[26], 1);
	TextDrawSetShadow(PhoneTD[26], 0);
	TextDrawSetSelectable(PhoneTD[26], 1);
	TextDrawTextSize(PhoneTD[26], 15.000000, 15.000000);

	PhoneTD[27] = TextDrawCreate(581.000000, 225.000000, "H");
	TextDrawAlignment(PhoneTD[27], 2);
	TextDrawBackgroundColor(PhoneTD[27], 255);
	TextDrawFont(PhoneTD[27], 1);
	TextDrawLetterSize(PhoneTD[27], 0.729998, 2.899999);
	TextDrawColor(PhoneTD[27], -1);
	TextDrawSetOutline(PhoneTD[27], 0);
	TextDrawSetProportional(PhoneTD[27], 1);
	TextDrawSetShadow(PhoneTD[27], 0);
	TextDrawSetSelectable(PhoneTD[27], 1);
	TextDrawTextSize(PhoneTD[27], 15.000000, 15.000000);

	/* CAMERA APPLICATION */
	PhoneTD[28] = TextDrawCreate(506.000000, 371.000000, "camera-app");
	TextDrawAlignment(PhoneTD[28], 2);
	TextDrawBackgroundColor(PhoneTD[28], 255);
	TextDrawFont(PhoneTD[28], 1);
	TextDrawLetterSize(PhoneTD[28], 0.289999, 2.000000);
	TextDrawColor(PhoneTD[28], 0);
	TextDrawSetOutline(PhoneTD[28], 0);
	TextDrawSetProportional(PhoneTD[28], 1);
	TextDrawSetShadow(PhoneTD[28], 0);
	TextDrawUseBox(PhoneTD[28], 1);
	TextDrawBoxColor(PhoneTD[28], -932957441);
	TextDrawTextSize(PhoneTD[28], 97.000000, -23.000000);
	TextDrawSetSelectable(PhoneTD[28], 0);

	PhoneTD[29] = TextDrawCreate(506.000000, 375.000000, "o");
	TextDrawAlignment(PhoneTD[29], 2);
	TextDrawBackgroundColor(PhoneTD[29], 255);
	TextDrawFont(PhoneTD[29], 1);
	TextDrawLetterSize(PhoneTD[29], 0.529998, 0.999999);
	TextDrawColor(PhoneTD[29], 0);
	TextDrawSetOutline(PhoneTD[29], 0);
	TextDrawSetProportional(PhoneTD[29], 1);
	TextDrawSetShadow(PhoneTD[29], 0);
	TextDrawUseBox(PhoneTD[29], 1);
	TextDrawBoxColor(PhoneTD[29], 255);
	TextDrawTextSize(PhoneTD[29], 97.000000, -19.000000);
	TextDrawSetSelectable(PhoneTD[29], 0);

	PhoneTD[30] = TextDrawCreate(506.000000, 369.000000, "o");
	TextDrawAlignment(PhoneTD[30], 2);
	TextDrawBackgroundColor(PhoneTD[30], 255);
	TextDrawFont(PhoneTD[30], 1);
	TextDrawLetterSize(PhoneTD[30], 0.379998, 1.699999);
	TextDrawColor(PhoneTD[30], -1);
	TextDrawSetOutline(PhoneTD[30], 0);
	TextDrawSetProportional(PhoneTD[30], 1);
	TextDrawSetShadow(PhoneTD[30], 0);
	TextDrawSetSelectable(PhoneTD[30], 1);
	TextDrawTextSize(PhoneTD[30], 15.000000, 15.000000);

	PhoneTD[31] = TextDrawCreate(511.000000, 367.000000, "l");
	TextDrawAlignment(PhoneTD[31], 2);
	TextDrawBackgroundColor(PhoneTD[31], 255);
	TextDrawFont(PhoneTD[31], 1);
	TextDrawLetterSize(PhoneTD[31], 0.459998, 0.799999);
	TextDrawColor(PhoneTD[31], -1);
	TextDrawSetOutline(PhoneTD[31], 0);
	TextDrawSetProportional(PhoneTD[31], 1);
	TextDrawSetShadow(PhoneTD[31], 0);
	TextDrawSetSelectable(PhoneTD[31], 0);
	/* _______________ */

	/* CALLED */
	PhoneTD[32] = TextDrawCreate(543.000000, 295.000000, "caller-bground");
	TextDrawAlignment(PhoneTD[32], 2);
	TextDrawBackgroundColor(PhoneTD[32], 255);
	TextDrawFont(PhoneTD[32], 1);
	TextDrawLetterSize(PhoneTD[32], 0.289999, 1.599999);
	TextDrawColor(PhoneTD[32], 0);
	TextDrawSetOutline(PhoneTD[32], 0);
	TextDrawSetProportional(PhoneTD[32], 1);
	TextDrawSetShadow(PhoneTD[32], 0);
	TextDrawUseBox(PhoneTD[32], 1);
	TextDrawBoxColor(PhoneTD[32], 1010580735);
	TextDrawTextSize(PhoneTD[32], 97.000000, -107.000000);
	TextDrawSetSelectable(PhoneTD[32], 0);

	PhoneTD[33] = TextDrawCreate(527.000000, 280.000000, "caller");
	TextDrawBackgroundColor(PhoneTD[33], 255);
	TextDrawFont(PhoneTD[33], 2);
	TextDrawLetterSize(PhoneTD[33], 0.200000, 1.100000);
	TextDrawColor(PhoneTD[33], -1);
	TextDrawSetOutline(PhoneTD[33], 1);
	TextDrawSetProportional(PhoneTD[33], 1);
	TextDrawSetSelectable(PhoneTD[33], 0);

	PhoneTD[34] = TextDrawCreate(543.000000, 296.000000, "caller-name");
	TextDrawAlignment(PhoneTD[34], 2);
	TextDrawBackgroundColor(PhoneTD[34], 255);
	TextDrawFont(PhoneTD[34], 2);
	TextDrawLetterSize(PhoneTD[34], 0.200000, 1.100000);
	TextDrawColor(PhoneTD[34], -1);
	TextDrawSetOutline(PhoneTD[34], 1);
	TextDrawSetProportional(PhoneTD[34], 1);
	TextDrawSetSelectable(PhoneTD[34], 0);

	PhoneTD[35] = TextDrawCreate(543.000000, 326.000000, "caller-bground");
	TextDrawAlignment(PhoneTD[35], 2);
	TextDrawBackgroundColor(PhoneTD[35], 255);
	TextDrawFont(PhoneTD[35], 1);
	TextDrawLetterSize(PhoneTD[35], 0.289999, -0.000000);
	TextDrawColor(PhoneTD[35], 0);
	TextDrawSetOutline(PhoneTD[35], 0);
	TextDrawSetProportional(PhoneTD[35], 1);
	TextDrawSetShadow(PhoneTD[35], 0);
	TextDrawUseBox(PhoneTD[35], 1);
	TextDrawBoxColor(PhoneTD[35], 1010580735);
	TextDrawTextSize(PhoneTD[35], 97.000000, -107.000000);
	TextDrawSetSelectable(PhoneTD[35], 0);

	PhoneTD[36] = TextDrawCreate(544.000000, 312.000000, "caller-number");
	TextDrawAlignment(PhoneTD[36], 2);
	TextDrawBackgroundColor(PhoneTD[36], 255);
	TextDrawFont(PhoneTD[36], 2);
	TextDrawLetterSize(PhoneTD[36], 0.200000, 1.100000);
	TextDrawColor(PhoneTD[36], -925044481);
	TextDrawSetOutline(PhoneTD[36], 1);
	TextDrawSetProportional(PhoneTD[36], 1);
	TextDrawSetSelectable(PhoneTD[36], 0);
	/* ------------ END CALL ---------------- */

	PhoneTD[37] = TextDrawCreate(507.000000, 260.000000, "music-app");
	TextDrawAlignment(PhoneTD[37], 2);
	TextDrawBackgroundColor(PhoneTD[37], 255);
	TextDrawFont(PhoneTD[37], 1);
	TextDrawLetterSize(PhoneTD[37], 0.319999, 1.899999);
	TextDrawColor(PhoneTD[37], 0);
	TextDrawSetOutline(PhoneTD[37], 0);
	TextDrawSetProportional(PhoneTD[37], 1);
	TextDrawSetShadow(PhoneTD[37], 0);
	TextDrawUseBox(PhoneTD[37], 1);
	TextDrawBoxColor(PhoneTD[37], -936889601);
	TextDrawTextSize(PhoneTD[37], 97.000000, -23.000000);
	TextDrawSetSelectable(PhoneTD[37], 0);

	PhoneTD[38] = TextDrawCreate(507.000000, 251.000000, "-");
	TextDrawAlignment(PhoneTD[38], 2);
	TextDrawBackgroundColor(PhoneTD[38], 255);
	TextDrawFont(PhoneTD[38], 1);
	TextDrawLetterSize(PhoneTD[38], 0.749999, 2.099999);
	TextDrawColor(PhoneTD[38], -1);
	TextDrawSetOutline(PhoneTD[38], 0);
	TextDrawSetProportional(PhoneTD[38], 1);
	TextDrawSetShadow(PhoneTD[38], 0);
	TextDrawSetSelectable(PhoneTD[38], 1);
	TextDrawTextSize(PhoneTD[38], 15.000000, 15.000000);

	PhoneTD[39] = TextDrawCreate(504.000000, 259.000000, "l");
	TextDrawAlignment(PhoneTD[39], 2);
	TextDrawBackgroundColor(PhoneTD[39], 255);
	TextDrawFont(PhoneTD[39], 1);
	TextDrawLetterSize(PhoneTD[39], 0.529999, 1.699999);
	TextDrawColor(PhoneTD[39], -1);
	TextDrawSetOutline(PhoneTD[39], 0);
	TextDrawSetProportional(PhoneTD[39], 1);
	TextDrawSetShadow(PhoneTD[39], 0);
	TextDrawSetSelectable(PhoneTD[39], 0);

	PhoneTD[40] = TextDrawCreate(512.000000, 259.000000, "l");
	TextDrawAlignment(PhoneTD[40], 2);
	TextDrawBackgroundColor(PhoneTD[40], 255);
	TextDrawFont(PhoneTD[40], 1);
	TextDrawLetterSize(PhoneTD[40], 0.529999, 1.799999);
	TextDrawColor(PhoneTD[40], -1);
	TextDrawSetOutline(PhoneTD[40], 0);
	TextDrawSetProportional(PhoneTD[40], 1);
	TextDrawSetShadow(PhoneTD[40], 0);
	TextDrawSetSelectable(PhoneTD[40], 0);

	PhoneTD[41] = TextDrawCreate(503.000000, 266.000000, "o");
	TextDrawAlignment(PhoneTD[41], 2);
	TextDrawBackgroundColor(PhoneTD[41], 255);
	TextDrawFont(PhoneTD[41], 1);
	TextDrawLetterSize(PhoneTD[41], 0.379999, 1.200000);
	TextDrawColor(PhoneTD[41], -1);
	TextDrawSetOutline(PhoneTD[41], 0);
	TextDrawSetProportional(PhoneTD[41], 1);
	TextDrawSetShadow(PhoneTD[41], 0);
	TextDrawSetSelectable(PhoneTD[41], 0);

	PhoneTD[42] = TextDrawCreate(510.000000, 263.000000, "o");
	TextDrawAlignment(PhoneTD[42], 2);
	TextDrawBackgroundColor(PhoneTD[42], 255);
	TextDrawFont(PhoneTD[42], 1);
	TextDrawLetterSize(PhoneTD[42], 0.350000, 1.200000);
	TextDrawColor(PhoneTD[42], -1);
	TextDrawSetOutline(PhoneTD[42], 0);
	TextDrawSetProportional(PhoneTD[42], 1);
	TextDrawSetShadow(PhoneTD[42], 0);
	TextDrawSetSelectable(PhoneTD[42], 0);

    PhoneTD[43] = TextDrawCreate(521.500, 257.500, "LD_RACE:race00");
    TextDrawFont(PhoneTD[43], 4);
    TextDrawTextSize(PhoneTD[43], 20.500, 22.000);
    TextDrawColor(PhoneTD[43], -1);
    TextDrawSetSelectable(PhoneTD[43], 1);

    PhoneTD[44] = TextDrawCreate(492.000000, 216.000000, "menubar");
	TextDrawBackgroundColor(PhoneTD[44], 255);
	TextDrawFont(PhoneTD[44], 1);
	TextDrawLetterSize(PhoneTD[44], 0.500000, 0.799998);
	TextDrawColor(PhoneTD[44], 0);
	TextDrawSetOutline(PhoneTD[44], 0);
	TextDrawSetProportional(PhoneTD[44], 1);
	TextDrawSetShadow(PhoneTD[44], 0);
	TextDrawUseBox(PhoneTD[44], 1);
	TextDrawBoxColor(PhoneTD[44], 100);
	TextDrawTextSize(PhoneTD[44], 594.000000, 70.000000);
	TextDrawSetSelectable(PhoneTD[44], 0);

	PhoneTD[45] = TextDrawCreate(493.000000, 215.000000, "T-Mobile");
	TextDrawBackgroundColor(PhoneTD[45], 255);
	TextDrawFont(PhoneTD[45], 2);
	TextDrawLetterSize(PhoneTD[45], 0.109999, 0.700000);
	TextDrawColor(PhoneTD[45], -1);
	TextDrawSetOutline(PhoneTD[45], 0);
	TextDrawSetProportional(PhoneTD[45], 1);
	TextDrawSetShadow(PhoneTD[45], 0);
	TextDrawSetSelectable(PhoneTD[45], 0);

	PhoneTD[46] = TextDrawCreate(586.000000, 215.000000, "100%");
	TextDrawAlignment(PhoneTD[46], 2);
	TextDrawBackgroundColor(PhoneTD[46], 255);
	TextDrawFont(PhoneTD[46], 2);
	TextDrawLetterSize(PhoneTD[46], 0.109999, 0.700000);
	TextDrawColor(PhoneTD[46], -1);
	TextDrawSetOutline(PhoneTD[46], 0);
	TextDrawSetProportional(PhoneTD[46], 1);
	TextDrawSetShadow(PhoneTD[46], 0);
	TextDrawSetSelectable(PhoneTD[46], 0);

	PhoneTD[47] = TextDrawCreate(573.000000, 215.000000, "A");
	TextDrawAlignment(PhoneTD[47], 2);
	TextDrawBackgroundColor(PhoneTD[47], 255);
	TextDrawFont(PhoneTD[47], 2);
	TextDrawLetterSize(PhoneTD[47], 0.109999, 0.700000);
	TextDrawColor(PhoneTD[47], -65281);
	TextDrawSetOutline(PhoneTD[47], 0);
	TextDrawSetProportional(PhoneTD[47], 1);
	TextDrawSetShadow(PhoneTD[47], 0);
	TextDrawSetSelectable(PhoneTD[47], 0);

	PhoneTD[48] = TextDrawCreate(507.000000, 341.000000, "YT-app");
	TextDrawAlignment(PhoneTD[48], 2);
	TextDrawBackgroundColor(PhoneTD[48], 255);
	TextDrawFont(PhoneTD[48], 1);
	TextDrawLetterSize(PhoneTD[48], 0.289999, 2.000000);
	TextDrawColor(PhoneTD[48], 0);
	TextDrawSetOutline(PhoneTD[48], 0);
	TextDrawSetProportional(PhoneTD[48], 1);
	TextDrawSetShadow(PhoneTD[48], 0);
	TextDrawUseBox(PhoneTD[48], 1);
	TextDrawBoxColor(PhoneTD[48], -16776961);
	TextDrawTextSize(PhoneTD[48], 97.000000, -23.000000);
	TextDrawSetSelectable(PhoneTD[48], 1);

	PhoneTD[49] = TextDrawCreate(507.000000, 345.000000, "yt-back");
	TextDrawAlignment(PhoneTD[49], 2);
	TextDrawBackgroundColor(PhoneTD[49], 255);
	TextDrawFont(PhoneTD[49], 3);
	TextDrawLetterSize(PhoneTD[49], 0.369998, 1.099998);
	TextDrawColor(PhoneTD[49], 0);
	TextDrawSetOutline(PhoneTD[49], 0);
	TextDrawSetProportional(PhoneTD[49], 1);
	TextDrawSetShadow(PhoneTD[49], 0);
	TextDrawUseBox(PhoneTD[49], 1);
	TextDrawBoxColor(PhoneTD[49], -1);
	TextDrawTextSize(PhoneTD[49], 97.000000, -16.000000);
	TextDrawSetSelectable(PhoneTD[49], 1);

	PhoneTD[50] = TextDrawCreate(504.000000, 347.000000, "yt-i");
	TextDrawAlignment(PhoneTD[50], 2);
	TextDrawBackgroundColor(PhoneTD[50], 255);
	TextDrawFont(PhoneTD[50], 3);
	TextDrawLetterSize(PhoneTD[50], 0.369998, 0.699998);
	TextDrawColor(PhoneTD[50], 0);
	TextDrawSetOutline(PhoneTD[50], 0);
	TextDrawSetProportional(PhoneTD[50], 1);
	TextDrawSetShadow(PhoneTD[50], 0);
	TextDrawUseBox(PhoneTD[50], 1);
	TextDrawBoxColor(PhoneTD[50], -16776961);
	TextDrawTextSize(PhoneTD[50], 97.000000, -4.000000);
	TextDrawSetSelectable(PhoneTD[50], 1);

	PhoneTD[51] = TextDrawCreate(508.000000, 341.000000, ">");
	TextDrawAlignment(PhoneTD[51], 2);
	TextDrawBackgroundColor(PhoneTD[51], 255);
	TextDrawFont(PhoneTD[51], 3);
	TextDrawLetterSize(PhoneTD[51], 0.419997, 1.899999);
	TextDrawColor(PhoneTD[51], -16776961);
	TextDrawSetOutline(PhoneTD[51], 0);
	TextDrawSetProportional(PhoneTD[51], 1);
	TextDrawSetShadow(PhoneTD[51], 0);
	TextDrawTextSize(PhoneTD[51], 15.000000, 15.000000);
	TextDrawSetSelectable(PhoneTD[51], 1);

	PhoneTD[52] = TextDrawCreate(556.000000, 260.000000, "medic-app");
	TextDrawAlignment(PhoneTD[52], 2);
	TextDrawBackgroundColor(PhoneTD[52], 255);
	TextDrawFont(PhoneTD[52], 1);
	TextDrawLetterSize(PhoneTD[52], 0.289999, 2.000000);
	TextDrawColor(PhoneTD[52], 0);
	TextDrawSetOutline(PhoneTD[52], 0);
	TextDrawSetProportional(PhoneTD[52], 1);
	TextDrawSetShadow(PhoneTD[52], 0);
	TextDrawUseBox(PhoneTD[52], 1);
	TextDrawBoxColor(PhoneTD[52], -1);
	TextDrawTextSize(PhoneTD[52], 97.000000, -23.000000);
	TextDrawSetSelectable(PhoneTD[52], 1);

	PhoneTD[53] = TextDrawCreate(556.000000, 250.500000, "+");
	TextDrawAlignment(PhoneTD[53], 2);
	TextDrawBackgroundColor(PhoneTD[53], -1);
	TextDrawFont(PhoneTD[53], 1);
	TextDrawLetterSize(PhoneTD[53], 0.839999, 4.000000);
	TextDrawColor(PhoneTD[53], -16776961);
	TextDrawSetOutline(PhoneTD[53], 1);
	TextDrawSetProportional(PhoneTD[53], 1);
	TextDrawSetShadow(PhoneTD[53], 0);
	TextDrawTextSize(PhoneTD[53], 15.000000, 15.000000);
	TextDrawSetSelectable(PhoneTD[53], 1);

	PhoneTD[54] = TextDrawCreate(582.000000, 260.000000, "MDC-app");
	TextDrawAlignment(PhoneTD[54], 2);
	TextDrawBackgroundColor(PhoneTD[54], 255);
	TextDrawFont(PhoneTD[54], 1);
	TextDrawLetterSize(PhoneTD[54], 0.289999, 2.000000);
	TextDrawColor(PhoneTD[54], 0);
	TextDrawSetOutline(PhoneTD[54], 0);
	TextDrawSetProportional(PhoneTD[54], 1);
	TextDrawSetShadow(PhoneTD[54], 0);
	TextDrawUseBox(PhoneTD[54], 1);
	TextDrawBoxColor(PhoneTD[54], 1009961215);
	TextDrawTextSize(PhoneTD[54], 97.000000, -23.000000);
	TextDrawSetSelectable(PhoneTD[54], 0);

	PhoneTD[55] = TextDrawCreate(584.000000, 255.000000, "P");
	TextDrawAlignment(PhoneTD[55], 2);
	TextDrawBackgroundColor(PhoneTD[55], 255);
	TextDrawFont(PhoneTD[55], 1);
	TextDrawLetterSize(PhoneTD[55], 0.729998, 2.899999);
	TextDrawColor(PhoneTD[55], -1);
	TextDrawSetOutline(PhoneTD[55], 0);
	TextDrawSetProportional(PhoneTD[55], 1);
	TextDrawSetShadow(PhoneTD[55], 0);
	TextDrawSetSelectable(PhoneTD[55], 1);
	TextDrawTextSize(PhoneTD[55], 15.000000, 15.000000);
}