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
								*** Director of SA:MP Development:
									Austin

								**  Development Staff:
									Dom
									Miguel (s0nic)
									Jingles
									Winterfield

				Past Developers:
								*** Director of SA:MP Development:F
									Akatony
									John
									Brendan
									BrianF
									Scott
									GhoulSlayer
									Zhao
									Donuts
									Mo Cena
									Calgon

								** 	Developers:
									AlexR
									Jamie
									Connor
									Neo
									ThomasJWhite
									Beren
									Kareemtastic
									Sew Sumi
									Razbit
									Farva

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

#define SERVER_GM_TEXT "NG:RP v3.0.278"

// #define AREA_DEBUG

#include <a_samp>
#undef  MAX_PLAYERS
#define MAX_PLAYERS (500)
#include <a_mysql>
#include <streamer>
#include <yom_buttons>
#include <ZCMD>
#include <sscanf2>
#include <crashdetect>
#include <YSI\y_timers>
#include <YSI\y_utils>
#include <mSelection>
#include <gvar>
//#include <irc>

#if defined SOCKET_ENABLED
#include <socket>
#endif

#include "./includes/defines.pwn"
#include "./includes/enums.pwn"
#include "./includes/variables.pwn"
#include "./includes/wrappers.pwn"
#include "./includes/timers.pwn"
#include "./includes/functions.pwn"
#include "./includes/mysql.pwn"
#include "./includes/OnPlayerLoad.pwn"
#include "./includes/callbacks.pwn"
#include "./includes/textdraws.pwn"
#include "./includes/streamer.pwn"
#include "./includes/OnDialogResponse.pwn"
//#include "./includes/irc.pwn"

//streamer includes
#include "./includes/streamer/removebuildings.pwn"
#include "./includes/streamer/areas.pwn"
#include "./includes/streamer/buttons.pwn"
#include "./includes/streamer/objects.pwn"
#include "./includes/streamer/pickups.pwn"
#include "./includes/streamer/textlabels.pwn"
#include "./includes/streamer/vehicles.pwn"
#include "./includes/streamer/OnPlayerEditDynamicObject.pwn"

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
#include "./includes/admin/watchdogs.pwn"
#include "./includes/admin/intlist.pwn"
#include "./includes/admin/anticheat.pwn"
#include "./includes/admin/spectate.pwn"
#include "./includes/admin/teleport.pwn"
#include "./includes/admin/watch.pwn"
#include "./includes/admin/newbie.pwn"
#include "./includes/admin/ban.pwn"

//business includes
#include "./includes/business/247items.pwn"
#include "./includes/business/businesscore.pwn"
#include "./includes/business/mailsystem.pwn"

//core includes
#include "./includes/core/acceptcancel.pwn"
#include "./includes/core/advertisements.pwn"
#include "./includes/core/banking.pwn"
#include "./includes/core/chat.pwn"
//#include "./includes/core/enterexit.pwn"
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
//#include "./includes/core/tutorial.pwn"
#include "./includes/core/upgrades.pwn"
#include "./includes/core/vactions.pwn"
#include "./includes/core/weapons.pwn"
#include "./includes/core/damage.pwn"
#include "./includes/core/health.pwn"
#include "./includes/core/teams.pwn"
#include "./includes/core/stats.pwn"
#include "./includes/core/timefuncs.pwn"
#include "./includes/core/camerafuncs.pwn"
#include "./includes/core/clearcheckpoint.pwn"
#include "./includes/core/maintenance.pwn"
#include "./includes/core/countrycheck.pwn"
#include "./includes/core/countdown.pwn"
#include "./includes/core/filehandle.pwn"
#include "./includes/core/initgamemode.pwn"
#include "./includes/core/login.pwn"
#include "./includes/core/miscload.pwn"
#include "./includes/core/proxdetector.pwn"
#include "./includes/core/setplayerspawn.pwn"
#include "./includes/core/stats.pwn"
#include "./includes/core/streamprep.pwn"
#include "./includes/core/emailcheck.pwn"
#include "./includes/core/AccountSettings.pwn"
#include "./includes/core/tutorial_new.pwn"

//WIP
#include "./includes/core/deluxegps.pwn"

// #tryinclude "./includes/core/inactive.pwn"

//dynamic core includes
#include "./includes/dynamic/doors.pwn"
#include "./includes/dynamic/garages.pwn"
#include "./includes/dynamic/gates.pwn"
#include "./includes/dynamic/houses.pwn"
#include "./includes/dynamic/mapicons.pwn"
#include "./includes/dynamic/motds.pwn"
#include "./includes/dynamic/paynsprays.pwn"
#include "./includes/dynamic/textlabels.pwn"
#include "./includes/dynamic/impound.pwn"
#include "./includes/dynamic/speedcamera.pwn"
#include "./includes/dynamic/arrestpoints.pwn"
#include "./includes/dynamic/dynsu.pwn"
#include "./includes/dynamic/housemarket.pwn"
#include "./includes/dynamic/ddsale.pwn"
#include "./includes/dynamic/parking.pwn"
#include "./includes/dynamic/MetalDetectors.pwn"

