InitiateGamemode()
{
	AddPlayerClass(0, 1715.1201, -1903.1711, 13.5665, 360, 0, 0, 0, 0, 0, 0);
	
	SetGameModeText(SERVER_GM_TEXT);
    
	// MySQL
    g_mysql_LoadMOTD();
 	g_mysql_AccountOnlineReset();
	g_mysql_LoadGiftBox();
 	mysql_LoadCrates();
	LoadHouses();
	LoadDynamicDoors();
	LoadDynamicMapIcons();
	LoadMailboxes();
	LoadBusinesses();
	LoadAuctions();
	LoadTxtLabels();
	LoadPlants();
	LoadSpeedCameras();
	LoadPayNSprays();
	LoadArrestPoints();
	LoadImpoundPoints();
	LoadRelayForLifeTeams();
	LoadGarages();
	LoadCrimes();
		/*---[Shop Automation]---*/
	
 	g_mysql_LoadSales();
 	g_mysql_LoadPrices();
 	LoadBusinessSales();
 	ToyList = LoadModelSelectionMenu("ToyList.txt");
	CarList = LoadModelSelectionMenu("CarList.txt");
	PlaneList = LoadModelSelectionMenu("PlaneList.txt");
	BoatList = LoadModelSelectionMenu("BoatList.txt");
	ToyList2 = LoadModelSelectionMenu("ToyList.txt");
	CarList2 = LoadModelSelectionMenu("CarList.txt");
	CarList3 = LoadModelSelectionMenu("RestrictedCarList.txt");
	SkinList = LoadModelSelectionMenu("SkinList.txt");
	
	/*---[Miscs]---*/
	NGGShop = CreateDynamicPolygon(shop_vertices);
	InitTurfWars();
	LoadTurfWars();
	InitPaintballArenas();
	LoadPaintballArenas();
	InitEventPoints();
	LoadEventPoints();
	LoadGates();
	LoadElevatorStuff();
	LoadPoints();
	ClearCalls();
	//LoadHelp();
	Misc_Load();
	InitPokerTables();
	ResetElevatorQueue();
	Elevator_Initialize();
	AntiDeAMX();
	EnableStuntBonusForAll(0);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	DisableInteriorEnterExits();
	ClearReports();
	NationSel_InitTextDraws();
	CountCitizens();
	SetNameTagDrawDistance(40.0);
	AllowInteriorWeapons(1);
	UsePlayerPedAnims();
	ManualVehicleEngineAndLights();
	GiftAllowed = 1;
	ResetNews();
	ResetVariables();
	FixServerTime();
	LoadVactionsHelper();
	SetTimer("RotateWheel",3*1000,0);
	SetTimer("WarmupLock", 15000, 0);
	SetTimer("MailDeliveryTimer", 60000, 1);
	//SetTimer("SyncTurfWarsMiniMap", 2500, 1);
	SetTimer("Anti_Rapidfire", 1000, true);
	SetTimer("OnEnterFire", 1000, true);
	
	//Island for crate system
    MAXCRATES = 10; // Sets Default Max Crates
	
	//LoadCarrier()
	//SelectCharmPoint();
	
	gWeather = random(19) + 1;
	if(gWeather == 1) gWeather=10;
	SetWeather(gWeather);
    
    // Streamer
    Streamer_TickRate(100);
    print("[Streamer] Loading Dynamic Static Vehicles...");
    LoadStreamerStaticVehicles();
    print("[Streamer] Loading Dynamic Pickups...");
    LoadStreamerDynamicPickups();
    print("[Streamer] Loading 3D Text Labels...");
    LoadStreamerDynamic3DTextLabels();
    UpdateSANewsBroadcast();
    print("[Streamer] Loading Dynamic Buttons...");
    LoadStreamerDynamicButtons();
    print("[Streamer] Loading Dynamic Objects...");
    LoadStreamerDynamicObjects();
    BikeParkourObjectStage[0] = 0; //BikeParkourObjectStage[1] = 0;
    
    // Textdraws
    print("[Textdraws] Loading Textdraws...");
    LoadTextDraws();
    
    // Dynamic Groups
    print("[Dynamic Groups] Loading Dynamic Groups...");
    LoadDynamicGroups();
    print("[Dynamic Groups] Loading Dynamic Groups Vehicles...");
    LoadDynamicGroupVehicles();
	
	print("\n-------------------------------------------");
	print("Next Generation Roleplay\n");
	print("Copyright (C) Next Generation Gaming, LLC (2010-2014)");
	print("All Rights Reserved");
	print("-------------------------------------------\n");
	print("Successfully initiated the gamemode...");
	return 1;
}		