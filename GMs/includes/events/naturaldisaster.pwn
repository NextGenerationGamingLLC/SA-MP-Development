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
		- Jingles
		
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

new const gLocalZones[][SAZONE_MAIN] = { 
	//	NAME                         
	{"The Big Ear",	                {-410.00,1403.30,-3.00,-137.90,1681.20,200.00}},
	{"Angel Pine",                  {-2324.90,-2584.20,-6.10,-1964.20,-2212.10,200.00}},
	{"Bayside",                     {-2741.00,2175.10,0.00,-2353.10,2722.70,200.00}},
	{"Blueberry",                   {19.60,-404.10,3.80,349.60,-220.10,200.00}},
	{"City Hall",                   {-2867.80,277.40,-9.10,-2593.40,458.40,200.00}},
	{"Dillimore",                   {580.70,-674.80,-9.50,861.00,-404.70,200.00}},
	{"Doherty",                     {-2270.00,-324.10,-0.00,-1794.90,-222.50,200.00}},
	{"Downtown",                    {-1993.20,265.20,-9.10,-1794.90,578.30,200.00}},
	{"Downtown Los Santos",         {1463.90,-1430.80,-89.00,1724.70,-1290.80,110.90}},
	{"East Beach",                  {2632.80,-1852.80,-89.00,2959.30,-1668.10,110.90}},
	{"Flint Intersection",          {-187.70,-1596.70,-89.00,17.00,-1276.60,110.90}},
	{"Flint Range",                 {-594.10,-1648.50,0.00,-187.70,-1276.60,200.00}},
	{"Ganton",                      {2222.50,-1722.30,-89.00,2632.80,-1628.50,110.90}},
	{"Glen Park",                   {1812.60,-1350.70,-89.00,2056.80,-1100.80,110.90}},
	{"Hilltop Farm",                {967.30,-450.30,-3.00,1176.70,-217.90,200.00}},
	{"Idlewood",                    {1971.60,-1852.80,-89.00,2222.50,-1742.30,110.90}},
	{"Jefferson",                   {2056.80,-1449.60,-89.00,2266.20,-1372.00,110.90}},
	{"Little Mexico",               {1758.90,-1722.20,-89.00,1812.60,-1577.50,110.90}},
	{"Los Santos International",    {2051.60,-2597.20,-39.00,2152.40,-2394.30,60.90}},
	{"Marina",                      {807.90,-1577.50,-89.00,926.90,-1416.20,110.90}},
	{"Market",                      {787.40,-1416.20,-89.00,1072.60,-1310.20,110.90}},
	{"Montgomery",                  {1119.50,119.50,-3.00,1451.40,493.30,200.00}},
	{"Montgomery Intersection",     {1582.40,347.40,0.00,1664.60,401.70,200.00}},
	{"Mulholland",                  {1414.00,-768.00,-89.00,1667.60,-452.40,110.90}},
	{"Mulholland Intersection",     {1463.90,-1150.80,-89.00,1812.60,-768.00,110.90}},
	{"Ocean Docks",                 {2324.00,-2145.10,-89.00,2703.50,-2059.20,110.90}},
	{"Palomino Creek",              {2160.20,-149.00,0.00,2576.90,228.30,200.00}},
	{"Pershing Square",             {1440.90,-1722.20,-89.00,1583.50,-1577.50,110.90}},
	{"Richman",                     {647.50,-1118.20,-89.00,787.40,-954.60,110.90}},
	{"Rodeo",                       {334.50,-1406.00,-89.00,466.20,-1292.00,110.90}},
	{"Santa Maria Beach",           {342.60,-2173.20,-89.00,647.70,-1684.60,110.90}},
	{"Temple",                      {1252.30,-1130.80,-89.00,1378.30,-1026.30,110.90}},
	{"The Panopticon",              {-947.90,-304.30,-1.10,-319.60,327.00,200.00}},
	{"The Sherman Dam",             {-968.70,1929.40,-3.00,-481.10,2155.20,200.00}},
	{"Unity Station",               {1692.60,-1971.80,-20.40,1812.60,-1932.80,79.50}},
	{"Verdant Bluffs",              {1249.60,-2179.20,-89.00,1692.60,-1842.20,110.90}},
	{"Verona Beach",                {647.70,-2173.20,-89.00,930.20,-1804.20,110.90}},
	{"Vinewood",                    {787.40,-1310.20,-89.00,952.60,-1130.80,110.90}},
	{"Willowfield",                 {2541.70,-2059.20,-89.00,2703.50,-1941.40,110.90}}
};

#include <YSI\y_hooks>

#define TYPE_EARTHQUAKE 0
#define TYPE_SANDSTORM 1
#define TYPE_FLOOD 2
#define TYPE_HURRICANE 3
#define TYPE_NUKE 4
#define TYPE_ALIENS 5


#define MAX_NATDIS_ZONES 20

#define MAX_NATDIS_MAPS 5

#define NATDIS_MAPAREA_DOWNTOWNLS 0
#define NATDIS_MAPAREA_EASTLS 1
#define NATDIS_MAPAREA_COMMERCE 2
#define NATDIS_MAPAREA_MARKET 3
#define NATDIS_MAPAREA_BRIDGES 5

enum eNatDis {
	nat_iGZID,
	nat_iAreaID,
	nat_iTypeID,
	nat_iZoneTypeID,
	nat_iZoneID,
	nat_iStatus
}
new NatDis[MAX_NATDIS_ZONES][eNatDis];

new Float:g_aMarketExplosions[][3] = {
	{1239.3417, -1376.6849, 13.4054},
	{1127.2487, -1406.5330, 9.3318},
	{1053.9044, -1321.9883, 21.8503},
	{1241.3762, -1287.0360, 13.6125},
	{347.5374, -1527.9596, 34.8646}
};

new Float:g_aCommerceExplosions[][3] = {
	{1477.1429, -1634.7776, 18.3358},
	{1494.6349, -1727.6606, 13.7819},
	{1546.6965, -1727.1017, 13.3416},
	{1400.1318, -1728.5299, 14.7573},
	{1573.1984, -1597.7356, 13.1397}
};

new Float:g_aLSDowntownExplosions[][3] = {
	{1328.9755, -1505.3248, 18.2389},
	{1406.4028, -1447.6858, 13.8323},
	{1536.9622, -1426.4609, 17.2701},
	{1684.0129, -1435.5986, 15.7439},
	{1619.4305, -1602.2864, 14.7449}
};


new Float:g_aEastLSExplosions[][3] = {
	{2087.3225, -1765.4458, 14.6534},
	{2321.2729, -1730.1904, 13.5186},
	{2497.6470, -1688.1013, -8.7726},
	{2429.4832, -1631.7568, 15.9447},
	{2103.8589, -1821.1707, 14.8629}
};


new Float:g_aBridgesExplosions[][3] = {
	{1699.8018, 415.0071, 30.2675},
	{2767.1348, 324.4352, 5.5794},
	{611.6396, 347.4425, 15.9124},
	{-193.2310, 259.4931, 11.3849},
	{53.9346, -1534.0623, 4.0346}
};

new natdis_ptCam[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	GetPlayerNatDisZones(playerid);
	KillTimer(natdis_ptCam[playerid]);
	natdis_ptCam[playerid] = 0;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {

	KillTimer(natdis_ptCam[playerid]);
	natdis_ptCam[playerid] = -1;
}

hook OnGameModeExit()
{
	for(new i; i < MAX_NATDIS_ZONES; ++i) 
	{
		GangZoneDestroy(NatDis[i][nat_iGZID]);
		DestroyDynamicArea(NatDis[i][nat_iAreaID]);
	}
	return 1;
}

GetPlayerNatDisZones(playerid)
{
	for(new i; i < MAX_NATDIS_MAPS; ++i) {

		if(GetGVarInt("_NatDis_gMapLoaded", i))
		{
			NatDis_RemoveBuildings(playerid, TYPE_EARTHQUAKE, i);
		}
	}

	for(new i; i < MAX_NATDIS_ZONES; ++i)
	{
		if(IsValidDynamicArea(NatDis[i][nat_iAreaID]))
		{
			switch(NatDis[i][nat_iStatus])
			{
				case 1: GangZoneShowForPlayer(playerid, NatDis[i][nat_iGZID], COLOR_RED);
				case 2: GangZoneShowForPlayer(playerid, NatDis[i][nat_iGZID], COLOR_YELLOW);
				case 3: GangZoneShowForPlayer(playerid, NatDis[i][nat_iGZID], COLOR_GREEN);
			}
			GangZoneFlashForPlayer(playerid, NatDis[i][nat_iGZID], COLOR_BLACK);
			SetTimerEx("NatDis_StopFlash", 20000, false, "ii", i, playerid);
			NatDis_Effects(playerid, i, NatDis[i][nat_iTypeID], 2);
		}
	}
}

CheckNatDisZone(playerid, iTypeID, iZoneTypeID, iZoneID, iStatus)
{
	szMiscArray[0] = 0;
	new id = -1;
	for(new i; i < sizeof(NatDis); ++i)
	{
		if(NatDis[i][nat_iTypeID] == iTypeID && NatDis[i][nat_iZoneTypeID] == iZoneTypeID && NatDis[i][nat_iZoneID] == iZoneID)
		{
			id = i;
		}
	}
	if(iStatus == 0 || iStatus == 5) return DeleteNatDisZone(playerid, id);
	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `natdiszones` WHERE `id` = %d", id+1);
	return mysql_tquery(MainPipeline, szMiscArray, true, "OnCheckNatDisZone", "iiiiii", playerid, id, iTypeID, iZoneTypeID, iZoneID, iStatus);
}

forward OnCheckNatDisZone(playerid, id, iTypeID, iZoneTypeID, iZoneID, iStatus);
public OnCheckNatDisZone(playerid, id, iTypeID, iZoneTypeID, iZoneID, iStatus)
{
	new iRows = cache_get_row_count(MainPipeline);
	if(!iRows) CreateNatDisZone(playerid, iTypeID, iZoneTypeID, iZoneID, iStatus);
	else 
	{
		UpdateNatDisZone(playerid, id, iTypeID, iZoneTypeID, iZoneID, iStatus);
	}
	return 1;
}

CreateNatDisZone(playerid, iTypeID, iZoneTypeID, iZoneID, iStatus) {
	
	szMiscArray[0] = 0;
	for(new i; i < MAX_NATDIS_ZONES; ++i)
	{
		if(!IsValidDynamicArea(NatDis[i][nat_iAreaID])) {
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `natdiszones` SET `type` = '%d', `zonetype` = '%d', `zoneid` = '%d', `zonestatus` = '%d' WHERE `id` = '%d'",
				iTypeID,
				iZoneTypeID,
				iZoneID,
				iStatus,
				i+1);
			return mysql_tquery(MainPipeline, szMiscArray, true, "OnCreateNatDisZone", "iiiiii", playerid, i, iTypeID, iZoneTypeID, iZoneID, iStatus);
		}
	}
	SendClientMessage(playerid, COLOR_GRAD1, "There are no more natural disaster zones available. Please try again at a later moment.");
	return 1;
}

forward OnCreateNatDisZone(playerid, i, iTypeID, iZoneTypeID, iZoneID, iStatus);
public OnCreateNatDisZone(playerid, i, iTypeID, iZoneTypeID, iZoneID, iStatus) 
{
	szMiscArray[0] = 0;
	GetPlayerName(playerid, szMiscArray, sizeof(szMiscArray));
	switch(iZoneTypeID)
	{
		case 1:
		{
			format(szMiscArray, sizeof(szMiscArray), "[NATDIS ZONE] [Deployed by: %s] [Location: %s]", szMiscArray, gMainZones[iZoneID][SAZONE_NAME]);
			
		}
		case 2:
		{
			format(szMiscArray, sizeof(szMiscArray), "[NATDIS ZONE] [Deployed by: %s] [Location: %s]", szMiscArray, gMainZones[iZoneID][SAZONE_NAME]);			
		}
	}
	Log("logs/NatDisZones.log", szMiscArray);
	ProcessNatDisZone(i, iTypeID, iZoneTypeID, iZoneID, iStatus);
	return 1;
}

