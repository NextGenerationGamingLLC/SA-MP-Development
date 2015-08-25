/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Fire System

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

CreateStructureFire(Float:FirePosX, Float:FirePosY, Float:FirePosZ, VW)
{
	if(iServerFires < MAX_STRUCTURE_FIRES)
	{
		new next = GetAvailableFireSlot();
		arrStructureFires[next][iFireObj] = CreateDynamicObject(18691, FirePosX, FirePosY, FirePosZ - 1.5, 0,0,0, VW, .streamdistance = 300);
		arrStructureFires[next][iFireArea] = CreateDynamicSphere(FirePosX, FirePosY, FirePosZ, 3.0, VW);

		arrStructureFires[next][fFirePos][0] = FirePosX;
		arrStructureFires[next][fFirePos][1] = FirePosY;
		arrStructureFires[next][fFirePos][2] = FirePosZ;

		Streamer_SetIntData(STREAMER_TYPE_OBJECT, arrStructureFires[next][iFireObj], E_STREAMER_EXTRA_ID, next);
		Streamer_SetIntData(STREAMER_TYPE_AREA, arrStructureFires[next][iFireArea], E_STREAMER_EXTRA_ID, next);
		
		arrStructureFires[next][iFireStrength] = MAX_FIRE_HEALTH;

		format(szMiscArray, sizeof(szMiscArray), "%d/%d\nID%d", arrStructureFires[next][iFireStrength], MAX_FIRE_HEALTH, next);
		arrStructureFires[next][szFireLabel] = CreateDynamic3DTextLabel(szMiscArray, 0xFFFFFFFFF, FirePosX, FirePosY, FirePosZ, 20, .worldid = VW);
		++iServerFires;
	}
}

DeleteStructureFire(iFireID)
{
	if(!IsValidDynamicObject(arrStructureFires[iFireID][iFireObj])) return 1;
	else DestroyDynamicObject(arrStructureFires[iFireID][iFireObj]), arrStructureFires[iFireID][iFireObj] = -1;
	if(IsValidDynamic3DTextLabel(arrStructureFires[iFireID][szFireLabel])) DestroyDynamic3DTextLabel(arrStructureFires[iFireID][szFireLabel]), arrStructureFires[iFireID][szFireLabel] = Text3D:-1;
	if(IsValidDynamicArea(arrStructureFires[iFireID][iFireArea])) DestroyDynamicArea(arrStructureFires[iFireID][iFireArea]);
	if(iServerFires) --iServerFires;
	return 1;
}

IsValidStructureFire(iFireID)
{
	if(IsValidDynamicObject(arrStructureFires[iFireID][iFireObj])) return true;
	else return false;
}

GetAvailableFireSlot()
{
	for(new i; i < MAX_STRUCTURE_FIRES; i++)
	{
		if(!IsValidDynamicObject(arrStructureFires[i][iFireObj])) return i;
	}
	return -1;
}

hook OnPlayerUpdate(playerid) {

	new newkeys, dir1, dir2;
	GetPlayerKeys(playerid, newkeys, dir1, dir2);
	
	if(ActiveKey(KEY_FIRE))
	{
		if(GetPlayerWeapon(playerid) == WEAPON_FIREEXTINGUISHER)
		{
			new n;
			for(n = 0; n < MAX_STRUCTURE_FIRES; n++)
			{
				if(IsValidStructureFire(n))
				{
					if(IsPlayerAimingAt(playerid, arrStructureFires[n][fFirePos][0], arrStructureFires[n][fFirePos][1], arrStructureFires[n][fFirePos][2], 1) \
					&& IsPlayerInRangeOfPoint(playerid, 4, arrStructureFires[n][fFirePos][0], arrStructureFires[n][fFirePos][1], arrStructureFires[n][fFirePos][2]))
					{
						arrStructureFires[n][iFireStrength] -=2;
						format(szMiscArray, sizeof(szMiscArray), "%d/%d\nID%d", arrStructureFires[n][iFireStrength], MAX_FIRE_HEALTH, n);
						UpdateDynamic3DTextLabelText(arrStructureFires[n][szFireLabel], 0xFFFFFFFF, szMiscArray);

						if(arrStructureFires[n][iFireStrength] <=0)
						{
							DeleteStructureFire(n);
						}
					}
				}
			}
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 407 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 601)
		{
			new n;
			for(n = 0; n < MAX_STRUCTURE_FIRES; n++)
			{
				if(IsValidStructureFire(n))
				{
					if(IsPlayerAimingAt(playerid, arrStructureFires[n][fFirePos][0], arrStructureFires[n][fFirePos][1], arrStructureFires[n][fFirePos][2], 3) \
					&& IsPlayerInRangeOfPoint(playerid, 20, arrStructureFires[n][fFirePos][0], arrStructureFires[n][fFirePos][1], arrStructureFires[n][fFirePos][2]))
					{
						arrStructureFires[n][iFireStrength] -=2;
						format(szMiscArray, sizeof(szMiscArray), "%d/%d\nID%d", arrStructureFires[n][iFireStrength], MAX_FIRE_HEALTH, n);
						UpdateDynamic3DTextLabelText(arrStructureFires[n][szFireLabel], 0xFFFFFFFF, szMiscArray);
						if(arrStructureFires[n][iFireStrength] <=0)
						{
							DeleteStructureFire(n);
						}
					}
				}
			}
		}
	}
	return 1;
}

