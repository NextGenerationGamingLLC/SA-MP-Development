//-------------------------------------------------------
//
// GRAND LARCENY Property creation and management script
//
// by damospiderman 2008
//
//-------------------------------------------------------

#include <a_samp>
#include "../include/gl_common.inc"

#define FILTERSCRIPT
//#define USE_SQLITE

#define PROP_VW    		(10000)
#define MAX_INTERIORS	(146)
#define MAX_PROPERTIES  (1000)

#define PROPERTY_FOLDER	"properties" // Location of properties file
#define PROPERTY_UNIQID_FILE    "properties/uniqId.txt" // Location of Uniq Interior Info
#define DB_PROPERTIES   "properties/dbProperties.db" // Location of the properties Database

#define MAX_TYPES       (5)
#define TYPE_EMPTY      (0)
#define TYPE_HOUSE 		(1)
#define TYPE_BUSINESS	(2)
#define TYPE_BANK   	(3)
#define TYPE_COP        (4)

enum // Property Type Enum
	E_P_TYPES {
		tIcon,
		tName[32]
	}

enum // Uniq Interiors Enum
	E_INTERIORS {
		inIntID,
		Float:inExitX,
		Float:inExitY,
		Float:inExitZ,
		Float:inExitA,
		inName[64]
	};

enum // Properties Enum
	E_PROPERTIES {
		eInterior,
		eType,
		Float:eEntX,
		Float:eEntY,
		Float:eEntZ,
		Float:eEntA,
		eUniqIntId,
		eOwner,
		ePrice,
		ePname[64]
	};

//  [ uniq property id ]
new	unid;

//	[ Array of all the property interior info ]
new interiorInfo[MAX_INTERIORS][E_INTERIORS];

//	[ Pickup array with property id assigned via array slot ( pickupid ) ]
new propPickups[MAX_PROPERTIES] = {-1};

//	[ Handles for 3D text displayed at property entrances ]
new Text3D:propTextInfo[MAX_PROPERTIES];

// 	[ Mass array of all the properties and info about them ]
new properties[MAX_PROPERTIES][E_PROPERTIES];

//	[ The last pickup the player went through so they can do /enter command ]
new lastPickup[MAX_PLAYERS] = {-1};

//	[ Current property Unique Interior the player is in.. defaults to -1 when not in any property ]
new currentInt[MAX_PLAYERS] = {-1};

//	[ Player Position array to store the last place the player was before /view command so they can be teleported back ]
new Float:plPos[MAX_PLAYERS][3];

//	[ Players actual interior id used for /view /return command ]
new plInt[MAX_PLAYERS];

//  [ Array of property type iconid's and strings for property type ]
new propIcons[MAX_TYPES][E_P_TYPES] =	{
											{ 0, "" }, 					// TYPE_EMPTY ( not used )
											{ 1273, "House" }, 			// TYPE_HOUSE green house icon
											{ 1272, "Business" }, 		// TYPE_BUSINESS blue house icon
											{ 1274, "Bank" }, 			// TYPE_BANK dollar sign icon
											{ 1247, "Police Station" }	// TYPE_COP Bribe Star 1247
										};
										
new	propFile[MAX_TYPES][64] =   {
									{ "blank" },
		                            { "properties/houses.txt" },
		                            { "properties/businesses.txt" },
		                            { "properties/banks.txt" },
		                            { "properties/police.txt" }
							 	};
							 	
//  Keep track of what properties we've sent an /enter notification for
new gLastPropertyEnterNotification[MAX_PLAYERS];


/********************************
*   Interior Info Functions     *
********************************/
stock Float:GetInteriorExit( id, &Float:x, &Float:y, &Float:z ){
	if( id > MAX_INTERIORS ) return 0.0;
	else {
	    x = interiorInfo[id][inExitX];
	    y = interiorInfo[id][inExitY];
	    z = interiorInfo[id][inExitZ];
		return interiorInfo[id][inExitA];
	}
}

