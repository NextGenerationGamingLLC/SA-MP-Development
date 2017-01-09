/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Bodyguard System

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

CMD:frisk(playerid, params[])
{
	if(IsACop(playerid) || PlayerInfo[playerid][pJob] == 8 || PlayerInfo[playerid][pJob2] == 8 || PlayerInfo[playerid][pJob3] == 8)
	{
		new giveplayerid;
		if(sscanf(params, "u", giveplayerid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /frisk [player]");
			return 1;
		}
		/*if(sscanf(params, "ud", giveplayerid, storageid)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /frisk [player] [storageid]");
		SendClientMessageEx(playerid, COLOR_GREY, "StorageIDs: (0) Pocket - (1) Equipped Storage Device");
		return 1;
		}

		if(storageid < 0 || storageid > 1) {
			SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /frisk [player] [storageid]");
			SendClientMessageEx(playerid, COLOR_GREY, "StorageIDs: (0) Pocket - (1) Equipped Storage Device");
			return 1;
		}*/

		if(IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot frisk yourself!"); return 1; }
				if(PlayerInfo[giveplayerid][pAdmin] >= 2 && !PlayerInfo[giveplayerid][pTogReports]) return 1;

				PlayerFriskPlayer(playerid, giveplayerid); // It did a frisk ... why request?
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
			}

		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You're not a law enforcement officer, or a bodyguard!");
		return 1;
	}
	return 1;
}

PlayerFriskPlayer(playerid, giveplayerid)
{
	if(playerid == giveplayerid) return 1; 
	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(giveplayerid)) return 1;
	szMiscArray[0] = 0;
	new packages = GetPVarInt(giveplayerid, "Packages");
	new crates = PlayerInfo[giveplayerid][pCrates];
	SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
	format(szMiscArray, sizeof(szMiscArray), "Listing pocket for %s.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	SendClientMessageEx(playerid, COLOR_WHITE, "** Items **");
	format(szMiscArray, sizeof(szMiscArray), "* %s has frisked %s for any illegal items.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	if(PlayerInfo[giveplayerid][pMats] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Pocket) %d materials.", PlayerInfo[giveplayerid][pMats]);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
	if(PlayerInfo[giveplayerid][pSyringes] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Pocket) %d syringes.", PlayerInfo[giveplayerid][pSyringes]);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
    if(packages > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Pocket) %d material packages.", packages);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
	if(crates > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Pocket) %d drug crates.", crates);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}

	SendClientMessageEx(playerid, COLOR_WHITE, "** Drugs **");
	for(new i = 0; i < sizeof(Drugs); ++i) {

		if(PlayerInfo[giveplayerid][pDrugs][i] > 0) {
			format(szMiscArray, sizeof(szMiscArray), "%s: %dg", Drugs[i], PlayerInfo[giveplayerid][pDrugs][i]);
			SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
			}
	}
	if(Fishes[giveplayerid][pWeight1] > 0 || Fishes[giveplayerid][pWeight2] > 0 || Fishes[giveplayerid][pWeight3] > 0 || Fishes[giveplayerid][pWeight4] > 0 || Fishes[giveplayerid][pWeight5] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Pocket) %d fish.", PlayerInfo[giveplayerid][pFishes]);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
	SendClientMessageEx(playerid, COLOR_WHITE, "** Misc **");
	if(PlayerInfo[giveplayerid][pPhoneBook] > 0) SendClientMessageEx(playerid, COLOR_GREY, "Phone book.");
	if(PlayerInfo[giveplayerid][pCDPlayer] > 0) SendClientMessageEx(playerid, COLOR_GREY, "Music player.");
	new weaponname[50];
	SendClientMessageEx(playerid, COLOR_WHITE, "** Weapons **");
	for (new i = 0; i < 12; i++)
	{
		if(PlayerInfo[giveplayerid][pGuns][i] > 0)
		{
			GetWeaponName(PlayerInfo[giveplayerid][pGuns][i], weaponname, sizeof(weaponname));
			format(szMiscArray, sizeof(szMiscArray), "Weapon: %s.", weaponname);
			SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
		}
	}
	SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
	return 0;
}

CMD:guard(playerid, params[])
{
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
	if(PlayerInfo[playerid][pJob] != 8 && PlayerInfo[playerid][pJob2] != 8 && PlayerInfo[playerid][pJob3] != 8)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not a bodyguard.");
		return 1;
	}
	if(GetPVarInt(playerid, "WatchingTV")) return SendClientMessageEx(playerid, COLOR_GREY, "You can not do this while watching TV!");
	if(GetPVarType(playerid, "IsInArena"))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
		return 1;
	}
	new string[128], giveplayerid, money;
	if(sscanf(params, "ud", giveplayerid, money)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /guard [player] [price]");
	if (GetPVarInt(playerid, "GuardTimer") > 0)
	{
		format(string, sizeof(string), "   You must wait %d seconds before selling another vest.", GetPVarInt(playerid, "GuardTimer"));
		SendClientMessageEx(playerid,COLOR_GREY,string);
		return 1;
	}
	if(money < 2000 || money > 10000) { SendClientMessageEx(playerid, COLOR_GREY, "Specified price must be between $2,000 and $10,000."); return 1; }
	if(IsPlayerConnected(giveplayerid))
	{

		if(ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(giveplayerid == playerid)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You can't /guard yourself.");
				return 1;
			}

			SetPVarInt(playerid, "GuardTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GUARDTIMER);
			format(string, sizeof(string), "* You offered protection to %s for $%d.", GetPlayerNameEx(giveplayerid), money);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* Bodyguard %s wants to protect you for $%d, type /accept bodyguard to accept.", GetPlayerNameEx(playerid), money);
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			GuardOffer[giveplayerid] = playerid;
			GuardPrice[giveplayerid] = money;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
		}

	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	}
	return 1;
}
