/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)

	Developers:
		(***) Austin
		(***) Connor
		(***) Jingles

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

#define		DIALOG_GPS_ONE				9800
#define		DIALOG_GPS_TWO				9801
#define		DIALOG_GPS_GEN				9802
#define		DIALOG_GPS_THREE			9984
#define		DIALOG_GPS_BCATS			9986
#define		DIALOG_GPS_BSELECT			9987
#define		DIALOG_GPS_BIZCONF			9988
#define		DIALOG_GPS_FAVS				9809
#define		DIALOG_GPS_SETFAV			9808
#define		DIALOG_GPS_SETFAVNAME		9708

#define 	DIALOG_MAP_BUSINESSES 		9709
#define 	DIALOG_MAP_BUSINESSES2 		9710
#define 	DIALOG_MAP_JOBS				9711

#define 	CHECKPOINT_GEN_LOCATION 	4500
#define 	CHECKPOINT_BUSINESS 		4501
#define 	CHECKPOINT_JOB 				4502
#define 	CHECKPOINT_DOOR				4503
#define 	CHECKPOINT_HOUSE			4504

#define		MAX_GPSFAV					(5)

/*
enum gpsFavs
{
	FavName[128],
	Float:FavPos[3]
}
new GPSFav[MAX_PLAYERS][MAX_GPSFAV][gpsFavs];
*/

new Float:gpsZones[][4] = {
	{1555.1693, -1675.6151, 16.1953}, // LSPD
	{626.9811,-571.8036,17.9207,110.9859}, // SASD
	{-1605.7848,710.9673,13.8672,175.0478}, // SFPD
	{327.9552,-1512.2510,36.0325,88.4196}, // FBI
	{-1944.2158,457.2660,35.1719,224.4054}, // FBI SF
	{-2028.5834,-100.6595,35.1641,235.1625}, // DOC
	{1295.7305,-2526.1033,13.9679,189.1324}, //FDSA HQ
	{648.2982,-1357.5068,13.5716,331.5677}, // SA News HQ
	{-54.6465,-1152.5557,2.1316,64.1502}, // RCTR // Dialog 1 END -- (8)
	{-1580.5352,903.4696,7.6953,149.5203}, // SF Bank
	{1456.8411,-1011.4421,26.8438,57.0505}, // Mullholand Bank
	{2462.5857,2244.9272,10.8203,310.6805}, // LV Bank
	{595.3816,-1249.2163,18.2463,136.4379}, // Rodeo Bank
	{648.4630,-519.8029,16.5537,347.8049}, // Dillimore Bank -- Dialog 2 End -- (13)
	{-2455.3552,503.7207,30.0781,81.6989}, // SF Vip
	{1797.4575,-1578.9565,14.0856,120.4249}, // LSVIP
	{1930.8643,1345.4410,9.9688,145.0573}, // LV Vip
	{2017.6354,-1311.6549,23.9861,332.9441}, // Glen Park VIP
	{1022.0172,-1122.0380,23.8709,297.9781}, // Famed Lounge -- Dialog 3 End -- (18)
	{-2653.6384,638.8214,14.4531,43.3566}, // SF Hospital
	{2034.3092,-1402.3984,17.2961,339.7592}, // County Hospital
	{1172.1243,-1323.2010,15.4027,99.1248}, // All Saints
	{1241.3552,326.6962,19.7555,154.6608}, // Montgomery Hospital -- Dialog 4 End -- (22)
	{-560.008483, -1020.256652, 24.084102}, // Flint Hospital
	{-2413.4434,2251.3003,4.8138,267.8773}, // Bayside Appts.
	{-2436.0908,2305.2141,4.9844,132.8512}, // Bayside VIP 
	{-2544.1807,2346.4771,4.9844,44.3360}, // TR Capitol Building
	{-2630.0063,2272.8008,8.3225,111.7500}, // TRES HQ 
	{-1390.6035,2638.3354,55.9844,282.1874}, // TRAF HQ Elque
	{-1439.2744,2591.3591,55.8359,342.5681}, // TRES Recruitment office
	{-1514.5067,2520.9653,55.8705,164.9699}, // Elquebrado's Hospital
	{-827.9031,1504.0640,19.8300,322.0778}, // Las Barancas Bank
	{-319.8820,1049.0958,20.3403,142.6894}, // Fort Carson Hospital -- Dialog 5 End -- (33)
	{1481.0574,-1772.0535,18.7958,178.1923}, // LS City Hall 
	{-2765.8823,375.7053,6.3347,74.5302}, // SF City Hall
	{-1750.6162,964.0596,24.8906,4.3083}, // SF Appts.
	{288.1022,-1600.4684,32.7701,203.7112}, // NG Recuruitment Office
	{-2056.9709,228.3147,35.3800,265.4275}, // Donahue Family Condo's SF
	{2025.7943,-1296.6964,23.9861,195.1668}, // Glen Park Community Center
	{2634.0679,-1384.9991,30.4456,281.2836}, // Los Flores Hotel
	{2752.2041,-1962.6484,13.5469,124.7719}, // Seville Appts.
	{2248.1704,-1795.4705,13.5469,138.6487}, // Ganton Appts.
	{1863.7871,-1599.4569,13.9770,298.1175}, // Idlewood Appts.
	{487.3402,-1640.4919,23.7031,10.7028}, // Trump Industries
	{607.6238,-1458.9736,14.3879,94.2657}, // Fuente's Rodeo Appts
	{1117.4316,-1380.5221,15.3364,49.8436}, // Mall Appts.
	{994.3275,-1211.3960,16.9375,355.9103}, // Market Appts.
	{1241.7294,-1259.3480,13.5300,7.8954}, // Donahue Family Condos, Market
	{1420.0615,-1623.9930,13.5469,333.2560}, // Commerce Appts.
	{1498.6129,-1584.3176,13.5469,7.0856} // Pershing Square Appts. -- Dialog 6 End --
};

