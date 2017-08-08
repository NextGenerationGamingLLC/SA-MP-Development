/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[VARIABLES.PWN]--------------------------------


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


//MySQL Connection Variable
new MySQL: MainPipeline;
new MySQL: ShopPipeline;
new ShopToggle = 0;

#if defined zombiemode
new zombieevent;
new prezombie;
#endif

new szMiscArray[4096];

#if defined event_chancegambler
new chancegambler;
#endif

#if defined zombiemode
new Float:ZombieSpawns[28][4] = {
	{1350.6937,-1403.0984,13.3218,358.6370},
	{1356.0006,-1392.1688,13.4138,307.4587},
	{1197.9908,-1571.8323,13.3828,94.8079},
	{1357.4742,-1407.1138,13.3208,262.6198},
	{1152.7860,-1571.2064,13.3951,94.8079},
	{495.6123,-1724.2697,11.4812,117.3682},
	{503.5860,-1709.4460,12.9300,117.3682},
	{370.3556,-1647.0231,32.7236,83.1101},
	{351.9395,-1647.4919,32.9281,128.1101},
	{336.5251,-1645.6549,33.1162,83.1101},
	{330.3757,-1639.7368,33.1126,83.1101},
	{1951.6541,-1782.1271,13.5469,8.0371},
	{2008.7362,-1739.2256,13.5547,299.7298},
	{2222.9272,-1725.6631,14.6020,275.8117},
	{2230.1055,-1731.6937,13.3828,275.8117},
	{1566.9086,-1883.1245,13.5573,187.5554},
	{1568.2396,-1893.1550,13.5597,187.5554},
	{1492.0753,-1742.4341,13.5469,100.4479},
	{1479.4088,-1742.4391,13.5469,100.5523},
	{1480.2676,-1705.3685,15.3152,342.8424},
	{1487.0659,-1681.8663,14.0469,342.8424},
	{1538.6758,-1631.5092,13.3828,28.5895},
	{1549.9163,-1625.6472,14.2006,271.6107},
	{1562.6821,-1704.4867,5.8906,54.9909},
	{339.5412,-1513.9010,35.4142,142.1709},
	{355.3271,-1495.3164,36.2781,314.7233},
	{311.5376,-1501.7266,24.5938,145.0228},
	{297.2737,-1522.1150,24.5938,145.0228}
};
#endif

#if defined SHOPAUTOMATED
enum VehicleNameShopEnum
{
	svehicleid,
	svehiclename[24]
}
#endif

new ToyList = mS_INVALID_LISTID, CarList = mS_INVALID_LISTID, PlaneList = mS_INVALID_LISTID, BoatList = mS_INVALID_LISTID,  CarList2 = mS_INVALID_LISTID,  ToyList2 = mS_INVALID_LISTID, CarList3 = mS_INVALID_LISTID, SkinList = mS_INVALID_LISTID;

new lockercosttype[][] = { "Locker Stock", "Group Budget", "Player" };
new stock
	arrGroupData[MAX_GROUPS][eGroupData],
	arrGroupRanks[MAX_GROUPS][MAX_GROUP_RANKS][GROUP_MAX_RANK_LEN],
	arrGroupDivisions[MAX_GROUPS][MAX_GROUP_DIVS][GROUP_MAX_DIV_LEN],
	arrGroupLockers[MAX_GROUPS][MAX_GROUP_LOCKERS][eLockerData],
	arrGroupJurisdictions[MAX_GROUPS][MAX_GROUP_JURISDICTIONS][eJurisdictionData];

new
	DynVehicleInfo[MAX_DYNAMIC_VEHICLES][eGroupVehData],
	DynVehicleObjInfo[MAX_DYNAMIC_VEHICLES][MAX_DV_OBJECTS][eGroupVehObjectData];
// Gym dynamic objects
new BikeParkourObjects[2];
new BikeParkourObjectStage[2];
new Selected[MAX_PLAYERS][MAX_BUSINESSSALES];
new Businesses[MAX_BUSINESSES][eBiz];
new PlayerText:PlayerPokerUI[MAX_PLAYERS][MAX_PLAYERPOKERUI];
new PlayerText:PullDraw[MAX_PLAYERS][12];

new StoreItemCost[][StoreItemCostEnum] =
{
	{1},
	{1},
	{1},
	{1},
	{1},
	{2},
	{2},
	{2},
	{6},
	{3},
	{15},
	{4},
	{1},
	{1},
	{1},
	{25},
	{80},
	{28},
	{3},
	{1}
};

new const StoreItems[][] =
{
	"Cell Phone",
	"Phone Book",
	"Dice",
	"Condom",
	"Music Player",
	"Rope",
	"Cigar",
	"Sprunk",
	"Vehicle Lock",
	"Spraycan",
	"Portable Radio",
	"Camera",
	"Lottery Ticket",
	"Checkbook",
	"Papers",
	"Industrial Lock",
	"Electrical Lock",
	"Standard Car Alarm",
	"Helmet",
	"Rags"
};

new PokerTable[MAX_POKERTABLES][pkrInfo];

new TruckerDropoffs[][CargoArrayData] =
{
	{1220.2327,190.2997,20.0014}, // legal1
	{1323.5343,205.1021,19.7282}, // illegal 1
	{2139.3987,2518.7720,10.9946}, // legal 2
	{2203.9888,2490.0000,10.9617},// legal 2
	{2179.8560,2526.6365,10.9945}, // illegal 2
	{2536.3188,2315.7339,10.9895}, // legal 4
	{2518.2173,2321.1667,10.9782}, // illegal 3
	{664.3947,-546.8538,16.5103}, // legal 24/7
	{830.7441,-608.4459,16.5128}, // illegal
	{1887.0354,-1757.5684,13.6345}, // illegal
	{2101.4219,-1781.3594,13.5669}, // legal food
	{2857.1589,-1342.5669,11.1923}, // illegal
	{920.421142, -1361.637084, 13.003659},
	{1197.744384, -886.373901, 42.819854},
	{2111.115722, -1783.749877, 13.188007},
	{2236.051757, -1690.114990, 13.744861},
	{454.168640, -1501.456909, 30.757781},
	{2111.877929, -1218.093139, 23.604995},
	{2197.721923, -1975.567260, 13.359717},
	{1339.484497, -1763.289916, 13.332603},
	{1003.885925, -906.400634, 41.986915},
	{653.9890, 1690.1085, 6.9922},
	{2781.596435, -2494.261230, 13.457942},
	{2443.682373, -1426.901489, 23.796508},
	{2166.486083, -2273.158935, 13.166786}
};

new BoatDropoffs[][CargoArrayData] =
{
	{-107.3502,-567.7731,-0.4124}, // boat pickup 1
	{-323.5109,-471.8895,-0.4350}, // boat pickup
	{-1632.3124,159.0898,-0.5562}, // boat dropoff
	{-1472.8782,689.3031,-0.7115}, // boat dropoff
	{-1464.4757,1089.6381,-0.3583}, // boat dropoff
	{-2957.4927,500.7650,-0.8111}, // boat dropoff
	{-2240.6965, 2439.7158, -0.5795}, // boat dropoff
	{-2214.1277,2413.1074,-0.5795}, // boat dropoff
	{-1448.7850,1506.3970,0.0910}, // boat dropoff
	{-492.1511,617.2073,-0.4076}, // boat dropoff
	{1188.8872,654.2936,-0.3999} // boat dropoff
};

new const Drinks[][] =
{
	"Beer",
	"Vodka",
	"Whiskey",
	"Martini",
	"Tequilla",
	"Gin",
	"Water",
	"Soda"
};

new const SexItems[][] =
{
	"Purple Dildo",
	"Short Vibrator",
	"Long Vibrator",
	"White Dildo"
};

new const RestaurantItems[][] =
{
	"Starter Meal",
	"Full Meal",
	"Beer",
	"Vodka",
	"Whiskey",
	"Martini",
	"Tequilla",
	"Gin",
	"Water",
	"Soda"
};

new const Weapons[][WeaponsEnum] =
{
	{WEAPON_BRASSKNUCKLE,	25, 	1},
	{WEAPON_BAT,			25, 	2},
	{WEAPON_SHOVEL,			25, 	3},
	{WEAPON_KATANA, 		25, 	5},
	{WEAPON_SILENCED, 		100, 	1},
	{WEAPON_COLT45, 		150, 	1},
	{WEAPON_SHOTGUN,		200, 	1},
	{WEAPON_MP5,			400, 	2},
	{WEAPON_RIFLE, 			1000, 	2},
	{WEAPON_DEAGLE, 		2000, 	3}
};

// Hunger Games Event
new Float:hgRandomSpawn[5][3] = {
	{115.2273,1059.2841,13.6154},
	{-252.5923,1483.9485,75.5625},
	{-16.8378,1842.5656,17.6406},
	{-116.0394,1016.1692,19.8728},
	{-285.0634,863.9926,10.1560}
};

new Float:PokerTableMiscObjOffsets[MAX_POKERTABLEMISCOBJS][6] = {
{-1.25, -0.470, 0.1, 0.0, 0.0, 180.0}, // (Slot 2)
{-1.25, 0.470, 0.1, 0.0, 0.0, 180.0}, // (Slot 1)
{0.01, 1.85, 0.1, 0.0, 0.0, 90.0},  // (Slot 6)
{1.25, 0.470, 0.1, 0.0, 0.0, 0.0}, // (Slot 5)
{1.25, -0.470, 0.1, 0.0, 0.0, 0.0}, // (Slot 4)
{-0.01, -1.85, 0.1, 0.0, 0.0, -90.0} // (Slot 3)
};

new DeckTextdrw[53][] = {
"LD_CARD:cdback", // CARD BACK
"LD_CARD:cd1c", // A Clubs - 0
"LD_CARD:cd2c", // 2 Clubs - 1
"LD_CARD:cd3c", // 3 Clubs - 2
"LD_CARD:cd4c", // 4 Clubs - 3
"LD_CARD:cd5c", // 5 Clubs - 4
"LD_CARD:cd6c", // 6 Clubs - 5
"LD_CARD:cd7c", // 7 Clubs - 6
"LD_CARD:cd8c", // 8 Clubs - 7
"LD_CARD:cd9c", // 9 Clubs - 8
"LD_CARD:cd10c", // 10 Clubs - 9
"LD_CARD:cd11c", // J Clubs - 10
"LD_CARD:cd12c", // Q Clubs - 11
"LD_CARD:cd13c", // K Clubs - 12
"LD_CARD:cd1d", // A Diamonds - 13
"LD_CARD:cd2d", // 2 Diamonds - 14
"LD_CARD:cd3d", // 3 Diamonds - 15
"LD_CARD:cd4d", // 4 Diamonds - 16
"LD_CARD:cd5d", // 5 Diamonds - 17
"LD_CARD:cd6d", // 6 Diamonds - 18
"LD_CARD:cd7d", // 7 Diamonds - 19
"LD_CARD:cd8d", // 8 Diamonds - 20
"LD_CARD:cd9d", // 9 Diamonds - 21
"LD_CARD:cd10d", // 10 Diamonds - 22
"LD_CARD:cd11d", // J Diamonds - 23
"LD_CARD:cd12d", // Q Diamonds - 24
"LD_CARD:cd13d", // K Diamonds - 25
"LD_CARD:cd1h", // A Heats - 26
"LD_CARD:cd2h", // 2 Heats - 27
"LD_CARD:cd3h", // 3 Heats - 28
"LD_CARD:cd4h", // 4 Heats - 29
"LD_CARD:cd5h", // 5 Heats - 30
"LD_CARD:cd6h", // 6 Heats - 31
"LD_CARD:cd7h", // 7 Heats - 32
"LD_CARD:cd8h", // 8 Heats - 33
"LD_CARD:cd9h", // 9 Heats - 34
"LD_CARD:cd10h", // 10 Heats - 35
"LD_CARD:cd11h", // J Heats - 36
"LD_CARD:cd12h", // Q Heats - 37
"LD_CARD:cd13h", // K Heats - 38
"LD_CARD:cd1s", // A Spades - 39
"LD_CARD:cd2s", // 2 Spades - 40
"LD_CARD:cd3s", // 3 Spades - 41
"LD_CARD:cd4s", // 4 Spades - 42
"LD_CARD:cd5s", // 5 Spades - 43
"LD_CARD:cd6s", // 6 Spades - 44
"LD_CARD:cd7s", // 7 Spades - 45
"LD_CARD:cd8s", // 8 Spades - 46
"LD_CARD:cd9s", // 9 Spades - 47
"LD_CARD:cd10s", // 10 Spades - 48
"LD_CARD:cd11s", // J Spades - 49
"LD_CARD:cd12s", // Q Spades - 50
"LD_CARD:cd13s" // K Spades - 51
};

// Textdraw Global Variables
new Text:MainMenuTxtdraw[12];
new Text:NoticeTxtdraw[8];
new Text:TutTxtdraw[118];
new Text:WristWatch;
new PlayerText:GPS[MAX_PLAYERS];
new Text:BFText;
new Text:PriorityReport[MAX_PLAYERS];
new Text:TD_ServerError;
new Text:TD_LoginScreen;
new PlayerText:TD_ChatBox[11];
new Text:TD_RepFam;
new Text:g_tHouseLights;
//new Text:PointTime;


// Sobeit Check Variable
new sobeitCheckvar[MAX_PLAYERS];
new sobeitCheckIsDone[MAX_PLAYERS];
new IsPlayerFrozen[MAX_PLAYERS];

// Vehicle HUD Text
new PlayerText:_vhudTextFuel[MAX_PLAYERS];
new PlayerText:_vhudTextSpeed[MAX_PLAYERS];
new PlayerText:_vhudSeatBelt[MAX_PLAYERS];
new PlayerText:_vhudLights[MAX_PLAYERS];
new PlayerText:_vhudFlash[MAX_PLAYERS];
new PlayerText:_crTextTarget[MAX_PLAYERS];
new PlayerText:_crTextSpeed[MAX_PLAYERS];
new PlayerText:_crTickets[MAX_PLAYERS];
new _vhudVisible[MAX_PLAYERS]; // not to be confused with pSpeedo
new CarRadars[MAX_PLAYERS];
new PlayerText:BackupText[MAX_PLAYERS];
new BackupClearTimer[MAX_PLAYERS]; // backup clear timer

// Countdown var
new CountDown = 0;

// Main Menu Random Tooltips
new Tooltips[][] =
{
	"Next Generation Gaming Staff will never ask you for your password.",
	"Bored? Have a round of Paintball at the ~r~Paintball Arena~w~!",
	"Remember! We log everything, and have auto-detection for the majority of hacks.",
	"Don't have a voip server? No Problem! Use our ~b~TeamSpeak~w~ at ~y~ts.ng-gaming.net:9987~w~.",
	"We are not just a sa-mp community, don't forget to check our other projects at ~y~ng-gaming.net~w~!",
	"Don't forget to check out our E-store at ~y~shop.ng-gaming.net~w~, Helps keep this server up and running~w~!",
	"We have a full Advisors staff waiting to help you! Use ~g~/requesthelp~w~ to communicate with them!",
	"Found a bug? Don't report it to our staff, please goto our bug forums at ~y~ng-gaming.net~w~.",
	"Remember to read the ~r~rules~w~, failure to do so may lead toward punishment or even a ban.",
	"Wait at least 5 minutes inbetween ~g~/reports~w~, We work hard to get to everyone who reports.",
	"Want to make a suggestion? Our suggestions box is on our forums, submit away!",
	"If you get lost, be sure to take a look at the ~r~map~w~, in the Pause Menu.",
	"Dying to join a gang or faction? Be sure to roleplay with their leaders, or apply on the forums!",
	"Abusing newbie channel will result in mutes, frequent abuse will be punished with a ban.",
	"It's not nice to DM, it can also lead you to punishment or ban.",
	"Caught a player breaking the rules? Make a complaint on the forums, or simply ~g~/report ~w~it!"
};

new Float:HiddenTreasure[23][4] = {
{499.4000,-1876.4641,3.2405, 303.3795},
{572.4984,-1906.5488,1.1445, 241.9238},
{649.0212,-1891.9897,3.1568, 287.7738},
{681.2654,-1864.1283,4.6024, 356.4178},
{708.8422,-1861.1516,5.2880, 175.1556},
{530.7000,-1845.5283,4.3082, 69.9655},
{454.1830,-1825.2172,4.7307, 89.5104},
{411.1668,-1837.5348,3.6362, 101.0816},
{483.3954,-1817.4180,5.0099, 296.0503},
{571.5657,-1836.0237,4.7739,296.0283},
{609.7228,-1868.7610,4.0774,266.1917},
{544.5139,-1786.9791,5.3168,353.7110},
{584.9310,-1778.3846,9.1923,276.6728},
{640.9448,-1804.0861,8.6770,271.4366},
{705.0074,-1811.1953,10.8770,267.0296},
{688.1936,-1830.8987,6.1499,103.3270},
{511.9401,-1780.1162,5.1178,50.3657},
{440.7988,-1898.5311,0.9697,135.1886},
{495.5740,-1898.7710,0.7914,272.0278},
{555.6092,-1904.5034,1.2150,264.8812},
{641.1351,-1912.0164,1.5181,264.9957},
{709.3392,-1893.0990,3.1038,309.7114},
{404.1025,-1882.6399,2.0538,350.5217} };

new itemtype[][] = { "Nothing", "Cash", "Cannabis", "Crack", "Materials" };
new storagetype[][] = { "Pocket", "Bag", "Backpack", "Briefcase", "PSF" };

// Cash, Cannabis, Crack, Mats
//new onhandlimit[] = { 250000, 20, 15, 0 };
new const onhandlimit[] = { 2147483647, 50, 50, 2147483647 };
new bbackpacklimit[] = { 250000, 20, 15, 25000 };
new backpacklimit[] = { 500000, 200,  200, 75000 };
new briefcaselimit[] = { 500000, 100, 100, 50000 };

//new limits[][] = {{250000, 20, 15, 0}, {250000, 20, 15, 25000}, {500000, 200, 200, 75000}, {500000, 100, 100, 50000}};

new servernumber, betaserver;
new textdrawscount;

new hour, minuite, second;

new InsidePlane[MAX_PLAYERS];
new InsideMainMenu[MAX_PLAYERS char];
new InsideTut[MAX_PLAYERS char];
new pDrunkLevelLast[MAX_PLAYERS];
new pFPS[MAX_PLAYERS];


//new File:dumpfile; // global variable for buffer overflow protection
#if defined _WIN32
new File:logfile; // global variable for buffer overflow protection
#endif

