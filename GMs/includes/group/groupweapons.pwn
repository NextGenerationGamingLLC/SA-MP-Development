/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Group Weapons Handler (Locker)

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

stock ShowGroupWeapons(playerid, group) {
	if(!ValidGroup(group)) return 1;
	Dialog_Show(playerid, wep_option, DIALOG_STYLE_LIST, "Weapon Safe", "Withdraw Weapon\nDeposit Weapon", "Select", "Go Back");
	return 1;
}

stock WeaponMenu(playerid, group, crate = 0) {
	szMiscArray[0] = 0;
	if(!ValidGroup(group)) return 1;

	format(szMiscArray, sizeof(szMiscArray), "Weapon\tQuantity\n");
	for(new w = 0; w < 18; w++) {
		format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s\t%s\n", szMiscArray, w+1, Weapon_ReturnName(w+1), number_format(LockerWep[group][lwWep][w]));
	}
	for(new w = 21; w < 46; w++) {
		format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s\t%s\n", szMiscArray, w+1, Weapon_ReturnName(w+1), number_format(LockerWep[group][lwWep][w]));
	}
	if(crate) {
		Dialog_Show(playerid, crate_withdraw, DIALOG_STYLE_TABLIST_HEADERS, "Transfer to Crate", szMiscArray, "Select", "Go Back");
	} else {
		Dialog_Show(playerid, weapon_withdraw, DIALOG_STYLE_TABLIST_HEADERS, "Safe Weapon Withdraw", szMiscArray, "Select", "Go Back");
	}
	return 1;
}

stock DepositMenu(playerid, group) {
	szMiscArray[0] = 0;
	if(!ValidGroup(group)) return 1;
	for(new g = 0; g < 12; g++)	{
		if(PlayerInfo[playerid][pGuns][g] != 0 && PlayerInfo[playerid][pAGuns][g] == 0) {
			format(szMiscArray, sizeof(szMiscArray), "%s\n(%i) %s", szMiscArray, PlayerInfo[playerid][pGuns][g], Weapon_ReturnName(PlayerInfo[playerid][pGuns][g]));
		}
	}
	if(isnull(szMiscArray)) format(szMiscArray, sizeof(szMiscArray), "You have no weapons to deposit!");
	return Dialog_Show(playerid, weapon_deposit, DIALOG_STYLE_LIST, "Safe Weapon Deposit", szMiscArray, "Deposit", "Go Back");
}

Dialog:wep_option(playerid, response, listitem, inputtext[]) {
	if(response) {
		switch(listitem) {
			case 0: {
				WeaponMenu(playerid, PlayerInfo[playerid][pMember]);
			}
			case 1: {
				DepositMenu(playerid, PlayerInfo[playerid][pMember]);
			}
		}
	} else {
		return cmd_locker(playerid, "");
	}
	return 1;
}

Dialog:weapon_withdraw(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
		szMiscArray[0] = 0;
		new stpos = strfind(inputtext, "(");
	    new fpos = strfind(inputtext, ")");
	    new gid[6], id;
	    strmid(gid, inputtext, stpos+1, fpos);
	    id = strval(gid);
	    if(LockerWep[PlayerInfo[playerid][pMember]][lwWep][id-1] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "There are no %s's in the locker to take!", Weapon_ReturnName(id)), WeaponMenu(playerid, PlayerInfo[playerid][pMember]);
		
		if(PlayerInfo[playerid][pGuns][GetWeaponSlot(id)] != id) {
			--LockerWep[PlayerInfo[playerid][pMember]][lwWep][id-1];
			GivePlayerValidWeapon(playerid, id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You withdraw a %s from the locker.", Weapon_ReturnName(id));
			SaveWeapons(PlayerInfo[playerid][pMember]);
			format(szMiscArray, sizeof(szMiscArray), "%s has withdrawn a %s from the weapon locker", GetPlayerNameEx(playerid), Weapon_ReturnName(id));
			GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
			return WeaponMenu(playerid, PlayerInfo[playerid][pMember]);
		} else {
			SendClientMessageEx(playerid, COLOR_RED, "You already have a %s on you!", Weapon_ReturnName(id));
			return WeaponMenu(playerid, PlayerInfo[playerid][pMember]);
		}
	} else {
		ShowGroupWeapons(playerid, PlayerInfo[playerid][pMember]);
	}
	return 1;
}

