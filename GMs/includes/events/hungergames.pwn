/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Hunger Games

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)
					
	* Copyright (c) 2016, Next Generation Gaming, LLC
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

stock NextAvailableBackpack()
{
	if(hgBackpackCount+1 == 200) return false;
	return hgBackpackCount+1;
}

stock GetHungerBackpackName(id)
{
	new string[24];
	switch(HungerBackpackInfo[id][hgBackpackType])
	{
		case 1: format(string, sizeof(string), "15 Percent Armour");
		case 2: format(string, sizeof(string), "Random Weapon");
		case 3: format(string, sizeof(string), "Full Hunger");
		case 4: format(string, sizeof(string), "Full Health");
		default: format(string, sizeof(string), "NULL");
	}
	return string;
}

CMD:createbackpack(playerid, params[])
{
	new type;
	if(sscanf(params, "d", type)) 
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /createbackpack [type]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available Types: Type 1 (Armour) - Type 2 (Random Weapon) - Type 3 (Full Hunger) - Type 4 (Full Health).");
		return true;
	}
	
	if(type < 1 || type > 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid Type!");
	
	new id = NextAvailableBackpack();
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		if(id)
		{
			new Float: mypos[3];
			GetPlayerPos(playerid, mypos[0], mypos[1], mypos[2]);
			
			HungerBackpackInfo[id][hgBackpackType] = type;
			
			HungerBackpackInfo[id][hgBackpackPos][0] = mypos[0];
			HungerBackpackInfo[id][hgBackpackPos][1] = mypos[1];
			HungerBackpackInfo[id][hgBackpackPos][2] = mypos[2];
			
			AddNewBackpack(id);
			
			new string[128];
			format(string, sizeof(string), "You have successfully created a Hunger Games Backpack {FF0000}(Type: %s){FFFFFF}.", GetHungerBackpackName(id));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_RED, "The server has reached the maximum amount of Hunger Games Backpacks.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return true;
}

CMD:starthunger(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		if(hgActive != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "The Hunger Games event has already been started.");
		
		SendClientMessageToAll(COLOR_LIGHTBLUE, "The Hunger Games event is begining in 2 minutes, type /joinhunger to participate.");
		
		hgActive = 1;
		hgCountdown = 120;
	}
	else 
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return true;
}

CMD:endhunger(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		if(hgActive > 0)
		{
			foreach(new i: Player)
			{
				if(HungerPlayerInfo[i][hgInEvent] == 1)
				{
					SetHealth(i, HungerPlayerInfo[i][hgLastHealth]);
					SetArmour(i, HungerPlayerInfo[i][hgLastArmour]);
					SetPlayerVirtualWorld(i, HungerPlayerInfo[i][hgLastVW]);
					SetPlayerInterior(i, HungerPlayerInfo[i][hgLastInt]);
					SetPlayerPos(i, HungerPlayerInfo[i][hgLastPosition][0], HungerPlayerInfo[i][hgLastPosition][1], HungerPlayerInfo[i][hgLastPosition][2]);
								
					ResetPlayerWeapons(i);
					
					for(new w = 0; w < 12; w++)
					{
						PlayerInfo[i][pGuns][w] = HungerPlayerInfo[i][hgLastWeapon][w];
						if(PlayerInfo[i][pGuns][w] > 0 && PlayerInfo[i][pAGuns][w] == 0)
						{
							GivePlayerValidWeapon(i, PlayerInfo[i][pGuns][w]);
						}
					}
							
					HungerPlayerInfo[i][hgInEvent] = 0;
					hgPlayerCount--;
					HideHungerGamesTextdraw(i);
					
					for(new v = 0; v < 600; v++)
					{
						if(IsValidDynamic3DTextLabel(HungerBackpackInfo[v][hgBackpack3DText]))
						{
							DestroyDynamic3DTextLabel(HungerBackpackInfo[v][hgBackpack3DText]);
						}
						if(IsValidDynamicPickup(HungerBackpackInfo[v][hgBackpackPickupId]))
						{
							DestroyDynamicPickup(HungerBackpackInfo[v][hgBackpackPickupId]);
						}
								
						HungerBackpackInfo[v][hgActiveEx] = 0;
					}
					
					new string[128];
					format(string, sizeof(string), "Players in event: %d", hgPlayerCount);
					PlayerTextDrawSetString(i, HungerPlayerInfo[i][hgPlayerText], string);
					
					hgActive = 0;
					
					SendClientMessageToAll(COLOR_LIGHTBLUE, "** The Hunger Games Event has been ended by an Administrator.");
				}
			}
		}
	}
	return true;
}				
				
