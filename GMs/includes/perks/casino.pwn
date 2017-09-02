/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Casino System
						  ROTHSCHILD
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

new CASINOPoint[17]; 

// --- Automated Dice System by Thomas ---
// Stock Functions
stock IsPlayerInRangeOfPlayer(playerid, targetid, Float:range)
{
	if(!IsPlayerConnected(targetid) || !IsPlayerConnected(playerid)) return false;
	new Float:Position[3];
	GetPlayerPos(targetid, Position[0], Position[1], Position[2]);
	if(IsPlayerInRangeOfPoint(playerid, range, Position[0], Position[1], Position[2])) return true;
	else return false;
}
stock DestroyOfferDiceData(playerid)
{
	if((GetPVarInt(playerid, "OfferDiceID") == 0) && (GetPVarInt(playerid, "OfferingDiceID") == 0))
	{
		SetPVarInt(playerid, "OfferingDiceID", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "OfferDiceID", INVALID_PLAYER_ID);
		DeletePVar(playerid, "OfferDiceTimer");
		DeletePVar(playerid, "OfferDiceAmount");
		DeletePVar(playerid, "OfferDiceRolls");
		//printf("[DEBUG-DESTROYOFFERDICEDATA]: %d (1)", playerid);
		return 0;
	}
	if(GetPVarInt(playerid, "OfferDiceID") != INVALID_PLAYER_ID)
	{
		SetPVarInt(GetPVarInt(playerid, "OfferDiceID"), "OfferingDiceID", INVALID_PLAYER_ID);
		DeletePVar(playerid, "OfferDiceAmount");
		DeletePVar(playerid, "OfferDiceRolls");
		SetPVarInt(playerid, "OfferDiceID", INVALID_PLAYER_ID);
		//printf("[DEBUG-DESTROYOFFERDICEDATA]: %d (2)", playerid);
	}
	else if(GetPVarInt(playerid, "OfferingDiceID") != INVALID_PLAYER_ID)
	{
		DeletePVar(GetPVarInt(playerid, "OfferingDiceID"), "OfferDiceAmount");
		DeletePVar(GetPVarInt(playerid, "OfferingDiceID"), "OfferDiceRolls");
		SetPVarInt(GetPVarInt(playerid, "OfferingDiceID"), "OfferDiceID", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "OfferingDiceID", INVALID_PLAYER_ID);
		//printf("[DEBUG-DESTROYOFFERDICEDATA]: %d (3)", playerid);
	}
	return 1;
}
// Commands
CMD:offerdice(playerid, params[])
{
	new targetid, amount, rolls;
	if(sscanf(params, "udd", targetid, amount, rolls)) return SendClientMessageEx(playerid, COLOR_GREY, "Syntax: /offerdice [playerid] [amount] [rolls]");
	if(gettime() < GetPVarInt(playerid, "OfferDiceTimer")) return SendClientMessageEx(playerid, COLOR_GREY, "You must wait %d seconds before offering another dice game.", GetPVarInt(playerid, "OfferDiceTimer")-gettime());
	if(!IsPlayerInRangeOfPlayer(playerid, targetid, 5)) return SendClientMessageEx(playerid, COLOR_GREY, "Error: You are not near the player.");
	if(playerid == targetid) return SendClientMessageEx(playerid, COLOR_GREY, "Error: You are cannot roll with yourself.");
	if(GetPVarInt(playerid, "OfferDiceID") != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Error: You are already being offered a dice game. Please accept or deny it.");
	if(GetPVarInt(playerid, "OfferingDiceID") != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Error: You are already offering a dice game. Use /canceldice to cancel it.");
	if(amount < 5000000) return SendClientMessageEx(playerid, COLOR_GREY, "Error: You can only bet more than $5,000,000.");
	if(rolls < 1 || rolls > 3) return SendClientMessageEx(playerid, COLOR_GREY, "Error: You can only use 1 to 3 rolls.");
	if(PlayerInfo[playerid][pCash] < amount) return SendClientMessageEx(playerid, COLOR_GREY, "Error: You don't have enough money.");
	if(PlayerInfo[targetid][pCash] < amount) return SendClientMessageEx(playerid, COLOR_GREY, "Error: The player doesn't have enough money.");

	SetPVarInt(playerid, "OfferingDiceID", targetid);
	SetPVarInt(playerid, "OfferDiceTimer", gettime()+30);
	SetPVarInt(targetid, "OfferDiceID", playerid);
	SetPVarInt(targetid, "OfferDiceAmount", amount);
	SetPVarInt(targetid, "OfferDiceRolls", rolls);

	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "DICE: You have offered %s a game of dice for $%s with %d dice rolls. (/canceldice)", GetPlayerNameEx(targetid), number_format(amount), rolls);
	SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "DICE: %s has offered you a game of dice for $%s with %d dice rolls. (/acceptdice or /denydice)", GetPlayerNameEx(playerid), number_format(amount), rolls);
	return 1;
}

