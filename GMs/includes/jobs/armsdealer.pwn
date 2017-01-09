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
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this at this time.");
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(PlayerInfo[playerid][pJob] == 9 || PlayerInfo[playerid][pJob2] == 9 || PlayerInfo[playerid][pJob3] == 9)
	{
		if(GetPVarInt(playerid, "pSellGunTime") > gettime()) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must wait 10 seconds before selling another gun.");
		if(GetPVarType(playerid, "WatchingTV") || GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot use drugs while watching TV.");
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot sell a gun while in a vehicle!");
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
					SendClientMessageEx(playerid, COLOR_WHITE, "sdpistol(1000)");
				}
				case 50 .. 199: // level 2
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "sdpistol(1000)  shotgun(4000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "mp5(2500)");
				}
				case 200 .. 699: // level 3
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "sdpistol(1000)  shotgun(4000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "mp5(2500)		 rifle(3000)");
				}
				case 700 .. 1199:// Level 4 
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "sdpistol(1000)  shotgun(4000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "mp5(2500)		 rifle(3000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "tec9(3000)       	uzi(2500)");
				}
				default:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(100)    knuckles(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "bat(100)            cane(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(100)         club(100)");
					SendClientMessageEx(playerid, COLOR_WHITE, "pool(100)         katana(100)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(100)           9mm(500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "sdpistol(1000)  shotgun(4000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "mp5(2500)		  rifle(3000)");
					SendClientMessageEx(playerid, COLOR_WHITE, "tec9(3000)        	uzi(2500)");
					SendClientMessageEx(playerid, COLOR_WHITE, "deagle(5000)");
				}
			}
			if(PlayerInfo[playerid][pArmsSkill] >= 1200) SendClientMessageEx(playerid, COLOR_WHITE, "ak47(10000) - Requires Gold VIP");
			SendClientMessageEx(playerid, COLOR_WHITE, "-------------------------------------");
			SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /sellgun [playerid] [weapon]");
			return 1;
		}

		if(IsPlayerConnected(id))
		{
			if(IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot sell a gun to someone in a vehicle!");
			if(!ProxDetectorS(8.0, playerid, id)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near that player.");
			if(PlayerInfo[id][pConnectHours] < 2 || PlayerInfo[id][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "That player is currently weapon restricted!");

			if(strcmp(weapon, "Flowers", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 100;
						GivePlayerValidWeapon(id, 14);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 14);
						SetPVarInt(id, "pSellGunMats", 100);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Knuckles", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 100;
						GivePlayerValidWeapon(id, 1);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 1);
						SetPVarInt(id, "pSellGunMats", 100);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Bat", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 100;
						GivePlayerValidWeapon(id, 5);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 5);
						SetPVarInt(id, "pSellGunMats", 100);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Cane", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 100;
						GivePlayerValidWeapon(id, 15);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 15);
						SetPVarInt(id, "pSellGunMats", 100);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Shovel", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 100;
						GivePlayerValidWeapon(id, 6);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 6);
						SetPVarInt(id, "pSellGunMats", 100);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Club", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 100;
						GivePlayerValidWeapon(id, 2);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 2);
						SetPVarInt(id, "pSellGunMats", 100);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Pool", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 100;
						GivePlayerValidWeapon(id, 7);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 7);
						SetPVarInt(id, "pSellGunMats", 100);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Katana", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 100;
						GivePlayerValidWeapon(id, 8);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 8);
						SetPVarInt(id, "pSellGunMats", 100);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Dildo", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 100)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 100;
						GivePlayerValidWeapon(id, 10);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 10);
						SetPVarInt(id, "pSellGunMats", 100);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "9mm", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 500;
						GivePlayerValidWeapon(id, 22);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 22);
						SetPVarInt(id, "pSellGunMats", 500);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Shotgun", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 50)
			{
				if(PlayerInfo[playerid][pMats] >= 4000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 4000;
						GivePlayerValidWeapon(id, 25);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 25);
						SetPVarInt(id, "pSellGunMats", 4000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "SDPistol", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 1000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 1000;
						GivePlayerValidWeapon(id, 23);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 23);
						SetPVarInt(id, "pSellGunMats", 1000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Uzi", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 700)
			{
				if(PlayerInfo[playerid][pMats] >= 2500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 2500;
						GivePlayerValidWeapon(id, 28);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 28);
						SetPVarInt(id, "pSellGunMats", 2500);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Tec9", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 700)
			{
				if(PlayerInfo[playerid][pMats] >= 3000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 3000;
						GivePlayerValidWeapon(id, 32);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 32);
						SetPVarInt(id, "pSellGunMats", 3000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Rifle", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 200)
			{
				if(PlayerInfo[playerid][pMats] >= 3000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 3000;
						GivePlayerValidWeapon(id, 33);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 33);
						SetPVarInt(id, "pSellGunMats", 3000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "MP5", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 200)
			{
				if(PlayerInfo[playerid][pMats] >= 2500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 2500;
						GivePlayerValidWeapon(id, 29);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 29);
						SetPVarInt(id, "pSellGunMats", 2500);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "Deagle", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 1200)
			{
				if(PlayerInfo[playerid][pMats] >= 5000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 5000;
						GivePlayerValidWeapon(id, 24);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 24);
						SetPVarInt(id, "pSellGunMats", 5000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
			}
			else if(strcmp(weapon, "AK47", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 1200)
			{
				if(PlayerInfo[playerid][pDonateRank] > 2) {
					if(PlayerInfo[playerid][pMats] >= 10000)
					{
						if(id == playerid)
						{
							PlayerInfo[playerid][pMats] -= 10000;
							GivePlayerValidWeapon(id, 30);

							PlayerInfo[playerid][pArmsSkill] += 1;
						}
						else
						{
							SetPVarInt(id, "pSellGun", 30);
							SetPVarInt(id, "pSellGunMats", 10000);
							SetPVarInt(id, "pSellGunID", playerid);
							SetPVarInt(id, "pSellGunXP", 1);
						}
					}
					else return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough materials!");
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "You need to be a Gold VIP to craft this weapon!");
			}
			else 
			{
				return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid Weapon!");
			}
			weapon[0] = toupper(weapon[0]);

			if(id == playerid) 
			{ 
				format(szMiscArray, sizeof(szMiscArray), "%s crafts a %s from their materials, handing it to themselves.", GetPlayerNameEx(playerid), weapon); 
				ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); // Just a little 'classic' feel to it. -Winterfield
			}
			else 
			{
				format(szMiscArray, sizeof(szMiscArray), "You have offered %s a %s.", GetPlayerNameEx(id), weapon);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "%s has offered to sell you a %s, type /accept weapon to accept it.", GetPlayerNameEx(playerid), weapon);
				SendClientMessage(id, COLOR_LIGHTBLUE, szMiscArray);
			}

			SetPVarInt(playerid, "pSellGunTime", gettime() + 10);
			return 1; // Added so the error message would work.
		}
		else return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not currently online, please try again!");
	}
	SendClientMessage(playerid, COLOR_WHITE, "You are not an Arms Dealer!");
	return 1;
}