hook OnPlayerEnterDynamicArea(playerid, areaid) {

	new i = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);

	if(-1 < i < MAX_STRUCTURE_FIRES) {
		
		if(arrStructureFires[i][iFireArea] == areaid) OnEnterFire(playerid, i);
	}
	return 1;
}

hook OnPlayerLeaveDynamicArea(playerid, areaid) {

	new i = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);

	if(-1 < i < MAX_STRUCTURE_FIRES) {

		if(arrStructureFires[i][iFireArea] == areaid) {

			DeletePVar(playerid, "pInFire");
		}
	}
	return 1;
}


forward OnEnterFire(i, fireid);
public OnEnterFire(i, fireid)
{
	if(GetPVarType(i, "pGodMode")) return 1;

	if(IsValidStructureFire(fireid))
	{
		if(!GetPVarType(i, "pInFire")) SetTimerEx("Fire_HealthTimer", 1000, false, "i", i);
		SetPVarInt(i, "pInFire", 1);
	}
	return 1;
}

forward Fire_HealthTimer(playerid);
public Fire_HealthTimer(playerid) {

	new Float:ftempHP;
	GetHealth(playerid, ftempHP);
	if(GetPlayerSkin(playerid) == 277 || GetPlayerSkin(playerid) == 278 || GetPlayerSkin(playerid) == 279) SetHealth(playerid, ftempHP - 5);
	else SetHealth(playerid, ftempHP - 20);

	if(GetPVarType(playerid, "pInFire")) SetTimerEx("Fire_HealthTimer", 1000, false, "i", playerid);
	return 1;
}

CMD:fires(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	if(GetPVarInt(playerid, "FireStart") != 1)
	{
		SetPVarInt(playerid, "FireStart", 1);
		SendClientMessageEx(playerid, COLOR_GREY, "You are now in fire creation mode");
		SendClientMessageEx(playerid, COLOR_GREY, "Please use a weapon and shoot whereever you wish to create a fire");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You have exited fire creation mode and are no longer able to create fires");
		DeletePVar(playerid, "FireStart");
	}
	return 1;
}

CMD:destroyfire(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	new fire;
	if(sscanf(params, "d", fire)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /destroyfire [fireid]");
	if(!(0 <= fire <= MAX_STRUCTURE_FIRES)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Fire ID!");
	DeleteStructureFire(fire);
	return 1;
}

CMD:destroyfires(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 2 && PlayerInfo[playerid][pFactionModerator] < 2) return 1;
	for(new i; i < MAX_STRUCTURE_FIRES; i++)
	{
		DeleteStructureFire(i);
	}
	return 1;
}

CMD:gotofire(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	new fire,
		Float:fPos[3];
	if(sscanf(params, "d", fire)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotofire [fireid]");
	if(!(0 <= fire <= MAX_STRUCTURE_FIRES)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Fire ID!");
	if(!IsValidStructureFire(fire)) return SendClientMessageEx(playerid, COLOR_GREY, "Fire has not been created!");
	GetDynamicObjectPos(arrStructureFires[fire][iFireObj], fPos[0], fPos[1], fPos[2]);
	SetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	return 1;
}

CMD:setfstrength(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	new fire, strength;
	if(sscanf(params, "dd", fire, strength)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setfstrength [fireid] [strength]");
	if(!(0 <= fire <= MAX_STRUCTURE_FIRES)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Fire ID!");
	if(!IsValidStructureFire(fire)) return SendClientMessageEx(playerid, COLOR_GREY, "Fire has not been created!");
	arrStructureFires[fire][iFireStrength] = strength;
	return 1;
}
