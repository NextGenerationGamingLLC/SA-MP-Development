//==============================================================================
//                         GarObject v1.3 by [03]Garsino!
//==============================================================================
// - Credits to DracoBlue for dini, dcmd and dudb.
// - Credits to Y_Less for sscanf2.
// - Thanks to everyone who gave me ideas for this object editing system (Admins on Garsino's Funserver).
// - Thanks to everyone who helped me find bugs.
//==============================================================================
//                        Changelog
//==============================================================================
// - [Fixed] Fixed problem with editing objects after loading them from a file.
// - [Added] Added /startobjectloop - it will move your object from point (A) to point (B). When arrived at point (B) it will go back to point (A) like a loop.
// - [Added] Added /startallobjectloop - it will move all your objects from point (A) to point (B). When arrived at point (B) they will go back to point (A) like a loop.
// - [Added] Added /sol - shortcut command for /startobjectloop.
// - [Added] Added /sallol - shortcut command for /startallobjectloop.
// - [Added] Added /stopobjectloop - it will stop the current ongoing object loop for your object.
// - [Added] Added /stopallobjectloop - it will stop the current ongoing object loop for all your objects.
// - [Added] Added /stopol - shortcut command for /stopobjectloop.
// - [Added] Added /stopallol - shortcut command for /stopallobjectloop.
// - [Added] Added /getmypos (only works if you have defined GO_DEBUG_CMDS).
//==============================================================================
//                              Includes
//==============================================================================
#include <a_samp> // Credits to the SA:MP Developement Team

