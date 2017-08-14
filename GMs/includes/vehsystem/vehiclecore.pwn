/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Vehicle Functions

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

stock vehicle_lock_doors(vehicle) {

	new
		vParamArr[7];

	GetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], vParamArr[3], vParamArr[4], vParamArr[5], vParamArr[6]);
	// if(IsABike(vehicle)) return SetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], VEHICLE_PARAMS_OFF, vParamArr[4], vParamArr[5], vParamArr[6]);
	return SetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], VEHICLE_PARAMS_ON, vParamArr[4], vParamArr[5], vParamArr[6]);
}

stock vehicle_unlock_doors(vehicle) {

	new
		vParamArr[7];

	GetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], vParamArr[3], vParamArr[4], vParamArr[5], vParamArr[6]);
	return SetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], VEHICLE_PARAMS_OFF, vParamArr[4], vParamArr[5], vParamArr[6]);
}

stock IsSeatAvailable(vehicleid, seat)
{
	switch(GetVehicleModel(vehicleid)) {
		case 425, 430, 432, 441, 446, 448, 452, 453, 454, 464, 465, 472, 473, 476, 481, 484, 485, 486, 493, 501, 509, 510, 519, 520, 530, 531, 532, 539, 553, 564, 568, 571, 572, 574, 583, 592, 594, 595: return 0;
		default: if(IsVehicleOccupied(vehicleid, seat)) return 0;
	}
	return 1;
}

stock IsPlayerInInvalidNosVehicle(playerid)
{
	switch(GetVehicleModel(GetPlayerVehicleID(playerid))) {
		case 430, 446, 448, 449, 452, 453, 454, 461, 462, 463, 468, 472, 473, 481, 484, 493, 509, 510, 521, 522, 523, 537, 538, 569, 570, 581, 586, 590, 595: return 1;
	}
	return 0;
}


stock IsARC(carid)
{
	switch(GetVehicleModel(carid)) {
		case 441, 464, 465, 501, 564: return 1;
	}
	return 0;
}

stock IsABoat(carid) {
	switch(GetVehicleModel(carid)) {
		case 472, 473, 493, 484, 430, 454, 453, 452, 446, 595: return 1;
	}
	return 0;
}

stock IsABike(carid) {
	switch(GetVehicleModel(carid)) {
		case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: return 1;
	}
	return 0;
}

stock IsATrain(modelid) {
	switch(modelid) {
		case 538, 537, 590, 569, 570: return 1;
	}
	return 0;
}

stock NoWindows(modelid) {
	switch(GetVehicleModel(modelid)) {
		case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471, 431, 437, 472, 473, 493, 484, 430, 454, 453, 452, 446, 595: return 1;
	}
	return 0;
}

stock IsASpawnedTrain(carid) {
	switch(GetVehicleModel(carid)) {
		case 538, 537, 590, 569, 570: return 1;
	}
	return 0;
}

stock IsAPlane(carid, type = 0)
{
	if(type == 0)
	{
		switch(GetVehicleModel(carid)) {
			case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
		}
	}
	else
	{
		switch(carid) {
			case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
		}
	}
	return 0;
}

stock IsRestrictedVehicle(modelid)
{
	switch(modelid) {
		case 406, 407, 408, 416, 425, 430, 432, 433, 447, 464, 465, 476, 486, 488, 490, 497, 501, 520, 523, 524, 525, 528, 532, 544, 548, 552, 563, 564, 577, 582, 592, 594, 596, 597, 598, 599, 601, 610, 611: return 1;
	}
	return 0;
}

stock IsWeaponizedVehicle(modelid)
{
	switch(modelid) {
		case 425, 432, 447, 476, 520: return 1;
	}
	return 0;
}	

stock IsATruckerCar(carid)
{
	for(new v = 0; v < sizeof(TruckerVehicles); v++) {
	    if(carid == TruckerVehicles[v]) return 1;
	}
	return 0;
}

stock IsInGarbageTruck(id)
{
	for(new i = 0; i < sizeof(GarbageVehicles); i++)
	{
		if(id == GarbageVehicles[i]) return 1;
	}
	return 0;
}

stock IsAPizzaCar(carid)
{
	for (new v = 0; v < sizeof(PizzaVehicles); v++) {
	    if(carid == PizzaVehicles[v]) return 1;
	}
	return 0;
}

stock IsATowTruck(carid)
{
	if(GetVehicleModel(carid) == 525) {
		return 1;
	}
	return 0;
}

stock IsAAircraftTowTruck(carid)
{
	if(GetVehicleModel(carid) == 485 || GetVehicleModel(carid) == 583) {
		return 1;
	}
	return 0;
}
stock IsAHelicopter(carid)
{
	if(GetVehicleModel(carid) == 548 || GetVehicleModel(carid) == 425 || GetVehicleModel(carid) == 417 || GetVehicleModel(carid) == 487 || GetVehicleModel(carid) == 488 || GetVehicleModel(carid) == 497 || GetVehicleModel(carid) == 563 || GetVehicleModel(carid) == 447 || GetVehicleModel(carid) == 469 || GetVehicleModel(carid) == 593) {
		return 1;
	}
	return 0;
}


stock IsAnBus(carid)
{
	if(GetVehicleModel(carid) == 431 || GetVehicleModel(carid) == 437) {
		return 1;
	}
	return 0;
}

stock IsAnTaxi(carid)
{
	if(GetVehicleModel(carid) == 420 || GetVehicleModel(carid) == 438) {
		return 1;
	}
	return 0;
}

stock partType(type)
{
	new name[32];
	switch(type)
	{
	    case 0:
		{
			name = "Spoiler";
        }
        case 1:
		{
			name = "Hood";
        }
        case 2:
		{
			name = "Roof";
        }
        case 3:
		{
			name = "Sideskirt";
        }
        case 4:
		{
			name = "Lamps";
        }
        case 5:
		{
			name = "Nitro";
        }
        case 6:
		{
			name = "Exhaust";
        }
        case 7:
		{
			name = "Wheels";
        }
        case 8:
		{
			name = "Stereo";
        }
        case 9:
		{
			name = "Hydraulics";
        }
        case 10:
		{
			name = "Front Bumper";
        }
        case 11:
		{
			name = "Rear Bumper";
        }
        case 12:
		{
			name = "Left Vent";
        }
        case 13:
		{
			name = "Right Vent";
        }
        default:
        {
            name = "Unknown";
		}
	}
	return name;
}

stock partName(part)
{
	new name[32];
	switch(part - 1000)
	{
		case 0:
		{
			name = "Pro";
        }
		case 1:
        {
			name = "Win";
        }
		case 2:
        {
			name = "Drag";
        }
		case 3:
        {
			name = "Alpha";
        }
		case 4:
        {
			name = "Champ Scoop";
        }
		case 5:
        {
			name = "Fury Scoop";
        }
		case 6:
        {
			name = "Roof Scoop";
        }
		case 7:
        {
			name = "Sideskirt";
        }
        case 8:
        {
            name = "2x";
        }
        case 9:
        {
            name = "5x";
        }
        case 10:
        {
            name = "10x";
        }
		case 11:
        {
			name = "Race Scoop";
        }
		case 12:
        {
			name = "Worx Scoop";
        }
		case 13:
        {
			name = "Round Fog";
        }
		case 14:
        {
			name = "Champ";
        }
		case 15:
        {
			name = "Race";
        }
		case 16:
        {
			name = "Worx";
        }
		case 17:
        {
			name = "Sideskirt";
        }
		case 18:
        {
			name = "Upswept";
        }
		case 19:
        {
			name = "Twin";
        }
		case 20:
		{
			name = "Large";
        }
		case 21:
        {
			name = "Medium";
        }
		case 22:
        {
			name = "Small";
        }
		case 23:
        {
			name = "Fury";
        }
		case 24:
        {
			name = "Square Fog";
        }
        case 25:
        {
            name = "Offroad";
        }
		case 26:
        {
			name = "Alien";
        }
		case 27:
        {
			name = "Alien";
        }
		case 28:
        {
			name = "Alien";
        }
		case 29:
        {
			name = "X-Flow";
        }
		case 30:
        {
			name = "X-Flow";
        }
		case 31:
        {
			name = "X-Flow";
        }
		case 32:
        {
			name = "Alien Roof Vent";
        }
		case 33:
        {
			name = "X-Flow Roof Vent";
        }
		case 34:
        {
			name = "Alien";
        }
		case 35:
        {
			name = "X-Flow Roof Vent";
        }
		case 36:
        {
			name = "Alien";
        }
		case 37:
        {
			name = "X-Flow";
        }
		case 38:
        {
			name = "Alien Roof Vent";
        }
		case 39:
        {
			name = "X-Flow";
        }
		case 40:
        {
			name = "Alien";
        }
		case 41:
        {
			name = "X-Flow";
        }
		case 42:
        {
			name = "Chrome";
        }
		case 43:
        {
			name = "Slamin";
        }
		case 44:
        {
			name = "Chrome";
        }
		case 45:
        {
			name = "X-Flow";
        }
		case 46:
        {
			name = "Alien";
        }
		case 47:
        {
			name = "Alien";
        }
		case 48:
        {
			name = "X-Flow";
        }
		case 49:
        {
			name = "Alien";
        }
		case 50:
        {
			name = "X-Flow";
        }
		case 51:
        {
			name = "Alien";
        }
		case 52:
        {
			name = "X-Flow";
        }
		case 53:
        {
			name = "X-Flow";
        }
		case 54:
        {
			name = "Alien";
        }
		case 55:
        {
			name = "Alien";
        }
		case 56:
        {
			name = "Alien";
        }
		case 57:
        {
			name = "X-Flow";
        }
		case 58:
        {
			name = "Alien";
        }
		case 59:
        {
			name = "X-Flow";
        }
		case 60:
        {
			name = "X-Flow";
        }
		case 61:
        {
			name = "X-Flow";
        }
		case 62:
        {
			name = "Alien";
        }
		case 63:
        {
			name = "X-Flow";
        }
		case 64:
        {
			name = "Alien";
        }
		case 65:
        {
			name = "Alien";
        }
		case 66:
        {
			name = "X-Flow";
        }
		case 67:
        {
			name = "Alien";
        }
		case 68:
        {
			name = "X-Flow";
        }
		case 69:
        {
			name = "Alien";
        }
		case 70:
        {
			name = "X-Flow";
        }
		case 71:
        {
			name = "Alien";
        }
		case 72:
        {
			name = "X-Flow";
        }
        case 73:
        {
            name = "Shadow";
        }
        case 74:
        {
            name = "Mega";
        }
        case 75:
        {
            name = "Rimshine";
        }
        case 76:
        {
            name = "Wires";
        }
        case 77:
        {
            name = "Classic";
        }
        case 78:
        {
            name = "Twist";
        }
        case 79:
        {
            name = "Cutter";
        }
        case 80:
        {
            name = "Switch";
        }
        case 81:
        {
            name = "Grove";
        }
        case 82:
        {
            name = "Import";
        }
        case 83:
        {
            name = "Dollar";
        }
        case 84:
        {
            name = "Trance";
        }
        case 85:
        {
            name = "Atomic";
        }
		case 88:
        {
			name = "Alien";
        }
		case 89:
        {
			name = "X-Flow";
        }
		case 90:
        {
			name = "Alien";
        }
		case 91:
        {
			name = "X-Flow";
        }
		case 92:
        {
			name = "Alien";
        }
		case 93:
        {
			name = "X-Flow";
        }
		case 94:
        {
			name = "Alien";
        }
		case 95:
        {
			name = "X-Flow";
        }
        case 96:
        {
            name = "Ahab";
        }
        case 97:
        {
            name = "Virtual";
        }
        case 98:
        {
            name = "Access";
        }
		case 99:
        {
			name = "Chrome";
        }
		case 100:
        {
			name = "Chrome Grill";
        }
 		case 101:
        {
			name = "Chrome Flames";
        }
		case 102:
        {
			name = "Chrome Strip";
        }
		case 103:
        {
			name = "Covertible";
        }
		case 104:
        {
			name = "Chrome";
        }
		case 105:
        {
			name = "Slamin";
        }
		case 106:
        {
			name = "Chrome Arches";
        }
		case 107:
        {
			name = "Chrome Strip";
        }
		case 108:
        {
			name = "Chrome Strip";
        }
		case 109:
        {
			name = "Chrome";
        }
		case 110:
        {
			name = "Slamin";
        }
		case 113:
        {
			name = "Chrome";
        }
		case 114:
        {
			name = "Slamin";
        }
		case 115:
        {
			name = "Chrome";
        }
		case 116:
        {
			name = "Slamin";
        }
		case 117:
        {
			name = "Chrome";
        }
		case 118:
        {
			name = "Chrome Trim";
        }
		case 119:
        {
			name = "Wheelcovers";
        }
		case 120:
        {
			name = "Chrome Trim";
        }
		case 121:
        {
			name = "Wheelcovers";
        }
		case 122:
        {
			name = "Chrome Flames";
        }
		case 123:
        {
			name = "Bullbar Chrome Bars";
        }
		case 124:
        {
			name = "Chrome Arches";
        }
		case 125:
        {
			name = "Bullbar Chrome Lights";
        }
		case 126:
        {
			name = "Chrome";
        }
		case 127:
        {
			name = "Slamin";
        }
		case 128:
        {
			name = "Vinyl Hardtop";
        }
		case 129:
        {
			name = "Chrome";
        }
		case 130:
        {
			name = "Hardtop";
        }
		case 131:
        {
			name = "Softtop";
        }
		case 132:
        {
			name = "Slamin";
        }
		case 133:
        {
			name = "Chrome Strip";
        }
		case 134:
        {
			name = "Chrome Strip";
        }
		case 135:
        {
			name = "Slamin";
        }
		case 136:
        {
			name = "Chrome";
        }
		case 137:
        {
			name = "Chrome Strip";
        }
		case 138:
        {
			name = "Alien";
        }
		case 139:
        {
			name = "X-Flow";
        }
		case 140:
        {
			name = "X-Flow";
        }
		case 141:
        {
			name = "Alien";
        }
		case 142:
        {
			name = "Left Oval Vents";
        }
		case 143:
        {
			name = "Right Oval Vents";
        }
		case 144:
        {
			name = "Left Square Vents";
        }
		case 145:
        {
			name = "Right Square Vents";
        }
		case 146:
        {
			name = "X-Flow";
        }
		case 147:
        {
			name = "Alien";
        }
		case 148:
        {
			name = "X-Flow";
        }
		case 149:
        {
			name = "Alien";
        }
		case 150:
        {
			name = "Alien";
        }
		case 151:
        {
			name = "X-Flow";
        }
		case 152:
        {
			name = "X-Flow";
        }
		case 153:
        {
			name = "Alien";
        }
		case 154:
        {
			name = "Alien";
        }
		case 155:
        {
			name = "Alien";
        }
		case 156:
        {
			name = "X-Flow";
        }
		case 157:
        {
			name = "X-Flow";
        }
		case 158:
        {
			name = "X-Flow";
        }
		case 159:
        {
			name = "Alien";
        }
		case 160:
        {
			name = "Alien";
        }
		case 161:
        {
			name = "X-Flow";
        }
		case 162:
        {
			name = "Alien";
        }
		case 163:
        {
			name = "X-Flow";
        }
		case 164:
        {
			name = "Alien";
        }
		case 165:
        {
			name = "X-Flow";
        }
		case 166:
        {
			name = "Alien";
        }
		case 167:
        {
			name = "X-Flow";
        }
		case 168:
        {
			name = "Alien";
        }
		case 169:
        {
			name = "Alien";
        }
		case 170:
        {
			name = "X-Flow";
        }
		case 171:
        {
			name = "Alien";
        }
		case 172:
        {
			name = "X-Flow";
        }
		case 173:
        {
			name = "X-Flow";
        }
		case 174:
        {
			name = "Chrome";
        }
		case 175:
        {
			name = "Slamin";
        }
		case 176:
        {
			name = "Chrome";
        }
		case 177:
        {
			name = "Slamin";
        }
		case 178:
        {
			name = "Slamin";
        }
		case 179:
        {
			name = "Chrome";
        }
		case 180:
        {
			name = "Chrome";
        }
		case 181:
        {
			name = "Slamin";
        }
		case 182:
        {
			name = "Chrome";
        }
		case 183:
        {
			name = "Slamin";
        }
		case 184:
        {
			name = "Chrome";
        }
		case 185:
        {
			name = "Slamin";
        }
		case 186:
        {
			name = "Slamin";
        }
		case 187:
        {
			name = "Chrome";
        }
		case 188:
        {
			name = "Slamin";
        }
		case 189:
        {
			name = "Chrome";
        }
		case 190:
        {
			name = "Slamin";
        }
		case 191:
        {
			name = "Chrome";
        }
		case 192:
        {
			name = "Chrome";
        }
		case 193:
        {
			name = "Slamin";
        }
   	}
	return name;
}

