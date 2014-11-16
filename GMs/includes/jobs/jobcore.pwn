/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Job System Core

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

CMD:join(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this while being inside a vehicle.");
	if(GetPlayerState(playerid) == 1 && PlayerInfo[playerid][pJob] == 0 || (PlayerInfo[playerid][pJob2] == 0 && (PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0)) || (PlayerInfo[playerid][pJob3] == 0 && PlayerInfo[playerid][pDonateRank] >= 3)) {
		if(IsPlayerInRangeOfPoint(playerid,3.0,251.99, 117.36, 1003.22) || IsPlayerInRangeOfPoint(playerid,3.0, 1478.9515, -1755.7147, 3285.2859) || IsPlayerInRangeOfPoint(playerid,3.0,301.042633, 178.700408, 1007.171875) || IsPlayerInRangeOfPoint(playerid,3.0,-1385.6786,2625.6636,55.5572)) {
			if(PlayerInfo[playerid][pJob] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Detective, type /accept job.");
				GettingJob[playerid] = 1;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Detective, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 1;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Detective, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 1;
				return 1;
			}			
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1469.5247, -1755.7039, 3285.2859)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Lawyer, type /accept job.");
				GettingJob[playerid] = 2;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Lawyer, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 2;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Lawyer, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 2;
				return 1;
			}			
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,1215.1304,-11.8431,1000.9219)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Whore, type /accept job.");
				GettingJob[playerid] = 3;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Whore, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 3;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Whore, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 3;
				return 1;
			}			
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,2166.3772,-1675.3829,15.0859) || IsPlayerInRangeOfPoint(playerid,3.0,-2089.344970, 87.800231, 35.320312) || IsPlayerInRangeOfPoint(playerid,3.0,-1528.0924,2688.7837,55.8359)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Drug Dealer, type /accept job.");
				GettingJob[playerid] = 4;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Drug Dealer, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 4;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Drug Dealer, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 4;
				return 1;
			}			
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,161.92, -25.70, 1.57) || IsPlayerInRangeOfPoint(playerid,3.0,-2032.601928, 143.866592, 28.835937) || IsPlayerInRangeOfPoint(playerid,3.0,-1475.4224,1877.3550,32.6328) || IsPlayerInRangeOfPoint(playerid,3.0,-2412.5095, 2279.8159, 4.8137)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Mechanic, type /accept job.");
				GettingJob[playerid] = 7;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Mechanic, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 7;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Mechanic, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 7;
				return 1;
			}			
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,1224.13, 267.98, 19.55) || IsPlayerInRangeOfPoint(playerid,3.0,-2269.256103, -158.054321, 35.320312) || IsPlayerInRangeOfPoint(playerid,3.0,2226.1716,-1718.1792,13.5165) || IsPlayerInRangeOfPoint(playerid,3.0,1099.73,-1504.67,15.800) || IsPlayerInRangeOfPoint(playerid,3.0,-821.3508,1574.9393,27.1172) || IsPlayerInRangeOfPoint(playerid,3.0,-2412.5095, 2293.3923, 4.8137)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Bodyguard, type /accept job.");
				GettingJob[playerid] = 8;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Bodyguard, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 8;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Bodyguard, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 8;
				return 1;
			}			
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,1366.4325,-1275.2096,13.5469) || IsPlayerInRangeOfPoint(playerid,3.0,-2623.333984, 209.235931, 4.684767) || IsPlayerInRangeOfPoint(playerid,3.0,-1513.4904,2614.3591,55.8078)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become an Arms Dealer, type /accept job.");
				GettingJob[playerid] = 9;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become an Arms Dealer, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 9;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become an Arms Dealer, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 9;
				return 1;
			}			
		}
		/*else if (PlayerInfo[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid,3.0,531.7930,-1292.4044,17.2422)) {
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Car Dealer, type /accept job.");
			GettingJob[playerid] = 10;
			return 1;
		}*/
		else if (IsPlayerInRangeOfPoint(playerid,3.0,766.0804,14.5133,1000.7004) || IsPlayerInRangeOfPoint(playerid,3.0,758.98, -60.32, 1000.78)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Boxer, type /accept job.");
				GettingJob[playerid] = 12;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Boxer, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 12;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Boxer, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 12;
				return 1;
			}			
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,2354.2808,-1169.2959,28.0066) || IsPlayerInRangeOfPoint(playerid,3.0,-2630.7375,2349.3994,8.4892)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Drug Smuggler, type /accept job.");
				GettingJob[playerid] = 14;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Drug Smuggler, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 14;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Drug Smuggler, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 14;
				return 1;
			}			
		}
		/*else if (PlayerInfo[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid,3.0,-2040.9436,456.2395,35.1719)) {
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Paper Boy, type /accept job.");
			GettingJob[playerid] = 15;
			return 1;
		}*/
		/*else if (PlayerInfo[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid,3.0,-77.7288,-1136.3896,1.0781)) {
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Trucker, type /accept job.");
			GettingJob[playerid] = 16;
			return 1;
		}*/
		else if (IsPlayerInRangeOfPoint(playerid,3.0,1741.5199,-1863.4615,13.5750) || IsPlayerInRangeOfPoint(playerid,3.0,-1981.144775, 133.063293, 27.687500)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Taxi Driver, type /accept job.");
				GettingJob[playerid] = 17;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Taxi Driver, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 17;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Taxi Driver, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 17;
				return 1;
			}			
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,2195.8335,-1973.0638,13.5589) || IsPlayerInRangeOfPoint(playerid,3.0,-1356.7195,2065.3450,52.4677) || IsPlayerInRangeOfPoint(playerid,3.0,-2412.5095, 2246.2598, 4.8137)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Craftsman, type /accept job.");
				GettingJob[playerid] = 18;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Craftsman, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 18;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Craftsman, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 18;
				return 1;
			}			
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,502.6696,-11.6603,1000.6797) || IsPlayerInRangeOfPoint(playerid,3.0,-864.3550,1536.9703,22.5870)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Bartender, type /accept job.");
				GettingJob[playerid] = 19;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Bartender, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 19;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Bartender, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 19;
				return 1;
			}			
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,-1560.963867, 127.491157, 3.554687) || IsPlayerInRangeOfPoint(playerid,3.0,-2412.5095, 2240.7227, 4.8137)) {
			if(PlayerInfo[playerid][pLevel] >= 2)
			{
				if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Shipment Contractor, type /accept job.");
				GettingJob[playerid] = 20;
				return 1;
				}
				if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Shipment Contractor, type /accept job.");
					SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
					GettingJob2[playerid] = 20;
					return 1;
				}
				if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Shipment Contractor, type /accept job.");
					SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
					GettingJob3[playerid] = 20;
					return 1;
				}				
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 2 to become a Shipment Contractor.");
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,-1720.962646, 1364.456176, 7.187500)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Pizza Boy, type /accept job.");
				GettingJob[playerid] = 21;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Pizza Boy, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 21;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* If you are sure to become a Pizza Boy, type /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 21;
				return 1;
			}			
		}
		else {
			SendClientMessageEx(playerid, COLOR_GREY, "You are not even near a place to get a Job!");
		}
	}
	else {
		if(PlayerInfo[playerid][pDonateRank] == 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "You already have a Job, use /quitjob first!");
            SendClientMessageEx(playerid, COLOR_YELLOW, "Only VIP/Famed can get two jobs, Gold VIP+ can get three jobs!");
		}
		else if(PlayerInfo[playerid][pDonateRank] < 3 && PlayerInfo[playerid][pJob2] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You already have 2 Jobs, use /quitjob first!");
			SendClientMessageEx(playerid, COLOR_YELLOW, "Only Gold VIP+ can get three jobs!");
		}
		else {
			SendClientMessageEx(playerid, COLOR_GREY, "You already have 3 Jobs, use /quitjob first!");
		}
	}
    return 1;
}

