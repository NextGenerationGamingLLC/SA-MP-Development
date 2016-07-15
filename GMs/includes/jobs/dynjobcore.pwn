#include <YSI\y_hooks>

#define 	MAX_JOB_VEHICLES		200

#define 	PVAR_EDITINGJOBID	"JOB_ED"
#define 	PVAR_JOB_OBTAINING 	"JOB_OB"
#define 	PVAR_JOB2_OBTAINING "JOB2_OB"

new Iterator:JobVehicle<MAX_JOB_VEHICLES>;

enum e_JobVehData {
	jveh_iTypeID,
	jveh_iVehID
}
new arrJobVehData[MAX_JOB_VEHICLES][e_JobVehData];


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_JOBS_EDITTYPE:
		{
			if(!response) return SendClientMessage(playerid, COLOR_GRAD1, "You cancelled creating a job type.");
			SetPVarInt(playerid, PVAR_EDITINGJOBID, listitem);
			return ShowPlayerDialogEx(playerid, DIALOG_JOBS_EDITTYPE2, DIALOG_STYLE_INPUT, "Specify Job Name", "Please specify the job's name.", "Enter", "Back");
		}
		case DIALOG_JOBS_EDITTYPE2:
		{
			if(4 > strlen(inputtext) > MAX_JOBNAME_LEN) return DeletePVar(playerid, PVAR_EDITINGJOBID), SendClientMessage(playerid, COLOR_GRAD1, "That name is either too short or long.");
			if(IsNumeric(inputtext)) return DeletePVar(playerid, PVAR_EDITINGJOBID), SendClientMessage(playerid, COLOR_GRAD1, "You cannot use numbers.");
			Job_CreateJobType(playerid, GetPVarInt(playerid, PVAR_EDITINGJOBID), inputtext);
			format(szMiscArray, sizeof(szMiscArray), "You have successfully created the {FFFFFF}%s {FFFF00}job.", inputtext);
			SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
			DeletePVar(playerid, PVAR_EDITINGJOBID);
			return 1;
		}
		case DIALOG_JOBS_EDIT:
		{
			if(response) {
				switch(listitem) {
					case 0: {

						new
							iJobID = GetPVarInt(playerid, PVAR_EDITINGJOBID);

						Job_Process(playerid, iJobID, 0);
						DeletePVar(playerid, PVAR_EDITINGJOBID);
						return 1;
					}

					case 1: {

						new
							iJobID = GetPVarInt(playerid, PVAR_EDITINGJOBID);

						Job_Process(playerid, iJobID, 1);
						DeletePVar(playerid, PVAR_EDITINGJOBID);
						return 1;
					}
					case 2: {
						ShowPlayerDialogEx(playerid, DIALOG_JOBS_EDITACTOR, DIALOG_STYLE_INPUT, "Edit Job's Actor Skin", "Enter a skin ID from 0 to 311.", "Change", "Cancel");
						return 1;
					}
				}
			}
		}
		case DIALOG_JOBS_EDITACTOR: {
			if(isnull(inputtext) || !IsNumeric(inputtext) || !(0 <= strval(inputtext) <= 311)) return SendClientMessage(playerid, COLOR_GRAD1, "Only use a number from 0 to 311.");
			new iJobID = GetPVarInt(playerid, PVAR_EDITINGJOBID),
				Float:fPos[2][4],
				iActorModel = strval(inputtext);
			GetActorPos(arrJobData[iJobID][job_iActorID][0], fPos[0][0], fPos[0][1], fPos[0][2]);
			GetActorPos(arrJobData[iJobID][job_iActorID][1], fPos[1][0], fPos[1][1], fPos[1][2]);
			GetActorFacingAngle(arrJobData[iJobID][job_iActorID][0], fPos[1][3]);
			GetActorFacingAngle(arrJobData[iJobID][job_iActorID][1], fPos[1][3]);
			DestroyActor(arrJobData[iJobID][job_iActorID][0]);
			DestroyActor(arrJobData[iJobID][job_iActorID][1]);
			arrJobData[iJobID][job_iActorID][0] = CreateActor(iActorModel, fPos[0][0], fPos[0][1], fPos[0][2], fPos[0][3]);
			arrJobData[iJobID][job_iActorID][1] = CreateActor(iActorModel, fPos[1][0], fPos[1][1], fPos[1][2], fPos[1][3]);
			SetActorInvulnerable(arrJobData[iJobID][job_iActorID][0], true);
			SetActorInvulnerable(arrJobData[iJobID][job_iActorID][1], true);
			arrJobData[iJobID][job_iActorModel] = iActorModel;
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `jobs` SET `actormodel` = '%d' WHERE `id` = '%d'", strval(inputtext), iJobID);
			mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			return 1;
		}
		case DIALOG_JOBS_ACCEPTJOB:
		{
			if(response) {
				
				new iJob = GetPVarInt(playerid, PVAR_JOB_OBTAINING);

				if(PlayerInfo[playerid][pJob] == 0)	{

					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Congratulations with your new Job, type /help to see your new command.");
					if(iJob == 21) {

						SendClientMessageEx(playerid, COLOR_WHITE, "You have been given a Pizza Stack uniform!");
						SendClientMessageEx(playerid, COLOR_WHITE, "You have been accepted to Pizza Nation; one of the most secret societies in the world.");
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
	            if(PlayerInfo[playerid][pDonateRank] >= 3 || PlayerInfo[playerid][pFamed] > 0) {

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
				return SendClientMessage(playerid, COLOR_GRAD1, "You cannot take any more jobs. Please use /quitjob to take this job.");
	        }
		}
		case DIALOG_JOBS_NEAREST: {

			if(response) {

				new i = ListItemTrackId[playerid][listitem],
					Float:f_Pos[3];

				format(szMiscArray, sizeof(szMiscArray), "A checkpoint to the {FFFF00}%s {FFFFFF}job has been marked on your map.", GetJobName(arrJobData[i][job_iType]));
				SendClientMessage(playerid, COLOR_WHITE, szMiscArray);

				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrJobData[i][job_iTextID][0], E_STREAMER_X, f_Pos[0]);
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrJobData[i][job_iTextID][0], E_STREAMER_Y, f_Pos[1]);
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrJobData[i][job_iTextID][0], E_STREAMER_Z, f_Pos[2]);

				SetPlayerCheckpoint(playerid, f_Pos[0], f_Pos[1], f_Pos[2], 10.0);
				return 1;
			}
		}

	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {

	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER) {
		new iVehID = GetPlayerVehicleID(playerid);
		foreach(new i : JobVehicle)
		{
			if(arrJobVehData[i][jveh_iVehID] == iVehID)
			{
				if(PlayerInfo[playerid][pJob] != arrJobVehData[i][jveh_iTypeID] && PlayerInfo[playerid][pJob2] != arrJobVehData[i][jveh_iTypeID] &&
					PlayerInfo[playerid][pJob3] != arrJobVehData[i][jveh_iTypeID])
				{
					format(szMiscArray, sizeof(szMiscArray), "You must be a %s to use this vehicle.", GetJobName(arrJobVehData[i][jveh_iTypeID]));
					RemovePlayerFromVehicle(playerid);
					SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
				}
			}
		}
	}
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES)
	{
		if(GetPlayerTargetActor(playerid) != INVALID_ACTOR_ID)
		{
			new iActorID = GetPlayerTargetActor(playerid);
			for(new i; i < MAX_JOBPOINTS; ++i)
			{
				if(arrJobData[i][job_iActorID][0] == iActorID)
				{
					Job_GetJob(playerid, i);
					return 1;
				}
			}
		}
	}
	return 1;
}