CMD:acceptdice(playerid, params[])
{
	if(GetPVarInt(playerid, "OfferDiceID") == INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Error: No one offered you a dice game.");
	if(!IsPlayerInRangeOfPlayer(playerid, GetPVarInt(playerid, "OfferDiceID"), 5)) return SendClientMessageEx(playerid, COLOR_GREY, "Error: You are too far from the player.");

	if(PlayerInfo[playerid][pCash] < GetPVarInt(playerid, "OfferDiceAmount")) return SendClientMessageEx(playerid, COLOR_GREY, "Error: You don't have enough money.");
	if(PlayerInfo[GetPVarInt(playerid, "OfferDiceID")][pCash] < GetPVarInt(playerid, "OfferDiceAmount")) return SendClientMessageEx(playerid, COLOR_GREY, "Error: The player doesn't have enough money.");

	new player1, player2;
	player1 = CalculateDiceRoll(GetPVarInt(playerid, "OfferDiceID"), GetPVarInt(playerid, "OfferDiceRolls"));
	player2 = CalculateDiceRoll(playerid, GetPVarInt(playerid, "OfferDiceRolls"));

	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "DICE: %s got {FF6347}%d{33CCFF} and you got {FF6347}%d{33CCFF}.", GetPlayerNameEx(GetPVarInt(playerid, "OfferDiceID")), player1, player2);
	SendClientMessageEx(GetPVarInt(playerid, "OfferDiceID"), COLOR_LIGHTBLUE, "DICE: You got {FF6347}%d{33CCFF} and %s got {FF6347}%d{33CCFF}.", player1, GetPlayerNameEx(playerid), player2);

	if(player1 > player2) 
	{
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "DICE: You lost $%s on the dice game verses %s.", number_format(GetPVarInt(playerid, "OfferDiceAmount")), GetPlayerNameEx(GetPVarInt(playerid, "OfferDiceID")));
		SendClientMessageEx(GetPVarInt(playerid, "OfferDiceID"), COLOR_LIGHTBLUE, "DICE: You won $%s on the dice game verses %s.", number_format(GetPVarInt(playerid, "OfferDiceAmount")), GetPlayerNameEx(playerid));
		
		PlayerInfo[playerid][pCash] -= GetPVarInt(playerid, "OfferDiceAmount");	
		PlayerInfo[GetPVarInt(playerid, "OfferDiceID")][pCash] += GetPVarInt(playerid, "OfferDiceAmount");	
		
		CasinoDBLog(GetPVarInt(playerid, "OfferDiceID"), "OFFERDICE", GetPVarInt(playerid, "OfferDiceAmount"), 0, player1, player2, 0);
	} 
	else if (player1 == player2) 
	{
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "DICE: The dice game for $%s verses %s ended in a draw.", number_format(GetPVarInt(playerid, "OfferDiceAmount")), GetPlayerNameEx(GetPVarInt(playerid, "OfferDiceID")));
		SendClientMessageEx(GetPVarInt(playerid, "OfferDiceID"), COLOR_LIGHTBLUE, "DICE: The dice game for $%s verses %s ended in a draw.", number_format(GetPVarInt(playerid, "OfferDiceAmount")), GetPlayerNameEx(playerid));
	}
	else 
	{
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "DICE: You won $%s on the dice game verses %s.", number_format(GetPVarInt(playerid, "OfferDiceAmount")), GetPlayerNameEx(GetPVarInt(playerid, "OfferDiceID")));
		SendClientMessageEx(GetPVarInt(playerid, "OfferDiceID"), COLOR_LIGHTBLUE, "DICE: You lost $%s on the dice game verses %s.", number_format(GetPVarInt(playerid, "OfferDiceAmount")), GetPlayerNameEx(playerid));
		
		PlayerInfo[playerid][pCash] += GetPVarInt(playerid, "OfferDiceAmount");	
		PlayerInfo[GetPVarInt(playerid, "OfferDiceID")][pCash] -= GetPVarInt(playerid, "OfferDiceAmount");	
		
		CasinoDBLog(playerid, "OFFERDICE", GetPVarInt(playerid, "OfferDiceAmount"), 0, player1, player2, 0);
	}
	DestroyOfferDiceData(playerid);
	return 1;
}

