/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Gift System

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

CMD:gifts(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
     	if(Gifts == 0)
     	{
           	Gifts = 1;
           	new sString[41 + MAX_PLAYER_NAME];
			format( sString, sizeof( sString ), "AdmCmd: %s has enabled the /gift command.", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, sString, 1337 );
		}
		else
		{
		    Gifts = 0;
		    new sString[41 + MAX_PLAYER_NAME];
	   		format( sString, sizeof( sString ), "AdmCmd: %s has disabled the /gift command.", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, sString, 1337 );
		}
	}
	return 1;
}

CMD:vipgifts(playerid, params[])
{
	new string[128];

    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
     	if(VIPGifts == 0)
     	{
           	VIPGifts = 1;
           	new sString[128];
			format( sString, sizeof( sString ), "%s would like for you to come to Club VIP for free gifts and great times [20 minutes remains]", GetPlayerNameEx(playerid));
			SendVIPMessage(COLOR_LIGHTGREEN, sString);
			VIPGiftsTimeLeft = 20;
			format(VIPGiftsName, sizeof(VIPGiftsName), "%s", GetPlayerNameEx(playerid));
		}
		else
		{
		    VIPGifts = 0;
		    new sString[128];
	   		format( sString, sizeof( sString ), "AdmCmd: %s has disabled the /getgift command early", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, sString, 1337 );
			format(string, sizeof(string), "Club VIP is no longer giving away free gifts. Thanks for coming!", VIPGiftsName, VIPGiftsTimeLeft);
			SendVIPMessage(COLOR_LIGHTGREEN, string);
			VIPGiftsTimeLeft = 0;
		}
	}
	return 1;
}

CMD:resetgift(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /resetgift [player]");

    if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		if(IsPlayerConnected(giveplayerid))
		{
	   		if(PlayerInfo[giveplayerid][pGiftTime] > 0)
    		{
				new string[128];
	    	    PlayerInfo[giveplayerid][pGiftTime] = 0;
	     	    format(string, sizeof(string), "%s's gift timer has been reset", GetPlayerNameEx(giveplayerid));
	     	    SendClientMessageEx(playerid, COLOR_YELLOW, string);
   			}
   			else
   			{
	   		    SendClientMessageEx(playerid, COLOR_GRAD2, "That players gift timer is already on 0!");
			}
		}
		else
		{
   			SendClientMessageEx(playerid, COLOR_GRAD2, "That person is not connected.");
		}
	}
	return 1;
}

CMD:giftnear(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
       	new range;
		if(sscanf(params, "d", range)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /giftnear [range]");

		if(range < 1)
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "The range can not be lower than 1.");
			return 1;
		}

        new string[128];
        new count;
        //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(ProxDetectorS(range, playerid, i))
				{
					if(PlayerInfo[i][pGiftTime] <= 0)
					{
						GiftPlayer(playerid, i);
						count++;
					}
				}
			}	
        }
        format(string, sizeof(string), "You have gifted everyone (%d) nearby.", count);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }
    return 1;
}

CMD:resetgiftall(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1338)
	{
		new string[128];
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has reset everyone's gift timer.", GetPlayerNameEx(playerid));
		ABroadCast(COLOR_YELLOW, string, 2);
		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				PlayerInfo[i][pGiftTime] = 0;
			}	
		}
	}
	return 1;
}

CMD:gift(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gift [player]");

    if(PlayerInfo[playerid][pAdmin] >= 2)
	{
 		if(Gifts == 1 || PlayerInfo[playerid][pAdmin] >= 1337)
   		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    if(PlayerInfo[giveplayerid][pGiftTime] > 0)
	           	{
	               	SendClientMessageEx(playerid, COLOR_GRAD2, "The person has already got a gift in the last 5 hours !");
					return 1;
	           	}
			    GiftPlayer(playerid, giveplayerid);
			}
			else
			{
			    SendClientMessageEx(playerid, COLOR_GRAD2, "That person is not connected.");
			}
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GRAD2, "This command is not activated!");
		}
	}
	return 1;
}

CMD:giftall(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
    	if(GiftAllowed || PlayerInfo[playerid][pAdmin] >= 99999)
     	{
			new string[128];
      		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has just sent a gift to all players.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW, string, 2);
			GiftAllowed = 0;
			//foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					GiftPlayer(playerid, i);
				}	
			}
		}
		else
		{
		    return SendClientMessageEx(playerid, COLOR_GRAD2, "This command has already been used, wait until the next paycheck!");
		}
	}
	return 1;
}

