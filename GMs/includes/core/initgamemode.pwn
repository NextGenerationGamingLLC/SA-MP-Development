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
	LoadSpeedCameras();
	LoadPayNSprays();
	LoadArrestPoints();
	LoadImpoundPoints();
	LoadRelayForLifeTeams();
	LoadGarages();
	LoadCrimes();
	LoadGCrates();

	//loadSafes(); 
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
	InitPaintballArenas();
	LoadPaintballArenas();
	InitEventPoints();
	LoadEventPoints();
	LoadGates();
	LoadElevatorStuff();
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
	//NationSel_InitTextDraws();
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
	RotateWheel();

	LoadParkingMeters();
	GovGuns_LoadCosts();
	MetDet_LoadMetDets();
	LoadATMPoints();
	LoadBanks();
	LoadPayPhones();
	
	//Island for crate system
    MAXCRATES = 0; // Sets Default Max Crates
	
	//LoadCarrier()
	//SelectCharmPoint();
	
	gWeather = random(19) + 1;
	if(gWeather == 1 || gWeather == 8 || gWeather == 9) gWeather=10;
	SetWeather(gWeather);
    
    // Streamer
    Streamer_TickRate(100);
    
    BikeParkourObjectStage[0] = 0; //BikeParkourObjectStage[1] = 0;
    
    // Textdraws
    print("[Textdraws] Loading Textdraws...");
    LoadTextDraws();
    
    // Dynamic Groups
    print("[Dynamic Groups] Loading Dynamic Groups...");
    LoadDynamicGroups();
    print("[Dynamic Groups] Loading Dynamic Groups Vehicles...");
    LoadDynamicGroupVehicles();

    Job_LoadJobs();
    GangTag_Load();
    DS_LoadDrugSystem();

    TurfWars_LoadData();

    // Bank_LoadBank();
    LoadFurniture();
    FurnitureListInit();

	print("\n-------------------------------------------");
	print("Next Generation Roleplay\n");
	print("Copyright (C) Next Generation Gaming, LLC (2010-2014)");
	print("All Rights Reserved");
	print("-------------------------------------------\n");
	print("Successfully initiated the gamemode...");
	return 1;
}		