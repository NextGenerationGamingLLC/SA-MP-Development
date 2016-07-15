/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Tutorial System

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

stock ShowTutGUIFrame(playerid, frame)
{
	switch(frame)
	{
		case 1:
		{
			for(new i = 4; i < 14; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 2:
		{
			for(new i = 14; i < 18; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 3:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[18]);
		}
		case 4:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[19]);
		}
		case 5:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[20]);
		}
		case 6:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[21]);
		}
		case 7:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[22]);
		}
		case 8:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[23]);
		}
		case 9:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[24]);
		}
		case 10:
		{
			for(new i = 25; i < 34; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 11:
		{
			for(new i = 34; i < 40; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 12:
		{
			for(new i = 40; i < 46; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 13:
		{
			for(new i = 46; i < 52; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 14:
		{
			for(new i = 52; i < 58; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 15:
		{
			for(new i = 58; i < 65; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 16:
		{
			for(new i = 65; i < 71; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 17:
		{
			for(new i = 71; i < 77; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 18:
		{
			for(new i = 77; i < 82; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 19:
		{
			for(new i = 82; i < 87; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 20:
		{
			for(new i = 87; i < 93; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 21:
		{
			for(new i = 93; i < 100; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 22:
		{
			for(new i = 100; i < 108; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 23:
		{
			for(new i = 108; i < 114; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
	}
}

stock HideTutGUIFrame(playerid, frame)
{
	switch(frame)
	{
		case 1:
		{
			for(new i = 4; i < 14; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 2:
		{
			for(new i = 14; i < 18; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 3:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[18]);
		}
		case 4:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[19]);
		}
		case 5:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[20]);
		}
		case 6:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[21]);
		}
		case 7:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[22]);
		}
		case 8:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[23]);
		}
		case 9:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[24]);
		}
		case 10:
		{
			for(new i = 25; i < 34; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 11:
		{
			for(new i = 34; i < 40; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 12:
		{
			for(new i = 40; i < 46; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 13:
		{
			for(new i = 46; i < 52; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 14:
		{
			for(new i = 52; i < 58; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 15:
		{
			for(new i = 58; i < 65; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 16:
		{
			for(new i = 65; i < 71; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 17:
		{
			for(new i = 71; i < 77; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 18:
		{
			for(new i = 77; i < 82; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 19:
		{
			for(new i = 82; i < 87; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 20:
		{
			for(new i = 87; i < 93; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 21:
		{
			for(new i = 93; i < 100; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 22:
		{
			for(new i = 100; i < 108; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 23:
		{
			for(new i = 108; i < 114; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
	}
}

stock ShowTutGUIBox(playerid)
{
	InsideTut{playerid} = true;

	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[10]);

	TextDrawShowForPlayer(playerid, TutTxtdraw[0]);
	TextDrawShowForPlayer(playerid, TutTxtdraw[1]);
	TextDrawShowForPlayer(playerid, TutTxtdraw[2]);
	TextDrawShowForPlayer(playerid, TutTxtdraw[3]);
	TextDrawShowForPlayer(playerid, TutTxtdraw[114]);

}

stock HideTutGUIBox(playerid)
{
	InsideTut{playerid} = false;

	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[10]);

	TextDrawHideForPlayer(playerid, TutTxtdraw[0]);
	TextDrawHideForPlayer(playerid, TutTxtdraw[1]);
	TextDrawHideForPlayer(playerid, TutTxtdraw[2]);
	TextDrawHideForPlayer(playerid, TutTxtdraw[3]);
	TextDrawHideForPlayer(playerid, TutTxtdraw[114]);
}

stock TutorialStep(playerid)
{
	if(gettime() - GetPVarInt(playerid, "pTutTime") < 5)
	{
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~r~PLEASE WAIT", 1100, 3);
		return 1;
	}

	if(InsideTut{playerid} < 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You can't use the command outside the tutorial.");
		return 1;
	}

    SetPVarInt(playerid, "pTutTime", gettime());
	switch(TutStep[playerid])
	{
		case 1:
		{
			HideTutGUIFrame(playerid, 1);
			ShowTutGUIFrame(playerid, 2);
			TutStep[playerid] = 2;
            SetPVarInt(playerid, "pTutTime", gettime()-4);

			// Los Santos Bank (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid, 1457.4854,-1011.5267,26.8438);
			SetPlayerPos(playerid, 1457.4854,-1011.5267,-10.0);
			SetPlayerCameraPos(playerid, 1457.5421,-1039.4404,28.4274);
			SetPlayerCameraLookAt(playerid, 1457.4854,-1011.5267,26.8438);
		}
		case 2:
		{
			ShowTutGUIFrame(playerid, 3);
			TutStep[playerid] = 3;
            SetPVarInt(playerid, "pTutTime", gettime()-4);
			// Los Santos ATM (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid, 2140.5173,-1163.9576,23.9922);
			SetPlayerPos(playerid, 2140.5173,-1163.9576,-10.0);
			SetPlayerCameraPos(playerid, 2145.8252,-1159.2659,27.7218);
			SetPlayerCameraLookAt(playerid, 2140.5173,-1163.9576,23.9922);
		}
		case 3:
		{
			ShowTutGUIFrame(playerid, 4);
			TutStep[playerid] = 4;
            SetPVarInt(playerid, "pTutTime", gettime()-4);
			// Fishing Pier (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid, 370.0804,-2087.8767,7.8359);
			SetPlayerPos(playerid, 370.0804,-2087.8767,-10.0);
			SetPlayerCameraPos(playerid, 423.3802,-2067.7915,29.8605);
			SetPlayerCameraLookAt(playerid, 370.0804,-2087.8767,7.8359);
		}
		case 4:
		{
			ShowTutGUIFrame(playerid, 5);
			TutStep[playerid] = 5;
            SetPVarInt(playerid, "pTutTime", gettime()-4);
			// Ganton Gym (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid, 2229.4968,-1722.0701,13.5625);
			SetPlayerPos(playerid, 2229.4968,-1722.0701,-10.0);
			SetPlayerCameraPos(playerid, 2211.1460,-1748.3909,29.3744);
			SetPlayerCameraLookAt(playerid, 2229.4968,-1722.0701,13.5625);
		}
		case 5:
		{
			ShowTutGUIFrame(playerid, 6);
			TutStep[playerid] = 6;
            SetPVarInt(playerid, "pTutTime", gettime()-4);
			// Arms Dealer (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid, 1366.1187,-1275.1248,13.5469);
			SetPlayerPos(playerid, 1366.1187,-1275.1248,-10.0);
			SetPlayerCameraPos(playerid, 1341.2936,-1294.8105,23.3096);
			SetPlayerCameraLookAt(playerid, 1366.1187,-1275.1248,13.5469);
		}
		case 6:
		{
			ShowTutGUIFrame(playerid, 7);
			TutStep[playerid] = 7;
            SetPVarInt(playerid, "pTutTime", gettime()-4);
			// Drugs Dealer (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid, 2167.5542,-1673.1503,15.0812);
			SetPlayerPos(playerid, 2167.5542,-1673.1503,-10.0);
			SetPlayerCameraPos(playerid, 2186.2607,-1693.4254,29.5406);
			SetPlayerCameraLookAt(playerid, 2167.5542,-1673.1503,15.0812);
		}
		case 7:
		{
			ShowTutGUIFrame(playerid, 8);
			TutStep[playerid] = 8;
            SetPVarInt(playerid, "pTutTime", gettime()-4);
			// Drugs Smuggler (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid, 59.9634,-283.6652,1.5781);
			SetPlayerPos(playerid, 59.9634,-283.6652,-10.0);
			SetPlayerCameraPos(playerid, 96.4630,-216.5790,34.2965);
			SetPlayerCameraLookAt(playerid, 59.9634,-283.6652,1.5781);
		}
		case 8:
		{
			ShowTutGUIFrame(playerid, 9);
			TutStep[playerid] = 9;
		}
		case 9:
		{
			for(new f = 2; f < 10; f++)
			{
				HideTutGUIFrame(playerid, f);
			}
			ShowTutGUIFrame(playerid, 10);
			TutStep[playerid] = 10;

			// LSPD (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid, 1554.3381,-1675.5692,16.1953);
			SetPlayerPos(playerid, 1554.3381,-1675.5692,-10.0);
			SetPlayerCameraPos(playerid, 1514.7783,-1700.2913,36.7506);
			SetPlayerCameraLookAt(playerid, 1554.3381,-1675.5692,16.1953);
		}
		case 10:
		{
			HideTutGUIFrame(playerid, 10);
			ShowTutGUIFrame(playerid, 11);
			TutStep[playerid] = 11;

			// All Saints (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1175.5581,-1324.7922,18.1610);
			SetPlayerPos(playerid, 1188.4574,-1309.2242,-10.0);
			SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
			SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);
		}
		case 11:
		{
			HideTutGUIFrame(playerid, 11);
			ShowTutGUIFrame(playerid, 12);
			TutStep[playerid] = 12;

			// San Andreas News (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,643.6738,-1348.9811,17.7879);
			SetPlayerPos(playerid, 643.6738,-1348.9811,-10.0);
			SetPlayerCameraPos(playerid,616.4327,-1336.6818,20.9202);
			SetPlayerCameraLookAt(playerid,643.6738,-1348.9811,17.7879);
		}
		case 12:
		{
			HideTutGUIFrame(playerid, 12);
			ShowTutGUIFrame(playerid, 13);
			TutStep[playerid] = 13;

			// Government (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1478.4708,-1754.7579,16.7400);
			SetPlayerPos(playerid, 1478.4708,-1754.7579,-10.0);
			SetPlayerCameraPos(playerid,1520.2188,-1712.0742,40.5350);
			SetPlayerCameraLookAt(playerid,1478.4708,-1754.7579,16.7400);
		}
		case 13:
		{
			HideTutGUIFrame(playerid, 13);
			ShowTutGUIFrame(playerid, 14);
			TutStep[playerid] = 14;

			// TR (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,-2679.5342,1639.0643,65.8865);
			SetPlayerPos(playerid, -2679.5342,1639.0643,-10.0);
			SetPlayerCameraPos(playerid,-2734.3477,1520.4971,87.1810);
			SetPlayerCameraLookAt(playerid,-2679.5342,1639.0643,65.8865);
		}
		case 14:
		{
			HideTutGUIFrame(playerid, 14);
			ShowTutGUIFrame(playerid, 15);
			TutStep[playerid] = 15;

			// Gang SaC Beach (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,655.5394,-1867.2231,5.4609);
			SetPlayerPos(playerid, 655.5394,-1867.2231,-10.0);
			SetPlayerCameraPos(playerid,699.7435,-1936.7568,24.8646);
			SetPlayerCameraLookAt(playerid,655.5394,-1867.2231,5.4609);
		}
		case 15:
		{
			HideTutGUIFrame(playerid, 15);
			ShowTutGUIFrame(playerid, 16);
			TutStep[playerid] = 16;

			// 24/7 Store (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1315.6570,-898.7749,39.5781);
			SetPlayerPos(playerid, 1315.6570,-898.7749,-10.0);
			SetPlayerCameraPos(playerid,1315.4285,-922.5234,44.0355);
			SetPlayerCameraLookAt(playerid,1315.6570,-898.7749,39.5781);
		}
		case 16:
		{
			HideTutGUIFrame(playerid, 16);
			ShowTutGUIFrame(playerid, 17);
			TutStep[playerid] = 17;

			// Clothing Store (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1457.1664,-1138.0111,26.6261);
			SetPlayerPos(playerid, 1457.1664,-1138.0111,-10.0);
			SetPlayerCameraPos(playerid,1459.0411,-1156.4342,33.4464);
			SetPlayerCameraLookAt(playerid,1457.1664,-1138.0111,26.6261);
		}
		case 17:
		{
			HideTutGUIFrame(playerid, 17);
			ShowTutGUIFrame(playerid, 18);
			TutStep[playerid] = 18;

			// Car Dealership (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1656.6107,-1892.3878,13.5521);
			SetPlayerPos(playerid,1656.6107,-1892.3878,-10.0);
			SetPlayerCameraPos(playerid,1678.1699,-1863.5964,22.9622);
			SetPlayerCameraLookAt(playerid,1656.6107,-1892.3878,13.5521);
		}
		case 18:
		{
			HideTutGUIFrame(playerid, 18);
			ShowTutGUIFrame(playerid, 19);
			TutStep[playerid] = 19;

			// Los Santos (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1607.0160,-1510.8218,207.4438);
			SetPlayerPos(playerid,1607.0160,-1510.8218,-10.0);
			SetPlayerCameraPos(playerid,1850.1813,-1765.7552,81.9271);
			SetPlayerCameraLookAt(playerid,1607.0160,-1510.8218,207.4438);
		}
		case 19:
		{
			HideTutGUIFrame(playerid, 19);
			ShowTutGUIFrame(playerid, 20);
			TutStep[playerid] = 20;

			// VIP (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1797.3397,-1578.3440,14.0798);
			SetPlayerPos(playerid,1797.3397,-1578.3440,-10.0);
			SetPlayerCameraPos(playerid,1832.1698,-1600.1538,32.2877);
			SetPlayerCameraLookAt(playerid,1797.3397,-1578.3440,14.0798);
		}
		case 20:
		{
			HideTutGUIFrame(playerid, 20);
			ShowTutGUIFrame(playerid, 21);
			TutStep[playerid] = 21;

			// Unity Station (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1716.1129,-1880.0715,22.0264);
			SetPlayerPos(playerid,1716.1129,-1880.0715,-10.0);
			SetPlayerCameraPos(playerid,1755.0413,-1824.8710,20.2100);
			SetPlayerCameraLookAt(playerid,1716.1129,-1880.0715,22.0264);
		}
		case 21:
		{
			HideTutGUIFrame(playerid, 21);
			ShowTutGUIFrame(playerid, 22);
			TutStep[playerid] = 22;
   			SetPVarInt(playerid, "pTutTime", gettime()-4);
			// Unity Station (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1716.1129,-1880.0715,22.0264);
			SetPlayerPos(playerid,1716.1129,-1880.0715,-10.0);
			SetPlayerCameraPos(playerid,1755.0413,-1824.8710,20.2100);
			SetPlayerCameraLookAt(playerid,1716.1129,-1880.0715,22.0264);
		}
		case 22:
		{
			HideTutGUIFrame(playerid, 22);
			ShowTutGUIFrame(playerid, 23);
			TutStep[playerid] = 23;
   			SetPVarInt(playerid, "pTutTime", gettime()+3);
			// Unity Station (Camera)
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1716.1129,-1880.0715,22.0264);
			SetPlayerPos(playerid,1716.1129,-1880.0715,-10.0);
			SetPlayerCameraPos(playerid,1755.0413,-1824.8710,20.2100);
			SetPlayerCameraLookAt(playerid,1716.1129,-1880.0715,22.0264);
		}
		case 23:
		{
			HideTutGUIBox(playerid);
			HideTutGUIFrame(playerid, 23);
			DeletePVar(playerid, "pTutTime");
			TutStep[playerid] = 24;
			/* TextDrawShowForPlayer(playerid, txtNationSelHelper);
			TextDrawShowForPlayer(playerid, txtNationSelMain);
    		PlayerNationSelection[playerid] = -1; */
			RegistrationStep[playerid] = 0;
			PlayerInfo[playerid][pTut] = 1;
			gOoc[playerid] = 0; gNews[playerid] = 0;
			TogglePlayerControllable(playerid, 0);
			SetCamBack(playerid);
			DeletePVar(playerid, "MedicBill");
			SetPlayerColor(playerid,TEAM_HIT_COLOR);
			SetPlayerInterior(playerid,0);
			SetHealth(playerid, 100);
			for(new x;x<10000;x++)
			{
				new rand=random(300);
				if(PlayerInfo[playerid][pSex] == 2)
				{
					if(IsValidSkin(rand) && IsFemaleSpawnSkin(rand))
					{
						PlayerInfo[playerid][pModel] = rand;
						SetPlayerSkin(playerid, rand);
						break;
					}
				}
				else
				{
					if(IsValidSkin(rand) && !IsFemaleSkin(rand))
					{
						PlayerInfo[playerid][pModel] = rand;
						SetPlayerSkin(playerid, rand);
						break;
					}
				}
			}
			SetCameraBehindPlayer(playerid);
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pNation] = 0;
			switch(random(2))
			{
				case 0:
				{
					SetPlayerPos(playerid, 1715.1201,-1903.1711,13.5665);
					SetPlayerFacingAngle(playerid, 360.0);
					InterpolateCameraPos(playerid, 1715.130615, -1905.752563, 165.564697, 1715.130615, -1905.752563, 14.295700, 8000, 1);
					InterpolateCameraLookAt(playerid, 1712.883056, -1902.467529, 165.168472, 1715.114868, -1901.757568, 14.095783, 8000, 1);
				}
				case 1:
				{
					SetPlayerPos(playerid, -1969.0737,138.1210,27.6875);
					SetPlayerFacingAngle(playerid, 90.0);
					InterpolateCameraPos(playerid, -1948.954711, 138.121002, 123.546340, -1965.578247, 138.121002, 28.462400, 8000, 1);
					InterpolateCameraLookAt(playerid, -1947.651367, 141.897277, 123.343559, -1969.573242, 138.121002, 28.262483, 8000, 1);
				}
			}
			SetTimerEx("DelaySetCameraBehindPlayer", 8000, 0, "i", playerid);
			if(emailcheck) InvalidEmailCheck(playerid, PlayerInfo[playerid][pEmail], 1);
		}
	}
	return 1;
}

CMD:next(playerid, params[])
{
	TutorialStep(playerid);
	return 1;
}

forward DelaySetCameraBehindPlayer(playerid);
public DelaySetCameraBehindPlayer(playerid) SetCameraBehindPlayer(playerid), TogglePlayerControllable(playerid, 1);