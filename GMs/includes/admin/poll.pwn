/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Poll System
						  Jingles

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

#include <YSI\y_hooks>

#define MAX_POLL_OPTIONS 5

enum ePolls {

	pol_iPollID,
	bool:pol_bFinished,
	bool:pol_bActive,
	pol_szQuestion[64],
	pol_iTypeID,
	pol_iHours
}
new arrPolls[ePolls];

new arrPollOption[MAX_POLL_OPTIONS][32];

hook OnGameModeExit() {
	Poll_UnloadPolls();
}

Poll_LoadPolls() {

 	mysql_tquery(MainPipeline, "SELECT * FROM `polls` WHERE `active` = '1' LIMIT 1", true, "Poll_OnLoadPolls", "");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0; 

	switch(dialogid) {


		case DIALOG_POLLS_VOTE: {

			if(!response || !(2 <= listitem <= MAX_POLL_OPTIONS)) return SendClientMessage(playerid, COLOR_WHITE, "You did not cast your vote");
			if(strlen(inputtext) < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot vote this option.");
			PlayerInfo[playerid][pLastPoll] = arrPolls[pol_iPollID];
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `polls` SET `OptionV%d` = OptionV%d + '1' WHERE `id` = '%d'", listitem-2, listitem-2, arrPolls[pol_iPollID]);
			mysql_tquery(MainPipeline, szMiscArray, false, "Poll_CastVote", "ii", playerid, listitem-2);

		}
		case DIALOG_POLLS_EDIT: {

			if(!response) return 1;

			switch(listitem) {
				case 0: ShowPlayerDialogEx(playerid, DIALOG_POLLS_QUESTION, DIALOG_STYLE_INPUT, "NGRP Polls | Edit Question", "Please formulate a question for this poll", "Enter", "Cancel");
				case 1: {

					szMiscArray[0] = 0;
					for(new i; i < MAX_POLL_OPTIONS; ++i) {
						format(szMiscArray, sizeof(szMiscArray), "%s\n%d. %s", szMiscArray, i+1, arrPollOption[i]);
					}
					ShowPlayerDialogEx(playerid, DIALOG_POLLS_OPTIONS, DIALOG_STYLE_LIST, "NGRP Polls | Edit Options", szMiscArray, "Edit", "Cancel");
				}
				case 2: ShowPlayerDialogEx(playerid, DIALOG_POLLS_TYPE, DIALOG_STYLE_LIST, "NG:RP | Polls", "All\nFactions\nGangs\nBusiness\nVIP", "Enter", "Cancel");
				case 3: ShowPlayerDialogEx(playerid, DIALOG_POLLS_HOURS, DIALOG_STYLE_INPUT, "NG:RP | Polls", "Enter the minimum amount of playing hours to be able to cast a vote.", "Enter", "Cancel");
				case 4: {
					if(!arrPolls[pol_bActive]) {
						Poll_TogglePoll(playerid, true);
					}
					else SendClientMessageEx(playerid, COLOR_GRAD1, "This poll is already active.");
				}
				case 5: {
					if(arrPolls[pol_bActive]) {
						Poll_TogglePoll(playerid, false);
					}
					else SendClientMessageEx(playerid, COLOR_GRAD1, "This poll is already inactive.");
				}
			}
				
		}
		case DIALOG_POLLS_QUESTION: {
			
			if(!response || isnull(inputtext)) return 1;

			szMiscArray[0] = 0;

			new szPoll[64];
			mysql_escape_string(inputtext, szPoll);

			format(arrPolls[pol_szQuestion], sizeof(arrPolls[pol_szQuestion]), szPoll);
			
			format(szMiscArray, sizeof(szMiscArray), "Poll: Administrator %s set the Poll ID %d's question: %s", GetPlayerNameEx(playerid), arrPolls[pol_iPollID], szPoll);
			ABroadCast(COLOR_YELLOW, szMiscArray, 2);

			Log("logs/polls.log", szMiscArray);

			format(szMiscArray, sizeof(szMiscArray), "UPDATE `polls` SET `Question` = '%s' WHERE `id` = '%d'", szPoll, arrPolls[pol_iPollID]);
			mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);

		}
		case DIALOG_POLLS_OPTIONS: {

			if(!response) return 1;
			SetPVarInt(playerid, "EditPoll", listitem);
			ShowPlayerDialogEx(playerid, DIALOG_POLLS_OPTIONS2, DIALOG_STYLE_INPUT, "NGRP Polls | Edit", "Please enter an option", "Enter", "Cancel");
		}
		case DIALOG_POLLS_OPTIONS2: {

			if(!response || isnull(inputtext)) return DeletePVar(playerid, "EditPoll");

			new iPollOption = GetPVarInt(playerid, "EditPoll"),
				szPoll[32];

			szMiscArray[0] = 0;
			mysql_escape_string(inputtext, szPoll);

			format(arrPollOption[iPollOption], 32, szPoll);

			format(szMiscArray, sizeof(szMiscArray), "Poll: Administrator %s set the Poll ID %d's option #%d: %s", GetPlayerNameEx(playerid), arrPolls[pol_iPollID], iPollOption, szPoll);
			ABroadCast(COLOR_YELLOW, szMiscArray, 2);
			Log("logs/polls.log", szMiscArray);

			format(szMiscArray, sizeof(szMiscArray), "Option%d", iPollOption);
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `polls` SET `%s` = '%s' WHERE `id` = '%d'", szMiscArray, szPoll, arrPolls[pol_iPollID]);
			mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);


			DeletePVar(playerid, "EditPoll");

		}
		case DIALOG_POLLS_TYPE: {
			
			if(!response) return 1;

			arrPolls[pol_iTypeID] = listitem;
			format(szMiscArray, sizeof(szMiscArray), "Administrator %s set Poll ID %d's type to: %s", GetPlayerNameEx(playerid), arrPolls[pol_iPollID], inputtext);
			ABroadCast(COLOR_YELLOW, szMiscArray, 2);
			Log("logs/polls.log", szMiscArray);

			format(szMiscArray, sizeof(szMiscArray), "UPDATE `polls` SET `Type` = '%d' WHERE `id` = '%d'", arrPolls[pol_iTypeID], arrPolls[pol_iPollID]);
			mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
		case DIALOG_POLLS_HOURS: {

			if(!response || !IsNumeric(inputtext)) return 1;

			arrPolls[pol_iHours] = strval(inputtext);
			format(szMiscArray, sizeof(szMiscArray), "Administrator %s set the minimum playing hours for Poll ID %d to %d hours.", GetPlayerNameEx(playerid), arrPolls[pol_iPollID], arrPolls[pol_iHours]);
			ABroadCast(COLOR_YELLOW, szMiscArray, 2);
			Log("logs/polls.log", szMiscArray);

			format(szMiscArray, sizeof(szMiscArray), "UPDATE `polls` SET `Hours` = '%d' WHERE `id` = '%d'", arrPolls[pol_iHours], arrPolls[pol_iPollID]);
			mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
	return 0;
}


forward Poll_OnLoadPolls();
public Poll_OnLoadPolls() {

	new iRows,
		iFields;

	cache_get_data(iRows, iFields, MainPipeline);
	
	if(iRows) {

		arrPolls[pol_iPollID] = cache_get_field_content_int(0, "id", MainPipeline);
		arrPolls[pol_iTypeID] = cache_get_field_content_int(0, "Type", MainPipeline);
		arrPolls[pol_iHours] = cache_get_field_content_int(0, "Hours", MainPipeline);
		arrPolls[pol_bActive] = true;
		cache_get_field_content(0, "Question", arrPolls[pol_szQuestion], MainPipeline, 64);
		for(new i; i < MAX_POLL_OPTIONS; ++i) {

			format(szMiscArray, sizeof(szMiscArray), "Option%d", i);
			cache_get_field_content(0, szMiscArray, arrPollOption[i], MainPipeline, 32);
		}
	}
	else print("[Polls] There aren't any active polls in the database.");
	return 1;
}

Poll_UnloadPolls() {
	
	arrPolls[pol_szQuestion][0] = 0;
	for(new i; i < MAX_POLL_OPTIONS; ++i) arrPollOption[i][0] = 0;
}

forward Poll_CastVote(playerid, iOptionID);
public Poll_CastVote(playerid, iOptionID) {

	if(mysql_errno(MainPipeline)) SendClientMessageEx(playerid, COLOR_YELLOW, "There was an error when casting your vote. Please contact tech support.");
	format(szMiscArray, sizeof(szMiscArray), "POLL: You voted %s in Poll %d.", arrPollOption[iOptionID], arrPolls[pol_iPollID]);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "%s (%s) (IP: %s) cast a vote, Poll ID %d, OptionID %d",
		GetPlayerNameExt(playerid), PlayerInfo[playerid][pId], GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), arrPolls[pol_iPollID], iOptionID);
	Log("logs/polls.log", szMiscArray);
	return 1;
}

