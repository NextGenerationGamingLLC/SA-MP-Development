/* Realism Additions...
A) Adds Bleeding
B) Removes the auto health from the Ambulance
C) Makes you anim/freeze in the spot waiting for ambulances and has an opt out by holding Jump
D) Sets checkpoint for any player in an ambulance when the call comes through
*/

#include <a_samp>
//#include <Seifader>
#include <foreach>

forward BleedingTick();
forward SummonMedics(forplayer);
//forward CancelMedics(forplayer);

new Float:BC[MAX_PLAYERS];
new Float:HC1[MAX_PLAYERS];
new Float:HC2[MAX_PLAYERS];
new Float:AC[MAX_PLAYERS];
new Float:AC2[MAX_PLAYERS];

new pBWarning[MAX_PLAYERS]=0;

new bool:pFrozen[MAX_PLAYERS];
new bool:pBleeding[MAX_PLAYERS];
new bool:pSpawned[MAX_PLAYERS];
new bool:pRecovered[MAX_PLAYERS];

//new bool:pOnCall[MAX_PLAYERS];
//new CallOut[MAX_PLAYERS];

new LastCar[MAX_PLAYERS];

//new levelhurt[MAX_PLAYERS];
//new FadeState[MAX_PLAYERS]=0;

public OnFilterScriptInit()
{
	SetTimer("BleedingTick", 2000, 1);
}

public OnFilterScriptExit()
{
	//Seifader_OnExit();
}

public OnPlayerConnect(playerid)
{
	pBleeding[playerid] = false;
	pSpawned[playerid] = false;
	pRecovered[playerid] = false;
	pFrozen[playerid] = false;
	//CallOut[playerid]=-1;
	pBWarning[playerid] = 0;
	//FadeState[playerid]=0;
}

public OnPlayerDisconnect(playerid, reason)
{
	pBleeding[playerid] = false;
	pSpawned[playerid] = false;
	pRecovered[playerid] = false;
	pFrozen[playerid] = false;
	//CallOut[playerid]=-1;
	//CancelMedics(playerid);
	pBWarning[playerid]=0;
	//FadeState[playerid]=0;
}

public OnPlayerSpawn(playerid)
{
	PreloadAnimLib(playerid,"SWEET");
	pBleeding[playerid] = false;
	pSpawned[playerid] = true;
	GetPlayerHealth(playerid, BC[playerid]);
	if(BC[playerid] > 30)
	{
		pRecovered[playerid] = true;
	}
	else
	{
		pRecovered[playerid] = false;
	}
	pBWarning[playerid]=0;
	//RemovePlayerColorFade(playerid);
	//FadeState[playerid]=0;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	//CancelMedics(playerid);
	pBWarning[playerid]=0;
	pBleeding[playerid] = false;
	pSpawned[playerid] = false;
	pRecovered[playerid] = false;
	/*RemovePlayerColorFade(playerid);
	if(FadeState[playerid]==1)
	{
		FadePlayerScreen(playerid, 0x94000022, 5, true);
	}
	if(FadeState[playerid]==2)
	{
		FadePlayerScreen(playerid, 0x94000044, 5, true);
	}
	if(FadeState[playerid]==3)
	{
		FadePlayerScreen(playerid, 0x94000066, 5, true);
	}
	if(FadeState[playerid]==4)
	{
		FadePlayerScreen(playerid, 0x94000088, 5, true);
	}*/
	if(pFrozen[playerid] == true)
	{
		pFrozen[playerid]=false;
		TogglePlayerControllable(playerid, 1);
	}
	//FadeState[playerid]=0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    GetPlayerHealth(playerid, HC1[playerid]);
    GetPlayerArmour(playerid, AC[playerid]);
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if ((newkeys & KEY_JUMP) && !(oldkeys & KEY_JUMP))
	{
		if(pBleeding[playerid]==true&&pFrozen[playerid]==true)
		{
			TogglePlayerControllable(playerid,1);
			SetPlayerHealth(playerid,0);
			pFrozen[playerid] = false;
			//CancelMedics(playerid);
		}
	}
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate==PLAYER_STATE_ONFOOT&&oldstate==PLAYER_STATE_DRIVER&&GetVehicleModel(LastCar[playerid])==416)
	{
		GetPlayerHealth(playerid, HC2[playerid]);
		if(HC2[playerid]!=100)
		{
			if(HC2[playerid]-20==HC1[playerid])
			{
				SetPlayerHealth(playerid, HC1[playerid]);
				SendClientMessage(playerid, 0x007700ff, "Stop exploiting Ambulances...");
			}
		}
	}
	if(newstate==PLAYER_STATE_ONFOOT&&oldstate==PLAYER_STATE_DRIVER&&GetVehicleModel(LastCar[playerid])==427)
	{
	    GetPlayerArmour(playerid,AC2[playerid]);
	    if(AC[playerid]<AC2[playerid])
	    {
	        SetPlayerArmour(playerid,AC[playerid]);
	        SendClientMessage(playerid, 0x007700ff, "Stop exploiting Enforcers...");
	    }
	}
	if(newstate==PLAYER_STATE_DRIVER)
	{
		LastCar[playerid]=GetPlayerVehicleID(playerid);
		if(pBleeding[playerid]==true)
		{
			RemovePlayerFromVehicle(playerid);
			SendClientMessage(playerid, 0xff3232ff, "You feel the need to get out and walk to find help.");
			SendClientMessage(playerid, 0x007700ff, "You can't drive in your state.");
		}
	}
}

