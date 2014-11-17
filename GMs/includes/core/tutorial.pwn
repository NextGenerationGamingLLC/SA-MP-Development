/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Tutorial System

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

CMD:rules(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_WHITE,"*** Server Rules ***");
	SendClientMessageEx(playerid, COLOR_GRAD1,"Always roleplay - NGRP is a role-play server. Your character's behavior needs to be as realistic, and close to real life as possible!");
	SendClientMessageEx(playerid, COLOR_GRAD1,"No metagaming! Don't mix in-character (IC) and out-of-character (OOC) chat/information. IC chat is the default chat, OOC is used by typing /b!");
	SendClientMessageEx(playerid, COLOR_GRAD2,"No killing on sight (KOS). Killing a person on sight without a word or any attempt to roleplay is not allowed and is prisonable!");
	SendClientMessageEx(playerid, COLOR_GRAD2,"No revenge-killing (RK). If a person critically injured you, you are not allowed to go back to kill them! After hospital, you lose all memory of the last 30 minutes!");
	SendClientMessageEx(playerid, COLOR_GRAD3,"No powergaming! Impossible roleplay, meaning anything that is cannot be done in real life is forbidden! Do not force roleplay on others!");
	SendClientMessageEx(playerid, COLOR_GRAD3,"No driver drive-by (DDB). Shooting out the window as a driver is strictly against the rules! You may only shoot out the window as a passenger.");
	SendClientMessageEx(playerid, COLOR_GRAD4,"No car-ramming or car parking! Do not repeatedly ram other people with your car, and don't park on top of a person to kill them!");
	SendClientMessageEx(playerid, COLOR_GRAD4,"No logging to avoid! Never log out or alt-tab out of game to avoid death, arrest or prison!");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** This is a short version of our server rulebook. Please visit www.ng-gaming.net to see a full list of NGRP's server rules! ***");
	return 1;
}

CMD:faq(playerid, params[]) {
	return ShowPlayerDialog(playerid, FAQMENU, DIALOG_STYLE_LIST, "Frequently Asked Questions","Locks\nSkins & Toys\nATMs\nFactions\nGangs\nHitmen\nWebsite, Teamspeak and Other Information\nFurther Help", "Select", "Cancel");
}

CMD:next(playerid, params[])
{
	TutorialStep(playerid);
	return 1;
}