Job_LoadJobNames()
{
	format(szMiscArray, sizeof(szMiscArray), "SELECT `name` FROM `jobs_types`");
	mysql_function_query(MainPipeline, szMiscArray, true, "Job_OnLoadJobNames", "");
}

forward Job_OnLoadJobNames();
public Job_OnLoadJobNames()
{
	new iRows, iFields, idx;
	cache_get_data(iRows, iFields, MainPipeline);
	while(idx < iRows) {
		cache_get_field_content(idx, "name", szJobNames[idx], MainPipeline);
		// printf("[Jobs] Loaded: %s", szJobNames[idx]);
		idx++;
	}
	return 1;
}

Job_LoadJobs() {

	Job_LoadJobNames();
	Job_LoadJobVehicles();
	printf("[Job System] Loading Jobs from the database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `jobs`", true, "Job_OnLoadJobs", "");
}

forward Job_OnLoadJobs();
public Job_OnLoadJobs() 
{
	szMiscArray[0] = 0;
	new
	    iRows,
		iFields, 
		iRow;

	cache_get_data(iRows, iFields, MainPipeline);
	if(iRows) {
		for(iRow = 0; iRow < iRows; ++iRow) {
				
			new Float:fPos[4],
				iVW,
				iActorModel;

			fPos[0] = cache_get_field_content_float(iRow, "posx", MainPipeline);
			fPos[1] = cache_get_field_content_float(iRow, "posy", MainPipeline);
					
			if(fPos[0] != 0 && fPos[1] != 0) {

				fPos[2] = cache_get_field_content_float(iRow, "posz", MainPipeline);
				fPos[3] = cache_get_field_content_float(iRow, "rot", MainPipeline);
				
				arrJobData[iRow][job_iSpawned] = 1;

				iActorModel = cache_get_field_content_int(iRow, "actormodel", MainPipeline);
				iVW = cache_get_field_content_int(iRow, "vw", MainPipeline);

				arrJobData[iRow][job_iType] = cache_get_field_content_int(iRow, "type", MainPipeline);
				arrJobData[iRow][job_iLevel] = cache_get_field_content_int(iRow, "level", MainPipeline);
				arrJobData[iRow][job_iActorID][0] = CreateActor(iActorModel, fPos[0], fPos[1], fPos[2], fPos[3]);
				arrJobData[iRow][job_iActorModel] = iActorModel;
				arrJobData[iRow][job_iMapMarker] = CreateDynamicMapIcon(fPos[0], fPos[1], fPos[2], 56, 0, .streamdistance = 1000.0, .style = MAPICON_GLOBAL);

				format(szMiscArray, sizeof szMiscArray, "{FFFF00}[Job Point ({FFFFFF}ID %i{FFFF00})]\n\nName: {FFFFFF}%s\n{FFFF00}Aim at me and use {FFFFFF}~k~~CONVERSATION_YES~ {FFFF00}to obtain the job.", iRow, GetJobName(arrJobData[iRow][job_iType]));
				arrJobData[iRow][job_iTextID][0] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, fPos[0], fPos[1], fPos[2] + 1.5, 8.0, .worldid = iVW);

				if(cache_get_field_content_float(iRow, "delx", MainPipeline) != 0)
				{
					fPos[0] = cache_get_field_content_float(iRow, "delx", MainPipeline);
					fPos[1] = cache_get_field_content_float(iRow, "dely", MainPipeline);
					fPos[2] = cache_get_field_content_float(iRow, "delz", MainPipeline);
					
					arrJobData[iRow][job_iActorID][1] = CreateActor(iActorModel, fPos[0], fPos[1], fPos[2], fPos[3]);
					format(szMiscArray, sizeof szMiscArray, "{FFFF00}Job Pickup Point ({FFFFFF}ID %i{FFFF00})\n\nName: {FFFFFF}%s\n{FFFF00}Type {FFFFFF}'/%s' {FFFF00}to use the pickup.", iRow, GetJobName(arrJobData[iRow][job_iType]), ((arrJobData[iRow][job_iType] == 21) ? ("getpizza") : ("t")));
					arrJobData[iRow][job_iTextID][1] = CreateDynamic3DTextLabel(szMiscArray, COLOR_LIGHTBLUE, fPos[0],fPos[1], fPos[2] + 1.5, 8.0);
				}
				SetActorInvulnerable(arrJobData[iRow][job_iActorID][0], true);
				SetActorInvulnerable(arrJobData[iRow][job_iActorID][1], true);
			}
		}
	}
	printf("[Job System] Loaded %d job points from the database.", iRow);
	return 1;
}