//vehicle system includes
#include "./includes/vehsystem/vehiclecore.pwn"
#include "./includes/vehsystem/drivingtest.pwn"
#include "./includes/vehsystem/Server_DMV.pwn"
#include "./includes/vehsystem/speedo.pwn"
#include "./includes/vehsystem/tow.pwn"
#include "./includes/vehsystem/VLP.pwn"
#include "./includes/vehsystem/helmet.pwn"
#include "./includes/vehsystem/groupvehs.pwn"
#include "./includes/vehsystem/playervehs.pwn"

//event kernels includes
//#include "./includes/events/bday.pwn"
#include "./includes/events/event.pwn"
#include "./includes/events/eventpoints.pwn"
#include "./includes/events/fif.pwn"
#include "./includes/events/hungergames.pwn"
#include "./includes/events/paintball.pwn"
#include "./includes/events/rewardplay.pwn"
#include "./includes/events/rfl.pwn"
#include "./includes/events/xmas.pwn"
#include "./includes/events/zombies.pwn"
#include "./includes/events/valentine.pwn"
//#include "./includes/events/festival.pwn"
//#include "./includes/events/stpatricks.pwn"
//#include "./includes/events/memorial.pwn"

//dynamic group system includes
#include "./includes/group/citizenship.pwn"
#include "./includes/group/contract.pwn"
#include "./includes/group/fires.pwn"
#include "./includes/group/gov.pwn"
#include "./includes/group/groupcore.pwn"
#include "./includes/group/judicial.pwn"
#include "./includes/group/lea.pwn"
#include "./includes/group/medic.pwn"
#include "./includes/group/news.pwn"
// #include "./includes/group/prisonsystem.pwn"
#include "./includes/group/racing.pwn"
#include "./includes/group/taxi.pwn"
#include "./includes/group/towing.pwn"
#include "./includes/group/turfs.pwn"
#include "./includes/group/points.pwn"
#include "./includes/group/cratesystem.pwn"
#include "./includes/group/callsystem.pwn"
#include "./includes/group/gangshipment.pwn"
#include "./includes/group/gangcrates.pwn"
//#include "./includes/group/gangrobbery.pwn"
#include "./includes/group/GovArms.pwn"
#include "./includes/group/grouppay.pwn"
#include "./includes/group/gangtags.pwn"
#include "./includes/group/GunLicense.pwn"
//#include "./includes/group/URLrace.pwn"
#include "./includes/group/sanews.pwn"
#include "./includes/group/turfs2.pwn"

//job system includes
#include "./includes/jobs/bartender.pwn"
#include "./includes/jobs/bodyguard.pwn"
#include "./includes/jobs/boxing.pwn"
#include "./includes/jobs/craftsman.pwn"
#include "./includes/jobs/detective.pwn"
#include "./includes/jobs/drugs.pwn"
// #include "./includes/jobs/fishing.pwn"
#include "./includes/jobs/jobcore.pwn"
#include "./includes/jobs/dynjobcore.pwn"
#include "./includes/jobs/lawyer.pwn"
#include "./includes/jobs/mechanic.pwn"
#include "./includes/jobs/pizzaboy.pwn"
#include "./includes/jobs/shipment.pwn"
#include "./includes/jobs/taxi.pwn"
#include "./includes/jobs/treasure.pwn"
#include "./includes/jobs/whore.pwn"


//perk system includes
#include "./includes/perks/boombox.pwn"
#include "./includes/perks/backpack.pwn"
#include "./includes/perks/dedicated.pwn"
#include "./includes/perks/famed.pwn"
#include "./includes/perks/poker.pwn"
#include "./includes/perks/shopcore.pwn"
#include "./includes/perks/tokens.pwn"
#include "./includes/perks/toys.pwn"
#include "./includes/perks/vipcore.pwn"

#include "./includes/core/ammo.pwn"
#include "./includes/core/drugsystem.pwn"
#include "./includes/core/phone_new.pwn"
#include "./includes/core/payphones.pwn"
#include "./includes/group/rivalry.pwn"


// WIP
#include "./includes/core/ATMs.pwn"
#include "./includes/core/Banks.pwn"
#include "./includes/core/entexit.pwn"
#include "./includes/vehsystem/vehauto.pwn"
#include "./includes/DBLog.pwn"
#include "./includes/core/Player_Interact.pwn"
#include "./includes/core/inactive2.pwn"


// Jingles WIP
#include "./includes/core/minigame.pwn"
#include "./includes/anticheat2.pwn"
#include "./includes/furniture.pwn"

// Winterfield WIP

#include "./includes/prison_system.pwn"
#include "./includes/garbagesystem.pwn"
#include "./includes/fishingsystem.pwn"


main(){}

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

AntiDeAMX()
{
    new a[][] = {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}