stock GetXYBehindVehicle(vehicleid, &Float:x, &Float:y, Float:distance)
{
    new
        Float:a;
    GetVehiclePos( vehicleid, x, y, a );
    GetVehicleZAngle( vehicleid, a );
    x += ( distance * floatsin( -a+180, degrees ));
    y += ( distance * floatcos( -a+180, degrees ));
}

stock GetPosBehindVehicle(vehicleid, &Float:x, &Float:y, &Float:z, Float:offset=1.0)
{
	new Float:vehicleSize[3], Float:vehiclePos[3];
	GetVehiclePos(vehicleid, vehiclePos[0], vehiclePos[1], vehiclePos[2]);
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, vehicleSize[0], vehicleSize[1], vehicleSize[2]);
	GetXYBehindVehicle(vehicleid, vehiclePos[0], vehiclePos[1], (vehicleSize[1]/2)+offset);
	x = vehiclePos[0];
	y = vehiclePos[1];
	z = vehiclePos[2];
	return 1;
}

TriggerVehicleAlarm(triggerid, ownerid, vehicleid)
{
	new szMessage[128], szCarLocation[MAX_ZONE_NAME], slot = GetPlayerVehicle(ownerid, vehicleid), Float: CarPos[3], engine, lights, alarm, doors, bonnet, boot, objective;
	if(PlayerVehicleInfo[ownerid][slot][pvAlarm] > 0) {
		ProxDetector(30.0, triggerid, "(( A vehicle alarm has been triggered. ))", COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		GetVehiclePos(vehicleid, CarPos[0], CarPos[1], CarPos[2]);
		Get3DZone(CarPos[0], CarPos[1], CarPos[2], szCarLocation, sizeof(szCarLocation));
		format(szMessage, sizeof(szMessage), "SMS: Your %s(%d)'s Alarm at %s has been triggered, call 911, Sender: Vehicle Security Company", VehicleName[PlayerVehicleInfo[ownerid][slot][pvModelId] - 400], vehicleid, szCarLocation);
		SendClientMessageEx(ownerid, COLOR_YELLOW, szMessage);
		PlayerVehicleInfo[ownerid][slot][pvAlarmTriggered] = 1;
		GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
		SetVehicleParamsEx(vehicleid,engine,lights,VEHICLE_PARAMS_ON,doors,bonnet,boot,objective);
	}
}

stock GetVehicleRelativePos(vehicleid, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
{
    new Float:rot;
    GetVehicleZAngle(vehicleid, rot);
    rot = 360 - rot;    // Making the vehicle rotation compatible with pawns sin/cos
	GetVehiclePos(vehicleid, x, y, z);
    
    x = floatsin(rot,degrees) * yoff + floatcos(rot,degrees) * xoff + x;
    y = floatcos(rot,degrees) * yoff - floatsin(rot,degrees) * xoff + y;
    z = zoff + z;

    /*
       where xoff/yoff/zoff are the offsets relative to the vehicle
       x/y/z then are the coordinates of the point with the given offset to the vehicle
       xoff = 1.0 would e.g. point to the right side of the vehicle, -1.0 to the left, etc.
    */
}

stock RegisterVehicleNumberPlate(vehicleid, sz_NumPlate[]) {
	new
	    Float: a_CarPos[4], Float: fuel; // X, Y, Z, Z Angle, Fuel

	GetVehiclePos(vehicleid, a_CarPos[0], a_CarPos[1], a_CarPos[2]);
	GetVehicleZAngle(vehicleid, a_CarPos[3]);
	fuel = VehicleFuel[vehicleid];
	SetVehicleNumberPlate(vehicleid, sz_NumPlate);
	SetVehicleToRespawn(vehicleid);
	SetVehiclePos(vehicleid, a_CarPos[0], a_CarPos[1], a_CarPos[2]);
	SetVehicleZAngle(vehicleid, a_CarPos[3]);
	VehicleFuel[vehicleid] = fuel;
	return 1;
}


stock legalRims(playerid, compenent, vehicleid)
{
	if(IsPlayerInRangeOfPoint(playerid, 20, 617.5360,-1.9900,1000.6592)) // Transfender
	{
		switch(compenent)
		{
		    case 1098, 1096, 1085, 1081, 1082, 1074, 1025, 1078, 1097, 1076:
		    {
		        switch(GetVehicleModel(vehicleid))
		        {
		            case  579, 400, 500, 418, 404, 489, 479, 442, 458, 602, 496, 401, 518, 527, 589, 419, 533, 526, 474, 545,
		            517, 410, 600, 436, 439, 549, 491, 555, 445, 507, 585, 604, 466, 492, 546, 551, 516, 467, 426, 405, 580, 409, 550,
		            540, 421, 529, 402, 542, 603, 475, 429, 541, 415, 480, 587, 411, 506, 451, 477, 422, 478, 438, 420, 547: return 1;
		            default: return 0;
		        }
			}
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 20,615.2861,-124.2390,997.6703)) //Wheel Arch
	{
	    switch(compenent)
		{
		    case 1085, 1077, 1079, 1083, 1081, 1082, 1074, 1075, 1073, 1080:
		    {
		        switch(GetVehicleModel(vehicleid))
		        {
		            case  562, 565, 559, 561, 560, 558: return 1;
		            default: return 0;
		        }
			}
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 20, 616.7914,-74.8150,997.8929)) // Loco
	{
	    switch(compenent)
		{
		    case 1098, 1077, 1079, 1083, 1075, 1084, 1078, 1097, 1076:
		    {
		        switch(GetVehicleModel(vehicleid))
		        {
		            case  536, 575, 534, 567, 535, 566, 576, 412: return 1;
		            default: return 0;
		        }
			}
		}
	}
	return 0;
}

vehicleSpawnCountCheck(playerid) {
	switch(PlayerInfo[playerid][pDonateRank]) {
		case 0, 1, 2: if(VehicleSpawned[playerid] >= 2) return 0;
		case 3: if(VehicleSpawned[playerid] >= 3) return 0;
		case 4, 5: if(VehicleSpawned[playerid] >= 5) return 0;
		default: return 0;
	}
	return 1;
}

vehicleCountCheck(playerid) {

	new
		iCount = GetPlayerVehicleCount(playerid);

	switch(PlayerInfo[playerid][pDonateRank]) {
		case 0: if(iCount >= 5 + PlayerInfo[playerid][pVehicleSlot]) return 0;
		case 1: if((iCount >= 6 + PlayerInfo[playerid][pVehicleSlot]) || (PlayerInfo[playerid][pTempVIP] > 0 && iCount >= 5 + PlayerInfo[playerid][pVehicleSlot])) return 0;
		case 2: if(iCount >= 7 + PlayerInfo[playerid][pVehicleSlot]) return 0;
		case 3: if(iCount >= 8 + PlayerInfo[playerid][pVehicleSlot]) return 0;
		case 4, 5: if(iCount >= 10 + PlayerInfo[playerid][pVehicleSlot]) return 0;
		default: return 0;
	}
	return 1;
}

GetPlayerVehicleCount(playerid)
{
	new cars = 0;
	for(new i = 0; i < MAX_PLAYERVEHICLES; i++) if(PlayerVehicleInfo[playerid][i][pvModelId]) ++cars;
	return cars;
}

GetPlayerVehicleSlots(playerid)
{
	switch(PlayerInfo[playerid][pDonateRank]) {
		case 0: return 5 + PlayerInfo[playerid][pVehicleSlot];
		case 1:
		{
			if(PlayerInfo[playerid][pTempVIP] > 0)
			{
				return 5 +  PlayerInfo[playerid][pVehicleSlot];
			}
			else
			{
				return 6 + PlayerInfo[playerid][pVehicleSlot];
			}
		}
		case 2: return 7 + PlayerInfo[playerid][pVehicleSlot];
		case 3: return 8 + PlayerInfo[playerid][pVehicleSlot];
		case 4, 5: return 10 + PlayerInfo[playerid][pVehicleSlot];
		default: return 0;
	}
	return 0;
}

CheckPlayerVehiclesForDesync(playerid) {
	for(new i = 0; i != MAX_PLAYERVEHICLES; ++i) {
		if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID && GetVehicleModel(PlayerVehicleInfo[playerid][i][pvId]) != PlayerVehicleInfo[playerid][i][pvModelId]) {
			UnloadPlayerVehicles(playerid);
			LoadPlayerVehicles(playerid);
			return SendClientMessageEx(playerid, COLOR_YELLOW, "Your vehicles were de-synced; they have been respawned to ensure no conflicts arise.");
	    }
	}
	return 1;
}

Vehicle_ResetData(iVehicleID) {
	if(GetVehicleModel(iVehicleID)) {
		Vehicle_Armor(iVehicleID);
		LockStatus{iVehicleID} = 0;
		VehicleStatus{iVehicleID} = 0;
		WheelClamp{iVehicleID} = 0;
		arr_Engine{iVehicleID} = 0;
		stationidv[iVehicleID][0] = 0;
		TruckContents{iVehicleID} = 0;
		TruckDeliveringTo[iVehicleID] = INVALID_BUSINESS_ID;
		VehicleFuel[iVehicleID] = 100.0;
		
		foreach(new i: Player)
		{
			if(TruckUsed[i] == iVehicleID)
			{
				DeletePVar(i, "LoadTruckTime");
				DeletePVar(i, "TruckDeliver");
				TruckUsed[i] = INVALID_VEHICLE_ID;
				gPlayerCheckpointStatus[i] = CHECKPOINT_NONE;
				DisablePlayerCheckpoint(i);
			}
			if(LockStatus{iVehicleID}) {
				if(PlayerInfo[i][pLockCar] == iVehicleID) {
					PlayerInfo[i][pLockCar] = INVALID_VEHICLE_ID;
				}
			}
			if(VehicleBomb{iVehicleID} == 1) {
				if(PlacedVehicleBomb[i] == iVehicleID) {
					VehicleBomb{iVehicleID} = 0;
					PlacedVehicleBomb[i] = INVALID_VEHICLE_ID;
					PickUpC4(i);
					PlayerInfo[i][pC4Used] = 0;
					PlayerInfo[i][pC4Get] = 1;
				}
			}
		}
	}
}

Vehicle_Armor(iVehicleID) {
	if(DynVeh[iVehicleID] != -1 && iVehicleID == DynVehicleInfo[DynVeh[iVehicleID]][gv_iSpawnedID])
	{
	    SetVehicleHealth(iVehicleID, DynVehicleInfo[DynVeh[iVehicleID]][gv_fMaxHealth]);
	}
	else if(IsDynamicCrateVehicle(iVehicleID) != -1) 
	{
		SetVehicleHealth(iVehicleID, CrateVehicle[IsDynamicCrateVehicle(iVehicleID)][cvMaxHealth]);
	}
	else
	{
		switch(GetVehicleModel(iVehicleID)) {
			case 520, 476:SetVehicleHealth(iVehicleID, 5000.0);
			case 596, 597, 598: SetVehicleHealth(iVehicleID, 2000.0);
			case 490: SetVehicleHealth(iVehicleID, 2500.0);
			case 407, 470: SetVehicleHealth(iVehicleID, 3000.0);
			case 428, 433, 447, 427: SetVehicleHealth(iVehicleID, 4000.0);
			case 601, 528: SetVehicleHealth(iVehicleID, 5000.0);
			case 432, 425: SetVehicleHealth(iVehicleID, 7500.0);
		}
	}
}

LockPlayerVehicle(ownerid, carid, type)
{
	new v = GetPlayerVehicle(ownerid, carid);
	if(PlayerVehicleInfo[ownerid][v][pvId] == carid && type == 3)
	{
	    LockStatus{carid} = 1;
	    vehicle_lock_doors(carid);
	}
}

UnLockPlayerVehicle(ownerid, carid, type)
{
	new v = GetPlayerVehicle(ownerid, carid);
	if(PlayerVehicleInfo[ownerid][v][pvId] == carid && type == 3)
	{
	    LockStatus{carid} = 0;
		vehicle_unlock_doors(carid);
	}
}

encode_tires(tire1, tire2, tire3, tire4)
{
	return tire1 | (tire2 << 1) | (tire3 << 2) | (tire4 << 3);
}

stock SurfingCheck(vehicleid)
{
	foreach(new p: Player)
	{
		if(GetPlayerSurfingVehicleID(p) == vehicleid)
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(p, x, y, z);
			SetTimerEx("SurfingFix", 2000, 0, "ifff", p, x, y, z);
		}
	}	
}