Job_Process(playerid, iJobID, choice = 0) {

	new Float:fPos[4],
		iVW = GetPlayerVirtualWorld(playerid);

	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	GetPlayerFacingAngle(playerid, fPos[3]);
	
	switch(choice)
	{
		case 0:
		{
			DestroyActor(arrJobData[iJobID][job_iActorID][0]);
			DestroyDynamic3DTextLabel(arrJobData[iJobID][job_iTextID][0]);
			arrJobData[iJobID][job_iActorID][0] = CreateActor(arrJobData[iJobID][job_iActorModel], fPos[0], fPos[1], fPos[2], fPos[3]);
			SetActorVirtualWorld(arrJobData[iJobID][job_iActorID][0], iVW);
			SetActorInvulnerable(arrJobData[iJobID][job_iActorID][0], true);
			format(szMiscArray, sizeof szMiscArray, "{FFFF00}[Job Point ({FFFFFF}ID %i{FFFF00})]\n\nName: {FFFFFF}%s\n{FFFF00}Aim at me and use {FFFFFF}~k~~CONVERSATION_YES~ {FFFF00}to obtain the job.", iJobID, GetJobName(arrJobData[iJobID][job_iType]));
			arrJobData[iJobID][job_iTextID][0] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, fPos[0], fPos[1], fPos[2] + 1.5, 8.0, .worldid = iVW);
			format(szMiscArray, sizeof szMiscArray, "You have moved job point ID %i.", iJobID);
       		SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
			return 1;
		}
		case 1:
		{
			DestroyActor(arrJobData[iJobID][job_iActorID][1]);
			DestroyDynamic3DTextLabel(arrJobData[iJobID][job_iTextID][1]);
			arrJobData[iJobID][job_iActorID][1] = CreateActor(arrJobData[iJobID][job_iActorModel], fPos[0], fPos[1], fPos[2], fPos[3]);
			SetActorVirtualWorld(arrJobData[iJobID][job_iActorID][1], iVW);
			SetActorInvulnerable(arrJobData[iJobID][job_iActorID][1], true);
			format(szMiscArray, sizeof szMiscArray, "{FFFF00}Job Pickup Point ({FFFFFF}ID %i{FFFF00})\n\nName: {FFFFFF}%s\n{FFFF00}Type {FFFFFF}'/%s' {FFFF00}to use the pickup.", iJobID, GetJobName(arrJobData[iJobID][job_iType]), ((arrJobData[iJobID][job_iType] == 21) ? ("getpizza") : ("t")));
			arrJobData[iJobID][job_iTextID][1] = CreateDynamic3DTextLabel(szMiscArray, COLOR_LIGHTBLUE, fPos[0],fPos[1], fPos[2] + 1.5, 8.0);
			format(szMiscArray, sizeof szMiscArray, "You have created/moved the job pickup for job ID %i.", iJobID);
        	SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
		}
	}
	Job_Save(iJobID, choice, fPos[0], fPos[1], fPos[2], fPos[3], iVW);
	return 1;
}

