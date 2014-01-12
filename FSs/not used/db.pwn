#include <a_samp>

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate==PLAYER_STATE_PASSENGER)
    {
        new gun,tmp;
        GetPlayerWeaponData(playerid,4,gun,tmp);
        #pragma unused tmp
        if(gun)SetPlayerArmedWeapon(playerid,gun);
        else SetPlayerArmedWeapon(playerid,0);
    }
    return 1;
}