stock InvalidModCheck(model, partid) {
    switch(model) {
		case 427, 430, 446, 452, 453, 454, 472, 473, 484, 493, 595, 573, 556, 557, 539, 471, 432, 406, 444,
		448, 461, 462, 463, 468, 481, 509, 510, 521, 522, 581, 586, 417, 425, 447, 460, 469, 476, 487,
		488, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593: return 0;
		default: switch(GetVehicleComponentType(partid)) {
			case 5: switch(partid) {
				case 1008, 1009, 1010: return 1;
				default: return 0;
			}
			case 7: switch(partid) {
				case 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098, 1025: return 1;
				default: return 0;
			}
			case 8: switch(partid) {
				case 1086: return 1;
				default: return 0;
			}
			case 9: switch(partid) {
				case 1087: return 1;
				default: return 0;
			}
			case 12, 13: switch(partid) {
				case 1142, 1144, 1143, 1145: return 1;
				default: return 0;
			}
		}
	}
	return 1;
}


stock SetVehicleLights(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(lights == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,VEHICLE_PARAMS_OFF,alarm,doors,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle lights successfully turned off.");
	}
    else if(lights == VEHICLE_PARAMS_OFF || lights == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,VEHICLE_PARAMS_ON,alarm,doors,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle lights successfully turned on.");
	}
	return 1;
}

stock SetVehicleHood(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(bonnet == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,VEHICLE_PARAMS_OFF,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle hood successfully closed.");
	}
    else if(bonnet == VEHICLE_PARAMS_OFF || bonnet == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,VEHICLE_PARAMS_ON,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle hood successfully opened.");
	}
	return 1;
}

stock SetVehicleTrunk(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(boot == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_OFF,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle trunk successfully closed.");
	}
    else if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_ON,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle trunk successfully opened.");
	}
	return 1;
}

stock SetVehicleDoors(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(doors == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,VEHICLE_PARAMS_OFF,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle {AA3333}Doors {FFFFFF}successfully {33AA33}closed{FFFFFF}.");
	}
    else if(doors == VEHICLE_PARAMS_OFF || doors == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,VEHICLE_PARAMS_ON,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle {AA3333}Doors {FFFFFF}successfully {33AA33}opened{FFFFFF}.");
	}
	return 1;
}

stock IsValidVehicleID(vehicleid)
{
   if(GetVehicleModel(vehicleid)) return 1;
   return 0;
}

stock GetClosestCar(iPlayer, iException = INVALID_VEHICLE_ID, Float: fRange = Float: 0x7F800000) {

	new
		iReturnID = INVALID_VEHICLE_ID,
		Float: fVehiclePos[4];

	for(new i = 1; i <= MAX_VEHICLES; ++i) if(GetVehicleModel(i) && i != iException) {
		GetVehiclePos(i, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
		if((fVehiclePos[3] = GetPlayerDistanceFromPoint(iPlayer, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2])) < fRange) {
			fRange = fVehiclePos[3];
			iReturnID = i;
		}
	}
	return iReturnID;
}

stock Float: GetVehicleFuelCapacity(vehicleid)
{
	new Float: capacity;
	if (IsABike(vehicleid)) {
		capacity = 5.0;
	}
 	else {
	 	capacity = 20.00;
	}
	return capacity;
	//TODO optimise more
}

stock RespawnNearbyVehicles(iPlayerID, Float: fRadius) {

	new
		Float: fPlayerPos[3];

    GetPlayerPos(iPlayerID, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
    for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(GetVehicleModel(i) && GetVehicleDistanceFromPoint(i, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]) <= fRadius && !IsVehicleOccupied(i))
		{
			if(DynVeh[i] != -1)
			{
			    DynVeh_Spawn(DynVeh[i]);
			    TruckDeliveringTo[i] = INVALID_BUSINESS_ID;
			}
			SetVehicleToRespawn(i);
		}
	}
	return 1;
}

stock IsRefuelableVehicle(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);
	switch (modelid)
	{
		case 481, 509, 510: return 0; // Bikes
	}
	return 1;
}

stock SetVehicleTireState(vehicleid, tire1, tire2, tire3, tire4)
{
    new panels, doors, Lights, tires;
   	GetVehicleDamageStatus(vehicleid, panels, doors, Lights, tires);
    tires = encode_tires(!tire1, !tire2, !tire3, !tire4);
    UpdateVehicleDamageStatus(vehicleid, panels, doors, Lights, tires);
}

stock GetVehicleTireState(vehicleid, &tire1, &tire2, &tire3, &tire4)
{
    new panels, doors, Lights, tires;
   	GetVehicleDamageStatus(vehicleid, panels, doors, Lights, tires);
    tire1 = !(tires >> 0 & 0x1);
	tire2 = !(tires >> 1 & 0x1);
	tire3 = !(tires >> 2 & 0x1);
	tire4 = !(tires >> 3 & 0x1);
}

stock IsVehicleOccupied(iVehicleID, iSeatID = 0) {
	foreach(new x : Player)
	{
		if(GetPlayerVehicleID(x) == iVehicleID && GetPlayerVehicleSeat(x) == iSeatID) {
			return 1;
		}
	}	
	return 0;
}

