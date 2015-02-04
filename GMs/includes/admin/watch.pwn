CMD:watch(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not authorised to use this command.");
		return 1;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can not do this while spectating.");
		return 1;
	}
	if(isnull(params))
	{
	    // VIP gold room needs to be fixed
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /watch [location] (or /watch off)");
		SendClientMessageEx(playerid, COLOR_GRAD2, "General locations: gym, lspd, allsaints, countygen, grove, tgb, bank, motel, cityhall, mall");
        SendClientMessageEx(playerid, COLOR_GRAD2, "VIP locations: lsvip, sfvip, loungeview1, loungeview2, goldlounge, vipgarage");
        SendClientMessageEx(playerid, COLOR_GRAD2, "Point locations: mp1, df, mf1, dh, mp2, cl, mf2, sfd, ffc");
	}

	new Float: Pos[3], int, vw;

	// SAVING INITIAL POSITION TO TELEPORT BACK TO LATER
	if(!(strcmp(params, "off", true) == 0) && GetPVarFloat(playerid, "WatchLastx") == 0 && GetPVarFloat(playerid, "WatchLasty") == 0 && GetPVarFloat(playerid, "WatchLastz") == 0 && GetPVarInt(playerid, "WatchLastVW") == 0 && GetPVarInt(playerid, "WatchLastInt") == 0)
	{
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	vw = GetPlayerVirtualWorld(playerid);
	int = GetPlayerInterior(playerid);

	SetPVarFloat(playerid, "WatchLastx", Pos[0]);
	SetPVarFloat(playerid, "WatchLasty", Pos[1]);
	SetPVarFloat(playerid, "WatchLastz", Pos[2]);
	SetPVarInt(playerid, "WatchLastInt", int);
	SetPVarInt(playerid, "WatchLastVW", vw);
	}

	// GENERAL LOCATIONS
	if(strcmp(params, "gym", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Ganton gym.");
		SetPlayerPos(playerid, 2212.61, -1730.57, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2208.67, -1733.71, 27.48);
		SetPlayerCameraLookAt(playerid, 2225.25, -1723.1, 13.56);
	}
	else if(strcmp(params, "lspd", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the LSPD.");
		SetPlayerPos(playerid, 1504.23, -1700.17, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1500.21, -1691.75, 38.38);
		SetPlayerCameraLookAt(playerid, 1541.46, -1676.17, 13.55);
	}
	else if(strcmp(params, "allsaints", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching All Saints General Hospital.");
		SetPlayerPos(playerid, 1201.12, -1324, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1207.39, -1294.71, 24.61);
		SetPlayerCameraLookAt(playerid, 1181.72, -1322.65, 13.58);
	}
	else if(strcmp(params, "countygen", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching County General Hospital.");
		SetPlayerPos(playerid, 1989.24, -1461.38, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1981.79, -1461.55, 31.93);
		SetPlayerCameraLookAt(playerid, 2021.23, -1427.48, 13.97);
	}
	else if(strcmp(params, "grove", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Grove Street.");
		SetPlayerPos(playerid, 2489.09, -1669.88, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2459.82, -1652.68, 26.45);
		SetPlayerCameraLookAt(playerid, 2489.09, -1669.88, 13.34);
	}
	else if(strcmp(params, "tgb", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Ten Green Bottles.");
		SetPlayerPos(playerid, 2319.09, -1650.90, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2336.31, -1664.76, 24.98);
		SetPlayerCameraLookAt(playerid, 2319.09, -1650.90, 14.16);
	}
	else if(strcmp(params, "bank", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the Los Santos bank.");
		SetPlayerPos(playerid, 1466.24, -1023.05, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1502.28, -1044.47, 31.19);
		SetPlayerCameraLookAt(playerid, 1466.24, -1023.05, 23.83);
	}
	else if(strcmp(params, "motel", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Jefferson motel.");
		SetPlayerPos(playerid, 2215.73, -1163.39, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2203.05, -1152.81, 37.03);
		SetPlayerCameraLookAt(playerid, 2215.73, -1163.39, 25.73);
	}
	else if(strcmp(params, "cityhall", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Los Santos City Hall.");
		SetPlayerPos(playerid, 1478.936035, -1746.446655, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1447.461669, -1717.788085, 44.047473);
		SetPlayerCameraLookAt(playerid, 1478.936035, -1746.446655, 14.347633);
	}
	else if(strcmp(params, "mall", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Los Santos Mall.");
		SetPlayerPos(playerid, 1127.245483, -1451.613891, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1092.614868, -1499.197998, 42.018226);
		SetPlayerCameraLookAt(playerid, 1127.245483, -1451.613891, 15.796875);
	}


	// VIP LOCATIONS
	else if(strcmp(params, "lsvip", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the Los Santos VIP entrance.");
		SetPlayerPos(playerid, 1809.888427, -1570.615844, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1861.195190, -1533.169677, 33.800296);
		SetPlayerCameraLookAt(playerid, 1809.888427, -1570.615844, 13.465585);
	}
	else if(strcmp(params, "sfvip", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the San Fierro VIP entrance.");
		SetPlayerPos(playerid, -2437.302490, 508.727020, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, -2410.812011, 488.762603, 40.148445);
		SetPlayerCameraLookAt(playerid, -2437.302490, 508.727020, 29.933441);
	}
	else if(strcmp(params, "loungeview1", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the VIP Lounge.");
		SetPlayerPos(playerid, 2526.647949, 1431.128417, 7754.650390);
		SetPlayerInterior(playerid, 1);
		PlayerInfo[playerid][pInt] = 1;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2572.895996, 1424.583007, 7705.613769);
		SetPlayerCameraLookAt(playerid, 2555.148681, 1407.475708, 7699.584472);
	}
	else if(strcmp(params, "loungeview2", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the VIP Lounge.");
		SetPlayerPos(playerid, 2526.647949, 1431.128417, 7754.650390);
		SetPlayerInterior(playerid, 1);
		PlayerInfo[playerid][pInt] = 1;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2488.598388, 1419.864868, 7703.525390);
		SetPlayerCameraLookAt(playerid, 2519.420410, 1418.585693, 7697.718261);
	}
	else if(strcmp(params, "goldlounge", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the VIP Gold+ Lounge.");
  		SetPlayerPos(playerid, 2864.634277, 2290.584960, 1272.007568);
		SetPlayerInterior(playerid, 1);
		PlayerInfo[playerid][pInt] = 1;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid,2787.102050, 2392.162841, 1243.898681);
		SetPlayerCameraLookAt(playerid,2801.281982, 2404.575683, 1240.531127);
	}
	else if(strcmp(params, "vipgarage", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the VIP Garage.");
  		SetPlayerPos(playerid, -4412.440429, 867.361694, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, -4437.200683, 870.038269, 989.548767);
		SetPlayerCameraLookAt(playerid, -4412.440429, 867.361694, 986.708435);
	}


	// Points (mp1, df, mf1, dh, mp2, cl, mf2, sfd, ffc)
	else if(strcmp(params, "mp1", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Materials Pickup 1.");
  		SetPlayerPos(playerid, 1423.773437, -1320.386962, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1411.689941, -1352.002929, 24.477527);
		SetPlayerCameraLookAt(playerid, 1423.773437, -1320.386962, 13.554687);
	}
	else if(strcmp(params, "df", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Drug Factory.");
  		SetPlayerPos(playerid, 2206.402587, 1582.398681, -80.0);
		SetPlayerInterior(playerid, 1);
		PlayerInfo[playerid][pInt] = 1;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2222.844482, 1590.667968, 1002.612915);
		SetPlayerCameraLookAt(playerid, 2206.402587, 1582.398681, 999.976562);
	}
	else if(strcmp(params, "mf1", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Materials Factory 1.");
  		SetPlayerPos(playerid, 2172.315185, -2263.781250, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2206.363769, -2262.568359, 24.240808);
		SetPlayerCameraLookAt(playerid, 2172.315185, -2263.781250, 13.335824);
	}
	else if(strcmp(params, "dh", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the Drug House.");
  		SetPlayerPos(playerid, 323.577026, 1118.344116, -80.0);
		SetPlayerInterior(playerid, 5);
		PlayerInfo[playerid][pInt] = 5;
		SetPlayerVirtualWorld(playerid, 371);
		PlayerInfo[playerid][pVW] = 371;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 316.387817, 1123.946289, 1085.046020);
		SetPlayerCameraLookAt(playerid, 323.577026, 1118.344116, 1083.882812);
	}
	else if(strcmp(params, "mp2", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Materials Pickup 2.");
  		SetPlayerPos(playerid, 2390.212402, -2008.328491, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2410.285644, -2013.919433, 21.716161);
		SetPlayerCameraLookAt(playerid, 2390.212402, -2008.328491, 13.553703);
	}
	else if(strcmp(params, "cl", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Crack Lab.");
  		SetPlayerPos(playerid, 2346.013916, -1185.367065, -80.0);
		SetPlayerInterior(playerid, 5);
		PlayerInfo[playerid][pInt] = 5;
		SetPlayerVirtualWorld(playerid, 371);
		PlayerInfo[playerid][pVW] = 371;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2342.012207, -1180.969848, 1029.412353);
		SetPlayerCameraLookAt(playerid, 2346.013916, -1185.367065, 1027.976562);
	}
	else if(strcmp(params, "mf2", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Materials Factory 2.");
  		SetPlayerPos(playerid, 2282.298828, -1110.143798, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2306.088623, -1133.968627, 52.929584);
		SetPlayerCameraLookAt(playerid, 2282.298828, -1110.143798, 37.976562);
	}
	else if(strcmp(params, "sfd", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the San Fierro Docks.");
  		SetPlayerPos(playerid, -1576.488159, 50.301193, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, -1569.082153, 96.206344, 34.091339);
		SetPlayerCameraLookAt(playerid, -1576.488159, 50.301193, 17.328125);
	}
	else if(strcmp(params, "ffc", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Fossil Fuel Company.");
  		SetPlayerPos(playerid, -2139.215087, -248.235076, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, -2170.527832, -246.948257, 40.965312);
		SetPlayerCameraLookAt(playerid, -2139.215087, -248.235076, 36.515625);
	}


	// OFF
	else if(strcmp(params, "off", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are no longer watching any area.");
		SetPlayerPos(playerid, GetPVarFloat(playerid, "WatchLastx"), GetPVarFloat(playerid, "WatchLasty"), GetPVarFloat(playerid, "WatchLastz"));
		SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "WatchLastVW"));
		PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "WatchLastVW");
		SetPlayerInterior(playerid, GetPVarInt(playerid, "WatchLastInt"));
		PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "WatchLastInt");
		SetPlayerFacingAngle(playerid, 270.0);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid,1);
		DeletePVar(playerid,"WatchLastx");
		DeletePVar(playerid,"WatchLasty");
		DeletePVar(playerid,"WatchLastz");
		DeletePVar(playerid,"WatchLastVW");
		DeletePVar(playerid,"WatchLastInt");
	}
	return 1;
}