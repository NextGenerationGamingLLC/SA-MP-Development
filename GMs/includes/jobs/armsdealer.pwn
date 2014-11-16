/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Arms Dealer Core

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

CMD:sellgun(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
    new string[128];
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
    if(GetPVarInt(playerid, "IsInArena") >= 0) {
        SendClientMessageEx(playerid,COLOR_GREY,"   You cannot do this while being in an arena!");
        return 1;
    }
   	if(GetPVarInt( playerid, "EventToken") != 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
		return 1;
	}
    if (PlayerInfo[playerid][pJob] != 9 && PlayerInfo[playerid][pJob2] != 9 && PlayerInfo[playerid][pJob3] != 9) {
        SendClientMessageEx(playerid,COLOR_GREY,"   You are not a Arms Dealer!");
        return 1;
    }
    if(WatchingTV[playerid] != 0) {
        SendClientMessageEx(playerid, COLOR_GREY, "You can not do this while watching TV!");
        return 1;
    }
    if (PlayerInfo[playerid][pScrewdriver] == 0) {
        SendClientMessageEx(playerid,COLOR_GREY,"   You need a screwdriver from a craftsman to make a weapon!");
        return 1;
    }
    if (PlayerInfo[playerid][pJailTime] > 0) {
        SendClientMessageEx(playerid,COLOR_GREY,"   You can not make guns while in jail or prison!");
        return 1;
    }
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this right now.");
    if (GetPVarInt(playerid, "ArmsTimer") > 0) {
        format(string, sizeof(string), "   You must wait %d seconds before selling another weapon.", GetPVarInt(playerid, "ArmsTimer"));
        SendClientMessageEx(playerid,COLOR_GREY,string);
        return 1;
    }
    if(PlayerInfo[playerid][pHospital] > 0) {
        SendClientMessageEx(playerid, COLOR_GREY, "You can't spawn a weapon whilst in Hospital.");
        return 1;
    }

    new giveplayerid,x_weapon[20],weapon,price,storageid;

	/*// Find the storageid of the storagedevice.
	new bool:itemEquipped = false;

	for(new i = 0; i < 3; i++)
	{
		if(StorageInfo[playerid][i][sAttached] == 1) {
			storageid = i;
			itemEquipped = true;
		}
	}
	if(itemEquipped == false) return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a storage device equipped! - /storagehelp");
	*/

    if(sscanf(params, "us[20]", giveplayerid, x_weapon)) {
        SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
        SendClientMessageEx(playerid, COLOR_YELLOW, "<< Available weapons >>");
        new level = PlayerInfo[playerid][pArmsSkill];
        if(level >= 0 && level < 50) {
            SendClientMessageEx(playerid, COLOR_GRAD1, "sdpistol(100)	flowers(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "9mm(150)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "shotgun(200)	knuckles(25)");
        }
        else if(level >= 50 && level < 100) {
            SendClientMessageEx(playerid, COLOR_GRAD1, "sdpistol(100)	flowers(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "9mm(150)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "shotgun(200)	knuckles(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "mp5(400)		baseballbat(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "rifle(1000)	    cane(25)");
        }
        else if(level >= 100 && level < 200) {
            SendClientMessageEx(playerid, COLOR_GRAD1, "sdpistol(100)	flowers(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "9mm(150)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "shotgun(200)	knuckles(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "mp5(400)		baseballbat(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "rifle(1000)	    cane(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "deagle(2000)	shovel(25)");
        }
        else if(level >= 200 && level < 400) {
            SendClientMessageEx(playerid, COLOR_GRAD1, "sdpistol(100)	flowers(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "9mm(150)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "shotgun(200)	knuckles(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "mp5(400)   		baseballbat(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "rifle(1000)	    cane(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "deagle(2000)    shovel(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "golfclub(25)	poolcue(25)");
        }
        else if(level >= 400) {
            SendClientMessageEx(playerid, COLOR_GRAD1, "sdpistol(100)	flowers(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "shotgun(200)	knuckles(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "mp5(400)        baseballbat(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "rifle(1000)	    cane(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "deagle(2000)    shovel(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "golfclub(25)	poolcue(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(25)	    katana(25)");
            SendClientMessageEx(playerid, COLOR_GRAD1, "uzi(1250)      tec9(1250)");
        }
        if(PlayerInfo[playerid][pDonateRank] >= 3)
        {
       		SendClientMessageEx(playerid, COLOR_YELLOW, "Gold+ VIP Feature: AK-47(10000)");
        }
        SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
        SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellgun [player] [weaponname]");
        return 1;
    }

	if(!IsPlayerConnected(giveplayerid)) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
	}
	if(PlayerInfo[giveplayerid][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this to someone that has his account restricted!");
	if(HungerPlayerInfo[giveplayerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   This person is not able to receive weapons at the moment.");
	if(zombieevent && GetPVarType(giveplayerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't have guns.");
    if(strcmp(x_weapon,"dildo",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 400) return SendClientMessageEx(playerid, COLOR_GREY, " You are not the required level to create that!");
        if(PlayerInfo[playerid][pMats] > 24) {
            weapon = 10; price = 25;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"katana",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 400) return SendClientMessageEx(playerid, COLOR_GREY, " You are not the required level to create that!");
        if(PlayerInfo[playerid][pMats] > 24) {
            weapon = 8; price = 25;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }
    else if(strcmp(x_weapon,"ak47",true) == 0) {
        if(PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_GREY, " You are not a Gold VIP+!");
        if(PlayerInfo[playerid][pMats] >= 10000) {
            weapon = 30; price = 10000;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }
    else if(strcmp(x_weapon,"golfclub",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 200) return SendClientMessageEx(playerid, COLOR_GREY, " You are not the required level to create that!");
        if(PlayerInfo[playerid][pMats] > 24) {
            weapon = 2; price = 25;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"poolcue",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 200) return SendClientMessageEx(playerid, COLOR_GREY, " You are not the required level to create that!");
        if(PlayerInfo[playerid][pMats] > 24) {
            weapon = 7; price = 25;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"shovel",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 100) return SendClientMessageEx(playerid, COLOR_GREY, " You are not the required level to create that!");
        if(PlayerInfo[playerid][pMats] > 24) {
            weapon = 6; price = 25;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"cane",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 50) return SendClientMessageEx(playerid, COLOR_GREY, " You are not the required level to create that!");
        if(PlayerInfo[playerid][pMats] > 24) {
            weapon = 15; price = 25;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"baseballbat",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 50) return SendClientMessageEx(playerid, COLOR_GREY, " You are not the required level to create that!");
        if(PlayerInfo[playerid][pMats] > 24) {
            weapon = 5; price = 25;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"knuckles",true) == 0) {
        if(PlayerInfo[playerid][pMats] > 24) {
            weapon = 1; price = 25;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"sdpistol",true) == 0) {
        if(PlayerInfo[playerid][pMats] > 99) {
            weapon = 23; price = 100;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"flowers",true) == 0) {
        if(PlayerInfo[playerid][pMats] > 24) {
            weapon = 14; price = 25;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"deagle",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 100) return SendClientMessageEx(playerid, COLOR_GREY, " You are not the required level to create that!");
        if(PlayerInfo[playerid][pMats] > 1999) {
            weapon = 24; price = 2000;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"mp5",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 50) return SendClientMessageEx(playerid, COLOR_GREY, " You are not the required level to create that!");
        if(PlayerInfo[playerid][pMats] > 399) {
            weapon = 29; price = 400;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"uzi",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 400) return SendClientMessageEx(playerid, COLOR_GREY, "You're not a high enough level to craft this item!");
        if(PlayerInfo[playerid][pMats] > 1249) {
            weapon = 28; price = 1250;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"tec9",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 400) return SendClientMessageEx(playerid, COLOR_GREY, "You're not a high enough level to craft this item!");
        if(PlayerInfo[playerid][pMats] > 1249) {
            weapon = 32; price = 1250;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"shotgun",true) == 0) {
        if(PlayerInfo[playerid][pMats] > 199) {
            weapon = 25; price = 200;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else if(strcmp(x_weapon,"9mm",true) == 0) {
        if(PlayerInfo[playerid][pMats] > 149) {
            weapon = 22; price = 150;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }



    else if(strcmp(x_weapon,"rifle",true) == 0) {
        if(PlayerInfo[playerid][pArmsSkill] < 50) return SendClientMessageEx(playerid, COLOR_GREY, " You are not the required level to create that!");
        if(PlayerInfo[playerid][pMats] > 999) {
            weapon = 33; price = 1000;
        }
        else {
            SendClientMessageEx(playerid,COLOR_GREY,"   Not enough Materials for that Weapon!");
            return 1;
        }
    }

    else { SendClientMessageEx(playerid,COLOR_GREY,"   Invalid Weapon name!"); return 1; }
    if (ProxDetectorS(5.0, playerid, giveplayerid)) {
        if(PlayerInfo[giveplayerid][pConnectHours] < 2 || PlayerInfo[giveplayerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "That person is currently restricted from possessing weapons!");

        if(giveplayerid == playerid) {
            format(string, sizeof(string), "   You have given yourself a %s.", x_weapon);
            PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
            SendClientMessageEx(playerid, COLOR_GRAD1, string);
            PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
            switch( PlayerInfo[playerid][pSex] ) {
                case 1: format(string, sizeof(string), "* %s created a Gun from Materials, and hands it to himself.", GetPlayerNameEx(playerid));
                case 2: format(string, sizeof(string), "* %s created a Gun from Materials, and hands it to herself.", GetPlayerNameEx(playerid));
            }
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            GivePlayerValidWeapon(playerid,weapon,50000);
            PlayerInfo[playerid][pMats] -= price;
            if(weapon > 15)
			{
				if(PlayerInfo[playerid][pDonateRank] == 2 || PlayerInfo[playerid][pDonateRank] == 3)
 				{
  					PlayerInfo[playerid][pArmsSkill] += 2;
 				}
  				else if(PlayerInfo[playerid][pDoubleEXP] > 0 && PlayerInfo[playerid][pDonateRank] < 2)
				{
					format(string, sizeof(string), "You have gained 2 arms skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
					PlayerInfo[playerid][pArmsSkill] += 2;
				}
 				else
  				{
  					PlayerInfo[playerid][pArmsSkill]++;
   				}
            }
            if(PlayerInfo[playerid][pAdmin] < 3) {
                SetPVarInt(playerid, "ArmsTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_ARMSTIMER);
            }
            if(PlayerInfo[playerid][pArmsSkill] == 50)
            { SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Arms Dealer Skill is now Level 2, more weapons are available to sell."); }
            else if(PlayerInfo[playerid][pArmsSkill] == 100)
            { SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Arms Dealer Skill is now Level 3, more weapons are available to sell."); }
            else if(PlayerInfo[playerid][pArmsSkill] == 200)
            { SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Arms Dealer Skill is now Level 4, more weapons are available to sell."); }
            else if(PlayerInfo[playerid][pArmsSkill] == 400)
            { SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Arms Dealer Skill is now Level 5, more weapons are available to sell."); }
            return 1;
        }

        format(string, sizeof(string), "* You offered %s to buy a %s.", GetPlayerNameEx(giveplayerid), x_weapon);
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
        format(string, sizeof(string), "* Arms Dealer %s wants to sell you a %s, (type /accept weapon) to buy.", GetPlayerNameEx(playerid), x_weapon);
        SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
        GunOffer[giveplayerid] = playerid;
		GunStorageID[giveplayerid] = storageid;
        GunId[giveplayerid] = weapon;
        GunMats[giveplayerid] = price;
	 	SetPVarInt(giveplayerid, "WeaponSeller_SQLId", GetPlayerSQLId(playerid));
        if(PlayerInfo[playerid][pAdmin] < 3) {
            SetPVarInt(playerid, "ArmsTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_ARMSTIMER);
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
        return 1;
    }
	return 1;
}