DeleteNatDisZone(playerid, id) {
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `natdiszones` SET `zonestatus` = WHERE `id` = %d", id);
	return mysql_tquery(MainPipeline, szMiscArray, true, "OnDeleteNatDisZone", "ii", playerid, id);
}

forward OnDeleteNatDisZone(playerid, id);
public OnDeleteNatDisZone(playerid, id)
{
	GangZoneDestroy(NatDis[id][nat_iGZID]);
	DestroyDynamicArea(NatDis[id][nat_iAreaID]);
	NatDis[id][nat_iTypeID] = 0;
	NatDis[id][nat_iZoneTypeID] = 0;
	NatDis[id][nat_iZoneID] = 0;
	NatDis[id][nat_iStatus] = 0;
	if(playerid == INVALID_PLAYER_ID) return 1;
	format(szMiscArray, sizeof szMiscArray, "You have successfully destroyed zone ID %i.", id);
	SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
	return 1;
}

LoadNatDisZones() {
	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `natdiszones`");
	return mysql_tquery(MainPipeline, szMiscArray, true, "OnLoadNatDisZones", "");
}

forward OnLoadNatDisZones();
public OnLoadNatDisZones() {
	new
		iFields,
		iRows,
		iCount,
		i;

	cache_get_data(iRows, iFields, MainPipeline);
	while(iCount < iRows) {
		i = cache_get_field_content_int(iCount, "id", MainPipeline);
		if(!(0 <= i < MAX_NATDIS_ZONES)) break;
		ProcessNatDisZone(i, cache_get_field_content_int(iCount, "type", MainPipeline), cache_get_field_content_int(iCount, "zonetype", MainPipeline),
			cache_get_field_content_int(iCount, "zoneid", MainPipeline), cache_get_field_content_int(iCount, "zonestatus", MainPipeline));
		iCount++;
	}
	printf("[NatDis Zones] Loaded %d Natural Disaster Zones", iCount);
	return 1;
}

UpdateNatDisZone(playerid, i, iTypeID, iZoneTypeID, iZoneID, iStatus) {
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `natdiszones` SET `type` = %d, `zonetype` = %d, `zoneid` = %d, `zonestatus` = %d WHERE id = %d", iTypeID, iZoneTypeID, iZoneID, iStatus, i+1);
	mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	format(szMiscArray, sizeof(szMiscArray), "Updated ID: %d | TypeID: %d, ZoneID: %d, Status: %d", i, iTypeID, iZoneID, iStatus);
	SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
	GangZoneDestroy(NatDis[i][nat_iGZID]);
	DestroyDynamicArea(NatDis[i][nat_iAreaID]);
	ProcessNatDisZone(i, iTypeID, iZoneTypeID, iZoneID, iStatus);
	return 1;
}


ProcessNatDisZone(i, iTypeID, iZoneTypeID, iZoneID, iStatus) {

	if(iStatus) {

		NatDis[i][nat_iTypeID] = iTypeID;
		NatDis[i][nat_iZoneTypeID] = iZoneTypeID;
		NatDis[i][nat_iZoneID] = iZoneID;
		NatDis[i][nat_iStatus] = iStatus;
		
		switch(iZoneTypeID) {
			case 1: {
				NatDis[i][nat_iGZID] = GangZoneCreate(gMainZones[iZoneID][SAZONE_AREA][0], gMainZones[iZoneID][SAZONE_AREA][1], gMainZones[iZoneID][SAZONE_AREA][3], gMainZones[iZoneID][SAZONE_AREA][4]);
				NatDis[i][nat_iAreaID] = CreateDynamicRectangle(gMainZones[iZoneID][SAZONE_AREA][0], gMainZones[iZoneID][SAZONE_AREA][1], gMainZones[iZoneID][SAZONE_AREA][3], gMainZones[iZoneID][SAZONE_AREA][4]);
			}
			case 2:
			{
				NatDis[i][nat_iGZID] = GangZoneCreate(gLocalZones[iZoneID][SAZONE_AREA][0], gLocalZones[iZoneID][SAZONE_AREA][1], gLocalZones[iZoneID][SAZONE_AREA][3], gLocalZones[iZoneID][SAZONE_AREA][4]);
				NatDis[i][nat_iAreaID] = CreateDynamicRectangle(gLocalZones[iZoneID][SAZONE_AREA][0], gLocalZones[iZoneID][SAZONE_AREA][1], gLocalZones[iZoneID][SAZONE_AREA][3], gLocalZones[iZoneID][SAZONE_AREA][4]);
			}
		}
		switch(iStatus) {

			case 1: GangZoneShowForAll(NatDis[i][nat_iGZID], COLOR_RED);
			case 2: GangZoneShowForAll(NatDis[i][nat_iGZID], COLOR_YELLOW);
			case 3: GangZoneShowForAll(NatDis[i][nat_iGZID], COLOR_GREEN);
		}

		GangZoneFlashForAll(NatDis[i][nat_iGZID], COLOR_BLACK);
		SetTimerEx("NatDis_StopFlash", 20000, false, "ii", i, INVALID_PLAYER_ID);
		foreach(new playerid : Player) SetTimerEx("NatDis_StartEffects", 2000, false, "iiii", playerid, i, TYPE_EARTHQUAKE, 2);
	}
}

forward NatDis_StartEffects(playerid, i, iTypeID, choice);
public NatDis_StartEffects(playerid, i, iTypeID, choice)
{
	NatDis_Effects(playerid, i, iTypeID, choice);
	return 1;
}

forward NatDis_StopFlash(i, playerid);
public NatDis_StopFlash(i, playerid)
{
	if(playerid != INVALID_PLAYER_ID) GangZoneStopFlashForPlayer(playerid, NatDis[i][nat_iGZID]);
	else GangZoneStopFlashForAll(NatDis[i][nat_iGZID]);
	return 1;
}
	
NatDis_MainMenu(playerid)
{
	szMiscArray[0] = 0;
	new szStatus[6][24];
	if(GetGVarInt("_NatDis_GID", TYPE_EARTHQUAKE)) szStatus[0] = "{00FF00} ACTIVE"; else szStatus[0] = "{FF0000} INACTIVE";
	if(GetGVarInt("_NatDis_GID", TYPE_SANDSTORM)) szStatus[1] ="{00FF00} ACTIVE"; else szStatus[1] = "{FF0000} INACTIVE";
	if(GetGVarInt("_NatDis_GID", TYPE_FLOOD)) szStatus[2] = "{00FF00} ACTIVE"; else szStatus[2] = "{FF0000} INACTIVE";
	if(GetGVarInt("_NatDis_GID", TYPE_HURRICANE)) szStatus[3] = "{00FF00} ACTIVE"; else szStatus[3] = "{FF0000} INACTIVE";
	if(GetGVarInt("_NatDis_GID", TYPE_NUKE)) szStatus[4] = "{00FF00} ACTIVE"; else szStatus[4] = "{FF0000} INACTIVE";
	if(GetGVarInt("_NatDis_GID", TYPE_ALIENS)) szStatus[5] = "{00FF00} ACTIVE"; else szStatus[5] = "{FF0000} INACTIVE";

	format(szMiscArray, sizeof(szMiscArray), "Earthquake\t%s\n\
		Sandstorm\t%s\n\
		Flood\t%s\n\
		Hurricane / Thunderstorm\t%s\n\
		Nuke\t%s\n\
		Aliens\t%s", szStatus[0], szStatus[1], szStatus[2], szStatus[3], szStatus[4], szStatus[5]);
	return ShowPlayerDialogEx(playerid, DIALOG_NATDIS_MAIN, DIALOG_STYLE_TABLIST, "Natural Disaster Menu", szMiscArray, "Cancel", "Select");
}

NatDis_EditDialog(playerid, iDialogID)
{
	szMiscArray[0] = 0;
	new szTitle[32];
	switch(iDialogID)
	{
		case DIALOG_NATDIS_EARTHQUAKE:
		{
			if(!GetGVarInt("_NatDis_GID", TYPE_EARTHQUAKE)) SetGVarInt("_NatDis_GID", 1, TYPE_EARTHQUAKE);
			SetPVarInt(playerid, "_EditingNasType", TYPE_EARTHQUAKE);
			format(szTitle, sizeof(szTitle), "Natural Disasters | Earthquake");
			format(szMiscArray, sizeof(szMiscArray), "\
				Initiate weather\n\
				Initiate sound\n\
				Initiate global effects\n\
				Load Area Mapping\n\
				Edit zones\n\
				___________________\n\
				Reset program");
		}
		case DIALOG_NATDIS_SANDSTORM:
		{
			if(!GetGVarInt("_NatDis_GID", TYPE_SANDSTORM)) SetGVarInt("_NatDis_GID", 1, TYPE_SANDSTORM);
			SetPVarInt(playerid, "_EditingNasType", TYPE_SANDSTORM);
			format(szTitle, sizeof(szTitle), "Natural Disasters | Sandstorm");
			format(szMiscArray, sizeof(szMiscArray), "\
				Initiate weather\n\
				Initiate sound\n\
				___________________\n\
				Reset program");
		}
		case DIALOG_NATDIS_FLOOD:
		{
			if(!GetGVarInt("_NatDis_GID", TYPE_FLOOD)) SetGVarInt("_NatDis_GID", 1, TYPE_FLOOD);
			SetPVarInt(playerid, "_EditingNasType", TYPE_FLOOD);
			format(szTitle, sizeof(szTitle), "Natural Disasters | Sandstorm");
			format(szMiscArray, sizeof(szMiscArray), "\
				Initiate weather\n\
				Initiate sound\n\
				Initiate global effects\n\
				Load Area Mapping\n\
				Edit zones\n\
				___________________\n\
				Reset program");
		}
		case DIALOG_NATDIS_NUKE: {
			if(!GetGVarInt("_NatDis_GID", TYPE_NUKE)) SetGVarInt("_NatDis_GID", 1, TYPE_NUKE);
			SetPVarInt(playerid, "_EditingNasType", TYPE_NUKE);
			format(szTitle, sizeof(szTitle), "Natural Disasters | Nuke");
			format(szMiscArray, sizeof(szMiscArray), "\
				Initiate program\n\
				Edit zones\n\
				___________________\n\
				Reset program");
		}
		case DIALOG_NATDIS_ALIENS: {

			if(!GetGVarInt("_NatDis_GID", TYPE_ALIENS)) SetGVarInt("_NatDis_GID", 1, TYPE_ALIENS);
			SetPVarInt(playerid, "_EditingNasType", TYPE_ALIENS);
			format(szTitle, sizeof(szTitle), "Natural Disasters | Nuke");
			format(szMiscArray, sizeof(szMiscArray), "\
				Spawn Ufo & Initiate Program\n\
				Edit zones\n\
				___________________\n\
				Reset program");
		}
	}
	return ShowPlayerDialogEx(playerid, iDialogID, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Back", "Select");
}

NatDis_Reset(iTypeID)
{
	NatDis_PropertyExplosions(0);
	switch(iTypeID)
	{
		case TYPE_EARTHQUAKE:
		{
			DeleteGVar("_NatDis_GID", TYPE_EARTHQUAKE);
			foreach(new i : Player) NatDis_Effects(i, 0, TYPE_EARTHQUAKE, 0);
			for(new i; i < MAX_NATDIS_ZONES; ++i)
			{
				GangZoneDestroy(NatDis[i][nat_iGZID]);
				DestroyDynamicArea(NatDis[i][nat_iAreaID]);
				DeleteNatDisZone(INVALID_PLAYER_ID, i);
			}
		}
		case TYPE_SANDSTORM:
		{
			DeleteGVar("_NatDis", TYPE_SANDSTORM);
			foreach(new i : Player) NatDis_Effects(i, 0, TYPE_SANDSTORM, 0);
			for(new i; i < MAX_NATDIS_ZONES; ++i)
			{
				GangZoneDestroy(NatDis[i][nat_iGZID]);
				DestroyDynamicArea(NatDis[i][nat_iAreaID]);
				DeleteNatDisZone(INVALID_PLAYER_ID, i);
			}
		}
		case TYPE_NUKE: {
			
			DeleteGVar("_NatDis", TYPE_NUKE);
			foreach(new i : Player) NatDis_Effects(i, 0, TYPE_EARTHQUAKE, 0);
			for(new i; i < MAX_NATDIS_ZONES; ++i)
			{
				GangZoneDestroy(NatDis[i][nat_iGZID]);
				DestroyDynamicArea(NatDis[i][nat_iAreaID]);
				DeleteNatDisZone(INVALID_PLAYER_ID, i);
			}

		}
		case TYPE_ALIENS: {

			DeleteGVar("_NatDis", TYPE_NUKE);
			foreach(new i : Player) NatDis_Effects(i, 0, TYPE_EARTHQUAKE, 0);
			for(new i; i < MAX_NATDIS_ZONES; ++i)
			{
				GangZoneDestroy(NatDis[i][nat_iGZID]);
				DestroyDynamicArea(NatDis[i][nat_iAreaID]);
				DeleteNatDisZone(INVALID_PLAYER_ID, i);
			}
			//Ufo_DestroyAdminUfo();
		}
	}
}

NatDis_PropertyExplosions(choice)
{
	switch(choice)
	{
		case 0: 
		{ 
			DeleteGVar("_NatDis_PropertyExplosions"); 
			KillTimer(GetGVarInt("_NatDis_PropExplTimer")); 
			DeleteGVar("_NatDis_PropExplTimer");
			return 1; 
		}
		case 1:
		{
			if(!GetGVarInt("_NatDis_PropertyExplosions")) return 1;
			{
				SetGVarInt("_NatDis_PropertyExplosions", 1);
			}
			if(!GetGVarInt("_NatDis_PropExplTimer")) 
				SetGVarInt("_NatDis_PropExplTimer", SetTimerEx("NatDis_PropertyExplosions", 60000, true, "i", choice));
			for(new i; i < sizeof(HouseInfo); ++i)
			{
				if(IsPointInDynamicArea(NatDis[i][nat_iAreaID], HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]))
				{
					CreateExplosion(HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ], 7, 8.0);
				}
			}
			for(new i; i < sizeof(Businesses); ++i)
			{
				if(IsPointInDynamicArea(NatDis[i][nat_iAreaID], Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]))
				{
					CreateExplosion(Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2], 7, 8.0);
				}
			}
			return 1;
		}
	}
	return 1;
}

