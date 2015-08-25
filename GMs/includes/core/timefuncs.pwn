stock ConvertToTwelveHour(tHour)
{
	new string[56], suffix[3], cHour;
	if(tHour > 12 && tHour < 24)
	{
		cHour = tHour - 12;
		suffix = "PM";
	}
	else if(tHour == 12)
	{
		cHour = 12;
		suffix = "PM";
	}
	else if(tHour > 0 && tHour < 12)
	{
		cHour = tHour;
		suffix = "AM";
	}
	else if(tHour == 0)
	{
		cHour = 12;
		suffix = "AM";
	}
	format(string, sizeof(string), "%d%s", cHour, suffix);
	return string;
}

forward FixServerTime();
public FixServerTime()
{
	gettime(ghour, gminute, gsecond);
	FixHour(ghour);
	ghour = shifthour;
	
	new tmphour;
	new tmpminute;
	new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;
	
	new iTempHour = CalculateWorldGameTime(hour, minuite);
	SetWorldTime(iTempHour);
	print("Adjusted the server time...");
	return 1;
}	

GetWeekday(display = 0, day = 0, month = 0, year = 0)
{
	if(!day) getdate(year, month, day);

	new weekday_str[10], j, e;

	if(month <= 2)
	{
		month += 12;
		--year;
	}

	j = year % 100;
	e = year / 100;
	
	if(display == 1)
	{
		switch((day + (month+1)*26/10 + j + j/4 + e/4 - 2*e) % 7)
		{
			case 0: weekday_str = "sat";
			case 1: weekday_str = "sun";
			case 2: weekday_str = "mon";
			case 3: weekday_str = "tues";
			case 4: weekday_str = "wed";
			case 5: weekday_str = "thurs";
			case 6: weekday_str = "fri";
		}
	}
	else
	{
		switch((day + (month+1)*26/10 + j + j/4 + e/4 - 2*e) % 7)
		{
			case 0: weekday_str = "saturday";
			case 1: weekday_str = "sunday";
			case 2: weekday_str = "monday";
			case 3: weekday_str = "tuesday";
			case 4: weekday_str = "wednesday";
			case 5: weekday_str = "thursday";
			case 6: weekday_str = "friday";
		}
	}

	return weekday_str;
}

stock ConvertTimeS(seconds, TYPE = 0)
{
	new string[64], minutes;
	if(TYPE == 0) {
		if(seconds > 86400)
		{
			if(floatround((seconds/86400), floatround_floor) > 1) format(string, sizeof(string), "%d days", floatround((seconds/86400), floatround_floor));
			else format(string, sizeof(string), "%d day", floatround((seconds/86400), floatround_floor));
			seconds=seconds-((floatround((seconds/86400), floatround_floor))*86400);
		}
		if(seconds > 3600)
		{
			if(strlen(string) > 0) format(string, sizeof(string), "%s, ", string);
			if(floatround((seconds/3600), floatround_floor) > 1) format(string, sizeof(string), "%s%d hours", string, floatround((seconds/3600), floatround_floor));
			else format(string, sizeof(string), "%s%d hour", string, floatround((seconds/3600), floatround_floor));
			seconds=seconds-((floatround((seconds/3600), floatround_floor))*3600);
		}
		if(seconds > 60)
		{
			if(strlen(string) > 0) format(string, sizeof(string), "%s, ", string);
			if(floatround((seconds/60), floatround_floor) > 1) format(string, sizeof(string), "%s%d minutes", string, floatround((seconds/60), floatround_floor));
			else format(string, sizeof(string), "%s%d minute", string, floatround((seconds/60), floatround_floor));
			seconds=seconds-((floatround((seconds/60), floatround_floor))*60);
		}
		if(strlen(string) > 0) format(string, sizeof(string), "%s, ", string);
		if(seconds > 1) format(string, sizeof(string), "%s%d seconds", string, seconds);
		else if(seconds != 0) format(string, sizeof(string), "%s%d second", string, seconds);
	}
	else {
		if(seconds > 60)
		{
			minutes = floatround((seconds/60), floatround_floor);
			if(minutes > 9) format(string, sizeof(string), "%d", minutes);
			else format(string, sizeof(string), "0%d", minutes);
			seconds = seconds - (minutes * 60);
		}
		if(minutes > 0) {
			if(seconds > 9) format(string, sizeof(string), "%s:%d", string, seconds);
			else format(string, sizeof(string), "%s:0%d", string, seconds);
		}
		else {
			if(seconds > 9) format(string, sizeof(string), "00:%d", seconds);
			else format(string, sizeof(string), "00:0%d", seconds);
		}
		
	}
	return string;
}

