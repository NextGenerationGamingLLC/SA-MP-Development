/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Report System

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

forward ReplyTimer(reportid);
public ReplyTimer(reportid)
{
    Reports[reportid][ReportPriority] = 0;
    Reports[reportid][ReportLevel] = 0;
    Reports[reportid][BeingUsed] = 0;
	Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
    Reports[reportid][CheckingReport] = INVALID_PLAYER_ID;
}

stock SendReportToQue(reportfrom, report[], reportlevel, reportpriority)
{
    new newid = INVALID_REPORT_ID, string[128];

	for(new i; i < MAX_REPORTS; ++i)
	{
		if(Reports[i][HasBeenUsed] == 0)
		{
			newid = i;
			break;
		}
    }
    if(newid != INVALID_REPORT_ID)
    {
        switch(reportpriority)
       	{
   	    	case 1:
   	    	{
	        	foreach(new i: Player)
				{
					if(PlayerInfo[i][pAdmin] >= 2 && PlayerInfo[i][pTogReports] == 0)
					{
						GameTextForPlayer(i, "~r~DM Alert", 1500, 1);
					}
				}	
    		}
 	    	case 2:
  	    	{
        		foreach(new i: Player)
				{
					if(PlayerInfo[i][pAdmin] >= reportlevel && PlayerInfo[i][pTogReports] == 0)
					{
						GameTextForPlayer(i, "~p~Priority Report", 1500, 1);
					}
				}	
			}
   			case 3..4:
 	    	{
       			foreach(new i: Player)
				{
					if(PlayerInfo[i][pAdmin] >= reportlevel && PlayerInfo[i][pTogReports] == 0)
					{
						TextDrawSetString(PriorityReport[i], "~y~New Report");
						TextDrawShowForPlayer(i, PriorityReport[i]);
						SetTimerEx("HideReportText", 2000, 0, "d", i);
					}
				}	
    		}
 	    	case 5:
  	    	{
        		foreach(new i: Player)
				{
					if(PlayerInfo[i][pAdmin] >= reportlevel && PlayerInfo[i][pTogReports] == 0)
					{
						//GameTextForPlayer(i, "~w~~n~n~n~Priority 5 Item Pending", 1500, 3);
						TextDrawSetString(PriorityReport[i], "~w~Priority 5 Item Pending");
						TextDrawShowForPlayer(i, PriorityReport[i]);
						SetTimerEx("HideReportText", 2000, 0, "d", i);
					}
				}	
    		}
     	}
     	foreach(new i: Player)
		{
			if(PlayerInfo[i][pAdmin] >= 2 && PlayerInfo[i][pTogReports] == 0 && !GetPVarType(i, "TogReports")) {
				format(string, sizeof(string), "%s (ID: %i) | RID: %i | %s | Pend: 0 mins | Pr: %i", GetPlayerNameEx(reportfrom), reportfrom, newid, report, reportpriority);
				SendClientMessageEx(i, COLOR_REPORT, string);
			}
			else if((reportpriority == 1 || reportpriority == 2) && PlayerInfo[i][pTogReports] == 0 && GetPVarType(i, "TogReports")) {
				format(string, sizeof(string), "%s (ID: %i) | RID: %i | %s | Pend: 0 mins | Pr: %i", GetPlayerNameEx(reportfrom), reportfrom, newid, report, reportpriority);
				SendClientMessageEx(i, COLOR_REPORT, string);
			}
		}	
     	SetPVarInt(reportfrom, "HasReport", 1);

     	format(string, sizeof(string), "%s | SQLID: %i | RID: %i | Report: %s | Pr: %i", GetPlayerNameEx(reportfrom), GetPlayerSQLId(reportfrom), newid, report, reportpriority);
     	Log("logs/report.log", string);

        if(reportlevel == 2)
		{
        	strmid(Reports[newid][Report], report, 0, strlen(report), 128);
        	Reports[newid][ReportFrom] = reportfrom;
        	Reports[newid][TimeToExpire] = 0;
        	Reports[newid][HasBeenUsed] = 1;
        	Reports[newid][BeingUsed] = 1;
        	Reports[newid][ReportPriority] = reportpriority;
        	Reports[newid][ReportExpireTimer] = SetTimerEx("ReportTimer", 60000, 0, "d", newid);
		}
		else
		{
		    strmid(Reports[newid][Report], report, 0, strlen(report), 128);
        	Reports[newid][ReportFrom] = reportfrom;
        	Reports[newid][TimeToExpire] = 0;
        	Reports[newid][HasBeenUsed] = 1;
        	Reports[newid][BeingUsed] = 1;
        	Reports[newid][ReportPriority] = reportpriority;
        	Reports[newid][ReportExpireTimer] = SetTimerEx("ReportTimer", 60000, 0, "d", newid);
		}
    }
    else
    {
        ClearReports();
        SendReportToQue(reportfrom, report, reportlevel, reportpriority);
    }
}

stock ClearReports()
{
	for(new i=0;i<MAX_REPORTS;i++)
	{
	    if(Reports[i][BeingUsed] == 1) {
			DeletePVar(Reports[i][ReportFrom], "HasReport");
		}
		if(GetPVarInt(Reports[i][ReportFrom], "AlertedThisPlayer"))
		{
			DeletePVar(Reports[i][ReportFrom], "AlertedThisPlayer");
			DeletePVar(Reports[i][ReportFrom], "AlertType");
			if(AlertTime[Reports[i][ReportFrom]] != 0) AlertTime[Reports[i][ReportFrom]] = 0;
		}
		strmid(Reports[i][Report], "None", 0, 4, 4);
		Reports[i][CheckingReport] = INVALID_PLAYER_ID;
        Reports[i][ReportFrom] = INVALID_PLAYER_ID;
        Reports[i][TimeToExpire] = 0;
        Reports[i][HasBeenUsed] = 0;
        Reports[i][BeingUsed] = 0;
        Reports[i][ReportPriority] = 0;
        Reports[i][ReportLevel] = 0;
	}
	return 1;
}

forward ReportTimer(reportid);
public ReportTimer(reportid)
{
	if(Reports[reportid][BeingUsed] == 1)
	{
	    if(Reports[reportid][TimeToExpire] >= 0)
	    {
	        Reports[reportid][TimeToExpire]++;
  			Reports[reportid][ReportExpireTimer] = SetTimerEx("ReportTimer", 60000, 0, "d", reportid);
		}
	}
	return 1;
}

