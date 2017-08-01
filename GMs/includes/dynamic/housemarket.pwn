#include <YSI\y_hooks>

#define MAX_LISTINGS_PER_PAGE (35)

hook OnPlayerConnect(playerid)
{
	AdTracking[playerid] = 0;
	HouseMarketTracking[playerid] = 0;
	ClearDoorSaleVariables(playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	for(new i = 0; i < sizeof(HouseInfo); i ++) if(HouseInfo[i][hOwnerID] == GetPlayerSQLId(playerid) && HouseInfo[i][Listed] == 1 && HouseInfo[i][PendingApproval] == 1) ClearHouseSaleVariables(i);
	foreach(new i : Player)
	{
		if(DDSaleTarget[i] == playerid && i != playerid)
		{
			SendClientMessageEx(i, COLOR_GREY, "The person purchasing your dynamic doors has disconnected.");
			ClearDoorSaleVariables(i);
			break;
		}
	}
	return 1;
}

ClearHouseSaleVariables(houseid)
{
	HouseInfo[houseid][Listed] = 0;
	HouseInfo[houseid][PendingApproval] = 0;
	HouseInfo[houseid][ListedTimeStamp] = 0;
	HouseInfo[houseid][ListingPrice] = 0;
	for(new i = 0; i < 5; i ++)
	{
		if(i < 2) HouseInfo[houseid][LinkedGarage][i] = 0;
		HouseInfo[houseid][LinkedDoor][i] = 0;
	}
	strcpy(HouseInfo[houseid][ListingDescription], "N/A", 128);
	SaveHouse(houseid);
	return 1;
}

ShowListingInformation(playerid, houseid, dialogid)
{
	new count[3];
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "General Information:\n\n  » House ID: %d\n  » Price: $%s\n  » Seller: %s", houseid, number_format(HouseInfo[houseid][ListingPrice]), StripUnderscore(HouseInfo[houseid][hOwnerName]));
	if(strcmp("N/A", HouseInfo[houseid][ListingDescription], true) != 0) format(szMiscArray, sizeof(szMiscArray), "%s\n  » Description: %s", szMiscArray, HouseInfo[houseid][ListingDescription]);
	format(szMiscArray, sizeof(szMiscArray), "%s\n  » Expiry: %s", szMiscArray, date(HouseInfo[houseid][ListedTimeStamp], 4));
	strcat(szMiscArray, "\n\nLinked Dynamic Doors:\n");
	for(new i = 0; i < 5; i ++)
	{
		if(HouseInfo[houseid][LinkedDoor][i] != 0 && DDoorsInfo[HouseInfo[houseid][LinkedDoor][i]][ddOwner] == HouseInfo[houseid][hOwnerID]) 
		{
			format(szMiscArray, sizeof(szMiscArray), "%s\n  » Door ID: %d (%s)", szMiscArray, HouseInfo[houseid][LinkedDoor][i], DDoorsInfo[HouseInfo[houseid][LinkedDoor][i]][ddDescription]);
			count[0] ++;
		}
	}
	if(count[0] == 0) strcat(szMiscArray, "\n  » None");
	strcat(szMiscArray, "\n\nLinked Dynamic Gates:\n");
	for(new i = 0; i < sizeof(GateInfo); i ++)
	{
		if(GateInfo[i][gHID] == houseid) 
		{
			format(szMiscArray, sizeof(szMiscArray), "%s\n  » Gate ID: %d", szMiscArray, i);
			count[1] ++;
		}
	}
	if(count[1] == 0) strcat(szMiscArray, "\n  » None");
	strcat(szMiscArray, "\n\nLinked Garages:\n");
	for(new i = 0; i < 2; i ++)
	{
		if(HouseInfo[houseid][LinkedGarage][i] != 0 && GarageInfo[HouseInfo[houseid][LinkedGarage][i]][gar_Owner] == HouseInfo[houseid][hOwnerID]) 
		{
			format(szMiscArray, sizeof(szMiscArray), "%s\n  » Garage ID: %d", szMiscArray, HouseInfo[houseid][LinkedGarage][i]);
			count[2] ++;
		}
	}
	if(count[2] == 0) strcat(szMiscArray, "\n  » None");
	ShowPlayerDialogEx(playerid, dialogid, DIALOG_STYLE_MSGBOX, "House Listing Information", szMiscArray, "Okay", "Cancel");
	return 1;
}

GetNearestOwnedHouse(playerid)
{
	for(new i = 0; i < sizeof(HouseInfo); i ++) if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW]) return i;
	return -1;
}

