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

stock SendJobMessage(job, color, string[])
{
	foreach(new i: Player)
	{
		if(((PlayerInfo[i][pJob] == job || PlayerInfo[i][pJob2] == job || PlayerInfo[i][pJob3] == job) && JobDuty[i] == 1) || ((PlayerInfo[i][pJob] == job || PlayerInfo[i][pJob2] == job || PlayerInfo[i][pJob3] == job) && (job == 7 && GetPVarInt(i, "MechanicDuty") == 1) || (job == 2 && GetPVarInt(i, "LawyerDuty") == 1))) {
			SendClientMessageEx(i, color, string);
		}
	}
}

/*
stock GetJobName(job)
{
	new name[20];
	switch(job)
	{
		case 1: name = "Detective";
		case 2: name = "Lawyer";
		case 3: name = "Whore";
		case 4: name = "Drugs Dealer";
		case 6: name = "News Reporter";
		case 7: name = "Car Mechanic";
		case 8: name = "Bodyguard";
		case 9: name = "Arms Dealer";
		case 10: name = "Car Dealer";
		case 12: name = "Boxer";
		case 14: name = "Drug Smuggler";
		case 15: name = "Paper Boy";
		case 16: name = "Shipment Contractor";
		case 17: name = "Taxi Driver";
		case 18: name = "Craftsman";
		case 19: name = "Bartender";
		case 20: name = "Shipment Contractor";
		case 21: name = "Pizza Boy";
		default: name = "None";
	}
	return name;
}
*/