new gpsZoneName[50][] = {
	"LSPD",
	"SASD",
	"SFPD",
	"FBI",
	"FBI SF",
	"DoC",
	"FDSA",
	"SANews",
	"RCTR",
	"SF Bank",
	"Mullholand Bank",
	"LV Bank",
	"Rodeo Bank",
	"Dillimore Bank",
	"SF VIP",
	"LS VIP",
	"LV VIP",
	"Glen Park VIP",
	"Famed Lounge",
	"SF Hospital",
	"County Hospital",
	"All Saints Hospital",
	"Montgomery Hospital",
	"Flint Hospital",
	"Bayside Apartments",
	"Bayside VIP",
	"TR Capitol",
	"TRES",
	"TRAF El Quebrados",
	"TRES Recruitment",
	"El Quebrados Hospital",
	"Los Barrancas Bank",
	"Fort Carson Hospital",
	"City Hall",
	"SF City Hall",
	"SF Apartments",
	"Nation Guard Recruitment",
	"Donahue Condos - SF",
	"Glen Park Community Center",
	"Los Flores Hotel",
	"Seville Apartments",
	"Ganton Apartments",
	"Idlewood Apartments",
	"Rodeo Apartments",
	"Fuente's Rodeo Apartments",
	"Mall Apartments",
	"Market Apartments",
	"Donahue Condos - Market",
	"Commerce Apartments",
	"Pershing Square Apartments"
};

