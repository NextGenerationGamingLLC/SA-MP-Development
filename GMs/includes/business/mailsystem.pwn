/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Mail System

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
#define		MAILBOX_RANGE	8.0

stock SaveMailboxes()
{
	for(new i = 0; i < MAX_MAILBOXES; i++)
	{
		SaveMailbox(i);
	}
	return 1;
}

stock IsAtPostOffice(playerid)
{
	return IsPlayerInRangeOfPoint(playerid,100.0,-262.0643, 6.0924, 2000.9038);
}

stock IsNearHouseMailbox(playerid)
{
	if (PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailZ])) return 1;
	if (PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailZ])) return 1;
	if (PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey3]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hMailZ])) return 1;	
	return 0;
}

stock IsNearPublicMailbox(playerid)
{
    for(new i = 0; i < sizeof(MailBoxes); i++) if (IsPlayerInRangeOfPoint(playerid, 3.0, MailBoxes[i][mbPosX], MailBoxes[i][mbPosY], MailBoxes[i][mbPosZ])) return 1;
	return 0;
}

stock DisplayStampDialog(playerid)
{
	ShowPlayerDialogEx(playerid, DIALOG_POSTAMP, DIALOG_STYLE_LIST, "Buy a stamp", "Regular Mail		$100\nPriority Mail		$250\nPremium Mail		$500 (Gold VIP+)\nGovernment Mail	Free", "Next", "Cancel");
}

stock RenderHouseMailbox(h)
{
	DestroyDynamicObject(HouseInfo[h][hMailObjectId]);
	DestroyDynamic3DTextLabel(HouseInfo[h][hMailTextID]);
	if (HouseInfo[h][hMailX] != 0.0)
	{
		HouseInfo[h][hMailObjectId] = CreateDynamicObject((HouseInfo[h][hMailType] == 1) ? 1478 : 3407, HouseInfo[h][hMailX], HouseInfo[h][hMailY], HouseInfo[h][hMailZ], 0, 0, HouseInfo[h][hMailA]);
		new string[10];
		format(string, sizeof(string), "HID: %d",h);
		HouseInfo[h][hMailTextID] = CreateDynamic3DTextLabel(string, 0xFFFFFF88, HouseInfo[h][hMailX], HouseInfo[h][hMailY], HouseInfo[h][hMailZ]+0.5,10.0, .streamdistance = 10.0);
	}
}

stock RenderStreetMailbox(id)
{
	DestroyDynamicObject(MailBoxes[id][mbObjectId]);
	DestroyDynamic3DTextLabel(MailBoxes[id][mbTextId]);
	if(MailBoxes[id][mbPosX] != 0.0)
	{
	    new string[128];
		MailBoxes[id][mbObjectId] = CreateDynamicObject(1258, MailBoxes[id][mbPosX], MailBoxes[id][mbPosY], MailBoxes[id][mbPosZ], 0.0, 0.0, MailBoxes[id][mbAngle], MailBoxes[id][mbVW], MailBoxes[id][mbInt], .streamdistance = 100.0);
		format(string,sizeof(string),"Mailbox (ID: %d)\nType /sendmail to send a letter.", id);
		MailBoxes[id][mbTextId] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, MailBoxes[id][mbPosX], MailBoxes[id][mbPosY], MailBoxes[id][mbPosZ] + 0.5, 10.0, .worldid = MailBoxes[id][mbVW], .testlos = 0, .streamdistance = 25.0);
	}
}

stock HasMailbox(playerid)
{
	if (PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID &&	HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailX] != 0.0) return 1;
	if (PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailX] != 0.0) return 1;
	if (PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hMailX] != 0.0) return 1;
	return 0;
}

stock GetFreeMailboxId()
{
    for (new i; i < MAX_MAILBOXES; i++) {
		if (MailBoxes[i][mbPosX] == 0.0) return i;
	}
	return -1;
}

stock ClearHouseMailbox(houseid)
{
	HouseInfo[houseid][hMailX] = 0.0;
	HouseInfo[houseid][hMailY] = 0.0;
	HouseInfo[houseid][hMailZ] = 0.0;
	HouseInfo[houseid][hMailA] = 0.0;
	HouseInfo[houseid][hMailType] = 0;
	SaveHouse(houseid);
}