ShowMainListingDialog(playerid)
{
	new houseid;
	szMiscArray[0] = 0;
	houseid = GetNearestOwnedHouse(playerid);
	if(houseid == -1) return 1;
	format(szMiscArray, sizeof(szMiscArray), "Setting\tValue\nPrice\t$%s\nLinked Door 1\t%s\nLinked Door 2\t%s\nLinked Door 3\t%s\nLinked Door 4\t%s\nLinked Door 5\t%s\nLinked Garage 1\t%s\nLinked Garage 2\t%s\nDescription\t%s\nFinalize And Submit",
	number_format(HouseInfo[houseid][ListingPrice]), ReturnDoorLineDetails(playerid, HouseInfo[houseid][LinkedDoor][0]),
	ReturnDoorLineDetails(playerid, HouseInfo[houseid][LinkedDoor][1]), ReturnDoorLineDetails(playerid, HouseInfo[houseid][LinkedDoor][2]),
	ReturnDoorLineDetails(playerid, HouseInfo[houseid][LinkedDoor][3]), ReturnDoorLineDetails(playerid, HouseInfo[houseid][LinkedDoor][4]), 
	ReturnGarageLineDetails(playerid, HouseInfo[houseid][LinkedGarage][0]), ReturnGarageLineDetails(playerid, HouseInfo[houseid][LinkedGarage][1]), HouseInfo[houseid][ListingDescription]);
	ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEMAIN, DIALOG_STYLE_TABLIST_HEADERS, "House Market", szMiscArray, "Okay", "Cancel");
	return 1;
}

AdditionalAdvertisements(index)
{
	for(new i = index; i < sizeof(HouseInfo); i ++) if(HouseInfo[i][Listed] == 1 && HouseInfo[i][PendingApproval] == 0) return true;
	return false;
}

task HouseMarket[60000]()
{
	new bool:notification;
	for(new i = 0; i < sizeof(HouseInfo); i ++)
	{
		if(HouseInfo[i][Listed] == 1)
		{
			switch(HouseInfo[i][PendingApproval])
			{
				case 0:
				{
					if(gettime() >= HouseInfo[i][ListedTimeStamp])
					{
						ClearHouseSaleVariables(i);
						foreach(new p: Player) 
						{
							if(gPlayerLogged{p} == 1 && HouseInfo[i][hOwnerID] == GetPlayerSQLId(p))
							{
								SendClientMessageEx(p, COLOR_GREY, "Your house listing has expired and has been removed from the market.");
								break;
							}
						}
					}
				}
				case 1:
				{
					if(notification == false)
					{
						ABroadCast(COLOR_LIGHTRED, "One or more house listing(s) are pending review.", 4, true);
						notification = true;
					}
				}
			}
		}
	}
	return 1;
}

CMD:al(playerid, params[]) return cmd_approvelisting(playerid, params);
CMD:dli(playerid, params[]) return cmd_denylisting(playerid, params);

CMD:houselistinghelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_WHITE, "** HOUSE LISTING COMMANDS **");
	SendClientMessageEx(playerid, COLOR_GREY, "» /listhouse - Allows you to place a house listing ($500,000).");
	SendClientMessageEx(playerid, COLOR_GREY, "» /renewlisting - Allows you to renew an active house listing ($100,000).");
	SendClientMessageEx(playerid, COLOR_GREY, "» /listingdate - Allows you to view the date your house listing will expire on.");
	SendClientMessageEx(playerid, COLOR_GREY, "» /deletelisting - Allows you to delete a house listing you placed previously.");
	SendClientMessageEx(playerid, COLOR_GREY, "» /houselistings - Allows you to view a list of active house listings.");
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "» {EE9A4D}SENIOR ADMIN{D8D8D8} /pendinglistings - Allows you to view a list of active house listings pending administrative approval.");
		SendClientMessageEx(playerid, COLOR_GREY, "» {EE9A4D}SENIOR ADMIN{D8D8D8} /listingdetails [House ID] - Allows you view the details of a specified and pending house listing.");
		SendClientMessageEx(playerid, COLOR_GREY, "» {EE9A4D}SENIOR ADMIN{D8D8D8} /(a)pprove(l)isting [House ID] - Allows you to approve the specified pending house listing.");
		SendClientMessageEx(playerid, COLOR_GREY, "» {EE9A4D}SENIOR ADMIN{D8D8D8} /(d)eny(li)sting [House ID] - Allows you to deny the specified pending house listing.");
		SendClientMessageEx(playerid, COLOR_GREY, "» {EE9A4D}SENIOR ADMIN{D8D8D8} /adeletelisting [House ID] - Allows you to delete the specified pending house listing.");
		SendClientMessageEx(playerid, COLOR_GREY, "* NOTICE: Using the (/admute) command will deny players the ability to post housing listings. *");
	}
	return 1;
}

