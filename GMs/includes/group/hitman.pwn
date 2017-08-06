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

// The new proposed Hitman Agency system. Approved by Rizi & Chapman on 07/08/16.
// Relevant Documentation: https://docs.google.com/document/d/1rJzSK7MiNKJQOVSdhtc6RXgUr_X5ixkMYaG6nDvgTFc/

#define COLOR_HMARADIO			0x008BE8FF
#define COLOR_HMAOOC			0x00FFFFFF

//new Float:fHMASafe_Loc[3];
//new iHMASafe_Val = 0;
//new File:HMAFile, iFileLoaded = 0;



/****** Stocks & Functions ******/
hook OnGameModeInit()
{
	if(!fexist("hma.cfg"))
	{
		new File:NewFile = fopen("hma.cfg", io_write);
		fwrite(NewFile, "1415.727905\r\n");
		fwrite(NewFile, "-1299.371093\r\n");
		fwrite(NewFile, "15.054657\r\n");
		fwrite(NewFile, "0\r\n");
		fwrite(NewFile, "New Agency!\r");
		fclose(NewFile);
	}
	HMAFile = fopen("hma.cfg", io_readwrite);

	new szTemp[128];
	for(new i = 0; i < 3; i++)
	{
		// Load position of safe.
		fread(HMAFile, szTemp, sizeof szTemp);
		fHMASafe_Loc[i] = floatstr(szTemp);
	}

	// Load safe value.
	fread(HMAFile, szTemp, sizeof szTemp);
	iHMASafe_Val = strval(szTemp);

	// Load MOTD
	fread(HMAFile, HMAMOTD, sizeof HMAMOTD);
	iFileLoaded = 1;
}

hook OnGameModeExit()
{
	fclose(HMAFile);
}

stock GetPlayerIDEx(playername[]) // Uncomment this
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
  	{
    	if(IsPlayerConnected(i))
    	{
      		new szName[MAX_PLAYER_NAME];
      		GetPlayerName(i, szName, sizeof szName);

      		if(strcmp(szName, playername, true, strlen(szName)) == 0)
      		{
        		return i;
      		}
    	}
  	}
	return INVALID_PLAYER_ID;
}

forward PickUpC4(playerid);
public PickUpC4(playerid)
{
    DestroyDynamicObject(PlayerInfo[playerid][pC4]);
    PlayerInfo[playerid][pC4] = 0;
    return 1;
}

stock IsAHitman(playerid)
{
	if(PlayerInfo[playerid][pHitman] > -1) return 1;
	return 0;
}

stock IsAHitmanLeader(playerid)
{
	if(PlayerInfo[playerid][pHitmanLeader] == 1) return 1;
	return 0;
}

stock IsBlacklisted(playerid)
{
	if(PlayerInfo[playerid][pHitmanBlacklisted] > 0) return 1;
	return 0;
}

stock GetHitmanRank(playerid)
{
	new szRank[25];

	switch(PlayerInfo[playerid][pHitman])
	{
		case 0: format(szRank, sizeof szRank, "Freelancer");
		case 1: format(szRank, sizeof szRank, "Agent");
		case 2: format(szRank, sizeof szRank, "Marksman");
		case 3: format(szRank, sizeof szRank, "Operative");
		case 4: format(szRank, sizeof szRank, "Specialist");
		case 5: format(szRank, sizeof szRank, "Vice Director");
		case 6: format(szRank, sizeof szRank, "Director");
		default: format(szRank, sizeof szRank, "null"); // Player is not a valid hitman.
	}

	return szRank;
}

stock SaveHitmanSafe()
{
	if(HMAFile)
	{
		// For some reason it was appending the file instead of overwriting. Temporary fix.
		fclose(HMAFile);
		fremove("hma.cfg");

		HMAFile = fopen("hma.cfg", io_readwrite);
		format(szMiscArray, sizeof szMiscArray, "%f\r\n%f\r\n%f\r\n%d\r\n%s", fHMASafe_Loc[0], fHMASafe_Loc[1], fHMASafe_Loc[2], iHMASafe_Val, HMAMOTD);
		fwrite(HMAFile, szMiscArray);
	}
	else
	{
		Log("logs/hitman.log", "Error saving hitman safe (file not open).");
	}
}

/****** Commands ******/
CMD:toghma(playerid, params[])
{
	if(!IsAHitman(playerid)) return 0;
	//if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /toghma [ic or ooc]");
	if(GetPVarInt(playerid, "DisableHMAChat")) 
	{
		DeletePVar(playerid, "DisableHMAChat");
		SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the Hitman Agency chats.");
	}
	else 
	{
		SetPVarInt(playerid, "DisableHMAChat", 1);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the Hitman Agency chats.");
	}
	return 1;
}
CMD:hr(playerid, params[])
{
	if(!IsAHitman(playerid)) return 0;
	else if(GetPVarInt(playerid, "DisableHMAChat")) return SendClientMessageEx(playerid, COLOR_WHITE, "Your Hitman Agency chats are disabled. Please re-enable it using /toghma.");
	else if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /hr [text]");

	foreach(new i: Player) if(IsAHitman(i) && !GetPVarInt(playerid, "DisableHMAChat")) SendClientMessageEx(i, COLOR_HMARADIO, "** [IC] %s %s: %s **", GetHitmanRank(playerid), GetPlayerNameEx(playerid), params);
	return 1;
}

CMD:hg(playerid, params[])
{
	if(!IsAHitman(playerid)) return 0;
	else if(GetPVarInt(playerid, "DisableHMAChat")) return SendClientMessageEx(playerid, COLOR_WHITE, "Your Hitman Agency chats are disabled. Please re-enable it using /toghma.");
	else if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /hg [text]");

	format(szMiscArray, sizeof szMiscArray,  "** [OOC] %s (%d) %s: %s **", GetHitmanRank(playerid), PlayerInfo[playerid][pHitman], GetPlayerNameEx(playerid), params);
	foreach(new i: Player) if(IsAHitman(i) && !GetPVarInt(playerid, "DisableHMAChat")) SendClientMessageEx(i, COLOR_HMAOOC, szMiscArray);
	return 1;
}

