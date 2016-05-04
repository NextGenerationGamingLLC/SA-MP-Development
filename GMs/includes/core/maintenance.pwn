forward Maintenance();
public Maintenance()
{
	new string[128];
    ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Freezing Accounts...", 1);

    foreach(new i: Player)
	{
		TogglePlayerControllable(i, false);
	}

    ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Locking Paintball Arenas...", 1);

    for(new i = 0; i < MAX_ARENAS; i++)
    {
		foreach(new p: Player)
		{
			if(!GetPVarType(p, "IsInArena")) continue;
			new arenaid = GetPVarInt(p, "IsInArena");
			if(arenaid == i)
			{
				if(PaintBallArena[arenaid][pbBidMoney] > 0)
				{
					GivePlayerCash(p,PaintBallArena[GetPVarInt(p, "IsInArena")][pbBidMoney]);
					format(string,sizeof(string),"You have been refunded a total of $%d because of premature closure.",PaintBallArena[GetPVarInt(p, "IsInArena")][pbBidMoney]);
					SendClientMessageEx(p, COLOR_WHITE, string);
				}
				if(arenaid == GetPVarInt(p, "ArenaNumber"))
				{
					switch(PaintBallArena[arenaid][pbGameType])
					{
						case 1:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 3;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",3);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
						case 2:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 4;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",4);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
						case 3:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 5;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
						case 4:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 5;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
						case 5:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 6;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",6);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
					}
				}
				LeavePaintballArena(p, arenaid);
			}
		}	
		ResetPaintballArena(i);
		PaintBallArena[i][pbLocked] = 2;
    }
    foreach(new i: Player)
	{
		GameTextForPlayer(i, "Scheduled Maintenance..", 5000, 5);
	}	


    ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Accounts...", 1);
	SendRconCommand("password asdatasdhwda");
	SendRconCommand("hostname Next Generation Roleplay [Restarting for Maintenance]");
	foreach(new i: Player)
	{
		if(gPlayerLogged{i}) {
			SetPVarInt(i, "RestartKick", 1);
			//g_mysql_SaveAccount(i);
			OnPlayerStatsUpdate(i);
			break; // We only need to save one person at a time.
		}
	}	
	SetTimer("FinishMaintenance", 60000, false);
	//g_mysql_DumpAccounts();


	return 1;
}

forward FinishMaintenance();
public FinishMaintenance()
{
    foreach(new i: Player) Kick(i);
    ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Houses...", 1);
	SaveHouses();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Dynamic Doors...", 1);
	SaveDynamicDoors();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Garages...", 1);
	SaveGarages();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Map Icons...", 1);
	SaveDynamicMapIcons();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Gates...", 1);
	SaveGates();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Event Points...", 1);
	SaveEventPoints();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Paintball Arenas...", 1);
	SavePaintballArenas();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Server Configuration", 1);
    Misc_Save();
    ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Office Elevator...", 1);
	SaveElevatorStuff();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Mail Boxes...", 1);
	SaveMailboxes();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Speed Cameras...", 1);
	SaveSpeedCameras();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Points...", 1);
	for (new i=0; i<MAX_POINTS; i++)
	{
		SavePoint(i);	
	}
	if(rflstatus > 0) {
		ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving RFL Teams...", 1);
		SaveRelayForLifeTeams();
	}
	g_mysql_SavePrices();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Turfs...", 1);
	TurfWars_SaveAll();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Streamer Plugin Shutting Down...", 1);
	DestroyAllDynamicObjects();
	DestroyAllDynamic3DTextLabels();
	DestroyAllDynamicCPs();
	DestroyAllDynamicMapIcons();
	DestroyAllDynamicRaceCPs();
	DestroyAllDynamicAreas();
	g_mysql_SaveMOTD();
	SetTimer("ShutDown", 5000, false);
	return 1;
}


forward ShutDown();
public ShutDown()
{
	return SendRconCommand("exit");
}