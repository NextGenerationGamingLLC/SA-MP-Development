#include a_samp
#include foreach

new Points[MAX_PLAYERS];
new PlayerTick[MAX_PLAYERS];
new PlayerTickOld[MAX_PLAYERS];
new Text3D:PausedPlayerText[MAX_PLAYERS];
new Labeled[MAX_PLAYERS];
new Tabbed[MAX_PLAYERS];
new Spawned[MAX_PLAYERS];

forward watcher();

public OnFilterScriptInit()
{
	SetTimer("watcher", 1000, 1);
}

public OnFilterScriptExit()
{
}

public OnPlayerConnect(playerid)
{
	Spawned[playerid] = 0;
	PlayerTick[playerid]=2;
	PlayerTickOld[playerid]=1;
	Points[playerid]=0;
	Labeled[playerid]=0;
	Tabbed[playerid]=0;
}

public OnPlayerDisconnect(playerid, reason)
{
	Spawned[playerid] = 0;
	Points[playerid]=0;
	if(Labeled[playerid]==1)
	{
		Delete3DTextLabel(PausedPlayerText[playerid]);
		Labeled[playerid]=0;
	}
}

public OnPlayerSpawn(playerid)
{
	Spawned[playerid] = 1;
}

public OnPlayerUpdate(playerid)
{
	PlayerTick[playerid]=GetTickCount();
}

public watcher()
{
	foreach(Player, i)
	{
		if(PlayerTickOld[i]==PlayerTick[i])
		{
			if(Points[i]<40)
			{
			Points[i]++;
			}
			Tabbed[i]=1;
		}
		if(PlayerTickOld[i]!=PlayerTick[i]&&Points[i]>0)
		{
			Points[i]--;
			if(Labeled[i]&&Tabbed[i]&&Spawned[i])
			{
			    GameTextForPlayer(i, "~g~Please ~w~refrain from ~r~Alt~w~-~r~Tabbing.", 3000, 6);
			    Update3DTextLabelText(PausedPlayerText[i],0xFF44FFFF,"Has returned...");
			    Points[i]--;
			}
		}
		if(Points[i]>=10&&Labeled[i]&&Tabbed[i])
		{
			Update3DTextLabelText(PausedPlayerText[i],0xFF1111FF,"Paused\nHas been for a while");
		}
		if(Points[i]>=2&&!Labeled[i])
		{
			PausedPlayerText[i] = Create3DTextLabel("Paused\n.\nCould be\nConnection Issues.", 0xFF4444FF,0.0,0.0,0.0,40.0,0);
			Attach3DTextLabelToPlayer(PausedPlayerText[i],i,0,0,-1);
			Labeled[i]=1;
		}
		if(Points[i]<=0&&Labeled[i])
		{
			Delete3DTextLabel(PausedPlayerText[i]);
			Labeled[i]=0;
		}
		PlayerTickOld[i]=PlayerTick[i];
  	}
}