CMD:plantcarbomb(playerid, params[]) {
	return cmd_pcb(playerid, params);
}

CMD:pcb(playerid, params[])
{
	if (IsAHitman(playerid))
	{
		if(PlayerInfo[playerid][pC4] == 0)
		{
			if(PlayerInfo[playerid][pBombs] != 0)
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
			SendClientMessageEx(playerid, COLOR_GRAD2, " You can only deploy 1 C4 at a time.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, " You are not a member of the Hitman Agency");
	}
	return 1;
}

CMD:gotohmasafe(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pFactionModerator] != 0 && PlayerInfo[playerid][pAdmin] >= 4)
	{
		if(!iFileLoaded) return SendClientMessage(playerid, COLOR_GREY, "There was an error loading the Hitman Agency safe. A server restart is needed.");

		SetPlayerPos(playerid, fHMASafe_Loc[0], fHMASafe_Loc[1], fHMASafe_Loc[2]);
		SendClientMessage(playerid, COLOR_GRAD2, "	You have been teleported to the Hitman Agency's safe.");
	}
	else return 0;
	return 1;
}

CMD:edithmasafepos(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pFactionModerator] != 0 && PlayerInfo[playerid][pAdmin] >= 4)
	{
		if(!iFileLoaded) return SendClientMessage(playerid, COLOR_GREY, "There was an error loading the Hitman Agency safe. A server restart is needed.");

		new Float:fPos[3];
		GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);

		for(new i = 0; i < 3; i++) fHMASafe_Loc[i] = fPos[i];

		SaveHitmanSafe();
		SendClientMessage(playerid, COLOR_GRAD2, "	Hitman agency safe position edited successfully.");

		format(szMiscArray, sizeof szMiscArray, "Administrator %s has edited the safe position to X: %f, Y: %f, Z: %f.", GetPlayerNameEx(playerid), fHMASafe_Loc[0], fHMASafe_Loc[1], fHMASafe_Loc[2]);
		new file[256], month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
		Log(file, szMiscArray);
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "You're not authorized to use this command.");

	return 1;
}

CMD:hmasafedeposit(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		if(!iFileLoaded) return SendClientMessage(playerid, COLOR_GREY, "There was an error loading the Hitman Agency safe. A server restart is needed.");

		if(!IsPlayerInRangeOfPoint(playerid, 5.0, fHMASafe_Loc[0], fHMASafe_Loc[1], fHMASafe_Loc[2])) return SendClientMessage(playerid, COLOR_GRAD2, "You are not in range of the Agency's safe.");

		new iVal;
		if(sscanf(params, "d", iVal)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /hmasafedeposit [amount]");

		if(iVal < 1 || iVal > 99999999) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid amount specified. Valid amounts are between $1 and $99,999,999.");
		if(iVal > GetPlayerCash(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "You do not have that much money.");

		iHMASafe_Val += iVal;
		GivePlayerCash(playerid, -iVal);
		SaveHitmanSafe();

		format(szMiscArray, sizeof szMiscArray, "$%s has been deposited into the Agency's safe. Current balance: $%s.", number_format(iVal), number_format(iHMASafe_Val));
		SendClientMessage(playerid, COLOR_GRAD2, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "[SAFE DEPOSIT] %s %s | $%s deposited (total balance: $%s)", GetHitmanRank(playerid), GetPlayerNameEx(playerid), number_format(iVal), number_format(iHMASafe_Val));
		new file[256], month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
		Log(file, szMiscArray);
	}
	else return 0;
	return 1;
}

CMD:hmasafewithdraw(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		if(!iFileLoaded) return SendClientMessage(playerid, COLOR_GREY, "There was an error loading the Hitman Agency safe. A server restart is needed.");

		if(!IsPlayerInRangeOfPoint(playerid, 5.0, fHMASafe_Loc[0], fHMASafe_Loc[1], fHMASafe_Loc[2])) return SendClientMessage(playerid, COLOR_GRAD2, "You are not in range of the Agency's safe.");

		new iVal;
		if(sscanf(params, "d", iVal)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /hmasafewithdraw [amount]");

		if(iVal < 1 || iVal > 99999999) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid amount specified. Valid amounts are between $1 and $99,999,999.");

		if(iHMASafe_Val < iVal) return SendClientMessage(playerid, COLOR_GRAD2, "The Agency's safe does not have that much money.");

		iHMASafe_Val -= iVal;
		GivePlayerCash(playerid, iVal);
		SaveHitmanSafe();

		format(szMiscArray, sizeof szMiscArray, "$%s has been withdrawn from the Agency's safe. Current balance: $%s.", number_format(iVal), number_format(iHMASafe_Val));
		SendClientMessage(playerid, COLOR_GRAD2, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "[SAFE WITHDRAW] %s %s | $%s withdrawn (total balance: $%s)", GetHitmanRank(playerid), GetPlayerNameEx(playerid), number_format(iVal), number_format(iHMASafe_Val));
		new file[256], month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
		Log(file, szMiscArray);
	}
	else return 0;
	return 1;
}


CMD:hmasafe(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		if(!iFileLoaded) return SendClientMessage(playerid, COLOR_GREY, "There was an error loading the Hitman Agency safe. A server restart is needed.");

		if(!IsPlayerInRangeOfPoint(playerid, 5.0, fHMASafe_Loc[0], fHMASafe_Loc[1], fHMASafe_Loc[2])) return SendClientMessage(playerid, COLOR_GRAD2, "You are not in range of the Agency's safe.");

		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");

		format(szMiscArray, sizeof szMiscArray, "Hitman Agency - Safe Balance: $%s", number_format(iHMASafe_Val));
		SendClientMessage(playerid, COLOR_GRAD3, szMiscArray);

		SendClientMessage(playerid, COLOR_GRAD2, "/hmasafewithdraw, /hmasafedeposit");

		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
	}
	else return 0;
	return 1;
}

