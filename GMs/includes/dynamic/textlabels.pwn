/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic Textlabel System 

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

CMD:tledit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] == 2 || PlayerInfo[playerid][pFactionModerator] == 2)
	{
		new string[128], choice[32], labelid, amount;
		if(sscanf(params, "s[32]dD", choice, labelid, amount))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /tledit [name] [labelid] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Position, Color, PickupModel, Delete");
			return 1;
		}

		if(labelid >= MAX_3DLABELS)
		{
			SendClientMessageEx( playerid, COLOR_WHITE, "Invalid Text Label ID!");
			return 1;
		}

		if(strcmp(choice, "position", true) == 0)
		{
			GetPlayerPos(playerid, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]);
			TxtLabels[labelid][tlInt] = GetPlayerInterior(playerid);
			TxtLabels[labelid][tlVW] = GetPlayerVirtualWorld(playerid);
			format(string, sizeof(string), "You have changed the position on Text Label #%d.", labelid);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			CreateTxtLabel(labelid);
			SaveTxtLabel(labelid);
			format(string, sizeof(string), "%s has edited Text Label ID %d's position.", GetPlayerNameEx(playerid), labelid);
			Log("logs/tledit.log", string);
			return 1;
		}
		else if(strcmp(choice, "color", true) == 0)
		{
			TxtLabels[labelid][tlColor] = amount;
			format(string, sizeof(string), "You have changed the color to %d on Text Label #%d.", amount, labelid);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			CreateTxtLabel(labelid);
			SaveTxtLabel(labelid);
			format(string, sizeof(string), "%s has edited Text Label ID %d's color.", GetPlayerNameEx(playerid), labelid);
			Log("logs/tledit.log", string);
			return 1;
		}
		else if(strcmp(choice, "pickupmodel", true) == 0)
		{
			TxtLabels[labelid][tlPickupModel] = amount;
			format(string, sizeof(string), "You have changed the pickup model to %d on Text Label #%d.", amount, labelid);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			CreateTxtLabel(labelid);
			SaveTxtLabel(labelid);
			format(string, sizeof(string), "%s has edited Text Label ID %d's PickupModel.", GetPlayerNameEx(playerid), labelid);
			Log("logs/tledit.log", string);
			return 1;
		}
		else if(strcmp(choice, "delete", true) == 0)
		{
			if(strcmp(TxtLabels[labelid][tlText], "None", true) == 0) {
				format(string, sizeof(string), "Text Label %d does not exist.", labelid);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
			if(IsValidDynamicPickup(TxtLabels[labelid][tlPickupID])) DestroyDynamicPickup(TxtLabels[labelid][tlPickupID]);
			if(IsValidDynamic3DTextLabel(TxtLabels[labelid][tlTextID])) DestroyDynamic3DTextLabel(TxtLabels[labelid][tlTextID]);
			TxtLabels[labelid][tlText] = 0;
			TxtLabels[labelid][tlPosX] = 0.0;
			TxtLabels[labelid][tlPosY] = 0.0;
			TxtLabels[labelid][tlPosZ] = 0.0;
			TxtLabels[labelid][tlVW] = 0;
			TxtLabels[labelid][tlInt] = 0;
			TxtLabels[labelid][tlColor] = 0;
			TxtLabels[labelid][tlPickupModel] = 0;
			SaveTxtLabel(labelid);
			format(string, sizeof(string), "You have deleted Text Label #%d.", labelid);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s has deleted Text Label %d.", GetPlayerNameEx(playerid), labelid);
			Log("logs/tledit.log", string);
			return 1;
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	return 1;
}

CMD:tltext(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] == 2 || PlayerInfo[playerid][pFactionModerator] == 2)
	{
		new szName[128], labelid;

		if(sscanf(params, "ds[128]", labelid, szName)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /tltext [labelid] [text]");
		}
		else if(!(0 <= labelid <= MAX_3DLABELS)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "Invalid door specified.");
		}
		else if(strfind(szName, "\r") != -1 || strfind(szName, "\n") != -1) {
			return SendClientMessageEx(playerid, COLOR_GREY, "Newline characters are forbidden.");
		}
		strcat((TxtLabels[labelid][tlText][0] = 0, TxtLabels[labelid][tlText]), szName, 128);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully changed the text on this text label.");
		CreateTxtLabel(labelid);
		SaveTxtLabel(labelid);
		format(szName, sizeof(szName), "%s has edited Text Label ID %d's text to %s.", GetPlayerNameEx(playerid), labelid, TxtLabels[labelid][tlText]);
		Log("logs/tledit.log", szName);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	return 1;
}