/*public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(pOnCall[playerid]==true)
	{
		DisablePlayerRaceCheckpoint(playerid);
		pOnCall[playerid]=false;
		CallOut[playerid]=-1;
	}
}

public SummonMedics(forplayer)
{
	//OnPlayerCommandText(forplayer, "/service medic");
	new Float:forx, Float:fory, Float:forz;
	GetPlayerPos(forplayer, forx, fory, forz);
	foreach(Player, i)
	{
		if(IsPlayerInAnyVehicle(i))
		{
			if(GetVehicleModel(GetPlayerVehicleID(i))==416&&pOnCall[i]==false)
			{
				SetPlayerRaceCheckpoint(i, 2, forx, fory, forz, forx, fory, forz, 20);
				SetPlayerMarkerForPlayer(i, forplayer, 0x940000FF);
				pOnCall[i]=true;
				CallOut[i]=forplayer;
			}
		}
	}
}

public CancelMedics(forplayer)
{
	foreach(Player, i)
	{
		if(pOnCall[i]==true)
		{
			if(CallOut[i]==forplayer)
			{
				DisablePlayerRaceCheckpoint(i);
				SetPlayerMarkerForPlayer(i, forplayer, 0xFFFFFF00);
				pOnCall[i]=false;
				CallOut[i]=-1;
			}
		}
  	}
}*/

public BleedingTick()
{
	foreach(Player, i)
	{
		if(!pSpawned[i]) continue;
		{
			GetPlayerHealth(i, BC[i]);
			if(pBleeding[i] == true && BC[i]>30 && pRecovered[i] == true)//Healed
			{
				pBleeding[i] = false;
				pBWarning[i] = false;
				SendClientMessage(i, 0x007700ff, "You are no longer bleeding.");
				//CancelMedics(i);
				/*if(FadeState[i]==1)
				{
					RemovePlayerColorFade(i);
					FadePlayerScreen(i, 0x94000022, 10, true);
					FadeState[i]=0;
				}
				if(FadeState[i]==2)
				{
					RemovePlayerColorFade(i);
					FadePlayerScreen(i, 0x94000044, 10, true);
					FadeState[i]=0;
				}
				if(FadeState[i]==3)
				{
					RemovePlayerColorFade(i);
					FadePlayerScreen(i, 0x94000066, 10, true);
					FadeState[i]=0;
				}
				if(FadeState[i]==4)
				{
					RemovePlayerColorFade(i);
					FadePlayerScreen(i, 0x94000088, 10, true);
					FadeState[i]=0;
				}*/
				if(pFrozen[i] == true)
				{
					pFrozen[i]=false;
					TogglePlayerControllable(i, 1);
				}
			}
			if(pBleeding[i] == false&&BC[i]<30&&pRecovered[i] == true&&pFrozen[i]==false)//Bleeding start
			{
				pBleeding[i] = true;
				//SetPlayerDrunkLevel(i, 1500);
				SendClientMessage(i, 0xff3232ff, "You suddenly realise that you are soaking in blood. (You're bleeding)");
				//RemovePlayerColorFade(i);
				//FadePlayerScreenToColor(i, 0x94000022, 5);
				//FadeState[i]=1;
			}
			if(pBleeding[i] == true&&pFrozen[i]==false)//Bleeding "reminder" count
			{
				GetPlayerHealth(i, BC[i]);
				SetPlayerHealth(i, BC[i]-1);
				pBWarning[i]++;
			}
			if(pBleeding[i] == true&&BC[i] < 8 &&pFrozen[i] == false)
			{
				//levelhurt[i]=GetPlayerDrunkLevel(i);
				//SetPlayerDrunkLevel(i, levelhurt[i]+500);
				pFrozen[i] = true;
				TogglePlayerControllable(i,0);
				ApplyAnimation(i, "SWEET", "Sweet_injuredloop",1,0,0,0,1,0);
				SendClientMessage(i, 0xff3232ff, "You can't move another step.");
				//if(GetPlayerInterior(i)!=0)
				//{
				SendClientMessage(i, 0xff3232ff, "You need to call 911, or find means of recooperation");
				//}
				/*if(GetPlayerInterior(i)==0)
				{
					SummonMedics(i);
					SendClientMessage(i, 0xff3232ff, "Medics have been called and may be near shortly.");
				}*/
				SendClientMessage(i, 0x007700ff, "You can skip waiting by pressing jump.");
				//RemovePlayerColorFade(i);
				//FadePlayerScreenToColor(i, 0x94000088, 5);
				//FadeState[i]=4;
				
			}
			if(pBWarning[i] > 4 && pBleeding[i] == true) //Actual Reminder
			{
				pBWarning[i]=0;
				//levelhurt[i]=GetPlayerDrunkLevel(i);
				//SetPlayerDrunkLevel(i, levelhurt[i]+500);
				SendClientMessage(i, 0xff3232ff, "You're starting to feel faint, You need help quick.");
			}
			/*if(FadeState[i]==1&&BC[i]<22)
			{
				FadeState[i]=2;
				RemovePlayerColorFade(i);
				FadePlayerScreenToColor(i, 0x94000044, 5);
			}
			if(FadeState[i]==2&&BC[i]<14)
			{
				RemovePlayerColorFade(i);
				FadePlayerScreenToColor(i, 0x94000066, 5);
				FadeState[i]=3;
			}*/
			if(BC[i] > 35 && pRecovered[i] == false)
			{
				pRecovered[i] = true;
			}
		}
	}
}

PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

/*public OnPlayerScreenFade(playerid, color, speed)
{
    return 1;
}

public OnPlayerScreenColorFade(playerid, color, speed)
{
    return 1;
}

public OnPlayerFadeFlashed(playerid, color, speed)
{
    return 1;
}*/
