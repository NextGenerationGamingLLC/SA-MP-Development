//#define dpsmap

#include <a_samp>
#include <a_http>
#if defined dpsmap
#include <djson>
#endif
#include <streamer>

new rcontimer, playertimer, players, area;

new unbanip[MAX_PLAYERS][16];
new lastconnect[100][16];

#if defined dpsmap
new vehicledriver[47][24];
new dps;
#endif

native gpci(playerid, serial[], maxlen);

enum AC_STRUCT_INFO {
	Float:LastOnFootPosition[3],
	lastantijackstate,
	antijackcount,
	checkmaptp,
	maptplastclick,
	Float:maptp[3]
}

new acstruct[MAX_PLAYERS][AC_STRUCT_INFO];
	/*
	 *	Weapon information.
	 */
		enum PCOR_ENU_WEAPON_INFO {
			WEP_SLOT_INDEX,
			WEP_NAME[32],
			WEP_MODEL_ID,
			Float:WEP_BASE_DAMAGE
		}

		/*
		// Other
		// -1+1 = unknown, 12-12 = index 12, but weapon should be ignored(id 40 - Detonator)
		new const WeaponIDToSlot[47] = { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 8, 8, 8, -1+1, -1+1, -1+1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 4, 6, 6, 7, 7, 7, 7, 8, 12-12, 9, 9, 9, 11, 11, 11 };
		*/

		stock const WEAPON_DATA[47][PCOR_ENU_WEAPON_INFO] = {
			{ 0, 	"Fists",							0	, 1000.0000	},	// 0   Fists
			{ 0,	"Brassknuckle",						331	, 1000.0000	},	// 1   Brassknuckle
			{ 1,	"Golf club",						333	, 1000.0000	},	// 2   Golf
			{ 1,	"Nite stick",						334	, 1000.0000	},	// 3   Nite
			{ 1,	"Knife",							335	, 1000.0000	},	// 4   Knife
			{ 1,	"Baseball bat",						336	, 1000.0000	},	// 5   Baseball
			{ 1,	"Shovel",							337	, 1000.0000	},	// 6   Shovel
			{ 1,	"Pool stick",						338	, 1000.0000	},	// 7   Pool
			{ 1,	"Katakana",							339	, 1000.0000	},	// 8   Katakana
			{ 1,	"Chainsaw",							341	, 1000.0000	},	// 9   Chainsaw
			{ 10,	"Dildo",							321	, 1000.0000	},	// 10  Dildo
			{ 10,	"Dildo2",							322	, 1000.0000	},	// 11  Dildo2
			{ 10,	"Vibrator",							323	, 1000.0000	},	// 12  Vibrator
			{ 10,	"Vibrator2",						324	, 1000.0000	},	// 13  Vibrator2
			{ 10,	"Flowers",							325	, 1000.0000	},	// 14  Flowers
			{ 10,	"Cane",								326	, 1000.0000	},	// 15  Cane
			{ 8,	"Grenade",							342	, 1000.0000	},	// 16  Grenade
			{ 8,	"Teargas",							343	, 1000.0000	},	// 17  Teargas
			{ 8,	"Molotov cocktail",					344	, 1000.0000	},	// 18  Molotov
			{ -1+1,	"Rocket projectile",				-1	, 1000.0000	},	// 19  Rocket
			{ -1+1,	"Heat seeking rocket projectile",	-1	, 1000.0000	},	// 20  Heat
			{ -1+1,	"Hydra rocket projectile",			345	, 1000.0000	},	// 21  Hydra
			{ 2,	"Colt45",							346	, 8.2500	},	// 22  Colt45
			{ 2,	"Silenced pistol",					347	, 13.2000	},	// 23  Silenced
			{ 2,	"Desert Eagle",						348	, 46.2000	},	// 24  Desert
			{ 3,	"Shotgun",							349	, 3.3000	},	// 25  Shotgun
			{ 3,	"Sawn-off Shotgun",					350	, 3.3000	},	// 26  Sawn
			{ 3,	"Combat Shotgun",					351	, 4.9500	},	// 27  Combat
			{ 4,	"Micro Uzi",						352	, 6.6000	},	// 28  Micro
			{ 4,	"MP5",								353	, 8.2500	},	// 29  MP5
			{ 5,	"AK47",								355	, 9.9000	},	// 30  AK47
			{ 5,	"M4",								356	, 9.9000	},	// 31  M4
			{ 4,	"Tec9",								372	, 6.6000	},	// 32  Tec9
			{ 6,	"Rifle",							357	, 24.7500	},	// 33  Rifle
			{ 6,	"Sniper rifle",						358	, 41.2500	},	// 34  Sniper
			{ 7,	"Rocketlauncher",					359	, 1000.0000	},	// 35  Rocketlauncher
			{ 7,	"Heatseeking rocketlauncher",		360	, 1000.0000	},	// 36  Heatseeking
			{ 7,	"Flamethrower",						361	, 1000.0000	},	// 37  Flamethrower		(Cannot handle this properly.. seems like game calculates this on the fly, not properly divided by anything.)
			{ 7,	"Minigun",							362	, 1000.0000	},	// 38  Minigun
			{ 8,	"Satchel",							363	, 1000.0000	},	// 39  Satchel
			{ 12-12,"Detonator",						364	, 1000.0000	},	// 40  Detonator
			{ 9,	"Spraycan",							365	, 0.3300	},	// 41  Spraycan
			{ 9,	"Fire extinguisher",				366	, 1000.0000	},	// 42  Fire				(Cannot handle this properly.. seems like game calculates this on the fly, not properly divided by anything.)
			{ 9,	"Camera",							367	, 1000.0000	},	// 43  Camera
			{ 11,	"Nightvision Goggles",				368	, 1000.0000	},	// 44  Nightvision
			{ 11,	"Thermal Goggles",					369	, 1000.0000	},	// 45  Thermal
			{ 11,	"Parachute",						371	, 1000.0000	}	// 46  Parachute
		};