NatDis_Effects(playerid, i, iTypeID, choice) {

	switch(choice) {

		case 0: return NatDis_StopEffects(playerid);
		case 1: {
			KillTimer(natdis_ptCam[playerid]);
			natdis_ptCam[playerid] = -1;
			natdis_ptCam[playerid] = SetTimerEx("CameraShaker", 100, true, "i", playerid);
			SetTimerEx("NatDis_StopEffects", 20000, false, "i", playerid);
			NatDis_AnimEffects(playerid);
			return 1;
		}
		case 2: // not working yet
		{
			switch(iTypeID)
			{
				case TYPE_EARTHQUAKE:
				{
					if(IsPlayerInDynamicArea(playerid, NatDis[i][nat_iAreaID]))
					{
						KillTimer(natdis_ptCam[playerid]);
						natdis_ptCam[playerid] = SetTimerEx("CameraShaker", 100, true, "i", playerid);
						SetTimerEx("NatDis_StopEffects", 10000, false, "i", playerid);
						NatDis_AnimEffects(playerid);
						SendClientMessageToAll(COLOR_WHITE, "EFFECTS");
						SetTimerEx("NatDis_StartEffects", 2000, false, "iiii", playerid, i, iTypeID, 2);
					}
				}
			}
		}
	}
	return 1;
}

NatDis_AnimEffects(playerid)
{
	new Float:fTemp[3];
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new iVehID = GetPlayerVehicleID(playerid);
		GetVehicleVelocity(iVehID, fTemp[0], fTemp[1], fTemp[2]);
		SetVehicleVelocity(iVehID, fTemp[0] + 0.3, fTemp[1] + 0.2, fTemp[2] + 0.1);
		SetVehicleAngularVelocity(iVehID, 0.0, 0.0, 0.1);
	}
	else 
	{
		SetPlayerVelocity(playerid, random(10) / 100, random(10) / 100, random(10) / 100);
		switch(random(3))
		{
			case 0: ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 0, 0, 0, 0, 6000, 1);
			case 1: ApplyAnimation(playerid, "PED", "KO_shot_face", 4.0, 0, 1, 1, 1, 6000, 1);
			case 2: ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 6000, 1);
		}
	}
}

forward NatDis_StopEffects(playerid);
public NatDis_StopEffects(playerid)
{
	ResetCameraShake(playerid);
	KillTimer(natdis_ptCam[playerid]);
	natdis_ptCam[playerid] = -1;
	return 1;
}

forward CameraShaker(playerid);
public CameraShaker(playerid)
{
	if(natdis_ptCam[playerid] == -1) return 1;
	SetPlayerDrunkLevel(playerid, 2003);
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_NATDIS_MAIN:
		{
			if(!response)
			{
				DeletePVar(playerid, "_EditingZone");
				DeletePVar(playerid, "_EditingZoneType");
				DeletePVar(playerid, "_EditingNasType");
				return 1;
			}
			switch(listitem)
			{
				case 0: return NatDis_EditDialog(playerid, DIALOG_NATDIS_EARTHQUAKE);
				case 1: return NatDis_EditDialog(playerid, DIALOG_NATDIS_SANDSTORM);
				case 2: return NatDis_EditDialog(playerid, DIALOG_NATDIS_FLOOD);
				case 3: return 1;
				case 4: NatDis_EditDialog(playerid, DIALOG_NATDIS_NUKE);
				case 5: NatDis_EditDialog(playerid, DIALOG_NATDIS_ALIENS);
			}
		}
		case DIALOG_NATDIS_EARTHQUAKE:
		{
			if(!response) return NatDis_MainMenu(playerid);
			switch(listitem)
			{
				case 0: { gWeather = 43; SetWeather(43); }
				case 1: foreach(new i : Player) PlayAudioStreamForPlayer(i, "http://localhost/audio/earthquake_siren.mp3");
				case 2: 
				{ 
					foreach(new i : Player) NatDis_Effects(i, 0, TYPE_EARTHQUAKE, 1);
					for(new iex; iex < MAX_NATDIS_MAPS; ++iex) NatDis_Explosions(iex, 1);
					NatDis_PropertyExplosions(1);
				}
				case 3: NatDis_LoadMaps(playerid);
				case 4: ShowPlayerDialogEx(playerid, DIALOG_NATDIS_EDITZONES, DIALOG_STYLE_LIST, "Natural Disaster | Edit Zones", "Cities / Mainland\nLocal Areas", "Back", "Select");
				case 5: return NatDis_MainMenu(playerid);
				case 6: NatDis_Reset(TYPE_EARTHQUAKE);
			}
			return 1;
		}
		case DIALOG_NATDIS_SANDSTORM:
		{
			if(!response) return NatDis_MainMenu(playerid);
			switch(listitem)
			{
				case 0: { gWeather = 19; SetWeather(19); }
				case 1: foreach(new i : Player) PlayAudioStreamForPlayer(i, "http://localhost/audio/earthquake_siren.mp3");
				case 5: NatDis_MainMenu(playerid);
				case 6: NatDis_Reset(TYPE_SANDSTORM);
			}
		}
		case DIALOG_NATDIS_FLOOD:
		{
			if(!response) return NatDis_MainMenu(playerid);
			switch(listitem)
			{
				case 0: { gWeather = 16; SetWeather(16); }
				case 1: foreach(new i : Player) PlayAudioStreamForPlayer(i, "http://localhost/audio/earthquake_siren.mp3");
				case 2: foreach(new i : Player) NatDis_Effects(i, 0, TYPE_FLOOD, 1);
				case 3: NatDis_LoadMaps(playerid);
				case 4: ShowPlayerDialogEx(playerid, DIALOG_NATDIS_EDITZONES, DIALOG_STYLE_LIST, "Natural Disaster | Edit Zones", "Cities / Mainland\nLocal Areas", "Back", "Select");
				case 5: NatDis_MainMenu(playerid);
				case 6: NatDis_Reset(TYPE_FLOOD);
			}
		}
		case DIALOG_NATDIS_NUKE: {
			if(!response) return NatDis_MainMenu(playerid);
			switch(listitem)
			{
				case 0: InitiateProgram(playerid, TYPE_NUKE);
				case 1: ShowPlayerDialogEx(playerid, DIALOG_NATDIS_EDITZONES, DIALOG_STYLE_LIST, "Natural Disaster | Edit Zones", "Cities / Mainland\nLocal Areas", "Back", "Select");
				case 2: NatDis_MainMenu(playerid);
				case 3: NatDis_Reset(TYPE_NUKE);
			}
		}
		case DIALOG_NATDIS_ALIENS: {
			if(!response) return NatDis_EditDialog(playerid, DIALOG_NATDIS_EARTHQUAKE);
			switch(listitem)
			{
				case 0: InitiateProgram(playerid, TYPE_ALIENS);
				case 1: ShowPlayerDialogEx(playerid, DIALOG_NATDIS_EDITZONES, DIALOG_STYLE_LIST, "Natural Disaster | Edit Zones", "Cities / Mainland\nLocal Areas", "Back", "Select");
				case 2: NatDis_MainMenu(playerid);
				case 3: NatDis_Reset(TYPE_ALIENS);
			}
		}
		case DIALOG_NATDIS_EDITZONES:
		{
			if(!response) return NatDis_EditDialog(playerid, DIALOG_NATDIS_EARTHQUAKE);
			switch(listitem)
			{
				case 0: return NatDis_EditZones(playerid, 1);
				case 1: return NatDis_EditZones(playerid, 2);
			}
		}
		case DIALOG_NATDIS_EDITZONE:
		{
			if(!response) return NatDis_EditDialog(playerid, DIALOG_NATDIS_EARTHQUAKE);
			SetPVarInt(playerid, "_EditingZone", listitem);
			switch(GetPVarInt(playerid, "_EditingNasType"))
			{
				case TYPE_EARTHQUAKE: 
				{
					ShowPlayerDialogEx(playerid, DIALOG_NATDIS_EQFINAL, DIALOG_STYLE_LIST, "Earthquake Menu | Edit Zone", "\
						Inactive Zone\n\
						Quake Zone\n\
						Evacuation Zone\n\
						Safe Zone\n\
						_______________\n\
						Delete Zone\n",
						"Back", "Select");
				}
			}
			
		}
		case DIALOG_NATDIS_EQFINAL:
		{
			if(!response) return ShowPlayerDialogEx(playerid, DIALOG_NATDIS_EDITZONES, DIALOG_STYLE_LIST, "Natural Disaster | Edit Zones", "Cities / Mainland\nLocal Areas", "Back", "Select");
			new iZoneTypeID = GetPVarInt(playerid, "_EditingZoneType");
			CheckNatDisZone(playerid, GetPVarInt(playerid, "_EditingNasType"), iZoneTypeID, GetPVarInt(playerid, "_EditingZone"), listitem);
			return NatDis_EditZones(playerid, iZoneTypeID);
		}
		case DIALOG_NATDIS_LOADMAPS: 
		{
			if(!response) return NatDis_MainMenu(playerid);
			return NatDis_LoadMapping(playerid, GetPVarInt(playerid, "_EditingNasType"), listitem);
		}
	}
	return 0;
}

