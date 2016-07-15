#include <YSI\y_hooks>

ClearDoorSaleVariables(playerid)
{
	stop DDSaleTimer[playerid];
	DDSalePendingAdmin[playerid] = false;
	DDSalePendingPlayer[playerid] = false;
	DDSaleTarget[playerid] = INVALID_PLAYER_ID;
	DDSalePrice[playerid] = 0;
	DDSaleTracking[playerid] = 0;
	for(new i = 0; i < sizeof(DDSaleDoors[]); i ++) DDSaleDoors[playerid][i] = 0;
	return 1;
}

CalculatePercentage(source, percentage, minimum)
{
	new amount;
	amount = percentage * source / 100;
	if(amount < minimum) amount = minimum;
	return amount;
}

ReturnDoorLineDetails(playerid, doorid)
{
	new string[32];
	string = "N/A";
	if(doorid != 0 && GetPlayerSQLId(playerid) == DDoorsInfo[doorid][ddOwner]) format(string, sizeof(string), "%d (%s)", doorid, DDoorsInfo[doorid][ddDescription]);
	return string;
}

ShowDynamicDoorDialog(playerid)
{
	if(!IsPlayerConnected(DDSaleTarget[playerid]) || DDSaleTarget[playerid] == INVALID_PLAYER_ID)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "The specified buyer is no longer connected.");
		ClearDoorSaleVariables(playerid);
		return 1;
	}
	if(DDSalePendingPlayer[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "Your dynamic door sale is pending approval from the specified buyer.");
	if(DDSalePendingAdmin[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "Your dynamic door sale is pending approval from server administration.");
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "Setting\tValue\nBuyer\t%s\nPrice\t$%s\nSeller Fine\t$%s\nDynamic Door 1\t%s\nDynamic Door 2\t%s\nDynamic Door 3\t%s\nDynamic Door 4\t%s\nDynamic Door 5\t%s\nGarage 1\t%s\nGarage 2\t%s\nFinalize And Submit", 
	GetPlayerNameEx(DDSaleTarget[playerid]), number_format(DDSalePrice[playerid]), number_format(CalculatePercentage(DDSalePrice[playerid], 10, 1000000)),
	ReturnDoorLineDetails(playerid, DDSaleDoors[playerid][0]), ReturnDoorLineDetails(playerid, DDSaleDoors[playerid][1]), ReturnDoorLineDetails(playerid, DDSaleDoors[playerid][2]), 
	ReturnDoorLineDetails(playerid, DDSaleDoors[playerid][3]), ReturnDoorLineDetails(playerid, DDSaleDoors[playerid][4]), ReturnGarageLineDetails(playerid, DDSaleDoors[playerid][5]), ReturnGarageLineDetails(playerid, DDSaleDoors[playerid][6]));
	ShowPlayerDialogEx(playerid, DIALOG_DDSALEMAIN, DIALOG_STYLE_TABLIST_HEADERS, "Dynamic Door Selling", szMiscArray, "Okay", "Cancel");
	return 1;
}

task DynamicDoorSellRequests[60000]()
{
	new bool:notification;
	foreach(new i : Player)
	{
		if(gPlayerLogged{i} == 1 && DDSalePendingAdmin[i] == true)
		{
			notification = true;
			break;
		}
	}
	if(notification == true)
	{
		ABroadCast(COLOR_LIGHTRED, "One or more dynamic door sale requests are pending review.", 4, true);
		return 1;
	}
	return 1;
}

timer DDSaleTimerEx[30000](playerid)
{
	if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid) && playerid != INVALID_PLAYER_ID)
	{
		new string[128];
		format(string, sizeof(string), "Your dynamic door offer (buyer: %s) has expired.", GetPlayerNameEx(DDSaleTarget[playerid]));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		format(string, sizeof(string), "Your dynamic door sale offer from %s has expired.", GetPlayerNameEx(playerid));
		SendClientMessageEx(DDSaleTarget[playerid], COLOR_GREY, string);
		ClearDoorSaleVariables(playerid);
		return 1;
	}
	return 1;
}