// Gets interior exit info from uniq Interior Id. Returns InteriorId or -1 if interior doesn't exist
stock GetInteriorExitInfo( uniqIntId, &Float:exitX, &Float:exitY, &Float:exitZ, &Float:exitA ){
	if( uniqIntId < MAX_INTERIORS ){
	    exitX = interiorInfo[uniqIntId][inExitX];
	    exitY = interiorInfo[uniqIntId][inExitY];
	    exitZ = interiorInfo[uniqIntId][inExitZ];
	    exitA = interiorInfo[uniqIntId][inExitA];
		return interiorInfo[uniqIntId][inIntID];
	}
	return -1;
}


stock GetInteriorIntID( id ){ // Gets the interior id of a uniq Interior Id :S
	if( id > MAX_INTERIORS ) return -1;
	else return interiorInfo[id][inIntID];
}

stock GetInteriorName( id )
{
	new tmp[64];
	if( id > MAX_PROPERTIES ) return tmp;

	else {
  		format( tmp, 64, "%s", interiorInfo[id][inName] );
		return tmp;
	}
}

/********************************************************
********************************************************/


/********************************
*  	 Property Functions  		*
********************************/

stock Float:GetPropertyEntrance( id, &Float:x, &Float:y, &Float:z ){
	if( id > MAX_PROPERTIES ) return 0.0;
	x = properties[id][eEntX];
	y = properties[id][eEntY];
	z = properties[id][eEntZ];
	return properties[id][eEntA];
}

stock Float:GetPropertyExit( id, &Float:x, &Float:y, &Float:z ){
	if( id > MAX_PROPERTIES ) return 0.0;
	return GetInteriorExit( properties[id][eUniqIntId], x, y, z );
}

stock GetPropertyInteriorFileId( id ){
	if( id > MAX_PROPERTIES ) return 0;
	else return properties[id][eUniqIntId];
}

stock GetPropertyInteriorId( id ){
	if( id > MAX_PROPERTIES ) return 0;
	else return GetInteriorIntID( properties[id][eUniqIntId] );
}

stock GetPropertyType( id ){
	if( id > MAX_PROPERTIES ) return 0;
	else return properties[id][eType];
}

stock GetPropertyOwner( id ){
	if( id > MAX_PROPERTIES ) return -1;
	else return properties[id][eOwner];
}

stock GetPropertyPrice( id ){
	if( id > MAX_PROPERTIES ) return -1;
	else return properties[id][ePrice];
}

stock GetPropertyName( id ){
	new tmp[64];
	if( id > MAX_PROPERTIES ) return tmp;
	else {
  		format( tmp, 64, "%s", properties[id][ePname] );
		return tmp;
	}
}

/********************************************************
********************************************************/

/********************************
*   	Database Functions	    *
********************************/

stock Float:dbGetPropertyEntrance( database[], uniqId, &Float:x, &Float:y, &Float:z ){
	new
	    DB:prop,
	    DBResult:query_result,
	    query[128],
		num;

	prop = db_open( database );
	format( query, 128,"SELECT entX, entY, enZ, entA FROM properties WHERE id = %d LIMIT 1", uniqId );

	query_result = db_query( prop, query );
	num = db_num_rows(query_result);
	if(!num) return -1.0;

	else {
		db_get_field_assoc( query_result, "entX", query, 128 );
		x = floatstr( query );
		db_get_field_assoc( query_result, "entY", query, 128 );
		y = floatstr( query );
		db_get_field_assoc( query_result, "entZ", query, 128 );
		z = floatstr( query );
		db_get_field_assoc( query_result, "entA", query, 128 );
		return floatstr( query );
	}
}

stock dbSetPropertyOwner( database[], uniqId, ownerId ){
}

stock dbSetPropertyPrice( database[], uniqId, price ){
}

stock dbDeleteProperty( database[], uniqId ){
}

