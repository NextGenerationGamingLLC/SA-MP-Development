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
			format(szMiscArray, sizeof(szMiscArray), "Pay\nGive Item\nSell Item\nFrisk\nShow License");

			/*if(IsACop(playerid)) format(szMiscArray, sizeof(szMiscArray), "%s\n(Un)cuff\nJailcuff\nDrag\nDetain\nTicket\nConfiscate", szMiscArray);
			if(IsAMedic(playerid)) format(szMiscArray, sizeof(szMiscArray), "%s\nLoad Patient\nTriage\nHeal\nMove Patient", szMiscArray);
			if(IsAGuard(playerid)) format(szMiscArray, sizeof(szMiscArray), "%s\n(Un)cuff\nJailcuff\nDrag\nDetain\nConfiscate\nExtend Sentence\nReduce Sentence\nIsolation", szMiscArray);*/

			if(IsACop(playerid)) format(szMiscArray, sizeof(szMiscArray), "%s\nCop", szMiscArray);
			if(IsAMedic(playerid)) format(szMiscArray, sizeof(szMiscArray), "%s\nMedic", szMiscArray);
			if(IsAGuard(playerid)) format(szMiscArray, sizeof(szMiscArray), "%s\nGuard", szMiscArray);

			ShowPlayerDialog(playerid, DIALOG_INTERACT, DIALOG_STYLE_LIST, "Interaction Menu", szMiscArray, "Select", "Cancel");
		}
		case 1: // Give / Sell
		{
			format(szMiscArray, sizeof(szMiscArray), "Item\tCurrent Amount\n\
				Ammo\n\
				Drugs\n\
				Weapons\n\
				Materials\t%d\n\
				Syringes\t%d\n\
				Sprunk\t%d\n\
				Fireworks\t%d\n\
				PB Tokens\t%d",
				PlayerInfo[playerid][pMats],
				PlayerInfo[playerid][pSyringes],
				PlayerInfo[playerid][pSprunk],
				PlayerInfo[playerid][pFirework]
				PlayerInfo[playerid][pPaintTokens]);

			if(GetPVarInt(playerid, "pGiving")) ShowPlayerDialog(playerid, DIALOG_INTERACT_GIVEITEM, DIALOG_STYLE_TABLIST_HEADERS, "Interaction Menu - Give", szMiscArray);
			else if(GetPVarInt(playerid, "pSelling")) ShowPlayerDialog(playerid, DIALOG_INTERACT_GIVEITEM, DIALOG_STYLE_TABLIST_HEADERS, "Interaction Menu - Sell", szMiscArray);
		}
	}
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_INTERACT:
		{
			if(!response) return 1;
			if(!IsPlayerConnected) return SendClientMessage(playerid, COLOR_GRAD1, "The player you were interacting with has disconnected!");
			if(!ProxDetectorS(8.0, playerid, GetPVarInt(playerid, "pInteract"))) return SendClientMessageEx(playerid, COLOR_GREY, "The player you have tried to interact with is not near you.");

			szMiscArray[0] = 0;
			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, DIALOG_INTERACT_PAY, DIALOG_STYLE_INPUT, "Interaction Menu - Pay", "How much would you like to transfer?"); // Pay
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
					PlayerFriskPlayer(playerid, GetPVarInt(playerid, "pInteract"));

					format(szMiscArray, sizeof(szMiscArray), "* %s has frisked %s for any illegal items.", GetPlayerNameEx(playerid),GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
					ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				case 4: // Show License
				{
					PlayerShowLicenses(playerid, GetPVarInt(playerid, "pInteract"));
				}
			}

			if(listitem == 5 && IsACop(playerid))
			{
				format(szMiscArray, sizeof(szMiscArray), "(Un)cuff\nJailcuff\nDrag\nDetain\nTicket\nConfiscate", szMiscArray);
				ShowPlayerDialog(playerid, DIALOG_INTERACT, DIALOG_STYLE_LIST, "Interaction Menu - Cop", szMiscArray, "Select", "Cancel");
			}
			if(listitem == 5 && IsAMedic(playerid))
			{
				format(szMiscArray, sizeof(szMiscArray), "%s\nLoad Patient\nTriage\nHeal\nMove Patient", szMiscArray);
				ShowPlayerDialog(playerid, DIALOG_INTERACT, DIALOG_STYLE_LIST, "Interaction Menu - Cop", szMiscArray, "Select", "Cancel");
			}
			if(listitem == 5 && IsAGuard(playerid))
			{
				format(szMiscArray, sizeof(szMiscArray), "%s\n(Un)cuff\nJailcuff\nDrag\nDetain\nConfiscate\nExtend Sentence\nReduce Sentence\nIsolation", szMiscArray);
				ShowPlayerDialog(playerid, DIALOG_INTERACT, DIALOG_STYLE_LIST, "Interaction Menu - Cop", szMiscArray, "Select", "Cancel");
			}
		}
		case DIALOG_INTERACT_COP
		{
			switch(listitem)
			{
				case 5: // (Un)cuff
				{
					if(GetPVarInt(GetPVarInt(playerid, "pInteract"), "Injured") == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot cuff someone in a injured state.");

					if(PlayerCuffed[GetPVarInt(playerid, "pInteract")] > 1)
					{
						DeletePVar(GetPVarInt(playerid, "pInteract"), "IsFrozen");
						format(szMiscArray, sizeof(szMiscArray), "* You have been uncuffed by %s.", GetPlayerNameEx(playerid));
						SendClientMessageEx(GetPVarInt(playerid, "pInteract"), COLOR_LIGHTBLUE, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "* You uncuffed %s.", GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "* %s has uncuffed %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
						ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						GameTextForPlayer(GetPVarInt(playerid, "pInteract"), "~g~Uncuffed", 2500, 3);
						TogglePlayerControllable(GetPVarInt(playerid, "pInteract"), 1);
						ClearAnimations(GetPVarInt(playerid, "pInteract"));
						SetPlayerSpecialAction(GetPVarInt(playerid, "pInteract"), SPECIAL_ACTION_NONE);
						PlayerCuffed[GetPVarInt(playerid, "pInteract")] = 0;
                  	    PlayerCuffedTime[GetPVarInt(playerid, "pInteract")] = 0;
                   	    SetHealth(GetPVarInt(playerid, "pInteract"), GetPVarFloat(GetPVarInt(playerid, "pInteract"), "cuffhealth"));
                    	SetArmour(GetPVarInt(playerid, "pInteract"), GetPVarFloat(GetPVarInt(playerid, "pInteract"), "cuffarmor"));
                    	DeletePVar(GetPVarInt(playerid, "pInteract"), "cuffhealth");
						DeletePVar(GetPVarInt(playerid, "pInteract"), "PlayerCuffed");
						DeletePVar(GetPVarInt(playerid, "pInteract"), "jailcuffs");
					}
					else if(GetPVarInt(GetPVarInt(playerid, "pInteract"), "jailcuffs") == 1)
					{
						DeletePVar(GetPVarInt(playerid, "pInteract"), "IsFrozen");
						format(szMiscArray, sizeof(szMiscArray), "* You have been uncuffed by %s.", GetPlayerNameEx(playerid));
						SendClientMessageEx(GetPVarInt(playerid, "pInteract"), COLOR_LIGHTBLUE, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "* You uncuffed %s.", GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "* %s has uncuffed %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
						ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						GameTextForPlayer(GetPVarInt(playerid, "pInteract"), "~g~Uncuffed", 2500, 3);
						ClearAnimations(GetPVarInt(playerid, "pInteract"));
						SetPlayerSpecialAction(GetPVarInt(playerid, "pInteract"), SPECIAL_ACTION_NONE);
						DeletePVar(GetPVarInt(playerid, "pInteract"), "jailcuffs");
					}
					else
					{
						new Float:health, Float:armor;
						if(PlayerCuffed[GetPVarInt(playerid, "pInteract")] == 1 || GetPlayerSpecialAction(GetPVarInt(playerid, "pInteract")) == SPECIAL_ACTION_HANDSUP || GetPVarInt(GetPVarInt(playerid, "pInteract"), "pBagged") >= 1)
						{
							if(PlayerInfo[GetPVarInt(playerid, "pInteract")][pConnectHours] < 32) SendClientMessageEx(GetPVarInt(playerid, "pInteract"), COLOR_WHITE, "If you logout now you will automatically be prisoned for 2+ hours!");
							format(szMiscArray, sizeof(szMiscArray), "* You have been handcuffed by %s.", GetPlayerNameEx(playerid));
							SendClientMessageEx(GetPVarInt(playerid, "pInteract"), COLOR_LIGHTBLUE, szMiscArray);
							format(szMiscArray, sizeof(szMiscArray), "* You handcuffed %s, till uncuff.", GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
							format(szMiscArray, sizeof(szMiscArray), "* %s handcuffs %s, tightening the cuffs securely.", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
							ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							GameTextForPlayer(GetPVarInt(playerid, "pInteract"), "~r~Cuffed", 2500, 3);
							TogglePlayerControllable(GetPVarInt(playerid, "pInteract"), 0);
							ClearAnimations(GetPVarInt(playerid, "pInteract"));
							GetHealth(GetPVarInt(playerid, "pInteract"), health);
							GetArmour(GetPVarInt(playerid, "pInteract"), armor);
							SetPVarFloat(GetPVarInt(playerid, "pInteract"), "cuffhealth",health);
							SetPVarFloat(GetPVarInt(playerid, "pInteract"), "cuffarmor",armor);
							SetPlayerSpecialAction(GetPVarInt(playerid, "pInteract"), SPECIAL_ACTION_CUFFED);
							ApplyAnimation(GetPVarInt(playerid, "pInteract"),"ped","cower",1,1,0,0,0,0,1);
							PlayerCuffed[GetPVarInt(playerid, "pInteract")] = 2;
							SetPVarInt(GetPVarInt(playerid, "pInteract"), "PlayerCuffed", 2);
							SetPVarInt(GetPVarInt(playerid, "pInteract"), "IsFrozen", 1);
							DeletePVar(GetPVarInt(playerid, "pInteract"), "pBagged");
							//Frozen[GetPVarInt(playerid, "pInteract")] = 1;
							PlayerCuffedTime[GetPVarInt(playerid, "pInteract")] = 300;
						}
						else if(GetPVarType(GetPVarInt(playerid, "pInteract"), "IsTackled"))
						{
				    		format(szMiscArray, sizeof(szMiscArray), "* %s removes a set of cuffs from his belt and attempts to cuff %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
							ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							SetTimerEx("CuffTackled", 4000, 0, "ii", playerid, GetPVarInt(playerid, "pInteract"));
						}
						else
						{
							return SendClientMessageEx(playerid, COLOR_GREY, "That person isn't restrained!");
						}
					}
				}
				case 6:
				{
					if(GetPlayerSpecialAction(GetPVarInt(playerid, "pInteract")) == SPECIAL_ACTION_HANDSUP || PlayerCuffed[GetPVarInt(playerid, "pInteract")] == 1)
					{
						format(szMiscArray, sizeof(szMiscArray), "* You have been handcuffed by %s.", GetPlayerNameEx(playerid));
						SendClientMessageEx(GetPVarInt(playerid, "pInteract"), COLOR_LIGHTBLUE, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "* You handcuffed %s, till uncuff.", GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "* %s handcuffs %s, tightening the cuffs securely.", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
						ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						GameTextForPlayer(GetPVarInt(playerid, "pInteract"), "~r~Cuffed", 2500, 3);
						ClearAnimations(GetPVarInt(playerid, "pInteract"));
						TogglePlayerControllable(GetPVarInt(playerid, "pInteract"), 0);
						SetPlayerSpecialAction(GetPVarInt(playerid, "pInteract"), SPECIAL_ACTION_CUFFED);
						TogglePlayerControllable(GetPVarInt(playerid, "pInteract"), 1);
						SetPVarInt(GetPVarInt(playerid, "pInteract"), "jailcuffs", 1);
					}
					else if(GetPVarType(GetPVarInt(playerid, "pInteract"), "IsTackled"))
					{
				    	format(szMiscArray, sizeof(szMiscArray), "* %s removes a set of cuffs from his belt and attempts to cuff %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
						ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetTimerEx("CuffTackled", 4000, 0, "ii", playerid, GetPVarInt(playerid, "pInteract"));
					}
					else
					{
						return SendClientMessageEx(playerid, COLOR_GREY, "That person isn't restrained!");
					}
				}
				case 7:
				{
					if(GetPVarInt(GetPVarInt(playerid, "pInteract"), "PlayerCuffed") == 2)
					{
						if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, " You must be out of the vehicle to use this command.");
						if(GetPVarInt(GetPVarInt(playerid, "pInteract"), "BeingDragged") == 1)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, " That person is already being dragged. ");
							return 1;
						}
                		new Float:dX, Float:dY, Float:dZ;
						GetPlayerPos(GetPVarInt(playerid, "pInteract"), dX, dY, dZ);

						format(szMiscArray, sizeof(szMiscArray), "* %s is now dragging you.", GetPlayerNameEx(playerid));
						SendClientMessageEx(GetPVarInt(playerid, "pInteract"), COLOR_WHITE, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "* You are now dragging %s, you may move them now.", GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
						SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "* %s grabs ahold of %s and begins to move them.", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPVarInt(playerid, "pInteract")));
						ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SendClientMessageEx(playerid, COLOR_WHITE, "You are now dragging the suspect, press the '{AA3333}FIRE{FFFFFF}' button to stop.");
						SetPVarInt(GetPVarInt(playerid, "pInteract"), "BeingDragged", 1);
						SetPVarInt(playerid, "DraggingPlayer", GetPVarInt(playerid, "pInteract"));
						SetTimerEx("DragPlayer", 1000, 0, "ii", playerid, GetPVarInt(playerid, "pInteract"));
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_WHITE, " The specified person is not cuffed !");
					}
				}
			}
		}
	}
}