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

stock HigherBid(playerid)
{
	new
    	AuctionItem = GetPVarInt(playerid, "AuctionItem");

	if(Auctions[AuctionItem][InProgress] == 1) {
		if(Auctions[AuctionItem][Bidder] != 0) {

			new Player = ReturnUser(Auctions[AuctionItem][Wining]);
			if(IsPlayerConnected(Player) && GetPlayerSQLId(Player) == Auctions[AuctionItem][Bidder])
			{
	  			GivePlayerCash(Player, Auctions[AuctionItem][Bid]);
	    		SendClientMessageEx(Player, COLOR_WHITE, "Someone has outbid you, your money has been returned.");
		    	new szMessage[128];
		    	format(szMessage, sizeof(szMessage), "Amount of $%d has been returned to %s(%d) (IP:%s) for being outbid", Auctions[AuctionItem][Bid], GetPlayerNameEx(Player), GetPlayerSQLId(Player), GetPlayerIpEx(Player));
				Log("logs/auction.log", szMessage);

                GivePlayerCash(playerid, -GetPVarInt(playerid, "BidPlaced"));
				Auctions[AuctionItem][Bid] = GetPVarInt(playerid, "BidPlaced");
				Auctions[AuctionItem][Bidder] = GetPlayerSQLId(playerid);
				strcpy(Auctions[AuctionItem][Wining], GetPlayerNameExt(playerid), MAX_PLAYER_NAME);

				format(szMessage, sizeof(szMessage), "You have placed a bid of $%i on %s.", GetPVarInt(playerid, "BidPlaced"), Auctions[AuctionItem][BiddingFor]);
				SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

				format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has placed a bid of $%i on %s(%i)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "BidPlaced"), Auctions[AuctionItem][BiddingFor], AuctionItem);
				Log("logs/auction.log", szMessage);

				SaveAuction(AuctionItem);

				DeletePVar(playerid, "BidPlaced");
				DeletePVar(playerid, "AuctionItem");
			}
			else
			{
	  			new query[128];
	    		format(query, sizeof(query), "SELECT `Money` FROM `accounts` WHERE `id` = %d", Auctions[AuctionItem][Bidder]);
	    		mysql_function_query(MainPipeline, query, true, "ReturnMoney", "i", playerid);
		   }
		}
		else
		{
		    new
		        szMessage[128];

  			GivePlayerCash(playerid, -GetPVarInt(playerid, "BidPlaced"));
			Auctions[AuctionItem][Bid] = GetPVarInt(playerid, "BidPlaced");
			Auctions[AuctionItem][Bidder] = GetPlayerSQLId(playerid);
			strcpy(Auctions[AuctionItem][Wining], GetPlayerNameExt(playerid), MAX_PLAYER_NAME);

			format(szMessage, sizeof(szMessage), "You have placed a bid of $%i on %s.", GetPVarInt(playerid, "BidPlaced"), Auctions[AuctionItem][BiddingFor]);
			SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

			format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has placed a bid of $%i on %s(%i)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "BidPlaced"), Auctions[AuctionItem][BiddingFor], AuctionItem);
			Log("logs/auction.log", szMessage);

			SaveAuction(AuctionItem);

			DeletePVar(playerid, "BidPlaced");
			DeletePVar(playerid, "AuctionItem");
		}
	}
	return 1;
}

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