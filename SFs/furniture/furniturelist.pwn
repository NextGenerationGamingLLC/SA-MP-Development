/* NG:RP Furniture List
	Assembled by Jingles
*/

#include <a_samp>

// Bathroom

new szFurnitureCatList0[][][32] = {
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
	{2527, "Mac Shower", 5000}
};


// Comfort}
new szFurnitureCatList1[][][32] = {

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
	{11717, "Love Couch", 5000}
};


// Doors
new szFurnitureCatList2[][][32] = {

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
	{1622, "Security Camera 2", 2500}
};


// Household

new szFurnitureCatList3[][][32] = {

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
	{1439, "Dumpster No. 2", 2000}
};


// Lights
new szFurnitureCatList4[][][32] = {

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
	{18652, "White Neons", 8000}
};

// Office},

new szFurnitureCatList5[][][32] = {

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
	{2202, "HP Deskjet 3000", 5000}
};


// Ornaments

new szFurnitureCatList6[][][32] = {

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
	{2254, "Yellow Cab", 1000}
};


// Plants 

new szFurnitureCatList7[][][32] = {

	{949, "Plant Pot", 700},
	{2001, "Plant Pot 2", 700},
	{2010, "Plant Pot 3", 800},
	{2011, "Palm Pot", 1000},
	{2244, "Natural Plant", 1200},
	{2345, "Plant Wall Decor", 1500},
	{3802, "Plant Ornament", 1500},
	{3811, "WinPlanterz", 2000},
	{14804, "Funky Plant", 3000}
};



// Recreation
new szFurnitureCatList8[][][32] = {

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
	{2227, "HiFi Set", 4000}
};


// Storage
new szFurnitureCatList9[][][32] = {

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
	{19899, "Tool Cabinet", 3500}
};


// Tables

new szFurnitureCatList10[][][32] = {

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
	{2802, "Cosy Set 2", 1500}
};