stock dbCreateProperty( database[], uniqId, Float:entX, Float:entY, Float:entZ, Float:entA ){ // remember to add rest of params
}

stock dbLoadProperties( database[] )
{
	new
		    DB:prop,
		    DBResult:query_result,
		    query[128],
			num,
			i;

	prop = db_open( database );
	format( query, 128,"SELECT * FROM properties", uniqId );

	query_result = db_query( prop, query );
	num = db_num_rows(query_result);
	if(!num) return 0;
	else {
		while( i < num ){
		    db_get_field_assoc( query_result, "entX", query, 128 );
			x = floatstr( query );
			db_get_field_assoc( query_result, "entX", query, 128 );
			x = floatstr( query );
			db_get_field_assoc( query_result, "entY", query, 128 );
			y = floatstr( query );
			db_get_field_assoc( query_result, "entZ", query, 128 );
			z = floatstr( query );
			db_get_field_assoc( query_result, "entA", query, 128 );
			i++;
		}
	}

}
/********************************************************
********************************************************/

/*********************************
*   Property System Functions    *
*********************************/

ReadInteriorInfo( fileName[] )
{
	new
	    File:file_ptr,
	    buf[256],
	    tmp[64],
	    idx,
		uniqId;


	file_ptr = fopen( fileName, io_read );
	if( file_ptr ){
		while( fread( file_ptr, buf, 256 ) > 0){
		    idx = 0;

     		idx = token_by_delim( buf, tmp, ' ', idx );
			if(idx == (-1)) continue;
			uniqId = strval( tmp );

			if( uniqId >= MAX_INTERIORS ) return 0;

			idx = token_by_delim( buf, tmp, ' ', idx+1 );
		    if(idx == (-1)) continue;
		 	interiorInfo[uniqId][inIntID] = strval( tmp );

			idx = token_by_delim( buf, tmp, ' ', idx+1 );
		    if(idx == (-1)) continue;
			interiorInfo[uniqId][inExitX] = floatstr( tmp );

			idx = token_by_delim( buf, tmp, ' ', idx+1 );
		    if(idx == (-1)) continue;
			interiorInfo[uniqId][inExitY] = floatstr( tmp );

			idx = token_by_delim( buf, tmp, ' ', idx+1);
		    if(idx == (-1)) continue;
			interiorInfo[uniqId][inExitZ] = floatstr( tmp );

			idx = token_by_delim( buf, tmp, ' ', idx+1 );
		    if(idx == (-1)) continue;
			interiorInfo[uniqId][inExitA] = floatstr( tmp );

			idx = token_by_delim( buf, interiorInfo[uniqId][inName], ';', idx+1 );
		    if(idx == (-1)) continue;

			/*
			printf( "ReadInteriorInfo(%d, %d, %f, %f, %f, %f ( %s ))",
					uniqId,
					interiorInfo[uniqId][inIntID],
					interiorInfo[uniqId][inExitX],
					interiorInfo[uniqId][inExitY],
					interiorInfo[uniqId][inExitZ],
					interiorInfo[uniqId][inExitA],
					interiorInfo[uniqId][inName] );*/

		}
		//printf( "Interiors File read successfully" );
		fclose( file_ptr );
		return 1;
	}
	printf( "Could Not Read Interiors file ( %s )", fileName );
	return 0;
}

