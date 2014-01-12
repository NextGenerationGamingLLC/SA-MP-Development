#include <a_samp>
#include <djson>
#include <streamer>

/*

    Car Ownership/Dealership
- Make sure you have the includes to compile and latest versions.
- You need to create a folder in your scriptfiles named playervehicles.
- You need the cardealerships.json file in your scriptfiles folder. ( Check SFs )
- For admin commands only admin rcon. (/createdealership /destroydealership /createpvehicle /destroypvehicle)

*/

#define DIALOG_CDEDIT 1329
#define DIALOG_CDUPGRADE 1328
#define DIALOG_CDTILL 1327
#define DIALOG_CDEDITCARS 1326
#define DIALOG_CDEDITONE 1325
#define DIALOG_CDEDITMODEL 1324
#define DIALOG_CDEDITCOST 1323
#define DIALOG_CDEDITPARK 1322
#define DIALOG_CDDELVEH 1321
#define DIALOG_CDNEWVEH 1320
#define DIALOG_CDRADIUS 1319
#define DIALOG_CDNAME 1318
#define DIALOG_CDPRICE 1317
#define DIALOG_CDBUY 1316
#define DIALOG_CDWITHDRAW 1315
#define DIALOG_CDDEPOSIT 1314
#define DIALOG_CDSELL 1313
#define DIALOG_CDLOCKBUY 1312
#define DIALOG_CDLOCKMENU 1311

#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_PURPLE 0xC2A2DAAA

/* PLAYER VEHICLE DEFINES */
#define MAX_PLAYERVEHICLES 5
#define MAX_MODS 15
#define INVALID_PLAYER_VEHICLE_ID 0
#define MAX_DEALERSHIPVEHICLES 10
#define MAX_CARDEALERSHIPS 10

forward LoadcDealerships();
forward SavecDealership(id);
forward PlayerPlayMusic(playerid);
forward StopMusic();
forward OnPlayerVehicleUpdate(playerid);
forward OnPlayerVehicleLogin(playerid);
forward LockPlayerVehicle(ownerid, carid, type);
forward UnLockPlayerVehicle(ownerid, carid, type);
forward Random(min, max);
forward IsAt247(playerid);
forward MeepMeep(playerid, vehicleid);
forward PutPlayerInVeh(playerid, vehicleid);
forward ReleasePlayer(playerid);
forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);

new meepmeep[MAX_VEHICLES];

enum pvInfo
{
    Float:pvPosX,
	Float:pvPosY,
	Float:pvPosZ,
	Float:pvPosAngle,
	pvId,
	pvModelId,
	pvLock,
	pvLocked,
	pvPaintJob,
	pvColor1,
	pvColor2,
	pvMods[MAX_MODS],
	pvAllowPlayer[MAX_PLAYER_NAME],
	pvPark,
};
new PlayerVehicleInfo[MAX_PLAYERS][MAX_PLAYERVEHICLES][pvInfo];

enum cdInfo
{
	cdOwned,
	cdOwner[MAX_PLAYER_NAME],
	Float: cdEntranceX,
	Float: cdEntranceY,
	Float: cdEntranceZ,
	Float: cdExitX,
	Float: cdExitY,
	Float: cdExitZ,
	cdMessage[128],
	cdTill,
	cdInterior,
	Float: cdRadius,
	cdPrice,
	cdPickupID,
	Text3D:cdTextLabel,
	Text3D:cdVehicleLabel[MAX_DEALERSHIPVEHICLES],
	cdVehicleModel[MAX_DEALERSHIPVEHICLES],
	cdVehicleCost[MAX_DEALERSHIPVEHICLES],
	cdVehicleId[MAX_DEALERSHIPVEHICLES],
	Float: cdVehicleSpawnX[MAX_DEALERSHIPVEHICLES],
	Float: cdVehicleSpawnY[MAX_DEALERSHIPVEHICLES],
	Float: cdVehicleSpawnZ[MAX_DEALERSHIPVEHICLES],
	Float: cdVehicleSpawnAngle[MAX_DEALERSHIPVEHICLES],
	Float: cdVehicleSpawn[4],
};
new CarDealershipInfo[MAX_CARDEALERSHIPS][cdInfo];

new VehicleName[][] = {
   "Landstalker",
   "Bravura",
   "Buffalo",
   "Linerunner",
   "Pereniel",
   "Sentinel",
   "Dumper",
   "Firetruck",
   "Trashmaster",
   "Stretch",
   "Manana",
   "Infernus",
   "Voodoo",
   "Pony",
   "Mule",
   "Cheetah",
   "Ambulance",
   "Leviathan",
   "Moonbeam",
   "Esperanto",
   "Taxi",
   "Washington",
   "Bobcat",
   "Mr Whoopee",
   "BF Injection",
   "Hunter",
   "Premier",
   "Enforcer",
   "Securicar",
   "Banshee",
   "Predator",
   "Bus",
   "Rhino",
   "Barracks",
   "Hotknife",
   "Trailer",
   "Previon",
   "Coach",
   "Cabbie",
   "Stallion",
   "Rumpo",
   "RC Bandit",
   "Romero",
   "Packer",
   "Monster Truck",
   "Admiral",
   "Squalo",
   "Seasparrow",
   "Pizzaboy",
   "Tram",
   "Trailer",
   "Turismo",
   "Speeder",
   "Reefer",
   "Tropic",
   "Flatbed",
   "Yankee",
   "Caddy",
   "Solair",
   "Berkley's RC Van",
   "Skimmer",
   "PCJ-600",
   "Faggio",
   "Freeway",
   "RC Baron",
   "RC Raider",
   "Glendale",
   "Oceanic",
   "Sanchez",
   "Sparrow",
   "Patriot",
   "Quad",
   "Coastguard",
   "Dinghy",
   "Hermes",
   "Sabre",
   "Rustler",
   "ZR-350",
   "Walton",
   "Regina",
   "Comet",
   "BMX",
   "Burrito",
   "Camper",
   "Marquis",
   "Baggage",
   "Dozer",
   "Maverick",
   "News Chopper",
   "Rancher",
   "FBI Rancher",
   "Virgo",
   "Greenwood",
   "Jetmax",
   "Hotring",
   "Sandking",
   "Blista Compact",
   "Police Maverick",
   "Boxville",
   "Benson",
   "Mesa",
   "RC Goblin",
   "Hotring Racer",
   "Hotring Racer",
   "Bloodring Banger",
   "Rancher",
   "Super GT",
   "Elegant",
   "Journey",
   "Bike",
   "Mountain Bike",
   "Beagle",
   "Cropdust",
   "Stunt",
   "Tanker",
   "RoadTrain",
   "Nebula",
   "Majestic",
   "Buccaneer",
   "Shamal",
   "Hydra",
   "FCR-900",
   "NRG-500",
   "HPV1000",
   "Cement Truck",
   "Tow Truck",
   "Fortune",
   "Cadrona",
   "FBI Truck",
   "Willard",
   "Forklift",
   "Tractor",
   "Combine",
   "Feltzer",
   "Remington",
   "Slamvan",
   "Blade",
   "Freight",
   "Streak",
   "Vortex",
   "Vincent",
   "Bullet",
   "Clover",
   "Sadler",
   "Firetruck",
   "Hustler",
   "Intruder",
   "Primo",
   "Cargobob",
   "Tampa",
   "Sunrise",
   "Merit",
   "Utility",
   "Nevada",
   "Yosemite",
   "Windsor",
   "Monster Truck",
   "Monster Truck",
   "Uranus",
   "Jester",
   "Sultan",
   "Stratum",
   "Elegy",
   "Raindance",
   "RC Tiger",
   "Flash",
   "Tahoma",
   "Savanna",
   "Bandito",
   "Freight",
   "Trailer",
   "Kart",
   "Mower",
   "Duneride",
   "Sweeper",
   "Broadway",
   "Tornado",
   "AT-400",
   "DFT-30",
   "Huntley",
   "Stafford",
   "BF-400",
   "Newsvan",
   "Tug",
   "Trailer",
   "Emperor",
   "Wayfarer",
   "Euros",
   "Hotdog",
   "Club",
   "Trailer",
   "Trailer",
   "Andromada",
   "Dodo",
   "RC Cam",
   "Launch",
   "Police Car (LSPD)",
   "Police Car (SFPD)",
   "Police Car (LVPD)",
   "Police Ranger",
   "Picador",
   "S.W.A.T. Van",
   "Alpha",
   "Phoenix",
   "Glendale",
   "Sadler",
   "Luggage Trailer",
   "Luggage Trailer",
   "Stair Trailer",
   "Boxville",
   "Farm Plow",
   "Utility Trailer"
};

public OnFilterScriptInit()
{
	print("Debug 1");
    djson_GameModeInit();
    print("Debug 2");
    LoadcDealerships();
    print("Debug 3");
    new text_info[128];
	for(new d = 0; d < sizeof(CarDealershipInfo); d++)
	{
		if(CarDealershipInfo[d][cdEntranceX] != 0.0 && CarDealershipInfo[d][cdEntranceY] != 0.0)
		{
			CarDealershipInfo[d][cdPickupID] = CreateDynamicPickup(1239, 1, CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]);
			if(CarDealershipInfo[d][cdOwned])
			{
	            format(text_info,256,"Car Dealership %s\nOwner: %s\nRadius: %.1f", CarDealershipInfo[d][cdMessage], CarDealershipInfo[d][cdOwner], CarDealershipInfo[d][cdRadius]);
	            CarDealershipInfo[d][cdTextLabel] = CreateDynamic3DTextLabel(text_info,COLOR_GREEN,CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]+0.75,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1);
			}
			else
			{
	            format(text_info,256,"Car Dealership %s For Sale\nPrice: %d\nRadius: %.1f", CarDealershipInfo[d][cdMessage], CarDealershipInfo[d][cdPrice], CarDealershipInfo[d][cdRadius]);
	            CarDealershipInfo[d][cdTextLabel] = CreateDynamic3DTextLabel(text_info,COLOR_RED,CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]+0.75,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1);
			}
		}
		for(new v = 0; v < MAX_DEALERSHIPVEHICLES; v++)
	    {
			if (CarDealershipInfo[d][cdVehicleModel][v] != 0)
			{
		        new carcreated = CreateVehicle(CarDealershipInfo[d][cdVehicleModel][v], CarDealershipInfo[d][cdVehicleSpawnX][v], CarDealershipInfo[d][cdVehicleSpawnY][v], CarDealershipInfo[d][cdVehicleSpawnZ][v], CarDealershipInfo[d][cdVehicleSpawnAngle][v], 0, 0, 6);
		        format(text_info,256,"%s For Sale | Price: %d", GetVehicleName(carcreated), CarDealershipInfo[d][cdVehicleCost][v]);
                CarDealershipInfo[d][cdVehicleLabel][v] = CreateDynamic3DTextLabel(text_info,COLOR_LIGHTBLUE,0.0, 0.0, 0.0,8.0,INVALID_PLAYER_ID,carcreated);
                CarDealershipInfo[d][cdVehicleId][v] = carcreated;
			}
		}
	}
	print("Car System loaded.");
    return 1;
}

stock ini_GetKey( line[] )
{
	new keyRes[256];
	keyRes[0] = 0;
    if ( strfind( line , "=" , true ) == -1 ) return keyRes;
    strmid( keyRes , line , 0 , strfind( line , "=" , true ) , sizeof( keyRes) );
    return keyRes;
}

stock ini_GetValue( line[] )
{
	new valRes[256];
	valRes[0]=0;
	if ( strfind( line , "=" , true ) == -1 ) return valRes;
	strmid( valRes , line , strfind( line , "=" , true )+1 , strlen( line ) , sizeof( valRes ) );
	return valRes;
}

public Random(min, max)
{
    new a = random(max - min) + min;
    return a;
}

public IsAt247(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new GVW;
		GVW = GetPlayerVirtualWorld(playerid);
		if(IsPlayerInRangeOfPoint(playerid, 100.0, -30.875, -88.9609, 1004.53))
		{
		    return 1;
		}
		if(GVW == 2)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 100.0, 349.9702,177.8098,1014.1875))
		    {
		        return 1;
			}
		}
	}
	return 0;
}

public ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
					new playerworld, player2world;
					playerworld = GetPlayerVirtualWorld(playerid);
					player2world = GetPlayerVirtualWorld(i);
					if(playerworld == player2world)
					{
						if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
						{
							SendClientMessage(i, col1, string);
						}
						else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
						{
							SendClientMessage(i, col2, string);
						}
						else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
						{
							SendClientMessage(i, col3, string);
						}
						else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
						{
							SendClientMessage(i, col4, string);
						}
						else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
						{
							SendClientMessage(i, col5, string);
						}
					}
				}
				else
				{
					SendClientMessage(i, col1, string);
				}
		}
	}//not connected
	return 1;
}