CMD:tlstatus(playerid, params[])
{
	new labelid;
	if(sscanf(params, "i", labelid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /tlstatus [labelid]");
		return 1;
	}
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] == 2 || PlayerInfo[playerid][pFactionModerator] == 2)
	{
		new string[128];
		format(string,sizeof(string),"|___________ Text Label Status (ID: %d) ___________|", labelid);
		SendClientMessageEx(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "[Position] X: %f | Y: %f | Z: %f | VW: %d | Int: %d", TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Text: %s | Color: %d | Pickup Model: %d", TxtLabels[labelid][tlText], TxtLabels[labelid][tlColor], TxtLabels[labelid][tlPickupModel]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return 1;
}

CMD:tlnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] == 2 || PlayerInfo[playerid][pFactionModerator] == 2)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available text label...");
		for(new x = 0;x<MAX_3DLABELS;x++)
		{
			if(TxtLabels[x][tlPosX] == 0)
			{
				new string[128];
				format(string, sizeof(string), "%d is available to use.", x);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				break;
			}
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	return 1;
}

CMD:gotolabel(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] == 2 || PlayerInfo[playerid][pFactionModerator] == 2)
	{
		new labelnum;
		if(sscanf(params, "d", labelnum)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotolabel [labelnumber]");

		SetPlayerPos(playerid,TxtLabels[labelnum][tlPosX],TxtLabels[labelnum][tlPosY],TxtLabels[labelnum][tlPosZ]);
		SetPlayerInterior(playerid,TxtLabels[labelnum][tlInt]);
		PlayerInfo[playerid][pInt] = TxtLabels[labelnum][tlInt];
		SetPlayerVirtualWorld(playerid, TxtLabels[labelnum][tlVW]);
		PlayerInfo[playerid][pVW] = TxtLabels[labelnum][tlVW];
	}
	return 1;
}

