/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Poker System

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

PokerOptions(playerid, option)
{
	switch(option)
	{
		case 0:
		{
			DeletePVar(playerid, "pkrActionOptions");
			PlayerTextDrawHide(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawHide(playerid, PlayerPokerUI[playerid][39]);
			PlayerTextDrawHide(playerid, PlayerPokerUI[playerid][40]);
		}
		case 1: // if(CurrentBet >= ActiveBet)
		{
			SetPVarInt(playerid, "pkrActionOptions", 1);
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][38], "RAISE");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][39], "CHECK");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][40], "FOLD");

			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][39]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][40]);
		}
		case 2: // if(CurrentBet < ActiveBet)
		{
			SetPVarInt(playerid, "pkrActionOptions", 2);
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][38], "CALL");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][39], "RAISE");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][40], "FOLD");

			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][39]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][40]);
		}
		case 3: // if(pkrChips < 1)
		{
			SetPVarInt(playerid, "pkrActionOptions", 3);

			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][38], "CHECK");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][39], "FOLD");

			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][39]);
		}
	}
}

PokerCallHand(playerid)
{
	ShowCasinoGamesMenu(playerid, DIALOG_CGAMESCALLPOKER);
}

PokerRaiseHand(playerid)
{
	ShowCasinoGamesMenu(playerid, DIALOG_CGAMESRAISEPOKER);
}

PokerCheckHand(playerid)
{
	if(GetPVarInt(playerid, "pkrActiveHand")) {
		SetPVarString(playerid, "pkrStatusString", "Check");
	}

	// Animation
	ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
}

PokerFoldHand(playerid)
{
	if(GetPVarInt(playerid, "pkrActiveHand")) {
		DeletePVar(playerid, "pkrCard1");
		DeletePVar(playerid, "pkrCard2");
		DeletePVar(playerid, "pkrActiveHand");
		DeletePVar(playerid, "pkrStatus");

		PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActiveHands]--;

		SetPVarString(playerid, "pkrStatusString", "Fold");

		// SFX
		GlobalPlaySound(5602, PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrX], PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrY], PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrZ]);

		// Animation
		ApplyAnimation(playerid, "CASINO", "cards_out", 4.1, 0, 1, 1, 1, 1, 1);
	}
}

PokerDealHands(tableid)
{
	new tmp = 0;

	// Loop through active players.
	for(new i = 0; i < 6; i++) {
		new playerid = PokerTable[tableid][pkrSlot][i];

		if(playerid != -1) {

			if(GetPVarInt(playerid, "pkrStatus") && GetPVarInt(playerid, "pkrChips") > 0) {
				SetPVarInt(playerid, "pkrCard1", PokerTable[tableid][pkrDeck][tmp]);
				SetPVarInt(playerid, "pkrCard2", PokerTable[tableid][pkrDeck][tmp+1]);

				SetPVarInt(playerid, "pkrActiveHand", 1);

				PokerTable[tableid][pkrActiveHands]++;

				// SFX
				PlayerPlaySound(playerid, 5602, 0.0, 0.0, 0.0);

				// Animation
				ApplyAnimation(playerid, "CASINO", "cards_in", 4.1, 0, 1, 1, 1, 1, 1);

				tmp += 2;
			}
		}
	}

	// Loop through community cards.
	for(new i = 0; i < 5; i++) {

		PokerTable[tableid][pkrCCards][i] = PokerTable[tableid][pkrDeck][tmp];
		tmp++;
	}
}

PokerShuffleDeck(tableid)
{
	// SFX
	GlobalPlaySound(5600, PokerTable[tableid][pkrX], PokerTable[tableid][pkrY], PokerTable[tableid][pkrZ]);

	// Order the deck
	for(new i = 0; i < 52; i++) {
		PokerTable[tableid][pkrDeck][i] = i;
	}

	// Randomize the array (AKA Shuffle Algorithm)
	new rand, tmp, i;
	for(i = 52; i > 1; i--) {
		rand = random(52) % i;
		tmp = PokerTable[tableid][pkrDeck][rand];
		PokerTable[tableid][pkrDeck][rand] = PokerTable[tableid][pkrDeck][i-1];
		PokerTable[tableid][pkrDeck][i-1] = tmp;
	}
}