Poll_TogglePoll(playerid, bool:bState) {

	arrPolls[pol_bActive] = bState;
	if(!bState) arrPolls[pol_bFinished] = true;
	format(szMiscArray, sizeof(szMiscArray), "Administrator %s %s a poll. (Use /poll to cast your vote or view the results).", GetPlayerNameEx(playerid), bState == true ? ("started") : ("ended"));
	SendClientMessageToAllEx(COLOR_YELLOW, szMiscArray);
	Log("logs/polls.log", szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `polls` SET `Active` = '%d' WHERE `id` = '%d'", bState, arrPolls[pol_iPollID]);
	mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

Poll_CreatePoll() {

	mysql_tquery(MainPipeline, "INSERT INTO `polls` (`Active`) VALUES ('1')", true, "Poll_OnCreatePoll", "");
}

forward Poll_OnCreatePoll();
public Poll_OnCreatePoll() {

	arrPolls[pol_iPollID] = cache_insert_id();
	arrPolls[pol_szQuestion][0] = 0;
	arrPolls[pol_bFinished] = false;
	arrPolls[pol_bActive] = false;
	arrPolls[pol_iTypeID] = 0;
	arrPolls[pol_iHours] = 0;
	for(new i; i < MAX_POLL_OPTIONS; ++i) arrPollOption[i][0] = 0;
	return 1;
}

Poll_GetVotes(playerid) {

	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `polls` WHERE `id` = '%d'", arrPolls[pol_iPollID]);
	mysql_tquery(MainPipeline, szMiscArray, true, "Poll_OnGetVotes", "i", playerid);
}

forward Poll_OnGetVotes(playerid);
public Poll_OnGetVotes(playerid) {

	szMiscArray[0] = 0;

	new iRows,
		iFields,
		iCount,
		iTotalCount,
		szVoteStr[2];

	cache_get_data(iRows, iFields, MainPipeline);

	format(szMiscArray, sizeof(szMiscArray), "----\tVotes\n\
		POLL: %s\t_\n\
		__________________________________________\t____\n", arrPolls[pol_szQuestion]);

	for(new i; i < MAX_POLL_OPTIONS; ++i) {

		// if(!isnull(arrPollOption[i]))
		{
			format(szVoteStr, sizeof(szVoteStr), "OptionV%d", i);
			iCount = cache_get_field_content_int(0, szVoteStr, MainPipeline);
			iTotalCount += iCount;
			format(szMiscArray, sizeof(szMiscArray), "%s\n%d. %s\t%d",
				szMiscArray,
				i+1,
				arrPollOption[i],
				iCount);
		}
	}
	format(szMiscArray, sizeof(szMiscArray), "%s\nTotal Votes:\t%d", szMiscArray, iTotalCount);
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "NG:RP | Poll Results", szMiscArray, "OK", "");
	return 1;
}

Poll_GetPollType(iTypeID) {

	szMiscArray[0] = 0;
	switch(iTypeID) {
		case 1: szMiscArray = "Faction";
		case 2: szMiscArray = "Gang";
		case 3: szMiscArray = "Business";
		case 4: szMiscArray = "VIP";
		default: szMiscArray = "All";
	}
	return szMiscArray;
}

Poll_CheckVoteRights(playerid) {

	if(PlayerInfo[playerid][pLastPoll] == arrPolls[pol_iPollID]) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You already casted your vote in this poll.");
		return 0;
	}
	if(PlayerInfo[playerid][pConnectHours] < arrPolls[pol_iHours]) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You have insufficient playing hours to participate in this poll.");
		return 0;
	}
	switch(arrPolls[pol_iTypeID]) {
		case 0: return 1;
		case 1: if(PlayerInfo[playerid][pMember] != INVALID_GROUP_ID && !IsACriminal(playerid)) return 1;
		case 2: if(IsACriminal(playerid)) return 1;
		case 3: if(PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID) return 1;
		case 4: if(PlayerInfo[playerid][pDonateRank] > 0) return 1;
	}
	return 0;
}