new
	iRewardPlay,
	Text3D: tRewardText,
	iRewardObj,
	iRewardBox;

// Editing Objects
//new EditingObject[MAX_PLAYERS] = INVALID_OBJECT_ID;

//Kill Spoof Detecting
new SpoofKill[MAX_PLAYERS];
new KillTime[MAX_PLAYERS];

// SHIPMENT CONTRACTOR JOB

// Shipment revamp.
//new TruckUsedBy[MAX_VEHICLES] = -1;
//new TruckHolding[MAX_VEHICLES] = 0;

new TruckUsed[MAX_PLAYERS];
new TruckDeliveringTo[MAX_VEHICLES];
new TruckContents[MAX_VEHICLES char] = 0;
new TruckRoute[MAX_VEHICLES char] = -1;

new Float: VehicleFuel[MAX_VEHICLES];
new VehicleStatus[MAX_VEHICLES char] = 0; // 0 == none, 1 == vehicle dead about to respawn
new DynVeh[MAX_VEHICLES]; // -1 = Not a dynamic vehicle, 0 > = DynVehicleInfo ID


new Float: fVehSpeed[MAX_PLAYERS];
new Float: fVehHealth[MAX_PLAYERS];
new szAdvert[MAX_PLAYERS][128];
new AdvertType[MAX_PLAYERS];

// C4 vehicle bomb
new VehicleBomb[MAX_VEHICLES char] = 0;
new PlacedVehicleBomb[MAX_PLAYERS] = INVALID_VEHICLE_ID;

new audiourlurl[256];
new audiourlid;
new Float:audiourlparams[4];

/* SAAS */
/*
new backlift;
new sidelift;
new backhatch;
*/

new TempNumber[MAX_PLAYERS];

new Carrier[17];

new CrateLoad[2];
new AdminWarning;

new Price[MAX_ITEMS];

new ShopItems[MAX_ITEMS][ShopItem];

new AmountSold[MAX_ITEMS], AmountMade[MAX_ITEMS], GarageVW;

new PumpkinStock, HalloweenShop;

/*
new CrateVehicleLoad[MAX_VEHICLES][cVehicleLoad];*/
new LockerWep[MAX_GROUPS][lockerWeapons];
new CrateOrder[MAX_GROUPS][crateOrders];
new CrateBox[MAX_CRATES][crateInfo];
new CrateVehicle[MAX_CRATE_VEHCILES][CrateVehInfo];
new CrateFacility[MAX_CRATE_FACILITY][crateFacInfo];

// Vehicle Properties (Replicate from the crate vehicle).
new VehInfo[MAX_VEHICLES][vehProp];

//new IslandThreatElimTimer;

new IsRim[17] = { 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098, 1025 };

new TextSpamTimes[MAX_PLAYERS];
new TextSpamUnmute[MAX_PLAYERS];
new CommandSpamTimes[MAX_PLAYERS];
new CommandSpamUnmute[MAX_PLAYERS];

new control[MAX_PLAYERS];
new ControlTimer[MAX_PLAYERS];

/*
new controlspeed[MAX_PLAYERS];
new controldistance[MAX_PLAYERS];
*/

new Rocket[MAX_PLAYERS];
new RocketLight[MAX_PLAYERS];
new RocketSmoke[MAX_PLAYERS];
new RocketExplosions[MAX_PLAYERS];

new stationidv[MAX_VEHICLES][64];
new courtjail[MAX_PLAYERS];

new PlayerText: pFPSCounter[MAX_PLAYERS];

new TotalLogin, TotalConnect, TotalAutoBan, TotalRegister,MaxPlayersConnected,MPDay,MPMonth,MPYear,PlayerCars,TotalUptime;
new Float:StopaniFloats[MAX_PLAYERS][3];
new Float:EventFloats[MAX_PLAYERS][6]; // 0 = EventLastR 1 = EventLastX 2 = EventLastY 3 = EventLastZ 4 = EventLastH 5 = EventLastA
new RCPIdCurrent[MAX_PLAYERS];
new RaceTotalLaps;
new TotalJoinsRace;
new toglapcount;
new ConfigEventCPs[MAX_PLAYERS][3]; // 0 = person is editing the cps 1 = cp config stage 2 = creating/editing checkpoint
new ConfigEventCPId[MAX_PLAYERS]; // the eventcp Id that person is editing
/* person is editing the cps; 1 = yes 0 = no
   cp config stages; 0 = not active 1 = adjusting position 2 = confirming position 3 = setting checkpoint size 4 = setting checkpoint type

   checkpoint types; 1 = Start CP 2 = middle cp 3 = watering stations 4 = finish checkpoint */
new Float:BroadcastFloats[MAX_PLAYERS][6];
new BroadcastLastVW[MAX_PLAYERS];
new BroadcastLastInt[MAX_PLAYERS];
new EventLastInt[MAX_PLAYERS]; new EventLastVW[MAX_PLAYERS];
new Gifts, VIPGifts = 0, VIPGiftsTimeLeft, VIPGiftsName[MAX_PLAYER_NAME], ValGifts;
new GiftCode[32], GiftCodeBypass, SecurityCode[32], ShopClosed, SellClosed, RimMod, CarVoucher, PVIPVoucher;
new XMASGifts = 0;
new GiftAllowed;
new SpecTimer;
new WeatherCalling;
new gWeather;
new OrderAssignedTo[MAX_PLAYERS];

/* LA ELEVATOR STUFF - ORIGINALLY SCRIPTED BY SCOTT, PORTED CODE OVER FROM KYE ON 10/12/11 */

new Obj_Elevator, Obj_ElevatorDoors[2],
	Obj_FloorDoors[21][2];
new ElevatorState,
	ElevatorFloor;  // If Idle or Waiting, this is the current floor. If Moving, the floor it's moving to.
new ElevatorQueue[21],  	// Floors in queue.
	FloorRequestedBy[21];   // FloorRequestedBy[floor_id] = playerid; - Points out who requested which floor.
new ElevatorBoostTimer;     // Timer that makes the elevator move faster after players start surfing the object.
new Text3D:Label_Elevator, Text3D:Label_Floors[21];

new LAElevatorFloorData[2][21][24]; // Stores floor name and passwords

new gFerrisWheel;
new gFerrisCages[10];
new Float:gCurrentTargetYAngle = 0.0;
new gWheelTransAlternate = 0;
new Float:gFerrisOrigin[3] = {389.77, -2028.47, 22.0};

new gBug[MAX_PLAYERS char];
new gRadio[MAX_PLAYERS char];
new NOPTrigger[MAX_PLAYERS];
new pTazer[MAX_PLAYERS char];
new pTazerReplace[MAX_PLAYERS char];
new TazerTimeout[MAX_PLAYERS];
new pCurrentWeapon[MAX_PLAYERS char];
new ReleasingMenu[MAX_PLAYERS];
new ListItemReleaseId[MAX_PLAYERS][MAX_PLAYERVEHICLES];
new ListItemRCPId[MAX_PLAYERS][20];
new GiveKeysTo[MAX_PLAYERS];
new ListItemTrackId[MAX_PLAYERS][MAX_PLAYERVEHICLES];
new dynamicgift;
new Text3D:dynamicgift3DText;
new nextteam;
new AdvisorMessage;
new MatsHolding[MAX_PLAYERS];
new MatDeliver[MAX_PLAYERS];
new MatDeliver2[MAX_PLAYERS];
new NewbieTimer[MAX_PLAYERS];
new HelperTimer[MAX_PLAYERS];
new HlKickTimer[MAX_PLAYERS];
new JustReported[MAX_PLAYERS];
new UsedWeed[MAX_PLAYERS];
new UsedCrack[MAX_PLAYERS];
new Backup[MAX_PLAYERS];
new VIPM = 1;
new CreatedCars[100] = INVALID_VEHICLE_ID;
new Tax= 0;
new TaxValue = 0;
new TRTax = 0;
new TRTaxValue = 0, SpeedingTickets;
new nonewbie = 0;
new novip = 0;
new Jackpot, TicketsSold, NextDrawing, LottoNumbers[MAX_PLAYERS][5], SpecLotto, LottoPrize[64];
new Float:Positions[14][3];
new InRing = 0;
new RoundStarted = 0;
new BoxDelay = 0;
new Boxer1 = INVALID_PLAYER_ID;
new Boxer2 = INVALID_PLAYER_ID;
new TBoxer = INVALID_PLAYER_ID;
new PlayerBoxing[MAX_PLAYERS];
new Medics = 0;
new Coastguard = 0;
new MedicCall = INVALID_PLAYER_ID;
new MedicCallTime[MAX_PLAYERS];
new MedicAccepted[MAX_PLAYERS];
new Mechanics = 0;
new Lawyers = 0;
new Advisors = 0;
new shutdown = 0;
new timeshift = 0;
new MechanicCall = INVALID_PLAYER_ID;
new HelpingNewbie[MAX_PLAYERS];
new MechanicCallTime[MAX_PLAYERS];
new TaxiDrivers = 0;
new TaxiCallTime[MAX_PLAYERS];
new TaxiAccepted[MAX_PLAYERS];
new EMSCallTime[MAX_PLAYERS];
new EMSAccepted[MAX_PLAYERS];
new BusDrivers = 0;
new BusCallTime[MAX_PLAYERS];
new BusAccepted[MAX_PLAYERS];
new Text3D:Camera3D[MAX_PLAYERS];
new Text3D:RFLTeamN3D[MAX_PLAYERS];
new TransportDuty[MAX_PLAYERS];
new TransportValue[MAX_PLAYERS];
new TransportMoney[MAX_PLAYERS];
new TransportTime[MAX_PLAYERS];
new TransportCost[MAX_PLAYERS];
new TransportDriver[MAX_PLAYERS];
new JobDuty[MAX_PLAYERS];
new RegistrationStep[MAX_PLAYERS];
new playerSeconds[MAX_PLAYERS];
new playerTabbed[MAX_PLAYERS];
new playerAFK[MAX_PLAYERS];
new playerLastTyped[MAX_PLAYERS];
new UsedFind[MAX_PLAYERS];
new Spectating[MAX_PLAYERS];
new DivorceOffer[MAX_PLAYERS];
new MarriageCeremoney[MAX_PLAYERS];
new ProposeOffer[MAX_PLAYERS];
new ProposedTo[MAX_PLAYERS];
new GotProposedBy[MAX_PLAYERS];
new MarryWitness[MAX_PLAYERS];
new MarryWitnessOffer[MAX_PLAYERS];
new TicketOffer[MAX_PLAYERS];
new TicketMoney[MAX_PLAYERS];
new PlayerStoned[MAX_PLAYERS];
//new FishCount[MAX_PLAYERS];
new ActiveChatbox[MAX_PLAYERS];
new TutStep[MAX_PLAYERS];
new PlayerDrunk[MAX_PLAYERS];
new PlayerDrunkTime[MAX_PLAYERS];
new FindTimePoints[MAX_PLAYERS];
new FindingPlayer[MAX_PLAYERS];
new FindTime[MAX_PLAYERS];
new CalledCops[MAX_PLAYERS];
new CopsCallTime[MAX_PLAYERS];
new CalledMedics[MAX_PLAYERS];
new MedicsCallTime[MAX_PLAYERS];
new BoxWaitTime[MAX_PLAYERS];
new BoxOffer[MAX_PLAYERS];
new GotHit[MAX_PLAYERS];
new GoChase[MAX_PLAYERS];
new GetChased[MAX_PLAYERS];
new OrderReady[MAX_PLAYERS];
new ConnectedToPC[MAX_PLAYERS];
new PlayerTied[MAX_PLAYERS];
new PlayerCuffed[MAX_PLAYERS];
new PlayerCuffedTime[MAX_PLAYERS];
new LiveOffer[MAX_PLAYERS];
new TalkingLive[MAX_PLAYERS];
new broadcasting = 0;
new cameraangle = 0;
// new Text3D:camera;
new viewers = 0;
new SelectFChar[MAX_PLAYERS];
new SelectFCharPlace[MAX_PLAYERS];
new ChosenSkin[MAX_PLAYERS];
new GettingJob[MAX_PLAYERS];
new GettingJob2[MAX_PLAYERS];
new GettingJob3[MAX_PLAYERS];
new GuardOffer[MAX_PLAYERS];
new GuardPrice[MAX_PLAYERS];
new DefendOffer[MAX_PLAYERS];
new DefendPrice[MAX_PLAYERS];
new ApprovedLawyer[MAX_PLAYERS];
new CallLawyer[MAX_PLAYERS];
new WantLawyer[MAX_PLAYERS];
new AppealOffer[MAX_PLAYERS];
new AppealOfferAccepted[MAX_PLAYERS];
new CurrentMoney[MAX_PLAYERS];
new CP[MAX_PLAYERS];
new Condom[MAX_PLAYERS];
new SexOffer[MAX_PLAYERS];
new SexPrice[MAX_PLAYERS];
new RepairOffer[MAX_PLAYERS];
new RepairPrice[MAX_PLAYERS];
new RefillOffer[MAX_PLAYERS];
new RefillPrice[MAX_PLAYERS];
new RepairCar[MAX_PLAYERS];
new GunOffer[MAX_PLAYERS];
new GunStorageID[MAX_PLAYERS];
new GunId[MAX_PLAYERS];
new GunMats[MAX_PLAYERS];
new CraftOffer[MAX_PLAYERS];
new CraftId[MAX_PLAYERS];
new CraftMats[MAX_PLAYERS];
new CraftName[MAX_PLAYERS][50];
new HitOffer[MAX_PLAYERS];
new HitToGet[MAX_PLAYERS];
new hInviteOffer[MAX_PLAYERS];
new hInviteHouse[MAX_PLAYERS];
new hInviteOfferTo[MAX_PLAYERS];
new InviteOffer[MAX_PLAYERS];
new MatsOffer[MAX_PLAYERS];
new MatsStorageID[MAX_PLAYERS];
new MatsPrice[MAX_PLAYERS];
new MatsAmount[MAX_PLAYERS];
new PotOffer[MAX_PLAYERS];
new PotStorageID[MAX_PLAYERS];
new PotPrice[MAX_PLAYERS];
new PotGram[MAX_PLAYERS];
new CrackOffer[MAX_PLAYERS];
new CrackStorageID[MAX_PLAYERS];
new CrackPrice[MAX_PLAYERS];
new CrackGram[MAX_PLAYERS];
new DrinkOffer[MAX_PLAYERS];
new VehicleOffer[MAX_PLAYERS];
new VehicleId[MAX_PLAYERS];
new VehiclePrice[MAX_PLAYERS];
new HouseOffer[MAX_PLAYERS];
new House[MAX_PLAYERS];
new HousePrice[MAX_PLAYERS];
new gPlayerCheckpointStatus[MAX_PLAYERS];
new gPlayerLogged[MAX_PLAYERS char];
new gPlayerLogTries[MAX_PLAYERS];
new gLastCar[MAX_PLAYERS];
new gOoc[MAX_PLAYERS];
new gNews[MAX_PLAYERS];
new Spectate[MAX_PLAYERS];
new GettingSpectated[MAX_PLAYERS];
new SpecTime[MAX_PLAYERS];
new CellTime[MAX_PLAYERS];
new StartTime[MAX_PLAYERS];
new HireCar[MAX_PLAYERS];
new HidePM[MAX_PLAYERS];
new PhoneOnline[MAX_PLAYERS];
new advisorchat[MAX_PLAYERS];
new FirstSpawn[MAX_PLAYERS];
new JetPack[MAX_PLAYERS];
new Fixr[MAX_PLAYERS];
new VehicleSpawned[MAX_PLAYERS];
new ShotPlayer[MAX_PLAYERS][MAX_PLAYERS];
new LastShot[MAX_PLAYERS];
new unbanip[MAX_PLAYERS][16];
new GarbageVehicles[8];
new TruckerVehicles[37];
new PizzaVehicles[23];
new VIPVehicles[50];
new FamedVehicles[39];
new Homes[MAX_PLAYERS];
new Locator[MAX_PLAYERS];
new Mobile[MAX_PLAYERS];
new RingTone[MAX_PLAYERS];
new CallCost[MAX_PLAYERS];
new LockStatus[MAX_VEHICLES char];
new arr_Engine[MAX_VEHICLES char];
new arr_Towing[MAX_PLAYERS];
new WheelClamp[MAX_VEHICLES char];

new
	g_arrQueryHandle[MAX_PLAYERS char],
	bool:IsPlayerEntering[ MAX_PLAYERS char ];

new iAdverTimer = 0;
new gBike[MAX_PLAYERS];
new gBikeRenting[MAX_PLAYERS];
new ReportCount[MAX_PLAYERS];
new ReportHourCount[MAX_PLAYERS];
new WDReportCount[MAX_PLAYERS];
new WDReportHourCount[MAX_PLAYERS];
new noooc = 1;
new rflstatus = 0;
new GlobalMOTD[128];
new AdminMOTD[128];
new VIPMOTD[128];
new CAMOTD[128];
new pMOTD[256];
new gMOTD[MAX_GROUPS][3][GROUP_MAX_MOTD_LEN];
new prisonerMOTD[3][GROUP_MAX_MOTD_LEN];
new Float:ShopTechPay;
new TotalCitizens;
new TRCitizens;
//new PlayerNationSelection[MAX_PLAYERS];
//new PlayerHasNationSelected[MAX_PLAYERS];
/* new Text:txtNationSelHelper;
new Text:txtNationSelMain;
new Text:txtSanAndreas;
new Text:txtTierraRobada; */
new ghour = 0;
new gminute = 0;
new gsecond = 0;
new shifthour;
new EventTimerHandle;
new cage;
new entrancedoor;
new Purification[2];
new logincheck[MAX_PLAYERS];
new AlertTime[MAX_PLAYERS];
new PublicSQLString[4096]; // cuz the mysql plugin is stupid a/f
new FetchingWatchlist;
new PlayerText:AccountRestriction[MAX_PLAYERS];
new PlayerText:AccountRestrictionEx[MAX_PLAYERS];