PokerFindPlayerOrder(tableid, index)
{
	new tmpIndex = -1;
	for(new i = 0; i < 6; i++) {
		new playerid = PokerTable[tableid][pkrSlot][i];

		if(playerid != -1) {
			tmpIndex++;

			if(tmpIndex == index) {
				if(GetPVarInt(playerid, "pkrStatus") == 1)
					return playerid;
			}
		}
	}
	return -1;
}

PokerAssignBlinds(tableid)
{
	if(PokerTable[tableid][pkrPos] == 6) {
		PokerTable[tableid][pkrPos] = 0;
	}

	// Find where to start & distubute blinds.
	new bool:roomDealer = false, bool:roomBigBlind = false, bool:roomSmallBlind = false;

	// Find the Dealer.
	new tmpPos = PokerTable[tableid][pkrPos];
	if(roomDealer == false) {
		if(tmpPos == 6) {
			tmpPos = 0;
		}

		new playerid = PokerFindPlayerOrder(tableid, tmpPos);

		if(playerid != -1) {
			SetPVarInt(playerid, "pkrRoomDealer", 1);
			SetPVarString(playerid, "pkrStatusString", "Dealer");
			roomDealer = true;
		} else {
			tmpPos++;
		}
	}

	// Find the player after the Dealer.
	tmpPos = PokerTable[tableid][pkrPos];
	if(roomBigBlind == false) {
		if(tmpPos == 6) {
			tmpPos = 0;
		}

		new playerid = PokerFindPlayerOrder(tableid, tmpPos);

		if(playerid != -1) {
			if(GetPVarInt(playerid, "pkrRoomDealer") != 1 && GetPVarInt(playerid, "pkrRoomBigBlind") != 1 && GetPVarInt(playerid, "pkrRoomSmallBlind") != 1) {
				SetPVarInt(playerid, "pkrRoomBigBlind", 1);
				new tmpString[128];
				format(tmpString, sizeof(tmpString), "~r~BB -$%d", PokerTable[tableid][pkrBlind]);
				SetPVarString(playerid, "pkrStatusString", tmpString);
				roomBigBlind = true;

				if(GetPVarInt(playerid, "pkrChips") < PokerTable[tableid][pkrBlind]) {
					PokerTable[tableid][pkrPot] += GetPVarInt(playerid, "pkrChips");
					SetPVarInt(playerid, "pkrChips", 0);
				} else {
					PokerTable[tableid][pkrPot] += PokerTable[tableid][pkrBlind];
					SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")-PokerTable[tableid][pkrBlind]);
				}

				SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrBlind]);
				PokerTable[tableid][pkrActiveBet] = PokerTable[tableid][pkrBlind];

			} else {
				tmpPos++;
			}
		} else {
			tmpPos++;
		}
	}

	// Small Blinds are active only if there are more than 2 players.
	if(PokerTable[tableid][pkrActivePlayers] > 2) {

		// Find the player after the Big Blind.
		tmpPos = PokerTable[tableid][pkrPos];
		if(roomSmallBlind == false) {
			if(tmpPos == 6) {
				tmpPos = 0;
			}

			new playerid = PokerFindPlayerOrder(tableid, tmpPos);

			if(playerid != -1) {
				if(GetPVarInt(playerid, "pkrRoomDealer") != 1 && GetPVarInt(playerid, "pkrRoomBigBlind") != 1 && GetPVarInt(playerid, "pkrRoomSmallBlind") != 1) {
					SetPVarInt(playerid, "pkrRoomSmallBlind", 1);
					new tmpString[128];
					format(tmpString, sizeof(tmpString), "~r~SB -$%d", PokerTable[tableid][pkrBlind]/2);
					SetPVarString(playerid, "pkrStatusString", tmpString);
					roomSmallBlind = true;

					if(GetPVarInt(playerid, "pkrChips") < (PokerTable[tableid][pkrBlind]/2)) {
						PokerTable[tableid][pkrPot] += GetPVarInt(playerid, "pkrChips");
						SetPVarInt(playerid, "pkrChips", 0);
					} else {
						PokerTable[tableid][pkrPot] += (PokerTable[tableid][pkrBlind]/2);
						SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")-(PokerTable[tableid][pkrBlind]/2));
					}

					SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrBlind]/2);
					PokerTable[tableid][pkrActiveBet] = PokerTable[tableid][pkrBlind]/2;
				} else {
					tmpPos++;
				}
			} else {
				tmpPos++;
			}
		}
	}
	PokerTable[tableid][pkrPos]++;
}