CMD:denydice(playerid, params[])
{	
	if(GetPVarInt(playerid, "OfferDiceID") == INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Error: No one offered you a dice game.");

	SendClientMessageEx(GetPVarInt(playerid, "OfferDiceID"), COLOR_LIGHTBLUE, "DICE: %s has denied the dice game.", GetPlayerNameEx(playerid));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "DICE: You have denied the dice game with %s.", GetPlayerNameEx(GetPVarInt(playerid, "OfferDiceID")));
	DestroyOfferDiceData(playerid);
	return 1;
}

CMD:canceldice(playerid, params[])
{	
	if(GetPVarInt(playerid, "OfferingDiceID") == INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Error: You don't have a pending dice game.");

	SendClientMessageEx(GetPVarInt(playerid, "OfferingDiceID"), COLOR_LIGHTBLUE, "DICE: %s has cancelled the dice game.", GetPlayerNameEx(playerid));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "DICE: You have cancelled the dice game with %s.", GetPlayerNameEx(GetPVarInt(playerid, "OfferingDiceID")));
	DestroyOfferDiceData(playerid);
	return 1;
}

// --- End of Automated Dice System ---

stock randomEx(min, max)
{
    new rand = random(max-min)+min;
    return rand;
}

CMD:rolldice(playerid, params[])
{
	new amount, dice, theplayer;
	if(!IsAtCasino(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You are not in a Casino.");
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_CASINO) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not working for a Casino!");
	}
	if(PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not working for this Casino!");
	if(GetPVarInt(playerid, "pRollDiceID") != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, "You are already in a game.");
	if(sscanf(params, "udd", theplayer, amount, dice)) return SendClientMessage(playerid, COLOR_GREY, "Usage: /rolldice [PlayerID] [Money Amount] [Amount of Dice]");
	if(!IsPlayerConnected(theplayer)) return SendClientMessage(playerid, COLOR_GREY, "This players isn't connected.");
	if(playerid == theplayer) return SendClientMessage(playerid, COLOR_GREY, "You can't dice with yourself.");
	if(amount > 50000000 || amount < 1000) return SendClientMessage(playerid, COLOR_GREY, "You can only bet $1000-$50,000,000");
	if(dice > 3 || dice <= 0) return SendClientMessage(playerid, COLOR_GREY, "You can only use 1-3 Dice.");
	if(PlayerInfo[theplayer][pCash] < amount) 
	{
		SendClientMessage(playerid, COLOR_GREY, "The Player doesn't have enough money.");
		return SendClientMessage(theplayer, COLOR_GREY, "You don't have enough money.");
	}
	if(PlayerInfo[theplayer][pCash] < 0) return SendClientMessage(playerid, COLOR_GREY, "You're broke.");
	if(Businesses[InBusiness(playerid)][bSafeBalance] <= 0) return SendClientMessage(playerid, COLOR_GREY, "This casino is bankrupt.");
	SetPVarInt(theplayer, "pRollDiceID", playerid);
	SetPVarInt(theplayer, "pRollDiceMoney", amount);
	SetPVarInt(theplayer, "pRollDiceAmount", dice);
	SetPVarInt(playerid, "pRollDiceID", theplayer);
	SetPVarInt(playerid, "pRollDiceMoney", amount);
	SetPVarInt(playerid, "pRollDiceAmount", dice);
	format(szMiscArray, sizeof(szMiscArray), "CASINO: %s has offered you a game of dice for $%s with %d dice rolls. (/acceptroll)", GetPlayerNameEx(playerid), number_format(amount), dice);
	SendClientMessage(theplayer, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "CASINO: You have offered %s a game of dice for $%s with %d dice rolls. (/cancelroll)", GetPlayerNameEx(theplayer), number_format(amount), dice);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
	return 1;
}

CMD:acceptroll(playerid, params[])
{
	if(GetPVarInt(playerid, "pRollDiceID") == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "You don't have a pending dice game.");
	if(PlayerInfo[playerid][pCash] < GetPVarInt(playerid, "pRollDiceMoney")) {
		DeletePVar(GetPVarInt(playerid, "pRollDiceID"), "pRollDiceID");
		DeletePVar(GetPVarInt(playerid, "pRollDiceID"), "pRollDiceMoney");
		DeletePVar(GetPVarInt(playerid, "pRollDiceID"), "pRollDiceAmount");
		SendClientMessage(GetPVarInt(playerid, "pRollDiceID"), COLOR_LIGHTBLUE, "The player couldn't afford the dice game. (/rolldice)");
		DeletePVar(playerid, "pRollDiceID");
		DeletePVar(playerid, "pRollDiceMoney");
		DeletePVar(playerid, "pRollDiceAmount");
		return SendClientMessage(playerid, COLOR_LIGHTBLUE, "You don't have enough money for the Dice Game.");
	}
	new player1, player2;
	PlayerInfo[playerid][pCash] -= GetPVarInt(playerid, "pRollDiceMoney");
	Businesses[InBusiness(playerid)][bSafeBalance] += GetPVarInt(playerid, "pRollDiceMoney");
	player1 = CalculateDiceRoll(GetPVarInt(playerid, "pRollDiceID"), GetPVarInt(playerid, "pRollDiceAmount"));
	player2 = CalculateDiceRoll(playerid, GetPVarInt(playerid, "pRollDiceAmount"));
	format(szMiscArray, sizeof(szMiscArray), "%s says: Casino got %d, Player got %d.", GetPlayerNameEx(GetPVarInt(playerid, "pRollDiceID")), player1, player2);
	ProxDetector(5.0, GetPVarInt(playerid, "pRollDiceID"), szMiscArray,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
	if(player1 > player2) 
	{
		format(szMiscArray, sizeof(szMiscArray), "%s says: Casino Wins.", GetPlayerNameEx(GetPVarInt(playerid, "pRollDiceID")));
		ProxDetector(5.0, GetPVarInt(playerid, "pRollDiceID"), szMiscArray,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
		CasinoDBLog(playerid, "DICE", GetPVarInt(playerid, "pRollDiceMoney"), 0, player1, player2, 0);
		SaveBusiness(InBusiness(playerid));
		DeleteDiceData(playerid);
	} 
	else if (player1 == player2) {
		format(szMiscArray, sizeof(szMiscArray), "%s says: It's a Draw.", GetPlayerNameEx(GetPVarInt(playerid, "pRollDiceID")));	
		ProxDetector(5.0, GetPVarInt(playerid, "pRollDiceID"), szMiscArray,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
		PlayerInfo[playerid][pCash] += GetPVarInt(playerid, "pRollDiceMoney");	
		Businesses[InBusiness(playerid)][bSafeBalance] -= GetPVarInt(playerid, "pRollDiceMoney");
		DeleteDiceData(playerid);
	}
	else {
		format(szMiscArray, sizeof(szMiscArray), "%s says: Player Wins.", GetPlayerNameEx(GetPVarInt(playerid, "pRollDiceID")));	
		ProxDetector(5.0, GetPVarInt(playerid, "pRollDiceID"), szMiscArray,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
		PlayerInfo[playerid][pCash] += GetPVarInt(playerid, "pRollDiceMoney") * 2;	
		CasinoDBLog(playerid, "DICE", GetPVarInt(playerid, "pRollDiceMoney"), GetPVarInt(playerid, "pRollDiceMoney")*2, player1, player2, 0);	
		Businesses[InBusiness(playerid)][bSafeBalance] -= GetPVarInt(playerid, "pRollDiceMoney") * 2;
		SaveBusiness(InBusiness(playerid));
		DeleteDiceData(playerid);
	}
	return 1;
}

CMD:cancelroll(playerid, params[])
{	
	if(GetPVarInt(playerid, "pRollDiceID") == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "You don't have a pending dice game.");
	format(szMiscArray, sizeof(szMiscArray), "CASINO: %s has cancelled the Dice Game.", GetPlayerNameEx(playerid));
	SendClientMessage(GetPVarInt(playerid, "pRollDiceID"), COLOR_LIGHTBLUE, szMiscArray);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "CASINO: You have cancelled the Dice Game.");
	DeleteDiceData(playerid);
	return 1;
}

CMD:slots(playerid, params[])
{
	new amount, rand[3], randsymbol[3], winPrize, areaid[1];
	GetPlayerDynamicAreas(playerid, areaid); //Assign nearest areaid
	for(new i; i < sizeof(CASINOPoint); ++i) {
	if(areaid[0] == CASINOPoint[i]) {
		SetPVarInt(playerid, "INCASINOAREA", 1);
		}
	}
	if(!GetPVarInt(playerid, "INCASINOAREA")) return SendClientMessage(playerid, COLOR_GREY, "You're not at a Slot Machine.");
	if(GetPVarInt(playerid, "UsedSlot") > gettime()) return SendClientMessage(playerid, COLOR_GREY, "You need to wait ten seconds.");
	if(!IsAtCasino(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You are not in a Casino.");
	if(sscanf(params, "d", amount)) return SendClientMessage(playerid, COLOR_GREY, "Usage: /slots [Money Amount]");
	if(amount > 1000000 || amount < 1000) return SendClientMessage(playerid, COLOR_GREY, "You can only bet $1000-$1,000,000");
	if(PlayerInfo[playerid][pCash] < amount) return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money.");
	if(PlayerInfo[playerid][pCash] < 0) return SendClientMessage(playerid, COLOR_GREY, "You're broke.");
	if(Businesses[InBusiness(playerid)][bSafeBalance] <= 0) return SendClientMessage(playerid, COLOR_GREY, "This casino is bankrupt.");
	Businesses[InBusiness(playerid)][bSafeBalance] += amount;
	PlayerInfo[playerid][pCash] -= amount;
	rand[0] = randomEx(1, 128);
	rand[1] = randomEx(1, 128);
	rand[2] = randomEx(1, 128);
	switch(rand[0])
	{
		case 1 .. 73: randsymbol[0] = 1;
		case 74 .. 78: randsymbol[0] = 2;
		case 79 .. 94: randsymbol[0] = 3;
		case 95 .. 107: randsymbol[0] = 4;
		case 108 .. 118: randsymbol[0] = 5;
		case 119 .. 126: randsymbol[0] = 6;
		case 127 .. 128: randsymbol[0] = 7;
	}
	switch(rand[1])
	{
		case 1 .. 73: randsymbol[1] = 1;
		case 74 .. 78: randsymbol[1] = 2;
		case 79 .. 94: randsymbol[1] = 3;
		case 95 .. 107: randsymbol[1] = 4;
		case 108 .. 118: randsymbol[1] = 5;
		case 119 .. 126: randsymbol[1] = 6;
		case 127 .. 128: randsymbol[1] = 7;
	}
	switch(rand[2])
	{
		case 1 .. 73: randsymbol[2] = 1;
		case 74 .. 78: randsymbol[2] = 2;
		case 79 .. 94: randsymbol[2] = 3;
		case 95 .. 107: randsymbol[2] = 4;
		case 108 .. 118: randsymbol[2] = 5;
		case 119 .. 126: randsymbol[2] = 6;
		case 127 .. 128: randsymbol[2] = 7;
	}
	winPrize = CalculateCasinoWinning(amount, randsymbol[0], randsymbol[1], randsymbol[2]);
	format(szMiscArray, sizeof(szMiscArray), "%d", randsymbol[0]);
	PlayerTextDrawSetString(playerid, PullDraw[playerid][7], szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%d", randsymbol[1]);
	PlayerTextDrawSetString(playerid, PullDraw[playerid][8], szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%d", randsymbol[2]);
	PlayerTextDrawSetString(playerid, PullDraw[playerid][9], szMiscArray);
	DisplayPullDraws(playerid);
	SetTimerEx("RemovePullDraws", 5000, false, "i", playerid);
	SetPVarInt(playerid, "UsedSlot", gettime() + 10);
	CasinoDBLog(playerid, "SLOTS", amount, winPrize, randsymbol[0], randsymbol[1], randsymbol[2]);
	DeletePVar(playerid, "INCASINOAREA");
	if(winPrize == 0)
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "You lose! Better luck, next time!");
		return 1;
	} 
	else if(randsymbol[0] == randsymbol[1] && randsymbol[1] == randsymbol[2] && randsymbol[1] == 7)
	{
		format(szMiscArray, sizeof(szMiscArray), "%s has just won the Casino %s JackPot of $%s", GetPlayerNameEx(playerid), Businesses[InBusiness(playerid)][bName], number_format(winPrize));
		SendClientMessageToAll(COLOR_YELLOW, szMiscArray);
	}
	format(szMiscArray, sizeof(szMiscArray), "Congratulations, you won $%s", number_format(winPrize));
	PlayerInfo[playerid][pCash] += winPrize;
	Businesses[InBusiness(playerid)][bSafeBalance] -= winPrize;
	SaveBusiness(InBusiness(playerid));
	SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
	return 1;
}

CalculateCasinoWinning(amount, rand0, rand1, rand2)
{
	new prize, calc;
	if(rand0 != rand1 && rand0 != rand2 && rand1 != rand2)
	{
		return 0;
	} 
	else if(rand0 == rand1 && rand1 != rand2)
	{
		switch(rand0)
		{
			case 1:
			{
				calc = amount / 100 * 42;
				prize = amount + calc;
			}
			case 2:
			{
				calc = amount / 100 * 112;
				prize = amount + calc;
			}
			case 3:
			{
				calc = amount / 100 * 61;
				prize = amount + calc;
			}
			case 4:
			{
				calc = amount / 100 * 76;
				prize = amount + calc;
			}
			case 5:
			{
				calc = amount / 100 * 92;
				prize = amount + calc;
			}
			case 6:
			{
				calc = amount / 100 * 248;
				prize = amount + calc;
			}
			case 7:
			{
				calc = amount / 100 * 677;
				prize = amount + calc;
			}
		}
	} 
	else if(rand1 == rand2 && rand1 != rand0)
	{
		switch(rand1)
		{
			case 1:
			{
				calc = amount / 100 * 42;
				prize = amount + calc;
			}
			case 2:
			{
				calc = amount / 100 * 112;
				prize = amount + calc;
			}
			case 3:
			{
				calc = amount / 100 * 61;
				prize = amount + calc;
			}
			case 4:
			{
				calc = amount / 100 * 76;
				prize = amount + calc;
			}
			case 5:
			{
				calc = amount / 100 * 92;
				prize = amount + calc;
			}
			case 6:
			{
				calc = amount / 100 * 248;
				prize = amount + calc;
			}
			case 7:
			{
				calc = amount / 100 * 677;
				prize = amount + calc;
			}
		}
	} 
	else if(rand0 == rand1 && rand1 == rand2)
	{
		switch(rand2)
		{
			case 1:
			{
				calc = amount / 100 * 92;
				prize = amount + calc;
			}
			case 2:
			{
				calc = amount / 100 * 262;
				prize = amount + calc;
			}
			case 3:
			{
				calc = amount / 100 * 146;
				prize = amount + calc;
			}
			case 4:
			{
				calc = amount / 100 * 222;
				prize = amount + calc;
			}
			case 5:
			{
				calc = amount / 100 * 338;
				prize = amount + calc;
			}
			case 6:
			{
				calc = amount / 100 * 763;
				prize = amount + calc;
			}
			case 7:
			{
				calc = amount / 100 * 28190;
				prize = amount + calc;
			}
		}	
	}
	return prize;
}


CalculateDiceRoll(playerid, dice)
{		
	new total;
	for(new i; i < dice; i++)
	{
		new rand = randomEx(1, 7);
		format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s rolls a dice that lands on %d.", GetPlayerNameEx(playerid), rand);
        ProxDetector(4.0, playerid, szMiscArray, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
        total += rand;
	}
	return total;
}

DeleteDiceData(playerid)
{
	SetPVarInt(GetPVarInt(playerid, "pRollDiceID"), "pRollDiceID", INVALID_PLAYER_ID);
	DeletePVar(GetPVarInt(playerid, "pRollDiceID"), "pRollDiceMoney");
	DeletePVar(GetPVarInt(playerid, "pRollDiceID"), "pRollDiceAmount");
	SetPVarInt(playerid, "pRollDiceID", INVALID_PLAYER_ID);
	DeletePVar(playerid, "pRollDiceMoney");
	DeletePVar(playerid, "pRollDiceAmount");
}

forward DisplayPullDraws(playerid);
public DisplayPullDraws(playerid)
{
	PlayerTextDrawShow(playerid, PullDraw[playerid][0]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][1]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][2]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][3]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][4]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][5]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][6]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][7]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][8]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][9]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][10]);
	PlayerTextDrawShow(playerid, PullDraw[playerid][11]);
}

