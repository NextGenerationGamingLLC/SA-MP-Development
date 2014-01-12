#include <a_samp>

// Sews DMRadar... A simple set-up to identify DM, and watching who is responsible.

// This contains a function and the concept comes from PEN:LS.
// Credits to Sneaky, and who-ever made the basis for, pen1...

#define L1KILLER_COLOR 0x9F0000C8
#define L1KILLER1_COLOR 0x9F000099
#define L1KILLER2_COLOR 0x9F000088
#define L1KILLER3_COLOR 0x9F000077
#define L1KILLER4_COLOR 0x9F000066
#define L1KILLER5_COLOR 0x9F000055
#define L1KILLER6_COLOR 0x9F000044
#define L1KILLER7_COLOR 0x9F000033
#define L1KILLER8_COLOR 0x9F000022
#define L1KILLER9_COLOR 0x9F000011
#define L1KILLER10_COLOR 0x9F000000

#define L2KILLER_COLOR 0xAE0000C8
#define L2KILLER1_COLOR 0xAE000099
#define L2KILLER2_COLOR 0xAE000088
#define L2KILLER3_COLOR 0xAE000077
#define L2KILLER4_COLOR 0xAE000066
#define L2KILLER5_COLOR 0xAE000055
#define L2KILLER6_COLOR 0xAE000044
#define L2KILLER7_COLOR 0xAE000033
#define L2KILLER8_COLOR 0xAE000022
#define L2KILLER9_COLOR 0xAE000011
#define L2KILLER10_COLOR 0xAE000000

#define L3KILLER_COLOR 0x8D0000C8
#define L3KILLER1_COLOR 0x8D000099
#define L3KILLER2_COLOR 0x8D000088
#define L3KILLER3_COLOR 0x8D000077
#define L3KILLER4_COLOR 0x8D000066
#define L3KILLER5_COLOR 0x8D000055
#define L3KILLER6_COLOR 0x8D000044
#define L3KILLER7_COLOR 0x8D000033
#define L3KILLER8_COLOR 0x8D000022
#define L3KILLER9_COLOR 0x8D000011
#define L3KILLER10_COLOR 0x8D000000

#define L4KILLER_COLOR 0xCC0000C8
#define L4KILLER1_COLOR 0xCC000099
#define L4KILLER2_COLOR 0xCC000088
#define L4KILLER3_COLOR 0xCC000077
#define L4KILLER4_COLOR 0xCC000066
#define L4KILLER5_COLOR 0xCC000055
#define L4KILLER6_COLOR 0xCC000044
#define L4KILLER7_COLOR 0xCC000033
#define L4KILLER8_COLOR 0xCC000022
#define L4KILLER9_COLOR 0xCC000011
#define L4KILLER10_COLOR 0xCC000000

#define L5KILLER_COLOR 0xE50000C8
#define L5KILLER1_COLOR 0xE5000099
#define L5KILLER2_COLOR 0xE5000088
#define L5KILLER3_COLOR 0xE5000077
#define L5KILLER4_COLOR 0xE5000066
#define L5KILLER5_COLOR 0xE5000055
#define L5KILLER6_COLOR 0xE5000044
#define L5KILLER7_COLOR 0xE5000033
#define L5KILLER8_COLOR 0xE5000022
#define L5KILLER9_COLOR 0xE5000011
#define L5KILLER10_COLOR 0xE5000000

#define L6KILLER_COLOR 0xFF0000C8
#define L6KILLER1_COLOR 0xFF000099
#define L6KILLER2_COLOR 0xFF000088
#define L6KILLER3_COLOR 0xFF000077
#define L6KILLER4_COLOR 0xFF000066
#define L6KILLER5_COLOR 0xFF000055
#define L6KILLER6_COLOR 0xFF000044
#define L6KILLER7_COLOR 0xFF000033
#define L6KILLER8_COLOR 0xFF000022
#define L6KILLER9_COLOR 0xFF000011
#define L6KILLER10_COLOR 0xFF000000

#define INBETWEEN_COLOR 0x969696C8
#define INBETWEEN1_COLOR 0x96969699
#define INBETWEEN2_COLOR 0x96969688
#define INBETWEEN3_COLOR 0x96969677
#define INBETWEEN4_COLOR 0x96969666
#define INBETWEEN5_COLOR 0x96969655
#define INBETWEEN6_COLOR 0x96969644
#define INBETWEEN7_COLOR 0x96969633
#define INBETWEEN8_COLOR 0x96969622
#define INBETWEEN9_COLOR 0x96969611
#define INBETWEEN10_COLOR 0x96969600