Dialog:weapon_deposit(playerid, response, listitem, inputtext[]) {
	if(response) {
		szMiscArray[0] = 0;
		if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
		new stpos = strfind(inputtext, "(");
	    new fpos = strfind(inputtext, ")");
	    new gid[6], id;
	    strmid(gid, inputtext, stpos+1, fpos);
	    id = strval(gid);

	    if(PlayerInfo[playerid][pGuns][GetWeaponSlot(id)] == 0) return SendClientMessageEx(playerid, COLOR_RED, "The weapon you tried to deposit doesn't exist!"), ShowGroupWeapons(playerid, PlayerInfo[playerid][pMember]);
	    ++LockerWep[PlayerInfo[playerid][pMember]][lwWep][id-1];
		PlayerInfo[playerid][pGuns][GetWeaponSlot(id)] = 0;
		SetPlayerWeaponsEx(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have deposited a %s into the locker.", Weapon_ReturnName(id));
		format(szMiscArray, sizeof(szMiscArray), "%s has deposited a %s into the locker.", GetPlayerNameEx(playerid), Weapon_ReturnName(id));
		GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
		DepositMenu(playerid, PlayerInfo[playerid][pMember]);
	} else {
		ShowGroupWeapons(playerid, PlayerInfo[playerid][pMember]);
	}
	return 1;
}

stock SaveWeapons(i) {
	new query[2048], wep[12];
	format(query, 2048, "UPDATE `gweaponsnew` SET ");
	for(new w = 0; w < 46; w++) {
		format(wep, sizeof(wep), "%d", w+1);
		SaveInteger(query, "gweaponsnew", i+1, wep, LockerWep[i][lwWep][w]);
	}
	SQLUpdateFinish(query, "gweaponsnew", i+1);
	return 1;
}

stock CrateTransferOption(playerid, group) {
	if(!ValidGroup(group)) return 1;
	if(PlayerInfo[playerid][pLeader] == group) {
		Dialog_Show(playerid, crate_tran_option, DIALOG_STYLE_LIST, "Crate Transfer", "Deploy Crate Box\nTransfer to Crate\nDeposit Crate\nRecall Crate", "Select", "Go Back");
	} else {
		Dialog_Show(playerid, crate_tran_option, DIALOG_STYLE_LIST, "Crate Transfer", "Deposit Crate", "Select", "Go Back");
	}
	return 1;
}

Dialog:crate_tran_option(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
		szMiscArray[0] = 0;
		new gbox;
		GetGroupCrate(playerid, gbox);
		if(PlayerInfo[playerid][pLeader] == PlayerInfo[playerid][pMember]) {
			switch(listitem) {
				case 0: {
					if(gbox == -1) {
						szMiscArray = "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n";
						strcat(szMiscArray, "{F69500}WARNING: Are you sure you want to deply a transfer crate?{FFFFFF}\n\n");
						strcat(szMiscArray, "Deploying a transfer crate will allow you to sell weapons to another group\n\n");
						strcat(szMiscArray, "You must be careful with the crate as anyone is able to steal it from you and dump the contents into their locker - Only leaders can deploy a transfer crate.\n");
						strcat(szMiscArray, "Anyone within the group has the ability to deposit any crate they come across or mange to steal from another group into your own group locker.\n\n");
						strcat(szMiscArray, "There is no time limit for when the crate will despawn, you must wait 24 hours before you can 'recall' it so be careful with the crate.\n");
						strcat(szMiscArray, "The only time the crate will despawned if it's been deposited into any locker or you recall it.\n\n");
						strcat(szMiscArray, "Note: You can recall the crate after 24 hours if you've lost it but all contents of the crate will be lost!\n\n");
						strcat(szMiscArray, "{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
						Dialog_Show(playerid, deploy_transfer_crate, DIALOG_STYLE_MSGBOX, "Deploy Transfer Crate?", szMiscArray, "Deploy", "Go Back");
					} else {
						SendClientMessageEx(playerid, COLOR_YELLOW, "There is already a transfer crate in use find it or wait until you can recall it.");
						return CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
					}
				}
				case 1: {
					if(CarryCrate[playerid] == -1) return SendClientMessageEx(playerid, COLOR_RED, "Your not carrying a group crate!"), CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
					if(CarryCrate[playerid] != gbox) return SendClientMessageEx(playerid, COLOR_RED, "You can't transfer items to a crate not owned by your group!"), CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
					return WeaponMenu(playerid, PlayerInfo[playerid][pMember], 1);
				}
				case 2: { // Deposit Crate
					if(CarryCrate[playerid] == -1) return SendClientMessageEx(playerid, COLOR_RED, "You need to be holding a crate to deposit!"), CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
					return DisplayCrateContents(playerid, CarryCrate[playerid]);
				}
				case 3: {
					if(gbox == -1) return SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: There was no response from the signal. (( No active crate )), Sender: MOLE (555)");
					if(CrateBox[gbox][cbLifespan] > gettime()) return SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: Signal will be active after %s, Sender: MOLE (555)", date(CrateBox[gbox][cbLifespan], 1));
					strcat(szMiscArray, "{F69500}WARNING: Are you sure you want to recall your group crate?{FFFFFF}\n\n");
					strcat(szMiscArray, "By recalling the crate it will be destroyed along with all of it's contents!\n");
					Dialog_Show(playerid, recall_box_check, DIALOG_STYLE_MSGBOX, "Recall Crate?", szMiscArray, "Recall", "Cancel");
				}
			}
		} else {
			switch(listitem) {
				case 0: {
					if(CarryCrate[playerid] == -1) return SendClientMessageEx(playerid, COLOR_RED, "You need to be holding a crate to deposit!"), CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
					return DisplayCrateContents(playerid, CarryCrate[playerid]);
				}
			}
		}
	} else {
		return cmd_locker(playerid, "");
	}
	return 1;
}

Dialog:recall_box_check(playerid, response, listitem, inputtext[]) {
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	if(response) {
		new gbox;
		GetGroupCrate(playerid, gbox);
		if(gbox == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Appears your group crate has already been recalled."), CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
		DestroyCrate(gbox);
		SendClientMessageEx(playerid, COLOR_YELLOW, "You have recalled your group crate, all contents were removed.");
		CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
	} else {
		CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
	}
	return 1;
}

Dialog:deploy_transfer_crate(playerid, response, listitem, inputtext[]) {
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	if(response) {
		szMiscArray[0] = 0;
		new Float: pcbPos[3];
		GetPlayerPos(playerid, pcbPos[0], pcbPos[1], pcbPos[2]);
		GetXYInFrontOfPlayer(playerid, pcbPos[0], pcbPos[1], 1);
		for(new c = 0; c < MAX_CRATES; c++) {
			if(CrateBox[c][cbFacility] == -1 && CrateBox[c][cbGroup] == -1) {
				CrateBox[c][cbGroup] = PlayerInfo[playerid][pMember];
				CrateBox[c][cbPos][0] = pcbPos[0];
				CrateBox[c][cbPos][1] = pcbPos[1];
				CrateBox[c][cbPos][2] = pcbPos[2]-1.0;
				CrateBox[c][cbInt] = GetPlayerInterior(playerid);
				CrateBox[c][cbVw] = GetPlayerVirtualWorld(playerid);
				CrateBox[c][cbPlacedBy] = GetPlayerNameEx(playerid);
				if(PlayerHoldingObject[playerid][8] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 8))
					RemovePlayerAttachedObject(playerid, 8), PlayerHoldingObject[playerid][8] = 0;
				SetPlayerAttachedObject(playerid, 8, 964, 1, -0.071, 0.536, -0.026999, -2.19999, 87.1999, 0.699999, 0.479999, 0.538999, 0.419999);
				if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_CARRY) SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				CarryCrate[playerid] = c;
				BeingMoved[c] = playerid;
				CrateBox[c][cbLifespan] = gettime()+86400; // 24 hours.
				CrateBox[c][cbActive] = 1;
				SaveCrate(c);
				UpdateCrateBox(c);
				break;
			}
		}
		SendClientMessageEx(playerid, COLOR_YELLOW, "You take out a transfer crate from the locker!");
		Streamer_Update(playerid);
		CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
	} else {
		CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
	}
	return 1;
}