forward RemovePullDraws(playerid);
public RemovePullDraws(playerid)
{
	PlayerTextDrawHide(playerid, PullDraw[playerid][0]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][1]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][2]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][3]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][4]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][5]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][6]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][7]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][8]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][9]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][10]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][11]);
}

LoadCASINOPoints()
{
	CASINOPoint[0] = CreateDynamicSphere(-2792.5225,91.8275,4500.2012,5);
	CASINOPoint[1] = CreateDynamicSphere(-2793.6812,85.8193,4500.201,5);
	CASINOPoint[2] = CreateDynamicSphere(-2792.5415,79.5602,4500.2012,5);
	CASINOPoint[3] = CreateDynamicSphere(-2761.8157,85.8474,4500.2012,5);
	CASINOPoint[4] = CreateDynamicSphere(-2761.8154,87.5817,4500.2012,5);
	CASINOPoint[5] = CreateDynamicSphere(-2759.2878,87.7986,4500.2012,5);
	CASINOPoint[6] = CreateDynamicSphere(-2759.2888,86.0897,4500.2012,5);
	CASINOPoint[7] = CreateDynamicSphere(-2780.5718,50.6592,4500.2012,5);
	CASINOPoint[8] = CreateDynamicSphere(-2780.5603,52.8230,4500.2012,5);
	CASINOPoint[9] = CreateDynamicSphere(-2780.5342,54.3733,4500.2012,5);
	CASINOPoint[10] = CreateDynamicSphere(228.35, 1812.55, 2001.09, 5); // Lucky Cowboy Casino
	CASINOPoint[11] = CreateDynamicSphere(200.95, 1828.80, 2001.09, 5); // Lucky Cowboy Casino
	CASINOPoint[12] = CreateDynamicSphere(1969.5468,1006.3386,992.4745,5);
    CASINOPoint[13] = CreateDynamicSphere(1969.6664,1021.0531,992.4688,5);
    CASINOPoint[14] = CreateDynamicSphere(1969.5417,1029.4148,992.4745,5);
    CASINOPoint[15] = CreateDynamicSphere(1942.3467,1014.5384,992.4688,5);
    CASINOPoint[16] = CreateDynamicSphere(1941.8306,1021.7505,992.4688,5);
}

