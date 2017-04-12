#include <YSI\y_hooks>

#define 	PVAR_JOB_OBTAINING 	"JOB_OB"

new JobCount = 0;

hook OnGameModeInit() {
	//Jobpoints
	for(new i = 0; i < MAX_JOBPOINTS; i++) {
		JobData[i][jId] = -1;
		JobData[i][jType] = 0;
		JobData[i][jPos][0] = 0.0;
		JobData[i][jPos][1] = 0.0;
		JobData[i][jPos][2] = 0.0;
		JobData[i][jVw] = 0;
		JobData[i][jInt] = 0;
		JobData[i][jLevel] = 1;
		//JobData[i][jAreaID] = 
	}
	for(new n = 1; n < MAX_JOBTYPES; n++) {
		format(JobName[n], 32, "-----");
	}
	//Jobvehs
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

    if((newkeys & KEY_YES) && IsPlayerInAnyDynamicArea(playerid)) {

        new areaid[1];
        GetPlayerDynamicAreas(playerid, areaid);
        // new i = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid[0], E_STREAMER_EXTRA_ID);

        if(areaid[0] != INVALID_STREAMER_ID) {
            for(new i; i < MAX_JOBPOINTS; ++i) {
                if(areaid[0] == JobData[i][jAreaID]) Job_GetJob(playerid, i);
            }
        }
    }
}

stock LoadJobNames()
{
	printf("[Dynamic Jobs Names] Loading Dynamic Job names from the database, please wait...");
	mysql_tquery(MainPipeline, "SELECT * FROM `jobs_types`", "OnLoadJobNames", "");
}

forward OnLoadJobNames();
public OnLoadJobNames()
{
	szMiscArray[0] = 0;
	new i, rows;
	cache_get_row_count(rows);

	while(i < rows)
	{
		if(i < MAX_JOBTYPES) {
			cache_get_value_name(i, "name", JobName[i], 32);
		}
		i++;
	}
	if(i > 0) printf("[Dynamic Job Names] %d dynamic job names have been loaded.", i-1);
	else printf("[Dynamic Job Names] No dynamic job names have been loaded.");
	return 1;
}

stock LoadJobPoints()
{
	LoadJobNames();
	printf("[Dynamic Jobs] Loading Dynamic Jobs from the database, please wait...");
	mysql_tquery(MainPipeline, "SELECT * FROM `jobs`", "OnLoadJobPoints", "");
}

