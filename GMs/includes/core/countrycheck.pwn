new bool:cCheck = false;
CMD:togcountrycheck(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return 0;
	if(cCheck)
		cCheck = false, SendClientMessageEx(playerid, -1, "Disabled");
	else
		cCheck = true, SendClientMessageEx(playerid, -1, "Enabled");
	return 1;
}

CountryCheck(playerid)
{
	if(cCheck == false) return 1;
	new ccGetUrl[68];
	format(ccGetUrl, sizeof(ccGetUrl), "jamie.ng-gaming.net/geocheck.php?ip=%s&id=%d", PlayerInfo[playerid][pIP], PlayerInfo[playerid][pId]);
	HTTP(playerid, HTTP_GET, ccGetUrl, "", "CountryCheckResponse");
	return 1;
}

forward CountryCheckResponse(playerid, response_code, data[]);
public CountryCheckResponse(playerid, response_code, data[]) {
	szMiscArray[0] = 0;
	if(response_code == 200) {
		new resCodeIndex = strfind(data, "GEORESULT:")+10;
		new resCode = strval(data[resCodeIndex]);
		if(data[resCodeIndex] != '4' && data[resCodeIndex] != '0' && data[resCodeIndex] !=  '1' && data[resCodeIndex] !=  '2' && data[resCodeIndex] !=  '3') 
		{ 
			resCode = '1'; 
		}
		/* Rescode response values:
		0 = Response error
		1 = Country code match / Allow login
		2 = Data submit error, IP/ID was missing or IP was invalid.
		3 = Country code mismatch, disallow login.
		*/
		switch(resCode) {
			case 0: {
				printf("GEOCHECK WARNING: Response error, returned %d (%s)", resCode, data[resCodeIndex]);
			}
			case 1: {
				// Allow login
			}
			 case 2: {
				 print("GEOCHECK WARNING: Invalid ID or IP input");
			}
			case 3: {
				format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) has failed their countrycode check and was auto-kicked.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pIP]);
				ABroadCast(COLOR_YELLOW, szMiscArray, 2);
				format(szMiscArray, sizeof(szMiscArray), "WARNING: %s(%d) (IP:%s) has failed their countrycode check and was auto-kicked.", GetPlayerNameEx(playerid), GetPVarInt(playerid, "pSQLID"), PlayerInfo[playerid][pIP]);
				Log("logs/geocheck.log", szMiscArray);
				SendClientMessage(playerid, COLOR_RED, "Your account is not set to log in from your current country. Make an Admin Request @ http://ng-gaming.net/forums");
				SetTimerEx("KickEx", 5000, 0, "i", playerid);
			}
			case 4: {
				format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) has attempted to log in while locked by the Geosecurity system, and was auto-kicked.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pIP]);
				ABroadCast(COLOR_YELLOW, szMiscArray, 2);
				format(szMiscArray, sizeof(szMiscArray), "WARNING: %s(%d) (IP:%s) has attempted to log in while locked by the Geosecurity system.", GetPlayerNameEx(playerid), GetPVarInt(playerid, "pSQLID"), PlayerInfo[playerid][pIP]);
				Log("logs/geocheck.log", szMiscArray);
				SendClientMessage(playerid, COLOR_RED, "Your account is locked due to numerous logins from incorrect countries. Make an Admin Request @ http://ng-gaming.net/forums");
				SetTimerEx("KickEx", 5000, 0, "i", playerid);
			}
			default: {
				printf("GEOCHECK: Unknown code returned, returned %d", resCode);
			}
		}
	}
	return 1;
}