/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Phone System

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

CMD:cellphonehelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    if (PlayerInfo[playerid][pPnumber] != 0) {
        SendClientMessageEx(playerid, COLOR_WHITE,"*** HELP *** - type a command for more infomation.");
        SendClientMessageEx(playerid, COLOR_GRAD3,"*** CELLPHONE *** /call 'eg: /call 911' /sms (/p)ickup (/h)angup /speakerphone /number");
    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE,"You can buy a cell phone in any 24-7");
    }
    return 1;
}

CMD:phoneprivacy(playerid, params[])
{
    if(PlayerInfo[playerid][pPnumber] != 0 && PlayerInfo[playerid][pDonateRank] >= 2)
	{
        if(PlayerInfo[playerid][pPhonePrivacy] == 1)
		{
            PlayerInfo[playerid][pPhonePrivacy] = 0;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the phone privacy feature.");
        }
        else
		{
            PlayerInfo[playerid][pPhonePrivacy] = 1;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the phone privacy feature.");
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a phone or you aren't a Silver VIP.");
    }
    return 1;
}

CMD:speakerphone(playerid, params[])
{
    if(PlayerInfo[playerid][pPnumber] != 0)
	{
        if(PlayerInfo[playerid][pSpeakerPhone] == 1)
		{
            PlayerInfo[playerid][pSpeakerPhone] = 0;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the speakerphone feature on your phone.");
        }
        else
		{
            PlayerInfo[playerid][pSpeakerPhone] = 1;
            SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the speakerphone feature on your phone.");
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a phone.");
    }
    return 1;
}

CMD:togphone(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use your phone in jail/prison.");
		return 1;
	}
	if(Mobile[playerid] == INVALID_PLAYER_ID)
	{
		if (!PhoneOnline[playerid])
		{
			PhoneOnline[playerid] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD2, "Your phone is now switched off.");
		}
		else
		{
			PhoneOnline[playerid] = 0;
			SendClientMessageEx(playerid, COLOR_GRAD2, "Your phone is now switched on.");
		}
		return 1;
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "First use /hangup.");
}

CMD:colorcar(playerid, params[]) {
	new iColors[2];
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a vehicle.");
	else if(PlayerInfo[playerid][pSpraycan] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your spraycan is empty.");
	if(sscanf(params, "ii", iColors[0], iColors[1])) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /colorcar [ID 1] [ID 2]. Colors must be an ID.");
	else if((PlayerInfo[playerid][pDonateRank] == 0) && (iColors[0] > 127 || iColors[1] > 127)) return SendClientMessageEx(playerid, COLOR_GREY, "Only VIPs can use special color IDs above 127.");
	else if(!(0 <= iColors[0] <= 255 && 0 <= iColors[1] <= 255)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid color specified (IDs start at 0, and end at 255).");
	new szMessage[60];
	for(new i = 0; i < MAX_PLAYERVEHICLES; i++)
	{
		if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][i][pvId]))
		{
			PlayerVehicleInfo[playerid][i][pvColor1] = iColors[0], PlayerVehicleInfo[playerid][i][pvColor2] = iColors[1];
			ChangeVehicleColor(PlayerVehicleInfo[playerid][i][pvId], PlayerVehicleInfo[playerid][i][pvColor1], PlayerVehicleInfo[playerid][i][pvColor2]);
			PlayerInfo[playerid][pSpraycan]--;
			g_mysql_SaveVehicle(playerid, i);
			format(szMessage, sizeof(szMessage), "You have changed the colors of your vehicle to ID %d, %d.", iColors[0], iColors[1]);
			return SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);
		}
	}
	for(new i = 0; i < sizeof(VIPVehicles); i++)
	{
		if(IsPlayerInVehicle(playerid, VIPVehicles[i]))
		{
			ChangeVehicleColor(VIPVehicles[i], iColors[0], iColors[1]);
			PlayerInfo[playerid][pSpraycan]--;
			format(szMessage, sizeof(szMessage), "You have changed the colors of this vehicle to ID %d, %d.", iColors[0], iColors[1]);
			return SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);			
		}
	}
	for(new i = 0; i < sizeof(FamedVehicles); i++)
	{
		if(IsPlayerInVehicle(playerid, FamedVehicles[i]))
		{
			ChangeVehicleColor(FamedVehicles[i], iColors[0], iColors[1]);
			PlayerInfo[playerid][pSpraycan]--;
			format(szMessage, sizeof(szMessage), "You have changed the colors of this vehicle to ID %d, %d.", iColors[0], iColors[1]);
			return SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);	
		}
	}
	SendClientMessageEx(playerid, COLOR_GREY, "You can't spray other people's vehicles.");
	return 1;
}

CMD:number(playerid, params[]) {
	if(PlayerInfo[playerid][pPhoneBook] == 1) {

		new
			iTarget;

		if(sscanf(params, "u", iTarget)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /number [player]");
		}
		else if(IsPlayerConnected(iTarget)) {
			new
				szNumber[16 + MAX_PLAYER_NAME];

			format(szNumber, sizeof(szNumber), "* %s (%i)", GetPlayerNameEx(iTarget), PlayerInfo[iTarget][pPnumber]);
			SendClientMessageEx(playerid, COLOR_GRAD1, szNumber);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a phone book.");
	return 1;
}

/*
CMD:ringtone(playerid, params[])
{
    if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) {
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	}

	if(!IsPlayerInAnyVehicle(playerid))
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		SetPlayerAttachedObject(playerid, 9, 330, 6);
	}
	return ShowPlayerDialog(playerid,RTONEMENU,DIALOG_STYLE_LIST,"Ringtone - Change Your Ringtone:","Ringtone 1\nRingtone 2\nRingtone 3\nRingtone 4\nRingtone 5\nRingtone 6\nRingtone 7\nRingtone 8\nRingtone 9\nTurn Off","Select","Close");
}
*/