stock ClearStreetMailbox(boxid)
{
	MailBoxes[boxid][mbVW] = 0;
	MailBoxes[boxid][mbInt] = 0;
	MailBoxes[boxid][mbModel] = 0;
	MailBoxes[boxid][mbPosX] = 0.0;
	MailBoxes[boxid][mbPosY] = 0.0;
	MailBoxes[boxid][mbPosZ] = 0.0;
	MailBoxes[boxid][mbAngle] = 0.0;
	SaveMailbox(boxid);
}

CMD:mailhelp(playerid, params[])
{
	SetPVarInt(playerid, "HelpResultCat0", 7);
	Help_ListCat(playerid, DIALOG_HELPCATOTHER1);
	return 1;
}

CMD:omailhelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Mail System Help");
	SendClientMessageEx(playerid, COLOR_GRAD2, "You can purchase writing paper from any 24/7 and send letters to your friends");
	SendClientMessageEx(playerid, COLOR_GRAD2, "and colleagues regardless of whether they are online or not. Letters can be sent");
	SendClientMessageEx(playerid, COLOR_GRAD2, "from your nearest Street Posting Box, or from your own mail box (at your own house)");
	SendClientMessageEx(playerid, COLOR_GRAD2, "and these will be delivered; time depending on which service you have purchased.");
	SendClientMessageEx(playerid, COLOR_GRAD3, "Mail System Commands: /sendmail /getmail /placemailbox /movemailbox /destroymailbox /postdirectory");
	if(PlayerInfo[playerid][pAdmin] > 3)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Admin Commands");
	    SendClientMessageEx(playerid, COLOR_GRAD1, "/createmailbox (Creates a street posting box)   /removemailbox [id] (Removes a street posting box)");
	    SendClientMessageEx(playerid, COLOR_GRAD1, "/gotomailbox [id] (Teleports to a street posting box)    /adestroymailbox [houseid] (Deletes a players mailbox)");
	}
	return 1;
}

CMD:sendmail(playerid, params[])
{
	if (!IsNearHouseMailbox(playerid) && !IsAtPostOffice(playerid) && !IsNearPublicMailbox(playerid)) {
    	return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at a post office, near a street mailbox, or your house mailbox.");
    }
	if (PlayerInfo[playerid][pPaper] < 1) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any papers left. You can buy some at a 24/7.");
	}
	if(GetPVarInt(playerid, "MailTime") > 0) {
	    new string[64];
		format(string, sizeof(string), "You must wait %d seconds before sending more mail.", GetPVarInt(playerid, "MailTime"));
		return SendClientMessageEx(playerid, COLOR_GREY, string);
	}
	DisplayStampDialog(playerid);
	return 1;
}

CMD:getmail(playerid, params[])
{
	if (!IsNearHouseMailbox(playerid) && !IsAtPostOffice(playerid)) {
	 	return SendClientMessageEx(playerid, COLOR_GREY, "You need to be near at a post office or near your house mailbox.");
	}
	DeletePVar(playerid, "UnreadMails");
	DisplayMails(playerid);
 	return 1;
}

CMD:createmailbox(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) {
        return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
    }

	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)	{
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You can not do this while spectating.");
	}

    new i = GetFreeMailboxId();
	if (i == -1) return	SendClientMessageEx(playerid, COLOR_GRAD1, "The maximum number of street mailboxes has been reached.");

	GetPlayerPos(playerid, MailBoxes[i][mbPosX], MailBoxes[i][mbPosY], MailBoxes[i][mbPosZ]);
	GetPlayerFacingAngle(playerid, MailBoxes[i][mbAngle]);
	MailBoxes[i][mbPosZ] -= 0.30;
	MailBoxes[i][mbInt] = GetPlayerInterior(playerid);
	MailBoxes[i][mbVW] = GetPlayerVirtualWorld(playerid);

	SaveMailbox(i);
	RenderStreetMailbox(i);

	new string[128], area[MAX_ZONE_NAME];
	format(string,sizeof(string),"You have successfully created a street mailbox with ID %d.", i);
	SendClientMessageEx(playerid, COLOR_GRAD2, string);
	GetPlayer2DZone(playerid, area, MAX_ZONE_NAME);
	format(string, sizeof(string), "Admin %s has placed street mailbox %d at %s", GetPlayerNameEx(playerid), i, area);
	Log("logs/mail.log", string);

	Streamer_UpdateEx(playerid, MailBoxes[i][mbPosX], MailBoxes[i][mbPosY], MailBoxes[i][mbPosZ]);

	return 1;

}

