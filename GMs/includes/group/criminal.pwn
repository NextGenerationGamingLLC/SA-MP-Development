/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Criminal Group Type

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

CMD:togfamily(playerid, params[])
{
	return cmd_togfam(playerid, params);
}

CMD:togfam(playerid, params[])
{
	if (!gFam[playerid])
	{
		gFam[playerid] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have disabled family chat.");
	}
	else
	{
		gFam[playerid] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have enabled family chat.");
	}
	return 1;
}

CMD:safebalance(playerid, params[]) {
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID) {
		if(FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyUSafe] < 1) {
			SendClientMessageEx(playerid, COLOR_GRAD1, "Your family doesn't have a safe.");
		}
		else
		{
			new string[128];

			new weaponsinlocker;
			for(new s = 0; s < 10; s++)
			{
				if(FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyGuns][s] != 0)
				{
					weaponsinlocker++;
				}
			}

			format(string, sizeof(string), " Safe: %s | Gunlockers: %d/10 | Cash: $%d | Pot: %d | Crack: %d | Materials: %d | Heroin: %d", FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyName], weaponsinlocker, FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyCash], FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyPot], FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyCrack], FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyMats], FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyHeroin]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a family.");
	return 1;
}

CMD:safehelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________________");
	SendClientMessageEx(playerid, COLOR_WHITE, "SAFE HELP: Type a command for more information.");
	SendClientMessageEx(playerid, COLOR_WHITE, "SAFE: /safebalance /safedeposit /safewithdraw /fstoregun /fgetgun.");
	return 1;
}