public LoadcDealerships()
{
	new idx, idx2;
	new string[128];
	new owner[MAX_PLAYER_NAME];
	new message[128];
	djAutocommit(false);
	while (idx < sizeof(CarDealershipInfo))
	{
        format(string, sizeof(string), "%d/owned", idx);
		CarDealershipInfo[idx][cdOwned] = djInt("cardealerships.json", string);
		format(string, sizeof(string), "%d/owner", idx);
		format(owner, sizeof(owner), "%s", dj("cardealerships.json", string));
		strmid(CarDealershipInfo[idx][cdOwner], owner, 0, strlen(owner), 255);
		format(string, sizeof(string), "%d/entrance/x", idx);
		CarDealershipInfo[idx][cdEntranceX] = djFloat("cardealerships.json", string);
		format(string, sizeof(string), "%d/entrance/y", idx);
		CarDealershipInfo[idx][cdEntranceY] = djFloat("cardealerships.json", string);
		format(string, sizeof(string), "%d/entrance/z", idx);
		CarDealershipInfo[idx][cdEntranceZ] = djFloat("cardealerships.json", string);
		format(string, sizeof(string), "%d/exit/x", idx);
		CarDealershipInfo[idx][cdExitX] = djFloat("cardealerships.json", string);
		format(string, sizeof(string), "%d/exit/y", idx);
		CarDealershipInfo[idx][cdExitY] = djFloat("cardealerships.json", string);
		format(string, sizeof(string), "%d/exit/z", idx);
	    CarDealershipInfo[idx][cdExitZ] = djFloat("cardealerships.json", string);
	    format(string, sizeof(string), "%d/message", idx);
		format(message, sizeof(message), "%s", dj("cardealerships.json", string));
		strmid(CarDealershipInfo[idx][cdMessage], message, 0, strlen(message), 255);
		format(string, sizeof(string), "%d/till", idx);
		CarDealershipInfo[idx][cdTill] = djInt("cardealerships.json", string);
		format(string, sizeof(string), "%d/interior", idx);
		CarDealershipInfo[idx][cdInterior] = djInt("cardealerships.json", string);
		format(string, sizeof(string), "%d/vehiclespawn/x", idx);
		CarDealershipInfo[idx][cdVehicleSpawn][0] = djFloat("cardealerships.json", string);
		format(string, sizeof(string), "%d/vehiclespawn/y", idx);
		CarDealershipInfo[idx][cdVehicleSpawn][1] = djFloat("cardealerships.json", string);
		format(string, sizeof(string), "%d/vehiclespawn/z", idx);
		CarDealershipInfo[idx][cdVehicleSpawn][2] = djFloat("cardealerships.json", string);
		format(string, sizeof(string), "%d/vehiclespawn/a", idx);
		CarDealershipInfo[idx][cdVehicleSpawn][3] = djFloat("cardealerships.json", string);
		format(string, sizeof(string), "%d/radius", idx);
		CarDealershipInfo[idx][cdRadius] = djFloat("cardealerships.json", string);
		format(string, sizeof(string), "%d/price", idx);
		CarDealershipInfo[idx][cdPrice] = djInt("cardealerships.json", string);
		while (idx2 < MAX_DEALERSHIPVEHICLES)
		{
            format(string, sizeof(string), "%d/vehicleangle/%d", idx, idx2);
		    CarDealershipInfo[idx][cdVehicleSpawnAngle][idx2] = djFloat("cardealerships.json", string);
		    format(string, sizeof(string), "%d/vehiclespawnx/%d", idx, idx2);
		    CarDealershipInfo[idx][cdVehicleSpawnX][idx2] = djFloat("cardealerships.json", string);
		    format(string, sizeof(string), "%d/vehiclespawny/%d", idx, idx2);
		    CarDealershipInfo[idx][cdVehicleSpawnY][idx2] = djFloat("cardealerships.json", string);
		    format(string, sizeof(string), "%d/vehiclespawnz/%d", idx, idx2);
		    CarDealershipInfo[idx][cdVehicleSpawnZ][idx2] = djFloat("cardealerships.json", string);
		    format(string, sizeof(string), "%d/vehiclecost/%d", idx, idx2);
		    CarDealershipInfo[idx][cdVehicleCost][idx2] = djInt("cardealerships.json", string);
		    format(string, sizeof(string), "%d/vehicletypes/%d", idx, idx2);
		    CarDealershipInfo[idx][cdVehicleModel][idx2] = djInt("cardealerships.json", string);
		    printf("VehicleId:%d VehicleAngle:%.1f VehicleCost:%d.",
			    idx2,
			    CarDealershipInfo[idx][cdVehicleSpawnAngle][idx2],
			    CarDealershipInfo[idx][cdVehicleCost][idx2]);
		    idx2++;
		}
		idx2 = 0;
		idx++;
	}
	djAutocommit(true);
	return 1;
}

public SavecDealership(id)
{
	new idx2;
	new string[128];
	printf("Saving Car Dealership %d.", id);
	//djAutocommit(false);
    format(string, sizeof(string), "%d/owned", id);
	djSetInt("cardealerships.json", string, CarDealershipInfo[id][cdOwned]);
	format(string, sizeof(string), "%d/owner", id);
	djSet("cardealerships.json", string, CarDealershipInfo[id][cdOwner]);
	format(string, sizeof(string), "%d/entrance/x", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdEntranceX]);
	format(string, sizeof(string), "%d/entrance/y", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdEntranceY]);
	format(string, sizeof(string), "%d/entrance/z", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdEntranceZ]);
	format(string, sizeof(string), "%d/exit/x", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdExitX]);
	format(string, sizeof(string), "%d/exit/y", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdExitY]);
	format(string, sizeof(string), "%d/exit/z", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdExitZ]);
	format(string, sizeof(string), "%d/message", id);
	djSet("cardealerships.json", string, CarDealershipInfo[id][cdMessage]);
	format(string, sizeof(string), "%d/till", id);
	djSetInt("cardealerships.json", string, CarDealershipInfo[id][cdTill]);
	format(string, sizeof(string), "%d/interior", id);
	djSetInt("cardealerships.json", string, CarDealershipInfo[id][cdInterior]);
	format(string, sizeof(string), "%d/vehiclespawn/x", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdVehicleSpawn][0]);
	format(string, sizeof(string), "%d/vehiclespawn/y", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdVehicleSpawn][1]);
	format(string, sizeof(string), "%d/vehiclespawn/z", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdVehicleSpawn][2]);
	format(string, sizeof(string), "%d/vehiclespawn/a", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdVehicleSpawn][3]);
	format(string, sizeof(string), "%d/radius", id);
	djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdRadius]);
	format(string, sizeof(string), "%d/price", id);
	djSetInt("cardealerships.json", string, CarDealershipInfo[id][cdPrice]);
	while (idx2 < MAX_DEALERSHIPVEHICLES)
	{
        format(string, sizeof(string), "%d/vehicleangle/%d", id, idx2);
        djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdVehicleSpawnAngle][idx2]);
	    format(string, sizeof(string), "%d/vehiclespawnx/%d", id, idx2);
	    djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdVehicleSpawnX][idx2]);
	    format(string, sizeof(string), "%d/vehiclespawny/%d", id, idx2);
	    djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdVehicleSpawnY][idx2]);
	    format(string, sizeof(string), "%d/vehiclespawnz/%d", id, idx2);
	    djSetFloat("cardealerships.json", string, CarDealershipInfo[id][cdVehicleSpawnZ][idx2]);
	    format(string, sizeof(string), "%d/vehiclecost/%d", id, idx2);
	    djSetInt("cardealerships.json", string, CarDealershipInfo[id][cdVehicleCost][idx2]);
	    format(string, sizeof(string), "%d/vehicletypes/%d", id, idx2);
	    djSetInt("cardealerships.json", string, CarDealershipInfo[id][cdVehicleModel][idx2]);
	    printf("VehicleId:%d VehicleModel:%d VehicleCost:%d.",
		    idx2,
		    CarDealershipInfo[id][cdVehicleModel][idx2],
		    CarDealershipInfo[id][cdVehicleCost][idx2]);
	    idx2++;
	}
    //djAutocommit(true);
	return 1;
}

public OnPlayerVehicleUpdate(playerid)
{
    new string[20+MAX_PLAYER_NAME];
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	format(string, sizeof(string), "playervehicles/%s.ini", playername);
	new File: hFile = fopen(string, io_write);
	if (hFile)
	{
        new var[32];
        for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
	    {
	        format(var, 32, "pv%dPosX=%.1f\n", v, PlayerVehicleInfo[playerid][v][pvPosX]);fwrite(hFile, var);
	    	format(var, 32, "pv%dPosY=%.1f\n", v, PlayerVehicleInfo[playerid][v][pvPosY]);fwrite(hFile, var);
	    	format(var, 32, "pv%dPosZ=%.1f\n", v, PlayerVehicleInfo[playerid][v][pvPosZ]);fwrite(hFile, var);
	    	format(var, 32, "pv%dPosAngle=%.1f\n", v, PlayerVehicleInfo[playerid][v][pvPosAngle]);fwrite(hFile, var);
	    	format(var, 32, "pv%dModelId=%d\n", v, PlayerVehicleInfo[playerid][v][pvModelId]);fwrite(hFile, var);
	    	format(var, 32, "pv%dLock=%d\n", v, PlayerVehicleInfo[playerid][v][pvLock]);fwrite(hFile, var);
	    	format(var, 32, "pv%dLocked=%d\n", v, PlayerVehicleInfo[playerid][v][pvLocked]);fwrite(hFile, var);
	    	format(var, 32, "pv%dPaintJob=%d\n", v, PlayerVehicleInfo[playerid][v][pvPaintJob]);fwrite(hFile, var);
	    	format(var, 32, "pv%dColor1=%d\n", v, PlayerVehicleInfo[playerid][v][pvColor1]);fwrite(hFile, var);
	    	format(var, 32, "pv%dColor2=%d\n", v, PlayerVehicleInfo[playerid][v][pvColor2]);fwrite(hFile, var);
	    	for(new m = 0; m < MAX_MODS; m++)
	        {
                format(var, 32, "pv%dMod%d=%d\n", v, m, PlayerVehicleInfo[playerid][v][pvMods][m]);fwrite(hFile, var);
	        }
	        format(var, 32, "pv%dAllowedPlayer=%s\n", v, PlayerVehicleInfo[playerid][v][pvAllowPlayer]);fwrite(hFile, var);
	    }
		fclose(hFile);
	}
	return 1;
}

public OnPlayerVehicleLogin(playerid)
{
    new string2[20+MAX_PLAYER_NAME];
	new playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
	format(string2, sizeof(string2), "playervehicles/%s.ini", playername);
	new File: UserFile = fopen(string2, io_read);
	if ( UserFile )
	{
        new key[ 256 ] , val[ 256 ];
		new Data[ 256 ];
		while ( fread( UserFile , Data , sizeof( Data ) ) )
		{
			key = ini_GetKey( Data );
			for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
	        {
	        	new string[128];
				format(string, 128, "pv%dPosX",v);
				if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvPosX] = floatstr( val ); }
				format(string, 128, "pv%dPosY",v);
				if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvPosY] = floatstr( val ); }
				format(string, 128, "pv%dPosZ",v);
				if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvPosZ] = floatstr( val ); }
				format(string, 128, "pv%dPosAngle",v);
				if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvPosAngle] = floatstr( val ); }
				format(string, 128, "pv%dModelId",v);
				if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvModelId] = strval( val ); }
				format(string, 128, "pv%dLock",v);
				if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvLock] = strval( val ); }
				format(string, 128, "pv%dLocked",v);
				if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvLocked] = strval( val ); }
				format(string, 128, "pv%dPaintJob",v);
				if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvPaintJob] = strval( val ); }
				format(string, 128, "pv%dColor1",v);
				if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvColor1] = strval( val ); }
				format(string, 128, "pv%dColor2",v);
				if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvColor2] = strval( val ); }
				for(new m = 0; m < MAX_MODS; m++)
	            {
                    format(string, 128, "pv%dMod%d", v, m);
                    if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); PlayerVehicleInfo[playerid][v][pvMods][m] = strval( val ); }
	            }
	            format(string, 128, "pv%dAllowedPlayer",v);
	            if( strcmp( key , string , true ) == 0 ) { val = ini_GetValue( Data ); strmid(PlayerVehicleInfo[playerid][v][pvAllowPlayer], val, 0, strlen(val)-1, 255); }
            }
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, " No player vehicle account found.");
	}
	LoadPlayerVehicles(playerid);
	return 1;
}

public PlayerPlayMusic(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		SetTimer("StopMusic", 5000, 0);
		PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
	}
}

public StopMusic()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			PlayerPlaySound(i, 1069, 0.0, 0.0, 0.0);
		}
	}
}

public OnFilterScriptExit()
{
	for(new d = 0; d < sizeof(CarDealershipInfo); d++)
	{
		if(CarDealershipInfo[d][cdEntranceX] != 0.0 && CarDealershipInfo[d][cdEntranceY] != 0.0)
		{
			DestroyDynamicPickup(CarDealershipInfo[d][cdPickupID]);
	        DestroyDynamic3DTextLabel(CarDealershipInfo[d][cdTextLabel]);
		}
		for(new v = 0; v < MAX_DEALERSHIPVEHICLES; v++)
	    {
			if (CarDealershipInfo[d][cdVehicleModel][v] != 0)
		    {
	        	DestroyCarDealershipVehicle(d, v);
		    }
		}
	}
    djson_GameModeExit();
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(GetPVarInt(playerid, "FirstSpawn") == 1)
	{
        OnPlayerVehicleLogin(playerid);
        SetPVarInt(playerid, "FirstSpawn", 0);
	}
    return 1;
}

public OnPlayerConnect(playerid)
{
	for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
	{
        PlayerVehicleInfo[playerid][v][pvModelId] = 0;
        PlayerVehicleInfo[playerid][v][pvPosX] = 0.0;
        PlayerVehicleInfo[playerid][v][pvPosY] = 0.0;
        PlayerVehicleInfo[playerid][v][pvPosZ] = 0.0;
        PlayerVehicleInfo[playerid][v][pvPosAngle] = 0.0;
        PlayerVehicleInfo[playerid][v][pvLock] = 0;
        PlayerVehicleInfo[playerid][v][pvLocked] = 0;
        PlayerVehicleInfo[playerid][v][pvPaintJob] = -1;
        PlayerVehicleInfo[playerid][v][pvColor1] = 0;
        PlayerVehicleInfo[playerid][v][pvColor2] = 0;
        new string[64];
		format(string, sizeof(string), "No-one");
		strmid(PlayerVehicleInfo[playerid][v][pvAllowPlayer], string, 0, strlen(string), 255);
        PlayerVehicleInfo[playerid][v][pvPark] = 0;
        for(new m = 0; m < MAX_MODS; m++)
	    {
            PlayerVehicleInfo[playerid][v][pvMods][m] = 0;
		}
	}
}