CMD:removemailbox(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) {
        return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
    }
	new id;
	if(sscanf(params, "d", id)) {
        return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /removemailbox [street mailbox id]");
    }
    if(id < 0 || id >= MAX_MAILBOXES) {
        return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid street mailbox ID.");
    }
    if(MailBoxes[id][mbPosX] == 0.0) {
        return SendClientMessageEx(playerid, COLOR_GRAD2, "No street mailbox found with that ID.");
    }

	ClearStreetMailbox(id);
	RenderStreetMailbox(id);

	new string[128], area[MAX_ZONE_NAME];
	format(string,sizeof(string),"You have successfully removed the street mailbox with ID %d.", id);
	SendClientMessageEx(playerid, COLOR_GRAD2, string);
	GetPlayer2DZone(playerid, area, MAX_ZONE_NAME);
	format(string, sizeof(string), "Administrator %s has removed a street mailbox %d, at %s", GetPlayerNameEx(playerid), id, area);
	Log("logs/mail.log", string);

    return 1;
}

CMD:gotomailbox(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) {
        return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
    }
	new id;
	if(sscanf(params, "d", id)) {
        SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotomailbox [street mailbox id]");
        return 1;
    }
    if(id < 0 || id >= MAX_MAILBOXES) {
        return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid street mailbox ID.");
    }
    if(MailBoxes[id][mbPosX] == 0.0) {
        return SendClientMessageEx(playerid, COLOR_GRAD2, "No street mailbox found with that ID.");
    }

	GameTextForPlayer(playerid, "~w~Teleporting", 5000, 1);
	SetPlayerVirtualWorld(playerid, MailBoxes[id][mbVW]);
	SetPlayerInterior(playerid, MailBoxes[id][mbInt]);
	SetPlayerPos(playerid,MailBoxes[id][mbPosX],MailBoxes[id][mbPosY] - 2.5,MailBoxes[id][mbPosZ]);
	PlayerInfo[playerid][pVW] = MailBoxes[id][mbVW];
	PlayerInfo[playerid][pInt] = MailBoxes[id][mbInt];

    return 1;
}

CMD:placemailbox(playerid, params[])
{
	if (PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID && PlayerInfo[playerid][pPhousekey2] == INVALID_HOUSE_ID && PlayerInfo[playerid][pPhousekey3] == INVALID_HOUSE_ID) {
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't own a house!");
	}
	if (PlayerInfo[playerid][pMailbox] < 1) {
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a mailbox item!");
	}
	new style;
	if (sscanf(params, "d", style)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /placemailbox [1 or 2] (1=wooden 2=steel)");
    }
	if (HasMailbox(playerid)) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You already have a mailbox placed. You cannot place more.");
	}
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You must be on foot to use this command!");
	}
	new h = InRangeOfWhichHouse(playerid, MAILBOX_RANGE);
	if (h == INVALID_HOUSE_ID) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not at your house!");
	}

	new Float: f_ZOffset;
	if (style == 1) f_ZOffset = -0.38; else if (style == 2) f_ZOffset = -0.95;
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid number!");

	PlayerInfo[playerid][pMailbox]--;

	GetPlayerPos(playerid, HouseInfo[h][hMailX], HouseInfo[h][hMailY], HouseInfo[h][hMailZ]);
	GetPlayerFacingAngle(playerid, HouseInfo[h][hMailA]);
	HouseInfo[h][hMailZ] += f_ZOffset;
	HouseInfo[h][hMailType] = style;
	SaveHouse(h);

	RenderHouseMailbox(h);

	SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully placed your mailbox!");
	SendClientMessageEx(playerid, COLOR_GRAD2, "HINT: If you need to change the location of your mailbox, you can type /movemailbox" );

	new szLog[128];
	format(szLog, sizeof(szLog), "%s(%d) has placed a mailbox for their house (House ID: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), h);
	Log("logs/house.log", szLog);

	return 1;
}

