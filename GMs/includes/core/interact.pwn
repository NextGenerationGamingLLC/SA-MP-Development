/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Interaction System Revision
						  Remastered by Winterfield

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

CMD:interact(playerid, params[])
{
	new id;

	if(sscanf(params, "u", id)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /interact [playerid]");

	if(IsPlayerConnected(id))
	{
		if(!ProxDetectorS(8.0, playerid, GetPVarInt(playerid, "pInteract"))) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not near you!.");
		if(id == playerid) return SendClientMessageEx(playerid, COLOR_GREY, "You can't interact with yourself.");
		SetPVarInt(playerid, "pInteract", id);
		ShowInteractionMenu(playerid, 0);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "That player is not connected!");
	return 1;
}

ShowInteractionMenu(playerid, menu)
{
	szMiscArray[0] = 0;
	if(!ProxDetectorS(8.0, playerid, GetPVarInt(playerid, "pInteract"))) return SendClientMessageEx(playerid, COLOR_GREY, "The player you have tried to interact with is not near you."); // An extra check never hurts! - Winterfield

	switch(menu)
	{
		case 0: // Main Menu
		{
			DeletePVar(playerid, "pGiving");
			DeletePVar(playerid, "pSelling");

			format(szMiscArray, sizeof(szMiscArray), "Pay\nGive Item\nSell Item\nFrisk\nShow License");

			if(IsACop(playerid)) format(szMiscArray, sizeof(szMiscArray), "%s\nCop", szMiscArray);
			if(IsAMedic(playerid)) format(szMiscArray, sizeof(szMiscArray), "%s\nMedic", szMiscArray);
			if(IsADocGuard(playerid)) format(szMiscArray, sizeof(szMiscArray), "%s\nGuard", szMiscArray);

			ShowPlayerDialogEx(playerid, DIALOG_INTERACT, DIALOG_STYLE_LIST, "Interaction Menu", szMiscArray, "Select", "Cancel");
		}
		case 1: // Give / Sell
		{
			format(szMiscArray, sizeof(szMiscArray), "Item\tCurrent Amount\n\
				Drugs\n\
				Weapons\n\
				Materials\t%d\n\
				Syringes\t%d\n\
				Sprunk\t%d\n\
				Fireworks\t%d",
				PlayerInfo[playerid][pMats],
				PlayerInfo[playerid][pSyringes],
				PlayerInfo[playerid][pSprunk],
				PlayerInfo[playerid][pFirework]);

			if(GetPVarInt(playerid, "pGiving")) ShowPlayerDialogEx(playerid, DIALOG_INTERACT_GIVEITEM, DIALOG_STYLE_TABLIST_HEADERS, "Interaction Menu - Give", szMiscArray, "Select", "Cancel");
			else if(GetPVarInt(playerid, "pSelling")) ShowPlayerDialogEx(playerid, DIALOG_INTERACT_SELLITEM, DIALOG_STYLE_TABLIST_HEADERS, "Interaction Menu - Sell", szMiscArray, "Select", "Cancel");
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_INTERACT:
		{
			if(!response) return 1;
			if(!IsPlayerConnected(GetPVarInt(playerid, "pInteract"))) return SendClientMessage(playerid, COLOR_GRAD1, "The player you were interacting with has disconnected!");
			if(!ProxDetectorS(8.0, playerid, GetPVarInt(playerid, "pInteract"))) return SendClientMessageEx(playerid, COLOR_GREY, "The player you have tried to interact with is not near you.");

			szMiscArray[0] = 0;
			switch(listitem)
			{
				case 0: ShowPlayerDialogEx(playerid, DIALOG_INTERACT_PAY, DIALOG_STYLE_INPUT, "Interaction Menu - Pay", "How much would you like to transfer?", "Select", "Cancel"); // Pay
				case 1: // Give
				{
					SetPVarInt(playerid, "pGiving", 1);
					ShowInteractionMenu(playerid, 1);
				}
				case 2: // Sell
				{
					SetPVarInt(playerid, "pSelling", 1);
					ShowInteractionMenu(playerid, 1);
				}
				case 3: // Frisk
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					cmd_frisk(playerid, id);
				}
				case 4: // Show License
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					cmd_showlicenses(playerid, id);
				}
			}

			if(listitem == 5 && IsACop(playerid))
			{
				format(szMiscArray, sizeof(szMiscArray), "(Un)cuff\nJailcuff\nDrag\nDetain\nTicket\nConfiscate", szMiscArray);
				ShowPlayerDialogEx(playerid, DIALOG_INTERACT_COP, DIALOG_STYLE_LIST, "Interaction Menu - Cop", szMiscArray, "Select", "Cancel");
			}
			if(listitem == 5 && IsAMedic(playerid))
			{
				format(szMiscArray, sizeof(szMiscArray), "Move Patient\nLoad Patient\nTriage\nHeal", szMiscArray);
				ShowPlayerDialogEx(playerid, DIALOG_INTERACT_MEDIC, DIALOG_STYLE_LIST, "Interaction Menu - Medic", szMiscArray, "Select", "Cancel");
			}
			if(listitem == 5 && IsADocGuard(playerid))
			{
				format(szMiscArray, sizeof(szMiscArray), "(Un)cuff\nJailcuff\nDrag\nDetain\nConfiscate\nExtend Sentence\nReduce Sentence\nIsolate", szMiscArray);
				ShowPlayerDialogEx(playerid, DIALOG_INTERACT_GUARD, DIALOG_STYLE_LIST, "Interaction Menu - DoC", szMiscArray, "Select", "Cancel");
			}
		}
		case DIALOG_INTERACT_PAY: 
		{
			if(!response) return 1;
			if(!IsPlayerConnected(GetPVarInt(playerid, "pInteract"))) return SendClientMessage(playerid, COLOR_GRAD1, "The player you were interacting with has disconnected!");
			if(!ProxDetectorS(8.0, playerid, GetPVarInt(playerid, "pInteract"))) return SendClientMessageEx(playerid, COLOR_GREY, "The player you have tried to interact with is not near you.");

			new id[3], realstring[50];
			valstr(id, GetPVarInt(playerid, "pInteract"));
			format(realstring, 50, "%s %s", id, inputtext);

			cmd_pay(playerid, realstring);
		}
		case DIALOG_INTERACT_GIVEITEM:
		{
			if(!response) return 1;
			if(!IsPlayerConnected(GetPVarInt(playerid, "pInteract"))) return SendClientMessage(playerid, COLOR_GRAD1, "The player you were interacting with has disconnected!");
			if(!ProxDetectorS(8.0, playerid, GetPVarInt(playerid, "pInteract"))) return SendClientMessageEx(playerid, COLOR_GREY, "The player you have tried to interact with is not near you.");

			switch(listitem)
			{
				case 0:
				{
					szMiscArray[0] = 0;
					for(new i; i < sizeof(Drugs); i++) format(szMiscArray, sizeof(szMiscArray), "%s\n{A9C4E4}%s {FFFFFF}(%dg){A9C4E4}", szMiscArray, GetDrugName(i), PlayerInfo[playerid][pDrugs][i]);

					ShowPlayerDialogEx(playerid, DIALOG_INTERACT_GI_DRUGS, DIALOG_STYLE_LIST, "Interaction Menu - Give Item (Drugs)", szMiscArray, "Select", "Cancel");
				}
				case 1:
				{
					szMiscArray[0] = 0;
					new weapon[16], weapons[13][2];
					for (new i = 0; i <= 12; i++) 
					{
						GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
						GetWeaponName(weapons[i][0], weapon, sizeof(weapon));
						if(PlayerInfo[playerid][pGuns][i] == weapons[i][0]) format(szMiscArray, sizeof(szMiscArray), "%s\n{A9C4E4}%s {FFFFFF}(%d){A9C4E4}", szMiscArray, weapon, weapons[i][0]);
					}

					ShowPlayerDialogEx(playerid, DIALOG_INTERACT_GI_WEAPON, DIALOG_STYLE_LIST, "Interaction Menu - Give Item (Weapons)", szMiscArray, "Select", "Cancel");
				}
			}
		}
		case DIALOG_INTERACT_COP:
		{
			if(!response) return 1;
			if(!IsPlayerConnected(GetPVarInt(playerid, "pInteract"))) return SendClientMessage(playerid, COLOR_GRAD1, "The player you were interacting with has disconnected!");
			if(!ProxDetectorS(8.0, playerid, GetPVarInt(playerid, "pInteract"))) return SendClientMessageEx(playerid, COLOR_GREY, "The player you have tried to interact with is not near you.");

			switch(listitem)
			{
				case 0: // (Un)cuff
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					if(PlayerCuffed[GetPVarInt(playerid, "pInteract")] > 1) cmd_uncuff(playerid, id);
					else cmd_cuff(playerid, id);
				}
				case 1: // Jailcuff
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					cmd_jailcuff(playerid, id);
				}
				case 2: // Drag
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					cmd_drag(playerid, id);
				}
				case 3: ShowPlayerDialogEx(playerid, DIALOG_INTERACT_DETAIN, DIALOG_STYLE_INPUT, "Interaction Menu - Detain", "Please choose the number of seat you'd like to detain the suspect in. (1-3)", "Select", "Cancel");
				case 4: ShowPlayerDialogEx(playerid, DIALOG_INTERACT_TICKET, DIALOG_STYLE_INPUT, "Interaction Menu - Ticket", "Please choose how much you would like to ticket the suspect.", "Select", "Cancel");
				case 5: ShowPlayerDialogEx(playerid, DIALOG_INTERACT_CONFISCATE, DIALOG_STYLE_LIST, "Interaction Menu - Confiscate", "Weapons\nPot\nCrack\nMeth\nEcstasy\nMaterials\nRadio\nHeroin\nRawopium\nSyringes\nPotSeeds\nOpiumSeeds\nDrugCrates", "Select", "Cancel");
			}
		}
		case DIALOG_INTERACT_MEDIC:
		{
			if(!response) return 1;
			if(!IsPlayerConnected(GetPVarInt(playerid, "pInteract"))) return SendClientMessage(playerid, COLOR_GRAD1, "The player you were interacting with has disconnected!");
			if(!ProxDetectorS(8.0, playerid, GetPVarInt(playerid, "pInteract"))) return SendClientMessageEx(playerid, COLOR_GREY, "The player you have tried to interact with is not near you.");

			switch(listitem)
			{
				case 0: // Move Patient
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					cmd_movept(playerid, id);
				}
				case 1: // Load Patient
				{
					new id[3], seat = -1, realstring[50];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					new carid = gLastCar[playerid];
                    if(IsAnAmbulance(carid))
					{
						for(new i = 2; i < 3; i++)
                        if(!IsVehicleOccupied(carid, i)) { seat = i; break; } 
					}
					else return 1;
					format(realstring, 50, "%s %d", id, seat);

					if(seat != -1) cmd_loadpt(playerid, realstring);
				}
				case 2: // Jailcuff
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					cmd_jailcuff(playerid, id);
				}
				case 3: // Triage
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					cmd_triage(playerid, id);
				}
				case 4: ShowPlayerDialogEx(playerid, DIALOG_INTERACT_HEAL, DIALOG_STYLE_INPUT, "Interaction Menu - Heal", "How much would you like to heal the patient for? ($200 - $1,000)", "Select", "Cancel");
			}
		}
		case DIALOG_INTERACT_GUARD:
		{
			if(!response) return 1;
			if(!IsPlayerConnected(GetPVarInt(playerid, "pInteract"))) return SendClientMessage(playerid, COLOR_GRAD1, "The player you were interacting with has disconnected!");
			if(!ProxDetectorS(8.0, playerid, GetPVarInt(playerid, "pInteract"))) return SendClientMessageEx(playerid, COLOR_GREY, "The player you have tried to interact with is not near you.");

			switch(listitem)
			{
				case 0: // (Un)cuff
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					if(PlayerCuffed[GetPVarInt(playerid, "pInteract")] > 1) cmd_uncuff(playerid, id);
					else cmd_cuff(playerid, id);
				}
				case 1: // Jailcuff
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					cmd_jailcuff(playerid, id);
				}
				case 2: // Drag
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "pInteract"));

					cmd_drag(playerid, id);
				}
				case 3: ShowPlayerDialogEx(playerid, DIALOG_INTERACT_DETAIN, DIALOG_STYLE_INPUT, "Interaction Menu - Detain", "Please choose the number of seat you'd like to detain the suspect in. (1-3)", "Select", "Cancel");
				case 4: ShowPlayerDialogEx(playerid, DIALOG_INTERACT_CONFISCATE, DIALOG_STYLE_LIST, "Interaction Menu - Confiscate", "Weapons\nPot\nCrack\nMeth\nEcstasy\nMaterials\nRadio\nHeroin\nRawopium\nSyringes\nPotSeeds\nOpiumSeeds\nDrugCrates", "Select", "Cancel");
				case 5: ShowPlayerDialogEx(playerid, DIALOG_INTERACT_EXTEND, DIALOG_STYLE_INPUT, "Interaction Menu - Extend Sentence", "How much would you like to extend the prisoners sentence? (1 - 30)", "Select", "Cancel");
				case 6: ShowPlayerDialogEx(playerid, DIALOG_INTERACT_REDUCE, DIALOG_STYLE_INPUT, "Interaction Menu - Reduce Sentence", "How much would you like to reduce the prisoners sentence? (1 - 30)", "Select", "Cancel");
				case 7: ShowPlayerDialogEx(playerid, DIALOG_INTERACT_ISOLATION, DIALOG_STYLE_LIST, "Interaction Menu - Isolation", "IC Isolation\nOOC Isolation", "Select", "Cancel");
			}
		}
	}
	return 0;
}