CMD:clearallreports(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 1337) {
        new string[128];
        ClearReports();
        SendClientMessageEx(playerid,COLOR_GRAD1, "You have cleared all the active reports.");
        format(string, sizeof(string), "AdmCmd: %s has cleared all the pending reports.", GetPlayerNameEx(playerid));
        ABroadCast(COLOR_LIGHTRED, string, 2);
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:checkreportcount(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		new string[128], adminname[MAX_PLAYER_NAME], tdate[11];
		if(sscanf(params, "s[24]s[11]", adminname, tdate)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /checkreportcount [admin name] [date (YYYY-MM-DD)]");
		new giveplayerid = ReturnUser(adminname);
		if(IsPlayerConnected(giveplayerid) && PlayerInfo[giveplayerid][pAdmin] >= 2)
		{
			mysql_format(MainPipeline, string, sizeof(string), "SELECT SUM(count) FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s'", GetPlayerSQLId(giveplayerid), tdate);
			mysql_tquery(MainPipeline, string, "QueryCheckCountFinish", "issi", playerid, GetPlayerNameEx(giveplayerid), tdate, 0);
			mysql_format(MainPipeline, string, sizeof(string), "SELECT `count`, `hour` FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s' ORDER BY `hour` ASC", GetPlayerSQLId(giveplayerid), tdate);
			mysql_tquery(MainPipeline, string, "QueryCheckCountFinish", "issi", playerid, GetPlayerNameEx(giveplayerid), tdate, 1);
		}
		else
		{
			new tmpName[MAX_PLAYER_NAME];
			mysql_escape_string(adminname, tmpName);
			mysql_format(MainPipeline, string, sizeof(string), "SELECT `id`, `Username` FROM `accounts` WHERE `Username` = '%s'", tmpName);
			mysql_tquery(MainPipeline, string, "QueryUsernameCheck", "isi", playerid, tdate, 0);
		}
    }
    return 1;
}

CMD:togchatreports(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2) {

	    if(GetPVarType(playerid, "TogReports")) {

	        DeletePVar(playerid, "TogReports");
	        SendClientMessageEx(playerid, COLOR_WHITE, "You will now see all reports.");
	    }
	    else {
	        SetPVarInt(playerid, "TogReports", 1);
	        SendClientMessageEx(playerid, COLOR_WHITE, "You will now see priority reports only.");
	    }
	}
	return 1;
}

CMD:togreports(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pUndercover] >= 1)
	{
		switch(PlayerInfo[playerid][pTogReports])
		{
			case 0:
			{
				PlayerInfo[playerid][pTogReports] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have went into spec ops mode, you will be unable to see admin messages.");
			}
			case 1:
			{
				PlayerInfo[playerid][pTogReports] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "You are now out of spec ops mode, you will be able to see admin messages.");
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You aren't authorized to use this command.");
	}
	return 1;
}

CMD:reporttips(playerid, params[])
{
	ShowPlayerDialogEx(playerid,7955,DIALOG_STYLE_MSGBOX,"Report tips","Tips when reporting:\n- Report what you need, not who you need.\n- Be specific, report exactly what you need.\n- Do not make false reports.\n- Do not flame admins.\n- Report only for in-game items.\n- For shop orders use the /shoporder command","Close", "");
	return 1;
}

CMD:reply(playerid, params[])
{
	new string[128];
	new reportid = INVALID_REPORT_ID;
	for(new i = 0; i < MAX_REPORTS; i++)
	{
		if(Reports[i][ReportFrom] == playerid && Reports[i][CheckingReport] != INVALID_PLAYER_ID)
		{
			reportid = i;
		}
	}
	if(reportid == INVALID_REPORT_ID)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have any reports being reviewed at the moment.");
		return 1;
	}
	if (IsPlayerConnected(Reports[reportid][CheckingReport]))
	{
		format(string, sizeof(string), "%s(ID: %d) replies: %s", GetPlayerNameEx(playerid), playerid, params);
		SendClientMessageEx(Reports[reportid][CheckingReport], COLOR_YELLOW, string);

		format(string, sizeof(string), "Reply sent to %s: %s", GetPlayerNameEx(Reports[reportid][CheckingReport]), params);
		SendClientMessageEx(playerid,  COLOR_YELLOW, string);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Player not connected.");
	return 1;
}