CMD:denylisting(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new houseid, reason[64], string[128];
	if(sscanf(params, "ds[64]", houseid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /denylisting [House ID] [Reason]");
	if(houseid < 1 || houseid >= MAX_HOUSES)
	{
		format(szMiscArray, sizeof(szMiscArray), "The specified house ID must be between 1 and %d.", MAX_HOUSES - 1);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
		return 1;
	}
	if(strlen(reason) < 3 || strlen(reason) > 60) return SendClientMessageEx(playerid, COLOR_GREY, "The specified reason cannot be under 3 characters or over 60 characters.");
	if(HouseInfo[houseid][hOwned] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently owned.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently pending approval to be listed.");
	ClearHouseSaleVariables(houseid);
	format(string, sizeof(string), "You have denied house ID %d's house listing request (owner: %s), reason: %s.", houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]), reason);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	foreach(new i: Player) 
	{
		if(gPlayerLogged{i} == 1 && HouseInfo[houseid][hOwnerID] == GetPlayerSQLId(i))
		{
			format(string, sizeof(string), "%s denied your house listing request (house ID %d), reason: %s.", GetPlayerNameEx(playerid), houseid, reason);
			SendClientMessageEx(i, COLOR_LIGHTRED, string);
			break;
		}
	}
	PlayerInfo[playerid][pTrashReport] ++;
	format(string, sizeof(string), "AdmCmd: %s denied house ID %d's house listing request (owner: %s), reason: %s.", GetPlayerNameEx(playerid), houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]), reason);
	ABroadCast(COLOR_LIGHTRED, string, 4);
	Log("logs/admin.log", string);
	return 1;
}

