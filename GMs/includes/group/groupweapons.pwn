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

new LockerReq[MAX_PLAYERS][3];

hook OnPlayerConnect(playerid) {
	LockerReq[playerid][0] = 0; // Gun ID
	LockerReq[playerid][1] = -1; // Slot
	LockerReq[playerid][2] = gettime(); // Time of request
	return 1;
}

stock ShowGroupWeapons(playerid, group) {
	if(!ValidGroup(group)) return 1;
	new title[54];
	format(title, sizeof(title), "Weapon Safe - Mats: %s", number_format(arrGroupData[group][g_iLockerStock]));
	Dialog_Show(playerid, wep_option, DIALOG_STYLE_LIST, title, "Withdraw Weapon\nDeposit Weapon", "Select", "Go Back");
	return 1;
}

stock WeaponMenu(playerid, group, crate = 0) {
	szMiscArray[0] = 0;
	new title[54];
	if(!ValidGroup(group)) return 1;
	format(title, sizeof(title), "Safe Weapon Withdraw - Mats: %s", number_format(arrGroupData[group][g_iLockerStock]));
	format(szMiscArray, sizeof(szMiscArray), "Weapon\tCost\n");
	for(new i = 0; i != MAX_GROUP_WEAPONS; ++i) {
		if(arrGroupData[group][g_iLockerGuns][i]) {
			format(szMiscArray, sizeof szMiscArray, "%s\n%s\t%d", szMiscArray, Weapon_ReturnName(arrGroupData[group][g_iLockerGuns][i]), arrGroupData[group][g_iLockerCost][i]);
		}
		else strcat(szMiscArray, "\nEmpty\t--");
	}
	if(crate) {
		Dialog_Show(playerid, crate_withdraw, DIALOG_STYLE_TABLIST_HEADERS, "Transfer to Crate", szMiscArray, "Select", "Go Back");
	} else {
		Dialog_Show(playerid, weapon_withdraw, DIALOG_STYLE_TABLIST_HEADERS, title, szMiscArray, "Select", "Go Back");
	}
	return 1;
}

