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