GetEntity3DZone(entityID, type, zone[], len, Float:x2 = 0.0, Float:y2 = 0.0, Float:z2 = 0.0) //Credits to Cueball, Betamaster, Mabako, and Simon.
{
	new Float:x, Float:y, Float:z;
	switch(type) {
		case 0: {
			x = Businesses[entityID][bExtPos][0];
			y = Businesses[entityID][bExtPos][1];
			z = Businesses[entityID][bExtPos][2];
		}
		case 1: {
			x = HouseInfo[entityID][hExteriorX];
			y = HouseInfo[entityID][hExteriorY];
			z = HouseInfo[entityID][hExteriorZ];
		}
		case 2: {
			x = DDoorsInfo[entityID][ddExteriorX];
			y = DDoorsInfo[entityID][ddExteriorY];
			z = DDoorsInfo[entityID][ddExteriorZ];
		}
		case 3: {
			x = x2;
			y = y2;
			z = z2;
		}
	}

	for(new i = 0; i != sizeof(gSAZones); i++) {
		if(x >= gSAZones[i][SAZONE_AREA][0]
				&& x <= gSAZones[i][SAZONE_AREA][3]
				&& y >= gSAZones[i][SAZONE_AREA][1]
				&& y <= gSAZones[i][SAZONE_AREA][4]
				&& z >= gSAZones[i][SAZONE_AREA][2]
				&& z <= gSAZones[i][SAZONE_AREA][5]) {
			return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}

/*
CMD:gpsfaves(playerid,params[])
{
	new string[128];
	for(new i = 0; i < MAX_GPSFAV; i++)
	{
		format(string,sizeof(string), "%s\n%s", string, GPSFav[playerid][i][FavName]);
	}
	ShowPlayerDialogEx(playerid, DIALOG_GPS_SETFAV, DIALOG_STYLE_LIST, "Delux GPS - Save Favorite", string, "Save Favorite", "Cancel");
	return 1;
}
*/

CMD:map(playerid, params[]) {

	Phone_Map(playerid);
	return 1;
}

CMD:mygps(playerid, params[]) {
	if(CheckPointCheck(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
	ShowPlayerDialogEx(playerid, DIALOG_GPS_ONE, DIALOG_STYLE_LIST, "Doodle Maps | Main Menu", "Businesses\n\
		Jobs\n\
		General Locations\n\
		Business Address\n\
		House Address\n\
		Door Address\n", "Okay", "Cancel");
	
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	switch(gPlayerCheckpointStatus[playerid])
	{
		case CHECKPOINT_GEN_LOCATION:
		{
			GetPVarString(playerid, "gpsName", szMiscArray, sizeof(szMiscArray));
			format(szMiscArray, sizeof(szMiscArray),"You have arrived at {33CCFF}%s{FFFFFF}.", szMiscArray);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			DeletePVar(playerid,"gpsName");
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
		}
		case CHECKPOINT_BUSINESS:
		{
			new id = GetPVarInt(playerid,"gpsBiz");
			format(szMiscArray, sizeof(szMiscArray), "You have arrived at {33CCFF}%s{FFFFFF}.", Businesses[id][bName]);
			SendClientMessageEx(playerid,COLOR_WHITE, szMiscArray);
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
		}
		case CHECKPOINT_JOB:
		{
			new id = GetPVarInt(playerid,"gpsJob");
			format(szMiscArray, sizeof(szMiscArray), "You have arrived at {33CCFF}%s{FFFFFF}.", GetJobName(JobData[id][jType]));
			SendClientMessageEx(playerid,COLOR_WHITE, szMiscArray);
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
		}

		case CHECKPOINT_HOUSE:
		{
			new id = GetPVarInt(playerid,"gpsHouse");
			format(szMiscArray, sizeof(szMiscArray), "You have arrived at house #{33CCFF}%i{FFFFFF}.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
		}
		case CHECKPOINT_DOOR:
		{
			new id = GetPVarInt(playerid,"gpsDoor");
			format(szMiscArray, sizeof(szMiscArray), "You have arrived at door #%i ({33CCFF}%s{FFFFFF}).", id,DDoorsInfo[id][ddDescription]);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
		}
		/*
		case CHECKPOINT_FAVORITES:
		{
			new id = GetPVarInt(playerid, "gpsFav");
			DeletePVar(playerid, "gpsFav");
			format(szMiscArray, sizeof(szMiscArray), "You have arrived at {33CCFF}%s{FFFFFF}.", GPSFav[playerid][id][FavName]);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			DisablePlayerCheckpoint(playerid);
		}
		*/
	}
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_MAP_BUSINESSES:	{

			if(!response) {

				return ShowPlayerDialogEx(playerid, DIALOG_GPS_ONE, DIALOG_STYLE_LIST, "Doodle Maps | Main Menu", "Businesses\n\
					Jobs\n\
					General Locations\n\
					Business Address\n\
					House Address\n\
					Door Address\n", "Okay", "Cancel");
			}

			Map_ShowBusinesses(playerid, listitem);
			return 1;
		}
		case DIALOG_MAP_BUSINESSES2: {

			if(!response) {

				return ShowPlayerDialogEx(playerid, DIALOG_MAP_BUSINESSES, DIALOG_STYLE_LIST, "San Andreas | Map | Businesses", "\
						24/7\n\
						Clothing Stores\n\
						Restaurants\n\
						Bars\n\
						Gun Stores\n\
						Petrol Stations\n\
						Car Dealerships\n\
						Clubs", "Select", "Back");
			}
			else {

				new id = ListItemTrackId[playerid][listitem];

				GetEntity3DZone(id, 0, szMiscArray, sizeof(szMiscArray));
				format(szMiscArray,sizeof(szMiscArray),"Your GPS Destination has been set to {33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}.", Businesses[id][bName], szMiscArray);
				SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_BUSINESS;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, Businesses[id][bExtPos][0], Businesses[id][bExtPos][1], Businesses[id][bExtPos][2], 15.0);
			}
			return 1;
		}
		case DIALOG_MAP_JOBS: if(response) return Map_ShowJobs(playerid, listitem);
		case DIALOG_GPS_ONE: {

			if(!response) return 1;

			switch(listitem) {

				case 0:
				{
					if(!response) return 1;
					ShowPlayerDialogEx(playerid, DIALOG_MAP_BUSINESSES, DIALOG_STYLE_LIST, "San Andreas | Map | Businesses", "\
						24/7\n\
						Clothing Stores\n\
						Restaurants\n\
						Bars\n\
						Gun Stores\n\
						Petrol Stations\n\
						Car Dealerships\n\
						Clubs", "Select", "Back");
				}
				case 1:
				{
					for(new i; i < MAX_JOBTYPES; ++i)
					{
						format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, JobName[i]);
					}
					return ShowPlayerDialogEx(playerid, DIALOG_MAP_JOBS, DIALOG_STYLE_LIST, "San Andreas | Map | Jobs", szMiscArray, "Select", "Back");
				}
				case 2: {
					SetPVarInt(playerid, "gpsUsingID", 0);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_LIST, "General Locations", "Faction HQs\nBanks\nVIP Areas\nHospitals\nNew Robada\nMiscellaneous", "Okay", "Cancel");
				}
				case 3: {
					SetPVarInt(playerid, "gpsUsingID", 1);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Find Business", "Enter the address of the business (ID)", "Okay", "Cancel");
				}
				case 4: {
					SetPVarInt(playerid, "gpsUsingID", 2);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Find House", "Enter the address of the house (ID)", "Okay", "Cancel");
				}
				case 5: {
					SetPVarInt(playerid, "gpsUsingID", 3);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Find Door", "Enter the address of the building (ID)", "Okay", "Cancel");
				}
			}
		}
		case DIALOG_GPS_TWO: {

			if(!response) return 1;
			
			switch(GetPVarInt(playerid, "gpsUsingID")) {
				
				case 0: {

					SetPVarInt(playerid, "gpsUsingID", listitem);
					switch(listitem) {
						case 0: {
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "HQs", "LSPD\nSASD\nSFPD\nFBI\nFBI SF\nDoC\nFDSA\nSAN NEWS\nRCTR", "Okay", "Cancel");
						}
						case 1: {
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Banks", "San Fierro\nMullholand\nLas Venturas\nRodeo\nDillimore", "Okay", "Cancel");
						}
						case 2:	{
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "VIP", "San Fierro\nLos Santos\nLas Venturas\nGlen Park\nFamed Lounge", "Okay", "Cancel");
						}
						case 3:	{
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Hospitals", "San Fierro\nCounty General\nAll Saints\nMontgomery Hospital", "Okay", "Cancel");
						}
						case 4:
						{
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "New Robada", "Flint Hospital\nBayside Apartments\nBayside VIP\nCapitol\nTRES HQ\n\
								TRAF HQ\nTRES Recruitment\nEl Quebrados Hospital\nLas Barranca Bank\nFort Carsonal Hospital", "Okay", "Cancel");
						}
						case 5: 
						{
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Miscellaneous","LS City Hall\nSF City Hall\nSF Apartments\nNG Recruitment\nDonahue Condos SF\nGlen Park Community Center\n\
								Los Flores Hotel\nSeville Apartments\nGanton Apartments\nIdlewood\nRodeo Apartments\nFuente's Rodeo Apartments\n\
								Mall Apartments\nMarket Apartments\nDonahue Apartments LS\nCommerce Apartments\nPershing Sq. Apartments", "Okay", "Cancel");
						}
					}
				}
				case 1: {

					for (new i = 0, j = strlen(inputtext); i < j; i++) {
						if(inputtext[i] > '9' || inputtext[i] < '0') {
							SendClientMessageEx(playerid, COLOR_WHITE, "You must input a numerical value. In this case, the ID of the business.");
							return 1;
						}
					}

					new id = strval(inputtext);

					if(!IsValidBusinessID(id)) {

						SendClientMessageEx(playerid, COLOR_WHITE, "That business does not exist.");
						return 1;
					}

					GetEntity3DZone(id, 0, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}Would you like to set your destination to:\n\n\
					{33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}?", Businesses[id][bName], szMiscArray);
					
					SetPVarInt(playerid, "gpsUsingID", 1);
					SetPVarInt(playerid,"gpsBiz", id);
					
					ShowPlayerDialogEx(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Delux GPS - Business", szMiscArray, "Yes", "Cancel");
				}
				case 2:
				{
					for (new i = 0, j = strlen(inputtext); i < j; i++) {
						if (inputtext[i] > '9' || inputtext[i] < '0')
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "You must input a numerical value. In this case, the ID of the house.");
							return 1;
						}
					}

					new id = strval(inputtext);

					SetPVarInt(playerid, "gpsHouse", id);

					if(HouseInfo[id][hOwned] == 0)
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "That house address is invalid.");
						return 1;
					}
					GetEntity3DZone(id, 1, szMiscArray, sizeof(szMiscArray));
					SetPVarInt(playerid, "gpsUsingID", 2);
					format(szMiscArray,sizeof(szMiscArray),"{FFFFFF}Would you like to set your destination to:\n\n\
					house {33CCFF}#%i{FFFFFF} in the area of {FF0000}%s{FFFFFF}?", id, szMiscArray);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Delux GPS - House", szMiscArray, "Yes", "Cancel");
 				}
				case 3:
				{
					for (new i = 0, j = strlen(inputtext); i < j; i++) {

						if (inputtext[i] > '9' || inputtext[i] < '0') {

							SendClientMessageEx(playerid, COLOR_WHITE, "You must input a numerical value. In this case, the ID of the door.");
							return 1;
						}
					}

					new id = strval(inputtext);
					SetPVarInt(playerid, "gpsDoor", id);
					if(DDoorsInfo[id][ddDescription] == 0)
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "That house address is invalid.");
						return 1;
					}

			     	GetEntity3DZone(id, 2, szMiscArray, sizeof(szMiscArray));
					SetPVarInt(playerid, "gpsUsingID", 3);
					format(szMiscArray,sizeof(szMiscArray),"{FFFFFF}Would you like to set your destination to:\n\n\
					Door #%i ({33CCFF}%s{FFFFFF}) in the area of {FF0000}%s{FFFFFF}?", id, DDoorsInfo[id][ddDescription], szMiscArray);

					ShowPlayerDialogEx(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Delux GPS - Door", szMiscArray, "Yes", "Cancel");
				}
			}
		}
		case DIALOG_GPS_GEN: {
			if(!response) return 1;
			new gpsItemStart;
			switch(GetPVarInt(playerid, "gpsUsingID")) {

				case 0: gpsItemStart = 0;
				case 1:	gpsItemStart = 9;
				case 2: gpsItemStart = 14;
				case 3: gpsItemStart = 19;
				case 4: gpsItemStart = 23;
				case 5: gpsItemStart = 33;
			}
			GetEntity3DZone(0, 3, szMiscArray, sizeof(szMiscArray), gpsZones[gpsItemStart + listitem][0], gpsZones[gpsItemStart + listitem][1], gpsZones[gpsItemStart + listitem][2]);
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, gpsZones[gpsItemStart + listitem][0], gpsZones[gpsItemStart + listitem][1], gpsZones[gpsItemStart + listitem][2] , 15.0);
			format(szMiscArray,sizeof(szMiscArray),"Your GPS Destination has been set to {33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}.", gpsZoneName[gpsItemStart + listitem], szMiscArray);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
			SetPVarString(playerid, "gpsName", gpsZoneName[gpsItemStart + listitem]);
		}
		case DIALOG_GPS_THREE:{

			if(!response) return 1;

			switch(GetPVarInt(playerid,"gpsUsingID"))
			{
				case 1:
				{
					new id = GetPVarInt(playerid,"gpsBiz");
					GetEntity3DZone(id, 1, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"Your GPS Destination has been set to {33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}.", Businesses[id][bName], szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					DisablePlayerCheckpoint(playerid);		
					SetPlayerCheckpoint(playerid, Businesses[id][bExtPos][0], Businesses[id][bExtPos][1], Businesses[id][bExtPos][2], 15.0);
				}
				case 2:
				{
					new id = GetPVarInt(playerid,"gpsHouse");
					GetEntity3DZone(id, 1, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"Your GPS Destination has been set to house #{33CCFF}%i{FFFFFF} in the area of {FF0000}%s{FFFFFF}.", id, szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					gPlayerCheckpointStatus[playerid] = CHECKPOINT_HOUSE;
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid, HouseInfo[id][hExteriorX], HouseInfo[id][hExteriorY], HouseInfo[id][hExteriorZ], 15.0);
				}
				case 3:
				{
					new id = GetPVarInt(playerid,"gpsDoor");
					GetEntity3DZone(id, 1, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"Your GPS Destination has been set to door #%i ({33CCFF}%s{FFFFFF}) in the area of {FF0000}%s{FFFFFF}.", id, DDoorsInfo[id][ddDescription],  szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					gPlayerCheckpointStatus[playerid] = CHECKPOINT_DOOR;
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid, DDoorsInfo[id][ddExteriorX], DDoorsInfo[id][ddExteriorY], DDoorsInfo[id][ddExteriorZ], 15.0);
				}
			}
		}
		/*
		case DIALOG_GPS_FAVS:
		{
			if(!response) return 1;
			if(!strcmp(inputtext, "None", true)) return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a favorite stored in that slot.");
			GetEntity3DZone(listitem, 3, szMiscArray, sizeof(szMiscArray), GPSFav[playerid][listitem][FavPos][0], GPSFav[playerid][listitem][FavPos][1], GPSFav[playerid][listitem][FavPos][2]);
			format(szMiscArray, sizeof(szMiscArray), "Your GPS Destination has been set to {33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}.", GPSFav[playerid][listitem][FavName], szMiscArray);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_FAVORITES;
			SetPVarInt(playerid, "gpsFav", listitem);
			SetPlayerCheckpoint(playerid, GPSFav[playerid][listitem][FavPos][0],GPSFav[playerid][listitem][FavPos][1],GPSFav[playerid][listitem][FavPos][2], 15.0);
		}
		case DIALOG_GPS_SETFAV:
		{
			if(!response) return 1;
			SetPVarInt(playerid, "sFav", listitem);
			ShowPlayerDialogEx(playerid, DIALOG_GPS_SETFAVNAME, DIALOG_STYLE_INPUT, "Enter Favorite Name", "Please enter a name for your favorite.\n\nIt will be saved in the slot you have selected.", "Submit", "Cancel"); 
		}
		case DIALOG_GPS_SETFAVNAME:
		{
			if(!response) return 1;
			new sFav = GetPVarInt(playerid, "sFav");
			strcpy(GPSFav[playerid][sFav][FavName], inputtext, 128);
			GetPlayerPos(playerid, GPSFav[playerid][sFav][FavPos][0],GPSFav[playerid][sFav][FavPos][1],GPSFav[playerid][sFav][FavPos][2]);
			SendClientMessage(playerid,COLOR_WHITE, "GPS Location Saved!");
			new szQuery[256];
			format(szQuery, sizeof(szQuery), "UPDATE `GPSFavs` SET `Fav%i` = '%s|%f|%f|%f' WHERE `SQLid` = %d", sFav+1, GPSFav[playerid][sFav][FavName], GPSFav[playerid][sFav][FavPos][0],GPSFav[playerid][sFav][FavPos][1],GPSFav[playerid][sFav][FavPos][2], GetPlayerSQLId(playerid)); 
			mysql_tquery(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		}
		*/
	}
	return 0;
}


Map_ShowBusinesses(playerid, btype)
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
	ShowPlayerDialogEx(playerid, DIALOG_MAP_BUSINESSES2, DIALOG_STYLE_TABLIST, "San Andreas | Map | Businesses", szMiscArray, "Select", "Back");
	return 1;
}


Map_ShowJobs(playerid, iJobType)
{
	if(!(1 <= iJobType < MAX_JOBPOINTS)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid job type specified.");
	for(new i; i < MAX_JOBPOINTS; ++i) {
		if(JobData[i][jType] == iJobType) {
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_JOB;
			SetPVarInt(playerid, "gpsJob", i);
			SetPlayerCheckpoint(playerid, JobData[i][jPos][0], JobData[i][jPos][1], JobData[i][jPos][2], 5.0);
			SendClientMessage(playerid, COLOR_YELLOW, "A checkpoint has been marked on your map.");
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_GRAD1, "Applications are currently closed for that job.");
	return 1;
}