stock DepositMenu(playerid, group) {
	szMiscArray[0] = 0;
	if(!ValidGroup(group)) return 1;
	for(new g = 0; g < 12; g++)	{
		if(PlayerInfo[playerid][pGuns][g] != 0 && PlayerInfo[playerid][pAGuns][g] == 0) {
			if(CanDeposit(PlayerInfo[playerid][pGuns][g])) {
				format(szMiscArray, sizeof(szMiscArray), "%s\n(%i) %s", szMiscArray, PlayerInfo[playerid][pGuns][g], Weapon_ReturnName(PlayerInfo[playerid][pGuns][g]));
			}
		}
	}
	if(isnull(szMiscArray)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can only deposit: Spas12, AK-47, M4 & Sniper Rifle."), ShowGroupWeapons(playerid, PlayerInfo[playerid][pMember]);
	return Dialog_Show(playerid, weapon_deposit, DIALOG_STYLE_LIST, "Safe Weapon Deposit", szMiscArray, "Deposit", "Go Back");
}

Dialog:wep_option(playerid, response, listitem, inputtext[]) {
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	if(response) {
		switch(listitem) {
			case 0: {
				//if(PlayerInfo[playerid][pRank] < arrGroupData[PlayerInfo[playerid][pMember]][g_iWithdrawRank][3]) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not authorized to withdraw weapons from the locker!"), ShowGroupWeapons(playerid, PlayerInfo[playerid][pMember]);
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
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	new group = PlayerInfo[playerid][pMember];
	if(response) {
		szMiscArray[0] = 0;
		if(PlayerInfo[playerid][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your account is restricted!");
		if(PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't take weapons out as you're currently weapon restricted!");
		new GunID = arrGroupData[group][g_iLockerGuns][listitem];

		if(!GunID) return SendClientMessageEx(playerid, COLOR_WHITE, "Theres no weapon assigned to that slot!"), WeaponMenu(playerid, PlayerInfo[playerid][pMember]);
		if(PlayerInfo[playerid][pRank] < LockerWep[group][lwRank][listitem]) {
			if(LockerReq[playerid][2] > gettime()) return SendClientMessageEx(playerid, COLOR_YELLOW, "A request was already sent please wait %d seconds before trying again!", LockerReq[playerid][2]-gettime()), WeaponMenu(playerid, PlayerInfo[playerid][pMember]);
			SendClientMessageEx(playerid, COLOR_WHITE, "You are not authorized to withdraw a %s from the locker! (Requires rank %d+)", Weapon_ReturnName(GunID), LockerWep[group][lwRank][listitem]);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* A request was sent to the leaders who may grant you access. - Ensure you don't move away from the locker!");
			LockerReq[playerid][0] = GunID;
			LockerReq[playerid][1] = listitem;
			LockerReq[playerid][2] = gettime()+60;
			foreach(new p: Player) {
				if(PlayerInfo[p][pLeader] == PlayerInfo[playerid][pMember]) {
					SendClientMessageEx(p, COLOR_YELLOW, "* %s is requesting to withdraw a %s from the locker. (( /allow %d ))", GetPlayerNameEx(playerid), Weapon_ReturnName(GunID), playerid);
				}
			}
			return 1;
		}
		if(arrGroupData[group][g_iLockerStock] < arrGroupData[group][g_iLockerCost][listitem]) return SendClientMessageEx(playerid, COLOR_RED, "Your locker doesn't have the materials to craft a %s.", Weapon_ReturnName(GunID));
		if(PlayerInfo[playerid][pGuns][GetWeaponSlot(GunID)] != GunID) {
			arrGroupData[group][g_iLockerStock] -= arrGroupData[group][g_iLockerCost][listitem];
			GivePlayerValidWeapon(playerid, GunID);
			SendClientMessageEx(playerid, COLOR_WHITE, "You withdraw a %s from the locker.", Weapon_ReturnName(GunID));
			format(szMiscArray, sizeof(szMiscArray), "%s has withdrawn a %s from the weapon locker (Cost: %d)", GetPlayerNameEx(playerid), Weapon_ReturnName(GunID), arrGroupData[group][g_iLockerCost][listitem]);
			GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
			return WeaponMenu(playerid, PlayerInfo[playerid][pMember]);
		} else {
			SendClientMessageEx(playerid, COLOR_RED, "You already have a %s on you!", Weapon_ReturnName(GunID));
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
	    new gid[6], id, slot;
	    strmid(gid, inputtext, stpos+1, fpos);
	    id = strval(gid);

	    if(PlayerInfo[playerid][pGuns][GetWeaponSlot(id)] == 0) return SendClientMessageEx(playerid, COLOR_RED, "The weapon you tried to deposit doesn't exist!"), ShowGroupWeapons(playerid, PlayerInfo[playerid][pMember]);
	    if(!CanDeposit(PlayerInfo[playerid][pGuns][GetWeaponSlot(id)])) return SendClientMessageEx(playerid, COLOR_RED, "You can't deposit that weapon!"), ShowGroupWeapons(playerid, PlayerInfo[playerid][pMember]); 
	    IsInSlot(PlayerInfo[playerid][pMember], id, slot);
	    if(slot == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your locker doesn't have that weapon so it can't be stored!"), DepositMenu(playerid, PlayerInfo[playerid][pMember]);
		PlayerInfo[playerid][pGuns][GetWeaponSlot(id)] = 0;
		SetPlayerWeaponsEx(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have deposited a %s into the locker.", Weapon_ReturnName(id));
		format(szMiscArray, sizeof(szMiscArray), "%s has deposited a %s into the locker.", GetPlayerNameEx(playerid), Weapon_ReturnName(id));
		GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
		arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerStock] += arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerCost][slot];
		DepositMenu(playerid, PlayerInfo[playerid][pMember]);
	} else {
		ShowGroupWeapons(playerid, PlayerInfo[playerid][pMember]);
	}
	return 1;
}

stock SaveLockerRanks(i) {
	new query[2048], wep[12];
	format(query, 2048, "UPDATE `locker_restrict` SET ");
	for(new w = 0; w < 16; w++) {
		format(wep, sizeof(wep), "%d", w+1);
		SaveInteger(query, "locker_restrict", i+1, wep, LockerWep[i][lwRank][w]);
	}
	SQLUpdateFinish(query, "locker_restrict", i+1);
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
					return DepositCrateContents(playerid, CarryCrate[playerid]);
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
					return DepositCrateContents(playerid, CarryCrate[playerid]);
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
		if(CarryCrate[playerid] != -1) return SendClientMessageEx(playerid, COLOR_RED, "Your carrying a crate put it down before deploying a transfer crate!"), CrateTransferOption(playerid, PlayerInfo[playerid][pMember]);
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
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	szMiscArray[0] = 0;
	if(response) {
		new group = PlayerInfo[playerid][pMember];
		new GunID = arrGroupData[group][g_iLockerGuns][listitem];

		if(!GunID) return SendClientMessageEx(playerid, COLOR_WHITE, "Theres no weapon assigned to that slot!"), WeaponMenu(playerid, PlayerInfo[playerid][pMember], 1);
		if(PlayerInfo[playerid][pRank] < LockerWep[group][lwRank][listitem]) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not authorized to withdraw a %s from the locker! (Requires rank %d+)", Weapon_ReturnName(GunID), LockerWep[group][lwRank][listitem]), WeaponMenu(playerid, PlayerInfo[playerid][pMember], 1);
		if(!CanTransferToCrate(GunID)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't transfer that item to the crate!"), WeaponMenu(playerid, PlayerInfo[playerid][pMember], 1);
		if(arrGroupData[group][g_iLockerStock] < arrGroupData[group][g_iLockerCost][listitem]) return SendClientMessageEx(playerid, COLOR_RED, "Your locker doesn't have the materials to craft a %s.", Weapon_ReturnName(GunID)), WeaponMenu(playerid, PlayerInfo[playerid][pMember], 1);

		SetPVarInt(playerid, "GunCrateID", GunID);
		SetPVarInt(playerid, "GunCrateSlot", listitem);
		format(szMiscArray, sizeof(szMiscArray), "Please enter the amount you would like to transfer to the crate.\n\nLocker Stock: %s\nCost Per %s: %s", number_format(arrGroupData[group][g_iLockerStock]), Weapon_ReturnName(GunID), number_format(arrGroupData[group][g_iLockerCost][listitem]));
		Dialog_Show(playerid, crate_tran_amount, DIALOG_STYLE_INPUT, "How many to withdraw?", szMiscArray, "Submit", "Go Back");
	} else {
		CrateTransferOption(playerid, PlayerInfo[playerid][pMember]); 
	}
	return 1;
}

Dialog:crate_tran_amount(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	if(response) {
		new gbox, amount = floatround(strval(inputtext));
		GetGroupCrate(playerid, gbox);
		if(CarryCrate[playerid] != gbox) return SendClientMessageEx(playerid, COLOR_RED, "Your no longer holding the group crate.");
		new total = (arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerCost][GetPVarInt(playerid, "GunCrateSlot")] * amount);
		if(amount < 1 || total > arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerStock]) {
			format(szMiscArray, sizeof(szMiscArray), "Please enter the amount you would like to transfer to the crate.\n\nLocker Stock: %s\nCost Per %s: %s\n\n{FF0000}Error: You can't go below 0 or you don't have enough materials.", number_format(arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerStock]), Weapon_ReturnName(GetPVarInt(playerid, "GunCrateID")), number_format(arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerCost][GetPVarInt(playerid, "GunCrateSlot")]));
	    	Dialog_Show(playerid, crate_tran_amount, DIALOG_STYLE_INPUT, "How many to transfer?", szMiscArray, "Submit", "Go Back");
			return 1;
		}
		CrateBox[CarryCrate[playerid]][cbWep][GetPVarInt(playerid, "GunCrateSlot")] = GetPVarInt(playerid, "GunCrateID");
		CrateBox[CarryCrate[playerid]][cbWepAmount][GetPVarInt(playerid, "GunCrateSlot")] += amount;
		arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerStock] -= total;
		SendClientMessageEx(playerid, COLOR_WHITE, "You transferred %s %s(s) to the crate.", number_format(amount), Weapon_ReturnName(GetPVarInt(playerid, "GunCrateID")));
		SaveGroup(PlayerInfo[playerid][pMember]);
		SaveCrate(CarryCrate[playerid]);
		format(szMiscArray, sizeof(szMiscArray), "%s has withdrawn %d %ss from the weapon locker into the transfer crate (Cost: %d)", GetPlayerNameEx(playerid), amount, Weapon_ReturnName(GetPVarInt(playerid, "GunCrateID")), total);
		GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
		WeaponMenu(playerid, PlayerInfo[playerid][pMember], 1);
	} else {
		DeletePVar(playerid, "GunCrateID");
		DeletePVar(playerid, "GunCrateSlot");
		WeaponMenu(playerid, PlayerInfo[playerid][pMember], 1);
	}
	return 1;
}

stock DepositCrateContents(playerid, boxid) {
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	if(CrateBox[boxid][cbGroup] != -1) {
		for(new c = 0; c < 16; c++) {
			if(CrateBox[boxid][cbWep][c] > 0) {
				for(new l = 0; l < 16; l++) {
					if(CrateBox[boxid][cbWep][c] == arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerGuns][l]) {
						arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerStock] += (CrateBox[boxid][cbWepAmount][c] * arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerCost][l]);
						CrateBox[boxid][cbWep][c] = 0;
					}
				}
			}
		}
		format(szMiscArray, sizeof(szMiscArray), "* %s has unloaded the contents of the crate into the locker.", GetPlayerNameEx(playerid));
		ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		DestroyCrate(boxid);
	} else {
		if(CrateBox[boxid][cbGroup] == -1 && CrateFacility[CrateBox[boxid][cbFacility]][cfGroup] == PlayerInfo[playerid][pMember] && !CrateBox[boxid][cbPaid]) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "You can't deposit this crate as it's unpaid!");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Please have the group leader order crates if you need to stock up.");
		} else {
			arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerStock] += floatround(CrateBox[boxid][cbMats] * CrateFacility[CrateBox[boxid][cbFacility]][cfProdMulti]);
			DestroyCrate(boxid);
			format(szMiscArray, sizeof(szMiscArray), "* %s has unloaded the contents of the crate into the locker.", GetPlayerNameEx(playerid));
			ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
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

stock CanDeposit(WepID) {
	switch(WepID) {
		case 27: return 1; // Combat Shotgun
		case 30: return 1; // AK-47
		case 31: return 1; // M4
		case 34: return 1; // Sniper Rifle
		default: return 0;
	}
	return 0;
}

CMD:editweprank(playerid, params[]) {
	if(!IsGroupLeader(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Only group leaders can use this command!");
	WeaponRankList(playerid);
	return 1;
}

stock WeaponRankList(playerid) {
	szMiscArray[0] = 0;
	if(!IsGroupLeader(playerid)) return 1;

	new group = PlayerInfo[playerid][pMember];

	format(szMiscArray, sizeof(szMiscArray), "Weapon\tRank\n");
	for(new i = 0; i != MAX_GROUP_WEAPONS; ++i) {
		if(arrGroupData[group][g_iLockerGuns][i]) {
			format(szMiscArray, sizeof szMiscArray, "%s\n%s\t%d", szMiscArray, Weapon_ReturnName(arrGroupData[group][g_iLockerGuns][i]), LockerWep[group][lwRank][i]);
		}
		else strcat(szMiscArray, "\nEmpty\t--");
	}
	Dialog_Show(playerid, wep_restrict, DIALOG_STYLE_TABLIST_HEADERS, "Weapon Restriction", szMiscArray, "Select", "Close");
	return 1;
}

Dialog:wep_restrict(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(!IsGroupLeader(playerid)) return 1;
	new group = PlayerInfo[playerid][pMember];
	if(response) {
		if(!arrGroupData[group][g_iLockerGuns][listitem]) return SendClientMessageEx(playerid, COLOR_GRAD1, "The selected slot is currently empty!"), WeaponRankList(playerid);
		SetPVarInt(playerid, "RGunID", listitem);
		format(szMiscArray, sizeof(szMiscArray), "Please specify what rank & above can access the %s.\n\nCurrent Rank: %d+", Weapon_ReturnName(arrGroupData[group][g_iLockerGuns][listitem]), LockerWep[group][lwRank][listitem]);
		Dialog_Show(playerid, set_weprank, DIALOG_STYLE_INPUT, "Restrict Weapon Withdraw", szMiscArray, "Ok", "Go Back");
	}
	return 1;
}

Dialog:set_weprank(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(!IsGroupLeader(playerid)) return 1;
	new group = PlayerInfo[playerid][pMember];
	if(response) {
		if(isnull(inputtext)) {
			format(szMiscArray, sizeof(szMiscArray), "Please specify what rank & above can access the %s.\n\nCurrent Rank: %d+\n\n{FF0000}ERROR: You must specify a rank number!", Weapon_ReturnName(arrGroupData[group][g_iLockerGuns][GetPVarInt(playerid, "RGunID")]), LockerWep[group][lwRank][GetPVarInt(playerid, "RGunID")], MAX_GROUP_RANKS-1);
			Dialog_Show(playerid, set_weprank, DIALOG_STYLE_INPUT, "Restrict Weapon Withdraw", szMiscArray, "Ok", "Go Back");
			return 1;
		}
		if(!IsNumeric(inputtext)) {
			format(szMiscArray, sizeof(szMiscArray), "Please specify what rank & above can access the %s.\n\nCurrent Rank: %d+\n\n{FF0000}ERROR: You can only use numeric values.", Weapon_ReturnName(arrGroupData[group][g_iLockerGuns][GetPVarInt(playerid, "RGunID")]), LockerWep[group][lwRank][GetPVarInt(playerid, "RGunID")], MAX_GROUP_RANKS-1);
			Dialog_Show(playerid, set_weprank, DIALOG_STYLE_INPUT, "Restrict Weapon Withdraw", szMiscArray, "Ok", "Go Back");
			return 1;
		}
		if(!(0 <= strval(inputtext) < MAX_GROUP_RANKS)) {
			format(szMiscArray, sizeof(szMiscArray), "Please specify what rank & above can access the %s.\n\nCurrent Rank: %d+\n\n{FF0000}ERROR: Invalid rank ID (0 - %d only!)", Weapon_ReturnName(arrGroupData[group][g_iLockerGuns][GetPVarInt(playerid, "RGunID")]), LockerWep[group][lwRank][GetPVarInt(playerid, "RGunID")], MAX_GROUP_RANKS-1);
			Dialog_Show(playerid, set_weprank, DIALOG_STYLE_INPUT, "Restrict Weapon Withdraw", szMiscArray, "Ok", "Go Back");
			return 1;
		}
		format(szMiscArray, sizeof(szMiscArray), "%s has set %s weapon restriction from rank %d+ to %d.", GetPlayerNameEx(playerid), Weapon_ReturnName(arrGroupData[group][g_iLockerGuns][GetPVarInt(playerid, "RGunID")]), LockerWep[group][lwRank][GetPVarInt(playerid, "RGunID")], strval(inputtext));
		GroupLog(group, szMiscArray);
		LockerWep[group][lwRank][GetPVarInt(playerid, "RGunID")] = strval(inputtext);
		SendClientMessageEx(playerid, COLOR_YELLOW, "You have set the %s weapon restriction to %d+ only.", Weapon_ReturnName(arrGroupData[group][g_iLockerGuns][GetPVarInt(playerid, "RGunID")]), strval(inputtext));
		SaveLockerRanks(group);
		DeletePVar(playerid, "RGunID");
		WeaponRankList(playerid);
	} else {
		DeletePVar(playerid, "RGunID");
		WeaponRankList(playerid);
	}
	return 1;
}

stock IsInSlot(group, id, &wep)
{
	wep = -1;
	if(ValidGroup(group)) {
		for(new i = 0; i != MAX_GROUP_WEAPONS; i++) {
			if(arrGroupData[group][g_iLockerGuns][i] == id) {
				wep = i; // Slot ID.
				break;
			}
		}
	}
}

CMD:allow(playerid, params[]) {
	new target, locker = -1;
	if(!IsGroupLeader(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Only group leaders can use this command!");
	if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /allow [player]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GRAD2, "The player selected isn't connected!");
	if(PlayerInfo[playerid][pMember] != PlayerInfo[target][pMember]) return SendClientMessageEx(playerid, COLOR_GRAD2, "%s isn't apart of your group!", GetPlayerNameEx(target));
	if(playerid == target) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this weapon on yourself!");
	if(!LockerReq[target][0]) return SendClientMessageEx(playerid, COLOR_GRAD2, "%s hasn't requested to withdraw a weapon!", GetPlayerNameEx(target));
	if(LockerReq[target][2] < gettime()) return SendClientMessageEx(playerid, COLOR_GRAD2, "%s's request either expired or one wasn't made!", GetPlayerNameEx(target));
	if(PlayerInfo[target][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Unable to process weapon - The player is restricted.");
	if(PlayerInfo[target][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Unable to process weapon - The player is currently weapon restricted!");
	if(PlayerBusy(playerid) || PlayerInfo[target][pJailTime] > 0 || PlayerCuffed[target] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Unable to process weapon - The player is currently busy!");
	for(new i; i < MAX_GROUPS; i++)
	{
		for(new j; j < MAX_GROUP_LOCKERS; j++)
		{
			if(IsPlayerInRangeOfPoint(target, 3.0, arrGroupLockers[i][j][g_fLockerPos][0], arrGroupLockers[i][j][g_fLockerPos][1], arrGroupLockers[i][j][g_fLockerPos][2]) && arrGroupLockers[i][j][g_iLockerVW] == GetPlayerVirtualWorld(target))
			{
				if(i == PlayerInfo[target][pMember] || (arrGroupData[i][g_iGroupType] == arrGroupData[PlayerInfo[target][pMember]][g_iGroupType] && arrGroupLockers[i][j][g_iLockerShare]))
				{
					locker = j;
				}
			}
		}
	}
	if(locker == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "%s is no longer at a locker!", GetPlayerNameEx(target)), SendClientMessageEx(target, COLOR_GRAD2, "Your weapon request failed - Your not near any lockers!");
	if(arrGroupData[PlayerInfo[target][pMember]][g_iLockerStock] < arrGroupData[PlayerInfo[target][pMember]][g_iLockerCost][LockerReq[target][1]]) return SendClientMessageEx(playerid, COLOR_RED, "Your locker doesn't have the materials to craft a %s.", Weapon_ReturnName(LockerReq[target][0]));
	if(PlayerInfo[target][pGuns][GetWeaponSlot(LockerReq[target][0])] != LockerReq[target][0]) {
		arrGroupData[PlayerInfo[target][pMember]][g_iLockerStock] -= arrGroupData[PlayerInfo[target][pMember]][g_iLockerCost][LockerReq[target][1]];
		GivePlayerValidWeapon(target, LockerReq[target][0]);
		SendClientMessageEx(target, COLOR_WHITE, "You withdraw a %s from the locker - authorized by %s.", Weapon_ReturnName(LockerReq[target][0]), GetPlayerNameEx(playerid));
		SendClientMessageEx(playerid, COLOR_WHITE, "You have authorized %s to withdraw a %s from the locker.", GetPlayerNameEx(target), Weapon_ReturnName(LockerReq[target][0]));
		format(szMiscArray, sizeof(szMiscArray), "%s has authorized %s to withdraw a %s from the weapon locker (Cost: %d)", GetPlayerNameEx(playerid), GetPlayerNameEx(target), Weapon_ReturnName(LockerReq[target][0]), arrGroupData[PlayerInfo[target][pMember]][g_iLockerCost][LockerReq[target][1]]);
		GroupLog(PlayerInfo[target][pMember], szMiscArray);
	} else {
		SendClientMessageEx(playerid, COLOR_RED, "%s already has an %s!", GetPlayerNameEx(target), Weapon_ReturnName(LockerReq[target][0]));
		SendClientMessageEx(target, COLOR_RED, "You already have a %s on you!", Weapon_ReturnName(LockerReq[target][0]));
	}
	LockerReq[target][0] = 0;
	LockerReq[target][1] = -1;
	return 1;
}

ptask LockerTimer[1000](i) {
	if(LockerReq[i][0] > 0) {
		if(LockerReq[i][2] > gettime()) {
			if(PlayerBusy(i) || PlayerInfo[i][pJailTime] > 0 || PlayerCuffed[i] != 0) {
			SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Your weapon withdraw request for the %s was interrupted.", Weapon_ReturnName(LockerReq[i][0]));
			LockerReq[i][0] = 0;
			LockerReq[i][1] = -1;
			}
		}
		if(LockerReq[i][2] == gettime()) {
			SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Your weapon withdraw request for the %s has expired.", Weapon_ReturnName(LockerReq[i][0]));
			LockerReq[i][0] = 0;
			LockerReq[i][1] = -1;
		}
	}
	return 1;
}

CMD:convertlocker(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
		new group, total, amount;
		if(sscanf(params, "i", group)) return SendClientMessageEx(playerid, COLOR_GREY, "Usage: /convertlocker [groupid]");
		if(!ValidGroup(group)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid group specified!");
		for(new l = 0; l < MAX_GROUP_WEAPONS; l++) {
			if(arrGroupData[group][g_iLockerGuns][l] > 0) {
				if(LockerWep[group][lwWep][arrGroupData[group][g_iLockerGuns][l]-1] > 0) {
					total += LockerWep[group][lwWep][arrGroupData[group][g_iLockerGuns][l]-1];
					amount += (LockerWep[group][lwWep][arrGroupData[group][g_iLockerGuns][l]-1] * arrGroupData[group][g_iLockerCost][l]);
				}
			}
		}
		SetPVarInt(playerid, "converttotal", total);
		SetPVarInt(playerid, "convertamount", amount);
		SetPVarInt(playerid, "convertgroup", group);
		format(szMiscArray, sizeof(szMiscArray), "You're about to convert %s's old locker into \"High Grade Materials\"!\n\nHave you finished setting up the group lockers & costs via /editgroup?\n\nTotal Weapons: %s\nTotal Materials: %s", arrGroupData[group][g_szGroupName], number_format(total), number_format(amount));
		if(amount > 0) {
			Dialog_Show(playerid, convert_locker, DIALOG_STYLE_MSGBOX, "Are you sure?", szMiscArray, "Yes", "No");
		} else {
			Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "No materials to convert", "There is no weapons to convert from the old locker.", "Close", "");
		}
	} else {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
	}
	return 1;
}

Dialog:convert_locker(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {

			arrGroupData[GetPVarInt(playerid, "convertgroup")][g_iLockerStock] += GetPVarInt(playerid, "convertamount");
			SendClientMessageEx(playerid, COLOR_YELLOW, "%s weapons have been converted into materials (Amount: %s)", number_format(GetPVarInt(playerid, "converttotal")), number_format(GetPVarInt(playerid, "convertamount")));
			for(new w = 0; w < 46; w++) {
				LockerWep[GetPVarInt(playerid, "convertgroup")][lwWep][w] = 0;
			}
			//SaveWeapons(GetPVarInt(playerid, "convertgroup"));
			DeletePVar(playerid, "converttotal");
			DeletePVar(playerid, "convertamount");
			DeletePVar(playerid, "convertgroup");
		}
	} else {
		DeletePVar(playerid, "converttotal");
		DeletePVar(playerid, "convertamount");
		DeletePVar(playerid, "convertgroup");
	}
	return 1;
}