CMD:rmute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pAP] >= 2 || PlayerInfo[playerid][pHR] >= 3)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /rmute [player]");
		if(PlayerInfo[giveplayerid][pAdmin] > 1) return SendClientMessageEx(playerid, COLOR_GREY, "You can't report mute an Admin.");
		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pRMuted] == 0)
			{
				PlayerInfo[giveplayerid][pRMuted] = 1;
				format(string, sizeof(string), "AdmCmd: %s has indefinitely blocked %s from submitting reports.",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ABroadCast(COLOR_LIGHTRED,string,2);
				format(string, sizeof(string), "You have been blocked from submitting /reports by %s.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, "You will not be able to submit reports until you are unblocked. To appeal this action contact hr@ng-gaming.net.");
				format(string, sizeof(string), "AdmCmd: %s(%d) was blocked from /report by %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
				Log("logs/mute.log", string);
			}
			else
			{
				PlayerInfo[giveplayerid][pRMuted] = 0;
				format(string, sizeof(string), "AdmCmd: %s has been re-allowed to submit reports by %s",GetPlayerNameEx(giveplayerid),GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED,string,2);
				format(string, sizeof(string), "You have been re-allowed to submitting /reports again by %s.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
				format(string, sizeof(string), "AdmCmd: %s(%d) was unblocked from /report by %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
				Log("logs/mute.log", string);
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:rto(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new string[512], giveplayerid, reason[64];
		if(sscanf(params, "us[64]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /rto [player] [reason]");
		if(PlayerInfo[giveplayerid][pAdmin] > 1) return SendClientMessageEx(playerid, COLOR_GREY, "You can't report mute an Admin.");
		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pRMuted] == 0)
			{
			    if(PlayerInfo[giveplayerid][pRMutedTotal] == 0)
			    {
  					PlayerInfo[giveplayerid][pRMutedTotal] = 1;
					format(string, sizeof(string), "AdmCmd: %s has given %s their first warning about report abuse, reason: %s",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
					ABroadCast(COLOR_LIGHTRED,string,2);

					format(string, sizeof(string), "An admin warns you not to abuse /report.\n\nNote that future abuse of /report could result in a mute from /report or loss of that privilege altogether.");
					ShowPlayerDialogEx(giveplayerid,7954,DIALOG_STYLE_MSGBOX,"Report abuse warning", string,"Next", "");

					format(string, sizeof(string), "AdmCmd: %s has given %s(%d) their first warning about report abuse, reason: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), reason);
					Log("logs/mute.log", string);

			    }
			    else if(PlayerInfo[giveplayerid][pRMutedTotal] == 1)
			    {
  					PlayerInfo[giveplayerid][pRMuted] = 2;
  					PlayerInfo[giveplayerid][pRMutedTotal] = 2;
					PlayerInfo[giveplayerid][pRMutedTime] = 15*60;
					format(string, sizeof(string), "AdmCmd: %s has temporarily blocked %s from submitting reports, reason: %s",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
					ABroadCast(COLOR_LIGHTRED,string,2);

					format(string, sizeof(string), "You have been temporarily blocked from submitting reports by %s, reason: %s.\n\nAs this is the second time you have been blocked from reporting, you will not be able to use /report for 15 minutes.\n\nNote that future abuse of /report could result in a longer mute from /report or loss of that privilege altogether.", GetPlayerNameEx(playerid), reason);
					ShowPlayerDialogEx(giveplayerid,7954,DIALOG_STYLE_MSGBOX,"Temporarily blocked from reports", string,"Next", "");

					format(string, sizeof(string), "AdmCmd: %s(%d) was temporarily blocked from /report by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason);
					Log("logs/mute.log", string);
			    }
			    else if(PlayerInfo[giveplayerid][pRMutedTotal] == 2)
			    {
  					PlayerInfo[giveplayerid][pRMuted] = 2;
  					PlayerInfo[giveplayerid][pRMutedTotal] = 3;
					PlayerInfo[giveplayerid][pRMutedTime] = 30*60;
					format(string, sizeof(string), "AdmCmd: %s has temporarily blocked %s from submitting reports, reason: %s",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
					ABroadCast(COLOR_LIGHTRED,string,2);

					format(string, sizeof(string), "You have been temporarily blocked from submitting reports by %s, reason: %s.\n\nAs this is the third time you have been blocked from reporting, you will not be able to use /report for 30 minutes.\n\nNote that future abuse of /report could result in a longer mute from /report or loss of that privilege altogether.", GetPlayerNameEx(playerid), reason);
					ShowPlayerDialogEx(giveplayerid,7954,DIALOG_STYLE_MSGBOX,"Temporarily blocked from reports", string,"Next", "");

					format(string, sizeof(string), "AdmCmd: %s(%d) was temporarily blocked from /report by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason);
					Log("logs/mute.log", string);
			    }
			    else if(PlayerInfo[giveplayerid][pRMutedTotal] == 3)
			    {
  					PlayerInfo[giveplayerid][pRMuted] = 2;
  					PlayerInfo[giveplayerid][pRMutedTotal] = 4;
					PlayerInfo[giveplayerid][pRMutedTime] = 45*60;
					format(string, sizeof(string), "AdmCmd: %s has temporarily blocked %s from submitting reports, reason: %s",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
					ABroadCast(COLOR_LIGHTRED,string,2);

					format(string, sizeof(string), "You have been temporarily blocked from submitting reports by %s, reason: %s.\n\nAs this is the fourth time you have been blocked from reporting, you will not be able to use /report for 45 minutes.\n\nNote that future abuse of /report could result in a longer mute from /report or loss of that privilege altogether.", GetPlayerNameEx(playerid), reason);
					ShowPlayerDialogEx(giveplayerid,7954,DIALOG_STYLE_MSGBOX,"Temporarily blocked from reports", string,"Next", "");

					format(string, sizeof(string), "AdmCmd: %s(%d) was temporarily blocked from /report by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason);
					Log("logs/mute.log", string);
				}
			    else if(PlayerInfo[giveplayerid][pRMutedTotal] == 4)
			    {
  					PlayerInfo[giveplayerid][pRMuted] = 2;
  					PlayerInfo[giveplayerid][pRMutedTotal] = 5;
					PlayerInfo[giveplayerid][pRMutedTime] = 60*60;
					format(string, sizeof(string), "AdmCmd: %s has temporarily blocked %s from submitting reports, reason: %s",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
					ABroadCast(COLOR_LIGHTRED,string,2);

					format(string, sizeof(string), "You have been temporarily blocked from submitting reports by %s, reason: %s.\n\nAs this is the fifth time you have been blocked from reporting, you will not be able to use /report for 60 minutes.\n\nNote that future abuse of /report could result in a loss of that privilege altogether.", GetPlayerNameEx(playerid), reason);
					ShowPlayerDialogEx(giveplayerid,7954,DIALOG_STYLE_MSGBOX,"Temporarily blocked from reports", string,"Next", "");

					format(string, sizeof(string), "AdmCmd: %s(%d) was temporarily blocked from /report by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason);
					Log("logs/mute.log", string);
				}
			    else if(PlayerInfo[giveplayerid][pRMutedTotal] >= 5)
			    {
  					PlayerInfo[giveplayerid][pRMuted] = 2;
  					PlayerInfo[giveplayerid][pRMutedTotal] = 6;
					PlayerInfo[giveplayerid][pRMutedTime] = 300*60;
					format(string, sizeof(string), "AdmCmd: %s has temporarily blocked %s from submitting reports, reason: %s",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
					ABroadCast(COLOR_LIGHTRED,string,2);

					format(string, sizeof(string), "You have been temporarily blocked from submitting reports by %s, reason: %s.\n\nAs this is the sixth time you have been blocked from reporting, you will not be able to use /report for 5 hours.\n\nNote that future abuse of /report could result in a loss of that privilege altogether.", GetPlayerNameEx(playerid), reason);
					ShowPlayerDialogEx(giveplayerid,7954,DIALOG_STYLE_MSGBOX,"Temporarily blocked from reports", string,"Next", "");

					format(string, sizeof(string), "AdmCmd: %s(%d) was temporarily blocked from /report by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason);
					Log("logs/mute.log", string);
				}

				for(new i = 0; i < MAX_REPORTS; i++)
				{
					if(Reports[i][ReportFrom] == giveplayerid)
					{
						Reports[i][BeingUsed] = 0;
					}
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That person is already disabled from /reports.");
			}

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:rtoreset(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new string[128], giveplayerid, reason[64];
		if(sscanf(params, "us[64]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /rtoreset [player] [reason]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pRMuted] == 2)
			{
				PlayerInfo[giveplayerid][pRMuted] = 0;
				PlayerInfo[giveplayerid][pRMutedTotal]--;
				PlayerInfo[giveplayerid][pRMutedTime] = 0;
				format(string, sizeof(string), "AdmCmd: %s has unblocked %s from reporting, reason: %s",GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid), reason);
				ABroadCast(COLOR_LIGHTRED,string,2);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, "You have been unblocked from submitting reports. You may now use the reporting system again.");
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Please accept our apologies for any error and inconvenience this may have caused.");
				format(string, sizeof(string), "AdmCmd: %s(%d) was unblocked from /report by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason);
				Log("logs/mute.log", string);
			}
			else
			{
			    SendClientMessageEx(playerid, COLOR_GRAD1, "That person is not blocked from reporting!");
			}

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:report(playerid, params[])
{
    if(GetPVarType(playerid, "HasReport")) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
	}
 	else if(PlayerInfo[playerid][pAdmin] >= 2 && PlayerInfo[playerid][pAdmin] < 1338) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can't submit reports as an administrator.");
	}
	else if(PlayerInfo[playerid][pRMuted] != 0) {
	    ShowPlayerDialogEx(playerid, 7955, DIALOG_STYLE_MSGBOX,"Report blocked","You are blocked from submitting any reports!\n\nTips when reporting:\n- Report what you need, not who you need.\n- Be specific, report exactly what you need.\n- Do not make false reports.\n- Do not flame admins.\n- Report only for in-game items.\n- For shop orders use the /shoporder command","Close", "");
	}
	else {
	    ShowPlayerDialogEx(playerid, DIALOG_REPORTMENU, DIALOG_STYLE_LIST, "Report Menu [1/2]", "Deathmatch\nFalling\nHacking\nChicken Running\nCar Ramming\nPower Gaming\nMeta Gaming\nGun Discharge Exploits (QS/CS)\nSpamming\nMoney Farming\nBan Evader\nGeneral Exploits\nReleasing Hitman Names\nRunning Man Exploiter\nCar Surfing\nNonRP Behavior\nNext Page","Select", "Exit");
	}
	return 1;
}

CMD:cancelreport(playerid, params[])
{
	for(new i = 999; i > 0; i--)
	{
		if(Reports[i][ReportFrom] == playerid)
		{
			if(GetPVarType(Reports[i][ReportFrom], "AlertedThisPlayer"))
			{
				DeletePVar(Reports[i][ReportFrom], "AlertedThisPlayer");
				DeletePVar(Reports[i][ReportFrom], "AlertType");
				if(AlertTime[Reports[i][ReportFrom]] != 0) AlertTime[Reports[i][ReportFrom]] = 0;
			}
			if(GetPVarInt(Reports[i][ReportFrom], "RequestingAdP") == 1)
			{
				DeletePVar(Reports[i][ReportFrom], "PriorityAdText");
				DeletePVar(Reports[i][ReportFrom], "RequestingAdP");
			}
			Reports[i][ReportFrom] = INVALID_PLAYER_ID;
			Reports[i][BeingUsed] = 0;
			Reports[i][TimeToExpire] = 0;
			Reports[i][ReportPriority] = 0;
			Reports[i][ReportLevel] = 0;
			strmid(Reports[i][Report], "None", 0, 4, 4);
			DeletePVar(playerid, "HasReport");
			DeletePVar(playerid, "_rAutoM");
			DeletePVar(playerid, "_rRepID");
			SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully canceled your report." );
			return 1;
		}
	}
	SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have any pending reports.");
	return 1;
}

CMD:reports(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128];
		SendClientMessageEx(playerid, COLOR_GREEN, "____________________ REPORTS _____________________");
		for(new i = 999; i >= 0; i--)
		{
			if(Reports[i][BeingUsed] == 1 && Reports[i][ReportPriority] == 5)
			{
			    if(Reports[i][ReportLevel] == 2 || PlayerInfo[playerid][pAdmin] >= 2)
			    {
					format(string, sizeof(string), "%s (ID: %i) | RID: %i | %s | Pend: %d mins | Pr: %i", GetPlayerNameEx(Reports[i][ReportFrom]), Reports[i][ReportFrom], i, (Reports[i][Report]), Reports[i][TimeToExpire], Reports[i][ReportPriority]);
					SendClientMessageEx(playerid, COLOR_REPORT, string);
				}
			}
		}
		for(new i = 999; i >= 0; i--)
		{
			if(Reports[i][BeingUsed] == 1 && Reports[i][ReportPriority] == 4)
			{
			    if(Reports[i][ReportLevel] == 2 || PlayerInfo[playerid][pAdmin] >= 2)
			    {
					format(string, sizeof(string), "%s (ID: %i) | RID: %i | %s | Pend: %d mins | Pr: %i", GetPlayerNameEx(Reports[i][ReportFrom]), Reports[i][ReportFrom], i, (Reports[i][Report]), Reports[i][TimeToExpire], Reports[i][ReportPriority]);
					SendClientMessageEx(playerid, COLOR_REPORT, string);
				}
			}
		}
		for(new i = 999; i >= 0; i--)
		{
			if(Reports[i][BeingUsed] == 1 && Reports[i][ReportPriority] == 3)
			{
			    if(Reports[i][ReportLevel] == 2 || PlayerInfo[playerid][pAdmin] >= 2)
			    {
					format(string, sizeof(string), "%s (ID: %i) | RID: %i | %s | Pend: %d mins | Pr: %i", GetPlayerNameEx(Reports[i][ReportFrom]), Reports[i][ReportFrom], i, (Reports[i][Report]), Reports[i][TimeToExpire], Reports[i][ReportPriority]);
					SendClientMessageEx(playerid, COLOR_REPORT, string);
				}
			}
		}
		for(new i = 999; i >= 0; i--)
		{
			if(Reports[i][BeingUsed] == 1 && Reports[i][ReportPriority] == 2)
			{
			    if(Reports[i][ReportLevel] == 2 || PlayerInfo[playerid][pAdmin] >= 2)
			    {
					format(string, sizeof(string), "%s (ID: %i) | RID: %i | %s | Pend: %d mins | Pr: %i", GetPlayerNameEx(Reports[i][ReportFrom]), Reports[i][ReportFrom], i, (Reports[i][Report]), Reports[i][TimeToExpire], Reports[i][ReportPriority]);
					SendClientMessageEx(playerid, COLOR_REPORT, string);
				}
			}
		}
		for(new i = 999; i >= 0; i--)
		{
			if(Reports[i][BeingUsed] == 1 && Reports[i][ReportPriority] == 1)
			{
			    if(Reports[i][ReportLevel] == 2 || PlayerInfo[playerid][pAdmin] >= 2)
			    {
					format(string, sizeof(string), "%s (ID: %i) | RID: %i | %s | Pend: %d mins | Pr: %i", GetPlayerNameEx(Reports[i][ReportFrom]), Reports[i][ReportFrom], i, (Reports[i][Report]), Reports[i][TimeToExpire], Reports[i][ReportPriority]);
					SendClientMessageEx(playerid, COLOR_REPORT, string);
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREEN, "___________________________________________________");
	}
	return 1;
}

CMD:sta(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], reportid;
		if(sscanf(params, "d", reportid)) return SendClientMessageEx(playerid, COLOR_WHITE,"USAGE: /sta [reportid]");

		if(reportid < 0 || reportid > 999) { SendClientMessageEx(playerid, COLOR_GREY, "   Report ID not below 0 or above 999!"); return 1; }
		if(Reports[reportid][BeingUsed] == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
			return 1;
		}
		if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "RequestingAdP") == 1)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot trash/post this advertisement, you must accept it with /ar.");
		}
		if(GetPVarType(Reports[reportid][ReportFrom], "AlertedThisPlayer"))
		{
			DeletePVar(Reports[reportid][ReportFrom], "AlertedThisPlayer");
			DeletePVar(Reports[reportid][ReportFrom], "AlertType");
			if(AlertTime[Reports[reportid][ReportFrom]] != 0) AlertTime[Reports[reportid][ReportFrom]] = 0;
		}
		if(Advisors < 1)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "There are no Advisors On Duty at the moment, try again later!");
			return 1;
		}

		format(string, sizeof(string), "AdmCmd: %s has sent %s (ID: %i) report RID: %i) to the Advisors.", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]),Reports[reportid][ReportFrom],reportid);
		ABroadCast(COLOR_ORANGE, string, 2);
		Log("logs/report.log", string);
		if(PlayerInfo[playerid][pAdmin] == 1)
		{
			SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "An admin has reviewed your report and referred it to the Advisors.");
			SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "An Advisor should be with you shortly.");
			SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "Newer players are encouraged to use /requesthelp for any questions you may have as opposed to using /report which is to report rule violations and get admin help.");
			SetPVarInt( Reports[reportid][ReportFrom], "COMMUNITY_ADVISOR_REQUEST", 1 );
			format(string, sizeof(string), "An Admin has referred a report over to you. person %s (ID: %d) stated: %s", GetPlayerNameEx(Reports[reportid][ReportFrom]), Reports[reportid][ReportFrom], Reports[reportid][Report]);
			SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
			SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, "Please type /accepthelp to teleport to the player.");
		}
		else
		{
			format(string, sizeof(string), "%s has reviewed your report and referred it to the Advisors.", GetPlayerNameEx(playerid));
			SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
			SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "An Advisor should be with you shortly.");
			SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "Newer players are encouraged to use /requesthelp for any questions you may have as opposed to using /report which is to report rule violations and get admin help.");
			SetPVarInt( Reports[reportid][ReportFrom], "COMMUNITY_ADVISOR_REQUEST", 1 );
			format(string, sizeof(string), "Admin %s has referred a report over to you. person %s (ID: %d) stated: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]), Reports[reportid][ReportFrom], Reports[reportid][Report]);
			SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
			SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, "Please type /accepthelp to teleport to the player.");
		}

		PlayerInfo[playerid][pAcceptReport]++;
		ReportCount[playerid]++;
		ReportHourCount[playerid]++;
		Reports[reportid][BeingUsed] = 0;
		DeletePVar(Reports[reportid][ReportFrom], "HasReport");
		DeletePVar(Reports[reportid][ReportFrom], "_rAutoM");
		DeletePVar(Reports[reportid][ReportFrom], "_rRepID");		Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
		Reports[reportid][CheckingReport] = INVALID_PLAYER_ID;
		strmid(Reports[reportid][Report], "None", 0, 4, 4);
	}
	return 1;
}

CMD:ar(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], reportid;
		if(sscanf(params, "d", reportid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ar [reportid]");

		if(reportid < 0 || reportid > 999) { SendClientMessageEx(playerid, COLOR_GREY, "   Report ID not below 0 or above 999!"); return 1; }
		if(Reports[reportid][BeingUsed] == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
			return 1;
		}
		if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "ReverseReport") == 1) 
		{
			new reversereason[24];
			GetPVarString(Reports[reportid][ReportFrom], "ReverseReason", reversereason, 24);
			DeletePVar(Reports[reportid][ReportFrom], "ReverseReport");
			SetPVarInt(playerid, "ReverseFromID", Reports[reportid][ReportFrom]);
			format(string, 128, "%s would like to reverse their action on %s.\n\nReason: %s", GetPlayerNameEx(Reports[reportid][ReportFrom]), GetPlayerNameEx(GetPVarInt(Reports[reportid][ReportFrom], "ReverseID")), reversereason);
			ShowPlayerDialogEx(playerid, DIALOG_REVERSE, DIALOG_STYLE_MSGBOX, "Reverse Action", string, "Allow", "Deny");
			format(string, sizeof(string), "AdmCmd: %s has accepted the report from %s (ID: %i, RID: %i).", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]),Reports[reportid][ReportFrom],reportid);
			ABroadCast(COLOR_ORANGE, string, 2);
     		Log("logs/report.log", string);
			PlayerInfo[playerid][pAcceptReport]++;
			ReportCount[playerid]++;
			ReportHourCount[playerid]++;
			Reports[reportid][BeingUsed] = 0;
			Reports[reportid][TimeToExpire] = 0;
			strmid(Reports[reportid][Report], "None", 0, 4, 4);
			DeletePVar(Reports[reportid][ReportFrom], "HasReport");
			return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "AccountRestrictionReport") == 1)
		{
			if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot accept this report!");
			SetPVarInt(playerid, "PendingAction4", GetPVarInt(Reports[reportid][ReportFrom], "AccountRestID"));
			DeletePVar(Reports[reportid][ReportFrom], "AccountRestrictionReport");
			DeletePVar(Reports[reportid][ReportFrom], "AccountRestID");
			ShowPlayerDialogEx(playerid, DIALOG_NONRPACTION, DIALOG_STYLE_MSGBOX, "Account Restriction", "This player has 15+ Non RP Points, would you like to restrict his account?", "Yes", "No");
		}
		if(GetPVarType(Reports[reportid][ReportFrom], "AlertedThisPlayer"))
		{
			if(AlertTime[Reports[reportid][ReportFrom]] != 0)
			{
				SetPVarInt(playerid, "PendingAction", GetPVarInt(Reports[reportid][ReportFrom], "AlertType"));
				SetPVarInt(playerid, "PendingAction2", GetPVarInt(Reports[reportid][ReportFrom], "AlertedThisPlayer"));
				SetPVarInt(playerid, "PendingAction3", Reports[reportid][ReportFrom]);
				DeletePVar(Reports[reportid][ReportFrom], "AlertedThisPlayer");
			}
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "RequestingAdP") == 1)
		{
			new advert[128];
			GetPVarString(Reports[reportid][ReportFrom], "PriorityAdText", advert, 128);
			SetPVarInt(playerid, "ReporterID", Reports[reportid][ReportFrom]);
			ShowPlayerDialogEx(playerid, DIALOG_CONFIRMADP, DIALOG_STYLE_MSGBOX, "Advertisement Confirmation", advert, "Approve", "Deny");
			
			format(string, sizeof(string), "AdmCmd: %s has accepted the report from %s (ID: %i, RID: %i).", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]),Reports[reportid][ReportFrom],reportid);
			ABroadCast(COLOR_ORANGE, string, 2);
			Log("logs/report.log", string);
			PlayerInfo[playerid][pAcceptReport]++;
			ReportCount[playerid]++;
			ReportHourCount[playerid]++;
			Reports[reportid][BeingUsed] = 0;
			Reports[reportid][TimeToExpire] = 0;
			strmid(Reports[reportid][Report], "None", 0, 4, 4);
			DeletePVar(Reports[reportid][ReportFrom], "HasReport");
			return true;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "RequestingNameChange") == 1) {
		    new newname[MAX_PLAYER_NAME];
			GetPVarString(Reports[reportid][ReportFrom], "NewNameRequest", newname, MAX_PLAYER_NAME);

			if(GetPVarInt(Reports[reportid][ReportFrom], "NameChangeCost") > 2) format(string, sizeof(string), "{00BFFF}Old Name: {FFFFFF}%s\n\n{00BFFF}New Name: {FFFFFF}%s\n\n{00BFFF}Price: ${FFFFFF}%s", GetPlayerNameExt(Reports[reportid][ReportFrom]), newname, number_format(GetPVarInt(Reports[reportid][ReportFrom], "NameChangeCost")));
			else format(string, sizeof(string), "{00BFFF}Old Name: {FFFFFF}%s\n\n{00BFFF}New Name: {FFFFFF}%s\n\n{00BFFF}Price: {FFFFFF}Free", GetPlayerNameExt(Reports[reportid][ReportFrom]), newname);
			ShowPlayerDialogEx(playerid, DIALOG_REPORTNAME,DIALOG_STYLE_MSGBOX,"{00BFFF}Name Change Request",string,"Approve","Deny");

			format(string, sizeof(string), "AdmCmd: %s has accepted the report from %s (ID: %i, RID: %i).", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]),Reports[reportid][ReportFrom],reportid);
			ABroadCast(COLOR_ORANGE, string, 2);
			Log("logs/report.log", string);
			PlayerInfo[playerid][pAcceptReport]++;
			ReportCount[playerid]++;
			ReportHourCount[playerid]++;
			Reports[reportid][BeingUsed] = 0;
			Reports[reportid][TimeToExpire] = 0;
			strmid(Reports[reportid][Report], "None", 0, 4, 4);
			DeletePVar(Reports[reportid][ReportFrom], "HasReport");

			SetPVarInt(playerid, "NameChange",Reports[reportid][ReportFrom]);
		    return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "RFLNameRequest") == 1) {
		    new newname[MAX_PLAYER_NAME];
			new gid = Reports[reportid][ReportFrom];
			GetPVarString(Reports[reportid][ReportFrom], "NewRFLName", newname, MAX_PLAYER_NAME);

			format(string, sizeof(string), "{00BFFF}Old Team Name: {FFFFFF}%s\n\n{00BFFF}New Team Name: {FFFFFF}%s", RFLInfo[PlayerInfo[gid][pRFLTeam]][RFLname], newname);
			ShowPlayerDialogEx(playerid, DIALOG_REPORTTEAMNAME,DIALOG_STYLE_MSGBOX,"{00BFFF}Team Name Change Request",string,"Approve","Deny");

			format(string, sizeof(string), "AdmCmd: %s has accepted the report from %s (ID: %i, RID: %i).", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]),Reports[reportid][ReportFrom],reportid);
			ABroadCast(COLOR_ORANGE, string, 2);
			Log("logs/report.log", string);
			PlayerInfo[playerid][pAcceptReport]++;
			ReportCount[playerid]++;
			ReportHourCount[playerid]++;
			Reports[reportid][BeingUsed] = 0;
			Reports[reportid][TimeToExpire] = 0;
			strmid(Reports[reportid][Report], "None", 0, 4, 4);
			DeletePVar(Reports[reportid][ReportFrom], "HasReport");

			SetPVarInt(playerid, "RFLNameChange",Reports[reportid][ReportFrom]);
		    return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "hSignRequest")) {
			new hSignTxt[64];
			GetPVarString(Reports[reportid][ReportFrom], "hSignRequestText", hSignTxt, 64);
			ShowPlayerDialogEx(playerid, DIALOG_REPORT_HSIGN, DIALOG_STYLE_MSGBOX, "{00BFFF}House Sale Sign Text Change", hSignTxt, "Approve", "Deny");

			format(string, sizeof(string), "AdmCmd: %s has accepted the report from %s (ID: %i, RID: %i).", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]),Reports[reportid][ReportFrom],reportid);
			ABroadCast(COLOR_ORANGE, string, 2);
			Log("logs/report.log", string);
			PlayerInfo[playerid][pAcceptReport]++;
			ReportCount[playerid]++;
			ReportHourCount[playerid]++;
			Reports[reportid][BeingUsed] = 0;
			Reports[reportid][TimeToExpire] = 0;
			strmid(Reports[reportid][Report], "None", 0, 4, 4);
			DeletePVar(Reports[reportid][ReportFrom], "HasReport");
			SetPVarInt(playerid, "hSignTextChange", Reports[reportid][ReportFrom]);
			return 1;
		}
		format(string, sizeof(string), "AdmCmd: %s has accepted the report from %s (ID: %i, RID: %i).", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]),Reports[reportid][ReportFrom],reportid);
		ABroadCast(COLOR_ORANGE, string, 2);
		Log("logs/report.log", string);
		AddReportToken(playerid); // Report Tokens
		format(string, sizeof(string), "%s has accepted your report and is reviewing it, you can /reply to send messages to the admin reviewing your report.", GetPlayerNameEx(playerid));
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
		new giveplayerid;
		if(GetPVarType(Reports[reportid][ReportFrom], "_rAutoM")) {
			switch(GetPVarInt(Reports[reportid][ReportFrom], "_rAutoM")) {
				case 1: { // Ad Unmute
					ShowAdMuteFine(Reports[reportid][ReportFrom]);
					format(string, sizeof(string), "You offered %s an unmute from /ads.", GetPlayerNameEx(Reports[reportid][ReportFrom]));
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
				}
				case 2: { // NUnmute
					ShowNMuteFine(Reports[reportid][ReportFrom]);
					format(string, sizeof(string), "You offered %s an unmute from /newb.", GetPlayerNameEx(Reports[reportid][ReportFrom]));
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
				}
				case 3: { // NRN
					giveplayerid = GetPVarInt(Reports[reportid][ReportFrom], "_rRepID");
					if(IsPlayerConnected(giveplayerid)) {
						if (PlayerInfo[giveplayerid][pAdmin] < 2) {
							format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has offered %s a free name change because their name is non-RP.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
							foreach(new i: Player)
							{	
								if(PlayerInfo[i][pSMod] == 1) {
									SendClientMessageEx(i, COLOR_YELLOW, string);
								}
							}	
							ABroadCast( COLOR_YELLOW, string, 2);
							ShowPlayerDialogEx(giveplayerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_GREY, "You cannot offer admins an nrn.");
						}
					}
				}
				case 4: { // RK /kills
					giveplayerid = GetPVarInt(Reports[reportid][ReportFrom], "_rRepID");
					if(IsPlayerConnected(giveplayerid)) {
						SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
						format(string, sizeof(string), "<< Last 10 Kills/Deaths of %s >>", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
						GetLatestKills(playerid, giveplayerid);
						SpectatePlayer(playerid, giveplayerid);
					}
				}
				case 5: { // Auto Spectate
					giveplayerid = GetPVarInt(Reports[reportid][ReportFrom], "_rRepID");
					if(IsPlayerConnected(giveplayerid)) {
						SpectatePlayer(playerid, giveplayerid);
					}
				}
				case 6: { // Bug Player
					giveplayerid = GetPVarInt(Reports[reportid][ReportFrom], "_rRepID");
					if(IsPlayerConnected(giveplayerid)) {
						SetPVarInt(playerid, "BigEar", 6);
						SetPVarInt(playerid, "BigEarPlayer", giveplayerid);
						rBigEarT[playerid] = 30;
						format(string, sizeof(string), "You will hear all messages from %s (ID: %d) for 30 seconds. Use /bigears if you want to disable it.", GetPlayerNameEx(giveplayerid), giveplayerid);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}	
				}
			}
		}		PlayerInfo[playerid][pAcceptReport]++;
		ReportCount[playerid]++;
		ReportHourCount[playerid]++;
		Reports[reportid][ReplyTimerr] = SetTimerEx("ReplyTimer", 30000, 0, "d", reportid);
		Reports[reportid][CheckingReport] = playerid;
		Reports[reportid][BeingUsed] = 0;
		Reports[reportid][TimeToExpire] = 0;
		strmid(Reports[reportid][Report], "None", 0, 4, 4);
		DeletePVar(Reports[reportid][ReportFrom], "HasReport");
		DeletePVar(Reports[reportid][ReportFrom], "_rAutoM");
		DeletePVar(Reports[reportid][ReportFrom], "_rRepID");	}
	return 1;
}

