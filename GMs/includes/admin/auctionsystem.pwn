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
	    		mysql_format(MainPipeline, query, sizeof(query), "SELECT `Money` FROM `accounts` WHERE `id` = %d", Auctions[AuctionItem][Bidder]);
	    		mysql_tquery(MainPipeline, query, "ReturnMoney", "i", playerid);
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

forward EndAuction(auction);
public EndAuction(auction)
{
	if(Auctions[auction][InProgress] == 1 && Auctions[auction][Bidder] != 0) {
		if(Auctions[auction][Expires] == 0) {

			new string[128];
		    format( string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: %s has won the auction for %s with the amount of $%d", Auctions[auction][Wining], Auctions[auction][BiddingFor], Auctions[auction][Bid]);
			ABroadCast( COLOR_YELLOW, string, 2 );

			format(string, sizeof(string), "%s(%d) has won the auction for item %s(%i) and has paid $%d", Auctions[auction][Wining], Auctions[auction][Bidder], Auctions[auction][BiddingFor], auction, Auctions[auction][Bid]);
			Log("logs/auction.log", string);

			new Player = ReturnUser(Auctions[auction][Wining]);
			if(IsPlayerConnected(Player) && GetPlayerSQLId(Player) == Auctions[auction][Bidder])
			{
	 			format(string, sizeof(string), "(Auction Winner) %s %s", Auctions[auction][Wining], Auctions[auction][BiddingFor]);
			   	AddFlag(Player, INVALID_PLAYER_ID, string);

				format(string, sizeof(string), "You have won the auction for the %s!", Auctions[auction][BiddingFor]);
		  		SendClientMessageEx(Player, COLOR_GREEN, string);
			}
			else
			{
		 		format(string, sizeof(string), "(Auction Winner) %s %s", Auctions[auction][Wining], Auctions[auction][BiddingFor]);
		   		AddOFlag(Auctions[auction][Bidder], INVALID_PLAYER_ID, string);
			}

			Auctions[auction][InProgress] = 0;
			Auctions[auction][Bid] = 0;
			Auctions[auction][Bidder] = 0;
			Auctions[auction][Expires] = 0;
			strcpy(Auctions[auction][Wining], "(none)", MAX_PLAYER_NAME);
			strcpy(Auctions[auction][BiddingFor], "(none)", 64);
			Auctions[auction][Increment] = 0;
			KillTimer(Auctions[auction][Timer]);
			SaveAuction(auction);
		}
		else
		{
		    Auctions[auction][Expires] += -1;
		}
	}
	else
	{
	    KillTimer(Auctions[auction][Timer]);
	}
	return 1;
}

CMD:editauctions(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) {
		new
		    szDialog[700];

		for (new i; i < sizeof(Auctions); i++)
    	{
            format(szDialog, sizeof(szDialog), "%s\n Auction: %i | Item: %s | Highest Bid: $%i | Wining: %s(%i)", szDialog, i+1, Auctions[i][BiddingFor], Auctions[i][Bid], Auctions[i][Wining], Auctions[i][Bidder]);
    	}
    	ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS, DIALOG_STYLE_LIST, "Auctions", szDialog, "Edit", "Close");
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
	ShowPlayerDialogEx(playerid, DIALOG_AUCTIONS, DIALOG_STYLE_LIST, "Auctions", szDialog, "More Info", "Close");
	return 1;
}