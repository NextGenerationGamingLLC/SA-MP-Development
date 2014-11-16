/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Dynamic Group Core

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

CMD:clearbugs(playerid, params[])
{
	if(IsACop(playerid))
	{
		if(PlayerInfo[playerid][pLeader] == PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iBugAccess]) // has leader flag
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "All agency bugs destroyed.");
			//foreach(new i : Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(PlayerInfo[i][pBugged] == PlayerInfo[playerid][pMember]){
						PlayerInfo[i][pBugged] = INVALID_GROUP_ID;
					}
				}	
			}
			new query[256];
			format(query, sizeof(query), "UPDATE accounts SET `Bugged` = %d WHERE `Bugged` > %d AND `Online` = 0", INVALID_GROUP_ID, INVALID_GROUP_ID);
			mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			return 1;
		}
	}
	return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorized to use this command.");
}

CMD:listbugs(playerid, params[])
{
	if(IsACop(playerid))
	{
		if(PlayerInfo[playerid][pLeader] == PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iBugAccess]) // has leader flag
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "List of deployed Bugs:");
			//foreach(new i : Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(PlayerInfo[i][pBugged] == PlayerInfo[playerid][pMember]){
						SendClientMessageEx(playerid, COLOR_GREEN, GetPlayerNameEx(i));
					}
				}	
			}
			new query[256];
			format(query, sizeof(query), "SELECT `Username`, `Bugged` FROM `accounts`  WHERE `Bugged` = %d AND `Online` = 0", PlayerInfo[playerid][pMember]);
			mysql_function_query(MainPipeline, query, true, "OnQueryFinish", "iii", BUG_LIST_THREAD, playerid, g_arrQueryHandle{playerid});
			return 1;
		}
	}
	return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorized to use this command.");
}

CMD:online(playerid, params[]) {
	if(PlayerInfo[playerid][pLeader] >= 0 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1)
	{
		if(PlayerInfo[playerid][pMember] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, -1, "You are not a member of any group!");
		new
			badge[11],
			szDialog[1024];

		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(strcmp(PlayerInfo[i][pBadge], "None", true) != 0) format(badge, sizeof(badge), "[%s] ", PlayerInfo[i][pBadge]);
				else format(badge, sizeof(badge), "");
				if(IsATaxiDriver(playerid) && IsATaxiDriver(i)) switch(TransportDuty[i]) {
					case 1: format(szDialog, sizeof(szDialog), "%s\n* %s%s (on duty), %i calls accepted", szDialog, badge, GetPlayerNameEx(i), PlayerInfo[i][pCallsAccepted]);
					default: format(szDialog, sizeof(szDialog), "%s\n* %s%s (off duty), %i calls accepted", szDialog, badge, GetPlayerNameEx(i), PlayerInfo[i][pCallsAccepted]);
				}
				else if(IsAMedic(playerid) && IsAMedic(i) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == arrGroupData[PlayerInfo[i][pMember]][g_iAllegiance])) switch(PlayerInfo[i][pDuty]) {
					case 1: format(szDialog, sizeof(szDialog), "%s\n* %s%s (on duty), %i calls accepted, %i patients delivered.", szDialog, badge, GetPlayerNameEx(i), PlayerInfo[i][pCallsAccepted], PlayerInfo[i][pPatientsDelivered]);
					default: format(szDialog, sizeof(szDialog), "%s\n* %s%s (off duty), %i calls accepted, %i patients delivered.", szDialog, badge, GetPlayerNameEx(i), PlayerInfo[i][pCallsAccepted], PlayerInfo[i][pPatientsDelivered]);
				}
				else if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember]) switch(PlayerInfo[i][pDuty]) {
					case 1: format(szDialog, sizeof(szDialog), "%s\n* %s%s (on duty)", szDialog, badge, GetPlayerNameEx(i));
					default: format(szDialog, sizeof(szDialog), "%s\n* %s%s (off duty)", szDialog, badge, GetPlayerNameEx(i));
				}
			}	
		}
		if(!isnull(szDialog)) {
		    strdel(szDialog, 0, 1);
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "Online Members", szDialog, "Select", "Cancel");
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "No members are online at this time.");

    }  else SendClientMessageEx(playerid, COLOR_GREY, "Only group leaders may use this command.");
    return 1;
}

CMD:badge(playerid, params[]) {
    if(PlayerInfo[playerid][pMember] >= 0 && arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] != 0xFFFFFF)
	{
		if(GetPVarInt(playerid, "IsInArena") >= 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "EventToken") != 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You can't use your badge now.");
			return 1;
		}
		#if defined zombiemode
		if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
		#endif
		if(PlayerInfo[playerid][pDuty]) {
			PlayerInfo[playerid][pDuty] = 0;
			SetPlayerToTeamColor(playerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have hidden your badge, and will now be identified as being off-duty.");
			if(IsAMedic(playerid))
			{
				Medics -= 1;
			}
		}
		else {
			PlayerInfo[playerid][pDuty] = 1;
			SetPlayerToTeamColor(playerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have shown your badge, and will now be identified as being on-duty.");
			if(IsAMedic(playerid))
			{
				Medics += 1;
			}
		}
	}
	return 1;
}