public OnPlayerDisconnect(playerid, reason)
{
    UnloadPlayerVehicles(playerid);
    OnPlayerVehicleUpdate(playerid);
}

//------------------------------------------------------------------------------
//CAR DEALERSHIP SYSTEM BY ALEX DONUTS
//------------------------------------------------------------------------------
stock CreateCarDealership(Float: enx, Float: eny, Float: enz, Float: radius, price, message[])
{
	new dealershipid = GetFreeCarDealership();
	if(dealershipid == -1) return -1;
	new text_info[128];
	CarDealershipInfo[dealershipid][cdEntranceX] = enx;
	CarDealershipInfo[dealershipid][cdEntranceY] = eny;
	CarDealershipInfo[dealershipid][cdEntranceZ] = enz;
	CarDealershipInfo[dealershipid][cdRadius] = radius;
	CarDealershipInfo[dealershipid][cdPrice] = price;
	strmid(CarDealershipInfo[dealershipid][cdMessage], message, 0, strlen(message), 255);
	CarDealershipInfo[dealershipid][cdPickupID] = CreateDynamicPickup(1239, 1, CarDealershipInfo[dealershipid][cdEntranceX], CarDealershipInfo[dealershipid][cdEntranceY], CarDealershipInfo[dealershipid][cdEntranceZ]);
	format(text_info,256,"Car Dealership %s For Sale\nPrice: %d\nRadius: %.1f", CarDealershipInfo[dealershipid][cdMessage], CarDealershipInfo[dealershipid][cdPrice], CarDealershipInfo[dealershipid][cdRadius]);
    CarDealershipInfo[dealershipid][cdTextLabel] = CreateDynamic3DTextLabel(text_info,COLOR_RED,CarDealershipInfo[dealershipid][cdEntranceX], CarDealershipInfo[dealershipid][cdEntranceY], CarDealershipInfo[dealershipid][cdEntranceZ]+0.75,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1);
    SavecDealership(dealershipid);
    return dealershipid;
}
stock DestroyCarDealership(dealershipid)
{
	new string[30];
	CarDealershipInfo[dealershipid][cdEntranceX] = 0.0;
	CarDealershipInfo[dealershipid][cdEntranceY] = 0.0;
	CarDealershipInfo[dealershipid][cdEntranceZ] = 0.0;
	CarDealershipInfo[dealershipid][cdRadius] = 0.0;
	CarDealershipInfo[dealershipid][cdTill] = 0;
	CarDealershipInfo[dealershipid][cdOwned] = 0;
	CarDealershipInfo[dealershipid][cdPrice] = 0;
	format(string, sizeof(string), "None");
	strmid(CarDealershipInfo[dealershipid][cdOwner], string, 0, strlen(string), 255);
	format(string, sizeof(string), "None");
	strmid(CarDealershipInfo[dealershipid][cdMessage], string, 0, strlen(string), 255);
	DestroyDynamic3DTextLabel(CarDealershipInfo[dealershipid][cdTextLabel]);
	DestroyDynamicPickup(CarDealershipInfo[dealershipid][cdPickupID]);
	CarDealershipInfo[dealershipid][cdPickupID] = 0;
	CarDealershipInfo[dealershipid][cdTextLabel] = Text3D:INVALID_3DTEXT_ID;
	CarDealershipInfo[dealershipid][cdVehicleSpawn][0] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawn][1] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawn][2] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawn][3] = 0.0;
	for(new v = 0; v < MAX_DEALERSHIPVEHICLES; v++)
	{
		if (CarDealershipInfo[dealershipid][cdVehicleModel][v] != 0)
		{
	        DestroyCarDealershipVehicle(dealershipid, v);
		}
	}
	SavecDealership(dealershipid);
}
stock GetFreeCarDealership()
{
    new
		i = 0;
	while (i < MAX_CARDEALERSHIPS && CarDealershipInfo[i][cdEntranceX] != 0.0 && CarDealershipInfo[i][cdEntranceY] != 0.0)
	{
		i++;
	}
	if (i == MAX_CARDEALERSHIPS) return -1;
	return i;

}
stock SetPlayerOwnerOfCD(playerid, dealershipid)
{
	new owner[MAX_PLAYER_NAME];
	CarDealershipInfo[dealershipid][cdOwned] = 1;
	GetPlayerName(playerid, owner, sizeof(owner));
	strmid(CarDealershipInfo[dealershipid][cdOwner], owner, 0, strlen(owner), 255);
	new text_info[128];
	format(text_info,256,"Car Dealership %s\nOwner: %s\nRadius: %.1f", CarDealershipInfo[dealershipid][cdMessage], CarDealershipInfo[dealershipid][cdOwner], CarDealershipInfo[dealershipid][cdRadius]);
	UpdateDynamic3DTextLabelText(CarDealershipInfo[dealershipid][cdTextLabel], COLOR_GREEN, text_info);
	SavecDealership(dealershipid);
}
stock SellCarDealership(dealershipid)
{
	CarDealershipInfo[dealershipid][cdOwned] = 0;
	CarDealershipInfo[dealershipid][cdVehicleSpawn][0] = 0.0;
	CarDealershipInfo[dealershipid][cdVehicleSpawn][1] = 0.0;
	CarDealershipInfo[dealershipid][cdVehicleSpawn][2] = 0.0;
	CarDealershipInfo[dealershipid][cdVehicleSpawn][3] = 0.0;
	strmid(CarDealershipInfo[dealershipid][cdOwner], "No-one", 0, MAX_PLAYER_NAME, 255);
	new text_info[128];
	format(text_info,256,"Car Dealership %s For Sale\nPrice: %d\nRadius: %.1f", CarDealershipInfo[dealershipid][cdMessage], CarDealershipInfo[dealershipid][cdPrice], CarDealershipInfo[dealershipid][cdRadius]);
	UpdateDynamic3DTextLabelText(CarDealershipInfo[dealershipid][cdTextLabel], COLOR_RED, text_info);
	SavecDealership(dealershipid);
}
stock IsPlayerOwnerOfCD(playerid)
{
	new owner[MAX_PLAYER_NAME];
	GetPlayerName(playerid, owner, sizeof(owner));
	for(new d = 0; d < MAX_CARDEALERSHIPS; d++)
    {
	    if(strcmp(CarDealershipInfo[d][cdOwner],owner, true ) == 0)
	    {
			return d;
		}
	}
	return -1;
}
stock IsPlayerOwnerOfCDEx(playerid, dealershipid)
{
	new owner[MAX_PLAYER_NAME];
	GetPlayerName(playerid, owner, sizeof(owner));
	if(strcmp(CarDealershipInfo[dealershipid][cdOwner],owner, true ) == 0)
	{
	    return 1;
	}
	return 0;
}
stock CreateCarDealershipVehicle(dealershipid, modelid, Float: x, Float: y, Float: z, Float: a, price)
{
    new cdvehicleid = GetFreeCarDealershipVehicleId(dealershipid);
    if(cdvehicleid == -1) return -1;
    new text_info[128];
    CarDealershipInfo[dealershipid][cdVehicleModel][cdvehicleid] = modelid;
    CarDealershipInfo[dealershipid][cdVehicleCost][cdvehicleid] = price;
    CarDealershipInfo[dealershipid][cdVehicleSpawnX][cdvehicleid] = x;
    CarDealershipInfo[dealershipid][cdVehicleSpawnY][cdvehicleid] = y;
    CarDealershipInfo[dealershipid][cdVehicleSpawnZ][cdvehicleid] = z;
    CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][cdvehicleid] = a;
    new carcreated = CreateVehicle(modelid, x, y, z, a, 0, 0, 6);
    format(text_info,256,"%s For Sale | Price: %d", GetVehicleName(carcreated), CarDealershipInfo[dealershipid][cdVehicleCost][cdvehicleid]);
    CarDealershipInfo[dealershipid][cdVehicleLabel][cdvehicleid] = CreateDynamic3DTextLabel(text_info,COLOR_LIGHTBLUE,0.0, 0.0, 0.0,5.0,INVALID_PLAYER_ID,carcreated,1);
	CarDealershipInfo[dealershipid][cdVehicleId][cdvehicleid] = carcreated;
	SavecDealership(cdvehicleid);
    return cdvehicleid;
}
stock DestroyCarDealershipVehicle(dealershipid, cdvehicleid)
{
    CarDealershipInfo[dealershipid][cdVehicleModel][cdvehicleid] = 0;
    CarDealershipInfo[dealershipid][cdVehicleCost][cdvehicleid] = 0;
    CarDealershipInfo[dealershipid][cdVehicleSpawnX][cdvehicleid] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawnY][cdvehicleid] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawnZ][cdvehicleid] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][cdvehicleid] = 0.0;
    DestroyDynamic3DTextLabel(CarDealershipInfo[dealershipid][cdVehicleLabel][cdvehicleid]);
    DestroyVehicle(CarDealershipInfo[dealershipid][cdVehicleId][cdvehicleid]);
    CarDealershipInfo[dealershipid][cdVehicleLabel][cdvehicleid] = Text3D:INVALID_3DTEXT_ID;
    CarDealershipInfo[dealershipid][cdVehicleId][cdvehicleid] = 0;
}
stock GetFreeCarDealershipVehicleId(dealershipid)
{
    new
		i = 0;
	while (i < MAX_DEALERSHIPVEHICLES && CarDealershipInfo[dealershipid][cdVehicleModel][i] != 0)
	{
		i++;
	}
	if (i == MAX_DEALERSHIPVEHICLES) return -1;
	return i;

}
stock GetCarDealershipVehicleId(vehicleid)
{
    for(new d = 0; d < MAX_CARDEALERSHIPS; d++)
    {
        for(new v = 0; v < MAX_DEALERSHIPVEHICLES; v++)
        {
            if(CarDealershipInfo[d][cdVehicleId][v] == vehicleid)
            {
                return v;
            }
		}
    }
    return -1;
}
stock GetCarDealershipId(vehicleid)
{
    for(new d = 0; d < MAX_CARDEALERSHIPS; d++)
    {
        for(new v = 0; v < MAX_DEALERSHIPVEHICLES; v++)
        {
            if(CarDealershipInfo[d][cdVehicleId][v] == vehicleid)
            {
                return d;
            }
		}
    }
    return -1;
}

//------------------------------------------------------------------------------
//PLAYER VEHICLE SYSTEM BY ALEX DONUTS
//------------------------------------------------------------------------------
stock CreatePlayerVehicle(playerid, playervehicleid, modelid, Float: x, Float: y, Float: z, Float: angle, color1, color2)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvId] == INVALID_PLAYER_VEHICLE_ID)
	{
        new string[99];
		PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = modelid;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = x;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = y;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = z;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = angle;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = color1;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = color2;
		PlayerVehicleInfo[playerid][playervehicleid][pvPark] = 1;
		for(new m = 0; m < MAX_MODS; m++)
	    {
	    	PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] = 0;
		}
		new carcreated = CreateVehicle(modelid,x,y,z,angle,color1,color2,-1);
		PlayerVehicleInfo[playerid][playervehicleid][pvId] = carcreated;
		format(string, sizeof(string), "Created your vehicle #%d.", PlayerVehicleInfo[playerid][playervehicleid][pvId]);
	    SendClientMessage(playerid, COLOR_GRAD1,string);
		return carcreated;
	}
	return INVALID_PLAYER_VEHICLE_ID;
}

stock DestroyPlayerVehicle(playerid, playervehicleid)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvId] != INVALID_PLAYER_VEHICLE_ID)
	{
		new string[99];
		DestroyVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvId]);
		PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob] = -1;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = 126;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = 126;
		format(string, sizeof(string), "None");
	    strmid(PlayerVehicleInfo[playerid][playervehicleid][pvAllowPlayer], string, 0, strlen(string), 255);
	    format(string, sizeof(string), "Your vehicle #%d has been destroyed.", PlayerVehicleInfo[playerid][playervehicleid][pvId]);
	    SendClientMessage(playerid, COLOR_GRAD1,string);
	    PlayerVehicleInfo[playerid][playervehicleid][pvId] = INVALID_PLAYER_VEHICLE_ID;
	}
}

stock LoadPlayerVehicles(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	printf(" Loading %s's vehicles.", playername);
	for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
    {
        if(PlayerVehicleInfo[playerid][v][pvModelId] != 0)
        {
			new carcreated = CreateVehicle(PlayerVehicleInfo[playerid][v][pvModelId], PlayerVehicleInfo[playerid][v][pvPosX], PlayerVehicleInfo[playerid][v][pvPosY], PlayerVehicleInfo[playerid][v][pvPosZ], PlayerVehicleInfo[playerid][v][pvPosAngle],PlayerVehicleInfo[playerid][v][pvColor1], PlayerVehicleInfo[playerid][v][pvColor2], -1);
			PlayerVehicleInfo[playerid][v][pvId] = carcreated;
        }
    }
    LoadAllPlayerVehicleMods(playerid);
}