PokerRotateActivePlayer(tableid)
{
	new nextactiveid = -1, lastapid = -1, lastapslot = -1;
	if(PokerTable[tableid][pkrActivePlayerID] != -1) {
		lastapid = PokerTable[tableid][pkrActivePlayerID];

		for(new i = 0; i < 6; i++) {
			if(PokerTable[tableid][pkrSlot][i] == lastapid) {
				lastapslot = i;
			}
		}

		DeletePVar(lastapid, "pkrActivePlayer");
		DeletePVar(lastapid, "pkrTime");

		PokerOptions(lastapid, 0);
	}

	// New Round Init Block
	if(PokerTable[tableid][pkrRotations] == 0 && lastapid == -1 && lastapslot == -1) {

		// Find & Assign ActivePlayer to Dealer
		for(new i = 0; i < 6; i++) {
			new playerid = PokerTable[tableid][pkrSlot][i];

			if(GetPVarInt(playerid, "pkrRoomDealer") == 1) {
				nextactiveid = playerid;
				PokerTable[tableid][pkrActivePlayerID] = playerid;
				PokerTable[tableid][pkrActivePlayerSlot] = i;
				PokerTable[tableid][pkrRotations]++;
				PokerTable[tableid][pkrSlotRotations] = i;
			}
		}
	}
	else if(PokerTable[tableid][pkrRotations] >= 6)
	{
		PokerTable[tableid][pkrRotations] = 0;
		PokerTable[tableid][pkrStage]++;

		if(PokerTable[tableid][pkrStage] > 3) {
			PokerTable[tableid][pkrActive] = 4;
			PokerTable[tableid][pkrDelay] = 20+1;
			return 1;
		}

		PokerTable[tableid][pkrSlotRotations]++;
		if(PokerTable[tableid][pkrSlotRotations] >= 6) {
			PokerTable[tableid][pkrSlotRotations] -= 6;
		}

		new playerid = PokerFindPlayerOrder(tableid, PokerTable[tableid][pkrSlotRotations]);

		if(playerid != -1) {
			nextactiveid = playerid;
			PokerTable[tableid][pkrActivePlayerID] = playerid;
			PokerTable[tableid][pkrActivePlayerSlot] = PokerTable[tableid][pkrSlotRotations];
			PokerTable[tableid][pkrRotations]++;
		} else {
			PokerTable[tableid][pkrRotations]++;
			PokerRotateActivePlayer(tableid);
		}
	}
	else
	{
		PokerTable[tableid][pkrSlotRotations]++;
		if(PokerTable[tableid][pkrSlotRotations] >= 6) {
			PokerTable[tableid][pkrSlotRotations] -= 6;
		}

		new playerid = PokerFindPlayerOrder(tableid, PokerTable[tableid][pkrSlotRotations]);

		if(playerid != -1) {
			nextactiveid = playerid;
			PokerTable[tableid][pkrActivePlayerID] = playerid;
			PokerTable[tableid][pkrActivePlayerSlot] = PokerTable[tableid][pkrSlotRotations];
			PokerTable[tableid][pkrRotations]++;
		} else {
			PokerTable[tableid][pkrRotations]++;
			PokerRotateActivePlayer(tableid);
		}
	}

	if(nextactiveid != -1) {
		if(GetPVarInt(nextactiveid, "pkrActiveHand")) {
			new currentBet = GetPVarInt(nextactiveid, "pkrCurrentBet");
			new activeBet = PokerTable[tableid][pkrActiveBet];

			new apSoundID[] = {5809, 5810};
			new randomApSoundID = random(sizeof(apSoundID));
			PlayerPlaySound(nextactiveid, apSoundID[randomApSoundID], 0.0, 0.0, 0.0);

			if(GetPVarInt(nextactiveid, "pkrChips") < 1) {
				PokerOptions(nextactiveid, 3);
			} else if(currentBet >= activeBet) {
				PokerOptions(nextactiveid, 1);
			} else if (currentBet < activeBet) {
				PokerOptions(nextactiveid, 2);
			} else {
				PokerOptions(nextactiveid, 0);
			}

			SetPVarInt(nextactiveid, "pkrTime", 60);
			SetPVarInt(nextactiveid, "pkrActivePlayer", 1);
		}
	}
	return 1;
}

