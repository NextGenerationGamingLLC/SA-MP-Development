SetPlayerSpawn(playerid)
{
    if(IsPlayerConnected(playerid))
	{
		if(GetPVarType(playerid, "WatchingTV")) return 1;
		if(PlayerInfo[playerid][pBackpack] > 0 && PlayerInfo[playerid][pBEquipped])
		{
			switch(PlayerInfo[playerid][pBackpack])
			{
				case 1:
				{
					if(PlayerHoldingObject[playerid][9] != 0 && IsPlayerAttachedObjectSlotUsed(playerid, 9)) 
						RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
					SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
					//PlayerInfo[playerid][pBEquipped] = 1;
				}
				case 2: // Med
				{
					if(PlayerHoldingObject[playerid][9] != 0 && IsPlayerAttachedObjectSlotUsed(playerid, 9)) 
						RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
					SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
					//PlayerInfo[playerid][pBEquipped] = 1;
				}
				case 3: // Large
				{
					if(PlayerHoldingObject[playerid][9] != 0 && IsPlayerAttachedObjectSlotUsed(playerid, 9)) 
						RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
					SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
					//PlayerInfo[playerid][pBEquipped] = 1;
				}
			}
		}
	    SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		if(HungerPlayerInfo[playerid][hgInEvent] == 1)
		{
			if(hgActive > 0)
			{
				if(hgPlayerCount == 3)
				{
					new szmessage[128];
					format(szmessage, sizeof(szmessage), "** %s has came in third place in the Hunger Games Event.", GetPlayerNameEx(playerid));
					SendClientMessageToAll(COLOR_LIGHTBLUE, szmessage);
						
					SetHealth(playerid, HungerPlayerInfo[playerid][hgLastHealth]);
					SetArmour(playerid, HungerPlayerInfo[playerid][hgLastArmour]);
					SetPlayerVirtualWorld(playerid, HungerPlayerInfo[playerid][hgLastVW]);
					SetPlayerInterior(playerid, HungerPlayerInfo[playerid][hgLastInt]);
					SetPlayerPos(playerid, HungerPlayerInfo[playerid][hgLastPosition][0], HungerPlayerInfo[playerid][hgLastPosition][1], HungerPlayerInfo[playerid][hgLastPosition][2]);
							
					ResetPlayerWeapons(playerid);
						
					HungerPlayerInfo[playerid][hgInEvent] = 0;
					hgPlayerCount--;
					HideHungerGamesTextdraw(playerid);
					PlayerInfo[playerid][pRewardDrawChance] += 10;
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "** You have been given 10 Draw Chances for the Fall Into Fun Event.");
					
					for(new w = 0; w < 12; w++)
					{
						PlayerInfo[playerid][pGuns][w] = HungerPlayerInfo[playerid][hgLastWeapon][w];
						if(PlayerInfo[playerid][pGuns][w] > 0 && PlayerInfo[playerid][pAGuns][w] == 0)
						{
							GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][w]);
						}
					}
				}
				else if(hgPlayerCount == 2)
				{
					new szmessage[128];
					format(szmessage, sizeof(szmessage), "** %s has came in second place in the Hunger Games Event.", GetPlayerNameEx(playerid));
					SendClientMessageToAll(COLOR_LIGHTBLUE, szmessage);
						
					SetHealth(playerid, HungerPlayerInfo[playerid][hgLastHealth]);
					SetArmour(playerid, HungerPlayerInfo[playerid][hgLastArmour]);
					SetPlayerVirtualWorld(playerid, HungerPlayerInfo[playerid][hgLastVW]);
					SetPlayerInterior(playerid, HungerPlayerInfo[playerid][hgLastInt]);
					SetPlayerPos(playerid, HungerPlayerInfo[playerid][hgLastPosition][0], HungerPlayerInfo[playerid][hgLastPosition][1], HungerPlayerInfo[playerid][hgLastPosition][2]);
							
					ResetPlayerWeapons(playerid);
						
					HungerPlayerInfo[playerid][hgInEvent] = 0;
					hgPlayerCount--;
					HideHungerGamesTextdraw(playerid);
					PlayerInfo[playerid][pRewardDrawChance] += 25;
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "** You have been given 25 Draw Chances for the Fall Into Fun Event.");
						
					for(new w = 0; w < 12; w++)
					{
						PlayerInfo[playerid][pGuns][w] = HungerPlayerInfo[playerid][hgLastWeapon][w];
						if(PlayerInfo[playerid][pGuns][w] > 0 && PlayerInfo[playerid][pAGuns][w] == 0)
						{
							GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][w]);
						}
					}	
						
					foreach(new i: Player) 
					{
						if(HungerPlayerInfo[i][hgInEvent] == 1)
						{
							format(szmessage, sizeof(szmessage), "** %s has came in first place in the Hunger Games Event.", GetPlayerNameEx(i));
							SendClientMessageToAll(COLOR_LIGHTBLUE, szmessage);
								
							SetHealth(i, HungerPlayerInfo[i][hgLastHealth]);
							SetArmour(i, HungerPlayerInfo[i][hgLastArmour]);
							SetPlayerVirtualWorld(i, HungerPlayerInfo[i][hgLastVW]);
							SetPlayerInterior(i, HungerPlayerInfo[i][hgLastInt]);
							SetPlayerPos(i, HungerPlayerInfo[i][hgLastPosition][0], HungerPlayerInfo[i][hgLastPosition][1], HungerPlayerInfo[i][hgLastPosition][2]);
									
							ResetPlayerWeapons(i);
								
							HungerPlayerInfo[i][hgInEvent] = 0;
							hgPlayerCount--;
							HideHungerGamesTextdraw(i);
							PlayerInfo[i][pRewardDrawChance] += 50;
							SendClientMessageEx(i, COLOR_LIGHTBLUE, "** You have been given 50 Draw Chances for the Fall Into Fun Event.");
							hgActive = 0;
							
							for(new w = 0; w < 12; w++)
							{
								PlayerInfo[i][pGuns][w] = HungerPlayerInfo[i][hgLastWeapon][w];
								if(PlayerInfo[i][pGuns][w] > 0 && PlayerInfo[i][pAGuns][w] == 0)
								{
									GivePlayerValidWeapon(i, PlayerInfo[i][pGuns][w]);
								}
							}
						}
					}
					
					for(new i = 0; i < 600; i++)
					{
						if(IsValidDynamic3DTextLabel(HungerBackpackInfo[i][hgBackpack3DText]))
						{
							DestroyDynamic3DTextLabel(HungerBackpackInfo[i][hgBackpack3DText]);
						}
						if(IsValidDynamicPickup(HungerBackpackInfo[i][hgBackpackPickupId]))
						{
							DestroyDynamicPickup(HungerBackpackInfo[i][hgBackpackPickupId]);
						}
						
						HungerBackpackInfo[i][hgActiveEx] = 0;
					}
					
				}
				else if(hgPlayerCount > 3 || hgPlayerCount == 1)
				{
					SetHealth(playerid, HungerPlayerInfo[playerid][hgLastHealth]);
					SetArmour(playerid, HungerPlayerInfo[playerid][hgLastArmour]);
					SetPlayerVirtualWorld(playerid, HungerPlayerInfo[playerid][hgLastVW]);
					SetPlayerInterior(playerid, HungerPlayerInfo[playerid][hgLastInt]);
					SetPlayerPos(playerid, HungerPlayerInfo[playerid][hgLastPosition][0], HungerPlayerInfo[playerid][hgLastPosition][1], HungerPlayerInfo[playerid][hgLastPosition][2]);
							
					ResetPlayerWeapons(playerid);
						
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have died and has been removed from the Hunger Games Event, better luck next time.");
						
					HungerPlayerInfo[playerid][hgInEvent] = 0;
					hgPlayerCount--;
						
					HideHungerGamesTextdraw(playerid);
					
					for(new w = 0; w < 12; w++)
					{
						PlayerInfo[playerid][pGuns][w] = HungerPlayerInfo[playerid][hgLastWeapon][w];
						if(PlayerInfo[playerid][pGuns][w] > 0 && PlayerInfo[playerid][pAGuns][w] == 0)
						{
							GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][w]);
						}
					}
				}
				
				
				new string[128];
				format(string, sizeof(string), "Players in event: %d", hgPlayerCount);
				foreach(new i: Player) 
				{
					PlayerTextDrawSetString(i, HungerPlayerInfo[i][hgPlayerText], string);
				}
			}
			return true;
		}
		if(GetPVarType(playerid, "IsInArena"))
		{
			SpawnPaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
			return 1;
		}
		if(GetPVarType(playerid, "SpecOff"))
		{
			SetPlayerInterior(playerid, GetPVarInt(playerid, "SpecInt"));
			PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "SpecInt");
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "SpecVW"));
			PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "SpecVW");
			SetPlayerPos(playerid, GetPVarFloat(playerid, "SpecPosX"), GetPVarFloat(playerid, "SpecPosY"), GetPVarFloat(playerid, "SpecPosZ"));
			if(GetPVarInt(playerid, "SpecInt") > 0) {
				Player_StreamPrep(playerid, GetPVarFloat(playerid, "SpecPosX"), GetPVarFloat(playerid, "SpecPosY"), GetPVarFloat(playerid, "SpecPosZ"), FREEZE_TIME);
			}	
			DeletePVar(playerid, "SpecOff");
			DeletePVar(playerid, "SpecInt");
			DeletePVar(playerid, "SpecVW");
			DeletePVar(playerid, "SpecPosX");
			DeletePVar(playerid, "SpecPosY");
			DeletePVar(playerid, "SpecPosZ");
			if(GetPVarType(playerid, "pGodMode"))
	    	{
	        	SetHealth(playerid, 0x7FB00000);
		    	SetArmour(playerid, 0x7FB00000);
			}
			return 1;
		}
		new rand;
		if(PlayerInfo[playerid][pBeingSentenced] > 0)
		{
		    PhoneOnline[playerid] = 1;
		    rand = random(sizeof(WarrantJail));
			SetPlayerPos(playerid, WarrantJail[rand][0], WarrantJail[rand][1], WarrantJail[rand][2]);
			if(rand != 0) courtjail[playerid] = 2;
			else courtjail[playerid] = 1;
			Player_StreamPrep(playerid, WarrantJail[rand][0], WarrantJail[rand][1], WarrantJail[rand][2], FREEZE_TIME);
			PlayerInfo[playerid][pInt] = 0;
			KillEMSQueue(playerid);
			SetPlayerColor(playerid, SHITTY_JUDICIALSHITHOTCH);
			return 1;
		}

		if(PlayerInfo[playerid][pJailTime] > 0)
		{
			if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1)
			{
				if(!GetPVarType(playerid, "Injured")) {

					for(new i = 0; i < 3; i++) {
						
						format(szMiscArray, sizeof(szMiscArray), "MOTD: %s", prisonerMOTD[i]);
						SendClientMessageEx(playerid, COLOR_ORANGE, szMiscArray);
					}

					PhoneOnline[playerid] = 1;
					SetPlayerInterior(playerid, 1);
					PlayerInfo[playerid][pInt] = 1;
					SetPlayerVirtualWorld(playerid, 0);
					PlayerInfo[playerid][pVW] = 0;
					SetPlayerColor(playerid, TEAM_ORANGE_COLOR);
					SetHealth(playerid, 100);
					KillEMSQueue(playerid);
					DeletePVar(playerid, "ArrestPoint");
					ResetPlayerWeaponsEx(playerid);
					rand = random(sizeof(DocPrison));
					if(PlayerInfo[playerid][pIsolated] > 0)
					{
						SetPlayerPos(playerid, DocIsolation[PlayerInfo[playerid][pIsolated] - 1][0], DocIsolation[PlayerInfo[playerid][pIsolated] - 1][1], DocIsolation[PlayerInfo[playerid][pIsolated] - 1][2]);
						Player_StreamPrep(playerid, DocIsolation[PlayerInfo[playerid][pIsolated] - 1][0], DocIsolation[PlayerInfo[playerid][pIsolated] - 1][1], DocIsolation[PlayerInfo[playerid][pIsolated] - 1][2], FREEZE_TIME);
					}
					else
					{
						SpawnPlayerInPrisonCell(playerid, PlayerInfo[playerid][pPrisonCell]);
						/*SetPlayerPos(playerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
						Player_StreamPrep(playerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);*/
					}
					return 1;
				}
			}
		    else if(strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1)
		    {
		        SetHealth(playerid, 0x7FB00000);
		       	PhoneOnline[playerid] = 1;
				SetPlayerInterior(playerid, 1);
				PlayerInfo[playerid][pInt] = 1;
				rand = random(sizeof(OOCPrisonSpawns));
				SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
				SetPlayerSkin(playerid, 50);
				SetPlayerColor(playerid, TEAM_APRISON_COLOR);
				new string[128];
				format(string, sizeof(string), "You are in prison, reason: %s", PlayerInfo[playerid][pPrisonReason]);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
				ResetPlayerWeaponsEx(playerid);
				KillEMSQueue(playerid);
				Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
				return 1;
		    }
		}
		if(GetPVarInt(playerid, "Injured") == 1)
		{
		    switch(aLastShotWeapon[playerid])
			{
				case WEAPON_BRASSKNUCKLE, WEAPON_GOLFCLUB, WEAPON_BAT, WEAPON_SHOVEL, WEAPON_POOLSTICK, WEAPON_DILDO, WEAPON_DILDO2, WEAPON_VIBRATOR,
					WEAPON_VIBRATOR2, WEAPON_FLOWER, WEAPON_CANE:
				{
					format(szMiscArray, sizeof(szMiscArray), "Player brutally beaten with a %s.", Weapon_ReturnName(aLastShotWeapon[playerid]));
				}
				case WEAPON_KATANA, WEAPON_KNIFE:
				{
					format(szMiscArray, sizeof(szMiscArray), "Player was brutally slashed with a %s.", Weapon_ReturnName(aLastShotWeapon[playerid]));
				}
				case WEAPON_GRENADE, WEAPON_ROCKETLAUNCHER, WEAPON_HEATSEEKER, 51:
				{
					format(szMiscArray, sizeof(szMiscArray), "Player suffered critical damage from an explosive blast.");
				}
				case WEAPON_FIREEXTINGUISHER, WEAPON_SPRAYCAN:
				{
					format(szMiscArray, sizeof(szMiscArray), "Player would appear suffocated and poisoned.");
				}
				case WEAPON_MOLTOV, WEAPON_FLAMETHROWER:
				{
					format(szMiscArray, sizeof(szMiscArray), "Player suffered from critical severe burn injuries.");
				}
				case WEAPON_COLT45, WEAPON_SILENCED, WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_SAWEDOFF, WEAPON_SHOTGSPA, WEAPON_UZI, WEAPON_MP5, WEAPON_AK47,
					WEAPON_M4, WEAPON_TEC9, WEAPON_RIFLE, WEAPON_SNIPER, WEAPON_MINIGUN:
				{
					format(szMiscArray, sizeof(szMiscArray), "Player was critically shot in the %s by a %s.", ReturnBoneName(aLastShotBone[playerid]), Weapon_ReturnName(aLastShotWeapon[playerid]));
				}
				case WEAPON_VEHICLE, WEAPON_COLLISION:
				{
					format(szMiscArray, sizeof(szMiscArray), "Player would appear to have multiple broken bones.");
				}
				case WEAPON_DROWN:
				{
					format(szMiscArray, sizeof(szMiscArray), "Player lost consciousness through drowning.");
				}
				case 0: format(szMiscArray, sizeof(szMiscArray), "Player would appear to be brutally beaten by someone's fists.");
				default: format(szMiscArray, sizeof(szMiscArray), "Player passed away from unknown causes.");
			}
			strcat(szMiscArray, "\n{FF0000}(Player is critically injured).", sizeof(szMiscArray));
			new Float: mX, Float: mY, Float: mZ;
			GetPlayerPos(playerid, mX, mY, mZ);
			SetPVarInt(playerid, "InjuredTL", _:CreateDynamic3DTextLabel(szMiscArray, COLOR_LIGHTBLUE, mX, mY, mZ+0.1, 5, .attachedplayer = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid), .streamdistance = 5));
		    SendEMSQueue(playerid,1);
		    if(GetPlayerInterior(playerid) == 0) defer DeathScreen(playerid);
		    return 1;
		}
		if(GetPVarInt(playerid, "EventToken") == 1)
		{
			for(new i; i < sizeof(EventKernel[EventStaff]); i++)
			{
				if(EventKernel[EventStaff][i] == playerid)
				{
					/*SetPlayerWeapons(playerid);
					SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
					//PlayerInfo[playerid][pInterior] = PlayerInfo[playerid][pInt];
					SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
					SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
					SetPlayerInterior(playerid,EventLastInt[playerid]);
					SetHealth(playerid, EventFloats[playerid][4]);
					if(EventFloats[playerid][5] > 0) {
						SetArmour(playerid, EventFloats[playerid][5]);
					}
					for(new d = 0; d < 6; d++)
					{
						EventFloats[playerid][d] = 0.0;
					}
					EventLastInt[playerid] = 0;
					EventLastVW[playerid] = 0;
					EventKernel[EventStaff][i] = INVALID_PLAYER_ID;*/
					new Float:health, Float:armor;
					ResetPlayerWeapons( playerid );
					DeletePVar(playerid, "EventToken");
					SetPlayerWeapons(playerid);
					SetPlayerToTeamColor(playerid);
					SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
					SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
					SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
					SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
					SetPlayerInterior(playerid,EventLastInt[playerid]);
					Player_StreamPrep(playerid, EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3], FREEZE_TIME);
					if(EventKernel[EventType] == 4)
					{
						if(GetPVarType(playerid, "pEventZombie")) DeletePVar(playerid, "pEventZombie");
						SetPlayerToTeamColor(playerid);
					}
					for(new d = 0; d < 6; d++)
					{
						EventFloats[playerid][d] = 0.0;
					}
					EventLastVW[playerid] = 0;
					EventLastInt[playerid] = 0;
					RemovePlayerWeapon(playerid, 38);
					health = GetPVarFloat(playerid, "pPreGodHealth");
					SetHealth(playerid,health);
					armor = GetPVarFloat(playerid, "pPreGodArmor");
					SetArmour(playerid, armor);
					DeletePVar(playerid, "pPreGodHealth");
					DeletePVar(playerid, "pPreGodArmor");
					DeletePVar(playerid, "eventStaff");
					return 1;
				}
			}
            if(EventKernel[EventType] == 4)
			{
			   	SetPlayerPos(playerid, EventKernel[ EventPositionX ], EventKernel[ EventPositionY ], EventKernel[ EventPositionZ ] );
				SetPlayerInterior(playerid, EventKernel[ EventInterior ] );
				SetPlayerVirtualWorld(playerid, EventKernel[ EventWorld ] );
				SendClientMessageEx(playerid, COLOR_WHITE, "You are a zombie! Use /bite to infect others");
				SetHealth(playerid, 30);
				RemoveArmor(playerid);
				SetPlayerSkin(playerid, 134);
				SetPlayerColor(playerid, 0x0BC43600);
				SetPVarInt(playerid, "pEventZombie", 1);
				return 1;
			}
			else
			{
			    DeletePVar(playerid, "EventToken");
			    SetPlayerWeapons(playerid);
			    SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
				//PlayerInfo[playerid][pInterior] = PlayerInfo[playerid][pInt];
				SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
				SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
				SetPlayerInterior(playerid,EventLastInt[playerid]);
				Player_StreamPrep(playerid, EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3], FREEZE_TIME);
				SetHealth(playerid, EventFloats[playerid][4]);
				if(EventFloats[playerid][5] > 0) {
					SetArmour(playerid, EventFloats[playerid][5]);
				}
				for(new i = 0; i < 6; i++)
				{
				    EventFloats[playerid][i] = 0.0;
				}
				EventLastVW[playerid] = 0;
				EventLastInt[playerid] = 0;
				return 1;
			}
		}
		if(GetPVarInt(playerid, "MedicBill") == 1 && PlayerInfo[playerid][pJailTime] == 0)
		{
			
		    #if defined zombiemode
	    	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
			{
				SpawnZombie(playerid);
  				return 1;
			}
			#endif
			if(PlayerInfo[playerid][pWantedLevel] > 0 && (PlayerInfo[playerid][pInsurance] == HOSPITAL_LSVIP || PlayerInfo[playerid][pInsurance] == HOSPITAL_LVVIP || PlayerInfo[playerid][pInsurance] == HOSPITAL_SFVIP || PlayerInfo[playerid][pInsurance] == HOSPITAL_HOMECARE || PlayerInfo[playerid][pInsurance] == HOSPITAL_FAMED || PlayerInfo[playerid][pInsurance] == HOSPITAL_TRFAMED))
			{
				new wantedplace;
				
				switch(random(3))
				{
					case 0: {wantedplace = HOSPITAL_COUNTYGEN;}
					case 1: {wantedplace = HOSPITAL_SANFIERRO;}
					case 2: {wantedplace = HOSPITAL_ALLSAINTS;}
				}
				DeliverPlayerToHospital(playerid, wantedplace);
				
				return 1;
			}
			else
			{
				return DeliverPlayerToHospital(playerid, PlayerInfo[playerid][pInsurance]);
			}
			
		}
		if(!PlayerInfo[playerid][pHospital])
		{
			SetPlayerPos(playerid,PlayerInfo[playerid][pPos_x],PlayerInfo[playerid][pPos_y],PlayerInfo[playerid][pPos_z]);
			SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
			SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPos_r]);
			SetPlayerInterior(playerid,PlayerInfo[playerid][pInt]);
			if(PlayerInfo[playerid][pHealth] < 1) PlayerInfo[playerid][pHealth] = 100;
			SetHealth(playerid, PlayerInfo[playerid][pHealth]);
			if(PlayerInfo[playerid][pArmor] > 0) SetArmour(playerid, PlayerInfo[playerid][pArmor]); else SetArmour(playerid, 0.0);
			SetCameraBehindPlayer(playerid);
			if(PlayerInfo[playerid][pInt] > 0) Player_StreamPrep(playerid, PlayerInfo[playerid][pPos_x],PlayerInfo[playerid][pPos_y],PlayerInfo[playerid][pPos_z], FREEZE_TIME);
			//if(PlayerInfo[playerid][pInt] == 0 && PlayerInfo[playerid][pVW] == 0) LoginCamToPlayer(playerid);
			return 1;

		}
		new Float: x, Float: y, Float: z;
		GetPlayerPos(playerid, x, y, z);
		if(x == 0.0 && y == 0.0)
		{
  			SetPlayerInterior(playerid,0);
			SetPlayerPos(playerid, 1715.1201,-1903.1711,13.5665);
			SetPlayerFacingAngle(playerid, 359.4621);
			SetCameraBehindPlayer(playerid);
		}
		SetPlayerToTeamColor(playerid);
		return 1;
	}
	return 1;
}

forward ForceSpawn(playerid);
public ForceSpawn(playerid)
{
	SpawnPlayer(playerid);
	return 1;
}