#define INNOCENT_COLOR 0x33FF66C8
#define INNOCENT1_COLOR 0x33FF6699
#define INNOCENT2_COLOR 0x33FF6688
#define INNOCENT3_COLOR 0x33FF6677
#define INNOCENT4_COLOR 0x33FF6666
#define INNOCENT5_COLOR 0x33FF6655
#define INNOCENT6_COLOR 0x33FF6644
#define INNOCENT7_COLOR 0x33FF6633
#define INNOCENT8_COLOR 0x33FF6622
#define INNOCENT9_COLOR 0x33FF6611
#define INNOCENT10_COLOR 0x33FF6600

forward CopScanner();
forward CrimProxDetector(Float:radi, playerid,col1,col2,col3,col4,col5,col6,col7,col8,col9,col10);

new pDKCount[MAX_PLAYERS];
new pCommited[MAX_PLAYERS];
new Covert = 1;
new Float:radardist = 500.0;

public OnFilterScriptInit()
{
	print("DM Radar");
	print("modified from penls");
	SetTimer("CopScanner", 1000, 1);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	SetPVarInt(playerid, "Concerned", 0);
	pDKCount[playerid]=0;
	pCommited[playerid]=0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	pDKCount[playerid]=0;
	pCommited[playerid]=0;
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SetPlayerColor(playerid,0x9A9999C8);
	pDKCount[playerid] = pDKCount[playerid] - 2;
    if(killerid!=INVALID_PLAYER_ID)
	{
	    if(GetPVarInt(playerid, "Concerned")&&!GetPVarInt(killerid, "Concerned"))
        {
            pDKCount[killerid] = pDKCount[killerid] + 5;
        }
        if(!GetPVarInt(killerid, "Concerned"))
        {
            pDKCount[killerid] = pDKCount[killerid] + (GetPlayerScore(playerid));
            pCommited[killerid] = 1;
        }
        if(GetPVarInt(killerid, "Concerned"))
        {
            if(!Covert)
            {
                SendClientMessage(playerid, L6KILLER10_COLOR, "   You have been killed for DMing.");
                SendClientMessage(playerid, L6KILLER10_COLOR, "   If you have issues, /report. But really, Stop DMing...");
            }
            new DMername[24];
			new string[70];
			GetPlayerName(playerid, DMername, 24);
			format(string, sizeof(string), "You have killed %s and he had %i points.", DMername, pDKCount[playerid]);
            SendClientMessage(playerid, L6KILLER10_COLOR, string);
			pDKCount[playerid] = pDKCount[playerid] - 8;
        }
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/covertops", true))
    {
        if(GetPVarInt(playerid, "Concerned")&&!Covert)
        {
            SendClientMessage(playerid, 0xFFFFFFFF, "CovertOps Enabled");
            Covert = 1;
            return 1;
        }
        if(!GetPVarInt(playerid, "Concerned")&&Covert)
        {
            SendClientMessage(playerid, 0xFFFFFFFF, "CovertOps Disabled");
			SendClientMessageToAll(0xFFFFFFFF, "DM/Non-RP Countermeasures, deplyed...");
            Covert = 0;
            return 1;
        }
    }
    return 0;
}

public CopScanner()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i) || IsPlayerNPC(i)) continue;
		{
			if(pDKCount[i] >= 40) // High Kills
			{
				CrimProxDetector(radardist, i,L6KILLER1_COLOR,L6KILLER2_COLOR,L6KILLER3_COLOR,L6KILLER4_COLOR,L6KILLER5_COLOR,L6KILLER6_COLOR,L6KILLER7_COLOR,L6KILLER8_COLOR,L6KILLER9_COLOR,L6KILLER10_COLOR);
			}
			else if(pDKCount[i] < 40 && pDKCount[i] >= 32)
			{
                CrimProxDetector(radardist, i,L5KILLER1_COLOR,L5KILLER2_COLOR,L5KILLER3_COLOR,L5KILLER4_COLOR,L5KILLER5_COLOR,L5KILLER6_COLOR,L5KILLER7_COLOR,L5KILLER8_COLOR,L5KILLER9_COLOR,L5KILLER10_COLOR);
			}
			else if(pDKCount[i] < 32 && pDKCount[i] >= 24)
			{
                CrimProxDetector(radardist, i,L4KILLER1_COLOR,L4KILLER2_COLOR,L4KILLER3_COLOR,L4KILLER4_COLOR,L4KILLER5_COLOR,L4KILLER6_COLOR,L4KILLER7_COLOR,L4KILLER8_COLOR,L4KILLER9_COLOR,L4KILLER10_COLOR);
			}
			else if(pDKCount[i] < 24 && pDKCount[i] >= 16)
			{
                CrimProxDetector(radardist, i,L3KILLER1_COLOR,L3KILLER2_COLOR,L3KILLER3_COLOR,L3KILLER4_COLOR,L3KILLER5_COLOR,L3KILLER6_COLOR,L3KILLER7_COLOR,L3KILLER8_COLOR,L3KILLER9_COLOR,L3KILLER10_COLOR);
			}
			else if(pDKCount[i] < 16 && pDKCount[i] >= 8)
			{
                CrimProxDetector(radardist, i,L2KILLER1_COLOR,L2KILLER2_COLOR,L2KILLER3_COLOR,L2KILLER4_COLOR,L2KILLER5_COLOR,L2KILLER6_COLOR,L2KILLER7_COLOR,L2KILLER8_COLOR,L2KILLER9_COLOR,L2KILLER10_COLOR);
			}
			else if(pDKCount[i] < 8 && pDKCount[i] >= 0)
			{
                CrimProxDetector(radardist, i,L1KILLER1_COLOR,L1KILLER2_COLOR,L1KILLER3_COLOR,L1KILLER4_COLOR,L1KILLER5_COLOR,L1KILLER6_COLOR,L1KILLER7_COLOR,L1KILLER8_COLOR,L1KILLER9_COLOR,L1KILLER10_COLOR);
			}
			else if(pDKCount[i] < 2 && !pCommited[i]) // Low Kills
			{
				CrimProxDetector(radardist, i,INNOCENT1_COLOR,INNOCENT2_COLOR,INNOCENT3_COLOR,INNOCENT4_COLOR,INNOCENT5_COLOR,INNOCENT6_COLOR,INNOCENT7_COLOR,INNOCENT8_COLOR,INNOCENT9_COLOR,INNOCENT10_COLOR);
			}
			else
			{
				CrimProxDetector(radardist, i,INBETWEEN1_COLOR,INBETWEEN2_COLOR,INBETWEEN3_COLOR,INBETWEEN4_COLOR,INBETWEEN5_COLOR,INBETWEEN6_COLOR,INBETWEEN7_COLOR,INBETWEEN8_COLOR,INBETWEEN9_COLOR,INBETWEEN10_COLOR);
			}
		}
	}
}

