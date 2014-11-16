/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Advisory System

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

CMD:advisors(playerid, params[])
{
    new string[128];
    if(PlayerInfo[playerid][pHelper] >= 1) {
        SendClientMessageEx(playerid, COLOR_GRAD1, "Advisors Online:");
        //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				new tdate[11], thour[9], i_timestamp[3];
				getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
				format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
				format(thour, sizeof(thour), "%02d:00:00", hour);

				if(PlayerInfo[i][pHelper] != 0 && PlayerInfo[i][pHelper] <= PlayerInfo[playerid][pHelper]) {
					if(PlayerInfo[i][pHelper] == 1 && PlayerInfo[i][pAdmin] < 2) {
						format(string, sizeof(string), "** Helper: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
					}
					if(PlayerInfo[i][pHelper] == 2&&PlayerInfo[i][pAdmin]<2) {
						format(string, sizeof(string), "** Community Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
					}
					if(PlayerInfo[i][pHelper] == 3&&PlayerInfo[i][pAdmin]<2) {
						format(string, sizeof(string), "** Senior Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
					}
					if(PlayerInfo[i][pHelper] >= 4&&PlayerInfo[i][pAdmin]<2) {
						format(string, sizeof(string), "** Chief Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
					}
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
				}
			}	
        }
    }
    else if(PlayerInfo[playerid][pAdmin] >= 2) {
        SendClientMessageEx(playerid, COLOR_GRAD1, "Advisors Online:");
        //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pHelper] >= 1) {
					new tdate[11], thour[9], i_timestamp[3];
					getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
					format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
					format(thour, sizeof(thour), "%02d:00:00", hour);

					if(PlayerInfo[i][pHelper] == 1&&PlayerInfo[i][pAdmin]<2) {
						format(string, sizeof(string), "** Helper: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
					}
					if(PlayerInfo[i][pHelper] == 2&&PlayerInfo[i][pAdmin]<2) {
						if(GetPVarInt(i, "AdvisorDuty") == 1) {
							format(string, sizeof(string), "** Community Advisor: %s (On Duty)	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
						else {
							format(string, sizeof(string), "** Community Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
					}
					if(PlayerInfo[i][pHelper] == 3&&PlayerInfo[i][pAdmin]<2) {
						if(GetPVarInt(i, "AdvisorDuty") == 1) {
							format(string, sizeof(string), "** Senior Advisor: %s (On Duty)	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
						else {
							format(string, sizeof(string), "** Senior Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
					}
					if(PlayerInfo[i][pHelper] >= 4&&PlayerInfo[i][pAdmin]<2) {
						if(GetPVarInt(i, "AdvisorDuty") == 1) {
							format(string, sizeof(string), "** Chief Advisor: %s (On Duty)	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
						else {
							format(string, sizeof(string), "** Chief Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
					}
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
				}
			}	
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "If you have questions regarding gameplay, or the server use /newb.");
        SendClientMessageEx(playerid, COLOR_GRAD1, "If you see suspicious happenings/players /report [id] [reason].");
    }
    return 1;
}

CMD:cduty(playerid, params[])
{
    if(PlayerInfo[playerid][pHelper] >= 2)
	{
        if(GetPVarInt(playerid, "AdvisorDuty") == 1)
		{
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are now off duty as a Community Advisor and will not receive calls anymore.");
            DeletePVar(playerid, "AdvisorDuty");
            Advisors -= 1;
        }
        else
		{
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are now on duty as a Community Advisor and will receive calls from people in need.");
            SetPVarInt(playerid, "AdvisorDuty", 1);
            Advisors += 1;
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not a Community Advisor!");
    }
    return 1;
}

CMD:nonewbie(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3 || PlayerInfo[playerid][pHelper] >= 4)
	{
		if (!nonewbie)
		{
			nonewbie = 1;
			SendClientMessageToAllEx(COLOR_GRAD2, "Newbie chat channel disabled by an Admin/Advisor!");
		}
		else
		{
			nonewbie = 0;
			SendClientMessageToAllEx(COLOR_GRAD2, "Newbie chat channel enabled by an Admin/Advisor!");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:tognewbie(playerid, params[])
{
	if (PlayerInfo[playerid][pNewbieTogged] == 0)
	{
		PlayerInfo[playerid][pNewbieTogged] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have disabled newbie chat.");
	}
	else
	{
		PlayerInfo[playerid][pNewbieTogged] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have enabled newbie chat.");
	}
	return 1;
}