stock CreateTxtLabel(labelid)
{
	if(IsValidDynamicPickup(TxtLabels[labelid][tlPickupID])) DestroyDynamicPickup(TxtLabels[labelid][tlPickupID]);
	if(IsValidDynamic3DTextLabel(TxtLabels[labelid][tlTextID])) DestroyDynamic3DTextLabel(TxtLabels[labelid][tlTextID]);
	new string[128];
	format(string, sizeof(string), "%s\nID: %d",TxtLabels[labelid][tlText],labelid);

	switch(TxtLabels[labelid][tlColor])
	{
	    case -1:{ /* Disable 3d Textdraw */ }
	    case 1:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWWHITE, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 2:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWPINK, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 3:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWRED, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 4:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWBROWN, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 5:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWGRAY, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 6:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWOLIVE, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 7:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWPURPLE, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 8:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWORANGE, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 9:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWAZURE, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 10:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWGREEN, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 11:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWBLUE, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	    case 12:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_TWBLACK, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
		default:{TxtLabels[labelid][tlTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TxtLabels[labelid][tlVW], TxtLabels[labelid][tlInt], -1);}
	}

	switch(TxtLabels[labelid][tlPickupModel])
	{
	    case -1: { /* Disable Pickup */ }
		case 1:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1210, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 2:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1212, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 3:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1239, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 4:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1240, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 5:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1241, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 6:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1242, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 7:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1247, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 8:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1248, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 9:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1252, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 10:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1253, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 11:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1254, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 12:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1313, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 13:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1272, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 14:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1273, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 15:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1274, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 16:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1275, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 17:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1276, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 18:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1277, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 19:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1279, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 20:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1314, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 21:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1316, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 22:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1317, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 23:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1559, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 24:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(1582, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
		case 25:{TxtLabels[labelid][tlPickupID] = CreateDynamicPickup(2894, 23, TxtLabels[labelid][tlPosX], TxtLabels[labelid][tlPosY], TxtLabels[labelid][tlPosZ], TxtLabels[labelid][tlVW]);}
	    default: { }
	}
}

stock SaveTxtLabels()
{
	for(new i = 0; i < MAX_3DLABELS; i++)
	{
		SaveTxtLabel(i);
	}
	return 1;
}

stock RehashTxtLabel(labelid)
{
	printf("[RehashTxtLabel] Deleting Text Label #%d from server...", labelid);
	if(IsValidDynamicPickup(TxtLabels[labelid][tlPickupID])) DestroyDynamicPickup(TxtLabels[labelid][tlPickupID]);
	if(IsValidDynamic3DTextLabel(TxtLabels[labelid][tlTextID])) DestroyDynamic3DTextLabel(TxtLabels[labelid][tlTextID]);
	TxtLabels[labelid][tlSQLId] = -1;
	TxtLabels[labelid][tlPosX] = 0.0;
	TxtLabels[labelid][tlPosY] = 0.0;
	TxtLabels[labelid][tlPosZ] = 0.0;
	TxtLabels[labelid][tlVW] = 0;
	TxtLabels[labelid][tlInt] = 0;
	TxtLabels[labelid][tlColor] = 0;
	TxtLabels[labelid][tlPickupModel] = 0;
	LoadTxtLabel(labelid);
}

stock RehashTxtLabels()
{
	printf("[RehashTxtLabels] Deleting text labels from server...");
	for(new i = 0; i < MAX_3DLABELS; i++)
	{
		RehashTxtLabel(i);
	}
	LoadTxtLabels();
}

stock SaveTxtLabel(labelid)
{
	new string[1024];
	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `text_labels` SET \
		`Text`='%e', \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VW`=%d, \
		`Int`=%d, \
		`Color`=%d, \
		`PickupModel`=%d WHERE `id`=%d",
		TxtLabels[labelid][tlText],
		TxtLabels[labelid][tlPosX],
		TxtLabels[labelid][tlPosY],
		TxtLabels[labelid][tlPosZ],
		TxtLabels[labelid][tlVW],
		TxtLabels[labelid][tlInt],
		TxtLabels[labelid][tlColor],
		TxtLabels[labelid][tlPickupModel],
		labelid+1
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadTxtLabel(labelid)
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `text_labels` WHERE `id`=%d", labelid+1); // Array starts at zero, MySQL starts at 1.
	mysql_tquery(MainPipeline, string, "OnLoadTxtLabel", "i", labelid);
}

stock LoadTxtLabels()
{
	printf("[LoadTxtLabels] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `text_labels`", "OnLoadTxtLabels", "");
}

forward OnLoadTxtLabel(index);
public OnLoadTxtLabel(index)
{
	new rows;
	cache_get_row_count(rows);

	for(new row; row < rows; row++)
	{
		cache_get_value_name_int(row, "id", TxtLabels[index][tlSQLId]);
		cache_get_value_name(row, "Text", TxtLabels[index][tlText], 128);
		cache_get_value_name_float(row, "PosX", TxtLabels[index][tlPosX]);
		cache_get_value_name_float(row, "PosY", TxtLabels[index][tlPosY]);
		cache_get_value_name_float(row, "PosZ", TxtLabels[index][tlPosZ]);
		cache_get_value_name_int(row, "VW", TxtLabels[index][tlVW]); 
		cache_get_value_name_int(row, "Int", TxtLabels[index][tlInt]); 
		cache_get_value_name_int(row, "Color", TxtLabels[index][tlColor]);
		cache_get_value_name_int(row, "PickupModel", TxtLabels[index][tlPickupModel]); 
		if(TxtLabels[index][tlPosX] != 0.0) CreateTxtLabel(index);
	}
	return 1;
}

forward OnLoadTxtLabels();
public OnLoadTxtLabels()
{
	new i, rows;
	cache_get_row_count(rows);

	while(i < rows)
	{
		/*TxtLabels[i][tlSQLId] = cache_get_field_content_int(i, "id", MainPipeline);
		cache_get_field_content(i, "Text", TxtLabels[i][tlText], MainPipeline, 128);
		TxtLabels[i][tlPosX] = cache_get_field_content_float(i, "PosX", MainPipeline);
		TxtLabels[i][tlPosY] = cache_get_field_content_float(i, "PosY", MainPipeline);
		TxtLabels[i][tlPosZ] = cache_get_field_content_float(i, "PosZ", MainPipeline);
		TxtLabels[i][tlVW] = cache_get_field_content_int(i, "VW", MainPipeline); 
		TxtLabels[i][tlInt] = cache_get_field_content_int(i, "Int", MainPipeline); 
		TxtLabels[i][tlColor] = cache_get_field_content_int(i, "Color", MainPipeline);
		TxtLabels[i][tlPickupModel] = cache_get_field_content_int(i, "PickupModel", MainPipeline); 
		if(TxtLabels[i][tlPosX] != 0.0) CreateTxtLabel(i);*/
		LoadTxtLabel(i);
		i++;
	}
}