CMD:giftreset(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /giftreset [player]");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	if(PlayerInfo[giveplayerid][pGiftTime] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "This player is already able to receive a gift.");
	new string[128];
	format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has reset %s's gift timer.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ABroadCast(COLOR_YELLOW, string, 2);
	PlayerInfo[giveplayerid][pGiftTime] = 0;
	return 1;
}

CMD:setcode(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 99999 || PlayerInfo[playerid][pShopTech] >= 3)
	{
		new code[32], string[128], bypass;
		if (sscanf(params, "s[32]d", code, bypass))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Usage: /setcode <code> <bypass 0/1>");
			SendClientMessageEx(playerid, COLOR_GREY, "If code is 'off', the active code will be disabled.");
			return 1;
		}

		format(GiftCode, 32, code);
		GiftCodeBypass = bypass;
        g_mysql_SaveMOTD();
		mysql_function_query(MainPipeline, "UPDATE `accounts` SET `GiftCode` = 0;", false, "OnQueryFinish", "i", SENDDATA_THREAD);
		//foreach(new i : Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pGiftCode] == 1)
					PlayerInfo[i][pGiftCode] = 0;
			}		
		}


		if (strcmp(code, "off") == 0)
		{
			format(string, sizeof(string), "You have disabled the gift code.");
		}
		else
		{
			format(string, sizeof(string), "You have set the gift code to \"%s\".", code);
		}

		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}

	return 1;
}

CMD:giftcode(playerid, params[])
{
	if (isnull(params))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /giftcode <code>");
		return 1;
	}
	if(PlayerInfo[playerid][pLevel] < 3) {
		SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to use this command.");
		return 1;
	}
	if (strcmp(GiftCode, "off") == 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "No gift codes are currently active.");
		return 1;
	}
	else
	{
	    if (strcmp(params, GiftCode) == 0)
		{
		    if(GiftCodeBypass > 0)
		    {
		        if(PlayerInfo[playerid][pGiftCode] == 0)
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "The code you entered was valid!");
		        	PlayerInfo[playerid][pGiftCode] = 1;
		        	GiftPlayer(MAX_PLAYERS, playerid);
				}
				else
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "You have already entered the gift code.");
				}
			}
			else
			{
			    if(PlayerInfo[playerid][pGiftTime] == 0)
			    {
					if(PlayerInfo[playerid][pGiftCode] == 0)
					{
					    SendClientMessageEx(playerid, COLOR_WHITE, "The code you entered was valid!");
			  			PlayerInfo[playerid][pGiftCode] = 1;
			  			GiftPlayer(MAX_PLAYERS, playerid);
					}
					else
					{
					    SendClientMessageEx(playerid, COLOR_GREY, "You have already entered the gift code.");
					}
			    }
			    else
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "You have already received a gift in the last 5 hours.");
			    }
			}
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "You have entered a invalid gift code.");
		}
	}
	return 1;
}

CMD:dynamicgift(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You must be on foot to use this command.");
			return 1;
		}

		new string[128], Float:Position[4];
		if(dynamicgift == 0)
		{
			GetPlayerPos(playerid, Position[0], Position[1], Position[2]);
			GetPlayerFacingAngle(playerid, Position[3]);
			dynamicgift = CreateDynamicObject(19054, Position[0], Position[1], Position[2]-0.4, 0.0, 0.0, Position[3], -1, -1, -1, 200.0);
			dynamicgift3DText = CreateDynamic3DTextLabel("/getgift\nTo reach inside.",COLOR_YELLOW,Position[0], Position[1], Position[2]+0.25,8.0);
			SetPlayerPos(playerid, Position[0], Position[1], Position[2]+3);
			format(string, sizeof(string), "AdmCmd: %s has placed the dynamic gift.", GetPlayerNameEx(playerid));
			
			if(IsDynamicGiftBoxEnabled == true)
			{
				SendClientMessageEx(playerid, COLOR_RED, "Due to the Dynamic Giftbox being enabled, you may view the content inside the giftbox.");
				
				if(PlayerInfo[playerid][pAdmin] == 99999 || PlayerInfo[playerid][pShopTech] >= 3) 
				{
					SendClientMessageEx(playerid, COLOR_RED, "Note: You must fill up the giftbox with /dgedit.");
				}
				ShowPlayerDynamicGiftBox(playerid);
			}
			ABroadCast( COLOR_LIGHTRED, string, 1337);
		}
		else
		{
			DestroyDynamicObject(dynamicgift);
			dynamicgift = 0;
			DestroyDynamic3DTextLabel( Text3D:dynamicgift3DText );
			format(string, sizeof(string), "AdmCmd: %s has destroyed the dynamic gift.", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, string, 1337);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:nextgift(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pGiftTime] < 1)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "You're now able to receive a gift from the giftbox or the safe.");
	}
	else {	
		format(string, sizeof(string), "You will be able to receive a gift in %d minutes.", PlayerInfo[playerid][pGiftTime]);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}	
	return 1;
}

