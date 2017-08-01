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

#include <YSI\y_hooks>

CMD:polls(playerid, params[])
{
	szMiscArray[0] = 0;
	for(new i; i < MAX_POLLS; i++)
	{
		DeletePVar(playerid, "pVoting");
		if(strfind(PlayerInfo[playerid][pPrisonReason], "Vacant", true) == -1)
		{
			format(szMiscArray, sizeof(szMiscArray), "%s\n%d | %s", szMiscArray, i, Polls[i][PollQuestion]);
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_POLLS, DIALOG_STYLE_LIST, "NG:RP Polls", szMiscArray, "Select", "Cancel");
	return 1;
}

CMD:editpolls(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) 
	{
		DeletePVar(playerid, "pEditingPoll");
		szMiscArray[0] = 0;
		for(new i; i < MAX_POLLS; i++)
		{
			format(szMiscArray, sizeof(szMiscArray), "%s\n%d | %s", szMiscArray, i, Polls[i][PollQuestion]);
		}
		ShowPlayerDialogEx(playerid, DIALOG_EDITPOLLS, DIALOG_STYLE_LIST, "NG:RP Polls | Edit", szMiscArray, "Select", "Cancel");
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_POLLS:
		{
			switch(listitem)
			{
				case 0 .. MAX_POLLS:
				{
					if(PlayerInfo[playerid][HasVoted][listitem] > 0) return SendClientMessage(playerid, COLOR_WHITE, "You have already voted on this poll!");
					SetPVarInt(playerid, "pVoting", listitem);
					for(new i; i < MAX_POLLS_CHOICES; i++)
					{
						format(szMiscArray, sizeof(szMiscArray), "%s\n%d | %s", szMiscArray, i, PollChoices[listitem][i]);
					}
					ShowPlayerDialogEx(playerid, DIALOG_POLLS_VOTE, DIALOG_STYLE_LIST, "NG:RP Polls | Vote", szMiscArray, "Select", "Cancel");
				}
			}
		}
		case DIALOG_POLLS_VOTE:
		{
			switch(listitem)
			{
				case 0 .. MAX_POLLS_CHOICES:
				{
					PlayerInfo[playerid][HasVoted][GetPVarInt(playerid, "pVoting")] = gettime();

					Polls[GetPVarInt(playerid, "pVoting")][PollVotes][listitem] += 1;
					SavePoll(GetPVarInt(playerid, "pVoting"));
				}
			}
		}
		case DIALOG_EDITPOLLS:
		{
			switch(listitem)
			{
				case 0 .. MAX_POLLS:
				{
					SetPVarInt(playerid, "pEditingPoll", listitem);
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOLLS2, DIALOG_STYLE_LIST, "NG:RP Polls | Edit", "Edit Question\nEdit Choices\nReset Poll", "Select", "Cancel");
				}
			}
		}
		case DIALOG_EDITPOLLS2:
		{
			switch(listitem)
			{
				case 0: ShowPlayerDialogEx(playerid, DIALOG_EDITPOLLS_NAME, DIALOG_STYLE_MSGBOX, "NG:RP Polls | Edit Question", "Please enter the question for the poll below.", "Okay", "Cancel");
				case 1:
				{
					szMiscArray[0] = 0;
					DeletePVar(playerid, "pEditingPollChoice");
					for(new i; i < MAX_POLLS_CHOICES; i++)
					{
						format(szMiscArray, sizeof(szMiscArray), "%s\n%d | %s", szMiscArray, i, PollChoices[GetPVarInt(playerid, "pEditingPoll")][i]);
					}
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOLLS_CHOICES, DIALOG_STYLE_LIST, "NG:RP Polls | Edit Choices", szMiscArray, "Select", "Cancel");
				}
				case 2:
				{
					ResetPoll(GetPVarInt(playerid, "pEditingPoll"));
				}
			}
		}
	}
	return 0;
}

/*CheckPlayerPollStatus(playerid)
{
	for(new i; i < MAX_POLLS; i++) if(PlayerInfo[playerid][HasVoted][i] < Polls[i][LastReset]) PlayerInfo[playerid][HasVoted][i] = 0;
	return 1;
}*/

ResetPoll(id)
{
	format(Polls[id][PollQuestion], 256, "Vacant");
	for(new i; i < MAX_POLLS_CHOICES; i++) format(PollChoices[id][i], 255, "Vacant");

	foreach(new i: Player)
	{
		if(PlayerInfo[i][HasVoted][id] > 0) PlayerInfo[i][HasVoted][id] = 0;
	}

	Polls[id][LastReset] = gettime();
	SavePoll(id);
	return 1;
}

SavePoll(id) 
{
	szMiscArray[0] = 0;
	new mistring[64];
	for(new i; i < MAX_POLLS; i++)
	{
		format(szMiscArray, sizeof szMiscArray, "UPDATE `polls` SET `Question` = '%s'", Polls[id][PollQuestion]);

		for(i = 0; i != MAX_POLLS_CHOICES; ++i) format(szMiscArray, sizeof szMiscArray, "%s, `Choice%d` = '%s'", szMiscArray, i, PollChoices[id][i]);

		for(i = 0; i != MAX_POLLS_CHOICES; ++i) 
		{
			format(mistring, sizeof(mistring), "%s%d", mistring, Polls[id][PollVotes][i]);
			strcat(mistring, "|");
		}
		format(szMiscArray, sizeof szMiscArray, "%s, `Votes` = '%s'", szMiscArray, mistring);
	}

	format(szMiscArray, sizeof szMiscArray, "%s WHERE `id` = %d", szMiscArray, id + 1);
	mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}