Job_Save(iJobID, choice = 0, Float:X, Float:Y, Float:Z, Float:Rot, iVW) 
{
	if(!(0 <= iJobID < MAX_JOBPOINTS))
	    return 1;

	switch(choice)
	{
		case 0:
		{
			format(szMiscArray, sizeof szMiscArray, "UPDATE `jobs` SET `type` = %i, \
				`posx` = %f, \
				`posy` = %f, \
				`posz` = %f, \
				`rot` = %f, \
				`vw` = %d, \
				`level` = %d \
				WHERE `id` = %d",
				arrJobData[iJobID][job_iType],
				X,
				Y,
				Z,
				Rot,
				iVW,
				arrJobData[iJobID][job_iLevel],
				iJobID
			);
		}
		case 1:
		{
			format(szMiscArray, sizeof szMiscArray, "UPDATE `jobs` SET `type` = %i, \
				`delx` = %f, \
				`dely` = %f, \
				`delz` = %f, \
				`rot` = %f, \
				`vw` = %d, \
				`level` = %d \
				WHERE `id` = %d",
				arrJobData[iJobID][job_iType],
				X,
				Y,
				Z,
				Rot,
				iVW,
				arrJobData[iJobID][job_iLevel],
				iJobID
			);
		}
	}

	return mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

forward Job_OnCreateJob(iExtraID, iJobID, iActorModel, Float:X, Float:Y, Float:Z, Float:Rot, iVW);
public Job_OnCreateJob(iExtraID, iJobID, iActorModel, Float:X, Float:Y, Float:Z, Float:Rot, iVW) {

	arrJobData[iJobID][job_iSpawned] = 1;
    arrJobData[iJobID][job_iActorID][0] = CreateActor(iActorModel, X, Y, Z, Rot);
    SetActorVirtualWorld(arrJobData[iJobID][job_iActorID][0], iVW);
    SetActorInvulnerable(arrJobData[iJobID][job_iActorID][0], true);
    arrJobData[iJobID][job_iActorModel]= iActorModel;

    arrJobData[iJobID][job_iMapMarker] = CreateDynamicMapIcon(X, Y, Z, 56, 0, .streamdistance = 1000.0, .style = MAPICON_GLOBAL);
		
	format(szMiscArray, sizeof szMiscArray, "{FFFF00}[Job Point ({FFFFFF}ID %i{FFFF00})]\n\nName: {FFFFFF}%s\n{FFFF00}Aim at me and use {FFFFFF}~k~~CONVERSATION_YES~ {FFFF00}to obtain the job.", iJobID, GetJobName(arrJobData[iJobID][job_iType]));
	arrJobData[iJobID][job_iTextID][0] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, X, Y, Z + 1.5, 8.0, .worldid = iVW);
	format(szMiscArray, sizeof szMiscArray, "You have created a new job using ID %i.", iJobID);
	SendClientMessage(iExtraID, COLOR_LIGHTRED, szMiscArray);
	return 1;
}