public OnFilterScriptInit()
{
	for(new x;x<MAX_PLAYERS;x++)
	{
	    if(IsPlayerConnected(x))
	    {
	        players++;
			#if defined dpsmap
			if(GetPlayerState(x) == PLAYER_STATE_DRIVER)
			{
			    if(GetPlayerVehicleID(x) >= 96 && GetPlayerVehicleID(x) <= 142)
			    {
			        GetPlayerName(x, vehicledriver[GetPlayerVehicleID(x)-96], MAX_PLAYER_NAME);
			    }
			}
			#endif
	    }
	}
	
	CreateDynamicObject(2103, 2545.2825,1412.0287,7698.5845, 0.0, 0.0, 0.0);
	CreateDynamic3DTextLabel("Check out {FF0000}shop.ng-gaming.net{FFFF00} to get a boombox!\n\nVIP's boombox\n{FF0000}/setboombox {FFFF00}or\n{FF0000}/destroyboombox",0xFFFF00AA, 2545.2825,1412.0287,7699.5845+0.6, 5.0);
	//area = CreateDynamicSphere(2547.0, 1410.0, 7699.0, 200.0);
	
	PlayerGraph();
	#if defined dpsmap
	djson_GameModeInit();
	#endif
    AddEchoMessage("p=IRC Echo Initialized");
	rcontimer=SetTimer("RconEcho", 1000, true);
	playertimer=SetTimer("PlayerGraph", 300000, true);
	#if defined dpsmap
	dps=SetTimer("DPSGraph", 5000, true);
	#endif
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(rcontimer);
	KillTimer(playertimer);
	#if defined dpsmap
	KillTimer(dps);
	djson_GameModeExit();
	#endif
	return 1;
}

forward Disconnect(playerid);
public Disconnect(playerid)
{
	new string[24];
    GetPlayerIp(playerid, unbanip[playerid], 16);
    format(string, sizeof(string), "banip %s", unbanip[playerid]);
	SendRconCommand(string);
}

public OnPlayerConnect(playerid)
{
    new string[128], serial[64], name[MAX_PLAYER_NAME], ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));
   	gpci(playerid, serial, sizeof(serial));
	GetPlayerName(playerid, name, sizeof(name));
	
	new count;
	for(new x;x<sizeof(lastconnect);x++)
	{
	    if(strlen(lastconnect[x]) < 1)
		{
			format(lastconnect[x], 16, "%s", ip);
			SetTimerEx("removeip", 5000, false, "i", x);
			break;
		}
	}
	for(new x;x<sizeof(lastconnect);x++)
	{
	    if(strlen(lastconnect[x]) > 0 && strcmp(ip, lastconnect[x]) == 0) count++;
	}
	if(count > 5)
	{
	    Kick(playerid);
	    format(string, sizeof(string), "banip %s", ip);
	    SendRconCommand(string);
	    
	    SetTimerEx("Unban", ((60*1000)*5), false, "s", ip);
	    
		format(string, sizeof(string), "p=blocked %s - %s [%d] - %s", name, ip, count, serial);
		AddEchoMessage(string);
	    return 1;
	}
	
	players++;

	if((strcmp(serial, "90E44CE48A4C059CC8D848D98D9E8D084F0D8844", true) == 0))
	{
 		GetPlayerName(playerid, name, sizeof(name));
   		format(string, sizeof(string), "p=%s %d (%s) may be ban evading (F)", name, playerid, ip);
	    AddEchoMessage(string);
  	}
  	if((strcmp(serial, "E8C49D8848484584A94D908A8CEA9D98D85DDA99", true) == 0))
	{
 		GetPlayerName(playerid, name, sizeof(name));
   		format(string, sizeof(string), "p=%s %d (%s) may be ban evading (F_H)", name, playerid, ip);
	    AddEchoMessage(string);
  	}
	return 1;
}

