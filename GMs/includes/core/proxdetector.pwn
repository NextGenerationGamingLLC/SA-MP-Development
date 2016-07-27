ProxDetector(Float: f_Radius, playerid, string[],col1,col2,col3,col4,col5, chat=0, chattype = -1, ooc = -1)
{
	if(GetPVarType(playerid, "WatchingTV")) return 1;

	new
		Float: f_playerPos[3];

	GetPlayerPos(playerid, f_playerPos[0], f_playerPos[1], f_playerPos[2]);
	new str[128];
	foreach(new i: Player)
	{
		if((InsidePlane[playerid] == GetPlayerVehicleID(i) && GetPlayerState(i) == 2) || (InsidePlane[i] == GetPlayerVehicleID(playerid) && GetPlayerState(playerid) == 2) || (InsidePlane[playerid] != INVALID_VEHICLE_ID && InsidePlane[playerid] == InsidePlane[i])) {
			SendClientMessageEx(i, col1, string);
		}
		else if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid)) {
			if(chat && ooc == -1 && IsPlayerInRangeOfPoint(i, f_Radius * 0.6, f_playerPos[0], f_playerPos[1], f_playerPos[2]) && PlayerInfo[i][pBugged] >= 0)
			{
				printf("");
				if(playerid == i)
				{
					format(str, sizeof(str), "{8D8DFF}(BUGGED) {CBCCCE}%s", string);
				}
				else {
					format(str, sizeof(str), "{8D8DFF}(BUG ID %d) {CBCCCE}%s", i,string);
				}
				if(PlayerInfo[playerid][pAdmin] >= 2 && PlayerInfo[playerid][pTogReports] == 1 || PlayerInfo[playerid][pAdmin] < 2 || PlayerInfo[i][pAdmin] >= 2 && PlayerInfo[i][pTogReports] == 1 || PlayerInfo[i][pAdmin] < 2) SendBugMessage(i, PlayerInfo[i][pBugged], str);
			}

			if(IsPlayerInRangeOfPoint(i, f_Radius / 16, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
				if(chattype != -1) ChatTrafficProcess(i, col1, string, chattype);
				else SendClientMessageEx(i, col1, string);
			}
			else if(IsPlayerInRangeOfPoint(i, f_Radius / 8, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
				if(chattype != -1) ChatTrafficProcess(i, col2, string, chattype);
				else SendClientMessageEx(i, col2, string);
			}
			else if(IsPlayerInRangeOfPoint(i, f_Radius / 4, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
				if(chattype != -1) ChatTrafficProcess(i, col3, string, chattype);
				else SendClientMessageEx(i, col3, string);
			}
			else if(IsPlayerInRangeOfPoint(i, f_Radius / 2, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
				if(chattype != -1) ChatTrafficProcess(i, col4, string, chattype);
				else SendClientMessageEx(i, col4, string);
			}
			else if(IsPlayerInRangeOfPoint(i, f_Radius, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
				if(chattype != -1) ChatTrafficProcess(i, col5, string, chattype);
				else SendClientMessageEx(i, col5, string);
			}
		}
		if(GetPVarInt(i, "BigEar") == 1 || GetPVarInt(i, "BigEar") == 6 && GetPVarInt(i, "BigEarPlayer") == playerid) {
			new string2[128] = "(BE) ";
			strcat(string2,string, sizeof(string2));
			SendClientMessageEx(i, col1,string);
		}
	}	
	return 1;
}

ProxDetectorS(Float:radi, playerid, targetid)
{
	if(GetPVarType(playerid, "WatchingTV")) return 1;
    if(Spectating[targetid] != 0 && PlayerInfo[playerid][pAdmin] < 2)
    {
    	return 0;
    }

	new
		Float: fp_playerPos[3];

	GetPlayerPos(targetid, fp_playerPos[0], fp_playerPos[1], fp_playerPos[2]);

	if(IsPlayerInRangeOfPoint(playerid, radi, fp_playerPos[0], fp_playerPos[1], fp_playerPos[2]) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid))
	{
		return 1;
	}
	return 0;
}

ProxDetectorWrap(playerid, string[], width, Float:wrap_radius, col1, col2, col3, col4, col5)
{
	if(strlen(string) > width)
	{
		new firstline[128], secondline[128];
		strmid(firstline, string, 0, 88);
		strmid(secondline, string, 88, 150);
		format(firstline, sizeof(firstline), "%s...", firstline);
		format(secondline, sizeof(secondline), "...%s", secondline);
		ProxDetector(wrap_radius, playerid, firstline, col1, col2, col3, col4, col5);
		ProxDetector(wrap_radius, playerid, secondline, col1, col2, col3, col4, col5);
	}
	else ProxDetector(wrap_radius, playerid, string, col1, col2, col3, col4, col5);
}