CMD:pollhelp(playerid, params[]) {
	
	SendClientMessageEx(playerid, COLOR_GRAD1, "/poll - To cast your vote or view the poll's results.");
	if(PlayerInfo[playerid][pAdmin] == 99999) SendClientMessageEx(playerid, COLOR_YELLOW, "/editpoll | /viewpoll | /nextpoll");
	return 1;
}

CMD:poll(playerid, params[]) {

	if(arrPolls[pol_bActive]) {
		if(!arrPolls[pol_iPollID]) return SendClientMessageEx(playerid, COLOR_GRAD1, "There isn't an active poll.");
		if(!Poll_CheckVoteRights(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot vote in this poll.");
		format(szMiscArray, sizeof(szMiscArray), "POLL: %s\n\
			_______________________________________________\n", arrPolls[pol_szQuestion]);

		for(new i; i < MAX_POLL_OPTIONS; ++i) {

			if(!isnull(arrPollOption[i])) {

				format(szMiscArray, sizeof(szMiscArray), "%s\n%d. %s", szMiscArray, i, arrPollOption[i]);
			}
		}
		ShowPlayerDialogEx(playerid, DIALOG_POLLS_VOTE, DIALOG_STYLE_LIST, "NG:RP | Poll", szMiscArray, "Vote", "Cancel");
	}
	else Poll_GetVotes(playerid);
	return 1;
}

CMD:viewpoll(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] != 99999) return SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	Poll_GetVotes(playerid);
	return 1;
}

CMD:nextpoll(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] != 99999) return SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	Poll_CreatePoll();
	SendClientMessageEx(playerid, COLOR_GRAD1, "You created a new poll. Use /editpoll to edit it.");
	return 1;
}

CMD:editpoll(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] != 99999) return SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	if(arrPolls[pol_iPollID] == 0 || arrPolls[pol_bFinished]) Poll_CreatePoll();

	format(szMiscArray, sizeof(szMiscArray), "Edit Question\n\
		Edit Options\n\
		Edit Poll Type (%s)\n\
		Edit Min. Playing Hours (%d)\n\
		Start\n\
		End", Poll_GetPollType(arrPolls[pol_iTypeID]), arrPolls[pol_iHours]);

	ShowPlayerDialogEx(playerid, DIALOG_POLLS_EDIT, DIALOG_STYLE_LIST, "NG:RP Polls | Edit", szMiscArray, "Select", "Cancel");
	return 1;
}