stock IsVehicleInTow(iVehicleID) {
	foreach(new x : Player)
	{
		if(arr_Towing[x] == iVehicleID) {
			return 1;
		}
	}	
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	szMiscArray[0] = 0;
	IsPlayerEntering{playerid} = true;
	Seatbelt[playerid] = 0;
	if(InsideTut{playerid} > 0)
	{
		if(GetPVarType(playerid, "Autoban")) return 1;
		SetPVarInt(playerid, "Autoban", 1); 
		CreateBan(INVALID_PLAYER_ID, PlayerInfo[playerid][pId], playerid, PlayerInfo[playerid][pIP], "Warp Hacking (Tutorial)", 180);
		TotalAutoBan++;
	}
	if(GetPVarType(playerid, "HelmetOn"))
	{
		for(new i; i < 10; i++) {
			if(PlayerHoldingObject[playerid][i] == GetPVarInt(playerid, "HelmetOn")) {
				PlayerHoldingObject[playerid][i] = 0;
				RemovePlayerAttachedObject(playerid, i);
				DeletePVar(playerid, "HelmetOn");
				break;
			}
		}
	}

	if(PlayerCuffed[playerid] != 0) SetPVarInt( playerid, "ToBeEjected", 1 );
	if(GetPVarInt(playerid, "BackpackMedKit") == 1)
		DeletePVar(playerid, "BackpackMedKit");
	if(GetPVarInt(playerid, "BackpackMeal") == 1)
		DeletePVar(playerid, "BackpackMeal");
	if(GetPVarType(playerid, "BackpackOpen"))
		DeletePVar(playerid, "BackpackOpen");
	if(ispassenger) {
		if(GetPVarType(playerid, "Injured")) {
			SetPlayerPos(playerid, GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"));
			ClearAnimationsEx(playerid);
			PlayDeathAnimation(playerid);
		}
		else if(PlayerCuffed[playerid] != 0) {
			ClearAnimationsEx(playerid);
			ApplyAnimation(playerid,"ped","cower",1,1,0,0,0,0,1);
			TogglePlayerControllable(playerid, false);
		}
	}
	SetPVarInt(playerid, "LastWeapon", GetPlayerWeapon(playerid));

	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	if(engine == VEHICLE_PARAMS_UNSET) switch(GetVehicleModel(vehicleid)) {
		case 509, 481, 510: VehicleFuel[vehicleid] = GetVehicleFuelCapacity(vehicleid), arr_Engine{vehicleid} = 1, SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
		default: SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF,VEHICLE_PARAMS_OFF,alarm,doors,bonnet,boot,objective), arr_Engine{vehicleid} = 0;
	}

	if(GetPVarInt(playerid, "UsingSprunk") == 1)
	{
		SetPVarInt(playerid, "UsingSprunk", 0);
		SetPVarInt(playerid, "DrinkCooledDown", 0);
	}

    if(GetPVarType(playerid, "Pizza") && !(IsAPizzaCar(vehicleid)))
	{
	    new Float:slx, Float:sly, Float:slz;
		GetPlayerPos(playerid, slx, sly, slz);
		SetPlayerPos(playerid, slx, sly, slz+1.3);
		PlayerPlaySound(playerid, 1130, slx, sly, slz+1.3);
		RemovePlayerFromVehicle(playerid);
		defer NOPCheck(playerid);
		SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be in a Pizzaboy when delivering pizzas!");
		return 1;
	}
	if(!ispassenger)
	{
	    SetPlayerArmedWeapon(playerid, 0);
		if(PlayerInfo[playerid][pAccountRestricted] == 1)
		{
			new Float:slx, Float:sly, Float:slz;
			GetPlayerPos(playerid, slx, sly, slz);
			SetPlayerPos(playerid, slx, sly, slz+1.3);
			RemovePlayerFromVehicle(playerid);
			defer NOPCheck(playerid);
			return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot drive any vehicles while your account is restricted!");
		}
		if(IsVIPcar(vehicleid))
		{
		    if(PlayerInfo[playerid][pDonateRank] == 0)
			{
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz+1.3);
				PlayerPlaySound(playerid, 1130, slx, sly, slz+1.3);
			    RemovePlayerFromVehicle(playerid);
			    defer NOPCheck(playerid);
			    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a VIP, this is a vehicle from the VIP Garage!");
			}
		}
		else if(IsWeaponizedVehicle(GetVehicleModel(vehicleid)))
	    {
	        if(PlayerInfo[playerid][pLevel] < 6)
	        {
				if(gettime() > GetPVarInt(playerid, "timeWepVeh"))
				{
					new szString[128];
					format(szString, sizeof(szString), "{AA3333}AdmWarning{FFFF00}: %s (ID: %d) has entered a weaponized vehicle (Vehicle ID: %d) (Level: %d)", GetPlayerNameEx(playerid), playerid, vehicleid, PlayerInfo[playerid][pLevel]);
					ABroadCast(COLOR_YELLOW, szString, 2);
					SetPVarInt(playerid, "timeWepVeh", gettime()+5);
				}
			}
		}
		else if(IsFamedVeh(vehicleid))
		{
		    if(PlayerInfo[playerid][pFamed] > 0 || PlayerInfo[playerid][pFamed] < 8)
		    {
				if(IsOSModel(vehicleid))
				{
				    if(PlayerInfo[playerid][pFamed] < 1)
				    {
                        new Float:slx, Float:sly, Float:slz;
						GetPlayerPos(playerid, slx, sly, slz);
						SetPlayerPos(playerid, slx, sly, slz+1.3);
						PlayerPlaySound(playerid, 1130, slx, sly, slz+1.3);
					    RemovePlayerFromVehicle(playerid);
					    defer NOPCheck(playerid);
					    SendClientMessageEx(playerid, COLOR_GRAD2, "This is a Old-School+ Vehicle, therefore you may not drive this.");
					}
				}
				else if(IsCOSModel(vehicleid))
				{
					if(PlayerInfo[playerid][pFamed] < 1)
					{
					    new Float:slx, Float:sly, Float:slz;
						GetPlayerPos(playerid, slx, sly, slz);
						SetPlayerPos(playerid, slx, sly, slz+1.3);
						PlayerPlaySound(playerid, 1130, slx, sly, slz+1.3);
					    RemovePlayerFromVehicle(playerid);
					    defer NOPCheck(playerid);
					    SendClientMessageEx(playerid, COLOR_GRAD2, "This is a Chartered Old-School+ Vehicle, therefore you may not drive this.");
					}
				}
				else if(IsFamedModel(vehicleid))
				{
				    if(PlayerInfo[playerid][pFamed] < 1)
				    {
				        new Float:slx, Float:sly, Float:slz;
						GetPlayerPos(playerid, slx, sly, slz);
						SetPlayerPos(playerid, slx, sly, slz+1.3);
						PlayerPlaySound(playerid, 1130, slx, sly, slz+1.3);
					    RemovePlayerFromVehicle(playerid);
					    defer NOPCheck(playerid);
					    SendClientMessageEx(playerid, COLOR_GRAD2, "This is a Famed+ Vehicle, therefore you may not drive this.");
					}
				}
			}
		}
		else if(IsAPizzaCar(vehicleid))
		{
		    if(PlayerInfo[playerid][pJob] != 21 && PlayerInfo[playerid][pJob2] != 21 && PlayerInfo[playerid][pJob3] != 21)
		    {
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz+1.3);
				PlayerPlaySound(playerid, 1130, slx, sly, slz+1.3);
			    RemovePlayerFromVehicle(playerid);
			    defer NOPCheck(playerid);
			    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a Pizza Boy!");
			}
		}

		else if(IsATruckerCar(vehicleid))
		{
		    if((PlayerInfo[playerid][pJob] == 20 || PlayerInfo[playerid][pJob2] == 20 || PlayerInfo[playerid][pJob3] == 20))
			{
				new string[128];
				new iTruckContents = TruckContents{vehicleid};
				new truckcontentname[50];
				if(iTruckContents == 1)
				{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}Food & beverages");}
				else if(iTruckContents == 2)
				{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}Clothing"); }
				else if(iTruckContents == 3)
				{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}Legal materials"); }
				else if(iTruckContents == 4)
				{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}24/7 items"); }
				else if(iTruckContents == 5)
				{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Illegal weapons"); }
				else if(iTruckContents == 6)
				{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Illegal drugs"); }
				else if(iTruckContents == 7)
				{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Illegal materials"); }
				if(iTruckContents == 0)
				{ format(truckcontentname, sizeof(truckcontentname), "%s",  GetInventoryType(TruckDeliveringTo[vehicleid])); }
				format(string, sizeof(string), "SHIPMENT CONTRACTOR: (Vehicle registration: %s %d) - (Content: %s{FFFF00})", GetVehicleName(vehicleid), vehicleid, truckcontentname);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);

				if(IsACop(playerid))
				{
					SendClientMessageEx(playerid, COLOR_DBLUE, "LAW ENFORCEMENT: To remove any illegal goods type /clearcargo near the Vehicle.");
				}
				if(TruckDeliveringTo[vehicleid] != INVALID_BUSINESS_ID && TruckUsed[playerid] == INVALID_VEHICLE_ID)
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "SHIPMENT CONTRACTOR JOB: To deliver the goods type /hijackcargo as the driver.");
				}
				else if(TruckUsed[playerid] == INVALID_VEHICLE_ID)
				{
    				SendClientMessageEx(playerid, COLOR_YELLOW, "SHIPMENT CONTRACTOR JOB: To get goods type /loadshipment as the driver.");
				}
				else if(TruckUsed[playerid] == vehicleid && gPlayerCheckpointStatus[playerid] == CHECKPOINT_RETURNTRUCK)
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "SHIPMENT CONTRACTOR JOB: This is your shipment, you have not returned it to the docks yet for your pay.");
				}
				else if(TruckUsed[playerid] == vehicleid)
   				{
      				SendClientMessageEx(playerid, COLOR_YELLOW, "SHIPMENT CONTRACTOR JOB: This is your shipment, you have not delivered your goods yet.");
     			}
				else if(TruckUsed[playerid] != INVALID_VEHICLE_ID)
   				{
      				SendClientMessageEx(playerid, COLOR_YELLOW, "SHIPMENT CONTRACTOR JOB: You are already on another delivery, type /cancel shipment to cancel that delivery.");
     			}
			}
		    else if(!IsABoat(vehicleid))
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    defer NOPCheck(playerid);
			    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a Shipment Contractor!");
			}
		}
		else if(IsInGarbageTruck(vehicleid))
		{
			if(PlayerInfo[playerid][pJob] == 27 || PlayerInfo[playerid][pJob2] == 27 || PlayerInfo[playerid][pJob3] == 27)
			{
			}
		    else
			{
		        SendClientMessageEx(playerid,COLOR_GREY,"   You are not a Garbage Man!");
		        RemovePlayerFromVehicle(playerid);
		        new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
		    }
		}
	   	else if(IsAPlane(vehicleid))
		{
	  		if(PlayerInfo[playerid][pFlyLic] != 1)
	  		{
				if(GetPVarInt(playerid, "SprunkGuardLic") == 0)
				{
					RemovePlayerFromVehicle(playerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(playerid, slx, sly, slz);
					SetPlayerPos(playerid, slx, sly, slz);
					defer NOPCheck(playerid);
					SendClientMessageEx(playerid,COLOR_GREY,"You don't have a pilot license!");
				}
	  		}
		}
		else if(IsAHelicopter(vehicleid))
		{
		    PlayerInfo[playerid][pAGuns][GetWeaponSlot(46)] = 46;
			GivePlayerValidWeapon(playerid, 46);
		}
		else if(IsAnTaxi(vehicleid) || IsAnBus(vehicleid))
		{
	        if(PlayerInfo[playerid][pJob] == 17 || PlayerInfo[playerid][pJob2] == 17 || PlayerInfo[playerid][pJob3] == 17 || IsATaxiDriver(playerid) || PlayerInfo[playerid][pTaxiLicense] == 1)
			{
			}
		    else
			{
		        SendClientMessageEx(playerid,COLOR_GREY,"   You are not a Taxi/Bus Driver!");
		        RemovePlayerFromVehicle(playerid);
		        new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
		    }
		}
		else if(IsASpawnedTrain(vehicleid))
		{
			if(!IsATaxiDriver(playerid))
			{
				SendClientMessageEx(playerid,COLOR_GREY,"   You are not part of a transportation department!");
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
		    }
		}
	}
	else if(!IsPlayerInRangeOfVehicle(playerid, vehicleid, 7.5) || (LockStatus{vehicleid} >= 1)) { // G-bugging fix
		ClearAnimationsEx(playerid);
	}
	return 1;
}

CMD:carhelp(playerid, params[])
{
	SetPVarInt(playerid, "HelpResultCat0", 3);
	Help_ListCat(playerid, DIALOG_HELPCATOTHER1);
	return 1;
}

CMD:ocarhelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** CAR OWNERSHIP HELP *** - type a command for more infomation.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** CAR OWNERSHIP *** /lock /pvlock /park /parktrailer /unmodcar /deletecar /sellmycar /trackcar");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** CAR OWNERSHIP *** /dmvmenu /givekeys /carkeys /trunkput /trunktake /car /refuel");
    return 1;
}