Dialog:crate_withdraw(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(response) {
		if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
		new stpos = strfind(inputtext, "(");
	    new fpos = strfind(inputtext, ")");
	    new gid[6], id;
	    strmid(gid, inputtext, stpos+1, fpos);
	    id = strval(gid);
	    if(LockerWep[PlayerInfo[playerid][pMember]][lwWep][id-1] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "There are no %s's in the locker to transfer!", Weapon_ReturnName(id)), WeaponMenu(playerid, PlayerInfo[playerid][pMember], 1);
	    if(!CanTransferToCrate(id)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't transfer that item to the crate!");
	    SetPVarInt(playerid, "GunCrateID", id);
	    format(szMiscArray, sizeof(szMiscArray), "Please enter the amount you would like to transfer to the crate.\n\nAmount in locker: %s (%s)", number_format(LockerWep[PlayerInfo[playerid][pMember]][lwWep][id-1]), Weapon_ReturnName(id));
	    Dialog_Show(playerid, crate_tran_amount, DIALOG_STYLE_INPUT, "How many to withdraw?", szMiscArray, "Submit", "Go Back");
	} else {
		CrateTransferOption(playerid, PlayerInfo[playerid][pMember]); 
	}
	return 1;
}

Dialog:crate_tran_amount(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(response) {
		new gbox, amount = floatround(strval(inputtext));
		if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
		GetGroupCrate(playerid, gbox);
		if(CarryCrate[playerid] != gbox) return SendClientMessageEx(playerid, COLOR_RED, "Your no longer holding the group crate.");
		if(amount < 1 || amount > LockerWep[PlayerInfo[playerid][pMember]][lwWep][GetPVarInt(playerid, "GunCrateID")-1]) {
	    	format(szMiscArray, sizeof(szMiscArray), "Please enter the amount you would like to transfer to the crate.\n\nAmount in locker: %s (%s)\n{FF0000}Error: You can't go below 0 or above %s", number_format(LockerWep[PlayerInfo[playerid][pMember]][lwWep][GetPVarInt(playerid, "GunCrateID")-1]), Weapon_ReturnName(GetPVarInt(playerid, "GunCrateID")), number_format(LockerWep[PlayerInfo[playerid][pMember]][lwWep][GetPVarInt(playerid, "GunCrateID")-1]));
	    	Dialog_Show(playerid, crate_tran_amount, DIALOG_STYLE_INPUT, "How many to transfer?", szMiscArray, "Submit", "Go Back");
	    	return 1;
	    }
		LockerWep[PlayerInfo[playerid][pMember]][lwWep][GetPVarInt(playerid, "GunCrateID")-1] -= amount;
		CrateBox[CarryCrate[playerid]][cbWep][GetPVarInt(playerid, "GunCrateID")-1] += amount;
		SendClientMessageEx(playerid, COLOR_WHITE, "You transferred %s %s(s) to the crate.", number_format(amount), Weapon_ReturnName(GetPVarInt(playerid, "GunCrateID")));
		SaveWeapons(PlayerInfo[playerid][pMember]);
		SaveCrate(CarryCrate[playerid]);
		WeaponMenu(playerid, PlayerInfo[playerid][pMember], 1);
	} else {
		DeletePVar(playerid, "GunCrateID");
		WeaponMenu(playerid, PlayerInfo[playerid][pMember], 1);
	}
	return 1;
}

stock DisplayCrateContents(playerid, boxid) {
	new title[54];
	szMiscArray[0] = 0;
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	format(title, sizeof(title), "Crate Contents (ID: %d)", boxid);
	format(szMiscArray, sizeof(szMiscArray), "Weapon\tQuantity\n");
	for(new w = 0; w < 46; w++) {
		if(CrateBox[boxid][cbWep][w] > 0) {
			format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Weapon_ReturnName(w+1), number_format(CrateBox[boxid][cbWep][w]));
		}
	}
	if(strlen(szMiscArray) == 16) return SendClientMessageEx(playerid, COLOR_YELLOW, "There are no weapons in this crate to deposit!"), CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
	Dialog_Show(playerid, crate_tran_deposit, DIALOG_STYLE_TABLIST_HEADERS, title, szMiscArray, "Deposit", "Cancel");
	return 1;
}