ReadPropertyFile( fileName[] )
{
	new  File:file_ptr,
	    tmp[128],
		buf[256],
		idx,
		Float:enX,
		Float:enY,
		Float:enZ,
		Float:enA,
		uniqIntId,
		p_type,
		pIcon;

	printf("Reading File: %s",fileName);

	file_ptr = fopen( fileName, io_read );

	if(!file_ptr )return 0;

 	while( fread( file_ptr, buf, 256 ) > 0){
 	    idx = 0;

 	    idx = token_by_delim( buf, tmp, ',', idx );
		if(idx == (-1)) continue;
		pIcon = strval( tmp );

 	    idx = token_by_delim( buf, tmp, ',', idx+1 );
		if(idx == (-1)) continue;
		enX = floatstr( tmp );

  		idx = token_by_delim( buf, tmp, ',', idx+1 );
		if(idx == (-1)) continue;
		enY = floatstr( tmp );

		idx = token_by_delim( buf, tmp, ',', idx+1 );
		if(idx == (-1)) continue;
		enZ = floatstr( tmp );

 		idx = token_by_delim( buf, tmp, ',', idx+1 );
		if(idx == (-1)) continue;
		enA = floatstr( tmp );

		idx = token_by_delim( buf, tmp, ',', idx+1 );
		if(idx == (-1)) continue;
		uniqIntId = strval( tmp );

		idx = token_by_delim( buf, tmp, ';', idx+1 );
		if(idx == (-1)) continue;
		p_type = strval( tmp );

		CreateProperty( uniqIntId, pIcon, enX, enY, enZ, enA, p_type  );
	}
	fclose( file_ptr );
	return 1;
}

PutPlayerInProperty( playerid, propId, propVW = 0 )
{
	new Float:x, Float:y, Float:z, Float:a;
	new intFileId;
	
    a = GetPropertyExit( propId, x, y, z );
	SetPlayerPos( playerid, x, y, z );
	SetPlayerFacingAngle( playerid, a );
	SetPlayerInterior( playerid, GetPropertyInteriorId( propId ));
	SetPlayerVirtualWorld( playerid, (propVW==0)? propId+PROP_VW:propVW );
	intFileId = GetPropertyInteriorFileId(propId);
	currentInt[playerid] = propId;
	
	//new dbgstring[128];
	//format(dbgstring,sizeof(dbgstring),"PutPlayerInProperty(%d): FileInt=%d",propId,intFileId);
	//SendClientMessage(playerid,0xFFFFFFFF,dbgstring);
	
	// the following will make the client shop scripts run if we tell it
	// the name of the shop.
	if(intFileId == 22) {
	    SetPlayerShopName(playerid,"FDPIZA");
	}
	else if(intFileId == 47) {
		SetPlayerShopName(playerid,"FDBURG");
	}
	else if(intFileId == 130) {
	    SetPlayerShopName(playerid,"FDCHICK");
	}
	else if(intFileId == 32) {
	    SetPlayerShopName(playerid,"AMMUN1");
	}
	else if(intFileId == 96) {
	    SetPlayerShopName(playerid,"AMMUN2");
	}
	else if(intFileId == 122) {
	    SetPlayerShopName(playerid,"AMMUN3");
	}
	else if(intFileId == 123) {
	    SetPlayerShopName(playerid,"AMMUN5");
	}
	
}

// Adds new property to property file
AddProperty( uniqIntId, Float:entX, Float:entY, Float:entZ, Float:entA, p_type, comment[]="" )
{
	new
	    Float:exitX,
	    Float:exitY,
	    Float:exitZ,
	    Float:exitA,
		interiorId,
		File:file_ptr,
		tmp[128];

	interiorId = GetInteriorExitInfo( uniqIntId, exitX, exitY, exitZ, exitA );

	if( interiorId != -1 ){
	    file_ptr = fopen( propFile[p_type], io_append );
	    if(file_ptr){
			format( tmp, 128, "%d, %f, %f, %f, %f, %d, %d ; //%s\r\n", propIcons[p_type][tIcon],entX, entY, entZ, entA, uniqIntId, p_type, comment );

			fwrite( file_ptr, tmp );
			fclose( file_ptr );
			printf( "PropDB - %s", tmp );
			return CreateProperty( uniqIntId, propIcons[p_type][tIcon], entX, entY, entZ, entA,  p_type );
		}
	}
	return -1;
}