CMD:tr(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], reportid;
		if(sscanf(params, "d", reportid)) return SendClientMessageEx(playerid, COLOR_WHITE,"USAGE: /tr [reportid]");

		if(reportid < 0 || reportid > 999) { SendClientMessageEx(playerid, COLOR_GREY, "   Report ID not below 0 or above 999!"); return 1; }
		if(Reports[reportid][BeingUsed] == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
			return 1;
		}
		if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "RequestingAdP") == 1)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot trash/post this advertisement, you must accept it with /ar.");
		}
		if(GetPVarType(Reports[reportid][ReportFrom], "AlertedThisPlayer"))
		{
			DeletePVar(Reports[reportid][ReportFrom], "AlertedThisPlayer");
			DeletePVar(Reports[reportid][ReportFrom], "AlertType");
			if(AlertTime[Reports[reportid][ReportFrom]] != 0) AlertTime[Reports[reportid][ReportFrom]] = 0;
		}
		format(string, sizeof(string), "AdmCmd: %s has trashed the report from %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]));
		ABroadCast(COLOR_ORANGE, string, 2);
		Log("logs/report.log", string);
		format(string, sizeof(string), "%s has marked your report invalid. It will not be reviewed. Please check /reporttips", GetPlayerNameEx(playerid));
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
		PlayerInfo[playerid][pTrashReport]++;
        DeletePVar(Reports[reportid][ReportFrom], "HasReport");
		DeletePVar(Reports[reportid][ReportFrom], "_rAutoM");
		DeletePVar(Reports[reportid][ReportFrom], "_rRepID");		Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
		Reports[reportid][BeingUsed] = 0;
		Reports[reportid][TimeToExpire] = 0;
		strmid(Reports[reportid][Report], "None", 0, 4, 4);
	}
	return 1;
}