public CrimProxDetector(Float:radi, playerid,col1,col2,col3,col4,col5,col6,col7,col8,col9,col10)
{
	new Float:posx, Float:posy, Float:posz;
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy;
	new count;
	GetPlayerPos(playerid, oldposx, oldposy, oldposz);
	for(count = 10; count >= 0; count=count-1)
	{
		for(new i = 0; i <= MAX_PLAYERS; i++)
		{
			if(!IsPlayerConnected(i) || IsPlayerNPC(i) || !GetPVarInt(i, "Concerned")) continue;
			{
				GetPlayerPos(i, posx, posy, posz);
				tempposx = (oldposx -posx);
				tempposy = (oldposy -posy);
				if (((tempposx < radi/count) && (tempposx > -radi/count)) && ((tempposy < radi/count) && (tempposy > -radi/count)))
				{
					//printf("DEBUG: player %d has at range %d",i,count);
					if (count == 10) {SetPlayerMarkerForPlayer(i,playerid,col1);return 1;}
					else if (count == 9) {SetPlayerMarkerForPlayer(i,playerid,col1);return 1;}
					else if (count == 8) {SetPlayerMarkerForPlayer(i,playerid,col2);return 1;}
					else if (count == 7) {SetPlayerMarkerForPlayer(i,playerid,col3);return 1;}
					else if (count == 6) {SetPlayerMarkerForPlayer(i,playerid,col4);return 1;}
					else if (count == 5) {SetPlayerMarkerForPlayer(i,playerid,col5);return 1;}
					else if (count == 4) {SetPlayerMarkerForPlayer(i,playerid,col6);return 1;}
					else if (count == 3) {SetPlayerMarkerForPlayer(i,playerid,col7);return 1;}
					else if (count == 2) {SetPlayerMarkerForPlayer(i,playerid,col8);return 1;}
					else if (count == 1) {SetPlayerMarkerForPlayer(i,playerid,col9);return 1;}
					else {SetPlayerMarkerForPlayer(i,playerid,col10);return 1;}
				}
			}
		}
	}
	return 1;
}