Job_CreateJobType(iPlayerID, i, name[]) {

	format(szJobNames[i], sizeof(szJobNames[]), name);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `jobs_types` SET `name` = '%e' WHERE `id` = '%d'", name, i+1);
	mysql_function_query(MainPipeline, szMiscArray, false, "Job_OnCreateJobType", "iis", iPlayerID, i, name);
}

forward Job_OnCreateJobType(iPlayerID, i, name[]);
public Job_OnCreateJobType(iPlayerID, i, name[])
{
	if(mysql_errno()) return SendClientMessage(iPlayerID, COLOR_GRAD1, "Something went wrong. Please try again later.");
	format(szMiscArray, sizeof(szMiscArray), "%s has created the %s job in slot %d", GetPlayerNameExt(iPlayerID), name, i);
	Log("logs/jobs/jobcreation.log", szMiscArray);
	return 1;
}

Job_GetJob(playerid, i)
{
	if(PlayerInfo[playerid][pLevel] < arrJobData[i][job_iLevel]) 
    {
        format(szMiscArray, sizeof szMiscArray, "You need to be level %i to get this job.", arrJobData[i][job_iLevel]);
        return SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
    }
    if(PlayerInfo[playerid][pJob] == arrJobData[i][job_iType] || PlayerInfo[playerid][pJob2] == arrJobData[i][job_iType] || PlayerInfo[playerid][pJob3] == arrJobData[i][job_iType]) {
    	return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have this job.");
    }
	if(PlayerInfo[playerid][pJob] == 0) format(szMiscArray, sizeof(szMiscArray), "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}?", GetJobName(arrJobData[i][job_iType]));
	else if(0 < PlayerInfo[playerid][pDonateRank] < 4) format(szMiscArray, sizeof szMiscArray, "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}? (VIP Job)", GetJobName(arrJobData[i][job_iType]));
	else if(PlayerInfo[playerid][pDonateRank] > 3) format(szMiscArray, sizeof szMiscArray, "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}? (Platinum VIP Job)", GetJobName(arrJobData[i][job_iType]));
	else if(PlayerInfo[playerid][pFamed] > 0) format(szMiscArray, sizeof szMiscArray, "Would you like to proceed a career as a {FFFF00}%s{FFFFFF}? (OS/Famed Job)", GetJobName(arrJobData[i][job_iType]));
	else if(PlayerInfo[playerid][pJob] > 0 && PlayerInfo[playerid][pDonateRank] == 0 && PlayerInfo[playerid][pFamed] == 0) return SendClientMessage(playerid, COLOR_GRAD1, "You already have a job, use '/quitjob' from your old job in order to obtain a new one.");
	
	SetPVarInt(playerid, PVAR_JOB_OBTAINING, arrJobData[i][job_iType]);
	ShowPlayerDialogEx(playerid, DIALOG_JOBS_ACCEPTJOB, DIALOG_STYLE_MSGBOX, "Job Point", szMiscArray, "Yes", "No");
	return 1;
}