NatDis_LoadMaps(playerid) {

	return ShowPlayerDialogEx(playerid, DIALOG_NATDIS_LOADMAPS, DIALOG_STYLE_LIST, "Natural Disaster | Load Mapping", "\
		Load LS Downtown\n\
		Load LS East\n\
		Load LS Commerce\n\
		Load LS Market\n\
		Load Bridges", "Cancel", "Select");
}

NatDis_LoadMapping(playerid, iNasType, iArea) {

	szMiscArray[0] = 0;
	new szChoice[20];
	if(GetGVarInt("_NatDis_gMapLoaded", iArea) == 1) {

		SendClientMessage(playerid, COLOR_RED, "This map is already loaded.");
		return NatDis_MainMenu(playerid);
	}
	SetGVarInt("_NatDis_gMapLoaded", 1, iArea);
	switch(iArea) {

		case 0:	szChoice = "Downtown";
		case 1: szChoice = "East Los Santos";
		case 2: szChoice = "Commerce";
		case 3: szChoice = "Market";		
		case 4: szChoice = "Destroyed Bridges";
	}
	NatDis_Streamer(iNasType, iArea);
	foreach(new i : Player) NatDis_RemoveBuildings(i, iNasType, iArea);
	format(szMiscArray, sizeof(szMiscArray), "Successfully loaded mapping: %s", szChoice);
	SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
	NatDis_LoadMaps(playerid);
	return 1;
}

forward NatDis_Explosions(iArea, choice);
public NatDis_Explosions(iArea, choice)
{
	// if(!GetGVarInt("_NatDis_GID"), iArea) return 1;
	new rand = random(sizeof(g_aLSDowntownExplosions));
	if(choice == 0) SetTimerEx("NatDis_Explosions", 60000, false, "ii", iArea, 0);
	switch(iArea)
	{
		case NATDIS_MAPAREA_DOWNTOWNLS:
		{
			CreateExplosion(g_aLSDowntownExplosions[rand][0], g_aLSDowntownExplosions[rand][1], g_aLSDowntownExplosions[rand][2], 7, 10.0);
		}
		case NATDIS_MAPAREA_COMMERCE:
		{
			CreateExplosion(g_aCommerceExplosions[rand][0], g_aCommerceExplosions[rand][1], g_aCommerceExplosions[rand][2], 7, 10.0);
		}
		case NATDIS_MAPAREA_EASTLS:
		{
			CreateExplosion(g_aEastLSExplosions[rand][0], g_aEastLSExplosions[rand][1], g_aEastLSExplosions[rand][2], 7, 10.0);
		}
		case NATDIS_MAPAREA_MARKET:
		{
			CreateExplosion(g_aMarketExplosions[rand][0], g_aMarketExplosions[rand][1], g_aMarketExplosions[rand][2], 7, 10.0);
		}
		case NATDIS_MAPAREA_BRIDGES:
		{
			CreateExplosion(g_aBridgesExplosions[rand][0], g_aBridgesExplosions[rand][1], g_aBridgesExplosions[rand][2], 7, 10.0);
		}
	}
	return 1;
}

InitiateProgram(playerid, iNasType) {

	switch(iNasType) {

		case TYPE_NUKE: {

			SetWorldTime(1);
			SetWeather(125);
			foreach(new i : Player) {
				BroadcastLastInt[i] = GetPlayerInterior(i);
				BroadcastLastVW[i] = GetPlayerVirtualWorld(i);
				GetPlayerFacingAngle(i, PlayerInfo[i][pPos_r]);
				GetPlayerPos(playerid, BroadcastFloats[i][1], BroadcastFloats[i][2], BroadcastFloats[i][3]);

				PlayerInfo[i][pInt] = BroadcastLastInt[i];
	 			PlayerInfo[i][pVW] = BroadcastLastVW[i];
	 			PlayerInfo[i][pPos_r] = BroadcastFloats[i][0];
	  			PlayerInfo[i][pPos_x] = BroadcastFloats[i][1];
	  			PlayerInfo[i][pPos_y] = BroadcastFloats[i][2];
	  			PlayerInfo[i][pPos_z] = BroadcastFloats[i][2];

	  			SetPlayerPos(i, 0.0, 0.0, 100000000);
	  			PlayAudioStreamForPlayer(i, "http://localhost/audio/nuke.mp3");
	  			defer ReturnPlayer(i);
	  		}
		}
		case TYPE_ALIENS: {

			//Ufo_CreateAdminUfo(playerid);
			SetWorldTime(1);
			SetWeather(125);
			PlayAudioStreamForPlayer(playerid, "http://localhost/audio/aliens.mp3");
			SetPlayerDrunkLevel(playerid, 1000);
		}
	}
	defer NatDisProgram(iNasType);
}

timer ReturnPlayer[30000](i) {

	Player_StreamPrep(i, BroadcastFloats[i][1], BroadcastFloats[i][2], BroadcastFloats[i][3], FREEZE_TIME);
	SetPlayerVirtualWorld(i, PlayerInfo[i][pVW]);
	SetPlayerInterior(i, PlayerInfo[i][pInt]);
}

timer NatDisProgram[30000](iNasType) {

	switch(iNasType) {
		case TYPE_NUKE: {
			SetWorldTime(4);
			SetWeather(23);
		}
		case TYPE_ALIENS: {

			foreach(new i : Player) SetPlayerDrunkLevel(i, 0);
		}
	}
}

