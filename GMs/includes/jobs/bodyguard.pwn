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
					
	* Copyright (c) 2014, Next Generation Gaming, LLC
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
		new string[128], storageid, giveplayerid;
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

				/*// Find the storageid of the storagedevice.
				if(storageid == 1) {
					new bool:itemEquipped = false;
					for(new i = 0; i < 3; i++)
					{
						if(StorageInfo[giveplayerid][i][sAttached] == 1) {
							storageid = i+1;
							itemEquipped = true;
						}
					}
					if(itemEquipped == false) return SendClientMessageEx(playerid, COLOR_WHITE, "That person doesn't have a storage device equipped!");
				}*/
				new packages = GetPVarInt(giveplayerid, "Packages");
				new crates = PlayerInfo[giveplayerid][pCrates];
				SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
				format(string, sizeof(string), "*** %s' items...  ***", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				if(PlayerInfo[giveplayerid][pPot] > 0)
				{
					format(string, sizeof(string), "(Pocket) %d grams of pot.", PlayerInfo[giveplayerid][pPot]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}

				if(PlayerInfo[giveplayerid][pWSeeds] == 1)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "(Pocket) Marijuana Seeds");
				}
				if(PlayerInfo[giveplayerid][pCrack] > 0)
				{
					format(string, sizeof(string), "(Pocket) %d grams of crack.", PlayerInfo[giveplayerid][pCrack]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(PlayerInfo[giveplayerid][pMats] > 0)
				{
					format(string, sizeof(string), "(Pocket) %d materials.", PlayerInfo[giveplayerid][pMats]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(PlayerInfo[giveplayerid][pHeroin] > 0)
				{
					format(string, sizeof(string), "(Pocket) %d grams of heroin.", PlayerInfo[giveplayerid][pHeroin]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(PlayerInfo[giveplayerid][pRawOpium] > 0)
				{
					format(string, sizeof(string), "(Pocket) %d grams of raw opium.", PlayerInfo[giveplayerid][pRawOpium]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(PlayerInfo[giveplayerid][pSyringes] > 0)
				{
					format(string, sizeof(string), "(Pocket) %d syringes.", PlayerInfo[giveplayerid][pSyringes]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(PlayerInfo[giveplayerid][pOpiumSeeds] > 0)
				{
					format(string, sizeof(string), "(Pocket) %d opium seeds.", PlayerInfo[giveplayerid][pOpiumSeeds]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
                if(packages > 0)
				{
					format(string, sizeof(string), "(Pocket) %d material packages.", packages);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(crates > 0)
				{
					format(string, sizeof(string), "(Pocket) %d drug crates.", crates);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(storageid > 0)
				{
					if(StorageInfo[giveplayerid][storageid-1][sPot] > 0)
					{
						format(string, sizeof(string), "(%s) %d grams of pot.", storagetype[storageid], StorageInfo[giveplayerid][storageid-1][sPot]);
						SendClientMessageEx(playerid, COLOR_GREY, string);
					}
					if(StorageInfo[giveplayerid][storageid-1][sCrack] > 0)
					{
						format(string, sizeof(string), "(%s) %d grams of crack.", storagetype[storageid], StorageInfo[giveplayerid][storageid-1][sCrack]);
						SendClientMessageEx(playerid, COLOR_GREY, string);
					}
					if(StorageInfo[giveplayerid][storageid-1][sMats] > 0)
					{
						format(string, sizeof(string), "(%s) %d materials.", storagetype[storageid], StorageInfo[giveplayerid][storageid-1][sMats]);
						SendClientMessageEx(playerid, COLOR_GREY, string);
					}
				}

				if(Fishes[giveplayerid][pWeight1] > 0 || Fishes[giveplayerid][pWeight2] > 0 || Fishes[giveplayerid][pWeight3] > 0 || Fishes[giveplayerid][pWeight4] > 0 || Fishes[giveplayerid][pWeight5] > 0)
				{
					format(string, sizeof(string), "(Pocket) %d fish.", PlayerInfo[giveplayerid][pFishes]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(PlayerInfo[giveplayerid][pPhoneBook] > 0) SendClientMessageEx(playerid, COLOR_GREY, "Phone book.");
				if(PlayerInfo[giveplayerid][pCDPlayer] > 0) SendClientMessageEx(playerid, COLOR_GREY, "Music player.");
				new weaponname[50];
				format(string, sizeof(string), "*** %s' weapons...  ***", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				for (new i = 0; i < 12; i++)
				{
					if(PlayerInfo[giveplayerid][pGuns][i] > 0)
					{
						GetWeaponName(PlayerInfo[giveplayerid][pGuns][i], weaponname, sizeof(weaponname));
						format(string, sizeof(string), "Weapon: %s.", weaponname);
						SendClientMessageEx(playerid, COLOR_GRAD1, string);
					}
				}
				if(arrAmmoData[giveplayerid][awp_iAmmo][0] > 0)
				{
					format(string, sizeof(string), "9mm rounds: %d", arrAmmoData[giveplayerid][awp_iAmmo][0]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(arrAmmoData[giveplayerid][awp_iAmmo][1] > 0)
				{
					format(string, sizeof(string), "7.62x51 rounds: %d", arrAmmoData[giveplayerid][awp_iAmmo][1]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(arrAmmoData[giveplayerid][awp_iAmmo][2] > 0)
				{
					format(string, sizeof(string), ".50 AE rounds: %d", arrAmmoData[giveplayerid][awp_iAmmo][2]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(arrAmmoData[giveplayerid][awp_iAmmo][3] > 0)
				{
					format(string, sizeof(string), "7.62x39 rounds: %d", arrAmmoData[giveplayerid][awp_iAmmo][3]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				if(arrAmmoData[giveplayerid][awp_iAmmo][4] > 0)
				{
					format(string, sizeof(string), "12-gauge rounds: %d", arrAmmoData[giveplayerid][awp_iAmmo][4]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
				format(string, sizeof(string), "* %s has frisked %s for any illegal items.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
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

CMD:guard(playerid, params[])
{
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
	if(PlayerInfo[playerid][pJob] != 8 && PlayerInfo[playerid][pJob2] != 8 && PlayerInfo[playerid][pJob3] != 8)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not a bodyguard.");
		return 1;
	}
	if(WatchingTV[playerid] != 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You can not do this while watching TV!");
		return 1;
	}
	if(GetPVarInt(playerid, "IsInArena") >= 0)
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