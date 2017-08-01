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
	
	Developers:
		(*) Miguel
	
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
	return ShowPlayerDialogEx(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_LIST, "Bug Report", string, "Select", "Close");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
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
						return ShowPlayerDialogEx(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_INPUT, "Bug Report - Subject", "Please enter a short description of the bug:\n * 15 characters min\n * 40 characters max", "Continue", "Close");
					}
					if(listitem == 1) //Bug Details
					{
						SetPVarInt(playerid, "BugStep", 2);
						return ShowPlayerDialogEx(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_INPUT, "Bug Report - Bug Details", "Please explain the bug in as much detail you can:\n * 50 characters minimum", "Continue", "Close");
					}
					if(listitem == 2) //Submit Anonymously?
					{
						SetPVarInt(playerid, "BugStep", 3);
						SetPVarInt(playerid, "BugListItem", 2);
						return ShowPlayerDialogEx(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_LIST, "Bug Report - Submit Anonymously?", "No\nYes", "Continue", "Close");
					}
					if(listitem == 3) //Submit
					{
						new stringg[256];
						if(strlen(bug) == 0 || strlen(bugdesc) == 0) 
							return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX , "Bug Report - {FF0000}Error", "Please fill in all the available text fields.", "Close", "");
						if(strlen(bugdesc) > 64)
						{
							new firstl[65], secondl[65];
							strmid(firstl, bugdesc, 0, 65);
							strmid(secondl, bugdesc, 64, 128);
							format(bugdesc, sizeof(bugdesc),"%s\n%s", firstl, secondl);
						}
						format(stringg, sizeof(stringg), "{4A8BC2}Subject: {BFC0C2}%s\n{4A8BC2}Details:\n{BFC0C2}%s\n{4A8BC2}Anonymous: {BFC0C2}%s", bug, bugdesc, GetPVarInt(playerid, "BugAnonymous") == 1 ? ("Yes"):("No"));
						SetPVarInt(playerid, "BugStep", 4);
						return ShowPlayerDialogEx(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_MSGBOX , "Bug Report - Submit", stringg, "Submit", "Cancel");
					}
				}
				if(GetPVarInt(playerid, "BugStep") == 1) //Subject
				{
					new bugsub[41];
					if(sscanf(inputtext, "s[41]", bugsub) || strlen(inputtext) < 15 || strlen(inputtext) > 40) 
						return ShowPlayerDialogEx(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_INPUT, "Bug Report - Subject", "Please enter a short description of the bug:\n * 15 characters min\n * 40 characters max", "Continue", "Close");
					SetPVarString(playerid, "BugSubject", bugsub);
					ShowBugReportMainMenu(playerid);
				}
				if(GetPVarInt(playerid, "BugStep") == 2) //Bug Details
				{
					new bugdetails[128];
					if(sscanf(inputtext, "s[128]", bugdetails) || strlen(inputtext) < 50) 
						return ShowPlayerDialogEx(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_INPUT, "Bug Report - Bug Details", "Please explain the bug in as much detail you can:\n * 50 characters minimum", "Continue", "Close");
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
					mysql_format(MainPipeline, szResult, sizeof(szResult), "INSERT INTO `bugs` (`Userid`, `Anoy`, `Type`, `Subject`, `Created`, `LastDate`) \
					VALUES(%d, %d, 0, '%e', UNIX_TIMESTAMP(), UNIX_TIMESTAMP())", GetPVarInt(playerid, "pSQLID"), GetPVarInt(playerid, "BugAnonymous"), bug);
					mysql_tquery(MainPipeline, szResult, "OnBugReport", "i", playerid);
				}
			}
		}
	}
	return 0;
}

