/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					  Health System

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

new Float:PlayerHealth[MAX_PLAYERS],
	Float:PlayerArmor[MAX_PLAYERS];

forward SetHealth(playerid, Float:hp);
public SetHealth(playerid, Float:hp)
{
	PlayerHealth[playerid] = hp;
	//UpdateDynamic3DTextLabelText(PlayerLabel[playerid], 0xFFFFFFFF, GetHealthArmorForLabel(playerid));
	return SetPlayerHealth(playerid, hp);
}

forward GetHealth(playerid, &Float:hp);
public GetHealth(playerid, &Float:hp)
{
	hp = PlayerHealth[playerid];
	return 1;
}

forward SetArmour(playerid, Float:hp);
public SetArmour(playerid, Float:hp)
{
	PlayerArmor[playerid] = hp;
	//UpdateDynamic3DTextLabelText(PlayerLabel[playerid], 0xFFFFFFFF, GetHealthArmorForLabel(playerid));
	return SetPlayerArmour(playerid, hp);
}

forward GetArmour(playerid, &Float:hp);
public GetArmour(playerid, &Float:hp)
{
	hp = PlayerArmor[playerid];
	return 1;
}

RemoveArmor(Player)
{
	SetArmour(Player, 0.0);
	return 1;
}

