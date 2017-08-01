/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic	Garages System

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

stock SaveGarages()
{
	for(new i = 0; i < MAX_GARAGES; i++)
	{
		SaveGarage(i);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	if(dialogid == GARAGELOCK)
	{
		if(response)
		{
			new i = GetPVarInt(playerid, "Garage");
			if(isnull(inputtext)) return SendClientMessage(playerid, COLOR_GREY, "You did not enter anything" );
			if(strlen(inputtext) > 24) return SendClientMessageEx(playerid, COLOR_GREY, "The password can not be greater than 24 characters.");
			if(strcmp(inputtext, GarageInfo[i][gar_Pass], true) == 0)
			{
				if(GarageInfo[i][gar_Locked] == 0)
				{
					GarageInfo[i][gar_Locked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "Password accepted, garage locked.");
				}
				else
				{
					GarageInfo[i][gar_Locked] = 0;
					SendClientMessageEx(playerid, COLOR_WHITE, "Password accepted, garage unlocked.");
				}
				SaveGarage(i);
			}
			else SendClientMessageEx(playerid, COLOR_WHITE, "Password declined.");
		}
	}
	return 0;
}

CMD:changegaragepass(playerid, params[])
{
	new garagepass[24];
	for(new i = 0; i < sizeof(GarageInfo); i++)
	{
		if (IsPlayerInRangeOfPoint(playerid,3.0,GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]) && PlayerInfo[playerid][pVW] == GarageInfo[i][gar_ExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]) && PlayerInfo[playerid][pVW] == GarageInfo[i][gar_InteriorVW])
		{
			if(sscanf(params, "s[24]", garagepass))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /changegaragepass [pass]");
				SendClientMessageEx(playerid, COLOR_WHITE, "To remove the password on the door set the password to 'none'.");
				return 1;
			}
			if(GarageInfo[i][gar_Owner] == GetPlayerSQLId(playerid))
			{
				format(GarageInfo[i][gar_Pass], 24, "%s", garagepass);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of this door.");
				SaveGarage(i);
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "You cannot change the password on this lock.");
		}
	}
	return 1;
}

CMD:lockgarage(playerid, params[])
{
	for(new i = 0; i < sizeof(GarageInfo); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]) && PlayerInfo[playerid][pVW] == GarageInfo[i][gar_ExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]) && PlayerInfo[playerid][pVW] == GarageInfo[i][gar_InteriorVW])
		{
			if(GarageInfo[i][gar_Owner] == GetPlayerSQLId(playerid))
			{
				if(GarageInfo[i][gar_Locked] == 0)
				{
					GarageInfo[i][gar_Locked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "This garage has been locked.");
				}
				else if(GarageInfo[i][gar_Locked] == 1)
				{
					GarageInfo[i][gar_Locked] = 0;
					SendClientMessageEx(playerid, COLOR_GREY, "This garage has been unlocked.");
				}
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "You cannot lock this garage.");
		}
	}
	return 1;
}

CMD:garagepass(playerid, params[])
{
	for(new i = 0; i < sizeof(GarageInfo); i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]) && PlayerInfo[playerid][pVW] == GarageInfo[i][gar_ExteriorVW] || IsPlayerInRangeOfPoint(playerid, 3.0, GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]) && PlayerInfo[playerid][pVW] == GarageInfo[i][gar_InteriorVW])
		{
			if(strcmp(GarageInfo[i][gar_Pass], "None", true) == 0 || GarageInfo[i][gar_Pass] <= 1) return SendClientMessageEx(playerid, COLOR_GREY, "This garage isn't locked.");
			ShowPlayerDialogEx(playerid, GARAGELOCK, DIALOG_STYLE_INPUT, "Garage Security", "Enter the password for this garage", "Login", "Cancel");
			SetPVarInt(playerid, "Garage", i);
			break;
		}
	}
	return 1;
}

