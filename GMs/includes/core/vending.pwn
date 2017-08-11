/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

    	    		  Vending Machine System (Serversided Health)
    			        by Hector & Shane Roberts

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

/*
If a vending machine says "you are not at a candy/spunk vending machine" when pressing F and the animation starts, you need to add it's coordinate.
Vending Machine coordinates are located in callbacks.inc at like 216. You also need to specify if it's a Candy or Sprunk machine. Make sure to update callbacks.inc on Github when updating.
*/

public OnPlayerUseVending(playerid, type) {
    if(!IsPlayerNearVending(playerid, type)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not near a %s machine!", (type == 1) ? ("Sprunk") : ("Candy"));
    new Float:healtha;
    GetHealth(playerid, healtha);
    if(gettime() - LastShot[playerid] < 60) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have been injured within the last 60 seconds, you cannot use the vending machine");
  	if((PlayerInfo[playerid][pConnectHours] > 5 && GetPlayerCash(playerid) < 750)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need at least $750 to buy %s!", (type == 1) ? ("a Sprunk") : ("some Candy")), ClearAnimationsEx(playerid);
    if((PlayerInfo[playerid][pConnectHours] < 5 && GetPlayerCash(playerid) < 150)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need at least $150 to buy %s!", (type == 1) ? ("a Sprunk") : ("some Candy")), ClearAnimationsEx(playerid);
  	if((healtha > 99.0)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your health is already at 100");
//    if((healtha + 35.0) > 100.0) SetHealth(playerid, 100);
//    else SetHealth(playerid, healtha+35);
  	SetTimerEx("SprunkTimer", 3000, false, "i", playerid); 
    if((PlayerInfo[playerid][pConnectHours] > 5)) {
    	SendClientMessageEx(playerid, COLOR_GRAD1, "You paid $750 for %s!", (type == 1) ? ("a Sprunk") : ("some Candy"));
    	GivePlayerCash(playerid, -750);
    }
    if((PlayerInfo[playerid][pConnectHours] < 5)) {
    	SendClientMessageEx(playerid, COLOR_GRAD1, "You paid $150 for %s!", (type == 1) ? ("a Sprunk") : ("some Candy"));
    	GivePlayerCash(playerid, -150);
    }
    return 1;
}  


forward SprunkTimer(playerid);
public SprunkTimer(playerid)
{
	new Float:healtha;
    GetHealth(playerid, healtha);
    if((healtha + 35.0) > 100.0) SetHealth(playerid, 100);
    else SetHealth(playerid, healtha+35);
	return 1;
}