new CIV[] = {7,19,20,23,73,101,122};
new STD1[] = {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3};
new STD2[] = {0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3};
new STD3[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3};
new STD4[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3};
new Float:PlayerPos[MAX_PLAYERS][3];
new lspddoor1;
new lspddoor2;
new Seatbelt[MAX_PLAYERS];
new Float:fHMASafe_Loc[3];
new iHMASafe_Val = 0;
new HMAMOTD[64];
new File:HMAFile, iFileLoaded = 0;
new SpikeStrips[MAX_GROUPS][MAX_SPIKES][Spikes];
new Cones[MAX_GROUPS][MAX_CONES][Cone];
new Flares[MAX_GROUPS][MAX_FLARES][Flare];
new Barricades[MAX_GROUPS][MAX_BARRICADES][Barricade];
new Barrels[MAX_GROUPS][MAX_BARRELS][Barrel];
new Ladders[MAX_GROUPS][MAX_LADDERS][Ladder];
new Signs[MAX_GROUPS][MAX_SIGNS][Sign];
new Tapes[MAX_TAPES][Tape];
new Auctions[MAX_AUCTIONS][Auction];
new BusinessSales[MAX_BUSINESSSALES][BusinessSale];
new Reports[MAX_REPORTS][reportinfo];
new Calls[MAX_CALLS][callinfo];
new ListItemReportId[MAX_PLAYERS][40];
new CancelReport[MAX_PLAYERS];
new Music[MAX_PLAYERS];
new Float: pSpeed[MAX_PLAYERS];
new HackingMods[MAX_PLAYERS];
new rBigEarT[MAX_PLAYERS];
new aLastShot[MAX_PLAYERS];
new aLastShotBone[MAX_PLAYERS];
new aLastShotWeapon[MAX_PLAYERS];
new IsSpawned[MAX_PLAYERS];
new SpawnKick[MAX_PLAYERS];

// Tradable Toys
new InsideTradeToys[MAX_PLAYERS], PlayerText: ttBackground[MAX_PLAYERS], PlayerText: ttModel[MAX_PLAYERS], PlayerText: ttObjectInfo[MAX_PLAYERS], PlayerText: ttLogo[MAX_PLAYERS], PlayerText: ttPurchase[MAX_PLAYERS],
	PlayerText: ttDecline[MAX_PLAYERS], PlayerText: ttOffer[MAX_PLAYERS], PlayerText: ttNote[MAX_PLAYERS], PlayerText: ttYes[MAX_PLAYERS], PlayerText: ttNo[MAX_PLAYERS];

// Hunger games stuff
new HungerPlayerInfo[MAX_PLAYERS][HUNGER_PLAYER_INFO];
new HungerBackpackInfo[601][HUNGER_BACKPACK_INFO];
new hgPlayerCount,
	hgCountdown,
	hgBackpackCount,
	hgActive;

SSCANF:storeitem(string[])
{
	if (!strcmp(string, "cellphone", true)) return ITEM_CELLPHONE;
	if (!strcmp(string, "phonebook", true)) return ITEM_PHONEBOOK;
	if (!strcmp(string, "dice", true)) return ITEM_DICE;
	if (!strcmp(string, "condom", true)) return ITEM_CONDOM;
	if (!strcmp(string, "musicplayer", true)) return ITEM_MUSICPLAYER;
	if (!strcmp(string, "rope", true)) return ITEM_ROPE;
	if (!strcmp(string, "cigar", true)) return ITEM_CIGAR;
	if (!strcmp(string, "sprunk", true)) return ITEM_SPRUNK;
	if (!strcmp(string, "lock", true)) return ITEM_VEHICLELOCK;
	if (!strcmp(string, "spraycan", true)) return ITEM_SPRAYCAN;
	if (!strcmp(string, "radio", true)) return ITEM_RADIO;
	if (!strcmp(string, "camera", true)) return ITEM_CAMERA;
	if (!strcmp(string, "lotteryticket", true)) return ITEM_LOTTERYTICKET;
	if (!strcmp(string, "checkbook", true)) return ITEM_CHECKBOOK;
	if (!strcmp(string, "paper", true)) return ITEM_PAPERS;
	if (!strcmp(string, "industriallock", true)) return ITEM_ILOCK;
	if (!strcmp(string, "elock", true)) return ITEM_ELOCK;
	if (!strcmp(string, "standardcaralarm", true)) return ITEM_SCALARM;
	if (!strcmp(string, "helmet", true)) return ITEM_HELMET;
	return INVALID_STORE_ITEM;
}

SSCANF:sweapon(string[])
{
	if (!strcmp(string, "knuckles", true)) return WEAPON_BRASSKNUCKLE;
	if (!strcmp(string, "bat", true)) return WEAPON_BAT;
	if (!strcmp(string, "shovel", true)) return WEAPON_SHOVEL;
	if (!strcmp(string, "katana", true)) return WEAPON_KATANA;
	if (!strcmp(string, "sdpistol", true)) return WEAPON_SILENCED;
	if (!strcmp(string, "9mm", true)) return WEAPON_COLT45;
	if (!strcmp(string, "shotgun", true)) return WEAPON_SHOTGUN;
	if (!strcmp(string, "mp5", true)) return WEAPON_MP5;
	if (!strcmp(string, "rifle", true)) return WEAPON_RIFLE;
	if (!strcmp(string, "deagle", true)) return WEAPON_DEAGLE;
	return -1;
}

new Songs[7][1] = {
{1187},
{1185},
{1183},
{1097},
{1076},
{1068},
{1062}
};

/*new FishNames[22][20] = {
{"Jacket"}, {"Amberjack"}, {"Grouper"},
{"Red Snapper"}, {"Pants"}, {"Trout"},
{"Blue Marlin"}, {"Can"}, {"Mackeral"},
{"Sea Bass"}, {"Shoes"}, {"Pike"},
{"Sail Fish"}, {"Garbage"}, {"Tuna"},
{"Eel"}, {"Dolphin"}, {"Shark"},
{"Turtle"}, {"Catfish"}, {"Money Bag"},
{"Swordfish"}
};*/

/*new Float:DocPrison[12][3] = {
{-2081.1941,-188.6734,991.536},
{-2075.0042,-188.3738,991.5364},
{-2069.1348,-188.3445,991.5364},
{-2062.9697,-188.8881,991.5364},
{-2057.2039,-189.1190,991.5364},
{-2051.4260,-188.8504,991.5364},
{-2057.0588,-209.8594,991.5364},
{-2062.7124,-210.4578,991.5364},
{-2068.8271,-210.3926,991.5364},
{-2074.9646,-210.1767,991.5364},
{-2080.8003,-210.1505,991.5364},
{-2086.3982,-209.9947,991.5364}
};*/

new Float:DocPrison[31][3] = {
{566.6217,1443.9063,6000.4712},
{563.4141,1443.9242,6000.4712},
{559.0266,1444.2406,6000.4712},
{555.1960,1444.0137,6000.4712},
{552.1860,1444.0975,6000.4712},
{547.9967,1444.0000,6000.4712},
{544.1797,1444.0023,6000.4712},
{540.1984,1447.7440,6000.4712},
{540.9143,1450.7118,6000.4712},
{540.6180,1454.5797,6000.4712},
{540.9262,1458.6176,6000.4712},
{543.5959,1463.9739,6000.4712},
{547.4905,1464.4880,6000.4712},
{550.9981,1464.4159,6000.4712},
{556.9213,1464.2755,6000.4712},
{560.2768,1465.3188,6000.4712},
{557.8386,1464.3350,6004.3984},
{550.2856,1464.7531,6004.3984},
{547.6868,1465.1648,6004.3984},
{543.0347,1464.5404,6004.3784},
{540.6564,1458.0435,6004.3784},
{540.8395,1454.0175,6004.3784},
{541.1672,1450.7792,6004.3784},
{540.0593,1446.8673,6004.3784},
{544.9167,1443.7372,6004.3784},
{548.1307,1444.8217,6004.3784},
{551.9464,1443.7279,6004.3784},
{555.7839,1443.8726,6004.3784},
{558.9515,1444.0236,6004.3784},
{563.0129,1444.1816,6004.3784},
{567.4249,1443.5105,6004.3784}
};

new Float:DocIsolation[6][3] = {
{496.9142,1445.5503,11000.4756},
{497.0593,1448.7583,11000.4756},
{496.8056,1451.7898,11000.4756},
{496.6227,1455.1790,11000.4756},
{496.6559,1458.2590,11000.4756},
{496.8119,1461.6667,11000.4756}
};

new DocCellsFloor1[16];
new DocCellsFloor2[15];
new DocCellRoomDoors[19];

new bool:bDocCellOpen[31] = false;
new bool:bDocAreaOpen[19] = false;
new bool:bDocCellsFloorOpen[2] = false;
new bool:bDocLockdown = false;
new arrJailBoxingData[MAX_JAIL_BOXINGS][eJailBoxing];

/*new Float:JailBoxingPos[MAX_JAIL_BOXINGS][3] = {
{571.4730,1414.6787,6000.8008},
{571.0892,1406.3739,6000.8008},
{558.7887,1424.7054,6000.8008},
{-2040.8381,-233.3212,36.2392},
{-2061.5261,-234.1297,36.2392}
};*/

new Float:JailPhonePos[5][3] = {
{551.50531, 1423.10657, 6000.12012},
{547.87653, 1423.10657, 6000.12012},
{545.87531, 1425.07288, 6000.12012},
{547.10773, 1428.93091, 6000.12012},
{549.79559, 1428.93091, 6000.12012}
};

new bool:bJailPhoneUse[5] = false;

new Float:DMVRelease[4][3] = {
{850.336,-583.911,18.250},
{854.729,-583.911,18.250},
{859.060,-583.911,18.250},
{863.397,-583.911,18.250}
};

/*new Float:DMVReleaseNE[4][3] = {
{2540.4819, 118.9792, 26.5442},
{2537.6643, 118.7770, 26.5442},
{2534.5337, 118.5479, 26.5442},
{2540.8123, 104.9197, 26.5442}
};*/


/*new Float:LSPDJail[4][3] = {
{227.46, 110.0, 999.02},
{223.15, 110.0, 999.02},
{219.25, 110.0, 999.02},
{216.39, 110.0, 999.02}
}; */
new Float:WarrantJail[1][3] = {
{1496.8030,-1547.1371,1127.0251}
};
/*new Float:ICPrisonSpawns[3][3] = {
{-284.5741,1871.2554,29.8929},
{-292.8077,1871.3717,29.8929},
{-302.5636,1871.3998,29.8929}
}; */

/*new Float:OOCPrisonSpawns[3][3] = {
{-304.4369,1894.9891,29.8929},
{-295.9042,1894.9121,29.8929},
{-287.1133,1894.6259,29.8929}
};*/
new Float:OOCPrisonSpawns[20][3] = {
{-1169.8495,2907.1541,9993.1318},
{-1161.5973,2907.2935,9993.1318},
{-1152.9495,2907.0779,9993.1318},
{-1144.9945,2907.3643,9993.1318},
{-1139.0138,2901.8857,9993.1318},
{-1138.8224,2892.6199,9993.1318},
{-1142.2539,2883.1189,9993.1318},
{-1152.5369,2883.5552,9993.1318},
{-1161.8630,2883.5474,9993.1318},
{-1170.9556,2883.6836,9993.1318},
{-1170.3447,2907.0898,9997.2959},
{-1161.5493,2907.2043,9997.2959},
{-1153.7791,2907.1799,9997.2959},
{-1146.1752,2907.0950,9997.2959},
{-1139.0394,2902.7466,9997.2959},
{-1139.5280,2894.2209,9997.2959},
{-1143.3251,2883.4856,9997.2959},
{-1152.4774,2883.0095,9997.2959},
{-1160.3843,2883.4739,9997.2959},
{-1168.4708,2883.1897,9997.2959}
};

// X, Y, Z, Angle
/*new Float:LSPDJailSpawns[8][4] = {
	{1501.5892, -1759.7926, 3285.2859, 181.9316},
	{1501.6854, -1766.9313, 3285.2859, 2.5386},
	{1498.8138, -1767.2649, 3285.2859, 5.0662},
	{1498.3621, -1759.1687, 3285.2859, 180.1585},
	{1495.4730, -1766.7284, 3285.2859, 1.8493},
	{1495.0603, -1759.2269, 3285.2859, 176.2523},
	{1492.2045, -1767.4205, 3285.2859, 356.3346},
	{1491.8857, -1759.5046, 3285.2859, 188.8902}
};*/

new Titel[pBoxingStats];


new EventKernel[EventKernelEnum];

new EventRCPU[20]; // Value to know if rcp is being used
new Float:EventRCPX[20]; // Value for the x position of the RCP
new Float:EventRCPY[20]; // Value for the y position of the RCP
new Float:EventRCPZ[20]; // Value for the z position of the RCP
new Float:EventRCPS[20]; // RCP Size
new EventRCPT[20]; // RCP Type
new PaintBallArena[MAX_ARENAS][PaintBallArenaEnum];
new TurfWars[MAX_TURFS][TurfWarsEnum];
new Points[MAX_POINTS][fPoint];
new Fishes[MAX_PLAYERS][pFishing];
new News[hNews];
new StorageInfo[MAX_PLAYERS][3][sInfo];
new PlayerInfo[MAX_PLAYERS][pInfo];
new PlayerVehicleInfo[MAX_PLAYERS][MAX_PLAYERVEHICLES][pvInfo];
new PlayerToyInfo[MAX_PLAYERS][MAX_PLAYERTOYS][ptInfo];
new HouseInfo[MAX_HOUSES][hInfo];
new DMPInfo[MAX_DMAPICONS][dmpInfo];
new DDoorsInfo[MAX_DDOORS][ddInfo];
new GateInfo[MAX_GATES][gInfo];
new SpeedCameras[MAX_SPEEDCAMERAS][_scInfoEnum];
new EventPoints[MAX_EVENTPOINTS][ePoints];
//new PlayerCrime[MAX_PLAYERS][pCrime];
new MailBoxes[MAX_MAILBOXES][mbInfo];
new TxtLabels[MAX_3DLABELS][tlInfo];
new PayNSprays[MAX_PAYNSPRAYS][pnsInfo];
new ArrestPoints[MAX_ARRESTPOINTS][arrestInfo];
new ImpoundPoints[MAX_IMPOUNDPOINTS][impoundInfo];
new RFLInfo[MAX_RFLTEAMS][rflinfo];
//new HelpInfo[TOTAL_COMMANDS][cmdInfo];
//new GangTags[MAX_GANGTAGS][GANG_TAG_INFO];
new fireworktog = 1;

/*new Polls[MAX_POLLS][PollData];
new PollChoices[MAX_POLLS_CHOICES][255];*/

// Vehicle Lock Pick Timer Textdraw
new PlayerText:VLPTextDraws[MAX_PLAYERS][4];

new PlayerText:ShopNotice[MAX_PLAYERS];
new PlayerText:MicroNotice[MAX_PLAYERS];
new ShopReminder = 1;
new NGGShop;
new Float:shop_vertices[] = {
	2905.0,-1588.0,
	2999.0,-1606.0,
	2998.0,-1264.0,
	2999.0,-1113.0,
	2894.0,-1118.0,
	2895.0,-1175.0,
	2926.0,-1359.0,
	2933.0,-1439.0,
	2929.0,-1490.0,
	2905.0,-1588.0
};
new restarting;
new PassComplexCheck;
new PlayerShots[MAX_PLAYERS];
new PlayerSniperShots[MAX_PLAYERS];
new PlayerKills[MAX_PLAYERS];
new GarageInfo[MAX_GARAGES][garInfo];
#define MicroSpecifier "p<|>e<dddddddddddddddddddd>"
new MicroItems[MAX_MICROITEMS],
	AmountSoldMicro[MAX_MICROITEMS],
	AmountMadeMicro[MAX_MICROITEMS];
new mItemName[MAX_MICROITEMS][] = {
	{"Job Change"},
	{"Job Boost"},
	{"Buddy Invites Reset"},
	{"Buddy Invite Extension"},
	{"Energy Bars"},
	{"Gift Reset Voucher"},
	{"House Sale Sign"},
	{"Fuel Canister"},
	{"Jump Start"},
	{"Restricted Car Colors"},
	{"Priority Ads"},
	{"Number Change (TODO)"},
	{"Quick Bank Access"},
	{"Restricted Skin Voucher"},
	{"Dynamic Door Move"},
	{"Dynamic Door Interior Change"},
	{"Scrap Metal"},
	{"x15 .50 Caliber Ammo (Sniper/Rifle)"},
	{"Antibiotic Injection"},
	{"Survivor Kits"}
};
/*new ShopMsg[11][] = {
	{"Need to get a job quick?~n~Get a Job Change to change your job instantly!~n~~b~~h~~h~/microshop"},
	{"Do you want the level 5 perks of your job right now?~n~Purchase a Job Boost!~n~~b~~h~~h~/microshop"},
	{"Want to make your car stand out?~n~Get a restricted car color without being a VIP member!~n~~b~~h~~h~/microshop"},
	{"Want to get a restricted skin you couldn't otherwise have?~n~Purchase a Restricted Skin Voucher to do just that!~n~~b~~h~~h~/microshop"},
	{"Your buddy invite is going to run out soon!~n~Want to extend the time? Get a Buddy Invite Extension!~n~~b~~h~~h~/microshop"},
	{"Are you super hungry?~n~Eat an Energy Bar to tie you over until your next meal!~n~~b~~h~~h~/microshop"},
	{"Selling your house?~n~Get a For Sale sign for your front yard!~n~~b~~h~~h~/microshop"},
	{"Stranded without gasoline?~n~Purchase a fuel can to get going again!~n~~b~~h~~h~/microshop"},
	{"Engine won't start?~n~Get a Jump Start to get moving again!~n~~b~~h~~h~/microshop"},
	{"Trying to move a large sum of money?~n~Don't want to be taxed? Get a Quick Bank Access pass!~n~~b~~h~~h~/microshop"},
	{"You're not exercising to your full potential!~n~Try an energy bar!~n~~b~~h~~h~/microshop"}
};*/

// Fall Into Fun
new FIFInfo[MAX_PLAYERS][FallIntoFun],
	FIFType = 1,
	FIFGP3,
	FIFEnabled,
	FIFTimeWarrior,
	Float:FIFGamble[3],
	FIFPickup,
	Text3D:FIFText,
	FIFGThurs,
	GThursChances;

new freeweekend,
	nonvipcredits;

new PlayerHoldingObject[MAX_PLAYERS][10];

new turfWarsRadar[MAX_PLAYERS] = 0;
new turfWarsMiniMap[MAX_PLAYERS] = 0;

// Dynamic Gift Box Stuff
new dgVar[dgItems][4];
new dgAmount, dgTimer = -1, dgTimerTime, dgGoldToken;
new bool: IsDynamicGiftBoxEnabled = false;

/*
new arrFires[MAX_STRUCTURE_FIRES][eStructureFires];
new iServerFires = 0;
*/

