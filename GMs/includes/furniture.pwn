/* Furniture System
	by Jingles
*/

#include <YSI\y_hooks>

new Text:Furniture_TD[26];

// Bathroom
new const szFurnitureCatList[][][32] = {

	{2514, "Small Talk Toilet", 1500},
	{2521, "Baby  Toilet", 1000},
	{2528, "Chique Toilet", 2500},
	{2602, "Police Cell Toilet", 3000},
	{2738, "Toilet Toilet", 1500},
	{19873, "Toilet Paper", 300},
	{2515, "Soft White Sink", 1000},
	{2518, "Regular Sink", 1000},
	{2523, "Chique Du Sink", 2000},
	{2524, "Bright White Sink", 2500},
	{11709, "Retro Sink", 4000},
	{2097, "Sprunk Bath", 5000},
	{2516, "Regular Bath", 2500},
	{2519, "Regular Bath 2", 2500},
	{2522, "Bath Decor", 1500},
	{2526, "Mac Bath", 2500},
	{11732, "Heart Bath", 3000},
	{2517, "Regular Shower", 2000},
	{2520, "Regular Shower 2", 2000},
	{2527, "Mac Shower", 5000},

	// Comfort
	{1700, "The Queen Elizabeth", 2000},
	{1701, "The King George", 2000},
	{1771, "Prisoner's Dream", 1000},
	{1794, "Regular Bed", 500},
	{1795, "Swanky Bed", 500},
	{1798, "Swanky Bed 2", 500},
	{2298, "Swanky Bed 3", 1000},
	{1804, "Wooden Bed", 200},
	{2301, "Bed and Cup", 600},
	{2563, "Luxury Bed", 1500},
	{2566, "Dark Luxury Bed", 1500},
	{2564, "Twin Hotel Beds", 2000},
	{2565, "Twin Dark Hotel Beds", 2500},
	{11720, "Red Love Bed", 5000},
	{11731, "Heart Bed", 10000},
	{14446, "Zebra Bed", 7000},
	{15035, "Bed Set", 6000},
	{15039, "Bed Set 2", 6000},
	{1369, "Wheel Chair", 500},
	{1671, "Office Chair", 1000},
	{1714, "Office Chair 2", 1500},
	{1715, "Swivel Chair", 1500},
	{1704, "Dark Blue Chair", 500},
	{1705, "Brown Chair", 500},
	{1708, "Blue Seat", 1000},
	{1720, "Restaurant Chair", 500},
	{1722, "Waiting Room Chair", 500},
	{1735, "Grandma's Seat", 600},
	{1739, "Dining Chair", 600},
	{2122, "Luxury Dining Chair", 1000},
	{2123, "Luxury Dining Chair 2", 1000},
	{2343, "Barber's Chair", 1000},
	{11665, "Chair and Speakers", 1000},
	{11734, "Ol' Grandpa's", 1500},
	{1702, "Brown Couch", 1500},
	{1703, "Blue Couch", 1500},
	{1706, "Purple Couch", 1500},
	{1707, "Funky Couch", 1500},
	{1712, "Dusty Couch", 1000},
	{1713, "Big Blue Couch", 1000},
	{1753, "Leather Couch", 3000},
	{1756, "Gangland Couch", 1000},
	{1760, "Gangland Couch 2", 1000},
	{1764, "Gangland Couch 3", 1000},
	{2290, "Swanky Couch", 2500},
	{11717, "Love Couch", 5000},

	// Doors
	{1491, "Rich Mahogany Door", 1000},
	{1502, "Rich Mahogany Door 2", 1000},
	{1492, "ShitInc. Door", 500},
	{1493, "ShitInc. Door 2", 500},
	{1495, "Wired Door", 500},
	{1500, "Wired Door 2", 500},
	{1501, "Wired Door 3", 500},
	{1496, "Heavy Door", 1000},
	{1497, "Heavy Door 2", 1000},
	{1504, "Red Door", 1500},
	{1505, "Blue Door", 1500},
	{1506, "White Door", 1500},
	{1507, "Yellow Door", 1500},
	{1523, "Lab Door", 2000},
	{1536, "Alex Inc. Door", 2000},
	{1535, "Pink Door", 2000},
	{1557, "Chique Door", 2000},
	{19302, "Jail Door", 4000},
	{19304, "Cage Wall", 4000},
	{18756, "Elevator Door", 5000},
	{11714, "Big Blue Door", 4000},
	{3440, "Chique Metal Pillar", 3000},
	{3533, "Chinese Pillar", 2000},
	{19943, "Roman Pillar", 4000},
	{1616, "Security Camera", 2500},
	{1622, "Security Camera 2", 2500},

	// Household
	{2131, "Whiteboi Fridge", 4000},
	{2132, "Whiteboi Sink", 4000},
	{2133, "Whiteboi Kitchen cabs", 4000},
	{2340, "Whiteboi Kitcehn desk", 2000},
	{2147, "Ol' Rusty Fridge", 500},
	{2334, "Classy Cook's Kitchen desk", 700},
	{2336, "Classy Cook's Kitchen sink", 2336},
	{2338, "Classy Cook's Kitchen corner", 1200},
	{2170, "Cookie Dough Cook Machine", 500},
	{2127, "LoveU2 Fridge", 5000},
	{2127, "LoveU2 Unit", 2500},
	{2130, "LoveU2 Sink", 2000},
	{2129, "LoveU2 Cookin'", 3000},
	{2452, "Sprunk2Kitch", 1000},
	{2443, "Empty Sprunk Machine", 2000},
	{2361, "Ice Fridge", 600},
	{2149, "SeeJay MicroWave", 1200},
	{2426, "Pizza Baby Oven", 1200},
	{1328, "Trash Bin", 200},
	{1371, "Dem Hippo Bin", 400},
	{2770, "Cluckin' Bin", 500},
	{1337, "Rolling Trash Can", 600},
	{1415, "Dumpster", 2000},
	{1439, "Dumpster No. 2", 2000},

	// Lights
	{2196, "Desk Lamp", 600},
	{2238, "Lava Lamp", 300},
	{2726, "Bunga Bunga Lamp", 600},
	{3534, "Triad Lamp", 700},
	{921, "Industrial Lights", 800},
	{1215, "The Bollard Inc. Light", 1500},
	{1734, "Retro Lamp", 1500},
	{15050, "Luxury Lamp", 2500},
	{2069, "Classy Lamp", 2000},
	{2073, "Ol' Man's Lamp", 2500},
	{2075, "China China Lamp", 3000},
	{2989, "Skylight", 3000},
	{3526, "Airport Light", 3000},
	{3785, "Headlight", 2000},
	{14527, "Fanny Fan", 2000},
	{19279, "Build Light", 2000},
	{19121, "Bolla Bolla 1", 3000},
	{19122, "Bolla Bolla 2", 3000},
	{19123, "Bolla Bolla 3", 3000},
	{19124, "Bolla Bolla 4", 3000},
	{19125, "Bolla Bolla 5", 3000},
	{19126, "Bolla Bolla 6", 3000},
	{19127, "Bolla Bolla 7", 3000},
	{18647, "Red Neons", 8000},
	{18648, "Blue Neons", 8000},
	{18649, "Green Neons", 8000},
	{18650, "Yellow Neons", 8000},
	{18651, "Pink Neons", 8000},
	{18652, "White Neons", 8000},

	// Miscellaneous
	{19897, "Cigarette Pack 2", 500},
	{19896, "Cigarette Pack 1", 500},
	{19942, "Handheld Radio", 1000},
	{19944, "Bodybag", 10000},
	{18659, "Grove Spray", 5000},
	{18661, "VLA Spray", 5000},
	{18660, "Seville Spray", 5000},
	{18665, "LS Vagos", 5000},
	{18664, "Balla tag", 5000},
	{2404, "Rockstar Surfboard", 1000},
	{2405, "Surfboard 1", 1000},
	{2406, "Surfboard 2", 1000},
	{1640, "Beach towel 1", 500},
	{1641, "Beach towel 2", 500},
	{1642, "Beach towel 3", 500},
	{1643, "Beach towel 4", 500},
	{2845, "Pile of clothes 1", 100},
	{2846, "Pile of clothes 2", 100},
	{1550, "Sack of money", 5000},
	{19086, "Chainsaw dildo", 15000},
	{2690, "Fire extinguisher", 1000},
	{2773, "Airport velvet", 1000},
	{18782, "Giant cookie", 10000},
	{19054, "Giftbox 1", 10000},
	{19056, "Giftbox 2", 10000},
	{19076, "Christmas Tress", 10000},
	{19339, "Coffin", 1000},
	{19346, "Hotdog", 1000},
	{19579, "Rye Breado", 100},
	{19610, "Microphone", 100},
	{19611, "Microphone stand", 100},
	{19609, "Drum kit", 1000},
	{19804, "Padlock", 100},
	{19815, "Tool set", 1000},
	{19819, "Wineglass", 100},
	{19835, "Coffee cup", 100},
	{19820, "Beer bottle", 100},
	{119825, "Sprunk Clock", 100},
	{19873, "Toilet paper", 100},
	{19878, "Skateboard", 2000},
	{19830, "Blender", 2000},
	{19831, "BBQ", 2000},
	{11710, "Fire exit sign", 100},
	{11711, "Exit sign", 100},
	{11712, "Holy Cross", 666},
	{11725, "Fire place", 10000},
	{11713, "Fire hose holder", 1000},
	{11705, "Telephone", 1000},
	{11738, "MED cabinet", 1000},
	{11729, "Locker", 10000},

	// Office
	{1998, "Rimbo Rambo Desk", 1500},
	{1999, "Rimbo Rambo Desk 2", 1500},
	{2008, "Rimbo Rambo Desk 3", 1500},
	{2161, "Wooden Unit", 1500},
	{2162, "Wooden Unit 2", 1500},
	{2163, "Wooden Metal Cabinet", 1600},
	{2164, "Wooden Metal Cabinet 2", 1800},
	{2167, "Wooden Metal Cabinet 3", 2000},
	{2165, "Wooden Desk with Computer", 2000},
	{2166, "Wooden Desk", 1200},
	{2183, "Library Desk", 1500},
	{2204, "Rich Mahogany Cabinet", 3000},
	{2205, "Rich Mahogany Desk", 3500},
	{2207, "Super Rich Desk", 4000},
	{2208, "Wooden Seperator", 1500},
	{2209, "Glass Desk", 1500},
	{2210, "Glass Unit", 2000},
	{2211, "Glass Unit 2", 2500},
	{16378, "Office Set", 3000},
	{2190, "Macintosh 680", 5000},
	{2202, "HP Deskjet 3000", 5000},

	// Ornaments
	{2594, "Model Art", 1000},
	{2558, "Blue Curtains Closed", 500},
	{2559, "Blue Curtains Open", 500},
	{2561, "Big Blue Curtains Closed", 1000},
	{14752, "Luxury Curtains", 2000},
	{2047, "LS:CDF Flag", 1000},
	{2048, "Red-Blue Flag", 1000},
	{2614, "American Flag", 1000},
	{19306, "Red Flag", 1000},
	{2993, "Green Flag", 1000},
	{19307, "Purple Flag", 1000},
	{2631, "Red Carpet", 500},
	{2632, "Blue Carpet", 500},
	{11737, "Rockstar Carpet", 1000},
	{1828, "Tiger Car", 2000},
	{2815, "Purple Bedroom Rug", 1000},
	{2817, "Green Bedroom Rug", 1000},
	{2818, "Red Square Rug", 1000},
	{2833, "Classy Rug", 1000},
	{2834, "Classy Rug 2", 1000},
	{2836, "Classy Rug 3", 1000},
	{2835, "Round Classy Rug", 1000},
	{2841, "Round Blue Rug", 1000},
	{2847, "Sexy Rug", 2000},
	{3935, "Sexy Statue", 5000},
	{3471, "Lion Statue", 6000},
	{1736, "Ol' Pal's Deer", 5000},
	{14608, "Huge Budha", 15000},
	{2641, "Burger Poster", 1000},
	{2642, "Burger Poster 2", 1500},
	{2643, "Burger Shots", 1500},
	{2685, "Wash Hands", 1500},
	{2715, "Ring Donuts", 2000},
	{2051, "Target Poster", 2000},
	{2055, "Gun Poster", 2000},
	{2257, "Artistic Squares", 1000},
	{2254, "Yellow Cab", 1000},
	
	// Plants 
	{949, "Plant Pot", 700},
	{2001, "Plant Pot 2", 700},
	{2010, "Plant Pot 3", 800},
	{2011, "Palm Pot", 1000},
	{2244, "Natural Plant", 1200},
	{2345, "Plant Wall Decor", 1500},
	{3802, "Plant Ornament", 1500},
	{3811, "WinPlanterz", 2000},
	{14804, "Funky Plant", 3000},

	// Recreation
	{3111, "Blueprint", 1500},
	{19583, "The Knife", 3000},
	{2589, "Meat!", 3000},
	{2627, "Ol' Man's Threadmill", 2500},
	{2628, "Gym Bench", 3500},
	{2630, "Gym Bike", 4000},
	{1985, "Punch Bag", 1500},
	{2964, "Blue Pool Table", 1500},
	{1518, "Aristona TV", 1500},
	{1748, "Ol' Skool TV", 1600},
	{1749, "SmallWatch", 1600},
	{1752, "Swanky TV", 2000},
	{1786, "Swank HD TV", 2500},
	{2091, "TV in Ward", 3000},
	{2093, "White TV in Ward", 3500},
	{2224, "Funky Sphere TV", 5000},
	{2296, "TV Unit", 4500},
	{2297, "TV Unit 2", 4500},
	{14604, "TV Stand", 2500},
	{19786, "OLED TV", 9000},
	{2778, "Bee Bee Gone! Arcade", 6000},
	{2779, "Duality Arcade", 7000},
	{1719, "Nintendo 64", 12000},
	{2028, "Playstation 5", 15000},
	{2229, "Swanky Speaker", 6000},
	{2230, "Swanky Speaker 2", 6000},
	{2231, "Swanky Speaker 3", 6000},
	{2233, "Swanky Speaker 4", 6000},
	{2227, "HiFi Set", 4000},
	{18863, "Snow Machine", 100000},

	// Storage
	{2332, "Safe", 10000},
	{1742, "Medium Book Shelf", 1000},
	{14455, "Big Book Case", 5000},
	{2608, "Book n TV Shelf", 1000},
	{2567, "Warehouse Shelf", 2000},
	{1740, "Wooden Cabinet", 1000},
	{1741, "Wooden Cabinet 2", 1000},
	{1743, "Wooden Cabinet 3", 1500},
	{2078, "Ol' Lady's Cabinet", 1500},
	{2204, "Office Cabinet", 1500},
	{2562, "Bright Hotel Dresser", 2000},
	{2568, "Dark Hotel Dresser", 2500},
	{2570, "Regular Hotel Dresser", 1000},
	{2573, "Hotel Dresser Set", 2500},
	{2574, "Hotel Dresser Set 2", 2500},
	{2576, "Rich Mahogany Dresser", 2500},
	{19899, "Tool Cabinet", 3500},

	// Tables
	{1281, "Park Table", 1000},
	{1433, "Small Dining Table", 800},
	{1594, "Chair and Table Set", 1000},
	{1825, "Luxe Set", 1000},
	{1827, "Glass Coffee Table", 1000},
	{2086, "Roman Dining", 1000},
	{1822, "Coffee Swank Table", 1000},
	{2311, "Rich Mahogany Coffee Table", 1000},
	{2313, "Bright TV Table", 1000},
	{2315, "Dark TV Table", 2315},
	{2592, "Slot Table", 2500},
	{2764, "Pizza Table", 1000},
	{2799, "Cosy Set", 1500},
	{2802, "Cosy Set 2", 1500},

	// Walls
	{19372, "Wall", 2000},
	{19373, "Wall", 2000},
	{19374, "Wall", 2000},
	{19375, "Wall", 2000},
	{19376, "Wall", 2000},
	{19377, "Wall", 2000},
	{19378, "Wall", 2000},
	{19379, "Wall", 2000},
	{19380, "Wall", 2000},
	{19381, "Wall", 2000},
	{19382, "Wall", 2000},
	{19383, "Wall", 2000},
	{19384, "Wall", 2000},
	{19385, "Wall", 2000},
	{19386, "Wall", 2000},

	{19387, "Doorway wall", 2000},
	{19388, "Doorway wall", 2000},
	{19389, "Doorway wall", 2000},
	{19390, "Doorway wall", 2000},
	{19391, "Doorway wall", 2000},
	{19392, "Doorway wall", 2000},
	{19393, "Doorway wall", 2000},
	{19394, "Doorway wall", 2000},
	{19395, "Doorway wall", 2000},
	{19396, "Doorway wall", 2000},
	{19397, "Doorway wall", 2000},
	{19398, "Doorway wall", 2000},
	{19399, "Doorway wall", 2000},
	{19400, "Doorway wall", 2000},
	{19401, "Doorway wall", 2000},

	{19402, "Window wall", 2000},
	{19403, "Window wall", 2000},
	{19404, "Window wall", 2000},
	{19405, "Window wall", 2000},
	{19406, "Window wall", 2000},
	{19407, "Window wall", 2000},
	{19408, "Window wall", 2000},
	{19409, "Window wall", 2000},
	{19410, "Window wall", 2000},
	{19411, "Window wall", 2000},
	{19412, "Window wall", 2000},
	{19413, "Window wall", 2000},
	{19414, "Window wall", 2000},
	{19415, "Window wall", 2000},
	{19416, "Window wall", 2000}
};