GetJobName(i)
{
	return szJobNames[i];
}

stock Job_IsValidJob(iTypeID)
{
	for(new i; i < MAX_JOBPOINTS; ++i) if(IsValidDynamic3DTextLabel(arrJobData[i][job_iTextID][0]) && arrJobData[i][job_iType] == iTypeID) return 1;
	return 0;
}

stock Job_GetPlayerJob(playerID) 
{
	if(PlayerInfo[playerID][pJob] <= 0)
	    return 0;

	for(new i; i < MAX_JOBPOINTS; ++i) if(PlayerInfo[playerID][pJob] == arrJobData[i][job_iType]) return arrJobData[i][job_iType];
	return 0;
}

stock Job_GetPlayerJob2(playerID) 
{
	if(PlayerInfo[playerID][pJob2] == 0)
	    return 0;

	for(new i; i < MAX_JOBPOINTS; ++i) if(PlayerInfo[playerID][pJob2] == arrJobData[i][job_iType]) return arrJobData[i][job_iType];
	return 0;
}

CMD:getjob(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GRAD1, "This command has been deprecated. Use ~k~~CONVERSATION_YES~ while looking (aiming) at a job point's operator.");
	return 1;
}

CMD:jobpointhelp(playerid, params[]) 
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) 
	{
		SendClientMessage(playerid, COLOR_GREEN, "|____________________| Job Point Commands |____________________|");
	    SendClientMessage(playerid, COLOR_GRAD2, "* '/createjobpoint' - '/deletejobpoint' - '/gotojob' - '/jobpos' '/jobdeliver'");
	    SendClientMessage(playerid, COLOR_GRAD1, "* '/createjobtype' - '/jobtypes' - '/createjobveh' - '/deletejobveh'");
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not authorised to use this command.");
	return 1;
}

CMD:createjobpoint(playerid, params[]) 
{
	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) 
	{
	    new
			ijob_iType,
			ijob_iLevel,
			ijob_iActorModel,
			Float:fPos[4];

		if(sscanf(params, "iii", ijob_iType, ijob_iLevel, ijob_iActorModel))
		    return SendClientMessage(playerid, COLOR_GRAD1, "/createjobpoint [type] [levelrequirement] [skinmodel]"),
		        SendClientMessage(playerid, COLOR_GREEN, "[Job Help] {DDDDDD} Use /jobtypes to get a list of all available job types.");

		if(ijob_iType < 0 || ijob_iType > MAX_JOBTYPES) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid job type.");

		for(new i = 0; i < MAX_JOBPOINTS; ++i) {	
			
			if(arrJobData[i][job_iSpawned] == 0) {

		        GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
		        GetPlayerFacingAngle(playerid, fPos[3]);
		        arrJobData[i][job_iType] = ijob_iType;
		        arrJobData[i][job_iLevel] = ijob_iLevel;
                format(szMiscArray, sizeof szMiscArray, "UPDATE `jobs` SET `type` = '%d', `actormodel` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', `rot` = '%f', `level` = '%d' WHERE `id` = '%d'",
                    ijob_iType,
                    ijob_iActorModel,
                    fPos[0],
					fPos[1],
					fPos[2],
					fPos[3],
					ijob_iLevel,
					i+1
				);
				return mysql_function_query(MainPipeline, szMiscArray, true, "Job_OnCreateJob", "iiiffffi", playerid, i, ijob_iActorModel, fPos[0], fPos[1], fPos[2], fPos[3], GetPlayerVirtualWorld(playerid));
		    }
		}
		SendClientMessage(playerid, COLOR_GRAD1, "There are no job points available.");
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not authorised to use this command.");
	return 1;
}

