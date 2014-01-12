//
// Fireworks Filterscript by Martok
//   Based upon & using xFireworks by Boylett
//
//   Using dcmd by DracoBlue
//         sscanf from the SA:MP-Wiki by an unknown author ;)
//


#include <a_samp>
#include <sscanf2>
#include <xFireworks>
#include <zcmd>
#include <streamer>

#undef MAX_PLAYERS
#define MAX_PLAYERS 700

new explosions[] = {0,2,4,5,6,7,8,9,10,13};

new machines[] = {19121, 19122, 19123, 19124, 19125, 19126, 19127 };
enum t_fwbattery {
    inuse,
    timer,
    count,
    Float:height,
    hvar,
    Float:windspeed,
    Float:interval,
    Float:pos[3],
    machine
};

new batteries[100][t_fwbattery];

findempty()
{
    for (new i=0;i<sizeof(batteries);i++) {
        if (!batteries[i][inuse]) return i;
    }
    return -1;
}

GetSomeTime(id)
{
   return floatround((400 + random(300)) * batteries[id][interval]);
}



forward machinetimer(id);
public machinetimer(id)
{
    if (batteries[id][count]) {
		CreateFirework(batteries[id][pos][0],batteries[id][pos][1],batteries[id][pos][2],           //pos
                       batteries[id][height] - batteries[id][hvar]/2 + random(batteries[id][hvar]),   //height
                       random(360),batteries[id][windspeed],                                        //wind
                       50.0,                                                                        //speed
                       explosions[random(sizeof(explosions))],100.0);                               //explosion
        batteries[id][count]--;
        batteries[id][timer] = SetTimerEx("machinetimer",GetSomeTime(id),false,"i",id);
    } else {
        KillTimer(batteries[id][timer]);
        batteries[id][timer] = -1;
        batteries[id][inuse] = false;
	    DestroyObject(batteries[id][machine]);
    }
}

public OnFilterScriptInit()
{
    for (new i=0;i<sizeof(batteries);i++) {
        batteries[i][inuse] = false;
    }
    print(" --  Fireworks by Martok");
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 900);
}

public OnFilterScriptExit()
{
    for (new i=0;i<sizeof(batteries);i++) {
	   DestroyObject(batteries[i][machine]);
    }
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 965);
}

CMD:fwspawn(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
	new c, id, Float:h, hv, Float:w, Float:in;
	if (sscanf(params, "ififf",c,h,hv,w,in)) {
       SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /fwspawn {COUNT} {HEIGHT} {HVAR} {WINDSPEED} {INTERVAL}");
       SendClientMessage(playerid, 0xFFFFFFFF, "Example: /fwspawn 20 50.0 20 30.0 1.0");
	}
	else {
		id = findempty();
		if (id<0) SendClientMessage(playerid, 0xFFFFFFFF, "No free slot!");
		else {
			new Float:x, Float:y, Float:z, Float:a;
			GetPlayerPos(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,a);
			GetXYInFrontOfPosition(x,y,a,1.0);
			batteries[id][pos][0] = x;
			batteries[id][pos][1] = y;
			batteries[id][pos][2] = z-1;
			batteries[id][count] = c;
			batteries[id][height] = h;
			batteries[id][hvar] = hv;
			batteries[id][windspeed] = w;
			batteries[id][interval] = in;

			batteries[id][inuse] = true;
			new robj =  machines[ random( sizeof(machines) ) ];
			batteries[id][machine] = CreateObject(robj,x,y,z,0.0,0.0,0.0);
			new tmp[256];
			format(tmp,sizeof(tmp),"Machine created. Slot: %d", id);
			SendClientMessage(playerid, 0x55FF55FF, tmp);
		}
	}
	return 1;
}

CMD:fwfire(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
	new id;
	if (sscanf(params, "i",id) || id>sizeof(batteries) || id<0) SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /fwfire {ID}");
	else {
		batteries[id][timer] = SetTimerEx("machinetimer",GetSomeTime(id),false,"i",id);
		SendClientMessage(playerid, 0xFFFFFFFF, "Firework started.");
	}
	return 1;
}

CMD:fwfireall(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
	#pragma unused params
	#pragma unused playerid
	for (new i=0; i<sizeof(batteries); i++) {
	   if (batteries[i][inuse]) {
			batteries[i][timer] = SetTimerEx("machinetimer",GetSomeTime(i),false,"i",i);
	   }
	}
	SendClientMessage(playerid, 0xFFFFFFFF, "All fireworks started.");
	return 1;
}