NatDis_Streamer(iNasType, iArea)
{
	NatDis_Explosions(iArea, 0);
	switch(iNasType)
	{
		case TYPE_EARTHQUAKE:
		{
			switch(iArea)
			{
				case NATDIS_MAPAREA_DOWNTOWNLS:  // somehow including map .pwn files only loads the first object?
				{
					CreateDynamicObject(8647, -2135.2, -149.5, 2000, 0, 0, 0);
					CreateDynamicObject(14437, -2147.5, -137.10001, 2011.22, 0, 0, 0);
					CreateDynamicObject(14408, -2135.3, -144.5, 2018.5466, 0, 0, 0);
					CreateDynamicObject(7191, -2149.3999, -114.6, 2011.2, 0, 0, 0);
					CreateDynamicObject(7191, -2145.5, -114.6, 2011.2, 0, 0, 0);
					CreateDynamicObject(2930, -2146.6001, -137, 2011.8, 0, 0, 270);
					CreateDynamicObject(1968, -2147.2, -141.10001, 2009.7, 0, 0, 0);
					CreateDynamicObject(14439, -2141.7, -143.60001, 2020.3, 0, 0, 2);
					CreateDynamicObject(1771, -2148.3, -134.39999, 2009.8, 358, 1.001, 358.535);
					CreateDynamicObject(7191, -2145.3, -172.7, 2011.1, 0, 0, 180);
					CreateDynamicObject(7191, -2149.3999, -172.7, 2011, 0, 0, 179.995);
					CreateDynamicObject(14437, -2147.3, -166.39999, 2011.2, 0, 0, 0);
					CreateDynamicObject(1771, -2147.2, -156, 2009.8, 0, 0, 0);
					CreateDynamicObject(1810, -2148.7, -153.60001, 2009.2, 0, 0, 192);
					CreateDynamicObject(2747, -2148.8, -152.39999, 2009.5, 0, 0, 267.75);
					CreateDynamicObject(7191, -2129.5, -118.5, 2015.3, 0, 0, 0);
					CreateDynamicObject(7191, -2129.5, -168.3, 2009.8, 0, 0, 179.995);
					CreateDynamicObject(7191, -2145.5, -114.6, 2015.5, 0, 0, 0);
					CreateDynamicObject(7191, -2149.3999, -114.6, 2015.5, 0, 0, 0);
					CreateDynamicObject(14437, -2147.5, -137.10001, 2015.1, 0, 0, 0);
					CreateDynamicObject(14437, -2143.6001, -137.2, 2015.1, 0, 0, 0);
					CreateDynamicObject(7191, -2141.3, -114.6, 2015.5, 0, 0, 0);
					CreateDynamicObject(14437, -2139.5, -137.3, 2015.1, 0, 0, 0);
					CreateDynamicObject(7191, -2137.2, -114.6, 2015.5, 0, 0, 0);
					CreateDynamicObject(14437, -2151.6001, -137.3, 2015.1, 0, 0, 0);
					CreateDynamicObject(7191, -2153.1001, -114.6, 2015.5, 0, 0, 0);
					CreateDynamicObject(14437, -2154.8, -137.2, 2015.1, 0, 0, 0);
					CreateDynamicObject(7191, -2156.3999, -114.6, 2015.4, 0, 0, 0);
					CreateDynamicObject(14437, -2135.3999, -137.2, 2015.1, 0, 0, 0);
					CreateDynamicObject(14437, -2151.6001, -137.3, 2011.1, 0, 0, 0);
					CreateDynamicObject(7191, -2153.1001, -114.8, 2011, 0, 0, 0);
					CreateDynamicObject(7191, -2141.3, -114.6, 2011, 0, 0, 0);
					CreateDynamicObject(7191, -2137.2, -114.6, 2011.1, 0, 0, 0);
					CreateDynamicObject(14437, -2143.7, -137.2, 2011.2, 0, 0, 0);
					CreateDynamicObject(14437, -2139.2, -137.3, 2011.2, 0, 0, 0);
					CreateDynamicObject(14437, -2135.3999, -137.2, 2011.2, 0, 0, 0);
					CreateDynamicObject(7191, -2151.69995, -135.3, 2013.40002, 0, 90, 270);
					CreateDynamicObject(7191, -2152.3999, -131.39999, 2013.4, 0, 90, 90);
					CreateDynamicObject(7191, -2152.3, -132.8, 2014.4, 0, 0, 90);
					CreateDynamicObject(7191, -2152.3999, -132.8, 2010.5, 0, 0, 90);
					CreateDynamicObject(7191, -2147.7, -137.3, 2019, 0, 180, 270);
					CreateDynamicObject(7191, -2152.3, -132.7, 2018.3, 0, 0, 90);
					CreateDynamicObject(7191, -2151.6001, -135.3, 2017.1, 0, 270, 270);
					CreateDynamicObject(7191, -2152.1001, -131.39999, 2017.5, 0, 90, 90);
					CreateDynamicObject(18092, -2155.6001, -137.5, 2009.7, 0, 0, 180);
					CreateDynamicObject(2339, -2154.8999, -133.39999, 2009.3, 0, 0, 0);
					CreateDynamicObject(2136, -2153.7, -135.3, 2009.2, 0, 0, 269.75);
					CreateDynamicObject(14445, -2133.3, -137, 2015.2, 0, 0, 0);
					CreateDynamicObject(16645, -2140.7, -138.2, 2013.4, 0, 0, 0);
					CreateDynamicObject(14437, -2143.6001, -166.39999, 2011.2, 0, 0, 0);
					CreateDynamicObject(14437, -2139.3, -166.39999, 2011.2, 0, 0, 0);
					CreateDynamicObject(14437, -2135.5, -166.39999, 2011.2, 0, 0, 0);
					CreateDynamicObject(7191, -2141.3, -172.8, 2011.2, 0, 0, 179.995);
					CreateDynamicObject(7191, -2137.2, -172.8, 2010.7, 0, 0, 179.995);
					CreateDynamicObject(7191, -2139.6001, -152.60001, 2013.19995, 0, 90, 90);
					CreateDynamicObject(7191, -2145.3, -172.7, 2015.1, 0, 0, 179.995);
					CreateDynamicObject(7191, -2137.2, -172.8, 2015, 0, 0, 179.995);
					CreateDynamicObject(7191, -2153, -173.2, 2015.1, 0, 0, 179.995);
					CreateDynamicObject(7191, -2149.3999, -172.7, 2014.9, 0, 0, 179.995);
					CreateDynamicObject(7191, -2141.3, -172.8, 2015.2, 0, 0, 179.995);
					CreateDynamicObject(14408, -2135.6001, -158.2, 2030.2, 0, 0, 0);
					CreateDynamicObject(14437, -2135.5, -166.89999, 2015.3, 0, 0, 0);
					CreateDynamicObject(14437, -2139.3, -166.89999, 2015.3, 0, 0, 0);
					CreateDynamicObject(14437, -2143.6001, -166.89999, 2015.3, 0, 0, 0);
					CreateDynamicObject(14437, -2147.3, -166.89999, 2015.3, 0, 0, 0);
					CreateDynamicObject(14437, -2151.3999, -166.89999, 2015.3, 0, 0, 0);
					CreateDynamicObject(7191, -2151.3, -156.39999, 2015.1, 0, 0, 270);
					CreateDynamicObject(7191, -2139.5, -156.5, 2013.2, 0, 90, 90);
					CreateDynamicObject(16645, -2137, -149.8, 2013.2, 0, 0, 180.747);
					CreateDynamicObject(7191, -2147.6001, -150.39999, 2018.6, 0, 0, 269.25);
					CreateDynamicObject(7191, -2151.6001, -152.89999, 2016.8, 0, 270, 270);
					CreateDynamicObject(7191, -2151.7, -156.5, 2016.8, 0, 270, 270);
					CreateDynamicObject(14437, -2154.7, -166.89999, 2015.3, 0, 0, 0);
					CreateDynamicObject(7191, -2156.5, -172.8, 2015.1, 0, 0, 179.995);
					CreateDynamicObject(7191, -2159.3, -150.14, 2035.9, 90, 180, 90);
					CreateDynamicObject(7191, -2159.7, -150.2, 2035.9, 90, 179.995, 90);
					CreateDynamicObject(7191, -2129.5, -118.5, 2009.8, 0, 0, 0);
					CreateDynamicObject(7191, -2129.5, -168.3, 2015.1, 0, 0, 180);
					CreateDynamicObject(14437, -2131.5, -167.10001, 2015.3, 0, 0, 0);
					CreateDynamicObject(7191, -2133.3, -173.3, 2010.7, 0, 0, 179.995);
					CreateDynamicObject(14437, -2131.5, -166.39999, 2011.2, 0, 0, 0);
					CreateDynamicObject(14437, -2131.5, -137.3, 2011.2, 0, 0, 0);
					CreateDynamicObject(14437, -2131.5, -137.3, 2015.2, 0, 0, 0);
					CreateDynamicObject(16645, -2145, -149.89999, 2013.2, 0, 0, 180.747);
					CreateDynamicObject(16645, -2149.6001, -138.2, 2013.4, 0, 0, 0);
					CreateDynamicObject(7191, -2159.3, -137.3, 2036.1, 90, 0, 90);
					CreateDynamicObject(7191, -2161.1001, -137.28999, 2036.1, 90, 0, 90);
					CreateDynamicObject(3657, -2154, -156.39999, 2009.7, 0, 0, 88);
					CreateDynamicObject(3657, -2153.8, -151.5, 2009.7, 0, 0, 87.995);
					CreateDynamicObject(3657, -2157.6001, -156.39999, 2009.7, 0, 0, 92.495);
					CreateDynamicObject(14532, -2150.6001, -154.10001, 2010.2, 0, 0, 89.25);
					CreateDynamicObject(7191, -2147.1001, -150.89999, 2021.7, 0, 0, 270);
					CreateDynamicObject(7191, -2129.5, -118.5, 2012.2, 0, 0, 0);
					CreateDynamicObject(7191, -2129.5, -168.3, 2011.3, 0, 0, 179.995);
					CreateDynamicObject(7191, -2147.7002, -137.2998, 2019, 179.995, 0, 90);
					CreateDynamicObject(7191, -2147.7, -137.3, 2022.9, 179.995, 0, 90);
					CreateDynamicObject(7191, -2125.6001, -114.7, 2018.1, 0.005, 180, 0);
					CreateDynamicObject(7191, -2127.5, -137.39999, 2031.1, 90, 0, 90);
					CreateDynamicObject(7191, -2125.6001, -114.7, 2015.3, 0, 179.995, 0);
					CreateDynamicObject(7191, -2125.6001, -114.7, 2010.3, 0, 179.995, 0);
					CreateDynamicObject(1969, -2138.3999, -140.60001, 2009.7, 0, 0, 0);
					CreateDynamicObject(2909, -2129.5, -143.3, 2013, 0, 0, 0);
					CreateDynamicObject(2909, -2129.5, -143.3, 2010.4, 0, 0, 0);
					CreateDynamicObject(4100, -2129.5, -143.2, 2016, 0, 0, 50.5);
					CreateDynamicObject(4100, -2129.5, -143.2, 2018.9, 0, 0, 50.499);
					CreateDynamicObject(4100, -2129.5, -143.2, 2021.6, 0, 0, 50.499);
					CreateDynamicObject(1536, -2168.1001, -150.39999, 2009.2, 0, 0, 90);
					CreateDynamicObject(1536, -2168.1001, -147.39999, 2009.2, 0, 0, 269.25);
					CreateDynamicObject(971, -2166.1001, -151.60001, 2012.3, 0, 0, 181.25);
					CreateDynamicObject(1497, -2161.8, -146.2, 2009.1, 0, 0, 328);
					CreateDynamicObject(1497, -2161.7, -143.3, 2009.1, 0, 0, 33.997);
					CreateDynamicObject(1500, -2165.8999, -142.60001, 2009.2, 0, 0, 0);
					CreateDynamicObject(985, -2165.8, -142.60001, 2010.9, 0, 0, 0);
					CreateDynamicObject(4106, -2159.5, -148.10001, 2011.8, 0, 0, 90.25);
					CreateDynamicObject(4106, -2127.5, -140, 2011.8, 0, 0, 269.997);
					CreateDynamicObject(4106, -2159.6001, -140.5, 2014.3, 0, 0, 0.495);
					CreateDynamicObject(4007, 1417.5, -1471.5, 12, 6.299, 345.662, 338.106);
					CreateDynamicObject(4113, 1327.3, -1550.7, 25.8, 0, 319.5, 0);
					CreateDynamicObject(4570, 1489.5, -1268, 23.2, 0, 336, 8);
					CreateDynamicObject(4563, 1568.7, -1254, 39, 0, 18, 0);
					CreateDynamicObject(4662, 1621.1, -1230.2, 18.8, 0, 34, 0);
					CreateDynamicObject(4602, 1656.6, -1345.9, 37.9, 0, 344, 0);
					CreateDynamicObject(4586, 1405.1, -1191.2, 85.3, 0, 0, 0);
					CreateDynamicObject(4586, 1416.8, -1193.1, 40.4, 0, 26, 2);
					CreateDynamicObject(10986, 1752.5, -1439.3, 13.8, 0, 0, 0);
					CreateDynamicObject(10777, 1711.4, -1444.2, 7.3, 0, 0, 354);
					CreateDynamicObject(11340, 1761, -1456.6, 9.4, 0, 0, 0);
					CreateDynamicObject(10394, 1737.4, -1561.9, 15.1, 0, 0, 86);
					CreateDynamicObject(3998, 1737.2, -1557.6, 12.7, 0, 26, 0);
					CreateDynamicObject(4079, 1786, -1563.6, 23.4, 355.503, 357.994, 354.838);
					CreateDynamicObject(11340, 1858.2, -1417.9, 10.2, 2, 0.25, 352.491);
					CreateDynamicObject(3866, 1824.3, -1432.9, 20.1, 0, 0, 90);
					CreateDynamicObject(3887, 1822.7, -1414.1, 20.7, 0, 0, 0);
					CreateDynamicObject(11340, 1854.8, -1338.7, 10.2, 2, 0.247, 172.991);
					CreateDynamicObject(7347, 1893.4, -1363.9, 8.9, 35.476, 287.388, 132.649);
					CreateDynamicObject(1337, 1807.4238, -1344.0625, 21.79014, 0, 0, 0);
					CreateDynamicObject(7916, 1826.2, -1336.8, 1.4, 0, 334, 248);
					CreateDynamicObject(7347, 1890.1, -1356.7, 9.6, 35.475, 287.386, 142.649);
					CreateDynamicObject(11340, 1541.7, -1253.1, 11.4, 0, 358, 0);
					CreateDynamicObject(11340, 1516.4, -1250.1, 11.4, 0, 357.995, 6);
					CreateDynamicObject(10985, 1510.5, -1277.8, 15.4, 0, 0, 0);
					CreateDynamicObject(4666, 1614.1, -1036.4, 9, 342.756, 1.571, 0.716);
					CreateDynamicObject(12824, 1694.5, -1046.5, -56.7, 63.415, 110.691, 61.881);
					CreateDynamicObject(12824, 1541.6, -1056, -59, 67.162, 94.819, 252.546);
					CreateDynamicObject(7347, 1600.2, -1013.7, 4.7, 43.865, 5.552, 356.146);
					CreateDynamicObject(4683, 1614, -1186.2, 28, 7, 359.748, 0.281);
					CreateDynamicObject(4708, 1544.5, -1186.9, 29.7, 0, 6.5, 0);
					CreateDynamicObject(13717, 1595.5, -1158.6, 4, 354.017, 355.727, 359.554);
					CreateDynamicObject(11340, 1587.8, -1177.9, 19.1, 0.5, 359.747, 184.002);
					CreateDynamicObject(11340, 1649.6, -1174.9, 19.5, 358.75, 359.492, 182.484);
					CreateDynamicObject(11340, 1529.2, -1183.2, 18.9, 0.494, 359.742, 183.999);
					CreateDynamicObject(11340, 1503.3, -1164.7, 20.7, 357.744, 359.491, 183.977);
					CreateDynamicObject(18450, 1562.7, -1135.4, 25.2, 41.874, 5.375, 92.406);
					CreateDynamicObject(4664, 1643.3, -1130.2, 26.6, 358.002, 2.501, 0.087);
					CreateDynamicObject(4666, 1614.7, -1030.2, 19.3, 350.77, 3.799, 359.61);
					CreateDynamicObject(4131, 1588.4, -1509.1, 19.8, 351, 0, 0);
					CreateDynamicObject(10777, 1614.7, -1429.5, 2.8, 0, 352, 343.996);
					CreateDynamicObject(11340, 1641.5, -1462.1, 11.4, 0, 357.995, 0);
					CreateDynamicObject(11340, 1595.5, -1463.4, 10.6, 0, 357.995, 0);
					CreateDynamicObject(10777, 1550, -1413.7, 8, 0, 359.996, 356.743);
					CreateDynamicObject(11340, 1455.4, -1262.5, 11.2, 0, 357.99, 5.999);
					CreateDynamicObject(11340, 1452.3, -1302.5, 11.4, 0, 353.24, 5.999);
					CreateDynamicObject(18450, 1534.8, -1301.2, 13.4, 359.75, 2.25, 352.76);
					CreateDynamicObject(11340, 1493.3, -1315, 13.1, 355.26, 356.225, 86.436);
					CreateDynamicObject(7347, 1538.2, -1348.5, -10.8, 68.994, 358.605, 356.552);
					CreateDynamicObject(11340, 1540.7, -1287.1, 13.9, 358.502, 356.232, 86.649);
					CreateDynamicObject(11340, 1607.2, -1327.3, 14.4, 355.259, 356.221, 250.435);
					CreateDynamicObject(7347, 1497.8, -1329, -14.1, 68.994, 358.605, 356.55);
					CreateDynamicObject(7347, 1433.5, -1300.1, -40, 72.984, 177.437, 91.449);
					CreateDynamicObject(1337, 1468.9717, -1301.3135, 12.93676, 0, 0, 0);
					CreateDynamicObject(7916, 1476.3, -1302.4, 14.3, 0, 7.75, 74.75);
					CreateDynamicObject(7347, 1431.8, -1308.9, -40, 72.982, 177.435, 91.445);
					CreateDynamicObject(3990, 1594, -1416.4, 30.1, 359.256, 7.501, 0.098);
					CreateDynamicObject(4679, 1607.6, -1326, 33.6, 0, 8.5, 0);
					CreateDynamicObject(11340, 1615.4, -1566, 12.4, 1.986, 353.241, 0.235);
					CreateDynamicObject(11340, 1580.8, -1567.9, 12.4, 1.983, 353.238, 0.231);
					CreateDynamicObject(17622, 1576.5, -1591.6, 3.8, 10.063, 343.235, 269.513);
					CreateDynamicObject(17622, 1642.4, -1595.6, 3.8, 9.935, 19.042, 84.341);
					CreateDynamicObject(11340, 1551, -1567.9, 12.4, 1.983, 353.238, 0.231);
					CreateDynamicObject(11340, 1519, -1556.5, 11.9, 1.983, 353.238, 0.231);
					CreateDynamicObject(11340, 1536.5, -1414.1, 10.6, 0, 357.995, 0);
					CreateDynamicObject(11340, 1499.5, -1465.6, 10.6, 0, 358, 0);
					CreateDynamicObject(11340, 1398.8, -1491.6, 9.1, 0, 359.745, 254);
					CreateDynamicObject(11340, 1549.6, -1286.4, 14.4, 355.259, 356.221, 71.933);
					CreateDynamicObject(4113, 1295.8, -1547.9, 51.2, 354.169, 298.712, 356.743);
					CreateDynamicObject(11340, 1307.9, -1566.4, 11.1, 358.248, 357.99, 95.684);
					CreateDynamicObject(3866, 1332.1, -1592.6, 19.9, 0, 0, 349.5);
					CreateDynamicObject(7344, 1359.6, -1518.2, -8.4, 58, 0, 52);
					CreateDynamicObject(11340, 1363.7, -1515.2, 9.6, 0.5, 359.74, 336.998);
					CreateDynamicObject(7344, 1372.6, -1470.3, -6.4, 53.331, 6.288, 56.945);
					CreateDynamicObject(11340, 1372.2, -1488.5, 9.2, 0.494, 359.736, 350.995);
					CreateDynamicObject(5995, 1128.8, -1400.8, 3.4, 0, 9.25, 0);
					CreateDynamicObject(5995, 1130.9, -1400.7, 8.2, 0.249, 355.495, 0.02);
					CreateDynamicObject(16303, 1167.9, -1381.1, 6.6, 0, 0, 10);
				}
				case NATDIS_MAPAREA_EASTLS:
				{
					CreateDynamicObject(7347, 2160.3, -1777, 3.3, 0, 98.25, 42);
					CreateDynamicObject(11340, 2103.7, -1795.5, 9.7, 0, 0, 0);
					CreateDynamicObject(11340, 2176.1001, -1773.9, 9.7, 0, 0.25, 0);
					CreateDynamicObject(11340, 2111.2, -1730, 10.6, 0, 358.997, 0);
					CreateDynamicObject(11340, 2046.5, -1738.2, 10.3, 0, 358.995, 176);
					CreateDynamicObject(10985, 2104.3, -1817.3, 14, 0, 0, 0);
					CreateDynamicObject(10985, 2106.1001, -1795.9, 13.9, 0, 0, 0);
					CreateDynamicObject(10985, 2092.5, -1768.9, 13.9, 0, 0, 0);
					CreateDynamicObject(10985, 2081.2, -1767.5, 13.9, 0, 0, 0);
					CreateDynamicObject(10985, 2072.6001, -1769.3, 13.1, 0, 0, 0);
					CreateDynamicObject(18450, 2020.9, -1752.4, -10.8, 0, 310, 0);
					CreateDynamicObject(18450, 2049.7, -1750.2, 9.4, 336.35, 349.615, 355.795);
					CreateDynamicObject(18450, 2139.5, -1747.3, 9.4, 336.276, 9.284, 3.761);
					CreateDynamicObject(18450, 2081.5, -1835.1, 9.4, 336.346, 349.612, 88.792);
					CreateDynamicObject(18450, 2110.3, -1686.2, 10.1, 35.964, 357.206, 182.642);
					CreateDynamicObject(3865, 2083.8999, -1696.3, 14.3, 0, 0, 0);
					CreateDynamicObject(3865, 2100.3, -1719.1, 13.2, 316.135, 93.854, 95.552);
					CreateDynamicObject(3865, 2090.5, -1763.5, 13.2, 316.132, 93.851, 163.548);
					CreateDynamicObject(3865, 2089, -1775, 13.2, 352.017, 90.561, 26.038);
					CreateDynamicObject(3865, 2079.3999, -1773.2, 13.2, 352.013, 90.56, 334.038);
					CreateDynamicObject(3865, 2083.7, -1773.5, 12.9, 352.007, 90.555, 0.034);
					CreateDynamicObject(3865, 2083.7002, -1773.5, 12.9, 352.002, 90.549, 0.033);
					CreateDynamicObject(7916, 2081.3, -1784.8, 11.5, 0, 0, 0);
					CreateDynamicObject(3865, 2111, -1772.8, 15.4, 352.013, 90.56, 358.038);
					CreateDynamicObject(3865, 2108, -1771.9, 15.4, 352.007, 90.555, 326.033);
					CreateDynamicObject(10985, 2116.5, -1765.1, 13.9, 0, 0, 0);
					CreateDynamicObject(10985, 2123.1001, -1779.7, 13.9, 0, 0, 0);
					CreateDynamicObject(10985, 2110.8, -1767.4, 15.4, 21.992, 1.618, 359.394);
					CreateDynamicObject(18450, 2135.6001, -1755.9, 6.4, 282.772, 51.711, 51.006);
					CreateDynamicObject(18450, 2084.7, -1701.3, 10.1, 336.346, 349.612, 259.792);
					CreateDynamicObject(11340, 2525, -1668.9, -10.4, 0, 0, 0);
					CreateDynamicObject(11340, 2480.5, -1667.5, -10.8, 0, 0, 0);
					CreateDynamicObject(18450, 2431.8999, -1654.2, 8.3, 318.237, 337.619, 328.663);
					CreateDynamicObject(18450, 2463.7, -1663.6, 7.1, 316.003, 358.954, 83.275);
					CreateDynamicObject(16057, 2433.3, -1616.5, -26, 1.747, 356.498, 236.357);
					CreateDynamicObject(16057, 2413.8999, -1694, -23.4, 0, 353.5, 295.499);
					CreateDynamicObject(16057, 2434, -1739.3, -23.5, 0.249, 355.996, 336.261);
					CreateDynamicObject(16057, 2538, -1600.2, -25.8, 352.497, 358.484, 152.05);
					CreateDynamicObject(18450, 2471.5, -1693.4, 3.8, 276.134, 191.825, 201.758);
					CreateDynamicObject(18450, 2512.1001, -1689.2, 4.5, 276.13, 191.821, 267.758);
					CreateDynamicObject(18450, 2500.3999, -1652.5, 4.9, 276.125, 191.821, 327.753);
					CreateDynamicObject(18450, 2504.5, -1649.1, 4.4, 276.816, 151.489, 287.653);
					CreateDynamicObject(18450, 2486.6001, -1676.4, -15.6, 355.038, 44.962, 273.431);
					CreateDynamicObject(18450, 2484.1001, -1648.2, 4.9, 276.125, 191.821, 7.75);
					CreateDynamicObject(17026, 2489.3999, -1649.7, -8.5, 0, 0, 38);
					CreateDynamicObject(17026, 2467, -1684.3, -7, 0, 0, 37.996);
					CreateDynamicObject(17026, 2458.6001, -1682.9, -7, 0, 0, 37.996);
					CreateDynamicObject(3865, 2485, -1661.8, 4.7, 0, 0, 62);
					CreateDynamicObject(7916, 2470.5, -1675.3, 6.6, 0, 2, 56);
					CreateDynamicObject(7916, 2487.3999, -1677.4, 2.3, 0, 2, 55.997);
					CreateDynamicObject(3865, 2486.3999, -1658.4, 4.7, 0, 0, 61.996);
					CreateDynamicObject(3865, 2466.8, -1656.8, 8.9, 0, 0, 83.996);
					CreateDynamicObject(3865, 2466.3999, -1660.3, 8.9, 0, 0, 83.99);
					CreateDynamicObject(3865, 2467.1001, -1666.1, 8.9, 0, 0, 57.99);
					CreateDynamicObject(17026, 2479.8999, -1654.9, -19, 0, 336, 301.996);
					CreateDynamicObject(11340, 2417, -1689.9, 9.3, 0, 0, 0);
					CreateDynamicObject(11340, 2296.8999, -1745.5, 9.3, 0, 0, 180.5);
					CreateDynamicObject(11340, 2292.7, -1755.2, 9.2, 0, 0, 4.5);
					CreateDynamicObject(11340, 2235.8999, -1758.9, 9.3, 0, 359.25, 4.499);
					CreateDynamicObject(18450, 2294.1001, -1727.6, 8.3, 318.235, 337.615, 328.662);
					CreateDynamicObject(18450, 2266.3, -1753.5, 8.3, 318.235, 337.615, 156.662);
					CreateDynamicObject(5513, 2201, -1749.9, 11.5, 354.409, 333.363, 357.202);
					CreateDynamicObject(11340, 2235, -1800.9, 9.4, 0, 359.247, 4.499);
					CreateDynamicObject(18450, 2199.5, -1759.2, 11.1, 25.625, 354.17, 268.784);
					CreateDynamicObject(17657, 2431.3, -1601.7, 14.4, 11.747, 1.277, 359.74);
					CreateDynamicObject(18450, 2423.5, -1629, -12.1, 357.505, 273.439, 242.325);
					CreateDynamicObject(18450, 2434.6001, -1630.4, -9.1, 357.501, 273.433, 268.325);
					CreateDynamicObject(11340, 2428.6001, -1661.8, 9.5, 359.251, 357.5, 269.967);
					CreateDynamicObject(10985, 2361.1001, -1656.5, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 2383.1001, -1659.6, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 2353.8, -1729.6, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 2351.6001, -1755.6, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 2325.2, -1743, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 2248.3, -1731.6, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 2177.8, -1734.8, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 2184.7, -1737.5, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 2206.8999, -1726, 12.4, 0, 0, 0);
				}
				case NATDIS_MAPAREA_COMMERCE:
				{
					CreateDynamicObject(11340, 1513.4, -1631.4, 8.7, 0, 0, 0);
					CreateDynamicObject(11340, 1434.4, -1626.8, 10.4, 0, 0, 180);
					CreateDynamicObject(11340, 1436.3, -1691, 10, 0, 0, 179.995);
					CreateDynamicObject(11340, 1522, -1689.3, 9.7, 0, 0, 0.245);
					CreateDynamicObject(11340, 1485.7, -1651.9, 10.1, 0, 0, 266.75);
					CreateDynamicObject(11340, 1603.3, -1696.5, 9.3, 0, 0, 0.242);
					CreateDynamicObject(10985, 1554.4, -1700.5, 14.4, 0, 0, 0);
					CreateDynamicObject(10985, 1557.4, -1662.2, 14.4, 0, 0, 0);
					CreateDynamicObject(10985, 1548.2, -1719.2, 13.4, 0, 0, 0);
					CreateDynamicObject(10985, 1544.6, -1734.2, 13.4, 0, 0, 186);
					CreateDynamicObject(10985, 1587.3, -1731.6, 13.4, 0, 0, 185.999);
					CreateDynamicObject(10985, 1521.6, -1717.5, 12.9, 0, 0, 185.999);
					CreateDynamicObject(10985, 1531.2, -1653.5, 12.9, 0, 0, 185.999);
					CreateDynamicObject(17034, 1474.2, -1647.1, -2.6, 0, 0, 0);
					CreateDynamicObject(17034, 1481.2, -1643.2, -2.6, 0, 0, 92);
					CreateDynamicObject(17034, 1489.8, -1636.7, -2.6, 0, 0, 186);
					CreateDynamicObject(17034, 1489, -1630.4, -7.3, 0, 356, 185.999);
					CreateDynamicObject(17034, 1469.5, -1643.7, -2.6, 0, 358, 58);
					CreateDynamicObject(17034, 1477.9, -1651.5, -1.6, 0, 355.995, 57.997);
					CreateDynamicObject(17034, 1490.9, -1622.8, -2.6, 0, 0, 92);
					CreateDynamicObject(18450, 1528.5, -1636.9, 6.4, 67.657, 349.426, 97.796);
					CreateDynamicObject(18450, 1488.1, -1595.4, 6.4, 272.655, 318.74, 315.769);
					CreateDynamicObject(18450, 1526.9, -1683.7, 6.4, 67.948, 356, 91.707);
					CreateDynamicObject(18450, 1482.2, -1732.3, 6.4, 67.945, 355.995, 3.703);
					CreateDynamicObject(18450, 1427.1, -1731.4, 10.2, 66.726, 340.031, 21.693);
					CreateDynamicObject(11340, 1391.3, -1759.7, 9.2, 0, 0, 179.995);
					CreateDynamicObject(11340, 1443, -1764.4, 9.2, 0, 0, 179.995);
					CreateDynamicObject(11340, 1479.9, -1752.8, 9.2, 0, 0, 201.495);
					CreateDynamicObject(10985, 1475.5, -1737.7, 12.9, 0, 0, 185.999);
					CreateDynamicObject(10985, 1399.7, -1729, 12.9, 0, 0, 185.999);
					CreateDynamicObject(10985, 1462.4, -1728.9, 13.5, 0, 0, 185.999);
					CreateDynamicObject(4186, 1482.43201, -1696.39392, 12.08902,   356.85840, 0.00000, 5.90668);
					CreateDynamicObject(3985, 1470.64819, -1632.44666, 9.40672,   356.85840, 0.00000, 3.14159);
				}
				case NATDIS_MAPAREA_MARKET:
				{
					CreateDynamicObject(16303, 1142.8, -1380.7, 7.4, 0, 6.5, 9.998);
					CreateDynamicObject(16084, 1121.9, -1399.6, 3.7, 0, 344.75, 4);
					CreateDynamicObject(18451, 1113.4, -1404.9, 7.1, 0, 7.5, 174);
					CreateDynamicObject(17565, 1130.5, -1402, 9.9, 0, 0, 270);
					CreateDynamicObject(17565, 1101, -1402.1, 9.9, 0, 0, 270);
					CreateDynamicObject(16302, 1111.8, -1385.8, 7, 0, 0, 0);
					CreateDynamicObject(16302, 1175.3, -1420.2, 12.5, 0, 0, 0);
					CreateDynamicObject(16766, 1113.7, -1414.1, 9.9, 0, 1, 0);
					CreateDynamicObject(16766, 1115.3, -1392.6, 9.9, 0, 1, 10);
					CreateDynamicObject(16384, 1110.9, -1383.9, 4.6, 89.099, 236.312, 123.691);
					CreateDynamicObject(16384, 1102.4, -1418.1, 4.6, 89.44, 153.941, 26.554);
					CreateDynamicObject(11340, 1139.4, -1409.5, 5.3, 0, 0.495, 0);
					CreateDynamicObject(18450, 1173.1, -1400.1, -5.2, 17.44, 51.445, 342.892);
					CreateDynamicObject(16302, 1157.1, -1400.1, 10.3, 0, 342, 0);
					CreateDynamicObject(11340, 1171.3, -1404.7, 6.1, 354.005, 357.733, 273.763);
					CreateDynamicObject(16302, 1134.4, -1411.4, 8.8, 0, 0, 0);
					CreateDynamicObject(3865, 1110.8, -1387.7, 9, 0, 0, 0);
					CreateDynamicObject(3865, 1088, -1406.7, 9, 334.223, 8.056, 91.522);
					CreateDynamicObject(7347, 1142.5, -1419.5, -23.2, 72.381, 296.265, 62.627);
					CreateDynamicObject(7916, 1109.2, -1396.1, 8.4, 0, 2, 0);
					CreateDynamicObject(7916, 1097.6, -1410, 8.4, 0, 2, 84);
					CreateDynamicObject(11340, 1083.3, -1387.8, 8.1, 0, 351.494, 338.25);
					CreateDynamicObject(3865, 1084.9, -1397.8, 9, 334.221, 8.053, 91.522);
					CreateDynamicObject(3865, 1091.4, -1384.5, 9, 334.221, 8.053, 61.522);
					CreateDynamicObject(18450, 1087.5, -1400.8, -12.4, 332.558, 61.865, 197.497);
					CreateDynamicObject(5811, 1127.3, -1380.5, 13.5, 355.114, 287.345, 344.746);
					CreateDynamicObject(16302, 1124.4, -1379.5, 9.6, 328.542, 348.253, 193.807);
					CreateDynamicObject(615, 1150, -1418.2, 11.9, 0, 324, 347.397);
					CreateDynamicObject(11340, 1247.8, -1372, 5.3, 354.001, 357.731, 269.763);
					CreateDynamicObject(11340, 1252, -1323.6, 5.3, 353.996, 357.731, 269.758);
					CreateDynamicObject(11340, 1212, -1291.4, 5.6, 354.01, 355.469, 89.522);
					CreateDynamicObject(1395, 1228.3, -1316.8, 15.5, 359.336, 276.466, 69.287);
					CreateDynamicObject(16084, 1211.8, -1348.9, 7, 0, 359.995, 255.999);
					CreateDynamicObject(16084, 1226.9, -1322.3, 6.2, 6.748, 1.253, 71.851);
					CreateDynamicObject(10675, 1238.4, -1376.9, 9.7, 0, 0, 0);
					CreateDynamicObject(11340, 1253.2, -1393.3, 5.3, 353.995, 357.983, 269.785);
					CreateDynamicObject(16302, 1221.4, -1293.2, 11.3, 0, 0, 0);
					CreateDynamicObject(16084, 1225.7, -1289.7, 6.2, 6.628, 349.171, 27.263);
					CreateDynamicObject(899, 1225.3, -1371.6, 7.5, 0, 0, 0);
					CreateDynamicObject(899, 1231.2, -1352.7, 8.8, 0, 0, 72);
					CreateDynamicObject(899, 1230.4, -1331.5, 8.8, 0, 0, 71.999);
					CreateDynamicObject(899, 1226.6, -1318, 8.8, 0, 0, 85.999);
					CreateDynamicObject(899, 1231.3, -1301.6, 8.3, 0, 354, 197.995);
					CreateDynamicObject(623, 1034, -1391.1, 11.4, 318.031, 2.69, 187.8);
					CreateDynamicObject(10985, 1031.3, -1388.9, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 951.90002, -1410.8, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 873.09998, -1413.6, 13.1, 0, 0, 0);
					CreateDynamicObject(10985, 825.79999, -1393.2, 13.1, 0, 0, 0);
					CreateDynamicObject(621, 873.90002, -1412.4, 11.6, 0, 84, 141.995);
					CreateDynamicObject(621, 828.20001, -1388.9, 11.9, 0, 86.746, 239.993);
					CreateDynamicObject(621, 956.29999, -1413.6, 11.6, 0, 73.996, 141.993);
					CreateDynamicObject(6342, 324, -1513.5, 54.2, 358.253, 356.498, 359.393);
					CreateDynamicObject(10985, 346.60001, -1491.3, 35.2, 356.503, 2.254, 37.638);
					CreateDynamicObject(10985, 314.5, -1520.9, 36.6, 2.994, 358.494, 52.828);
					CreateDynamicObject(16303, 350.20001, -1466.2, 30.9, 0, 354, 313.25);
					CreateDynamicObject(16303, 288.10001, -1556, 31.4, 0, 348.996, 7.248);
					CreateDynamicObject(11340, 333.5, -1509.2, 29.7, 0, 358.494, 66);
					CreateDynamicObject(18450, 335, -1547.1, 5.9, 0, 302, 48);
					CreateDynamicObject(18450, 359.10001, -1507.9, 5.9, 0, 301.998, 249.999);
					CreateDynamicObject(10985, 366.70001, -1527.9, 32.5, 356.501, 2.252, 253.634);
					CreateDynamicObject(10985, 359.10001, -1505, 32.5, 356.501, 2.247, 331.63);
					CreateDynamicObject(10985, 347.39999, -1562.8, 32.5, 356.501, 2.241, 331.628);
					CreateDynamicObject(6300, 378.5, -2050.2, 2.2, 352.532, 5.295, 0.69);
					CreateDynamicObject(6189, 850, -1998.2, 1.4, 0, 38, 0);
					CreateDynamicObject(6189, 826, -1998.7, 2.9, 0, 317.996, 358);
					CreateDynamicObject(6188, 852.09998, -1874.4, 1, 0, 9.75, 0);
					CreateDynamicObject(6188, 824, -1871.4, 1, 0, 325.745, 0);
					CreateDynamicObject(5481, 486.89999, -1712.6, 8.2, 0, 354, 0);
					CreateDynamicObject(5481, 580, -1752.7, 5.4, 2.979, 6.755, 332.147);
					CreateDynamicObject(10985, 524.20001, -1727.8, 12.3, 0, 0, 0);
					CreateDynamicObject(10985, 458.20001, -1700.1, 10.6, 0, 0, 0);
					CreateDynamicObject(10985, 453.39999, -1713, 10.6, 3.498, 357.996, 0.122);
					CreateDynamicObject(17026, 616.5, -1185.5, 5.9, 0, 0, 256);
					CreateDynamicObject(17026, 590.5, -1177.1, 7.9, 0, 0, 111.998);
					CreateDynamicObject(17026, 618.5, -1173.3, 7.9, 0, 0, 111.995);
					CreateDynamicObject(17026, 106.4, -1270.3, 7.1, 0, 0, 0);
					CreateDynamicObject(17026, 100.8, -1246.5, 7.1, 0, 0, 0);
					CreateDynamicObject(11340, 1019.9, -1371.6, 9.9, 0, 358.741, 0.247);
					CreateDynamicObject(11340, 1031.4, -1291.5, 10.6, 0, 358.737, 179.992);
					CreateDynamicObject(7347, 1026.8, -1339.5, -4.7, 49.212, 346.534, 282.276);
					CreateDynamicObject(7347, 1067.1, -1322.5, -43.5, 30.191, 165.502, 47.403);
					CreateDynamicObject(5995, 1131.20349, -1400.71777, 2.77620,   0.00000, 350.00000, 0.00000);
					CreateDynamicObject(5995, 1129.14209, -1400.70569, 2.56870,   0.00000, 10.00000, 0.00000);
				}
				case NATDIS_MAPAREA_BRIDGES:
				{
					CreateDynamicObject(16430, 567.40002, 405.5, 7.1, 0, 352, 304.997);
					CreateDynamicObject(3331, 535, 433.5, -4.1, 329.5, 0, 34.997);
					CreateDynamicObject(8056, 1737.6, 519.70001, 27.1, 1.486, 7.753, 0.298);
					CreateDynamicObject(8128, 1736.1, 519, 6.2, 0.495, 8, 359.18);
					CreateDynamicObject(3411, 2770.7, 361.60001, -7.5, 0, 350, 0);
					CreateDynamicObject(16358, -220.7, 169.39999, -8.1, 0, 347, 75.245);
					CreateDynamicObject(16358, -225.89999, 149, -7.6, 0, 350.998, 75.24);
					CreateDynamicObject(17002, 53.5, -1533.9, 6.6, 9.93, 353.147, 12.233);
					CreateDynamicObject(17034, 40.6, -1515.1, -14.1, 0, 0, 0);
					CreateDynamicObject(17034, 43.4, -1511.7, -14.1, 0, 4, 336);
					CreateDynamicObject(17034, 46.4, -1538.1, -14.1, 0, 3.999, 335.995);
					CreateDynamicObject(17034, 49.7, -1514.4, -9.4, 0, 181.999, 335.995);
				}
			}
		}
	}
}