new HoldingObjectsShop[][HoldingEnumAll] = {
{18647,0,	"RedNeonTube1"},
{18648,0,	"BlueNeonTube1"},
{18649,0,	"GreenNeonTube1"},
{18650,0,	"YellowNeonTube1"},
{18651,0,	"PinkNeonTube1"},
{18652,0,	"WhiteNeonTube1"},
{365,0, 	"Spray Can"},
{368,0, 	"Nightvision Googles"},
{373,0, 	"Armour model"},
{371,0, 	"Parachute"},
{1486,0,	"Beer Bottle"},
{1575,0, 	"white sack of cocaine"},
{1212,0, 	"money packet"},
{348, 0, 	"deagle toy"},
{349, 0, 	"shotgun toy"},
{352, 0, 	"uzi toy"},
{353, 0, 	"mp5 toy"},
{343, 0, 	"teargas grenade"},
{326, 0, 	"cane"},
{325, 0, 	"flowers"},
{355, 0, 	"AK47 toy"},
{371, 0, 	"parachute bag"},
{1484, 0, 	"beer bottle"},
{3028, 0, 	"sword"},
{1279, 0, 	"drug bundle"},
{3027, 0, 	"weed"},
{2114, 0, 	"basketball"},
{19348, 0, 	"cane"},
{19349, 0, 	"monocle"},
{19350, 0, 	"moustache1"},
{19469, 0, 	"scarf"},
{19472, 0, 	"gasmask"},
{19352, 0, 	"Top hat 01"},
{19487,0, 	"tophat02"},
{351,0, "Combat Shotgun"},
{335,0, "Combat Knife"},
{356,0, "M4 Assault Rifle"},
{373,0, "Armour Model"},
{1550,0,"sack of money"},
{1212,0,"money packet"},
{19347,0, "Badge01"},
{19418,0, "Handcuffs01"},
{19514,0, "SWATHgrey"},
{19515,0, "SWATAgrey"},
{19161,0, "PoliceHat1"},
{19162,0, "PoliceHat2"},
{18636,0, "PoliceCap1"},
{19099,0, "PoliceCap2"},
{19100,0, "PoliceCap3"},
{18642,0, "Taser1"},
{18637,0, "Police Shield"},
{355,0, "AK47"},
{358,0, "Sniper Rifle"},
{366,0, "Fire Extinguisher"},
{334,0, "Nightstick"},
{3026, 0, "Purple Backpack"},
{19421, 0, "White Headphones"},
{19422, 0, "Black Headphones"},
{19423, 0, "Red Headphones"},
{19424, 0, "Blue Headphones"},
{19351, 0, "moustache2"},
{19520, 0, "pilotHat01"},
{19521, 0, "policehat01"},
{19516, 0, "Hair1_nc"},
{19517, 0, "Hair2_nc"},
{19518, 0, "Hair3_nc"},
{19519, 0, "Hair5_nc"},
{19488, 0, "HatBowler6"},
{19308, 0, "Taxi01"},
{19309, 0, "Taxi02"},
{19310, 0, "Taxi03"},
{19311, 0, "Taxi04"},
{2590, 0, "Scythe"},
{347, 0, "Silenced Pistol"},
{19330, 0, "Fire Hat01"},
{19331, 0, "Fire Hat02"},
{336, 0, "Baseball Bat"},
{341, 0, "Chainsaw"},
{2035, 0, "Rusty M4"},
{1000, 0, "Spoiler1"},
{1001, 0, "Spoiler2"},
{1002, 0, "Spoiler3"},
{2036, 0, "Rusty Sniper Rifle"},
{2044, 0, "Rusty MP5"},
{367, 0, "Camera"},
{1543, 0, "Pissh Beer Bottle"},
{1544, 0, "Revolver Beer Bottle"},
{19558, 0, "Pizza Hat"},
{19559, 0, "Hiker Backpack"},
{19773, 0, "Gun Holster"},
{19878, 0, "Skateboard"}
};

new HoldingObjectsCop[20][HoldingEnumAll] = { 
{18642,1000,"Taser1"},
{19141,2500,"SWATHelmet1"},
{19142,2500,"SWATArmour1"},
{18636,1000,"PoliceCap1"},
{19099,1000,"PoliceCap2"},
{19100,1000,"PoliceCap3"},
{18637,1000,"PoliceShield1"},
{19161,1000,"PoliceHat1"},
{19162,1000,"PoliceHat2"},
{19200,1000,"PoliceHelmet1"},
{19138,1000,"PoliceGlasses1"},
{19139,1000,"PoliceGlasses2"},
{19140,1000,"PoliceGlasses3"},
{19904,1000,"OrangeVest"},
{19776,1000,"FBICard"},
{19773,1000,"Holster"},
{19347,1000,"SheriffBadge"},
{19942,1000,"Radio"},
{18641,1000,"Flashlight"},
{11749,1000,"Handcuffs"}
};

new HoldingObjectsAll[][HoldingEnumAll] = {
{18642,1000,"Taser1"},
{18643,10000,"LaserPointer1"},
{19080,10000,"LaserPointer2"},
{19081,10000,"LaserPointer3"},
{19082,10000,"LaserPointer4"},
{19083,10000,"LaserPointer5"},
{19084,10000,"LaserPointer6"},
{19086,5000,"ChainsawDildo1"},
{18675,10000,"SmokePuff"},
{19701,10000,"SmallFlame"},
{18693,10000,"LargeFlame"},
{18698,10000,"Insects"},
{18708,10000,"Bubbles"},
{19141,2500,"SWATHelmet1"},
{19142,2500,"SWATArmour1"},
{18636,1000,"PoliceCap1"},
{19099,1000,"PoliceCap2"},
{19100,1000,"PoliceCap3"},
{18637,1000,"PoliceShield1"},
{19161,1000,"PoliceHat1"},
{19162,1000,"PoliceHat2"},
{19200,1000,"PoliceHelmet1"},
{19138,1000,"PoliceGlasses1"},
{19139,1000,"PoliceGlasses2"},
{19140,1000,"PoliceGlasses3"},
{18632,1000,"FishingRod"},
{18633,1500,"Wrench"},
{18634,1000,"Crowbar"},
{18635,1000,"Hammer"},
{18638,500,"HardHat"},
{19093,500,"HardHat2"},
{19160,500,"HardHat3"},
{18639,500,"BlackHat"},
{19317,1000,"Bass Guitar"},
{19318,1000,"FlyingV Guitar"},
{19319,1000,"Warlock Guitar"},
{18640,700,"Hair"},
{18975,700,"Hair2"},
{19136,700,"Hair3"},
{19274,700,"Hair4"},
{18641,1000,"Flashlight"},
{18644,5000,"Screwdriver"},
{18865,500,"MobilePhone1"},
{18866,500,"MobilePhone2"},
{18867,500,"MobilePhone3"},
{18868,500,"MobilePhone4"},
{18869,500,"MobilePhone5"},
{18870,1000,"MobilePhone6"},
{18871,1000,"MobilePhone7"},
{18872,1000,"MobilePhone8"},
{18873,1000,"MobilePhone9"},
{18874,1000,"MobilePhone10"},
{18875,750,"Pager"},
{18890,500,"Rake"},
{18891,500,"Bandana1"},
{18892,500,"Bandana2"},
{18893,500,"Bandana3"},
{18894,500,"Bandana4"},
{18895,500,"Bandana5"},
{18896,500,"Bandana6"},
{18897,500,"Bandana7"},
{18898,500,"Bandana8"},
{18899,500,"Bandana9"},
{18900,500,"Bandana10"},
{18901,750,"Bandana11"},
{18902,750,"Bandana12"},
{18903,750,"Bandana13"},
{18904,750,"Bandana14"},
{18905,750,"Bandana15"},
{18906,750,"Bandana16"},
{18907,750,"Bandana17"},
{18908,750,"Bandana18"},
{18909,750,"Bandana19"},
{18910,750,"Bandana20"},
{18911,1000,"Mask1"},
{18912,1000,"Mask2"},
{18913,1000,"Mask3"},
{18914,1000,"Mask4"},
{18915,1000,"Mask5"},
{18916,1000,"Mask6"},
{18917,1000,"Mask7"},
{18918,1000,"Mask8"},
{18919,1000,"Mask9"},
{18920,1000,"Mask10"},
{18921,500,"Beret1"},
{18922,500,"Beret2"},
{18923,750,"Beret3"},
{18924,1000,"Beret4"},
{18925,1000,"Beret5"},
{18926,500,"Hat1"},
{18927,500,"Hat2"},
{18928,500,"Hat3"},
{18929,500,"Hat4"},
{18930,500,"Hat5"},
{18931,1000,"Hat6"},
{18932,1000,"Hat7"},
{18933,1000,"Hat8"},
{18934,1000,"Hat9"},
{18935,1000,"Hat10"},
{18936,500,"Helmet1"},
{18937,750,"Helmet2"},
{18938,1000,"Helmet3"},
{18939,750,"CapBack1"},
{18940,750,"CapBack2"},
{18941,750,"CapBack3"},
{18942,1000,"CapBack4"},
{18943,1000,"CapBack5"},
{18944,1000,"HatBoater1"},
{18945,1250,"HatBoater2"},
{18946,1500,"HatBoater3"},
{18947,1000,"HatBowler1"},
{18948,1000,"HatBowler2"},
{18949,1000,"HatBowler3"},
{18950,1000,"HatBowler4"},
{18951,1000,"HatBowler5"},
{18952,1500,"BoxingHelmet"},
{18953,500,"CapKnit1"},
{18954,750,"CapKnit2"},
{18955,750,"CapOverEye1"},
{18956,750,"CapOverEye2"},
{18957,750,"CapOverEye3"},
{18958,750,"CapOverEye4"},
{18959,750,"CapOverEye5"},
{18960,1000,"CapRimUp1"},
{18961,750,"CapTrucker1"},
{18962,750,"CowboyHat2"},
{18964,1000,"SkullyCap1"},
{18965,1250,"SkullyCap2"},
{18966,1500,"SkullyCap3"},
{18967,1000,"HatMan1"},
{18968,1000,"HatMan2"},
{18969,1000,"HatMan3"},
{18970,2000,"HatTiger"},
{18971,1000,"HatCool1"},
{18972,1250,"HatCool2"},
{18973,1500,"HatCool3"},
{18974,10000,"MaskZorro1"},
{18645,1500,"MotorcycleHelmet"},
{18976,1000,"MotorcycleHelmet2"},
{18977,1000,"MotorcycleHelmet3"},
{18978,1250,"MotorcycleHelmet4"},
{18979,1500,"MotorcycleHelmet5"},
{19006,500,"GlassesType1"},
{19007,500,"GlassesType2"},
{19008,500,"GlassesType3"},
{19009,500,"GlassesType4"},
{19010,500,"GlassesType5"},
{19011,500,"GlassesType6"},
{19012,500,"GlassesType7"},
{19013,500,"GlassesType8"},
{19014,500,"GlassesType9"},
{19015,500,"GlassesType10"},
{19016,1000,"GlassesType11"},
{19017,1000,"GlassesType12"},
{19018,1000,"GlassesType13"},
{19019,1000,"GlassesType14"},
{19020,1000,"GlassesType15"},
{19021,1000,"GlassesType16"},
{19022,1000,"GlassesType17"},
{19023,1000,"GlassesType18"},
{19024,1000,"GlassesType19"},
{19025,1000,"GlassesType20"},
{19026,1500,"GlassesType21"},
{19027,1500,"GlassesType22"},
{19028,1500,"GlassesType23"},
{19029,1500,"GlassesType24"},
{19030,1500,"GlassesType25"},
{19031,1500,"GlassesType26"},
{19032,1500,"GlassesType27"},
{19033,1500,"GlassesType28"},
{19034,1500,"GlassesType29"},
{19035,1500,"GlassesType30"},
{19036,2000,"HockeyMask1"},
{19037,2000,"HockeyMask2"},
{19038,2000,"HockeyMask3"},
{19039,500,"WatchType1"},
{19040,500,"WatchType2"},
{19041,500,"WatchType3"},
{19042,500,"WatchType4"},
{19043,500,"WatchType5"},
{19044,500,"WatchType6"},
{19045,500,"WatchType7"},
{19046,1000,"WatchType8"},
{19047,1000,"WatchType9"},
{19048,1000,"WatchType10"},
{19049,1000,"WatchType11"},
{19050,1000,"WatchType12"},
{19051,1000,"WatchType13"},
{19052,1000,"WatchType14"},
{19053,1000,"WatchType15"},
{19064,10000, "SantaHat1"},
{19065,20000, "SantaHat2"},
{19066,30000, "SantaHat3"},
{19067,1000, "HoodyHat1"},
{19068,1000, "HoodyHat2"},
{19069,1000, "HoodyHat3"},
{19078,7500, "TheParrot1"},
{19079,7500, "TheParrot2"},
{19085,5000, "EyePatch"},
{19090,1500, "PomPomBlue"},
{19091,1500, "PomPomRed"},
{19092,1500, "PomPomGreen"},
{19094,2000, "BurgerShotHat"},
{19095,500, "CowboyHat1"},
{19096,500, "CowboyHat3"},
{19097,1000, "CowboyHat4"},
{19098,1000, "CowboyHat5"},
{19101,2000, "ArmyHelmet1"},
{19102,2000, "ArmyHelmet2"},
{19103,2000, "ArmyHelmet3"},
{19104,2000, "ArmyHelmet4"},
{19105,2000, "ArmyHelmet5"},
{19106,2000, "ArmyHelmet6"},
{19107,4000, "ArmyHelmet7"},
{19108,4000, "ArmyHelmet8"},
{19109,4000, "ArmyHelmet9"},
{19110,4000, "ArmyHelmet10"},
{19111,4000, "ArmyHelmet11"},
{19112,4000, "ArmyHelmet12"},
{19113,1000, "SillyHelmet1"},
{19114,2000, "SillyHelmet2"},
{19115,3000, "SillyHelmet3"},
{19116,500, "PlainHelmet1"},
{19117,500, "PlainHelmet2"},
{19118,750, "PlainHelmet3"},
{19119,1000, "PlainHelmet4"},
{19120,1000, "PlainHelmet5"},
{19137,5000, "CluckinBellHat"},
{19163,1000, "GimpMask"},
{1210,500, "Briefcase"},
{18647,0,	"RedNeonTube1"},
{18648,0,	"BlueNeonTube1"},
{18649,0,	"GreenNeonTube1"},
{18650,0,	"YellowNeonTube1"},
{18651,0,	"PinkNeonTube1"},
{18652,0,	"WhiteNeonTube1"},
{365,0, 	"Spray Can"},
{373,0, 	"Armour model"},
{371,0, 	"Parachute"},
{1486,0,	"Beer Bottle"},
{1575,0, 	"white sack of cocaine"},
{1212,0, 	"money packet"},
{348, 0, "deagle toy"},
{349, 0, "shotgun toy"},
{352, 0, "uzi toy"},
{353, 0, "mp5 toy"},
{343, 0, "teargas grenade"},
{326, 0, "cane"},
{325, 0, "flowers"},
{355, 0, "AK47 toy"},
{371, 0, "parachute bag"},
{1484, 0, "beer bottle"},
{3028, 0, "sword"},
{1279, 0, "drug bundle"},
{19348, 0, "cane"},
{19349, 0, "monocle"},
{19350, 0, "moustache1"},
{19469, 0, "scarf"},
{19472, 0, "gasmask"},
{19352, 0, "Top hat 01"},
{19487,0, "tophat02"},
{351,0, "Combat Shotgun"},
{335,0, "Combat Knife"},
{356,0, "M4 Assault Rifle"},
{373,0, "Armour Model"},
{1550,0,"sack of money"},
{1212,0,"money packet"},
{19347,0, "Badge01"},
{19418,0, "Handcuffs01"},
{19514,0, "SWATHgrey"},
{19515,0, "SWATAgrey"},
{19161,0, "PoliceHat1"},
{19162,0, "PoliceHat2"},
{18636,0, "PoliceCap1"},
{19099,0, "PoliceCap2"},
{19100,0, "PoliceCap3"},
{18642,0, "Taser1"},
{18637,0, "Police Shield"},
{355,0, "AK47"},
{358,0, "Sniper Rifle"},
{366,0, "Fire Extinguisher"},
{368,0, "Nightvision Goggles"},
{1485,0, "Weed"},
{2114,0, "Basketball"},
{334,0, "Nightstick"},
{3026, 0, "Purple Backpack"},
{19421, 0, "White Headphones"},
{19422, 0, "Black Headphones"},
{19423, 0, "Red Headphones"},
{19424, 0, "Blue Headphones"},
{11245, 0, "US Flag"},
{2614, 0, "US Flag 2"},
{2404, 0,"Surfboard1"},
{2405, 0,"Surfboard2"},
{2406, 0,"Surfboard3"},
{1598, 0,"Beachball"},
{19331, 0, "Firefigher Helmet"},
{2045, 0, "Spiked Club"},
{19320, 0, "Pumpkin Toy"},
{19351, 0, "moustache2"},
{19520, 0, "pilotHat01"},
{19521, 0, "policehat01"},
{19516, 0, "Hair1_nc"},
{19517, 0, "Hair2_nc"},
{19518, 0, "Hair3_nc"},
{19519, 0, "Hair5_nc"},
{19488, 0, "HatBowler6"},
{19308, 0, "Taxi01"},
{19309, 0, "Taxi02"},
{19310, 0, "Taxi03"},
{19311, 0, "Taxi04"},
{2590, 0, "Scythe"},
{347, 0, "Silenced Pistol"},
{19330, 0, "Fire Hat01"},
{19331, 0, "Fire Hat02"},
{336, 0, "Baseball Bat"},
{341, 0, "Chainsaw"},
{2035, 0, "Rusty M4"},
{1000, 0, "Spoiler1"},
{1001, 0, "Spoiler2"},
{1002, 0, "Spoiler3"},
{2036, 0, "Rusty Sniper Rifle"},
{2044, 0, "Rusty MP5"},
{367, 0, "Camera"},
{1543, 0, "Pissh Beer Bottle"},
{1544, 0, "Revolver Beer Bottle"},
{19558, 0, "Pizza Hat"},
{19559, 0, "Hiker Backpack"},
{19773, 0, "Gun Holster"},
{19878, 0, "Skateboard"},
{19904,1000,"OrangeVest"},
{19776,1000,"FBICard"},
{19773,1000,"Holster"},
{19347,1000,"SheriffBadge"},
{19942,1000,"Radio"},
{18641,1000,"Flashlight"},
{11749,1000,"Handcuffs"}
};

