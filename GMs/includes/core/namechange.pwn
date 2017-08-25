/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Name Change System

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

stock IsAtNameChange(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0,1154.7295,-1440.2323,15.7969)) return 1;//LS
		else if(IsPlayerInRangeOfPoint(playerid, 3.0,-2279.6545, 2311.2238, 4.9641)) return 1;//TR
	}
	return 0;
}

/*CMD:nchange(playerid, params[]) return cmd_namechanges(playerid, params);

CMD:namechanges(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3)
 	{

		new
			nstring[64 + (MAX_PLAYER_NAME * 2)],
			newname[ MAX_PLAYER_NAME ];

  		SendClientMessageEx(playerid, COLOR_GREEN, "* Pending name changes:");
   		foreach(new i: Player)
		{
			if(GetPVarType(i, "RequestingNameChange"))
			{
  				GetPVarString(i, "NewNameRequest", newname, MAX_PLAYER_NAME);
				format(nstring, sizeof(nstring), "Current name: %s (ID: %d) | Requested name: %s | Price: %d", GetPlayerNameEx(i), i, newname, GetPVarInt(i, "NameChangeCost"));
				SendClientMessageEx(playerid, COLOR_YELLOW, nstring);
			}
		}
		SendClientMessageEx(playerid, COLOR_GREEN, "_____________________________________________________");
	}
	return 1;
} */

/*CMD:changename(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] == 1 && PlayerInfo[playerid][pSMod] > 0) return ShowPlayerDialogEx( playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, "Name Change","Please enter your new desired name!\n\nNote: Name Changes are free because you are a Senior Moderator.", "Change", "Cancel" );
	if(!IsAtNameChange(playerid)) return SendClientMessageEx( playerid, COLOR_WHITE, "   You are not in the Name Change Place!" );
	if(!isnull(PlayerInfo[playerid][pWarrant]) || PlayerInfo[playerid][pWarrant] != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cant name change, while warranted.");
	if(gettime()-GetPVarInt(playerid, "LastNameChange") < 120) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only request a name change every two minutes.");
	new iGroupID = PlayerInfo[playerid][pMember];
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (PlayerInfo[playerid][pRank] >= arrGroupData[iGroupID][g_iFreeNameChange] && (PlayerInfo[playerid][pDivision] == arrGroupData[iGroupID][g_iFreeNameChangeDiv] || arrGroupData[iGroupID][g_iFreeNameChangeDiv] == INVALID_DIVISION)))
	{
		ShowPlayerDialogEx( playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, "Name Change","Please enter your new desired name!\n\nNote: Name Changes are free for your faction.", "Change", "Cancel" );
	}
	else if(gettime() >= PlayerInfo[playerid][pNextNameChange])
	{
		ShowPlayerDialogEx(playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, "Free Name Change", "Please enter your new desired name!\n\nNote: Name Changes are free every 120 days.", "Change", "Cancel");
	}
	else
	{
		if(GetPVarInt(playerid, "PinConfirmed"))
		{
			new string[128];
			format(string, sizeof(string), "Please enter your new desired name!\n\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[40][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[40][sItemPrice]));
			ShowPlayerDialogEx(playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, "Name Change", string, "Purchase", "Cancel");
		}
		else SetPVarInt(playerid, "OpenShop", 10), PinLogin(playerid);
	}
	return 1;
}*/
CMD:changename(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] == 1 && PlayerInfo[playerid][pSMod] > 0) return ShowPlayerDialogEx( playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, "Free Name Change","Please enter your new desired name!\n\nNote: Name Changes are free because you are a Senior Moderator.", "Change", "Cancel" );
	if(!IsAtNameChange(playerid)) return SendClientMessageEx( playerid, COLOR_WHITE, "You are not in the Name Change Place!" );
	if(!isnull(PlayerInfo[playerid][pWarrant]) || PlayerInfo[playerid][pWarrant] != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cant name change, while warranted.");
	if(gettime()-GetPVarInt(playerid, "LastNameChange") < 120) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only request a name change every two minutes.");
	new iGroupID = PlayerInfo[playerid][pMember];
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (PlayerInfo[playerid][pRank] >= arrGroupData[iGroupID][g_iFreeNameChange] && (PlayerInfo[playerid][pDivision] == arrGroupData[iGroupID][g_iFreeNameChangeDiv] || arrGroupData[iGroupID][g_iFreeNameChangeDiv] == INVALID_DIVISION)))
	{
		ShowPlayerDialogEx( playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, "Free Name Change","Please enter your new desired name!\n\nNote: Name Changes are free for your faction.", "Change", "Cancel" );
	}
	else if(gettime() >= PlayerInfo[playerid][pNextNameChange])
	{
		ShowPlayerDialogEx(playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, "Free Name Change", "Please enter your new desired name!\n\nNote: Name Changes are free every 120 days.", "Change", "Cancel");
	}
	else
	{
		new string[128];
		switch(PlayerInfo[playerid][pLevel])
		{
			case 1: string = "10,000";
			case 2: string = "15,000";
			case 3: string = "20,000";
			default: string = number_format((PlayerInfo[playerid][pLevel]-3)*50000);
		}
		format(string, sizeof(string), "Please enter your new desired name!\n\nCost of a currnet name change is: $%s\nUse /nextnamechange to see the next free change.", string);	
		ShowPlayerDialogEx(playerid, DIALOG_NAMECHANGE, DIALOG_STYLE_INPUT, "Name Change", string, "Change", "Cancel");
	}
	return 1;
}

CMD:nextnamechange(playerid, params[])
{
	if(PlayerInfo[playerid][pNextNameChange] == 0 || gettime() >= PlayerInfo[playerid][pNextNameChange]) return SendClientMessageEx(playerid, -1, "You can change your name for free now.");
	else
	{
		new string[128];
		format(string, sizeof(string), "Your next free name change will be on %s", date(PlayerInfo[playerid][pNextNameChange], 4));
		SendClientMessageEx(playerid, -1, string);
	}
	return 1;
}