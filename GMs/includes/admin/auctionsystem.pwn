/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Auction System

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

CMD:editauctions(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4) {
		new
		    szDialog[700];

		for (new i; i < sizeof(Auctions); i++)
    	{
            format(szDialog, sizeof(szDialog), "%s\n Auction: %i | Item: %s | Highest Bid: $%i | Wining: %s(%i)", szDialog, i+1, Auctions[i][BiddingFor], Auctions[i][Bid], Auctions[i][Wining], Auctions[i][Bidder]);
    	}
    	ShowPlayerDialog(playerid, DIALOG_ADMINAUCTIONS, DIALOG_STYLE_LIST, "Auctions", szDialog, "Edit", "Close");
	}
	return 1;
}

CMD:auctions(playerid, params[]) {

	new
		szDialog[500];

    for (new i; i < sizeof(Auctions); i++)
    {
    	format(szDialog, sizeof(szDialog), "%s\n Auction: %i | Item: %s | Highest Bid: $%i", szDialog, i+1, Auctions[i][BiddingFor], Auctions[i][Bid]);
    }
	ShowPlayerDialog(playerid, DIALOG_AUCTIONS, DIALOG_STYLE_LIST, "Auctions", szDialog, "More Info", "Close");
	return 1;
}