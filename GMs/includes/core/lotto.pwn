/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Lottery System

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

CMD:lottoinfo(playerid, params[])
{
	new szMessage[128];
	format(szMessage, sizeof(szMessage), "Next drawing is at %i:00, tickets sold %i, and total jackpot is $%s.", NextDrawing, TicketsSold, number_format(Jackpot));
	SendClientMessage(playerid, COLOR_WHITE, szMessage);
	return 1;
}

CMD:speclotto(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4) {
	    SendClientMessage(playerid, COLOR_GREY, "You don't have access to this command.");
	}
	else if(SpecLotto) {
	    SendClientMessage(playerid, COLOR_GREY, "A special lottery has already been started.");
	}
	else {

	    new
	        prize[64],
	        string[128];

	    if(sscanf(params, "s[64]", prize)) {
	        SendClientMessage(playerid, COLOR_GREY, "USAGE: /speclotto [text]");
		}
		else {
		    SpecLotto = 1;
		    LottoPrize = prize;
		    format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has started a special lottery. (Prize: %s)", GetPlayerNameEx(playerid), prize);
			ABroadCast(COLOR_YELLOW, string, 4);
			return 1;
		}
	}
	return 1;
}

CMD:cancelspeclotto(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4) {
	    SendClientMessage(playerid, COLOR_GREY, "You don't have access to this command.");
	}
	else if(!SpecLotto) {
	    SendClientMessage(playerid, COLOR_GREY, "No special lottery.");
	}
	else {
	    SpecLotto = 0;
	    LottoPrize = "";
	}
	return 1;
}
