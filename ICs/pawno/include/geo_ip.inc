/*
           _.-,=_""""--,_
        .-" =/7"   _  .3#"=.
      ,#7  " "  ,//)#d#######=.		GEO-IP
    ,/ "      # ,i-/###########= 		Version 2.1
   /         _)#sm###=#=# #######\
  /         (#/"_`;\//#=#\-#######\ 		FEATURES :
 /         ,d####-_.._.)##P########\		+ Gets Country, States/Provinces
,        ,"############\\##bi- `\| Y.           and City Info for any IP Address
|       .d##############b\##P'   V  |       + Bigger Database (SQLite)
|\      '#################!",       |       + Faster Operation
|C.       \###=############7        |       + Uses No Plugins
'###.           )#########/         '
 \#(             \#######|         /        CREDITS :
  \B             /#######7 /      /         Database (CSV) : http://db-ip.com
   \             \######" /"     /          Script By : Abhinav Dabral
    `.            \###7'       ,'                       (abhinavdabral)
      "-_          `"'      ,-'                         ALIAS : Code Wave
         "-._           _.-"                Facebook : fb.me/codewave
             """"---""""                        
*/

stock GetPlayerLocation(playerid, Country[],State[], City[],isotype=0){
   	new IPAddress[32];
   	new a,b,c,d,ipf;
   	new DB:IPDB;
   	new DBResult:Result;
   	new Q[256];

	GetPlayerIp(playerid,IPAddress,sizeof(IPAddress));


   	new _parameters[4][8];
   	new Destination[8];
	new SLen=strlen(IPAddress);
	new at,pos=0,tp=0;
	new tempo[256];

	for(new i=0;i<4;i++) format(_parameters[i],sizeof(_parameters),"");

	for(at=pos;at<=SLen;at++){
		strmid(tempo,IPAddress,at,at+1,sizeof(tempo));
		if(!strcmp(tempo,".",true)){
			if(tp<=3){
				strmid(Destination,IPAddress,pos,at,sizeof(Destination));
				format(_parameters[tp][0],256,"%s",Destination);
				tp=tp+1;
			}
			pos=at+1;
		}
	}
	
   	a=strval(_parameters[0]);
   	b=strval(_parameters[1]);
   	c=strval(_parameters[2]);
   	d=strval(_parameters[3]);

   	if(a==127 && b==0 && c==0 && d==1){
   		format(Country,256,"Localhost");
   		return 0;
   	}

   	ipf = (16777216*a) + (65536*b) + (256*c) + d;
   	IPDB=db_open("IPList.db");
	format(Q,sizeof(Q),"SELECT * FROM 'IPTable' WHERE start<=%d AND end>=%d",ipf,ipf);

	if(isotype==1) format(Q,sizeof(Q),"SELECT IPTable.start,IPTable.end,isoshort.alpha_three,IPTable.state,IPTable.city FROM 'IPTable','isoshort' WHERE IPTable.start<=%d AND IPTable.end>=%d AND IPTable.country==isoshort.alpha_two",ipf,ipf);
	else if(isotype==2) format(Q,sizeof(Q),"SELECT IPTable.start,IPTable.end,isofull.fullname,IPTable.state,IPTable.city FROM 'IPTable','isofull' WHERE IPTable.start<=%d AND IPTable.end>=%d AND IPTable.country==isofull.alpha_two",ipf,ipf);

	Result=db_query(IPDB, Q);
	if(db_num_rows(Result) == 1)
    {
  	  db_get_field(Result,2,Country,256);
      db_get_field(Result,3,State,256);
      db_get_field(Result,4,City,256);
    }

	db_free_result(Result);
	db_close(IPDB);
	return 1;
}

stock GetPlayerCountry(playerid,isotype=2){
   	new Country[256], State[256], City[256];
	GetPlayerLocation(playerid,Country,State,City,isotype);
	return Country;
}

stock GetPlayerProvince(playerid){
   	new Country[256], State[256], City[256];
	GetPlayerLocation(playerid,Country,State,City);
	return State;
}

stock GetPlayerCity(playerid){
   	new Country[256], State[256], City[256];
	GetPlayerLocation(playerid,Country,State,City);
	return City;
}