InitPokerTables()
{
	for(new i = 0; i < MAX_POKERTABLES; i++) {
		PokerTable[i][pkrActive] = 0;
		PokerTable[i][pkrPlaced] = 0;
		PokerTable[i][pkrObjectID] = 0;

		for(new c = 0; c < MAX_POKERTABLEMISCOBJS; c++) {
			PokerTable[i][pkrMiscObjectID][c] = 0;
		}

		for(new s = 0; s < 6; s++) {
			PokerTable[i][pkrSlot][s] = -1;
		}

		PokerTable[i][pkrX] = 0.0;
		PokerTable[i][pkrY] = 0.0;
		PokerTable[i][pkrZ] = 0.0;
		PokerTable[i][pkrRX] = 0.0;
		PokerTable[i][pkrRY] = 0.0;
		PokerTable[i][pkrRZ] = 0.0;
		PokerTable[i][pkrVW] = 0;
		PokerTable[i][pkrInt] = 0;
		PokerTable[i][pkrPlayers] = 0;
		PokerTable[i][pkrLimit] = 6;
		PokerTable[i][pkrBuyInMax] = 1000;
		PokerTable[i][pkrBuyInMin] = 500;
		PokerTable[i][pkrBlind] = 100;
		PokerTable[i][pkrPos] = 0;
		PokerTable[i][pkrRound] = 0;
		PokerTable[i][pkrStage] = 0;
		PokerTable[i][pkrActiveBet] = 0;
		PokerTable[i][pkrSetDelay] = 15;
		PokerTable[i][pkrActivePlayerID] = -1;
		PokerTable[i][pkrActivePlayerSlot] = -1;
		PokerTable[i][pkrRotations] = 0;
		PokerTable[i][pkrSlotRotations] = 0;
		PokerTable[i][pkrWinnerID] = -1;
		PokerTable[i][pkrWinners] = 0;
	}
}

ResetPokerRound(tableid)
{
	PokerTable[tableid][pkrRound] = 0;
	PokerTable[tableid][pkrStage] = 0;
	PokerTable[tableid][pkrActiveBet] = 0;
	PokerTable[tableid][pkrActive] = 2;
	PokerTable[tableid][pkrDelay] = PokerTable[tableid][pkrSetDelay];
	PokerTable[tableid][pkrPot] = 0;
	PokerTable[tableid][pkrRotations] = 0;
	PokerTable[tableid][pkrSlotRotations] = 0;
	PokerTable[tableid][pkrWinnerID] = -1;
	PokerTable[tableid][pkrWinners] = 0;

	// Reset Player Variables
	for(new i = 0; i < 6; i++) {
		new playerid = PokerTable[tableid][pkrSlot][i];

		if(playerid != -1) {
			DeletePVar(playerid, "pkrWinner");
			DeletePVar(playerid, "pkrRoomBigBlind");
			DeletePVar(playerid, "pkrRoomSmallBlind");
			DeletePVar(playerid, "pkrRoomDealer");
			DeletePVar(playerid, "pkrCard1");
			DeletePVar(playerid, "pkrCard2");
			DeletePVar(playerid, "pkrActivePlayer");
			DeletePVar(playerid, "pkrTime");

			if(GetPVarInt(playerid, "pkrActiveHand")) {
				PokerTable[tableid][pkrActiveHands]--;

				// Animation
				ApplyAnimation(playerid, "CASINO", "cards_out", 4.1, 0, 1, 1, 1, 1, 1);
			}

			DeletePVar(playerid, "pkrActiveHand");
			DeletePVar(playerid, "pkrCurrentBet");
			DeletePVar(playerid, "pkrResultString");
			DeletePVar(playerid, "pkrHide");
		}
	}

	return 1;
}