forward OnLoadJobPoints();
public OnLoadJobPoints()
{
	szMiscArray[0] = 0;
	new i, rows, sqlid;
	cache_get_row_count(rows);

	while(i < rows)
	{
		cache_get_value_name_int(i, "id", JobData[i][jId]);
		if(i < MAX_JOBPOINTS) {
			cache_get_value_name_int(i, "type", JobData[i][jType]);
			cache_get_value_name_float(i, "posx", JobData[i][jPos][0]);
			cache_get_value_name_float(i, "posy", JobData[i][jPos][1]);
			cache_get_value_name_float(i, "posz", JobData[i][jPos][2]);
			cache_get_value_name_int(i, "vw", JobData[i][jVw]);
			cache_get_value_name_int(i, "int", JobData[i][jInt]);
			cache_get_value_name_int(i, "marker", JobData[i][jMarkerID]);
			cache_get_value_name_int(i, "level", JobData[i][jLevel]);
			UpdateJobPoint(i);
			++JobCount;
		} else {
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `jobs` WHERE `id` = %d", sqlid);
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
		i++;
	}
	if(JobCount > 0) printf("[Dynamic Job Points] %d dynamic job points has been loaded.", i);
	else printf("[Dynamic Job Points] No dynamic job points has been loaded.");
	return 1;
}

stock SaveJobPoint(i) {
	new query[2048];

	format(query, 2048, "UPDATE `jobs` SET ");
	SaveInteger(query, "jobs", i+1, "type", JobData[i][jType]);
	SaveFloat(query, "jobs", i+1, "posx", JobData[i][jPos][0]);
	SaveFloat(query, "jobs", i+1, "posy", JobData[i][jPos][1]);
	SaveFloat(query, "jobs", i+1, "posz", JobData[i][jPos][2]);
	SaveInteger(query, "jobs", i+1, "vw", JobData[i][jVw]);
	SaveInteger(query, "jobs", i+1, "int", JobData[i][jInt]);
	SaveInteger(query, "jobs", i+1, "marker", JobData[i][jMarkerID]);
	SaveInteger(query, "jobs", i+1, "level", JobData[i][jLevel]);
	SQLUpdateFinish(query, "jobs", i+1);
}

forward UpdateJobPoint(id);
public UpdateJobPoint(id)
{
	szMiscArray[0] = 0;
	if(IsValidDynamicArea(JobData[id][jAreaID])) DestroyDynamicArea(JobData[id][jAreaID]);
	if(IsValidDynamicPickup(JobData[id][jPickupID])) DestroyDynamicPickup(JobData[id][jPickupID]);
	if(IsValidDynamic3DTextLabel(JobData[id][jTextID])) DestroyDynamic3DTextLabel(JobData[id][jTextID]);
	if(IsValidDynamicMapIcon(JobData[id][jMapMarker])) DestroyDynamicMapIcon(JobData[id][jMapMarker]);

	if(JobData[id][jPos][0] == 0.0) return 1;
	
	JobData[id][jAreaID] = CreateDynamicSphere(JobData[id][jPos][0], JobData[id][jPos][1], JobData[id][jPos][2], 3.0, .worldid = JobData[id][jVw], .interiorid = JobData[id][jInt]);
	JobData[id][jMapMarker] = CreateDynamicMapIcon(JobData[id][jPos][0], JobData[id][jPos][1], JobData[id][jPos][2], (JobData[id][jMarkerID] < 5 || JobData[id][jMarkerID] > 63) ? 56 : JobData[id][jMarkerID], 0, .streamdistance = 500.0, .style = MAPICON_GLOBAL);
	JobData[id][jPickupID] = CreateDynamicPickup(1239, 23, JobData[id][jPos][0], JobData[id][jPos][1], JobData[id][jPos][2], .worldid = JobData[id][jVw], .interiorid = JobData[id][jInt], .streamdistance = 200.0);
	format(szMiscArray, sizeof szMiscArray, "{FFFF00}Job Point ({FFFFFF}ID: %i{FFFF00})\n\nName: {FFFFFF}%s\n{FFFF00}Press {FFFFFF}~k~~CONVERSATION_YES~ {FFFF00}to obtain the job.", id, GetJobName(JobData[id][jType]));
	JobData[id][jTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, JobData[id][jPos][0], JobData[id][jPos][1], JobData[id][jPos][2]+0.6, 10.0, .testlos = 1, .worldid = JobData[id][jVw], .interiorid = JobData[id][jInt], .streamdistance = 10.0);
	return 1;
}

/*LoadJobVehicles() {
	mysql_tquery(MainPipeline, "SELECT * FROM `jobs_vehicles`", true, "OnLoadJobVehicles", "");
}

forward OnLoadJobVehicles();
public OnLoadJobVehicles()
{
	new iRows = cache_get_row_count();
	if(!iRows) print("[Job Vehicles] There are no job vehicles in the database.");
	new iFields,
		idx,
		Float:fPos[2];

	cache_get_data(iRows, iFields, MainPipeline);
	while(idx < iRows) {

		fPos[0] = cache_get_field_content_float(idx, "posx", MainPipeline);
		fPos[1] = cache_get_field_content_float(idx, "posy", MainPipeline);

		if(fPos[0] != 0 && fPos[1] != 0) {

			JobVehData[idx][jveh_iTypeID] = cache_get_field_content_int(idx, "type", MainPipeline);
			Job_ProcessJobVehicle(idx,
				cache_get_field_content_int(idx, "vehid", MainPipeline),
				fPos[0],
				fPos[1],
				cache_get_field_content_float(idx, "posz", MainPipeline),
				cache_get_field_content_float(idx, "rotz", MainPipeline),
				cache_get_field_content_int(idx, "col1", MainPipeline),
				cache_get_field_content_int(idx, "col2", MainPipeline));
		}
		idx++;
	}
	printf("[Job Vehicles] Loaded %d job vehicles.", idx);
}*/

stock Job_GetPlayerJob(playerID) 
{
	if(PlayerInfo[playerID][pJob] <= 0)
	    return 0;

	for(new i; i < MAX_JOBPOINTS; ++i) if(PlayerInfo[playerID][pJob] == JobData[i][jType]) return JobData[i][jType];
	return 0;
}

stock Job_GetPlayerJob2(playerID) 
{
	if(PlayerInfo[playerID][pJob2] == 0)
	    return 0;

	for(new i; i < MAX_JOBPOINTS; ++i) if(PlayerInfo[playerID][pJob2] == JobData[i][jType]) return JobData[i][jType];
	return 0;
}

Job_GetJob(playerid, i)
{
	if(PlayerInfo[playerid][pLevel] < JobData[i][jLevel]) 
    {
        format(szMiscArray, sizeof(szMiscArray), "You need to be level %i to get this job.", JobData[i][jLevel]);
        return SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
    }
    if(PlayerInfo[playerid][pJob] == JobData[i][jType] || PlayerInfo[playerid][pJob2] == JobData[i][jType] || PlayerInfo[playerid][pJob3] == JobData[i][jType]) {
    	return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have this job.");
    }
	if(PlayerInfo[playerid][pJob] == 0) format(szMiscArray, sizeof(szMiscArray), "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}?", GetJobName(JobData[i][jType]));
	else if(0 < PlayerInfo[playerid][pDonateRank] < 4) format(szMiscArray, sizeof(szMiscArray), "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}? (VIP Job)", GetJobName(JobData[i][jType]));
	else if(PlayerInfo[playerid][pDonateRank] > 3) format(szMiscArray, sizeof(szMiscArray), "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}? (Platinum VIP Job)", GetJobName(JobData[i][jType]));
	else if(PlayerInfo[playerid][pFamed] > 0) format(szMiscArray, sizeof(szMiscArray), "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}? (OS/Famed Job)", GetJobName(JobData[i][jType]));
	else if(PlayerInfo[playerid][pJob] > 0 && PlayerInfo[playerid][pDonateRank] == 0 && PlayerInfo[playerid][pFamed] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have a job, use '/quitjob' from your old job in order to obtain a new one.");
	
	SetPVarInt(playerid, PVAR_JOB_OBTAINING, JobData[i][jType]);
	Dialog_Show(playerid, acceptjob, DIALOG_STYLE_MSGBOX, "Job Point", szMiscArray, "Yes", "No");
	return 1;
}

stock GetJobName(i)
{
	return JobName[i];
}

CMD:getjob(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GRAD1, "This command has been removed. Use ~k~~CONVERSATION_YES~ while near a job point.");
	return 1;
}

/*
CMD:jobtypes(playerid) {

	szMiscArray = "Job Type ID\tName\n";
	for(new i; i < MAX_JOBTYPES; ++i)
	{
		if(!isnull(szJobNames[i])) format(szMiscArray, sizeof(szMiscArray), "%sID %d:\t%s\n", szMiscArray, i, szJobNames[i]);
	}
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Job List", szMiscArray, "<<", "");
	return 1;
}
*/

CMD:jobpointhelp(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 2) {
    	SendClientMessageEx(playerid, COLOR_GREEN,"|____________________| Job Point Commands |____________________|");
        SendClientMessageEx(playerid, COLOR_GRAD2, "--* Job Commands --* '/gotojob'");
        if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "--* Job Commands --* '/editjobpoint' - '/editjob'");
//            SendClientMessageEx(playerid, COLOR_GRAD1, "--* Job Vehicle Commands --* '/createjobtype' - '/jobtypes' - '/createjobveh' - '/deletejobveh'");
        }
		SendClientMessageEx(playerid, COLOR_GREEN,"_____________________________________________________________");
    }
    else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorised to use this command.");
    return 1;
}