CMD:car(playerid, params[])
{
	new string[128], choice[8], id;
	if(sscanf(params, "s[8]D(0)", choice, id))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /car [name]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Status, Engine, Lights, Trunk, Hood, Fuel, Window [0-3], Windows");
		return 1;
	}
	if(strcmp(choice, "engine", true) == 0 && IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new engine,lights,alarm,doors,bonnet,boot,objective,vehicleid;
		vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510 || DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1 && GetVehicleModel(vehicleid) == 592) return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used in this vehicle.");
		if(WheelClamp{vehicleid}) return SendClientMessageEx(playerid,COLOR_WHITE,"(( This vehicle has a wheel camp on its front tire, you will not be able to drive away with it. ))");

		GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
		if(engine == VEHICLE_PARAMS_ON)
		{
			SetVehicleEngine(vehicleid, playerid);
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s turns the key in the ignition and the engine stops.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else if((engine == VEHICLE_PARAMS_OFF || engine == VEHICLE_PARAMS_UNSET))
		{
			if (GetPVarInt(playerid, "Refueling")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while refueling.");
			// if(!Vehicle_LockCheck(playerid, vehicleid)) return 1;
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s turns the key in the ignition and the engine starts.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle engine starting, please wait...");
			SetTimerEx("SetVehicleEngine", 1000, 0, "dd",  vehicleid, playerid);
			RemoveVehicleFromMeter(vehicleid);
		}
	}
	else if(strcmp(choice, "lights", true) == 0 && IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510) return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used in this vehicle.");
		SetVehicleLights(vehicleid, playerid);
	}
	else if(strcmp(choice, "hood", true) == 0)
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510 || IsAPlane(vehicleid) || IsABike(vehicleid))
			{
				return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used in this vehicle.");
			}
			SetVehicleHood(vehicleid, playerid);
		}
		else if(!IsPlayerInAnyVehicle(playerid))
		{
			new closestcar = GetClosestCar(playerid);
			if(IsPlayerInRangeOfVehicle(playerid, closestcar, 5.0))
			{
				if(GetVehicleModel(closestcar) == 481 || GetVehicleModel(closestcar) == 509 || GetVehicleModel(closestcar) == 510 || IsAPlane(closestcar) || IsABike(closestcar))
				{
					return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used on this vehicle.");
				}
				SetVehicleHood(closestcar, playerid);
			}
		}
	}
	else if(strcmp(choice, "trunk", true) == 0)
  	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510)
			{
				return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used in this vehicle.");
			}
			if(CarryCrate[playerid] != -1) return SendClientMessageEx(playerid,COLOR_WHITE,"You need both hands to open the car trunk!"); 
			SetVehicleTrunk(vehicleid, playerid);
		}
		else if(!IsPlayerInAnyVehicle(playerid))
		{
			new closestcar = GetClosestCar(playerid);
			if(IsPlayerInRangeOfVehicle(playerid, closestcar, 5.0))
			{
				if(GetVehicleModel(closestcar) == 481 || GetVehicleModel(closestcar) == 509 || GetVehicleModel(closestcar) == 510)
				{
					return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used on this vehicle.");
				}
				if(CarryCrate[playerid] != -1) return SendClientMessageEx(playerid,COLOR_WHITE,"You need both hands to open the car trunk!"); 
				SetVehicleTrunk(closestcar, playerid);
			}
		}
	}
	else if(strcmp(choice, "fuel", true) == 0 && IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		new engine,lights,alarm,doors,bonnet,boot,objective,enginestatus[4],lightstatus[4];
		GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
		if(!IsRefuelableVehicle(vehicleid)) return SendClientMessageEx(playerid,COLOR_RED,"This vehicle doesn't need fuel.");
		if(engine != VEHICLE_PARAMS_ON) strcpy(enginestatus, "OFF", 4);
		else strcpy(enginestatus, "ON", 3);
		if(lights != VEHICLE_PARAMS_ON) strcpy(lightstatus, "OFF", 4);
		else strcpy(lightstatus, "ON", 3);

		if(IsVIPcar(vehicleid) || IsAdminSpawnedVehicle(vehicleid) || IsFamedVeh(vehicleid)) format(string, sizeof(string), "Engine: %s | Lights: %s | Fuel: Unlimited",enginestatus,lightstatus);
		else format(string, sizeof(string), "Engine: %s | Lights: %s | Fuel: %.1f%s",enginestatus,lightstatus, VehicleFuel[vehicleid], "%");
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else if(strcmp(choice, "status", true) == 0 && IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicle(playerid, vehicleid);
		new engine,lights,alarm,doors,bonnet,boot,objective,enginestatus[4],lightstatus[4];
		GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
		if(!IsRefuelableVehicle(vehicleid)) return SendClientMessageEx(playerid,COLOR_RED,"This vehicle doesn't need fuel.");
		if(engine != VEHICLE_PARAMS_ON) strcpy(enginestatus, "OFF", 4);
		else strcpy(enginestatus, "ON", 3);
		if(lights != VEHICLE_PARAMS_ON) strcpy(lightstatus, "OFF", 4);
		else strcpy(lightstatus, "ON", 3);
		if (IsVIPcar(vehicleid) || IsAdminSpawnedVehicle(vehicleid) || IsFamedVeh(vehicleid)) format(string, sizeof(string), "Engine: %s | Lights: %s | Fuel: Unlimited | Windows: %s",enginestatus,lightstatus,(VehInfo[GetPlayerVehicleID(playerid)][vCarWindows] == 0) ? ("Up") : ("Down"));
		else if(slot != -1) format(string, sizeof(string), "Engine: %s | Lights: %s | Fuel: %.1f percent | Windows: %s | Lock Durability: %d/5",enginestatus,lightstatus, VehicleFuel[vehicleid], (VehInfo[GetPlayerVehicleID(playerid)][vCarWindows] == 0) ? ("Up") : ("Down"), PlayerVehicleInfo[playerid][slot][pvLocksLeft]);
		else format(string, sizeof(string), "Engine: %s | Lights: %s | Fuel: %.1f percent | Windows: %s",enginestatus,lightstatus, VehicleFuel[vehicleid], (VehInfo[GetPlayerVehicleID(playerid)][vCarWindows] == 0) ? ("Up") : ("Down"));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else if(strcmp(choice, "window", true) == 0 && IsPlayerInAnyVehicle(playerid) && !IsABike(GetPlayerVehicleID(playerid)) && !IsABoat(GetPlayerVehicleID(playerid)))
	{
		if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't do that at this time.");
		if(NoWindows(GetPlayerVehicleID(playerid))) return SendClientMessageEx(playerid, COLOR_GREY, "You can't do use this on this type of vehicle.");
		new driver, passenger, backleft, backright;
		GetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), driver, passenger, backleft, backright);
		if((GetPlayerState(playerid) == PLAYER_STATE_DRIVER && id == 0) || (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER && GetPlayerVehicleSeat(playerid) == 0))
		{
			if(VehInfo[GetPlayerVehicleID(playerid)][vCarWindow0]) VehInfo[GetPlayerVehicleID(playerid)][vCarWindow0] = 0;
			else VehInfo[GetPlayerVehicleID(playerid)][vCarWindow0] = 1;
			SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), !driver, passenger, backleft, backright);
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s winds the driver-side window %s.", GetPlayerNameEx(playerid), (VehInfo[GetPlayerVehicleID(playerid)][vCarWindow0] == 0) ? ("up") : ("down"));
		}
		else if((GetPlayerState(playerid) == PLAYER_STATE_DRIVER && id == 1) || (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER && GetPlayerVehicleSeat(playerid) == 1))
		{
			if(VehInfo[GetPlayerVehicleID(playerid)][vCarWindow1]) VehInfo[GetPlayerVehicleID(playerid)][vCarWindow1] = 0;
			else VehInfo[GetPlayerVehicleID(playerid)][vCarWindow1] = 1;
			SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), driver, !passenger, backleft, backright);
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s winds the passenger-side window %s.", GetPlayerNameEx(playerid), (VehInfo[GetPlayerVehicleID(playerid)][vCarWindow1] == 0) ? ("up") : ("down"));
		}
		else if((GetPlayerState(playerid) == PLAYER_STATE_DRIVER && id == 2) || (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER && GetPlayerVehicleSeat(playerid) == 2))
		{
			if(VehInfo[GetPlayerVehicleID(playerid)][vCarWindow2]) VehInfo[GetPlayerVehicleID(playerid)][vCarWindow2] = 0;
			else VehInfo[GetPlayerVehicleID(playerid)][vCarWindow2] = 1;
			SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), driver, passenger, !backleft, backright);
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s winds the rear driver-side window %s.", GetPlayerNameEx(playerid), (VehInfo[GetPlayerVehicleID(playerid)][vCarWindow2] == 0) ? ("up") : ("down"));
		}
		else if((GetPlayerState(playerid) == PLAYER_STATE_DRIVER && id == 3) || (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER && GetPlayerVehicleSeat(playerid) == 3))
		{
			if(VehInfo[GetPlayerVehicleID(playerid)][vCarWindow3]) VehInfo[GetPlayerVehicleID(playerid)][vCarWindow3] = 0;
			else VehInfo[GetPlayerVehicleID(playerid)][vCarWindow3] = 1;
			SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), driver, passenger, backleft, !backright);
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s winds the rear passenger-side window %s.", GetPlayerNameEx(playerid), (VehInfo[GetPlayerVehicleID(playerid)][vCarWindow3] == 0) ? ("up") : ("down"));
		}
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else if(strcmp(choice, "windows", true) == 0 && IsPlayerInAnyVehicle(playerid) && !IsABike(GetPlayerVehicleID(playerid)) && !IsABoat(GetPlayerVehicleID(playerid)))
	{
		if(NoWindows(GetPlayerVehicleID(playerid))) return SendClientMessageEx(playerid, COLOR_GREY, "You can't do use this on this type of vehicle.");
		new driver, passenger, backleft, backright;
		GetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), driver, passenger, backleft, backright);
		SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), !driver, !passenger, !backleft, !backright);
	    if(VehInfo[GetPlayerVehicleID(playerid)][vCarWindows])
	    {
	    	VehInfo[GetPlayerVehicleID(playerid)][vCarWindows] = 0;
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s winds their windows up.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	    }
	    else {
            VehInfo[GetPlayerVehicleID(playerid)][vCarWindows] = 1;
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s winds their windows down.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	    }
	}
	return 1;
}