CMD:garageedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	new option[128], garageid, value, string[128];
	if(sscanf(params, "s[128]iD(0)", option, garageid, value))
	{
		SendClientMessage(playerid, COLOR_GRAD2, "USAGE: /garageedit [option] [garageid] [value]");
		SendClientMessage(playerid, COLOR_GRAD2, "Available Options: Exterior, CustomExterior, Size, VW, Delete");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Valid Sizes: 1 = Small | 2 = Medium | 3 = Large | 4 = Extra Large");
		return 1;
	}
	if(garageid >= MAX_GARAGES) return SendClientMessageEx(playerid, COLOR_WHITE, "Invalid Garage ID!");
	if(strcmp(option, "exterior", true) == 0)
	{
		GetPlayerPos(playerid, GarageInfo[garageid][gar_ExteriorX], GarageInfo[garageid][gar_ExteriorY], GarageInfo[garageid][gar_ExteriorZ]);
		GetPlayerFacingAngle(playerid, GarageInfo[garageid][gar_ExteriorA]);
		GarageInfo[garageid][gar_ExteriorVW] = GetPlayerVirtualWorld(playerid);
		GarageInfo[garageid][gar_ExteriorInt] = GetPlayerInterior(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the exterior!");
		CreateGarage(garageid);
		format(string, sizeof(string), "%s has edited Garage ID: %d's Exterior.", GetPlayerNameEx(playerid), garageid);
		Log("logs/garage.log", string);
	}
	else if(strcmp(option, "customexterior", true) == 0)
	{
		if(GarageInfo[garageid][gar_CustomExterior] == 0)
		{
			GarageInfo[garageid][gar_CustomExterior] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "Garage set to custom exterior!");
		}
		else
		{
			GarageInfo[garageid][gar_CustomExterior] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "Garage set to normal (not custom) exterior!");
		}
		CreateGarage(garageid);
		format(string, sizeof(string), "%s has edited Garage ID: %d's CustomExterior.", GetPlayerNameEx(playerid), garageid);
		Log("logs/garage.log", string);
	}
	else if(strcmp(option, "size", true) == 0)
	{
		if(!(1 <= value <= 4)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Valid Sizes: 1 = Small | 2 = Medium | 3 = Large | 4 = Extra Large");
		new size[12];
		if(value == 1)
		{
			GarageInfo[garageid][gar_InteriorX] = 1198.753051;
			GarageInfo[garageid][gar_InteriorY] = 1591.710937;
			GarageInfo[garageid][gar_InteriorZ] = 5290.287109;
			GarageInfo[garageid][gar_InteriorA] = 360;
			size = "Small";
		}
		if(value == 2)
		{
			GarageInfo[garageid][gar_InteriorX] = 1070.967651;
			GarageInfo[garageid][gar_InteriorY] = 1582.612548;
			GarageInfo[garageid][gar_InteriorZ] = 5290.239257;
			GarageInfo[garageid][gar_InteriorA] = 270;
			size = "Medium";
		}
		if(value == 3)
		{
			GarageInfo[garageid][gar_InteriorX] = 1193.128662;
			GarageInfo[garageid][gar_InteriorY] = 1535.807128;
			GarageInfo[garageid][gar_InteriorZ] = 5290.287109;
			GarageInfo[garageid][gar_InteriorA] = 180;
			size = "Large";
		}
		if(value == 4)
		{
			GarageInfo[garageid][gar_InteriorX] = 1103.262939;
			GarageInfo[garageid][gar_InteriorY] = 1544.137695;
			GarageInfo[garageid][gar_InteriorZ] = 5290.279296;
			GarageInfo[garageid][gar_InteriorA] = 180;
			size = "Extra Large";
		}
		CreateGarage(garageid);
		format(string, sizeof(string), "Garage size set to %s", size);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has edited Garage ID: %d's size to %s", GetPlayerNameEx(playerid), garageid, size);
		Log("logs/garage.log", string);
	}
	else if(strcmp(option, "vw", true) == 0)
	{
		GarageInfo[garageid][gar_InteriorVW] = value;
		format(string, sizeof(string), "Garage Interior VW set to %d", value);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has edited Garage ID: %d's VW to %d", GetPlayerNameEx(playerid), garageid, value);
		Log("logs/garage.log", string);
		CreateGarage(garageid);
	}
	else if(strcmp(option, "delete", true) == 0)
	{
		format(string, sizeof(string), "%s has deleted Garage ID: %d was owned by %s(%d)", GetPlayerNameEx(playerid), garageid, GarageInfo[garageid][gar_OwnerName], GarageInfo[garageid][gar_Owner]);
		Log("logs/garage.log", string);
		format(string, sizeof(string), "You have successfully deleted Garage ID: %d was owned by %s", garageid, GarageInfo[garageid][gar_OwnerName]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		GarageInfo[garageid][gar_Owner] = -1;
		format(GarageInfo[garageid][gar_OwnerName], MAX_PLAYER_NAME, "Nobody");
		GarageInfo[garageid][gar_ExteriorX] = 0.0;
		GarageInfo[garageid][gar_ExteriorY] = 0.0;
		GarageInfo[garageid][gar_ExteriorZ] = 0.0;
		GarageInfo[garageid][gar_ExteriorA] = 0.0;
		GarageInfo[garageid][gar_ExteriorVW] = 0;
		GarageInfo[garageid][gar_ExteriorInt] = 0;
		GarageInfo[garageid][gar_CustomExterior] = 0;
		GarageInfo[garageid][gar_InteriorX] = 0.0;
		GarageInfo[garageid][gar_InteriorY] = 0.0;
		GarageInfo[garageid][gar_InteriorZ] = 0.0;
		GarageInfo[garageid][gar_InteriorA] = 0.0;
		GarageInfo[garageid][gar_InteriorVW] = 0;
		format(GarageInfo[garageid][gar_Pass], MAX_PLAYER_NAME, "none");
		GarageInfo[garageid][gar_Locked] = 0;
		CreateGarage(garageid);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid option!");
	SaveGarage(garageid);
	return 1;
}

CMD:changeddtogarage(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	new doorid;
	if(sscanf(params, "d", doorid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /changeddtogarage [doorid]");
	if(doorid >= MAX_DDOORS) return SendClientMessageEx(playerid, COLOR_WHITE, "Invalid Door ID!");
	if(DDoorsInfo[doorid][ddType] != 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "This door is not owned by a player, please confirm and modify door type if needed!");
	new next, bool:available = false;
	for(new i; i < MAX_GARAGES; i++)
	{
		if(GarageInfo[i][gar_ExteriorX] == 0.0)
		{
			available = true;
			next = i;
			break;
		}
	}
	if(available == false) return SendClientMessageEx(playerid, COLOR_GRAD2, "No Garages available.");
	new string[128];
	GarageInfo[next][gar_Owner] = DDoorsInfo[doorid][ddOwner];
	format(GarageInfo[next][gar_OwnerName], MAX_PLAYER_NAME, "%s", DDoorsInfo[doorid][ddOwnerName]);
	GarageInfo[next][gar_ExteriorX] = DDoorsInfo[doorid][ddExteriorX];
	GarageInfo[next][gar_ExteriorY] = DDoorsInfo[doorid][ddExteriorY];
	GarageInfo[next][gar_ExteriorZ] = DDoorsInfo[doorid][ddExteriorZ];
	GarageInfo[next][gar_ExteriorA] = DDoorsInfo[doorid][ddExteriorA];
	GarageInfo[next][gar_ExteriorVW] = DDoorsInfo[doorid][ddExteriorVW];
	GarageInfo[next][gar_ExteriorInt] = DDoorsInfo[doorid][ddExteriorInt];
	GarageInfo[next][gar_CustomExterior] = DDoorsInfo[doorid][ddCustomExterior];
	GarageInfo[next][gar_InteriorX] = DDoorsInfo[doorid][ddInteriorX];
	GarageInfo[next][gar_InteriorY] = DDoorsInfo[doorid][ddInteriorY];
	GarageInfo[next][gar_InteriorZ] = DDoorsInfo[doorid][ddInteriorZ];
	GarageInfo[next][gar_InteriorA] = DDoorsInfo[doorid][ddInteriorA];
	GarageInfo[next][gar_InteriorVW] = DDoorsInfo[doorid][ddInteriorVW];
	format(GarageInfo[next][gar_Pass], 24, "%s", DDoorsInfo[doorid][ddPass]);
	GarageInfo[next][gar_Locked] = DDoorsInfo[doorid][ddLocked];
	format(string, sizeof(string), "Door ID %d has been transferred to Garage ID: %d by %s", doorid, next, GetPlayerNameEx(playerid));
	SendClientMessageEx(playerid, COLOR_GRAD2, string);
	Log("logs/ddedit.log", string);
	Log("logs/garage.log", string);
	CreateGarage(next);
	SaveGarage(next);
	SendClientMessageEx(playerid, COLOR_GRAD2, "If garage has been successfully transferred delete the door. /ddedit delete");
	return 1;
}

CMD:garageowner(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new playername[MAX_PLAYER_NAME], garageid, string[128];
		if(sscanf(params, "ds[24]", garageid, playername)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /garageowner [garageid] [player name]");

		new giveplayerid = ReturnUser(playername);
		if(IsPlayerConnected(giveplayerid))
		{
			format(GarageInfo[garageid][gar_OwnerName], MAX_PLAYER_NAME, "%s", GetPlayerNameEx(giveplayerid));
			GarageInfo[garageid][gar_Owner] = GetPlayerSQLId(giveplayerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully changed the owner of this garage.");
			CreateGarage(garageid);
			SaveGarage(garageid);
			format(string, sizeof(string), "%s has edited Garage ID: %d's owner to %s (SQL ID: %d).", GetPlayerNameEx(playerid), garageid, GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
			Log("logs/garage.log", string);
		}
		else
		{
			mysql_format(MainPipeline, string, sizeof(string), "SELECT `id`, `Username` FROM `accounts` WHERE `Username` = '%e'", playername);
			mysql_tquery(MainPipeline, string, "OnSetGarageOwner", "ii", playerid, garageid);
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command!");
	return 1;
}

CMD:agaragepass(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");

	new string[128],
		garageid,
		garagepass[24];

	if(sscanf(params, "ds[24]", garageid, garagepass)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /agaragepass [garageid] [pass]"), SendClientMessageEx(playerid, COLOR_WHITE, "To remove the password on the garage set the password to 'none' ");
	format(GarageInfo[garageid][gar_Pass], 24, "%s", garagepass);
	SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of that garage.");
	SaveGarage(garageid);
	format(string, sizeof(string), "%s has edited Garage ID: %d's password to %s.", GetPlayerNameEx(playerid), garageid, garagepass);
	Log("logs/garage.log", string);
	return 1;
}

CMD:garagenext(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[128];
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available garage...");
		for(new x; x < MAX_GARAGES; x++)
		{
			if(GarageInfo[x][gar_ExteriorX] == 0.0)
			{
				format(string, sizeof(string), "%d is available to use.", x);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				break;
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:goingarage(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[48], garage;
		if(sscanf(params, "d", garage)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /goingarage [garageid]");
		if(garage < 0 || garage >= MAX_GARAGES)
		{
			format(string, sizeof(string), "Garage ID must be between 0 and %d.", MAX_GARAGES - 1);
			return SendClientMessageEx(playerid, COLOR_GREY, string);
		}
		SetPlayerPos(playerid, GarageInfo[garage][gar_InteriorX], GarageInfo[garage][gar_InteriorY], GarageInfo[garage][gar_InteriorZ]);
		SetPlayerFacingAngle(playerid, GarageInfo[garage][gar_InteriorA]);
		SetPlayerInterior(playerid, 1);
		PlayerInfo[playerid][pInt] = 1;
		PlayerInfo[playerid][pVW] = GarageInfo[garage][gar_InteriorVW];
		SetPlayerVirtualWorld(playerid, GarageInfo[garage][gar_InteriorVW]);
		Player_StreamPrep(playerid, GarageInfo[garage][gar_InteriorX], GarageInfo[garage][gar_InteriorY], GarageInfo[garage][gar_InteriorZ], FREEZE_TIME);
	}
	return 1;
}

CMD:gotogarage(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[48], garage;
		if(sscanf(params, "d", garage)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotogarage [garageid]");
		if(garage < 0 || garage >= MAX_GARAGES)
		{
			format(string, sizeof(string), "GarageID must be between 0 and %d.", MAX_GARAGES - 1);
			return SendClientMessageEx(playerid, COLOR_GREY, string);
		}
		if(GarageInfo[garage][gar_ExteriorX] == 0.0) return SendClientMessageEx(playerid, COLOR_GRAD2, "No exterior is set for this garage");
		SetPlayerInterior(playerid,GarageInfo[garage][gar_ExteriorInt]);
		SetPlayerPos(playerid,GarageInfo[garage][gar_ExteriorX],GarageInfo[garage][gar_ExteriorY],GarageInfo[garage][gar_ExteriorZ]);
		SetPlayerFacingAngle(playerid, GarageInfo[garage][gar_ExteriorA]);
		PlayerInfo[playerid][pInt] = GarageInfo[garage][gar_ExteriorInt];
		SetPlayerVirtualWorld(playerid, GarageInfo[garage][gar_ExteriorVW]);
		PlayerInfo[playerid][pVW] = GarageInfo[garage][gar_ExteriorVW];
		if(GarageInfo[garage][gar_CustomExterior]) Player_StreamPrep(playerid, GarageInfo[garage][gar_ExteriorX], GarageInfo[garage][gar_ExteriorY], GarageInfo[garage][gar_ExteriorZ], FREEZE_TIME);
	}
	return 1;
}

CMD:garagestatus(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	new garageid;
	if(sscanf(params, "i", garageid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /garagestatus [garageid]");
	new string[128];
	format(string,sizeof(string),"|___________ Garage Status (ID: %d) ___________|", garageid);
	SendClientMessageEx(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), "(Ext) X: %f | Y: %f | Z: %f | (Int) X: %f | Y: %f | Z: %f", GarageInfo[garageid][gar_ExteriorX], GarageInfo[garageid][gar_ExteriorY], GarageInfo[garageid][gar_ExteriorZ], GarageInfo[garageid][gar_InteriorX], GarageInfo[garageid][gar_InteriorY], GarageInfo[garageid][gar_InteriorZ]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Custom Ext: %d | Exterior VW: %d | Exterior Int: %d | Interior VW: %d | Locked: %d | Password: %s", GarageInfo[garageid][gar_CustomExterior], GarageInfo[garageid][gar_ExteriorVW], GarageInfo[garageid][gar_ExteriorInt], GarageInfo[garageid][gar_InteriorVW], GarageInfo[garageid][gar_Locked], GarageInfo[garageid][gar_Pass]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	return 1;
}

CMD:garagenear(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	new option, string[128];
	if(!sscanf(params, "d", option))
	{
		format(string, sizeof(string), "* Listing all garages within 30 meters of you in VW %d...", option);
		SendClientMessageEx(playerid, COLOR_RED, string);
		for(new i; i < MAX_GARAGES; i++)
		{
			if(GarageInfo[i][gar_InteriorX] != 0.0)
			{
				if(option == -1)
				{
					if(IsPlayerInRangeOfPoint(playerid, 30, GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]))
					{
						format(string, sizeof(string), "(Interior) Garage ID %d | %f from you", i, GetPlayerDistanceFromPoint(playerid, GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
					if(IsPlayerInRangeOfPoint(playerid, 30, GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]))
					{
						format(string, sizeof(string), "(Exterior) Garage ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]), GarageInfo[i][gar_ExteriorInt]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
				}
				else
				{
					if(IsPlayerInRangeOfPoint(playerid, 30, GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]) && GarageInfo[i][gar_InteriorVW] == option)
					{
						format(string, sizeof(string), "(Interior) Garage ID %d | %f from you", i, GetPlayerDistanceFromPoint(playerid, GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
					if(IsPlayerInRangeOfPoint(playerid, 30, GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]) && GarageInfo[i][gar_ExteriorVW] == option)
					{
						format(string, sizeof(string), "(Exterior) Garage ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]), GarageInfo[i][gar_ExteriorInt]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
				}
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing all garages within 30 meters of you...");
		for(new i; i < MAX_GARAGES; i++)
		{
			if(GarageInfo[i][gar_InteriorX] != 0.0)
			{
				if(IsPlayerInRangeOfPoint(playerid, 30, GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]) && GarageInfo[i][gar_InteriorVW] == GetPlayerVirtualWorld(playerid))
				{
					format(string, sizeof(string), "(Interior) Garage ID %d | %f from you", i, GetPlayerDistanceFromPoint(playerid, GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
				if(IsPlayerInRangeOfPoint(playerid, 30, GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]) && GarageInfo[i][gar_ExteriorVW] == GetPlayerVirtualWorld(playerid))
				{
					format(string, sizeof(string), "(Exterior) Garage ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]), GarageInfo[i][gar_ExteriorInt]);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
		}
	}
	return 1;
}

CMD:garagehelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GRAD2, "*** GARAGE *** /garagepass /lockgarage /changegaragepass");
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "*** GARAGE - Admin *** /garageedit /garageowner /agaragepass /garagenext /gotogarage /goingarage /garagenear /garagestatus /changeddtogarage");
	}
	return 1;
}

stock LoadGarages()
{
	printf("[LoadGarages] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `garages`", "OnLoadGarages", "");
}

forward OnLoadGarages();
public OnLoadGarages()
{
	new i, rows;
	cache_get_row_count(rows);

	while(i < rows)
	{
		cache_get_value_name_int(i, "id", GarageInfo[i][gar_SQLId]);
		cache_get_value_name_int(i, "Owner", GarageInfo[i][gar_Owner]);
		cache_get_value_name(i, "OwnerName", GarageInfo[i][gar_OwnerName], 24);
		cache_get_value_name_float(i, "ExteriorX", GarageInfo[i][gar_ExteriorX]);
		cache_get_value_name_float(i, "ExteriorY", GarageInfo[i][gar_ExteriorY]);
		cache_get_value_name_float(i, "ExteriorZ", GarageInfo[i][gar_ExteriorZ]);
		cache_get_value_name_float(i, "ExteriorA", GarageInfo[i][gar_ExteriorA]);
		cache_get_value_name_int(i, "ExteriorVW", GarageInfo[i][gar_ExteriorVW]);
		cache_get_value_name_int(i, "ExteriorInt", GarageInfo[i][gar_ExteriorInt]);
		cache_get_value_name_int(i, "CustomExterior", GarageInfo[i][gar_CustomExterior]);
		cache_get_value_name_float(i, "InteriorX", GarageInfo[i][gar_InteriorX]);
		cache_get_value_name_float(i, "InteriorY", GarageInfo[i][gar_InteriorY]);
		cache_get_value_name_float(i, "InteriorZ", GarageInfo[i][gar_InteriorZ]);
		cache_get_value_name_float(i, "InteriorA", GarageInfo[i][gar_InteriorA]);
		cache_get_value_name_int(i, "InteriorVW", GarageInfo[i][gar_InteriorVW]);
		cache_get_value_name(i, "Pass", GarageInfo[i][gar_Pass], 24);
		cache_get_value_name_int(i, "Locked", GarageInfo[i][gar_Locked]);
		if(GarageInfo[i][gar_ExteriorX] != 0.0) CreateGarage(i);
		i++;
	}
	if(i > 0) printf("[LoadGarages] %d garages rehashed/loaded.", i);
	else printf("[LoadGarages] Failed to load any garages.");
	return 1;
}

stock SaveGarage(garageid)
{
	new string[512];
	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `garages` SET \
		`Owner`=%d, \
		`OwnerName`='%e', \
		`ExteriorX`=%f, \
		`ExteriorY`=%f, \
		`ExteriorZ`=%f, \
		`ExteriorA`=%f, \
		`ExteriorVW`=%d, \
		`ExteriorInt`=%d, \
		`CustomExterior`=%d, \
		`InteriorX`=%f, \
		`InteriorY`=%f, \
		`InteriorZ`=%f, \
		`InteriorA`=%f, \
		`InteriorVW`=%d, \
		`Pass`='%e', \
		`Locked`=%d \
		WHERE `id`=%d",
		GarageInfo[garageid][gar_Owner],
		GarageInfo[garageid][gar_OwnerName],
		GarageInfo[garageid][gar_ExteriorX],
		GarageInfo[garageid][gar_ExteriorY],
		GarageInfo[garageid][gar_ExteriorZ],
		GarageInfo[garageid][gar_ExteriorA],
		GarageInfo[garageid][gar_ExteriorVW],
		GarageInfo[garageid][gar_ExteriorInt],
		GarageInfo[garageid][gar_CustomExterior],
		GarageInfo[garageid][gar_InteriorX],
		GarageInfo[garageid][gar_InteriorY],
		GarageInfo[garageid][gar_InteriorZ],
		GarageInfo[garageid][gar_InteriorA],
		GarageInfo[garageid][gar_InteriorVW],
		GarageInfo[garageid][gar_Pass],
		GarageInfo[garageid][gar_Locked],
		garageid
	);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock CreateGarage(garageid)
{
	if(IsValidDynamic3DTextLabel(GarageInfo[garageid][gar_TextID])) DestroyDynamic3DTextLabel(GarageInfo[garageid][gar_TextID]), GarageInfo[garageid][gar_TextID] = Text3D:-1;
	if(GarageInfo[garageid][gar_ExteriorX] == 0.0) return 1;
	new string[128];
	format(string, sizeof(string), "Garage | Owner: %s\nID: %d", StripUnderscore(GarageInfo[garageid][gar_OwnerName]), garageid);
	GarageInfo[garageid][gar_TextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, GarageInfo[garageid][gar_ExteriorX], GarageInfo[garageid][gar_ExteriorY], GarageInfo[garageid][gar_ExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GarageInfo[garageid][gar_ExteriorVW], GarageInfo[garageid][gar_ExteriorInt], -1);

	if(IsValidDynamicArea(GarageInfo[garageid][gar_AreaID])) DestroyDynamicArea(GarageInfo[garageid][gar_AreaID]);
	GarageInfo[garageid][gar_AreaID] = CreateDynamicSphere(GarageInfo[garageid][gar_ExteriorX], GarageInfo[garageid][gar_ExteriorY], GarageInfo[garageid][gar_ExteriorZ], 3, .worldid = GarageInfo[garageid][gar_ExteriorVW], .interiorid = GarageInfo[garageid][gar_ExteriorInt]);

	if(IsValidDynamicArea(GarageInfo[garageid][gar_AreaID_int])) DestroyDynamicArea(GarageInfo[garageid][gar_AreaID_int]);
	GarageInfo[garageid][gar_AreaID_int] = CreateDynamicSphere(GarageInfo[garageid][gar_InteriorX], GarageInfo[garageid][gar_InteriorY], GarageInfo[garageid][gar_InteriorZ], 3, .worldid = GarageInfo[garageid][gar_InteriorVW]);

	Streamer_SetIntData(STREAMER_TYPE_AREA, GarageInfo[garageid][gar_AreaID], E_STREAMER_EXTRA_ID, garageid);
	Streamer_SetIntData(STREAMER_TYPE_AREA, GarageInfo[garageid][gar_AreaID_int], E_STREAMER_EXTRA_ID, garageid);

	format(szMiscArray, sizeof(szMiscArray), "[Garage] Created Garage: %d | Exterior Area ID: %d | Interior Area ID: %d", garageid, GarageInfo[garageid][gar_AreaID], GarageInfo[garageid][gar_AreaID_int]);
	Log("debug/door_garage.log", szMiscArray);
	return 1;
}

forward OnSetGarageOwner(playerid, garageid);
public OnSetGarageOwner(playerid, garageid)
{
	if(IsPlayerConnected(playerid))
	{
		new rows;
		new string[128];
		cache_get_row_count(rows);

		if(rows)
		{
			cache_get_value_name_int(0, "id", GarageInfo[garageid][gar_Owner]);
			cache_get_value_name(0, "Username", GarageInfo[garageid][gar_OwnerName], MAX_PLAYER_NAME);
			format(string, sizeof(string), "Successfully set the owner to %s.", GarageInfo[garageid][gar_OwnerName]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			CreateGarage(garageid);
			SaveGarage(garageid);
			format(string, sizeof(string), "%s has edited Garage ID: %d's owner to %s (SQL ID: %d).", GetPlayerNameEx(playerid), garageid, GarageInfo[garageid][gar_OwnerName], GarageInfo[garageid][gar_Owner]);
			Log("logs/garage.log", string);
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "That account name does not appear to exist.");
	}
	return 1;
}

ReturnGarageLineDetails(playerid, garageid)
{
	new string[8];
	string = "N/A";
	if(garageid != 0 && GetPlayerSQLId(playerid) == GarageInfo[garageid][gar_Owner]) format(string, sizeof(string), "%d", garageid);
	return string;
}
