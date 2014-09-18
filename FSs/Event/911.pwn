#include <a_samp>
#include <zcmd>

CMD:load911(playerid, params[])
{
	if(GetPVarInt(playerid, "aLvl") < 1337) return 0;
	SendRconCommand("loadfs 911parademapping");
	SendClientMessage(playerid, -1, "9/11 Parade Mapping Loaded.");
	return 1;
}
CMD:unload911(playerid, params[])
{
	if(GetPVarInt(playerid, "aLvl") < 1337) return 0;
	SendRconCommand("unloadfs 911parademapping");
	SendClientMessage(playerid, -1, "9/11 Parade Mapping Unloaded.");
	return 1;
}
