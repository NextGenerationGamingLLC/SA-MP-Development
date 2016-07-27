ini_GetInt(szParse[], szValueName[], &iValue) {

	new
		iPos = strfind(szParse, "=", false);

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		iValue = strval(szParse[iPos + 1]);
		return 1;
	}
	return 0;
}

/*ini_GetFloat(szParse[], szValueName[], & Float: iValue) {

	new
		iPos = strfind(szParse, "=", false);

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		iValue = floatstr(szParse[iPos + 1]);
		return 1;
	}
	return 0;
}

ini_GetString(szParse[], szValueName[], szDest[], iLength = sizeof(szDest)) {

	new
		iPos = strfind(szParse, "=", false);

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		strcat(szDest, szParse[iPos + 1], iLength);
		return 1;
	}
	return 0;
}*/

ini_GetValue(szParse[], szValueName[], szDest[], iDestLen) { // brian!!1

	new
		iPos = strfind(szParse, "=", false),
		iLength = strlen(szParse);
		
	while(iLength-- && szParse[iLength] <= ' ') {
		szParse[iLength] = 0;
	}

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		strmid(szDest, szParse, iPos + 1, iLength + 1, iDestLen);
		return 1;
	}
	return 0;
}

Log(sz_fileName[], sz_input[]) {

	new
		sz_logEntry[256],
		#if defined _LINUX
		File: logfile,
		#endif
		i_dateTime[2][3];

	gettime(i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2]);
	getdate(i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2]);

	format(sz_logEntry, sizeof(sz_logEntry), "[%i/%i/%i - %i:%02i:%02i] %s\r\n", i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2], i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2], sz_input);
	if(logfile) fclose(logfile);
	if(!fexist(sz_fileName)) logfile = fopen(sz_fileName, io_write);
	else logfile = fopen(sz_fileName, io_append);
	if(logfile)
	{
		fwrite(logfile, sz_logEntry);
		fclose(logfile);
	}
	return 1;
}