CMD:editjob(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) 
	{
		new i;
		if(sscanf(params, "d", i)) return SendClientMessage(playerid, COLOR_GRAD1, "Usage: /editjob [id]");
		if(!IsValidDynamic3DTextLabel(arrJobData[i][job_iTextID][0])) return SendClientMessageEx(playerid, COLOR_GRAD1, "This is not a valid job point.");
		format(szMiscArray, sizeof(szMiscArray), "Edit Job ID %d", i);
		SetPVarInt(playerid, PVAR_EDITINGJOBID, i);
		ShowPlayerDialogEx(playerid, DIALOG_JOBS_EDIT, DIALOG_STYLE_LIST, szMiscArray, "Edit Position\nEdit Deliver Position\nEdit Actor Skin", "Select", "Cancel");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	return 1;
}

CMD:deletejobpoint(playerid, params[]) 
{
	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) 
	{
	    new iJobID;

		if(sscanf(params, "i", iJobID))
		    return SendClientMessage(playerid, COLOR_GRAD1, "/deletejob [jobid]");

		if(!(0 <= iJobID < MAX_JOBPOINTS))
		    return SendClientMessage(playerid, COLOR_GRAD1, "Invalid job ID specified.");

		if(arrJobData[iJobID][job_iSpawned] == 0)
		    return SendClientMessage(playerid, COLOR_GRAD1, "The specified job ID is not been used.");

        format(szMiscArray, sizeof szMiscArray, "UPDATE `jobs` SET `posx` = '0', `posy` = '0', `posz` = '0' WHERE `id` = %d", iJobID+1);
        mysql_function_query(MainPipeline, szMiscArray, false, "Job_OnDeleteJob", "ii", playerid, iJobID);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not authorised to use this command.");
	return 1;
}

forward Job_OnDeleteJob(playerid, iJobID);
public Job_OnDeleteJob(playerid, iJobID) {
	DestroyActor(arrJobData[iJobID][job_iActorID][0]);
	DestroyActor(arrJobData[iJobID][job_iActorID][1]);
	DestroyDynamic3DTextLabel(arrJobData[iJobID][job_iTextID][0]);
	DestroyDynamic3DTextLabel(arrJobData[iJobID][job_iTextID][1]);
	DestroyDynamicMapIcon(arrJobData[iJobID][job_iMapMarker]);
	arrJobData[iJobID][job_iSpawned] = 0;
	format(szMiscArray, sizeof szMiscArray, "You have successfully deleted job ID %i.", iJobID);
    return SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
}

CMD:gotojob(playerid, params[]) {
	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pAdmin] >= 1) 
	{
	    new
			iJobID,
			Float:fPos[3];

		if(sscanf(params, "i", iJobID))
		    return SendClientMessage(playerid, COLOR_GRAD1, "/gotojob [jobid]");

		if(!IsValidDynamic3DTextLabel(arrJobData[iJobID][job_iTextID][0]))
		    return SendClientMessage(playerid, COLOR_GRAD1, "The specified job ID is not been used.");

		GetActorPos(arrJobData[iJobID][job_iActorID][0], fPos[0], fPos[1], fPos[2]);
		SetPlayerPos(playerid, fPos[0], fPos[1] + 0.5, fPos[2]);

		format(szMiscArray, sizeof szMiscArray, "You have teleported to job point ID %i.", iJobID);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not authorised to use this command.");
	return 1;
}


/* JOB VEHICLES */
Job_LoadJobVehicles() {
	mysql_function_query(MainPipeline, "SELECT * FROM `jobs_vehicles`", true, "Job_OnLoadJobVehicles", "");
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
		mysql_function_query(MainPipeline, szMiscArray, true, "Job_OnCreateJobVehicle", "iiiffffii", i, iTypeID, iVehID, fPos[0], fPos[1], fPos[2], fPos[3], color1, color2);
	}
	else SendClientMessage(iPlayerID, COLOR_GRAD1, "You exceeded the maximum job vehicle quotum.");
	return 1;
}

