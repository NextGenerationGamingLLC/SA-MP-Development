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

#define			MAX_GPSFAV					(5)
enum gpsFavs
{
	FavName[128],
	Float:FavPos[3]
}
new GPSFav[MAX_PLAYERS][MAX_GPSFAV][gpsFavs];

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
	{-2492.3062,2234.6753,4.9844,273.1860}, // Bayside Hospital
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
	"Bayside Hospital",
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

CMD:gpsfaves(playerid,params[])
{
	new string[128];
	for(new i = 0; i < MAX_GPSFAV; i++)
	{
		format(string,sizeof(string), "%s\n%s", string, GPSFav[playerid][i][FavName]);
	}
	ShowPlayerDialog(playerid, DIALOG_GPS_SETFAV, DIALOG_STYLE_LIST, "Delux GPS - Save Favorite", string, "Save Favorite", "Cancel");
	return 1;
}

CMD:mygps(playerid, params[])
{
	if(CheckPointCheck(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
	ShowPlayerDialog(playerid, DIALOG_GPS_ONE, DIALOG_STYLE_LIST, "Deluxe GPS", "Business Menu\nBusiness Address\nHouse Address\nDoor Address\nGeneral Locations\nFavorite Locations", "Okay", "Cancel");
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(GetPVarType(playerid,"gpsType"))
	{
		switch(GetPVarInt(playerid,"gpsType"))
		{
			case 1:
			{
				new string[128];
				DeletePVar(playerid, "gpsType");
				new gpsName[128];
				GetPVarString(playerid, "gpsName", gpsName, 128);
				format(string,sizeof(string),"You have arrived at {33CCFF}%s{FFFFFF}.", gpsName);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				DeletePVar(playerid,"gpsName");
				DisablePlayerCheckpoint(playerid);
			}
			case 2:
			{
				new string[128];
				DeletePVar(playerid,"gpsType");
				new id = GetPVarInt(playerid,"gpsBiz");
				format(string,sizeof(string), "You have arrived at {33CCFF}%s{FFFFFF}.",Businesses[id][bName]);
				SendClientMessageEx(playerid,COLOR_WHITE,string);
				DisablePlayerCheckpoint(playerid);
			}
			case 3:
			{
				new string[128];
				DeletePVar(playerid, "gpsType");
				new id = GetPVarInt(playerid,"gpsHouse");
				format(string, sizeof(string), "You have arrived at house #{33CCFF}%i{FFFFFF}.", id);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				DisablePlayerCheckpoint(playerid);
			}
			case 4:
			{
				new string[128];
				DeletePVar(playerid, "gpsType");
				new id = GetPVarInt(playerid,"gpsDoor");
				format(string, sizeof(string), "You have arrived at door #%i ({33CCFF}%s{FFFFFF}).", id,DDoorsInfo[id][ddDescription]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				DisablePlayerCheckpoint(playerid);
			}
			case 5:
			{
				new string[128];
				DeletePVar(playerid, "gpsType");
				new id = GetPVarInt(playerid,"gpsBizID");
				format(string, sizeof(string), "You have arrived at {33CCFF}%s{FFFFFF}.", Businesses[id][bName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				DisablePlayerCheckpoint(playerid);
			}
			case 6:
			{
				new string[128];
				DeletePVar(playerid, "gpsType");
				new id = GetPVarInt(playerid, "gpsFav");
				DeletePVar(playerid, "gpsFav");
				format(string, sizeof(string), "You have arrived at {33CCFF}%s{FFFFFF}.", GPSFav[playerid][id][FavName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				DisablePlayerCheckpoint(playerid);
			}
		}
	}
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid) {
		case DIALOG_GPS_ONE: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					new string[2048];
					for(new i; i<sizeof(AreaName);i++)
					{
						new bCount = 0;
						for(new b; b<MAX_BUSINESSES;b++)
						{
							if(IsValidBusinessID(b) && strcmp(Businesses[b][bOwnerName], "None", true)){
								new zone[MAX_ZONE_NAME];
								GetEntity3DZone(b, 0, zone, sizeof(zone));
								
								if(!strcmp(zone, AreaName[i], true))
								{
									bCount = 1;
								}
							}
						}
						if(bCount == 1)
						{
							format(string,sizeof(string),"%s\n%s", string, AreaName[i]);
						}
					}
					ShowPlayerDialog(playerid, DIALOG_GPS_BCATS, DIALOG_STYLE_LIST, "Business Areas", string, "Select", "Cancel");
				}
				case 1: {
					SetPVarInt(playerid, "gpsUsingID", 2);
					ShowPlayerDialog(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Find Business", "Enter the address of the business (ID)", "Okay", "Cancel");
				}
				case 2: {
					SetPVarInt(playerid, "gpsUsingID", 3);
					ShowPlayerDialog(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Find House", "Enter the address of the house (ID)", "Okay", "Cancel");
				}
				case 3: {
					SetPVarInt(playerid, "gpsUsingID", 4);
					ShowPlayerDialog(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Find Door", "Enter the address of the building (ID)", "Okay", "Cancel");
				}
				case 4: {
					SetPVarInt(playerid, "gpsUsingID", 5);
					ShowPlayerDialog(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_LIST, "General Locations", "Faction HQs\nBanks\nVIP Areas\nHospitals\nTierra Robada\nMiscellaneous", "Okay", "Cancel");
				}
				case 5:{
					SetPVarInt(playerid, "gpsUsingID", 6);
					new string[128];
					for(new i = 0; i < MAX_GPSFAV; i++)
					{
						format(string,sizeof(string), "%s\n%s", string,GPSFav[playerid][i][FavName]);
					}
					ShowPlayerDialog(playerid, DIALOG_GPS_FAVS, DIALOG_STYLE_LIST, "Delux GPS - My Favorites", string, "Navigate", "Cancel");
				}
			}
		}
		case DIALOG_GPS_TWO: {
			new str[128 + MAX_BUSINESS_NAME + MAX_ZONE_NAME];
			if(!response) return 1;
			switch(GetPVarInt(playerid, "gpsUsingID")) {
				case 1:
				{
					return 1;
				}
				case 2: {
					for (new i = 0, j = strlen(inputtext); i < j; i++) {
						if (inputtext[i] > '9' || inputtext[i] < '0')
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "You must input a numerical value. In this case, the ID of the business.");
							return 1;
						}
					}
					new id = strval(inputtext);
					if(!IsValidBusinessID(id)) {
						SendClientMessageEx(playerid, COLOR_WHITE, "That business does not exist.");
						return 1;
					}
					new zone[MAX_ZONE_NAME];
					GetEntity3DZone(id, 0, zone, sizeof(zone));
					format(str, sizeof(str), "{FFFFFF}Would you like to set your destination to:\n\n\
					{33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}?", Businesses[id][bName], zone);
					SetPVarInt(playerid,"gpsBiz", id);
					ShowPlayerDialog(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Delux GPS - Business", str, "Yes", "Cancel");
				}
				case 3:
				{
					for (new i = 0, j = strlen(inputtext); i < j; i++) {
						if (inputtext[i] > '9' || inputtext[i] < '0')
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "You must input a numerical value. In this case, the ID of the business.");
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
					new zone[MAX_ZONE_NAME];
					new string[128 + MAX_ZONE_NAME];
					GetEntity3DZone(id, 1, zone, sizeof(zone));
					SetPVarInt(playerid, "gpsUsingID", 3);
					format(string,sizeof(string),"{FFFFFF}Would you like to set your destination to:\n\n\
					house {33CCFF}#%i{FFFFFF} in the area of {FF0000}%s{FFFFFF}?", id, zone);
					ShowPlayerDialog(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Delux GPS - House", string, "Yes", "Cancel");
 				}
				case 4:
				{
					for (new i = 0, j = strlen(inputtext); i < j; i++) {
						if (inputtext[i] > '9' || inputtext[i] < '0')
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "You must input a numerical value. In this case, the ID of the business.");
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
					new zone[MAX_ZONE_NAME];
					new string[128 + MAX_ZONE_NAME];
			     	GetEntity3DZone(id, 2, zone, sizeof(zone));
					SetPVarInt(playerid, "gpsUsingID", 4);
					format(string,sizeof(string),"{FFFFFF}Would you like to set your destination to:\n\n\
					Door #%i ({33CCFF}%s{FFFFFF}) in the area of {FF0000}%s{FFFFFF}?", id, DDoorsInfo[id][ddDescription], zone);
					ShowPlayerDialog(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Delux GPS - Door", string, "Yes", "Cancel");
				}
				case 5: {
					SetPVarInt(playerid, "gpsUsingID", listitem);
					switch(listitem) {
						case 0: {
							ShowPlayerDialog(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "HQs", "LSPD\nSASD\nSFPD\nFBI\nFBI SF\nDoC\nFDSA\nSAN NEWS\nRCTR", "Okay", "Cancel");
						}
						case 1: {
							ShowPlayerDialog(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Banks", "San Fierro\nMullholand\nLas Venturas\nRodeo\nDillimore", "Okay", "Cancel");
						}
						case 2:	{
							ShowPlayerDialog(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "VIP", "San Fierro\nLos Santos\nLas Venturas\nGlen Park\nFamed Lounge", "Okay", "Cancel");
						}
						case 3:	{
							ShowPlayerDialog(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Hospitals", "San Fierro\nCounty General\nAll Saints\nMontgomery Hospital", "Okay", "Cancel");
						}
						case 4:
						{
							ShowPlayerDialog(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Tierra Robada", "Bayside Hospital\nBayside Apartments\nBayside VIP\nCapitol\nTRES HQ\n\
								TRAF HQ\nTRES Recruitment\nEl Quebrados Hospital\nLas Barranca Bank\nFort Carsonal Hospital", "Okay", "Cancel");
						}
						case 5: 
						{
							ShowPlayerDialog(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Miscellaneous","LS City Hall\nSF City Hall\nSF Apartments\nNG Recruitment\nDonahue Condos SF\nGlen Park Community Center\n\
								Los Flores Hotel\nSeville Apartments\nGanton Apartments\nIdlewood\nRodeo Apartments\nFuente's Rodeo Apartments\n\
								Mall Apartments\nMarket Apartments\nDonahue Apartments LS\nCommerce Apartments\nPershing Sq. Apartments", "Okay", "Cancel");
						}
					}
				}
			}
		}
		case DIALOG_GPS_GEN: {
			if(!response) return 1;
			new gpsItemStart;
			switch(GetPVarInt(playerid, "gpsUsingID")) {
				case 0: {
					gpsItemStart = 0;
				}
				case 1:
				{
					gpsItemStart = 9;
				}
				case 2:
				{
					gpsItemStart = 14;
				}
				case 3:
				{
					gpsItemStart = 19;
				}
				case 4: {
					gpsItemStart = 23;
				}
				case 5:{
					gpsItemStart = 33;
				}
			}
			new string[128];
			new zone[MAX_ZONE_NAME];
			GetEntity3DZone(0, 3, zone, sizeof(zone), gpsZones[gpsItemStart + listitem][0], gpsZones[gpsItemStart + listitem][1], gpsZones[gpsItemStart + listitem][2]);
			SetPlayerCheckpoint(playerid, gpsZones[gpsItemStart + listitem][0], gpsZones[gpsItemStart + listitem][1], gpsZones[gpsItemStart + listitem][2] , 15.0);
			format(string,sizeof(string),"Your GPS Destination has been set to {33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}.", gpsZoneName[gpsItemStart + listitem], zone);
			SendClientMessage(playerid, COLOR_WHITE, string);
			SetPVarInt(playerid, "gpsType", 1);
			SetPVarString(playerid, "gpsName", gpsZoneName[gpsItemStart + listitem]);
		}
		case DIALOG_GPS_THREE:{
			if(!response) return 1;
			switch(GetPVarInt(playerid,"gpsUsingID"))
			{
				case 1:
				{
				}
				case 2:
				{
					new string[128 + MAX_BUSINESS_NAME + MAX_ZONE_NAME];
					new zone[MAX_ZONE_NAME];
					new id = GetPVarInt(playerid,"gpsBiz");
					GetEntity3DZone(id, 1, zone, sizeof(zone));
					format(string,sizeof(string),"Your GPS Destination has been set to {33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}.", Businesses[id][bName], zone);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					SetPVarInt(playerid,"gpsType", 2);
				
					SetPlayerCheckpoint(playerid, Businesses[id][bExtPos][0], Businesses[id][bExtPos][1], Businesses[id][bExtPos][2], 15.0);
				}
				case 3:
				{
					new string[128 + MAX_BUSINESS_NAME + MAX_ZONE_NAME];
					new zone[MAX_ZONE_NAME];
					new id = GetPVarInt(playerid,"gpsHouse");
					GetEntity3DZone(id, 1, zone, sizeof(zone));
					format(string,sizeof(string),"Your GPS Destination has been set to house #{33CCFF}%i{FFFFFF} in the area of {FF0000}%s{FFFFFF}.", id, zone);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					SetPVarInt(playerid,"gpsType", 3);
					SetPlayerCheckpoint(playerid, HouseInfo[id][hExteriorX], HouseInfo[id][hExteriorY], HouseInfo[id][hExteriorZ], 15.0);
				}
				case 4:
				{
					new string[128 + MAX_BUSINESS_NAME + MAX_ZONE_NAME];
					new zone[MAX_ZONE_NAME];
					new id = GetPVarInt(playerid,"gpsDoor");
					GetEntity3DZone(id, 1, zone, sizeof(zone));
					format(string,sizeof(string),"Your GPS Destination has been set to door #%i ({33CCFF}%s{FFFFFF}) in the area of {FF0000}%s{FFFFFF}.", id, DDoorsInfo[id][ddDescription],  zone);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					SetPVarInt(playerid,"gpsType", 4);
					SetPlayerCheckpoint(playerid, DDoorsInfo[id][ddExteriorX], DDoorsInfo[id][ddExteriorY], DDoorsInfo[id][ddExteriorZ], 15.0);
				}
			}
		}
		case DIALOG_GPS_BCATS:
		{
			if(!response) return 1;
			new GPSArea[128];
			new string[2048];
			format(GPSArea, sizeof(GPSArea), "%s", inputtext);
			for(new i=0;i<MAX_BUSINESSES;i++)
			{
				if(IsValidBusinessID(i) && strcmp(Businesses[i][bOwnerName], "None", true))
				{
					new zone[MAX_ZONE_NAME];
					GetEntity3DZone(i, 0, zone, sizeof(zone));
					if(!strcmp(zone, GPSArea, true))
					{
						format(string,sizeof(string),"%s\n%s", string, Businesses[i][bName]);
					}
				}
			}
			new title[128];
			format(title,sizeof(title), "Delux GPS - Businesses In %s", GPSArea);
			ShowPlayerDialog(playerid, DIALOG_GPS_BSELECT, DIALOG_STYLE_LIST, title, string, "Select", "Cancel");
		}
		case DIALOG_GPS_BSELECT:
		{
			if(!response) return 1;
			for(new b = 0; b < MAX_BUSINESSES; b++)
			{
				if(!strcmp(inputtext, Businesses[b][bName], true) && strlen(Businesses[b][bName]) > 0)
				{
					printf("ID: %i", b);
					SetPVarInt(playerid, "gpsBizID", b);
					new zone[MAX_ZONE_NAME];
					GetEntity3DZone(b, 0, zone, sizeof(zone));
					new str[128 + MAX_BUSINESS_NAME + MAX_ZONE_NAME];
					format(str, sizeof(str), "{FFFFFF}Would you like to set your destination to:\n\n\
					{33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}?", Businesses[b][bName], zone);
					ShowPlayerDialog(playerid, DIALOG_GPS_BIZCONF, DIALOG_STYLE_MSGBOX, "{FF0000}Delux GPS - Business", str, "Yes", "Cancel");
					return 1;
				}
			}
		}
		case DIALOG_GPS_BIZCONF:
		{
			if(!response) return 1;
			new string[128 + MAX_BUSINESS_NAME + MAX_ZONE_NAME];
			new zone[MAX_ZONE_NAME];
			new id = GetPVarInt(playerid,"gpsBizID");
			GetEntity3DZone(id, 0, zone, sizeof(zone));
			format(string,sizeof(string),"Your GPS Destination has been set to {33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}.", Businesses[id][bName], zone);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SetPVarInt(playerid,"gpsType", 5);	
			SetPlayerCheckpoint(playerid, Businesses[id][bExtPos][0], Businesses[id][bExtPos][1], Businesses[id][bExtPos][2], 15.0);
		}
		case DIALOG_GPS_FAVS:
		{
			if(!response) return 1;
			if(!strcmp(inputtext, "None", true)) return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a favorite stored in that slot.");
			new string[128 + MAX_BUSINESS_NAME + MAX_ZONE_NAME];
			new zone[MAX_ZONE_NAME];
			GetEntity3DZone(listitem, 3, zone, sizeof(zone), GPSFav[playerid][listitem][FavPos][0], GPSFav[playerid][listitem][FavPos][1], GPSFav[playerid][listitem][FavPos][2]);
			format(string,sizeof(string), "Your GPS Destination has been set to {33CCFF}%s{FFFFFF} in the area of {FF0000}%s{FFFFFF}.", GPSFav[playerid][listitem][FavName], zone);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SetPVarInt(playerid, "gpsType", 6);
			SetPVarInt(playerid, "gpsFav", listitem);
			SetPlayerCheckpoint(playerid, GPSFav[playerid][listitem][FavPos][0],GPSFav[playerid][listitem][FavPos][1],GPSFav[playerid][listitem][FavPos][2], 15.0);
		}
		case DIALOG_GPS_SETFAV:
		{
			if(!response) return 1;
			SetPVarInt(playerid, "sFav", listitem);
			ShowPlayerDialog(playerid, DIALOG_GPS_SETFAVNAME, DIALOG_STYLE_INPUT, "Enter Favorite Name", "Please enter a name for your favorite.\n\nIt will be saved in the slot you have selected.", "Submit", "Cancel"); 
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
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		}
	}
	return 1;
}