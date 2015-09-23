/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						House List Module

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)
					
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

#define 	INTERIOR_TYPE_SMALL		(0)
#define 	INTERIOR_TYPE_MEDIUM 	(1)
#define 	INTERIOR_TYPE_LARGE		(2)

new Float:InteriorsList[42][4] = {
	{140.17, 1366.07, 1083.65, 5.0},
	{2324.53, -1149.54, 1050.71, 12.0},
	{225.68, 1021.45, 1084.02, 7.0},
	{234.19, 1063.73, 1084.21, 6.0},
	{226.30, 1114.24, 1080.99, 5.0},
	{235.34, 1186.68, 1080.26, 3.0},
	{491.07, 1398.50, 1080.26, 2.0},
	{24.04, 1340.17, 1084.38, 10.0},
	{-283.44, 1470.93, 1084.38, 15.0},
	{-260.49, 1456.75, 1084.37, 4.0},
	{83.03, 1322.28, 1083.87, 9.0},
	{2317.89, -1026.76, 1050.22, 9.0},
	{2495.98, -1692.08, 1014.74, 3.0},
	{2807.48, -1174.76, 1025.57, 8.0},
	{2196.85, -1204.25, 1049.02, 6.0},
	{377.15, 1417.41, 1081.33, 15.0},
	{2270.38, -1210.35, 1047.56, 10.0},
	{446.99, 1397.07, 1084.30, 2.0},
	{387.22, 1471.70, 1080.19, 15.0},
	{22.88, 1403.33, 1084.44, 5.0},
	{2365.31, -1135.60, 1050.88, 8.0},
	{2237.59, -1081.64, 1049.02, 2.0},
	{295.04, 1472.26, 1080.26, 15.0},
	{261.12, 1284.30, 1080.26, 4.0},
	{221.92, 1140.20, 1082.61, 4.0},
	{-68.81, 1351.21, 1080.21, 6.0},
	{260.85, 1237.24, 1084.26, 9.0},
	{2468.84, -1698.24, 1013.51, 2.0},
	{223.20, 1287.08, 1082.14, 1.0},
	{2283.04, -1140.28, 1050.90, 11.0},
	{328.05, 1477.73, 1084.44, 15.0},
	{223.20, 1287.08, 1082.14, 1.0},
	{-42.59, 1405.47, 1084.43, 8.0},
	{446.90, 506.35, 1001.42, 12.0},
	{299.78, 309.89, 1003.30, 4.0},
	{2308.77, -1212.94, 1049.02, 6.0},
	{2233.64, -1115.26, 1050.88, 5.0},
	{2218.40, -1076.18, 1050.48, 1.0},
	{266.50, 304.90, 999.15, 2.0},
	{243.72, 304.91, 999.15, 1.0},
	{343.81, 304.86, 999.15, 6.0},
	{2259.38, -1135.77, 1050.64, 10.0}
};

ListInteriors(playerid, iType)
{
	szMiscArray[0] = 0; // this must be done to null initiate the global variable. 

	switch(iType)
	{
		case INTERIOR_TYPE_SMALL:
		{
			format(szMiscArray, sizeof(szMiscArray),
				"Interior (30)\n\
				Interior (31)\n\
				Interior (32)\n\
				Interior (33)\n\
				Interior (34)\n\
				Interior (35)\n\
				Interior (36)\n\
				Interior (37)\n\
				Interior (38)\n\
				Interior (39)\n\
				Interior (40)\n\
				Interior (41)\n\
				Interior (42)\n\
				Interior (43)"
			);

		}
		case INTERIOR_TYPE_MEDIUM:
		{
			format(szMiscArray, sizeof(szMiscArray),
				"Interior (7)\n\
				Interior (8)\n\
				Interior (9)\n\
				Interior (10\n\
				Interior (11)\n\
				Interior (12)\n\
				Interior (13)\n\
				Interior (14)\n\
				Interior (15)\n\
				Iterior (16)\n\
				Interior (17)\n\
				Interior (18)\n\
				Interior (19)\n\
				Interior (20)\n\
				Interior (21)\n\
				Interior (22)\n\
				Interior (23)\n\
				Interior (24)\n\
				Interior (25)\n\
				Interior (26)\n\
				Interior (27)\n\
				Interior (28)\n\
				Interior (29)"
			);

		}
		case INTERIOR_TYPE_LARGE:
		{
			format(szMiscArray, sizeof(szMiscArray),
				"Interior (2)\n\
				Interior (3)\n\
				Interior (4)\n\
				Interior (5)\n\
				Interior (6)"
			);
		}
	}
	return ShowPlayerDialog(playerid, DIALOG_LIST_INTERIORS2, DIALOG_STYLE_LIST, "Interior List", szMiscArray, "Goto", "Cancel");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

	if(dialogid == DIALOG_LIST_INTERIORS && response)
	{
		ListInteriors(playerid, listitem);
	}
	if(dialogid == DIALOG_LIST_INTERIORS2 && response)
	{
		new stpos = strfind(inputtext, "(");
	    new fpos = strfind(inputtext, ")");
	    new idstr[4], id;
	    strmid(idstr, inputtext, stpos+1, fpos);
	    id = strval(idstr);

	    SetPlayerInterior(playerid, floatround(InteriorsList[id][3]));
	    SetPlayerPos(playerid, InteriorsList[id][0], InteriorsList[id][1], InteriorsList[id][2]);
	}
	return 1;
}