NatDis_RemoveBuildings(playerid, iNasType, iArea)
{
	switch(iNasType)
	{
		case TYPE_EARTHQUAKE:
		{
			switch(iArea)
			{
				case 0:
				{
					// #include "Map_NatDis/Earthquake/RemoveBuildings/EQ_Downtown.pwn"
					RemoveBuildingForPlayer(playerid, 1290, 1614.9844, -1303.9375, 42.6797, 100.0);
					RemoveBuildingForPlayer(playerid, 3999, 1785.9766, -1564.8594, 25.2500, 0.25);
					RemoveBuildingForPlayer(playerid, 4009, 1421.3750, -1477.6016, 42.2031, 0.25);
					RemoveBuildingForPlayer(playerid, 4042, 1593.9531, -1416.3516, 26.6641, 0.25);
					RemoveBuildingForPlayer(playerid, 4081, 1734.3047, -1560.7109, 18.8828, 0.25);
					RemoveBuildingForPlayer(playerid, 4116, 1345.6250, -1552.9609, 48.5156, 0.25);
					RemoveBuildingForPlayer(playerid, 4131, 1588.4453, -1509.1406, 27.3125, 0.25);
					RemoveBuildingForPlayer(playerid, 4132, 1588.4453, -1509.1406, 27.3125, 0.25);
					RemoveBuildingForPlayer(playerid, 4221, 1406.7109, -1499.5625, 69.1563, 0.25);
					RemoveBuildingForPlayer(playerid, 4113, 1345.6250, -1552.9609, 48.5156, 0.25);
					RemoveBuildingForPlayer(playerid, 4007, 1421.3750, -1477.6016, 42.2031, 0.25);
					RemoveBuildingForPlayer(playerid, 3990, 1593.9531, -1416.3516, 26.6641, 0.25);
					RemoveBuildingForPlayer(playerid, 3998, 1734.3047, -1560.7109, 18.8828, 0.25);
					RemoveBuildingForPlayer(playerid, 4079, 1785.9766, -1564.8594, 25.2500, 0.25);
					RemoveBuildingForPlayer(playerid, 4563, 1567.6016, -1248.6953, 102.5234, 0.25);
					RemoveBuildingForPlayer(playerid, 4566, 1567.6016, -1248.6953, 102.5234, 0.25);
					RemoveBuildingForPlayer(playerid, 4578, 1496.8203, -1265.9531, 61.3516, 0.25);
					RemoveBuildingForPlayer(playerid, 4580, 1671.5078, -1343.3359, 87.5391, 0.25);
					RemoveBuildingForPlayer(playerid, 4606, 1825.0000, -1413.9297, 12.5547, 0.25);
					RemoveBuildingForPlayer(playerid, 4629, 1405.1172, -1191.4063, 85.0313, 0.25);
					RemoveBuildingForPlayer(playerid, 4663, 1624.8203, -1229.8594, 34.0859, 0.25);
					RemoveBuildingForPlayer(playerid, 4664, 1643.1641, -1128.2344, 41.5625, 0.25);
					RemoveBuildingForPlayer(playerid, 4665, 1643.1641, -1128.2344, 41.5625, 0.25);
					RemoveBuildingForPlayer(playerid, 4715, 1567.7188, -1248.6953, 102.5234, 0.25);
					RemoveBuildingForPlayer(playerid, 4723, 1496.8203, -1265.9531, 61.3516, 0.25);
					RemoveBuildingForPlayer(playerid, 4725, 1406.2266, -1194.4063, 22.8203, 0.25);
					RemoveBuildingForPlayer(playerid, 4747, 1671.5078, -1343.3359, 87.5391, 0.25);
					RemoveBuildingForPlayer(playerid, 4586, 1405.1172, -1191.4063, 85.0313, 0.25);
					RemoveBuildingForPlayer(playerid, 4570, 1496.8203, -1265.9531, 61.3516, 0.25);
					RemoveBuildingForPlayer(playerid, 4594, 1825.0000, -1413.9297, 12.5547, 0.25);
					RemoveBuildingForPlayer(playerid, 4602, 1671.5078, -1343.3359, 87.5391, 0.25);
					RemoveBuildingForPlayer(playerid, 1290, 1624.4297, -1226.6484, 56.1016, 0.25);
					RemoveBuildingForPlayer(playerid, 4662, 1624.8203, -1229.8594, 34.0859, 0.25);
				}
				case 1:
				{
					// #include "Map_NatDis/Earthquake/RemoveBuildings/EQ_EastLS.pwn"
					RemoveBuildingForPlayer(playerid, 17835, 2431.0391, -1603.4922, 20.2031, 0.25);
					RemoveBuildingForPlayer(playerid, 17858, 2489.2969, -1668.5000, 12.2969, 0.25);
					RemoveBuildingForPlayer(playerid, 17613, 2489.2969, -1668.5000, 12.2969, 0.25);
					RemoveBuildingForPlayer(playerid, 17971, 2484.5313, -1667.6094, 21.4375, 0.25);
					RemoveBuildingForPlayer(playerid, 17657, 2431.0391, -1603.4922, 20.2031, 0.25);
					RemoveBuildingForPlayer(playerid, 17898, 2431.0391, -1603.4922, 20.2031, 0.25);
				}
				case 2:
				{
					// #include "Map_NatDis/Earthquake/RemoveBuildings/EQ_Commerce.pwn"
					RemoveBuildingForPlayer(playerid, 4057, 1479.5547, -1693.1406, 19.5781, 0.25);
					RemoveBuildingForPlayer(playerid, 4210, 1479.5625, -1631.4531, 12.0781, 0.25);
					RemoveBuildingForPlayer(playerid, 4186, 1479.5547, -1693.1406, 19.5781, 0.25);
					RemoveBuildingForPlayer(playerid, 3985, 1479.5625, -1631.4531, 12.0781, 0.25);
				}
				case 3:
				{
					// #include "Map_NatDis/Earthquake/RemoveBuildings/EQ_Market.pwn"
					RemoveBuildingForPlayer(playerid, 1297, 1161.1563, -1390.1172, 15.6406, 100.25);
					RemoveBuildingForPlayer(playerid, 5812, 1230.8906, -1337.9844, 12.5391, 0.25);
					RemoveBuildingForPlayer(playerid, 5995, 1130.0547, -1400.7031, 12.5234, 0.25);
					RemoveBuildingForPlayer(playerid, 5997, 1130.0547, -1400.7031, 12.5234, 0.25);
					RemoveBuildingForPlayer(playerid, 5811, 1131.1953, -1380.4219, 17.0703, 0.25);
					RemoveBuildingForPlayer(playerid, 6475, 322.4219, -1514.9922, 55.2891, 0.25);
					RemoveBuildingForPlayer(playerid, 6342, 322.4219, -1514.9922, 55.2891, 0.25);
				}
				case 4:
				{
					// #include "Map_NatDis/Earthquake/RemoveBuildings/EQ_Bridges.pwn"
					RemoveBuildingForPlayer(playerid, 8028, 1735.8594, 519.1563, 25.1563, 0.25);
					RemoveBuildingForPlayer(playerid, 8056, 1735.8594, 519.1563, 25.1563, 0.25);
					RemoveBuildingForPlayer(playerid, 8128, 1735.8750, 519.0078, 4.3594, 0.25);
					RemoveBuildingForPlayer(playerid, 8129, 1735.8750, 519.0078, 4.3594, 0.25);
					RemoveBuildingForPlayer(playerid, 3332, 537.1953, 434.4063, 24.5547, 0.25);
					RemoveBuildingForPlayer(playerid, 16432, 566.8984, 406.3750, 17.5859, 0.25);
					RemoveBuildingForPlayer(playerid, 3382, -176.3516, 367.5234, 17.6953, 0.25);
					RemoveBuildingForPlayer(playerid, 3382, -196.7891, 290.1797, 17.6953, 0.25);
					RemoveBuildingForPlayer(playerid, 16688, -168.3203, 367.2422, 10.6641, 0.25);
					RemoveBuildingForPlayer(playerid, 3381, -196.7891, 290.1797, 17.6953, 0.25);
					RemoveBuildingForPlayer(playerid, 3381, -176.3516, 367.5234, 17.6953, 0.25);
					RemoveBuildingForPlayer(playerid, 16358, -168.3203, 367.2422, 10.6641, 0.25);
					RemoveBuildingForPlayer(playerid, 3331, 537.1953, 434.4063, 24.5547, 0.25);
					RemoveBuildingForPlayer(playerid, 16430, 566.8984, 406.3750, 17.5859, 0.25);
					RemoveBuildingForPlayer(playerid, 13317, 2766.8594, 468.0469, 7.3203, 0.25);
					RemoveBuildingForPlayer(playerid, 3413, 2766.7578, 364.9531, -4.4922, 0.25);
					RemoveBuildingForPlayer(playerid, 3413, 2766.7578, 463.9922, -4.4922, 0.25);
					RemoveBuildingForPlayer(playerid, 12831, 2766.8594, 468.0469, 7.3203, 0.25);
					RemoveBuildingForPlayer(playerid, 3411, 2766.7578, 463.9922, -4.4922, 0.25);
					RemoveBuildingForPlayer(playerid, 3412, 2766.7578, 464.1563, -4.4922, 0.25);
					RemoveBuildingForPlayer(playerid, 17002, 52.8906, -1532.0313, 7.7422, 0.25);
					RemoveBuildingForPlayer(playerid, 4250, -188.9609, 288.2578, -44.9922, 0.25);
					RemoveBuildingForPlayer(playerid, 4385, -188.9609, 288.2578, -44.9922, 0.25);
				}
			}
		}
	}
	format(szMiscArray, sizeof(szMiscArray), "Successfully loaded mapping: NastType: %i | Area: %i", iNasType, iArea);
	SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
}