CasinoPullLoad(playerid)
{
	PullDraw[playerid][0] = CreatePlayerTextDraw(playerid,247.000000, 244.000000, "LD_SPAC:white");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][0], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][0], -65281);
	PlayerTextDrawFont(playerid,PullDraw[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,PullDraw[playerid][0], 255);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][0], 1);
	PlayerTextDrawUseBox(playerid,PullDraw[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid,PullDraw[playerid][0], 255);
	PlayerTextDrawTextSize(playerid,PullDraw[playerid][0], 140.000000, 29.000000);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][0], 0);

	PullDraw[playerid][1] = CreatePlayerTextDraw(playerid,211.000000, 272.000000, "LD_SPAC:white");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][1], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][1], 255);
	PlayerTextDrawFont(playerid,PullDraw[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,PullDraw[playerid][1], -65281);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid,PullDraw[playerid][1], 1);
	PlayerTextDrawUseBox(playerid,PullDraw[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid,PullDraw[playerid][1], 255);
	PlayerTextDrawTextSize(playerid,PullDraw[playerid][1], 208.000000, 76.000000);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][1], 0);

	PullDraw[playerid][2] = CreatePlayerTextDraw(playerid,212.000000, 273.000000, "LD_SPAC:white");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][2], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][2], 255);
	PlayerTextDrawFont(playerid,PullDraw[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,PullDraw[playerid][2], -16776961);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid,PullDraw[playerid][2], 1);
	PlayerTextDrawUseBox(playerid,PullDraw[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid,PullDraw[playerid][2], 255);
	PlayerTextDrawTextSize(playerid,PullDraw[playerid][2], 206.000000, 74.000000);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][2], 0);

	PullDraw[playerid][3] = CreatePlayerTextDraw(playerid,213.000000, 274.000000, "LD_SPAC:white");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][3], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][3], 255);
	PlayerTextDrawFont(playerid,PullDraw[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][3], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,PullDraw[playerid][3], 65535);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid,PullDraw[playerid][3], 1);
	PlayerTextDrawUseBox(playerid,PullDraw[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid,PullDraw[playerid][3], 255);
	PlayerTextDrawTextSize(playerid,PullDraw[playerid][3], 204.000000, 72.000000);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][3], 0);

	PullDraw[playerid][4] = CreatePlayerTextDraw(playerid,214.000000, 275.000000, "LD_SPAC:white");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][4], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][4], 255);
	PlayerTextDrawFont(playerid,PullDraw[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][4], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,PullDraw[playerid][4], 255);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid,PullDraw[playerid][4], 1);
	PlayerTextDrawUseBox(playerid,PullDraw[playerid][4], 1);
	PlayerTextDrawBoxColor(playerid,PullDraw[playerid][4], 255);
	PlayerTextDrawTextSize(playerid,PullDraw[playerid][4], 202.000000, 70.000000);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][4], 0);

	PullDraw[playerid][5] = CreatePlayerTextDraw(playerid,280.000000, 275.000000, "LD_SPAC:white");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][5], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][5], 255);
	PlayerTextDrawFont(playerid,PullDraw[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][5], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,PullDraw[playerid][5], -65281);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid,PullDraw[playerid][5], 1);
	PlayerTextDrawUseBox(playerid,PullDraw[playerid][5], 1);
	PlayerTextDrawBoxColor(playerid,PullDraw[playerid][5], 255);
	PlayerTextDrawTextSize(playerid,PullDraw[playerid][5], 2.000000, 70.000000);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][5], 0);

	PullDraw[playerid][6] = CreatePlayerTextDraw(playerid,354.000000, 275.000000, "LD_SPAC:white");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][6], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][6], 255);
	PlayerTextDrawFont(playerid,PullDraw[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][6], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,PullDraw[playerid][6], -65281);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid,PullDraw[playerid][6], 1);
	PlayerTextDrawUseBox(playerid,PullDraw[playerid][6], 1);
	PlayerTextDrawBoxColor(playerid,PullDraw[playerid][6], 255);
	PlayerTextDrawTextSize(playerid,PullDraw[playerid][6], 2.000000, 70.000000);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][6], 0);

	PullDraw[playerid][7] = CreatePlayerTextDraw(playerid,247.000000, 281.000000, "7");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][7], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][7], 65535);
	PlayerTextDrawFont(playerid,PullDraw[playerid][7], 3);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][7], 1.190000, 6.000000);
	PlayerTextDrawColor(playerid,PullDraw[playerid][7], -1);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][7], 0);

	PullDraw[playerid][8] = CreatePlayerTextDraw(playerid,319.000000, 281.000000, "7");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][8], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][8], 65535);
	PlayerTextDrawFont(playerid,PullDraw[playerid][8], 3);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][8], 1.190000, 6.000000);
	PlayerTextDrawColor(playerid,PullDraw[playerid][8], -1);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][8], 0);

	PullDraw[playerid][9] = CreatePlayerTextDraw(playerid,389.000000, 281.000000, "7");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][9], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][9], 65535);
	PlayerTextDrawFont(playerid,PullDraw[playerid][9], 3);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][9], 1.190000, 6.000000);
	PlayerTextDrawColor(playerid,PullDraw[playerid][9], -1);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][9], 0);

	PullDraw[playerid][10] = CreatePlayerTextDraw(playerid,319.000000, 249.000000, "ROTHSCHILD INC");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][10], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][10], -1);
	PlayerTextDrawFont(playerid,PullDraw[playerid][10], 2);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][10], 0.410000, 2.099999);
	PlayerTextDrawColor(playerid,PullDraw[playerid][10], 65535);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid,PullDraw[playerid][10], 0);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][10], 0);

	PullDraw[playerid][11] = CreatePlayerTextDraw(playerid,318.000000, 247.000000, "ROTHSCHILD INC");
	PlayerTextDrawAlignment(playerid,PullDraw[playerid][11], 2);
	PlayerTextDrawBackgroundColor(playerid,PullDraw[playerid][11], -1);
	PlayerTextDrawFont(playerid,PullDraw[playerid][11], 2);
	PlayerTextDrawLetterSize(playerid,PullDraw[playerid][11], 0.410000, 2.099999);
	PlayerTextDrawColor(playerid,PullDraw[playerid][11], -1);
	PlayerTextDrawSetOutline(playerid,PullDraw[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid,PullDraw[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid,PullDraw[playerid][11], 0);
	PlayerTextDrawSetSelectable(playerid,PullDraw[playerid][11], 0);

}

hook OnPlayerConnect(playerid)
{
	CasinoPullLoad(playerid);
	SetPVarInt(playerid, "pRollDiceID", INVALID_PLAYER_ID);
	DestroyOfferDiceData(playerid);
}

hook OnPlayerDisconnect(playerid)
{
	PlayerTextDrawHide(playerid, PullDraw[playerid][0]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][1]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][2]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][3]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][4]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][5]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][6]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][7]);
	PlayerTextDrawHide(playerid, PullDraw[playerid][8]);
	SendClientMessage(GetPVarInt(playerid, "pRollDiceID"), COLOR_LIGHTBLUE, "The player you offered dice to, left the server.");
	DeleteDiceData(playerid);
}