/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Staff Ban System
					     Winterfield

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

CMD:staffban(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] > 1)
	{
		new id, reason[128];
		if(sscanf(params, "us[128]", id, reason)) 
		{
			return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /staffban [playerid] [reason]");
		}
		else
		{
			if(IsPlayerConnected(id))
			{
				if(PlayerInfo[playerid][pAdmin] > PlayerInfo[id][pAdmin] || PlayerInfo[playerid][pAdmin] == 99999)
				{
					szMiscArray[0] = 0;
					if(PlayerInfo[id][pStaffBanned] == 0)
					{
						PlayerInfo[id][pStaffBanned] = 1;
						format(szMiscArray, 256, "You have been staff banned by %s, reason: %s", GetPlayerNameEx(playerid), reason);
						SendClientMessage(id, COLOR_LIGHTRED, szMiscArray);

						PlayerInfo[id][pAdmin] = 0;
						PlayerInfo[id][pSMod] = 0;
						PlayerInfo[id][pVIPMod] = 0;
						PlayerInfo[id][pHelper] = 0;

						format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has been staff banned by %s, reason: %s.", GetPlayerNameEx(id), id, GetPlayerNameEx(playerid), reason);
					}
					else
					{
						PlayerInfo[id][pStaffBanned] = 0;
						format(szMiscArray, 256, "Your staff ban was removed by %s, reason: %s", GetPlayerNameEx(playerid), reason);
						SendClientMessage(id, COLOR_LIGHTRED, szMiscArray);

						format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has had their staff banned removed by %s, reason: %s.", GetPlayerNameEx(id), id, GetPlayerNameEx(playerid), reason);
					}

   					ABroadCast(COLOR_YELLOW, szMiscArray, 4);
   					Log("logs/staffban.log", szMiscArray);
   				}
   				else return SendClientMessage(playerid, COLOR_WHITE, "You cannot do this to an equal or higher level administrator!");
			}
			else return SendClientMessage(playerid, COLOR_WHITE, "That player is not connected!");
		}
	}
	else return SendClientMessage(playerid, COLOR_WHITE, "You are not authorized to preform this command!");
	return 1;
}

CMD:staffbans(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] > 1)
	{
		new staffbans;
		szMiscArray[0] = 0;
		SendClientMessage(playerid, COLOR_WHITE, "-------------------------------------------------------------");

		for(new i; i < GetPlayerPoolSize(); i++)
		{
			if(PlayerInfo[i][pStaffBanned] >= 1)
			{
				format(szMiscArray, 256, "Username: %s | Reason: %s");
				SendClientMessage(playerid, COLOR_GREY, szMiscArray);

				staffbans++;
			}
		}

		if(staffbans == 0) SendClientMessage(playerid, COLOR_GREY, "There is nobody online currently serving an active staff ban.");

		SendClientMessage(playerid, COLOR_WHITE, "-------------------------------------------------------------");
	}
	else return SendClientMessage(playerid, COLOR_WHITE, "You are not authorized to preform this command!");
	return 1;
}

CMD:ostaffban(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] > 1)
	{
		new username[16];
		if(sscanf(params, "s[16]", username)) 
		{
			return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /ostaffban [username]");
		}
		else
		{
			if(IsPlayerConnected(ReturnUser(username))) return SendClientMessageEx(playerid, COLOR_GREY, "That player is currently connected, use /staffban.");

			mysql_escape_string(params, username);
			SetPVarString(playerid, "OnStaffBan", username);

			format(szMiscArray,sizeof(szMiscArray),"UPDATE `accounts` SET `AdminLevel` = 0, `HR` = 0, `AP` = 0, `Security` = 0, `ShopTech` = 0, `FactionModerator` = 0, `GangModerator` = 0, \
				`Undercover` = 0, `BanAppealer` = 0, `Helper` = 0, `pVIPMod` = 0, `SecureIP` = '0.0.0.0', `SeniorModerator` = 0, `BanAppealer` = 0, `ShopTech` = 0, `StaffBanned` = 1 WHERE `Username`= '%s' AND `AdminLevel` < %d AND `StaffBanned` = 0", username, PlayerInfo[playerid][pAdmin]);
			mysql_tquery(MainPipeline, szMiscArray, false, "OnStaffBan", "ii", playerid, 1);

			format(szMiscArray, sizeof(szMiscArray), "Attempting to staff ban %s's account.", username);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
		}
	}
	else return SendClientMessage(playerid, COLOR_WHITE, "You are not authorized to preform this command!");
	return 1;
}

CMD:ounstaffban(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] > 1)
	{
		new username[16];
		if(sscanf(params, "s[16]", username)) 
		{
			return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /ounstaffban [username]");
		}
		else
		{
			if(IsPlayerConnected(ReturnUser(username))) return SendClientMessageEx(playerid, COLOR_GREY, "That player is currently connected, use /staffban.");

			mysql_escape_string(params, username);
			SetPVarString(playerid, "OnStaffBan", username);

			format(szMiscArray,sizeof(szMiscArray),"UPDATE `accounts` SET `StaffBanned` = 0 WHERE `Username`= '%s'", username, PlayerInfo[playerid][pAdmin]);
			mysql_tquery(MainPipeline, szMiscArray, false, "OnStaffBan", "ii", playerid, 0);

			format(szMiscArray, sizeof(szMiscArray), "Attempting to remove the staff ban from %s's account.", username);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
		}
	}
	else return SendClientMessage(playerid, COLOR_WHITE, "You are not authorized to preform this command!");
	return 1;
}

forward OnStaffBan(index, value);
public OnStaffBan(index, value)
{
	print("test");
	new string[128], name[24];
	GetPVarString(index, "OnStaffBan", name, 24);

	if(mysql_affected_rows(MainPipeline)) {
		format(string, sizeof(string), "You have successfully %s %s's account.", ((value) ? ("staff banned") : ("removed the staff ban from")), name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s has had their %s offline by %s.", name, ((value) ? ("account staff banned") : ("staff ban removed")), GetPlayerNameEx(index));
		Log("logs/staffban.log", string);
	}
	else {
		format(string, sizeof(string), "There was an issue with %s %s's account.", ((value) ? ("staff banning") : ("removing the staff ban from")), name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnStaffBan");
	return 1;
}