new HoldingObjects[206][HoldingEnum] = {
{18632,1000,"FishingRod"},
{18633,1500,"Wrench"},
{18634,1000,"Crowbar"},
{18635,1000,"Hammer"},
{18638,500,"HardHat"},
{19093,500,"HardHat2"},
{19160,500,"HardHat3"},
{18639,500,"BlackHat"},
{19317,1000,"Bass Guitar"},
{19318,1000,"FlyingV Guitar"},
{19319,1000,"Warlock Guitar"},
{18640,700,"Hair"},
{18975,700,"Hair2"},
{19136,700,"Hair3"},
{19274,700,"Hair4"},
{18641,1000,"Flashlight"},
{18644,5000,"Screwdriver"},
{18865,500,"MobilePhone1"},
{18866,500,"MobilePhone2"},
{18867,500,"MobilePhone3"},
{18868,500,"MobilePhone4"},
{18869,500,"MobilePhone5"},
{18870,1000,"MobilePhone6"},
{18871,1000,"MobilePhone7"},
{18872,1000,"MobilePhone8"},
{18873,1000,"MobilePhone9"},
{18874,1000,"MobilePhone10"},
{18875,750,"Pager"},
{18890,500,"Rake"},
{18891,500,"Bandana1"},
{18892,500,"Bandana2"},
{18893,500,"Bandana3"},
{18894,500,"Bandana4"},
{18895,500,"Bandana5"},
{18896,500,"Bandana6"},
{18897,500,"Bandana7"},
{18898,500,"Bandana8"},
{18899,500,"Bandana9"},
{18900,500,"Bandana10"},
{18901,750,"Bandana11"},
{18902,750,"Bandana12"},
{18903,750,"Bandana13"},
{18904,750,"Bandana14"},
{18905,750,"Bandana15"},
{18906,750,"Bandana16"},
{18907,750,"Bandana17"},
{18908,750,"Bandana18"},
{18909,750,"Bandana19"},
{18910,750,"Bandana20"},
{18911,1000,"Mask1"},
{18912,1000,"Mask2"},
{18913,1000,"Mask3"},
{18914,1000,"Mask4"},
{18915,1000,"Mask5"},
{18916,1000,"Mask6"},
{18917,1000,"Mask7"},
{18918,1000,"Mask8"},
{18919,1000,"Mask9"},
{18920,1000,"Mask10"},
{18921,500,"Beret1"},
{18922,500,"Beret2"},
{18923,750,"Beret3"},
{18924,1000,"Beret4"},
{18925,1000,"Beret5"},
{18926,500,"Hat1"},
{18927,500,"Hat2"},
{18928,500,"Hat3"},
{18929,500,"Hat4"},
{18930,500,"Hat5"},
{18931,1000,"Hat6"},
{18932,1000,"Hat7"},
{18933,1000,"Hat8"},
{18934,1000,"Hat9"},
{18935,1000,"Hat10"},
{18936,500,"Helmet1"},
{18937,750,"Helmet2"},
{18938,1000,"Helmet3"},
{18939,750,"CapBack1"},
{18940,750,"CapBack2"},
{18941,750,"CapBack3"},
{18942,1000,"CapBack4"},
{18943,1000,"CapBack5"},
{18944,1000,"HatBoater1"},
{18945,1250,"HatBoater2"},
{18946,1500,"HatBoater3"},
{18947,1000,"HatBowler1"},
{18948,1000,"HatBowler2"},
{18949,1000,"HatBowler3"},
{18950,1000,"HatBowler4"},
{18951,1000,"HatBowler5"},
{18952,1500,"BoxingHelmet"},
{18953,500,"CapKnit1"},
{18954,750,"CapKnit2"},
{18955,750,"CapOverEye1"},
{18956,750,"CapOverEye2"},
{18957,750,"CapOverEye3"},
{18958,750,"CapOverEye4"},
{18959,750,"CapOverEye5"},
{18960,1000,"CapRimUp1"},
{18961,750,"CapTrucker1"},
{18962,750,"CowboyHat2"},
{18964,1000,"SkullyCap1"},
{18965,1250,"SkullyCap2"},
{18966,1500,"SkullyCap3"},
{18967,1000,"HatMan1"},
{18968,1000,"HatMan2"},
{18969,1000,"HatMan3"},
{18970,2000,"HatTiger"},
{18971,1000,"HatCool1"},
{18972,1250,"HatCool2"},
{18973,1500,"HatCool3"},
{18974,10000,"MaskZorro1"},
{18645,1500,"MotorcycleHelmet"},
{18976,1000,"MotorcycleHelmet2"},
{18977,1000,"MotorcycleHelmet3"},
{18978,1250,"MotorcycleHelmet4"},
{18979,1500,"MotorcycleHelmet5"},
{19006,500,"GlassesType1"},
{19007,500,"GlassesType2"},
{19008,500,"GlassesType3"},
{19009,500,"GlassesType4"},
{19010,500,"GlassesType5"},
{19011,500,"GlassesType6"},
{19012,500,"GlassesType7"},
{19013,500,"GlassesType8"},
{19014,500,"GlassesType9"},
{19015,500,"GlassesType10"},
{19016,1000,"GlassesType11"},
{19017,1000,"GlassesType12"},
{19018,1000,"GlassesType13"},
{19019,1000,"GlassesType14"},
{19020,1000,"GlassesType15"},
{19021,1000,"GlassesType16"},
{19022,1000,"GlassesType17"},
{19023,1000,"GlassesType18"},
{19024,1000,"GlassesType19"},
{19025,1000,"GlassesType20"},
{19026,1500,"GlassesType21"},
{19027,1500,"GlassesType22"},
{19028,1500,"GlassesType23"},
{19029,1500,"GlassesType24"},
{19030,1500,"GlassesType25"},
{19031,1500,"GlassesType26"},
{19032,1500,"GlassesType27"},
{19033,1500,"GlassesType28"},
{19034,1500,"GlassesType29"},
{19035,1500,"GlassesType30"},
{19036,2000,"HockeyMask1"},
{19037,2000,"HockeyMask2"},
{19038,2000,"HockeyMask3"},
{19039,500,"WatchType1"},
{19040,500,"WatchType2"},
{19041,500,"WatchType3"},
{19042,500,"WatchType4"},
{19043,500,"WatchType5"},
{19044,500,"WatchType6"},
{19045,500,"WatchType7"},
{19046,1000,"WatchType8"},
{19047,1000,"WatchType9"},
{19048,1000,"WatchType10"},
{19049,1000,"WatchType11"},
{19050,1000,"WatchType12"},
{19051,1000,"WatchType13"},
{19052,1000,"WatchType14"},
{19053,1000,"WatchType15"},
{19064,10000, "SantaHat1"},
{19065,20000, "SantaHat2"},
{19066,30000, "SantaHat3"},
{19067,1000, "HoodyHat1"},
{19068,1000, "HoodyHat2"},
{19069,1000, "HoodyHat3"},
{19078,7500, "TheParrot1"},
{19079,7500, "TheParrot2"},
{19085,5000, "EyePatch"},
{19090,1500, "PomPomBlue"},
{19091,1500, "PomPomRed"},
{19092,1500, "PomPomGreen"},
{19094,2000, "BurgerShotHat"},
{19095,500, "CowboyHat1"},
{19096,500, "CowboyHat3"},
{19097,1000, "CowboyHat4"},
{19098,1000, "CowboyHat5"},
{19101,2000, "ArmyHelmet1"},
{19102,2000, "ArmyHelmet2"},
{19103,2000, "ArmyHelmet3"},
{19104,2000, "ArmyHelmet4"},
{19105,2000, "ArmyHelmet5"},
{19106,2000, "ArmyHelmet6"},
{19107,4000, "ArmyHelmet7"},
{19108,4000, "ArmyHelmet8"},
{19109,4000, "ArmyHelmet9"},
{19110,4000, "ArmyHelmet10"},
{19111,4000, "ArmyHelmet11"},
{19112,4000, "ArmyHelmet12"},
{19113,1000, "SillyHelmet1"},
{19114,2000, "SillyHelmet2"},
{19115,3000, "SillyHelmet3"},
{19116,500, "PlainHelmet1"},
{19117,500, "PlainHelmet2"},
{19118,750, "PlainHelmet3"},
{19119,1000, "PlainHelmet4"},
{19120,1000, "PlainHelmet5"},
{19137,5000, "CluckinBellHat"},
{19163,1000, "GimpMask"},
{1210,500, "Briefcase"},
{3044,500, "Cigar"}
};

new HoldingBones[][] = {
	"None",
	"Spine",
	"Head",
	"Left upper arm",
	"Right upper arm",
	"Left hand",
	"Right hand",
	"Left thigh",
	"Right thigh",
	"Left foot",
	"Right foot",
	"Right calf",
	"Left calf",
	"Left forearm",
	"Right forearm",
	"Left clavicle",
	"Right clavicle",
	"Neck",
	"Jaw"
};

new acstruct[MAX_PLAYERS][AC_STRUCT_INFO];

new MDCInfo[12][mdcInfo];

new Float:gFerrisCageOffsets[10][3] = {
	{0.0699, 0.0600, -11.7500},
	{-6.9100, -0.0899, -9.5000},
	{11.1600, 0.0000, -3.6300},
	{-11.1600, -0.0399, 3.6499},
	{-6.9100, -0.0899, 9.4799},
	{0.0699, 0.0600, 11.7500},
	{6.9599, 0.0100, -9.5000},
	{-11.1600, -0.0399, -3.6300},
	{11.1600, 0.0000, 3.6499},
	{7.0399, -0.0200, 9.3600}
};

new SuspectCrimes[][] = {
	"2-1-2 Attempted Murder",
	"2-1-3 Aggravated assault",
	"2-1-5 Assault/Battery",
	"2-1-6 Kidnapping",
	"2-1-7 Terroristic Threats",
	"2-1-8 Armed Robbery",
	"2-1-11 Trespassing",
	"2-1-13 Aiding and abetting",
	"2-1-14 Grand Theft (Auto)",
	"2-1-19 Possession of an illegal firearm",
	"2-1-20 Possession of illegal substances",
	"2-1-21 Unlawful discharge of a firearm",
	"2-1-22 Unlawful brandishing of a firearm",
	"2-1-27 Evading",
	"2-1-28 Arms Trafficking",
	"2-1-32 Smuggling Illegal Goods",
	"2-1-36 Shooting from a Motor Vehicle",
	"2-1-39 Failure to provide identification",
	"2-1-45 Criminal Negligence",
	"2-1-47 Vehicular Assault",
	"3-1-1 Reckless Driving",
	"3-1-3 Possession/Use of NOS",
	"3-1-5 Street Racing",
	"3-1-7 Hit & Run",
	"3-4-1 Obstruction of Justice",
	"3-4-3 Resisting an Arrest",
	"3-4-9 Disobeying Lawful Orders",
	"3-4-5 Vandalism",
	"3-5-6 Consumption of Cannabis in Public"
};

	// Category (0 = mis, 1 = fel), Stars(1 mis, 2 fel, 3 violent)
new SuspectCrimeInfo[][] = {
	{ 1, 3, 60, 60000 }, //"2-1-2 Attempted Murder",
	{ 1, 3, 35, 35000 }, //"2-1-3 Aggravated assault",
	{ 1, 3, 35, 35000 }, //"2-1-5 Assault/Battery",
	{ 1, 3, 60, 60000 }, //"2-1-6 Kidnapping",
	{ 1, 3, 45, 45000 }, //"2-1-7 Terroristic Threats",
	{ 1, 3, 60, 60000 }, //"2-1-8 Armed Robbery",
	{ 1, 2, 25, 10000 }, //"2-1-11 Trespassing",
	{ 1, 2, 40, 40000 }, //"2-1-13 Aiding and abetting",
	{ 1, 2, 40, 40000 }, //"2-1-14 Grand Theft (Auto)",
	{ 1, 2, 30, 30000 }, //"2-1-19 Possession of an illegal firearm",
	{ 1, 2, 30, 30000 }, //"2-1-20 Possession of illegal substances",
	{ 1, 2, 30, 30000 }, //"2-1-21 Unlawful discharge of a firearm",
	{ 1, 2, 25, 25000 }, //"2-1-22 Unlawful brandishing of a firearm",
	{ 1, 2, 45, 45000 }, //"2-1-27 Evading",
	{ 1, 2, 10, 10000 }, //"2-1-28 Arms Trafficking",
	{ 1, 2, 15, 5000 }, //"2-1-32 Smuggling Illegal Goods",
	{ 1, 3, 25, 25000 }, //"2-1-36 Shooting from a Motor Vehicle",
	{ 1, 2, 10, 1000 }, //"2-1-39 Failure to provide identification",
	{ 1, 2, 30, 30000 }, //"2-1-45 Criminal Negligence",
	{ 1, 3, 15, 10000 }, //"2-1-47 Vehicular Assault",
	{ 0, 1, 15, 10000 }, //"3-1-1 Reckless Driving",
	{ 0, 1, 15, 10000 }, //"3-1-3 Possession/Use of NOS",
	{ 0, 1, 30, 20000 }, //"3-1-5 Street Racing",
	{ 0, 1, 20, 20000 }, //"3-1-7 Hit &amp; Run",
	{ 0, 1, 15, 10000 }, //"3-4-1 Obstruction of Justice",
	{ 0, 1, 30, 15000 }, //"3-4-3 Resisting an Arrest",
	{ 0, 1, 15, 8000 }, //"3-4-9 Disobeying Lawful Orders",
	{ 0, 1, 10, 5000 }, //"3-4-5 Vandalism",
	{ 0, 1, 10, 5000 } //"3-5-6 Consumption of Cannabis in Public"
};

#if defined SHOPAUTOMATED
new const VehicleNameShop[167][VehicleNameShopEnum] = {
	{400, "Landstalker"}, {401, "Bravura"}, {402, "Buffalo"}, {403, "Linerunner"}, {404, "Perennial"}, {405, "Sentinel"}, {409, "Stretch"},
	{410, "Manana"}, {411, "Infernus"}, {412, "Voodoo"}, {413, "Pony"}, {414, "Mule"}, {415, "Cheetah"}, {417, "Leviathan"}, {418, "Moonbeam"},
	{419, "Esperanto"}, {420, "Taxi"}, {421, "Washington"}, {422, "Bobcat"}, {423, "Mr Whoopee"}, {424, "BF Injection"}, {426, "Premier"},
	{428, "Securicar"}, {429, "Banshee"}, {431, "Bus"}, {434, "Hotknife"}, {435, "Trailer"}, {436, "Previon"}, {437, "Coach"}, {438, "Cabbie"},
	{439, "Stallion"}, {440, "Rumpo"}, {442, "Romero"}, {443, "Packer"}, {444, "Monster"}, {445, "Admiral"}, {446, "Squalo"},
	{448, "Pizzaboy"}, {450, "Trailer"}, {451, "Turismo"}, {452, "Speeder"}, {453, "Reefer"}, {454, "Tropic"}, {455, "Flatbed"}, {456, "Yankee"},
	{457, "Caddy"}, {458, "Solair"}, {459, "Berkley's RC Van"}, {460, "Skimmer"}, {461, "PCJ-600"}, {462, "Faggio"}, {463, "Freeway"},
	{466, "Glendale"}, {467, "Oceanic"}, {468, "Sanchez"}, {469, "Sparrow"}, {470, "Patriot"}, {471, "Quad"}, {472, "Coastguard"},
	{473, "Dinghy"}, {474, "Hermes"}, {475, "Sabre"}, {477, "ZR-350"}, {478, "Walton"}, {479, "Regina"}, {480, "Comet"}, {481, "BMX"}, {482, "Burrito"},
	{483, "Camper"}, {484, "Marquis"}, {485, "Baggage"}, {487, "Maverick"}, {489, "Rancher"}, {491, "Virgo"}, {492, "Greenwood"}, {493, "Jetmax"},
	{494, "Hotring Racer"}, {495, "Sandking"}, {496, "Blista Compact"}, {498, "Boxville"}, {499, "Benson"}, {500, "Mesa"}, {502, "Hotring Racer A"},
	{503, "Hotring Racer B"}, {504, "Bloodring Banger"}, {505, "Rancher"}, {506, "Super GT"}, {507, "Elegant"}, {508, "Journey"}, {509, "Bike"},
	{510, "Mountain Bike"}, {511, "Beagle"}, {512, "Cropduster"}, {513, "Stuntplane"}, {514, "Tanker"}, {515, "Road Train"}, {516, "Nebula"},
	{517, "Majestic"}, {518, "Buccaneer"}, {519, "Shamal"}, {521, "FCR-900"}, {522, "NRG-500"}, {526, "Fortune"}, {527, "Cadrona"}, {529, "Willard"},
	{530, "Forklift"}, {531, "Tractor"}, {533, "Feltzer"}, {534, "Remington"}, {535, "Slamvan"}, {536, "Blade"}, {539, "Vortex"}, {540, "Vincent"},
	{541, "Bullet"}, {542, "Clover"}, {543, "Sadler"}, {545, "Hustler"}, {546, "Intruder"}, {547, "Primo"}, {549, "Tampa"}, {550, "Sunrise"},
	{551, "Merit"}, {553, "Nevada"}, {554, "Yosemite"}, {555, "Windsor"}, {556, "Monster A"}, {557, "Monster B"}, {558, "Uranus"}, {559, "Jester"},
	{560, "Sultan"}, {561, "Stratum"}, {562, "Elegy"}, {565, "Flash"}, {566, "Tahoma"}, {567, "Savanna"}, {568, "Bandito"}, {571, "Kart"}, {572, "Mower"},
	{573, "Duneride"}, {574, "Sweeper"}, {575, "Broadway"}, {576, "Tornado"}, {578, "DFT-30"}, {579, "Huntley"}, {580, "Stafford"}, {581, "BF-400"},
	{582, "Newsvan"}, {583, "Tug"}, {584, "Trailer"}, {585, "Emperor"}, {586, "Wayfarer"}, {587, "Euros"}, {588, "Hotdog"}, {589, "Club"}, {591, "Trailer"},
	{592, "Andromada"}, {593, "Dodo"}, {595, "Launch"}, {600, "Picador"}, {602, "Alpha"}, {603, "Phoenix"}, {604, "Glendale"}, {605, "Sadler"},
	{606, "Luggage Trailer A"}, {607, "Luggage Trailer B"}, {608, "Stair Trailer"}, {609, "Boxville"}
};
#endif

