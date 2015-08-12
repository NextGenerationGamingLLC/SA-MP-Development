#include <YSI\y_hooks>

LoadElections() {
	SetGVarInt("ElectionArea", _:CreateDynamicSphere(366.54, 159.09, 1008.38, 100));

	return 1;
}

UnloadElections() {
	DestroyDynamicArea(GetGVarInt("ElectionArea"));
	DeleteGVar("ElectionArea");
}

hook OnPlayerEnterDynamicArea(playerid, areaid) {
	if(areaid == GetGVarInt("ElectionArea")) {
		SendClientMessage(playerid, COLOR_WHITE, "You have entered an election area - press ~k~~CONVERSATION_YES~ to vote");
	}
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_YES && IsPlayerInDynamicArea(playerid, GetGVarInt("ElectionArea"))) {
		ShowElectionMenu(playerid);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	szMiscArray[0] = 0; 

	switch(dialogid) {
		case ELECTIONS: {
			if(!response) return SendClientMessage(playerid, COLOR_WHITE, "You have not cast a vote");

			if(listitem <= GetGVarInt("CandidateCount")) {
				return CastVote(playerid, iOptionID);
			}

			if(strcmp(inputext, "Add Candidate") == 0) {
				return ShowPlayerDialog(playerid, ELECTION_CANDIDATE_ADD, DIALOG_STYLE_INPUT, "Add candidate", "Please enter the candidates name", "Select", "Cancel");
			}

			if(strcmp(inputext, "Remove Candidate") == 0) {
				new 
					szTemp[MAX_PLAYER_NAME];

				for(new i = 0; i < GetGVarInt("CandidateCount"); i++) {
					szTemp[0] = 0; 
					GetGVarString("CandidateName", szTemp, i);
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s", szMiscArray, szTemp);
				}
				ShowPlayerDialog(playerid, ELECTIONS_REMOVE, DIALOG_STYLE_LIST, "Gov Elections", szMiscArray, "Select", "Cancel");
			}	

			if(strcmp(inputext, "Start Elections") == 0) {
				SendClientMessageToAll(COLOR_WHITE, "[ELECTION NEWS] The elections have been started.");
				SendClientMessageToAll(COLOR_WHITE, "[ELECTION NEWS] Head over to your local city hall to vote!");
				return SetGVarInt("ElectionsActive", 1);
			}

			if(strcmp(inputext, "End Elections") == 0) {
				DeleteGVar("ElectionsActive");
				return CountVotes(playerid);
			}
		}
	}

	return 1;
}

CastVote(playerid, iOptionID) {

	szMiscArray[0] = 0; 

	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `electionresults` WHERE `accountid` = '%d'", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, szMiscArray, true, "OnCastVote", "ii", playerid, iOptionID)

	return 1;
}

forward OnCastVote(playerid, iOptionID);
public OnCastVote(playerid, iOptionID) {

	new 
		iRows = cache_get_row_count(MainPipeline);

	szMiscArray[0] = 0;

	if(iRows > 0) {
		return SendClientMessageEx(playerid, COLOR_WHITE, "You have voted already!");
	}
	else {
		format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `electionresults` (`accountid`, `optionid`) VALUES ('%d', '%d')", PlayerInfo[playerid][pId], iOptionID);
		return mysql_function_query(MainPipeline, szMiscArray, false, "OnFinaliseVote", "ii", playerid, iOptionID);
	}

	return 1;
}

forward OnFinaliseVote(playerid, iOptionID);
public OnFinaliseVote(playerid, iOptionID) {

	if(!mysql_errno(MainPipeline)) SendClientMessage(playerid, COLOR_WHITE, "You have cast your vote!");
	return 1;
}

CountVotes(playerid) {

	if(GetGVarInt("CandidateCount") == 0) return SendClientMessageEx(iPlayerID, COLOR_RED, "There are no candidates, therefore no count can be made.");
	else mysql_function_query(MainPipeline, "SELECT `optionid` FROM `electionresults`", true, "OnCountVotes", "i", playerid);
	return 1;
}

forward OnCountVotes(playerid);
public OnCountVotes(playerid) {

	new 
		iRows,
		iCount,
		iFields,
		szTemp[MAX_PLAYER_NAME];

	szMiscArray[0] = 0;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows) {
		new iTemp = cache_get_field_content_int(iCount, "optionid", MainPipeline);
		SetGVarInt("Results", GetGVarInt("Results", iTemp)+1, iTemp);

		iCount++;
	}

	SendClientMessageToAll(COLOR_WHITE, "[ELECTION NEWS] Ladies and gentlemen the elections have concluded and here are the results");
	for(new i = 0; i < GetGVarInt("CandidateCount"); i++) {
		
		GetGVarString("CandidateName", szTemp, i);
		format(szMiscArray, sizeof(szMiscArray), "%s - %d votes.", szTemp, GetGVarInt("Results", i));
		SendClientMessageToAll(color, szMiscArray);
	}

	return 1;
}

ShowElectionMenu(playerid) {

	if(PlayerInfo[playerid][pConnectHours] < 32 && PlayerInfo[playerid][pAdmin] < 1337) return SendClientmessage(playerid, COLOR_WHITE, "You have not played enough to vote.");

	szMiscArray[0] = 0;

	new 
		szTemp[MAX_PLAYER_NAME];

	for(new i = 0; i < GetGVarInt("CandidateCount"); i++) {
		szTemp[0] = 0; 
		GetGVarString("CandidateName", szTemp, i);
		format(szMiscArray, sizeof(szMiscArray), "%s\n%s", szMiscArray, szTemp);
	}

	if(PlayerInfo[playerid][pAdmin] >= 1337 && !GetGVarType("ElectionActive")) strcat(szMiscArray, "\nAdd Candidate\nRemove Candidate\nStart Elections");
	if(PlayerInfo[playerid][pAdmin] >= 1337 && GetGVarType("ElectionActive")) strcat(szMiscArray, "\nEnd Elections");
	ShowPlayerDialog(playerid, ELECTIONS, DIALOG_STYLE_LIST, "Gov Elections", szMiscArray, "Select", "Close");
}