CMD:bugreport(playerid, params[]) {

	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarInt(playerid, "pDoingPJob") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital]) {
		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	}
	else if(GetPVarType(playerid, "FixVehicleTimer")) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You are fixing a vehicle!");
	}
	if(gettime() - PlayerInfo[playerid][pBugReportTimeout] < 3600) 
		return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX , "Bug Report - {FF0000}Error", "You can only submit a bug report once every hour!\nAlternatively, you can visit http://cp.ng-gaming.net and post a bug report there.", "Close", "");

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `devcpbans` WHERE `Userid` = %d LIMIT 1", GetPlayerSQLId(playerid));
	return mysql_tquery(MainPipeline, szMiscArray, "CheckBugReportBans", "ii", playerid, 1);
}

CMD:changes(playerid, params[])
{
	new rev[16], string[64];
	format(rev, sizeof(rev), "%s", str_replace("NG:RP ", "", SERVER_GM_TEXT));
	format(string, sizeof(string), "dev.ng-gaming.net/server.php?revision=%s", rev);
	HTTP(playerid, HTTP_GET, string, "", "RevisionListHTTP");
	return 1;
}

forward OnBugReport(playerid);
public OnBugReport(playerid)
{
	new string[128], bug[41], szResult[512], bugdesc[129];
	GetPVarString(playerid, "BugSubject", bug, 40);
	GetPVarString(playerid, "BugDetail", bugdesc, 128);

	mysql_format(MainPipeline, szResult, sizeof(szResult), "INSERT INTO `bugcomments` (`Bugid`, `Postid`, `UserId`, `Message`, `Created`) \
	VALUES(%d, 1, %d, '%e', UNIX_TIMESTAMP())", cache_insert_id(), GetPVarInt(playerid, "pSQLID"), bugdesc);
	mysql_tquery(MainPipeline, szResult, "OnQueryFinish", "i", SENDDATA_THREAD);

	format(string, sizeof(string), "[BugID: %d] %s(%d) submitted a%sbug (%s)", cache_insert_id(), GetPlayerNameEx(playerid), GetPVarInt(playerid, "pSQLID"), GetPVarInt(playerid, "BugAnonymous") == 1 ? (" anonymous "):(" "), bug);
	Log("logs/bugreport.log", string);
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX , "Bug Report Submitted", 
	"{FFFFFF}Your bug report has been successfully submitted.\n\
	 We highly suggest adding more information regarding the bug by visiting: http://cp.ng-gaming.net\n\
	 {FF8000}Note:{FFFFFF} If you are found abusing this system you will be restricted from submitting future bug reports.", "Close", "");
	PlayerInfo[playerid][pBugReportTimeout] = gettime();
	DeletePVar(playerid, "BugStep");
	DeletePVar(playerid, "BugSubject");
	DeletePVar(playerid, "BugDetail");
	DeletePVar(playerid, "BugAnonymous");
	DeletePVar(playerid, "BugListItem");
	return 1;
}

forward CheckBugReportBans(playerid, check);
public CheckBugReportBans(playerid, check)
{
	new rows;
	cache_get_row_count(rows);
	if(rows == 0)
	{
		ShowBugReportMainMenu(playerid);
	}
	else
	{
		ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Bug Report - {FF0000}Error", "You are restricted from submitting bug reports.\n\nPlease visit http://cp.ng-gaming.net and select anything from the Bug Report menu\nand your unban date/reason will be displayed.", "Close", "");
	}
	return 1;
}

forward CheckPendingBugReports(playerid);
public CheckPendingBugReports(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows == 0) return 1;
	new string[256], szResult[41];
	format(string, sizeof(string), "{BFC0C2}You have {4A8BC2}%d{BFC0C2} bug report(s) pending your response.", rows);
	strcat(string, "\nPlease follow up with the bug reports listed below and provide as many details as you can.\n{4A8BC2}BugID\tBug{BFC0C2}");
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name(i, "id", szResult);
		format(string, sizeof(string), "%s\n%s\t", string, szResult);
		cache_get_value_name(i, "Subject", szResult);
		format(string, sizeof(string), "%s%s", string, szResult);
	}
	return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Bug Reports Pending Response - {4A8BC2}http://cp.ng-gaming.net", string, "Close", "");
}