CMD:dmr(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], reportid, giveplayerid;
		if(sscanf(params, "du", reportid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_WHITE,"USAGE: /dmr [reportid] [DM'ers ID]");

		if(reportid < 0 || reportid > 999) { SendClientMessageEx(playerid, COLOR_GREY, "   Report ID not below 0 or above 999!"); return 1; }
		if(Reports[reportid][BeingUsed] == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
			return 1;
		}
		if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "RequestingAdP") == 1)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot trash/post this advertisement, you must accept it with /ar.");
		}
		if(GetPVarType(Reports[reportid][ReportFrom], "AlertedThisPlayer"))
		{
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot forward a DM Alert to the Watch Dogs Team.");
		}
		format(string, sizeof(string), "AdmCmd: %s has forwarded the report from %s (RID: %d) to the DM Report system", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]), reportid);
		ABroadCast(COLOR_ORANGE, string, 2);
		Log("logs/report.log", string);
		format(string, sizeof(string), "%s has acknowledged your report about death matching.", GetPlayerNameEx(playerid));
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "In the future please use the /dmreport command for all reports regarding DM.");

		if(PlayerInfo[Reports[reportid][ReportFrom]][pAdmin] >= 2 || PlayerInfo[Reports[reportid][ReportFrom]][pSMod] == 1) mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO dm_watchdog (id,reporter,timestamp,superwatch) VALUES (%d,%d,%d,1)", GetPlayerSQLId(giveplayerid), GetPlayerSQLId(Reports[reportid][ReportFrom]), gettime());
		else mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO dm_watchdog (id,reporter,timestamp) VALUES (%d,%d,%d)", GetPlayerSQLId(giveplayerid), GetPlayerSQLId(Reports[reportid][ReportFrom]), gettime());
		mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, Reports[reportid][ReportFrom]);

        DeletePVar(Reports[reportid][ReportFrom], "HasReport");
		DeletePVar(Reports[reportid][ReportFrom], "_rAutoM");
		DeletePVar(Reports[reportid][ReportFrom], "_rRepID");     	Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
		Reports[reportid][BeingUsed] = 0;
		Reports[reportid][TimeToExpire] = 0;
		strmid(Reports[reportid][Report], "None", 0, 4, 4);
	}
	return 1;
}