stock UnloadPlayerVehicles(playerid)
{
    new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	printf(" Unloading %s's vehicles.", playername);
	for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
    {
        if(PlayerVehicleInfo[playerid][v][pvId] != INVALID_PLAYER_VEHICLE_ID)
        {
            //new Float:x, Float:y, Float:z, Float:angle;
            //GetVehiclePos(PlayerVehicleInfo[playerid][v][pvId], x, y, z);
            //GetVehicleZAngle(PlayerVehicleInfo[playerid][v][pvId], angle);
            //UpdatePlayerVehicleParkPosition(playerid, v, x, y, z, angle);
            UpdatePlayerVehicleMods(playerid, v);
			DestroyVehicle(PlayerVehicleInfo[playerid][v][pvId]);
			PlayerVehicleInfo[playerid][v][pvId] = INVALID_PLAYER_VEHICLE_ID;
        }
    }
}

stock UpdatePlayerVehicleParkPosition(playerid, playervehicleid, Float:newx, Float:newy, Float:newz, Float:newangle, Float:health)
{
    new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	if(PlayerVehicleInfo[playerid][playervehicleid][pvId] != INVALID_PLAYER_VEHICLE_ID)
	{
		 new Float:oldx, Float:oldy, Float:oldz;
		 oldx = PlayerVehicleInfo[playerid][playervehicleid][pvPosX];
		 oldy = PlayerVehicleInfo[playerid][playervehicleid][pvPosY];
		 oldz = PlayerVehicleInfo[playerid][playervehicleid][pvPosZ];
		 if(oldx == newx && oldy == newy && oldz == newz) return 0;
		 PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = newx;
		 PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = newy;
		 PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = newz;
		 PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = newangle;
		 UpdatePlayerVehicleMods(playerid, playervehicleid);
		 DestroyVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvId]);
		 new carcreated = CreateVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvModelId], PlayerVehicleInfo[playerid][playervehicleid][pvPosX], PlayerVehicleInfo[playerid][playervehicleid][pvPosY], PlayerVehicleInfo[playerid][playervehicleid][pvPosZ],
		 PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle],PlayerVehicleInfo[playerid][playervehicleid][pvColor1], PlayerVehicleInfo[playerid][playervehicleid][pvColor2], -1);
         PlayerVehicleInfo[playerid][playervehicleid][pvId] = carcreated;
         SetVehicleHealth(carcreated, health);
         LoadPlayerVehicleMods(playerid, playervehicleid);
         return 1;
	}
	return 0;
}

stock UpdatePlayerVehicleMods(playerid, playervehicleid)
{
    new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	new carid = PlayerVehicleInfo[playerid][playervehicleid][pvId];
    new exhaust, frontbumper, rearbumper, roof, spoilers, sideskirt1,
		sideskirt2, wheels, hydraulics, nitro, hood, lamps, stereo, ventright, ventleft;
	exhaust = GetVehicleComponentInSlot(carid, CARMODTYPE_EXHAUST);
	frontbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_FRONT_BUMPER);
	rearbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_REAR_BUMPER);
	roof = GetVehicleComponentInSlot(carid, CARMODTYPE_ROOF);
	spoilers = GetVehicleComponentInSlot(carid, CARMODTYPE_SPOILER);
	sideskirt1 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
	sideskirt2 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
	wheels = GetVehicleComponentInSlot(carid, CARMODTYPE_WHEELS);
	hydraulics = GetVehicleComponentInSlot(carid, CARMODTYPE_HYDRAULICS);
	nitro = GetVehicleComponentInSlot(carid, CARMODTYPE_NITRO);
	hood = GetVehicleComponentInSlot(carid, CARMODTYPE_HOOD);
	lamps = GetVehicleComponentInSlot(carid, CARMODTYPE_LAMPS);
	stereo = GetVehicleComponentInSlot(carid, CARMODTYPE_STEREO);
	ventright = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_RIGHT);
	ventleft = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_LEFT);
	if(spoilers >= 1000)    PlayerVehicleInfo[playerid][playervehicleid][pvMods][0] = spoilers;
	if(hood >= 1000)        PlayerVehicleInfo[playerid][playervehicleid][pvMods][1] = hood;
	if(roof >= 1000)        PlayerVehicleInfo[playerid][playervehicleid][pvMods][2] = roof;
	if(sideskirt1 >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][3] = sideskirt1;
	if(lamps >= 1000)       PlayerVehicleInfo[playerid][playervehicleid][pvMods][4] = lamps;
	if(nitro >= 1000)       PlayerVehicleInfo[playerid][playervehicleid][pvMods][5] = nitro;
	if(exhaust >= 1000)     PlayerVehicleInfo[playerid][playervehicleid][pvMods][6] = exhaust;
	if(wheels >= 1000)      PlayerVehicleInfo[playerid][playervehicleid][pvMods][7] = wheels;
	if(stereo >= 1000)      PlayerVehicleInfo[playerid][playervehicleid][pvMods][8] = stereo;
	if(hydraulics >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][9] = hydraulics;
	if(frontbumper >= 1000) PlayerVehicleInfo[playerid][playervehicleid][pvMods][10] = frontbumper;
	if(rearbumper >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][11] = rearbumper;
	if(ventright >= 1000)   PlayerVehicleInfo[playerid][playervehicleid][pvMods][12] = ventright;
	if(ventleft >= 1000)    PlayerVehicleInfo[playerid][playervehicleid][pvMods][13] = ventleft;
	if(sideskirt2 >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][14] = sideskirt2;
}

stock LoadPlayerVehicleMods(playerid, playervehicleid)
{
	printf(" Loading player #%d vehicle #%d mods.", playerid, playervehicleid);
    new paintjob = PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob];
	new color1 = PlayerVehicleInfo[playerid][playervehicleid][pvColor1];
	new color2 = PlayerVehicleInfo[playerid][playervehicleid][pvColor2];
    if(PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob] != -1)
	{
         ChangeVehiclePaintjob(PlayerVehicleInfo[playerid][playervehicleid][pvId], paintjob);
		 ChangeVehicleColor(PlayerVehicleInfo[playerid][playervehicleid][pvId], color1, color2);
	}
	for(new m = 0; m < MAX_MODS; m++)
	{
		if (PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] >= 1000)
	    {
	    	AddVehicleComponent(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvMods][m]);
		}
	}
}

stock LoadAllPlayerVehicleMods(playerid)
{
	print(" Loading all vehicles mods.");
	for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
    {
        if(PlayerVehicleInfo[playerid][v][pvModelId] != 0)
        {
            new paintjob = PlayerVehicleInfo[playerid][v][pvPaintJob];
        	new color1 = PlayerVehicleInfo[playerid][v][pvColor1];
	        new color2 = PlayerVehicleInfo[playerid][v][pvColor2];
            if(PlayerVehicleInfo[playerid][v][pvPaintJob] != -1)
	        {
                ChangeVehiclePaintjob(PlayerVehicleInfo[playerid][v][pvId], paintjob);
	        }
	        ChangeVehicleColor(PlayerVehicleInfo[playerid][v][pvId], color1, color2);
	        for(new m = 0; m < MAX_MODS; m++)
	        {
		        if (PlayerVehicleInfo[playerid][v][pvMods][m] >= 1000)
	            {
	    	        AddVehicleComponent(PlayerVehicleInfo[playerid][v][pvId], PlayerVehicleInfo[playerid][v][pvMods][m]);
		        }
	        }
		}
	}
}

stock GetPlayerFreeVehicleId(playerid)
{
    new
		i = 0;
	while (i < MAX_PLAYERVEHICLES && PlayerVehicleInfo[playerid][i][pvId])
	{
		i++;
	}
	if (i == MAX_PLAYERVEHICLES) return -1;
	return i;

}

stock GetPlayerVehicle(playerid, vehicleid)
{
    for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
    {
        if(PlayerVehicleInfo[playerid][v][pvId] == vehicleid)
        {
            return v;
        }
    }
    return -1;
}

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];

	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock GetVehicleName(vehicleid)
{
	new vn[50];
	format(vn,sizeof(vn),"%s",VehicleName[GetVehicleModel(vehicleid)-400]);
	return vn;
}

IsKeyJustDown(key, newkeys, oldkeys)
{
    if((newkeys & key) && !(oldkeys & key)) return 1;
    return 0;
}

IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}

ReturnUser(text[], playerid = INVALID_PLAYER_ID)
{
	new pos = 0;
	while (text[pos] < 0x21) // Strip out leading spaces
	{
		if (text[pos] == 0) return INVALID_PLAYER_ID; // No passed text
		pos++;
	}
	new userid = INVALID_PLAYER_ID;
	if (IsNumeric(text[pos])) // Check whole passed string
	{
		// If they have a numeric name you have a problem (although names are checked on id failure)
		userid = strval(text[pos]);
		if (userid >=0 && userid < MAX_PLAYERS)
		{
			if(!IsPlayerConnected(userid))
			{
				/*if (playerid != INVALID_PLAYER_ID)
				{
					SendClientMessage(playerid, 0xFF0000AA, "User not connected");
				}*/
				userid = INVALID_PLAYER_ID;
			}
			else
			{
				return userid; // A player was found
			}
		}
		/*else
		{
			if (playerid != INVALID_PLAYER_ID)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Invalid user ID");
			}
			userid = INVALID_PLAYER_ID;
		}
		return userid;*/
		// Removed for fallthrough code
	}
	// They entered [part of] a name or the id search failed (check names just incase)
	new len = strlen(text[pos]);
	new count = 0;
	new name[MAX_PLAYER_NAME];
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, name, sizeof (name));
			if (strcmp(name, text[pos], true, len) == 0) // Check segment of name
			{
				if (len == strlen(name)) // Exact match
				{
					return i; // Return the exact player on an exact match
					// Otherwise if there are two players:
					// Me and MeYou any time you entered Me it would find both
					// And never be able to return just Me's id
				}
				else // Partial match
				{
					count++;
					userid = i;
				}
			}
		}
	}
	if (count != 1)
	{
		if (playerid != INVALID_PLAYER_ID)
		{
			if (count)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Multiple users found, please narrow earch");
			}
			else
			{
				SendClientMessage(playerid, 0xFF0000AA, "No matching user found");
			}
		}
		userid = INVALID_PLAYER_ID;
	}
	return userid; // INVALID_USER_ID for bad return
}

public OnEnterExitModShop(playerid,enterexit,interiorid)
{
	if(enterexit == 1)
	{
		SendClientMessage(playerid, COLOR_GRAD1, " You have entered a modding shop.");
	}
	else
	{
		// Saving cars.
		if(GetPlayerVehicle(playerid, GetPlayerVehicleID(playerid)) > -1)
		{
			UpdatePlayerVehicleMods(playerid, GetPlayerVehicle(playerid, GetPlayerVehicleID(playerid)));
			return 1;
		}
	}
	return 0;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    if(GetPlayerVehicle(playerid, vehicleid) > -1)
	{
		PlayerVehicleInfo[playerid][GetPlayerVehicle(playerid, vehicleid)][pvPaintJob] = paintjobid;
		return 1;
	}
    return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    if(GetPlayerVehicle(playerid, vehicleid) > -1)
	{
		PlayerVehicleInfo[playerid][GetPlayerVehicle(playerid, vehicleid)][pvColor1] = color1;
		PlayerVehicleInfo[playerid][GetPlayerVehicle(playerid, vehicleid)][pvColor2] = color2;
		return 1;
	}
    return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	new v;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		v = GetPlayerVehicle(i, vehicleid);
		if(PlayerVehicleInfo[i][v][pvId] == vehicleid && forplayerid != i)
  	    {
			if(PlayerVehicleInfo[i][v][pvLock] == 3 && PlayerVehicleInfo[i][v][pvLocked])
			{
                SetVehicleParamsForPlayer(vehicleid,forplayerid,0,1);
		    }
			else if(PlayerVehicleInfo[i][v][pvLock] == 3 && !PlayerVehicleInfo[i][v][pvLocked])
			{
                SetVehicleParamsForPlayer(vehicleid,forplayerid,0,0);
			}
		}
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
    new v;
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			v = GetPlayerVehicle(i, vehicleid);
			if(v != -1)
			{
                SendClientMessage(i, COLOR_GRAD1, " Your vehicle has been spawned.");
				new paintjob = PlayerVehicleInfo[i][v][pvPaintJob];
				new color1 = PlayerVehicleInfo[i][v][pvColor1];
				new color2 = PlayerVehicleInfo[i][v][pvColor2];
                ChangeVehiclePaintjob(vehicleid, paintjob);
				ChangeVehicleColor(vehicleid, color1, color2);
				for(new m = 0; m < MAX_MODS; m++)
	            {
		            if (PlayerVehicleInfo[i][v][pvMods][m] >= 1000)
	                {
	    	            AddVehicleComponent(vehicleid, PlayerVehicleInfo[i][v][pvMods][m]);
		            }
	            }
			}
		}
	}
}

public MeepMeep(playerid, vehicleid)
{
	if(IsPlayerInVehicle(playerid, vehicleid) && !meepmeep[vehicleid])
	{
        new Float:x, Float: y, Float: z;
		GetVehiclePos(vehicleid, x, y, z);
  		for(new d = 0; d < MAX_PLAYERS; d++)
		{
			 if(IsPlayerInRangeOfPoint(d, 30.0, x, y, z))
			 {
				 PlayerPlaySound(d, 1147, x, y, z);
			 }
		}
		SetTimerEx("MeepMeep", 1000, 0, "dd", playerid, vehicleid);
	}
	else if(!IsPlayerInVehicle(playerid, vehicleid) && !meepmeep[vehicleid])
	{
        new Float:x, Float: y, Float: z;
		GetVehiclePos(vehicleid, x, y, z);
  		for(new d = 0; d < MAX_PLAYERS; d++)
		{
			 if(IsPlayerInRangeOfPoint(d, 30.0, x, y, z))
			 {
				 PlayerPlaySound(d, 1147, x, y, z);
			 }
		}
		meepmeep[vehicleid] = 10;
		SetTimerEx("MeepMeep", 1000, 0, "dd", playerid, vehicleid);
	}
	else if(meepmeep[vehicleid] > 1)
	{
        new Float:x, Float: y, Float: z;
		GetVehiclePos(vehicleid, x, y, z);
  		for(new d = 0; d < MAX_PLAYERS; d++)
		{
			 if(IsPlayerInRangeOfPoint(d, 30.0, x, y, z))
			 {
				 PlayerPlaySound(d, 1147, x, y, z);
			 }
		}
		meepmeep[vehicleid]--;
		SetTimerEx("MeepMeep", 1000, 0, "dd", playerid, vehicleid);
	}
	else if(meepmeep[vehicleid] == 1)
	{
        new Float:x, Float: y, Float: z;
		GetVehiclePos(vehicleid, x, y, z);
  		for(new d = 0; d < MAX_PLAYERS; d++)
		{
			 if(IsPlayerInRangeOfPoint(d, 30.0, x, y, z))
			 {
				 PlayerPlaySound(d, 1147, x, y, z);
			 }
		}
		meepmeep[vehicleid] = 0;
	}
	return 1;
}