ResetPokerTable(tableid)
{
	new szString[32];
	format(szString, sizeof(szString), "");
	strmid(PokerTable[tableid][pkrPass], szString, 0, strlen(szString), 64);

	PokerTable[tableid][pkrActive] = 0;
	PokerTable[tableid][pkrLimit] = 6;
	PokerTable[tableid][pkrBuyInMax] = 1000;
	PokerTable[tableid][pkrBuyInMin] = 500;
	PokerTable[tableid][pkrBlind] = 100;
	PokerTable[tableid][pkrPos] = 0;
	PokerTable[tableid][pkrRound] = 0;
	PokerTable[tableid][pkrStage] = 0;
	PokerTable[tableid][pkrActiveBet] = 0;
	PokerTable[tableid][pkrDelay] = 0;
	PokerTable[tableid][pkrPot] = 0;
	PokerTable[tableid][pkrSetDelay] = 15;
	PokerTable[tableid][pkrRotations] = 0;
	PokerTable[tableid][pkrSlotRotations] = 0;
	PokerTable[tableid][pkrWinnerID] = -1;
	PokerTable[tableid][pkrWinners] = 0;
}

ShowPokerGUI(playerid, guitype)
{
	switch(guitype)
	{
		case GUI_POKER_TABLE:
		{
			SetPVarInt(playerid, "pkrTableGUI", 1);
			for(new i = 0; i < MAX_PLAYERPOKERUI; i++) {
				PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][i]);
			}
		}
	}
}

DestroyPokerGUI(playerid)
{
	for(new i = 0; i < MAX_PLAYERPOKERUI; i++) {
		PlayerTextDrawDestroy(playerid, PlayerPokerUI[playerid][i]);
	}
}

PlacePokerTable(tableid, skipmisc, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, virtualworld, interior)
{
	PokerTable[tableid][pkrPlaced] = 1;
	PokerTable[tableid][pkrX] = x;
	PokerTable[tableid][pkrY] = y;
	PokerTable[tableid][pkrZ] = z;
	PokerTable[tableid][pkrRX] = rx;
	PokerTable[tableid][pkrRY] = ry;
	PokerTable[tableid][pkrRZ] = rz;
	PokerTable[tableid][pkrVW] = virtualworld;
	PokerTable[tableid][pkrInt] = interior;

	// Create Table
	PokerTable[tableid][pkrObjectID] = CreateDynamicObject(OBJ_POKER_TABLE, x, y, z, rx, ry, rz, virtualworld, interior, -1, DRAWDISTANCE_POKER_TABLE);

	if(skipmisc != 0) {
	}

	// Create 3D Text Label
	new szString[64];
	format(szString, sizeof(szString), "Poker Table %d", tableid);
	PokerTable[tableid][pkrText3DID] = Create3DTextLabel(szString, COLOR_YELLOW, x, y, z+1.3, DRAWDISTANCE_POKER_MISC, virtualworld, 0);

	return tableid;
}

DestroyPokerTable(tableid)
{
	if(PokerTable[tableid][pkrPlaced] == 1) {
		//foreach(new i : Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPVarInt(i, "pkrTableID")-1 == tableid)
				{
					LeavePokerTable(i);
					SendClientMessageEx(i, COLOR_YELLOW, "The poker table owner has destroyed the table.");
				}
			}	
		}

		// Delete Table
		if(IsValidDynamicObject(PokerTable[tableid][pkrObjectID])) DestroyDynamicObject(PokerTable[tableid][pkrObjectID]);

		// Delete 3D Text Label
		Delete3DTextLabel(PokerTable[tableid][pkrText3DID]);

		// Delete Misc Obj
		for(new c = 0; c < MAX_POKERTABLEMISCOBJS; c++) {
			if(IsValidObject(PokerTable[tableid][pkrMiscObjectID][c])) DestroyObject(PokerTable[tableid][pkrMiscObjectID][c]);
		}
	}
	PokerTable[tableid][pkrX] = 0.0;
	PokerTable[tableid][pkrY] = 0.0;
	PokerTable[tableid][pkrZ] = 0.0;
	PokerTable[tableid][pkrRX] = 0.0;
	PokerTable[tableid][pkrRY] = 0.0;
	PokerTable[tableid][pkrRZ] = 0.0;
	PokerTable[tableid][pkrVW] = 0;
	PokerTable[tableid][pkrInt] = 0;
	PokerTable[tableid][pkrPlayers] = 0;
	PokerTable[tableid][pkrLimit] = 6;
	PokerTable[tableid][pkrPlaced] = 0;
	return tableid;
}

