forward Player_StreamPrep(iPlayer, Float: fPosX, Float: fPosY, Float: fPosZ, iTime);
public Player_StreamPrep(iPlayer, Float: fPosX, Float: fPosY, Float: fPosZ, iTime) {
    if(sobeitCheckvar[iPlayer] == 0)
	{
		if(sobeitCheckIsDone[iPlayer] == 0)
		{
   			if(PlayerInfo[iPlayer][pAdmin] < 2)
   			{
   			    ShowNoticeGUIFrame(iPlayer, 4);
		    	sobeitCheckIsDone[iPlayer] = 1;
   				SetTimerEx("sobeitCheck", 10000, 0, "i", iPlayer);
				TogglePlayerControllable(iPlayer, false);
				return 1;
			}
		}
	}
	switch(GetPVarInt(iPlayer, "StreamPrep")) {
		case 0: {

			ShowNoticeGUIFrame(iPlayer, 4);
			TogglePlayerControllable(iPlayer, false);
			//GameTextForPlayer(iPlayer, "~w~Collecting position...", iTime * 2, 3);
			SetPVarInt(iPlayer, "StreamPrep", 1);
			SetTimerEx("Player_StreamPrep", iTime / 2, false, "ifffi", iPlayer, fPosX, fPosY, fPosZ, iTime);
		}
		case 1: {

			if(GetPlayerState(iPlayer) == PLAYER_STATE_DRIVER && !GetPVarType(iPlayer, "ShopTP"))
				SetVehiclePos(GetPlayerVehicleID(iPlayer), fPosX, fPosY, fPosZ + 2.0);

			else
				SetPlayerPos(iPlayer, fPosX, fPosY, fPosZ + 0.5);

			//GameTextForPlayer(iPlayer, "~w~Streaming objects...", iTime * 2, 3);
			SetPVarInt(iPlayer, "StreamPrep", 2);
			SetTimerEx("Player_StreamPrep", iTime / 2, false, "ifffi", iPlayer, fPosX, fPosY, fPosZ, iTime);
		}
		default: {
			//GameTextForPlayer(iPlayer, "~r~Loaded!", 1000, 3);
			HideNoticeGUIFrame(iPlayer);
			if(!PlayerInfo[iPlayer][pHospital]) TogglePlayerControllable(iPlayer, true);

			if(GetPlayerState(iPlayer) == PLAYER_STATE_DRIVER && !GetPVarType(iPlayer, "ShopTP"))
				SetVehiclePos(GetPlayerVehicleID(iPlayer), fPosX, fPosY, fPosZ);

			else
				SetPlayerPos(iPlayer, fPosX, fPosY, fPosZ);

			if(GetPVarType(iPlayer, "MedicCall")) {
				ClearAnimationsEx(iPlayer);
				PlayDeathAnimation(iPlayer);
			}
			DeletePVar(iPlayer, "StreamPrep");
		}
	}
	SetCameraBehindPlayer(iPlayer);
	Streamer_UpdateEx(iPlayer, fPosX, fPosY, fPosZ);
	return 1;
}