CMD:nao(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pASM] >= 1)
	{
		new string[128], reportid;
		if(sscanf(params, "d", reportid)) return SendClientMessageEx(playerid, COLOR_WHITE,"USAGE: /nao [reportid]");

		if(reportid < 0 || reportid > 999) { SendClientMessageEx(playerid, COLOR_GREY, "   Report ID not below 0 or above 999!"); return 1; }
		if(Reports[reportid][BeingUsed] == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
			return 1;
		}
		if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "RequestingAdP") == 1)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot trash/post this advertisement, you must accept it with /ar.");
		}
		if(GetPVarType(Reports[reportid][ReportFrom], "AlertedThisPlayer"))
		{
			DeletePVar(Reports[reportid][ReportFrom], "AlertedThisPlayer");
			DeletePVar(Reports[reportid][ReportFrom], "AlertType");
			if(AlertTime[Reports[reportid][ReportFrom]] != 0) AlertTime[Reports[reportid][ReportFrom]] = 0;
		}
		format(string, sizeof(string), "AdmCmd: %s has cleared report from %s (RID: %d) due to not having admin of sufficient authority online.", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]), reportid);
		ABroadCast(COLOR_ORANGE, string, 2);
		Log("logs/report.log", string);
		format(string, sizeof(string), "%s has reviewed your report, however there is not an Admin presently online with sufficient authority to handle your request.", GetPlayerNameEx(playerid));
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "You can post a request on the forums for additional assistance (www.ng-gaming.net/forums). Our apologies for the inconvenience. ");
        DeletePVar(Reports[reportid][ReportFrom], "HasReport");
		DeletePVar(Reports[reportid][ReportFrom], "_rAutoM");
		DeletePVar(Reports[reportid][ReportFrom], "_rRepID");	
		Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
		Reports[reportid][BeingUsed] = 0;
		Reports[reportid][TimeToExpire] = 0;
		strmid(Reports[reportid][Report], "None", 0, 4, 4);
	}
	return 1;
}