//==============================================================================
// 									Configuration
//==============================================================================
#undef MAX_PLAYERS
#define MAX_PLAYERS 500 // Change it to the amount of server slots!!
//#define G_OBJ_AUTOSAVE // Uncomment to enable autosave of objects on disconnect/filterscript exit. Objects will be saved in <PlayerName>.txt
//#define G_OBJ_USE_SHORTCUTS // Unomment to enable command shortcuts.
//#define GO_DEBUG_CMDS // Uncomment to enable debug commands like /getmypos.
#define GOBJ_MAX_OBJECTS_CREATED 	400 // Max objects an admin can create (Remember the limit is 400 in SA:MP 0.3b/0.3c...)
#define G_OBJ_DID   12357
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define Loop(%0,%1) for(new %0 = 0; %0 < %1; %0++)
new Objects[MAX_PLAYERS][GOBJ_MAX_OBJECTS_CREATED], ObjectCreator[MAX_OBJECTS];
new Float:oOffset[MAX_OBJECTS][3], Float:oRot[MAX_OBJECTS][3], Float:oPos[MAX_OBJECTS][3], ModelID[MAX_OBJECTS];
new Float:oStart[MAX_OBJECTS][3], Float:oEnd[MAX_OBJECTS][3], oMoving[MAX_OBJECTS], oLap[MAX_OBJECTS], Float:oMSpeed[MAX_OBJECTS];
new AttachedVehicle[MAX_OBJECTS], AttachedPlayer[MAX_OBJECTS];
new Float:X, Float:Y, Float:Z;
//==============================================================================
//                              Colours
//==============================================================================
#define COLOUR_INFO			   			0x00FFFFFF
#define COLOUR_SYSTEM 		   			0xB60000FF
//==============================================================================
//                              Awesomeness
//==============================================================================
public OnFilterScriptInit()
{
    Loop(obj, MAX_OBJECTS)
	{
		ObjectCreator[obj] = INVALID_PLAYER_ID;
		ModelID[obj] = -1;
	}
	Loop(i, MAX_PLAYERS)
	{
	    Loop(o, GOBJ_MAX_OBJECTS_CREATED)
		{
			Objects[i][o] = INVALID_OBJECT_ID;
		}
	}
	print("\n>> GarObject v1.3 By [03]Garsino Loaded <<\n");
    return 1;
}
public OnFilterScriptExit()
{
	#if defined G_OBJ_AUTOSAVE
	new filename[MAX_PLAYER_NAME+4];
	Loop(i, MAX_PLAYERS)
	{
		if(!IsPlayerAdmin(i) || !IsPlayerConnected(i) || IsPlayerNPC(i)) continue;
	    format(filename, sizeof(filename), "%s.txt", pNick(i));
	    SaveObjectsToFile(i, filename, 0);
	    SaveHObjectsToFile(i, filename, 0);
	}
	#endif
    Loop(obj, MAX_OBJECTS)
	{
	    if(ObjectCreator[obj] != INVALID_PLAYER_ID && ModelID[obj] != -1)
	    {
	        DestroyObject(obj);
	        ModelID[obj] = -1;
	    }
	}
	print("\n>> GarObject v1.3 By [03]Garsino Unloaded <<\n");
    return 1;
}
public OnPlayerConnect(playerid)
{
	Loop(o, GOBJ_MAX_OBJECTS_CREATED)
	{
		Objects[playerid][o] = INVALID_OBJECT_ID;
	}
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	#if defined G_OBJ_AUTOSAVE
	if(IsPlayerAdmin(playerid))
	{
	    new filename[MAX_PLAYER_NAME+4];
	    format(filename, sizeof(filename), "%s.txt", pNick(playerid));
	    SaveObjectsToFile(playerid, filename, 0);
	    SaveHObjectsToFile(playerid, filename, 0);
	}
	#endif
	Loop(o, MAX_OBJECTS)
	{
 		if(ObjectCreator[o] == playerid)
   		{
   		    if(ModelID[o] != -1)
	    	{
		    	DestroyObject(o);
		    	ModelID[o] = -1;
		    }
	    	ObjectCreator[o] = INVALID_PLAYER_ID;
        }
	}
 	Loop(o2, GOBJ_MAX_OBJECTS_CREATED)
	{
		Objects[playerid][o2] = INVALID_OBJECT_ID;
	}
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
    dcmd(stopallobjectloop, 17, cmdtext);
	dcmd(stopobjectloop, 14, cmdtext);
    dcmd(startallobjectloop, 18, cmdtext);
	dcmd(startobjectloop, 15, cmdtext);
    dcmd(createobject, 12, cmdtext);
	dcmd(rotateobject, 12, cmdtext);
	dcmd(attachpobject, 13, cmdtext);
	dcmd(deattachpobject, 15, cmdtext);
	dcmd(attachvobject, 13, cmdtext);
	dcmd(deattachvobject, 15, cmdtext);
	dcmd(rotateallobject, 15, cmdtext);
	dcmd(destroyobject, 13, cmdtext);
	dcmd(destroyallobject, 16, cmdtext);
	dcmd(stopobject, 10, cmdtext);
	dcmd(stopallobject, 13, cmdtext);
	dcmd(moveobject, 10, cmdtext);
	dcmd(moveallobject, 13, cmdtext);
	dcmd(getobject, 9, cmdtext);
	dcmd(getallobject, 12, cmdtext);
	dcmd(objecttele, 10, cmdtext);
	dcmd(sethobj, 7, cmdtext);
	dcmd(stophobj, 8, cmdtext);
	dcmd(stopallhobj, 11, cmdtext);
	dcmd(saveobject, 10, cmdtext);
	dcmd(loadobject, 10, cmdtext);
	dcmd(savehobject, 11, cmdtext);
	dcmd(loadhobject, 11, cmdtext);
	dcmd(copyobject, 10, cmdtext);
	dcmd(garobject, 9, cmdtext);
	#if defined G_OBJ_USE_SHORTCUTS
	dcmd(oc, 2, cmdtext); // /createobject
	dcmd(or, 2, cmdtext); // /rotateobject
	dcmd(apo, 3, cmdtext); // /attachpobject
	dcmd(deapo, 5, cmdtext); // /deattachpobject
	dcmd(avo, 3, cmdtext); // /attachvobject
	dcmd(deavo, 5, cmdtext); // /deattachvobject
	dcmd(orall, 5, cmdtext); // /rotateallobject
	dcmd(od, 2, cmdtext); // /destroyobject
	dcmd(odall, 5, cmdtext); // /destroyallobject
	dcmd(os, 2, cmdtext); // /stopobject
	dcmd(osall, 5, cmdtext); // /stopallobject
	dcmd(om, 2, cmdtext); // /moveobject
	dcmd(omall, 5, cmdtext); // /moveallobject
	dcmd(og, 2, cmdtext); // /getobject
	dcmd(ogall, 5, cmdtext); // /getallobject
	dcmd(ot, 2, cmdtext); // /objecttele
	dcmd(setho, 5, cmdtext); // /sethobj
	dcmd(stopho, 6, cmdtext); // /stophobj
	dcmd(stopallho, 9, cmdtext); // /stopallhobj
	dcmd(so, 2, cmdtext); // /saveobject
	dcmd(lo, 2, cmdtext); // /loadobject
	dcmd(sho, 3, cmdtext); // /savehobject
	dcmd(lho, 3, cmdtext); // /loadhobject
	dcmd(co, 2, cmdtext); // /copyobject
	dcmd(sallol, 6, cmdtext); // /startallobjectloop
	dcmd(sol, 3, cmdtext); // /startobjectloop
	dcmd(stopallol, 6, cmdtext); // /stopallobjectloop
	dcmd(stopol, 3, cmdtext); // /stopobjectloop
	dcmd(gobj, 4, cmdtext); // /garobject
	#endif
	#if defined GO_DEBUG_CMDS
	dcmd(getmypos, 8, cmdtext);
	#endif
	return 0;
}
dcmd_createobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new modelid, Float:rX, Float:rY, Float:rZ, string[128], objid = GetFreeObjectID(playerid);
		if(sscanf(params, "dF(0)F(0)F(0)", modelid, rX, rY, rZ)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /createobject (object id) (rotX) (rotY) (rotZ)");
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT && !IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You need to spawn to be able to use this command.");
		if(GetTotalNativeObjects() >= (MAX_OBJECTS-1)) return SendClientMessage(playerid, COLOUR_SYSTEM, "The SA:MP object limit has been reached. You can not spawn any more objects.");
		if(objid < 0)  return SendClientMessage(playerid, COLOUR_SYSTEM, "You can not spawn any more objects. Please delete one of the current ones first.");
		else
		{
			GetPlayerPos(playerid, X, Y, Z);
			Objects[playerid][objid] = CreateObject(modelid, X, Y, Z, rX, rY, rZ);
			new o = Objects[playerid][objid];
			ModelID[o] = modelid;
			ObjectCreator[o] = playerid;
			oPos[o][0] = X, oPos[o][1] = Y, oPos[o][2] = Z;
			oRot[o][0] = rX, oRot[o][1] = rY, oRot[o][2] = rZ;
			AttachedVehicle[o] = INVALID_VEHICLE_ID, AttachedPlayer[o] = INVALID_PLAYER_ID;
			format(string, sizeof(string), "Object ID %d created. Modelid: %d. Rotation: X: %0.2f | Y: %0.2f | Z: %0.2f.", objid, modelid, rX, rY, rZ);
			SendClientMessage(playerid, COLOUR_INFO, string);
		}
		return 1;
	}
	else return 0;
}
dcmd_copyobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new string[128], objectid, objid = GetFreeObjectID(playerid);
		if(sscanf(params, "d", objectid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /copyobject (objectid)");
		if(GetTotalNativeObjects() >= (MAX_OBJECTS-1)) return SendClientMessage(playerid, COLOUR_SYSTEM, "The SA:MP object limit has been reached. You can not spawn any more objects.");
		if(objid < 0) return SendClientMessage(playerid, COLOUR_SYSTEM, "You can not spawn any more objects. Please delete one of the current ones first.");
		else
		{
			new o2 = Objects[playerid][objectid];
			Objects[playerid][objid] = CreateObject(ModelID[o2], oPos[o2][0], oPos[o2][1], oPos[o2][2], oRot[o2][0], oRot[o2][1], oRot[o2][2]);
			new o = Objects[playerid][objid];
			ModelID[o] = ModelID[o2];
			ObjectCreator[o] = playerid;
			oPos[o][0] = oPos[o2][0], oPos[o][1] = oPos[o2][1], oPos[o][2] = oPos[o2][2];
			oRot[o][0] = oRot[o2][0], oRot[o][1] = oRot[o2][1], oRot[o][2] = oRot[o2][2];
			AttachedVehicle[o] = AttachedVehicle[o2], AttachedPlayer[o] = AttachedPlayer[o2];
			if(AttachedVehicle[o] != INVALID_VEHICLE_ID)
			{
				oOffset[o][0] = oOffset[o2][0], oOffset[o][1] = oOffset[o2][1], oOffset[o][2] = oOffset[o2][2];
				oRot[o][0] = oRot[o][0], oRot[o][1] = oRot[o2][1], oRot[o][2] = oRot[o2][2];
				AttachObjectToVehicle(o, AttachedVehicle[o], oOffset[o2][0], oOffset[o2][1], oOffset[o2][2], oRot[o2][0], oRot[o2][1], oRot[o2][2]);
			}
			if(AttachedPlayer[o] != INVALID_PLAYER_ID)
			{
				oOffset[o][0] = oOffset[o2][0], oOffset[o][1] = oOffset[o2][1], oOffset[o][2] = oOffset[o2][2];
				oRot[o][0] = oRot[o][0], oRot[o][1] = oRot[o2][1], oRot[o][2] = oRot[o2][2];
				AttachObjectToVehicle(o, AttachedPlayer[o], oOffset[o2][0], oOffset[o2][1], oOffset[o2][2], oRot[o2][0], oRot[o2][1], oRot[o2][2]);
			}
			format(string, sizeof(string), "Object ID %d copied. Object ID for the copied object is %d.", objectid, objid);
			SendClientMessage(playerid, COLOUR_INFO, string);
		}
		return 1;
	}
	else return 0;
}
dcmd_rotateobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new objectid, Float:rX, Float:rY, Float:rZ, string[128];
		if(sscanf(params, "dF(0)F(0)F(0)", objectid, rX, rY, rZ)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /rotateobject (object id) (rotX) (rotY) (rotZ)");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
        else
		{
		    if(ObjectCreator[Objects[playerid][objectid]] == playerid)
		    {
		        new o = Objects[playerid][objectid];
				SetObjectRot(o, rX, rY, rZ);
				oRot[o][0] = rX, oRot[o][1] = rY, oRot[o][2] = rZ;
				format(string, sizeof(string), "Object ID %d rotated. New rotation: X: %0.2f | Y: %0.2f | Z: %0.2f.", objectid, rX, rY, rZ);
				SendClientMessage(playerid, COLOUR_INFO, string);
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_attachpobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new id, objectid, Float:ofsX, Float:ofsY, Float:ofsZ, Float:rX, Float:rY, Float:rZ, string[128];
		if(sscanf(params, "duF(0)F(0)F(0)F(0)F(0)F(0)", objectid, id, ofsX, ofsY, ofsZ, rX, rY, rZ)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /attachpobject (object id) (nick/id) (offset X) (offset Y) (offset Z) (rotation X) (rotation Y) (rotation Z)");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
        if(AttachedVehicle[Objects[playerid][objectid]] != INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "You can not attach an object to a player wich is already attached to a vehicle!");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOUR_SYSTEM, "This player is not connected!");
		else
		{
		    if(ObjectCreator[Objects[playerid][objectid]] == playerid)
		    {
		        new o = Objects[playerid][objectid];
		        oOffset[o][0] = ofsX, oOffset[o][1] = ofsY, oOffset[o][2] = ofsZ;
				oRot[o][0] = rX, oRot[o][1] = rY, oRot[o][2] = rZ;
				AttachedPlayer[o] = id;
				AttachObjectToPlayer(o, id, ofsX, ofsY, ofsZ, rX, rY, rZ);
				format(string, sizeof(string), "Object ID %d attached to %s (%d). Offset: X: %0.2f | Y: %0.2f | Z: %0.2f | Rotation: X: %0.2f | Y: %0.2f | Z: %0.2f.", objectid, pNick(id), id, ofsX, ofsY, ofsZ, rX, rY, rZ);
				SendClientMessage(playerid, COLOUR_INFO, string);
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_deattachpobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new objectid, string[128], o, o2;
		if(sscanf(params, "d", objectid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /deattachpobject (object id)");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
		else
		{
		    if(ObjectCreator[Objects[playerid][objectid]] == playerid)
		    {
		        DestroyObject(Objects[playerid][objectid]);
		        ObjectCreator[Objects[playerid][objectid]] = INVALID_PLAYER_ID;
		        o = Objects[playerid][objectid];
				Objects[playerid][objectid] = CreateObject(ModelID[o], (oPos[o][0] + oOffset[o][0]), (oPos[o][1] + oOffset[o][1]), (oPos[o][2] + oOffset[o][2]), oRot[o][0], oRot[o][1], oRot[o][2]);
                o2 = Objects[playerid][objectid];
				ModelID[o2] = ModelID[o], oPos[o2][0] = (oPos[o][0] + oOffset[o][0]), oPos[o2][1] = (oPos[o][1] + oOffset[o][1]), oPos[o2][2] = (oPos[o][2] + oOffset[o][2]), oRot[o2][0] = oRot[o][0], oRot[o2][1] = oRot[o][1], oRot[o2][2] = oRot[o][2];
				ObjectCreator[o2] = playerid;
				format(string, sizeof(string), "Object ID %d de-attached from %s (%d).", objectid, pNick(AttachedPlayer[o]), AttachedPlayer[o]);
				SendClientMessage(playerid, COLOUR_INFO, string);
				AttachedPlayer[o2] = INVALID_PLAYER_ID, AttachedPlayer[o] = INVALID_PLAYER_ID;
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_attachvobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new vehicleid, objectid, Float:ofsX, Float:ofsY, Float:ofsZ, Float:rX, Float:rY, Float:rZ, string[128];
		if(sscanf(params, "ddF(0)F(0)F(0)F(0)F(0)F(0)", objectid, vehicleid, ofsX, ofsY, ofsZ, rX, rY, rZ)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /attachpobject (object id) (vehicleid) (offset X) (offset Y) (offset Z) (rotation X) (rotation Y) (rotation Z)");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
        if(AttachedPlayer[Objects[playerid][objectid]] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "You can not attach an object to a vehicle wich is already attached to a player!");
        if(vehicleid == INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid vehicle ID!");
		else
		{
		    if(ObjectCreator[Objects[playerid][objectid]] == playerid)
		    {
		        new o = Objects[playerid][objectid];
		        oOffset[o][0] = ofsX, oOffset[o][1] = ofsY, oOffset[o][2] = ofsZ;
				oRot[o][0] = rX, oRot[o][1] = rY, oRot[o][2] = rZ;
				AttachedVehicle[o] = vehicleid;
				AttachObjectToVehicle(o, vehicleid, ofsX, ofsY, ofsZ, rX, rY, rZ);
				format(string, sizeof(string), "Object ID %d attached to vehicle ID %d. Offset: X: %0.2f | Y: %0.2f | Z: %0.2f | Rotation: X: %0.2f | Y: %0.2f | Z: %0.2f.", objectid, vehicleid, ofsX, ofsY, ofsZ, rX, rY, rZ);
				SendClientMessage(playerid, COLOUR_INFO, string);
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_deattachvobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new objectid, string[128], o, o2;
		if(sscanf(params, "d", objectid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /deattachpobject (object id)");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
		else
		{
		    if(ObjectCreator[Objects[playerid][objectid]] == playerid)
		    {
		        DestroyObject(Objects[playerid][objectid]);
		        ObjectCreator[Objects[playerid][objectid]] = INVALID_PLAYER_ID;
		        o = Objects[playerid][objectid];
		        GetVehiclePos(AttachedVehicle[o], oPos[o][0], oPos[o][1], oPos[o][2]);
				Objects[playerid][objectid] = CreateObject(ModelID[o], (oPos[o][0] + oOffset[o][0]), (oPos[o][1] + oOffset[o][1]), (oPos[o][2] + oOffset[o][2]), oRot[o][0], oRot[o][1], oRot[o][2]);
                o2 = Objects[playerid][objectid];
				ObjectCreator[o2] = playerid;
				format(string, sizeof(string), "Object %d de-attached from vehicle ID %d.", objectid, AttachedVehicle[o]);
				SendClientMessage(playerid, COLOUR_INFO, string);
				ModelID[o2] = ModelID[o], oPos[o2][0] = (oPos[o][0] + oOffset[o][0]), oPos[o2][1] = (oPos[o][1] + oOffset[o][1]), oPos[o2][2] = (oPos[o][2] + oOffset[o][2]), oRot[o2][0] = oRot[o][0], oRot[o2][1] = oRot[o][1], oRot[o2][2] = oRot[o][2];
				AttachedVehicle[o2] = INVALID_VEHICLE_ID, AttachedVehicle[o] = INVALID_VEHICLE_ID;
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_sethobj(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new id, modelid, slot, Float:rX[3], Float:rY[3], Float:rZ[3], string[128], bodypart[36], bid;
		if(sscanf(params, "udds[36]F(0)F(0)F(0)F(0)F(0)F(0)F(1)F(1)F(1)", id, modelid, slot, bodypart, rX[0], rY[0], rZ[0], rX[1], rY[1], rZ[1], rX[2], rY[2], rZ[2])) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /sethobj (nick/id) (modelid) (slot: 0-4) (bodypart: name/id) (rotX) (rotY) (rotZ) (rotX) (rotY) (rotZ) (sizeX) (sizeY) (sizeZ)");
		if(strlen(bodypart) < 1 || bodypart[35] || GetBodypartIDFromName(bodypart) == -1) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid Bodypart Name/ID.");
		if(slot < 0 || slot > 4) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid slot ID. Valid slot IDs are between 0-4.");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOUR_SYSTEM, "This player is not connected!");
		else
		{
		    if(IsPlayerAttachedObjectSlotUsed(id, slot))
		    {
      			RemovePlayerAttachedObject(id, slot);
		   	}
		   	bid = GetBodypartIDFromName(bodypart);
		    SetPlayerAttachedObject(id, slot, modelid, bid, rX[0], rY[0], rZ[0], rX[1], rY[1], rZ[1], rX[2], rY[2], rZ[2]);
			format(string, sizeof(string), "Modelid %d has been attached to %s's (%d) Bodypart [%s].", modelid, pNick(id), id, GetBodypartName(bodypart));
			SendClientMessage(playerid, COLOUR_INFO, string);
			SetHOPVar(playerid, "HOIndex", slot, slot);
			SetHOPVar(playerid, "HOModel", modelid, slot);
			SetHOPVar(playerid, "HOBone", bid, slot);
			SetHOPFloat(playerid, "HOOX", rX[0], slot);
			SetHOPFloat(playerid, "HOOY", rY[0], slot);
			SetHOPFloat(playerid, "HOOZ", rZ[0], slot);
			SetHOPFloat(playerid, "HORX", rX[1], slot);
			SetHOPFloat(playerid, "HORY", rY[1], slot);
			SetHOPFloat(playerid, "HORZ", rZ[1], slot);
			SetHOPFloat(playerid, "HOSX", rX[2], slot);
			SetHOPFloat(playerid, "HOSY", rY[2], slot);
			SetHOPFloat(playerid, "HOSZ", rZ[2], slot);
		}
		return 1;
	}
	else return 0;
}
dcmd_stophobj(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new id, string[128], slot;
		if(sscanf(params, "ud", id, slot)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /stophobj (nick/id) (slot: 0-4)");
		if(slot < 0 || slot > 4) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid slot ID. Valid slot IDs are between 0-4.");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOUR_SYSTEM, "This player is not connected!");
		else
		{
		    RemovePlayerAttachedObject(id, slot);
			format(string, sizeof(string), "Attached object in slot ID %d removed from %s's (%d) bodypart.", slot, pNick(id), id);
			SendClientMessage(playerid, COLOUR_INFO, string);
		}
		return 1;
	}
	else return 0;
}
dcmd_stopallhobj(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new id, string[128], count;
		if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /stopallhobj (nick/id)");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOUR_SYSTEM, "This player is not connected!");
		else
		{
		    Loop(slot, 5)
		    {
		        if(IsPlayerAttachedObjectSlotUsed(id, slot))
		        {
		            count++;
		    		RemovePlayerAttachedObject(id, slot);
		    	}
		    }
			format(string, sizeof(string), "All attached objects removed from %s's (%d) bodyparts (%d in total).", pNick(id), id, count);
			SendClientMessage(playerid, COLOUR_INFO, string);
		}
		return 1;
	}
	else return 0;
}
stock GetBodypartName(bodypart[])
{
	new string[25];
    if(!strcmp(bodypart, "0", true)) format(string, sizeof(string), "-1");
	if(!strcmp(bodypart, "Spine", true) || !strcmp(bodypart, "1", true)) format(string, sizeof(string), "Spine - 1");
	if(!strcmp(bodypart, "Head", true) || !strcmp(bodypart, "2", true)) format(string, sizeof(string), "Head - 2");
	if(!strcmp(bodypart, "Left upper arm", true) || !strcmp(bodypart, "3", true)) format(string, sizeof(string), "Left upper arm - 3");
	if(!strcmp(bodypart, "Right upper arm", true) || !strcmp(bodypart, "4", true)) format(string, sizeof(string), "Right upper arm - 4");
	if(!strcmp(bodypart, "Left hand", true) || !strcmp(bodypart, "5", true)) format(string, sizeof(string), "Left hand - 5");
	if(!strcmp(bodypart, "Right hand", true) || !strcmp(bodypart, "6", true)) format(string, sizeof(string), "Right hand - 6");
	if(!strcmp(bodypart, "Left thigh ", true) || !strcmp(bodypart, "7", true)) format(string, sizeof(string), "Left thigh  - 7");
	if(!strcmp(bodypart, "Right thigh ", true) || !strcmp(bodypart, "8", true)) format(string, sizeof(string), "Right thigh  - 8");
	if(!strcmp(bodypart, "Left foot", true) || !strcmp(bodypart, "9", true)) format(string, sizeof(string), "Left foot - 9");
	if(!strcmp(bodypart, "Right foot", true) || !strcmp(bodypart, "10", true)) format(string, sizeof(string), "Right foot - 10");
	if(!strcmp(bodypart, "Left calf ", true) || !strcmp(bodypart, "11", true)) format(string, sizeof(string), "Left calf  - 11");
	if(!strcmp(bodypart, "Right calf ", true) || !strcmp(bodypart, "12", true)) format(string, sizeof(string), "Right calf  - 12");
	if(!strcmp(bodypart, "Left forearm", true) || !strcmp(bodypart, "13", true)) format(string, sizeof(string), "Left forearm - 13");
	if(!strcmp(bodypart, "Right forearm ", true) || !strcmp(bodypart, "14", true)) format(string, sizeof(string), "Right forearm  - 14");
	if(!strcmp(bodypart, "Left clavicle ", true) || !strcmp(bodypart, "15", true)) format(string, sizeof(string), "Left clavicle  - 15");
	if(!strcmp(bodypart, "Right clavicle ", true) || !strcmp(bodypart, "16", true)) format(string, sizeof(string), "Right clavicle  - 16");
	if(!strcmp(bodypart, "Neck", true) || !strcmp(bodypart, "17", true)) format(string, sizeof(string), "Neck - 17");
	if(!strcmp(bodypart, "Jew", true) || !strcmp(bodypart, "18", true)) format(string, sizeof(string), "Jew - 18");
	return string;
}
stock GetBodypartIDFromName(bodypart[])
{
    if(!strcmp(bodypart, "0", true)) return -1;
	if(!strcmp(bodypart, "Spine", true) || strval(bodypart) == 1) return 1;
	if(!strcmp(bodypart, "Head", true) || strval(bodypart) == 2) return 2;
	if(!strcmp(bodypart, "Left upper arm", true) || strval(bodypart) == 3) return 3;
	if(!strcmp(bodypart, "Right upper arm", true) || strval(bodypart) == 4) return 4;
	if(!strcmp(bodypart, "Left hand", true) || strval(bodypart) == 5) return 5;
	if(!strcmp(bodypart, "Right hand", true) || strval(bodypart) == 6) return 6;
	if(!strcmp(bodypart, "Left thigh ", true) || strval(bodypart) == 7) return 7;
	if(!strcmp(bodypart, "Right thigh ", true) || strval(bodypart) == 8) return 8;
	if(!strcmp(bodypart, "Left foot", true) || strval(bodypart) == 9) return 9;
	if(!strcmp(bodypart, "Right foot", true) || strval(bodypart) == 10) return 10;
	if(!strcmp(bodypart, "Left calf ", true) || strval(bodypart) == 11) return 11;
	if(!strcmp(bodypart, "Right calf ", true) || strval(bodypart) == 12) return 12;
	if(!strcmp(bodypart, "Left forearm", true) || strval(bodypart) == 13) return 13;
	if(!strcmp(bodypart, "Right forearm ", true) || strval(bodypart) == 14) return 14;
	if(!strcmp(bodypart, "Left clavicle ", true) || strval(bodypart) == 15) return 15;
	if(!strcmp(bodypart, "Right clavicle ", true) || strval(bodypart) == 16) return 16;
	if(!strcmp(bodypart, "Neck", true) || strval(bodypart) == 17) return 17;
	if(!strcmp(bodypart, "Jew", true) || strval(bodypart) == 18) return 18;
	else return -1;
}
dcmd_rotateallobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new Float:rX, Float:rY, Float:rZ, string[128];
		if(sscanf(params, "F(0)F(0)F(0)", rX, rY, rZ)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /rotateallobject (rotX) (rotY) (rotZ)");
        else
		{
		    Loop(o, MAX_OBJECTS)
			{
			    if(ObjectCreator[o] == playerid)
			    {
					SetObjectRot(o, rX, rY, rZ);
					oRot[o][0] = rX, oRot[o][1] = rY, oRot[o][2] = rZ;
				}
			}
			format(string, sizeof(string), "All of your objects have been rotated. New rotation: X: %0.2f | Y: %0.2f | Z: %0.2f.", rX, rY, rZ);
			SendClientMessage(playerid, COLOUR_INFO, string);
		}
		return 1;
	}
	else return 0;
}

dcmd_destroyobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new objectid, string[128];
		if(sscanf(params, "d", objectid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /destroyobject (object id)");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
		else
		{
		    if(ObjectCreator[Objects[playerid][objectid]] == playerid)
		    {
		        new o = Objects[playerid][objectid];
		        if(ModelID[o] != -1)
		        {
			 		DestroyObject(o);
			 		ModelID[o] = -1;
			 	}
				ObjectCreator[o] = INVALID_PLAYER_ID;
				oOffset[o][0] = -1, oOffset[o][1] = -1, oOffset[o][2] = -1;
				oPos[o][0] = -1, oPos[o][1] = -1, oPos[o][2] = -1;
				oRot[o][0] = -1, oRot[o][1] = -1, oRot[o][2] = -1;
				AttachedVehicle[o] = INVALID_VEHICLE_ID, AttachedPlayer[o] = INVALID_PLAYER_ID;
			 	format(string, sizeof(string), "Object ID %d destroyed.", objectid);
				SendClientMessage(playerid, COLOUR_INFO, string);
				Objects[playerid][objectid] = INVALID_OBJECT_ID;
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_destroyallobject(playerid, params[])
{
	#pragma unused params
	if(IsPlayerAdmin(playerid))
	{
	    if(GetFreeObjectID(playerid) >= GOBJ_MAX_OBJECTS_CREATED-1) return SendClientMessage(playerid, COLOUR_SYSTEM, "You haven't created any objects.");
		else
		{
			Loop(o, MAX_OBJECTS)
			{
			    if(ObjectCreator[o] == playerid)
			    {
			        if(ModelID[o] != -1)
					{
		            	DestroyObject(o);
		            	ModelID[o] = -1;
		            }
					ObjectCreator[o] = INVALID_PLAYER_ID;
					oOffset[o][0] = -1, oOffset[o][1] = -1, oOffset[o][2] = -1;
					oPos[o][0] = -1, oPos[o][1] = -1, oPos[o][2] = -1;
					oRot[o][0] = -1, oRot[o][1] = -1, oRot[o][2] = -1;
					AttachedVehicle[o] = INVALID_VEHICLE_ID, AttachedPlayer[o] = INVALID_PLAYER_ID;
	            }
			}
			Loop(o2, GOBJ_MAX_OBJECTS_CREATED)
			{
				Objects[playerid][o2] = INVALID_OBJECT_ID;
			}
			SendClientMessage(playerid, COLOUR_SYSTEM, "All of your objects have been destroyed.");
			return 1;
		}
	}
	else return 0;
}
dcmd_stopobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new objectid, string[128];
		if(sscanf(params, "d", objectid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /stopobject (object id)");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
		else
		{
		    if(ObjectCreator[Objects[playerid][objectid]] == playerid)
		    {
		        new o = Objects[playerid][objectid];
				StopObject(o);
				GetObjectPos(o, oPos[o][0], oPos[o][1], oPos[o][2]);
			 	format(string, sizeof(string), "You have stopped the movement of object ID %d.", objectid);
				SendClientMessage(playerid, COLOUR_INFO, string);
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_stopallobject(playerid, params[])
{
	#pragma unused params
	if(IsPlayerAdmin(playerid))
	{
		Loop(o, MAX_OBJECTS)
  		{
    		if(ObjectCreator[o] == playerid)
		    {
				StopObject(o);
				GetObjectPos(o, oPos[o][0], oPos[o][1], oPos[o][2]);
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_moveobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new objectid, direction[6], Float:amount, Float:speed, string[128];
		if(sscanf(params, "ds[6]F(10)F(10)", objectid, direction, amount, speed)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /moveobject (object id) (direction) (amount) (speed) - Accepted directions are: north, south, east, west, up and down.");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
		if(strlen(direction) < 2 || strlen(direction) > 5) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid direction. Accepted directions are: north, south, east, west, up and down.");
		if(strcmp(direction, "north", true) && strcmp(direction, "south", true) && strcmp(direction, "east", true) && strcmp(direction, "west", true) && strcmp(direction, "up", true) && strcmp(direction, "down", true)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid direction. Accepted directions are: north, south, east, west, up and down.");
		else
		{
			if(ObjectCreator[Objects[playerid][objectid]] == playerid)
	  		{
	  		    new o = Objects[playerid][objectid];
				GetObjectPos(o, X, Y, Z);
				if(!strcmp(direction, "north", true)) MoveObject(o, X, Y+amount, Z, speed), oPos[o][1]+=amount;
				if(!strcmp(direction, "south", true)) MoveObject(o, X, Y-amount, Z, speed), oPos[o][1]-=amount;
				if(!strcmp(direction, "east", true)) MoveObject(o, X+amount, Y, Z, speed), oPos[o][0]+=amount;
				if(!strcmp(direction, "west", true)) MoveObject(o, X-amount, Y, Z, speed), oPos[o][0]-=amount;
				if(!strcmp(direction, "up", true)) MoveObject(o, X, Y, Z+amount, speed), oPos[o][2]+=amount;
				if(!strcmp(direction, "down", true)) MoveObject(o, X, Y, Z-amount, speed), oPos[o][2]-=amount;
				format(string, sizeof(string), "Object ID %d moved. Direction: %s (%d meters, %0.2f speed).", objectid, direction, speed);
				SendClientMessage(playerid, COLOUR_INFO, string);
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_moveallobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new direction[6], Float:amount, Float:speed, string[128], count;
		if(sscanf(params, "s[6]F(10)F(10)", direction, amount, speed)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /moveallobject (direction) (amount) (speed) - Accepted directions are: north, south, east, west, up and down.");
		if(strlen(direction) < 2 || strlen(direction) > 5) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid direction. Accepted directions are: north, south, east, west, up and down.");
		if(strcmp(direction, "north", true) && strcmp(direction, "south", true) && strcmp(direction, "east", true) && strcmp(direction, "west", true) && strcmp(direction, "up", true) && strcmp(direction, "down", true)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid direction. Accepted directions are: north, south, east, west, up and down.");
		else
		{
		    Loop(o, MAX_OBJECTS)
		    {
				if(ObjectCreator[o] == playerid)
		  		{
					GetObjectPos(o, X, Y, Z);
					if(!strcmp(direction, "north", true)) MoveObject(o, X, Y+amount, Z, speed), oPos[o][1]+=amount;
					if(!strcmp(direction, "south", true)) MoveObject(o, X, Y-amount, Z, speed), oPos[o][1]-=amount;
					if(!strcmp(direction, "east", true)) MoveObject(o, X+amount, Y, Z, speed), oPos[o][0]+=amount;
					if(!strcmp(direction, "west", true)) MoveObject(o, X-amount, Y, Z, speed), oPos[o][0]-=amount;
					if(!strcmp(direction, "up", true)) MoveObject(o, X, Y, Z+amount, speed), oPos[o][2]+=amount;
					if(!strcmp(direction, "down", true)) MoveObject(o, X, Y, Z-amount, speed), oPos[o][2]-=amount;
					count++;
				}
			}
			format(string, sizeof(string), "Moved %d objects. Direction: %s (%d meters, %0.2f speed).", count, direction, speed);
			SendClientMessage(playerid, COLOUR_INFO, string);
		}
		return 1;
	}
	else return 0;
}
dcmd_startobjectloop(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new objectid, Float:Pos[6], Float:speed, string[128];
		if(sscanf(params, "dffffffF(10.0)", objectid, Pos[0], Pos[1], Pos[2], Pos[3], Pos[4], Pos[5], speed)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /startobjectloop (object id) (x1) (y1) (z1) (x2) (y2) (z2) (speed)");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
		else
		{
			if(ObjectCreator[Objects[playerid][objectid]] == playerid)
	  		{
	  		    new o = Objects[playerid][objectid];
	  		    SetObjectPos(o, Pos[0], Pos[1], Pos[2]);
				oMoving[o] = 1, oLap[o] = 1, oMSpeed[o] = speed;
				oStart[o][0] = Pos[0], oStart[o][1] = Pos[1], oStart[o][2] = Pos[2];
				oEnd[o][0] = Pos[3], oEnd[o][1] = Pos[4], oEnd[o][2] = Pos[5];
				MoveObject(o, Pos[3], Pos[4], Pos[5], speed);
				format(string, sizeof(string), "Object loop for object ID %d started.", objectid);
				SendClientMessage(playerid, COLOUR_INFO, string);
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_startallobjectloop(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new Float:Pos[6], Float:speed, string[128], count;
		if(sscanf(params, "ffffffF(10.0)", Pos[0], Pos[1], Pos[2], Pos[3], Pos[4], Pos[5], speed)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /startallobjectloop (x1) (y1) (z1) (x2) (y2) (z2) (speed)");
		else
		{
		    Loop(o, MAX_OBJECTS)
		    {
				if(ObjectCreator[o] == playerid)
		  		{
		  		    SetObjectPos(o, Pos[0], Pos[1], Pos[2]);
					oMoving[o] = 1, oLap[o] = 1, oMSpeed[o] = speed;
					oStart[o][0] = Pos[0], oStart[o][1] = Pos[1], oStart[o][2] = Pos[2];
					oEnd[o][0] = Pos[3], oEnd[o][1] = Pos[4], oEnd[o][2] = Pos[5];
					MoveObject(o, Pos[3], Pos[4], Pos[5], speed);
					count++;
				}
			}
			format(string, sizeof(string), "Object loop for %d objects started.", count);
			SendClientMessage(playerid, COLOUR_INFO, string);
		}
		return 1;
	}
	else return 0;
}
dcmd_stopobjectloop(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new objectid, string[128];
		if(sscanf(params, "d", objectid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /stopobjectloop (object id)");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
		else
		{
			if(ObjectCreator[Objects[playerid][objectid]] == playerid)
	  		{
	  		    oMoving[Objects[playerid][objectid]] = 0;
			    StopObject(Objects[playerid][objectid]);
			    format(string, sizeof(string), "Stopped the object loop for object ID %d.", objectid);
				SendClientMessage(playerid, COLOUR_INFO, string);
			}
		}
		return 1;
	}
	else return 0;
}
#if defined GO_DEBUG_CMDS
dcmd_getmypos(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new Float:Pos[3], string[128];
		switch(IsPlayerInAnyVehicle(playerid))
		{
		    case 0:
			{
			    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				format(string, sizeof(string), "Position: X: %0.2f | Y: %0.2f | Z: %0.2f", Pos[0], Pos[1], Pos[2]);
			}
		    case 1:
		    {
			    GetVehiclePos(GetPlayerVehicleID(playerid), Pos[0], Pos[1], Pos[2]);
				format(string, sizeof(string), "Position: X: %0.2f | Y: %0.2f | Z: %0.2f", Pos[0], Pos[1], Pos[2]);
			}
		}
		SendClientMessage(playerid, COLOUR_INFO, string);
		return 1;
	}
}
#endif
dcmd_stopallobjectloop(playerid, params[])
{
	#pragma unused params
	if(IsPlayerAdmin(playerid))
	{
	    new string[128], count;
		Loop(o, MAX_OBJECTS)
  		{
			if(ObjectCreator[o] == playerid)
			{
			    oMoving[o] = 0;
			    StopObject(o);
			    count++;
			}
		}
		format(string, sizeof(string), "Stopped the object loop for %d objects.", count);
		SendClientMessage(playerid, COLOUR_INFO, string);
		return 1;
	}
	else return 0;
}
public OnObjectMoved(objectid)
{
    if(oMoving[objectid] == 1)
    {
		switch(oLap[objectid])
		{
		    case 0:
			{
				MoveObject(objectid, oEnd[objectid][0], oEnd[objectid][1], oEnd[objectid][2], oMSpeed[objectid]);
				oLap[objectid] = 1;
			}
		    case 1:
			{
				MoveObject(objectid, oStart[objectid][0], oStart[objectid][1], oStart[objectid][2], oMSpeed[objectid]);
				oLap[objectid] = 0;
			}
		}
    }
    return 1;
}
dcmd_getobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new objectid;
		if(sscanf(params, "d", objectid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /getobject (object id)");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
		else
		{
		    if(ObjectCreator[Objects[playerid][objectid]] == playerid)
		    {
		        new o = Objects[playerid][objectid];
				GetPlayerPos(playerid, X, Y, Z);
				SetObjectPos(o, X, Y, Z);
				GetObjectPos(o, oPos[o][0], oPos[o][1], oPos[o][2]);
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_getallobject(playerid, params[])
{
	#pragma unused params
	if(IsPlayerAdmin(playerid))
	{
		GetPlayerPos(playerid, X, Y, Z);
  		Loop(o, MAX_OBJECTS)
  		{
	  		if(ObjectCreator[o] == playerid)
	  		{
				SetObjectPos(o, X, Y, Z);
				GetObjectPos(o, oPos[o][0], oPos[o][1], oPos[o][2]);
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_objecttele(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new objectid;
		if(sscanf(params, "d", objectid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Usage: /objecttele (objectid)");
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT && !IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, "You need to spawn to be able to use this command.");
		if(objectid < 0 || objectid >= GOBJ_MAX_OBJECTS_CREATED-1 || Objects[playerid][objectid] == INVALID_OBJECT_ID) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid object ID!");
        else
		{
		    if(ObjectCreator[Objects[playerid][objectid]] == playerid)
		    {
				GetObjectPos(Objects[playerid][objectid], X, Y, Z);
			    SetPlayerPos(playerid, X, Y, Z+1);
			}
		}
		return 1;
	}
	else return 0;
}
dcmd_saveobject(playerid, params[])
{
    #pragma unused params
	if(IsPlayerAdmin(playerid))
	{
        return ShowPlayerDialog(playerid, G_OBJ_DID, DIALOG_STYLE_INPUT, "{009900}GarObject - Object Saving", "{FF0000}Warning! {FFFFFF}You're about to save objects to a file.\nYou must include the .txt tag at the end of the filename.\nAll existing text in the file you're saving to will be overwritten.\n\nEnter the filename where you want to save the objects below:", "Save", "Cancel");
	}
	else return 0;
}
dcmd_loadobject(playerid, params[])
{
	#pragma unused params
	if(IsPlayerAdmin(playerid))
	{
        return ShowPlayerDialog(playerid, (G_OBJ_DID+1), DIALOG_STYLE_INPUT, "{009900}GarObject - Object Loading", "{FF0000}Warning! {FFFFFF}You're about to load objects from a file.\nYou must include the .txt tag at the end of the filename.\n\nEnter the filename where you want to load the objects from below:", "Load", "Cancel");
	}
	else return 0;
}
dcmd_savehobject(playerid, params[])
{
    #pragma unused params
	if(IsPlayerAdmin(playerid))
	{
        return ShowPlayerDialog(playerid, (G_OBJ_DID+2), DIALOG_STYLE_INPUT, "{009900}GarObject - Object Saving", "{FF0000}Warning! {FFFFFF}You're about to save objects to a file.\nYou must include the .txt tag at the end of the filename.\nAll existing text in the file you're saving to will be overwritten.\n\nEnter the filename where you want to save the objects below:", "Save", "Cancel");
	}
	else return 0;
}
dcmd_loadhobject(playerid, params[])
{
	#pragma unused params
	if(IsPlayerAdmin(playerid))
	{
        return ShowPlayerDialog(playerid, (G_OBJ_DID+3), DIALOG_STYLE_INPUT, "{009900}GarObject - Object Loading", "{FF0000}Warning! {FFFFFF}You're about to load objects from a file.\nYou must include the .txt tag at the end of the filename.\n\nEnter the filename where you want to load the objects from below:", "Load", "Cancel");
	}
	else return 0;
}
dcmd_garobject(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		#pragma unused params
		#if !defined G_OBJ_USE_SHORTCUTS
		ShowPlayerDialog(playerid, (G_OBJ_DID+4), DIALOG_STYLE_MSGBOX, "{00BC00}GarObject {FF0000}v1.3 {00BC00}by {FF0000}[03]Garsino", "/createobject\n/destroy(all)object\n/rotate(all)object\n/stop(all)object\n/move(all)object\n/objecttele\n/(de)attachpobject\n/get(all)object\n/sethobj\n/(de)attachvobject\n/stop(all)hobj\n/copyobject\n/saveobject\n/loadobject\n/savehobject\n/loadhobject\n/start(all)objectloop\n/stop(all)objectloop\n\n{00BC00}Available at the {FF0000}SA:MP {00BC00}forum.", "Close", "");
		#endif
		#if defined G_OBJ_USE_SHORTCUTS
		new string[500];
		strcat(string, "/createobject\t\t/oc\n/destroy(all)object\t/od(all)\n/rotate(all)object\t/orot(all)\n/stop(all)object\t/os(all)\n/move(all)object\t/om(all)\n/objecttele\t\t/ot\n");
        strcat(string, "/(de)attachpobject\t/(de)apo\n/get(all)object\t\t/og(all)\n/sethobj\t\t/setho\n/(de)attachvobject\t/(de)avo\n/stop(all)hobj\t\t/stop(all)ho\n/copyobject\t\t/co\n/saveobject\t\t/so\n/loadobject\t\t/lo\n/savehobject\t\t/sho\n/loadhobject\t\t/lho\n/start(all)objectloop\t/s(all)ol\n/stop(all)objectloop\t/stop(all)ol\n\n{00BC00}Available at the {FF0000}SA:MP {00BC00}forum.");
		ShowPlayerDialog(playerid, (G_OBJ_DID+4), DIALOG_STYLE_MSGBOX, "{00BC00}GarObject {FF0000}v1.3 {00BC00}by {FF0000}[03]Garsino", string, "Close", "");
		#endif
		return 1;
	}
	else return 0;
}
#if defined G_OBJ_USE_SHORTCUTS
dcmd_stopallol(playerid, params[]) return dcmd_stopallobjectloop(playerid, params);
dcmd_stopol(playerid, params[]) return dcmd_stopobjectloop(playerid, params);
dcmd_sallol(playerid, params[]) return dcmd_startallobjectloop(playerid, params);
dcmd_sol(playerid, params[]) return dcmd_startobjectloop(playerid, params);
dcmd_oc(playerid, params[]) return dcmd_createobject(playerid, params);
dcmd_or(playerid, params[]) return dcmd_rotateobject(playerid, params);
dcmd_apo(playerid, params[]) return dcmd_attachpobject(playerid, params);
dcmd_deapo(playerid, params[]) return dcmd_deattachpobject(playerid, params);
dcmd_avo(playerid, params[]) return dcmd_attachvobject(playerid, params);
dcmd_deavo(playerid, params[]) return dcmd_deattachvobject(playerid, params);
dcmd_orall(playerid, params[]) return dcmd_rotateallobject(playerid, params);
dcmd_od(playerid, params[]) return dcmd_destroyobject(playerid, params);
dcmd_odall(playerid, params[]) return dcmd_destroyallobject(playerid, params);
dcmd_os(playerid, params[]) return dcmd_stopobject(playerid, params);
dcmd_osall(playerid, params[]) return dcmd_stopallobject(playerid, params);
dcmd_om(playerid, params[]) return dcmd_moveobject(playerid, params);
dcmd_omall(playerid, params[]) return dcmd_moveallobject(playerid, params);
dcmd_og(playerid, params[]) return dcmd_getobject(playerid, params);
dcmd_ogall(playerid, params[]) return dcmd_getallobject(playerid, params);
dcmd_ot(playerid, params[]) return dcmd_objecttele(playerid, params);
dcmd_setho(playerid, params[]) return dcmd_sethobj(playerid, params);
dcmd_stopho(playerid, params[]) return dcmd_stophobj(playerid, params);
dcmd_stopallho(playerid, params[]) return dcmd_stopallhobj(playerid, params);
dcmd_so(playerid, params[]) return dcmd_saveobject(playerid, params);
dcmd_lo(playerid, params[]) return dcmd_loadobject(playerid, params);
dcmd_sho(playerid, params[]) return dcmd_savehobject(playerid, params);
dcmd_lho(playerid, params[]) return dcmd_loadhobject(playerid, params);
dcmd_co(playerid, params[]) return dcmd_copyobject(playerid, params);
dcmd_gobj(playerid, params[]) return dcmd_garobject(playerid, params);
#endif
stock GetFreeObjectID(playerid)
{
    for(new a = 0; a < GOBJ_MAX_OBJECTS_CREATED; a++)
    {
        if(Objects[playerid][a] == INVALID_OBJECT_ID)
        {
            return a;
		}
	}
    return -1;
}
stock GetTotalNativeObjects()
{
	new tmpcount = 0;
    Loop(o, MAX_OBJECTS)
    {
        if(IsValidObject(o))
        {
            tmpcount++;
		}
	}
    return tmpcount;
}
stock pNick(playerid)
{
	new GFSnick[MAX_PLAYER_NAME];
	GetPlayerName(playerid, GFSnick, MAX_PLAYER_NAME);
 	return GFSnick;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == G_OBJ_DID && response)
	{
	    return SaveObjectsToFile(playerid, inputtext);
	}
	if(dialogid == (G_OBJ_DID + 1) && response)
	{
	    return LoadObjectsFromFile(playerid, inputtext);
	}
	if(dialogid == (G_OBJ_DID + 2) && response)
	{
	    return SaveHObjectsToFile(playerid, inputtext);
	}
	if(dialogid == (G_OBJ_DID + 3) && response)
	{
	    return LoadHObjectsFromFile(playerid, inputtext);
	}
	return 0;
}
stock SaveObjectsToFile(playerid, filename[], sendmsg = 1)
{
	new File:gFile, string[158], count;
	if(strlen(filename) < 4) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}The filename you entered is shorter than 4 characters. Minimum filename is 4 characters including the .txt extension.");
    if(strfind(filename, ".txt", true) == -1) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}The filename you entered didn't have the .txt extension at the end. Please add it and continue.");
	else
	{
		if(fexist(filename))
		{
			fremove(filename);
		}
		gFile = fopen(filename, io_write);
		fclose(gFile);
		gFile = fopen(filename, io_append);
		Loop(o, MAX_OBJECTS)
		{
		    if(ObjectCreator[o] == playerid && ModelID[o] != -1)
		    {
				format(string, sizeof(string), "CreateObject(%d, %f, %f, %f, %f, %f, %f);\r\n", ModelID[o], oPos[o][0], oPos[o][1], oPos[o][2], oRot[o][0], oRot[o][1], oRot[o][2]);
				fwrite(gFile, string);
				DestroyObject(o);
				ModelID[o] = -1;
				count++;
			}
		}
		fclose(gFile);
		if(sendmsg == 1)
		{
			format(string, sizeof(string), "{009900}Save Successfull{FFFFFF}! Saved{009900} %d{FFFFFF} objects to {009900}%s{FFFFFF}.", count, filename);
			SendClientMessage(playerid, COLOUR_INFO, string);
		}
	}
	return 1;
}
stock LoadObjectsFromFile(playerid, filename[], sendmsg = 1)
{
	new File:file_ptr, modelid, Float:pos[3], Float:rot[3], count, line[256];
	if(strlen(filename) < 4) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}The filename you entered is shorter than 4 characters. Minimum filename is 4 characters including the .txt extension.");
    if(strfind(filename, ".txt", true) == -1) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}The filename you entered didn't have the .txt extension at the end. Please add it and continue.");
	if(!fexist(filename)) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}This file does not exist.");
	else
	{
		file_ptr = fopen(filename, io_read);
		while(fread(file_ptr, line) > 0)
		{
		    if(GetTotalNativeObjects() >= (MAX_OBJECTS-1)) return SendClientMessage(playerid, COLOUR_SYSTEM, "The SA:MP object limit has been reached. You can not spawn any more objects.");
		    if(GetFreeObjectID(playerid) < 0) return SendClientMessage(playerid, COLOUR_SYSTEM, "You can not spawn any more objects. Please delete one of the current ones first.");
			if(!sscanf(line, "p<,>'('ifffffp<)>f", modelid, pos[0], pos[1], pos[2], rot[0], rot[1], rot[2]))
		    {
		        new obj = GetFreeObjectID(playerid);
		        Objects[playerid][obj] = CreateObject(modelid, pos[0], pos[1], pos[2], rot[0], rot[1], rot[2]);
                new o = Objects[playerid][obj];
				ObjectCreator[o] = playerid, ModelID[o] = modelid, oPos[o][0] = pos[0], oPos[o][1] = pos[1], oPos[o][2] = pos[2], oRot[o][0] = rot[0], oRot[o][1] = rot[1], oRot[o][2] = rot[2], AttachedVehicle[o] = INVALID_VEHICLE_ID, AttachedPlayer[o] = INVALID_PLAYER_ID;
				count++;
			}
		}
		fclose(file_ptr);
		if(sendmsg == 1)
		{
			format(line, sizeof(line), "{009900}Load Successfull{FFFFFF}! Loaded{009900} %d{FFFFFF} objects from {009900}%s{FFFFFF}.", count, filename);
			SendClientMessage(playerid, COLOUR_INFO, line);
		}
	}
	return 1;
}
stock SetHOPVar(playerid, varname[], int_value, slot)
{
	new string[128];
	format(string, sizeof(string), "%s%d", varname, slot);
	return SetPVarInt(playerid, string, int_value);
}
stock GetHOPVar(playerid, varname[], slot)
{
	new string[128];
	format(string, sizeof(string), "%s%d", varname, slot);
	return GetPVarInt(playerid, string);
}
stock SetHOPFloat(playerid, varname[], Float:int_value, slot)
{
	new string[128];
	format(string, sizeof(string), "%s%d", varname, slot);
	return SetPVarFloat(playerid, string, int_value);
}
stock Float:GetHOPFloat(playerid, varname[], slot)
{
	new string[128];
	format(string, sizeof(string), "%s%d", varname, slot);
	return GetPVarFloat(playerid, string);
}
stock CountTotalHoldingObjects(playerid)
{
	new count;
	Loop(o, 5)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, o))
	    {
	        count++;
	    }
	}
	return count;
}
stock SaveHObjectsToFile(pid, filename[], sendmsg = 1)
{
	new File:gFile, string[158], count;
	if(strlen(filename) < 4) return SendClientMessage(pid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}The filename you entered is shorter than 4 characters. Minimum filename is 4 characters including the .txt extension.");
    if(strfind(filename, ".txt", true) == -1) return SendClientMessage(pid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}The filename you entered didn't have the .txt extension at the end. Please add it and continue.");
	if(CountTotalHoldingObjects(pid) == 0) return SendClientMessage(pid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}You do not have any objects to save.");
	else
	{
		if(fexist(filename))
		{
			fremove(filename);
		}
		gFile = fopen(filename, io_write);
		fclose(gFile);
		gFile = fopen(filename, io_append);
		Loop(o, 5)
		{
		    if(IsPlayerAttachedObjectSlotUsed(pid, o))
		    {
				format(string, sizeof(string), "SetPlayerAttachedObject(playerid, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f);\r\n", GetHOPVar(pid, "HOIndex", o), GetHOPVar(pid, "HOModel", o), GetHOPVar(pid, "HOBone", o), GetHOPFloat(pid, "HOOX", o), GetHOPFloat(pid, "HOOY", o), GetHOPFloat(pid, "HOOZ", o), GetHOPFloat(pid, "HORX", o), GetHOPFloat(pid, "HORY", o), GetHOPFloat(pid, "HORZ", o), GetHOPFloat(pid, "HOSX", o), GetHOPFloat(pid, "HOSY", o), GetHOPFloat(pid, "HOSZ", o));
				print(string);
				fwrite(gFile, string);
				RemovePlayerAttachedObject(pid, o);
				count++;
			}
		}
		fclose(gFile);
		if(sendmsg == 1)
		{
			format(string, sizeof(string), "{009900}Save Successfull{FFFFFF}! Saved{009900} %d{FFFFFF} objects to {009900}%s{FFFFFF}.", count, filename);
			SendClientMessage(pid, COLOUR_INFO, string);
		}
	}
	return 1;
}
stock LoadHObjectsFromFile(playerid, filename[], sendmsg = 1)
{
	new File:file_ptr, modelid, bone, index, Float:o[3], Float:r[3], Float:s[3], count, line[256];
	if(strlen(filename) < 4) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}The filename you entered is shorter than 4 characters. Minimum filename is 4 characters including the .txt extension.");
    if(strfind(filename, ".txt", true) == -1) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}The filename you entered didn't have the .txt extension at the end. Please add it and continue.");
	if(!fexist(filename)) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}This file does not exist.");
	else
	{
		file_ptr = fopen(filename, io_read);
		while(fread(file_ptr, line) > 0)
		{
			if(!sscanf(line, "p<,>'(playerid'dddffffffffp<)>f", index, modelid, bone, o[0], o[1], o[2], r[0], r[1], r[2], s[0], s[1], s[2]))
		    {
		        print(line);
		        SetPlayerAttachedObject(playerid, count, modelid, bone, o[0], o[1], o[2], r[0], r[1], r[2], s[0], s[1], s[2]);
                SetHOPVar(playerid, "HOIndex", count, count);
				SetHOPVar(playerid, "HOModel", modelid, count);
				SetHOPVar(playerid, "HOBone", bone, count);
				SetHOPFloat(playerid, "HOOX", o[0], count);
				SetHOPFloat(playerid, "HOOY", o[1], count);
				SetHOPFloat(playerid, "HOOZ", o[2], count);
				SetHOPFloat(playerid, "HORX", r[0], count);
				SetHOPFloat(playerid, "HORY", r[1], count);
				SetHOPFloat(playerid, "HORZ", r[2], count);
				SetHOPFloat(playerid, "HOSX", s[0], count);
				SetHOPFloat(playerid, "HOSY", s[1], count);
				SetHOPFloat(playerid, "HOSZ", s[2], count);
				count++;
			}
		}
		fclose(file_ptr);
		if(sendmsg == 1)
		{
			format(line, sizeof(line), "{009900}Load Successfull{FFFFFF}! Loaded{009900} %d{FFFFFF} objects from {009900}%s{FFFFFF}.", count, filename);
			SendClientMessage(playerid, COLOUR_INFO, line);
		}
	}
	return 1;
}

stock sscanf(string[], format[], {Float,_}:...)
{
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs();
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if (ch >= '0' && ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return 1;
					}
				}
				while ((ch = string[stringPos]) && ch != ' ');
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					ch,
					num = 0;
				while ((ch = string[stringPos++]))
				{
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						case ' ':
						{
							break;
						}
						default:
						{
							return 1;
						}
					}
				}
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{
				new tmp[25];
				strmid(tmp, string, stringPos, stringPos+sizeof(tmp)-2);
				setarg(paramPos, 0, _:floatstr(tmp));
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != ' ')
					{
						setarg(paramPos, i++, ch);
					}
					if (!i) return 1;
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != ' ')
		{
			stringPos++;
		}
		while (string[stringPos] == ' ')
		{
			stringPos++;
		}
		paramPos++;
	}
	while (format[formatPos] == 'z') formatPos++;
	return format[formatPos];
}