CMD:getgift(playerid, params[])
{
	new string[128], year, month, day;
	getdate(year, month, day);

	if(IsPlayerInRangeOfPoint(playerid, 3.0,2546.680908, 1403.430786, 7699.584472) || IsPlayerInRangeOfPoint(playerid, 3.0,1726.1000, 1370.1000, 1449.9000) || IsPlayerInRangeOfPoint(playerid, 3.0,1763.5000, 1432.5000, 2015.7000) || IsPlayerInRangeOfPoint(playerid, 3.0,772.4000, 1743.2000, 1938.8800))
	{
		if(PlayerInfo[playerid][pDonateRank] >= 1)
		{
			if(VIPGifts == 0 && PlayerInfo[playerid][pDonateRank] < 4)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "The safe is locked!");
				return 1;
			}
			if(PlayerInfo[playerid][pGiftTime] > 0)
			{
			    format(string, sizeof(string),"Item: Reset Gift Timer\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[17][sItemPrice]));
	    		ShowPlayerDialog( playerid, DIALOG_SHOPGIFTRESET, DIALOG_STYLE_MSGBOX, "Reset Gift Timer", string, "Purchase", "Exit" );
				SendClientMessageEx(playerid, COLOR_GRAD2, "You have already received a gift in the last 5 hours!");
				return 1;
			}
			format(string, sizeof(string), "* %s reaches inside the safe with their eyes closed.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			GiftPlayer(MAX_PLAYERS, playerid);
		}
	}
	else if(dynamicgift != 0)
	{
		new Float:Position[3];
		GetDynamicObjectPos(dynamicgift, Position[0], Position[1], Position[2]);

		if(IsPlayerInRangeOfPoint(playerid, 5.0, Position[0], Position[1], Position[2]))
		{
			if(PlayerInfo[playerid][pLevel] >= 3)
			{
				if(PlayerInfo[playerid][pGiftTime] > 0 && (IsDynamicGiftBoxEnabled == false || (IsDynamicGiftBoxEnabled == true && !dgGoldToken)))
				{
				    format(string, sizeof(string),"Item: Reset Gift Timer\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[17][sItemPrice]));
	    			ShowPlayerDialog( playerid, DIALOG_SHOPGIFTRESET, DIALOG_STYLE_MSGBOX, "Reset Gift Timer", string, "Purchase", "Exit" );
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have already received a gift in the last 5 hours!");
					return 1;
				}
				if(IsDynamicGiftBoxEnabled == true)
				{
					if(dgGoldToken)
					{
						if(!PlayerInfo[playerid][pGoldBoxTokens]) return SendClientMessageEx(playerid, COLOR_GREY, "You have no Gold Giftbox tokens!");
						PlayerInfo[playerid][pGoldBoxTokens]--;
					}
					GiftPlayer(MAX_PLAYERS, playerid, 1);
				}
				else if(IsDynamicGiftBoxEnabled == false)
				{
					GiftPlayer(MAX_PLAYERS, playerid);
				}
				if(month == 12 && day == 25) // Christmas event.
				{
					PlayerInfo[playerid][pHungerTimer] = 0;
					PlayerInfo[playerid][pHungerDeathTimer] = 0;
					PlayerInfo[playerid][pHunger] += 83;
					
					if(PlayerInfo[playerid][pHunger] > 100) 
						PlayerInfo[playerid][pHunger] = 100;

					SendClientMessageEx(playerid, COLOR_GRAD2, "* Your hunger has been refilled!  Merry christmas!");
				}
				format(string, sizeof(string), "* %s reaches inside the bag of gifts with their eyes closed.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "* You must be at least level 3 to use this, sorry!");
			}
		}
	}
	return 1;
}

// Dynamic Giftbox
CMD:dgedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 99999 && PlayerInfo[playerid][pShopTech] < 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	new string[128], choice[32], type, amount, var;
	if(strcmp(params, "autoreset", true) == 0)
	{
		DeletePVar(playerid, "dgInputSel");
		format(string, sizeof(string), "Timer: %d min(s)\nAmount: %d\n%s", dgTimerTime, dgAmount, (dgTimer != -1)?("{FF0606}Disable"):("{00ff00}Enable"));
		return ShowPlayerDialog(playerid, DIALOG_DGRAUTORESET, DIALOG_STYLE_LIST, "Dynamic Giftbox Auto Reset - Select to modify", string, "Select", "Close");
	}
	if(sscanf(params, "s[32]dD", choice, type, amount))
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /dgedit [choice] [type] [value]");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Available Choices: Money, RimKit, Firework, 7DayGVIP, 1MonthGVIP, 7DaySVIP, 1MonthSVIP, CarSlot, ToySlot");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Available Choices: FullArmor, Firstaid, DDFlag, GateFlag, Credits, PriorityAd, HealthNArmor, Giftreset, Material");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Available Choices: Warning, Pot, Crack, PaintballToken, VIPToken, RespectPoint, CarVoucher, BuddyInvite, Laser");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Available Choices: CustomToy, AdmuteReset, NewbieMuteReset, RestrictedCarVoucher, PlatVIPVoucher");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Available Choices: AutoReset, UseGoldTokens");
		return SendClientMessageEx(playerid, COLOR_RED, "Available Types: 0 = Enable/Disable | 1 = Quantity available | 2 = Quantity Given | 3 = Category");
	}
	if(type < 0 || type > 3) 
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid Type!");
		return SendClientMessageEx(playerid, COLOR_RED, "Available Type: 0 = Enable/Disable | 1 = Quantity available | 2 = Quantity Given | 3 = Category");
	}
	if(amount < 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot choose an amount below 0!");
	if(strcmp(choice, "money", true) == 0) var = dgMoney;
	else if(strcmp(choice, "rimkit", true) == 0) var = dgRimKit;
	else if(strcmp(choice, "firework", true) == 0) var = dgFirework;
	else if(strcmp(choice, "7daygvip", true) == 0) var = dgGVIP;
	else if(strcmp(choice, "1monthgvip", true) == 0) var = dgGVIPEx;
	else if(strcmp(choice, "7daysvip", true) == 0) var = dgSVIPEx;
	else if(strcmp(choice, "1monthsvip", true) == 0) var = dgSVIP;
	else if(strcmp(choice, "carslot", true) == 0) var = dgCarSlot;
	else if(strcmp(choice, "toyslot", true) == 0) var = dgToySlot;
	else if(strcmp(choice, "fullarmor", true) == 0) var = dgArmor;
	else if(strcmp(choice, "firstaid", true) == 0) var = dgFirstaid;
	else if(strcmp(choice, "ddflag", true) == 0) var = dgDDFlag;
	else if(strcmp(choice, "gateflag", true) == 0) var = dgGateFlag;
	else if(strcmp(choice, "credits", true) == 0) var = dgCredits;
	else if(strcmp(choice, "priorityad", true) == 0) var = dgPriorityAd;
	else if(strcmp(choice, "healthnarmor", true) == 0) var = dgHealthNArmor;
	else if(strcmp(choice, "giftreset", true) == 0) var = dgGiftReset;
	else if(strcmp(choice, "material", true) == 0) var = dgMaterial;
	else if(strcmp(choice, "warning", true) == 0) var = dgWarning;
	else if(strcmp(choice, "pot", true) == 0) var = dgPot;
	else if(strcmp(choice, "crack", true) == 0) var = dgCrack;
	else if(strcmp(choice, "paintballtoken", true) == 0) var = dgPaintballToken;
	else if(strcmp(choice, "viptoken", true) == 0) var = dgVIPToken;
	else if(strcmp(choice, "respectpoint", true) == 0) var = dgRespectPoint;
	else if(strcmp(choice, "carvoucher", true) == 0) var = dgCarVoucher;
	else if(strcmp(choice, "buddyinvite", true) == 0) var = dgBuddyInvite;
	else if(strcmp(choice, "laser", true) == 0) var = dgLaser;
	else if(strcmp(choice, "customtoy", true) == 0) var = dgCustomToy;
	else if(strcmp(choice, "admutereset", true) == 0) var = dgAdmuteReset;
	else if(strcmp(choice, "newbiemutereset", true) == 0) var = dgNewbieMuteReset;
	else if(strcmp(choice, "restrictedcarvoucher", true) == 0) var = dgRestrictedCarVoucher;
	else if(strcmp(choice, "platvipvoucher", true) == 0) var = dgPlatinumVIPVoucher;
	else if(strcmp(choice, "autoreset", true) == 0) return cmd_dgedit(playerid, "autoreset");
	else if(strcmp(choice, "usegoldtokens", true) == 0)
	{
		if(dgGoldToken) dgGoldToken = 0, SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the use of a Gold Giftbox token to recieve a gift.");
		else dgGoldToken = 1, SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the use of a Gold Giftbox token to recieve a gift.");
		return 1;
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid Choice!");
	// Prepare the proper and approriate string
	switch(type)
	{
		case 0:
		{
			// Little check to make sure they're not inserting invalid values
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, COLOR_RED, "0 = Disabled | 1 - Enabled");
			switch(amount)
			{
				case 0: format(string, sizeof(string), "You have disabled the gift.");
				case 1: format(string, sizeof(string), "You have enabled the gift.");
				default: return true;
			}
		}
		case 1:
		{
			format(string, sizeof(string), "You have set the gift quantity to %s.", number_format(amount));
		}
		case 2:
		{
			format(string, sizeof(string), "You have set the gift amount to %s.", number_format(amount));
		}
		case 3:
		{
			if(amount < 0 || amount > 3) return SendClientMessageEx(playerid, COLOR_RED, "0 = Common | 1 = Less Common | 2 = Rare | 3 = Super Rare");
			switch(amount)
			{
				case 0: format(string, sizeof(string), "You have set the category to Common.");
				case 1: format(string, sizeof(string), "You have set the category to Less Common.");
				case 2: format(string, sizeof(string), "You have set the category to Rare.");
				case 3: format(string, sizeof(string), "You have set the category to Super Rare.");
				default: return true;
			}
		}
		default: return true;
	}
	// Set the data to the variable
	dgVar[dgItems:var][type] = amount;
	// Save the GiftBox Stuff
	SaveDynamicGiftBox();
	// Send the client message
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	return true;
}