// Note: 0, 1 should be the hand, the rest are community cards.
AnaylzePokerHand(playerid, Hand[])
{
	new pokerArray[7];
	for(new i = 0; i < sizeof(pokerArray); i++) {
		pokerArray[i] = Hand[i];
	}

	new suitArray[4][13];
	new tmp = 0;
	new pairs = 0;
	new bool:isRoyalFlush = false;
	new bool:isFlush = false;
	new bool:isStraight = false;
	new bool:isFour = false;
	new bool:isThree = false;
	new bool:isTwoPair = false;
	new bool:isPair = false;

	// Convert Hand[] (AKA pokerArray) to suitArray[]
	for(new i = 0; i < sizeof(pokerArray); i++) {
		if(pokerArray[i] <= 12) { // Clubs (0 - 12)
			suitArray[0][pokerArray[i]] = 1;
		}
		if(pokerArray[i] <= 25 && pokerArray[i] >= 13) { // Diamonds (13 - 25)
			suitArray[1][pokerArray[i]-13] = 1;
		}
		if(pokerArray[i] <= 38 && pokerArray[i] >= 26) { // Hearts (26 - 38)
			suitArray[2][pokerArray[i]-26] = 1;
		}
		if(pokerArray[i] <= 51 && pokerArray[i] >= 39) { // Spades (39 - 51)
			suitArray[3][pokerArray[i]-39] = 1;
		}
	}

	// Royal Check
	for(new i = 0; i < 4; i++) {
		if(suitArray[i][0] == 1) {
			if(suitArray[i][9] == 1) {
				if(suitArray[i][10] == 1) {
					if(suitArray[i][11] == 1) {
						if(suitArray[i][12] == 1) {
							isRoyalFlush = true;
							break;
						}
					}
				}
			}
		}
	}
	tmp = 0;

	// Flush Check
	for(new i = 0; i < 4; i++) {
		for(new j = 0; j < 13; j++) {
			if(suitArray[i][j] == 1) {
				tmp++;
			}
		}

		if(tmp > 4) {
			isFlush = true;
			break;
		} else {
			tmp = 0;
		}
	}
	tmp = 0;

	// Four of a Kind Check
	// Three of a Kind Check
	for(new i = 0; i < 4; i++) {
		for(new j = 0; j < 13; j++) {
			if(suitArray[i][j] == 1) {
				for(new c = 0; c < 4; c++) {
					if(suitArray[c][j] == 1) {
						tmp++;
					}
				}
				if(tmp == 4) {
					isFour = true;
				}
				else if(tmp >= 3) {
					isThree = true;
				} else {
					tmp = 0;
				}
			}
		}
	}
	tmp = 0;

	// Two Pair & Pair Check
	for(new j = 0; j < 13; j++) {
		tmp = 0;
		for(new i = 0; i < 4; i++) {
			if(suitArray[i][j] == 1) {
				tmp++;

				if(tmp >= 2) {
					isPair = true;
					pairs++;

					if(pairs >= 2) {
						isTwoPair = true;
					}
				}
			}
		}
	}
	tmp = 0;

	// Straight Check
	for(new j = 0; j < 13; j++) {
		for(new i = 0; i < 4; i++) {
			if(suitArray[i][j] == 1) {
				for(new s = 0; s < 5; s++) {
					for(new c = 0; c < 4; c++) {
						if(j+s == 13)
						{
							if(suitArray[c][0] == 1) {
								tmp++;
								break;
							}
						}
						else if (j+s >= 14)
						{
							break;
						}
						else
						{
							if(suitArray[c][j+s] == 1) {
								tmp++;
								break;
							}
						}
					}
				}
			}
			if(tmp >= 5) {
				isStraight = true;
			}
			tmp = 0;
		}
	}
	tmp = 0;

	// Convert Hand to Singles

	// Card 1
	if(pokerArray[0] > 12 && pokerArray[0] < 26) pokerArray[0] -= 13;
	if(pokerArray[0] > 25 && pokerArray[0] < 39) pokerArray[0] -= 26;
	if(pokerArray[0] > 38 && pokerArray[0] < 52) pokerArray[0] -= 39;
	if(pokerArray[0] == 0) pokerArray[0] = 13; // Convert Aces to worth 13.

	// Card 2
	if(pokerArray[1] > 12 && pokerArray[1] < 26) pokerArray[1] -= 13;
	if(pokerArray[1] > 25 && pokerArray[1] < 39) pokerArray[1] -= 26;
	if(pokerArray[1] > 38 && pokerArray[1] < 52) pokerArray[1] -= 39;
	if(pokerArray[1] == 0) pokerArray[1] = 13; // Convert Aces to worth 13.

	// 10) POKER_RESULT_ROYAL_FLUSH - A, K, Q, J, 10 (SAME SUIT) * ROYAL + FLUSH *
	if(isRoyalFlush) {
		SetPVarString(playerid, "pkrResultString", "Royal Flush");
		return 1000 + pokerArray[0] + pokerArray[1];
	}

	// 9) POKER_RESULT_STRAIGHT_FLUSH - Any five card squence. (SAME SUIT) * STRAIGHT + FLUSH *
	if(isStraight && isFlush) {
		SetPVarString(playerid, "pkrResultString", "Straight Flush");
		return 900 + pokerArray[0] + pokerArray[1];
	}

	// 8) POKER_RESULT_FOUR_KIND - All four cards of the same rank. * FOUR KIND *
	if(isFour) {
		SetPVarString(playerid, "pkrResultString", "Four of a Kind");
		return 800 + pokerArray[0] + pokerArray[1];
	}

	// 7) POKER_RESULT_FULL_HOUSE - Three of a kind combined with a pair. * THREE KIND + PAIR *
	if(isThree && isTwoPair) {
		SetPVarString(playerid, "pkrResultString", "Full House");
		return 700 + pokerArray[0] + pokerArray[1];
	}

	// 6) POKER_RESULT_FLUSH - Any five cards of the same suit, no sequence. * FLUSH *
	if(isFlush) {
		SetPVarString(playerid, "pkrResultString", "Flush");
		return 600 + pokerArray[0] + pokerArray[1];
	}

	// 5) POKER_RESULT_STRAIGHT - Five cards in sequence, but not in the same suit. * STRAIGHT *
	if(isStraight) {
		SetPVarString(playerid, "pkrResultString", "Straight");
		return 500 + pokerArray[0] + pokerArray[1];
	}

	// 4) POKER_RESULT_THREE_KIND - Three cards of the same rank. * THREE KIND *
	if(isThree) {
		SetPVarString(playerid, "pkrResultString", "Three of a Kind");
		return 400 + pokerArray[0] + pokerArray[1];
	}

	// 3) POKER_RESULT_TWO_PAIR - Two seperate pair. * TWO PAIR *
	if(isTwoPair) {
		SetPVarString(playerid, "pkrResultString", "Two Pair");
		return 300 + pokerArray[0] + pokerArray[1];
	}

	// 2) POKER_RESULT_PAIR - Two cards of the same rank. * PAIR *
	if(isPair) {
		SetPVarString(playerid, "pkrResultString", "Pair");
		return 200 + pokerArray[0] + pokerArray[1];
	}

	// 1) POKER_RESULT_HIGH_CARD - Highest card.
	SetPVarString(playerid, "pkrResultString", "High Card");
	return pokerArray[0] + pokerArray[1];
}

