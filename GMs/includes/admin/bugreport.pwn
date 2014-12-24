/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Bug Report System

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

#include <YSI\y_hooks>

ShowBugReportMainMenu(playerid)
{
	new string[256], bug[41], bugdesc[41];
	DeletePVar(playerid, "BugStep");
	SetPVarInt(playerid, "BugListItem", 1);
	if(GetPVarType(playerid, "BugSubject")) GetPVarString(playerid, "BugSubject", bug, 40); else bug = "N/A";
	if(GetPVarType(playerid, "BugDetail")) GetPVarString(playerid, "BugDetail", bugdesc, 40); else bugdesc = "N/A";
	if(strlen(bugdesc) > 35) strmid(bugdesc, bugdesc, 0, 35, 35), format(bugdesc, 41, "%s [...]", bugdesc);
	format(string, sizeof(string), "Subject: %s\nDetails: %s\nSubmit Anonymously?: %s\nSubmit", bug, bugdesc, GetPVarInt(playerid, "BugAnonymous") == 1 ? ("Yes"):("No"));
	return ShowPlayerDialog(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_LIST, "Bug Report", string, "Select", "Close");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DIALOG_BUGREPORT:
		{
			if(!response && GetPVarType(playerid, "BugStep")) return ShowBugReportMainMenu(playerid);
			if(response)
			{
				new bug[41], bugdesc[129];
				GetPVarString(playerid, "BugSubject", bug, 40);
				GetPVarString(playerid, "BugDetail", bugdesc, 128);
				if(GetPVarInt(playerid, "BugListItem") == 1)
				{
					if(listitem == 0) //Subject
					{
						SetPVarInt(playerid, "BugStep", 1);
						return ShowPlayerDialog(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_INPUT, "Bug Report - Subject", "Please enter a short description of the bug:\n * 15 characters min\n * 40 characters max", "Continue", "Close");
					}
					if(listitem == 1) //Bug Details
					{
						SetPVarInt(playerid, "BugStep", 2);
						return ShowPlayerDialog(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_INPUT, "Bug Report - Bug Details", "Please explain the bug in as much detail you can:\n * 50 characters minimum", "Continue", "Close");
					}
					if(listitem == 2) //Submit Anonymously?
					{
						new query[128];
						format(query, sizeof(query), "SELECT * from `devcpBans` where `user` = %d AND `anon` = 1", GetPlayerSQLId(playerid));
						return mysql_function_query(MainPipeline, query, true, "CheckBugReportBans", "ii", playerid, 2);
					}
					if(listitem == 3) //Submit
					{
						new stringg[256];
						if(strlen(bug) == 0 || strlen(bugdesc) == 0) 
							return ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX , "Bug Report - {FF0000}Error", "Please fill in all the available text fields.", "Close", "");
						if(strlen(bugdesc) > 64)
						{
							new firstl[65], secondl[65];
							strmid(firstl, bugdesc, 0, 65);
							strmid(secondl, bugdesc, 64, 128);
							format(bugdesc, sizeof(bugdesc),"%s\n%s", firstl, secondl);
						}
						format(stringg, sizeof(stringg), "{4A8BC2}Subject: {BFC0C2}%s\n{4A8BC2}Details:\n{BFC0C2}%s\n{4A8BC2}Anonymous: {BFC0C2}%s", bug, bugdesc, GetPVarInt(playerid, "BugAnonymous") == 1 ? ("Yes"):("No"));
						SetPVarInt(playerid, "BugStep", 4);
						return ShowPlayerDialog(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_MSGBOX , "Bug Report - Submit", stringg, "Submit", "Cancel");
					}
				}
				if(GetPVarInt(playerid, "BugStep") == 1) //Subject
				{
					new bugsub[41];
					if(sscanf(inputtext, "s[41]", bugsub) || strlen(inputtext) < 15 || strlen(inputtext) > 40) 
						return ShowPlayerDialog(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_INPUT, "Bug Report - Subject", "Please enter a short description of the bug:\n * 15 characters min\n * 40 characters max", "Continue", "Close");
					SetPVarString(playerid, "BugSubject", bugsub);
					ShowBugReportMainMenu(playerid);
				}
				if(GetPVarInt(playerid, "BugStep") == 2) //Bug Details
				{
					new bugdetails[128];
					if(sscanf(inputtext, "s[128]", bugdetails) || strlen(inputtext) < 50) 
						return ShowPlayerDialog(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_INPUT, "Bug Report - Bug Details", "Please explain the bug in as much detail you can:\n * 50 characters minimum", "Continue", "Close");
					SetPVarString(playerid, "BugDetail", bugdetails);
					ShowBugReportMainMenu(playerid);
				}
				if(GetPVarInt(playerid, "BugStep") == 3) //Submit Anonymously?
				{
					if(GetPVarInt(playerid, "BugListItem") == 2)
					{
						SetPVarInt(playerid, "BugAnonymous", listitem);
						ShowBugReportMainMenu(playerid);
					}
				}
				if(GetPVarInt(playerid, "BugStep") == 4) //Submit
				{
					new szResult[512];
					format(szResult, sizeof(szResult), "INSERT INTO `bugs` (`ReportedBy`, `Time`, `Bug`, `Status`, `Description`, `Anonymous`) \
					VALUES('%d', UNIX_TIMESTAMP(), '%s', '0', '%s', '%d')", GetPVarInt(playerid, "pSQLID"), g_mysql_ReturnEscaped(bug, MainPipeline), g_mysql_ReturnEscaped(bugdesc, MainPipeline), GetPVarInt(playerid, "BugAnonymous"));
					mysql_function_query(MainPipeline, szResult, true, "OnBugReport", "i", playerid);
				}
			}
		}
	}
	return 1;
}

CMD:bugreport(playerid, params[])
{
	if(gettime() - PlayerInfo[playerid][pBugReportTimeout] < 3600) 
		return ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX , "Bug Report - {FF0000}Error", "You can only submit a bug report once every hour!\nAlternatively, you can visit http://devcp.ng-gaming.net and post a bug report there.", "Close", "");
	new query[128];
	format(query, sizeof(query), "SELECT * from `devcpBans` where `user` = %d AND `bugs` = 1", GetPlayerSQLId(playerid));
	return mysql_function_query(MainPipeline, query, true, "CheckBugReportBans", "ii", playerid, 1);
}

CMD:changes(playerid, params[])
{
	new rev[16], string[64];
	format(rev, sizeof(rev), "%s", str_replace("NG:RP ", "", SERVER_GM_TEXT));
	format(string, sizeof(string), "%s/devlog/server.php?revision=%s", SAMP_WEB, rev);
	HTTP(playerid, HTTP_GET, string, "", "RevisionListHTTP");
	return 1;
}