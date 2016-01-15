/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Detective System

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

CMD:find(playerid, params[]) {
	
	SendClientMessage(playerid, COLOR_YELLOW, "This command has been deprecated. Use /trace [player's phone number] to trace someone.");
	cmd_trace(playerid, "");
	/*
	if(PlayerInfo[playerid][pJob] != 1 && PlayerInfo[playerid][pJob2] != 1 && PlayerInfo[playerid][pJob3] != 1) {
		SendClientMessageEx(playerid, COLOR_GREY, "You're not a detective.");
	}
	else if(gettime() < UsedFind[playerid]) {
		SendClientMessageEx(playerid, COLOR_GREY, "You've already searched for someone - wait a little.");
	}
	else {
		new
			iTargetID;

		if(sscanf(params, "u", iTargetID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /find [player]");
		}
		else if(iTargetID == playerid) {
			SendClientMessageEx(playerid, COLOR_GREY, "You can't use this command on yourself.");
		}
		else if(!IsPlayerConnected(iTargetID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		}
		else if(GetPlayerInterior(iTargetID) != 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "That person is inside an interior.");
		}
		else if((PlayerInfo[iTargetID][pAdmin] >= 2 || PlayerInfo[iTargetID][pWatchdog] >= 2) && PlayerInfo[iTargetID][pTogReports] != 1) {
			SendClientMessageEx(playerid, COLOR_GREY, "You are unable to find this person.");
		}
		else if (GetPVarInt(playerid, "_SwimmingActivity") >= 1) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "You are unable to find people while swimming.");
		}
		else if (PlayerInfo[iTargetID][pPnumber] == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "This person does not have a phone.");
		}
		else if(PhoneOnline[iTargetID] == 0)
		{
			switch(PlayerInfo[playerid][pDetSkill]) {
				case 0 .. 50: {
					FindTimePoints[playerid] = 4;
					UsedFind[playerid] = gettime()+120;
				}
				case 51 .. 100: {
					FindTimePoints[playerid] = 6;
					UsedFind[playerid] = gettime()+90;
				}
				case 101 .. 200: {
					FindTimePoints[playerid] = 8;
					UsedFind[playerid] = gettime()+60;
				}
				case 201 .. 400: {
					FindTimePoints[playerid] = 10;
					UsedFind[playerid] = gettime()+30;
				}
				default: {
					FindTimePoints[playerid] = 12;
					UsedFind[playerid] = gettime()+15;
				}
			}

			new
				szZone[MAX_ZONE_NAME],
				szMessage[108];

			SetPlayerMarkerForPlayer(playerid, iTargetID, FIND_COLOR);
			GetPlayer3DZone(iTargetID, szZone, sizeof(szZone));
			format(szMessage, sizeof(szMessage), "%s has been last seen at %s.", GetPlayerNameEx(iTargetID), szZone);
			SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);
			FindingPlayer[playerid]=iTargetID;
			FindTime[playerid] = 1;

			if(PlayerInfo[playerid][pDoubleEXP] > 0) {
				format(szMessage, sizeof(szMessage), "You have gained 2 detective skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
				SendClientMessageEx(playerid, COLOR_YELLOW, szMessage);
				PlayerInfo[playerid][pDetSkill] += 2;
			}
			else ++PlayerInfo[playerid][pDetSkill];

			switch(PlayerInfo[playerid][pDetSkill]) {
				case 50: SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Detective Skill is now Level 2, you can find a little faster.");
				case 100: SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Detective Skill is now Level 3, you can find a little faster.");
				case 200: SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Detective Skill is now Level 4, you can find a little faster.");
				case 400: SendClientMessageEx(playerid, COLOR_YELLOW, "* Your Detective Skill is now Level 5, you can find a little faster.");
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "You are unable to get a trace on this person.");
			return 1;
		}
	}
	*/
	return 1;
}