Dialog:crate_tran_deposit(playerid, response, listitem, inputtext[]) {
	new clog[128];
	szMiscArray[0] = 0;
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	if(response) {
		new box = CarryCrate[playerid];
		if(box == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're no longer carrying a crate to deposit!");
		if(CrateBox[box][cbGroup] == -1 && CrateFacility[CrateBox[box][cbFacility]][cfGroup] == PlayerInfo[playerid][pMember] && !CrateBox[box][cbPaid]) {
			format(szMiscArray, sizeof(szMiscArray), "{F69500}WARNING: You are required to purcahse this crate!{FFFFFF}\n\n");
			format(szMiscArray, sizeof(szMiscArray), "%sThis crate was manufactured at your facility (%s) but it hasn't been paid for.\n\n", szMiscArray, CrateFacility[CrateBox[box][cbFacility]][cfName]);
			format(szMiscArray, sizeof(szMiscArray), "%sThis crate will cost your group {F69500}$%s{FFFFFF} to deposit into your locker would like to purcahse this crate?", szMiscArray, number_format(CrateFacility[CrateBox[box][cbFacility]][cfProdCost]));
			Dialog_Show(playerid, purcahse_own_crate, DIALOG_STYLE_MSGBOX, "Purcahse Crate?", szMiscArray, "Confirm", "Cancel");
		} else {
			format(clog, sizeof(clog), "%s has deposited a crate into the locker.", GetPlayerNameEx(playerid));
			CrateLog(PlayerInfo[playerid][pMember], clog);
			for(new w = 0; w < 46; w++) {
				if(CrateBox[box][cbWep][w] > 0) {
					LockerWep[PlayerInfo[playerid][pMember]][lwWep][w] += CrateBox[box][cbWep][w]; // Deposit
				}
			}
			DestroyCrate(box);
			SaveWeapons(PlayerInfo[playerid][pMember]);
			format(szMiscArray, sizeof(szMiscArray), "* %s has unloaded the contents of the crate into the locker.", GetPlayerNameEx(playerid));
			ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
	} else {
		CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
	}
	return 1;
}

Dialog:purcahse_own_crate(playerid, response, listitem, inputtext[]) {
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	if(response) {
		szMiscArray[0] = 0;
		new box = CarryCrate[playerid], clog[128];
		if(box == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're no longer carrying a crate to deposit!");
		if(GetGroupBudget(PlayerInfo[playerid][pMember]) < CrateFacility[CrateBox[box][cbFacility]][cfProdCost]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your group doesn't have $%s to purcahse this crate!", number_format(CrateFacility[CrateBox[box][cbFacility]][cfProdCost]));
		SetGroupBudget(PlayerInfo[playerid][pMember], -CrateFacility[CrateBox[box][cbFacility]][cfProdCost]);
		if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2) {
			TRTax += CrateFacility[CrateBox[box][cbFacility]][cfProdCost];
			format(szMiscArray, sizeof(szMiscArray), "%s has purchased a crate from their own facility adding $%s", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName], number_format(CrateFacility[CrateBox[box][cbFacility]][cfProdCost]));
			GroupPayLog(8, szMiscArray);
		} else {
			Tax += CrateFacility[CrateBox[box][cbFacility]][cfProdCost];
			format(szMiscArray, sizeof(szMiscArray), "%s has purchased a crate from their own facility adding $%s", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName], number_format(CrateFacility[CrateBox[box][cbFacility]][cfProdCost]));
			GroupPayLog(8, szMiscArray);
		}
		format(clog, sizeof(clog), "%s has deposited a crate into the locker.", GetPlayerNameEx(playerid));
		CrateLog(PlayerInfo[playerid][pMember], clog);
		for(new w = 0; w < 46; w++) {
			if(CrateBox[box][cbWep][w] > 0) {
				LockerWep[PlayerInfo[playerid][pMember]][lwWep][w] += CrateBox[box][cbWep][w]; // Deposit
			}
		}
		DestroyCrate(box);
		SaveWeapons(PlayerInfo[playerid][pMember]);
		format(szMiscArray, sizeof(szMiscArray), "* %s has unloaded the contents of the crate into the locker.", GetPlayerNameEx(playerid));
		ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	} else {
		CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
	}
	return 1;
}

stock CanTransferToCrate(WepID) {
	switch(WepID) {
		case 1: return 1; // Brass Knuckle
		case 2: return 1; // Golf Club
		case 3: return 1; // Nitestick
		case 5: return 1; // Bat
		case 6: return 1; // Shovel
		case 7: return 1; // Pool Cue
		case 8: return 1; // Katana Sword
		case 10: return 1; // Dildo (Purple)
		case 11: return 1; // Dildo
		case 12: return 1; // Vibrator
		case 13: return 1; // Silver Vibrator
		case 14: return 1; // Flower
		case 15: return 1; // Cane
		case 17: return 1; // Tear Gas
		case 22: return 1; // 9MM
		case 23: return 1; // Silenced 9mm
		case 24: return 1; // Desert Eagle
		case 25: return 1; // Pump Shotgun
		case 26: return 1; // Sawnoff Shotgun
		case 27: return 1; // Combat Shotgun
		case 28: return 1; // Micro SMG
		case 29: return 1; // MP5
		case 30: return 1; // AK-47
		case 31: return 1; // M4
		case 32: return 1; // Tec9
		case 33: return 1; // Rifle
		case 34: return 1; // Sniper Rifle
		case 46: return 1; // Parachute
		default: return 0;
	}
	return 0;
}