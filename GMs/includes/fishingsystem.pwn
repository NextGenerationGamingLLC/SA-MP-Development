/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Fishing Job System

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

// WINTERFIELD: VERSION .278 FISHING SYSTEM

#include <YSI\y_hooks>

command(fish, playerid, params[])
{
    //if(PlayerInfo[playerid][pJob] == 70 || PlayerInfo[playerid][pJob2] == 70 || PlayerInfo[playerid][pJob3] == 70)
    {
        if(IsABoat(GetPlayerVehicleID(playerid)))
        {
            {
                if(PlayerInfo[playerid][pFishWeight] <= 1000)
                {
                    if(GetPVarInt(playerid, "pFishTime") < gettime())
                    {
						switch(PlayerInfo[playerid][pFishingSkill])
                        {
                            case 0 .. 49:
                            {
                                new string[128];
                         		switch(random(2))
                        		{
                        		    case 0:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught nothing!");
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 1:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a bluegill!");
    									
    									PlayerInfo[playerid][pFishWeight] += 5;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 2:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a bass!");
    									
    									PlayerInfo[playerid][pFishWeight] += 7;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
								}
                            }
                            case 50 .. 99:
                            {
                                new string[128];
                         		switch(random(4))
                        		{
                        		    case 0:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught nothing!");
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 1:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a bluegill!");

    									PlayerInfo[playerid][pFishWeight] += 5;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 2:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a bass!");

    									PlayerInfo[playerid][pFishWeight] += 7;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 3:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a cod!");

    									PlayerInfo[playerid][pFishWeight] += 14;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 4:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a catfish!");

    									PlayerInfo[playerid][pFishWeight] += 17;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
								}
                            }
                            case 100 .. 199:
                            {
                                new string[128];
                         		switch(random(8))
                        		{
                        		    case 0:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught nothing!");
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 1:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a bluegill!");

    									PlayerInfo[playerid][pFishWeight] += 5;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 2:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a bass!");

    									PlayerInfo[playerid][pFishWeight] += 7;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 3:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a cod!");

    									PlayerInfo[playerid][pFishWeight] += 14;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 4:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a catfish!");

    									PlayerInfo[playerid][pFishWeight] += 17;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 5:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a pike!");

    									PlayerInfo[playerid][pFishWeight] += 24;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
                                        IncreaseFishingLevel(playerid);
									}
									case 6:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a zander!");

    									PlayerInfo[playerid][pFishWeight] += 30;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 7:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a mackerel!");

    									PlayerInfo[playerid][pFishWeight] += 35;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 8:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a molly!");

    									PlayerInfo[playerid][pFishWeight] += 40;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
								}
                            }
                            case 200 .. 399:
                            {
                            	new string[128];
                         		switch(random(11))
                        		{
                        		    case 0:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught nothing!");
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 1:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a bluegill!");

    									PlayerInfo[playerid][pFishWeight] += 5;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 2:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a bass!");

    									PlayerInfo[playerid][pFishWeight] += 7;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 3:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a cod!");

    									PlayerInfo[playerid][pFishWeight] += 14;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 4:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a catfish!");

    									PlayerInfo[playerid][pFishWeight] += 17;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 5:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a pike!");

    									PlayerInfo[playerid][pFishWeight] += 24;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 6:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a zander!");

    									PlayerInfo[playerid][pFishWeight] += 30;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 7:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a mackerel!");

    									PlayerInfo[playerid][pFishWeight] += 35;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 8:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a molly!");

    									PlayerInfo[playerid][pFishWeight] += 40;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 9:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a swordfish!");

    									PlayerInfo[playerid][pFishWeight] += 70;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 10:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a tench!");

    									PlayerInfo[playerid][pFishWeight] += 71;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 11:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a seabass!");

    									PlayerInfo[playerid][pFishWeight] += 80;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
								}
                            }
							default:
							{
								new string[128];
                         		switch(random(12))
                        		{
                        		    case 0:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught nothing!");
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 1:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a bluegill!");

    									PlayerInfo[playerid][pFishWeight] += 5;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 2:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a bass!");

    									PlayerInfo[playerid][pFishWeight] += 7;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 3:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a cod!");

    									PlayerInfo[playerid][pFishWeight] += 14;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 4:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a catfish!");

    									PlayerInfo[playerid][pFishWeight] += 17;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 5:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a pike!");

    									PlayerInfo[playerid][pFishWeight] += 24;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 6:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a zander!");

    									PlayerInfo[playerid][pFishWeight] += 30;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 7:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a mackerel!");

    									PlayerInfo[playerid][pFishWeight] += 35;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 8:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a molly!");

    									PlayerInfo[playerid][pFishWeight] += 40;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 9:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a swordfish!");

    									PlayerInfo[playerid][pFishWeight] += 70;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 10:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a tench!");

    									PlayerInfo[playerid][pFishWeight] += 71;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 11:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a seabass!");

    									PlayerInfo[playerid][pFishWeight] += 80;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
									case 12:
                            		{
                						format(string, sizeof string, "{FF8000}* {C2A2DA}%s casts their rod out, reeling it back in.", GetPlayerNameEx(playerid));
    									SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 4000);
    									SendClientMessageEx(playerid, COLOR_PURPLE, string);

    									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have caught a kraken!");

    									PlayerInfo[playerid][pFishWeight] += 200;
    									
    									SetPVarInt(playerid, "pFishTime", gettime() + 10);
    									IncreaseFishingLevel(playerid);
									}
								}
							}
						}
					}
					else SendClientMessageEx(playerid, COLOR_GRAD2, "  You must wait 10 more seconds before you can cast out again!");
				}
				else SendClientMessageEx(playerid, COLOR_GRAD2, "  You have reached your maximum weight. Type /sellfish to profit.");
            }
        }
        else return SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not in a boat!");
    }
    //else SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not a fisherman!");
	return 1;
}