stock ConvertTime(cts, &ctm=-1,&cth=-1,&ctd=-1,&ctw=-1,&ctmo=-1,&cty=-1)
{
    //Defines to drastically reduce the code..

    #define PLUR(%0,%1,%2) (%0),((%0) == 1)?((#%1)):((#%2))

    #define CTM_cty 31536000
    #define CTM_ctmo 2628000
    #define CTM_ctw 604800
    #define CTM_ctd 86400
    #define CTM_cth 3600
    #define CTM_ctm 60

    #define CT(%0) %0 = cts / CTM_%0; cts %= CTM_%0


    new strii[128];

    if(cty != -1)
    {
        CT(cty); CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(cty,"year","years"),PLUR(ctmo,"month","months"),PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctmo != -1)
    {
        CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(ctmo,"month","months"),PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctw != -1)
    {
        CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctd != -1)
    {
        CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, and %d %s",PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(cth != -1)
    {
        CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, and %d %s",PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctm != -1)
    {
        CT(ctm);
        format(strii, sizeof(strii), "%d %s, and %d %s",PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    format(strii, sizeof(strii), "%d %s", PLUR(cts,"second","seconds"));
    return strii;
}

TimeConvert(time) {
	new jhour;
    new jmin;
	new jdiv;
    new jsec;
    new string[128];
	if(time > 3599){
		jhour = floatround(time / (60*60));
		jdiv = floatround(time % (60*60));
        jmin = floatround(jdiv / 60, floatround_floor);
        jsec = floatround(jdiv % 60, floatround_ceil);
        format(string,sizeof(string),"%02d:%02d:%02d",jhour,jmin,jsec);
    }
    else if(time > 59 && time < 3600){
        jmin = floatround(time/60);
        jsec = floatround(time - jmin*60);
        format(string,sizeof(string),"%02d:%02d",jmin,jsec);
    }
    else{
        jsec = floatround(time);
        format(string,sizeof(string),"%02d seconds",jsec);
    }
    return string;
}

forward FixHour(hourt);
public FixHour(hourt)
{
	hourt = timeshift+hourt;
	if (hourt < 0)
	{
		hourt = hourt+24;
	}
	else if (hourt > 23)
	{
		hourt = hourt-24;
	}
	shifthour = hourt;
	return 1;
}

#if defined zombiemode
forward SyncPlayerTime(playerid);
public SyncPlayerTime(playerid)
{
	if(zombieevent == 0)
	{
		new
		iTempHour = CalculateWorldGameTime(hour, minuite),
		iTempMinute = CalculateGameMinute(minuite, second);

		SetPlayerTime(playerid, iTempHour, iTempMinute);
	}
	else SetPlayerTime(playerid, 0, 0);
	return 1;
}

forward SyncMinTime(i);
public SyncMinTime(i)
{
	if(GetPlayerVirtualWorld(i) == 133769)
	{
		SetPlayerWeather(i, 45);
		SetPlayerTime(i, 0, 0);
	}
	else
	{
		if(zombieevent == 0) 
		{
			new
			iTempHour = CalculateWorldGameTime(hour, minuite),
			iTempMinute = CalculateGameMinute(minuite, second);

			SetPlayerTime(i, iTempHour, iTempMinute);
		}
    	else SetPlayerTime(i, 0, 0);
	}
	return 1;
}
#else
forward SyncPlayerTime(playerid);
public SyncPlayerTime(playerid)
{
	new
		iTempHour = CalculateWorldGameTime(hour, minuite),
		iTempMinute = CalculateGameMinute(minuite, second);

	SetPlayerTime(playerid, iTempHour, iTempMinute);
	return 1;
}

forward SyncMinTime(i);
public SyncMinTime(i)
{
	new
		iTempHour = CalculateWorldGameTime(hour, minuite),
		iTempMinute = CalculateGameMinute(minuite, second);

	if(GetPlayerVirtualWorld(i) == 133769)
	{
		SetPlayerWeather(i, 45);
		SetPlayerTime(i, 0, 0);
	}
	else
	{
		SetPlayerTime(i, iTempHour, iTempMinute);
	}	
	return 1;
}
#endif

stock date( timestamp, _form=0 )
{
    /*
        date( 1247182451 )  will print >> 09.07.2009-23:34:11
        date( 1247182451, 1) will print >> 09/07/2009, 23:34:11
        date( 1247182451, 2) will print >> July 09, 2009, 23:34:11
        date( 1247182451, 3) will print >> 9 Jul 2009, 23:34
    */
    new year=1970, day=0, month=0, hourt=0, mins=0, sec=0;

    new days_of_month[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };
    new names_of_month[12][10] = {"January","February","March","April","May","June","July","August","September","October","November","December"};
    new returnstring[32];

    while(timestamp>31622400){
        timestamp -= 31536000;
        if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) timestamp -= 86400;
        year++;
    }

    if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )
        days_of_month[1] = 29;
    else
        days_of_month[1] = 28;


    while(timestamp>86400){
        timestamp -= 86400, day++;
        if(day==days_of_month[month]) day=0, month++;
    }

    while(timestamp>60){
        timestamp -= 60, mins++;
        if( mins == 60) mins=0, hourt++;
    }

    sec=timestamp;

    switch( _form ){
        case 1: format(returnstring, 31, "%02d/%02d/%d %02d:%02d:%02d", day+1, month+1, year, hourt, mins, sec);
        case 2: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, hourt, mins, sec);
        case 3: format(returnstring, 31, "%d %c%c%c %d, %02d:%02d", day+1,names_of_month[month][0],names_of_month[month][1],names_of_month[month][2], year,hourt,mins);
		case 4: format(returnstring, 31, "%s %02d, %d", names_of_month[month],day+1,year);
        default: format(returnstring, 31, "%02d.%02d.%d-%02d:%02d:%02d", day+1, month+1, year, hourt, mins, sec);
    }

    return returnstring;
}

CalculateWorldGameTime(iTempSVHour, iTempSVMinute)
{
	// Note that 1 hour in-game time is equivalent to half an hour server-time. By logic this means the clock 
	// advances 2x as fast as it should.
	new iTime = 0; 
	switch(iTempSVHour)
	{
		case 0, 12: iTime = 0; // 00:00
		case 1, 13: iTime = 2; // 02:00
		case 2, 14: iTime = 4; // 04:00
		case 3, 15: iTime = 6; // 06:00
		case 4, 16: iTime = 8; // 08:00
		case 5, 17: iTime = 10; // 10:00
		case 6, 18: iTime = 12; // 12:00
		case 7, 19: iTime = 14; // 14:00 
		case 8, 20: iTime = 16; // 16:00
		case 9, 21: iTime = 18; // 18:00
		case 10, 22: iTime = 20; // 20:00
		case 11, 23: iTime = 22;// 22:00
	}
	if(iTempSVMinute >= 30) iTime +=1;

	return iTime;
}

/*CalculateGameMinute(iTempSVSec)
{
	new iTime = 0;
	if(iTempSVSec == 0) iTime = 0;
	else 
	{
		iTime = iTempSVSec/30;
	}
	return iTime;
}*/

CalculateGameMinute(iMinute, iSecond)
{
	new iTime = 0;
	if(iMinute == 0 || iMinute == 30) iTime = 0;
	else if(iMinute > 30) iTime = (iMinute -30) * 2; 
	else iTime = iMinute * 2;
	if(iSecond >= 30) iTime += 1; 
	return iTime; 
}