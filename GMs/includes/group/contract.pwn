/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Contract Group Type

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

#include <YSI\y_hooks>

forward PickUpC4(playerid);
public PickUpC4(playerid)
{
   	DestroyDynamicObject(PlayerInfo[playerid][pC4]);
   	PlayerInfo[playerid][pC4] = 0;
	return 1;
}


stock SearchingHit(playerid)
{
	new string[128], group = PlayerInfo[playerid][pMember];
   	SendClientMessageEx(playerid, COLOR_WHITE, "Available Contracts:");
   	new hits;
	foreach(new i: Player)
	{
		if(!IsAHitman(i) && PlayerInfo[i][pHeadValue] > 0)
		{
			if(GotHit[i] == 0)
			{
				hits++;
				format(string, sizeof(string), "%s (ID %d) | $%s | Placed By: %s | Reason: %s | Chased By: Nobody", GetPlayerNameEx(i), i, number_format(PlayerInfo[i][pHeadValue]), PlayerInfo[i][pContractBy], PlayerInfo[i][pContractDetail]);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
			else
			{
				format(string, sizeof(string), "%s (ID %d) | $%s | Placed By: %s | Reason: %s | Chased By: %s", GetPlayerNameEx(i), i, number_format(PlayerInfo[i][pHeadValue]), PlayerInfo[i][pContractBy], PlayerInfo[i][pContractDetail], GetPlayerNameEx(GetChased[i]));
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
		}
	}
	if(hits && PlayerInfo[playerid][pRank] <= 1 && arrGroupData[group][g_iGroupType] == GROUP_TYPE_CONTRACT)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "Use /givemehit to assign a contract to yourself.");
	}
	if(hits && PlayerInfo[playerid][pRank] >= 6 && arrGroupData[group][g_iGroupType] == GROUP_TYPE_CONTRACT)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "Use /givehit to assign a contract to one of the hitmen.");
	}
	if(hits == 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "There are no hits available.");
	}
	return 0;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;

	switch(dialogid)
	{
		case DIALOG_ORDER_HMA1:
		{
			if(response) {
				switch(listitem) {
					case 0: {
						if(GetPlayerCash(playerid) >= 2000) {
							SetHealth(playerid, 100);
							SetArmour(playerid, 100);
							GivePlayerCash(playerid, - 2000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 1: {
						if(PlayerInfo[playerid][pRank] < 4) { // use this to check their rank
							format(szMiscArray, sizeof(szMiscArray), "\nTear Gas\t\t $5,000\n\
							Knife\t\t\t $12,000\n\
							Baton\t\t\t $5,000\n\
							Spraycan\t\t $4,500\n\
							Colt.45\t\t\t $5,000\n\
							SD Pistol\t\t $7,500\n\
							Deagle\t\t\t $12,000\n\
							MP5\t\t\t $17,500\n\
							UZI\t\t\t $17,500\n\
							TEC9\t\t\t $17,500\n\
							Shotgun\t\t $11,000\n\
							SPAS12\t\t\t $90,000\n\
							AK47\t\t\t $35,000\n\
							M4\t\t\t $70,000\n\
							Rifle\t\t\t $10,000\n\
							Sniper\t\t\t $65,000"
							);
						}
						else {
							format(szMiscArray, sizeof(szMiscArray), "\nTear Gas\t\t $5,000\n\
							Knife\t\t\t $12,000\n\
							Baton\t\t\t $5,000\n\
							Spraycan\t\t $4,500\n\
							Colt.45\t\t\t $5,000\n\
							SD Pistol\t\t $7,500\n\
							Deagle\t\t\t $12,000\n\
							MP5\t\t\t $17,500\n\
							UZI\t\t\t $17,500\n\
							TEC9\t\t\t $17,500\n\
							Shotgun\t\t $11,000\n\
							SPAS12\t\t\t $90,000\n\
							AK47\t\t\t $35,000\n\
							M4\t\t\t $70,000\n\
							Rifle\t\t\t $10,000\n\
							Sniper\t\t\t $65,000\n\
							Chainsaw\t\t $20,000\n\
							C4\t\t\t $50,000"
							);
						}
						ShowPlayerDialogEx(playerid, DIALOG_ORDER_HMAWPS, DIALOG_STYLE_LIST, "Weapon Select", szMiscArray, "Select", "Back");
					}
					case 2: {
						ShowPlayerDialogEx(playerid, DIALOG_ORDER_HMASKIN, DIALOG_STYLE_INPUT, "Uniform", "Choose a skin (by ID).", "Change", "Back");
					}
					case 3: {
						if(gettime()-GetPVarInt(playerid, "LastNameChange") < 120) {
							return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only request a name change every two minutes.");
						}
						ShowPlayerDialogEx(playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, "Name Change","Please enter your new desired name!\n\nNote: Name Changes are free for your faction.", "Change", "Back");
					}
				}
			}
		}
		case DIALOG_ORDER_HMAWPS:
		{
			if(!response) {
				format(szMiscArray, sizeof(szMiscArray), "Health and Armour\t\t $2000\nWeapons\nUniform\nName Change");
				ShowPlayerDialogEx(playerid, DIALOG_ORDER_HMA1, DIALOG_STYLE_LIST, "HMA Order Weapons", szMiscArray, "Order", "Cancel");
			}
			else {
				switch(listitem) {
					case 0: { // tear gas - $5000
						if(GetPlayerCash(playerid) >= 5000) {
							GivePlayerValidWeapon(playerid, 17);
							GivePlayerCash(playerid, - 5000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 1: { // knife - $12000
						if(GetPlayerCash(playerid) >= 12000) {
							GivePlayerValidWeapon(playerid, 4);
							GivePlayerCash(playerid, - 12000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 2: {// baton - $5000
						if(GetPlayerCash(playerid) >= 5000) {
							GivePlayerValidWeapon(playerid, 3);
							GivePlayerCash(playerid, - 5000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 3: { // Spraycan - $4500
						if(GetPlayerCash(playerid) >= 4500) {
							GivePlayerValidWeapon(playerid, 41);
							GivePlayerCash(playerid, - 4500);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 4: { // Colt.45 - $5000
						if(GetPlayerCash(playerid) >= 5000) {
							GivePlayerValidWeapon(playerid, 22);
							GivePlayerCash(playerid, - 5000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 5: { // SD Pistol - $7500
						if(GetPlayerCash(playerid) >= 7500) {
							GivePlayerValidWeapon(playerid, 23);
							GivePlayerCash(playerid, - 7500);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 6: { // Deagle - $12000
						if(GetPlayerCash(playerid) >= 12000) {
							GivePlayerValidWeapon(playerid, 24);
							GivePlayerCash(playerid, - 12000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 7: { // MP5 - $17500
						if(GetPlayerCash(playerid) >= 17500) {
							GivePlayerValidWeapon(playerid, 29);
							GivePlayerCash(playerid, - 17500);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 8: { // UZI - $17500
						if(GetPlayerCash(playerid) >= 17500) {
							GivePlayerValidWeapon(playerid, 28);
							GivePlayerCash(playerid, - 17500);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 9: { // TEC9 - $17500
						if(GetPlayerCash(playerid) >= 17500) {
							GivePlayerValidWeapon(playerid, 32);
							GivePlayerCash(playerid, - 17500);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 10: { // Shotgun - $11000
						if(GetPlayerCash(playerid) >= 11000) {
							GivePlayerValidWeapon(playerid, 25);
							GivePlayerCash(playerid, - 11000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 11: { // SPAS - $90000
						if(GetPlayerCash(playerid) >= 90000) {
							GivePlayerValidWeapon(playerid, 27);
							GivePlayerCash(playerid, - 90000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 12: { // AK47 - $35000
						if(GetPlayerCash(playerid) >= 35000) {
							GivePlayerValidWeapon(playerid, 30);
							GivePlayerCash(playerid, - 35000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 13: { // M4 - $70000
						if(GetPlayerCash(playerid) >= 70000) {
							GivePlayerValidWeapon(playerid, 31);
							GivePlayerCash(playerid, - 70000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 14: { // Rifle - $10000
						if(GetPlayerCash(playerid) >= 10000) {
							GivePlayerValidWeapon(playerid, 33);
							GivePlayerCash(playerid, - 10000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 15: { // Sniper - $65000
						if(GetPlayerCash(playerid) >= 65000) {
							GivePlayerValidWeapon(playerid, 34);
							GivePlayerCash(playerid, - 65000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 16: { // Chainsaws - $20000
						if(GetPlayerCash(playerid) >= 20000) {
							GivePlayerValidWeapon(playerid, 9);
							GivePlayerCash(playerid, - 20000);
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
					case 17: { // C4s - $50000
						if(GetPlayerCash(playerid) >= 20000) {
							PlayerInfo[playerid][pC4Get] = 1;
							PlayerInfo[playerid][pBombs]++;
							GivePlayerCash(playerid, -50000);
							SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"   You have purchased one block of C4!");
						}
						else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
					}
				}
			}
		}
		case DIALOG_ORDER_HMASKIN:
		{
			if(response)	{
				new skin = strval(inputtext);
				if(IsInvalidSkin(skin)) {
					return ShowPlayerDialogEx(playerid, DIALOG_ORDER_HMASKIN, DIALOG_STYLE_INPUT, "Uniform","Invalid skin specified. Choose another.", "Select", "Cancel");
				}
				PlayerInfo[playerid][pModel] = skin;
				SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "Health and Armour\t\t $2000\nWeapons\nUniform\nName Change");
				ShowPlayerDialogEx(playerid, DIALOG_ORDER_HMA1, DIALOG_STYLE_LIST, "HMA Order Weapons", szMiscArray, "Order", "Cancel");
			}
		}
	}
	return 0;
}


CMD:contracts(playerid, params[])
{
    if(IsAHitman(playerid) || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
        SearchingHit(playerid);
    }
    return 1;
}

CMD:order(playerid, params[])
{
	if (IsAHitman(playerid))
	{
	    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this right now.");
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 63.973995, 1973.618774, -68.786064) || IsPlayerInRangeOfPoint(playerid, 6.0, 1415.727905, -1299.371093, 15.054657))
		{
			if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this as you are currently restricted from possessing weapons!");
			new string[128];
			format(string, sizeof(string), "Health and Armour\t\t $2000\nWeapons\nUniform\nName Change");
			ShowPlayerDialogEx(playerid, DIALOG_ORDER_HMA1, DIALOG_STYLE_LIST, "HMA Order Weapons", string, "Order", "Cancel");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, " You are not at the gun shack!");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a member of the hitman agency!");
		return 1;
	}
	return 1;
}

CMD:hbadge(playerid, params[])
{
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	if (IsAHitman(playerid))
	{
		new giveplayerid = 1;
 		if(sscanf(params, "d", giveplayerid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Type /hbadge 0 to reset");
		}
		if(giveplayerid == 0)
		{
			DeletePVar(playerid, "HitmanBadgeColour");
  			SendClientMessageEx(playerid, COLOR_WHITE, "You have set your badge back to normal.");
  			SetPlayerColor(playerid,TEAM_HIT_COLOR);
		}
		else
		{
			Group_ListGroups(playerid, DIALOG_HBADGE);
		}
	}
	return 1;
}

CMD:execute(playerid, params[])
{
	if(IsAHitman(playerid))
	{
		if(GoChase[playerid] != INVALID_PLAYER_ID || HitToGet[playerid] != INVALID_PLAYER_ID) {
			if(GetPVarInt(playerid, "KillShotCooldown") != 0 && gettime() < GetPVarInt(playerid, "KillShotCooldown") + 300) return SendClientMessageEx(playerid, COLOR_GRAD2, "You must wait 5 minutes between execution shots.");

			SetPVarInt(playerid, "ExecutionMode", 1);
			SendClientMessageEx(playerid, COLOR_GRAD2, " You have loaded a Hollow point round.  Aim for the Head when executing your target. ");
			SetPVarInt(playerid, "KillShotCooldown", gettime());
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have an active contract!");
	}
	return 1;
}

CMD:resetheadshot(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		return SetPVarInt(playerid, "KillShotCooldown", gettime()-300);
	}
	return 1;
}

CMD:profile(playerid, params[])
{
	if(IsAHitman(playerid))
	{
		new string[600], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /profile [player]");

		if(IsPlayerConnected(giveplayerid))
		{
		    new str2[64];
			if(0 <= PlayerInfo[giveplayerid][pMember] < MAX_GROUPS)
			{
				format(str2, sizeof(str2), "%s", arrGroupData[PlayerInfo[giveplayerid][pMember]][g_szGroupName]);
			}
			else str2 = "None";



			format(string, sizeof(string),
			"{FF6347}Name: {BFC0C2}%s\n\
			{FF6347}Date of Birth: {BFC0C2}%s\n\
			{FF6347}Phone Number: {BFC0C2}%d\n\n\
			{FF6347}Organization: {BFC0C2}%s\n\
			{FF6347}Bounty: {BFC0C2}$%d\n\
			{FF6347}Bounty Reason: {BFC0C2}%s", GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pBirthDate], PlayerInfo[giveplayerid][pPnumber], str2, PlayerInfo[giveplayerid][pHeadValue], PlayerInfo[giveplayerid][pContractDetail]);
			ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Target Profile", string, "OK", "");
		}
	}
	return 1;
}

CMD:ranks(playerid, params[])
{
	if ((!IsAHitman(playerid)) && PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not a Member of the Hitman Agency!");
	SendClientMessageEx(playerid, COLOR_WHITE, "|__________________ Agency's Ranks __________________|");

	new string[128];
	foreach(new i: Player)
	{
		if((IsAHitman(i)))
		{
			if( GoChase[playerid] == INVALID_PLAYER_ID )
			{
				format(string, sizeof(string), "* Name: %s | Rank %d | Completed Hits: %d | Failed Hits: %d", GetPlayerNameEx(i),PlayerInfo[i][pRank], PlayerInfo[i][pCHits], PlayerInfo[i][pFHits]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			else
			{
				format(string, sizeof(string), "* Name: %s | Rank %d | Completed Hits: %d | Failed Hits: %d | Chasing: %s", GetPlayerNameEx(i),PlayerInfo[i][pRank], PlayerInfo[i][pCHits], PlayerInfo[i][pFHits], GetPlayerNameEx(GoChase[i]));
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
		}
	}
	return 1;
}

CMD:plantcarbomb(playerid, params[]) {
	return cmd_pcb(playerid, params);
}

CMD:pcb(playerid, params[])
{
	if (IsAHitman(playerid))
	{
		if (PlayerInfo[playerid][pC4] == 0)
		{
			if (PlayerInfo[playerid][pBombs] != 0)
			{
				new carid = GetPlayerVehicleID(playerid);
				new closestcar = GetClosestCar(playerid, carid);
				if(IsPlayerInRangeOfVehicle(playerid, closestcar, 4.0))
				{
					if(VehicleBomb{closestcar} == 1)
					{
						SendClientMessageEx(playerid, COLOR_GRAD2, "There is already a C4 on the vehicle engine!");
						return 1;
					}
					VehicleBomb{closestcar} = 1;
					PlacedVehicleBomb[playerid] = closestcar;
					ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
					ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
					SendClientMessageEx(playerid, COLOR_GREEN, "You have placed C4 on the vehicle engine, /pickupbomb to remove it.");
					PlayerInfo[playerid][pC4] = 1;
					PlayerInfo[playerid][pBombs]--;
					PlayerInfo[playerid][pC4Used] = 2;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "You are not close enough to any vehicle!");
					return 1;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You do not have C4!");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, " You can only deploy 1 C4 at a time ! ");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, " You are not a member of the Hitman Agency ! ");
	}
	return 1;
}

CMD:plantbomb(playerid, params[]) {
	return cmd_pb(playerid, params);
}

CMD:pb(playerid, params[])
{
	if (IsAHitman(playerid))
	{
		if (PlayerInfo[playerid][pC4] == 0)
		{
			if (PlayerInfo[playerid][pBombs] != 0)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					SendClientMessageEx(playerid, COLOR_LIGHTRED,"You can't plant C4 while in a vehicle!");
					return 1;
				}
				GetPlayerPos(playerid, Positions[0][0], Positions[0][1], Positions[0][2]);
				SetPVarFloat(playerid, "DYN_C4_FLOAT_X", Positions[0][0]);
				SetPVarFloat(playerid, "DYN_C4_FLOAT_Y", Positions[0][1]);
				SetPVarFloat(playerid, "DYN_C4_FLOAT_Z", Positions[0][2]);
				new models[9] = {1654, 1230, 1778, 2814, 1271, 1328, 2919, 2770, 1840};
				ShowModelSelectionMenuEx(playerid, models, sizeof(models), "Bomb Model Selector", 1338, 0.0, 0.0, 180.0);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You do not have C4!");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "You can only deploy 1 C4 at a time!");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a member of the Hitman Agency!");
	}
	return 1;
}

CMD:pub(playerid, params[]) {
	return cmd_pickupbomb(playerid, params);
}

CMD:pickupbomb(playerid, params[])
{
	if (!IsAHitman(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are not a Hitman!");
		return 1;
	}
	if (PlayerInfo[playerid][pC4] == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You haven't planted a bomb!");
		return 1;
	}
	new carid = GetPlayerVehicleID(playerid);
	new closestcar = GetClosestCar(playerid, carid);
	if(IsPlayerInRangeOfVehicle(playerid, closestcar, 4.0) && VehicleBomb{closestcar} == 1)
	{
		VehicleBomb{closestcar} = 0;
		PlacedVehicleBomb[playerid] = INVALID_VEHICLE_ID;
		PickUpC4(playerid);
		SendClientMessageEx(playerid, COLOR_GREEN, "Bomb picked up successfully.");
		PlayerInfo[playerid][pBombs]++;
		PlayerInfo[playerid][pC4Used] = 0;
		PlayerInfo[playerid][pC4Get] = 1;
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "DYN_C4_FLOAT_X"), GetPVarFloat(playerid, "DYN_C4_FLOAT_Y"), GetPVarFloat(playerid, "DYN_C4_FLOAT_Z")))
	{
		PickUpC4(playerid);
		SendClientMessageEx(playerid, COLOR_GREEN, "Bomb picked up successfully.");
		PlayerInfo[playerid][pBombs]++;
		PlayerInfo[playerid][pC4Used] = 0;
		PlayerInfo[playerid][pC4Get] = 1;
		return 1;
	}
	return 1;
}

CMD:myc4(playerid, params[])
{
	if (IsAHitman(playerid))
	{
		new string[128];

		if (PlayerInfo[playerid][pBombs] > 0)
		{
			format(string, sizeof(string), "You currently have %i C4 in your inventory.", PlayerInfo[playerid][pBombs]);
		}
		else
		{
			format(string, sizeof(string), "You do not have any C4 in your inventory.");
		}

		SendClientMessageEx(playerid, COLOR_GRAD2, string);
	}

	return 1;
}

CMD:setmylevel(playerid, params[])
{
	if (!IsAHitman(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this command.");
	new level;
	if(sscanf(params, "d", level)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setmylevel [level]");
	if(PlayerInfo[playerid][pLevel] < level)  return SendClientMessageEx(playerid, COLOR_GREY, "The new level can't be greater than your current level.");
	DeletePVar(playerid, "TempLevel");
	SetPVarInt(playerid, "TempLevel", level);
	SetPlayerScore(playerid, level);
	format(szMiscArray, sizeof(szMiscArray), "You have set your level to %d", level);
	return SendClientMessage(playerid, COLOR_LIGHTRED, szMiscArray);
}

CMD:givehit(playerid, params[])
{
	if (IsAHitman(playerid))
	{
		if(PlayerInfo[playerid][pRank] < 5)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   Only ranks 5 and above can assign contracts to people !");
			return 1;
		}

		new string[128], giveplayerid, targetid;
		if(sscanf(params, "uu", giveplayerid, targetid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givehit [player] [targetid]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not near you.");
			if(giveplayerid == targetid) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot issue hits to the target.");
			if(GoChase[giveplayerid] != INVALID_PLAYER_ID)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   That Hitman is already busy with a Contract!");
				return 1;
			}
			if(GotHit[targetid] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   Another hitman has already assigned this target!");
				return 1;
			}
			if(IsPlayerConnected(targetid))
			{
				if(PlayerInfo[targetid][pHeadValue] == 0)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "   That target doesn't have a contract on them!");
					return 1;
				}

				format(string, sizeof(string), "* You offered %s a contract to kill %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(targetid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Hitman %s has offered you a contract to kill %s (type /accept contract), to accept it.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				HitOffer[giveplayerid] = playerid;
				HitToGet[giveplayerid] = targetid;
				return 1;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   The contracted person is offline, use /contracts!");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   That Hitman is not Online!");
			return 1;
		}
	}
	return 1;
}

CMD:givemehit(playerid, params[])
{
	if (IsAHitman(playerid))
	{
		new string[128], targetid;
		if(sscanf(params, "u", targetid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givemehit [targetid]");

		if(IsPlayerConnected(targetid))
		{
			if(GoChase[playerid] != INVALID_PLAYER_ID)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   You are already busy with another contract!");
				return 1;
			}
			if(GotHit[targetid] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   Another hitman has already assigned this target!");
				return 1;
			}
			if(PlayerInfo[targetid][pHeadValue] == 0)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   That target doesn't have a contract on them!");
				return 1;
			}
			format(string, sizeof(string), "* You have offered yourself a contract to kill %s. (type /accept contract)", GetPlayerNameEx(targetid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			HitOffer[playerid] = playerid;
			HitToGet[playerid] = targetid;
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The contracted person is offline, use /contracts!");
			return 1;
		}
	}
	return 1;
}

CMD:deletehit(playerid, params[])
{
	if( PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GROUP_TYPE_CONTRACT && PlayerInfo[playerid][pRank] >= 5) || arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == GROUP_TYPE_CONTRACT )
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deletehit [player]");

		if(!IsPlayerConnected(giveplayerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
			return 1;
		}

		if(PlayerInfo[giveplayerid][pHeadValue] >= 1 )
		{
			PlayerInfo[giveplayerid][pHeadValue] = 0;
			format(string, sizeof(string), "<< %s(%d) has removed the contract on %s(%d) >>", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
			Log("logs/contracts.log", string);
			format(string, sizeof(string), "You have removed the contract which was on %s's head.", GetPlayerNameEx(giveplayerid) );
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			GoChase[giveplayerid] = INVALID_PLAYER_ID;

			foreach(new i: Player)
			{
				if( HitToGet[i] == giveplayerid )
				{
					HitToGet[i] = INVALID_PLAYER_ID;
					HitOffer[i] = INVALID_PLAYER_ID;
				}
			}
		}
		else
		{
			SendClientMessageEx( playerid, COLOR_WHITE, "There's not an active contract on that player!" );
		}
	}
	return 1;
}

CMD:contract(playerid, params[])
{
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't place contracts while in cuffs.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't place contracts while in jail.");

	new string[128], giveplayerid, moneys, detail[32];
	if(sscanf(params, "uds[32]", giveplayerid, moneys, detail))
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /contract [player] [amount] [details]");

	if (IsPlayerConnected(giveplayerid) && giveplayerid != INVALID_PLAYER_ID)
	{
		if(giveplayerid == playerid)
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't contract yourself.");

		if(PlayerInfo[playerid][pLevel] < 3 || PlayerInfo[giveplayerid][pLevel] < 3)
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot place a contract unless both you and the hit are at least level 3.");

		if(moneys < 50000 || moneys > 3000000)
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't place contracts that are less than $50,000 or more than $3,000,000.");

		if((moneys < 50000 || moneys > 3000000) && IsACop(giveplayerid))
			return SendClientMessageEx(playerid, COLOR_GREY, "The minimum hit amount for a law enforcement officer is $150,000.");

		if(PlayerInfo[playerid][pMember] != INVALID_GROUP_ID && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GROUP_TYPE_CONTRACT)
			return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this to that person.");

		if(PlayerInfo[giveplayerid][pHeadValue] >= 3000000 || moneys + PlayerInfo[giveplayerid][pHeadValue] > 3000000)
			return SendClientMessageEx(playerid, COLOR_GREY, "That person has the maximum on their head.");

		if(PlayerInfo[playerid][pJailTime] > 0 || PlayerCuffed[playerid] > 0)
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't do this right now");

		if (moneys > 0 && GetPlayerCash(playerid) >= moneys)
		{
			if(strlen(detail) > 32) return SendClientMessageEx(playerid, COLOR_GRAD1, "Contract details may not be longer than 32 characters in length.");
			GivePlayerCash(playerid, (0 - moneys));
			PlayerInfo[giveplayerid][pHeadValue] += moneys;
			strmid(PlayerInfo[giveplayerid][pContractBy], GetPlayerNameEx(playerid), 0, strlen(GetPlayerNameEx(playerid)), MAX_PLAYER_NAME);
			strmid(PlayerInfo[giveplayerid][pContractDetail], detail, 0, strlen(detail), 32);
			format(string, sizeof(string), "%s has placed a contract on %s for $%s, details: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), number_format(moneys), detail);
			SendGroupMessage(GROUP_TYPE_CONTRACT, COLOR_YELLOW, string);
			format(string, sizeof(string), "* You placed a contract on %s for $%s, details: %s", GetPlayerNameEx(giveplayerid), number_format(moneys), detail);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "<< %s has placed a contract on %s for $%s, details: %s >>", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), number_format(moneys), detail);
			Log("logs/contracts.log", string);
			format(string, sizeof(string), "%s has placed a contract on %s for $%s, details: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), number_format(moneys), detail);
			ABroadCast(COLOR_YELLOW, string, 2);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have enough money for this.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	return 1;
}

CMD:knife(playerid, params[])
{
	if(IsAHitman(playerid)) {
		if(GetPVarInt(playerid, "HidingKnife") == 1) {
			GivePlayerValidWeapon(playerid, 4);
			DeletePVar(playerid, "HidingKnife");
			SendClientMessageEx(playerid, COLOR_YELLOW, "You have pulled out your knife.");
		}
		else {
			if(PlayerInfo[playerid][pGuns][1] == WEAPON_KNIFE) {
				RemovePlayerWeapon(playerid, 4); // Remove Knife
				SetPVarInt(playerid, "HidingKnife", 1);
				SendClientMessageEx(playerid, COLOR_YELLOW, "You have hidden your knife.");
			}
			else {
				SendClientMessageEx(playerid, COLOR_WHITE, "You do not have a knife available.");
			}
		}
	}
	return 1;
}
