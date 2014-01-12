/*
	Server sided HP/Armour for 0.3d
	Created by Scott - scottreed36@gmail.com
	DO NOT DISTRIBUTE, LET'S KEEP UPPER HAND ON HACKERS BY KEEPING THIS METHOD SECRET
	
	Works because in 0.3d you can set everyone on server to same team, and they won't receive normal damage client side
	However, OnPlayerDamage is still called, so can use SetHP to create server sided armour/HP
	Another perk: Car parking and heliblading is now impossible, they just get stuck under car!
*/
#include <a_samp>
#include <streamer>

#define SetPlayerHealthEx(%0,%1) (pHealth[%0]=(%1); & SetPlayerHealth(%0,%1))
#define SetPlayerArmourEx(%0,%1) (pArmour[%0]=(%1); & SetPlayerArmour(%0,%1))

new Float:pHealth[MAX_PLAYERS];
new Float:pArmour[MAX_PLAYERS];
/*
enum VendMachinesEnum
{
	Float:PosX,
	Float:PosY,
	Float:PosZ
}

new VendMachines[75][VendMachinesEnum] = {
{-14.70,1175.36,18.95},
{201.02,-107.62,0.90},
{662.43,-552.16,15.71},
{-76.03,1227.99,19.13},
{1154.73,-1460.89,15.16},
{1277.84,372.52,18.95},
{1398.84,2222.61,10.42},
{1520.15,1055.27,10.00},
{1634.11,-2237.53,12.89},
{1659.46,1722.86,10.22},
{1729.79,-1943.05,12.95},
{1789.21,-1369.27,15.16},
{1928.73,-1772.45,12.95},
{2060.12,-1897.64,12.93},
{2085.77,2071.36,10.45},
{2139.52,-1161.48,23.36},
{2153.23,-1016.15,62.23},
{2271.73,-76.46,25.96},
{2319.99,2532.85,10.22},
{2325.98,-1645.13,14.21},
{2352.18,-1357.16,23.77},
{2480.86,-1959.27,12.96},
{2503.14,1243.70,10.22},
{-253.74,2597.95,62.24},
{-253.74,2599.76,62.24},
{2647.70,1129.66,10.22},
{2845.73,1295.05,10.79},
{-862.83,1536.61,21.98},
{-1350.12,492.29,10.59},
{-1350.12,493.86,10.59},
{-1455.12,2591.66,55.23},
{-1980.79,142.66,27.07},
{-2005.65,-490.05,34.73},
{-2011.14,-398.34,34.73},
{-2034.46,-490.05,34.73},
{-2039.85,-398.34,34.73},
{-2063.27,-490.05,34.73},
{-2068.56,-398.34,34.73},
{-2092.09,-490.05,34.73},
{-2097.27,-398.34,34.73},
{-2118.62,-422.41,34.73},
{-2118.97,-423.65,34.73},
{-2229.19,286.41,34.70},
{-2420.18,985.95,44.30},
{-2420.22,984.58,44.30},
{2155.84,1607.88,1000.06},
{2155.91,1606.77,1000.05},
{2202.45,1617.01,1000.06},
{2209.24,1621.21,1000.06},
{2209.91,1607.20,1000.05},
{2222.20,1606.77,1000.05},
{2222.37,1602.64,1000.06},
{2225.20,-1153.42,1025.91},
{-15.10,-140.23,1003.63},
{-16.12,-91.64,1003.63},
{-16.53,-140.30,1003.63},
{-17.55,-91.71,1003.63},
{-19.04,-57.84,1003.63},
{-32.45,-186.70,1003.63},
{-33.88,-186.77,1003.63},
{330.68,178.50,1020.07},
{331.92,178.50,1020.07},
{-35.73,-140.23,1003.63},
{350.91,206.09,1008.48},
{-36.15,-57.88,1003.63},
{361.56,158.62,1008.48},
{371.59,178.45,1020.07},
{373.83,-178.14,1000.73},
{374.89,188.98,1008.48},
{379.04,-178.88,1000.73},
{495.97,-24.32,1000.73},
{500.56,-1.37,1000.73},
{501.83,-1.43,1000.73},
2576.70,-1284.43,1061.09}
};
*/