hook OnGameModeInit() {

	//0
	CreateDynamicObject(14758, 139.52341, 1365.56250, 1114.73438,   0.00000, 0.00000, 0.00000);

	//1
	CreateDynamicObject(15045, 2324.41333, -1143.32397, 1079.58752,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(15059, 2315.48438, -1144.89063, 1083.28906,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(15048, 2315.48438, -1144.89063, 1083.28906,   0.00000, 0.00000, 0.00000);

	//2
	CreateDynamicObject(14707, 238.00238, 1035.88708, 1117.60156,   0.00000, 0.00000, 0.00000);

	//3
	CreateDynamicObject(14706, 233.91409, 1075.82813, 1116.41406,   0.00000, 0.00000, 0.00000);
	
	//4
	CreateDynamicObject(14708, 235.21091, 1113.21094, 1111.75781,   0.00000, 0.00000, 0.00000);

	//5
	CreateDynamicObject(14702, 232.62939, 1199.79309, 1113.55469,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1504, 234.51559, 1186.24219, 1109.24219,   0.00000, 0.00000, 0.00000);

	//6
	CreateDynamicObject(14703, 488.49219, 1411.59375, 1113.55469,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1504, 490.37500, 1398.06250, 1109.24219,   0.00000, 0.00000, 0.00000);
	
	//7
	CreateDynamicObject(14750, 27.30470, 1349.10156, 1119.87500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1506, 23.24870, 1339.75000, 1113.27942,   0.00000, 0.00000, 0.00000);

	//8
	CreateDynamicObject(14759, -292.29184, 1478.24170, 1119.87500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, -283.01559, 1471.79688, 1113.35938,   0.00000, 0.00000, 270.00000);

	//9
	CreateDynamicObject(14760, -264.09381, 1449.44531, 1115.36719,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, -260.06250, 1457.45313, 1113.35938,   0.00000, 0.00000, 270.00000);

	//10
	CreateDynamicObject(14754, 85.75780, 1330.96094, 1116.80469,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1506, 82.30190, 1321.82434, 1112.85156,   0.00000, 0.00000, 0.00000);

	//11
	CreateDynamicObject(15058, 2321.61719, -1018.10162, 1083.14844,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1506, 2317.05469, -1027.20313, 1079.20313,   0.00000, 0.00000, 0.00000);

	//12
	CreateDynamicObject(14476, 2494.03125, -1699.28125, 1043.73438,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14471, 2496.46094, -1708.96094, 1045.47656,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(14472, 2497.87500, -1709.07031, 1045.23438,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1498, 2496.73438, -1691.63281, 1043.73438,   0.00000, 0.00000, 180.00000);

	//13
	CreateDynamicObject(14383, 2817.35938, -1169.32031, 1056.32031,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, 2808.37500, -1175.17969, 1054.56250,   0.00000, 0.00000, 180.00000);

	//14
	CreateDynamicObject(15041, 2192.39844, -1213.01563, 1080.02344,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1506, 2197.28906, -1205.12500, 1078.01563,   0.00000, 0.00000, 90.00000);

	//15
	CreateDynamicObject(14710, 367.84381, 1420.55469, 1111.84375,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, 377.57809, 1418.09375, 1110.33594,   0.00000, 0.00000, 270.00000);

	//16
	CreateDynamicObject(15054, 2258.26563, -1219.25000, 1080.02344,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1506, 2270.82813, -1209.71875, 1076.55469,   0.00000, 0.00000, 270.00000);

	//17
	CreateDynamicObject(14701, 447.42090, 1407.08362, 1115.37500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1506, 446.28909, 1396.62500, 1113.28125,   0.00000, 0.00000, 0.00000);

	//18
	CreateDynamicObject(14711, 378.55469, 1464.31250, 1110.78906,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, 387.64841, 1472.51563, 1109.18750,   0.00000, 0.00000, 270.00000);

	//19
	CreateDynamicObject(14748, 24.41410, 1408.00000, 1115.42969,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1506, 23.60940, 1402.91406, 1113.44531,   0.00000, 0.00000, 180.00000);

	//20
	CreateDynamicObject(15055, 2361.75000, -1127.46094, 1081.12500,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1506, 2366.01563, -1136.00781, 1079.86719,   0.00000, 0.00000, 180.00000);

	//21
	CreateDynamicObject(15053, 2237.53125, -1085.48438, 1079.27344,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1535, 2236.76563, -1082.06250, 1078.01563,   0.00000, 0.00000, 0.00000);

	//22
	CreateDynamicObject(1498, 294.36719, 1471.80469, 1109.24219,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14714, 295.14059, 1479.96875, 1111.06250,   0.00000, 0.00000, 0.00000);

	//23
	CreateDynamicObject(14713, 255.86720, 1288.90625, 1111.06250,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, 260.26559, 1283.84375, 1109.24219,   0.00000, 0.00000, 0.00000);

	//24
	CreateDynamicObject(14709, 222.72659, 1150.16406, 1113.07813,   0.00000, 0.00000, 0.00000);

	//25
	CreateDynamicObject(14755, -68.66410, 1343.54688, 1110.46094,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, -68.06250, 1350.77344, 1109.20313,   0.00000, 0.00000, 180.00000);

	//26
	CreateDynamicObject(14712, 257.79691, 1244.47656, 1114.82813,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, 260.00000, 1236.78125, 1113.23438,   0.00000, 0.00000, 0.00000);

	//27
	CreateDynamicObject(14743, 2458.01563, -1695.93750, 1044.28906,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14744, 2458.01563, -1695.93750, 1044.28906,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14746, 2451.96875, -1702.14063, 1044.28003,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14763, 2447.75000, -1694.25781, 1044.06250,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1498, 2469.26563, -1697.52344, 1042.50000,   0.00000, 0.00000, 270.00000);

	//28
	CreateDynamicObject(14718, 220.12500, 1291.62500, 1111.13281,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, 222.36720, 1286.62500, 1111.12500,   0.00000, 0.00000, 0.00000);

	//29
	CreateDynamicObject(15031, 2279.93750, -1135.82031, 1079.89844,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1535, 2282.17969, -1140.70313, 1079.89063,   0.00000, 0.00000, 0.00000);

	//30
	CreateDynamicObject(14700, 327.98798, 1481.48694, 1114.93750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, 327.21091, 1477.27344, 1113.42188,   0.00000, 0.00000, 0.00000);

	//31
	CreateDynamicObject(14718, 220.12500, 1291.62500, 1111.13281,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1498, 222.36720, 1286.62500, 1111.12500,   0.00000, 0.00000, 0.00000);

	//32
	CreateDynamicObject(14756, -42.57810, 1405.77344, 1115.42969,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1506, -43.33590, 1405.03125, 1113.42969,   0.00000, 0.00000, 0.00000);

	//33
	CreateDynamicObject(14479, 450.25781, 516.39063, 1032.06250,   0.00000, 0.00000, 0.00000);

	//34
	CreateDynamicObject(14876, 304.82321, 307.58221, 1033.21875,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14877, 306.45309, 313.70309, 1030.21875,   0.00000, 0.00000, 0.00000);

	//35
	CreateDynamicObject(15042, 2313.84375, -1212.73438, 1080.02344,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1501, 2308.03906, -1213.37500, 1078.01563,   0.00000, 0.00000, 0.00000);

	//36
	CreateDynamicObject(15034, 2233.24219, -1111.08594, 1081.62500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1535, 2232.92969, -1115.67969, 1079.86719,   0.00000, 0.00000, 0.00000);

	//37
	CreateDynamicObject(15033, 2206.16406, -1072.56250, 1079.47656,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1535, 2218.82031, -1077.01563, 1079.46875,   0.00000, 0.00000, 90.00000);

	//38
	CreateDynamicObject(14865, 270.19531, 305.64059, 1030.14844,   0.00000, 0.00000, 0.00000);

	//39
	CreateDynamicObject(14859, 246.66409, 303.83591, 1030.14844,   0.00000, 0.00000, 0.00000);

	//40
	CreateDynamicObject(14889, 346.80469, 305.79691, 1030.39844,   0.00000, 0.00000, 0.00000);

	//41
	CreateDynamicObject(15029, 2264.58594, -1137.51563, 1081.38281,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1535, 2259.00000, -1136.64063, 1079.62500,   0.00000, 0.00000, 90.00000);
}

CMD:interiors(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not authorized to use this command!");
	ShowPlayerDialog(playerid, DIALOG_LIST_INTERIORS, DIALOG_STYLE_LIST, "Select a category", "Small Interiors\nMedium Interiors\nLarge Interiors", "Select", "Cancel");
	return 1;
}