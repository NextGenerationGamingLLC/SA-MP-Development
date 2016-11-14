/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Fishing System

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

stock IsAtFishPlace(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid,1.0,403.8266,-2088.7598,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,398.7553,-2088.7490,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,396.2197,-2088.6692,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,391.1094,-2088.7976,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,383.4157,-2088.7849,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,374.9598,-2088.7979,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,369.8107,-2088.7927,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,367.3637,-2088.7925,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,362.2244,-2088.7981,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,354.5382,-2088.7979,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
	}
	return 0;
}

stock FishCost(playerid, fish)
{
	if(IsPlayerConnected(playerid)) {
		new cost = 0;
		switch (fish)
		{
			case 1:
			{
				cost = 1;
			}
			case 2:
			{
				cost = 3;
			}
			case 3:
			{
				cost = 3;
			}
			case 5:
			{
				cost = 5;
			}
			case 6:
			{
				cost = 2;
			}
			case 8:
			{
				cost = 8;
			}
			case 9:
			{
				cost = 12;
			}
			case 11:
			{
				cost = 9;
			}
			case 12:
			{
				cost = 7;
			}
			case 14:
			{
				cost = 12;
			}
			case 15:
			{
				cost = 9;
			}
			case 16:
			{
				cost = 7;
			}
			case 17:
			{
				cost = 7;
			}
			case 18:
			{
				cost = 10;
			}
			case 19:
			{
				cost = 4;
			}
			case 21:
			{
				cost = 3;
			}
		}
		return cost;
	}
	return 0;
}

stock ClearFishes(playerid)
{
	if(IsPlayerConnected(playerid)) {
		Fishes[playerid][pFid1] = 0; Fishes[playerid][pFid2] = 0; Fishes[playerid][pFid3] = 0;
		Fishes[playerid][pFid4] = 0; Fishes[playerid][pFid5] = 0;
		Fishes[playerid][pWeight1] = 0; Fishes[playerid][pWeight2] = 0; Fishes[playerid][pWeight3] = 0;
		Fishes[playerid][pWeight4] = 0; Fishes[playerid][pWeight5] = 0;

		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "None");
		strmid(Fishes[playerid][pFish1], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish2], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish3], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish4], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish5], string, 0, strlen(string), 255);
	}
	return 1;
}

stock ClearFishID(playerid, fish)
{
	if(IsPlayerConnected(playerid))
	{
		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "None");
		switch (fish)
		{
			case 1:
			{
				strmid(Fishes[playerid][pFish1], string, 0, strlen(string), 255);
				Fishes[playerid][pWeight1] = 0;
				Fishes[playerid][pFid1] = 0;
			}
			case 2:
			{
				strmid(Fishes[playerid][pFish2], string, 0, strlen(string), 255);
				Fishes[playerid][pWeight2] = 0;
				Fishes[playerid][pFid2] = 0;
			}
			case 3:
			{
				strmid(Fishes[playerid][pFish3], string, 0, strlen(string), 255);
				Fishes[playerid][pWeight3] = 0;
				Fishes[playerid][pFid3] = 0;
			}
			case 4:
			{
				strmid(Fishes[playerid][pFish4], string, 0, strlen(string), 255);
				Fishes[playerid][pWeight4] = 0;
				Fishes[playerid][pFid4] = 0;
			}
			case 5:
			{
				strmid(Fishes[playerid][pFish5], string, 0, strlen(string), 255);
				Fishes[playerid][pWeight5] = 0;
				Fishes[playerid][pFid5] = 0;
			}
		}
	}
	return 1;
}

CMD:fishhelp(playerid, params[])
{
	SetPVarInt(playerid, "HelpResultCat0", 5);
	Help_ListCat(playerid, DIALOG_HELPCATOTHER1);
	return 1;
}

CMD:ofishhelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** FISH HELP *** - type a command for more infomation.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** FISHING *** /fish (Try to catch a fish)   /fishes (Show the fishes you have caught)");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** FISHING *** /throwback (Throw the last fish you caught back)   /throwbackall");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** FISHING *** /releasefish (Release one of your fishes)");
    return 1;
}