CMD:post(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], reportid;
		if(sscanf(params, "d", reportid)) return SendClientMessageEx(playerid, COLOR_WHITE,"USAGE: /post [reportid]");

		if(reportid < 0 || reportid > 999) { SendClientMessageEx(playerid, COLOR_GREY, "   Report ID not below 0 or above 999!"); return 1; }
		if(Reports[reportid][BeingUsed] == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
			return 1;
		}
		if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "RequestingAdP") == 1)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot trash/post this advertisement, you must accept it with /ar.");
		}
		if(GetPVarType(Reports[reportid][ReportFrom], "AlertedThisPlayer"))
		{
			DeletePVar(Reports[reportid][ReportFrom], "AlertedThisPlayer");
			DeletePVar(Reports[reportid][ReportFrom], "AlertType");
			if(AlertTime[Reports[reportid][ReportFrom]] != 0) AlertTime[Reports[reportid][ReportFrom]] = 0;
		}
		format(string, sizeof(string), "AdmCmd: %s has cleared report from %s (RID: %d) due to it needing to be handled on the forums", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]), reportid);
		ABroadCast(COLOR_ORANGE, string, 2);
		Log("logs/report.log", string);
		format(string, sizeof(string), "%s has reviewed your report and determined this report should be handled on the forums (i.e. complaint or request.)", GetPlayerNameEx(playerid));
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "Please only report for items that are actively occuring in game. (www.ng-gaming.net/forums)");
        DeletePVar(Reports[reportid][ReportFrom], "HasReport");
		DeletePVar(Reports[reportid][ReportFrom], "_rAutoM");
		DeletePVar(Reports[reportid][ReportFrom], "_rRepID");		Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
		Reports[reportid][BeingUsed] = 0;
		Reports[reportid][TimeToExpire] = 0;
		strmid(Reports[reportid][Report], "None", 0, 4, 4);
	}
	return 1;
}