CMD:viewgiftbox(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] == 99999 || PlayerInfo[playerid][pShopTech] >= 3)
	{
		ShowPlayerDynamicGiftBox(playerid);
	}
	else
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not an Executive Administrator!");
	return true;
}

CMD:togdynamicgift(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] == 99999 || PlayerInfo[playerid][pShopTech] >= 3)
	{
		if(IsDynamicGiftBoxEnabled == false)
		{
			IsDynamicGiftBoxEnabled = true;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the Dynamic GiftBox, please use /dgedit to modify the giftbox items.");
		}
		else if(IsDynamicGiftBoxEnabled == true)
		{
			IsDynamicGiftBoxEnabled = false;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the Dynamic Giftbox.");
		}
	}
	else
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not an Executive Administrator!");
	return true;
}

CMD:giftbox(playerid, params[])
{
	if(dynamicgift != 0)
	{
		new Float: pos[3];
		SendClientMessageEx(playerid, COLOR_YELLOW, "** There is currently a giftbox placed down and we have set a checkpoint to the location of the giftbox.");
		if(CheckPointCheck(playerid)) cmd_killcheckpoint(playerid, params); //If they have a checkpoint, just remove it
		DisablePlayerCheckpoint(playerid);
		GetDynamicObjectPos(dynamicgift, pos[0], pos[1], pos[2]);
		SetPlayerCheckpoint(playerid, pos[0], pos[1], pos[2], 5);
		SetPVarInt(playerid, "GiftBoxCP", 1);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "** There is currently no giftbox placed down.");
	}
	return true;
}