CMD:sellfish(playerid, params[])
{
	if (!IsAt247(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "   You are not in a 24-7!");
		return 1;
	}

	new fishid;
	if(sscanf(params, "d", fishid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellfish [fish]");

	new price;
	if(fishid < 1 || fishid > 5) return SendClientMessageEx(playerid, COLOR_GREY, "   Fish number cant be below 1 or above 5!");
	if(fishid == 1 && Fishes[playerid][pWeight1] < 1) { SendClientMessageEx(playerid, COLOR_GREY, "   You didnt even catch a Fish at that number(1)!"); return 1; }
	if(fishid == 2 && Fishes[playerid][pWeight2] < 1) { SendClientMessageEx(playerid, COLOR_GREY, "   You didnt even catch a Fish at that number(2)!"); return 1; }
	if(fishid == 3 && Fishes[playerid][pWeight3] < 1) { SendClientMessageEx(playerid, COLOR_GREY, "   You didnt even catch a Fish at that number(3)!"); return 1; }
	if(fishid == 4 && Fishes[playerid][pWeight4] < 1) { SendClientMessageEx(playerid, COLOR_GREY, "   You didnt even catch a Fish at that number(4)!"); return 1; }
	if(fishid == 5 && Fishes[playerid][pWeight5] < 1) { SendClientMessageEx(playerid, COLOR_GREY, "   You didnt even catch a Fish at that number(5)!"); return 1; }

	switch (fishid)
	{
		case 1:
		{
			if(Fishes[playerid][pWeight1] < 20)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "We are only interested in Fishes weighting 20 LBS or more.");
				return 1;
			}
			price = FishCost(playerid, Fishes[playerid][pFid1]);
			price = price * Fishes[playerid][pWeight1];
			GameTextForPlayer(playerid, "~g~Fish~n~~r~Sold", 3000, 1);
			format(szMiscArray, sizeof(szMiscArray), "* You have sold your %s that weights %d, for $%d.", Fishes[playerid][pFish1],Fishes[playerid][pWeight1],price);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			GivePlayerCash(playerid, price);
			ClearFishID(playerid, 1);
		}
		case 2:
		{
			if(Fishes[playerid][pWeight2] < 20)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "We are only interested in Fishes weighting 20 LBS or more.");
				return 1;
			}
			price = FishCost(playerid, Fishes[playerid][pFid2]);
			price = price * Fishes[playerid][pWeight2];
			GameTextForPlayer(playerid, "~g~Fish~n~~r~Sold", 3000, 1);
			format(szMiscArray, sizeof(szMiscArray), "* You have sold your %s that weights %d, for $%d.", Fishes[playerid][pFish2],Fishes[playerid][pWeight2],price);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			GivePlayerCash(playerid, price);
			ClearFishID(playerid, 2);
		}
		case 3:
		{
			if(Fishes[playerid][pWeight3] < 20)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "We are only interested in Fishes weighting 20 LBS or more.");
				return 1;
			}
			price = FishCost(playerid, Fishes[playerid][pFid3]);
			price = price * Fishes[playerid][pWeight3];
			GameTextForPlayer(playerid, "~g~Fish~n~~r~Sold", 3000, 1);
			format(szMiscArray, sizeof(szMiscArray), "* You have sold your %s that weights %d, for $%d.", Fishes[playerid][pFish3],Fishes[playerid][pWeight3],price);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			GivePlayerCash(playerid, price);
			ClearFishID(playerid, 3);
		}
		case 4:
		{
			if(Fishes[playerid][pWeight4] < 20)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "We are only interested in Fishes weighting 20 LBS or more.");
				return 1;
			}
			price = FishCost(playerid, Fishes[playerid][pFid4]);
			price = price * Fishes[playerid][pWeight4];
			GameTextForPlayer(playerid, "~g~Fish~n~~r~Sold", 3000, 1);
			format(szMiscArray, sizeof(szMiscArray), "* You have sold your %s that weights %d, for $%d.", Fishes[playerid][pFish4],Fishes[playerid][pWeight4],price);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			GivePlayerCash(playerid, price);
			ClearFishID(playerid, 4);
		}
		case 5:
		{
			if(Fishes[playerid][pWeight5] < 20)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "We are only interested in Fishes weighting 20 LBS or more.");
				return 1;
			}
			price = FishCost(playerid, Fishes[playerid][pFid5]);
			price = price * Fishes[playerid][pWeight5];
			GameTextForPlayer(playerid, "~g~Fish~n~~r~Sold", 3000, 1);
			format(szMiscArray, sizeof(szMiscArray), "* You have sold your %s that weights %d, for $%d.", Fishes[playerid][pFish5],Fishes[playerid][pWeight5],price);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			GivePlayerCash(playerid, price);
			ClearFishID(playerid, 5);
		}
	}
	Fishes[playerid][pLastFish] = 0;
	Fishes[playerid][pFishID] = 0;
	return 1;
}




