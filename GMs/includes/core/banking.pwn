/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Banking System

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

CMD:cashchecks(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422))
 	{
  		SendClientMessageEx(playerid, COLOR_GREY, "You are not at the bank!");
    	return 1;
	}
 	if(PlayerInfo[playerid][pCheckCash] > 0)
    {
    	GivePlayerCash(playerid,PlayerInfo[playerid][pCheckCash]);
     	PlayerInfo[playerid][pCheckCash] = 0;
      	SendClientMessageEx(playerid, COLOR_GRAD1, "You have successfully deposited all of your checks.");
       	return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You did not have any undeposited checks on hand.");
	}
	return 1;
}

CMD:pay(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
	new id, storageid, amount;

	if(sscanf(params, "ud", id, amount)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pay [player] [amount]");
	}
	/*if(sscanf(params, "udd", id, storageid, amount)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pay [player] [storageid] [amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "StorageIDs: (0) Pocket - (1) Equipped Storage Device");
		return 1;
	}

	if(storageid < 0 || storageid > 1) {
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /pay [player] [storageid] [amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "StorageIDs: (0) Pocket - (1) Equipped Storage Device");
		return 1;
	}

	// Find the storageid of the storagedevice.
	if(storageid == 1) {
		new bool:itemEquipped = false;
		for(new i = 0; i < 3; i++)
		{
			if(StorageInfo[playerid][i][sAttached] == 1) {
				storageid = i+1;
				itemEquipped = true;
			}
		}
		if(itemEquipped == false) return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a storage device equipped!");
	}*/
	else if(!IsPlayerConnected(id)) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else if(id == playerid) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can not use this command on yourself!");
	}
	else if(amount > 1000 && PlayerInfo[playerid][pLevel] < 3) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You must be level 3 to pay over $1,000 at a time.");
	}
	else if(!(1 <= amount <= 100000)) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "Don't go below $1, or above $100,000 at once.");
	}
	else if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
	}
	else if(PlayerInfo[playerid][pCash] < 0 || PlayerInfo[playerid][pAccount] < 0) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "Your cash on-hand or in the bank is currently at a negative value!");
	}
	else if((2 <= PlayerInfo[playerid][pAdmin] < 4) || (2 <= PlayerInfo[id][pAdmin] <= 4)) return 1;
	else if(ProxDetectorS(5.0, playerid, id)) {
		TransferStorage(id, -1, playerid, storageid, 1, amount, -1, -1);
		OnPlayerStatsUpdate(playerid);
		OnPlayerStatsUpdate(id);
		SetPVarInt(playerid, "LastTransaction", gettime());
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
	return 1;
}