CMD:sethmamotd(playerid, params[])
{
	if(!IsAHitmanLeader(playerid)) return 0;

	if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /sethmamotd [motd]");

	format(HMAMOTD, sizeof HMAMOTD, params);

	format(szMiscArray, sizeof szMiscArray, "Agency MOTD changed! The new MOTD is: {FFFFFF}%s", HMAMOTD);
	foreach(new i: Player) if(IsAHitman(i)) SendClientMessage(i, COLOR_GRAD1, szMiscArray);

	SaveHitmanSafe();
	return 1;
}

CMD:givehit(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{

		new string[128], giveplayerid, targetid;
		if(sscanf(params, "uu", giveplayerid, targetid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givehit [player] [targetid]");

		if(IsPlayerConnected(giveplayerid))
		{
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
	else return 0;
}
CMD:ranks(playerid, params[])
{
	if ((!IsAHitman(playerid)) && PlayerInfo[playerid][pAdmin] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "You are not a Member of the Hitman Agency!");

	SendClientMessageEx(playerid, COLOR_WHITE, "|__________________ Hitman Agency Online Members __________________|");

	new string[128];
	foreach(new i: Player)
	{
		if((IsAHitman(i)))
		{
			if( GoChase[playerid] == INVALID_PLAYER_ID )
			{
				format(string, sizeof(string), "* Name: %s | Rank: %s (%d) | Completed Hits: %d | Failed Hits: %d", GetPlayerNameEx(i), GetHitmanRank(i), PlayerInfo[i][pHitman], PlayerInfo[i][pCHits], PlayerInfo[i][pFHits]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			else
			{
				format(string, sizeof(string), "* Name: %s | Rank: %s (%d) | Completed Hits: %d | Failed Hits: %d | Chasing: %s", GetPlayerNameEx(i), GetHitmanRank(i), PlayerInfo[i][pHitman], PlayerInfo[i][pCHits], PlayerInfo[i][pFHits], GetPlayerNameEx(GoChase[i]));
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
		}


	}
	return 1;
}

CMD:profile(playerid, params[])
{
    if(IsAHitman(playerid))
    {
        new string[600], giveplayerid, employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
        if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /profile [player]");

        if(IsPlayerConnected(giveplayerid))
        {
            new str2[256];
            if(0 <= PlayerInfo[giveplayerid][pMember] < MAX_GROUPS)
            {
            	GetPlayerGroupInfo(giveplayerid, rank, division, employer);
                format(str2, sizeof(str2), "%s{FF6347} | Division: {BFC0C2}%s\n{FF6347}Rank: {BFC0C2}%s (%d)\n", employer, division, rank, PlayerInfo[giveplayerid][pRank]);
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

CMD:viewblacklist(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessage(playerid, COLOR_GRAD1, "Hitman Agency Blacklist:");

		mysql_tquery(MainPipeline, "SELECT `Username`, `BlacklistReason` FROM `accounts` WHERE `HitmanBlacklisted`=1", "ShowBlacklistedPlayers", "d", playerid);
	}
	else return 0;
	return 1;
}

CMD:givehitmanrank(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		new iTarget, iRank;
		if(sscanf(params, "ud", iTarget, iRank)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /givehitmanrank [playerid] [rank 0-6]");

		new szRank[25];
		switch(iRank)
		{
			case 0: format(szRank, sizeof szRank, "Freelancer");
			case 1: format(szRank, sizeof szRank, "Agent");
			case 2: format(szRank, sizeof szRank, "Marksman");
			case 3: format(szRank, sizeof szRank, "Operative");
			case 4: format(szRank, sizeof szRank, "Specialist");
			case 5: format(szRank, sizeof szRank, "Vice Director");
			case 6: format(szRank, sizeof szRank, "Director");
		}

		if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified.");

		if(!IsAHitman(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not a hitman.");

		if(iRank < 0 || iRank > 6) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid rank specified. Valid ranks are between 0 and 6.");

		if(PlayerInfo[iTarget][pHitman] > PlayerInfo[playerid][pHitman]) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot edit the rank of a higher ranking hitman.");

		if(iRank == PlayerInfo[playerid][pHitman]) return SendClientMessage(playerid, COLOR_GRAD2, "That player is already the specified rank.");

		new szChange[12];
		if(iRank > PlayerInfo[iTarget][pHitman]) format(szChange, sizeof szChange, "promoted");
		else if(iRank < PlayerInfo[iTarget][pHitman]) format(szChange, sizeof szChange, "demoted");

		format(szMiscArray, sizeof szMiscArray, "%s %s has %s %s to %s (%d) from %s (%d).", GetHitmanRank(playerid), GetPlayerNameEx(playerid), szChange, GetPlayerNameEx(iTarget), szRank, iRank, GetHitmanRank(iTarget), PlayerInfo[iTarget][pHitman]);
		new file[256], month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
		Log(file, szMiscArray);
		PlayerInfo[iTarget][pHitman] = iRank;


		format(szMiscArray, sizeof szMiscArray, "* (hitman) You have %s %s to the rank of %s (%d).", szChange, GetPlayerNameEx(iTarget), szRank, iRank);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);

		if(iRank >= 5 && PlayerInfo[iTarget][pHitmanLeader] == 0) SendClientMessage(playerid, COLOR_LIGHTBLUE, "* The rank you have given is a leadership rank. Please contact an administrator to have it issued if necessary.");

		format(szMiscArray, sizeof szMiscArray, "* (hitman) %s %s has %s you to the rank of %s (%d).", GetHitmanRank(playerid), GetPlayerNameEx(playerid), szChange, szRank, iRank);
		SendClientMessage(iTarget, COLOR_LIGHTBLUE, szMiscArray);
	}
	else return 0;
	return 1;
}

CMD:quithma(playerid, params[])
{
	if(!IsAHitman(playerid)) return 0;

	PlayerInfo[playerid][pHitman] = -1;
	PlayerInfo[playerid][pHitmanLeader] = 0;

	SendClientMessage(playerid, COLOR_LIGHTBLUE, "*	You have quit the Hitman Agency. Your knife has been removed.");

	if(PlayerInfo[playerid][pGuns][1] == 4) RemovePlayerWeapon(playerid, 4);
	return 1;
}

CMD:makehitman(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		new iTarget;
		if(sscanf(params, "u", iTarget)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /makehitman [playerid]");

		if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified.");

		if(IsAHitman(iTarget) || IsAHitmanLeader(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is already a hitman. To revoke it, use /removehitman.");

		if(IsBlacklisted(iTarget))
		{
			SendClientMessage(playerid, COLOR_GRAD2, "That player cannot be invited to the Hitman Agency as they are blacklisted.");
			format(szMiscArray, sizeof szMiscArray, "Reason:{FFFFFF} %s", PlayerInfo[iTarget][pBlacklistReason]);
			SendClientMessage(playerid, COLOR_GRAD2, szMiscArray);
			return 1;
		}

		PlayerInfo[iTarget][pHitman] = 0;
		PlayerInfo[iTarget][pHitmanLeader] = 0;

		format(szMiscArray, sizeof szMiscArray, "* You have made %s a hitman.", GetPlayerNameEx(iTarget));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "* %s %s has made you a hitman. Use /hmahelp to see your new commands.", GetHitmanRank(playerid), GetPlayerNameEx(playerid));
		SendClientMessage(iTarget, COLOR_LIGHTBLUE, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "%s %s has made %s a hitman.", GetHitmanRank(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget));
		new file[256], month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
		Log(file, szMiscArray);
	}
	else if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pFactionModerator] != 0 && PlayerInfo[playerid][pAdmin] >= 4) // They're either a HA+ or a Senior Admin w/ FMod.
	{
		new iTarget;
		if(sscanf(params, "u", iTarget)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /makehitman [playerid]");

		if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified.");

		if(IsAHitman(iTarget) || IsAHitmanLeader(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is already a hitman. To revoke it, use /removehitman.");

		if(IsBlacklisted(iTarget))
		{
			SendClientMessage(playerid, COLOR_GRAD2, "That player cannot be invited to the Hitman Agency as they are blacklisted.");
			format(szMiscArray, sizeof szMiscArray, "Reason:{FFFFFF} %s", PlayerInfo[iTarget][pBlacklistReason]);
			SendClientMessage(playerid, COLOR_GRAD2, szMiscArray);
			return 1;
		}

		PlayerInfo[iTarget][pHitman] = 0;
		PlayerInfo[iTarget][pHitmanLeader] = 0;

		format(szMiscArray, sizeof szMiscArray, "* You have made %s a hitman.", GetPlayerNameEx(iTarget));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "* Administrator %s has admin invited you to the Hitman Agency. Use /hmahelp to see your new commands.", GetPlayerNameEx(playerid));
		SendClientMessage(iTarget, COLOR_LIGHTBLUE, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "Administrator %s has admin invited %s to the Hitman Agency.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget));
		new file[256], month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
		Log(file, szMiscArray);
	}
	else return 0;

	return 1;
}

CMD:removehitman(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		new iTarget;
		if(sscanf(params, "u", iTarget)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /removehitman [playerid]");

		if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified.");

		if(!IsAHitman(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not a hitman. If you wish to invite them, use /makehitman.");

		if(PlayerInfo[iTarget][pHitman] > PlayerInfo[playerid][pHitman]) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot kick higher ranked hitmen.");

		PlayerInfo[iTarget][pHitman] = -1;
		PlayerInfo[iTarget][pHitmanLeader] = 0;

		format(szMiscArray, sizeof szMiscArray, "* You have kicked %s from the Hitman Agency.", GetPlayerNameEx(iTarget));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "* %s %s has kicked you from the Hitman Agency. Your knife has been removed.", GetHitmanRank(playerid), GetPlayerNameEx(playerid));
		SendClientMessage(iTarget, COLOR_LIGHTBLUE, szMiscArray);
		if(PlayerInfo[iTarget][pGuns][1] == 4) RemovePlayerWeapon(iTarget, 4);

		format(szMiscArray, sizeof szMiscArray, "%s %s has kicked %s from the Hitman Agency.", GetHitmanRank(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget));
		new file[256], month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
		Log(file, szMiscArray);
	}
	else if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pFactionModerator] != 0 && PlayerInfo[playerid][pAdmin] >= 4)
	{
		new iTarget;
		if(sscanf(params, "u", iTarget)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /removehitman [playerid]");

		if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified.");

		if(!IsAHitman(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not a hitman. If you wish to invite them, use /makehitman.");

		PlayerInfo[iTarget][pHitman] = -1;
		PlayerInfo[iTarget][pHitmanLeader] = 0;

		format(szMiscArray, sizeof szMiscArray, "* You have kicked %s from the Hitman Agency.", GetPlayerNameEx(iTarget));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "* Administrator %s has kicked you from the Hitman Agency. Your knife has been removed.",  GetPlayerNameEx(playerid));
		SendClientMessage(iTarget, COLOR_LIGHTBLUE, szMiscArray);
		if(PlayerInfo[iTarget][pGuns][1] == 4) RemovePlayerWeapon(iTarget, 4);

		format(szMiscArray, sizeof szMiscArray, "Administrator %s has kicked %s from the Hitman Agency.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget));
		new file[256], month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
		Log(file, szMiscArray);
	}
	else return 0;

	return 1;
}

CMD:makehitmanleader(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pFactionModerator] != 0 && PlayerInfo[playerid][pAdmin] >= 4)
	{
		new iTarget;
		if(sscanf(params, "u", iTarget)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /makehitmanleader [playerid]");

		if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified.");

		if(IsAHitmanLeader(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is already a hitman leader. To revoke it, use /removehitmanleader.");

		if(IsBlacklisted(iTarget))
		{
			SendClientMessage(playerid, COLOR_GRAD2, "That player cannot be made a Hitman Leader as they are blacklisted.");
			format(szMiscArray, sizeof szMiscArray, "Reason:{FFFFFF} %s", PlayerInfo[iTarget][pBlacklistReason]);
			SendClientMessage(playerid, COLOR_GRAD2, szMiscArray);
			return 1;
		}

		PlayerInfo[iTarget][pHitmanLeader] = 1;
		PlayerInfo[iTarget][pHitman] = 6;

		format(szMiscArray, sizeof szMiscArray, "* You have made %s a hitman leader.", GetPlayerNameEx(iTarget));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "* Administrator %s has made you a hitman leader. Use /hmahelp to see your new commands.", GetPlayerNameEx(playerid));
		SendClientMessage(iTarget, COLOR_LIGHTBLUE, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "Administrator %s has made %s a hitman leader.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget));
		new file[256], month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
		Log(file, szMiscArray);
	}
	else return 0;

	return 1;
}

CMD:removehitmanleader(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pFactionModerator] != 0 && PlayerInfo[playerid][pAdmin] >= 4)
	{
		new iTarget;
		if(sscanf(params, "u", iTarget)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /removehitmanleader [playerid]");

		if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified.");

		if(!IsAHitmanLeader(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not a hitman leader. If you wish to make them, use /makehitmanleader.");

		PlayerInfo[iTarget][pHitmanLeader] = 0;

		format(szMiscArray, sizeof szMiscArray, "* You have removed %s's hitman leadership.", GetPlayerNameEx(iTarget));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "* Administrator %s has revoked your hitman leadership.",  GetPlayerNameEx(playerid));
		SendClientMessage(iTarget, COLOR_LIGHTBLUE, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "Administrator %s has removed %s's hitman leadership.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget));
		new file[256], month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
		Log(file, szMiscArray);
	}
	else return 0;
	return 1;
}

CMD:hmahelp(playerid, params[])
{
	if(IsAHitman(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessageEx(playerid, COLOR_GRAD3, "*** Hitman Agency Commands *** /hr /hg /toghma /ranks /contracts /givemehit /order /profile");
		SendClientMessageEx(playerid, COLOR_GRAD3, "*** Hitman Agency Commands *** /hfind /setmylevel /tempnum /pb /pcb /pub /myc4 /quithma");

		if(IsAHitmanLeader(playerid))
		{
			SendClientMessageEx(playerid, COLOR_GRAD3, "*** Leadership Commands *** /makehitman /givehitmanrank /(o)removehitman /hmasafe");
			SendClientMessageEx(playerid, COLOR_GRAD3, "*** Leadership Commands *** /(o)blacklist /(o)unblacklist /viewblacklist");
		}

		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
	}
	else if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pFactionModerator] != 0 && PlayerInfo[playerid][pAdmin] >= 4)
	{
		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessageEx(playerid, COLOR_GRAD3, "*** Administrator Commands *** /makehitmanleader, /removehitmanleader, /oremovehitmanleader");
		SendClientMessageEx(playerid, COLOR_GRAD3, "*** Administrator Commands *** /gotohmasafe, /edithmasafepos");
		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
	}
	else return 0;
	return 1;
}

CMD:blacklist(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		new iTarget, szReason[64];
		if(sscanf(params, "us[64]", iTarget, szReason))
		{
			SendClientMessage(playerid, COLOR_GREY, "USAGE: /blacklist [playerid] [reason]");
			SendClientMessage(playerid, COLOR_GREY, "NOTE: This will prevent them from joining the Agency.");
			return 1;
		}
		else
		{
			if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified. To offline blacklist a user, use /oblacklist.");

			if(IsBlacklisted(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is already blacklisted. If you wish to remove it, use /unblacklist.");

			if(IsAHitmanLeader(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot blacklist Hitman Leadership.");

			if(IsAHitman(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is in the Hitman Agency. Please use /removehitman first.");

			PlayerInfo[iTarget][pHitmanBlacklisted] = 1;
			format(PlayerInfo[iTarget][pBlacklistReason], 64, szReason);

			format(szMiscArray, sizeof szMiscArray, "* You have blacklisted %s from the Hitman Agency, reason: %s.", GetPlayerNameEx(iTarget), szReason);
			SendClientMessage(playerid, COLOR_GREY, szMiscArray);

			format(szMiscArray, sizeof szMiscArray, "%s %s has blacklisted %s, reason: %s.", GetHitmanRank(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget), szReason);
			new file[256], month, day, year;
			getdate(year,month,day);
			format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
			Log(file, szMiscArray);

			g_mysql_SaveAccount(iTarget); // The reason accounts are saved is because the /viewblacklist uses a mysql query to fetch whichever players are blacklisted.
		}
	}
	else return 0;
	return 1;
}

CMD:unblacklist(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		new iTarget;
		if(sscanf(params, "u", iTarget))
		{
			SendClientMessage(playerid, COLOR_GREY, "USAGE: /unblacklist [playerid]");
			SendClientMessage(playerid, COLOR_GREY, "NOTE: This will allow the player to join the Hitman Agency again.");
			return 1;
		}
		else
		{
			if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified. To offline un-blacklist a user, use /ounblacklist.");

			if(!IsBlacklisted(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not blacklisted. If you wish to blacklist them, use /blacklist.");

			PlayerInfo[iTarget][pHitmanBlacklisted] = 0;
			format(PlayerInfo[iTarget][pBlacklistReason], 64, "");

			format(szMiscArray, sizeof szMiscArray, "* You have removed %s from the Hitman Agency blacklist.", GetPlayerNameEx(iTarget));
			SendClientMessage(playerid, COLOR_GREY, szMiscArray);

			format(szMiscArray, sizeof szMiscArray, "%s %s has unblacklisted %s.", GetHitmanRank(playerid), GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget));
			new file[256], month, day, year;
			getdate(year,month,day);
			format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
			Log(file, szMiscArray);

			g_mysql_SaveAccount(iTarget); // The reason accounts are saved is because the /viewblacklist uses a mysql query to fetch whichever players are blacklisted.
		}
	}
	else return 0;
	return 1;
}
/*
CMD:oblacklist(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		new szAccount[MAX_PLAYER_NAME], szReason[64];
		if(sscanf(params, "ss", szAccount, szReason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /oblacklist [account name] [reason]");

		if(IsPlayerConnected(GetPlayerIDEx(szAccount))) return SendClientMessage(playerid, COLOR_GRAD2, "That player is connected, please use /blacklist instead.");

		format(szMiscArray, sizeof szMiscArray, "SELECT * FROM `accounts` WHERE `Username`='%s'", g_mysql_ReturnEscaped(szAccount, MainPipeline));
		mysql_tquery(MainPipeline, szMiscArray, true, "OfflineBlacklistAccountFetch", "dss", playerid, szReason, szAccount);
	}
	else return 0;
	return 1;
}

CMD:ounblacklist(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		new szAccount[MAX_PLAYER_NAME];
		if(sscanf(params, "s", szAccount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /ounblacklist [account name]");

		if(IsPlayerConnected(GetPlayerIDEx(szAccount))) return SendClientMessage(playerid, COLOR_GRAD2, "That player is connected, please use /unblacklist instead.");

		format(szMiscArray, sizeof szMiscArray, "SELECT * FROM `accounts` WHERE `Username`='%s'", g_mysql_ReturnEscaped(szAccount, MainPipeline));
		mysql_tquery(MainPipeline, szMiscArray, true, "OfflineUnBlacklistAccountFetch", "ds", playerid, szAccount);
	}
	else return 0;
	return 1;
}

CMD:oremovehitman(playerid, params[])
{
	if(IsAHitmanLeader(playerid))
	{
		new szAccount[MAX_PLAYER_NAME];
		if(sscanf(params, "s", szAccount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /oremovehitman [account name]");

		if(IsPlayerConnected(GetPlayerIDEx(szAccount))) return SendClientMessage(playerid, COLOR_GRAD2, "That player is connected, please use /removehitman instead.");

		format(szMiscArray, sizeof szMiscArray, "SELECT * FROM `accounts` WHERE `Username`='%s'", g_mysql_ReturnEscaped(szAccount, MainPipeline));
		mysql_tquery(MainPipeline, szMiscArray, true, "OfflineRemoveHitman", "ds", playerid, szAccount);
	}
	else return 0;
	return 1;
}

CMD:oremovehitmanleader(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pFactionModerator] != 0 && PlayerInfo[playerid][pAdmin] >= 4)
	{
		new szAccount[MAX_PLAYER_NAME];
		if(sscanf(params, "s", szAccount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /oremovehitmanleader [account name]");

		if(IsPlayerConnected(GetPlayerIDEx(szAccount))) return SendClientMessage(playerid, COLOR_GRAD2, "That player is connected, please use /removehitman instead.");

		format(szMiscArray, sizeof szMiscArray, "SELECT * FROM `accounts` WHERE `Username`='%s'", g_mysql_ReturnEscaped(szAccount, MainPipeline));
		mysql_tquery(MainPipeline, szMiscArray, true, "OfflineRemoveHitmanLeader", "ds", playerid, szAccount);
	}
	else return 0;
	return 1;
}
*/



/****** Query Related Functions ******/
forward ShowBlacklistedPlayers(playerid);
public ShowBlacklistedPlayers(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(rows > 0)
	{
		new szName[MAX_PLAYER_NAME], szBlacklistReason[64];
		for(new row = 0; row < rows; row++)
		{
			cache_get_value_name(row, "Username", szName);
			for(new i = 0; i < MAX_PLAYER_NAME; i++) if(szName[i] == '_') szName[i] = ' ';
			cache_get_value_name(row, "BlacklistReason", szBlacklistReason);

			format(szMiscArray, sizeof szMiscArray, "{A9C4E4}Name: {FFFFFF}%s {A9C4E4}| Reason: {FFFFFF}%s", szName, szBlacklistReason);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD3, "The blacklist is empty. To add a player, use /blacklist or /oblacklist.");

	SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	return 1;
}
forward OfflineBlacklistAccountFetch(playerid, reason[], account[]);
public OfflineBlacklistAccountFetch(playerid, reason[], account[])
{
	new rows;
	cache_get_row_count(rows);
	if(rows > 0)
	{
		new iHitman, iHitmanLeader, iBlacklisted, szBlacklistReason[64];
		for(new row = 0; row < rows; row++)
		{
			cache_get_value_name_int(row, "Hitman", iHitman);
			cache_get_value_name_int(row, "HitmanLeader", iHitmanLeader);
			cache_get_value_name_int(row, "HitmanBlacklisted", iBlacklisted);
			cache_get_value_name(row, "BlacklistReason", szBlacklistReason);
		}

		if(iHitman == 1) return SendClientMessage(playerid, COLOR_GRAD2, "That player is in the Hitman Agency. Please use /oremovehitman first.");
		if(iHitmanLeader == 1) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot blacklist Hitman Leadership.");
		if(iBlacklisted == 1) return SendClientMessage(playerid, COLOR_GRAD2, "That player is already blacklisted. If you wish to unblacklist them, use /ounblacklist.");

		mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `accounts` SET `HitmanBlacklisted`=1, `BlacklistReason`='%e' WHERE `Username`='%s'", reason, account);
		mysql_tquery(MainPipeline, szMiscArray, "OfflineBlacklisted", "dss", playerid, reason, account);
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "That account does not exist.");
	return 1;
}

forward OfflineBlacklisted(playerid, reason[], account[]);
public OfflineBlacklisted(playerid, reason[], account[])
{
	format(szMiscArray, sizeof szMiscArray, "%s has been blacklisted successfully.", account);
	SendClientMessage(playerid, COLOR_WHITE, szMiscArray);

	format(szMiscArray, sizeof szMiscArray, "%s %s has offline-blacklisted %s, reason: %s.", GetHitmanRank(playerid), GetPlayerNameEx(playerid), account, reason);
	new file[256], month, day, year;
	getdate(year,month,day);
	format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
	Log(file, szMiscArray);
	return 1;
}

forward OfflineUnBlacklistAccountFetch(playerid, account[]);
public OfflineUnBlacklistAccountFetch(playerid, account[])
{
	new rows;
	cache_get_row_count(rows);

	if(rows > 0)
	{
		new iHitman, iHitmanLeader, iBlacklisted, szBlacklistReason[64];
		for(new row = 0; row < rows; row++)
		{
			cache_get_value_name_int(row, "Hitman", iHitman);
			cache_get_value_name_int(row, "HitmanLeader", iHitmanLeader);
			cache_get_value_name_int(row, "HitmanBlacklisted", iBlacklisted);
			cache_get_value_name(row, "BlacklistReason", szBlacklistReason);
		}

		if(iHitman == 1) return SendClientMessage(playerid, COLOR_GRAD2, "That player is in the Hitman Agency. Please use /oremovehitman first.");
		if(iHitmanLeader == 1) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot blacklist Hitman Leadership.");
		if(iBlacklisted == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not blacklisted. If you wish to blacklist them, use /oblacklist.");

		mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `accounts` SET `HitmanBlacklisted`=0, `BlacklistReason`='' WHERE `Username`='%s'", account);
		mysql_tquery(MainPipeline, szMiscArray, "OfflineUnBlacklisted", "ds", playerid, account);
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "That account does not exist.");
	return 1;
}

forward OfflineUnBlacklisted(playerid, account[]);
public OfflineUnBlacklisted(playerid, account[])
{
	format(szMiscArray, sizeof szMiscArray, "%s has been unblacklisted successfully.", account);
	SendClientMessage(playerid, COLOR_WHITE, szMiscArray);

	format(szMiscArray, sizeof szMiscArray, "%s %s has offline-unblacklisted %s.", GetHitmanRank(playerid), GetPlayerNameEx(playerid), account);
	new file[256], month, day, year;
	getdate(year,month,day);
	format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
	Log(file, szMiscArray);
	return 1;
}

forward OfflineRemoveHitman(playerid, account[]);
public OfflineRemoveHitman(playerid, account[])
{
	new rows;
	cache_get_row_count(rows);

	if(rows > 0)
	{
		new iHitman;
		for(new row = 0; row < rows; row++)
		{
			cache_get_value_name_int(row, "Hitman", iHitman);
		}

		if(iHitman == -1) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not a hitman.");

		mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `accounts` SET `Hitman`=-1, `HitmanLeader`=0 WHERE `Username`='%s'", account);
		mysql_tquery(MainPipeline, szMiscArray, "OfflineHitmanRemoved", "ds", playerid, account);
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "That account does not exist.");
	return 1;
}

forward OfflineHitmanRemoved(playerid, account[]);
public OfflineHitmanRemoved(playerid, account[])
{
	format(szMiscArray, sizeof szMiscArray, "%s has been removed from the Hitman Agency successfully.", account);
	SendClientMessage(playerid, COLOR_WHITE, szMiscArray);

	format(szMiscArray, sizeof szMiscArray, "%s %s has offline-removed %s.", GetHitmanRank(playerid), GetPlayerNameEx(playerid), account);
	new file[256], month, day, year;
	getdate(year,month,day);
	format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
	Log(file, szMiscArray);
	return 1;
}

forward OfflineRemoveHitmanLeader(playerid, account[]);
public OfflineRemoveHitmanLeader(playerid, account[])
{
	new rows;
	cache_get_row_count(rows);

	if(rows > 0)
	{
		new iHitman, iHitmanLeader;
		for(new row = 0; row < rows; row++)
		{
			cache_get_value_name_int(row, "Hitman", iHitman);
			cache_get_value_name_int(row, "HitmanLeader", iHitmanLeader);
		}
		if(iHitman > PlayerInfo[playerid][pHitman]) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot remove a higher ranking hitman's leadership.");

		if(iHitmanLeader == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not a hitman leader.");

		mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `accounts` SET `HitmanLeader`=0 WHERE `Username`='%s'", account);
		mysql_tquery(MainPipeline, szMiscArray, "OfflineHitmanLeaderRemoved", "ds", playerid, account);
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "That account does not exist.");
	return 1;
}

forward OfflineHitmanLeaderRemoved(playerid, account[]);
public OfflineHitmanLeaderRemoved(playerid, account[])
{
	format(szMiscArray, sizeof szMiscArray, "%s's hitman leadership has been removed.", account);
	SendClientMessage(playerid, COLOR_WHITE, szMiscArray);

	format(szMiscArray, sizeof szMiscArray, "Administrator %s has offline-removed %s's hitman leadership.", GetHitmanRank(playerid), GetPlayerNameEx(playerid), account);
	new file[256], month, day, year;
	getdate(year,month,day);
	format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
	Log(file, szMiscArray);
	return 1;
}

/////////////////// ADDITIONAL
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
                        if(PlayerInfo[playerid][pHitman] < 4) { // use this to check their rank
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
                        ShowPlayerDialogEx(playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Name Change","Please enter your new desired name!\n\nNote: Name Changes are free for your faction.", "Change", "Back");
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

                            format(szMiscArray, sizeof szMiscArray, "%s has taken teargas (17) from the locker at $5,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 1: { // knife - $12000
                        if(GetPlayerCash(playerid) >= 12000) {
                            GivePlayerValidWeapon(playerid, 4);
                            GivePlayerCash(playerid, - 12000);
                            format(szMiscArray, sizeof szMiscArray, "%s has taken a knife (4) from the locker at $12,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 2: {// baton - $5000
                        if(GetPlayerCash(playerid) >= 5000) {
                            GivePlayerValidWeapon(playerid, 3);
                            GivePlayerCash(playerid, - 5000);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken a baton (3) from the locker at $5,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 3: { // Spraycan - $4500
                        if(GetPlayerCash(playerid) >= 4500) {
                            GivePlayerValidWeapon(playerid, 41);
                            GivePlayerCash(playerid, - 4500);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken a spraycan (41) from the locker at $4,500.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 4: { // Colt.45 - $5000
                        if(GetPlayerCash(playerid) >= 5000) {
                            GivePlayerValidWeapon(playerid, 22);
                            GivePlayerCash(playerid, - 5000);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken a 9mm (22) from the locker at $5,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 5: { // SD Pistol - $7500
                        if(GetPlayerCash(playerid) >= 7500) {
                            GivePlayerValidWeapon(playerid, 23);
                            GivePlayerCash(playerid, - 7500);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken an SD pistol (23) from the locker at $7,500.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 6: { // Deagle - $12000
                        if(GetPlayerCash(playerid) >= 12000) {
                            GivePlayerValidWeapon(playerid, 24);
                            GivePlayerCash(playerid, - 12000);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken a deagle (24) from the locker at $12,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 7: { // MP5 - $17500
                        if(GetPlayerCash(playerid) >= 17500) {
                            GivePlayerValidWeapon(playerid, 29);
                            GivePlayerCash(playerid, - 17500);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken an MP5 (29) from the locker at $17,500.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 8: { // UZI - $17500
                        if(GetPlayerCash(playerid) >= 17500) {
                            GivePlayerValidWeapon(playerid, 28);
                            GivePlayerCash(playerid, - 17500);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken an uzi (28) from the locker at $17,500.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 9: { // TEC9 - $17500
                        if(GetPlayerCash(playerid) >= 17500) {
                            GivePlayerValidWeapon(playerid, 32);
                            GivePlayerCash(playerid, - 17500);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken a tec9 (32) from the locker at $17,500.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 10: { // Shotgun - $11000
                        if(GetPlayerCash(playerid) >= 11000) {
                            GivePlayerValidWeapon(playerid, 25);
                            GivePlayerCash(playerid, - 11000);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken a shotgun (25) from the locker at $11,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 11: { // SPAS - $90000
                        if(GetPlayerCash(playerid) >= 90000) {
                            GivePlayerValidWeapon(playerid, 27);
                            GivePlayerCash(playerid, - 90000);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken a SPAS-12 (27) from the locker at $90,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 12: { // AK47 - $35000
                        if(GetPlayerCash(playerid) >= 35000) {
                            GivePlayerValidWeapon(playerid, 30);
                            GivePlayerCash(playerid, - 35000);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken an AK47 (30) from the locker at $35,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 13: { // M4 - $70000
                        if(GetPlayerCash(playerid) >= 70000) {
                            GivePlayerValidWeapon(playerid, 31);
                            GivePlayerCash(playerid, - 70000);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken an m4 (31) from the locker at $70,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 14: { // Rifle - $10000
                        if(GetPlayerCash(playerid) >= 10000) {
                            GivePlayerValidWeapon(playerid, 33);
                            GivePlayerCash(playerid, - 10000);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken a rifle (33) from the locker at $10,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 15: { // Sniper - $65000
                        if(GetPlayerCash(playerid) >= 65000) {
                            GivePlayerValidWeapon(playerid, 34);
                            GivePlayerCash(playerid, - 65000);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken a sniper (34) from the locker at $65,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 16: { // Chainsaws - $20000
                        if(GetPlayerCash(playerid) >= 20000) {
                            GivePlayerValidWeapon(playerid, 9);
                            GivePlayerCash(playerid, - 20000);

                            format(szMiscArray, sizeof szMiscArray, "%s has taken a chainsaw (9) from the locker at $20,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                    case 17: { // C4s - $50000
                        if(GetPlayerCash(playerid) >= 20000) {
                            PlayerInfo[playerid][pC4Get] = 1;
                            PlayerInfo[playerid][pBombs]++;
                            GivePlayerCash(playerid, -50000);
                            format(szMiscArray, sizeof szMiscArray, "%s has taken a block of C4 from the locker at $50,000.", GetPlayerNameEx(playerid));
                            new file[256], month, day, year;
							getdate(year,month,day);
							format(file, sizeof(file), "logs/hitman/%d-%d-%d.log", month, day, year);
							Log(file, szMiscArray);
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"   You have purchased one block of C4!");
                        }
                        else SendClientMessageEx(playerid, COLOR_GRAD2, MSG_NOMONEY);
                    }
                }
            }
        }
        case DIALOG_ORDER_HMASKIN:
        {
            if(response)    {
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


stock SearchingHit(playerid)
{
    new string[128];
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
    if(hits && PlayerInfo[playerid][pHitman] <= 4 && IsAHitman(playerid))
    {
        SendClientMessageEx(playerid, COLOR_YELLOW, "Use /givemehit to assign a contract to yourself.");
    }
    if(hits && IsAHitmanLeader(playerid))
    {
        SendClientMessageEx(playerid, COLOR_YELLOW, "Use /givehit to assign a contract to one of the hitmen.");
    }
    if(hits == 0)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "There are no hits available.");
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

CMD:order(playerid, params[])
{
	if (IsAHitman(playerid))
	{
	    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this right now.");
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 63.973995, 1973.618774, -68.786064) || IsPlayerInRangeOfPoint(playerid, 6.0, 1415.727905, -1299.371093, 15.054657) || IsPlayerInRangeOfPoint(playerid, 2.0, 1666.3503, -1576.5717, 2195.8643))
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
    if(level < 1 || level > 80) return SendClientMessage(playerid, COLOR_GREY, "The new level cannot be below 1 or above 80.");
    DeletePVar(playerid, "TempLevel");
    SetPVarInt(playerid, "TempLevel", level);
    SetPlayerScore(playerid, level);
    format(szMiscArray, sizeof(szMiscArray), "You have set your level to %d", level);
    return SendClientMessage(playerid, COLOR_LIGHTRED, szMiscArray);
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
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || IsAHitmanLeader(playerid))
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
            return SendClientMessageEx(playerid, COLOR_GREY, "You can't do this right now.");

        if(IsAHitman(playerid))
        	return SendClientMessageEx(playerid, COLOR_GREY, "Hitmen cannot place contracts.");

        if (moneys > 0 && GetPlayerCash(playerid) >= moneys)
        {
            if(strlen(detail) > 32) return SendClientMessageEx(playerid, COLOR_GRAD1, "Contract details may not be longer than 32 characters in length.");
            GivePlayerCash(playerid, (0 - moneys));
            PlayerInfo[giveplayerid][pHeadValue] += moneys;
            strmid(PlayerInfo[giveplayerid][pContractBy], GetPlayerNameEx(playerid), 0, strlen(GetPlayerNameEx(playerid)), MAX_PLAYER_NAME);
            strmid(PlayerInfo[giveplayerid][pContractDetail], detail, 0, strlen(detail), 32);
            format(string, sizeof(string), "%s has placed a contract on %s for $%s, details: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), number_format(moneys), detail);
            foreach(new i: Player) if(IsAHitman(i)) SendClientMessage(i, COLOR_YELLOW, string);
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