CMD:fish(playerid, params[])
{
	if(PlayerInfo[playerid][pFishes] > 5)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You've caught enough fish for now - take a break.");
		return 1;
	}
	if(Fishes[playerid][pWeight1] > 0 && Fishes[playerid][pWeight2] > 0 && Fishes[playerid][pWeight3] > 0 && Fishes[playerid][pWeight4] > 0 && Fishes[playerid][pWeight5] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You can't carry more than five fish at a time - sell or release them first.");
		return 1;
	}

	new string[128];
	new Veh = GetPlayerVehicleID(playerid);
	if((IsAtFishPlace(playerid)) || IsABoat(Veh))
	{
		new Caught;
		new rand;
		new fstring[MAX_PLAYER_NAME];
		new Level = PlayerInfo[playerid][pFishSkill];
		if(Level >= 0 && Level <= 50) { Caught = random(20)-7; }
		else if(Level >= 51 && Level <= 100) { Caught = random(50)-20; }
		else if(Level >= 101 && Level <= 200) { Caught = random(100)-50; }
		else if(Level >= 201 && Level <= 400) { Caught = random(160)-60; }
		else if(Level >= 401) { Caught = random(180)-70; }
		rand = random(sizeof(FishNames));
		if(Caught <= 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "The line snapped.");
			return 1;
		}
		else if(rand == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You caught a jacket and threw it away.");
			return 1;
		}
		else if(rand == 4)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You caught a pair of trousers and threw it away.");
			return 1;
		}
		else if(rand == 7)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You caught a can and threw it away.");
			return 1;
		}
		else if(rand == 10)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You caught a pair of shoes and threw it away.");
			return 1;
		}
		else if(rand == 13)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You caught some garbage and threw it away.");
			return 1;
		}
		else if(rand == 20)
		{
			new mrand = random(500);
			format(string, sizeof(string), "* You caught a bag filled with money ($%d).", mrand);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			GivePlayerCash(playerid, mrand);
			return 1;
		}
		if(Fishes[playerid][pWeight1] == 0)
		{
			PlayerInfo[playerid][pFishes] += 1;

  			if(PlayerInfo[playerid][pDoubleEXP] > 0)
			{
				format(string, sizeof(string), "You have gained 2 fisher skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
   				PlayerInfo[playerid][pFishSkill] += 2;
			}
			else
			{
  				PlayerInfo[playerid][pFishSkill] += 1;
			}

			format(fstring, sizeof(fstring), "%s", FishNames[rand]);
			strmid(Fishes[playerid][pFish1], fstring, 0, strlen(fstring), 255);
			Fishes[playerid][pWeight1] = Caught;
			format(string, sizeof(string), "* You have caught a %s, weighing %d pounds.", Fishes[playerid][pFish1], Caught);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			Fishes[playerid][pLastWeight] = Caught;
			Fishes[playerid][pLastFish] = 1;
			Fishes[playerid][pFid1] = rand;
			Fishes[playerid][pFishID] = rand;
			if(Caught > PlayerInfo[playerid][pBiggestFish])
			{
				format(string, sizeof(string), "* Your old record of %d pounds has been passed, your new record is %d pounds.", PlayerInfo[playerid][pBiggestFish], Caught);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				PlayerInfo[playerid][pBiggestFish] = Caught;
			}
		}
		else if(Fishes[playerid][pWeight2] == 0)
		{
			PlayerInfo[playerid][pFishes] += 1;

  			if(PlayerInfo[playerid][pDoubleEXP] > 0)
			{
				format(string, sizeof(string), "You have gained 2 fisher skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
   				PlayerInfo[playerid][pFishSkill] += 2;
			}
			else
			{
  				PlayerInfo[playerid][pFishSkill] += 1;
			}

			format(fstring, sizeof(fstring), "%s", FishNames[rand]);
			strmid(Fishes[playerid][pFish2], fstring, 0, strlen(fstring), 255);
			Fishes[playerid][pWeight2] = Caught;
			format(string, sizeof(string), "* You have caught a %s, weighing %d pounds.", Fishes[playerid][pFish2], Caught);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			Fishes[playerid][pLastWeight] = Caught;
			Fishes[playerid][pLastFish] = 2;
			Fishes[playerid][pFid2] = rand;
			Fishes[playerid][pFishID] = rand;
			if(Caught > PlayerInfo[playerid][pBiggestFish])
			{
				format(string, sizeof(string), "* Your old record of %d pounds has been passed, your new record is %d pounds.", PlayerInfo[playerid][pBiggestFish], Caught);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				PlayerInfo[playerid][pBiggestFish] = Caught;
			}
		}
		else if(Fishes[playerid][pWeight3] == 0)
		{
			PlayerInfo[playerid][pFishes] += 1;

  			if(PlayerInfo[playerid][pDoubleEXP] > 0)
			{
				format(string, sizeof(string), "You have gained 2 fisher skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
   				PlayerInfo[playerid][pFishSkill] += 2;
			}
			else
			{
  				PlayerInfo[playerid][pFishSkill] += 1;
			}

			format(fstring, sizeof(fstring), "%s", FishNames[rand]);
			strmid(Fishes[playerid][pFish3], fstring, 0, strlen(fstring), 255);
			Fishes[playerid][pWeight3] = Caught;
			format(string, sizeof(string), "* You have caught a %s, weighing %d pounds.", Fishes[playerid][pFish3], Caught);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			Fishes[playerid][pLastWeight] = Caught;
			Fishes[playerid][pLastFish] = 3;
			Fishes[playerid][pFid3] = rand;
			Fishes[playerid][pFishID] = rand;
			if(Caught > PlayerInfo[playerid][pBiggestFish])
			{
				format(string, sizeof(string), "* Your old record of %d pounds has been passed, your new record is %d pounds.", PlayerInfo[playerid][pBiggestFish], Caught);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				PlayerInfo[playerid][pBiggestFish] = Caught;
			}
		}
		else if(Fishes[playerid][pWeight4] == 0)
		{
			PlayerInfo[playerid][pFishes] += 1;

  			if(PlayerInfo[playerid][pDoubleEXP] > 0)
			{
				format(string, sizeof(string), "You have gained 2 fisher skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
   				PlayerInfo[playerid][pFishSkill] += 2;
			}
			else
			{
  				PlayerInfo[playerid][pFishSkill] += 1;
			}

			format(fstring, sizeof(fstring), "%s", FishNames[rand]);
			strmid(Fishes[playerid][pFish4], fstring, 0, strlen(fstring), 255);
			Fishes[playerid][pWeight4] = Caught;
			format(string, sizeof(string), "* You have caught a %s, weighing %d pounds.", Fishes[playerid][pFish4], Caught);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			Fishes[playerid][pLastWeight] = Caught;
			Fishes[playerid][pLastFish] = 4;
			Fishes[playerid][pFid4] = rand;
			Fishes[playerid][pFishID] = rand;
			if(Caught > PlayerInfo[playerid][pBiggestFish])
			{
				format(string, sizeof(string), "* Your old record of %d pounds has been passed, your new record is %d pounds.", PlayerInfo[playerid][pBiggestFish], Caught);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				PlayerInfo[playerid][pBiggestFish] = Caught;
			}
		}
		else if(Fishes[playerid][pWeight5] == 0)
		{
			PlayerInfo[playerid][pFishes] += 1;

  			if(PlayerInfo[playerid][pDoubleEXP] > 0)
			{
				format(string, sizeof(string), "You have gained 2 fisher skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
   				PlayerInfo[playerid][pFishSkill] += 2;
			}
			else
			{
  				PlayerInfo[playerid][pFishSkill] += 1;
			}

			format(fstring, sizeof(fstring), "%s", FishNames[rand]);
			strmid(Fishes[playerid][pFish5], fstring, 0, strlen(fstring), 255);
			Fishes[playerid][pWeight5] = Caught;
			format(string, sizeof(string), "* You have caught a %s, weighing %d pounds.", Fishes[playerid][pFish5], Caught);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			Fishes[playerid][pLastWeight] = Caught;
			Fishes[playerid][pLastFish] = 5;
			Fishes[playerid][pFid5] = rand;
			Fishes[playerid][pFishID] = rand;
			if(Caught > PlayerInfo[playerid][pBiggestFish])
			{
				format(string, sizeof(string), "* Your old record of %d pounds has been passed, your new record is %d pounds.", PlayerInfo[playerid][pBiggestFish], Caught);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				PlayerInfo[playerid][pBiggestFish] = Caught;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You don't have any space for your fish.");
			return 1;
		}
		if(PlayerInfo[playerid][pFishSkill] == 50) SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Fishing Skill is now Level 2, you can now catch larger fish.");
		else if(PlayerInfo[playerid][pFishSkill] == 100) SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Fishing Skill is now Level 3, you can now catch larger fish.");
		else if(PlayerInfo[playerid][pFishSkill] == 200) SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Fishing Skill is now Level 4, you can now catch larger fish.");
		else if(PlayerInfo[playerid][pFishSkill] == 400) SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Fishing Skill is now Level 5, you can now catch larger fish.");
		if(PlayerInfo[playerid][pFishSkill] == 400) PlayerInfo[playerid][pFishSkill] = 400;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not at the Santa Maria Pier, or on a fishing boat.");
		return 1;
	}
	return 1;
}



CMD:fishes(playerid, params[])
{
	new string[128];

	SendClientMessageEx(playerid, COLOR_WHITE, "|__________________ Fishes __________________|");
	format(string, sizeof(string), "** (1) Fish: %s.   Weight: %d.", Fishes[playerid][pFish1], Fishes[playerid][pWeight1]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** (2) Fish: %s.   Weight: %d.", Fishes[playerid][pFish2], Fishes[playerid][pWeight2]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** (3) Fish: %s.   Weight: %d.", Fishes[playerid][pFish3], Fishes[playerid][pWeight3]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** (4) Fish: %s.   Weight: %d.", Fishes[playerid][pFish4], Fishes[playerid][pWeight4]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** (5) Fish: %s.   Weight: %d.", Fishes[playerid][pFish5], Fishes[playerid][pWeight5]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	SendClientMessageEx(playerid, COLOR_WHITE, "|____________________________________________|");
	return 1;
}


CMD:releasefish(playerid, params[])
{
	new fishid;
	if(sscanf(params, "d", fishid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /releasefish [fish 1-5]");

	if(fishid < 1 || fishid > 5) { SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /releasefish [fish 1-5]"); return 1; }
	else if(fishid == 1 && Fishes[playerid][pWeight1] < 1) { SendClientMessageEx(playerid, COLOR_GREY, "That slot is empty."); return 1; }
	else if(fishid == 2 && Fishes[playerid][pWeight2] < 1) { SendClientMessageEx(playerid, COLOR_GREY, "That slot is empty."); return 1; }
	else if(fishid == 3 && Fishes[playerid][pWeight3] < 1) { SendClientMessageEx(playerid, COLOR_GREY, "That slot is empty."); return 1; }
	else if(fishid == 4 && Fishes[playerid][pWeight4] < 1) { SendClientMessageEx(playerid, COLOR_GREY, "That slot is empty."); return 1; }
	else if(fishid == 5 && Fishes[playerid][pWeight5] < 1) { SendClientMessageEx(playerid, COLOR_GREY, "That slot is empty."); return 1; }
	ClearFishID(playerid, fishid);
	Fishes[playerid][pLastFish] = 0;
	Fishes[playerid][pFishID] = 0;
	SendClientMessageEx(playerid, COLOR_GREY, "You released a fish");
	return 1;
}

CMD:throwback(playerid, params[])
{
	if(Fishes[playerid][pLastFish] > 0)
	{
		ClearFishID(playerid, Fishes[playerid][pLastFish]);
		Fishes[playerid][pLastFish] = 0;
		Fishes[playerid][pFishID] = 0;
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have thrown back your last fish.");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You haven't even caught a fish yet.");
		return 1;
	}
	return 1;
}

CMD:throwbackall(playerid, params[])
{
	if(Fishes[playerid][pWeight1] > 0 || Fishes[playerid][pWeight2] > 0 || Fishes[playerid][pWeight3] > 0 || Fishes[playerid][pWeight4] > 0 || Fishes[playerid][pWeight5] > 0)
	{
		ClearFishes(playerid);
		Fishes[playerid][pLastFish] = 0;
		Fishes[playerid][pFishID] = 0;
		SendClientMessageEx(playerid, COLOR_GREY, "You have thrown back all your fish");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You haven't even caught a fish yet.");
		return 1;
	}
	return 1;
}