forward removeip(x);
public removeip(x)
{
	format(lastconnect[x], 16, "");
}

forward Unban(ip[]);
public Unban(ip[])
{
	new string[128];
	format(string, sizeof(string), "unbanip %s", ip);
	SendRconCommand(string);
	format(string, sizeof(string), "p=unblocking %s [block expired]", ip);
	AddEchoMessage(string);
}

public OnPlayerDisconnect(playerid)
{
	if(strlen(unbanip[playerid]) > 0)
	{
	    new string[26];
	    format(string, sizeof(string), "unbanip %s", unbanip[playerid]);
	    SendRconCommand(string);
	}
	players--;
    acstruct[playerid][lastantijackstate] = 0; acstruct[playerid][antijackcount] = 0;
    acstruct[playerid][LastOnFootPosition][0] = 0.0; acstruct[playerid][LastOnFootPosition][1] = 0.0; acstruct[playerid][LastOnFootPosition][2] = 0.0;
	acstruct[playerid][antijackcount] = 0; acstruct[playerid][checkmaptp] = 0; acstruct[playerid][maptplastclick] = 0; acstruct[playerid][lastantijackstate] = 0;
	acstruct[playerid][maptp][0] = 0.0; acstruct[playerid][maptp][1] = 0.0; acstruct[playerid][maptp][2] = 0.0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
    acstruct[playerid][lastantijackstate] = 0;
    acstruct[playerid][antijackcount] = 0;
    return 1;
}

forward PlayerGraph();
public PlayerGraph()
{
	new string[6];
	format(string, sizeof(string), "p=%d", players);
    HTTP(0, HTTP_POST, "samp.ng-gaming.net/scott/misc/players.php", string, "");
    return 1;
}

#if defined dpsmap
forward DPSGraph();
public DPSGraph()
{
	new Float:tmp_float;
	new Float:tmp_floatx,Float:tmp_floaty;
	new tmp[255], tmp2[255];

	djAutocommit(false);
	for (new i=96;i<142;i++) {

		format(tmp,255,"items/p%d/id",i);
		djSetInt("map.json",tmp,i);

        format(tmp2,255,"Vehicle ID: %d",i);
		format(tmp,255,"items/p%d/name",i);
		djSet("map.json",tmp,tmp2);

		format(tmp,255,"items/p%d/icon",i);
		djSet("map.json",tmp,"30");

		format(tmp2,255,"%s",vehicledriver[i-96]);
		format(tmp,255,"items/p%d/text",i);
		djSet("map.json",tmp,tmp2);

		GetVehiclePos(i,tmp_floatx,tmp_floaty,tmp_float);
		format(tmp,255,"items/p%d/pos/x",i);
		djSetInt("map.json",tmp,floatround(tmp_floatx));
		format(tmp,255,"items/p%d/pos/y",i);
		djSetInt("map.json",tmp,floatround(tmp_floaty));
	}
	djCommit("map.json");
	djAutocommit(true);
    return 1;
}
#endif

#if defined dpsmap
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
	{
	    if(GetPlayerVehicleID(playerid) >= 96 && GetPlayerVehicleID(playerid) <= 142)
	    {
	        GetPlayerName(playerid, vehicledriver[GetPlayerVehicleID(playerid)-96], MAX_PLAYER_NAME);
	    }
	}
	return 1;
}
#endif