new const AreaName[161][] = {
	"San Andreas", "Los Santos", "San Fierro", "Tierra Robada", "Las Venturas", "Red County", "Flint County", "Bone County",
	"Whetstone", "The Big Ear", "Aldea Malvada", "Angel Pine", "Arco del Oeste", "Avispa Country Club", "Back o Beyond",
	"Battery Point", "Bayside", "Bayside Marina", "Beacon Hill", "Blackfield", "Blackfield Chapel", "Blackfield Intersection",
	"Blueberry", "Blueberry Acres", "Caligula's Palace", "Calton Heights", "Chinatown", "City Hall", "Come-A-Lot", "Commerce",
	"Conference Center", "Cranberry Station", "Creek", "Dillimore", "Doherty", "Donahue Acres", "Downtown", "Downtown Los Santos",
	"East Beach", "East Los Santos", "Easter Basin", "Easter Bay Airport", "Easter Bay Chemicals", "El Castillo del Diablo",
	"El Corona", "El Quebrados", "Esplanade East", "Esplanade North", "Fallen Tree", "Fallow Bridge", "Fern Ridge", "Financial",
	"Fisher's Lagoon", "Flint Intersection", "Flint Range", "Fort Carson", "Foster Valley", "Frederick Bridge", "Gant Bridge",
	"Ganton", "Garcia", "Garver Bridge", "Glen Park", "Green Palms", "Greenglass College", "Hampton Barns", "Hankypanky Point",
	"Harry Gold Parkway", "Hashbury", "Hilltop Farm", "Hunter Quarry", "Idlewood", "Jefferson", "Julius Thruway East",
	"Julius Thruway North", "Julius Thruway South", "Julius Thruway West", "Juniper Hill", "Juniper Hollow", "K.A.C.C. Military Fuels",
	"Kincaid Bridge", "King's", "LVA Freight Depot", "Las Barrancas", "Las Brujas", "Las Colinas", "Las Payasadas", "Las Venturas Airport",
	"Last Dime Motel", "Leafy Hollow", "Liberty City", "Lil' Probe Inn", "Linden Side", "Linden Station", "Little Mexico", "Los Flores",
	"Los Santos International", "Marina", "Market", "Market Station", "Martin Bridge", "Missionary Hill", "Montgomery",
	"Montgomery Intersection", "Mulholland", "Mulholland Intersection", "North Rock", "Ocean Docks", "Octane Springs", "Old Venturas Strip",
	"Palisades", "Palomino Creek", "Paradiso", "Pershing Square", "Pilgrim", "Pilson Intersection", "Pirates in Men's Pants",
	"Playa del Seville", "Prickle Pine", "Queens", "Randolph Industrial Estate", "Redsands East", "Redsands West", "Regular Tom",
	"Richman", "Robada Intersection", "Roca Escalante", "Rockshore East", "Rockshore West", "Rodeo", "Royal Casino", "San Andreas Sound",
	"Santa Flora", "Santa Maria Beach", "Shady Cabin", "Shady Creeks", "Sobell Rail Yards", "Spinybed", "Starfish Casino", "Temple",
	"The Camel's Toe", "The Clown's Pocket", "The Emerald Isle", "The Farm", "The Four Dragons Casino", "The High Roller", "The Mako Span",
	"The Panopticon", "The Pink Swan", "The Sherman Dam", "The Strip", "The Visage", "Unity Station", "Valle Ocultado", "Verdant Bluffs",
	"Verdant Meadows", "Verona Beach", "Vinewood", "Whitewood Estates", "Willowfield", "Yellow Bell Station"
};

