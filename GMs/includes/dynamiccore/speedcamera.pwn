/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic Camera System 

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)
					
	* Copyright (c) 2014, Next Generation Gaming, LLC
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

CMD:speedcam(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessageEx(playerid, COLOR_GREY, "You cannot manage speed cameras whilst inside a vehicle.");

	if (IsACop(playerid) && PlayerInfo[playerid][pRank] == Group_GetMaxRank(PlayerInfo[playerid][pLeader]) || PlayerInfo[playerid][pAdmin] >= 1337)
	{
		ShowPlayerDialog(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
			Get nearest speedcamera", "Select", "Cancel");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You do not have permission to use this command.");
		return 1;
	}

	return 1;
}

CMD:gotospeedcam(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
	    new i;
	    if(sscanf(params, "d", i)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotospeedcam [Speedcam id]");
		if(i < 0 || i > MAX_SPEEDCAMERAS) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotospeedcam [Speedcam id]");
    	if (SpeedCameras[i][_scActive] == true)
    	{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ]);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ]);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			return 1;
    	}
	    else return SendClientMessageEx(playerid, COLOR_GRAD2, "That speed camera isn't active!");
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, " You are not authorized.");
	}
	return 1;
}