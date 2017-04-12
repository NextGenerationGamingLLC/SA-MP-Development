#include <YSI\y_hooks>

#define 	MAX_MULTIPLE_CHARACTERS		3
#define 	PVAR_LOGIN_CHARCAM			"P_LCC"

new p_iLoginActors[MAX_MULTIPLE_CHARACTERS];


Login_FetchAccountsData(playerid)
{
	format(szMiscArray, sizeof(szMiscArray), "SELECT `id`, `Model` FROM `accounts` WHERE '%d' IN (`LinkedAccount0`, `LinkedAccount1`, `LinkedAccount2`) LIMIT 3", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, szMiscArray, true, "Login_OnFetchAccountsData", "i", playerid);
}

forward Login_OnFetchAccountsData(playerid);
public Login_OnFetchAccountsData(playerid)
{
	new iRows = cache_get_row_count();
	if(!iRows) return SendClientMessage(playerid, COLOR_RED, "Something went terribly wrong.");
	new iFields,
		iCount;
	cache_get_data(iRows, iFields, MainPipeline);
	while(iCount < iRows)
	{
		PlayerInfo[playerid][pAccountIDs][iCount] = cache_get_field_content_int(iCount, "id", MainPipeline);
		switch(iCount)
		{
			case 0: p_iLoginActors[iCount] = CreateActor(cache_get_field_content_int(iCount, "Model", MainPipeline), 5.7748, 14.1756, 1628.3788, 270.0);
			case 1: p_iLoginActors[iCount] = CreateActor(cache_get_field_content_int(iCount, "Model", MainPipeline), 6.0349, 15.4743, 1628.4349, 270.0);
			case 2: p_iLoginActors[iCount] = CreateActor(cache_get_field_content_int(iCount, "Model", MainPipeline), 5.9984, 16.3238, 1628.3381, 270.0);
		}
		iCount++;
	}
	Login_ChooseCharacter(playerid);
	return 1;
}

Login_ChooseCharacter(playerid)
{
	SetPVarInt(playerid, PVAR_LOGIN_CHARCAM, 1); // middle char
	SetPlayerVirtualWorld(playerid, playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerTime(playerid, 0, 0);
	SetPlayerWeather(playerid, 0);
	InterpolateCameraPos(playerid, 14.8219, 16.1507, 1632.1367, 10.0860, 15.5576, 1628.5403, 3000, CAMERA_MOVE);
	InterpolateCameraLookAt(playerid, 13.8253, 16.0869, 1631.7872, 9.0879, 15.5258, 1628.4460, 3000, CAMERA_MOVE);
}

Login_SwitchCamera(playerid, source, destination)
{
	SetPVarInt(playerid, PVAR_LOGIN_CHARCAM, destination);
	switch(source)
	{
		case 0:
		{
			InterpolateCameraPos(playerid, 9.1368, 12.0155, 1628.7153, 10.4134, 15.4542, 1628.7153, 3000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 8.3955, 12.6845, 1628.5813, 9.4166, 15.3944, 1628.5713, 3000, CAMERA_MOVE);
		}
		case 1:
		{
			switch(destination)
			{
				case 0:
				{
					InterpolateCameraPos(playerid, 10.4134, 15.4542, 1628.7153, 9.1368, 12.0155, 1628.7153, 3000, CAMERA_MOVE);
					InterpolateCameraLookAt(playerid, 9.4166, 15.3944, 1628.5713, 8.3955, 12.6845, 1628.5813, 3000, CAMERA_MOVE);
				}
				case 2:
				{
					InterpolateCameraPos(playerid, 10.4134, 15.4542, 1628.7153, 8.7182, 19.5138, 1628.7153, 3000, CAMERA_MOVE);
					InterpolateCameraLookAt(playerid, 9.4166, 15.3944, 1628.5713, 8.7182, 19.5138, 1628.7153, 3000, CAMERA_MOVE);
				}
			}
		}
		case 2:
		{
			InterpolateCameraPos(playerid, 8.7182, 19.5138, 1628.7153, 10.4134, 15.4542, 1628.7153, 3000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 8.0880, 18.7392, 1628.62133, 9.4166, 15.3944, 1628.5713, 3000, CAMERA_MOVE);			
		}
	}
}

Login_LoadCharacter(playerid, choice)
{
	g_mysql_SaveAccount(playerid);
	OnPlayerDisconnect(playerid, 1);
	format(szMiscArray, sizeof(szMiscArray), "SELECT `Username` FROM `accounts` WHERE `id` = %d LIMIT 1", PlayerInfo[playerid][pAccountIDs][choice]);
	mysql_tquery(MainPipeline, szMiscArray, true, "Login_OnLoadCharacter", "i", playerid);
}

forward Login_OnLoadCharacter(playerid);
public Login_OnLoadCharacter(playerid)
{
	new iRows,
		iFields,
		iCount,
		szName[MAX_PLAYER_NAME];
	cache_get_data(iRows, iFields, MainPipeline);
	cache_get_field_content(iCount, "Username", szName, MainPipeline, sizeof(szName));
	while(iCount < iRows)
	{
		SetPlayerName(playerid, szName);
		iCount++;
	}
	DeletePVar(playerid, PVAR_LOGIN_CHARCAM);
	for(new i; i < sizeof(p_iLoginActors); ++i) DestroyActor(p_iLoginActors[i]);
	g_mysql_LoadAccount(playerid);
	return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPVarInt(playerid, PVAR_LOGIN_CHARCAM))
	{
		new logincharacter = GetPVarInt(playerid, PVAR_LOGIN_CHARCAM);
		if(newkeys & KEY_LEFT)
		{
			if(logincharacter == 0) return 1;
			Login_SwitchCamera(playerid, logincharacter, logincharacter - 1);
			return 1;
		}
		if(newkeys & KEY_RIGHT)
		{
			if(logincharacter == 2) return 1;
			Login_SwitchCamera(playerid, logincharacter, logincharacter + 1);
			return 1;
		}
		if(newkeys & KEY_SPRINT)
		{
			Login_LoadCharacter(playerid, logincharacter);
			return 1;
		}
	}
	return 1;
}

CMD:charselection(playerid, params[])
{
	Login_FetchAccountsData(playerid);
	return 1;
}