CMD:destroymailbox(playerid, params[])
{
	if (!HasMailbox(playerid)) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a placed mailbox.");
	}
	new h;
	if (PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailZ])) h = PlayerInfo[playerid][pPhousekey];
	else if (PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailZ])) h = PlayerInfo[playerid][pPhousekey2];
	else if (PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey3]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hMailZ])) h = PlayerInfo[playerid][pPhousekey3];
	else return SendClientMessageEx(playerid, COLOR_GREY, "You need to be near your mailbox.");

	ClearHouseMailbox(h);
	RenderHouseMailbox(h);
	SendClientMessageEx(playerid, COLOR_WHITE, "You have destroyed your mailbox.");

	new szLog[128];
	format(szLog, sizeof(szLog), "%s(%d) has destroyed their house mailbox (House ID: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), h);
	Log("logs/house.log", szLog);

	return 1;
}

CMD:movemailbox(playerid, params[])
{
	if (!HasMailbox(playerid)) {
   		return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a placed mailbox!");
   	}
	new h = InRangeOfWhichHouse(playerid, MAILBOX_RANGE);
	if (h == INVALID_HOUSE_ID || HouseInfo[h][hMailX] == 0.0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are too far away from your house door for the new location of your mailbox!");
	}
	GetPlayerPos(playerid, HouseInfo[h][hMailX], HouseInfo[h][hMailY], HouseInfo[h][hMailZ]);
	GetPlayerFacingAngle(playerid, HouseInfo[h][hMailA]);
	new Float: f_ZOffset;
	if (HouseInfo[h][hMailType] == 1) f_ZOffset = -0.38; else if (HouseInfo[h][hMailType] == 2) f_ZOffset = -0.95;
	HouseInfo[h][hMailZ] += f_ZOffset;
	SaveHouse(h);
    RenderHouseMailbox(h);
	SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully moved your mailbox to its new position!");
	return 1;
}

CMD:adestroymailbox(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) {
        return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
    }
    new houseid;
    if(sscanf(params,"d",houseid)) {
        return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adestroymailbox [houseid]");
    }
    if (houseid < 0 || houseid >= MAX_HOUSES) {
    	return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid house ID!");
	}
    if (HouseInfo[houseid][hMailX] == 0.0) {
    	return SendClientMessageEx(playerid, COLOR_GRAD2, "That house does not have a mailbox.");
	}

    ClearHouseMailbox(houseid);
	RenderHouseMailbox(houseid);

	new string[64];
	format(string, sizeof(string), "You have destroyed the mailbox of house %d.", houseid);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pPhousekey] == houseid || PlayerInfo[i][pPhousekey2] == houseid || PlayerInfo[i][pPhousekey3] == houseid)	{
			format(string, sizeof(string), "Administrator %s has destroyed your mailbox.", GetPlayerNameEx(playerid));
			SendClientMessageEx(i, COLOR_GREY, string);
			break;
		}
	}	

	format(string, sizeof(string), "Administrator %s has destroyed the mailbox of house %d.", GetPlayerNameEx(playerid), houseid);
	Log("logs/house.log", string);

	return 1;
}

CMD:postdirectory(playerid, params[])
{
	if (!IsAtPostOffice(playerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You're not at a post office!");
	}
	if(strcmp(params, "on", true) == 0)	{
	    PlayerInfo[playerid][pMailEnabled] = 1;
		SendClientMessage(playerid, COLOR_WHITE, "You have enabled look up in the postal directory.");
    }
    else if(strcmp(params, "off", true) == 0)	{
	    PlayerInfo[playerid][pMailEnabled] = 0;
        SendClientMessage(playerid, COLOR_WHITE, "You have disabled look up in the postal directory.");
    }
    else {
	    SendClientMessage(playerid, COLOR_GREY, "USAGE: /postdirectory [on/off]");
    }
	return 1;
}

CMD:mnear(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	SendClientMessageEx(playerid, COLOR_RED, "* Listing all mailboxes within 30 meters of you...");
	for(new i, szMessage[32]; i < MAX_HOUSES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 30, HouseInfo[i][hMailX], HouseInfo[i][hMailY], HouseInfo[i][hMailZ]))
		{
			format(szMessage, sizeof(szMessage), "ID %d | %f from you", i, GetPlayerDistanceFromPoint(playerid, HouseInfo[i][hMailX], HouseInfo[i][hMailY], HouseInfo[i][hMailZ]));
			SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
		}
	}
	return 1;
}