CMD:st(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], reportid;
		if(sscanf(params, "d", reportid)) return SendClientMessageEx(playerid, COLOR_WHITE,"USAGE: /st [reportid]");

		if(reportid < 0 || reportid > 999) { SendClientMessageEx(playerid, COLOR_GREY, "   Report ID not below 0 or above 999!"); return 1; }
		if(Reports[reportid][BeingUsed] == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
			return 1;
		}
		if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "RequestingAdP") == 1)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot trash/post this advertisement, you must accept it with /ar.");
		}
		if(GetPVarType(Reports[reportid][ReportFrom], "AlertedThisPlayer"))
		{
			DeletePVar(Reports[reportid][ReportFrom], "AlertedThisPlayer");
			DeletePVar(Reports[reportid][ReportFrom], "AlertType");
			if(AlertTime[Reports[reportid][ReportFrom]] != 0) AlertTime[Reports[reportid][ReportFrom]] = 0;
		}
		format(string, sizeof(string), "AdmCmd: %s has cleared report from %s (RID: %d) due to it needing to be handled via /shoporder", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]), reportid);
		ABroadCast(COLOR_ORANGE, string, 2);
		Log("logs/report.log", string);
		format(string, sizeof(string), "%s has reviewed your report and determined it needs to be handled by a Shop Tech.", GetPlayerNameEx(playerid));
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "Please use /shoporder to get your order processed by a Shop Tech.");
        DeletePVar(Reports[reportid][ReportFrom], "HasReport");
		DeletePVar(Reports[reportid][ReportFrom], "_rAutoM");
		DeletePVar(Reports[reportid][ReportFrom], "_rRepID");			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
		Reports[reportid][BeingUsed] = 0;
		Reports[reportid][TimeToExpire] = 0;
		strmid(Reports[reportid][Report], "None", 0, 4, 4);
	}
	return 1;
}

CMD:ts(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], reportid;
		if(sscanf(params, "d", reportid)) return SendClientMessageEx(playerid, COLOR_WHITE,"USAGE: /ts [reportid]");
		if(reportid < 0 || reportid > 999) return SendClientMessageEx(playerid, COLOR_GREY, "   Report ID not below 0 or above 999!");
		if(Reports[reportid][BeingUsed] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
		if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			return 1;
		}
		if(GetPVarInt(Reports[reportid][ReportFrom], "RequestingAdP") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot trash/ts this advertisement, you must accept it with /ar.");
		if(GetPVarType(Reports[reportid][ReportFrom], "AlertedThisPlayer"))
		{
			DeletePVar(Reports[reportid][ReportFrom], "AlertedThisPlayer");
			DeletePVar(Reports[reportid][ReportFrom], "AlertType");
			if(AlertTime[Reports[reportid][ReportFrom]] != 0) AlertTime[Reports[reportid][ReportFrom]] = 0;
		}
		format(string, sizeof(string), "AdmCmd: %s has cleared report from %s (RID: %d) due to it needing to be handled on TeamSpeak", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]), reportid);
		ABroadCast(COLOR_ORANGE, string, 2);
		Log("logs/report.log", string);
		format(string, sizeof(string), "%s has reviewed your report and determined this report should be handled on TeamSpeak (Admin Assistance Channels)", GetPlayerNameEx(playerid));
		SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
        DeletePVar(Reports[reportid][ReportFrom], "HasReport");
		DeletePVar(Reports[reportid][ReportFrom], "_rAutoM");
		DeletePVar(Reports[reportid][ReportFrom], "_rRepID");
		Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
		Reports[reportid][BeingUsed] = 0;
		Reports[reportid][TimeToExpire] = 0;
		strmid(Reports[reportid][Report], "None", 0, 4, 4);
	}
	return 1;
}