CMD:window(playerid, params[]) {
	
    if(InsidePlane[playerid] != INVALID_VEHICLE_ID && GetPVarType(playerid, "InsideCar")) {

        if(GetPlayerInterior(playerid) != 0) {

            new
                Float: fSpecPos[6];

            GetPlayerPos(playerid, fSpecPos[0], fSpecPos[1], fSpecPos[2]);
            GetPlayerFacingAngle(playerid, fSpecPos[3]);
            GetHealth(playerid, fSpecPos[4]);
            GetArmour(playerid, fSpecPos[5]);

            SetPVarFloat(playerid, "air_Xpos", fSpecPos[0]);
            SetPVarFloat(playerid, "air_Ypos", fSpecPos[1]);
            SetPVarFloat(playerid, "air_Zpos", fSpecPos[2]);
            SetPVarFloat(playerid, "air_Rpos", fSpecPos[3]);
            SetPVarFloat(playerid, "air_HP", fSpecPos[4]);
            SetPVarFloat(playerid, "air_Arm", fSpecPos[5]);
            SetPVarInt(playerid, "air_Int", GetPlayerInterior(playerid));
            SetPVarInt(playerid, "air_Mode", 1);

            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            TogglePlayerSpectating(playerid, true);
            PlayerSpectateVehicle(playerid, InsidePlane[playerid]);

            format(szMiscArray, sizeof(szMiscArray), "* %s glances out the window.", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        }
        else 
        {
        	TogglePlayerSpectating(playerid, 0);
        	SetPlayerPos(playerid, GetPVarFloat(playerid, "air_Xpos"), GetPVarFloat(playerid, "air_Ypos"), GetPVarFloat(playerid, "air_Zpos"));
   		}
    }
    return 1;
}

CMD:lock(playerid, params[])
{
   	if(PlayerInfo[playerid][pLock] == 1)
	{
 		if(IsPlayerInAnyVehicle(playerid))
   		{
			if(PlayerInfo[playerid][pLockCar] != GetPlayerVehicleID(playerid) && PlayerInfo[playerid][pLockCar] != INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a lock for this vehicle!");
   			if(GetPlayerVehicleSeat(playerid) != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Can't lock vehicles as a passenger!");
   			new v = -1;
   			foreach(new i: Player)
			{
				v = GetPlayerVehicle(i, GetPlayerVehicleID(playerid));
				if(v != -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Can't lock player-owned vehicles!");
			}	
   			if(PlayerInfo[playerid][pLockCar] == INVALID_VEHICLE_ID) PlayerInfo[playerid][pLockCar] = GetPlayerVehicleID(playerid);
      		if(LockStatus{GetPlayerVehicleID(playerid)} == 0)
        	{
				LockStatus{GetPlayerVehicleID(playerid)} = 1;
    			GameTextForPlayer(playerid, "~r~locked", 1000, 6);
       			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
          		vehicle_lock_doors(PlayerInfo[playerid][pLockCar]);
      		}
        	else
	        {
				LockStatus{GetPlayerVehicleID(playerid)} = 0;
   				vehicle_unlock_doors(PlayerInfo[playerid][pLockCar]);
      			GameTextForPlayer(playerid, "~g~unlocked", 1000, 6);
        		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
 	        }
   		}
	    else
	    {
     		new Float: x, Float: y, Float: z;
       		GetVehiclePos(PlayerInfo[playerid][pLockCar], x, y, z);
        	if(IsPlayerInRangeOfPoint(playerid, 4.0, x, y, z))
        	{
         		if(LockStatus{PlayerInfo[playerid][pLockCar]} == 0)
           		{
            		vehicle_lock_doors(PlayerInfo[playerid][pLockCar]);
            		GameTextForPlayer(playerid, "~r~locked", 1000, 6);
	            	PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
 	            }
 	            else
 	            {
	            	vehicle_unlock_doors(PlayerInfo[playerid][pLockCar]);
	            	GameTextForPlayer(playerid, "~g~unlocked", 1000, 6);
	            	PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
          		}
   	        }
   	        else
   	        {
            	SendClientMessageEx(playerid, COLOR_GRAD2, "You are not near your vehicle!");
	            return 1;
   	        }
       	}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, " You do not have a lock!");
		return 1;
 	}
	return 1;
}

CMD:vstorage(playerid, params[])
{
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this at this time.");
	if(PlayerInfo[playerid][pFreezeCar] == 0 || PlayerInfo[playerid][pAdmin] >= 2)
	{
		new vstring[4096], icount = GetPlayerVehicleSlots(playerid);
		new szCarLocation[MAX_ZONE_NAME];
		format(vstring, sizeof(vstring), "Vehicle\tStatus\tLocation\tTickets\n");
		for(new i, iModelID; i < icount; i++) {
			if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0) {
				Get3DZone(PlayerVehicleInfo[playerid][i][pvPosX], PlayerVehicleInfo[playerid][i][pvPosY], PlayerVehicleInfo[playerid][i][pvPosZ], szCarLocation, sizeof(szCarLocation));
				if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
					format(vstring, sizeof(vstring), "%s%s\tImpounded\tDillimore DMV\t$%s\n", vstring, VehicleName[iModelID], number_format(PlayerVehicleInfo[playerid][i][pvTicket]));
				}
				else if(PlayerVehicleInfo[playerid][i][pvDisabled]) {
					format(vstring, sizeof(vstring), "%s%s\tDisabled\t--\t$%s\n", vstring, VehicleName[iModelID], number_format(PlayerVehicleInfo[playerid][i][pvTicket]));
				}
				else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) {
					format(vstring, sizeof(vstring), "%s%s\tStored\t--\t$%s\n", vstring, VehicleName[iModelID], number_format(PlayerVehicleInfo[playerid][i][pvTicket]));
				}
				else format(vstring, sizeof(vstring), "%s%s\tSpawned\t%s\t$%s\n", vstring, VehicleName[iModelID], szCarLocation, number_format(PlayerVehicleInfo[playerid][i][pvTicket]));
			}
			else strcat(vstring, "Empty\t--\t--\t--\t--\n");
		}
		format(vstring, sizeof(vstring), "%s{40FFFF}Additional Vehicle Slot\t{FFD700}(Credits: %s){A9C4E4}\t\t\n", vstring, number_format(ShopItems[23][sItemPrice]));

		ShowPlayerDialogEx(playerid, VEHICLESTORAGE, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle storage", vstring, "(De)spawn", "Cancel");
	}
	else { return SendClientMessageEx(playerid, COLOR_GRAD2, "Your vehicle assets have been frozen by the Judiciary.  Consult your local courthouse to have this cleared"); }
	return 1;
}
/*
CMD:vstorage(playerid, params[])
{
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this at this time.");
	if(PlayerInfo[playerid][pFreezeCar] == 0 || PlayerInfo[playerid][pAdmin] >= 2)
	{
		szMiscArray[0] = 0;
		new icount = GetPlayerVehicleSlots(playerid);
		new szCarLocation[MAX_ZONE_NAME];
		for(new i, iModelID; i < icount; i++)
		{
			if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0) 
			{
				Get3DZone(PlayerVehicleInfo[playerid][i][pvPosX], PlayerVehicleInfo[playerid][i][pvPosY], PlayerVehicleInfo[playerid][i][pvPosZ], szCarLocation, sizeof(szCarLocation));
				if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (impounded) | Location: DMV", szMiscArray, VehicleName[iModelID]);
				}
				else if(PlayerVehicleInfo[playerid][i][pvDisabled]) {
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (disabled) | Location: Unknown", szMiscArray, VehicleName[iModelID]);
				}
				else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) {
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (stored)", szMiscArray, VehicleName[iModelID]);
				}
				else format(szMiscArray, sizeof(szMiscArray), "%s\n%s (spawned) | Location: %s", szMiscArray, VehicleName[iModelID], szCarLocation);
			}
			else strcat(szMiscArray, "\nEmpty");
		}
		format(szMiscArray, sizeof(szMiscArray), "%s\n{40FFFF}Additional Vehicle Slot {FFD700}(Credits: %s){A9C4E4}", szMiscArray, number_format(ShopItems[23][sItemPrice]));
		ShowPlayerDialogEx(playerid, VEHICLESTORAGE, DIALOG_STYLE_LIST, "Vehicle storage", szMiscArray, "(De)spawn", "Cancel");
	}
	else { return SendClientMessageEx(playerid, COLOR_GRAD2, "Your vehicle assets have been frozen by the Judiciary.  Consult your local courthouse to have this cleared"); }
	return 1;
}*/

CMD:trackcar(playerid, params[])
{
    if(GetPVarType(playerid, "RentedVehicle")) {
        ShowPlayerDialogEx(playerid, TRACKCAR2, DIALOG_STYLE_LIST, "Vehicle GPS Tracking", "Rented Vehicle\nOwned Vehicles", "Track", "Cancel");
	}
	else
	{
		szMiscArray[0] = 0;
		new icount = GetPlayerVehicleSlots(playerid);
		new szCarLocation[MAX_ZONE_NAME];
		for(new i, iModelID; i < icount; i++) 
		{
			if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0)
			{
				Get3DZone(PlayerVehicleInfo[playerid][i][pvPosX], PlayerVehicleInfo[playerid][i][pvPosY], PlayerVehicleInfo[playerid][i][pvPosZ], szCarLocation, sizeof(szCarLocation));
				if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (impounded) | Location: DMV", szMiscArray, VehicleName[iModelID]);
				}
				else if(PlayerVehicleInfo[playerid][i][pvDisabled]) {
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (disabled) | Location: Unknown", szMiscArray, VehicleName[iModelID]);
				}
				else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) {
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (stored)", szMiscArray, VehicleName[iModelID]);
				}
				else format(szMiscArray, sizeof(szMiscArray), "%s\n%s | Location: %s", szMiscArray, VehicleName[iModelID], szCarLocation);
			}
		}
		ShowPlayerDialogEx(playerid, TRACKCAR, DIALOG_STYLE_LIST, "Vehicle GPS Tracking", szMiscArray, "Track", "Cancel");
	}
	return 1;
}

CMD:unmodcar(playerid, params[]) {
	for(new d = 0; d < MAX_PLAYERVEHICLES; d++) if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId])) {
		new modList[512], string[16];
		new count = 0;
		for(new f = 0; f < MAX_MODS; f++) if(GetVehicleComponentInSlot(PlayerVehicleInfo[playerid][d][pvId], f) != 0) {
			if(f != 9 && f != 7 && f != 8) {
				format(modList, sizeof(modList), "%s\n%s - %s", modList, partType(f), partName(GetVehicleComponentInSlot(PlayerVehicleInfo[playerid][d][pvId], f)));
			}
			else format(modList, sizeof(modList), "%s\n%s", modList, partType(f));

			format(string, sizeof(string), "partList%d", count);
			SetPVarInt(playerid, string, GetVehicleComponentInSlot(PlayerVehicleInfo[playerid][d][pvId], f));
			count++;
		}
		if (count == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, " This vehicle does not have any modifications.");
			return 1;
		}
		format(modList, sizeof(modList), "%s\nAll", modList);
		format(string, sizeof(string), "partList%d", count);
		SetPVarInt(playerid, string, 999);
		count++;
		SetPVarInt(playerid, "modCount", count);
		return ShowPlayerDialogEx(playerid, UNMODCARMENU, DIALOG_STYLE_LIST, "Remove Modifications", modList, "Select", "Cancel");
	}
	SendClientMessageEx(playerid, COLOR_GREY, " You need to be inside a vehicle that you own.");
 	return 1;
}

CMD:deletecar(playerid, params[])
{
	szMiscArray[0] = 0;
	new icount = GetPlayerVehicleSlots(playerid);
	for(new i, iModelID; i < icount; i++) {
		if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0)
		{
			if(PlayerVehicleInfo[playerid][i][pvImpounded]) format(szMiscArray, sizeof(szMiscArray), "%s\n%s (impounded)", szMiscArray, VehicleName[iModelID]);
			else if(PlayerVehicleInfo[playerid][i][pvDisabled]) format(szMiscArray, sizeof(szMiscArray), "%s\n%s (disabled)", szMiscArray, VehicleName[iModelID]);
			else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) format(szMiscArray, sizeof(szMiscArray), "%s\n%s (stored)", szMiscArray, VehicleName[iModelID]);
			else format(szMiscArray, sizeof(szMiscArray), "%s\n%s", szMiscArray, VehicleName[iModelID]);
		}
		else strcat(szMiscArray, "\nEmpty");
	}
	return ShowPlayerDialogEx(playerid, DIALOG_DELETECAR, DIALOG_STYLE_LIST, "Delete Vehicle", szMiscArray, "Delete", "Cancel");
}

CMD:parktrailer(playerid, params[]) {
	for(new i = 0, Float: fVehiclePos[4], iVehicleID; i != MAX_PLAYERVEHICLES; ++i) switch(GetVehicleModel((iVehicleID = PlayerVehicleInfo[playerid][i][pvId]))) {
		case 435, 450, 584, 591, 606, 607, 608, 610, 611: {
			GetVehiclePos(iVehicleID, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
			if(IsPlayerInRangeOfPoint(playerid, 10.0, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2])) {

				new
					szMessage[64];

				GetVehicleZAngle(iVehicleID, fVehiclePos[3]);
				UpdatePlayerVehicleParkPosition(playerid, i, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2], fVehiclePos[3], 1000.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

				format(szMessage, sizeof szMessage, "* %s has parked their trailer.", GetPlayerNameEx(playerid));
				return ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			}
		}
	}
	return 1;
}