NatDis_EditZones(playerid, iZoneTypeID) {

	szMiscArray[0] = 0;
	new szStatus[32];
	SetPVarInt(playerid, "_EditingZoneType", iZoneTypeID);
	switch(iZoneTypeID)
	{
		case 1:
		{
			for(new i; i < sizeof(gMainZones); ++i) {

				switch(NatDis[i][nat_iStatus]) // needs rework
				{
					case 1: szStatus = "{FF0000}Quake Zone";
					case 2: szStatus = "{FFF000}Evacuation Zone";
					case 3: szStatus = "{00FF00}Safe Zone";
					default: szStatus = "{FFFFFF}Inactive Zone";
				}
				format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}%s%s\t%s\n", szMiscArray, gMainZones[i][SAZONE_NAME], szStatus);
			}
			
		}
		case 2:
		{
			for(new i; i < sizeof(gLocalZones); ++i)
			{

				switch(NatDis[i][nat_iStatus]) // needs rework
				{
					case 1: szStatus = "{FF0000}Quake Zone";
					case 2: szStatus = "{FFF000}Evacuation Zone";
					case 3: szStatus = "{00FF00}Safe Zone";
					default: szStatus = "{FFFFFF}Inactive Zone";
				}
				format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}%s%s\t%s\n", szMiscArray, gLocalZones[i][SAZONE_NAME], szStatus);
			}
		}
	}
	return ShowPlayerDialogEx(playerid, DIALOG_NATDIS_EDITZONE, DIALOG_STYLE_TABLIST, "Natural Disaster | Edit Zones", szMiscArray, "Cancel", "Select");
}

CMD:natdis(playerid, params[])
{
	if(!IsAdminLevel(playerid, ADMIN_EXECUTIVE)) return 1;
	NatDis_MainMenu(playerid);
	return 1;
}