stock GetJobLevel(playerid, job)
{
	new jlevel;
	switch(job)
	{
		case 1:
		{
			new skilllevel = PlayerInfo[playerid][pDetSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 2:
		{
			new skilllevel = PlayerInfo[playerid][pLawSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 3:
		{
			new skilllevel = PlayerInfo[playerid][pSexSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 7:
		{
			new skilllevel = PlayerInfo[playerid][pMechSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 9:
		{
			new skilllevel = PlayerInfo[playerid][pArmsSkill];
			if(skilllevel >= 50 && skilllevel < 200) jlevel = 1;
			else if(skilllevel >= 200 && skilllevel < 300) jlevel = 2;
			else if(skilllevel >= 300 && skilllevel < 700) jlevel = 3;
			else if(skilllevel >= 700 && skilllevel < 1200) jlevel = 4;
			else if(skilllevel >= 1200) jlevel = 5;
		}
		case 12:
		{
			new skilllevel = PlayerInfo[playerid][pBoxSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 14:
		{
			new skilllevel = PlayerInfo[playerid][pDrugSmuggler];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 20:
		{
			new skilllevel = PlayerInfo[playerid][pTruckSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 22:
		{
			new skilllevel = PlayerInfo[playerid][pTreasureSkill];
			if(skilllevel >= 0 && skilllevel <= 24) jlevel = 1;
			else if(skilllevel >= 25 && skilllevel <= 149) jlevel = 2;
			else if(skilllevel >= 150 && skilllevel <= 299) jlevel = 3;
			else if(skilllevel >= 300 && skilllevel <= 599) jlevel = 4;
			else if(skilllevel >= 600) jlevel = 5;
		}
	}
	return jlevel;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case JOBHELPMENU:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: //Detective
					{
						ShowPlayerDialogEx(playerid, DETECTIVEJOB, DIALOG_STYLE_MSGBOX, "Detective", "Information:\n\nThis job can be used to locate people anywhere around San Andreas.\nThis is helpful for the Government factions, and can be used to find criminals. It is a legal job and you cannot get busted for doing it.\nIt will tell you the last known location(area) they were found in and give you a beacon.", "Next", "Cancel");
					}
					case 1: //Lawyer
					{
						ShowPlayerDialogEx(playerid, LAWYERJOB, DIALOG_STYLE_MSGBOX, "Lawyer", "Information:\n\nThis job can be used to remove wanted stars, reduce jail time, and list all criminals.\nThis is helpful for criminals and crooks, it is a legal job and you cannot get busted for doing it.\nIt will come in handy for your friends and families who got trouble with the cops.", "Next", "Cancel");
					}
					case 2: //Whore
					{
						ShowPlayerDialogEx(playerid, WHOREJOB, DIALOG_STYLE_MSGBOX, "Whore", "Information:\n\nThis job can be used to bring pleasure to any clients who may be interested in having some fun.\nThis is a job that offers sex to every client who comes along.\nThis is an illegal job and you can get busted for doing it.", "Next", "Cancel");
					}
					case 3: //Drug Dealer
					{
						ShowPlayerDialogEx(playerid, DRUGDEALERJOB, DIALOG_STYLE_MSGBOX, "Drug Dealer", "Information:\n\nThis job can be used to sell Cannabis and crack to any customers you might find.\nIt often comes in handy, when you're a higher level at it.\nThe higher the level, the more drugs you can hold.\nThis is an illegal job and you can get busted for doing it.", "Next", "Cancel");
					}
					case 4: //Mechanic
					{
						ShowPlayerDialogEx(playerid, MECHANICJOB, DIALOG_STYLE_MSGBOX, "Mechanic", "Information:\n\nThis job can be used to repair, add nos, and add hydraulics to vehicles.\nThis job can sometimes be rewarding, but often people do not require assistance.\nThis is a legal job and you cannot get busted for doing it.", "Next", "Cancel");
					}
					case 5: //Bodyguard
					{
						ShowPlayerDialogEx(playerid, BODYGUARDJOB, DIALOG_STYLE_MSGBOX, "Bodyguard", "Information:\n\nThis job can be used to give people half armor.\nThis job is very profitable and the common spot for purchasing off bodyguards is the gym.\nThis is a legal job and you cannot get busted for doing it.", "Next", "Cancel");
					}
					case 6: //Arms Dealer
					{
						ShowPlayerDialogEx(playerid, ARMSDEALERJOB, DIALOG_STYLE_MSGBOX, "Arms Dealer", "Information:\n\nThis job can be used to sell people weapons.\nThis job is very profitable and can earn you big cash at later levels.\nThis is an illegal job and you can get busted for doing it.", "Next", "Cancel");
					}
					case 7: //Boxer
					{
						ShowPlayerDialogEx(playerid, BOXERJOB, DIALOG_STYLE_MSGBOX, "Boxer", "Information:\n\nThis job can be used to box people inside the Ganton Gym.\nThis job is not very money-making, but you can become the boxing champion.\nThis is a legal job and you cannot get busted for doing it.", "Next", "Cancel");
					}
					case 8: //Taxi Driver
					{
						ShowPlayerDialogEx(playerid, TAXIJOB, DIALOG_STYLE_MSGBOX, "Taxi Driver", "Information:\n\nThis job can be used to take passengers around the city for any price you desire($1 - $500 per 16 seconds).\nThis job is not very profitable as people do not usually call taxis, and sometimes they try to steal your taxi vehicle.\nThis is a legal job and you cannot get busted for doing it.", "Next", "Cancel");
					}
					case 9: //Drug Smuggling
					{
						ShowPlayerDialogEx(playerid, SMUGGLEJOB, DIALOG_STYLE_MSGBOX, "Drug Smuggling", "Information:\n\nThis job can be used to keep Crack and Cannabis filled in the Crack Lab.\nThis job is very profitable as people usually buy crack and Cannabis, and sometimes they try to steal your Cannabis and crack.\nThis is an ilegal job and you can get busted for doing it.", "Next", "Cancel");
					}
					case 10: //Craftsman
					{
						ShowPlayerDialogEx(playerid, CRAFTJOB, DIALOG_STYLE_MSGBOX, "Craftsman", "Information:\nThis job can be used to sell crafts to other players.\nThis job is very profitable as people have a need for many of the things you can make.\nThis is a legal job and you can not get busted for doing it.\n\nCommands:\n/getmats /craft\nLocation of job: This job can be obtained in Willowfield at the junkyard, at the job icon(yellow circle).", "Done", "Cancel");
					}
					case 11: //Bartender
					{
						ShowPlayerDialogEx(playerid, BARTENDERJOB, DIALOG_STYLE_MSGBOX, "Bartender", "Information:\nThis job can be used to sell drinks to other players.\nThis is a legal job and you can not get busted for doing it.\n\nCommands:\n/selldrink\nLocation of job: This job can be obtained in Idlewood inside the Alhambra Club, at the job icon(yellow i).", "Done", "Cancel");
					}
					case 12: //Trucker
					{
						ShowPlayerDialogEx(playerid, TRUCKERJOB, DIALOG_STYLE_MSGBOX, "Shipment Contractor","Information:\nThis job can be used to earn money by making truck deliveries\nThis is a legal job, however you can get busted if you transport illegal goods or hijack trucks. Also Shipment Contractors get a 25 percent bonus for carting illegal goods.\n\nCommands:\n/loadshipment /checkcargo /hijackcargo\nLocation of job: This job can be obtained at the San Fierro Docks, at the job icon(yellow I).", "Done", "Cancel");
					}
					case 13: //Pizza Boy
					{
						ShowPlayerDialogEx(playerid, PIZZAJOB, DIALOG_STYLE_MSGBOX, "Pizza Boy","Information:\nThis job can be used to earn money by grabbing a pizza from the\n SF Pizza Stack and then delivering it to different houses.\n You will get less and less money as time moves on and eventually,\n when the pizza is cold, it will be worthless.\n\nCommands:\n/getpizza\nLocation of job: This job can be obtained at the Pizza Stacks in Idlewood, at the job icon(yellow I).", "Done", "Cancel");
					}
					case 14: { // Garbageman
						ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Garbageman","Information:\nThis job can be used to earn money by collecting trash from\n the streets.\n\nCommands:\n/garbagerun\nLocation of job: Use /map to find it.", "Done", "Cancel");
					}
				}
			}
		}
		case SMUGGLEJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, SMUGGLEJOB3, DIALOG_STYLE_MSGBOX, "Drug Smuggling", "Commands:\n\n/getcrate [name(Cannabis/Crack)]\n\nLocation of job: This job can be obtained inside the Crack Lab, at the job icon(yellow circle).", "Done", "Cancel");
			}
		}
		case SMUGGLEJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, SMUGGLEJOB2, DIALOG_STYLE_MSGBOX, "Drug Smuggling", "Note: There is no reload time for drug smuggling and you do need to level it up to obtain more money. There are 5 levels for this job.", "Next", "Cancel");
			}
		}
		case TAXIJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, TAXIJOB2, DIALOG_STYLE_MSGBOX, "Taxi Driver", "Note: There is no reload time for taxi fares and there are no levels for this job. In other words, you do not need to level it up to earn the max money you can.", "Next", "Cancel");
			}
		}
		case TAXIJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, TAXIJOB3, DIALOG_STYLE_MSGBOX, "Taxi Driver", "Commands:\n\n/fare [$1 - $500]\n\nLocation of job: This job can be obtained in front of Unity Station at the job icon(yellow circle).", "Done", "Cancel");
			}
		}
		case BOXERJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, BOXERJOB3, DIALOG_STYLE_MSGBOX, "Boxer", "Commands:\n\n/fight [PlayerID/Name], /boxstats\n\nLocation of job: This job can be obtained inside the Ganton Gym, at the job icon(yellow circle).", "Done", "Cancel");
			}
		}
		case BOXERJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, BOXERJOB2, DIALOG_STYLE_MSGBOX, "Boxer", "Note: There is no reload time for boxing and you don't need to level it up to box people in the gym. There are 3 levels for this job.\n\nLevel 1: Beginner Boxer.\nLevel 2: Amateur Boxer.\nLevel 3: Professional Boxer.", "Next", "Cancel");
			}
		}
		case ARMSDEALERJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, ARMSDEALERJOB2, DIALOG_STYLE_MSGBOX, "Arms Dealer", "Note: The reload time for selling guns is always 10 seconds, no matter what level.\n\nSkills:\n\nLevel 1 Weapons: Flowers, Knuckles, SDPistol, 9mm, and Shotgun.\nLevel 2 Weapons: Baseball Bat, Cane, MP5, and Rifle.\nLevel 3 Weapons: Shovel and Deagle.\nLevel 4 Weapons: Poolcue and Golf Club.\nLevel 5 Weapons: Katana, Dildo, UZI & TEC9.\nGold+ VIP Feature: AK-47", "Next", "Cancel");
			}
		}
		case ARMSDEALERJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, ARMSDEALERJOB3, DIALOG_STYLE_MSGBOX, "Arms Dealer", "Commands:\n\n/getmats, /sellgun\n\nLocation of job: This job can be obtained outside the large Ammunation, at the 'gun' icon.", "Done", "Cancel");
			}
		}
		case BODYGUARDJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, BODYGUARDJOB3, DIALOG_STYLE_MSGBOX, "Bodyguard", "Commands:\n\n/guard [player] [Price $2000 - $10000]\n/frisk [player]\n\nLocation of job: This job can be obtained outside the Ganton Gym, at the job icon(yellow circle).", "Done", "Cancel");
			}
		}
		case BODYGUARDJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, BODYGUARDJOB2, DIALOG_STYLE_MSGBOX, "Bodyguard", "Note: The reload time is always 1 minute. There are no job levels for this job. In other words, you do not need to level it up to earn the max money you can.", "Next", "Cancel");
			}
		}
		case MECHANICJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, MECHANICJOB2, DIALOG_STYLE_MSGBOX, "Mechanic", "Note: The reload time is always 1 minute, no matter what level.", "Next", "Cancel");
			}
		}
		case MECHANICJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, MECHANICJOB3, DIALOG_STYLE_MSGBOX, "Mechanic", "Commands:\n\n/fix, /repair, /hyd, /nos, /refill, /mechduty\n\nLocation of job: This job can be obtained at blueberry, at the job icon(yellow circle).", "Done", "Cancel");
			}
		}
		case DRUGDEALERJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, DRUGDEALERJOB2, DIALOG_STYLE_MSGBOX, "Drug Dealer", "Note: The reload time is always 1 minute, no matter what level.\n\nSkills:\n\nLevel 1: You can hold 10 Cannabis and 5 crack.\nLevel 2: You can hold 20 Cannabis and 15 crack.\nLevel 3: You can hold 30 Cannabis and 15 crack.\nLevel 4: You can hold 40 Cannabis and 20 crack.\nLevel 5: You can hold 50 Cannabis and 25 crack.", "Next", "Cancel");
			}
		}
		case DRUGDEALERJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, DRUGDEALERJOB3, DIALOG_STYLE_MSGBOX, "Drug Dealer", "Commands:\n\n/sell, /mydrugs, /usedrug, /buypot, /buyopium, /plantpot, /plantopium, /pickplant, /checkplant, /makeheroin\n\nLocation of job: This job can be located outside the Drug Den, opposite the Ganton Gym, at the 'D' icon.", "Done", "Cancel");
			}
		}
		case WHOREJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, WHOREJOB3, DIALOG_STYLE_MSGBOX, "Whore", "Commands:\n\n/sex\n/sex is a command to offer sex to a client, and may only be used in a vehicle.\n\nLocation of job: This job can be obtained inside the Pig Pen, at the job icon(yellow circle).", "Done", "Cancel");
			}
		}
		case LAWYERJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, LAWYERJOB3, DIALOG_STYLE_MSGBOX, "Lawyer", "Commands:\n\n/defend, /free, /wanted, /lawyerduty, /offerappeal, /finishappeal\n\nLocation of job: This job can be found at the job map icon(yellow circle)near the bank.", "Done", "Cancel");
			}
		}
		case WHOREJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, WHOREJOB2, DIALOG_STYLE_MSGBOX, "Whore", "Note: The reload time is always 1 minute, no matter what level.\n\nSkills:\n\nLevel 1: You have a very high chance of catching/giving STD's.\nLevel 2: You have a high chance of catching/giving STD's.\nLevel 3: You have a medium chance of catching/giving STD's.\nLevel 4: You have a low chance of catching/giving STD's.\nLevel 5: You have a very low chance of catching/giving STD's.", "Next", "Cancel");
			}
		}
		case LAWYERJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, LAWYERJOB2, DIALOG_STYLE_MSGBOX, "Lawyer", "Note: The reload time is always 2 minutes, no matter what level.\n\nSkills:\n\nLevel 1: You can reduce inmates sentences by 1 minute.\nLevel 2: You can reduce inmates sentences by 2 minutes.\nLevel 3: You can reduce inmates sentences by 3 minutes.\nLevel 4: You can reduce inmates sentences by 4 minutes.\nLevel 5: You can reduce inmates sentences by 5 minutes.", "Next", "Cancel");
			}
		}
		case DETECTIVEJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, DETECTIVEJOB3, DIALOG_STYLE_MSGBOX, "Detective", "Commands:\n\n/trace\n/trace is a command that can locate a player's phone position.\n\nLocation of job: This job can be obtained in the Los Santos Police Department.", "Done", "Cancel");
			}
		}
		case DETECTIVEJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, DETECTIVEJOB2, DIALOG_STYLE_MSGBOX, "Detective", "Skills:\n\nLevel 1: You can find someone for 3 seconds, the reload time is 2 minutes.\nLevel 2: You can find someone for 5 seconds, the reload time is 1 minute, 20 seconds.\nLevel 3: You can find someone for 7 seconds, the reload time is 1 minute.\nLevel 4: You can find someone for 9 seconds, the reload time is 30 seconds.\nLevel 5: You can find someone for 11 seconds, the reload time is 20 seconds.", "Next", "Cancel");
			}
		}
	}
	return 0;
}

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
		/*else if (IsPlayerInRangeOfPoint(playerid,3.0,2166.3772,-1675.3829,15.0859) || IsPlayerInRangeOfPoint(playerid,3.0,-2089.344970, 87.800231, 35.320312) || IsPlayerInRangeOfPoint(playerid,3.0,-1528.0924,2688.7837,55.8359)) {
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
		}*/
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
		/*else if (IsPlayerInRangeOfPoint(playerid,3.0,1366.4325,-1275.2096,13.5469) || IsPlayerInRangeOfPoint(playerid,3.0,-2623.333984, 209.235931, 4.684767) || IsPlayerInRangeOfPoint(playerid,3.0,-1513.4904,2614.3591,55.8078)) {
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
		}*/
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
		/*else if (IsPlayerInRangeOfPoint(playerid,3.0,2354.2808,-1169.2959,28.0066) || IsPlayerInRangeOfPoint(playerid,3.0,-2630.7375,2349.3994,8.4892)) {
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
		}*/
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
		/*else if (IsPlayerInRangeOfPoint(playerid,3.0,1741.5199,-1863.4615,13.5750) || IsPlayerInRangeOfPoint(playerid,3.0,-1981.144775, 133.063293, 27.687500)) {
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
		}*/
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
		SendClientMessageEx(playerid, COLOR_GREY, "| 1: Detective\t\t\t\t\t\t\t\t\t\t\t\t6: Car Mechanic");
		SendClientMessageEx(playerid, COLOR_GREY, "| 2: Lawyer\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t7: Boxer");
		SendClientMessageEx(playerid, COLOR_GREY, "| 3: Whore\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t8: Fishing");
		SendClientMessageEx(playerid, COLOR_GREY, "| 4: Drug Smuggler\t\t\t\t\t9: Trucker");
		SendClientMessageEx(playerid, COLOR_GREY, "| 5: Arms Dealer\t\t\t\t\t\t\t10: Treasure Hunter");
		SendClientMessageEx(playerid, COLOR_GREY, "| 11: Lock Picking");
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
		case 4://Drug Smuggling
		{
			new level = PlayerInfo[playerid][pDrugSmuggler], string[61];
            if(level >=0 && level < 50) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Smuggling Level = 1"), format(string, sizeof(string), "You need to successfully smuggle %d more drugs to level up.", 50 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
            else if(level >= 50 && level < 100) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Smuggling Level = 2"), format(string, sizeof(string), "You need to successfully smuggle %d more drugs to level up.", 100 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=100 && level < 200) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Smuggling Level = 3"), format(string, sizeof(string), "You need to successfully smuggle %d more drugs to level up.", 200 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=200 && level < 400) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Smuggling Level = 4"), format(string, sizeof(string), "You need successfully smuggle %d more drugs to level up.", 400 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=400 && level < 885) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drug Smuggling Level = 5");
		}
		case 5://Arms Dealer
		{
			new level = PlayerInfo[playerid][pArmsSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer Skill Level = 1."); format(string, sizeof(string), "You need to sell %d more guns to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer Skill Level = 2."); format(string, sizeof(string), "You need to sell %d more guns to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 700) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer Skill Level = 3."); format(string, sizeof(string), "You need to sell %d more guns to level up.", 700 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 700 && level < 1200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer Skill Level = 4."); format(string, sizeof(string), "You need to sell %d more guns to level up.", 1200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 1200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer Skill Level = 5."); }
		}
		case 6://Car Mechanic
		{
			new level = PlayerInfo[playerid][pMechSkill], string[64];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic Skill Level = 1."); format(string, sizeof(string), "You need to repair/refill a car for %d times more to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic Skill Level = 2."); format(string, sizeof(string), "You need to repair/refill a car for %d times more to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic Skill Level = 3."); format(string, sizeof(string), "You need to repair/refill a car for %d times more to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic Skill Level = 4."); format(string, sizeof(string), "You need to repair/refill a car for %d times more to level up.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic Skill Level = 5."); }
		}
		case 7://Boxer
		{
			new level = PlayerInfo[playerid][pBoxSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxing Skill Level = 1."); format(string, sizeof(string), "You need to Win %d more Matches to level up.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxing Skill Level = 2."); format(string, sizeof(string), "You need to Win %d more Matches to level up.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxing Skill Level = 3."); format(string, sizeof(string), "You need to Win %d more Matches to level up.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxing Skill Level = 4."); format(string, sizeof(string), "You need to Win %d more Matches to level up.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxing Skill Level = 5."); }
		}
		case 8: //Fishing
		{
		    new level = PlayerInfo[playerid][pFishingSkill], string[61];
            if(level >=0 && level < 50) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing Level = 1"), format(string, sizeof(string), "You need to successfully fish %d more times to level up.", 50 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
            else if(level >= 50 && level < 100) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing Level = 2"), format(string, sizeof(string), "You need to successfully fish %d more times to level up.", 100 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=100 && level < 200) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing Level = 3"), format(string, sizeof(string), "You need to successfully fish %d more times to level up.", 200 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=200 && level < 400) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing Level = 4"), format(string, sizeof(string), "You need successfully fish %d more times to level up.", 400 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=400) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing Level = 5");
		}
		case 9://Trucker
		{
			new level = PlayerInfo[playerid][pTruckSkill], string[50];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor Skill Level = 1."); format(string, sizeof(string), "You need to transport goods %d times to level up.", 51 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor Skill Level = 2."); format(string, sizeof(string), "You need to transport goods %d times to level up.", 101 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor Skill Level = 3."); format(string, sizeof(string), "You need to transport goods %d times to level up.", 201 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor Skill Level = 4."); format(string, sizeof(string), "You need to transport goods %d times to level up.", 401 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor Skill Level = 5."); }
		}
		case 10://Treasure Hunter
		{
		    new level = PlayerInfo[playerid][pTreasureSkill], string[50];
            if(level >=0 && level <= 24) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 1"), format(string, sizeof(string), "You need to find treasure %d times to level up.", 25 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
            else if(level >= 25 && level <= 149) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 2"), format(string, sizeof(string), "You need to find treasure %d times to level up.", 150 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=150 && level <= 299) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 3"), format(string, sizeof(string), "You need to find treasure %d times to level up.", 300 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=300 && level <= 599) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 4"), format(string, sizeof(string), "You need to find treasure %d times to level up.", 600 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=600) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 5");
		}
		case 11: //Lock Picking
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

