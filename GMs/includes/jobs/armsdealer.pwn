/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Arms Dealer Revision
								Winterfield

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

CMD:sellgun(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 9 || PlayerInfo[playerid][pJob2] == 9 || PlayerInfo[playerid][pJob3] == 9)
	{
		if(GetPVarInt(playerid, "pSellGunTime") > gettime()) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must wait 30 seconds before selling another gun.");
		if(GetPVarType(playerid, "WatchingTV") || GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot use drugs while watching TV.");
		if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
   		#if defined zombiemode
		if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
		#endif
		if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || (PlayerInfo[playerid][pJailTime] > 0 && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1))
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
		if(GetPVarType(playerid, "AttemptingLockPick")) return SendClientMessageEx(playerid, COLOR_WHITE, "You are attempting to lockpick, please wait.");
		if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
		if(PlayerInfo[playerid][pHospital]) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this at this time.");

		szMiscArray[0] = 0;
		new id, weapon[16];
		if(sscanf(params, "us[16]", id, weapon)) 
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "-------------------------------------");
			switch(PlayerInfo[playerid][pArmsSkill])
			{
				case 0 .. 49: // level 1
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
				}
				case 50 .. 149: // level 2
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "shotgun(850)");
				}
				case 150 .. 299: // level 3
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "shotgun(650)    sdpistol(800)");
				}
				case 300 .. 499:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "shotgun(650)    sdpistol(800)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "uzi(1000)          tec9(1000)");
				}
				case 500 .. 874:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "shotgun(650)    sdpistol(800)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "uzi(1000)          tec9(1000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "rifle(2000)");
				}
				case 875 .. 1474:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "shotgun(650)    sdpistol(800)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "uzi(1000)          tec9(1000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "rifle(2000)         MP5(2500)");
				}
				case 1475 .. 2349:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "shotgun(650)    sdpistol(800)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "uzi(1000)          tec9(1000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "rifle(2000)         MP5(2500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "deagle(4000)");
				}
				case 2350 .. 3549:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "shotgun(650)    sdpistol(800)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "uzi(1000)          tec9(1000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "rifle(2000)         MP5(2500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "deagle(4000)      AK47(12000)");
				}
				case 3550 .. 5349:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "shotgun(650)    sdpistol(800)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "uzi(1000)          tec9(1000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "rifle(2000)         MP5(2500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "deagle(4000)      AK47(12000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "M4(20000)");
				}
				case 5350 .. 7849:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "shotgun(650)    sdpistol(800)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "uzi(1000)          tec9(1000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "rifle(2000)         MP5(2500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "deagle(4000)      AK47(12000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "M4(20000)       SPAS12(30000)");
				}
				default:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "shotgun(650)    sdpistol(800)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "uzi(1000)          tec9(1000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "rifle(2000)         MP5(2500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "deagle(4000)      AK47(12000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "M4(20000)       SPAS12(30000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "Sniper(30000)");
				}
			}
			SendClientMessageEx(playerid, COLOR_WHITE, "-------------------------------------");
			SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /sellgun [playerid] [weapon]");
			return 1;
		}

		if(IsPlayerConnected(id))
		{
			if(strcmp(weapon, "Flowers", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					PlayerInfo[playerid][pMats] -= 100;
					GivePlayerValidWeapon(id, 14, 9999);
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Knuckles", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					PlayerInfo[playerid][pMats] -= 100;
					GivePlayerValidWeapon(id, 1, 9999);
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Bat", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					PlayerInfo[playerid][pMats] -= 100;
					GivePlayerValidWeapon(id, 5, 9999);
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Cane", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					PlayerInfo[playerid][pMats] -= 100;
					GivePlayerValidWeapon(id, 15, 9999);
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Shovel", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					PlayerInfo[playerid][pMats] -= 100;
					GivePlayerValidWeapon(id, 6, 9999);
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Club", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					PlayerInfo[playerid][pMats] -= 100;
					GivePlayerValidWeapon(id, 2, 9999);
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Pool", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					PlayerInfo[playerid][pMats] -= 100;
					GivePlayerValidWeapon(id, 7, 9999);
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Katana", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					PlayerInfo[playerid][pMats] -= 100;
					GivePlayerValidWeapon(id, 8, 9999);
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Dildo", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					PlayerInfo[playerid][pMats] -= 100;
					GivePlayerValidWeapon(id, 11, 9999);
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "9mm", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 500)
				{
					PlayerInfo[playerid][pMats] -= 100;
					GivePlayerValidWeapon(id, 22, 0);

					PlayerInfo[playerid][pArmsSkill] += 1;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Shotgun", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 50)
			{
				if(PlayerInfo[playerid][pMats] >= 650)
				{
					PlayerInfo[playerid][pMats] -= 650;
					GivePlayerValidWeapon(id, 25, 0);

					PlayerInfo[playerid][pArmsSkill] += 2;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "SDPistol", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 150)
			{
				if(PlayerInfo[playerid][pMats] >= 800)
				{
					PlayerInfo[playerid][pMats] -= 800;
					GivePlayerValidWeapon(id, 25, 0);

					PlayerInfo[playerid][pArmsSkill] += 3;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Uzi", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 300)
			{
				if(PlayerInfo[playerid][pMats] >= 1000)
				{
					PlayerInfo[playerid][pMats] -= 1000;
					GivePlayerValidWeapon(id, 25, 0);

					PlayerInfo[playerid][pArmsSkill] += 4;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Tec9", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 300)
			{
				if(PlayerInfo[playerid][pMats] >= 1000)
				{
					PlayerInfo[playerid][pMats] -= 1000;
					GivePlayerValidWeapon(id, 25, 0);

					PlayerInfo[playerid][pArmsSkill] += 4;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "rifle", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 500)
			{
				if(PlayerInfo[playerid][pMats] >= 1000)
				{
					PlayerInfo[playerid][pMats] -= 1000;
					GivePlayerValidWeapon(id, 33, 0);

					PlayerInfo[playerid][pArmsSkill] += 5;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "MP5", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 875)
			{
				if(PlayerInfo[playerid][pMats] >= 2500)
				{
					PlayerInfo[playerid][pMats] -= 2500;
					GivePlayerValidWeapon(id, 29, 0);

					PlayerInfo[playerid][pArmsSkill] += 6;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Deagle", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 1475)
			{
				if(PlayerInfo[playerid][pMats] >= 4000)
				{
					PlayerInfo[playerid][pMats] -= 4000;
					GivePlayerValidWeapon(id, 24, 0);

					PlayerInfo[playerid][pArmsSkill] += 7;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "AK47", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 2350)
			{
				if(PlayerInfo[playerid][pMats] >= 12000)
				{
					PlayerInfo[playerid][pMats] -= 12000;
					GivePlayerValidWeapon(id, 30, 0);

					PlayerInfo[playerid][pArmsSkill] += 8;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "M4", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 3350)
			{
				if(PlayerInfo[playerid][pMats] >= 20000)
				{
					PlayerInfo[playerid][pMats] -= 20000;
					GivePlayerValidWeapon(id, 31, 0);

					PlayerInfo[playerid][pArmsSkill] += 9;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "SPAS12", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 5350)
			{
				if(PlayerInfo[playerid][pMats] >= 30000)
				{
					PlayerInfo[playerid][pMats] -= 30000;
					GivePlayerValidWeapon(id, 27, 0);

					PlayerInfo[playerid][pArmsSkill] += 10;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Sniper", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 7850)
			{
				if(PlayerInfo[playerid][pMats] >= 30000)
				{
					PlayerInfo[playerid][pMats] -= 30000;
					GivePlayerValidWeapon(id, 34, 0);

					PlayerInfo[playerid][pArmsSkill] += 10;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else 
			{
				return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid Weapon!");
			}
			weapon[0] = toupper(weapon[0]);

			if(id == playerid) { format(szMiscArray, sizeof(szMiscArray), "%s crafts a %s from their materials, handing it to themselves.", GetPlayerNameEx(playerid), weapon); }
			else format(szMiscArray, sizeof(szMiscArray), "%s crafts a %s from their materials, handing it to %s.", GetPlayerNameEx(playerid), weapon, GetPlayerNameEx(id));

			SetPVarInt(playerid, "pSellGunTime", gettime() + 30);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); // Just a little 'classic' feel to it. -Winterfield
			return 1; // Added so the error message would work.
		}
		else return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not currently online, please try again!");
	}
	SendClientMessage(playerid, COLOR_WHITE, "You are not an Arms Dealer!");
	return 1;
}