CMD:jointable(playerid, params[])
{
	if(PlayerInfo[playerid][pConnectHours] < 5) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You need 5 playing hours to join a poker table.");
	    return 1;
	}
	if(GetPVarType(playerid, "pkrTableID") == 0) {
		for(new t = 0; t < MAX_POKERTABLES; t++) {
			if(IsPlayerInRangeOfPoint(playerid, 5.0, PokerTable[t][pkrX], PokerTable[t][pkrY], PokerTable[t][pkrZ])) {
				if(PokerTable[t][pkrPass][0] != EOS) {
					if(!strcmp(params, PokerTable[t][pkrPass], false, 32)) {
						JoinPokerTable(playerid, t);
					} else {
						return SendClientMessage(playerid, COLOR_WHITE, "Usage: /jointable (password)");
					}
				} else {
					JoinPokerTable(playerid, t);
				}
				return 1;
			}
		}
	} else {
		SendClientMessage(playerid, COLOR_WHITE, "You are already at a Poker Table! You must /leavetable before you join another one!");
	}
	return 1;
}

CMD:leavetable(playerid, params[])
{
	if(GetPVarType(playerid, "pkrTableID")) {
		LeavePokerTable(playerid);
	}
	return 1;
}

CMD:placetable(playerid, params[])
{
	if(PlayerInfo[playerid][pTable] == 1 || PlayerInfo[playerid][pAdmin] >= 4)
	{
	    if(GetPVarInt(playerid, "IsInArena") >= 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't do this while being in an arena!");
		if(WatchingTV[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can not do this while watching TV!");
		if(GetPVarInt(playerid, "Injured") == 1 || PlayerInfo[playerid][pHospital] > 0 || IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You can't do this right now.");
		if(PlayerInfo[playerid][pVW] == 0 || PlayerInfo[playerid][pInt] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can only place poker tables inside interiors.");
		if(GetPVarType(playerid, "pTable")) return SendClientMessageEx(playerid, COLOR_GREY, "You already have a poker table out, use /destroytable.");

		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPVarType(i, "pTable"))
				{
					if(IsPlayerInRangeOfPoint(playerid, 7.0, PokerTable[GetPVarInt(i, "pTable")][pkrX], PokerTable[GetPVarInt(i, "pTable")][pkrY], PokerTable[GetPVarInt(i, "pTable")][pkrZ]))
					{
						SendClientMessage(playerid, COLOR_GREY, "You are in range of another poker table, you can't place one here!");
						return 1;
					}
				}
			}	
		}


		new string[128];
		format(string, sizeof(string), "%s has placed a poker table!", GetPlayerNameEx(playerid));
	    ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);

	    new Float:x, Float:y, Float:z, Float:a;
	    GetPlayerPos(playerid, x, y, z);
	    GetPlayerFacingAngle(playerid, a);
	    ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
	    x += (2 * floatsin(-a, degrees));
    	y += (2 * floatcos(-a, degrees));
		z -= 0.5;

        for(new i = 0; i < MAX_POKERTABLES; i++) {
		    if(PokerTable[i][pkrPlaced] == 0) {
				PlacePokerTable(i, 1, x, y, z, 0, 0, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				SetPVarInt(playerid, "pTable", i);
				break;
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a poker table! Buy from one shop.ng-gaming.net");
	}
	return 1;
}

CMD:destroytable(playerid, params[])
{
	if(GetPVarType(playerid, "pTable"))
	{
	    if(PokerTable[GetPVarType(playerid, "pTable")][pkrPlayers] != 0)
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't destroy your table while a game is in progress.");

	    DestroyPokerTable(GetPVarInt(playerid, "pTable"));
		DeletePVar(playerid, "pTable");
		SendClientMessage(playerid, COLOR_GREY, "You've destroyed your poker table!");
	}
	return 1;
}

CMD:shoptable(playerid, params[])
{
	if (PlayerInfo[playerid][pShopTech] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " You are not allowed to use this command.");
		return 1;
	}

	new giveplayerid, invoice;
	if(sscanf(params, "ui", giveplayerid, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shoptable [player] [invoice #]");
	new string[128];

	if(PlayerInfo[giveplayerid][pTable] == 1)
	{
	    PlayerInfo[giveplayerid][pTable] = 0;
    	format(string, sizeof(string), "Your poker table has been taken by Shop Tech %s. ", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "[SHOPPOKERTABLE] %s has taken %s(%d) poker table - Invoice %d", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), invoice);
		SendClientMessageEx(playerid, COLOR_GRAD1, string);
		Log("logs/shoplog.log", string);
	}
	else
	{
		PlayerInfo[giveplayerid][pTable] = 1;
    	format(string, sizeof(string), "You have been given a poker table from Shop Tech %s. ", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "[SHOPPOKERTABLE] %s has given %s(%d) a poker table - Invoice %d", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), invoice);
		SendClientMessageEx(playerid, COLOR_GRAD1, string);
		Log("logs/shoplog.log", string);
	}
	return 1;
}