Job_DeleteJobVehicle(iPlayerID, iVehID)
{
	new i;
	foreach(i : JobVehicle) if(arrJobVehData[i][jveh_iVehID] == iVehID) break;
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `jobs_vehicles` SET `posx` = '0', `posy` = '0', `posz` = '0' WHERE `id` = %d", i+1);
	return mysql_function_query(MainPipeline, szMiscArray, false, "Job_OnDeleteJobVehicle", "ii", iPlayerID, i);
}

forward Job_OnDeleteJobVehicle(iPlayerID, i);
public Job_OnDeleteJobVehicle(iPlayerID, i)
{
	if(mysql_errno()) return SendClientMessage(iPlayerID, COLOR_GRAD1, "Something went wrong. Please try again later.");
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
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	
	new iTypeID,
		iVehID,
		col[2];
	if(sscanf(params, "dddd", iTypeID, iVehID, col[0], col[1])) return SendClientMessage(playerid, COLOR_GRAD1, "Usage: /createjobveh [Job Type ID] [vehid] [col1] [col2]");
	if(!Job_IsValidJob(iTypeID)) return SendClientMessage(playerid, COLOR_GRAD1, "This job type has not been setup yet.");
	if(!(400 <= iVehID <= 611)) return SendClientMessage(playerid, COLOR_GRAD1, "The vehicle ID must be between 400 and 611.");
	Job_CreateJobVehicle(playerid, iTypeID, iVehID, col[0], col[1]);
	return 1;
}

CMD:deletejobveh(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	new iVehID;
	if(sscanf(params, "d", iVehID)) return SendClientMessage(playerid, COLOR_GRAD1, "Usage: /deletejobveh [vehid]");
	foreach(new i : JobVehicle)
	{
		if(arrJobVehData[i][jveh_iVehID] == iVehID) return Job_DeleteJobVehicle(playerid, i), 1;
	}
	SendClientMessage(playerid, COLOR_GRAD1, "Invalid job vehicle ID specified.");
	return 1;
}

CMD:nearjobveh(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	new Float:fPos2[3];
	GetPlayerPos(playerid, fPos2[0], fPos2[1], fPos2[2]);
	SendClientMessage(playerid, COLOR_GREEN, "[Job Vehicles] {FFFFFF} Listing all job vehicles within 30 meters of you.");
	foreach(new i : JobVehicle)
	{
		new Float:fPos[3];
		GetVehiclePos(arrJobVehData[i][jveh_iVehID], fPos[0], fPos[1], fPos[2]);
		if(IsPlayerInRangeOfPoint(playerid, 30.0, fPos[0], fPos[1], fPos[2]))
		{
			format(szMiscArray, sizeof(szMiscArray), "Job VehID: %d | Range: %.2f meters from you.", arrJobVehData[i][jveh_iVehID], GetDistanceBetweenPoints(fPos[0], fPos[1], fPos[2], fPos2[0], fPos2[1], fPos2[2]));
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
		}
	}
	return 1;
}

CMD:jobtypes(playerid) {

	szMiscArray = "Job Type ID\tName\n";
	for(new i; i < MAX_JOBTYPES; ++i)
	{
		if(!isnull(szJobNames[i])) format(szMiscArray, sizeof(szMiscArray), "%sID %d:\t%s\n", szMiscArray, i, szJobNames[i]);
	}
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Job List", szMiscArray, "<<", "");
	return 1;
}

CMD:createjobtype(playerid) {

	szMiscArray = "Job Type ID & Name\tEditable\n";
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	for(new i; i < MAX_JOBTYPES; ++i)
	{
		if(!isnull(szJobNames[i])) format(szMiscArray, sizeof(szMiscArray), "%s%d: %s\t{FF0000}Unavailable\n", szMiscArray, i);
		else format(szMiscArray, sizeof(szMiscArray), "%s%d): %s\t%s {00FF00}Available\n", szMiscArray, i, szJobNames[i]);
	}
	ShowPlayerDialogEx(playerid, DIALOG_JOBS_EDITTYPE, DIALOG_STYLE_TABLIST_HEADERS, "Edit Job Types", szMiscArray, "<<", "");
	return 1;
}