CMD:skill(playerid, params[])
{
	if(isnull(params))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /skill [number]");
		SendClientMessageEx(playerid, COLOR_GREY, "| 1: Detective																	 6: Arms Dealer");
		SendClientMessageEx(playerid, COLOR_GREY, "| 2: Lawyer						   											 7: Car Mechanic");
		SendClientMessageEx(playerid, COLOR_GREY, "| 3: Whore											  	 						 8: Boxer");
		SendClientMessageEx(playerid, COLOR_GREY, "| 4: Drugs Dealer										  9: Fishing");
		SendClientMessageEx(playerid, COLOR_GREY, "| 5: Drug Smuggler								10: Shipment Contractor");
		SendClientMessageEx(playerid, COLOR_GREY, "| 11: Treasure Hunter							12: Vehicle Lock Picking");
		return 1;
	}
	else switch(strval(params)) {
		case 1: //Detective
		{
			new level = PlayerInfo[playerid][pDetSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Detective Skill Level = 1."); format(string, sizeof(string), "You need to find %d more people to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Detective Skill Level = 2."); format(string, sizeof(string), "You need to find %d more people to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Detective Skill Level = 3."); format(string, sizeof(string), "You need to find %d more people to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Detective Skill Level = 4."); format(string, sizeof(string), "You need to find %d more people to level up.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Detective Skill Level = 5."); }
		}
		case 2://Lawyer
		{
			new level = PlayerInfo[playerid][pLawSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Lawyer Skill Level = 1."); format(string, sizeof(string), "You need to free %d more people to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Lawyer Skill Level = 2."); format(string, sizeof(string), "You need to free %d more people to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Lawyer Skill Level = 3."); format(string, sizeof(string), "You need to free %d more people to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Lawyer Skill Level = 4."); format(string, sizeof(string), "You need to free %d more people to level up.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Lawyer Skill Level = 5."); }
		}
		case 3://Whore
		{
			new level = PlayerInfo[playerid][pSexSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Whore Skill Level = 1."); format(string, sizeof(string), "You need to have sex %d times more to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Whore Skill Level = 2."); format(string, sizeof(string), "You need to have sex %d times more to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Whore Skill Level = 3."); format(string, sizeof(string), "You need to have sex %d times more to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Whore Skill Level = 4."); format(string, sizeof(string), "You need to have sex %d times more to level up.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Whore Skill Level = 5."); }
		}
		case 4://Drugs Dealer
		{
			new level = PlayerInfo[playerid][pDrugsSkill], string[50];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Dealer Skill Level = 1."); format(string, sizeof(string), "You need to sell drugs %d times more to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Dealer Skill Level = 2."); format(string, sizeof(string), "You need to sell drugs %d times more to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Dealer Skill Level = 3."); format(string, sizeof(string), "You need to sell drugs %d times more to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Dealer Skill Level = 4."); format(string, sizeof(string), "You need to sell drugs %d times more to level up.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Dealer Skill Level = 5."); }
		}
		case 5://Drug Smuggling
		{
			new level = PlayerInfo[playerid][pSmugSkill], string[53];
			if(level >= 0 && level < 20) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Smuggling Skill Level = 1."); format(string, sizeof(string), "You need to smuggle %d more drug crates to level up.", 20 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 20 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Smuggling Skill Level = 2."); format(string, sizeof(string), "You need to smuggle %d more drug crates to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Smuggling Skill Level = 3."); format(string, sizeof(string), "You need to smuggle %d more drug crates to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Smuggling Skill Level = 4."); format(string, sizeof(string), "You need to smuggle %d more drug crates to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Smuggling Skill Level = 5."); }
		}
		case 6://Arms Dealer
		{
			new level = PlayerInfo[playerid][pArmsSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer Skill Level = 1."); format(string, sizeof(string), "You need to sell %d more guns to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer Skill Level = 2."); format(string, sizeof(string), "You need to sell %d more guns to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer Skill Level = 3."); format(string, sizeof(string), "You need to sell %d more guns to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer Skill Level = 4."); format(string, sizeof(string), "You need to sell %d more guns to level up.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer Skill Level = 5."); }
		}
		case 7://Car Mechanic
		{
			new level = PlayerInfo[playerid][pMechSkill], string[60];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic Skill Level = 1."); format(string, sizeof(string), "You need to repair/refill a car for %d times more to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic Skill Level = 2."); format(string, sizeof(string), "You need to repair/refill a car for %d times more to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic Skill Level = 3."); format(string, sizeof(string), "You need to repair/refill a car for %d times more to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic Skill Level = 4."); format(string, sizeof(string), "You need to repair/refill a car for %d times more to level up.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic Skill Level = 5."); }
		}
		case 8://Boxer
		{
			new level = PlayerInfo[playerid][pBoxSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxing Skill Level = 1."); format(string, sizeof(string), "You need to Win %d more Matches to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxing Skill Level = 2."); format(string, sizeof(string), "You need to Win %d more Matches to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxing Skill Level = 3."); format(string, sizeof(string), "You need to Win %d more Matches to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxing Skill Level = 4."); format(string, sizeof(string), "You need to Win %d more Matches to level up.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxing Skill Level = 5."); }
		}
		case 9://Fishing
		{
			new level = PlayerInfo[playerid][pFishSkill], string[48];
			if(level >= 0 && level <= 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing Skill Level = 1."); format(string, sizeof(string), "You need to Fish %d more Fishes to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level <= 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing Skill Level = 2."); format(string, sizeof(string), "You need to Fish %d more Fishes to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level <= 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing Skill Level = 3."); format(string, sizeof(string), "You need to Fish %d more Fishes to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level <= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing Skill Level = 4."); format(string, sizeof(string), "You need to Fish %d more Fishes to level up.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing Skill Level = 5."); }
		}
		case 10://Trucker
		{
			new level = PlayerInfo[playerid][pTruckSkill], string[50];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor Skill Level = 1."); format(string, sizeof(string), "You need to transport goods %d times to level up.", 51 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor Skill Level = 2."); format(string, sizeof(string), "You need to transport goods %d times to level up.", 101 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor Skill Level = 3."); format(string, sizeof(string), "You need to transport goods %d times to level up.", 201 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor Skill Level = 4."); format(string, sizeof(string), "You need to transport goods %d times to level up.", 401 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor Skill Level = 5."); }
		}
		case 11://Treasure Hunter
		{
		    new level = PlayerInfo[playerid][pTreasureSkill], string[50];
            if(level >=0 && level <= 24) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 1"), format(string, sizeof(string), "You need to find treasure %d times to level up.", 25 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
            else if(level >= 25 && level <= 149) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 2"), format(string, sizeof(string), "You need to find treasure %d times to level up.", 150 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=150 && level <= 299) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 3"), format(string, sizeof(string), "You need to find treasure %d times to level up.", 300 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=300 && level <= 599) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 4"), format(string, sizeof(string), "You need to find treasure %d times to level up.", 600 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=600) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 5");
		}
		case 12: //Lock Picking
		{
		    new level = PlayerInfo[playerid][pCarLockPickSkill], string[61];
            if(level >=0 && level <= 49) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Lock Picking Skill Level = 1"), format(string, sizeof(string), "You need to successfully lock pick %d more cars to level up.", 50 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
            else if(level >= 50 && level <= 124) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Lock Picking Skill Level = 2"), format(string, sizeof(string), "You need to successfully lock pick %d more cars to level up.", 125 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=125 && level <= 224) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Lock Picking Skill Level = 3"), format(string, sizeof(string), "You need to successfully lock pick %d more cars to level up.", 225 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=225 && level <= 349) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Lock Picking Skill Level = 4"), format(string, sizeof(string), "You need successfully lock pick %d more cars to level up.", 350 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=350) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Lock Picking Skill Level = 5");
		}
		default:
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid skill number specified.");
		}
	}
	return 1;
}
