/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Contract Group Type

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

CMD:contracts(playerid, params[])
{
    if(IsAHitman(playerid) || PlayerInfo[playerid][pAdmin] >= 4)
	{
        SearchingHit(playerid);
    }
    return 1;
}

CMD:showmehq(playerid, params[])
{
    if(CheckPointCheck(playerid)) {
        SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
        return 1;
    }
	if (IsAHitman(playerid)) {
	    SetPlayerCheckpoint(playerid,-418.95, -1759.26, 6.22, 4.0);
	    GameTextForPlayer(playerid, "~w~Waypoint set ~r~HQ", 5000, 1);
	    gPlayerCheckpointStatus[playerid] = CHECKPOINT_HITMAN;
    }
    return 1;
}


CMD:showmehq2(playerid, params[])
{
    if(CheckPointCheck(playerid)) {
        SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
        return 1;
    }
	if (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 2 || arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == 2)
	{
	    SetPlayerCheckpoint(playerid,811.087707, -564.493835, 16.335937, 4.0);
	    GameTextForPlayer(playerid, "~w~Waypoint set ~r~HQ", 5000, 1);
	    gPlayerCheckpointStatus[playerid] = CHECKPOINT_HITMAN2;
    }
    return 1;
}


CMD:showmehq3(playerid, params[])
{
    if(CheckPointCheck(playerid)) {
        SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
        return 1;
    }
   	if (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 2 || arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == 2)
	{
    	SetPlayerCheckpoint(playerid, 1415.727905, -1299.371093, 15.054657, 4.0);
	    GameTextForPlayer(playerid, "~w~Waypoint set ~r~HQ", 5000, 1);
    	gPlayerCheckpointStatus[playerid] = CHECKPOINT_HITMAN3;
	}
    return 1;
}