CMD:park(playerid, params[])
{
	new
		iVehicle = GetPlayerVehicleID(playerid),
		iBusiness = GetCarBusiness(iVehicle),
		Float: XYZ[4];

    if(iVehicle == GetPVarInt(playerid, "RentedVehicle"))
	{
	    new Float:x, Float:y, Float:z, Float:health;
		GetVehicleHealth(iVehicle, health);
  		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in the driver seat.");
		if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to park it.");
		if(PlayerInfo[playerid][pLockCar] == GetPlayerVehicleID(playerid)) PlayerInfo[playerid][pLockCar] = INVALID_VEHICLE_ID;
		GetPlayerPos(playerid, x, y, z);

		SetTimerEx("ParkRentedVehicle", 1000, false, "iiifff", playerid, iVehicle, GetVehicleModel(iVehicle), x, y, z);
		SendClientMessageEx (playerid, COLOR_YELLOW, "Do not move to have your vehicle parked!");
		return 1;
	}
	if (iVehicle != 0 && iBusiness != INVALID_BUSINESS_ID)
	{
	 	if (iBusiness != PlayerInfo[playerid][pBusiness]) return SendClientMessageEx(playerid, COLOR_WHITE, "You're not authorized to park this vehicle.");
		new
			iSlot = GetBusinessCarSlot(iVehicle);

		GetVehiclePos(iVehicle, XYZ[0], XYZ[1], XYZ[2]);
		GetVehicleZAngle(iVehicle, XYZ[3]);

		Businesses[iBusiness][bParkPosX][iSlot] = XYZ[0];
		Businesses[iBusiness][bParkPosY][iSlot] = XYZ[1];
		Businesses[iBusiness][bParkPosZ][iSlot] = XYZ[2];
		Businesses[iBusiness][bParkAngle][iSlot] = XYZ[3];

		DestroyVehicle(Businesses[iBusiness][bVehID][iSlot]);
		Businesses[iBusiness][bVehID][iSlot] = CreateVehicle(Businesses[iBusiness][bModel][iSlot], Businesses[iBusiness][bParkPosX][iSlot], Businesses[iBusiness][bParkPosY][iSlot], Businesses[iBusiness][bParkPosZ][iSlot],
		Businesses[iBusiness][bParkAngle][iSlot], 0, 0, 10);

		if(IsValidDynamic3DTextLabel(Businesses[iBusiness][bVehicleLabel][iSlot])) DestroyDynamic3DTextLabel(Businesses[iBusiness][bVehicleLabel][iSlot]), Businesses[iBusiness][bVehicleLabel][iSlot] = Text3D:-1;
		szMiscArray[0] = 0;
		format(szMiscArray, sizeof(szMiscArray), "%s For Sale | Price: $%s", GetVehicleName(Businesses[iBusiness][bVehID][iSlot]), number_format(Businesses[iBusiness][bPrice][iSlot]));
		Businesses[iBusiness][bVehicleLabel][iSlot] = CreateDynamic3DTextLabel(szMiscArray, COLOR_LIGHTBLUE, Businesses[iBusiness][bParkPosX][iSlot]+1.0, Businesses[iBusiness][bParkPosY][iSlot]+1.0, Businesses[iBusiness][bParkPosZ][iSlot]+1.0, 8.0, INVALID_PLAYER_ID, Businesses[iBusiness][bVehID][iSlot]);
		
        SaveDealershipVehicle(iBusiness, iSlot);
		SendClientMessageEx(playerid, COLOR_WHITE, "You've parked this vehicle.");
		return 1;
	}

	if(PlayerInfo[playerid][pVehicleKeysFrom] != INVALID_PLAYER_ID)
	{
		new ownerid = PlayerInfo[playerid][pVehicleKeysFrom];
		if(IsPlayerConnected(ownerid))
		{
			new d = PlayerInfo[playerid][pVehicleKeys];
			if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[ownerid][d][pvId]))
			{
				if(PlayerVehicleInfo[ownerid][d][pvBeingPickLocked] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot park this vehicle at the moment.");
			    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in the driver seat.");
				new Float:x, Float:y, Float:z, Float:health;
				GetVehicleHealth(PlayerVehicleInfo[ownerid][d][pvId], health);
				if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to park it.");
				if(PlayerInfo[playerid][pLockCar] == GetPlayerVehicleID(playerid)) PlayerInfo[playerid][pLockCar] = INVALID_VEHICLE_ID;

                GetPlayerPos(playerid, x, y, z);
                SetTimerEx("ParkVehicle", 1000, false, "iiiifff", playerid, ownerid, PlayerVehicleInfo[ownerid][d][pvId], d, x, y, z);
                SendClientMessageEx (playerid, COLOR_YELLOW, "Do not move to have your vehicle parked!");
				return 1;
			}
		}
	}
	for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	{
		if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
		{
			if(PlayerVehicleInfo[playerid][d][pvBeingPickLocked] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot park this vehicle at the moment.");
			if(WheelClamp{PlayerVehicleInfo[playerid][d][pvId]}) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot park this vehicle at the moment.");
			new Float:x, Float:y, Float:z, Float:health;
			GetVehicleHealth(PlayerVehicleInfo[playerid][d][pvId], health);
            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in the driver seat.");
			if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to park it.");
			if(PlayerInfo[playerid][pLockCar] == GetPlayerVehicleID(playerid)) PlayerInfo[playerid][pLockCar] = INVALID_VEHICLE_ID;
			GetPlayerPos(playerid, x, y, z);

   			SetTimerEx("ParkVehicle", 1000, false, "iiiifff", playerid, INVALID_PLAYER_ID, PlayerVehicleInfo[playerid][d][pvId], d, x, y, z);
      		SendClientMessageEx (playerid, COLOR_YELLOW, "Do not move to have your vehicle parked!");
			return 1;
		}
	}
	SendClientMessageEx(playerid, COLOR_GREY, "You need to be inside a vehicle that you own.");
	return 1;
}

CMD:carkeys(playerid, params[])
{
	szMiscArray[0] = 0;
	new iValidVehicles;
	for(new i=0; i<MAX_PLAYERVEHICLES; i++)
	{
	    if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID) {
	        if(PlayerVehicleInfo[playerid][i][pvAllowedPlayerId] != INVALID_PLAYER_ID) {
				format(szMiscArray, sizeof(szMiscArray), "%s\n%s | Keys: %s", szMiscArray, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400], GetPlayerNameEx(PlayerVehicleInfo[playerid][i][pvAllowedPlayerId])), ++iValidVehicles;
			}
			else {
                format(szMiscArray, sizeof(szMiscArray), "%s\n%s | Keys: No-one", szMiscArray, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);
			}
		}
        else if((PlayerVehicleInfo[playerid][i][pvImpounded] == 1 || PlayerVehicleInfo[playerid][i][pvSpawned] == 0) && PlayerVehicleInfo[playerid][i][pvModelId] != 0) {
            format(szMiscArray, sizeof(szMiscArray), "%s\n%s | Keys: Unavailable", szMiscArray, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);
		}
        else {
			strcat(szMiscArray, "\nEmpty");
		}
	}
	if(iValidVehicles != 0)
	{
		ShowPlayerDialogEx(playerid, REMOVEKEYS, DIALOG_STYLE_LIST, "Please select a vehicle.", szMiscArray, "Remove Keys", "Cancel");
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have any keys given out.");
	}
	return 1;
}

CMD:sb(playerid, params[]) return cmd_seatbelt(playerid, params);

CMD:seatbelt(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid) == 0)
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in a vehicle!");
        return 1;
    }

    if(IsPlayerInAnyVehicle(playerid) == 1 && Seatbelt[playerid] == 0)
	{
        if(IsABike(GetPlayerVehicleID(playerid)))
            return SendClientMessageEx(playerid, COLOR_WHITE, "We have added a helmet feature, buy a helmet from any 24/7 and use /helmet(/hm).");
        else
		{
            format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s reaches for their seatbelt, and buckles it up.", GetPlayerNameEx(playerid));
            SendClientMessageEx(playerid, COLOR_WHITE, "You have put on your seatbelt.");
			Seatbelt[playerid] = 1;
        }

    }
    else if(IsPlayerInAnyVehicle(playerid) == 1 && Seatbelt[playerid] == 1)
	{
        if(IsABike(GetPlayerVehicleID(playerid)))
		{
            return SendClientMessageEx(playerid, COLOR_WHITE, "We have added a helmet feature, buy a helmet from any 24/7 and use /helmet(/hm).");
        }
        else
		{
            format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s reaches for their seatbelt, and unbuckles it.", GetPlayerNameEx(playerid));
            SendClientMessageEx(playerid, COLOR_WHITE, "You have taken off your seatbelt.");
			Seatbelt[playerid] = 0;
        }
    }
	else return 1;
	ProxChatBubble(playerid, szMiscArray);
    // ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    return 1;
}

CMD:cb(playerid, params[]) return cmd_checkbelt(playerid, params);