new const VehicleName[212][] = {
	"Landstalker","Bravura","Buffalo","Linerunner","Perennial","Sentinel","Dumper","Firetruck","Trashmaster","Stretch",
	"Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi",
	"Washington","Bobcat","Mr Whoopee","BF Injection","Hunter","Premier","Enforcer","Securicar","Banshee","Predator",
	"Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie","Stallion","Rumpo","RC Bandit", "Romero",
	"Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder","Reefer","Tropic","Flatbed",
	"Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler",
	"ZR-350","Walton","Regina","Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper",
	"Rancher","FBI Rancher","Virgo","Greenwood","Jetmax","Hotring Racer","Sandking","Blista Compact","Police Maverick",
	"Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B","Bloodring Banger","Rancher","Super GT",
	"Elegant","Journey","Bike","Mountain Bike","Beagle","Cropduster","Stuntplane","Tanker","Road Train","Nebula","Majestic",
	"Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV-1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent",
	"Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility",
	"Nevada","Yosemite","Windsor","Monster A","Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger",
	"Flash","Tahoma","Savanna","Bandito","Freight","Trailer","Kart","Mower","Duneride","Sweeper","Broadway",
	"Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer","Emperor","Wayfarer",
	"Euros","Hotdog","Club","Trailer","Trailer","Andromada","Dodo","RCCam","Launch","Police Car (LSPD)","Police Car (SFPD)",
	"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A",
	"Luggage Trailer B","Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};

new const gSAZones[][SAZONE_MAIN] = {  // Majority of names and area coordinates adopted from Mabako's 'Zones Script' v0.2
	//	NAME                            AREA (Xmin,Ymin,Zmin,Xmax,Ymax,Zmax)
	{"The Big Ear",	                {-410.00,1403.30,-3.00,-137.90,1681.20,200.00}},
	{"Aldea Malvada",               {-1372.10,2498.50,0.00,-1277.50,2615.30,200.00}},
	{"Angel Pine",                  {-2324.90,-2584.20,-6.10,-1964.20,-2212.10,200.00}},
	{"Arco del Oeste",              {-901.10,2221.80,0.00,-592.00,2571.90,200.00}},
	{"Avispa Country Club",         {-2646.40,-355.40,0.00,-2270.00,-222.50,200.00}},
	{"Avispa Country Club",         {-2831.80,-430.20,-6.10,-2646.40,-222.50,200.00}},
	{"Avispa Country Club",         {-2361.50,-417.10,0.00,-2270.00,-355.40,200.00}},
	{"Avispa Country Club",         {-2667.80,-302.10,-28.80,-2646.40,-262.30,71.10}},
	{"Avispa Country Club",         {-2470.00,-355.40,0.00,-2270.00,-318.40,46.10}},
	{"Avispa Country Club",         {-2550.00,-355.40,0.00,-2470.00,-318.40,39.70}},
	{"Back o Beyond",               {-1166.90,-2641.10,0.00,-321.70,-1856.00,200.00}},
	{"Battery Point",               {-2741.00,1268.40,-4.50,-2533.00,1490.40,200.00}},
	{"Bayside",                     {-2741.00,2175.10,0.00,-2353.10,2722.70,200.00}},
	{"Bayside Marina",              {-2353.10,2275.70,0.00,-2153.10,2475.70,200.00}},
	{"Beacon Hill",                 {-399.60,-1075.50,-1.40,-319.00,-977.50,198.50}},
	{"Blackfield",                  {964.30,1203.20,-89.00,1197.30,1403.20,110.90}},
	{"Blackfield",                  {964.30,1403.20,-89.00,1197.30,1726.20,110.90}},
	{"Blackfield Chapel",           {1375.60,596.30,-89.00,1558.00,823.20,110.90}},
	{"Blackfield Chapel",           {1325.60,596.30,-89.00,1375.60,795.00,110.90}},
	{"Blackfield Intersection",     {1197.30,1044.60,-89.00,1277.00,1163.30,110.90}},
	{"Blackfield Intersection",     {1166.50,795.00,-89.00,1375.60,1044.60,110.90}},
	{"Blackfield Intersection",     {1277.00,1044.60,-89.00,1315.30,1087.60,110.90}},
	{"Blackfield Intersection",     {1375.60,823.20,-89.00,1457.30,919.40,110.90}},
	{"Blueberry",                   {104.50,-220.10,2.30,349.60,152.20,200.00}},
	{"Blueberry",                   {19.60,-404.10,3.80,349.60,-220.10,200.00}},
	{"Blueberry Acres",             {-319.60,-220.10,0.00,104.50,293.30,200.00}},
	{"Caligula's Palace",           {2087.30,1543.20,-89.00,2437.30,1703.20,110.90}},
	{"Caligula's Palace",           {2137.40,1703.20,-89.00,2437.30,1783.20,110.90}},
	{"Calton Heights",              {-2274.10,744.10,-6.10,-1982.30,1358.90,200.00}},
	{"Chinatown",                   {-2274.10,578.30,-7.60,-2078.60,744.10,200.00}},
	{"City Hall",                   {-2867.80,277.40,-9.10,-2593.40,458.40,200.00}},
	{"Come-A-Lot",                  {2087.30,943.20,-89.00,2623.10,1203.20,110.90}},
	{"Commerce",                    {1323.90,-1842.20,-89.00,1701.90,-1722.20,110.90}},
	{"Commerce",                    {1323.90,-1722.20,-89.00,1440.90,-1577.50,110.90}},
	{"Commerce",                    {1370.80,-1577.50,-89.00,1463.90,-1384.90,110.90}},
	{"Commerce",                    {1463.90,-1577.50,-89.00,1667.90,-1430.80,110.90}},
	{"Commerce",                    {1583.50,-1722.20,-89.00,1758.90,-1577.50,110.90}},
	{"Commerce",                    {1667.90,-1577.50,-89.00,1812.60,-1430.80,110.90}},
	{"Conference Center",           {1046.10,-1804.20,-89.00,1323.90,-1722.20,110.90}},
	{"Conference Center",           {1073.20,-1842.20,-89.00,1323.90,-1804.20,110.90}},
	{"Cranberry Station",           {-2007.80,56.30,0.00,-1922.00,224.70,100.00}},
	{"Crate Cave",                  {-2500.00,-2000.00,11000.00,-1500.00,-1400.00,12000.00}},
	{"Creek",                       {2749.90,1937.20,-89.00,2921.60,2669.70,110.90}},
	{"Dillimore",                   {580.70,-674.80,-9.50,861.00,-404.70,200.00}},
	{"Doherty",                     {-2270.00,-324.10,-0.00,-1794.90,-222.50,200.00}},
	{"Doherty",                     {-2173.00,-222.50,-0.00,-1794.90,265.20,200.00}},
	{"Donahue Acres",               {-1599.56,-1306.60,-89.00,-1219.82,-866.31,300.00}},
	{"Downtown",                    {-1982.30,744.10,-6.10,-1871.70,1274.20,200.00}},
	{"Downtown",                    {-1871.70,1176.40,-4.50,-1620.30,1274.20,200.00}},
	{"Downtown",                    {-1700.00,744.20,-6.10,-1580.00,1176.50,200.00}},
	{"Downtown",                    {-1580.00,744.20,-6.10,-1499.80,1025.90,200.00}},
	{"Downtown",                    {-2078.60,578.30,-7.60,-1499.80,744.20,200.00}},
	{"Downtown",                    {-1993.20,265.20,-9.10,-1794.90,578.30,200.00}},
	{"Downtown Los Santos",         {1463.90,-1430.80,-89.00,1724.70,-1290.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1430.80,-89.00,1812.60,-1250.90,110.90}},
	{"Downtown Los Santos",         {1463.90,-1290.80,-89.00,1724.70,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1384.90,-89.00,1463.90,-1170.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1250.90,-89.00,1812.60,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1170.80,-89.00,1463.90,-1130.80,110.90}},
	{"Downtown Los Santos",         {1378.30,-1130.80,-89.00,1463.90,-1026.30,110.90}},
	{"Downtown Los Santos",         {1391.00,-1026.30,-89.00,1463.90,-926.90,110.90}},
	{"Downtown Los Santos",         {1507.50,-1385.20,110.90,1582.50,-1325.30,335.90}},
	{"East Beach",                  {2632.80,-1852.80,-89.00,2959.30,-1668.10,110.90}},
	{"East Beach",                  {2632.80,-1668.10,-89.00,2747.70,-1393.40,110.90}},
	{"East Beach",                  {2747.70,-1668.10,-89.00,2959.30,-1498.60,110.90}},
	{"East Beach",                  {2747.70,-1498.60,-89.00,2959.30,-1120.00,110.90}},
	{"East Los Santos",             {2421.00,-1628.50,-89.00,2632.80,-1454.30,110.90}},
	{"East Los Santos",             {2222.50,-1628.50,-89.00,2421.00,-1494.00,110.90}},
	{"East Los Santos",             {2266.20,-1494.00,-89.00,2381.60,-1372.00,110.90}},
	{"East Los Santos",             {2381.60,-1494.00,-89.00,2421.00,-1454.30,110.90}},
	{"East Los Santos",             {2281.40,-1372.00,-89.00,2381.60,-1135.00,110.90}},
	{"East Los Santos",             {2381.60,-1454.30,-89.00,2462.10,-1135.00,110.90}},
	{"East Los Santos",             {2462.10,-1454.30,-89.00,2581.70,-1135.00,110.90}},
	{"Easter Basin",                {-1794.90,249.90,-9.10,-1242.90,578.30,200.00}},
	{"Easter Basin",                {-1794.90,-50.00,-0.00,-1499.80,249.90,200.00}},
	{"Easter Bay Airport",          {-1499.80,-50.00,-0.00,-1242.90,249.90,200.00}},
	{"Easter Bay Airport",          {-1794.90,-730.10,-3.00,-1213.90,-50.00,200.00}},
	{"Easter Bay Airport",          {-1213.90,-730.10,0.00,-1132.80,-50.00,200.00}},
	{"Easter Bay Airport",          {-1242.90,-50.00,0.00,-1213.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1213.90,-50.00,-4.50,-947.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1315.40,-405.30,15.40,-1264.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1354.30,-287.30,15.40,-1315.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1490.30,-209.50,15.40,-1264.40,-148.30,25.40}},
	{"Easter Bay Chemicals",        {-1132.80,-768.00,0.00,-956.40,-578.10,200.00}},
	{"Easter Bay Chemicals",        {-1132.80,-787.30,0.00,-956.40,-768.00,200.00}},
	{"El Castillo del Diablo",      {-464.50,2217.60,0.00,-208.50,2580.30,200.00}},
	{"El Castillo del Diablo",      {-208.50,2123.00,-7.60,114.00,2337.10,200.00}},
	{"El Castillo del Diablo",      {-208.50,2337.10,0.00,8.40,2487.10,200.00}},
	{"El Corona",                   {1812.60,-2179.20,-89.00,1970.60,-1852.80,110.90}},
	{"El Corona",                   {1692.60,-2179.20,-89.00,1812.60,-1842.20,110.90}},
	{"El Quebrados",                {-1645.20,2498.50,0.00,-1372.10,2777.80,200.00}},
	{"Esplanade East",              {-1620.30,1176.50,-4.50,-1580.00,1274.20,200.00}},
	{"Esplanade East",              {-1580.00,1025.90,-6.10,-1499.80,1274.20,200.00}},
	{"Esplanade East",              {-1499.80,578.30,-79.60,-1339.80,1274.20,20.30}},
	{"Esplanade North",             {-2533.00,1358.90,-4.50,-1996.60,1501.20,200.00}},
	{"Esplanade North",             {-1996.60,1358.90,-4.50,-1524.20,1592.50,200.00}},
	{"Esplanade North",             {-1982.30,1274.20,-4.50,-1524.20,1358.90,200.00}},
	{"Fallen Tree",                 {-792.20,-698.50,-5.30,-452.40,-380.00,200.00}},
	{"Fallow Bridge",               {434.30,366.50,0.00,603.00,555.60,200.00}},
	{"Fern Ridge",                  {508.10,-139.20,0.00,1306.60,119.50,200.00}},
	{"Financial",                   {-1871.70,744.10,-6.10,-1701.30,1176.40,300.00}},
	{"Fisher's Lagoon",             {1916.90,-233.30,-100.00,2131.70,13.80,200.00}},
	{"Flint Intersection",          {-187.70,-1596.70,-89.00,17.00,-1276.60,110.90}},
	{"Flint Range",                 {-594.10,-1648.50,0.00,-187.70,-1276.60,200.00}},
	{"Fort Carson",                 {-376.20,826.30,-3.00,123.70,1220.40,200.00}},
	{"Foster Valley",               {-2270.00,-430.20,-0.00,-2178.60,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-599.80,-0.00,-1794.90,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-1115.50,0.00,-1794.90,-599.80,200.00}},
	{"Foster Valley",               {-2178.60,-1250.90,0.00,-1794.90,-1115.50,200.00}},
	{"Frederick Bridge",            {2759.20,296.50,0.00,2774.20,594.70,200.00}},
	{"Gant Bridge",                 {-2741.40,1659.60,-6.10,-2616.40,2175.10,200.00}},
	{"Gant Bridge",                 {-2741.00,1490.40,-6.10,-2616.40,1659.60,200.00}},
	{"Ganton",                      {2222.50,-1852.80,-89.00,2632.80,-1722.30,110.90}},
	{"Ganton",                      {2222.50,-1722.30,-89.00,2632.80,-1628.50,110.90}},
	{"Garcia",                      {-2411.20,-222.50,-0.00,-2173.00,265.20,200.00}},
	{"Garcia",                      {-2395.10,-222.50,-5.30,-2354.00,-204.70,200.00}},
	{"Garver Bridge",               {-1339.80,828.10,-89.00,-1213.90,1057.00,110.90}},
	{"Garver Bridge",               {-1213.90,950.00,-89.00,-1087.90,1178.90,110.90}},
	{"Garver Bridge",               {-1499.80,696.40,-179.60,-1339.80,925.30,20.30}},
	{"Glen Park",                   {1812.60,-1449.60,-89.00,1996.90,-1350.70,110.90}},
	{"Glen Park",                   {1812.60,-1100.80,-89.00,1994.30,-973.30,110.90}},
	{"Glen Park",                   {1812.60,-1350.70,-89.00,2056.80,-1100.80,110.90}},
	{"Gov. Weapon Facility",        {-1391.87,4087.72,-89.00,-883.24,4966.63,300.00}},
	{"Green Palms",                 {176.50,1305.40,-3.00,338.60,1520.70,200.00}},
	{"Greenglass College",          {964.30,1044.60,-89.00,1197.30,1203.20,110.90}},
	{"Greenglass College",          {964.30,930.80,-89.00,1166.50,1044.60,110.90}},
	{"Hampton Barns",               {603.00,264.30,0.00,761.90,366.50,200.00}},
	{"Hankypanky Point",            {2576.90,62.10,0.00,2759.20,385.50,200.00}},
	{"Harry Gold Parkway",          {1777.30,863.20,-89.00,1817.30,2342.80,110.90}},
	{"Hashbury",                    {-2593.40,-222.50,-0.00,-2411.20,54.70,200.00}},
	{"Hilltop Farm",                {967.30,-450.30,-3.00,1176.70,-217.90,200.00}},
	{"Hunter Quarry",               {337.20,710.80,-115.20,860.50,1031.70,203.70}},
	{"Idlewood",                    {1812.60,-1852.80,-89.00,1971.60,-1742.30,110.90}},
	{"Idlewood",                    {1812.60,-1742.30,-89.00,1951.60,-1602.30,110.90}},
	{"Idlewood",                    {1951.60,-1742.30,-89.00,2124.60,-1602.30,110.90}},
	{"Idlewood",                    {1812.60,-1602.30,-89.00,2124.60,-1449.60,110.90}},
	{"Idlewood",                    {2124.60,-1742.30,-89.00,2222.50,-1494.00,110.90}},
	{"Idlewood",                    {1971.60,-1852.80,-89.00,2222.50,-1742.30,110.90}},
	{"Jefferson",                   {1996.90,-1449.60,-89.00,2056.80,-1350.70,110.90}},
	{"Jefferson",                   {2124.60,-1494.00,-89.00,2266.20,-1449.60,110.90}},
	{"Jefferson",                   {2056.80,-1372.00,-89.00,2281.40,-1210.70,110.90}},
	{"Jefferson",                   {2056.80,-1210.70,-89.00,2185.30,-1126.30,110.90}},
	{"Jefferson",                   {2185.30,-1210.70,-89.00,2281.40,-1154.50,110.90}},
	{"Jefferson",                   {2056.80,-1449.60,-89.00,2266.20,-1372.00,110.90}},
	{"Julius Thruway East",         {2623.10,943.20,-89.00,2749.90,1055.90,110.90}},
	{"Julius Thruway East",         {2685.10,1055.90,-89.00,2749.90,2626.50,110.90}},
	{"Julius Thruway East",         {2536.40,2442.50,-89.00,2685.10,2542.50,110.90}},
	{"Julius Thruway East",         {2625.10,2202.70,-89.00,2685.10,2442.50,110.90}},
	{"Julius Thruway North",        {2498.20,2542.50,-89.00,2685.10,2626.50,110.90}},
	{"Julius Thruway North",        {2237.40,2542.50,-89.00,2498.20,2663.10,110.90}},
	{"Julius Thruway North",        {2121.40,2508.20,-89.00,2237.40,2663.10,110.90}},
	{"Julius Thruway North",        {1938.80,2508.20,-89.00,2121.40,2624.20,110.90}},
	{"Julius Thruway North",        {1534.50,2433.20,-89.00,1848.40,2583.20,110.90}},
	{"Julius Thruway North",        {1848.40,2478.40,-89.00,1938.80,2553.40,110.90}},
	{"Julius Thruway North",        {1704.50,2342.80,-89.00,1848.40,2433.20,110.90}},
	{"Julius Thruway North",        {1377.30,2433.20,-89.00,1534.50,2507.20,110.90}},
	{"Julius Thruway South",        {1457.30,823.20,-89.00,2377.30,863.20,110.90}},
	{"Julius Thruway South",        {2377.30,788.80,-89.00,2537.30,897.90,110.90}},
	{"Julius Thruway West",         {1197.30,1163.30,-89.00,1236.60,2243.20,110.90}},
	{"Julius Thruway West",         {1236.60,2142.80,-89.00,1297.40,2243.20,110.90}},
	{"Juniper Hill",                {-2533.00,578.30,-7.60,-2274.10,968.30,200.00}},
	{"Juniper Hollow",              {-2533.00,968.30,-6.10,-2274.10,1358.90,200.00}},
	{"K.A.C.C. Military Fuels",     {2498.20,2626.50,-89.00,2749.90,2861.50,110.90}},
	{"Kincaid Bridge",              {-1339.80,599.20,-89.00,-1213.90,828.10,110.90}},
	{"Kincaid Bridge",              {-1213.90,721.10,-89.00,-1087.90,950.00,110.90}},
	{"Kincaid Bridge",              {-1087.90,855.30,-89.00,-961.90,986.20,110.90}},
	{"King's",                      {-2329.30,458.40,-7.60,-1993.20,578.30,200.00}},
	{"King's",                      {-2411.20,265.20,-9.10,-1993.20,373.50,200.00}},
	{"King's",                      {-2253.50,373.50,-9.10,-1993.20,458.40,200.00}},
	{"LVA Freight Depot",           {1457.30,863.20,-89.00,1777.40,1143.20,110.90}},
	{"LVA Freight Depot",           {1375.60,919.40,-89.00,1457.30,1203.20,110.90}},
	{"LVA Freight Depot",           {1277.00,1087.60,-89.00,1375.60,1203.20,110.90}},
	{"LVA Freight Depot",           {1315.30,1044.60,-89.00,1375.60,1087.60,110.90}},
	{"LVA Freight Depot",           {1236.60,1163.40,-89.00,1277.00,1203.20,110.90}},
	{"Las Barrancas",               {-926.10,1398.70,-3.00,-719.20,1634.60,200.00}},
	{"Las Brujas",                  {-365.10,2123.00,-3.00,-208.50,2217.60,200.00}},
	{"Las Colinas",                 {1994.30,-1100.80,-89.00,2056.80,-920.80,110.90}},
	{"Las Colinas",                 {2056.80,-1126.30,-89.00,2126.80,-920.80,110.90}},
	{"Las Colinas",                 {2185.30,-1154.50,-89.00,2281.40,-934.40,110.90}},
	{"Las Colinas",                 {2126.80,-1126.30,-89.00,2185.30,-934.40,110.90}},
	{"Las Colinas",                 {2747.70,-1120.00,-89.00,2959.30,-945.00,110.90}},
	{"Las Colinas",                 {2632.70,-1135.00,-89.00,2747.70,-945.00,110.90}},
	{"Las Colinas",                 {2281.40,-1135.00,-89.00,2632.70,-945.00,110.90}},
	{"Las Payasadas",               {-354.30,2580.30,2.00,-133.60,2816.80,200.00}},
	{"Las Venturas Airport",        {1236.60,1203.20,-89.00,1457.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1203.20,-89.00,1777.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1143.20,-89.00,1777.40,1203.20,110.90}},
	{"Las Venturas Airport",        {1515.80,1586.40,-12.50,1729.90,1714.50,87.50}},
	{"Last Dime Motel",             {1823.00,596.30,-89.00,1997.20,823.20,110.90}},
	{"Leafy Hollow",                {-1166.90,-1856.00,0.00,-815.60,-1602.00,200.00}},
	{"Liberty City",                {-1000.00,400.00,1300.00,-700.00,600.00,1400.00}},
	{"Lil' Probe Inn",              {-90.20,1286.80,-3.00,153.80,1554.10,200.00}},
	{"Linden Side",                 {2749.90,943.20,-89.00,2923.30,1198.90,110.90}},
	{"Linden Station",              {2749.90,1198.90,-89.00,2923.30,1548.90,110.90}},
	{"Linden Station",              {2811.20,1229.50,-39.50,2861.20,1407.50,60.40}},
	{"Little Mexico",               {1701.90,-1842.20,-89.00,1812.60,-1722.20,110.90}},
	{"Little Mexico",               {1758.90,-1722.20,-89.00,1812.60,-1577.50,110.90}},
	{"Los Flores",                  {2581.70,-1454.30,-89.00,2632.80,-1393.40,110.90}},
	{"Los Flores",                  {2581.70,-1393.40,-89.00,2747.70,-1135.00,110.90}},
	{"Los Santos International",    {1249.60,-2394.30,-89.00,1852.00,-2179.20,110.90}},
	{"Los Santos International",    {1852.00,-2394.30,-89.00,2089.00,-2179.20,110.90}},
	{"Los Santos International",    {1382.70,-2730.80,-89.00,2201.80,-2394.30,110.90}},
	{"Los Santos International",    {1974.60,-2394.30,-39.00,2089.00,-2256.50,60.90}},
	{"Los Santos International",    {1400.90,-2669.20,-39.00,2189.80,-2597.20,60.90}},
	{"Los Santos International",    {2051.60,-2597.20,-39.00,2152.40,-2394.30,60.90}},
	{"Marina",                      {647.70,-1804.20,-89.00,851.40,-1577.50,110.90}},
	{"Marina",                      {647.70,-1577.50,-89.00,807.90,-1416.20,110.90}},
	{"Marina",                      {807.90,-1577.50,-89.00,926.90,-1416.20,110.90}},
	{"Market",                      {787.40,-1416.20,-89.00,1072.60,-1310.20,110.90}},
	{"Market",                      {952.60,-1310.20,-89.00,1072.60,-1130.80,110.90}},
	{"Market",                      {1072.60,-1416.20,-89.00,1370.80,-1130.80,110.90}},
	{"Market",                      {926.90,-1577.50,-89.00,1370.80,-1416.20,110.90}},
	{"Market Station",              {787.40,-1410.90,-34.10,866.00,-1310.20,65.80}},
	{"Martin Bridge",               {-222.10,293.30,0.00,-122.10,476.40,200.00}},
	{"Mile High Club",              {1590.00,1370.00,1120.00,1830.00,1550.00,1190.00}},
	{"Missionary Hill",             {-2994.40,-811.20,0.00,-2178.60,-430.20,200.00}},
	{"Montgomery",                  {1119.50,119.50,-3.00,1451.40,493.30,200.00}},
	{"Montgomery",                  {1451.40,347.40,-6.10,1582.40,420.80,200.00}},
	{"Montgomery Intersection",     {1546.60,208.10,0.00,1745.80,347.40,200.00}},
	{"Montgomery Intersection",     {1582.40,347.40,0.00,1664.60,401.70,200.00}},
	{"Mulholland",                  {1414.00,-768.00,-89.00,1667.60,-452.40,110.90}},
	{"Mulholland",                  {1281.10,-452.40,-89.00,1641.10,-290.90,110.90}},
	{"Mulholland",                  {1269.10,-768.00,-89.00,1414.00,-452.40,110.90}},
	{"Mulholland",                  {1357.00,-926.90,-89.00,1463.90,-768.00,110.90}},
	{"Mulholland",                  {1318.10,-910.10,-89.00,1357.00,-768.00,110.90}},
	{"Mulholland",                  {1169.10,-910.10,-89.00,1318.10,-768.00,110.90}},
	{"Mulholland",                  {768.60,-954.60,-89.00,952.60,-860.60,110.90}},
	{"Mulholland",                  {687.80,-860.60,-89.00,911.80,-768.00,110.90}},
	{"Mulholland",                  {737.50,-768.00,-89.00,1142.20,-674.80,110.90}},
	{"Mulholland",                  {1096.40,-910.10,-89.00,1169.10,-768.00,110.90}},
	{"Mulholland",                  {952.60,-937.10,-89.00,1096.40,-860.60,110.90}},
	{"Mulholland",                  {911.80,-860.60,-89.00,1096.40,-768.00,110.90}},
	{"Mulholland",                  {861.00,-674.80,-89.00,1156.50,-600.80,110.90}},
	{"Mulholland Intersection",     {1463.90,-1150.80,-89.00,1812.60,-768.00,110.90}},
	{"North Rock",                  {2285.30,-768.00,0.00,2770.50,-269.70,200.00}},
	{"Ocean Docks",                 {2373.70,-2697.00,-89.00,2809.20,-2330.40,110.90}},
	{"Ocean Docks",                 {2201.80,-2418.30,-89.00,2324.00,-2095.00,110.90}},
	{"Ocean Docks",                 {2324.00,-2302.30,-89.00,2703.50,-2145.10,110.90}},
	{"Ocean Docks",                 {2089.00,-2394.30,-89.00,2201.80,-2235.80,110.90}},
	{"Ocean Docks",                 {2201.80,-2730.80,-89.00,2324.00,-2418.30,110.90}},
	{"Ocean Docks",                 {2703.50,-2302.30,-89.00,2959.30,-2126.90,110.90}},
	{"Ocean Docks",                 {2324.00,-2145.10,-89.00,2703.50,-2059.20,110.90}},
	{"Ocean Flats",                 {-2994.40,277.40,-9.10,-2867.80,458.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-222.50,-0.00,-2593.40,277.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-430.20,-0.00,-2831.80,-222.50,200.00}},
	{"Octane Springs",              {338.60,1228.50,0.00,664.30,1655.00,200.00}},
	{"Old Venturas Strip",          {2162.30,2012.10,-89.00,2685.10,2202.70,110.90}},
	{"Palisades",                   {-2994.40,458.40,-6.10,-2741.00,1339.60,200.00}},
	{"Palomino Creek",              {2160.20,-149.00,0.00,2576.90,228.30,200.00}},
	{"Paradiso",                    {-2741.00,793.40,-6.10,-2533.00,1268.40,200.00}},
	{"Pershing Square",             {1440.90,-1722.20,-89.00,1583.50,-1577.50,110.90}},
	{"Pilgrim",                     {2437.30,1383.20,-89.00,2624.40,1783.20,110.90}},
	{"Pilgrim",                     {2624.40,1383.20,-89.00,2685.10,1783.20,110.90}},
	{"Pilson Intersection",         {1098.30,2243.20,-89.00,1377.30,2507.20,110.90}},
	{"Pirates in Men's Pants",      {1817.30,1469.20,-89.00,2027.40,1703.20,110.90}},
	{"Playa del Seville",           {2703.50,-2126.90,-89.00,2959.30,-1852.80,110.90}},
	{"Prickle Pine",                {1534.50,2583.20,-89.00,1848.40,2863.20,110.90}},
	{"Prickle Pine",                {1117.40,2507.20,-89.00,1534.50,2723.20,110.90}},
	{"Prickle Pine",                {1848.40,2553.40,-89.00,1938.80,2863.20,110.90}},
	{"Prickle Pine",                {1938.80,2624.20,-89.00,2121.40,2861.50,110.90}},
	{"Queens",                      {-2533.00,458.40,0.00,-2329.30,578.30,200.00}},
	{"Queens",                      {-2593.40,54.70,0.00,-2411.20,458.40,200.00}},
	{"Queens",                      {-2411.20,373.50,0.00,-2253.50,458.40,200.00}},
	{"Randolph Industrial Estate",  {1558.00,596.30,-89.00,1823.00,823.20,110.90}},
	{"Redsands East",               {1817.30,2011.80,-89.00,2106.70,2202.70,110.90}},
	{"Redsands East",               {1817.30,2202.70,-89.00,2011.90,2342.80,110.90}},
	{"Redsands East",               {1848.40,2342.80,-89.00,2011.90,2478.40,110.90}},
	{"Redsands West",               {1236.60,1883.10,-89.00,1777.30,2142.80,110.90}},
	{"Redsands West",               {1297.40,2142.80,-89.00,1777.30,2243.20,110.90}},
	{"Redsands West",               {1377.30,2243.20,-89.00,1704.50,2433.20,110.90}},
	{"Redsands West",               {1704.50,2243.20,-89.00,1777.30,2342.80,110.90}},
	{"Regular Tom",                 {-405.70,1712.80,-3.00,-276.70,1892.70,200.00}},
	{"Richman",                     {647.50,-1118.20,-89.00,787.40,-954.60,110.90}},
	{"Richman",                     {647.50,-954.60,-89.00,768.60,-860.60,110.90}},
	{"Richman",                     {225.10,-1369.60,-89.00,334.50,-1292.00,110.90}},
	{"Richman",                     {225.10,-1292.00,-89.00,466.20,-1235.00,110.90}},
	{"Richman",                     {72.60,-1404.90,-89.00,225.10,-1235.00,110.90}},
	{"Richman",                     {72.60,-1235.00,-89.00,321.30,-1008.10,110.90}},
	{"Richman",                     {321.30,-1235.00,-89.00,647.50,-1044.00,110.90}},
	{"Richman",                     {321.30,-1044.00,-89.00,647.50,-860.60,110.90}},
	{"Richman",                     {321.30,-860.60,-89.00,687.80,-768.00,110.90}},
	{"Richman",                     {321.30,-768.00,-89.00,700.70,-674.80,110.90}},
	{"Robada Intersection",         {-1119.00,1178.90,-89.00,-862.00,1351.40,110.90}},
	{"Roca Escalante",              {2237.40,2202.70,-89.00,2536.40,2542.50,110.90}},
	{"Roca Escalante",              {2536.40,2202.70,-89.00,2625.10,2442.50,110.90}},
	{"Rockshore East",              {2537.30,676.50,-89.00,2902.30,943.20,110.90}},
	{"Rockshore West",              {1997.20,596.30,-89.00,2377.30,823.20,110.90}},
	{"Rockshore West",              {2377.30,596.30,-89.00,2537.30,788.80,110.90}},
	{"Rodeo",                       {72.60,-1684.60,-89.00,225.10,-1544.10,110.90}},
	{"Rodeo",                       {72.60,-1544.10,-89.00,225.10,-1404.90,110.90}},
	{"Rodeo",                       {225.10,-1684.60,-89.00,312.80,-1501.90,110.90}},
	{"Rodeo",                       {225.10,-1501.90,-89.00,334.50,-1369.60,110.90}},
	{"Rodeo",                       {334.50,-1501.90,-89.00,422.60,-1406.00,110.90}},
	{"Rodeo",                       {312.80,-1684.60,-89.00,422.60,-1501.90,110.90}},
	{"Rodeo",                       {422.60,-1684.60,-89.00,558.00,-1570.20,110.90}},
	{"Rodeo",                       {558.00,-1684.60,-89.00,647.50,-1384.90,110.90}},
	{"Rodeo",                       {466.20,-1570.20,-89.00,558.00,-1385.00,110.90}},
	{"Rodeo",                       {422.60,-1570.20,-89.00,466.20,-1406.00,110.90}},
	{"Rodeo",                       {466.20,-1385.00,-89.00,647.50,-1235.00,110.90}},
	{"Rodeo",                       {334.50,-1406.00,-89.00,466.20,-1292.00,110.90}},
	{"Royal Casino",                {2087.30,1383.20,-89.00,2437.30,1543.20,110.90}},
	{"San Andreas Sound",           {2450.30,385.50,-100.00,2759.20,562.30,200.00}},
	{"Santa Flora",                 {-2741.00,458.40,-7.60,-2533.00,793.40,200.00}},
	{"Santa Maria Beach",           {342.60,-2173.20,-89.00,647.70,-1684.60,110.90}},
	{"Santa Maria Beach",           {72.60,-2173.20,-89.00,342.60,-1684.60,110.90}},
	{"Shady Cabin",                 {-1632.80,-2263.40,-3.00,-1601.30,-2231.70,200.00}},
	{"Shady Creeks",                {-1820.60,-2643.60,-8.00,-1226.70,-1771.60,200.00}},
	{"Shady Creeks",                {-2030.10,-2174.80,-6.10,-1820.60,-1771.60,200.00}},
	{"Sobell Rail Yards",           {2749.90,1548.90,-89.00,2923.30,1937.20,110.90}},
	{"Spinybed",                    {2121.40,2663.10,-89.00,2498.20,2861.50,110.90}},
	{"Starfish Casino",             {2437.30,1783.20,-89.00,2685.10,2012.10,110.90}},
	{"Starfish Casino",             {2437.30,1858.10,-39.00,2495.00,1970.80,60.90}},
	{"Starfish Casino",             {2162.30,1883.20,-89.00,2437.30,2012.10,110.90}},
	{"Temple",                      {1252.30,-1130.80,-89.00,1378.30,-1026.30,110.90}},
	{"Temple",                      {1252.30,-1026.30,-89.00,1391.00,-926.90,110.90}},
	{"Temple",                      {1252.30,-926.90,-89.00,1357.00,-910.10,110.90}},
	{"Temple",                      {952.60,-1130.80,-89.00,1096.40,-937.10,110.90}},
	{"Temple",                      {1096.40,-1130.80,-89.00,1252.30,-1026.30,110.90}},
	{"Temple",                      {1096.40,-1026.30,-89.00,1252.30,-910.10,110.90}},
	{"The Camel's Toe",             {2087.30,1203.20,-89.00,2640.40,1383.20,110.90}},
	{"The Clown's Pocket",          {2162.30,1783.20,-89.00,2437.30,1883.20,110.90}},
	{"The Emerald Isle",            {2011.90,2202.70,-89.00,2237.40,2508.20,110.90}},
	{"The Farm",                    {-1209.60,-1317.10,114.90,-908.10,-787.30,251.90}},
	{"The Four Dragons Casino",     {1817.30,863.20,-89.00,2027.30,1083.20,110.90}},
	{"The High Roller",             {1817.30,1283.20,-89.00,2027.30,1469.20,110.90}},
	{"The Mako Span",               {1664.60,401.70,0.00,1785.10,567.20,200.00}},
	{"The Panopticon",              {-947.90,-304.30,-1.10,-319.60,327.00,200.00}},
	{"The Pink Swan",               {1817.30,1083.20,-89.00,2027.30,1283.20,110.90}},
	{"The Sherman Dam",             {-968.70,1929.40,-3.00,-481.10,2155.20,200.00}},
	{"The Strip",                   {2027.40,863.20,-89.00,2087.30,1703.20,110.90}},
	{"The Strip",                   {2106.70,1863.20,-89.00,2162.30,2202.70,110.90}},
	{"The Strip",                   {2027.40,1783.20,-89.00,2162.30,1863.20,110.90}},
	{"The Strip",                   {2027.40,1703.20,-89.00,2137.40,1783.20,110.90}},
	{"The Visage",                  {1817.30,1863.20,-89.00,2106.70,2011.80,110.90}},
	{"The Visage",                  {1817.30,1703.20,-89.00,2027.40,1863.20,110.90}},
	{"Unity Station",               {1692.60,-1971.80,-20.40,1812.60,-1932.80,79.50}},
	{"Valle Ocultado",              {-936.60,2611.40,2.00,-715.90,2847.90,200.00}},
	{"Verdant Bluffs",              {930.20,-2488.40,-89.00,1249.60,-2006.70,110.90}},
	{"Verdant Bluffs",              {1073.20,-2006.70,-89.00,1249.60,-1842.20,110.90}},
	{"Verdant Bluffs",              {1249.60,-2179.20,-89.00,1692.60,-1842.20,110.90}},
	{"Verdant Meadows",             {37.00,2337.10,-3.00,435.90,2677.90,200.00}},
	{"Verona Beach",                {647.70,-2173.20,-89.00,930.20,-1804.20,110.90}},
	{"Verona Beach",                {930.20,-2006.70,-89.00,1073.20,-1804.20,110.90}},
	{"Verona Beach",                {851.40,-1804.20,-89.00,1046.10,-1577.50,110.90}},
	{"Verona Beach",                {1161.50,-1722.20,-89.00,1323.90,-1577.50,110.90}},
	{"Verona Beach",                {1046.10,-1722.20,-89.00,1161.50,-1577.50,110.90}},
	{"Vinewood",                    {787.40,-1310.20,-89.00,952.60,-1130.80,110.90}},
	{"Vinewood",                    {787.40,-1130.80,-89.00,952.60,-954.60,110.90}},
	{"Vinewood",                    {647.50,-1227.20,-89.00,787.40,-1118.20,110.90}},
	{"Vinewood",                    {647.70,-1416.20,-89.00,787.40,-1227.20,110.90}},
	{"Whitewood Estates",           {883.30,1726.20,-89.00,1098.30,2507.20,110.90}},
	{"Whitewood Estates",           {1098.30,1726.20,-89.00,1197.30,2243.20,110.90}},
	{"Willowfield",                 {1970.60,-2179.20,-89.00,2089.00,-1852.80,110.90}},
	{"Willowfield",                 {2089.00,-2235.80,-89.00,2201.80,-1989.90,110.90}},
	{"Willowfield",                 {2089.00,-1989.90,-89.00,2324.00,-1852.80,110.90}},
	{"Willowfield",                 {2201.80,-2095.00,-89.00,2324.00,-1989.90,110.90}},
	{"Willowfield",                 {2541.70,-1941.40,-89.00,2703.50,-1852.80,110.90}},
	{"Willowfield",                 {2324.00,-2059.20,-89.00,2541.70,-1852.80,110.90}},
	{"Willowfield",                 {2541.70,-2059.20,-89.00,2703.50,-1941.40,110.90}},
	{"Yellow Bell Station",         {1377.40,2600.40,-21.90,1492.40,2687.30,78.00}},
	// Main Zones
	{"Los Santos",                  {44.60,-2892.90,-242.90,2997.00,-768.00,900.00}},
	{"Las Venturas",                {869.40,596.30,-242.90,2997.00,2993.80,900.00}},
	{"Bone County",                 {-480.50,596.30,-242.90,869.40,2993.80,900.00}},
	{"Tierra Robada",               {-2997.40,1659.60,-242.90,-480.50,2993.80,900.00}},
	{"Tierra Robada",               {-1213.90,596.30,-242.90,-480.50,1659.60,900.00}},
	{"San Fierro",                  {-2997.40,-1115.50,-242.90,-1213.90,1659.60,900.00}},
	{"Red County",                  {-1213.90,-768.00,-242.90,2997.00,596.30,900.00}},
	{"Flint County",                {-1213.90,-2892.90,-242.90,44.60,-768.00,900.00}},
	{"Whetstone",                   {-2997.40,-2892.90,-242.90,-1213.90,-1115.50,900.00}},
	{"San Andreas",                 {-10000.00,-10000.00,-242.90,10000.00,10000.00,900.00}},
	{"DOC", 						{400.00, 1355.0, 5950.00, 700.00, 1600.00, 12000.00}}
};


new const gMainZones[][MAIN_ZONES] = {  // Majority of names and area coordinates adopted from Mabako's 'Zones Script' v0.2
	{"Los Santos",                  {44.60,-2892.90,-242.90,2997.00,-768.00,900.00}},
	{"Las Venturas",                {869.40,596.30,-242.90,2997.00,2993.80,900.00}},
	{"Bone County",                 {-480.50,596.30,-242.90,869.40,2993.80,900.00}},
	{"Tierra Robada",               {-2997.40,1659.60,-242.90,-480.50,2993.80,900.00}},
	{"Tierra Robada",               {-1213.90,596.30,-242.90,-480.50,1659.60,900.00}},
	{"San Fierro",                  {-2997.40,-1115.50,-242.90,-1213.90,1659.60,900.00}},
	{"Red County",                  {-1213.90,-768.00,-242.90,2997.00,596.30,900.00}},
	{"Flint County",                {-1213.90,-2892.90,-242.90,44.60,-768.00,900.00}},
	{"Whetstone",                   {-2997.40,-2892.90,-242.90,-1213.90,-1115.50,900.00}},
	{"San Andreas",                 {-10000.00,-10000.00,-242.90,10000.00,10000.00,900.00}}
};

stock GetPlayer2DZone(playerid, zone[], len) //Credits to Cueball, Betamaster, Mabako, and Simon (for finetuning).
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i != sizeof(gSAZones); i++ )
 	{
		if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4])
		{
		    return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}

