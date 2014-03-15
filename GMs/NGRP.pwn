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
								     Carlos
								
								***  Director of SA:MP Development: 
								     Akatony (ViruZz)
								
								**   Development Staff: 								
									 Brendan
									 Neo
									 Miguel (s0nic)
									 Donuts
									 AlexR


				Past Developers:
								*** Director of SA:MP Development:
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

#define SERVER_GM_TEXT "NG:RP v3.0.070"



#include <a_samp>
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
    g_mysql_Exit();
	return 1;
}