CMD:checkbelt(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /checkbelt [player]");

    if(GetPlayerState(giveplayerid) == PLAYER_STATE_ONFOOT)
	{
        SendClientMessageEx(playerid,COLOR_GREY,"That person is not in any vehicle!");
        return 1;
    }
    if (ProxDetectorS(9.0, playerid, giveplayerid))
	{
		new string[128];
        new stext[4];
        if(Seatbelt[giveplayerid] == 0) { stext = "off"; }
        else { stext = "on"; }
        if(IsABike(GetPlayerVehicleID(playerid)))
		{
            SendClientMessageEx(playerid, COLOR_WHITE, "We have added a helmet feature, use /checkhelmet(/chm) instead.");
        }
        else
		{
            format(string, sizeof(string), "%s's seat belt is currently %s." , GetPlayerNameEx(giveplayerid) , stext);
            SendClientMessageEx(playerid,COLOR_WHITE,string);

            format(string, sizeof(string), "* %s peers through the window at %s, checking to see if they are wearing a seatbelt.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
            // ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ProxChatBubble(playerid, string);
        }
    }
    else { SendClientMessageEx(playerid, COLOR_GREY, "You are not around that player!"); }
    return 1;
}

CMD:givekeys(playerid, params[])
{
	new
		giveplayerid;

    if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givekeys [player]");
    if(IsPlayerConnected(giveplayerid))
	{
        if(playerid == giveplayerid) return 1;
        if (ProxDetectorS(4.0, playerid, giveplayerid))
		{
			szMiscArray[0] = 0;
			new iValidVehicles;

			for(new i; i < MAX_PLAYERVEHICLES; i++) if(PlayerVehicleInfo[playerid][i][pvModelId] >= 400)
			{
				if(PlayerVehicleInfo[playerid][i][pvImpounded] == 1)
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (impounded)", szMiscArray, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);

				else if(PlayerVehicleInfo[playerid][i][pvDisabled] == 1)
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (disabled)", szMiscArray, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);

				else if(PlayerVehicleInfo[playerid][i][pvSpawned] == 0)
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (stored)", szMiscArray, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);

				else
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s", szMiscArray, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]), ++iValidVehicles;
			}
			else strcat(szMiscArray, "\nEmpty");
            if(iValidVehicles != 0)
			{
                GiveKeysTo[playerid] = giveplayerid;
                ShowPlayerDialogEx(playerid, GIVEKEYS, DIALOG_STYLE_LIST, "Please select a vehicle.", szMiscArray, "Give Keys", "Cancel");
            }
            else
			{
                SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have any vehicles for which you can give out keys.");
            }
        }
        else
		{
            SendClientMessageEx(playerid, COLOR_GRAD1, "You're not close enough to that player.");
        }
    }
    return 1;
}

CMD:sellmycar(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
    if(PlayerInfo[playerid][pFreezeCar] == 1)
    {
   		return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Your car assets are frozen, you cannot sell a car!");
	}
    for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	{
        if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
 		{
			if(PlayerInfo[playerid][pBackpack] > 0 && PlayerInfo[playerid][pBStoredV] == PlayerVehicleInfo[playerid][d][pvSlotId] && !GetPVarInt(playerid, "confirmvehsell")) 
			{
				SetPVarInt(playerid, "confirmvehsell", 1);
				return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You have a backpack stored in this car, withdraw it first or you will loose it, please confirm!");
			}
            new Float:health;
            GetVehicleHealth(PlayerVehicleInfo[playerid][d][pvId], health);
            if(PlayerInfo[playerid][pLevel] == 1)
			{
                SendClientMessageEx(playerid, COLOR_GREY, "You have to be level 2 or higher to be able to sell vehicles.");
                return 1;
            }
            if(health < 500) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to sell it.");

            new string[144], giveplayerid, price, alarmstring[9], lockstring[11], worklockstring[10];
			if(sscanf(params, "ud", giveplayerid, price)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellmycar [player] [price]");

            if(price < 1 || price > 1000000000) return SendClientMessageEx(playerid, COLOR_GREY, "Price must be higher than 0 and less than 1,000,000,000.");
            if(PlayerInfo[giveplayerid][pLevel] == 1)
			{
                SendClientMessageEx(playerid, COLOR_GREY, "The person has to be Level 2 or higher to be able to sell vehicles to them.");
                return 1;
            }
            if(playerid == giveplayerid)
			{
                SendClientMessageEx(playerid, COLOR_GREY, "You can not use this command on yourself.");
                return 1;
            }
            /*if(IsWeaponizedVehicle(PlayerVehicleInfo[playerid][d][pvModelId]))
            {
                SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to sell this restricted vehicle.");
                return 1;
            }*/ // Uncomment to disallow the sale of weaponized vehicles. 
			if(gettime()-GetPVarInt(playerid, "LastTransaction") < 60)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can only sell a car once every 60 seconds, please wait!");
				return 1;
			}
			if(PlayerVehicleInfo[playerid][d][pvTicket] > 0)
			{
			    SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle currently has unpaid tickets, you need to pay them before selling.");
			    return 1;
			}
            if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Player is currently not connected to the server.");
            if (ProxDetectorS(8.0, playerid, giveplayerid))
		 	{
		 	    if(PlayerInfo[giveplayerid][pFreezeCar] == 1)
	 		    {
	            	SendClientMessageEx(giveplayerid, COLOR_WHITE, "ERROR: Your car assets are frozen, you cannot buy a car!");
	            	SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Their car assets are frozen, they cannot buy a car!");
	            	return 1;
				}
				if(IsWeaponizedVehicle(PlayerVehicleInfo[playerid][d][pvModelId]))
				{
					new dialogstring[255], fine = (price / 100) * 15;
					format(dialogstring, sizeof(dialogstring), "Selling weaponized vehicles results in a 15 percent fine for each vehicle sold.\n\n{FF0000}You will only recieve %s(fine: %s) for this transaction, proceed?", number_format(price-fine), number_format(fine));
					ShowPlayerDialogEx(playerid, DIALOG_WEPVEHSALE, DIALOG_STYLE_MSGBOX, "{FF0000}Notice", dialogstring, "Proceed", "Exit");

					SetPVarInt(playerid, "WepVehSalePlayer", giveplayerid);
					SetPVarInt(playerid, "WepVehSaleVehicle", d);
					SetPVarInt(playerid, "WepVehSalePrice", price);
					SetPVarInt(playerid, "WepVehSaleFine", fine);
					return 1;
				}
				SetPVarInt(playerid, "LastTransaction", gettime());
                VehicleOffer[giveplayerid] = playerid;
                VehicleId[giveplayerid] = d;
                VehiclePrice[giveplayerid] = price;
				switch(PlayerVehicleInfo[playerid][d][pvAlarm]) {
					case 1: alarmstring = "Standard";
					case 2: alarmstring = "Deluxe";
					default: alarmstring = "no";
				}
				switch(PlayerVehicleInfo[playerid][d][pvLock]) {
					case 2: lockstring = "Electronic";
					case 3: lockstring = "Industrial";
					default: lockstring = "no";
				}
				if(PlayerVehicleInfo[playerid][d][pvLocksLeft] < 1) worklockstring = "(Broken)";
				format(string, sizeof(string), "* You offered %s to buy this %s with %s Alarm & %s%s Lock for $%s.", GetPlayerNameEx(giveplayerid), GetVehicleName(PlayerVehicleInfo[playerid][d][pvId]), alarmstring, worklockstring, lockstring, number_format(price));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* %s has offered you their %s (VID: %d) with %s Alarm & %s%s Lock for $%s, (type /accept car) to buy.", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][d][pvId]), PlayerVehicleInfo[playerid][d][pvId], alarmstring, worklockstring, lockstring, number_format(price));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				DeletePVar(playerid, "confirmvehsell");
                return 1;
            }
            else
			{
                SendClientMessageEx(playerid, COLOR_GREY, "That person is not near you.");
                return 1;
            }
        }
    }
    SendClientMessageEx(playerid, COLOR_GREY, " You need to be inside a vehicle that you own.");
    return 1;
}

CMD:pvlock(playerid, params[])
{
    new Float: x, Float: y, Float: z;
    if(PlayerInfo[playerid][pVehicleKeysFrom] != INVALID_PLAYER_ID)
	{
        new ownerid = PlayerInfo[playerid][pVehicleKeysFrom];
        if(IsPlayerConnected(ownerid))
		{
            new d = PlayerInfo[playerid][pVehicleKeys];
            if(PlayerVehicleInfo[ownerid][d][pvId] != INVALID_PLAYER_VEHICLE_ID) GetVehiclePos(PlayerVehicleInfo[ownerid][d][pvId], x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
			{
                if(PlayerVehicleInfo[ownerid][d][pvLock] > 0)
				{
					if(PlayerVehicleInfo[ownerid][d][pvLocksLeft] <= 0) {
						SendClientMessageEx(playerid, COLOR_GREY, "The lock has been damaged as result of a lock pick!");
						return 1;
					}
					if(PlayerVehicleInfo[ownerid][d][pvBeingPickLocked]) {
						SendClientMessageEx(playerid, COLOR_GREY, "This vehicle cannot be locked/unlocked right now.");
						return 1;
					}
                    if(PlayerVehicleInfo[ownerid][d][pvLocked] == 0)
					{
                        GameTextForPlayer(playerid,"~r~Vehicle Locked!",5000,6);
                        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                        PlayerVehicleInfo[ownerid][d][pvLocked] = 1;
                        LockPlayerVehicle(ownerid, PlayerVehicleInfo[ownerid][d][pvId], PlayerVehicleInfo[ownerid][d][pvLock]);
                        return 1;
                    }
                    else
					{
                        GameTextForPlayer(playerid,"~g~Vehicle Unlocked!",5000,6);
                        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                        PlayerVehicleInfo[ownerid][d][pvLocked] = 0;
                        UnLockPlayerVehicle(ownerid, PlayerVehicleInfo[ownerid][d][pvId], PlayerVehicleInfo[ownerid][d][pvLock]);
                        return 1;
                    }
                }
                else
				{
                    SendClientMessageEx(playerid, COLOR_GREY, " You don't have a lock system installed on this vehicle.");
					return 1;
                }
            }
        }
    }
    for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
    {
        if(PlayerVehicleInfo[playerid][d][pvId] != INVALID_PLAYER_VEHICLE_ID) GetVehiclePos(PlayerVehicleInfo[playerid][d][pvId], x, y, z);
        if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
		{
			if(PlayerVehicleInfo[playerid][d][pvLocksLeft] <= 0) {
				SendClientMessageEx(playerid, COLOR_GREY, "The lock has been damaged as result of a lock pick, please buy a new one!");
				return 1;
			}
			if(PlayerVehicleInfo[playerid][d][pvBeingPickLocked]) {
				SendClientMessageEx(playerid, COLOR_GREY, "This vehicle cannot be locked/unlocked right now.");
				return 1;
			}
            if(PlayerVehicleInfo[playerid][d][pvLock] > 0 && PlayerVehicleInfo[playerid][d][pvLocked] == 0)
			{
                GameTextForPlayer(playerid,"~r~Vehicle Locked!",5000,6);
                PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                PlayerVehicleInfo[playerid][d][pvLocked] = 1;
                LockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId], PlayerVehicleInfo[playerid][d][pvLock]);
                return 1;
            }
            else if(PlayerVehicleInfo[playerid][d][pvLock] > 0 && PlayerVehicleInfo[playerid][d][pvLocked] == 1)
			{
                GameTextForPlayer(playerid,"~g~Vehicle Unlocked!",5000,6);
                PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                PlayerVehicleInfo[playerid][d][pvLocked] = 0;
                UnLockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId], PlayerVehicleInfo[playerid][d][pvLock]);
                return 1;

            }
            SendClientMessageEx(playerid, COLOR_GREY, " You don't have a lock system installed on this vehicle.");
            return 1;
        }
    }
    SendClientMessageEx(playerid, COLOR_GREY, " You are not near any vehicle that you own.");
    return 1;
}

CMD:vehid(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
    {
		new string[128];
    	new idcar = GetPlayerVehicleID(playerid);
		format(string, sizeof(string), "* Vehicle Name: %s | Vehicle Model:%d | Vehicle ID: %d.",GetVehicleName(idcar), GetVehicleModel(idcar), idcar);
		SendClientMessageEx(playerid, COLOR_GREY, string);
	}
	return 1;
}

CMD:rc(playerid, params[])
{
	#if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	new ccar = GetClosestCar(playerid);
	if(IsARC(ccar) && IsPlayerInRangeOfVehicle(playerid, ccar, 5.0))
	{
		if(IsPlayerInVehicle(playerid,ccar))
		{
			new Float:vehPos[3];
			GetVehiclePos(ccar,vehPos[0], vehPos[1], vehPos[2]);
			SetPlayerPos(playerid,vehPos[0], vehPos[1]+0.5, vehPos[2]+0.5);
		}
		else if(!IsPlayerInAnyVehicle(playerid))
		{
			foreach(new i: Player)
			{
				new v = GetPlayerVehicle(i, ccar);
				if(v != -1 && PlayerVehicleInfo[i][v][pvLocked] == 0)
				{
					new Float:playerPos[3];
					GetPlayerPos(playerid,playerPos[0],playerPos[1],playerPos[2]);
					SetPlayerPos(playerid,playerPos[0],playerPos[1],playerPos[2]-500);
					IsPlayerEntering{playerid} = true;
					PutPlayerInVehicle(playerid, ccar, 0);
				}
			}	
		}
	}
	return 1;
}

CMD:lastcar(playerid, params[]) return cmd_oldcar(playerid, params);

CMD:oldcar(playerid, params[])
{
	new string[128];
	if(!gLastCar[playerid]) return SendClientMessageEx(playerid, COLOR_GREY, "You have not driven a vehicle yet.");
	format(string, sizeof(string), "Your last driven vehicle was a %s (Model: %d -- ID: %d)", GetVehicleName(gLastCar[playerid]), GetVehicleModel(gLastCar[playerid]), gLastCar[playerid]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	return 1;
}

CMD:userimkit(playerid, params[])
{
	if(PlayerInfo[playerid][pRimMod] == 0)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any rim modification kits.");

    if(!IsPlayerInAnyVehicle(playerid))
 		return SendClientMessageEx(playerid, COLOR_GREY, "You aren't in a vehicle.");

 	if(PlayerInfo[playerid][pJob] != 7 && PlayerInfo[playerid][pJob2] != 7 && PlayerInfo[playerid][pJob3] != 7) 
 		return SendClientMessageEx(playerid, COLOR_GREY, "You must be a mechanic to use this command.");
	
	new iVeh = GetPlayerVehicleID(playerid);
	new iModel  = GetVehicleModel(iVeh);

	if(IsRestrictedVehicle(iModel)) return SendClientMessageEx(playerid, COLOR_GREY, "This vehicle cannot have rims applied to it");

    if(InvalidModCheck(iModel, 1025))
	{
 		for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
		{
			if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
			{
				ShowPlayerDialogEx(playerid, DIALOG_RIMMOD, DIALOG_STYLE_LIST, "Rim Modification Kit", "Offroad\nShadow\nMega\nRimshine\nWires\nClassic\nTwist\nCutter\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic\nAhab\nVirtual\nAccess", "Select", "Exit");
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You need to be inside a vehicle that you own.");
		return 1;
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "This vehicle can't be modded.");
	}

	return 1;
}

CMD:eject(playerid, params[])
{
	new State;
	if(IsPlayerInAnyVehicle(playerid))
	{
		State=GetPlayerState(playerid);
		if(State!=PLAYER_STATE_DRIVER)
		{
			SendClientMessageEx(playerid,COLOR_GREY,"   You can only eject people as the driver!");
			return 1;
		}

		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /eject [player]");

		new test;
		test = GetPlayerVehicleID(playerid);
		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot Eject yourself!"); return 1; }
				if(IsPlayerInVehicle(giveplayerid,test))
				{
					if(GetPVarInt(giveplayerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't eject patients!");
					format(string, sizeof(string), "* You have thrown %s out of the car.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* You have been thrown out the car by %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					RemovePlayerFromVehicle(giveplayerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(giveplayerid, slx, sly, slz);
					SetPlayerPos(giveplayerid, slx, sly+3, slz+1);
					format(string, sizeof(string), "* %s has ejected %s from the vehicle.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "   That person is not in your Car!");
					return 1;
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, " Invalid ID/Name!");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You need to be in a Vehicle to use this!");
	}
	return 1;
}

RentVehicleTimer(i)
{
	szMiscArray[0] = 0;
	if(GetPVarType(i, "RentedVehicle"))
	{
		if(GetPVarInt(i, "RentedHours") > 0)
		{
			SetPVarInt(i, "RentedHours", GetPVarInt(i, "RentedHours")-1);
			if(GetPVarInt(i, "RentedHours") == 0)
			{
				SendClientMessageEx(i, COLOR_CYAN, "Your rented vehicle has expired.");
				DestroyVehicle(GetPVarInt(i, "RentedVehicle"));

				mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `rentedcars` WHERE `sqlid`= '%d'", GetPlayerSQLId(i));
				mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);

				DeletePVar(i, "RentedHours");
				DeletePVar(i, "RentedVehicle");
			}
			else if(GetPVarInt(i, "RentedHours") == 120 || GetPVarInt(i, "RentedHours") == 60)
			{
				format(szMiscArray, sizeof(szMiscArray), "%d minutes(s) remaining on your rented vehicle.", GetPVarInt(i, "RentedHours"));
				SendClientMessageEx(i, COLOR_CYAN, szMiscArray);
			}
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `rentedcars` SET `hours` = '%d' WHERE `sqlid` = '%d'",GetPVarInt(i, "RentedHours"), GetPlayerSQLId(i));
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
}