CMD:leavehunger(playerid, params[])
{
	if(HungerPlayerInfo[playerid][hgInEvent] != 1) return SendClientMessageEx(playerid, COLOR_GREY, "You're not in the Hunger Games event.");

	if(hgActive == 2)
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
					SetPVarInt(i, "hungerEx", 1);
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
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot leave at this stage of the event.");
	
	new string[128];
	format(string, sizeof(string), "Players in event: %d", hgPlayerCount);
	foreach(new i: Player)
	{
		PlayerTextDrawSetString(i, HungerPlayerInfo[i][hgPlayerText], string);
	}
	return true;
}	

CMD:joinhunger(playerid, params[])
{
	if(hgActive == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "The Hunger Games event has not been announced!");
	if(hgActive == 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "The Hunger Games event has already been started!");
	if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid,COLOR_GREY,"You cannot do this while being in an arena!");
   	if(GetPVarInt( playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while being cuffed.");
    if(GetPVarInt(playerid, "WatchingTV")) return SendClientMessageEx(playerid, COLOR_GREY, "You can not do this while watching TV!");
    if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid,COLOR_GREY,"You can not do this while in jail or prison!");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this right now.");
	if(PlayerInfo[playerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot join this event as an administrator.");
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're already in the Hunger Games event.");
	
	GetPlayerPos(playerid, HungerPlayerInfo[playerid][hgLastPosition][0], HungerPlayerInfo[playerid][hgLastPosition][1], HungerPlayerInfo[playerid][hgLastPosition][2]);
	new rand = random(sizeof(hgRandomSpawn));
	SetPlayerPos(playerid, hgRandomSpawn[rand][0], hgRandomSpawn[rand][1], hgRandomSpawn[rand][2]);
	
	GetHealth(playerid, HungerPlayerInfo[playerid][hgLastHealth]);
	SetHealth(playerid, 9999.9);
	
	GetArmour(playerid, HungerPlayerInfo[playerid][hgLastArmour]);
	SetArmour(playerid, 0);
	
	HungerPlayerInfo[playerid][hgLastVW] = GetPlayerVirtualWorld(playerid);
	SetPlayerVirtualWorld(playerid, 2039);
	
	HungerPlayerInfo[playerid][hgLastInt] = GetPlayerInterior(playerid);
	SetPlayerInterior(playerid, 0);
	
	for(new w = 0; w < 12; w++)
	{
		HungerPlayerInfo[playerid][hgLastWeapon][w] = PlayerInfo[playerid][pGuns][w];
	}
	
	ResetPlayerWeapons(playerid);
	pTazer{playerid} = 0;
	
	for(new x;x<MAX_PLAYERTOYS;x++) 
	{
		RemovePlayerAttachedObject(playerid, x);
	}
	
	for(new i; i < 11; i++) 
	{
		PlayerHoldingObject[playerid][i] = 0;
	}
	
	CreateHungerGamesTextdraw(playerid);
	
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have joined the Hunger Games Event.");
	SendClientMessageEx(playerid, COLOR_GRAD1, "* You may leave this event at anytime through /leavehunger.");
	SendClientMessageEx(playerid, COLOR_RED, "* Note: You have been given god mode & you cannot leave the area until the event has started.");
	
	HungerPlayerInfo[playerid][hgInEvent] = 1;
	hgPlayerCount++;
	
	new string[128];
	format(string, sizeof(string), "Players in event: %d", hgPlayerCount);
	foreach(new i: Player)
	{
		PlayerTextDrawSetString(i, HungerPlayerInfo[i][hgPlayerText], string);
	}
	
	if(PlayerInfo[playerid][pHungerVoucher] > 0)
	{
		ShowPlayerDialogEx(playerid, DIALOG_HUNGERGAMES, DIALOG_STYLE_MSGBOX, "Hunger Games Voucher", "Would you like to use a Hunger Games Voucher?", "Yes", "No");
	}
	return true;
}

CMD:openbackpack(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command as an administrator.");
	if(hgActive == 2)
	{
		new backpack;
		if(HungerPlayerInfo[playerid][hgInEvent] == 1)
		{
			if(GetPlayerVirtualWorld(playerid) != 2039) return SendClientMessageEx(playerid, COLOR_GRAD1, "You aren't near a backpack.");
			for(new i = 0; i < 600; i++)
			{	
				if(IsPlayerInRangeOfPoint(playerid, 1.0, HungerBackpackInfo[i][hgBackpackPos][0], HungerBackpackInfo[i][hgBackpackPos][1], HungerBackpackInfo[i][hgBackpackPos][2]))
				{
					backpack = i;
				}
			}
			
			if(HungerBackpackInfo[backpack][hgActiveEx] == 0) // Quick fix for the backpack not disappearing bug
			{
				return SendClientMessageEx(playerid, COLOR_GRAD1, "This backpack has already been opened and use.");
			}
			
			if(HungerBackpackInfo[backpack][hgBackpackType] == 1)
			{
				new Float: exarmor;
				GetArmour(playerid, exarmor);
				SetArmour(playerid, exarmor+15);
				SendClientMessageEx(playerid, COLOR_GRAD1, "You have picked up the backpack and received 15 percent armor.");
				HungerBackpackInfo[backpack][hgActiveEx] = 0;
				DestroyDynamic3DTextLabel(HungerBackpackInfo[backpack][hgBackpack3DText]);
				DestroyDynamicPickup(HungerBackpackInfo[backpack][hgBackpackPickupId]);
			}
			else if(HungerBackpackInfo[backpack][hgBackpackType] == 2)
			{
				new rand = Random(1, 35);
				if(rand > 0 && rand < 6)
				{
					GivePlayerValidWeapon(playerid, 24);
					SendClientMessageEx(playerid, COLOR_GRAD1, "You have picked up the backpack and received a deagle.");
					HungerBackpackInfo[backpack][hgActiveEx] = 0;
					DestroyDynamic3DTextLabel(HungerBackpackInfo[backpack][hgBackpack3DText]);
					DestroyDynamicPickup(HungerBackpackInfo[backpack][hgBackpackPickupId]);
				}
				else if(rand > 5 && rand < 11)
				{
					GivePlayerValidWeapon(playerid, 25);
					SendClientMessageEx(playerid, COLOR_GRAD1, "You have picked up the backpack and received a shotgun.");
					HungerBackpackInfo[backpack][hgActiveEx] = 0;
					DestroyDynamic3DTextLabel(HungerBackpackInfo[backpack][hgBackpack3DText]);
					DestroyDynamicPickup(HungerBackpackInfo[backpack][hgBackpackPickupId]);
				}
				else if(rand > 10 && rand < 16)
				{
					GivePlayerValidWeapon(playerid, 29);
					SendClientMessageEx(playerid, COLOR_GRAD1, "You have picked up the backpack and received a MP5.");
					HungerBackpackInfo[backpack][hgActiveEx] = 0;
					DestroyDynamic3DTextLabel(HungerBackpackInfo[backpack][hgBackpack3DText]);
					DestroyDynamicPickup(HungerBackpackInfo[backpack][hgBackpackPickupId]);
				}
				else if(rand > 15 && rand < 26)
				{
					GivePlayerValidWeapon(playerid, 5);
					SendClientMessageEx(playerid, COLOR_GRAD1, "You have picked up the backpack and received a baseball bat.");
					HungerBackpackInfo[backpack][hgActiveEx] = 0;
					DestroyDynamic3DTextLabel(HungerBackpackInfo[backpack][hgBackpack3DText]);
					DestroyDynamicPickup(HungerBackpackInfo[backpack][hgBackpackPickupId]);
				}
				else if(rand > 25 && rand < 36)
				{
					GivePlayerValidWeapon(playerid, 22);
					SendClientMessageEx(playerid, COLOR_GRAD1, "You have picked up the backpack and received a 9mm.");
					HungerBackpackInfo[backpack][hgActiveEx] = 0;
					DestroyDynamic3DTextLabel(HungerBackpackInfo[backpack][hgBackpack3DText]);
					DestroyDynamicPickup(HungerBackpackInfo[backpack][hgBackpackPickupId]);
				}
			}
			else if(HungerBackpackInfo[backpack][hgBackpackType] == 3)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "You have picked up the backpack and received 100 percent hunger.");
				HungerBackpackInfo[backpack][hgActiveEx] = 0;
				DestroyDynamic3DTextLabel(HungerBackpackInfo[backpack][hgBackpack3DText]);
				DestroyDynamicPickup(HungerBackpackInfo[backpack][hgBackpackPickupId]);
			}
			else if(HungerBackpackInfo[backpack][hgBackpackType] == 4)
			{
				SetHealth(playerid, 100.0);
				SendClientMessageEx(playerid, COLOR_GRAD1, "You have picked up the backpack and received 100 percent health.");\
				HungerBackpackInfo[backpack][hgActiveEx] = 0;
				DestroyDynamic3DTextLabel(HungerBackpackInfo[backpack][hgBackpack3DText]);
				DestroyDynamicPickup(HungerBackpackInfo[backpack][hgBackpackPickupId]);
			}
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in the Hunger Games Event");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "There's currently no active Hunger Games Event.");
	return true;
}
					
CMD:hungerhelp(playerid, params[])
{	
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "** Hunger Games: /starthunger /createbackpack /hgplayers /endhunger");
	}
	
	SendClientMessageEx(playerid, COLOR_GRAD1, "** Hunger Games: /joinhunger /miscshop (Hunger Voucher) /leavehunger /openbackpack");
	return true;
}

CMD:hgplayers(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		new string[128]; // 8024 memory is not enough when there is 400+ players in the event
		foreach(new i : Player)
		{
			if(HungerPlayerInfo[i][hgInEvent] == 1)
			{
				format(string, sizeof(string), "Player %s (ID %i)", GetPlayerNameEx(i), i);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
		}
	}
	else
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return 1;
}