forward RconEcho();
public RconEcho()
{
	if(fexist("recho.txt"))
	{
     	new string[128];
	    new File:rcon = fopen("recho.txt", io_read);
	    fread(rcon, string);
	    fclose(rcon);
		fremove("recho.txt");

	    format(string, sizeof(string), "say %s", string);
	    SendRconCommand(string);
	    format(string, sizeof(string), "p=%s", string);
	    AddEchoMessage(string);
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
	if(weaponid < 47)
	{
		// we only care about who took damage, not who received it.
		#pragma unused issuerid

		if (amount > 1833.33) // some weird glitch
			return 1;

		if ((WEAPON_DATA[weaponid][WEP_BASE_DAMAGE] < 1000.0) && (amount != 2.64)) {

			new upped = 0;
			new amountupped = 0;

			upped			= floatround(WEAPON_DATA[weaponid][WEP_BASE_DAMAGE] * 10000, floatround_floor);
			amountupped		= floatround(amount * 10000, floatround_floor);

			new rem = amountupped % upped;

			if (rem != 0) {
				new tmpstr[25], tmpstrrepc[25];
				format(tmpstr, 25, "WDATRT_%d_%0.4f", weaponid, amount);
				format(tmpstrrepc, 25, "WDATRN_%d_%0.4f", weaponid, amount);

				new lasttime = GetPVarInt(playerid, tmpstr);
				new reportcnt = GetPVarInt(playerid, tmpstrrepc);
				new rtd = GetTickCount()-lasttime;

				if ((lasttime == 0) || (rtd > 3000)) {

					reportcnt++;

					new string[128], name[MAX_PLAYER_NAME];
					GetPlayerName(playerid, name, sizeof(name));
					format(string, sizeof(string), "p=[weapon_dat] %s %d %d %0.5f %0.5f %d", name, playerid, weaponid, amount, WEAPON_DATA[weaponid][WEP_BASE_DAMAGE], reportcnt);
					AddEchoMessage(string);

					SetPVarInt(playerid, tmpstr, GetTickCount());
					SetPVarInt(playerid, tmpstrrepc, reportcnt);
				}

			}

		}
	}
	return 1;
}

stock Float:Distance( Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2 )
{
	new Float:d;
	d += floatpower(x1-x2, 2.0 );
	d += floatpower(y1-y2, 2.0 );
	d += floatpower(z1-z2, 2.0 );
	d = floatsqroot(d);
	return d;
}

check_remote_jacking(PlayerID)
{
    new currstate = GetPlayerVehicleID(PlayerID);

    if (!IsPlayerInAnyVehicle(PlayerID)) // always remember last onfoot coords.
        GetPlayerPos(PlayerID, acstruct[PlayerID][LastOnFootPosition][0], acstruct[PlayerID][LastOnFootPosition][1], acstruct[PlayerID][LastOnFootPosition][2]);

    if ((currstate != acstruct[PlayerID][lastantijackstate]) && (currstate != 0) && (GetPlayerState(PlayerID) == PLAYER_STATE_DRIVER)) {

        new Float:Tmppos[3];

        GetVehiclePos(GetPlayerVehicleID(PlayerID), Tmppos[0], Tmppos[1], Tmppos[2]);

        new Float:distancejack = 0.0;
        distancejack = Distance(Tmppos[0], Tmppos[1], Tmppos[2], acstruct[PlayerID][LastOnFootPosition][0], acstruct[PlayerID][LastOnFootPosition][1], acstruct[PlayerID][LastOnFootPosition][2]);

        new thiscaride;
        thiscaride = GetVehicleModel(GetPlayerVehicleID(PlayerID));

        new Float:distanceth = 10.0; // some sane random value

        if ((thiscaride == 577) || (thiscaride == 592)) //ignore AT-400 and andromada (false positives spam)
            distanceth = 25.0;

        if (distancejack > distanceth) {
            if(acstruct[PlayerID][antijackcount] > 2)
            {
	        	new issin = 0;
	         	if (IsVehicleStreamedIn(GetPlayerVehicleID(PlayerID), PlayerID))
	          		issin = 1;

				new sTemp2[256];
				new pNickname[MAX_PLAYER_NAME];
				GetPlayerName(PlayerID, pNickname, sizeof(pNickname)); // LDC: %d
	   			format(sTemp2, sizeof(sTemp2), "p=[checkremotejack] %s %d vid: %d IDE: %d distance: %0.1f (%0.2f, %0.2f, %0.2f -> %0.2f, %0.2f, %0.2f ) streamed: %d", pNickname, PlayerID, currstate, thiscaride, distancejack, Tmppos[0], Tmppos[1], Tmppos[2], acstruct[PlayerID][LastOnFootPosition][0], acstruct[PlayerID][LastOnFootPosition][1], acstruct[PlayerID][LastOnFootPosition][2], GetTickCount() /*- pLastDrunkChange[PlayerID]*/, issin);
	      		AddEchoMessage(sTemp2);
	      		Disconnect(PlayerID);
			}
			acstruct[PlayerID][antijackcount]++;
        }

        // This is now assumed last position, so we can see if player teleported from one car to another.
        GetPlayerPos(PlayerID, acstruct[PlayerID][LastOnFootPosition][0], acstruct[PlayerID][LastOnFootPosition][1], acstruct[PlayerID][LastOnFootPosition][2]);

        acstruct[PlayerID][lastantijackstate] = currstate;
    }
}

public OnPlayerUpdate(playerid)
{
	check_remote_jacking(playerid);
	return 1;
}

stock AddEchoMessage(string[])
{
    HTTP(0, HTTP_POST, "samp.ng-gaming.net/scott/irc/post.php", string, "");
    return 1;
}

/*public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == area)
	{
		PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1280356", 2547.0, 1410.0, 7699.0, 200.0, 1);
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(areaid == area)
	{
		StopAudioStreamForPlayer(playerid);
	}
	return 1;
}*/
