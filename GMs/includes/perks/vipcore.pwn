/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						VIP Core

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

CMD:vipdate(playerid, params[]) {
	new giveplayerid;
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    giveplayerid = playerid;
	}
	else
	{
	    if(sscanf(params, "u", giveplayerid)) giveplayerid = playerid;
	}
	if(1 <= PlayerInfo[giveplayerid][pDonateRank] <= 3 && !PlayerInfo[giveplayerid][pBuddyInvited])
	{
	    new string[128];
	    new drank[20];
		switch(PlayerInfo[giveplayerid][pDonateRank])
		{
			case 1: drank = "Bronze";
			case 2: drank = "Silver";
			case 3: drank = "Gold";
		}
	    new datestring[32];
		datestring = date(PlayerInfo[giveplayerid][pVIPExpire], 4);
		if(PlayerInfo[giveplayerid][pVIPExpire] == 0) format(string, sizeof(string), "* Your %s VIP subscription is not set to expire.", drank);
		else format(string, sizeof(string), "* Your %s VIP subscription expires on %s.", drank, datestring);
	    SendClientMessageEx(playerid, COLOR_VIP, string);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a VIP subscription.");
	return 1;
}

CMD:spawnathome(playerid, params[])
{
    if( PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID )
	{
        if(PlayerInfo[playerid][pDonateRank] >= 4)
		{
            PlayerInfo[playerid][pInsurance] = HOSPITAL_HOMECARE;
            SendClientMessageEx( playerid, COLOR_YELLOW, "Platinum VIP: You will now spawn at your house after deaths." );
        }
        else
		{
            SendClientMessageEx( playerid, COLOR_WHITE, "You are not Platinum VIP!" );
        }
    }
    else
	{
        SendClientMessageEx( playerid, COLOR_WHITE, "You do not own a house." );
    }
    return 1;
}

CMD:vipnum(playerid, params[])
{
	SendClientMessageEx(playerid, -1, "This command has been temporarily disabled.");
	/*
    if(!(IsPlayerInRangeOfPoint(playerid, 3.0, 2549.548095, 1404.047729, 7699.584472 ) || IsPlayerInRangeOfPoint(playerid, 3.0, 1832.6000, 1375.1700, 1464.4600)) )
    {
    	SendClientMessageEx(playerid, COLOR_GREY, "You are not at the VIP phone number changing station!");
     	return 1;
   	}
    if(PlayerInfo[playerid][pDonateRank] < 2)
    {
    	SendClientMessageEx(playerid, COLOR_GRAD1, "You must be a Silver VIP or higher to use this function.");
     	return 1;
	}
	ShowPlayerDialog(playerid, VIPNUMMENU, DIALOG_STYLE_INPUT, "New Phone Number","New phone number:", "Submit", "Cancel"); */
	return 1;
}