timer FurnitureControl[1000](playerid, Float:X, Float:Y, Float:Z) {
	TogglePlayerControllable(playerid, true);
	SetPlayerPos(playerid, X, Y, Z);
}

hook OnGameModeInit() {

	FurnitureListInit();
	FurnitureTDInit();
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) {

	if(clickedid == Furniture_TD[22]) FurnitureMenu(playerid, 5); // Painting
	if(clickedid == Furniture_TD[23]) FurnitureMenu(playerid, 4); // Building
	if(clickedid == Furniture_TD[8]) BuildIcons(playerid, 1);
	if(clickedid == Furniture_TD[19] || clickedid == Furniture_TD[18]) FurnitureMenu(playerid, 2); // Build Mode.
	if(clickedid == Furniture_TD[9]) FurnitureMenu(playerid, 3); // Sell Mode.
	if(clickedid == Furniture_TD[10]) FurnitureMenu(playerid, 1); // Buy Mode.
	if(clickedid == Furniture_TD[14]) cmd_furniture(playerid, "");	
	if(clickedid == Furniture_TD[15]) cmd_furniturehelp(playerid, "");
	if(clickedid == Furniture_TD[17]) cmd_furnitureresetpos(playerid, "");
	if(clickedid == Furniture_TD[11]) FurniturePermit(playerid);
	return 1;
}

BuildIcons(playerid, choice) {

	switch(choice) {

		case 0: {

			TextDrawHideForPlayer(playerid, Furniture_TD[20]);
			TextDrawHideForPlayer(playerid, Furniture_TD[21]);
			TextDrawHideForPlayer(playerid, Furniture_TD[22]);
			TextDrawHideForPlayer(playerid, Furniture_TD[23]);
		}
		case 1: {

			TextDrawShowForPlayer(playerid, Furniture_TD[20]);
			TextDrawShowForPlayer(playerid, Furniture_TD[21]);
			TextDrawShowForPlayer(playerid, Furniture_TD[22]);
			TextDrawShowForPlayer(playerid, Furniture_TD[23]);
		}
	}
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_SPRINT && newkeys & KEY_CROUCH) {

		if(GetPVarType(playerid, PVAR_FURNITURE_EDITING)) {

			new Float:fPos[3],
				iObjectID = GetPVarInt(playerid, PVAR_FURNITURE_EDITING);

			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			SetDynamicObjectPos(iObjectID, fPos[0], fPos[1], fPos[2]);
		}
	}
	if(newkeys & KEY_LOOK_BEHIND && GetPVarInt(playerid, PVAR_FURNITURE)) {

		if(!Bit_State(g_PlayerBits[playerid], g_bCursor)) {
 		
			Bit_On(g_PlayerBits[playerid], g_bCursor);
			SelectTextDraw(playerid, 0xF6FBFCFF);
		}
		else {
			CancelSelectTextDraw(playerid);
			Bit_Off(g_PlayerBits[playerid], g_bCursor);
		}
		return 1;
	}
	if((newkeys & KEY_YES) && IsPlayerInAnyDynamicArea(playerid)) {

		new areaid[3],
			iObjectID,
			iState,
			Float:fPos[6],
			szData[3];

		GetPlayerDynamicAreas(playerid, areaid);
		for(new i; i < sizeof(areaid); ++i) {

			Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid[i], E_STREAMER_EXTRA_ID, szData, sizeof(szData));
			iObjectID = szData[1];
			iState = szData[2];

			if(IsValidDynamicObject(iObjectID)) {
				if(IsDynamicObjectMoving(iObjectID)) return 1;
				GetDynamicObjectPos(iObjectID, fPos[0], fPos[1], fPos[2]);
				GetDynamicObjectRot(iObjectID, fPos[3], fPos[4], fPos[5]);
				if(IsPlayerInRangeOfPoint(playerid, 3.0, fPos[0], fPos[1], fPos[2])) {
					switch(iState) {
						case 0: {
							szData[2] = 1;
							MoveDynamicObject(iObjectID, fPos[0] + 0.01, fPos[1], fPos[2], 0.03, fPos[3], fPos[4], fPos[5] + 90.0);
							Streamer_SetArrayData(STREAMER_TYPE_AREA, areaid[i], E_STREAMER_EXTRA_ID, szData, sizeof(szData));
						}
						case 1: {
							szData[2] = 0;
							MoveDynamicObject(iObjectID, fPos[0] - 0.01, fPos[1], fPos[2], 0.03, fPos[3], fPos[4], fPos[5] - 90.0);
							Streamer_SetArrayData(STREAMER_TYPE_AREA, areaid[i], E_STREAMER_EXTRA_ID, szData, sizeof(szData));
						}
					}
				}
			}
		}
	}
	return 1;
}