public PutPlayerInVeh(playerid, vehicleid)
{
	PutPlayerInVehicle(playerid, vehicleid, 0);
}

public ReleasePlayer(playerid)
{
	TogglePlayerControllable(playerid,1);
}

public LockPlayerVehicle(ownerid, carid, type)
{
	new v = GetPlayerVehicle(ownerid, carid);
	if(PlayerVehicleInfo[ownerid][v][pvId] == carid && type == 3)
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(i != ownerid)
			{
			     SetVehicleParamsForPlayer(carid,i,0,1);
			}
		}
	}
}

public UnLockPlayerVehicle(ownerid, carid, type)
{
	new v = GetPlayerVehicle(ownerid, carid);
	if(PlayerVehicleInfo[ownerid][v][pvId] == carid && type == 3)
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(i != ownerid)
			{
			     SetVehicleParamsForPlayer(carid,i,0,0);
			}
		}
	}
}



public OnPlayerCommandText(playerid, cmdtext[])
{
	new string[128], cmd[128], tmp[128], idx;
    cmd = strtok(cmdtext, idx);
    new idcar = GetPlayerVehicleID(playerid);
    new giveplayerid;
    if(strcmp(cmd, "/park", true) == 0)
	{
		for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	    {
		    if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
		    {
		        new Float:x, Float:y, Float:z, Float:angle, playername[MAX_PLAYER_NAME], Float:health;
		        GetVehicleHealth(PlayerVehicleInfo[playerid][d][pvId], health);
		        if(health < 500) return SendClientMessage(playerid, COLOR_GREY, " Your vehicle is too damaged to park it.");
                GetVehiclePos(PlayerVehicleInfo[playerid][d][pvId], x, y, z);
                GetVehicleZAngle(PlayerVehicleInfo[playerid][d][pvId], angle);
                GetPlayerName(playerid, playername, sizeof(playername));
                UpdatePlayerVehicleParkPosition(playerid, d, x, y, z, angle, health);
                format(string, sizeof(string), "* %s has parked his vehicle.", playername);
		        ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                return 1;
			}
		}
		SendClientMessage(playerid, COLOR_GREY, " You need to be inside a vehicle that you own.");
		return 1;
	}
    if(strcmp(cmd, "/pvlock", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
			new Float: x, Float: y, Float: z, playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	        {
				 if(PlayerVehicleInfo[playerid][d][pvId] != 0) GetVehiclePos(PlayerVehicleInfo[playerid][d][pvId], x, y, z);
		         if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
		         {
			         if(PlayerVehicleInfo[playerid][d][pvLock] > 0 && PlayerVehicleInfo[playerid][d][pvLocked] == 0)
			         {
                         GameTextForPlayer(playerid,"~r~Vehicle Locked!",5000,6);
                         PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                         PlayerVehicleInfo[playerid][d][pvLocked] = 1;
                         LockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId], PlayerVehicleInfo[playerid][d][pvLock]);
                         format(string, sizeof(string), "* %s has locked his vehicle.", playername);
		                 ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                         return 1;
			         }
			         else if(PlayerVehicleInfo[playerid][d][pvLock] > 0 && PlayerVehicleInfo[playerid][d][pvLocked] == 1)
			         {
                         GameTextForPlayer(playerid,"~g~Vehicle Unlocked!",5000,6);
                         PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                         PlayerVehicleInfo[playerid][d][pvLocked] = 0;
                         UnLockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId], PlayerVehicleInfo[playerid][d][pvLock]);
                         format(string, sizeof(string), "* %s has unlocked his vehicle.", playername);
		                 ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                         return 1;

			         }
			         SendClientMessage(playerid, COLOR_GREY, " You don't have a lock system installed on this vehicle.");
			         return 1;
		         }
		    }
		    SendClientMessage(playerid, COLOR_GREY, " You are not near any vehicle that you own.");
		}
		return 1;
	}
    if(strcmp(cmd, "/editcardealership", true) == 0)
	{
	    for(new d = 0 ; d < MAX_CARDEALERSHIPS; d++)
	    {
		    if(IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[d][cdRadius], CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]))
		    {
			   if(IsPlayerOwnerOfCDEx(playerid, d))
			   {
                   SetPVarInt(playerid, "editingcd", d);
                   SetPVarInt(playerid, "editingcdveh", -1);
                   SetPVarInt(playerid, "editingcdvehpos", 0);
                   SetPVarInt(playerid, "editingcdvehnew", 0);
                   new listitems[] = "1 New Vehicle\n2 My Vehicles\n3 Upgrade\n4 Till";
			       ShowPlayerDialog(playerid,DIALOG_CDEDIT,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			       return 1;
			   }
			   else
			   {
                   SendClientMessage(playerid, COLOR_GREY, "You do not own that Car Dealership.");
                   return 1;
			   }
		    }
		}
		SendClientMessage(playerid, COLOR_GREY, "ERROR: You must be standing inside the radius of the Car Dealership.");
	}
	if(strcmp(cmd, "/editcar", true) == 0)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    new v, d;
	    v = GetCarDealershipVehicleId(vehicleid);
	    d = GetCarDealershipId(vehicleid);
	    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You are not in any car.");
		if(v != -1 && d != -1)
		{
		    if(IsPlayerOwnerOfCDEx(playerid, d))
		    {
                SetPVarInt(playerid, "editingcd", d);
                SetPVarInt(playerid, "editingcdveh", v);
                SetPVarInt(playerid, "editingcdvehpos", 0);
                SetPVarInt(playerid, "editingcdvehnew", 0);
                new listitems[] = "1 Edit Model\n2 Edit Cost\n3 Edit Park\n4 Delete Vehicle";
			    ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
			    return 1;
			}
			else
			{
                SendClientMessage(playerid, COLOR_GREY, "ERROR: You do not own that Car Dealership.");
			}
		}
		else
		{
            SendClientMessage(playerid, COLOR_GREY, "ERROR: Car is not part of a Car Dealership.");
		}
	}
	if(strcmp(cmd, "/buydealership", true) == 0)
	{
	    for(new d = 0 ; d < MAX_CARDEALERSHIPS; d++)
	    {
		    if(IsPlayerInRangeOfPoint(playerid, 3.0, CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]))
		    {
			   if(!CarDealershipInfo[d][cdOwned])
			   {
			       if(GetPVarInt(playerid, "Cash") < CarDealershipInfo[d][cdPrice])
			       {
				       SendClientMessage(playerid, COLOR_GREY, " You do not have enough money to buy this Car Dealership.");
			       }
			       SetPVarInt(playerid, "Cash", GetPVarInt(playerid, "Cash")-CarDealershipInfo[d][cdPrice]);
			       SetPlayerOwnerOfCD(playerid, d);
			       PlayerPlayMusic(playerid);
				   SendClientMessage(playerid, COLOR_WHITE, "Congratulations, On Your New Purchase.");
				   SendClientMessage(playerid, COLOR_WHITE, "Type /help to review the new car dealership help section.");
				   SendClientMessage(playerid, COLOR_GRAD1, " Please set the position you want your brought cars to spawn.");
				   SendClientMessage(playerid, COLOR_GRAD2, " Stand where you want to have your brought vehicles spawn.");
				   SendClientMessage(playerid, COLOR_GRAD2, " Once ready press the fire button.");
				   SendClientMessage(playerid, COLOR_WHITE, " Note: If you don't set it your costumers wont be able to buy any cars.");
				   SetPVarInt(playerid, "editingcdvehpos", 2);
				   SetPVarInt(playerid, "editingcd", d);
			       return 1;
			   }
			   else
			   {
                   SendClientMessage(playerid, COLOR_GREY, "That Car Dealership is already owned and it's not for sale.");
			   }
		    }
		}
	}
	if(strcmp(cmd, "/selldealership", true) == 0)
	{
	    for(new d = 0 ; d < MAX_CARDEALERSHIPS; d++)
	    {
		    if(IsPlayerInRangeOfPoint(playerid, 3.0, CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]))
		    {
			   if(IsPlayerOwnerOfCDEx(playerid, d))
			   {
				   SetPVarInt(playerid, "editingcd", d);
			       format(string,128,"Are you sure you want to sell this Car Dealership for $%d?\n.", CarDealershipInfo[d][cdPrice] / 2);
		           ShowPlayerDialog(playerid,DIALOG_CDSELL,DIALOG_STYLE_MSGBOX,"Warning:",string,"Sell","Cancel");
			       return 1;
			   }
			   else
			   {
                   SendClientMessage(playerid, COLOR_GREY, "You are not the owner of this car dealership.");
                   return 1;
			   }
		    }
		}
		SendClientMessage(playerid, COLOR_GREY, "You have to be near a car dealership.");
	}
	if(strcmp(cmd, "/createcdveh", true) == 0)
	{
	    if (!IsPlayerAdmin(playerid))
	    {
	        SendClientMessage(playerid, COLOR_GREY, " You are not allowed to use this command.");
	        return 1;
	    }
		tmp = strtok(cmdtext,idx);
		new dealershipid;
		if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /createcdveh [price] [dealership] [modelid]");
		    return 1;
	    }
	    new price = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /createcdveh [price] [dealership] [modelid]");
		    return 1;
	    }
	    dealershipid = strval(tmp);
	    tmp = strtok(cmdtext, idx);
	    if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /createcdveh [price] [dealership] [modelid]");
		    return 1;
	    }
	    new modelid = strval(tmp);
		new Float:X,Float:Y,Float:Z,Float:A;
	    GetPlayerPos(playerid,X,Y,Z);
	    GetPlayerFacingAngle(playerid, A);
	    new cdvehicleid = CreateCarDealershipVehicle(dealershipid, modelid, X, Y, Z, A, price);
	    if(cdvehicleid == -1)
		{
		    SendClientMessage(playerid, COLOR_GREY, "ERROR: cdVehicles limit reached.");
		}
	    else
	    {
            format(string, sizeof(string), " Car Dealership Vehicle created with ID %d.", cdvehicleid);
		    SendClientMessage(playerid, COLOR_GRAD1, string);
	    }
	}
	if(strcmp(cmd, "/destroycdveh", true) == 0)
	{
	    if (!IsPlayerAdmin(playerid))
	    {
	        SendClientMessage(playerid, COLOR_GREY, " You are not allowed to use this command.");
	        return 1;
	    }
	    /*for(new d = 1 ; d < MAX_CARDEALERSHIPS; d++)
	    {
		   if(IsPlayerInRangeOfPoint(playerid, 3.0, CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]))
		   {
			   DestroyCarDealership(d);
			   format(string, sizeof(string), " Car Dealership destroyed with ID %d.", d);
		       SendClientMessage(playerid, COLOR_GRAD1, string);
			   return 1;
		   }
		}*/
		new vehid;
		tmp = strtok(cmdtext, idx);
		if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /destroycdveh [vehicleid]");
		    return 1;
	    }
		vehid = strval(tmp);
		DestroyCarDealershipVehicle(GetCarDealershipId(vehid), GetCarDealershipVehicleId(vehid));
		SavecDealership(GetCarDealershipId(vehid));
		format(string, sizeof(string), " Car Dealership Vehicle destroyed with ID %d.", vehid);
		SendClientMessage(playerid, COLOR_GRAD1, string);
	}
	if(strcmp(cmd, "/createdealership", true) == 0)
	{
	    if (!IsPlayerAdmin(playerid))
	    {
	        SendClientMessage(playerid, COLOR_GREY, " You are not allowed to use this command.");
	        return 1;
	    }
		tmp = strtok(cmdtext,idx);
		new radius;
		if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /createdealership [price] [radius] [message]");
		    return 1;
	    }
	    new price = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /createdealership [price] [radius] [message]");
		    return 1;
	    }
	    radius = strval(tmp);
	    new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[64];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result))
		{
			SendClientMessage(playerid, COLOR_GRAD2, "USAGE: /createdealership [price] [radius] [message]");
			return 1;
		}
		new Float:X,Float:Y,Float:Z;
	    GetPlayerPos(playerid,X,Y,Z);
	    new dealershipid = CreateCarDealership(X, Y, Z, radius, price, result);
	    if(dealershipid == -1)
		{
		    SendClientMessage(playerid, COLOR_GREY, "ERROR: Car Dealerships limit reached.");
		}
	    else
	    {
            format(string, sizeof(string), " Car Dealership created with ID %d.", dealershipid);
		    SendClientMessage(playerid, COLOR_GRAD1, string);
	    }
	}
	if(strcmp(cmd, "/destroydealership", true) == 0)
	{
	    if (!IsPlayerAdmin(playerid))
	    {
	        SendClientMessage(playerid, COLOR_GREY, " You are not allowed to use this command.");
	        return 1;
	    }
	    for(new d = 0 ; d < MAX_CARDEALERSHIPS; d++)
	    {
		   if(IsPlayerInRangeOfPoint(playerid, 3.0, CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]))
		   {
			   DestroyCarDealership(d);
			   format(string, sizeof(string), " Car Dealership destroyed with ID %d.", d);
		       SendClientMessage(playerid, COLOR_GRAD1, string);
			   return 1;
		   }
		}
		new dealershipid;
		tmp = strtok(cmdtext, idx);
		if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /destroydealership [dealershipid]");
		    return 1;
	    }
		dealershipid = strval(tmp);
		if(dealershipid > MAX_CARDEALERSHIPS) return 1;
		if(dealershipid < 0) return 1;
		DestroyCarDealership(dealershipid);
		format(string, sizeof(string), " Car Dealership destroyed with ID %d.", dealershipid);
		SendClientMessage(playerid, COLOR_GRAD1, string);
	}
	if(strcmp(cmd, "/vehid", true) == 0)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
			format(string, sizeof(string), "* Vehicle Name: %s | Vehicle Model:%d | Vehicle ID: %d.",GetVehicleName(idcar), GetVehicleModel(idcar), idcar);
			SendClientMessage(playerid, COLOR_GREY, string);
		}
		return 1;
	}
	if(strcmp(cmd, "/createpvehicle", true) == 0)
	{
	    if (!IsPlayerAdmin(playerid))
	    {
	        SendClientMessage(playerid, COLOR_GREY, " You are not allowed to use this command.");
	        return 1;
	    }
		tmp = strtok(cmdtext,idx);
		new modelid;
		if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /createpvehicle [playerid/partOfName] [modelid] [color 1] [color 2]");
		    return 1;
	    }
	    giveplayerid = ReturnUser(tmp);
		tmp = strtok(cmdtext, idx);
		if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /createpvehicle [playerid/partOfName] [modelid] [color 1] [color 2]");
		    return 1;
	    }
		modelid = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
		    SendClientMessage(playerid, COLOR_GRAD2, "USAGE: /createpvehicle [playerid/partOfName] [modelid] [color 1] [color 2]");
			return 1;
		}
		new color1;
		color1 = strval(tmp);
		if(color1 < 0 || color1 > 126) { SendClientMessage(playerid, COLOR_GREY, "   Color Number can't be below 0 or above 126 !"); return 1; }
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GRAD2, "USAGE: /createpvehicle [playerid/partOfName] [modelid] [color 1] [color 2]");
			return 1;
		}
		new color2;
		color2 = strval(tmp);
		if(color2 < 0 || color2 > 126) { SendClientMessage(playerid, COLOR_GREY, "   Color Number can't be below 0 or above 126 !"); return 1; }
		if(modelid < 400 || modelid > 611) { SendClientMessage(playerid, COLOR_GREY, "   Vehicle Number can't be below 400 or above 611 !"); return 1; }
		new playervehicleid = GetPlayerFreeVehicleId(giveplayerid);
		if(playervehicleid == -1) return SendClientMessage(playerid, COLOR_GREY, "ERROR: That player can't have more cars.");
		new Float:X,Float:Y,Float:Z;
	    GetPlayerPos(giveplayerid,X,Y,Z);
	    new Float:Angle;
	    GetPlayerFacingAngle(giveplayerid,Angle);
	    new car = CreatePlayerVehicle(giveplayerid, playervehicleid, modelid, X, Y, Z, Angle, color1, color2);
	    if(car == INVALID_PLAYER_VEHICLE_ID)
		{
		    SendClientMessage(playerid, COLOR_GREY, "ERROR: Something went wrong and the car didn't got created.");
		}
	    else
	    {
            format(string, sizeof(string), " Vehicle successfully created with ID %d.", car);
		    SendClientMessage(playerid, COLOR_GRAD1, string);
	    }
	}
	if(strcmp(cmd, "/destroypvehicle", true) == 0)
	{
	    if (!IsPlayerAdmin(playerid))
	    {
	        SendClientMessage(playerid, COLOR_GREY, " You are not allowed to use this command.");
	        return 1;
	    }
		tmp = strtok(cmdtext,idx);
		new vehicleid;
		if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /destroypvehicle [playerid/partOfName] [vehicleid]");
		    return 1;
	    }
	    giveplayerid = ReturnUser(tmp);
		tmp = strtok(cmdtext, idx);
		if (!strlen(tmp))
	    {
		    SendClientMessage(playerid, COLOR_GREY, "USAGE: /destroypvehicle [playerid/partOfName] [vehicleid]");
		    return 1;
	    }
		vehicleid = strval(tmp);
		new playervehicleid = GetPlayerVehicle(giveplayerid, vehicleid);
		if(playervehicleid == -1) return SendClientMessage(playerid, COLOR_GREY, "ERROR: That player doesn't own that vehicle.");
		DestroyPlayerVehicle(giveplayerid, playervehicleid);
	}
	if(strcmp(cmd, "/buylock", true) == 0) /*Check*/
	{
		if(IsPlayerConnected(playerid))
		{
			if(!IsAt247(playerid))//centerpoint 24-7
			{
				SendClientMessage(playerid, COLOR_GRAD2, "   You are not in a 24-7 !");
				return 1;
			}
			ShowPlayerDialog(playerid, DIALOG_CDLOCKBUY, DIALOG_STYLE_LIST, "24/7", "[$10000]Alarm Lock\n[$50000]Electric Lock\n[$100000]Industrial Lock", "Buy", "Cancel");
		}
	}
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new string[128];
    if(dialogid == DIALOG_CDEDIT)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
            if(listitem == 0) // New Vehicle
			{
				format(string,256,"Please type the model id of the new vehicle.");
		        ShowPlayerDialog(playerid,DIALOG_CDNEWVEH,DIALOG_STYLE_INPUT,"Warning:",string,"Ok","Cancel");
			}
			else if(listitem == 1) // My Vehicles
			{
				new vehicles;
                for(new i=0; i<MAX_DEALERSHIPVEHICLES; i++)
	            {
					if(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleModel][i] != 0)
					{
						vehicles++;
		                format(string, sizeof(string), "Vehicle %d| Name: %s | Price: %d.",i+1,GetVehicleName(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleId][i]),CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleCost][i]);
		                SendClientMessage(playerid, COLOR_WHITE, string);
					}
				}
				if(vehicles)
				{
				    ShowPlayerDialog(playerid, DIALOG_CDEDITCARS, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose a vehicle to edit:", "Edit", "Back");
				}
				else
				{
					SendClientMessage(playerid, COLOR_GRAD2, " This Car Dealership doesn't have any cars.");
				}
			}
			else if(listitem == 2) // Upgrade
			{
				new listitems[] = "1 Vehicle Spawn\n2 Radius\n3 Dealership Name\n4 Price";
			    ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			}
			else if(listitem == 3) // Till
			{
				new listitems[] = "1 Withdraw\n2 Deposit";
			    ShowPlayerDialog(playerid,DIALOG_CDTILL,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			}
		}
		else
		{
			SavecDealership(GetPVarInt(playerid, "editingcd"));
            SetPVarInt(playerid, "editingcd", -1);
		}
	}
	else if(dialogid == DIALOG_CDTILL)
	{ // car dealership dialog
	    if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
            if(listitem == 0) // Withdraw
			{
				format(string, sizeof(string), "You have $%d in your till account.\n\n\tHow much money to withdraw?", CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]);
				ShowPlayerDialog(playerid,DIALOG_CDWITHDRAW,DIALOG_STYLE_INPUT,"Withdraw", string,"Select","Cancel");
			}
			else if(listitem == 1) // Deposit
			{
				format(string, sizeof(string), "You have $%d in your till account.\n\n\tHow much money to deposit?", CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]);
				ShowPlayerDialog(playerid,DIALOG_CDDEPOSIT,DIALOG_STYLE_INPUT,"Deposit", string,"Select","Cancel");
			}
		}
		else
		{
            SavecDealership(GetPVarInt(playerid, "editingcd"));
            SetPVarInt(playerid, "editingcd", -1);
		}
	}
	else if(dialogid == DIALOG_CDWITHDRAW)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
		    if (IsNumeric(inputtext))
	        {
	             new money = strval(inputtext);
	             if(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill] < money)
	             {
                     format(string, sizeof(string), "You don't have that much in your till!\n\nYou have $%d in your till account.\n\n\tHow much money to withdraw?", CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]);
				     ShowPlayerDialog(playerid,DIALOG_CDWITHDRAW,DIALOG_STYLE_INPUT,"Withdraw", string,"Select","Cancel");
                     return 1;
	             }
	             CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill] -= money;
	             SetPVarInt(playerid, "Cash", GetPVarInt(playerid, "Cash")+money);
	             format(string, sizeof(string), "You have successfully withdrawn $%d from your till, new balance: $%d", money, CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]);
	             SendClientMessage(playerid, COLOR_GRAD2, string);
	             SavecDealership(GetPVarInt(playerid, "editingcd"));
                 SetPVarInt(playerid, "editingcd", -1);
			}
        }
		else
		{
             SavecDealership(GetPVarInt(playerid, "editingcd"));
             SetPVarInt(playerid, "editingcd", -1);
		}
	}
	else if(dialogid == DIALOG_CDDEPOSIT)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
		    if (IsNumeric(inputtext))
	        {
	             new money = strval(inputtext);
	             if(GetPVarInt(playerid, "Cash") < money)
	             {
                     format(string, sizeof(string), "You don't have that much in your wallet!\n\nYou have $%d in your till account.\n\n\tHow much money to deposit?", CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]);
				     ShowPlayerDialog(playerid,DIALOG_CDDEPOSIT,DIALOG_STYLE_INPUT,"Deposit", string,"Select","Cancel");
                     return 1;
	             }
	             CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill] += money;
	             SetPVarInt(playerid, "Cash", GetPVarInt(playerid, "Cash")-money);
	             format(string, sizeof(string), "You have successfully deposited $%d to your till, new balance: $%d", money, CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]);
	             SendClientMessage(playerid, COLOR_GRAD2, string);
	             SavecDealership(GetPVarInt(playerid, "editingcd"));
                 SetPVarInt(playerid, "editingcd", -1);
			}
		}
		else
		{
             SavecDealership(GetPVarInt(playerid, "editingcd"));
             SetPVarInt(playerid, "editingcd", -1);
		}
	}
	else if(dialogid == DIALOG_CDUPGRADE)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
            if(listitem == 0) // Vehicle Spawn
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Please stand where you want to have your brought vehicles spawn.");
				SendClientMessage(playerid, COLOR_GRAD2, " Once ready press the fire button.");
				SetPVarInt(playerid, "editingcdvehpos", 2);
			}
            if(listitem == 1) // Radius
			{
				ShowPlayerDialog(playerid, DIALOG_CDRADIUS, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose the new radius:", "Edit", "Back");
			}
			else if(listitem == 2) // Dealership Name
			{
				ShowPlayerDialog(playerid, DIALOG_CDNAME, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose the new name:", "Edit", "Back");
			}
			else if(listitem == 3) // Price
			{
				ShowPlayerDialog(playerid, DIALOG_CDPRICE, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose the new price:", "Edit", "Back");
			}
		}
		else
		{
            SavecDealership(GetPVarInt(playerid, "editingcd"));
            SetPVarInt(playerid, "editingcd", -1);
		}
	}
	else if(dialogid == DIALOG_CDRADIUS)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
			new d;
			d = GetPVarInt(playerid, "editingcd");
			new Float:radius = floatstr(inputtext);
			new Float:radiusex = CarDealershipInfo[d][cdRadius];
			new test = floatround(radius), test1 = floatround(radiusex);
            if (CarDealershipInfo[d][cdRadius] > radius)
	        {
				 new cost = ( test - test1 ) * ( test1 * 1000 );
				 if(GetPVarInt(playerid, "Cash") < cost)
				 {
                     format(string, sizeof(string), "ERROR: You do not have enough money for this upgrade ($%d).",cost);
                     SendClientMessage(playerid, COLOR_GREY, string);
				 }
				 format(string, sizeof(string), " Car Dealership radius upgraded from %.1f to %.1f for $%d.",radiusex, radius, cost);
                 SendClientMessage(playerid, COLOR_GREY, string);
	             CarDealershipInfo[d][cdRadius] = radius;
	             format(string,128,"Car Dealership %s\nOwner: %s\nRadius: %.1f", CarDealershipInfo[d][cdMessage], CarDealershipInfo[d][cdOwner], CarDealershipInfo[d][cdRadius]);
	             UpdateDynamic3DTextLabelText(CarDealershipInfo[d][cdTextLabel], COLOR_GREEN, string);
	             new listitems[] = "1 Vehicle Spawn\n2 Radius\n3 Dealership Name\n4 Price";
			     ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			     SavecDealership(GetPVarInt(playerid, "editingcd"));
	        }
		}
		else
		{
		    new listitems[] = "1 Vehicle Spawn\n2 Radius\n3 Dealership Name\n4 Price";
			ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
		}
	}
	else if(dialogid == DIALOG_CDNAME)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
			new d;
			d = GetPVarInt(playerid, "editingcd");
            if (!strlen(inputtext))
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "** You must type a name **");
    	        ShowPlayerDialog(playerid, DIALOG_CDNAME, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose the new name:", "Edit", "Back");
		        return 1;
			}
			new cost = strlen(inputtext) * 50;
			format(string, sizeof(string), " Car Dealership name upgraded from %s to %s for $%d.", CarDealershipInfo[d][cdMessage], inputtext, cost);
            SendClientMessage(playerid, COLOR_GREY, string);
	        strmid(CarDealershipInfo[d][cdMessage], inputtext, 0, strlen(inputtext), 255);
	        format(string,128,"Car Dealership %s\nOwner: %s\nRadius: %.1f", CarDealershipInfo[d][cdMessage], CarDealershipInfo[d][cdOwner], CarDealershipInfo[d][cdRadius]);
	        UpdateDynamic3DTextLabelText(CarDealershipInfo[d][cdTextLabel], COLOR_GREEN, string);
	        new listitems[] = "1 Vehicle Spawn\n2 Radius\n3 Dealership Name\n4 Price";
			ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			SavecDealership(GetPVarInt(playerid, "editingcd"));
		}
		else
		{
		    new listitems[] = "1 Vehicle Spawn\n2 Radius\n3 Dealership Name\n4 Price";
			ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
		}
	}
	else if(dialogid == DIALOG_CDEDITCARS)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
			new cdvid;
            if (IsNumeric(inputtext))
	        {
	             cdvid = strval(inputtext);
	             if(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleModel][cdvid-1])
	             {
	                 SetPVarInt(playerid, "editingcdveh", cdvid-1);
	                 new listitems[] = "1 Edit Model\n2 Edit Cost\n3 Edit Park\n4 Delete Vehicle";
			         ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
				 }
	        }
		}
		else
		{
		    new listitems[] = "1 New Vehicle\n2 My Vehicles\n3 Upgrade\n4 Till";
			ShowPlayerDialog(playerid,DIALOG_CDEDIT,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
		}
	}
	else if(dialogid == DIALOG_CDEDITONE)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdveh") != -1)
		{
            if(listitem == 0) // Edit Model
			{
	             ShowPlayerDialog(playerid, DIALOG_CDEDITMODEL, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose the new model id:", "Edit", "Back");
	        }
	        else if(listitem == 1) // Edit Cost
			{
	             ShowPlayerDialog(playerid, DIALOG_CDEDITCOST, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose the new price of the car:", "Edit", "Back");
	        }
	        else if(listitem == 2) // Edit Park
			{
				 PutPlayerInVehicle(playerid, CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleId][GetPVarInt(playerid, "editingcdveh")], 0);
	             SendClientMessage(playerid, COLOR_GRAD2, " Please stand where you want to park the vehicle.");
				 SendClientMessage(playerid, COLOR_GRAD2, " Once ready press the fire button.");
				 SetPVarInt(playerid, "editingcdvehpos", 1);
	        }
	        else if(listitem == 3) // Delete Vehicle
			{
	             format(string,256,"Are you sure you want to delete this %s?\nNote: You will not get any refounds.",
				 GetVehicleName(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleId][GetPVarInt(playerid, "editingcdveh")]));
		         ShowPlayerDialog(playerid,DIALOG_CDDELVEH,DIALOG_STYLE_MSGBOX,"Warning:",string,"Ok","Cancel");
	        }
		}
		else
		{
            SavecDealership(GetPVarInt(playerid, "editingcd"));
            SetPVarInt(playerid, "editingcdveh", -1);
		}
	}
    else if(dialogid == DIALOG_CDEDITMODEL)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdveh") != -1)
		{
			new modelid, d, v;
			new text_info[128];
			d = GetPVarInt(playerid, "editingcd");
			v = GetPVarInt(playerid, "editingcdveh");
            if (IsNumeric(inputtext))
	        {
	             modelid = strval(inputtext);
	             if(modelid < 400 || modelid > 611) { SendClientMessage(playerid, COLOR_GREY, "   Vehicle Number can't be below 400 or above 611 !"); return 1; }
	             CarDealershipInfo[d][cdVehicleModel][v] = modelid;
	             DestroyDynamic3DTextLabel(CarDealershipInfo[d][cdVehicleLabel][v]);
	             DestroyVehicle(CarDealershipInfo[d][cdVehicleId][v]);
	             new carcreated;
	             carcreated = CreateVehicle(CarDealershipInfo[d][cdVehicleModel][v], CarDealershipInfo[d][cdVehicleSpawnX][v], CarDealershipInfo[d][cdVehicleSpawnY][v], CarDealershipInfo[d][cdVehicleSpawnZ][v], CarDealershipInfo[d][cdVehicleSpawnAngle][v], 0, 0, 6);
		         format(text_info,256,"%s For Sale | Price: %d", GetVehicleName(carcreated), CarDealershipInfo[d][cdVehicleCost][v]);
                 CarDealershipInfo[d][cdVehicleLabel][v] = CreateDynamic3DTextLabel(text_info,COLOR_LIGHTBLUE,0.0, 0.0, 0.0,8.0,INVALID_PLAYER_ID,carcreated);
	             CarDealershipInfo[d][cdVehicleId][v] = carcreated;
	             new listitems[] = "1 Edit Model\n2 Edit Cost\n3 Edit Park\n4 Delete Vehicle";
			     ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
			     SavecDealership(d);
	        }
		}
		else
		{
		    new listitems[] = "1 Edit Model\n2 Edit Cost\n3 Edit Park\n4 Delete Vehicle";
			ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
		}
	}
	else if(dialogid == DIALOG_CDEDITCOST)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdveh") != -1)
		{
			new price, d, v;
			new text_info[128];
			d = GetPVarInt(playerid, "editingcd");
			v = GetPVarInt(playerid, "editingcdveh");
            if (IsNumeric(inputtext))
	        {
	             price = strval(inputtext);
	             CarDealershipInfo[d][cdVehicleCost][v] = price;
	             format(text_info,256,"%s For Sale | Price: %d", GetVehicleName(CarDealershipInfo[d][cdVehicleId][v]), CarDealershipInfo[d][cdVehicleCost][v]);
	             UpdateDynamic3DTextLabelText(CarDealershipInfo[d][cdVehicleLabel][v], COLOR_LIGHTBLUE, text_info);
	             new listitems[] = "1 Edit Model\n2 Edit Cost\n3 Edit Park\n4 Delete Vehicle";
			     ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
			     SavecDealership(d);
	        }
		}
		else
		{
		    new listitems[] = "1 Edit Model\n2 Edit Cost\n3 Edit Park\n4 Delete Vehicle";
			ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
		}
	}
	else if(dialogid == DIALOG_CDDELVEH)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdveh") != -1)
		{
			DestroyCarDealershipVehicle(GetPVarInt(playerid, "editingcd"), GetPVarInt(playerid, "editingcdveh"));
			SavecDealership(GetPVarInt(playerid, "editingcd"));
		}
		else
		{
		    new listitems[] = "1 Edit Model\n2 Edit Cost\n3 Edit Park\n4 Delete Vehicle";
			ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
		}
	}
	else if(dialogid == DIALOG_CDEDITPARK)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdveh") != -1 &&  GetPVarInt(playerid, "editingcdvehpos") == 1 || GetPVarInt(playerid, "editingcdvehnew"))
		{
			new Float: x, Float: y, Float: z, Float: a;
			new d, v, text_info[128];
			d = GetPVarInt(playerid, "editingcd");
			v = GetPVarInt(playerid, "editingcdveh");
			GetVehiclePos(CarDealershipInfo[d][cdVehicleId][v], x, y, z);
	        GetVehicleZAngle(CarDealershipInfo[d][cdVehicleId][v], a);
			if(IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[d][cdRadius], CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]))
		    {
			     CarDealershipInfo[d][cdVehicleSpawnX][v] = x;
                 CarDealershipInfo[d][cdVehicleSpawnY][v] = y;
                 CarDealershipInfo[d][cdVehicleSpawnZ][v] = z;
                 CarDealershipInfo[d][cdVehicleSpawnAngle][v] = a;
                 SetPVarInt(playerid, "editingcdvehpos", 0);
                 SetPVarInt(playerid, "editingcdvehnew", 0);
                 DestroyDynamic3DTextLabel(CarDealershipInfo[d][cdVehicleLabel][v]);
	             DestroyVehicle(CarDealershipInfo[d][cdVehicleId][v]);
	             new carcreated;
	             carcreated = CreateVehicle(CarDealershipInfo[d][cdVehicleModel][v], CarDealershipInfo[d][cdVehicleSpawnX][v], CarDealershipInfo[d][cdVehicleSpawnY][v], CarDealershipInfo[d][cdVehicleSpawnZ][v], CarDealershipInfo[d][cdVehicleSpawnAngle][v], 0, 0, 6);
		         format(text_info,256,"%s For Sale | Price: %d", GetVehicleName(carcreated), CarDealershipInfo[d][cdVehicleCost][v]);
                 CarDealershipInfo[d][cdVehicleLabel][v] = CreateDynamic3DTextLabel(text_info,COLOR_LIGHTBLUE,0.0, 0.0, 0.0,8.0,INVALID_PLAYER_ID,carcreated);
	             CarDealershipInfo[d][cdVehicleId][v] = carcreated;
	             TogglePlayerControllable(playerid, true);
	             new listitems[] = "1 Edit Model\n2 Edit Cost\n3 Edit Park\n4 Delete Vehicle";
			     ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
			     SavecDealership(d);
			}
			else
			{
                 SendClientMessage(playerid, COLOR_GREY, "ERROR: You are out of this Car Dealership radius, please try again.");
                 TogglePlayerControllable(playerid, true);
			}
		}
		else if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdvehpos") == 2)
		{
			new Float: x, Float: y, Float: z, Float: a;
			new d;
			GetPlayerPos(playerid,x,y,z);
	        GetPlayerFacingAngle(playerid, a);
			d = GetPVarInt(playerid, "editingcd");
			if(IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[d][cdRadius], CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]))
		    {
			     CarDealershipInfo[d][cdVehicleSpawn][0] = x;
                 CarDealershipInfo[d][cdVehicleSpawn][1] = y;
                 CarDealershipInfo[d][cdVehicleSpawn][2] = z;
                 CarDealershipInfo[d][cdVehicleSpawn][3] = a;
                 SetPVarInt(playerid, "editingcdvehpos", 0);
	             TogglePlayerControllable(playerid, true);
	             new listitems[] = "1 Vehicle Spawn\n2 Radius\n3 Dealership Name\n4 Price";
			     ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			     SavecDealership(d);
			}
			else
			{
                 SendClientMessage(playerid, COLOR_GREY, "ERROR: You are out of this Car Dealership radius, please try again.");
                 TogglePlayerControllable(playerid, true);
			}
		}
		else if(!response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdvehpos") == 1)
		{
            new listitems[] = "1 Edit Model\n2 Edit Cost\n3 Edit Park\n4 Delete Vehicle";
			ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
			TogglePlayerControllable(playerid, true);
			SetPVarInt(playerid, "editingcdvehpos", 0);
		}
		else if(!response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdvehpos") == 2)
		{
            new listitems[] = "1 Vehicle Spawn\n2 Radius\n3 Dealership Name\n4 Price";
		    ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			TogglePlayerControllable(playerid, true);
			SetPVarInt(playerid, "editingcdvehpos", 0);
		}
	}
	else if(dialogid == DIALOG_CDNEWVEH)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
			new modelid, d;
			new Float: x, Float: y, Float: z, Float: a;
			new text_info[128];
			d = GetPVarInt(playerid, "editingcd");
			GetPlayerPos(playerid,x,y,z);
	        GetPlayerFacingAngle(playerid, a);
	        if (!IsNumeric(inputtext)) return SendClientMessage(playerid, COLOR_GRAD1, "ERROR: Model ID must be numbers.");
            if (IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[d][cdRadius], CarDealershipInfo[d][cdEntranceX], CarDealershipInfo[d][cdEntranceY], CarDealershipInfo[d][cdEntranceZ]))
	        {
	             modelid = strval(inputtext);
	             if(modelid < 400 || modelid > 611) { SendClientMessage(playerid, COLOR_GREY, "   Vehicle Number can't be below 400 or above 611 !"); return 1; }
	             new cdvehicleid = CreateCarDealershipVehicle(d, modelid, x, y, z, a, 1337);
	             if(cdvehicleid == -1)
		         {
		             SendClientMessage(playerid, COLOR_GREY, "ERROR: Car couldn't be created.");
		         }
	             else
	             {
					 PutPlayerInVehicle(playerid, CarDealershipInfo[d][cdVehicleId][cdvehicleid], 0);
                     format(text_info, sizeof(text_info), " Car Dealership Vehicle created with Vehicle ID %d.", cdvehicleid-1);
		             SendClientMessage(playerid, COLOR_GRAD1, text_info);
		             SendClientMessage(playerid, COLOR_GRAD2, " Please stand where you want to add your new vehicle.");
				     SendClientMessage(playerid, COLOR_GRAD2, " Once ready press the fire button.");
				     SetPVarInt(playerid, "editingcdvehnew", 1);
		             SetPVarInt(playerid, "editingcdveh", cdvehicleid);
	             }
	        }
	        else
	        {
                 SendClientMessage(playerid, COLOR_GREY, "ERROR: You are out of this Car Dealership radius, please try again.");
                 TogglePlayerControllable(playerid, true);
	        }
		}
		else
		{
            TogglePlayerControllable(playerid, true);
			SetPVarInt(playerid, "editingcd", -1);
		}
	}
	else if(dialogid == DIALOG_CDBUY)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		new v = GetCarDealershipVehicleId(vehicleid);
		new d = GetCarDealershipId(vehicleid);
		if(response)
		{
            if(CarDealershipInfo[d][cdVehicleSpawn][0] == 0.0 && CarDealershipInfo[d][cdVehicleSpawn][1] == 0.0 && CarDealershipInfo[d][cdVehicleSpawn][2] == 0.0)
            {
				SendClientMessage(playerid, COLOR_GRAD1, "ERROR: The owner of this Car Dealership hasen't set the brought vehicles spawn point.");
				RemovePlayerFromVehicle(playerid);
				return 1;
            }
            if(GetPVarInt(playerid, "Cash") < CarDealershipInfo[d][cdVehicleCost][v])
            {
				SendClientMessage(playerid, COLOR_GRAD1, "ERROR: You don't have enough money to buy this.");
				RemovePlayerFromVehicle(playerid);
				return 1;
            }
            new playervehicleid = GetPlayerFreeVehicleId(playerid);
		    if(playervehicleid == -1) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You can't have more cars.");
		    new randcolor1 = Random(0, 126);
		    new randcolor2 = Random(0, 126);
		    SetPlayerPos(playerid, CarDealershipInfo[d][cdVehicleSpawn][0], CarDealershipInfo[d][cdVehicleSpawn][1], CarDealershipInfo[d][cdVehicleSpawn][2]+2);
            new car = CreatePlayerVehicle(playerid, playervehicleid, CarDealershipInfo[d][cdVehicleModel][v], CarDealershipInfo[d][cdVehicleSpawn][0], CarDealershipInfo[d][cdVehicleSpawn][1], CarDealershipInfo[d][cdVehicleSpawn][2], CarDealershipInfo[d][cdVehicleSpawn][3], randcolor1, randcolor2);
	        if(car == INVALID_PLAYER_VEHICLE_ID)
		    {
		        SendClientMessage(playerid, COLOR_GREY, "ERROR: Something went wrong and the car didn't get created.");
		    }
	        else
	        {
				SetTimerEx("PutPlayerInVeh", 2000, 0, "dd", playerid, car);
                format(string, sizeof(string), " Thank you for buying at %s.", CarDealershipInfo[d][cdMessage]);
		        SendClientMessage(playerid, COLOR_GRAD1, string);
		        SetPVarInt(playerid, "Cash", GetPVarInt(playerid, "Cash")-CarDealershipInfo[d][cdVehicleCost][v]);
		        CarDealershipInfo[d][cdTill] += ( CarDealershipInfo[d][cdVehicleCost][v] * 40 ) / ( 100 );
		        SavecDealership(GetPVarInt(playerid, "editingcd"));
	        }
		}
		else
		{
            RemovePlayerFromVehicle(playerid);
			return 1;
		}
	}
	else if(dialogid == DIALOG_CDSELL)
	{
		if(response)
		{
			if(GetPVarInt(playerid, "editingcd") == -1) return 1;
            SetPVarInt(playerid, "Cash", GetPVarInt(playerid, "Cash")+ (CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdPrice] / 2));
			SellCarDealership(GetPVarInt(playerid, "editingcd"));
			PlayerPlayMusic(playerid);
			format(string, sizeof(string), "Car Dealership successfully sold for %d.", CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdPrice] / 2);
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
		else
		{
            SetPVarInt(playerid, "editingcd", -1);
			return 1;
		}
	}
	if(dialogid == DIALOG_CDLOCKBUY)
	{
		if(response)
		{
			if(listitem == 0)
			{
				if(GetPlayerFreeVehicleId(playerid) != -1)
				{
				    if(GetPVarInt(playerid, "Cash") < 10000)
			        {
                        SendClientMessage(playerid, COLOR_GRAD2, "   Not enough money!");
                        return 1;
					}
					SetPVarInt(playerid, "lockmenu", 1);
                    for(new i=0; i<MAX_PLAYERVEHICLES; i++)
	                {
					     if(PlayerVehicleInfo[playerid][i][pvId] != 0)
					     {
		                     format(string, sizeof(string), "Vehicle %d| Name: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
		                     SendClientMessage(playerid, COLOR_WHITE, string);
					     }
				    }
				    ShowPlayerDialog(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "24-7;"," Select a vehicle to install this:", "Select", "Cancel");

				}
				else
				{
					SendClientMessage(playerid, COLOR_WHITE, "You do not have any Cars where we can install this item.");
					return 1;
				}
			}
			if(listitem == 1)
			{
				if(GetPlayerFreeVehicleId(playerid) != -1)
				{
				    if(GetPVarInt(playerid, "Cash") < 50000)
			        {
                        SendClientMessage(playerid, COLOR_GRAD2, "   Not enough money!");
                        return 1;
					}
					SetPVarInt(playerid, "lockmenu", 2);
				    for(new i=0; i<MAX_PLAYERVEHICLES; i++)
	                {
					     if(PlayerVehicleInfo[playerid][i][pvId] != 0)
					     {
		                     format(string, sizeof(string), "Vehicle %d| Name: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
		                     SendClientMessage(playerid, COLOR_WHITE, string);
					     }
				    }
				    ShowPlayerDialog(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "24-7;"," Select a vehicle to install this:", "Select", "Cancel");
				}
				else
				{
					SendClientMessage(playerid, COLOR_WHITE, "You do not have any Cars where we can install this item.");
					return 1;
				}
			}
			if(listitem == 2)
			{
				if(GetPlayerFreeVehicleId(playerid) != -1)
				{
				    if(GetPVarInt(playerid, "Cash") < 100000)
			        {
                        SendClientMessage(playerid, COLOR_GRAD2, "   Not enough money!");
                        return 1;
					}
					SetPVarInt(playerid, "lockmenu", 3);
				    for(new i=0; i<MAX_PLAYERVEHICLES; i++)
	                {
					     if(PlayerVehicleInfo[playerid][i][pvId] != 0)
					     {
		                     format(string, sizeof(string), "Vehicle %d| Name: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
		                     SendClientMessage(playerid, COLOR_WHITE, string);
					     }
				    }
				    ShowPlayerDialog(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "24-7;"," Select a vehicle to install this:", "Select", "Cancel");
				}
				else
				{
					SendClientMessage(playerid, COLOR_WHITE, "You do not have any Cars where we can install this item.");
					return 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_CDLOCKMENU)
	{
		if(response)
		{
		if(GetPVarInt(playerid, "lockmenu") == 1)
		{
            new pvid;
            if (IsNumeric(inputtext))
	        {
				pvid = strval(inputtext)-1;
			    if(PlayerVehicleInfo[playerid][pvid][pvId] == 0)
			    {
				    SendClientMessage(playerid, COLOR_GRAD4, "ERROR: You don't have a vehicle in this slot.");
				    SetPVarInt(playerid, "lockmenu", 0);
				    return 1;
			    }
			    if(PlayerVehicleInfo[playerid][pvid][pvLock] == 1)
			    {
				    SendClientMessage(playerid, COLOR_GRAD4, "ERROR: You already have this item installed on this vehicle.");
				    SetPVarInt(playerid, "lockmenu", 0);
				    return 1;
			    }
			    format(string, sizeof(string), "   You have Purchased an Alarm Lock !");
			    SendClientMessage(playerid, COLOR_GRAD4, string);
			    SendClientMessage(playerid, COLOR_YELLOW, "HINT: You can now use /pvlock to lock your car.");
			    SetPVarInt(playerid, "Cash", GetPVarInt(playerid, "Cash")-10000);
			    PlayerVehicleInfo[playerid][pvid][pvLock] = 1;
			    SetPVarInt(playerid, "lockmenu", 0);
		    }
		}
		else if(GetPVarInt(playerid, "lockmenu") == 2)
		{
		    new pvid;
            if (IsNumeric(inputtext))
	        {
	            pvid = strval(inputtext)-1;
			    if(PlayerVehicleInfo[playerid][pvid][pvId] == 0)
			    {
					SendClientMessage(playerid, COLOR_GRAD4, "ERROR: You don't have a vehicle in this slot.");
					SetPVarInt(playerid, "lockmenu", 0);
					return 1;
				}
				if(PlayerVehicleInfo[playerid][pvid][pvLock] == 2)
				{
					SendClientMessage(playerid, COLOR_GRAD4, "ERROR: You already have this item installed on this vehicle.");
					SetPVarInt(playerid, "lockmenu", 0);
					return 1;
				}
				format(string, sizeof(string), "   You have Purchased an Electric Shock Lock !");
				SendClientMessage(playerid, COLOR_GRAD4, string);
				SendClientMessage(playerid, COLOR_YELLOW, "HINT: You can now use /pvlock to lock your car.");
				SetPVarInt(playerid, "Cash", GetPVarInt(playerid, "Cash")-50000);
				PlayerVehicleInfo[playerid][pvid][pvLock] = 2;
				SetPVarInt(playerid, "lockmenu", 0);
			}
		}
		else if(GetPVarInt(playerid, "lockmenu") == 3)
		{
		    new pvid;
            if (IsNumeric(inputtext))
	        {
                pvid = strval(inputtext)-1;
			    if(PlayerVehicleInfo[playerid][pvid][pvId] == 0)
			    {
				    SendClientMessage(playerid, COLOR_GRAD4, "ERROR: You don't have a vehicle in this slot.");
				    SetPVarInt(playerid, "lockmenu", 0);
	                return 1;
			    }
			    if(PlayerVehicleInfo[playerid][pvid][pvLock] == 3)
		  	    {
				    SendClientMessage(playerid, COLOR_GRAD4, "ERROR: You already have this item installed on this vehicle.");
				    SetPVarInt(playerid, "lockmenu", 0);
				    return 1;
			    }
			    format(string, sizeof(string), "   You have Purchased an Industrial Lock !");
			    SendClientMessage(playerid, COLOR_GRAD4, string);
			    SendClientMessage(playerid, COLOR_YELLOW, "HINT: You can now use /pvlock to lock your car.");
			    SetPVarInt(playerid, "Cash", GetPVarInt(playerid, "Cash")-100000);
			    PlayerVehicleInfo[playerid][pvid][pvLock] = 3;
			    SetPVarInt(playerid, "lockmenu", 0);
		    }
		}
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new string[128];
    if(newstate == PLAYER_STATE_DRIVER)
	{
	    new newcar = GetPlayerVehicleID(playerid);
	    if(GetCarDealershipVehicleId(newcar) != -1 && GetCarDealershipVehicleId(newcar) == GetPVarInt(playerid, "editingcdveh")) return 1;
        if(GetCarDealershipVehicleId(newcar) != -1)
        {
			format(string,256,"Would you like to buy this %s?\n\nThis vehicle costs $%d.", GetVehicleName(newcar), CarDealershipInfo[GetCarDealershipId(newcar)][cdVehicleCost][GetCarDealershipVehicleId(newcar)]);
		    ShowPlayerDialog(playerid,DIALOG_CDBUY,DIALOG_STYLE_MSGBOX,"Warning:",string,"Buy","Cancel");
		    return 1;
        }
        new sendername[MAX_PLAYER_NAME];
        new v;
        for(new i = 0; i < MAX_PLAYERS; i++)
	    {
		    if(IsPlayerConnected(i))
		    {
			    v = GetPlayerVehicle(i, newcar);
			    if(v != -1)
			    {
					if(i == playerid) goto owner;
					new Float:x, Float: y, Float: z;
					GetVehiclePos(newcar, x, y, z);
					if(PlayerVehicleInfo[i][v][pvLocked] == 1 && PlayerVehicleInfo[i][v][pvLock] == 1)
					{
						for(new d = 0; d < MAX_PLAYERS; d++)
						{
							 if(IsPlayerInRangeOfPoint(d, 30.0, x, y, z))
							 {
								 MeepMeep(playerid, newcar);
								 SetTimerEx("MeepMeep", 1000, 0, "dd", playerid, newcar);
							 }
						}
                        format(string, sizeof(string), "*Car Alarm: BEEP BEEP BEEP BEEP BEEP BEEP BEEP BEEP BEEP");
		                ProxDetector(60.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
					else if(PlayerVehicleInfo[i][v][pvLocked] == 1 && PlayerVehicleInfo[i][v][pvLock] == 2)
					{
                        new player[MAX_PLAYER_NAME];
			            GetPlayerName(playerid, player, sizeof(player));
			            format(string, sizeof(string), "* %s gets electrified by the car lock",player);
			            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			            new Float:X, Float:Y, Float:Z, Float:HP;
			            GetPlayerPos(playerid, X, Y, Z);
			            SetPlayerPos(playerid, X, Y, Z+1);
			            RemovePlayerFromVehicle(playerid);
			            TogglePlayerControllable(playerid,0);
			            SetTimerEx("ReleasePlayer", 10000, 0, "d", playerid);
			            GameTextForPlayer(playerid,"~r~ELECTRIFIED!!!",10000,1);
			            GetPlayerHealth(playerid,HP);
			            SetPlayerHealth(playerid,HP-15);
			            return 1;
					}
					GetPlayerName(i, sendername, sizeof(sendername));
                    format(string,256,"Warning: This %s is owned by %s.", GetVehicleName(newcar), sendername);
                    SendClientMessage(playerid, COLOR_GREY, string);
					owner:
					if(i == playerid)
					{
                        format(string,256," You are the owner of this %s.", GetVehicleName(newcar));
                        SendClientMessage(playerid, COLOR_GREY, string);
					}
				}
			}
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (IsKeyJustDown(KEY_FIRE, newkeys, oldkeys))
    {
	    if(IsPlayerConnected(playerid))
		{
			new string[128];
			if(GetPVarInt(playerid, "editingcdvehpos"))
			{
				TogglePlayerControllable(playerid, false);
				format(string,256,"Is this the new position you want?.");
		        ShowPlayerDialog(playerid,DIALOG_CDEDITPARK,DIALOG_STYLE_MSGBOX,"Warning:",string,"Ok","Cancel");
			}
			if(GetPVarInt(playerid, "editingcdvehnew"))
			{
                TogglePlayerControllable(playerid, false);
                format(string,256,"Is this the new position you want?.");
		        ShowPlayerDialog(playerid,DIALOG_CDEDITPARK,DIALOG_STYLE_MSGBOX,"Warning:",string,"Ok","Cancel");
			}
		}
	}
	return 1;
}
