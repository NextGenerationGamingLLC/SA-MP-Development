#include <a_samp>
#define COLOR_WHITE 0xFFFFFFAA

new status, rocket, usingrocket[MAX_PLAYERS], vehicle,  player, timer;

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
	
forward DestroyThisObject(objectid);
forward SetRocketRotation();

public OnFilterScriptExit()
{
    DestroyObject(rocket);
    KillTimer(timer);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp(cmdtext, "/attachr", true)==0)
	{
		if(IsPlayerAdmin(playerid))
 		{
			if(status == 1)
		    {
		        DestroyObject(rocket);
    			status = 0;
    			usingrocket[playerid] = 0;
				//KillTimer(timer);
			}
			else
			{
			    status = 1;
			    usingrocket[playerid] = 1;
		     	vehicle = GetPlayerVehicleID(playerid);
		     	player = playerid;
	   			rocket = CreateObject(18848,0,0,0,0,0,0);
	            AttachObjectToVehicle(rocket, vehicle, 0, -2, -1, 0, 0, 0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Rocket Installed");
				timer = SetTimer("SetRocketRotation", 50, true);
			}
		}
	}
	return 0;
}

public SetRocketRotation()
{
    AttachObjectToVehicle(rocket, vehicle, 0, -2, -1, 0, 0, (-GetRocketFacingAngle(player)));
}

Float:GetRocketFacingAngle(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
    new
	Float:fPX, Float:fPY, Float:fPZ,
	Float:fVX, Float:fVY, Float:fVZ,
	Float:object_x, Float:object_y;

	// Change me to change the scale you want. A larger scale increases the distance from the camera.
	// A negative scale will inverse the vectors and make them face in the opposite direction.
	const
		Float:fScale = -5.0;

	GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
	GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);

	object_x = fPX + floatmul(fVX, fScale);
	object_y = fPY + floatmul(fVY, fScale);
	
	new Float:angle = GetAngleBetweenPoints(object_x, object_y, X, Y);
	return angle;
}

Float:GetAngleBetweenPoints(Float:X1,Float:Y1,Float:X2,Float:Y2)
{
  new Float:angle=atan2(X2-X1,Y2-Y1);
  if(angle>360)angle-=360;
  if(angle<0)angle+=360;
  return angle;
}