stock GetPlayer2DTurf(playerid) //Jingles
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i < sizeof(gSAZones); ++i)
 	{
		if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4])
		{
		    return i;
		}
	}
	return 369;
}

stock GetPlayer3DZone(playerid, zone[], len) //Credits to Cueball, Betamaster, Mabako, and Simon (for finetuning).
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i != sizeof(gSAZones); i++ )
 	{
		if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4] && z >= gSAZones[i][SAZONE_AREA][2] && z <= gSAZones[i][SAZONE_AREA][5])
		{
		    return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}

stock Get3DZone(Float:x, Float:y, Float:z, zone[], len) //Credits to Cueball, Betamaster, Mabako, and Simon (for finetuning).
{
 	for(new i = 0; i != sizeof(gSAZones); i++ )
 	{
		if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4] && z >= gSAZones[i][SAZONE_AREA][2] && z <= gSAZones[i][SAZONE_AREA][5])
		{
		    return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}

stock IsPlayerInZone(playerid, zone[]) //Credits to Cueball, Betamaster, Mabako, and Simon (for finetuning).
{
	new TmpZone[MAX_ZONE_NAME];
	GetPlayer3DZone(playerid, TmpZone, sizeof(TmpZone));
	for(new i = 0; i != sizeof(gSAZones); i++)
	{
		if(strfind(TmpZone, zone, true) != -1)
			return 1;
	}
	return 0;
}

stock GetPlayerMainZone(playerid, zone[], len)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i != sizeof(gMainZones); i++ )
 	{
		if(x >= gMainZones[i][SAZONE_AREA][0] && x <= gMainZones[i][SAZONE_AREA][3] && y >= gMainZones[i][SAZONE_AREA][1] && y <= gMainZones[i][SAZONE_AREA][4])
		{
		    return format(zone, len, gMainZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}

stock Get2DMainZone(Float:x, Float:y, zone[], len)
{
 	for(new i = 0; i != sizeof(gMainZones); i++ )
 	{
		if(x >= gMainZones[i][SAZONE_AREA][0] && x <= gMainZones[i][SAZONE_AREA][3] && y >= gMainZones[i][SAZONE_AREA][1] && y <= gMainZones[i][SAZONE_AREA][4])
		{
		    return format(zone, len, gMainZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}

new Float:lpRandomLocations[10][3] = {
	{2867.5901,2573.4387,10.8203},
	{-1552.5514,119.2396,3.2238},
	{1743.3508,720.1166,10.8154},
	{2616.8364,-2226.5535,13.3828},
	{-1582.0787,1274.2910,6.8461},
	{-1512.6736,1274.1342,6.8469},
	{-1731.8909,1525.9912,6.8558},
	{-1731.6244,1503.1536,6.8568},
	{-2712.7786,216.4535,3.9102},
	{-2404.3477,-39.8431,34.9892}
};

// hospital spawn definitions
new Float:HospitalSpawns[MAX_HOSPITALBEDS][3] = {
{2393.7598,2655.1035,8001.9000},
{2393.9106,2648.8225,8001.9000},
{2393.8643,2642.1689,8001.9000},
{2383.0505,2641.9795,8001.9000},
{2383.0393,2648.7996,8001.9000},
{2381.5735,2648.4666,8001.9000},
{2381.7429,2642.1787,8001.9000},
{2370.7402,2642.2292,8001.9000},
{2370.9053,2648.5198,8001.9000},
{2370.7998,2654.7639,8001.9000}
};

new Float:DocHospitalSpawns[MAX_DOCHOSPITALBEDS][4] = {
{566.27, 1431.32, 6001.25,0.0},
{568.71, 1431.32, 6001.2500,0.0},
{571.16, 1431.32,6001.2500,0.0}
};

// format [PosX] [PosY] [PosZ]
new Float:HospitalDeliveryPoints[MAX_DELIVERY_POINTS][3] = {
	{1142.4733,-1326.3633,13.6259},
	{1165.1564,-1368.8240,26.6502},
	{2027.0599,-1410.6870,16.9922},
	{2024.5742,-1382.7844,48.3359},
	{1227.2339,306.4730,19.7028},
	{1233.3384,316.4022,24.7578},
	{-339.2989,1055.8138,19.7392},
	{-334.1560,1051.4434,26.0125},
	{-2695.5725,639.4147,14.4531},
	{-2656.0339,615.2567,66.0938},
	{-1528.814331, 2540.706054, 55.835937},
	{-552.8751, -1020.0660, 24.0724},//Flint Ground
	{3001.2070, -2528.8562, 13.6845},
	{1579.58, 1768.88, 10.82},
	{-2196.9641,-2303.8191,30.6250},
	{-2043.2212,-198.8035,15.0703},
	{2986.0796, -2514.1423, 33.1061},
	{-1506.1542,442.8032,42.3125},
	{2370.19434, -140.55753, 35.99259},
	{2386.92969, -142.99750, 28.31969},
	{1606.2567, 1769.2424, 37.3125},
	{-579.727905, -1031.585083, 35.166545} //Flint Rooftop
};

/*new HospitalDeliveryPointsInfo[MAX_DELIVERY_POINTS] = {
{HOSPITAL_ALLSAINTS},
{HOSPITAL_ALLSAINTS},
{HOSPITAL_COUNTYGEN},
{HOSPITAL_COUNTYGEN},
{HOSPITAL_REDCOUNTY},
{HOSPITAL_REDCOUNTY},
{HOSPITAL_FORTCARSON},
{HOSPITAL_FORTCARSON},
{HOSPITAL_SANFIERRO},
{HOSPITAL_SANFIERRO},
{HOSPITAL_ELQUEBRADOS},
{HOSPITAL_FLINT},
{HOSPITAL_DEMORGAN},
{HOSPITAL_LASVENTURAS},
{0},
{0}
};*/

// 1D - Hospital Spawn Price 2D - insurance purchase price
// edit to however you like
new HospitalSpawnInfo[MAX_HOSPITALS][2] = {
{3000,2500},
{3000,2500},
{2000,2500},
{3000,2500},
{3000,2500},
{1000,2500},
{1000,2500},
{3000,2500},
{3000,2500},
{1000,2500},
{1000,2500},
{1000,2500},
{1000,2500},
{1000,2500},
{1000,2500},
{1000,2500},
{1000,2500},
{1000,2500}
};

new arrHospitalBedData[MAX_HOSPITALS][eHospitalBedData];

new PlayerText:HospTime[MAX_PLAYERS];

new gPlayerUsingLoopingAnim[MAX_PLAYERS];
new gPlayerAnimLibsPreloaded[MAX_PLAYERS];

new Text:txtAnimHelper;

new bool:PlayerIsDead[MAX_PLAYERS];

/* Buttons */


new eastin, eastout, lockerin, lockerout, cctvin, cctvout, roofkey, elevator, garagekey, chiefout, chiefin, westin, westout;
new eastlobby1, eastlobby2, westlobby1, westlobby2, cctv1, cctv2, locker1, locker2, chief1, chief2, sasdbtn1, sasdbtn2, sasdbtn3, sasdbtn4, sasdbtn5, sasd1A, sasd2A, sasd3A, sasd4A, sasd5A, sasd1B, sasd2B, sasd3B, sasd4B, sasd5B;
new FBILobbyLeft, FBILobbyLeftBTN[2], FBILobbyRight, FBILobbyRightBTN[2], FBIPrivate[2], FBIPrivateBTN[2];
new DocButton[19];
new DocCPButton[2];
new SFPDHighCMDButton[3], SFPDHighCMDDoor[3], SFPDLobbyButton[2], SFPDLobbyDoor[2];
new SASDButtons[4], SASDDoors[2]; // New SASD interior vars.

new bool:emailcheck = true;

new AdTracking[MAX_PLAYERS];
new HouseMarketTracking[MAX_PLAYERS];

new DDSalePrice[MAX_PLAYERS];
new DDSaleTarget[MAX_PLAYERS];
new DDSaleTracking[MAX_PLAYERS];
new DDSaleDoors[MAX_PLAYERS][7];
new Timer:DDSaleTimer[MAX_PLAYERS];
new bool:DDSalePendingAdmin[MAX_PLAYERS];
new bool:DDSalePendingPlayer[MAX_PLAYERS];

new GunPrices[7];
new JobName[MAX_JOBTYPES][32];

new PlayerText:phone_PTextDraw[MAX_PLAYERS][24];


/* AC */
new iLastDialogID[MAX_PLAYERS];

/* Areas */
new iVehEnterAreaID[MAX_VEHICLES];
new iVehExits[3]; // for shamal, nevada and journey

/* Iterators - More efficient looping for changing/dynamic structures */
new Iterator:Vehicles<MAX_VEHICLES>;
new Iterator:GangTags<MAX_GANGTAGS>;

new const szFonts[][] = {
	"Arial",
	"Impact",
	"Bombing",
	"Real Chinese",
	"Los Santos",
	"Urban Riot",
	"Black Jack",
	"Gangland",
	"WildStyle",
	"Spray Day",
	"Bonzai Grande",
	"Big Daddy",
	"Amsterdam Graffiti"
};



new szFurnitureCategories[][] = {
	"Bathroom",
	"Comfort",
	"Doors",
	"Household",
	"Lights",
	"Miscellaneous",
	"Office",
	"Ornaments",
	"Plants",
	"Recreation",
	"Storage",
	"Tables",
	"Walls",
	"VIP"
};

new Text:Furniture_TD[29],
	PlayerText:Furniture_PTD[MAX_PLAYERS][4];

new iErrorID;

/*
Robbery System
new ROB_MAX_PERCENTAGE = 30,
	ROB_COLLECT_RATE = 5000,
	ROB_MIN_MEMBERS = 1;
*/

//new Text3D:PlayerLabel[MAX_PLAYERS];

new DCC_Channel:g_AdminChannelId, DCC_Channel:g_AdminWarningsChannelId, DCC_Channel:g_HeadAdminChannelId, DCC_Channel:g_ServerErrorsChannelId;

// Crate System.
new 
	CarryCrate[MAX_PLAYERS],
	BeingMoved[MAX_CRATES],
	AdminOpened[MAX_CRATE_FACILITY];

new
	IsDoingAnim[MAX_PLAYERS],
	GhostHacker[MAX_PLAYERS][7];

new
	bool:BuddyInvite = true;