CreateProperty( uniqIntId, iconId,  Float:entX, Float:entY, Float:entZ, Float:entA, p_type, name[64]="", owner=-1, price=0 )
{
	if( (unid+1) < MAX_PROPERTIES ){
		new Id = CreatePickup( iconId ,23, entX, entY, entZ, 0 );
		//printf( "CreateProperty(%d, %d, %f, %f, %f, %f, %d)", uniqIntId, iconId, entX, entY, entZ, entA, p_type );
		propPickups[Id] = unid;
		properties[unid][eEntX] 	= entX;
		properties[unid][eEntY] 	= entY;
		properties[unid][eEntZ] 	= entZ;
		properties[unid][eEntA] 	= entA;
		properties[unid][eUniqIntId] = uniqIntId;
		properties[unid][eOwner] 	= owner;
		properties[unid][ePrice] 	= price;
		properties[unid][eType] 	= p_type;
		format( properties[unid][ePname], 64, "%s", name );
		
		new text_info[256];
		
		propTextInfo[unid] = Text3D:INVALID_3DTEXT_ID;
		
		if(p_type == TYPE_HOUSE) {
		    format(text_info,256,"[House]");
		    propTextInfo[unid] = Create3DTextLabel(text_info,0x88EE88FF,entX,entY,entZ+0.75,20.0,0,1);
		}
		else if(p_type == TYPE_BUSINESS) {
		    format(text_info,256,"[Business]");
		    propTextInfo[unid] = Create3DTextLabel(text_info,0xAAAAFFFF,entX,entY,entZ+0.75,20.0,0,1);
		}
		else if(p_type == TYPE_BANK) {
		    format(text_info,256,"[Bank]");
		    propTextInfo[unid] = Create3DTextLabel(text_info,0xEEEE88FF,entX,entY,entZ+0.75,20.0,0,1);
		}
		else if(p_type == TYPE_COP) {
		    format(text_info,256,"[Police Station]");
		    propTextInfo[unid] = Create3DTextLabel(text_info,0xEEEE88FF,entX,entY,entZ+0.75,20.0,0,1);
		}

		return unid++;
	}
	else print( "Property Limit Reached" );
	return -1;
}

PropertyCommand( playerid, cmd[],cmdtext[],idx, p_type )
{
	new
	        Float:x,
	        Float:y,
	        Float:z,
	        Float:a,
	        tmp[256],
	        string[128],
			uniqId,
			id;

	if( GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid)!= 0 ){
	    SendClientMessage(playerid, 0x550000FF, "You can only create properties in Interior 0 and VW 0" );
	    return 1;
	}

	GetPlayerPos( playerid, x, y, z );
	GetPlayerFacingAngle( playerid, a );

	tmp = strtok( cmdtext, idx );
	if(!strlen(tmp)){
	    format( string, 128, "Usage: %s [uniqInteriorId] [optional-comment]", cmd );
	    SendClientMessage( playerid, 0xFF00CC, string );
	    return 1;
	}
	if(!isNumeric(tmp)){
	    SendClientMessage(playerid, 0x550000, "Uniq Interior Id must be a number" );
	    return 1;
	}
	uniqId = strval( tmp );

	if( uniqId > MAX_INTERIORS || uniqId < 0 ){
		SendClientMessage( playerid, 0xFFFFCC, "Invalid Uniq Interior Id" );
		return 1;
	}

    idx = token_by_delim( cmdtext, tmp, '\0', idx );
 	if(idx){
 	    id = AddProperty( uniqId, x, y, z, a, p_type, tmp );
	}

	else {
		id = AddProperty( uniqId, x, y, z, a, p_type );
	}

	if( id != -1 ){
		format( tmp, 256, "Property Type ( %d ) Added Successfully: UniqId: %d Interior: %d IntName: %s",p_type, id, interiorInfo[uniqId][inIntID], interiorInfo[uniqId][inName] );
	    SendClientMessage( playerid, 0xCC7700, tmp );
	}else{
	    SendClientMessage( playerid, 0x00FF55, "Error: Something went wrong/Property Limit Reached" );
	}
	return 1;
}