command(myfish, playerid, params[])
{
	new string[16];
	format(string, sizeof string, "Fish: %d lbs.", PlayerInfo[playerid][pFishWeight]);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	return 1;
}

command(sellfish, playerid, params[])
{
	new amount;
    //if(PlayerInfo[playerid][pJob] == 70 || PlayerInfo[playerid][pJob2] == 70 || PlayerInfo[playerid][pJob3] == 70)
    {
        if(IsPlayerInRangeOfPoint(playerid, 30.0, 2286.7698, -2425.2292, 3.0000))
        {
        	if(sscanf(params, "d", amount))
			{
		    	new string[16];
				SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellfish [amount]");
				format(string, sizeof string, "Fish: %d lbs.", PlayerInfo[playerid][pFishWeight]);
				return SendClientMessageEx(playerid, COLOR_YELLOW, string);
			}
        
            if(amount < 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot enter a negative ammount.");
        	if(PlayerInfo[playerid][pFishWeight] >= amount && PlayerInfo[playerid][pFishWeight] != 0)
       		{
   	    		new rand = random(100) + 100, money = amount * 40 + rand, string[128];
				PlayerInfo[playerid][pFishWeight] -= amount;
				GivePlayerCash(playerid, money);
				
				format(string, sizeof string, "You have sold %d lbs for $%d.", amount, money);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD2, "  You don't have that many pounds!");
		}
		else
		{
		    GameTextForPlayer(playerid, "~g~CHECKPOINT ~r~SET", 5000, 4);
		    SetPlayerCheckpoint(playerid, 2286.7698,-2425.2292,3.0000, 10.0);
		    SetPVarInt(playerid, "pSellingFish", 1);
			return SendClientMessageEx(playerid, COLOR_YELLOW, "Make your way to the checkpoint to sell your fish.");
		}
    }
    //else SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not a fisherman!");
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(GetPVarInt(playerid, "pSellingFish") >= 1)
	{
    	DisablePlayerCheckpoint(playerid);
    	SendClientMessageEx(playerid, COLOR_WHITE, "You have reached your destination. Type /sellfish [amount] to sell your fish.");
	}
 	return 1;
}

IncreaseFishingLevel(playerid)
{
	if(PlayerInfo[playerid][pDoubleEXP] > 0)
	{
		PlayerInfo[playerid][pFishingSkill] += 2;
		// PlayerInfo[playerid][pXP] += PlayerInfo[playerid][pLevel] * XP_RATE * 2;
	}
	else
	{
		PlayerInfo[playerid][pFishingSkill] += 1;
		// PlayerInfo[playerid][pXP] += PlayerInfo[playerid][pLevel] * XP_RATE;
	}
	return 1;
}
