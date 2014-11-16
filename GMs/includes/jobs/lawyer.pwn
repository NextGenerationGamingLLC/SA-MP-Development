/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Lawyer System

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

CMD:lawyerduty(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 2 || PlayerInfo[playerid][pJob2] == 2 || PlayerInfo[playerid][pJob3] == 2)
	{
        if(GetPVarInt(playerid, "LawyerDuty") == 1)
		{
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are now off duty on your lawyer job and will not receive calls anymore.");
			SetPVarInt(playerid, "LawyerDuty", 0);
            Lawyers -= 1;
        }
        else if(GetPVarInt(playerid, "LawyerDuty") == 0)
		{
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are now on duty on your lawyer job and will receive calls from people in need.");
			SetPVarInt(playerid, "LawyerDuty", 1);
            Lawyers += 1;
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not a lawyer!");
    }
    return 1;
}

CMD:offerappeal(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 2 || PlayerInfo[playerid][pJob2] == 2 || PlayerInfo[playerid][pJob3] == 2)
	{
	    new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /offerappeal [player]");
		if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
		if(IsPlayerConnected(giveplayerid))
		{
		    if(PlayerInfo[giveplayerid][pBeingSentenced] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "That person isn't pending a sentence!");
		    if(AppealOfferAccepted[giveplayerid] == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "That person has already accepted a lawyer to appeal for him!");
			AppealOffer[giveplayerid] = playerid;
		    format(string, sizeof(string), "You have offered your lawyer services to %s.",GetPlayerNameEx(giveplayerid));
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    format(string, sizeof(string), "%s has offered their lawyer services (use /accept appeal to accept them).", GetPlayerNameEx(playerid));
		    SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
		}
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a Lawyer!");
	}
	return 1;
}

CMD:finishappeal(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 2 || PlayerInfo[playerid][pJob2] == 2 || PlayerInfo[playerid][pJob3] == 2)
	{
	    new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /finishappeal [player]");
		if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
		if(IsPlayerConnected(giveplayerid))
		{
		    if(AppealOffer[giveplayerid] != playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not offering your services to this player!");
		    format(string, sizeof(string), "You have finished your Lawyer services to %s.",GetPlayerNameEx(giveplayerid));
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    format(string, sizeof(string), "%s has finished offering their Lawyer services.", GetPlayerNameEx(playerid));
		    SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
		    AppealOffer[giveplayerid] = INVALID_PLAYER_ID;
			AppealOfferAccepted[giveplayerid] = 0;
		}
	}
	else
	{
       	return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a Lawyer!");
	}
	return 1;
}