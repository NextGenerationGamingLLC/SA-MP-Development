/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Inactivity System
						Jingles

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

#define INACTIVE_REGULAR 15552000 // 180 days
#define INACTIVE_BRONZE_VIP 1814400 // 21 days
#define INACTIVE_SILVER_VIP 2592000 // 30 days
#define INACTIVE_GOLD_VIP 5184000 // 60 days

/*
task Inactive_ResourceCheck[60000 * 60]() { // Every 1 hour.

	Inactive_CheckHouses();
}


Inactive_CheckHouses() {

	mysql_tquery(MainPipeline, "SELECT id FROM houses WHERE `Inactive` = 0 AND `Expire` < UNIX_TIMESTAMP(NOW()) AND `Ignore` = 0", true, "Inactive_OnCheckHouses", "");
}
*/

forward Inactive_OnCheckHouses();
public Inactive_OnCheckHouses() {

	new iRows,
		iFields,
		iCount,
		iHouseID;

	cache_get_data(iRows, iFields, MainPipeline);
	while(iCount < iRows) {

		iHouseID = cache_get_field_content_int(iCount, "id", MainPipeline);
		Inactive_ProcessProperty(iHouseID, 0);
		iCount++;
	}
}

Inactive_ProcessProperty(i, type) {

	new iOwnerID;
	switch(type) {

		case 0: { // Houses
			iOwnerID = HouseInfo[i][hOwnerID];
			HouseInfo[i][hLastLogin] = 0;
			HouseInfo[i][hExpire] = 0;
			HouseInfo[i][hInactive] = 1;
			HouseInfo[i][hValue] = 3000000;

			SaveHouse(i);
			ReloadHousePickup(i);

			format(szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET `Apartment` = '-1', `Apartment2` = '-1', `Apartment3` = '-1' WHERE `id` = '%d'", HouseInfo[i][hOwnerID]);
		}
	}
	mysql_tquery(MainPipeline, szMiscArray, false, "Inactive_OnProcessProperty", "iii", i, type, iOwnerID);
}

forward Inactive_OnProcessProperty(i, type, iOwnerID);
public Inactive_OnProcessProperty(i, type, iOwnerID) {

	if(type == 0) {
		/*
		format(szMiscArray, sizeof(szMiscArray), "INACTIVITY: House ID %d", i);
		DBLog(iOwnerID, INVALID_PLAYER_ID, "Inactivity", szMiscArray);
		*/
		format(szMiscArray, sizeof(szMiscArray), "[HOUSE]: Account ID %d's House ID %d was set to INACTIVE.", iOwnerID, i);
	}
	Log("logs/inactivity.log", szMiscArray);
}

Inactive_BuyProperty(playerid, i, type) {
	switch(type) {
		case 0: {
			HouseInfo[i][hLastLogin] = gettime();
			HouseInfo[i][hExpire] = gettime() + INACTIVE_REGULAR;
			HouseInfo[i][hInactive] = 0;
			format(szMiscArray, sizeof(szMiscArray), "[HOUSE]: %s (%d) bought House ID (%d) previously owned by %s (%d)",
				GetPlayerNameExt(playerid), PlayerInfo[playerid][pId], i, HouseInfo[i][hOwnerName], HouseInfo[i][hOwnerID]);
			Log("logs/inactivity.log", szMiscArray);
		}
	}
}

Inactive_CalcTime() {

	/*
	if(PlayerInfo[playerid][pDonateRank] == 0) return INACTIVE_REGULAR;
	if(PlayerInfo[playerid][pDonateRank] == 1) return INACTIVE_BRONZE_VIP;
	if(PlayerInfo[playerid][pDonateRank] == 2) return INACTIVE_SILVER_VIP;
	if(PlayerInfo[playerid][pDonateRank] == 3) return INACTIVE_GOLD_VIP;
	*/
	return INACTIVE_REGULAR;
}

/*
CMD:inactivitycheck(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_EXECUTIVE)) return 1;
	Inactive_ResourceCheck();
	cmd_admin(playerid, "[INACTIVITY]: All server properties are checked for their inactivity.");
	return 1;
}
*/