CMD:approvelisting(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new houseid, seller, string[128];
	if(sscanf(params, "d", houseid)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /approvelisting [House ID]");
	if(houseid < 1 || houseid >= MAX_HOUSES)
	{
		format(szMiscArray, sizeof(szMiscArray), "The specified house ID must be between 1 and %d.", MAX_HOUSES - 1);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
		return 1;
	}
	if(HouseInfo[houseid][hOwned] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently owned.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently pending approval to be listed.");
	seller = INVALID_PLAYER_ID;
	foreach(new i: Player) 
	{
		if(gPlayerLogged{i} == 1 && HouseInfo[houseid][hOwnerID] == GetPlayerSQLId(i))
		{
			seller = i;
			break;
		}
	}
	switch(seller)
	{
		case INVALID_PLAYER_ID:
		{
			PlayerInfo[playerid][pAcceptReport] ++;
			ReportCount[playerid] ++;
			ReportHourCount[playerid] ++;
			format(string, sizeof(string), "House ID %d's listing is currently bugged, the listing has been removed.", houseid);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
			return 1;
		}
		default:
		{
			if(GetPlayerCash(seller) < 500000)
			{
				ClearHouseSaleVariables(houseid);
				SendClientMessageEx(seller, COLOR_GREY, "Your house listing has been approved by an administrator, however you no longer have $500,000.");
				SendClientMessageEx(seller, COLOR_GREY, "Your house listing has not been placed on the market as you could not afford the initial posting fee.");
				PlayerInfo[playerid][pAcceptReport] ++;
				ReportCount[playerid] ++;
				ReportHourCount[playerid] ++;
				format(string, sizeof(string), "You have approved house ID %d's house listing request (insufficient funds - owner: %s).", houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string), "AdmCmd: %s approved house ID %d's house listing request (insufficient funds - owner: %s).", GetPlayerNameEx(playerid), houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
				ABroadCast(COLOR_LIGHTRED, string, 4);
				Log("logs/admin.log", string);
				return 1;
			}
			else if(GetPlayerCash(seller) >= 500000)
			{
				GivePlayerCashEx(seller, TYPE_ONHAND, -500000);
				HouseInfo[houseid][PendingApproval] = 0;
				HouseInfo[houseid][ListedTimeStamp] = gettime() + 259200;
				SaveHouse(houseid);
				SendClientMessageEx(seller, COLOR_GREEN, "Your house listing has been approved by an administrator, you have been charged $500,000.");
				PlayerInfo[playerid][pAcceptReport] ++;
				ReportCount[playerid] ++;
				ReportHourCount[playerid] ++;
				format(string, sizeof(string), "You have approved house ID %d's house listing request (owner: %s).", houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string), "AdmCmd: %s approved house ID %d's house listing request (owner: %s).", GetPlayerNameEx(playerid), houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
				ABroadCast(COLOR_LIGHTRED, string, 4);
				Log("logs/admin.log", string);
				return 1;
			}
			return 1;
		}
	}
	return 1;
}

CMD:adeletelisting(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new houseid, string[128];
	if(sscanf(params, "d", houseid)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /adeletelisting [House ID]");
	if(houseid < 1 || houseid >= MAX_HOUSES)
	{
		format(szMiscArray, sizeof(szMiscArray), "The specified house ID must be between 1 and %d.", MAX_HOUSES - 1);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
		return 1;
	}
	if(HouseInfo[houseid][hOwned] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently owned.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently listed.");
	ClearHouseSaleVariables(houseid);
	format(string, sizeof(string), "You have deleted house ID %d's listing (owner: %s).", houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "AdmCmd: %s deleted house ID %d's house listing (owner: %s).", GetPlayerNameEx(playerid), houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
	ABroadCast(COLOR_LIGHTRED, string, 4);
	Log("logs/admin.log", string);
	return 1;
}

CMD:listingdetails(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new houseid;
	if(sscanf(params, "d", houseid)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /listingdetails [House ID]");
	szMiscArray[0] = 0;
	if(houseid < 1 || houseid >= MAX_HOUSES)
	{
		format(szMiscArray, sizeof(szMiscArray), "The specified house ID must be between 1 and %d.", MAX_HOUSES - 1);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
		return 1;
	}
	if(HouseInfo[houseid][hOwned] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently owned.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently pending approval to be listed.");
	ShowListingInformation(playerid, houseid, DIALOG_LISTINGINFORMATION);
	return 1;
}

CMD:pendinglistings(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new count, string[64];
	SendClientMessageEx(playerid, COLOR_WHITE, "** HOUSE LISTINGS PENDING APPROVAL: **");
	for(new i = 0; i < sizeof(HouseInfo); i ++)
	{
		if(HouseInfo[i][hOwned] == 1 && HouseInfo[i][Listed] == 1 && HouseInfo[i][PendingApproval] == 1)
		{
			format(string, sizeof(string), "(House ID: %d) Owner: %s", i, StripUnderscore(HouseInfo[i][hOwnerName]));
			SendClientMessageEx(playerid, COLOR_GREY, string);
			count ++;
		}
	}
	if(count == 0) return SendClientMessageEx(playerid, COLOR_GREY, "There are not currently any house listings pending approval.");
	return 1;
}

CMD:listhouse(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
	if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
	if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least $500,000 to place a house listing.");
	new houseid;
	if(servernumber == 2) return SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	houseid = GetNearestOwnedHouse(playerid);
	if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a house that you own.");
	if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is already listed on the house market.");
	HouseInfo[houseid][ListingPrice] = 0;
	HouseInfo[houseid][PendingApproval] = 0;
	HouseInfo[houseid][ListedTimeStamp] = 0;
	for(new i = 0; i < 5; i ++) 
	{
		if(i < 2) HouseInfo[houseid][LinkedGarage][i] = 0;
		HouseInfo[houseid][LinkedDoor][i] = 0;
	}
	strcpy(HouseInfo[houseid][ListingDescription], "N/A", 128);
	SaveHouse(houseid);
	ShowMainListingDialog(playerid);	
    return 1;
}

CMD:listingdate(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
	new houseid, string[128];
	if(servernumber == 2) return SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	houseid = GetNearestOwnedHouse(playerid);
	if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a house that you own.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is not currently listed on the house market.");
	format(string, sizeof(string), "Your house listing will expire on %s.", date(HouseInfo[houseid][ListedTimeStamp], 4));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
    return 1;
}

CMD:renewlisting(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
	if(GetPlayerCash(playerid) < 100000) return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least $100,000 to renew your house listing.");
	new houseid, string[128];
	if(servernumber == 2) return SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	houseid = GetNearestOwnedHouse(playerid);
	if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a house that you own.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is not currently listed on the house market.");
	HouseInfo[houseid][ListedTimeStamp] += 86400;
	SaveHouse(houseid);
	format(string, sizeof(string), "You have renewed your house listing by a day, it will expire on %s.", date(HouseInfo[houseid][ListedTimeStamp], 4));
	SendClientMessageEx(playerid, COLOR_GREEN, string);
	GivePlayerCashEx(playerid, TYPE_ONHAND, -100000);
    return 1;
}

CMD:deletelisting(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
	new houseid;
	if(servernumber == 2) return SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	houseid = GetNearestOwnedHouse(playerid);
	if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a house that you own.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is not currently listed on the house market.");
	ClearHouseSaleVariables(houseid);
	SendClientMessageEx(playerid, COLOR_GREY, "You have taken your house listing off of the market.");
    return 1;
}

CMD:houselistings(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
	new count[4], location[MAX_ZONE_NAME];
	szMiscArray[0] = 0;
	for(new i = 0; i < sizeof(HouseInfo); i ++)
	{
		if(HouseInfo[i][hOwned] == 1 && HouseInfo[i][Listed] == 1 && HouseInfo[i][PendingApproval] == 0)
		{
			location = "San Andreas";
			for(new l = 1; l < sizeof(count); l ++) count[l] = 0;
			for(new l = 0; l < 5; l ++) 
			{
				if(l < 2) if(HouseInfo[i][LinkedGarage][l] != 0) count[3] ++;
				if(HouseInfo[i][LinkedDoor][l] != 0) count[1] ++;
			}
			for(new l = 0; l < sizeof(GateInfo); l ++) if(GateInfo[l][gHID] == i) count[2] ++;
			Get3DZone(HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ], location, sizeof(location));
			format(szMiscArray, sizeof(szMiscArray), "%s\n(%d) [$%s] [%s] [%d DD(s)] [%d DG(s)] [%d G(s)]", szMiscArray, i, number_format(HouseInfo[i][ListingPrice]), location, count[1], count[2], count[3]);
			AdTracking[playerid] = i;
			count[0] ++;
		}
		if(count[0] == MAX_LISTINGS_PER_PAGE) break;
	}
	if(count[0] == 0) return SendClientMessage(playerid, COLOR_GREY, "There are no active advertisements at this time.");
	if(count[0] == MAX_LISTINGS_PER_PAGE) format(szMiscArray, sizeof(szMiscArray), "%s\n[Next Page...]", szMiscArray);
	ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSELISTINGS, DIALOG_STYLE_LIST, "House Listings", szMiscArray, "Okay", "Cancel");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	new string[128];
	switch(dialogid)
	{
		case DIALOG_LISTHOUSEMAIN:
		{
			new houseid;
			houseid = GetNearestOwnedHouse(playerid);
			switch(response)
			{
				case false: if(houseid != -1)  return ClearHouseSaleVariables(houseid);
				case true:
				{
					if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
					if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
					if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
					if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
					if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
					if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
					if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least $500,000 to place a house listing.");
					if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a house that you own.");
					if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is already listed on the house market.");
					switch(listitem)
					{
						case 0: return ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEPRICE, DIALOG_STYLE_INPUT, "House Listings", "Input the price of your listing below.", "Okay", "Cancel");
						case 1..5:
						{
							HouseMarketTracking[playerid] = listitem - 1;
							ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
							return 1;
						}
						case 6, 7:
						{
							HouseMarketTracking[playerid] = listitem - 6;
							ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
							return 1;
						}
						case 8: return ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDESCRIPTION, DIALOG_STYLE_INPUT, "House Listings", "Input the description of your listing below.", "Okay", "Cancel");
						case 9:
						{
							if(HouseInfo[houseid][ListingPrice] == 0)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You must specify a price before submitting your listing.");
								ShowMainListingDialog(playerid);
								return 1;
							}
							for(new i = 0; i < 5; i ++) 
							{
								if(i < 2) if(HouseInfo[houseid][LinkedGarage][i] != 0 && GetPlayerSQLId(playerid) != GarageInfo[HouseInfo[houseid][LinkedGarage][i]][gar_Owner]) HouseInfo[houseid][LinkedGarage][i] = 0;
								if(HouseInfo[houseid][LinkedDoor][i] != 0 && GetPlayerSQLId(playerid) != DDoorsInfo[HouseInfo[houseid][LinkedDoor][i]][ddOwner]) HouseInfo[houseid][LinkedDoor][i] = 0;
							}
							HouseInfo[houseid][Listed] = 1;
							HouseInfo[houseid][PendingApproval] = 1;
							SaveHouse(houseid);
							SendClientMessageEx(playerid, COLOR_GREEN, "Your housing listing has been submitted for review by server administration.");
							format(string, sizeof(string), "[New House Listing Request]: House ID %d, Owner: %s.", houseid, GetPlayerNameEx(playerid));
							ABroadCast(COLOR_LIGHTRED, string, 4);
							return 1;
						}
					}
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTHOUSEPRICE:
		{
			switch(response)
			{
				case false: return ShowMainListingDialog(playerid);
				case true:
				{
					if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
					if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
					if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
					if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
					if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
					if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
					if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least $500,000 to place a house listing.");
					new houseid, price;
					houseid = GetNearestOwnedHouse(playerid);
					if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a house that you own.");
					if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is already listed on the house market.");
					if(sscanf(inputtext, "d", price))
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified price must be numerical.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEPRICE, DIALOG_STYLE_INPUT, "House Listings", "Input the price of your listing below.", "Okay", "Cancel");
						return 1;
					}
					if(price < 100000 || price > 500000000)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified price cannot be under $100,000 or over $500,000,000.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEPRICE, DIALOG_STYLE_INPUT, "House Listings", "Input the price of your listing below.", "Okay", "Cancel");
						return 1;
					}
					if(price == HouseInfo[houseid][ListingPrice])
					{
						format(string, sizeof(string), "Your listing price is already set to $%s.", number_format(price));
						SendClientMessageEx(playerid, COLOR_GREY, string);
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEPRICE, DIALOG_STYLE_INPUT, "House Listings", "Input the price of your listing below.", "Okay", "Cancel");
						return 1;
					}
					HouseInfo[houseid][ListingPrice] = price;
					SaveHouse(houseid);
					SendClientMessageEx(playerid, COLOR_WHITE, "You have updated your listing price.");
					ShowMainListingDialog(playerid);
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTHOUSEDESCRIPTION:
		{
			switch(response)
			{
				case false: return ShowMainListingDialog(playerid);
				case true:
				{
					if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
					if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
					if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
					if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
					if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
					if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
					if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least $500,000 to place a house listing.");
					new houseid;
					houseid = GetNearestOwnedHouse(playerid);
					if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a house that you own.");
					if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is already listed on the house market.");
					if(strlen(inputtext) < 1 || strlen(inputtext) > 128)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The listing description cannot be under 1 character or over 128 characters.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDESCRIPTION, DIALOG_STYLE_INPUT, "House Listings", "Input the description of your listing below.", "Okay", "Cancel");
						return 1;
					}
					if(strcmp(inputtext, HouseInfo[houseid][ListingDescription], false) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The description you have specified is already set the set description.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDESCRIPTION, DIALOG_STYLE_INPUT, "House Listings", "Input the description of your listing below.", "Okay", "Cancel");
						return 1;
					}
					for(new i = 0; i < strlen(inputtext) - 7; i ++)
					{
						if(inputtext[i] == '{' && inputtext[i + 7] == '}')
						{
							strmid(string, inputtext, i + 1, i + 7);
							if(ishex(string))
							{
								strdel(inputtext, i, i + 8);
								continue;
							}
						}
					}
					strcpy(HouseInfo[houseid][ListingDescription], inputtext, 128);
					SaveHouse(houseid);
					SendClientMessageEx(playerid, COLOR_WHITE, "You have updated your listing description.");
					ShowMainListingDialog(playerid);
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTHOUSEDOORS:
		{
			switch(response)
			{
				case false: return ShowMainListingDialog(playerid);
				case true:
				{
					if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
					if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
					if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
					if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
					if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
					if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
					if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least $500,000 to place a house listing.");
					new houseid, doorid;
					houseid = GetNearestOwnedHouse(playerid);
					if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a house that you own.");
					if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is already listed on the house market.");
					if(sscanf(inputtext, "d", doorid))
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified door ID must be numerical.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
						return 1;
					}
					if(doorid < 0 || doorid >= MAX_DDOORS)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Invalid door ID specified.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
						return 1;
					}
					for(new i = 0; i < 5; i ++)
					{
						if(HouseInfo[houseid][LinkedDoor][i] == doorid && doorid != 0)
						{
							SendClientMessageEx(playerid, COLOR_GREY, "The specified dynamic door is already linked to your listing.");
							ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
							return 1;
						}
					}
					switch(doorid)
					{
						case 0:
						{
							if(HouseInfo[houseid][LinkedDoor][HouseMarketTracking[playerid]] == 0)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not currently have a linked dynamic door in the specified slot.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
								return 1;
							}
							HouseInfo[houseid][LinkedDoor][HouseMarketTracking[playerid]] = 0;
							SaveHouse(houseid);
							SendClientMessageEx(playerid, COLOR_WHITE, "You have updated/removed the dynamic door(s) linked to your listing.");
							ShowMainListingDialog(playerid);
							return 1;
						}
						default:
						{
							if(DDoorsInfo[doorid][ddOwner] != GetPlayerSQLId(playerid))
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not own the specified dynamic door.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
								return 1;
							}
							if(HouseInfo[houseid][hIntIW] != DDoorsInfo[doorid][ddInteriorInt] || HouseInfo[houseid][hIntVW] != DDoorsInfo[doorid][ddInteriorVW])
							{
								SendClientMessageEx(playerid, COLOR_GREY, "The specified dynamic door is not linked to your house.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
								return 1;
							}
							HouseInfo[houseid][LinkedDoor][HouseMarketTracking[playerid]] = doorid;
							SaveHouse(houseid);
							SendClientMessageEx(playerid, COLOR_WHITE, "You have updated the dynamic door(s) linked to your listing.");
							ShowMainListingDialog(playerid);
							return 1;
						}
					}
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTHOUSEGARAGES:
		{
			switch(response)
			{
				case false: return ShowMainListingDialog(playerid);
				case true:
				{
					if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
					if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
					if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
					if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
					if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
					if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
					if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least $500,000 to place a house listing.");
					new houseid, garageid;
					houseid = GetNearestOwnedHouse(playerid);
					if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a house that you own.");
					if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is already listed on the house market.");
					if(sscanf(inputtext, "d", garageid))
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified garage ID must be numerical.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
						return 1;
					}
					if(garageid < 0 || garageid >= MAX_GARAGES)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Invalid garage ID specified.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
						return 1;
					}
					for(new i = 0; i < 2; i ++)
					{
						if(HouseInfo[houseid][LinkedGarage][i] == garageid && garageid != 0)
						{
							SendClientMessageEx(playerid, COLOR_GREY, "The specified garage is already linked to your listing.");
							ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
							return 1;
						}
					}
					switch(garageid)
					{
						case 0:
						{
							if(HouseInfo[houseid][LinkedGarage][HouseMarketTracking[playerid]] == 0)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not currently have a linked garage in the specified slot.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
								return 1;
							}
							HouseInfo[houseid][LinkedGarage][HouseMarketTracking[playerid]] = 0;
							SaveHouse(houseid);
							SendClientMessageEx(playerid, COLOR_WHITE, "You have updated/removed the gate(s) linked to your listing.");
							ShowMainListingDialog(playerid);
							return 1;
						}
						default:
						{
							if(DDoorsInfo[garageid][ddOwner] != GetPlayerSQLId(playerid))
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not own the specified garage.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
								return 1;
							}
							HouseInfo[houseid][LinkedGarage][HouseMarketTracking[playerid]] = garageid;
							SaveHouse(houseid);
							SendClientMessageEx(playerid, COLOR_WHITE, "You have updated the garage(s) linked to your listing.");
							ShowMainListingDialog(playerid);
							return 1;
						}
					}
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTHOUSELISTINGS:
		{
			if(response)
			{
				if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
				if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
				if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
				if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
				if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
				szMiscArray[0] = 0;
				new houseid, position[2], count[4], location[MAX_ZONE_NAME];
				if(strcmp(inputtext, "[Next Page...]", true) == 0)
				{
					for(new i = AdTracking[playerid] + 1; i < sizeof(HouseInfo); i ++)
					{
						if(HouseInfo[i][hOwned] == 1 && HouseInfo[i][Listed] == 1 && HouseInfo[i][PendingApproval] == 0)
						{
							location = "San Andreas";
							for(new l = 1; l < sizeof(count); l ++) count[l] = 0;
							for(new l = 0; l < 5; l ++) 
							{
								if(l < 2) if(HouseInfo[i][LinkedGarage][l] != 0) count[3] ++;
								if(HouseInfo[i][LinkedDoor][l] != 0) count[1] ++;
							}
							for(new l = 0; l < sizeof(GateInfo); l ++) if(GateInfo[l][gHID] == i) count[2] ++;
							Get3DZone(HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ], location, sizeof(location));
							format(szMiscArray, sizeof(szMiscArray), "%s\n(%d) [$%s] [%s] [%d DD(s)] [%d DG(s)] [%d G(s)]", szMiscArray, i, number_format(HouseInfo[i][ListingPrice]), location, count[1], count[2], count[3]);
							AdTracking[playerid] = i;
							count[0] ++;
						}
						if(count[0] == MAX_LISTINGS_PER_PAGE) break;
					}
					if(count[0] == 0) return SendClientMessage(playerid, COLOR_GREY, "There are no active advertisements at this time.");
					if(count[0] == MAX_LISTINGS_PER_PAGE && AdditionalAdvertisements(AdTracking[playerid] + 1)) strcat(szMiscArray, "\n[Next Page...]");
					ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSELISTINGS, DIALOG_STYLE_LIST, "House Listings", szMiscArray, "Okay", "Cancel");
					return 1;
				}
				position[0] = strfind(inputtext, "(");
				position[1] = strfind(inputtext, ")");
				strmid(string, inputtext, position[0] + 1, position[1]);
				houseid = strval(string);
				if(HouseInfo[houseid][hOwned] == 0 || HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 1)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently for sale.");
					cmd_houselistings(playerid, "");
					return 1;
				}
				HouseMarketTracking[playerid] = houseid;
				ShowListingInformation(playerid, houseid, DIALOG_SELECTEDLISTING);
				return 1;
			}
		}
		case DIALOG_SELECTEDLISTING:
		{
			if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
			if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
			if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
			if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
			if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
			switch(response)
			{
				case false: return cmd_houselistings(playerid, "");
				case true: 
				{
					if(HouseInfo[HouseMarketTracking[playerid]][hOwned] == 0 || HouseInfo[HouseMarketTracking[playerid]][Listed] == 0 || HouseInfo[HouseMarketTracking[playerid]][PendingApproval] == 1)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently for sale.");
						cmd_houselistings(playerid, "");
						return 1;
					}
					ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "House Listings", "Visit House\nPurchase House", "Okay", "Cancel");
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTINGOPTIONS:
		{
			if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
			if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
			if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
			if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
			if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
			if(HouseInfo[HouseMarketTracking[playerid]][hOwned] == 0 || HouseInfo[HouseMarketTracking[playerid]][Listed] == 0 || HouseInfo[HouseMarketTracking[playerid]][PendingApproval] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently for sale.");
				cmd_houselistings(playerid, "");
				return 1;
			}
			switch(response)
			{
				case false: return ShowListingInformation(playerid, HouseMarketTracking[playerid], DIALOG_SELECTEDLISTING);
				case true:
				{
					switch(listitem)
					{
						case 0:
						{
							if(GetPlayerSQLId(playerid) == HouseInfo[HouseMarketTracking[playerid]][hOwnerID])
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You cannot visit your own house through house listings, use (/home).");
								ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "House Listings", "Visit House\nPurchase House", "Okay", "Cancel");
								return 1;
							}
							if(HouseInfo[HouseMarketTracking[playerid]][hExtIW] != 0 || HouseInfo[HouseMarketTracking[playerid]][hExtVW] != 0)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "The specified house's entry point is not outside. Contact the owner to visit it.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "House Listings", "Visit House\nPurchase House", "Okay", "Cancel");
								return 1;
							}
							DisablePlayerCheckpoint(playerid);
							SetPlayerCheckpoint(playerid, HouseInfo[HouseMarketTracking[playerid]][hExteriorX], HouseInfo[HouseMarketTracking[playerid]][hExteriorY], HouseInfo[HouseMarketTracking[playerid]][hExteriorZ], 4.0);
							gPlayerCheckpointStatus[playerid] = CHECKPOINT_HOME;
							hInviteHouse[playerid] = HouseMarketTracking[playerid];
							SendClientMessageEx(playerid, COLOR_WHITE, "A checkpoint has been set to the specified house.");
							return 1;
						}
						case 1:
						{
							if(GetPlayerSQLId(playerid) == HouseInfo[HouseMarketTracking[playerid]][hOwnerID])
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You cannot purchase your own house.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "House Listings", "Visit House\nPurchase House", "Okay", "Cancel");
								return 1;
							}
							if(Homes[playerid] >= MAX_OWNABLE_HOUSES)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You cannot own any more houses.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "House Listings", "Visit House\nPurchase House", "Okay", "Cancel");
								return 1;
							}
							if(GetPlayerCash(playerid) < HouseInfo[HouseMarketTracking[playerid]][ListingPrice])
							{
								format(string, sizeof(string), "You cannot afford this $%s house.", number_format(HouseInfo[HouseMarketTracking[playerid]][ListingPrice]));
								SendClientMessageEx(playerid, COLOR_GREY, string);
								ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "House Listings", "Visit House\nPurchase House", "Okay", "Cancel");
								return 1;
							}
							new name[24], bool:online;
							foreach(new i: Player) 
							{
								if(gPlayerLogged{i} == 1 && HouseInfo[HouseMarketTracking[playerid]][hOwnerID] == GetPlayerSQLId(i))
								{
									GivePlayerCashEx(i, TYPE_BANK, HouseInfo[HouseMarketTracking[playerid]][ListingPrice]);
									format(string, sizeof(string), "%s purchased your house (house ID: %d) for $%s.", GetPlayerNameEx(playerid), HouseMarketTracking[playerid], number_format(HouseInfo[HouseMarketTracking[playerid]][ListingPrice]));
									SendClientMessageEx(i, COLOR_GREEN, string);
									online = true;
									break;
								}
							}
							if(online == false)
							{
								szMiscArray[0] = 0;
								mysql_escape_string(HouseInfo[HouseMarketTracking[playerid]][hOwnerName], name);
								mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET `Bank`=`Bank`+%d WHERE `Username`='%s'", HouseInfo[HouseMarketTracking[playerid]][ListingPrice], name);
								mysql_tquery(MainPipeline, szMiscArray, "", "i", playerid);
								format(string, sizeof(string), "I purchased your house (ID: %d) for $%s.", HouseMarketTracking[playerid], number_format(HouseInfo[HouseMarketTracking[playerid]][ListingPrice]));
								mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `letters` (`Sender_Id`, `Receiver_Id`, `Date`, `Message`, `Delivery_Min`, `Notify`) VALUES (%d, %d, NOW(), '%e', 0, 1)", GetPlayerSQLId(playerid), HouseInfo[HouseMarketTracking[playerid]][hOwnerID], string);
								mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								
							}
							format(string, sizeof(string), "You have purchased house ID %d for $%s.", HouseMarketTracking[playerid], number_format(HouseInfo[HouseMarketTracking[playerid]][ListingPrice]));
							SendClientMessageEx(playerid, COLOR_GREEN, string);
							Homes[playerid] ++;
							GivePlayerCashEx(playerid, TYPE_ONHAND, -HouseInfo[HouseMarketTracking[playerid]][ListingPrice]);
							for(new i = 0; i < 5; i ++)
							{
								if(i < 2)
								{
									if(HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i] != 0 && HouseInfo[HouseMarketTracking[playerid]][hOwnerID] == GarageInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i]][gar_Owner])
									{
										strcpy(GarageInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i]][gar_OwnerName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
										GarageInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i]][gar_Owner] = GetPlayerSQLId(playerid);
										CreateGarage(HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i]);
										SaveGarage(HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i]);
									}
								}
								if(HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i] != 0 && HouseInfo[HouseMarketTracking[playerid]][hOwnerID] == DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddOwner])
								{
									strcpy(DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddOwnerName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
									DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddOwner] = GetPlayerSQLId(playerid);
									DestroyDynamicPickup(DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddPickupID]);
									if(IsValidDynamic3DTextLabel(DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddTextID]);
									CreateDynamicDoor(HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]);
									SaveDynamicDoor(HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]);
								}
							}
							if(PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID) PlayerInfo[playerid][pPhousekey] = HouseMarketTracking[playerid];
							else PlayerInfo[playerid][pPhousekey2] = HouseMarketTracking[playerid];
							HouseInfo[HouseMarketTracking[playerid]][hOwnerID] = GetPlayerSQLId(playerid);
							strcpy(HouseInfo[HouseMarketTracking[playerid]][hOwnerName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
							ReloadHouseText(HouseMarketTracking[playerid]);
							ClearHouseSaleVariables(HouseMarketTracking[playerid]);
							return 1;
						}
					}
				}
			}
			return 1;
		}
	}
	return 0;
}