/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Treasure System

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

FoundTreasure(playerid)
{
	new szMessage[128];

	switch(PlayerInfo[playerid][pTreasureSkill])
	{
	    case 1..149:
	    {
	        new FoundAnything = Random(1, 100);
	        if(FoundAnything >= 1 && FoundAnything <= 50)
	        {
	            new ItemFound = Random(1, 10);
	            if(ItemFound >= 1 && ItemFound <= 2)
	            {
	                SetPVarInt(playerid, "junkmetal", GetPVarInt(playerid, "junkmetal")+1);
	                SaveTreasureInventory(playerid);

	                format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds junk metal.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	            }
	            else if(ItemFound >= 3 && ItemFound <= 4)
	            {
	                SetPVarInt(playerid, "newcoin", GetPVarInt(playerid, "newcoin")+1);
	                SaveTreasureInventory(playerid);

	                format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a new coin.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	            }
                else if(ItemFound >= 5 && ItemFound <= 6)
	            {
	                SetPVarInt(playerid, "oldcoin", GetPVarInt(playerid, "oldcoin")+1);
	                SaveTreasureInventory(playerid);

	                format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a old coin.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	            }
	            else if(ItemFound >= 7 && ItemFound <= 8)
	            {
	                SetPVarInt(playerid, "brokenwatch", GetPVarInt(playerid, "brokenwatch")+1);
	                SaveTreasureInventory(playerid);

	                format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a broken watch.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	            }
	            else if(ItemFound >= 9 && ItemFound <= 10)
	            {
	                SetPVarInt(playerid, "oldkey", GetPVarInt(playerid, "oldkey")+1);
	                SaveTreasureInventory(playerid);

	                format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a old key.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	            }
	        }
	        else
	        {
	            SendClientMessageEx(playerid, COLOR_WHITE, "You did not discover anything.");

	            format(szMessage, 128, "%s's metal detector has seemed to malfunctioned", GetPlayerNameEx(playerid));
  				ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	        }
	    }
	    case 150..299:
	    {
	        new FoundAnything = Random(1, 100);
	        if(FoundAnything >= 1 && FoundAnything <= 75)
	        {
	            new ItemFound = Random(1, 10);
         		if(ItemFound >= 1 && ItemFound <= 2)
          		{
       	    		SetPVarInt(playerid, "junkmetal", GetPVarInt(playerid, "junkmetal")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds junk metal.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
           		}
            	else if(ItemFound == 3 && ItemFound <= 4)
            	{
      	    		SetPVarInt(playerid, "newcoin", GetPVarInt(playerid, "newcoin")+1);
        	    	SaveTreasureInventory(playerid);

        	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a new coin.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
            	else if(ItemFound == 5 && ItemFound <= 6)
            	{
        	    	SetPVarInt(playerid, "oldcoin", GetPVarInt(playerid, "oldcoin")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a old coin.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
            	else if(ItemFound == 7)
            	{
        	    	SetPVarInt(playerid, "brokenwatch", GetPVarInt(playerid, "brokenwatch")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a broken watch.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
            	else if(ItemFound == 8 || ItemFound == 9)
            	{
        	    	SetPVarInt(playerid, "oldkey", GetPVarInt(playerid, "oldkey")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a old key.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
				else if(ItemFound == 10)
				{
				    new VeryRare = Random(1, 90);
				    if(VeryRare >= 1 && VeryRare <= 30)
				    {
				        SetPVarInt(playerid, "goldwatch", GetPVarInt(playerid, "goldwatch")+1);
	            	    SaveTreasureInventory(playerid);

	            	    format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a gold watch!", GetPlayerNameEx(playerid));
  						ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    }
				    else if(VeryRare >= 31 && VeryRare <= 60)
				    {
				        SetPVarInt(playerid, "silvernugget", GetPVarInt(playerid, "silvernugget")+1);
	            	    SaveTreasureInventory(playerid);

	            	    format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a silver nugget!", GetPlayerNameEx(playerid));
  						ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    }
				    else if(VeryRare >= 61 && VeryRare <= 90)
				    {
				        SetPVarInt(playerid, "goldnugget", GetPVarInt(playerid, "goldnugget")+1);
	            	    SaveTreasureInventory(playerid);

	            	    format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a gold nugget!", GetPlayerNameEx(playerid));
  						ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    }
				}
	        }
	        else
	        {
	            SendClientMessageEx(playerid, COLOR_WHITE, "You did not discover anything.");

	            format(szMessage, 128, "%s's metal detector has seemed to malfunctioned", GetPlayerNameEx(playerid));
  				ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	        }
	    }
	    case 300..499:
	    {
	        new FoundAnything = Random(1, 125);
	        if(FoundAnything >= 1 && FoundAnything <= 75)
	        {
        		new ItemFound = Random(1, 10);
         		if(ItemFound >= 1 && ItemFound <= 2)
          		{
       	    		SetPVarInt(playerid, "junkmetal", GetPVarInt(playerid, "junkmetal")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds junk metal.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
           		}
            	else if(ItemFound == 3 && ItemFound <= 4)
            	{
      	    		SetPVarInt(playerid, "newcoin", GetPVarInt(playerid, "newcoin")+1);
        	    	SaveTreasureInventory(playerid);

        	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a new coin.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
            	else if(ItemFound == 5 && ItemFound <= 6)
            	{
        	    	SetPVarInt(playerid, "oldcoin", GetPVarInt(playerid, "oldcoin")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a old coin.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
            	else if(ItemFound == 7)
            	{
        	    	SetPVarInt(playerid, "brokenwatch", GetPVarInt(playerid, "brokenwatch")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a broken watch.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
            	else if(ItemFound == 8 || ItemFound == 9)
            	{
        	    	SetPVarInt(playerid, "oldkey", GetPVarInt(playerid, "oldkey")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a old key.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
				else if(ItemFound == 10)
				{
				    new VeryRare = Random(1, 90);
				    if(VeryRare >= 1 && VeryRare <= 30)
				    {
				        SetPVarInt(playerid, "goldwatch", GetPVarInt(playerid, "goldwatch")+1);
	            	    SaveTreasureInventory(playerid);

	            	    format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a gold watch!", GetPlayerNameEx(playerid));
  						ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    }
				    else if(VeryRare >= 31 && VeryRare <= 60)
				    {
				        SetPVarInt(playerid, "silvernugget", GetPVarInt(playerid, "silvernugget")+1);
	            	    SaveTreasureInventory(playerid);

	            	    format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a silver nugget!", GetPlayerNameEx(playerid));
  						ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    }
				    else if(VeryRare >= 61 && VeryRare <= 90)
				    {
				        SetPVarInt(playerid, "goldnugget", GetPVarInt(playerid, "goldnugget")+1);
	            	    SaveTreasureInventory(playerid);

	            	    format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a gold nugget!", GetPlayerNameEx(playerid));
  						ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    }
				}
	        }
	        else
	        {
	            SendClientMessageEx(playerid, COLOR_WHITE, "You did not discover anything.");

	            format(szMessage, 128, "%s's metal detector has seemed to malfunctioned", GetPlayerNameEx(playerid));
  				ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	        }
	    }
		case 500..9999:
		{
		    new FoundAnything = Random(1, 125);
	        if(FoundAnything >= 1 && FoundAnything <= 75)
	        {
        		new ItemFound = Random(1, 10);
         		if(ItemFound >= 1 && ItemFound <= 2)
          		{
       	    		SetPVarInt(playerid, "junkmetal", GetPVarInt(playerid, "junkmetal")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds junk metal.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
           		}
            	else if(ItemFound == 3 && ItemFound <= 4)
            	{
      	    		SetPVarInt(playerid, "newcoin", GetPVarInt(playerid, "newcoin")+1);
        	    	SaveTreasureInventory(playerid);

        	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a new coin.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
            	else if(ItemFound == 5 && ItemFound <= 6)
            	{
        	    	SetPVarInt(playerid, "oldcoin", GetPVarInt(playerid, "oldcoin")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a old coin.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
            	else if(ItemFound == 7)
            	{
        	    	SetPVarInt(playerid, "brokenwatch", GetPVarInt(playerid, "brokenwatch")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a broken watch.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
            	else if(ItemFound == 8)
            	{
        	    	SetPVarInt(playerid, "oldkey", GetPVarInt(playerid, "oldkey")+1);
         	    	SaveTreasureInventory(playerid);

         	    	format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a old key.", GetPlayerNameEx(playerid));
  					ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
				else if(ItemFound == 9 || ItemFound == 10)
				{
				    new VeryRare = Random(1, 100);
				    if(VeryRare >= 1 && VeryRare <= 35)
				    {
				        SetPVarInt(playerid, "goldwatch", GetPVarInt(playerid, "goldwatch")+1);
	            	    SaveTreasureInventory(playerid);

	            	    format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a gold watch!", GetPlayerNameEx(playerid));
  						ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    }
				    else if(VeryRare >= 36 && VeryRare <= 65)
				    {
				        SetPVarInt(playerid, "silvernugget", GetPVarInt(playerid, "silvernugget")+1);
	            	    SaveTreasureInventory(playerid);

	            	    format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a silver nugget!", GetPlayerNameEx(playerid));
  						ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    }
				    else if(VeryRare >= 66 && VeryRare <= 99)
				    {
				        SetPVarInt(playerid, "goldnugget", GetPVarInt(playerid, "goldnugget")+1);
	            	    SaveTreasureInventory(playerid);

	            	    format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a gold nugget!", GetPlayerNameEx(playerid));
  						ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				    }
				    else if(VeryRare == 100)
				    {
				        SetPVarInt(playerid, "treasure", GetPVarInt(playerid, "treasure")+1);
	            	    SaveTreasureInventory(playerid);

	            	    format(szMessage, 128, "%s's sweeps the ground with a metal detector and finds a hidden treasure!", GetPlayerNameEx(playerid));
  						ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

  						format(szMessage, 128, "{AA3333}AdmWarning{FFFF00}: %s has just found hidden treasure ($1,000,000)", GetPlayerNameEx(playerid));
						ABroadCast(COLOR_YELLOW, szMessage, 2);
				    }
				}
	        }
	        else
	        {
	            SendClientMessageEx(playerid, COLOR_WHITE, "You did not discover anything.");

	            format(szMessage, 128, "%s's metal detector has seemed to malfunctioned", GetPlayerNameEx(playerid));
  				ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	        }
		}
	}
	return 1;
}


CMD:search(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 22 && PlayerInfo[playerid][pJob2] != 22 && PlayerInfo[playerid][pJob3] != 22) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not a treasure hunter.");
	}
	else if(PlayerInfo[playerid][pMetalDetector] == 0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a metal detector. You can recieve one from a craftsman.");
	}
	else if(IsPlayerInAnyVehicle(playerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not allowed to metal detect while in a vehicle. " );
	}
	else if(gettime()-GetPVarInt(playerid, "LastScan") < GetPVarInt(playerid, "ScanReload")) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "Your metal detector is still charging.");
	}

	else if(!GetPVarType(playerid, "HiddenTreasure")) { // New Treasure
 		SetPVarInt(playerid, "HiddenTreasure", random(sizeof(HiddenTreasure)));
	}

	new
		szMessage[128],
		Float:distance = GetPlayerDistanceFromPoint(playerid, HiddenTreasure[GetPVarInt(playerid, "HiddenTreasure")][0], HiddenTreasure[GetPVarInt(playerid, "HiddenTreasure")][1], HiddenTreasure[GetPVarInt(playerid, "HiddenTreasure")][2]);

    if(IsPlayerInArea(playerid, 402.2964, 737.5547, -1923.9410, -1752.8732) && distance > 3)
  	{
   		PlayerInfo[playerid][pMetalDetector]--;

   		if(PlayerInfo[playerid][pMetalDetector] == 1) {
			SendClientMessageEx(playerid, COLOR_WHITE, "INFO: You only have 1 metal detector charge left.");
		}

        SetPlayerCheckpoint(playerid,HiddenTreasure[GetPVarInt(playerid, "HiddenTreasure")][0], HiddenTreasure[GetPVarInt(playerid, "HiddenTreasure")][1], HiddenTreasure[GetPVarInt(playerid, "HiddenTreasure")][2], 3);
        SetTimerEx("DisableCheckPoint", 2000, 0, "i", playerid);

   		format(szMessage, 128, "You are %f meters away from the treasure. ", distance);
     	SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

      	format(szMessage, 128, "%s sweeps the ground with a metal detector.", GetPlayerNameEx(playerid));
       	ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

        if(PlayerInfo[playerid][pTreasureSkill] >=0 && PlayerInfo[playerid][pTreasureSkill] <= 24) SetPVarInt(playerid, "ScanReload", 20);
		else if(PlayerInfo[playerid][pTreasureSkill] >=25 && PlayerInfo[playerid][pTreasureSkill] <= 299) SetPVarInt(playerid, "ScanReload", 15);
		else if(PlayerInfo[playerid][pTreasureSkill] >=300 && PlayerInfo[playerid][pTreasureSkill] <= 599) SetPVarInt(playerid, "ScanReload", 10);
		else if(PlayerInfo[playerid][pTreasureSkill] >=600) SetPVarInt(playerid, "ScanReload", 5);

  		SetPVarInt(playerid, "LastScan", gettime());

	}
 	else if(distance <= 3) // Finds Treasure
  	{
  	    FoundTreasure(playerid);
  	    PlayerInfo[playerid][pMetalDetector]--;
		/*if(PlayerInfo[playerid][pDoubleEXP] > 0)
		{
			format(szMessage, 128, "You have gained 2 treasure hunting skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMessage);
			PlayerInfo[playerid][pTreasureSkill] += 2;
		}
		else ++PlayerInfo[playerid][pTreasureSkill];*/
		++PlayerInfo[playerid][pTreasureSkill];
  	    DeletePVar(playerid, "HiddenTreasure");

  	    if(PlayerInfo[playerid][pMetalDetector] == 1) {
			SendClientMessageEx(playerid, COLOR_WHITE, "INFO: You only have 1 metal detector charge left.");
		}

  	    if(PlayerInfo[playerid][pTreasureSkill] == 25) {
  	        SendClientMessageEx(playerid, COLOR_WHITE, "* Your Treasure Hunting Skill is now Level 2, the time it takes for your metal detector to charge is now 15 seconds!");
  	    }
  	    if(PlayerInfo[playerid][pTreasureSkill] == 150) {
  	        SendClientMessageEx(playerid, COLOR_WHITE, "* Your Treasure Hunting Skill is now Level 3, your chance to find a rare is now 10%!");
  	    }
  	    if(PlayerInfo[playerid][pTreasureSkill] == 300) {
  	        SendClientMessageEx(playerid, COLOR_WHITE, "* Your Treasure Hunting Skill is now Level 4, the time it takes for your metal detector to charge is now 10 seconds!");
  	    }
  	    if(PlayerInfo[playerid][pTreasureSkill] == 600) {
  	        SendClientMessageEx(playerid, COLOR_WHITE, "* Your Treasure Hunting Skill is now Level 5, your chance to find a rare is now 20%!");
  	    }
   	}
    else {
    	SendClientMessageEx(playerid, COLOR_GREY, "You are not at a beach.");
    }
	return 1;
}

CMD:selltreasure(playerid, params[])
{
	new choice[32], amount;
    if(sscanf(params, "s[32]d", choice, amount))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /selltreasure [name] [amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: junkmetal ($150), newcoin ($50), oldcoin ($100), brokenwatch ($5), oldkey ($20), goldwatch ($50000)");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: goldnugget ($100000), silvernugget ($25000), treasurechest ($1000000)");
		return 1;
	}
	else if(!IsPlayerInRangeOfPoint(playerid, 3 , 164.9517, -1779.5931, 4.3000)) {
	    return SendClientMessageEx(playerid, COLOR_GREY, "You are not at a treasure sell point.");
	}
	else if(amount < 0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You can't sell negative of an item.");
	}
	new szMessage[128];
	if(strcmp(choice, "junkmetal", true) == 0) {
	    if(amount <= GetPVarInt(playerid, "junkmetal") && amount > 0) {
	        format(szMessage, 128, "You have sold %d junk metals for $%d.", amount, amount*150);
	        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	        GivePlayerCash(playerid, amount*150);
	        SetPVarInt(playerid, "junkmetal", GetPVarInt(playerid, "junkmetal")-amount);
	        SaveTreasureInventory(playerid);
	    }
	    else {
	        SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough of that item to sell.");
	    }
	}
	else if(strcmp(choice, "newcoin", true) == 0) {
	    if(amount <= GetPVarInt(playerid, "newcoin") && amount > 0) {
	        format(szMessage, 128, "You have sold %d new coins for $%d.", amount, amount*50);
	        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	        GivePlayerCash(playerid, amount*50);
	        SetPVarInt(playerid, "newcoin", GetPVarInt(playerid, "newcoin")-amount);
	        SaveTreasureInventory(playerid);
	    }
	    else {
	        SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough of that item to sell.");
	    }
	}
	else if(strcmp(choice, "oldcoin", true) == 0) {
	    if(amount <= GetPVarInt(playerid, "oldcoin") && amount > 0) {
	        format(szMessage, 128, "You have sold %d old coins for $%d.", amount, amount*100);
	        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	        GivePlayerCash(playerid, amount*100);
	        SetPVarInt(playerid, "oldcoin", GetPVarInt(playerid, "oldcoin")-amount);
	        SaveTreasureInventory(playerid);
	    }
	    else {
	        SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough of that item to sell.");
	    }
	}
	else if(strcmp(choice, "brokenwatch", true) == 0) {
	    if(amount <= GetPVarInt(playerid, "brokenwatch") && amount > 0) {
	        format(szMessage, 128, "You have sold %d broken watchs for $%d.", amount, amount*5);
	        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	        GivePlayerCash(playerid, amount*5);
	        SetPVarInt(playerid, "brokenwatch", GetPVarInt(playerid, "brokenwatch")-amount);
	        SaveTreasureInventory(playerid);
	    }
	    else {
	        SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough of that item to sell.");
	    }
	}
	else if(strcmp(choice, "oldkey", true) == 0) {
	    if(amount <= GetPVarInt(playerid, "oldkey") && amount > 0) {
	        format(szMessage, 128, "You have sold %d old keys for $%d.", amount, amount*20);
	        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	        GivePlayerCash(playerid, amount*20);
	        SetPVarInt(playerid, "oldkey", GetPVarInt(playerid, "oldkey")-amount);
	        SaveTreasureInventory(playerid);
	    }
	    else {
	        SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough of that item to sell.");
	    }
	}
	else if(strcmp(choice, "goldwatch", true) == 0) {
	    if(amount <= GetPVarInt(playerid, "goldwatch") && amount > 0) {
	        format(szMessage, 128, "You have sold %d gold watchs for $%d.", amount, amount*50000);
	        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	        GivePlayerCash(playerid, amount*50000);
	        SetPVarInt(playerid, "goldwatch", GetPVarInt(playerid, "goldwatch")-amount);
	        SaveTreasureInventory(playerid);
	    }
	    else {
	        SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough of that item to sell.");
	    }
	}
	else if(strcmp(choice, "goldnugget", true) == 0) {
	    if(amount <= GetPVarInt(playerid, "goldnugget") && amount > 0) {
	        format(szMessage, 128, "You have sold %d gold nuggets for $%d.", amount, amount*100000);
	        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	        GivePlayerCash(playerid, amount*100000);
	        SetPVarInt(playerid, "goldnugget", GetPVarInt(playerid, "goldnugget")-amount);
	        SaveTreasureInventory(playerid);
	    }
	    else {
	        SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough of that item to sell.");
	    }
	}
	else if(strcmp(choice, "silvernugget", true) == 0) {
	    if(amount <= GetPVarInt(playerid, "silvernugget") && amount > 0) {
	        format(szMessage, 128, "You have sold %d silver nuggets for $%d.", amount, amount*25000);
	        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	        GivePlayerCash(playerid, amount*25000);
	        SetPVarInt(playerid, "silvernugget", GetPVarInt(playerid, "silvernugget")-amount);
	        SaveTreasureInventory(playerid);
	    }
	    else {
	        SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough of that item to sell.");
	    }
	}
	else if(strcmp(choice, "treasurechest", true) == 0) {
	    if(amount <= GetPVarInt(playerid, "treasurechest") && amount > 0) {
	        format(szMessage, 128, "You have sold %d treasure chests for $%d.", amount, amount*1000000);
	        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	        GivePlayerCash(playerid, amount*1000000);
	        SetPVarInt(playerid, "treasure", GetPVarInt(playerid, "treasure")-amount);
	        SaveTreasureInventory(playerid);
	    }
	    else {
	        SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough of that item to sell.");
	    }
	}
	return 1;
}