public OnPlayerConnect(playerid)
{
    RemoveBuildingForPlayer(playerid, 955, 0, 0, 0, 25000); // Remove all sprunk machines
	RemoveBuildingForPlayer(playerid, 956, 0, 0, 0, 25000); // Remove all vending machines
}

public OnPlayerSpawn(playerid)
{
	SetPlayerTeam(playerid, 4);
}

public OnPlayerText(playerid, text[]) // THIS IS FOR DEBUGGING
{
	SetPlayerHealthEx(playerid, 100);
	SetPlayerArmourEx(playerid, 100);
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
	if(weaponid == 50)
	{
		SetPlayerArmourEx(playerid, pArmour[playerid]);
		SetPlayerHealthEx(playerid, pHealth[playerid]);
		return 1;
	}
	else if(weaponid == 54 || weaponid == 37 || weaponid == 51 || weaponid == 53)
	{
	    SetPlayerArmourEx(playerid, pArmour[playerid]);
		SetPlayerHealthEx(playerid, pHealth[playerid]);
	}
	
	new Float:armour, Float:HP;
	new string[128];
	GetPlayerArmour(playerid, armour);
	GetPlayerHealth(playerid, HP);

	if(HP <= 0) return 1; // let them die if they are dead!
	
	if((pArmour[playerid] > 0) && (((pArmour[playerid] > armour) && ((pArmour[playerid]-armour) > 1)) || ((pArmour[playerid] < armour) && ((armour-pArmour[playerid]) > 1))))
	{
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) is possibly armour hacking", GetPlayerNameEx(playerid), playerid);
// 		ABroadCast( COLOR_YELLOW, string, 2 );

 		format(string, sizeof(string), "{AA3333}Expected Armour: {AA3333}%f | {AA3333}Armour: {AA3333}%f]", pArmour[playerid], armour);
//		ABroadCast( COLOR_YELLOW, string, 2 );
	}
	if((pHealth[playerid] > 0) && (((pHealth[playerid] > HP) && ((pHealth[playerid]-HP) > 1)) || ((pHealth[playerid] < HP) && ((HP-pHealth[playerid]) > 1))))
 	{
		//Kick(playerid); (automatic kick?)
		
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) is possibly health hacking", GetPlayerNameEx(playerid), playerid);
 		SendClientMessageToAll(0xFFFFFFAA, string);
		 //ABroadCast( COLOR_YELLOW, string, 2 );
 		
 		format(string, sizeof(string), "{AA3333}Expected HP: {AA3333}%f | {AA3333}HP: {AA3333}%f]", pHealth[playerid], HP);
	 	SendClientMessageToAll(0xFFFFFFAA, string);
		 //ABroadCast( COLOR_YELLOW, string, 2 );
	}
	

	if(armour > 0)
	{
		if(armour >= amount)
		{
		    //Don't set double damage for drowning, splat, fire
		    if(weaponid == 54 || weaponid == 53 || weaponid == 37) pArmour[playerid] = (armour-amount);
			else SetPlayerArmourEx(playerid, armour-amount);
		}
		else
		{
			if(weaponid == 54 || weaponid == 53 || weaponid == 37)
		    {
		        pArmour[playerid] = 0;
		        pHealth[playerid] = (HP-(amount-armour));
			}
			else
			{
				SetPlayerArmourEx(playerid, 0);
				SetPlayerHealthEx(playerid, HP-(amount-armour));
			}
		}
	}
	else
	{
 		if(weaponid == 54 || weaponid == 53 || weaponid == 37) pHealth[playerid] = (HP-amount);
 		else SetPlayerHealthEx(playerid, HP-amount);
	}
	
	return 1;
}

stock GetPlayerNameEx(playerid) {

	new
		sz_playerName[MAX_PLAYER_NAME];

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	return sz_playerName;
}