CMD:gotojob(playerid, params[]) {
	szMiscArray[0] = 0;
	new
		jobid;

	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		if(sscanf(params, "i", jobid))
		    return SendClientMessageEx(playerid, COLOR_GRAD1, "/gotojob [jobid]");

		if(!(0 <= jobid < MAX_JOBPOINTS)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid job ID provided must be 0 - 99.");

		if(JobData[jobid][jType] == 0 || JobData[jobid][jPos][0] == 0.0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Job id given is not being used!");

		SetPlayerPos(playerid, JobData[jobid][jPos][0], JobData[jobid][jPos][1], JobData[jobid][jPos][2]);
		SetPlayerInterior(playerid, JobData[jobid][jInt]);
		PlayerInfo[playerid][pInt] = JobData[jobid][jInt];
		SetPlayerVirtualWorld(playerid, JobData[jobid][jVw]);
		PlayerInfo[playerid][pVW] = JobData[jobid][jVw];

		format(szMiscArray, sizeof szMiscArray, "You have teleported to job point ID %i.", jobid);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorised to use this command.");
	return 1;
}

CMD:editjobpoint(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		ListJobPoints(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to do this!");
	return 1;
}

CMD:editjob(playerid, params[]) {
	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		for(new i = 1; i != MAX_JOBTYPES; i++)
			format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s\n", szMiscArray, i, GetJobName(i));
			//strcat(szMiscArray, "\n"), strcat(szMiscArray, GetJobName(i));

		Dialog_Show(playerid, job_name, DIALOG_STYLE_LIST, "Edit Job Name", szMiscArray, "Select", "Cancel");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to do thiS!");
	return 1;
}

Dialog:job_name(playerid, response, listitem, inputtext[]) {
	if(response) {
		szMiscArray[0] = 0;
		format(szMiscArray, sizeof(szMiscArray), "Please enter in a new name to replace job %s (ID: %d) with.", GetJobName(listitem+1), listitem+1);
		Dialog_Show(playerid, job_name_confirm, DIALOG_STYLE_INPUT, "Please specify a new job name", szMiscArray, "Edit", "Close");
		SetPVarInt(playerid, "JobEditName", listitem+1);
	}
	return 1;
}

Dialog:job_name_confirm(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(response) {
		szMiscArray[0] = 0;
		new 
			id = GetPVarInt(playerid, "JobEditName");
		if(!(1 < strlen(inputtext) < 32) || isnull(inputtext)) {
			format(szMiscArray, sizeof(szMiscArray), "Please enter in a new name to replace job %s (ID: %d) with.\n\nYou must specify a name and it must be between 1 and 32 characters in length!", GetJobName(id), id);
			return Dialog_Show(playerid, job_name_confirm, DIALOG_STYLE_INPUT, "Please specify a new job name", szMiscArray, "Edit", "Close");
		}
		format(szMiscArray, sizeof(szMiscArray), "%s has edited Job ID %d's name from %s to %s", GetPlayerNameEx(playerid), id, GetJobName(id), inputtext);
		Log("logs/jobedit.log", szMiscArray);
		SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed job id: %d's name from %s to %s.", id, GetJobName(id), inputtext);
		mysql_escape_string(inputtext, JobName[id]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `jobs_types` SET `name` = '%e' WHERE `id` = %d", JobName[id], id);
		mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
		for(new j; j < MAX_JOBPOINTS; j++) {
    		if(JobData[j][jType] == id) {
        		UpdateJobPoint(j);
        	}
        }
	} else {
		DeletePVar(playerid, "JobEditName");
	}
	return 1;
}

stock ListJobPoints(playerid) {
	szMiscArray[0] = 0;
	new i = 0;
	while(i < MAX_JOBPOINTS) {
		if(strcmp(JobName[JobData[i][jType]], "-----", true) != 0)
		{
			format(szMiscArray, sizeof(szMiscArray), "%s\n(%i) %s{FFFFFF}", szMiscArray, i, JobName[JobData[i][jType]]);
		}
		else
		{
			format(szMiscArray, sizeof(szMiscArray), "%s\n(%i) (Not Placed)", szMiscArray, i);
		}
		++i; // Outside.
	}
	return Dialog_Show(playerid, jobpoints, DIALOG_STYLE_LIST, "Edit Job Point", szMiscArray, "Select", "Close");
}

Dialog:jobpoints(playerid, response, listitem, inputtext[]) {
	if(response)
	{
		if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return 1;
		SetPVarInt(playerid, "JobEditID", listitem);
		JobEditID(playerid, listitem);
	}
	return 1;

}

stock JobEditID(playerid, jobid) {
	szMiscArray[0] = 0;
	new szTitle[52];
	format(szTitle, sizeof(szTitle), "Editing Job: %s | Job ID: %d", JobName[JobData[jobid][jType]], jobid);

	format(szMiscArray, sizeof(szMiscArray),
		"{BBBBBB}Job Type:\t{FFFFFF}%s\n\
		 {BBBBBB}Move job point to my position\n\
		 {BBBBBB}Player Level Required:\t{FFFFFF}%d\n\
		 {BBBBBB}Delete Job Position\n",
		JobName[JobData[jobid][jType]],
		JobData[jobid][jLevel]
	);

	return Dialog_Show(playerid, editjob, DIALOG_STYLE_TABLIST, szTitle, szMiscArray, "Select", "Back");
}

Dialog:acceptjob(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(response) {
		
		new iJob = GetPVarInt(playerid, PVAR_JOB_OBTAINING);

		if(PlayerInfo[playerid][pJob] == 0)	{

			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Congratulations with your new Job, type /help to see your new command.");
			if(iJob == 21) {

				SendClientMessageEx(playerid, COLOR_WHITE, "You have been given a Pizza Stack uniform!");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have been accepted to join the Pizza Nation; one of the most secret societies in the world.");
            	SendClientMessageEx(playerid, COLOR_WHITE, "Remember: Do not consume the holy pizza, or else face a long, painful, imminent death.");
            	SetPlayerSkin(playerid, 155);
            	PlayerInfo[playerid][pModel] = 155;
			}
			PlayerInfo[playerid][pJob] = iJob;
			DeletePVar(playerid, PVAR_JOB_OBTAINING);
			return 1;
		}
		if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {

            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Congratulations with your new Job, type /help to see your new command.");
            SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have taken this as a secondary job.");

            if(iJob == 21) {
            	SendClientMessageEx(playerid, COLOR_WHITE, "You have been given a Pizza Stack uniform!");
            	SendClientMessageEx(playerid, COLOR_WHITE, "You have been accepted to Pizza Nation; one of the most secret societies in the world.");
            	SendClientMessageEx(playerid, COLOR_WHITE, "Remember: Do not consume the holy pizza, or else face a long, painful, imminent death.");
            	SetPlayerSkin(playerid, 155);
            	PlayerInfo[playerid][pModel] = 155;
            }
            PlayerInfo[playerid][pJob2] = iJob;
            DeletePVar(playerid, PVAR_JOB_OBTAINING);
            return 1;
        }
        if((PlayerInfo[playerid][pDonateRank] >= 3 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob3] == 0) {

		    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Congratulations with your new Job, type /help to see your new command.");
            SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have taken this as a third job.");

			if(iJob == 21) {
            	SendClientMessageEx(playerid, COLOR_WHITE, "You have been given a Pizza Stack uniform!");
            	SendClientMessageEx(playerid, COLOR_WHITE, "You have been accepted to Pizza Nation; one of the most secret societies in the world.");
            	SendClientMessageEx(playerid, COLOR_WHITE, "Remember: Do not consume the holy pizza, or else face a long, painful, imminent death.");
            	SetPlayerSkin(playerid, 155);
            	PlayerInfo[playerid][pModel] = 155;
            }
			PlayerInfo[playerid][pJob3] = iJob;
			DeletePVar(playerid, PVAR_JOB_OBTAINING);
			return 1;
		}
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot take any more jobs. Please use /quitjob to take this job.");
    }
    return 1;
}


Dialog:editjob(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(response) {
		if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return 1;
		new
			jobid = GetPVarInt(playerid, "JobEditID"),
			szTitle[52];
		switch(listitem) {
			case 0: {
				for(new i = 1; i != MAX_JOBTYPES; i++)
					strcat(szMiscArray, "\n"), strcat(szMiscArray, GetJobName(i));

				format(szTitle, sizeof(szTitle), "Edit Job Type (%s) ID: %d", JobName[JobData[jobid][jType]], jobid);
				Dialog_Show(playerid, job_type, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "Cancel");
			}
			case 1: {
				format(szMiscArray, sizeof(szMiscArray), "Are you sure you want to move %s (ID: %d) to your current position?", GetJobName(JobData[jobid][jType]), jobid);
				Dialog_Show(playerid, moveconfirm, DIALOG_STYLE_MSGBOX, "Relocation Confirmation", szMiscArray, "Yes", "No");
			}
			case 2: {
				format(szTitle, sizeof(szTitle), "Edit player Level requirement (%s) ID: %d", JobName[JobData[jobid][jType]], jobid);
				format(szMiscArray, sizeof(szMiscArray), "Are you sure you want change Job ID: %d's level from %d?", jobid, JobData[jobid][jLevel]);
				Dialog_Show(playerid, job_level, DIALOG_STYLE_INPUT, szTitle, szMiscArray, "Yes", "No");
			}
			case 3: {
				format(szMiscArray, sizeof(szMiscArray), "Are you sure you want to delete job point: %s (ID: %d)?", GetJobName(JobData[jobid][jType]), jobid);
				Dialog_Show(playerid, pointdeleteconfirm, DIALOG_STYLE_MSGBOX, "Job Point Deletion Confirmation", szMiscArray, "Yes", "No");
			}
		}
	} else {
		if(GetPVarType(playerid, "JobEditID")) {
			SaveJobPoint(GetPVarInt(playerid, "JobEditID"));
		}
		DeletePVar(playerid, "JobEditID");
		return ListJobPoints(playerid);
	}
	return 1;
}

Dialog:job_level(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	new
		jobid = GetPVarInt(playerid, "JobEditID");

	if(!(1 <= strval(inputtext))) return DeletePVar(playerid, "JobEditID"), SendClientMessageEx(playerid, COLOR_GRAD1, "The job Level may not be less than 1");
	if(!IsNumeric(inputtext)) return DeletePVar(playerid, "JobEditID"), SendClientMessageEx(playerid, COLOR_GRAD1, "You may only use numbers.");
	format(szMiscArray, sizeof(szMiscArray), "%s has edited Job Point %d's level from %d to %d", GetPlayerNameEx(playerid), jobid, JobData[jobid][jLevel], strval(inputtext));
	Log("logs/jobedit.log", szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "You have successfully changed Job ID: %d's level from %d to %d.", jobid, JobData[jobid][jLevel], strval(inputtext));
	JobData[jobid][jLevel] = strval(inputtext);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	SaveJobPoint(jobid);
	UpdateJobPoint(jobid);
	return JobEditID(playerid, jobid);
}


Dialog:pointdeleteconfirm(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	new
		jobid = GetPVarInt(playerid, "JobEditID");

	if(!response) return SendClientMessageEx(playerid, COLOR_GRAD1, "You have chosen to not delete job point: (%s) ID: %d", JobName[JobData[jobid][jType]], jobid);
	format(szMiscArray, sizeof(szMiscArray), "%s has deleted Job Point %d (%s)", GetPlayerNameEx(playerid), jobid, JobName[JobData[jobid][jType]]);
	Log("logs/jobedit.log", szMiscArray);	
	JobData[jobid][jId] = -1;
	JobData[jobid][jType] = 0;
	JobData[jobid][jPos][0] = 0.0;
	JobData[jobid][jPos][1] = 0.0;
	JobData[jobid][jPos][2] = 0.0;
	JobData[jobid][jVw] = 0;
	JobData[jobid][jInt] = 0;
	JobData[jobid][jLevel] = 1;
	SendClientMessageEx(playerid, COLOR_YELLOW, "You have successfully deleted this job point.");
	SaveJobPoint(jobid);
	UpdateJobPoint(jobid);
	return ListJobPoints(playerid);
}

Dialog:moveconfirm(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	new
		jobid = GetPVarInt(playerid, "JobEditID"),
		Float:pos[3];

	if(!response) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are no longer editing (%s) ID: %d", JobName[JobData[jobid][jType]], jobid), JobEditID(playerid, jobid);
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	format(szMiscArray, sizeof(szMiscArray), "%s has edited Job Point %d's Position (B: %f, %f, %f | A: %f, %f, %f)", GetPlayerNameEx(playerid), jobid, JobData[jobid][jPos][0], JobData[jobid][jPos][1], JobData[jobid][jPos][2], pos[0], pos[1], pos[2]);
	Log("logs/jobedit.log", szMiscArray);
	JobData[jobid][jPos][0] = pos[0];
	JobData[jobid][jPos][1] = pos[1];
	JobData[jobid][jPos][2] = pos[2];
	JobData[jobid][jInt] = GetPlayerInterior(playerid);
	JobData[jobid][jVw] = GetPlayerVirtualWorld(playerid);
	SendClientMessageEx(playerid, COLOR_YELLOW, "You have updated a job point position.");
	SaveJobPoint(jobid);
	UpdateJobPoint(jobid);
	return JobEditID(playerid, jobid);
}

/*
{
	if(PlayerInfo[playerid][pLevel] < JobData[i][jLevel]) 
    {
        format(szMiscArray, sizeof(szMiscArray), "You need to be level %i to get this job.", JobData[i][jLevel]);
        return SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
    }
    if(PlayerInfo[playerid][pJob] == JobData[i][jType] || PlayerInfo[playerid][pJob2] == JobData[i][jType] || PlayerInfo[playerid][pJob3] == JobData[i][jType]) {
    	return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have this job.");
    }
	if(PlayerInfo[playerid][pJob] == 0) format(szMiscArray, sizeof(szMiscArray), "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}?", GetJobName(JobData[i][jType]));
	else if(0 < PlayerInfo[playerid][pDonateRank] < 4) format(szMiscArray, sizeof(szMiscArray), "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}? (VIP Job)", GetJobName(JobData[i][jType]));
	else if(PlayerInfo[playerid][pDonateRank] > 3) format(szMiscArray, sizeof(szMiscArray), "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}? (Platinum VIP Job)", GetJobName(JobData[i][jType]));
	else if(PlayerInfo[playerid][pFamed] > 0) format(szMiscArray, sizeof(szMiscArray), "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}? (OS/Famed Job)", GetJobName(JobData[i][jType]));
	else if(PlayerInfo[playerid][pJob] > 0 && PlayerInfo[playerid][pDonateRank] == 0 && PlayerInfo[playerid][pFamed] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have a job, use '/quitjob' from your old job in order to obtain a new one.");
	
	SetPVarInt(playerid, PVAR_JOB_OBTAINING, JobData[i][jType]);
	Dialog_Show(playerid, acceptjob, DIALOG_STYLE_MSGBOX, "Job Point", szMiscArray, "Yes", "No");
	return 1;
}
*/

Dialog:job_type(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	new
		jobid = GetPVarInt(playerid, "JobEditID");
	szMiscArray[0] = 0;
	if(!response) return JobEditID(playerid, jobid);
	format(szMiscArray, sizeof(szMiscArray), "%s has edited Job Point %d's type from %s to %s.", GetPlayerNameEx(playerid), jobid, GetJobName(JobData[jobid][jType]), GetJobName(listitem+1));
	Log("logs/jobedit.log", szMiscArray);
	JobData[jobid][jType] = listitem+1;
	SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed the job type to %s", GetJobName(listitem+1));
	SaveJobPoint(jobid);
	UpdateJobPoint(jobid);
	return JobEditID(playerid, jobid);
}

	/*
			case DIALOG_GROUP_TYPE: {
	
				new
					iGroupID = GetPVarInt(playerid, "Group_EditID");
	
				if(response) {
	
					arrGroupData[iGroupID][g_iGroupType] = listitem;
	
					format(string, sizeof(string), "%s has changed group %d's type to %s", GetPlayerNameEx(playerid), iGroupID+1, Group_ReturnType(arrGroupData[iGroupID][g_iGroupType]));
					Log("logs/editgroup.log", string);
	
				}
				return Group_DisplayDialog(playerid, iGroupID);
			}
	*/
	


/*	
Dialog:job_name(playerid, response, listitem, inputtext[]) {
		new
			jobid = GetPVarInt(playerid, "JobEditName");
		szMiscArray[0] = 0;
		if(!response) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are no longer editing (%s) ID: %d", JobName[JobData[jobid][jType]], jobid);
		return Dialog_Show(playerid, job_name2, DIALOG_STYLE_INPUT, "Specify Job Name", "Please specify the job's name.", "Enter", "Back");
}

Dialog:job_name2(playerid, response, listitem, inputtext[]) {
	if(4 > strlen(inputtext) > MAX_JOBNAME_LEN) return DeletePVar(playerid, "JobEditName"), SendClientMessageEx(playerid, COLOR_GRAD1, "That name is either too short or long.");
	if(IsNumeric(inputtext)) return DeletePVar(playerid, "JobEditName"), SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use numbers.");
	Job_CreateJobType(playerid, GetPVarInt(playerid, "JobEditName"), inputtext);
	format(szMiscArray, sizeof(szMiscArray), "You have successfully created the {FFFFFF}%s {FFFF00}job.", inputtext);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	DeletePVar(playerid, "JobEditName");
	return 1;
}

Job_CreateJobType(iPlayerID, i, name[]) {
	szMiscArray[0] = 0;
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `jobs_types` SET `name` = '%e' WHERE `id` = '%d'", name, i+1);
	mysql_tquery(MainPipeline, szMiscArray, false, "Job_OnCreateJobType", "iis", iPlayerID, i, name);
}

forward Job_OnCreateJobType(iPlayerID, i, name[]);
public Job_OnCreateJobType(iPlayerID, i, name[])
{
	if(mysql_affected_rows(MainPipeline)) {
		strcpy(JobName[i], name, 32); // Update the name variable to the new name.
		SendClientMessageEx(iPlayerID, COLOR_WHITE, "Job name has successfully been changed to %s", name);
	} else {
		SendClientMessageEx(iPlayerID, COLOR_RED, "There was an issue updating the job name!");
	}
	return 1;
}*/

/*
forward Job_OnCreateJobType(iPlayerID, i, name[]);
public Job_OnCreateJobType(iPlayerID, i, name[])
{
	if(mysql_errno()) return SendClientMessageEx(iPlayerID, COLOR_GRAD1, "Something went wrong. Please try again later.");
	format(szMiscArray, sizeof(szMiscArray), "%s has created the %s job in slot %d", GetPlayerNameExt(iPlayerID), name, i);
	Log("logs/jobs/jobcreation.log", szMiscArray);
	return 1;
}
*/
/*
		case DIALOG_JOBS_EDITTYPE2:
		{
			if(4 > strlen(inputtext) > MAX_JOBNAME_LEN) return DeletePVar(playerid, PVAR_EDITINGJOBID), SendClientMessageEx(playerid, COLOR_GRAD1, "That name is either too short or long.");
			if(IsNumeric(inputtext)) return DeletePVar(playerid, PVAR_EDITINGJOBID), SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use numbers.");
			Job_CreateJobType(playerid, GetPVarInt(playerid, PVAR_EDITINGJOBID), inputtext);
			format(szMiscArray, sizeof(szMiscArray), "You have successfully created the {FFFFFF}%s {FFFF00}job.", inputtext);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			DeletePVar(playerid, PVAR_EDITINGJOBID);
			return 1;
		}

*/
/*CMD:createjobveh(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");

	new iTypeID,
		iVehID,
		col[2];
	if(sscanf(params, "dddd", iTypeID, iVehID, col[0], col[1])) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /createjobveh [Job Type ID] [vehid] [col1] [col2]");
	if(!IsValidDynamic3DTextLabel(JobData[JobID][jTextID][0])) return SendClientMessageEx(playerid, COLOR_GRAD1, "This job type has not been setup yet.");
	if(!(400 <= iVehID <= 611)) return SendClientMessageEx(playerid, COLOR_GRAD1, "The vehicle ID must be between 400 and 611.");
	Job_CreateJobVehicle(playerid, iTypeID, iVehID, col[0], col[1]);
	return 1;



}*/

/*CJob_LoadJobVehicles() {
	mysql_tquery(MainPipeline, "SELECT * FROM `jobs_vehicles`", true, "Job_OnLoadJobVehicles", "");
}

forward Job_OnLoadJobVehicles();
public Job_OnLoadJobVehicles()
{
	new iRows = cache_get_row_count();
	if(!iRows) print("[Job Vehicles] There are no job vehicles in the database.");
	new iFields,
		idx,
		Float:fPos[2];

	cache_get_data(iRows, iFields, MainPipeline);
	while(idx < iRows) {

		fPos[0] = cache_get_field_content_float(idx, "posx", MainPipeline);
		fPos[1] = cache_get_field_content_float(idx, "posy", MainPipeline);

		if(fPos[0] != 0 && fPos[1] != 0) {

			arrJobVehData[idx][jveh_iTypeID] = cache_get_field_content_int(idx, "type", MainPipeline);
			Job_ProcessJobVehicle(idx,
				cache_get_field_content_int(idx, "vehid", MainPipeline),
				fPos[0],
				fPos[1],
				cache_get_field_content_float(idx, "posz", MainPipeline),
				cache_get_field_content_float(idx, "rotz", MainPipeline),
				cache_get_field_content_int(idx, "col1", MainPipeline),
				cache_get_field_content_int(idx, "col2", MainPipeline));
		}
		idx++;
	}
	printf("[Job Vehicles] Loaded %d job vehicles.", idx);
}

Job_ProcessJobVehicle(i, iVehID, Float:x, Float:y, Float:z, Float:rotz, color1, color2) {

	arrJobVehData[i][jveh_iVehID] = CreateVehicle(iVehID, x, y, z, rotz, color1, color2, 5000);
}

Job_CreateJobVehicle(iPlayerID, iTypeID, iVehID, color1, color2) {

	new i = Iter_Free(JobVehicle);
	if(i != -1)
	{
		new Float:fPos[4];
		GetPlayerPos(iPlayerID, fPos[0], fPos[1], fPos[2]);
		GetPlayerFacingAngle(iPlayerID, fPos[3]);
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `jobs_vehicles` SET `typeid` = '%d', `vehid` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', \
			`rotz` = '%f', `vw` = '%d', `int` = '%d', `col1` = '%d', `col2` = '%d' WHERE `id` = '%d'",
			iTypeID, iVehID, fPos[0], fPos[1], fPos[2], fPos[3], GetPlayerVirtualWorld(iPlayerID), GetPlayerInterior(iPlayerID), color1, color2, i+1);
		mysql_tquery(MainPipeline, szMiscArray, true, "Job_OnCreateJobVehicle", "iiiffffii", i, iTypeID, iVehID, fPos[0], fPos[1], fPos[2], fPos[3], color1, color2);
	}
	else SendClientMessageEx(iPlayerID, COLOR_GRAD1, "You exceeded the maximum job vehicle quotum.");
	return 1;
}

Job_DeleteJobVehicle(iPlayerID, iVehID)
{
	new i;
	foreach(i : JobVehicle) if(arrJobVehData[i][jveh_iVehID] == iVehID) break;
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `jobs_vehicles` SET `posx` = '0', `posy` = '0', `posz` = '0' WHERE `id` = %d", i+1);
	return mysql_tquery(MainPipeline, szMiscArray, false, "Job_OnDeleteJobVehicle", "ii", iPlayerID, i);
}

forward Job_OnDeleteJobVehicle(iPlayerID, i);
public Job_OnDeleteJobVehicle(iPlayerID, i)
{
	if(mysql_errno()) return SendClientMessageEx(iPlayerID, COLOR_GRAD1, "Something went wrong. Please try again later.");
	Iter_Remove(JobVehicle, i);
	DestroyVehicle(arrJobVehData[i][jveh_iVehID]);
	return 1;
}

forward Job_OnCreateJobVehicle(i, iTypeID, iVehID, Float:x, Float:y, Float:z, Float:rotz, color1, color2);
public Job_OnCreateJobVehicle(i, iTypeID, iVehID, Float:x, Float:y, Float:z, Float:rotz, color1, color2)
{
	if(mysql_errno()) return printf("[Dynanmic Jobs System]: Couldn't create vehicle ID %d for job ID %d", iVehID, i);
	arrJobVehData[i][jveh_iTypeID] = iTypeID;
	arrJobVehData[i][jveh_iVehID] = CreateVehicle(iVehID, x, y, z, rotz, color1, color2, 5000);
	VehicleFuel[arrJobVehData[i][jveh_iVehID]] = 100.0;
	Iter_Add(JobVehicle, i);
	return 1;
}

CMD:createjobveh(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	
	new iTypeID,
		iVehID,
		col[2];
	if(sscanf(params, "dddd", iTypeID, iVehID, col[0], col[1])) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /createjobveh [Job Type ID] [vehid] [col1] [col2]");
	if(!Job_IsValidJob(iTypeID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "This job type has not been setup yet.");
	if(!(400 <= iVehID <= 611)) return SendClientMessageEx(playerid, COLOR_GRAD1, "The vehicle ID must be between 400 and 611.");
	Job_CreateJobVehicle(playerid, iTypeID, iVehID, col[0], col[1]);
	return 1;
}

CMD:deletejobveh(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	new iVehID;
	if(sscanf(params, "d", iVehID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /deletejobveh [vehid]");
	foreach(new i : JobVehicle)
	{
		if(arrJobVehData[i][jveh_iVehID] == iVehID) return Job_DeleteJobVehicle(playerid, i), 1;
	}
	SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid job vehicle ID specified.");
	return 1;
}

CMD:nearjobveh(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	new Float:fPos2[3];
	GetPlayerPos(playerid, fPos2[0], fPos2[1], fPos2[2]);
	SendClientMessageEx(playerid, COLOR_GREEN, "[Job Vehicles] {FFFFFF} Listing all job vehicles within 30 meters of you.");
	foreach(new i : JobVehicle)
	{
		new Float:fPos[3];
		GetVehiclePos(arrJobVehData[i][jveh_iVehID], fPos[0], fPos[1], fPos[2]);
		if(IsPlayerInRangeOfPoint(playerid, 30.0, fPos[0], fPos[1], fPos[2]))
		{
			format(szMiscArray, sizeof(szMiscArray), "Job VehID: %d | Range: %.2f meters from you.", arrJobVehData[i][jveh_iVehID], GetDistanceBetweenPoints(fPos[0], fPos[1], fPos[2], fPos2[0], fPos2[1], fPos2[2]));
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
		}
	}
	return 1;
}*/