CMD:jobhelp(playerid, params[]) {
    return ShowPlayerDialogEx(playerid, JOBHELPMENU, DIALOG_STYLE_LIST, "Which job do you need help with?","Detective\nLawyer\nWhore\nDrug Dealer\nMechanic\nBodyguard\nArms Dealer\nBoxer\nTaxi Driver\nDrug Smuggling\nCraftsman\nBartender\nShipment Contractor\nPizza Boy\nGarbageman", "Select", "Cancel");
}

CMD:quitjob(playerid, params[])
{
	if(PlayerInfo[playerid][pDonateRank] >= 1 || PlayerInfo[playerid][pFamed] >= 1)
	{
		new jobid;
		if(sscanf(params, "d", jobid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /quitjob [jobid]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available: 1, 2, 3 (secondary VIP/Famed)");
			return 1;
		}

		switch(jobid)
		{
		case 1:
			{
				if(PlayerInfo[playerid][pJob] > 0 ) {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have quit your Job.");
					if(PlayerInfo[playerid][pJob] == 2)
					{
						if(GetPVarInt(playerid, "LawyerDuty") == 1) Lawyers--;
						SetPVarInt(playerid, "LawyerDuty", 0);
					}
					if(PlayerInfo[playerid][pJob] == 7)
					{
						if(GetPVarInt(playerid, "MechanicDuty") == 1) Mechanics--;
						SetPVarInt(playerid, "MechanicDuty", 0);
					}
					PlayerInfo[playerid][pJob] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "   You don't have a job!");
				}
			}
		case 2:
			{
				if(PlayerInfo[playerid][pJob2] > 0 ) {				
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have quit your second Job.");
					if(PlayerInfo[playerid][pJob2] == 2)
					{
						if(GetPVarInt(playerid, "LawyerDuty") == 1) Lawyers--;
						SetPVarInt(playerid, "LawyerDuty", 0);
					}
					if(PlayerInfo[playerid][pJob2] == 7)
					{
						if(GetPVarInt(playerid, "MechanicDuty") == 1) Mechanics--;
						SetPVarInt(playerid, "MechanicDuty", 0);
					}
					PlayerInfo[playerid][pJob2] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "   You don't have a second job!");
				}
			}
		case 3:
			{
				if(PlayerInfo[playerid][pJob3] > 0 ) {				
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have quit your third job.");
					if(PlayerInfo[playerid][pJob3] == 2)
					{
						if(GetPVarInt(playerid, "LawyerDuty") == 1) Lawyers--;
						SetPVarInt(playerid, "LawyerDuty", 0);
					}
					if(PlayerInfo[playerid][pJob3] == 7)
					{
						if(GetPVarInt(playerid, "MechanicDuty") == 1) Mechanics--;
						SetPVarInt(playerid, "MechanicDuty", 0);
					}
					PlayerInfo[playerid][pJob3] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "   You don't have a third job!");
				}
			}
		default:
			{
				SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /quitjob [jobid]");
				SendClientMessageEx(playerid, COLOR_GREY, "Available: 1, 2, 3 (secondary VIP/Famed)");
			}
		}
	}
	else
	{
		if(PlayerInfo[playerid][pJob] > 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have quit your Job.");
			if(PlayerInfo[playerid][pJob] == 2)
			{
				if(GetPVarInt(playerid, "LawyerDuty") == 1) Lawyers--;
				SetPVarInt(playerid, "LawyerDuty", 0);
			}
			if(PlayerInfo[playerid][pJob] == 7)
			{
				if(GetPVarInt(playerid, "MechanicDuty") == 1) Mechanics--;
				SetPVarInt(playerid, "MechanicDuty", 0);
			}
			PlayerInfo[playerid][pJob] = 0;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   You don't even have a Job!");
		}
	}
	return 1;
}