CMD:fwkill(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
	new id;
	if (sscanf(params, "i",id) || id>sizeof(batteries) || id<0) SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /fwfire {ID}");
	else {
	   KillTimer(batteries[id][timer]);
	   batteries[id][inuse] = false;
	   DestroyObject(batteries[id][machine]);
	   SendClientMessage(playerid, 0xFFFFFFFF, "Firework deleted.");
	}
	return 1;
}

CMD:fwkillall(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
	#pragma unused params
	#pragma unused playerid
	for (new i=0; i<sizeof(batteries); i++) {
	   if (batteries[i][inuse]) {
		   KillTimer(batteries[i][timer]);
		   batteries[i][inuse] = false;
		   DestroyObject(batteries[i][machine]);
	   }
	}
	SendClientMessage(playerid, 0xFFFFFFFF, "All fireworks deleted.");
	return 1;
}

CMD:fwsave(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
    new filename[20],tmp[256];
    if (sscanf(params, "s",filename)) SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /fwsave {NAME}");
    else {
        format(tmp,sizeof(tmp),"%s.firework",filename);
        new File:f = fopen(tmp,io_write);
        for (new i=0; i<sizeof(batteries); i++) {
            if (batteries[i][inuse]) {
                format(tmp, sizeof(tmp), "%f %f %f %d %f %d %f %f\r\n",
                                        batteries[i][pos][0],
                                        batteries[i][pos][1],
                                        batteries[i][pos][2],
                                        batteries[i][count],
                                        batteries[i][height],
                                        batteries[i][hvar],
                                        batteries[i][windspeed],
                                        batteries[i][interval]);
                fwrite(f, tmp);
            }
        }
        fclose(f);
        SendClientMessage(playerid, 0xFFFFFFFF, "Fireworks saved.");
    }
    return 1;
}


CMD:fwload(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
    new filename[20],tmp[256];
    if (sscanf(params, "s",filename)) SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /fwload {NAME}");
    else {
        format(tmp,sizeof(tmp),"%s.firework",filename);
        if (!fexist(tmp)) SendClientMessage(playerid, 0xFFFFFFFF, "File not found!");
        else {
            new id;
            new File:f = fopen(tmp,io_read);
        	while(fread(f, tmp)) {
        	    id = findempty();
        	    if (id<0) {
        	        SendClientMessage(playerid, 0xFFFFFFFF, "Out of slots...");
                    return 1;
        	    }
                batteries[id][inuse] = true;
                sscanf(tmp, "fffififf",
                             batteries[id][pos][0],
                             batteries[id][pos][1],
                             batteries[id][pos][2],
                             batteries[id][count],
                             batteries[id][height],
                             batteries[id][hvar],
                             batteries[id][windspeed],
                             batteries[id][interval]);
		 		new robj =  machines[ random( sizeof(machines) ) ];
            	batteries[id][machine] = CreateObject(robj,batteries[id][pos][0],batteries[id][pos][1],batteries[id][pos][2],0.0,0.0,0.0);

        	}
            fclose(f);
            SendClientMessage(playerid, 0xFFFFFFFF, "Fireworks loaded.");
        }
    }
    return 1;
}

CMD:fwnight(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
    #pragma unused params
    #pragma unused playerid
    SetWorldTime(0);
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i))
            SetPlayerTime(playerid,0,0);
    }
    return SendClientMessageToAll(0xDDDD11FF,"The world time has been changed to 0:00.");
}

CMD:fwhelp(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
    #pragma unused params
    SendClientMessage(playerid, 0xDDDD11FF, "Fireworks Script Commands:");
    SendClientMessage(playerid, 0xDDDD11FF, "/fwspawn - create a battery");
    SendClientMessage(playerid, 0xDDDD11FF, "/fwfire - fire a single battery");
    SendClientMessage(playerid, 0xDDDD11FF, "/fwkill - remove a single battery");
    SendClientMessage(playerid, 0xDDDD11FF, "/fwfireall - fire all batteries");
    SendClientMessage(playerid, 0xDDDD11FF, "/fwkillall - remove all batteries");
    SendClientMessage(playerid, 0xDDDD11FF, "/fwsave - save/overwrite all current batteries");
    SendClientMessage(playerid, 0xDDDD11FF, "/fwload - load a file");
    SendClientMessage(playerid, 0xDDDD11FF, "/fwnight - switches everyone to night");
    return 1;
}



public OnObjectMoved(objectid)
{
    xFireworks_OnObjectMoved(objectid);
}