CMD:ad(playerid, params[]) return cmd_approvedoorsale(playerid, params);
CMD:ds(playerid, params[]) return cmd_denydoorsale(playerid, params);

CMD:doorsalehelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_WHITE, "** DYNAMIC DOOR SALE COMMANDS **");
	SendClientMessageEx(playerid, COLOR_GREY, "» /selldoors [Part Of Name/ ID] - Allows you to sell your dynamic doors to a specified player with a set price.");
	SendClientMessageEx(playerid, COLOR_GREY, "» /cancel door - Cancels your dynamic door sale request (must be pending review from server administrator).");
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "» {EE9A4D}SENIOR ADMIN{D8D8D8} /doorrequests - View the list of current dynamic door requests pending review from administration.");
		SendClientMessageEx(playerid, COLOR_GREY, "» {EE9A4D}SENIOR ADMIN{D8D8D8} /doorsaleinfo - View detailed information on a door sale request.");
		SendClientMessageEx(playerid, COLOR_GREY, "» {EE9A4D}SENIOR ADMIN{D8D8D8} /(a)pprove(d)oorsale [Part Of Name/ ID] - Approve a specified player's dynamic door sale.");
		SendClientMessageEx(playerid, COLOR_GREY, "» {EE9A4D}SENIOR ADMIN{D8D8D8} /(d)enydoor(s)ale [Part Of Name/ ID] - Deny a specified player's dynamic door sale.");
		return 1;
	}
	return 1;
}