GetMaxFurnitureSlots(playerid) {

	new iMaxSlots;
	if(PlayerInfo[playerid][pDonateRank] > 0) {

		switch(PlayerInfo[playerid][pDonateRank]) {
			case 0: iMaxSlots = 30; // Regular
			case 1: iMaxSlots = 35; // Bronze VIPs
			case 2: iMaxSlots = 40; // Silver VIPs
			case 3: iMaxSlots = 50; // Gold VIPs
			case 4: iMaxSlots = 75; // Platinum VIPs
		}
	}
	if(PlayerInfo[playerid][pFurnitureSlots] > iMaxSlots) iMaxSlots = PlayerInfo[playerid][pFurnitureSlots];
	if(IsAdminLevel(playerid, ADMIN_HEAD)) iMaxSlots = MAX_FURNITURE_SLOTS;
	return iMaxSlots;
}

CheckSlotValidity(playerid, iSlotID) {

	new iMaxSlots;

	if(PlayerInfo[playerid][pDonateRank] > 0) {

		switch(PlayerInfo[playerid][pDonateRank]) {
			case 0: iMaxSlots = 30; // Regular
			case 1: iMaxSlots = 35; // Bronze VIPs
			case 2: iMaxSlots = 40; // Silver VIPs
			case 3: iMaxSlots = 50; // Gold VIPs
			case 4: iMaxSlots = 75; // Platinum VIPs
		}
	}
	if(PlayerInfo[playerid][pFurnitureSlots] > iMaxSlots) iMaxSlots = PlayerInfo[playerid][pFurnitureSlots];
	if(iSlotID >= iMaxSlots) return 0;
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	switch(dialogid) {
		
		case DIALOG_FURNITURE: {
			if(!response) return 1;
			switch(listitem) {
				case 0: FurnitureMenu(playerid, 1);
				case 1: FurnitureMenu(playerid, 2);
				case 2: FurnitureMenu(playerid, 3);
			}
		}
		case DIALOG_FURNITURE_BUY: {
			if(!response) return FurnitureMenu(playerid, 0);

			ShowModelSelectionMenu(playerid, FurnitureList[listitem], szFurnitureCategories[listitem], 0x00000099, 0x000000BB, 0xFFFF00AA);
		}
		case DIALOG_FURNITURE_BUYCONFIRM: {

			if(!response) return FurnitureMenu(playerid, 0);

			new iModelID = GetPVarInt(playerid, PVAR_FURNITURE_BUYMODEL),
				iHouseID = GetHouseID(playerid),
				iSlotID = -1;

			iSlotID = GetNextFurnitureSlotID(playerid, iHouseID);

			if(!CheckSlotValidity(playerid, iSlotID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any furniture slots left.");
			if(iSlotID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any furniture slots left.");
			
			new iPrice = GetFurniturePrice(iModelID);
			if(GetPlayerMoney(playerid) < iPrice) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough money to buy this.");
			if(PlayerInfo[playerid][pMats] < (iPrice / 10)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough materials to make this.");

			new Float:fPos[3],
				iVW = GetPlayerVirtualWorld(playerid);

			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			defer FurnitureControl(playerid, fPos[0], fPos[1], fPos[2]);
			GetXYInFrontOfPlayer(playerid, fPos[0], fPos[1], 1.5);
			HouseInfo[iHouseID][hFurniture][iSlotID] = CreateDynamicObject(iModelID, fPos[0], fPos[1], fPos[2], 0.0, 0.0, 0.0, iVW);
			if(IsADoor(iModelID)) {

				new iLocalDoorArea = CreateDynamicSphere(fPos[0], fPos[1], fPos[2], 3.0, HouseInfo[iHouseID][hIntVW]),
					szData[3];

				szData[1] = HouseInfo[iHouseID][hFurniture][iSlotID];
				szData[2] = 0;
				Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
				Streamer_SetIntData(STREAMER_TYPE_OBJECT, szData[1], E_STREAMER_EXTRA_ID, iLocalDoorArea);
			}
			GivePlayerCash(playerid, -iPrice);
			PlayerInfo[playerid][pMats] -= (iPrice / 10);
			
			SetPVarInt(playerid, PVAR_FURNITURE_SLOT, iSlotID);
			SetPVarInt(playerid, PVAR_FURNITURE_EDITING, HouseInfo[iHouseID][hFurniture][iSlotID]);
			TogglePlayerControllable(playerid, false);
			CreateFurniture(playerid, iHouseID, iSlotID, iModelID, fPos[0], fPos[1], fPos[2], 0.0, 0.0, 0.0);
			EditDynamicObject(playerid, HouseInfo[iHouseID][hFurniture][iSlotID]);
			FurnitureEditObject(playerid);
			SetPVarInt(playerid, PVAR_FURNITURE_TIMER, SetTimerEx("FurnitureEditObject", 5000, true, "i", playerid));
		}
		case DIALOG_FURNITURE_EDIT: {

			if(!response) return FurnitureMenu(playerid, 0), DeletePVar(playerid, PVAR_FURNITURE_SLOT), DeletePVar(playerid, PVAR_FURNITURE_EDITING);

			new iHouseID = GetHouseID(playerid);

			if(GetPVarType(playerid, PVAR_FURNITURE_SLOT)) {
								
				switch(listitem) {

					case 0: {
						FurnitureEditObject(playerid);
						SetPVarInt(playerid, PVAR_FURNITURE_TIMER, SetTimerEx("FurnitureEditObject", 5000, true, "i", playerid));
						return EditDynamicObject(playerid, GetPVarInt(playerid, PVAR_FURNITURE_EDITING));
					}
					case 2: SetPVarInt(playerid, "color", 1);
				}
				return ShowPlayerDialog(playerid, DIALOG_FURNITURE_PAINT, DIALOG_STYLE_LIST, "Furniture Menu | Slot", "Slot 1\nSlot 2\nSlot 3\nSlot 4\nSlot 5\n{EE0000}Remove All", "Select", "Cancel");
			}
			else {

				if(IsValidDynamicObject(HouseInfo[iHouseID][hFurniture][listitem])) {

					SetPVarInt(playerid, PVAR_FURNITURE_SLOT, listitem);
					SetPVarInt(playerid, PVAR_FURNITURE_EDITING, HouseInfo[iHouseID][hFurniture][listitem]);
					//return ShowPlayerDialog(playerid, DIALOG_FURNITURE_EDIT, DIALOG_STYLE_LIST, "Furniture Menu | Edit", "Move position\nChange texture\nChange color", "Select", "Back");
					return ShowPlayerDialog(playerid, DIALOG_FURNITURE_EDIT, DIALOG_STYLE_LIST, "Furniture Menu | Edit", "Move position\nChange texture", "Select", "Back");
				}
				else SendClientMessage(playerid, COLOR_GRAD1, "There's no furniture in that slot.");			
			}
		}
		case DIALOG_FURNITURE_SELL: {
			
			if(!response) return FurnitureMenu(playerid, 0), DeletePVar(playerid, "SellFurniture");

			if(GetPVarType(playerid, "SellFurniture")) {

				new iHouseID = GetHouseID(playerid),
					iSlotID = GetPVarInt(playerid, PVAR_FURNITURE_SLOT),
					iModelID = Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][iSlotID], E_STREAMER_MODEL_ID);

				DeletePVar(playerid, "SellFurniture");
				SellFurniture(playerid, iHouseID, iSlotID, GetFurniturePrice(iModelID));
				DeletePVar(playerid, PVAR_FURNITURE_SLOT);
			}
			else {
				new iHouseID = GetHouseID(playerid);
				if(IsValidDynamicObject(HouseInfo[iHouseID][hFurniture][listitem])) {
					SetPVarInt(playerid, "SellFurniture", 1);
					SetPVarInt(playerid, PVAR_FURNITURE_SLOT, listitem);
					format(szMiscArray, sizeof(szMiscArray), "Are you sure you want to sell the %s for $%s?", 
						GetFurnitureName(GetDynamicObjectModel(HouseInfo[iHouseID][hFurniture][listitem])), number_format(GetFurniturePrice(GetDynamicObjectModel(HouseInfo[iHouseID][hFurniture][listitem]))));
					ShowPlayerDialog(playerid, DIALOG_FURNITURE_SELL, DIALOG_STYLE_MSGBOX, "Furniture Menu | Confirm", szMiscArray, "Sell", "Cancel");
				}
				else SendClientMessage(playerid, COLOR_GRAD1, "There's no furniture in that slot.");
			}
		}
		case DIALOG_FURNITURE_PAINT: {

			if(!response) return 1;

			switch(listitem) {

				case 1: SetPVarInt(playerid, "color", 1);
			}
			return ShowPlayerDialog(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_LIST, "Furniture Menu | Slot", "Slot 1\nSlot 2\nSlot 3\nSlot 4\nSlot 5\n{EE0000}Remove All", "Select", "Cancel");
		}
		case DIALOG_FURNITURE_PAINT2: {

			if(!response) return DeletePVar(playerid, "color");

			if(!GetPVarType(playerid, "textslot")) {

				if(strcmp(inputtext, "Remove All", true) == 0) return ReloadFurniture(playerid);

				szMiscArray[0] = 0;
				SetPVarInt(playerid, "textslot", listitem);
				switch(GetPVarType(playerid, "color")) {

					case 0: {

						for(new i; i < sizeof(szFurnitureTextures); ++i) format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szFurnitureTextures[i][0]);
						return ShowPlayerDialog(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_LIST, "Furniture Menu | Texture Lab", szMiscArray, "Select", "Cancel");
					}
					case 1: return ShowPlayerDialog(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_INPUT, "Furniture Menu | Color Lab", "Please enter a HEX color code.", "Select", "Cancel");
				}
			}
			else {

				new iObjectID = GetPVarInt(playerid, PVAR_FURNITURE_EDITING),
					iSlotID = GetPVarInt(playerid, PVAR_FURNITURE_SLOT),
					iTextSlot = GetPVarInt(playerid, "textslot"),
					iHouseID = GetHouseID(playerid);

				switch(GetPVarType(playerid, "color")) {

					case 0: ProcessFurnitureTexture(iHouseID, iSlotID, iObjectID, iTextSlot, listitem, 0, 1);
					case 1: ProcessFurnitureTexture(iHouseID, iSlotID, iObjectID, iTextSlot, 0, strval(inputtext), 1);
				}

				DeletePVar(playerid, PVAR_FURNITURE_EDITING);
				DeletePVar(playerid, PVAR_FURNITURE_SLOT);
				DeletePVar(playerid, "textslot");
				DeletePVar(playerid, "color");
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Furniture]: {CCCCCC}You successfully painted the furniture.");
				return 1;
			}
		}
		case DIALOG_PERMITBUILDER: {

			if(isnull(inputtext) || !response) return DeletePVar(playerid, "PRMBLD");

			if(!GetPVarType(playerid, "PRMBLD")) {

				new uPlayer;

				sscanf(inputtext, "u", uPlayer);
				if(!IsPlayerConnected(uPlayer)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid player id.");

				SetPVarInt(playerid, "PRMBLD", uPlayer);
				format(szMiscArray, sizeof(szMiscArray), "[Furniture]: {DDDDDD}Which house would like like to permit {FFFF00}%s {DDDDDD}to build in?", GetPlayerNameEx(uPlayer));
				SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
				ShowPlayerDialog(playerid, DIALOG_PERMITBUILDER, DIALOG_STYLE_LIST, "Furniture | Permit Builder", "House 1\nHouse 2\nHouse3", "Select", "Cancel");
			}
			else {

				new iHouseID;

				switch(listitem) {
					case 0: {
						if(PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a house in this slot."), DeletePVar(playerid, "PRMBLD");
						iHouseID = PlayerInfo[playerid][pPhousekey];
					}
					case 1: {
						if(PlayerInfo[playerid][pPhousekey2] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a house in this slot."), DeletePVar(playerid, "PRMBLD");
						iHouseID = PlayerInfo[playerid][pPhousekey2];
					}
					case 2: {
						if(PlayerInfo[playerid][pPhousekey3] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a house in this slot."), DeletePVar(playerid, "PRMBLD");
						iHouseID = PlayerInfo[playerid][pPhousekey3];
					}
					default: return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid house ID."), DeletePVar(playerid, "PRMBLD");
				}

				new giveplayerid = GetPVarInt(playerid, "PRMBLD");
				PlayerInfo[giveplayerid][pHouseBuilder] = iHouseID;

				DeletePVar(playerid, "PRMBLD");
				format(szMiscArray, sizeof(szMiscArray), "%s granted you the permission to build in their house. Your previous home permissions have been replaced.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_YELLOW, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "You have granted %s the permission to build in your house.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			}
		}
	}
	return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z) {

	if(GetPVarType(playerid, PVAR_FURNITURE)) {

		CancelEdit(playerid);
		if(GetPVarType(playerid, "paint")) {

			new iHouseID = GetHouseID(playerid),
				i,
				iCount;
				
			for(i = 0; i < MAX_FURNITURE_SLOTS; ++i) if(HouseInfo[iHouseID][hFurniture][i] == objectid) iCount++;
			if(iCount == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This object is not a piece of furniture.");

			for(i = 0; i < MAX_FURNITURE_SLOTS; ++i) if(HouseInfo[iHouseID][hFurniture][i] == objectid) break;
			DeletePVar(playerid, "paint");

			TextDrawSetPreviewModel(Furniture_TD[4], modelid);
			TextDrawSetPreviewRot(Furniture_TD[4], 345.000000, 0.000000, 0.000000, 1.300000);
			TextDrawHideForPlayer(playerid, Furniture_TD[4]);
			TextDrawShowForPlayer(playerid, Furniture_TD[4]);
			TextDrawShowForPlayer(playerid, Furniture_TD[24]);
			TextDrawShowForPlayer(playerid, Furniture_TD[25]);

			BuildIcons(playerid, 0);
			SetPVarInt(playerid, PVAR_FURNITURE_SLOT, i);
			SetPVarInt(playerid, PVAR_FURNITURE_EDITING, objectid);
			// ShowPlayerDialog(playerid, DIALOG_FURNITURE_PAINT, DIALOG_STYLE_LIST, "Furniture Menu | Edit", "Change texture\nChange color", "Select", "Back");
			ShowPlayerDialog(playerid, DIALOG_FURNITURE_PAINT2, DIALOG_STYLE_LIST, "Furniture Menu | Texture Slot", "Slot 1\nSlot 2\nSlot 3\nSlot 4\nSlot 5\n{EE0000}Remove All", "Select", "Cancel");

		}
		else {

			new iHouseID = GetHouseID(playerid),
				iCount;

			for(new i; i < MAX_FURNITURE_SLOTS; ++i) if(HouseInfo[iHouseID][hFurniture][i] == objectid) iCount++;
			if(iCount == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This object is not a piece of furniture.");
			EditFurniture(playerid, objectid, modelid);
			BuildIcons(playerid, 0);
		}
	}

	return 1;	
}

EditFurniture(playerid, objectid, modelid) {

	new iHouseID = GetHouseID(playerid);
	DeletePVar(playerid, "furnfirst");
	for(new i; i < MAX_FURNITURE_SLOTS; ++i) if(HouseInfo[iHouseID][hFurniture][i] == objectid) SetPVarInt(playerid, PVAR_FURNITURE_SLOT, i);
	SetPVarInt(playerid, PVAR_FURNITURE_EDITING, objectid);
	FurnitureEditObject(playerid);
	SetPVarInt(playerid, PVAR_FURNITURE_TIMER, SetTimerEx("FurnitureEditObject", 5000, true, "i", playerid));
	TextDrawSetPreviewModel(Furniture_TD[4], modelid);
	TextDrawSetPreviewRot(Furniture_TD[4], 345.000000, 0.000000, 0.000000, 1.300000);
	TextDrawHideForPlayer(playerid, Furniture_TD[4]);
	TextDrawShowForPlayer(playerid, Furniture_TD[4]);
	TextDrawShowForPlayer(playerid, Furniture_TD[24]);
	TextDrawShowForPlayer(playerid, Furniture_TD[25]);
	EditDynamicObject(playerid, objectid);
}
			

FurnitureListInit() {

	new szDir[16];
	szDir = "furniture/";

	for(new i; i < sizeof(szFurnitureCategories); ++i) {
		format(szMiscArray, sizeof(szMiscArray), "%s%s.txt", szDir, szFurnitureCategories[i]);
		FurnitureList[i] = LoadModelSelectionMenu(szMiscArray);
	}
}

GetNextFurnitureSlotID(playerid, iHouseID) {

	new iSlotID = -1,
		iMaxSlots = GetMaxFurnitureSlots(playerid);
	for(new i; i < iMaxSlots; ++i) {

		if(!IsValidDynamicObject(HouseInfo[iHouseID][hFurniture][i])) {
			iSlotID = i;
			break;
		}
	}	
	return iSlotID;
}

GetHouseID(playerid) {

	for(new i; i < MAX_HOUSES; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW]) return i;
	}
	return INVALID_HOUSE_ID;
}

HousePermissionCheck(playerid, iHouseID) {

	if(PlayerInfo[playerid][pPhousekey] == iHouseID) return 1;
	if(PlayerInfo[playerid][pPhousekey2] == iHouseID) return 1;
	if(PlayerInfo[playerid][pPhousekey3] == iHouseID) return 1;
	if(PlayerInfo[playerid][pHouseBuilder] == iHouseID) return 1;
	if(IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;
	return 0;
}

FurnitureMenu(playerid, menu = 0) {

	DeletePVar(playerid, "paint");
	new iHouseID = GetHouseID(playerid);
	if(iHouseID == INVALID_HOUSE_ID) {

		cmd_furniture(playerid, "");
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a house anymore.");
	}
	if(!HousePermissionCheck(playerid, iHouseID)) {
		cmd_furniture(playerid, "");
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not allowed to modify this house's furniture.");
	}
	switch(menu) {

		case 0: {
			
			if(!GetPVarInt(playerid, PVAR_FURNITURE)) {

				SetPVarInt(playerid, PVAR_FURNITURE, 1);
				SelectTextDraw(playerid, 0xF6FBFCFF);
				TextDrawSetPreviewModel(Furniture_TD[4], PlayerInfo[playerid][pModel]);
				TextDrawSetPreviewRot(Furniture_TD[4], 345.000000, 0.000000, 320.000000, 1.000000);
				for(new i; i < sizeof(Furniture_TD) - 6; ++i) TextDrawShowForPlayer(playerid, Furniture_TD[i]);
			}
			else {
				TextDrawHideForPlayer(playerid, Furniture_TD[24]);
				TextDrawHideForPlayer(playerid, Furniture_TD[25]);
				SelectTextDraw(playerid, 0xF6FBFCFF);
				DeletePVar(playerid, PVAR_FURNITURE_EDITING);
				DeletePVar(playerid, PVAR_FURNITURE_SLOT);
			}
			/*return ShowPlayerDialog(playerid, DIALOG_FURNITURE, DIALOG_STYLE_LIST, "Furniture Menu", "\
				Buy furniture\n\
				Edit furniture\n\
				Sell furniture\n", "Select", "Cancel");
			*/
		}
		case 1: { // Buy furniture.

			return ShowPlayerDialog(playerid, DIALOG_FURNITURE_BUY, DIALOG_STYLE_LIST, "Furniture Menu | Categories", FurnitureCatalog(), "Select", "Back");
		}
		case 2: { // Edit your own furniture.

			szMiscArray[0] = 0;
			TextDrawShowForPlayer(playerid, Furniture_TD[sizeof(Furniture_TD) - 2]);
			TextDrawShowForPlayer(playerid, Furniture_TD[sizeof(Furniture_TD) - 1]);
			new iMaxSlots = GetMaxFurnitureSlots(playerid);
			for(new i; i < iMaxSlots; ++i) {

				if(IsValidDynamicObject(HouseInfo[iHouseID][hFurniture][i])) format(szMiscArray, sizeof(szMiscArray), "%s[%d] %s\n", szMiscArray, i, GetFurnitureName(Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][i], E_STREAMER_MODEL_ID)));
				else format(szMiscArray, sizeof(szMiscArray), "%s[%d] %s\n", szMiscArray, i, "None");
			}
			if(isnull(szMiscArray)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any furniture.");
			return ShowPlayerDialog(playerid, DIALOG_FURNITURE_EDIT, DIALOG_STYLE_LIST, "Furniture Menu | Edit", szMiscArray, "Select", "Cancel");
		}
		case 3: { // Sell furniture.

			szMiscArray[0] = 0;
			new iMaxSlots = GetMaxFurnitureSlots(playerid);
			for(new i; i < iMaxSlots; ++i) {

				if(IsValidDynamicObject(HouseInfo[iHouseID][hFurniture][i])) format(szMiscArray, sizeof(szMiscArray), "%s[%d] %s\n", szMiscArray, i, GetFurnitureName(Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][i], E_STREAMER_MODEL_ID)));
				else format(szMiscArray, sizeof(szMiscArray), "%s[%d] %s\n", szMiscArray, i, "None");
			}
			if(isnull(szMiscArray)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any furniture.");
			return ShowPlayerDialog(playerid, DIALOG_FURNITURE_SELL, DIALOG_STYLE_LIST, "Furniture Menu | Sell", szMiscArray, "Select", "Cancel");

		}
		case 4: { // New Build Mode.

			SelectObject(playerid);
			return 1;
		}
		case 5: { // Paint

			SetPVarInt(playerid, "Paint", 1);
			SelectObject(playerid);
			return 1;
		}
	}
	return 1;
}

FurnitureCatalog() {

	szMiscArray[0] = 0;
	for(new i; i < sizeof(szFurnitureCategories); ++i) {
		format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szFurnitureCategories[i]);
	}
	return szMiscArray;
}


GetFurnitureName(iModelID) {
	
	new szName[32];

	for(new i; i < sizeof(szFurnitureCatList); ++i) {

		if(iModelID == szFurnitureCatList[i][0][0]) {

			szName = szFurnitureCatList[i][1];
			break;
		}
	}
	return szName;
}

GetFurniturePrice(iModelID) {
	
	new iPrice;

	for(new i; i < sizeof(szFurnitureCatList); ++i) {

		if(iModelID == szFurnitureCatList[i][0][0]) {

			iPrice = szFurnitureCatList[i][2][0];
			break;
		}
	}
	return iPrice;
}

SellFurniture(playerid, iHouseID, iSlotID, iPrice) {

	format(szMiscArray, sizeof(szMiscArray), "You have sold the %s for $%s", GetFurnitureName(GetDynamicObjectModel(HouseInfo[iHouseID][hFurniture][iSlotID])), number_format(iPrice));
	SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
	DestroyFurniture(iHouseID, iSlotID);
}

GetDynamicObjectModel(iObjectID) {

	return Streamer_GetIntData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_MODEL_ID);
}

CMD:furniturehelp(playerid, params[]) {

	SendClientMessageEx(playerid, COLOR_YELLOW, "[Furniture] {CCCCCC}/furniture | /furnitureresetpos | /permitbuilder | /revokebuilders | Press ~k~~PED_LOOKBEHIND~ to toggle the mouse cursor.");
	SendClientMessageEx(playerid, COLOR_YELLOW, "[Furniture] {CCCCCC}/unfurnishhouse (remove default furniture) | /furnishhouse (add default furniture).");
	return 1;
}

CMD:furniture(playerid, params[]) {

	if(GetPVarType(playerid, PVAR_FURNITURE)) {
		for(new x; x < sizeof(Furniture_TD); ++x) TextDrawHideForPlayer(playerid, Furniture_TD[x]);
		CancelSelectTextDraw(playerid);
		DeletePVar(playerid, PVAR_FURNITURE);
		DeletePVar(playerid, PVAR_INHOUSE);
		DeletePVar(playerid, PVAR_FURNITURE_SLOT);
		DeletePVar(playerid, PVAR_FURNITURE_EDITING);
		DeletePVar(playerid, PVAR_FURNITURE_BUYMODEL);
	}			
	else {
		new i = GetHouseID(playerid);
		if(i == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must be in a house.");
		if(!HousePermissionCheck(playerid, i)) return SendClientMessage(playerid, COLOR_GRAD1, "You do not have the permission to edit this house's furniture.");
		FurnitureMenu(playerid, 0), SetPVarInt(playerid, PVAR_INHOUSE, i);
	}
	return 1;
}

CMD:unfurnishhouse(playerid, params[]) {
	
	new iHouseID = GetHouseID(playerid),
		Float:fHouseZ,
		fDistance;

	// if(!HousePermissionCheck(playerid, iHouseID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this in this house.");
	if(HouseInfo[iHouseID][hOwnerID] != GetPlayerSQLId(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Only the house owner can do this.");
	for(new i; i < sizeof(InteriorsList); ++i) {
		fDistance = floatround(GetDistanceBetweenPoints(HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ],
			InteriorsList[i][0], InteriorsList[i][1], InteriorsList[i][2]), floatround_round);

		if(fDistance < 100 && HouseInfo[iHouseID][hIntIW] == floatround(InteriorsList[i][3])) {
			
			fHouseZ = InteriorsList[i][2];
			break;
		}
	}

	if(fHouseZ == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This task cannot be completed for your house interior type.");

	if(HouseInfo[iHouseID][hInteriorZ] > fHouseZ + 25.0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your house is already unfurnished.");
	HouseInfo[iHouseID][hInteriorZ] = fHouseZ + 30;
	HouseInfo[iHouseID][hCustomInterior] = 1;
	SaveHouse(iHouseID);

	new Float:fPos[6];
	for(new i; i < MAX_FURNITURE_SLOTS; ++i) {

		new iModelID = GetDynamicObjectModel(HouseInfo[iHouseID][hFurniture][i]);

		GetDynamicObjectPos(HouseInfo[iHouseID][hFurniture][i], fPos[0], fPos[1], fPos[2]);
		GetDynamicObjectRot(HouseInfo[iHouseID][hFurniture][i], fPos[3], fPos[4], fPos[5]);
		DestroyDynamicObject(HouseInfo[iHouseID][hFurniture][i]);

		fPos[2] -= 30;
		if(IsADoor(iModelID)) {

			new iLocalDoorArea = Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][i], E_STREAMER_EXTRA_ID),
				szData[3];
			DestroyDynamicArea(iLocalDoorArea);

			iLocalDoorArea = CreateDynamicSphere(fPos[0], fPos[1], fPos[2], 1.0, HouseInfo[iHouseID][hIntVW]),
			szData[1] = HouseInfo[iHouseID][hFurniture][i];
			szData[2] = 0;
			Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
			Streamer_SetIntData(STREAMER_TYPE_OBJECT, szData[1], E_STREAMER_EXTRA_ID, iLocalDoorArea);
		}
		HouseInfo[iHouseID][hFurniture][i] = CreateDynamicObject(iModelID, fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5], HouseInfo[iHouseID][hIntVW]);
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `z` = '%f' WHERE `houseid` = '%d' AND `slotid` = '%d'", fPos[2], iHouseID, i);
		mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	RehashHouse(iHouseID);
	// defer RehashHouseFurniture(iHouseID);
	foreach(new p : Player) {

		if(GetPVarInt(p, PVAR_INHOUSE) == iHouseID) {
			SendClientMessageEx(p, COLOR_GRAD1, "You will be moved to the unfurnished version of the house.");
			defer HousePosition(p, iHouseID);
		}
	}
	return 1;
}

timer HousePosition[5000](playerid, iHouseID) {

	Player_StreamPrep(playerid, HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ], FREEZE_TIME);
}

CMD:furnishhouse(playerid, params[]) {

	new iHouseID = GetHouseID(playerid),
		Float:fHouseZ,
		fDistance;

	// if(!HousePermissionCheck(playerid, iHouseID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this in this house.");
	if(HouseInfo[iHouseID][hOwnerID] != GetPlayerSQLId(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Only the house owner can do this.");
	for(new i; i < sizeof(InteriorsList); ++i) {
		fDistance = floatround(GetDistanceBetweenPoints(HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ],
			InteriorsList[i][0], InteriorsList[i][1], InteriorsList[i][2]), floatround_round);

		if(fDistance < 100 && HouseInfo[iHouseID][hIntIW] == floatround(InteriorsList[i][3])) {
			
			fHouseZ = InteriorsList[i][2];
			break;
		}
	}

	if(fHouseZ == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This task cannot be completed for your house interior type.");
	if(HouseInfo[iHouseID][hInteriorZ] < fHouseZ + 25.0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your house is already furnished.");
	HouseInfo[iHouseID][hInteriorZ] = fHouseZ;
	HouseInfo[iHouseID][hCustomInterior] = 0;
	SaveHouse(iHouseID);
	// defer RehashHouseFurniture(iHouseID);
	new Float:fPos[6];
	for(new i; i < MAX_FURNITURE_SLOTS; ++i) {

		new iModelID = GetDynamicObjectModel(HouseInfo[iHouseID][hFurniture][i]);

		GetDynamicObjectPos(HouseInfo[iHouseID][hFurniture][i], fPos[0], fPos[1], fPos[2]);
		GetDynamicObjectRot(HouseInfo[iHouseID][hFurniture][i], fPos[3], fPos[4], fPos[5]);
		DestroyDynamicObject(HouseInfo[iHouseID][hFurniture][i]);

		fPos[2] -= 30;
		if(IsADoor(iModelID)) {

			new iLocalDoorArea = Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][i], E_STREAMER_EXTRA_ID),
				szData[3];
			DestroyDynamicArea(iLocalDoorArea);

			iLocalDoorArea = CreateDynamicSphere(fPos[0], fPos[1], fPos[2], 1.0, HouseInfo[iHouseID][hIntVW]),
			szData[1] = HouseInfo[iHouseID][hFurniture][i];
			szData[2] = 0;
			Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
			Streamer_SetIntData(STREAMER_TYPE_OBJECT, szData[1], E_STREAMER_EXTRA_ID, iLocalDoorArea);
		}
		HouseInfo[iHouseID][hFurniture][i] = CreateDynamicObject(iModelID, fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5], HouseInfo[iHouseID][hIntVW]);
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `z` = '%f' WHERE `houseid` = '%d' AND `slotid` = '%d'", fPos[2], iHouseID, i);
		mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	RehashHouse(iHouseID);
	foreach(new p : Player) {

		if(GetPVarInt(p, PVAR_INHOUSE) == iHouseID) {
			SendClientMessageEx(p, COLOR_GRAD1, "You will be moved to the furnished version of the house.");
			defer HousePosition(p, iHouseID);
		}
	}
	return 1;
}

forward OnEditFurniture();
public OnEditFurniture() {

	if(mysql_errno()) return SendClientMessageToAll(0, "HELPPPPP");
	SendClientMessageToAll(0, "SUCCESS");
	return 1;
}

CMD:furnitureresetpos(playerid, params[]) {

	if(GetPVarType(playerid, PVAR_FURNITURE)) {

		new iHouseID = GetPVarInt(playerid, PVAR_INHOUSE);
		Player_StreamPrep(playerid, HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ], FREEZE_TIME);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You can only use this when you are falling while positioning a piece of furniture.");
	return 1;
}

CMD:destroyfurniture(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;

	new iHouseID = GetHouseID(playerid),
		iSlotID;

	if(iHouseID == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a house");
	if(sscanf(params, "d", iSlotID)) return SendClientMessageEx(playerid, COLOR_GREY, "Usage: /destroyfurniture [slot].");
	if(!IsValidDynamicObject(HouseInfo[iHouseID][hFurniture][iSlotID])) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid slot.");
	DestroyFurniture(iHouseID, iSlotID);
	return 1;
}

CMD:revokebuilders(playerid, params[]) {

	new iHouseID;
	if(sscanf(params, "d", iHouseID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /revokebuilder [house (1, 2, 3)]");
	switch(iHouseID) {
		case 1: if(PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "This house slot is not being used.");
		case 2: if(PlayerInfo[playerid][pPhousekey2] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "This house slot is not being used.");
		case 3: if(PlayerInfo[playerid][pPhousekey3] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "This house slot is not being used.");
		default: return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid house ID.");
	}

	foreach(new i : Player) if(PlayerInfo[playerid][pHouseBuilder] == iHouseID) PlayerInfo[playerid][pHouseBuilder] = INVALID_HOUSE_ID;
	format(szMiscArray, sizeof(szMiscArray), "SELECT `id` FROM `accounts` WHERE `HouseBuilder` = '%d'", iHouseID);
	mysql_function_query(MainPipeline, szMiscArray, true, "OnRevokeBuildPerms", "");
	SendClientMessageEx(playerid, COLOR_YELLOW, "All builder's permissions have been revoked.");
	return 1;
}

forward OnRevokeBuildPerms();
public OnRevokeBuildPerms() {

	new iRows = cache_get_row_count(MainPipeline);
	if(!iRows) return 1;

	new iFields;

	cache_get_data(iRows, iFields, MainPipeline);
	for(new row; row < iRows; ++row) {

		format(szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET `HouseBuilder` = '%d' WHERE `id` = '%d'", INVALID_HOUSE_ID, cache_get_field_content_int(row, "id", MainPipeline));
		mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	return 1;
}

forward FurnitureEditObject(playerid);
public FurnitureEditObject(playerid) {
	
	new Float:fPos[6];
	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	if(!GetPVarType(playerid, "furnfirst")) {

		SetPVarInt(playerid, "furnfirst", 1);
		SetPVarFloat(playerid, "PX", fPos[0]);
		SetPVarFloat(playerid, "PY", fPos[1]);
		SetPVarFloat(playerid, "PZ", fPos[2]);
		return 1;
	}
	fPos[3] = GetPVarFloat(playerid, "PX");
	fPos[4] = GetPVarFloat(playerid, "PY");
	fPos[5] = GetPVarFloat(playerid, "PZ");
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, fPos[3], fPos[4], fPos[5])) {

		CancelEdit(playerid);
		KillTimer(GetPVarInt(playerid, PVAR_FURNITURE_TIMER));
		DeletePVar(playerid, PVAR_FURNITURE_TIMER);
		DeletePVar(playerid, "furnfirst");
		new iHouseID = GetPVarInt(playerid, PVAR_INHOUSE);
		Player_StreamPrep(playerid, HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ], FREEZE_TIME);
		SendClientMessageEx(playerid, COLOR_GRAD1, "You went too far away.");
		return 1;
	}
	if(fPos[5] > (fPos[2] + 2.0)) {

		CancelEdit(playerid);
		KillTimer(GetPVarInt(playerid, PVAR_FURNITURE_TIMER));
		DeletePVar(playerid, PVAR_FURNITURE_TIMER);
		DeletePVar(playerid, "furnfirst");
		new iHouseID = GetPVarInt(playerid, PVAR_INHOUSE);
		Player_StreamPrep(playerid, HouseInfo[iHouseID][hInteriorX], HouseInfo[iHouseID][hInteriorY], HouseInfo[iHouseID][hInteriorZ], FREEZE_TIME);
		SendClientMessageEx(playerid, COLOR_GRAD1, "You went too far away.");
		return 1;
	}
	return 1;
}

FurniturePermit(playerid) {

	ShowPlayerDialog(playerid, DIALOG_PERMITBUILDER, DIALOG_STYLE_INPUT, "Furniture | Permit Builder", "Enter the ID or name of the person you would like to permit to build in your house.", "Select", "Cancel");

}

LoadFurniture() {

	mysql_function_query(MainPipeline, "SELECT * FROM `furniture`", true, "OnLoadFurniture", "");
}

forward OnLoadFurniture();
public OnLoadFurniture() {

	new iRows = cache_get_row_count(MainPipeline);
	if(!iRows) return print("[Furniture] No furniture was found in the database.");

	new iCount;
	for(iCount = 0; iCount < iRows; ++iCount) {

		ProcessFurniture(0,
			cache_get_field_content_int(iCount, "houseid", MainPipeline),
			cache_get_field_content_int(iCount, "slotid", MainPipeline), 
			cache_get_field_content_int(iCount, "modelid", MainPipeline),
			cache_get_field_content_float(iCount, "x", MainPipeline), 
			cache_get_field_content_float(iCount, "y", MainPipeline),
			cache_get_field_content_float(iCount, "z", MainPipeline),
			cache_get_field_content_float(iCount, "rx", MainPipeline), 
			cache_get_field_content_float(iCount, "ry", MainPipeline),
			cache_get_field_content_float(iCount, "rz", MainPipeline),
			cache_get_field_content_int(iCount, "text0", MainPipeline),
			cache_get_field_content_int(iCount, "text1", MainPipeline),
			cache_get_field_content_int(iCount, "text2", MainPipeline),
			cache_get_field_content_int(iCount, "text3", MainPipeline),
			cache_get_field_content_int(iCount, "text4", MainPipeline),
			cache_get_field_content_int(iCount, "col0", MainPipeline),
			cache_get_field_content_int(iCount, "col1", MainPipeline),
			cache_get_field_content_int(iCount, "col2", MainPipeline),
			cache_get_field_content_int(iCount, "col3", MainPipeline),
			cache_get_field_content_int(iCount, "col4", MainPipeline));
	}
	return printf("[Furniture] Loaded %d pieces of furniture from the database.", iCount);
}


timer RehashHouseFurniture[10000](iHouseID) {

	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `furniture` WHERE `houseid` = '%d'", iHouseID);
	mysql_function_query(MainPipeline, szMiscArray, true, "OnRehashHouseFurniture", "i", iHouseID);
}

forward OnRehashHouseFurniture(iHouseID);
public OnRehashHouseFurniture(iHouseID) {

	new iRows = cache_get_row_count(MainPipeline);
	if(!iRows) return 1;

	new iCount;
	for(iCount = 0; iCount < iRows; ++iCount) {

		ProcessFurniture(0,
			iHouseID,
			cache_get_field_content_int(iCount, "slotid", MainPipeline), 
			cache_get_field_content_int(iCount, "modelid", MainPipeline),
			cache_get_field_content_float(iCount, "x", MainPipeline), 
			cache_get_field_content_float(iCount, "y", MainPipeline),
			cache_get_field_content_float(iCount, "z", MainPipeline),
			cache_get_field_content_float(iCount, "rx", MainPipeline), 
			cache_get_field_content_float(iCount, "ry", MainPipeline),
			cache_get_field_content_float(iCount, "rz", MainPipeline),
			cache_get_field_content_int(iCount, "text0", MainPipeline),
			cache_get_field_content_int(iCount, "text1", MainPipeline),
			cache_get_field_content_int(iCount, "text2", MainPipeline),
			cache_get_field_content_int(iCount, "text3", MainPipeline),
			cache_get_field_content_int(iCount, "text4", MainPipeline),
			cache_get_field_content_int(iCount, "col0", MainPipeline),
			cache_get_field_content_int(iCount, "col1", MainPipeline),
			cache_get_field_content_int(iCount, "col2", MainPipeline),
			cache_get_field_content_int(iCount, "col3", MainPipeline),
			cache_get_field_content_int(iCount, "col4", MainPipeline));
	}
	return printf("[Furniture] Loaded %d pieces of furniture from the database.", iCount);
}


CreateFurniture(playerid, iHouseID, iSlotID, iModelID, Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ) {

	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `furniture` (`houseid`, `sqlid`, `modelid`, `slotid`, `x`,`y`,`z`, `rx`, `ry`, `rz`) \
		VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%f','%f')", iHouseID, PlayerInfo[playerid][pId], iModelID, iSlotID, X, Y, Z, RX, RY, RZ);
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

ProcessFurniture(type, iHouseID, iSlotID, iModelID, Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ, text0 = -1, text1 = -1, text2 = -1, text3 = -1, text4 = -1, col0 = -1, col1 = -1, col2 = -1, col3 = -1, col4 = -1) {

	switch(type) {

		case 0: {
			HouseInfo[iHouseID][hFurniture][iSlotID] = CreateDynamicObject(iModelID, X, Y, Z, RX, RY, RZ, HouseInfo[iHouseID][hIntVW]);
			ProcessFurnitureTexture(iHouseID, iSlotID, HouseInfo[iHouseID][hFurniture][iSlotID], 0, text0, col0, 0);
			ProcessFurnitureTexture(iHouseID, iSlotID, HouseInfo[iHouseID][hFurniture][iSlotID], 1, text1, col1, 0);
			ProcessFurnitureTexture(iHouseID, iSlotID, HouseInfo[iHouseID][hFurniture][iSlotID], 2, text2, col2, 0);
			ProcessFurnitureTexture(iHouseID, iSlotID, HouseInfo[iHouseID][hFurniture][iSlotID], 3, text3, col3, 0);
			ProcessFurnitureTexture(iHouseID, iSlotID, HouseInfo[iHouseID][hFurniture][iSlotID], 4, text4, col4, 0);
			if(IsADoor(iModelID)) {

				new iLocalDoorArea = CreateDynamicSphere(X, Y, Z, 3.0, HouseInfo[iHouseID][hIntVW]),
					szData[3];

				szData[1] = HouseInfo[iHouseID][hFurniture][iSlotID];
				szData[2] = 0;
				Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
				Streamer_SetIntData(STREAMER_TYPE_OBJECT, szData[1], E_STREAMER_EXTRA_ID, iLocalDoorArea);
			}
			return 1;
		}
	}
	return 1;
}

IsADoor(iModelID) {
	switch(iModelID) {
		case 1491, 1502, 1492, 1493, 1495, 1500, 1501, 1496, 1497, 1504, 1505, 1506, 1507, 1523, 1536, 1535, 1557, 19302, 19304, 18756, 11714, 3440, 3533, 19943, 1616, 1622: return 1;
	}
	return 0;
}

ProcessFurnitureTexture(iHouseID, iSlotID, iObjectID, textid, input, color = 0, sql = 0) {

	if(sql) {

		if(color == 0) {

			format(szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `text%d` = '%d' \
				WHERE `houseid` = '%d' AND `slotid` = '%d'", textid, input, iHouseID, iSlotID);
		}
		else {
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `col%d` = '%d' \
				WHERE `houseid` = '%d' AND `slotid` = '%d'", textid, color, iHouseID, iSlotID);
		}
		mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	if(input == -1) return 1;
	else SetDynamicObjectMaterial(iObjectID, textid, strval(szFurnitureTextures[input][1]), szFurnitureTextures[input][2], szFurnitureTextures[input][3], color);
	return 1;
}

ReloadFurniture(playerid) {

	new iObjectID = GetPVarInt(playerid, PVAR_FURNITURE_EDITING),
		iModelID = Streamer_GetIntData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_MODEL_ID),
		iSlotID = GetPVarInt(playerid, PVAR_FURNITURE_SLOT),
		iHouseID = GetHouseID(playerid);

	new Float:fPos[6];
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_X, fPos[0]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_Y, fPos[1]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_Z, fPos[2]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_R_X, fPos[3]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_R_Y, fPos[4]);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_R_Z, fPos[5]);

	DestroyDynamicObject(iObjectID);
	HouseInfo[iHouseID][hFurniture][iSlotID] = CreateDynamicObject(iModelID, fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5], HouseInfo[iHouseID][hIntVW]);

	if(IsADoor(iModelID)) {

		new iLocalDoorArea = Streamer_GetIntData(STREAMER_TYPE_OBJECT, iObjectID, E_STREAMER_EXTRA_ID),
			szData[3];
		
		DestroyDynamicArea(iLocalDoorArea);
		iLocalDoorArea = CreateDynamicSphere(fPos[0], fPos[1], fPos[2], 1.0, HouseInfo[iHouseID][hIntVW]),

		szData[1] = HouseInfo[iHouseID][hFurniture][iSlotID];
		szData[2] = 0;
		Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
		Streamer_SetIntData(STREAMER_TYPE_OBJECT, szData[1], E_STREAMER_EXTRA_ID, iLocalDoorArea);
	}

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `text0` = '-1', `text1` = '-1', `text2` = '-1', `text3` = '-1' \
			`col0` = '0', `col1` = '0', `col2` = '0', `col3` = '0', `col4` = '0' WHERE `houseid` = '%d' AND `slotid` = '%d'", iHouseID, iSlotID);
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

DestroyFurniture(iHouseID, iSlotID) {

	DestroyDynamicObject(HouseInfo[iHouseID][hFurniture][iSlotID]);
	format(szMiscArray, sizeof(szMiscArray), "DELETE FROM `furniture` WHERE `houseid` = '%d' AND `slotid` = '%d'", iHouseID, iSlotID);
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

FurnitureTDInit() {

	print("Textdraw file generated by");
	print("    Zamaroht's textdraw editor was loaded.");

	// Create the textdraws:
	Furniture_TD[0] = TextDrawCreate(555.000000, 356.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[0], 255);
	TextDrawFont(Furniture_TD[0], 4);
	TextDrawLetterSize(Furniture_TD[0], 0.209999, 1.200000);
	TextDrawColor(Furniture_TD[0], 9961471);
	TextDrawSetOutline(Furniture_TD[0], 0);
	TextDrawSetProportional(Furniture_TD[0], 1);
	TextDrawSetShadow(Furniture_TD[0], 1);
	TextDrawUseBox(Furniture_TD[0], 1);
	TextDrawBoxColor(Furniture_TD[0], 255);
	TextDrawTextSize(Furniture_TD[0], 74.000000, 73.000000);
	TextDrawSetSelectable(Furniture_TD[0], 0);

	Furniture_TD[1] = TextDrawCreate(572.000000, 322.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[1], 0);
	TextDrawFont(Furniture_TD[1], 4);
	TextDrawLetterSize(Furniture_TD[1], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[1], -926365636);
	TextDrawSetOutline(Furniture_TD[1], 0);
	TextDrawSetProportional(Furniture_TD[1], 1);
	TextDrawSetShadow(Furniture_TD[1], 2);
	TextDrawUseBox(Furniture_TD[1], 1);
	TextDrawBoxColor(Furniture_TD[1], 336860200);
	TextDrawTextSize(Furniture_TD[1], 32.000000, 36.000000);
	TextDrawSetSelectable(Furniture_TD[1], 0);

	Furniture_TD[2] = TextDrawCreate(559.000000, 359.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[2], 255);
	TextDrawFont(Furniture_TD[2], 4);
	TextDrawLetterSize(Furniture_TD[2], 0.209999, 1.200000);
	TextDrawColor(Furniture_TD[2], -1);
	TextDrawSetOutline(Furniture_TD[2], 0);
	TextDrawSetProportional(Furniture_TD[2], 1);
	TextDrawSetShadow(Furniture_TD[2], 1);
	TextDrawUseBox(Furniture_TD[2], 1);
	TextDrawBoxColor(Furniture_TD[2], 255);
	TextDrawTextSize(Furniture_TD[2], 67.000000, 66.000000);
	TextDrawSetSelectable(Furniture_TD[2], 0);

	Furniture_TD[3] = TextDrawCreate(571.000000, 421.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[3], 255);
	TextDrawFont(Furniture_TD[3], 4);
	TextDrawLetterSize(Furniture_TD[3], 0.209999, 1.200000);
	TextDrawColor(Furniture_TD[3], 1010580500);
	TextDrawSetOutline(Furniture_TD[3], 0);
	TextDrawSetProportional(Furniture_TD[3], 1);
	TextDrawSetShadow(Furniture_TD[3], 1);
	TextDrawUseBox(Furniture_TD[3], 1);
	TextDrawBoxColor(Furniture_TD[3], 255);
	TextDrawTextSize(Furniture_TD[3], 44.000000, -13.000000);
	TextDrawSetSelectable(Furniture_TD[3], 1);

	Furniture_TD[4] = TextDrawCreate(551.000000, 354.000000, "Skin");
	TextDrawBackgroundColor(Furniture_TD[4], 0);
	TextDrawFont(Furniture_TD[4], 5);
	TextDrawLetterSize(Furniture_TD[4], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[4], -1);
	TextDrawSetOutline(Furniture_TD[4], 0);
	TextDrawSetProportional(Furniture_TD[4], 1);
	TextDrawSetShadow(Furniture_TD[4], 2);
	TextDrawUseBox(Furniture_TD[4], 1);
	TextDrawBoxColor(Furniture_TD[4], 0);
	TextDrawTextSize(Furniture_TD[4], 80.000000, 74.000000);
	TextDrawSetPreviewModel(Furniture_TD[4], 93);
	TextDrawSetPreviewRot(Furniture_TD[4], 345.000000, 0.000000, 320.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[4], 0);

	Furniture_TD[5] = TextDrawCreate(525.000000, 368.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[5], 0);
	TextDrawFont(Furniture_TD[5], 4);
	TextDrawLetterSize(Furniture_TD[5], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[5], -926365636);
	TextDrawSetOutline(Furniture_TD[5], 0);
	TextDrawSetProportional(Furniture_TD[5], 1);
	TextDrawSetShadow(Furniture_TD[5], 2);
	TextDrawUseBox(Furniture_TD[5], 1);
	TextDrawBoxColor(Furniture_TD[5], 336860200);
	TextDrawTextSize(Furniture_TD[5], 32.000000, 36.000000);
	TextDrawSetSelectable(Furniture_TD[5], 1);

	Furniture_TD[6] = TextDrawCreate(603.000000, 329.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[6], 0);
	TextDrawFont(Furniture_TD[6], 4);
	TextDrawLetterSize(Furniture_TD[6], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[6], -926365636);
	TextDrawSetOutline(Furniture_TD[6], 0);
	TextDrawSetProportional(Furniture_TD[6], 1);
	TextDrawSetShadow(Furniture_TD[6], 2);
	TextDrawUseBox(Furniture_TD[6], 1);
	TextDrawBoxColor(Furniture_TD[6], 336860200);
	TextDrawTextSize(Furniture_TD[6], 32.000000, 36.000000);
	TextDrawSetSelectable(Furniture_TD[6], 1);

	Furniture_TD[7] = TextDrawCreate(542.000000, 335.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[7], 0);
	TextDrawFont(Furniture_TD[7], 4);
	TextDrawLetterSize(Furniture_TD[7], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[7], -926365636);
	TextDrawSetOutline(Furniture_TD[7], 0);
	TextDrawSetProportional(Furniture_TD[7], 1);
	TextDrawSetShadow(Furniture_TD[7], 2);
	TextDrawUseBox(Furniture_TD[7], 1);
	TextDrawBoxColor(Furniture_TD[7], 336860200);
	TextDrawTextSize(Furniture_TD[7], 32.000000, 36.000000);
	TextDrawSetSelectable(Furniture_TD[7], 1);

	Furniture_TD[8] = TextDrawCreate(528.000000, 339.000000, "Building mode");
	TextDrawBackgroundColor(Furniture_TD[8], 0);
	TextDrawFont(Furniture_TD[8], 5);
	TextDrawLetterSize(Furniture_TD[8], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[8], -1);
	TextDrawSetOutline(Furniture_TD[8], 0);
	TextDrawSetProportional(Furniture_TD[8], 1);
	TextDrawSetShadow(Furniture_TD[8], 2);
	TextDrawUseBox(Furniture_TD[8], 1);
	TextDrawBoxColor(Furniture_TD[8], 0);
	TextDrawTextSize(Furniture_TD[8], 66.000000, 31.000000);
	TextDrawSetPreviewModel(Furniture_TD[8], 18635);
	TextDrawSetPreviewRot(Furniture_TD[8], -16.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[8], 1);

	
	Furniture_TD[9] = TextDrawCreate(515.000000, 372.000000, "Sell Mode");
	TextDrawBackgroundColor(Furniture_TD[9], 0);
	TextDrawFont(Furniture_TD[9], 5);
	TextDrawLetterSize(Furniture_TD[9], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[9], -1);
	TextDrawSetOutline(Furniture_TD[9], 0);
	TextDrawSetProportional(Furniture_TD[9], 1);
	TextDrawSetShadow(Furniture_TD[9], 2);
	TextDrawUseBox(Furniture_TD[9], 1);
	TextDrawBoxColor(Furniture_TD[9], 0);
	TextDrawTextSize(Furniture_TD[9], 53.000000, 27.000000);
	TextDrawSetPreviewModel(Furniture_TD[9], 1274);
	TextDrawSetPreviewRot(Furniture_TD[9], 0.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[9], 1);

	Furniture_TD[10] = TextDrawCreate(570.000000, 324.000000, "Buy Mode");
	TextDrawBackgroundColor(Furniture_TD[10], 0);
	TextDrawFont(Furniture_TD[10], 5);
	TextDrawLetterSize(Furniture_TD[10], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[10], -1);
	TextDrawSetOutline(Furniture_TD[10], 0);
	TextDrawSetProportional(Furniture_TD[10], 1);
	TextDrawSetShadow(Furniture_TD[10], 2);
	TextDrawUseBox(Furniture_TD[10], 1);
	TextDrawBoxColor(Furniture_TD[10], 0);
	TextDrawTextSize(Furniture_TD[10], 37.000000, 33.000000);
	TextDrawSetPreviewModel(Furniture_TD[10], 1272);
	TextDrawSetPreviewRot(Furniture_TD[10], 0.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[10], 1);

	Furniture_TD[11] = TextDrawCreate(602.000000, 332.000000, "Permit Builder");
	TextDrawBackgroundColor(Furniture_TD[11], 0);
	TextDrawFont(Furniture_TD[11], 5);
	TextDrawLetterSize(Furniture_TD[11], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[11], -1);
	TextDrawSetOutline(Furniture_TD[11], 0);
	TextDrawSetProportional(Furniture_TD[11], 1);
	TextDrawSetShadow(Furniture_TD[11], 2);
	TextDrawUseBox(Furniture_TD[11], 1);
	TextDrawBoxColor(Furniture_TD[11], 0);
	TextDrawTextSize(Furniture_TD[11], 32.000000, 30.000000);
	TextDrawSetPreviewModel(Furniture_TD[11], 1314);
	TextDrawSetPreviewRot(Furniture_TD[11], 0.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[11], 1);

	Furniture_TD[12] = TextDrawCreate(603.000000, 424.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[12], 0);
	TextDrawFont(Furniture_TD[12], 4);
	TextDrawLetterSize(Furniture_TD[12], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[12], -926365636);
	TextDrawSetOutline(Furniture_TD[12], 0);
	TextDrawSetProportional(Furniture_TD[12], 1);
	TextDrawSetShadow(Furniture_TD[12], 2);
	TextDrawUseBox(Furniture_TD[12], 1);
	TextDrawBoxColor(Furniture_TD[12], 336860200);
	TextDrawTextSize(Furniture_TD[12], 13.000000, 14.000000);
	TextDrawSetSelectable(Furniture_TD[12], 1);

	Furniture_TD[13] = TextDrawCreate(617.000000, 413.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[13], 0);
	TextDrawFont(Furniture_TD[13], 4);
	TextDrawLetterSize(Furniture_TD[13], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[13], -926365636);
	TextDrawSetOutline(Furniture_TD[13], 0);
	TextDrawSetProportional(Furniture_TD[13], 1);
	TextDrawSetShadow(Furniture_TD[13], 2);
	TextDrawUseBox(Furniture_TD[13], 1);
	TextDrawBoxColor(Furniture_TD[13], 336860200);
	TextDrawTextSize(Furniture_TD[13], 13.000000, 14.000000);
	TextDrawSetSelectable(Furniture_TD[13], 1);

	Furniture_TD[14] = TextDrawCreate(618.000000, 414.000000, "LD_CHAT:thumbdn");
	TextDrawBackgroundColor(Furniture_TD[14], 0);
	TextDrawFont(Furniture_TD[14], 4);
	TextDrawLetterSize(Furniture_TD[14], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[14], -926365636);
	TextDrawSetOutline(Furniture_TD[14], 0);
	TextDrawSetProportional(Furniture_TD[14], 1);
	TextDrawSetShadow(Furniture_TD[14], 2);
	TextDrawUseBox(Furniture_TD[14], 1);
	TextDrawBoxColor(Furniture_TD[14], 336860200);
	TextDrawTextSize(Furniture_TD[14], 12.000000, 12.000000);
	TextDrawSetSelectable(Furniture_TD[14], 1);

	Furniture_TD[15] = TextDrawCreate(604.000000, 425.000000, "Info");
	TextDrawBackgroundColor(Furniture_TD[15], 0);
	TextDrawFont(Furniture_TD[15], 5);
	TextDrawLetterSize(Furniture_TD[15], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[15], -926365636);
	TextDrawSetOutline(Furniture_TD[15], 0);
	TextDrawSetProportional(Furniture_TD[15], 1);
	TextDrawSetShadow(Furniture_TD[15], 0);
	TextDrawUseBox(Furniture_TD[15], 1);
	TextDrawBoxColor(Furniture_TD[15], 336860200);
	TextDrawTextSize(Furniture_TD[15], 12.000000, 12.000000);
	TextDrawSetPreviewModel(Furniture_TD[15], 1239);
	TextDrawSetPreviewRot(Furniture_TD[15], -16.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[15], 1);

	Furniture_TD[16] = TextDrawCreate(624.000000, 367.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[16], 0);
	TextDrawFont(Furniture_TD[16], 4);
	TextDrawLetterSize(Furniture_TD[16], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[16], -926365636);
	TextDrawSetOutline(Furniture_TD[16], 0);
	TextDrawSetProportional(Furniture_TD[16], 1);
	TextDrawSetShadow(Furniture_TD[16], 2);
	TextDrawUseBox(Furniture_TD[16], 1);
	TextDrawBoxColor(Furniture_TD[16], 336860200);
	TextDrawTextSize(Furniture_TD[16], 13.000000, 14.000000);
	TextDrawSetSelectable(Furniture_TD[16], 1);

	Furniture_TD[17] = TextDrawCreate(625.000000, 367.000000, "LD_CHAT:badchat");
	TextDrawBackgroundColor(Furniture_TD[17], 0);
	TextDrawFont(Furniture_TD[17], 4);
	TextDrawLetterSize(Furniture_TD[17], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[17], -926365636);
	TextDrawSetOutline(Furniture_TD[17], 0);
	TextDrawSetProportional(Furniture_TD[17], 1);
	TextDrawSetShadow(Furniture_TD[17], 2);
	TextDrawUseBox(Furniture_TD[17], 1);
	TextDrawBoxColor(Furniture_TD[17], 336860200);
	TextDrawTextSize(Furniture_TD[17], 12.000000, 12.000000);
	TextDrawSetSelectable(Furniture_TD[17], 1);

	Furniture_TD[18] = TextDrawCreate(543.000000, 404.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[18], 0);
	TextDrawFont(Furniture_TD[18], 4);
	TextDrawLetterSize(Furniture_TD[18], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[18], -926365636);
	TextDrawSetOutline(Furniture_TD[18], 0);
	TextDrawSetProportional(Furniture_TD[18], 1);
	TextDrawSetShadow(Furniture_TD[18], 2);
	TextDrawUseBox(Furniture_TD[18], 1);
	TextDrawBoxColor(Furniture_TD[18], 336860200);
	TextDrawTextSize(Furniture_TD[18], 20.000000, 21.000000);
	TextDrawSetPreviewModel(Furniture_TD[18], 18635);
	TextDrawSetPreviewRot(Furniture_TD[18], -16.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[18], 1);

	Furniture_TD[19] = TextDrawCreate(542.000000, 404.000000, "House Icon 2");
	TextDrawBackgroundColor(Furniture_TD[19], 0);
	TextDrawFont(Furniture_TD[19], 5);
	TextDrawLetterSize(Furniture_TD[19], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[19], -1);
	TextDrawSetOutline(Furniture_TD[19], 1);
	TextDrawSetProportional(Furniture_TD[19], 1);
	TextDrawUseBox(Furniture_TD[19], 1);
	TextDrawBoxColor(Furniture_TD[19], 0);
	TextDrawTextSize(Furniture_TD[19], 22.000000, 21.000000);
	TextDrawSetPreviewModel(Furniture_TD[19], 1273);
	TextDrawSetPreviewRot(Furniture_TD[19], 0.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[19], 1);


	Furniture_TD[20] = TextDrawCreate(542.000000, 310.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[20], 0);
	TextDrawFont(Furniture_TD[20], 4);
	TextDrawLetterSize(Furniture_TD[20], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[20], -926365636);
	TextDrawSetOutline(Furniture_TD[20], 0);
	TextDrawSetProportional(Furniture_TD[20], 1);
	TextDrawSetShadow(Furniture_TD[20], 2);
	TextDrawUseBox(Furniture_TD[20], 1);
	TextDrawBoxColor(Furniture_TD[20], 336860200);
	TextDrawTextSize(Furniture_TD[20], 25.000000, 27.000000);
	TextDrawSetPreviewModel(Furniture_TD[20], 18635);
	TextDrawSetPreviewRot(Furniture_TD[20], -16.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[20], 1);

	Furniture_TD[21] = TextDrawCreate(519.000000, 333.000000, "ld_pool:ball");
	TextDrawBackgroundColor(Furniture_TD[21], 0);
	TextDrawFont(Furniture_TD[21], 4);
	TextDrawLetterSize(Furniture_TD[21], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[21], -926365636);
	TextDrawSetOutline(Furniture_TD[21], 0);
	TextDrawSetProportional(Furniture_TD[21], 1);
	TextDrawSetShadow(Furniture_TD[21], 2);
	TextDrawUseBox(Furniture_TD[21], 1);
	TextDrawBoxColor(Furniture_TD[21], 336860200);
	TextDrawTextSize(Furniture_TD[21], 25.000000, 27.000000);
	TextDrawSetPreviewModel(Furniture_TD[21], 18635);
	TextDrawSetPreviewRot(Furniture_TD[21], -16.000000, 0.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[21], 1);

	Furniture_TD[22] = TextDrawCreate(540.000000, 310.000000, "Paint");
	TextDrawBackgroundColor(Furniture_TD[22], -256);
	TextDrawFont(Furniture_TD[22], 5);
	TextDrawLetterSize(Furniture_TD[22], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[22], -922753281);
	TextDrawSetOutline(Furniture_TD[22], 0);
	TextDrawSetProportional(Furniture_TD[22], 1);
	TextDrawSetShadow(Furniture_TD[22], 0);
	TextDrawUseBox(Furniture_TD[22], 1);
	TextDrawBoxColor(Furniture_TD[22], 0);
	TextDrawTextSize(Furniture_TD[22], 29.000000, 27.000000);
	TextDrawSetPreviewModel(Furniture_TD[22], 19468);
	TextDrawSetPreviewRot(Furniture_TD[22], 0.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[22], 1);

	Furniture_TD[23] = TextDrawCreate(517.000000, 333.000000, "Build");
	TextDrawBackgroundColor(Furniture_TD[23], -256);
	TextDrawFont(Furniture_TD[23], 5);
	TextDrawLetterSize(Furniture_TD[23], 0.169999, 1.200000);
	TextDrawColor(Furniture_TD[23], -1);
	TextDrawSetOutline(Furniture_TD[23], 0);
	TextDrawSetProportional(Furniture_TD[23], 1);
	TextDrawSetShadow(Furniture_TD[23], 0);
	TextDrawUseBox(Furniture_TD[23], 1);
	TextDrawBoxColor(Furniture_TD[23], 0);
	TextDrawTextSize(Furniture_TD[23], 29.000000, 27.000000);
	TextDrawSetPreviewModel(Furniture_TD[23], 3096);
	TextDrawSetPreviewRot(Furniture_TD[23], 0.000000, 45.000000, 0.000000, 1.000000);
	TextDrawSetSelectable(Furniture_TD[23], 1);

	Furniture_TD[24] = TextDrawCreate(523.000000, 426.000000, "Building Mode");
	TextDrawAlignment(Furniture_TD[24], 2);
	TextDrawBackgroundColor(Furniture_TD[24], 255);
	TextDrawFont(Furniture_TD[24], 2);
	TextDrawLetterSize(Furniture_TD[24], 0.250000, 1.000000);
	TextDrawColor(Furniture_TD[24], -1);
	TextDrawSetOutline(Furniture_TD[24], 0);
	TextDrawSetProportional(Furniture_TD[24], 1);
	TextDrawSetShadow(Furniture_TD[24], 1);
	TextDrawSetSelectable(Furniture_TD[24], 1);

	Furniture_TD[25] = TextDrawCreate(448.000000, 437.000000, "Use the CROUCH and SPRINT key to move the object to your position");
	TextDrawAlignment(Furniture_TD[25], 2);
	TextDrawBackgroundColor(Furniture_TD[25], 255);
	TextDrawFont(Furniture_TD[25], 2);
	TextDrawLetterSize(Furniture_TD[25], 0.150000, 1.000000);
	TextDrawColor(Furniture_TD[25], -926355201);
	TextDrawSetOutline(Furniture_TD[25], 0);
	TextDrawSetProportional(Furniture_TD[25], 1);
	TextDrawSetShadow(Furniture_TD[25], 0);
	TextDrawSetSelectable(Furniture_TD[25], 0);
}