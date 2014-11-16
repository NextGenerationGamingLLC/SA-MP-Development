/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[MAIN NGRP.PWN]--------------------------------

							Next Generation Gaming, LLC
				(created by Next Generation Gaming Development Team)

				Current Developers:
								**** Director of Support Operations: 
									 Lewis
								
								***  Director of SA:MP Development: 
									 Miguel (s0nic)
								
								**   Development Staff:
									 Donuts
									 Austin
									 Dom
									 Connor
									 Farva

				Past Developers:
								*** Director of SA:MP Development:
									Akatony
									John
									Brendan
									Brian
									Scott
									GhoulSlayer
									Zhao
									Donuts
									Mo Cena
									Calgon
	  
								** 	Developers:
									Neo
									AlexR
									ThomasJWhite
									Beren
									Kareemtastic
									Sew Sumi
									Razbit

				Credits to alternate sources (Y_Less for foreach, gf, etc)
 *
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
 
			/*  ---------------- SCRIPT REVISION ----------------- */

// Do not forget to change this everytime you commit - it's mandatory!

#define SERVER_GM_TEXT "NG:RP v3.0.152"


#include <a_samp>
#undef  MAX_PLAYERS
#define MAX_PLAYERS (700)
#include <a_mysql>
#include <streamer>
#include <yom_buttons>
#include <ZCMD>
#include <sscanf2>
#include <crashdetect>
#include <YSI\y_timers>
#include <YSI\y_utils>
#if defined SOCKET_ENABLED
#include <socket>
#endif
#include "./includes/defines.pwn"
#include "./includes/enums.pwn"
#include "./includes/variables.pwn"
#include "./includes/timers.pwn"
#include "./includes/functions.pwn"
#include "./includes/commands.pwn"
#include "./includes/mysql.pwn"
#include "./includes/OnPlayerLoad.pwn"
#include "./includes/callbacks.pwn"
#include "./includes/textdraws.pwn"
#include "./includes/streamer.pwn"
#include "./includes/OnDialogResponse.pwn"
#include "./includes/core/vactions.pwn"

/*
//admin includes 
#include "./includes/admin/admin.pwn"
#include "./includes/admin/advisory.pwn"
#include "./includes/admin/auctionsystem.pwn"
#include "./includes/admin/bugreport.pwn"
#include "./includes/admin/flags.pwn"
#include "./includes/admin/gift.pwn"
#include "./includes/admin/reportsystem.pwn"
#include "./includes/admin/serveroffences.pwn"
#include "./includes/admin/vouchers.pwn"

//business includes
#include "./includes/business/247items.pwn"
#include "./includes/business/businesscore.pwn"
#include "./includes/business/mailsystem.pwn"

//core includes
#include "./includes/core/acceptcancel.pwn"
#include "./includes/core/advertisements.pwn"
#include "./includes/core/banking.pwn"
#include "./includes/core/chat.pwn"
#include "./includes/core/enterexit.pwn"
#include "./includes/core/fireworks.pwn"
#include "./includes/core/helpcmds.pwn"
#include "./includes/core/hospital.pwn"
#include "./includes/core/hunger.pwn"
#include "./includes/core/lotto.pwn"
#include "./includes/core/lselevator.pwn"
#include "./includes/core/marriage.pwn"
#include "./includes/core/namechange.pwn"
#include "./includes/core/phone.pwn"
#include "./includes/core/radio.pwn"
#include "./includes/core/service.pwn"
#include "./includes/core/storage.pwn"
#include "./includes/core/tutorial.pwn"
#include "./includes/core/upgrades.pwn"
#include "./includes/core/vactions.pwn"
#include "./includes/core/weapons.pwn"

//dynamic core includes
#include "./includes/dynamiccore/doors.pwn"
#include "./includes/dynamiccore/garages.pwn"
#include "./includes/dynamiccore/gates.pwn"
#include "./includes/dynamiccore/houses.pwn"
#include "./includes/dynamiccore/mapicons.pwn"
#include "./includes/dynamiccore/motds.pwn"
#include "./includes/dynamiccore/paynsprays.pwn"
#include "./includes/dynamiccore/textlables.pwn"

//event kernels includes
#include "./includes/eventkernels/bday.pwn"
#include "./includes/eventkernels/event.pwn"
#include "./includes/eventkernels/eventpoints.pwn"
#include "./includes/eventkernels/fif.pwn"
#include "./includes/eventkernels/hungergames.pwn"
#include "./includes/eventkernels/paintball.pwn"
#include "./includes/eventkernels/rewardplay.pwn"
#include "./includes/eventkernels/rfl.pwn"
#include "./includes/eventkernels/xmas.pwn"
#include "./includes/eventkernels/zombies.pwn"

//dynamic group system includes
#include "./includes/group/citizenship.pwn"
#include "./includes/group/contract.pwn"
#include "./includes/group/criminal.pwn"
#include "./includes/group/fires.pwn"
#include "./includes/group/gov.pwn"
#include "./includes/group/groupcore.pwn"
#include "./includes/group/judicial.pwn"
#include "./includes/group/lea.pwn"
#include "./includes/group/medic.pwn"
#include "./includes/group/news.pwn"
#include "./includes/group/prisonsystem.pwn"
#include "./includes/group/racing.pwn"
#include "./includes/group/taxi.pwn"
#include "./includes/group/towing.pwn"
#include "./includes/group/turfspoints.pwn"

//job system includes
#include "./includes/jobs/bartender.pwn"
#include "./includes/jobs/bodyguard.pwn"
#include "./includes/jobs/boxing.pwn"
#include "./includes/jobs/craftsman.pwn"
#include "./includes/jobs/drugs.pwn"
#include "./includes/jobs/fishing.pwn"
#include "./includes/jobs/jobcore.pwn"
#include "./includes/jobs/lawyer.pwn"
#include "./includes/jobs/mechanic.pwn"
#include "./includes/jobs/pizzaboy.pwn"
#include "./includes/jobs/shipment.pwn"
#include "./includes/jobs/taxi.pwn"
#include "./includes/jobs/treasure.pwn"
#include "./includes/jobs/whore.pwn"

//perk system includes
#include "./includes/perks/boombox.pwn"
#include "./includes/perks/dedicated.pwn"
#include "./includes/perks/famed.pwn"
#include "./includes/perks/poker.pwn"
#include "./includes/perks/shopcore.pwn"
#include "./includes/perks/tokens.pwn"
#include "./includes/perks/toys.pwn"
#include "./includes/perks/vipcore.pwn"

//vehicle system includes
#include "./includes/vehiclesystem/drivingtest.pwn"
#include "./includes/vehiclesystem/licenses.pwn"
#include "./includes/vehiclesystem/tow.pwn"
#include "./includes/vehiclesystem/vehiclecore.pwn"
*/

#pragma unused DynamicBusiness

main() {}

public OnGameModeInit()
{
	print("Preparing the gamemode, please wait...");
	g_mysql_Init();
	return 1;
}

public OnGameModeExit()
{
	print("Exiting the gamemode, please wait..."); // Added this for easier access to find logs about the gamemode exiting
    g_mysql_Exit();
	return 1;
}