LoadProperties()
{
	if( properties[0][eType] != TYPE_EMPTY ){
	    UnloadProperties();
	}
	unid = 0;
   	for( new i = 0; i < MAX_PROPERTIES; i++ ){
   	    properties[i][eType] = TYPE_EMPTY;
	}

	ReadInteriorInfo( "properties/interiors.txt" );

	for( new i = 0; i < MAX_TYPES; i++ ){
   		ReadPropertyFile( propFile[i] );
	}
	return 1;
}

UnloadProperties()
{
	new
	    p;
	for( new i = 0; i < MAX_PROPERTIES; i++ ){
		if( propPickups[i] != -1 ){
			DestroyPickup( i );
			p = propPickups[i];
			propPickups[i] = -1;
			properties[p][eInterior] = -1;
			properties[p][eType] = TYPE_EMPTY;
			properties[p][eOwner] = -1;
			properties[p][ePrice] = 0;
			properties[p][ePname][0] = '\0';
		}
	}
}

/********************************************************
********************************************************/


/************************************
*   		Callbacks			    *
************************************/


public OnFilterScriptInit()
{
	print("\n-----------------------------------");
	print("Grand Larceny Property Filterscript		");
	print("-----------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	UnloadProperties();
	return 1;
}

public OnGameModeInit()
{
	LoadProperties();
	return 1;
}

public OnGameModeExit()
{
	UnloadProperties();
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	if( newinteriorid == 0 ){
		currentInt[playerid] = -1;
		SetPlayerVirtualWorld( playerid, 0 );
	}
	return 1;
}

public OnPlayerSpawn( playerid )
{
	gLastPropertyEnterNotification[playerid] = -1;
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	//printf( "DEBUG: Player %d pickedup Pickup %d Prop Id %d", playerid, pickupid );
	lastPickup[playerid] = pickupid;
	new id = propPickups[pickupid];
	new pmsg[256];

	if( properties[id][eType] > 0 ){
	
	    if(gLastPropertyEnterNotification[playerid] != id){
	        gLastPropertyEnterNotification[playerid] = id;
          	switch( properties[id][eType] ){
		    	case TYPE_HOUSE:{
		        	format(pmsg,256,"* House: type /enter to enter");
		        	SendClientMessage( playerid, 0xFF55BBFF, pmsg );
		        	return 1;
				}

				case TYPE_BUSINESS:{
			   		format(pmsg,256,"* Business: type /enter to enter");
		        	SendClientMessage( playerid, 0xFF55BBFF, pmsg );
		        	return 1;
				}

				case TYPE_BANK:{
					format(pmsg,256,"* Bank: type /enter to enter");
		        	SendClientMessage( playerid, 0xFF55BBFF, pmsg );
		        	return 1;
				}

				case TYPE_COP:{
					format(pmsg,256,"* Police Station: type /enter to enter");
		        	SendClientMessage( playerid, 0xFF55BBFF, pmsg );
		        	return 1;
				}
		 	}
		}
	}
	else SendClientMessage( playerid, 0xFF9900FF, "This property doesn't exist :S" );

	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new idx;
	new cmd[256];

	cmd = strtok(cmdtext, idx);
	
	// Public commands.
	if(strcmp("/enter", cmd, true) == 0) // enter property
	{
		if( lastPickup[playerid] != -1 || properties[lastPickup[playerid]][eType] > 0 ){
		    new
		        id = propPickups[lastPickup[playerid]],
		        Float:x,
		        Float:y,
		        Float:z;

			GetPropertyEntrance( id, x, y, z );
	    	if( IsPlayerInRangeOfPoint( playerid, 3.0, x, y, z )){
	    	    PutPlayerInProperty( playerid, id );
	    	    SendClientMessage( playerid, 0x55AADDFF, "* You have entered a property.. type /exit to leave" );
	    	    return 1;
			}
		}
		return 1;
	}
	else if(strcmp("/exit", cmd, true) == 0) // exit property
	{
	    if( currentInt[playerid] > -1 && GetPlayerInterior(playerid) == GetPropertyInteriorId( currentInt[playerid] )){

	        new id = currentInt[playerid];
	        new Float:x;
			new	Float:y;
			new	Float:z;
			new	Float:a;

			// make sure they're near the exit before allowing them to exit.
			GetPropertyExit( id, x, y, z );
			if(!IsPlayerInRangeOfPoint(playerid,4.5,x,y,z)) {
			    SendClientMessage(playerid,0xDDAA55FF,"* You must be near the property exit to /exit");
			    return 1;
			}

			a = GetPropertyEntrance( id, x, y, z );
			SetPlayerPos( playerid, x, y, z );
			SetPlayerFacingAngle( playerid, a );
			SetPlayerInterior( playerid, 0 );
			SetPlayerVirtualWorld( playerid, 0 );
		}
		currentInt[playerid] = -1;
		return 1;
	}
	
	// The rest of the commands here are for
	// property creation which is admin only.
	
	if(!IsPlayerAdmin(playerid)) return 0;

	if(strcmp("/chouse", cmd, true) == 0) // creates a house type property
	{
		PropertyCommand( playerid, cmd, cmdtext,idx, TYPE_HOUSE );
		return 1;
	}
	else if(strcmp("/cbus", cmd, true) == 0) // creates a business type property
	{
 	    PropertyCommand( playerid, cmd, cmdtext,idx, TYPE_BUSINESS );
 	    return 1;
	}
	else if(strcmp("/ccop", cmd, true) == 0) // creates a police station property
	{
		PropertyCommand( playerid, cmd, cmdtext,idx, TYPE_COP );
		return 1;
	}
	else if(strcmp("/cbank", cmd, true) == 0) // creates a bank type property
	{
		PropertyCommand( playerid, cmd, cmdtext,idx, TYPE_BANK );
		return 1;
	}
	else if(strcmp("/view", cmd, true) == 0) //Basically lets you view an interior from the interiors.txt file by id
	{

	    new
			tmp[256],
			string[128],
			uniqId,
			Float:x,
			Float:y,
			Float:z,
			Float:a;
		tmp = strtok( cmdtext, idx );
		if(!strlen(tmp)){
		    format( string, 128, "Usage: %s [uniqInteriorId]", cmd );
		    SendClientMessage( playerid, 0xFF00CC, string );

		    return 1;
		}
		if(!isNumeric(tmp)){
		    SendClientMessage(playerid, 0x550000, "Uniq Interior Id must be a number" );
		    return 1;
		}
		uniqId = strval( tmp );

		if( uniqId > MAX_INTERIORS || uniqId < 0 ){
			SendClientMessage( playerid, 0xFFFFCC, "Invalid Uniq Interior Id" );
			return 1;
		}
		if( GetPlayerInterior( playerid ) == 0 ){
			GetPlayerPos( playerid, plPos[playerid][0], plPos[playerid][1], plPos[playerid][2] );
			plInt[playerid] = GetPlayerInterior( playerid );
		}
		a = GetInteriorExit( uniqId, x, y, z );
		SetPlayerInterior( playerid, GetInteriorIntID( uniqId ) );
		SetPlayerPos( playerid, x, y, z );
		SetPlayerFacingAngle( playerid, a );
		format( string, 128, "UniqId: %d InteriorId: %d Name: %s | Use /return to go to last position", uniqId,GetInteriorIntID( uniqId ), GetInteriorName( uniqId ));
		SendClientMessage( playerid, 0x556600FF, string );
		return 1;
	}
	else if( strcmp( "/return", cmd, true ) == 0 ) // return from /view command to last position
	{
	    SetPlayerPos( playerid, plPos[playerid][0], plPos[playerid][1], plPos[playerid][2] );
	    SetPlayerInterior( playerid, plInt[playerid] );
		return 1;
	}

	return 0;
}

/***********************************************************************
***********************************************************************/