CMD:selldoors(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You are not logged into your account.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot sell dynamic doors while injured.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot sell dynamic doors while handcuffed.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot sell dynamic doors while in prison.");
	new target;
	if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /selldoors [Part Of Name/ ID]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player isn't connected.");
	if(target == playerid) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot sell dynamic doors to yourself.");
	if(GetPlayerCash(playerid) < 1000000) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot afford the minimum $1,000,000 transfer fine.");
	if(gPlayerLogged{target} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player isn't logged into their account.");
	if(DDSalePendingPlayer[playerid] == true || DDSalePendingAdmin[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "You have an existing dynamic door sale offer, use (/cancel door) to cancel it.");
	foreach(new i : Player) if(DDSaleTarget[i] == target) return SendClientMessageEx(playerid, COLOR_GREY, "Another player has already offered the specified player a dynamic door sale offer.");
	ClearDoorSaleVariables(playerid);
	DDSaleTarget[playerid] = target;
	ShowDynamicDoorDialog(playerid);
	return 1;
}

CMD:doorrequests(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new count, string[64];
	SendClientMessageEx(playerid, COLOR_WHITE, "** DYNAMIC DOOR SALE REQUESTS PENDING APPROVAL: **");
	foreach(new i : Player)
	{
		if(gPlayerLogged{i} == 1 && DDSalePendingAdmin[i] == true)
		{
			format(string, sizeof(string), "(ID: %d) %s", i, GetPlayerNameEx(i));
			SendClientMessageEx(playerid, COLOR_GREY, string);
			count ++;
		}
	}
	if(count == 0) return SendClientMessageEx(playerid, COLOR_GREY, "There are not currently any dynamic door sale requests approval.");
	return 1;
}

CMD:doorsaleinfo(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new target;
	if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /doorsaleinfo [Part Of Name/ ID]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player isn't connected.");
	if(gPlayerLogged{target} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player isn't logged into their account.");
	if(DDSalePendingAdmin[target] == false) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player does not have a pending dynamic door sale request.");
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "General Information:\n\n  » Seller: %s\n  » Buyer: %s\n  » Price: $%s\n  » Fine: $%s\n\nDynamic Door(s):\n\n", GetPlayerNameEx(target), GetPlayerNameEx(DDSaleTarget[target]), number_format(DDSalePrice[target]), CalculatePercentage(DDSalePrice[target], 10, 1000000));
	for(new i = 0; i < sizeof(DDSaleDoors[]); i ++) if(DDSaleDoors[target][i] != 0 && GetPlayerSQLId(target) == DDoorsInfo[DDSaleDoors[target][i]][ddOwner]) format(szMiscArray, sizeof(szMiscArray), "%s\n  » Door ID: %d (%s)", szMiscArray, DDSaleDoors[target][i], DDoorsInfo[DDSaleDoors[target][i]][ddDescription]);
	ShowPlayerDialogEx(playerid, DIALOG_DDSALEINFO, DIALOG_STYLE_MSGBOX, "Dynamic Door Sale Details", szMiscArray, "Okay", "Cancel");
	return 1;
}

CMD:approvedoorsale(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new target, fine, count[2], timex[3], string[128];
	if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /approvedoorsale [Part Of Name/ ID]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player isn't connected.");
	if(gPlayerLogged{target} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player isn't logged into their account.");
	if(DDSalePendingAdmin[target] == false) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player does not have a pending dynamic door sale request.");
	fine = CalculatePercentage(DDSalePrice[target], 10, 1000000);
	if(GetPlayerCash(DDSaleTarget[target]) < DDSalePrice[target])
	{
		format(string, sizeof(string), "You have approved %s's dynamic door sale request.", GetPlayerNameEx(target));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "No transactions have been made however, as %s does not have the sufficient funds ($%s).", GetPlayerNameEx(DDSaleTarget[target]), number_format(DDSalePrice[target]));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		format(string, sizeof(string), "%s has approved your dynamic door sale request.", GetPlayerNameEx(playerid));
		SendClientMessageEx(target, COLOR_GREEN, string);
		format(string, sizeof(string), "No transactions have been made however, as %s does not have the sufficient funds ($%s).", GetPlayerNameEx(DDSaleTarget[target]), number_format(DDSalePrice[target]));
		SendClientMessageEx(target, COLOR_GREY, string);
		format(string, sizeof(string), "%s has approved %s's dynamic door sale request.", GetPlayerNameEx(playerid), GetPlayerNameEx(target));
		SendClientMessageEx(DDSaleTarget[target], COLOR_GREEN, string);
		format(string, sizeof(string), "No transactions have been made however, as you do not have the sufficient funds ($%s).", number_format(DDSalePrice[target]));
		SendClientMessageEx(DDSaleTarget[target], COLOR_GREY, string);
		ClearDoorSaleVariables(target);
		PlayerInfo[playerid][pAcceptReport] ++;
		ReportCount[playerid] ++;
		ReportHourCount[playerid] ++;
		format(string, sizeof(string), "AdmCmd: %s approved %s's dynamic door sale request (sale failed).", GetPlayerNameEx(playerid), GetPlayerNameEx(target));
		ABroadCast(COLOR_LIGHTRED, string, 4);
		Log("logs/admin.log", string);
		return 1;
	}
	else if(GetPlayerCash(target) < fine)
	{
		format(string, sizeof(string), "You have approved %s's dynamic door sale request.", GetPlayerNameEx(target));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "No transactions have been made however, as %s does not have the sufficient funds for the fine ($%s).", GetPlayerNameEx(target), number_format(fine));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		format(string, sizeof(string), "%s has approved your dynamic door sale request.", GetPlayerNameEx(playerid));
		SendClientMessageEx(target, COLOR_GREEN, string);
		format(string, sizeof(string), "No transactions have been made however, as you does not have the sufficient funds for the fine ($%s).", number_format(fine));
		SendClientMessageEx(target, COLOR_GREY, string);
		format(string, sizeof(string), "%s has approved %s's dynamic door sale request.", GetPlayerNameEx(playerid), GetPlayerNameEx(target));
		SendClientMessageEx(DDSaleTarget[target], COLOR_GREEN, string);
		format(string, sizeof(string), "No transactions have been made however, as %s does not have the sufficient funds for the fine ($%s).", GetPlayerNameEx(target), number_format(fine));
		SendClientMessageEx(DDSaleTarget[target], COLOR_GREY, string);
		PlayerInfo[playerid][pAcceptReport] ++;
		ReportCount[playerid] ++;
		ReportHourCount[playerid] ++;
		format(string, sizeof(string), "AdmCmd: %s approved %s's dynamic door sale request (sale failed).", GetPlayerNameEx(playerid), GetPlayerNameEx(target));
		ABroadCast(COLOR_LIGHTRED, string, 4);
		Log("logs/admin.log", string);
		ClearDoorSaleVariables(target);
		return 1;
	}
	else if(GetPlayerCash(DDSaleTarget[target]) >= DDSalePrice[target])
	{
		szMiscArray[0] = 0;
		gettime(timex[0], timex[1], timex[2]);
		format(string, sizeof(string), "You have approved %s's dynamic door sale request.", GetPlayerNameEx(target));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "%s has approved your dynamic door sale request ($%s).", GetPlayerNameEx(playerid), number_format(DDSalePrice[target]));
		SendClientMessageEx(target, COLOR_GREEN, string);
		format(string, sizeof(string), "%s has approved %s's dynamic door sale request ($%s).", GetPlayerNameEx(playerid), GetPlayerNameEx(target), number_format(DDSalePrice[target]));
		SendClientMessageEx(DDSaleTarget[target], COLOR_GREEN, string);
		GivePlayerCashEx(target, TYPE_ONHAND, DDSalePrice[target]);
		GivePlayerCashEx(target, TYPE_ONHAND, -fine);
		GivePlayerCashEx(DDSaleTarget[target], TYPE_ONHAND, -DDSalePrice[target]);
		format(szMiscArray, sizeof(szMiscArray), "General Transaction Information:\n\n  » Seller: %s\n  » Buyer: %s\n  » Price: $%s\n  » Seller Fine: $%s\n  » Date: %s (%02d:%02d:%02d)\n\nDynamic Doors:\n", 
		GetPlayerNameEx(target), GetPlayerNameEx(DDSaleTarget[target]), number_format(DDSalePrice[target]), number_format(fine), date(gettime(), 4), timex[0], timex[1], timex[2]);
		for(new i = 0; i < sizeof(DDSaleDoors[]) - 2; i ++) 
		{
			if(DDSaleDoors[target][i] != 0 && GetPlayerSQLId(target) == DDoorsInfo[DDSaleDoors[target][i]][ddOwner])
			{
				format(szMiscArray, sizeof(szMiscArray), "%s\n  » Door ID: %d (%s)", szMiscArray, DDSaleDoors[target][i], DDoorsInfo[DDSaleDoors[target][i]][ddDescription]);
				strcpy(DDoorsInfo[DDSaleDoors[target][i]][ddOwnerName], GetPlayerNameEx(DDSaleTarget[target]), MAX_PLAYER_NAME);
				DDoorsInfo[DDSaleDoors[target][i]][ddOwner] = GetPlayerSQLId(DDSaleTarget[target]);
				DestroyDynamicPickup(DDoorsInfo[DDSaleDoors[target][i]][ddPickupID]);
				if(IsValidDynamic3DTextLabel(DDoorsInfo[DDSaleDoors[target][i]][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[DDSaleDoors[target][i]][ddTextID]);
				CreateDynamicDoor(DDSaleDoors[target][i]);
				SaveDynamicDoor(DDSaleDoors[target][i]);
				count[0] ++;
			}
		}
		if(count[0] == 0) strcat(szMiscArray, "\n  » None");
		strcat(szMiscArray, "\n\nGarages:\n");
		for(new i = sizeof(DDSaleDoors[]) - 2; i < sizeof(DDSaleDoors[]); i ++)
		{
			if(DDSaleDoors[target][i] != 0 && GetPlayerSQLId(target) == GarageInfo[DDSaleDoors[target][i]][gar_Owner])
			{
				format(szMiscArray, sizeof(szMiscArray), "%s\n  » Garage ID: %d", szMiscArray, DDSaleDoors[target][i]);
				strcpy(GarageInfo[DDSaleDoors[target][i]][gar_OwnerName], GetPlayerNameEx(DDSaleTarget[target]), MAX_PLAYER_NAME);
				GarageInfo[DDSaleDoors[target][i]][gar_Owner] = GetPlayerSQLId(DDSaleTarget[target]);
				CreateGarage(DDSaleDoors[target][i]);
				SaveGarage(DDSaleDoors[target][i]);
				count[1] ++;
			}
		}
		if(count[1] == 0) strcat(szMiscArray, "\n  » None");
		strcat(szMiscArray, "\n\nPress (F8) to take a screen-shot of this receipt for future reference.");
		ShowPlayerDialogEx(target, DIALOG_DDSALERECIEPT, DIALOG_STYLE_MSGBOX, "Dynamic Door Sale Receipt", szMiscArray, "Okay", "Cancel");
		ShowPlayerDialogEx(DDSaleTarget[target], DIALOG_DDSALERECIEPT, DIALOG_STYLE_MSGBOX, "Dynamic Door Sale Receipt", szMiscArray, "Okay", "Cancel");
		PlayerInfo[playerid][pAcceptReport] ++;
		ReportCount[playerid] ++;
		ReportHourCount[playerid] ++;
		format(string, sizeof(string), "AdmCmd: DDSale: Auth: %s DD sale (Seller:%s) (DD:%d) (F:$%s) (P:$%s) (TO: (%s)).", GetPlayerNameEx(playerid), GetPlayerNameEx(target), DDSaleTracking[target], number_format(fine), number_format(DDSalePrice[target]), GetPlayerNameEx(DDSaleTarget[target]));
		ABroadCast(COLOR_LIGHTRED, string, 4);
		Log("logs/admin.log", string);
		ClearDoorSaleVariables(target);
		return 1;
	}
	return 1;
}

CMD:denydoorsale(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new target, reason[64], string[128];
	if(sscanf(params, "us[64]", target, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /denydoorsale [Part Of Name/ ID] [Reason]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player isn't connected.");
	if(gPlayerLogged{target} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player isn't logged into their account.");
	if(DDSalePendingAdmin[target] == false) return SendClientMessageEx(playerid, COLOR_GREY, "The specified player does not have a pending dynamic door sale request.");
	if(strlen(reason) < 3 || strlen(reason) > 60) return SendClientMessageEx(playerid, COLOR_GREY, "The specified reason cannot be under 3 characters or over 60 characters.");
	ClearDoorSaleVariables(target);
	format(string, sizeof(string), "You have denied %s's dynamic door sale request, reason: %s.", GetPlayerNameEx(target), reason);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "%s has denied your dynamic door sale request, reason: %s.", GetPlayerNameEx(playerid), reason);
	SendClientMessageEx(target, COLOR_LIGHTRED, string);
	PlayerInfo[playerid][pTrashReport] ++;
	format(string, sizeof(string), "AdmCmd: %s denied %s's dynamic door sale request, reason: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(target), reason);
	ABroadCast(COLOR_LIGHTRED, string, 4);
	Log("logs/admin.log", string);
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	new string[128];
	switch(dialogid)
	{
		case DIALOG_DDSALEMAIN:
		{
			switch(response)
			{
				case false: return ClearDoorSaleVariables(playerid);
				case true:
				{
					if(!IsPlayerConnected(DDSaleTarget[playerid]) || DDSaleTarget[playerid] == INVALID_PLAYER_ID)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified buyer is no longer connected.");
						ClearDoorSaleVariables(playerid);
						return 1;
					}
					if(DDSalePendingPlayer[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "Your dynamic door sale is pending approval from the specified buyer.");
					if(DDSalePendingAdmin[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "Your dynamic door sale is pending approval from server administration.");
					switch(listitem)
					{
						case 0:
						{
							ShowDynamicDoorDialog(playerid);
							SendClientMessageEx(playerid, COLOR_GREY, "To modify the buyer of your dynamic door(s), exit this dialog and use the command again.");
							return 1;
						}
						case 1: return ShowPlayerDialogEx(playerid, DIALOG_DDSALEPRICE, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input the total price of the sale below.", "Okay", "Cancel");
						case 2: 
						{
							SendClientMessageEx(playerid, COLOR_GREY, "The seller's fine is automatically determined by the total sale price. It cannot be modified.");
							ShowDynamicDoorDialog(playerid);
							return 1;
						}
						case 3..7:
						{
							DDSaleTracking[playerid] = (listitem - 3);
							ShowPlayerDialogEx(playerid, DIALOG_DDSALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the dynamic door you would like to link to the sale. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
							return 1;
						}
						case 8, 9:
						{
							DDSaleTracking[playerid] = (listitem - 8);
							ShowPlayerDialogEx(playerid, DIALOG_GARAGESALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the garage you would like to link to the sale. Input \"0\" to remove a garage.", "Okay", "Cancel");
							return 1;
						}
						case 10:
						{
							if(DDSalePrice[playerid] < 1 || DDSalePrice[playerid] > 1000000000)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You must specify a price between $1 and $1,000,000,000.");
								ShowDynamicDoorDialog(playerid);
								return 1;
							}
							new fine, bool:linked;
							for(new i = 0; i < sizeof(DDSaleDoors[]); i ++)
							{
								if(DDSaleDoors[playerid][i] != 0)
								{
									if(GetPlayerSQLId(playerid) == DDoorsInfo[DDSaleDoors[playerid][i]][ddOwner] && linked == false) linked = true;
									else if(GetPlayerSQLId(playerid) != DDoorsInfo[DDSaleDoors[playerid][i]][ddOwner]) DDSaleDoors[playerid][i] = 0;
								}
							}
							if(linked == false)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You must linked at minimum one dynamic door to your sale.");
								ShowDynamicDoorDialog(playerid);
								return 1;
							}
							fine = CalculatePercentage(DDSalePrice[playerid], 10, 1000000);
							if(GetPlayerCash(playerid) < fine)
							{
								format(string, sizeof(string), "You do not have the sufficient funds for the transfer fine ($%s).", number_format(fine));
								SendClientMessageEx(playerid, COLOR_GREY, string);
								return 1;
							}
							format(string, sizeof(string), "You have sent your dynamic door sale request offer to %s for $%s.", GetPlayerNameEx(DDSaleTarget[playerid]), number_format(DDSalePrice[playerid]));
							SendClientMessageEx(playerid, COLOR_CYAN, string);
							SendClientMessageEx(playerid, COLOR_GREY, "To cancel your dynamic door sale request offer, use (/cancel door).");
							format(string, sizeof(string), "** NEW DYNAMIC DOOR SALE OFFER FROM %s: **", GetPlayerNameEx(playerid));
							SendClientMessageEx(DDSaleTarget[playerid], COLOR_CYAN, string);
							format(string, sizeof(string), "» (Price): $%s", number_format(DDSalePrice[playerid]));
							SendClientMessageEx(DDSaleTarget[playerid], COLOR_WHITE, string);
							for(new i = 0; i < sizeof(DDSaleDoors[]); i ++)
							{
								if(DDSaleDoors[playerid][i] != 0 && GetPlayerSQLId(playerid) == DDoorsInfo[DDSaleDoors[playerid][i]][ddOwner])
								{
									format(string, sizeof(string), "» (Door ID %d): %s", DDSaleDoors[playerid][i], DDoorsInfo[DDSaleDoors[playerid][i]][ddDescription]);
									SendClientMessageEx(DDSaleTarget[playerid], COLOR_WHITE, string);
								}
							}
							SendClientMessageEx(DDSaleTarget[playerid], COLOR_CYAN, "Use (/accept door) to accept the dynamic door sale offer.");
							DDSalePendingPlayer[playerid] = true;
							DDSaleTimer[playerid] = defer DDSaleTimerEx(playerid);
							return 1;
						}
					}
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_DDSALEPRICE:
		{
			switch(response)
			{
				case false: return ShowDynamicDoorDialog(playerid);
				case true:
				{
					if(!IsPlayerConnected(DDSaleTarget[playerid]) || DDSaleTarget[playerid] == INVALID_PLAYER_ID)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified buyer is no longer connected.");
						ClearDoorSaleVariables(playerid);
						return 1;
					}
					if(DDSalePendingPlayer[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "Your dynamic door sale is pending approval from the specified buyer.");
					if(DDSalePendingAdmin[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "Your dynamic door sale is pending approval from server administration.");
					new price, fine;
					if(sscanf(inputtext, "d", price))
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified dynamic door sale price must be numerical.");
						ShowPlayerDialogEx(playerid, DIALOG_DDSALEPRICE, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input the total price of the sale below.", "Okay", "Cancel");
						return 1;
					}
					if(price < 1 || price > 1000000000)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified dynamic door sale price cannot be under $1 or over $1,000,000,000.");
						ShowPlayerDialogEx(playerid, DIALOG_DDSALEPRICE, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input the total price of the sale below.", "Okay", "Cancel");
						return 1;
					}
					if(GetPlayerCash(DDSaleTarget[playerid]) < price)
					{
						format(string, sizeof(string), "%s does not have enough money for the transaction ($%s).", GetPlayerNameEx(DDSaleTarget[playerid]), number_format(price));
						SendClientMessageEx(playerid, COLOR_GREY, string);
						ShowPlayerDialogEx(playerid, DIALOG_DDSALEPRICE, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input the total price of the sale below.", "Okay", "Cancel");
						return 1;
					}
					fine = CalculatePercentage(price, 10, 1000000);
					if(GetPlayerCash(playerid) < fine)
					{
						format(string, sizeof(string), "You do not have the sufficient funds for the transfer fine ($%s).", number_format(fine));
						SendClientMessageEx(playerid, COLOR_GREY, string);
						ShowPlayerDialogEx(playerid, DIALOG_DDSALEPRICE, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input the total price of the sale below.", "Okay", "Cancel");
						return 1;
					}
					DDSalePrice[playerid] = price;
					SendClientMessageEx(playerid, COLOR_GREEN, "You have updated your dynamic door sale price.");
					ShowDynamicDoorDialog(playerid);
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_DDSALELINK:
		{
			switch(response)
			{
				case false: return ShowDynamicDoorDialog(playerid);
				case true:
				{
					if(!IsPlayerConnected(DDSaleTarget[playerid]) || DDSaleTarget[playerid] == INVALID_PLAYER_ID)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified buyer is no longer connected.");
						ClearDoorSaleVariables(playerid);
						return 1;
					}
					if(DDSalePendingPlayer[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "Your dynamic door sale is pending approval from the specified buyer.");
					if(DDSalePendingAdmin[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "Your dynamic door sale is pending approval from server administration.");
					new doorid;
					if(sscanf(inputtext, "d", doorid))
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified door ID must be numerical.");
						ShowPlayerDialogEx(playerid, DIALOG_DDSALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the dynamic door you would like to link to the sale. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
						return 1;
					}
					if(doorid < 0 || doorid >= MAX_DDOORS)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Invalid door ID specified.");
						ShowPlayerDialogEx(playerid, DIALOG_DDSALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the dynamic door you would like to link to the sale. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
						return 1;
					}
					for(new i = 0; i < sizeof(DDSaleDoors[]); i ++)
					{
						if(DDSaleDoors[playerid][i] == doorid && doorid != 0)
						{
							SendClientMessageEx(playerid, COLOR_GREY, "The specified dynamic door is already linked to your sale.");
							ShowPlayerDialogEx(playerid, DIALOG_DDSALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the dynamic door you would like to link to the sale. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
							return 1;
						}
					}
					switch(doorid)
					{
						case 0:
						{
							if(DDSaleDoors[playerid][DDSaleTracking[playerid]] == 0)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not currently have a linked dynamic door in the specified slot.");
								ShowPlayerDialogEx(playerid, DIALOG_DDSALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the dynamic door you would like to link to the sale. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
								return 1;
							}
							DDSaleDoors[playerid][DDSaleTracking[playerid]] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "You have updated/removed the linked dynamic door(s) to your sale.");
							ShowDynamicDoorDialog(playerid);
							return 1;
						}
						default:
						{
							if(DDoorsInfo[doorid][ddOwner] != GetPlayerSQLId(playerid))
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not own the specified dynamic door.");
								ShowPlayerDialogEx(playerid, DIALOG_DDSALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the dynamic door you would like to link to the sale. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
								return 1;
							}
							DDSaleDoors[playerid][DDSaleTracking[playerid]] = doorid;
							SendClientMessageEx(playerid, COLOR_GREEN, "You have updated the linked dynamic door(s) to your sale.");
							ShowDynamicDoorDialog(playerid);
							return 1;
						}
					}
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_GARAGESALELINK:
		{
			switch(response)
			{
				case false: return ShowDynamicDoorDialog(playerid);
				case true:
				{
					if(!IsPlayerConnected(DDSaleTarget[playerid]) || DDSaleTarget[playerid] == INVALID_PLAYER_ID)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified buyer is no longer connected.");
						ClearDoorSaleVariables(playerid);
						return 1;
					}
					if(DDSalePendingPlayer[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "Your dynamic door sale is pending approval from the specified buyer.");
					if(DDSalePendingAdmin[playerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "Your dynamic door sale is pending approval from server administration.");
					new garageid;
					if(sscanf(inputtext, "d", garageid))
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified garage ID must be numerical.");
						ShowPlayerDialogEx(playerid, DIALOG_GARAGESALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the garage you would like to link to the sale. Input \"0\" to remove a garage.", "Okay", "Cancel");
						return 1;
					}
					if(garageid < 0 || garageid >= MAX_GARAGES)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Invalid garage ID specified.");
						ShowPlayerDialogEx(playerid, DIALOG_GARAGESALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the garage you would like to link to the sale. Input \"0\" to remove a garage.", "Okay", "Cancel");
						return 1;
					}
					if(garageid == 0)
					{
						DDSaleDoors[playerid][DDSaleTracking[playerid]] = 0;
						ShowDynamicDoorDialog(playerid);
						return 1;
					}
					for(new i = 0; i < sizeof(DDSaleDoors[]); i ++)
					{
						if(DDSaleDoors[playerid][i] == garageid && garageid != 0)
						{
							SendClientMessageEx(playerid, COLOR_GREY, "The specified garage is already linked to your sale.");
							ShowPlayerDialogEx(playerid, DIALOG_GARAGESALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the garage you would like to link to the sale. Input \"0\" to remove a garage.", "Okay", "Cancel");
							return 1;
						}
					}
					switch(garageid)
					{
						case 0:
						{
							if(DDSaleDoors[playerid][DDSaleTracking[playerid]] == 0)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not currently have a linked garage in the specified slot.");
								ShowPlayerDialogEx(playerid, DIALOG_GARAGESALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the garage you would like to link to the sale. Input \"0\" to remove a garage.", "Okay", "Cancel");
								return 1;
							}
							DDSaleDoors[playerid][DDSaleTracking[playerid]] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "You have updated/removed the linked garage(s) to your sale.");
							ShowDynamicDoorDialog(playerid);
							return 1;
						}
						default:
						{
							if(GarageInfo[garageid][gar_Owner] != GetPlayerSQLId(playerid))
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not own the specified garage.");
								ShowPlayerDialogEx(playerid, DIALOG_GARAGESALELINK, DIALOG_STYLE_INPUT, "Dynamic Door Selling", "Input below the ID of the garage you would like to link to the sale. Input \"0\" to remove a garage.", "Okay", "Cancel");
								return 1;
							}
							DDSaleDoors[playerid][DDSaleTracking[playerid]] = garageid;
							SendClientMessageEx(playerid, COLOR_GREEN, "You have updated the linked garage(s) to your sale.");
							ShowDynamicDoorDialog(playerid);
							return 1;
						}
					}
					return 1;
				}
			}
			return 1;
		}
	}
	return 0;
}