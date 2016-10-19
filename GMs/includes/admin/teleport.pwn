CMD:goto(playerid, params[])
{
    if(EventKernel[EventCreator] == playerid || PlayerInfo[playerid][pAdmin] >= 2)
	{
		new location[25], vw, int;
		if(sscanf(params, "s[25]D(0)D(0)", location, vw, int))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /goto [location] [(optional) virtual world] [(optional) interior]");
			SendClientMessageEx(playerid, COLOR_GRAD1, "Locations 1: LS,SF,LV,RC,ElQue,Bayside,LSVIP,SFVIP,LVVIP,Famed,MHC,stadium1");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Locations 2: stadium2,stadium3,stadium4,int1,mark,mark2,sfairport,dillimore,cave,doc,bank,mall,allsaints");
			SendClientMessageEx(playerid, COLOR_GRAD3, "Locations 3: countygen,cracklab,gym,rodeo,flint,idlewood,fbi,island,demorgan,doc,icprison,oocprison");
			SendClientMessageEx(playerid, COLOR_GRAD4, "Locations 4: garagesm,garagemed,garagelg,garagexlg,glenpark,palomino,nggshop, fc, unity, (l)os(c)olinas, SFDocks");
			return 1;
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "You can not do this while spectating.");
			return 1;
		}
        if(strcmp(location, "lascolinas", true) == 0 || strcmp(location, "lc", true) == 0)
        {
            if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2155.5400, -1011.4443, 62.9631);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 2155.5400, -1011.4443, 62.9631);
        }
		else if(strcmp(location,"glenpark",true) == 0 || strcmp(location,"gp",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2012.500366, -1264.768554, 23.547389);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1986.69, -1300.49, 25.03);
		}
		else if(strcmp(location,"palomino",true) == 0 || strcmp(location,"pc",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2229.485351, -63.457298, 26.134857);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 2231.578613, -48.729660, 26.484375);
		}
		else if(strcmp(location,"nggshop",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2930.920410, -1429.603637, 10.675988);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, 1);
				fVehSpeed[playerid] = 0.0;
			}
			else 
			{
				SetPlayerPos(playerid, 2957.967041, -1459.404541, 10.809198);
				SetPlayerVirtualWorld(playerid, 1);
			}
		}
		else if(strcmp(location,"sfdocks", true) == 0)
		{
			if(GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1576.40, 79.49, 3.95);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, -1576.40, 79.49, 3.55);
		}
		else if(strcmp(location,"ls",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1529.6,-1691.2,13.3);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1529.6,-1691.2,13.3);
		}
		else if(strcmp(location,"garagexlg",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1111.0139,1546.9510,5290.2793);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1111.0139,1546.9510,5290.2793);
		}
		else if(strcmp(location,"garagelg",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1192.8501,1540.0295,5290.2871);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1192.8501,1540.0295,5290.2871);
		}
		else if(strcmp(location,"garagemed",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1069.1473,1582.1029,5290.2529);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1069.1473,1582.1029,5290.2529);
		}
		else if(strcmp(location,"garagesm",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1198.1407,1589.2153,5290.2871);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1198.1407,1589.2153,5290.2871);
		}
		else if(strcmp(location,"cave",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1993.01, -1580.44, 86.39);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, -1993.01, -1580.44, 86.39);
		}
		else if(strcmp(location,"sfairport",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1412.5375,-301.8998,14.1411);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, -1412.5375,-301.8998,14.1411);
		}
		else if(strcmp(location,"sf",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1605.0,720.0,12.0);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, -1605.0,720.0,12.0);
		}
		else if(strcmp(location,"lv",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1699.2, 1435.1, 10.7);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1699.2,1435.1, 10.7);
		}
		else if(strcmp(location,"island",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -14.3755,-4472.8506, 4);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, -14.3755,-4472.8506, 4);
		}
		else if(strcmp(location,"cracklab",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2348.2871, -1146.8298, 27.3183);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 2348.2871, -1146.8298, 27.3183);
		}
		else if(strcmp(location,"bank",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1487.91, -1030.60, 23.66);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1487.91, -1030.60, 23.66);
		}
		else if(strcmp(location,"allsaints",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1192.78, -1292.68, 13.38);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1192.78, -1292.68, 13.38);
		}
		else if(strcmp(location,"countygen",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2000.05, -1409.36, 16.99);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 2000.05, -1409.36, 16.99);
		}
		else if(strcmp(location,"gym",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2227.60, -1674.89, 14.62);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 2227.60, -1674.89, 14.62);
   		}
		else if(strcmp(location,"fbi",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 344.77,-1526.08,33.28);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 344.77,-1526.08,33.28);
		}
  		else if(strcmp(location,"rc",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1253.70, 343.73, 19.41);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1253.70, 343.73, 19.41);
   		}
     	else if(strcmp(location,"lsvip",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1810.39, -1601.15, 13.54);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1810.39, -1601.15, 13.54);
		}
     	else if(strcmp(location,"sfvip",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -2433.63, 511.45, 30.38);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, -2433.63, 511.45, 30.38);
		}
       	else if(strcmp(location,"lvvip",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1875.7731, 1366.0796, 16.8998);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1875.7731, 1366.0796, 16.8998);
		}
		else if(strcmp(location,"demorgan",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 112.67, 1917.55, 18.72);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 112.67, 1917.55, 18.72);
		}
		else if(strcmp(location,"icprison",true) == 0)
		{
			Player_StreamPrep(playerid, 558.1121,1458.6663,6000.4712, FREEZE_TIME);
			SetPlayerInterior(playerid,1);
			PlayerInfo[playerid][pInt] = 1;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			return SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
		}
		else if(strcmp(location, "doc", true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1435.95, -2695.33, 13.90);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1435.95, -2695.33, 13.59);
		}
		else if(strcmp(location,"oocprison",true) == 0)
		{
			Player_StreamPrep(playerid, -1158.285644, 2894.152343, 9993.131835, FREEZE_TIME);
			SetPlayerInterior(playerid,1);
			PlayerInfo[playerid][pInt] = 1;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			return SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
		}
		else if(strcmp(location,"stadium1",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1424.93, -664.59, 1059.86);
				LinkVehicleToInterior(tmpcar, 4);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else 
			{
				SetPlayerPos(playerid, -1424.93, -664.59, 1059.86);
				SetPlayerInterior(playerid, 4);
				SetPlayerVirtualWorld(playerid, vw);
				return SendClientMessageEx(playerid, COLOR_GRAD1, "You have been teleported!");
			}
		}
		else if(strcmp(location,"stadium2",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1395.96, -208.20, 1051.28);
				LinkVehicleToInterior(tmpcar, 7);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else 
			{
				SetPlayerPos(playerid, -1395.96, -208.20, 1051.28);
				SetPlayerInterior(playerid, 7);
				SetPlayerVirtualWorld(playerid, vw);
				return SendClientMessageEx(playerid, COLOR_GRAD1, "You have been teleported!");
			}
		}
		else if(strcmp(location,"stadium3",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1410.72, 1591.16, 1052.53);
				LinkVehicleToInterior(tmpcar, 14);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else 
			{
				SetPlayerPos(playerid, -1410.72, 1591.16, 1052.53);
				SetPlayerInterior(playerid, 14);
				SetPlayerVirtualWorld(playerid, vw);
				return SendClientMessageEx(playerid, COLOR_GRAD1, "You have been teleported!");
			}
		}
		else if(strcmp(location,"stadium4",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1394.20, 987.62, 1023.96);
				LinkVehicleToInterior(tmpcar, 15);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
    		}
			else 
			{
				SetPlayerPos(playerid, -1394.20, 987.62, 1023.96);
				SetPlayerInterior(playerid, 15);
				SetPlayerVirtualWorld(playerid, vw);
				return SendClientMessageEx(playerid, COLOR_GRAD1, "You have been teleported!");
			}
		}
		else if(strcmp(location,"int1",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1416.107000,0.268620,1000.926000);
				LinkVehicleToInterior(tmpcar, 1);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else 
			{
				SetPlayerPos(playerid, 1416.107000,0.268620,1000.926000);
				SetPlayerInterior(playerid, 1);
				SetPlayerVirtualWorld(playerid, vw);
				return SendClientMessageEx(playerid, COLOR_GRAD1, "You have been teleported!");
			}
		}
		else if(strcmp(location,"mark",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, GetPVarFloat(playerid, "tpPosX1"), GetPVarFloat(playerid, "tpPosY1"), GetPVarFloat(playerid, "tpPosZ1"));
				LinkVehicleToInterior(tmpcar, GetPVarInt(playerid, "tpInt1"));
			}
			else
			{
				SetPlayerPos(playerid, GetPVarFloat(playerid, "tpPosX1"), GetPVarFloat(playerid, "tpPosY1"), GetPVarFloat(playerid, "tpPosZ1"));
			}
			SetPlayerInterior(playerid, GetPVarInt(playerid, "tpInt1"));
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You have been teleported!");
		}
		else if(strcmp(location,"mark2",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, GetPVarFloat(playerid, "tpPosX2"), GetPVarFloat(playerid, "tpPosY2"), GetPVarFloat(playerid, "tpPosZ2"));
				LinkVehicleToInterior(tmpcar, GetPVarInt(playerid, "tpInt2"));
			}
			else
			{
				SetPlayerPos(playerid, GetPVarFloat(playerid, "tpPosX2"), GetPVarFloat(playerid, "tpPosY2"), GetPVarFloat(playerid, "tpPosZ2"));
			}
			SetPlayerInterior(playerid, GetPVarInt(playerid, "tpInt2"));
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You have been teleported!");
		}
		else if(strcmp(location,"mall",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1133.71,-1464.52,15.77);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1133.71,-1464.52,15.77);
		}
		else if(strcmp(location,"elque",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1446.5997,2608.4478,55.8359);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, -1446.5997,2608.4478,55.8359);
		}
		else if(strcmp(location,"bayside",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -2465.1348,2333.6572,4.8359);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, -2465.1348,2333.6572,4.8359);
		}
		else if(strcmp(location,"dillimore",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 634.9734, -594.6402, 16.3359);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 634.9734, -594.6402, 16.3359);
		}
		else if(strcmp(location,"famed",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1020.29, -1129.06, 23.87);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1020.29, -1129.06, 23.87);
		}
		else if(strcmp(location,"rodeo",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 587.0106,-1238.3374,17.8049);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 587.0106,-1238.3374,17.8049);
		}
		else if(strcmp(location,"flint",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -108.1058,-1172.5293,2.8906);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, -108.1058,-1172.5293,2.8906);
		}
		else if(strcmp(location,"idlewood",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1955.1357,-1796.8896,13.5469);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1955.1357,-1796.8896,13.5469);
		}
		else if(strcmp(location,"mhc",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				Player_StreamPrep(playerid, 1700.2124, 1461.1771, 1145.7766, FREEZE_TIME);
				SetVehiclePos(tmpcar, 1700.2124, 1461.1771, 1145.7766);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else Player_StreamPrep(playerid, 1649.7531, 1463.1614, 1151.9687, FREEZE_TIME);
		}
		else if(strcmp(location,"fc",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -203.2537, 1105.27, 18.73);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, -203.2537, 1105.27, 18.73);

		}
		else if(strcmp(location,"unity",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1811.48, -1891.17, 12.3936);
				LinkVehicleToInterior(tmpcar, int);
				SetVehicleVirtualWorld(tmpcar, vw);
				fVehSpeed[playerid] = 0.0;
			}
			else SetPlayerPos(playerid, 1811.48, -1891.17, 12.3936);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /goto [location] [(optional) virtual world] [(optional) interior]");
			SendClientMessageEx(playerid, COLOR_GRAD1, "Locations 1: LS,SF,LV,RC,ElQue,Bayside,LSVIP,SFVIP,LVVIP,Famed,MHC,stadium1");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Locations 2: stadium2,stadium3,stadium4,int1,mark,mark2,sfairport,dillimore,cave,doc,bank,mall,allsaints");
			SendClientMessageEx(playerid, COLOR_GRAD3, "Locations 3: countygen,cracklab,gym,rodeo,flint,idlewood,fbi,island,demorgan,doc,icprison,oocprison");
			return SendClientMessageEx(playerid, COLOR_GRAD4, "Locations 4: garagesm,garagemed,garagelg,garagexlg,glenpark,palomino,nggshop, fc, unity, (l)os(c)olinas");
		}
		SetPlayerVirtualWorld(playerid, vw);
		SetPlayerInterior(playerid, int);
		PlayerInfo[playerid][pVW] = vw;
		PlayerInfo[playerid][pInt] = int;

		SendClientMessageEx(playerid, COLOR_GRAD1, "You have been teleported!");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:sendto(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], location[32], giveplayerid;
		if(sscanf(params, "s[32]u", location, giveplayerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sendto [location] [player]");
			SendClientMessageEx(playerid, COLOR_GRAD1, "Locations 1: LS,SF,LV,RC,ElQue,Bayside,LSVIP,SFVIP,LVVIP,MHC,Famed,stadium1");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Locations 2: stadium2,stadium3,stadium4,int1,mark,mark2,sfairport,dillimore,cave,doc,bank,mall,allsaints");
			SendClientMessageEx(playerid, COLOR_GRAD3, "Locations 3: countygen,cracklab,gym,rodeo,flint,idlewood,fbi,island,demorgan,doc,icprison,oocprison");
			SendClientMessageEx(playerid, COLOR_GRAD3, "Locations 4: glenpark, palomino, nggshop, fc, unity, LC (loscolinas), SFDocks");
			return 1;
		}
		if (!IsPlayerConnected(giveplayerid))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
			return 1;
		}
		if(PlayerInfo[giveplayerid][pAdmin] >= PlayerInfo[playerid][pAdmin])
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You can't perform this action on an equal or higher level administrator.");
			return 1;
		}
		if(GetPlayerState(giveplayerid) == PLAYER_STATE_SPECTATING)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "This person is currently in spectate mode.");
			return 1;
		}
		if(GetPVarType(giveplayerid, "IsInArena"))
		{
		    SetPVarInt(playerid, "tempPBP", giveplayerid);
		    format(string, sizeof(string), "%s (ID: %d) is currently in an active Paintball game.\n\nDo you want to force this player out?", GetPlayerNameEx(giveplayerid), giveplayerid);
		    ShowPlayerDialogEx(playerid, PBFORCE, DIALOG_STYLE_MSGBOX, "Paintball", string, "Yes", "No");
		    return 1;
		}
        else if(strcmp(location,"loscolinas",true) == 0 || strcmp(location,"lc",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2155.5400, -1011.4443, 62.9631);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2155.5400, -1011.4443, 62.9631);
			}
			format(string, sizeof(string), " You have sent %s to Los Colinas.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"glenpark",true) == 0 || strcmp(location,"gp",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2012.500366, -1264.768554, 23.547389);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1986.69, -1300.49, 25.03);
			}
			format(string, sizeof(string), " You have sent %s to Glen Park.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"palomino",true) == 0 || strcmp(location,"pc",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2229.485351, -63.457298, 26.134857);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2231.578613, -48.729660, 26.484375);
			}
			format(string, sizeof(string), " You have sent %s to Palomino Creek.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"nggshop",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2930.920410, -1429.603637, 10.675988);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 1);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2957.967041, -1459.404541, 10.809198);
			}
			format(string, sizeof(string), " You have sent %s to the NGG Shop.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 1);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"sfdocks", true) == 0)
		{
			if(GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1576.40, 79.49, 3.95);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1576.40, 79.49, 3.55);
			}
			format(string, sizeof(string), " You have sent %s to the SF Docks.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"ls",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1529.6,-1691.2,13.3);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1529.6,-1691.2,13.3);
			}
			format(string, sizeof(string), " You have sent %s to Los Santos.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"cave",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1993.01, -1580.44, 86.39);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1993.01, -1580.44, 86.39);
			}
			format(string, sizeof(string), " You have sent %s to crate cave.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
  		else if(strcmp(location, "sfairport", true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1412.5375, -301.8998, 14.1411);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1412.5375,-301.8998,14.1411);
			}
			format(string, sizeof(string), " You have sent %s to SF Airport.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location, "doc", true) == 0)
		{
			if(GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1435.95, -2695.33, 13.90);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1435.95, -2695.33, 13.59);
			}
			format(string, sizeof(string), " You have sent %s to DoC.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location, "cracklab", true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2348.2871, -1146.8298, 27.3183);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2348.2871, -1146.8298, 27.3183);
			}
			format(string, sizeof(string), " You have sent %s to Crack Lab.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"sf",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1605.0,720.0,12.0);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1605.0,720.0,12.0);
			}
			format(string, sizeof(string), " You have sent %s to San Fierro.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"dillimore",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 634.9734, -594.6402, 16.3359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 634.9734, -594.6402, 16.3359);
			}
			format(string, sizeof(string), " You have sent %s to Dillimore.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"lv",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1699.2, 1435.1, 10.7);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1699.2,1435.1, 10.7);
			}
			format(string, sizeof(string), " You have sent %s to Las Venturas.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"island",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -14.3755,-4472.8506, 4);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -14.3755,-4472.8506, 4);
			}
			format(string, sizeof(string), " You have sent %s to the Crate Island.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"bank",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1487.91, -1030.60, 23.66);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1487.91, -1030.60, 23.66);
			}
			format(string, sizeof(string), " You have sent %s to the bank.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"allsaints",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1192.78, -1292.68, 13.38);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1192.78, -1292.68, 13.38);
			}
			format(string, sizeof(string), " You have sent %s to All Saints.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"countygen",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2000.05, -1409.36, 16.99);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2000.05, -1409.36, 16.99);
			}
			format(string, sizeof(string), " You have sent %s to County General.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"gym",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2227.60, -1674.89, 14.62);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2227.60, -1674.89, 14.62);
			}
			format(string, sizeof(string), " You have sent %s to Ganton Gym.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

   		}
		else if(strcmp(location,"fbi",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 344.77,-1526.08,33.28);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 344.77,-1526.08,33.28);
			}
			format(string, sizeof(string), " You have sent %s to the FBI HQ.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
  		else if(strcmp(location,"rc",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1253.70, 343.73, 19.41);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1253.70, 343.73, 19.41);
			}
			format(string, sizeof(string), " You have sent %s to Red County.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

   		}
     	else if(strcmp(location,"lsvip",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1810.39, -1601.15, 13.54);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1810.39, -1601.15, 13.54);
			}
			format(string, sizeof(string), " You have sent %s to LS VIP.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
     	else if(strcmp(location,"sfvip",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -2433.63, 511.45, 30.38);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -2433.63, 511.45, 30.38);
			}
			format(string, sizeof(string), " You have sent %s to SF VIP.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
       	else if(strcmp(location,"lvvip",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1875.7731, 1366.0796, 16.8998);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1875.7731, 1366.0796, 16.8998);
			}
			format(string, sizeof(string), " You have sent %s to LV VIP.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"demorgan",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 112.67, 1917.55, 18.72);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 112.67, 1917.55, 18.72);
			}
			format(string, sizeof(string), " You have sent %s to DeMorgan.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"icprison",true) == 0)
		{
			if(PlayerInfo[giveplayerid][pJailTime] > 0)
			{
				SetPlayerInterior(giveplayerid, 10);
				new rand = random(sizeof(DocPrison));
				SetPlayerFacingAngle(giveplayerid, 0);
				SetPlayerPos(giveplayerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
				PhoneOnline[giveplayerid] = 1;
				PlayerInfo[giveplayerid][pWantedLevel] = 0;
				SetPlayerToTeamColor(giveplayerid);
				SetPlayerWantedLevel(giveplayerid, 0);
				PlayerInfo[giveplayerid][pVW] = 0;
				SetPlayerVirtualWorld(giveplayerid, 0);
				SetPlayerToTeamColor(giveplayerid);
				Player_StreamPrep(giveplayerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);
			}
			else
			{
				Player_StreamPrep(giveplayerid, -2069.76, -200.05, 991.53, FREEZE_TIME);
				SetPlayerInterior(giveplayerid,10);
				PlayerInfo[giveplayerid][pInt] = 10;
				SetPlayerVirtualWorld(giveplayerid, 0);
				PlayerInfo[giveplayerid][pVW] = 0;
			}
			format(string, sizeof(string), " You have sent %s to IC prison.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");

		}
		else if(strcmp(location,"oocprison",true) == 0)
		{
			if(PlayerInfo[giveplayerid][pJailTime] > 0)
			{
				SetPlayerInterior(giveplayerid,1);
				PlayerInfo[giveplayerid][pInt] = 1;
				ResetPlayerWeaponsEx(giveplayerid);
				PlayerInfo[giveplayerid][pWantedLevel] = 0;
				SetPlayerWantedLevel(giveplayerid, 0);
				PhoneOnline[giveplayerid] = 1;
				new rand = random(sizeof(OOCPrisonSpawns));
				Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
				SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
				SetPlayerSkin(giveplayerid, 50);
				SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
				Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
			}
			else
			{
				Player_StreamPrep(giveplayerid, -1158.285644, 2894.152343, 9993.131835, FREEZE_TIME);
				SetPlayerInterior(giveplayerid,1);
				PlayerInfo[giveplayerid][pInt] = 1;
				SetPlayerVirtualWorld(giveplayerid, 0);
				PlayerInfo[giveplayerid][pVW] = 0;
			}
			format(string, sizeof(string), " You have sent %s to OOC prison.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");

		}
		else if(strcmp(location,"stadium1",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1424.93, -664.59, 1059.86);
				LinkVehicleToInterior(tmpcar, 4);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1424.93, -664.59, 1059.86);
			}
			format(string, sizeof(string), " You have sent %s to Stadium 1.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,4);
			PlayerInfo[giveplayerid][pInt] = 4;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"stadium2",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1395.96, -208.20, 1051.28);
				LinkVehicleToInterior(tmpcar, 7);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1395.96, -208.20, 1051.28);
			}
			format(string, sizeof(string), " You have sent %s to Stadium 2.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,7);
			PlayerInfo[giveplayerid][pInt] = 7;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"stadium3",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1410.72, 1591.16, 1052.53);
				LinkVehicleToInterior(tmpcar, 14);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1410.72, 1591.16, 1052.53);
			}
			format(string, sizeof(string), " You have sent %s to Stadium 3.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,14);
			PlayerInfo[giveplayerid][pInt] = 14;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"stadium4",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1394.20, 987.62, 1023.96);
				LinkVehicleToInterior(tmpcar, 15);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
    		}
			else
			{
				SetPlayerPos(giveplayerid, -1394.20, 987.62, 1023.96);
			}
			format(string, sizeof(string), " You have sent %s to Stadium 4.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,15);
			PlayerInfo[giveplayerid][pInt] = 15;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"int1",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1416.107000,0.268620,1000.926000);
				LinkVehicleToInterior(tmpcar, 1);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1416.107000,0.268620,1000.926000);
			}
			format(string, sizeof(string), " You have sent %s to Int 1.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,1);
			PlayerInfo[giveplayerid][pInt] = 1;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"mark",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, GetPVarFloat(playerid, "tpPosX1"), GetPVarFloat(playerid, "tpPosY1"), GetPVarFloat(playerid, "tpPosZ1"));
				LinkVehicleToInterior(tmpcar, GetPVarInt(playerid, "tpInt1"));
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, GetPVarFloat(playerid, "tpPosX1"), GetPVarFloat(playerid, "tpPosY1"), GetPVarFloat(playerid, "tpPosZ1"));
			}
			format(string, sizeof(string), " You have sent %s to your first marked position.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SetPlayerInterior(playerid, GetPVarInt(playerid, "tpInt1"));
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
		}
		else if(strcmp(location,"mark2",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, GetPVarFloat(playerid, "tpPosX2"), GetPVarFloat(playerid, "tpPosY2"), GetPVarFloat(playerid, "tpPosZ2"));
				LinkVehicleToInterior(tmpcar, GetPVarInt(playerid, "tpInt2"));
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, GetPVarFloat(playerid, "tpPosX2"), GetPVarFloat(playerid, "tpPosY2"), GetPVarFloat(playerid, "tpPosZ2"));
			}
			format(string, sizeof(string), " You have sent %s to your second marked position.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SetPlayerInterior(playerid, GetPVarInt(playerid, "tpInt2"));
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
		}
		else if(strcmp(location,"mall",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1133.71,-1464.52,15.77);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1133.71,-1464.52,15.77);
			}
			format(string, sizeof(string), " You have sent %s to the mall.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"elque",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1446.5997,2608.4478,55.8359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1446.5997,2608.4478,55.8359);
			}
			format(string, sizeof(string), " You have sent %s to El Quebrados.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"bayside",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -2465.1348,2333.6572,4.8359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -2465.1348,2333.6572,4.8359);
			}
			format(string, sizeof(string), " You have sent %s to Bayside.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"famed",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1020.29, -1129.06, 23.87);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1020.29, -1129.06, 23.87);
			}
			format(string, sizeof(string), " You have sent %s to the Famed HQ.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"rodeo",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 587.0106,-1238.3374,17.8049);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 587.0106,-1238.3374,17.8049);
			}
			format(string, sizeof(string), " You have sent %s to Rodeo.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"flint",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -108.1058,-1172.5293,2.8906);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -108.1058,-1172.5293,2.8906);
			}
			format(string, sizeof(string), " You have sent %s to Flint County Gas Station.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"idlewood",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1955.1357,-1796.8896,13.5469);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1955.1357,-1796.8896,13.5469);
			}
			format(string, sizeof(string), " You have sent %s to Idlewood Gas Station.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"mhc",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				Player_StreamPrep(giveplayerid, 1700.2124, 1461.1771, 1145.7766, FREEZE_TIME);
				SetVehiclePos(tmpcar, 1700.2124, 1461.1771, 1145.7766);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				Player_StreamPrep(giveplayerid, 1649.7531, 1463.1614, 1151.9687, FREEZE_TIME);
			}
			format(string, sizeof(string), " You have sent %s to the Mile High Club.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"fc",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -203.2537, 1105.27, 18.73);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -203.2537, 1105.27, 18.73);
			}
			format(string, sizeof(string), " You have sent %s to Fort Carson.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"unity",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1811.48, -1891.17, 12.3936);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1811.48, -1891.17, 12.3936);
			}
			format(string, sizeof(string), " You have sent %s to Unity Station.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}
