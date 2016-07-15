/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					  Fall Festival

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

#define			DIALOG_BALLOON				(6019)

forward RemoveTicket(playerid);
public RemoveTicket(playerid) if(PlayerInfo[playerid][bTicket]) PlayerInfo[playerid][bTicket]--;

CMD:@@balloon@@(playerid, params[])
{
	if(!PlayerInfo[playerid][bTicket])
	{
		new string[128];
		format(string, sizeof(string),"Item: Balloon Ride Ticket\nYour Credits: %s\nCost: {FFD700}5{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(PlayerInfo[playerid][pCredits]-5));
		ShowPlayerDialogEx(playerid, DIALOG_BALLOON, DIALOG_STYLE_MSGBOX, "Purchase Balloon Ticket", string, "Purchase", "Cancel");
		return 0;
	}
	return 1;
}

CMD:giveticket(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338 && PlayerInfo[playerid][pPR] < 2 && PlayerInfo[playerid][pShopTech] < 3) return SendClientMessageEx(playerid, -1, "You are not authorized to use this command!");
	new target, amount;
	if(sscanf(params, "ud", target, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /giveticket [player] [amount]");
	PlayerInfo[target][bTicket] += amount;
	new string[128];
	format(string, sizeof(string), "You have given %s %d balloon ride tickets.", GetPlayerNameEx(target), amount);
	SendClientMessageEx(playerid, -1, string);
	format(string, sizeof(string), "%s has given you %d balloon ride tickets.", GetPlayerNameEx(playerid), amount);
	SendClientMessageEx(target, -1, string);
	format(string, sizeof(string), "[GIVETICKET] %s gave %s(%d) %d balloon ride tickets.", GetPlayerNameEx(playerid), GetPlayerNameEx(target), GetPlayerSQLId(target), amount);
	Log("logs/admin.log", string);
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	if(dialogid == DIALOG_BALLOON)
	{
		if(!response) return 1;
		if(PlayerInfo[playerid][pCredits] < 5) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");
		new string[128];
		GivePlayerCredits(playerid, -5, 1);
		PlayerInfo[playerid][bTicket]++;
		format(string, sizeof(string), "[BTICKET] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: 5]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]));
		Log("logs/credits.log", string), print(string);
		SendClientMessageEx(playerid, COLOR_CYAN, "You have purchased a Balloon Ride ticket for 5 credits.");
	}
	return 0;
}

CMD:corndog(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1468.1566,-76.7717,23.2247)) return SendClientMessage(playerid, COLOR_GREY, "You are not at a corn dog stand.");
	if(GetPlayerCash(playerid) < 2000) return SendClientMessage(playerid, COLOR_GREY, "You need $2000 to buy a corn dog.");
	SendClientMessageEx(playerid, COLOR_GRAD4, "You have purchased a 'Corn Dog' for $2000.");
	GivePlayerCash(playerid, -2000);
	new Float:health;
	GetHealth(playerid, health);
	if(health < 100) 
	{
		if(health > 90) SetHealth(playerid, 100);
		else SetHealth(playerid, health + 10.0);
	}
	return 1;
}

CMD:pizza(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1477.4579,-70.6260,23.2188)) return SendClientMessage(playerid, COLOR_GREY, "You are not at a pizza stand.");
	if(GetPlayerCash(playerid) < 2000) return SendClientMessage(playerid, COLOR_GREY, "You need $2000 to buy a pizza.");
	SendClientMessageEx(playerid, COLOR_GRAD4, "You have purchased a 'Pizza' for $2000.");
	GivePlayerCash(playerid, -2000);
	new Float:health;
	GetHealth(playerid, health);
	if(health < 100) 
	{
		if(health > 90) SetHealth(playerid, 100);
		else SetHealth(playerid, health + 10.0);
	}
	return 1;
}

CMD:frieddough(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1465.0697,-86.3609,23.2247)) return SendClientMessage(playerid, COLOR_GREY, "You are not at a fried dough stand.");
	if(GetPlayerCash(playerid) < 2000) return SendClientMessage(playerid, COLOR_GREY, "You need $2000 to buy a fried dough.");
	SendClientMessageEx(playerid, COLOR_GRAD4, "You have purchased a 'Fried Dough' for $2000.");
	GivePlayerCash(playerid, -2000);
	new Float:health;
	GetHealth(playerid, health);
	if(health < 100) 
	{
		if(health > 90) SetHealth(playerid, 100);
		else SetHealth(playerid, health + 10.0);
	}
	return 1;
}