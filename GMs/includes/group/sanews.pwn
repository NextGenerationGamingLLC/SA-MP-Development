/*
	SA News - Faction Update (2015)
	by Jingles
	
	-- MAIN FILE --
	Make sure to read the "Install instructions" to get this plug-and-play script set up.
*/


/*
	-- DEFINITIONS / VARIABLES (new)
*/

#include <YSI\y_hooks>

#define			MAX_SANCHANNELS			8
#define			MAX_SANCAMERAS			10
#define			SAN_INVALID_CHANNEL		0
#define			COLOR_NEWS2				0xFFD589AA
#define			COLOR_SANRADIO			0x9DFF9DAA
#define			COLOR_SANRADIO2			0xEAFFEAAA


#define 		DIALOG_SAN_LOGIN 		(20150)
#define 		DIALOG_SAN_SHOWS 		(20151)
#define			DIALOG_SAN_SHOWS_EDIT 	(20152)
#define 		DIALOG_SAN_SHOWS_EDIT2 	(20153)
#define 		DIALOG_SAN_SHOWS_MENU 	(20154)
#define			DIALOG_SAN_SHOWS_TOGGLE (20155)
#define 		DIALOG_SAN_SHOWS_NAME	(20156)
#define 		DIALOG_SAN_SHOWS_HOST 	(20157)
#define 		DIALOG_SAN_SHOWS_TYPE 	(20158)
#define 		DIALOG_SAN_SHOWS_GLOBAL (20159)

#define 		DIALOG_SAN_CAMLIST 		(20160)
#define 		DIALOG_SAN_CAMLIST2 	(20161)
#define 		DIALOG_SAN_CAMERAMAN 	(20162)
#define 		DIALOG_SAN_DCAMERAMAN 	(20163)
#define 		DIALOG_SAN_DIRECTOR 	(20164)
#define 		DIALOG_SAN_PSTREAM 		(20165)
#define 		DIALOG_SAN_BSTREAM 		(20166)
#define 		DIALOG_SAN_VIEWERS 		(20167)

#define 		SAN_CAMERAMAN_SET 			1
#define 		SAN_CAMERAMAN_STOP 			2
#define			SAN_CAMERAMAN_PREVIEW 		3
#define			SAN_CAMERAMAN_BROADCAST 	4
#define			SAN_CAMERAMAN_BIRDSEYE 		5
#define			SAN_CAMERAMAN_VEHICLE 		6
#define			SAN_CAMERAMAN_LOGOUT 		7
#define			SAN_CAMERAMAN_SETPOINTA 	8
#define			SAN_CAMERAMAN_SETPOINTB 	9
#define			SAN_CAMERAMAN_POINTA 		10
#define			SAN_CAMERAMAN_POINTB 		11
#define			SAN_CAMERAMAN_PINTERPOLATE 	12
#define			SAN_CAMERAMAN_INTERPOLATE 	13
#define			SAN_DIRECTOR_LOGIN 			14
#define			SAN_DIRECTOR_PREVIEW 		15
#define			SAN_DIRECTOR_STOP 			16
#define			SAN_DIRECTOR_BROADCAST 		17
#define			SAN_DIRECTOR_BIRDSEYE 		18
#define			SAN_DIRECTOR_INTERPOLATE 	19
#define			SAN_DIRECTOR_VEHICLE 		20
#define			SAN_DIRECTOR_STARTCAM 		21
#define			SAN_DIRECTOR_STOPCAM 		22
#define			SAN_DIRECTOR_LOGOUT 		23
#define			SAN_DIRECTOR_PSTREAM 		24
#define			SAN_DIRECTOR_BSTREAM 		25


new Float:CameramanFloats[MAX_SANCHANNELS][MAX_PLAYERS][4];
new Float:CameramanFVFloats[MAX_SANCHANNELS][MAX_PLAYERS][4];
new Float:ICCameramanFloats[MAX_SANCHANNELS][MAX_PLAYERS][6];
new Float:ICCameramanFVFloats[MAX_SANCHANNELS][MAX_PLAYERS][6];
new ListItemTrackID_Cameras[MAX_PLAYERS][MAX_SANCAMERAS];
new iLastCameraman[MAX_SANCHANNELS] = -1;
new Text:TV_text[14];
//new TVObject[10];

enum eSanShows {
	ChannelName[64],
	Hosts[MAX_PLAYER_NAME * 2],
	ChannelType,
	szChannelType[12],
	szStream[128],
	ChannelActive,
	Global,
	san_iRatings,
	san_iVehicleID,
	// iCameraObject[MAX_SANCAMERAS],
	Text3D:SANews3DText[2],
	Text3D:camera
};
new SANShows[MAX_SANCHANNELS][eSanShows];

hook OnPlayerConnect(playerid)
{
	SAN_PInit(playerid, 0);
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	if(GetPVarType(playerid, "WatchingTV"))
	{
		PlayerInfo[playerid][pInt] = BroadcastLastInt[playerid];
		PlayerInfo[playerid][pVW] = BroadcastLastVW[playerid];
		PlayerInfo[playerid][pPos_r] = BroadcastFloats[playerid][0];
		PlayerInfo[playerid][pPos_x] = BroadcastFloats[playerid][1];
		PlayerInfo[playerid][pPos_y] = BroadcastFloats[playerid][2];
		PlayerInfo[playerid][pPos_z] = BroadcastFloats[playerid][3];
		SANShows[GetPVarInt(playerid, "ChannelID")][san_iRatings]--;
		UpdateSANewsBroadcast(GetPVarInt(playerid, "ChannelID"));
	}
	DeletePVar(playerid, "ChannelID");
	DeletePVar(playerid, "ChannelID_FMEM");
	DeletePVar(playerid, "TVOffer");
	DeletePVar(playerid, "TalkingTV");
	DeletePVar(playerid, "WatchingTV");
	DeletePVar(playerid, "ChannelID");
	return 1;
}

hook OnGameModeInit()
{
	SAN_Init(0);
	return 1;
}

hook OnGameModeExit()
{
	SAN_Init(1);
	return 1;
}

hook OnPlayerDeath(playerid)
{
	SAN_Process_StopPreview(playerid);
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_SAN_LOGIN:
		{
			SAN_ShowsDialog(playerid, 0);
		}
		case DIALOG_SAN_SHOWS_MENU:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						SAN_ShowsDialog(playerid, 2);			
					}
					case 1:
					{
						SetPVarInt(playerid, "DirectorChannelID", 1);
						SAN_ShowsDialog(playerid, 0);
					}
					case 2:
					{
						SAN_ShowsDialog(playerid, 0);
					}
					case 3:
					{
						SAN_ShowsDialog(playerid, 1);
					}
					case 4:
					{
						SAN_Process_Logout(playerid);
					}
				}
			}
		}
		case DIALOG_SAN_SHOWS:
		{
			szMiscArray[0] = 0;
			if(response)
			{
				if(GetPVarType(playerid, "DirectorChannelID"))
				{
					new Float:X, Float:Y, Float:Z;
					SetPVarInt(playerid, "ChannelID_FMEM", listitem+1);
					GetPlayerPos(playerid,X,Y,Z);
					new channel = GetPVarInt(playerid, "ChannelID_FMEM");
					format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] Broadcast Director %s signed in to Channel %i. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid), GetPVarInt(playerid, "ChannelID_FMEM"));
					SANShows[channel][SANews3DText][1] = CreateDynamic3DTextLabel(szMiscArray,COLOR_LIGHTBLUE,X,Y,Z,5.0);
					UpdateSANewsBroadcast(channel);
					SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
					DeletePVar(playerid, "DirectorChannelID");
					cmd_bdirector(playerid, "");
				}
				else if(GetPVarType(playerid, "CameramanChannelID"))
				{
					SetPVarInt(playerid, "ChannelID_FMEM", listitem+1);
					format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] Cameraman %s signed in to Channel %i. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid), GetPVarInt(playerid, "ChannelID_FMEM"));
					SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
					DeletePVar(playerid, "CameramanChannelID");
					cmd_cameraman(playerid, "");
				}
				else if(GetPVarType(playerid, "LoginChannelID"))
				{
					SetPVarInt(playerid, "ChannelID_FMEM", listitem+1);
					format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] Host %s signed in to Channel %i. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid), GetPVarInt(playerid, "ChannelID_FMEM"));
					SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
					DeletePVar(playerid, "LoginChannelID");
				}
				else
				{
					SetPVarInt(playerid, "ChannelID", listitem + 1);
					if(SANShows[listitem+1][ChannelType] != 1) SAN_WatchTV(playerid, listitem+1);
					else SAN_ListenRadio(playerid, listitem+1);
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_SAN_SHOWS_EDIT:
		{
			if(response)
			{
				SetPVarInt(playerid, "SAN_EditingChannelID", listitem+1);
				SAN_ShowsDialog(playerid, 3);
			}
			else
			{
				SAN_ShowsDialog(playerid, 2);
				DeletePVar(playerid, "SAN_EditingChannelID");
			}
			return 1;
		}
		case DIALOG_SAN_SHOWS_EDIT2:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						ShowPlayerDialogEx(playerid, DIALOG_SAN_SHOWS_NAME, DIALOG_STYLE_INPUT, "SAN Shows | Name", "Type the new name of the show.", "Enter", "Cancel");
					}
					case 1:
					{
						ShowPlayerDialogEx(playerid, DIALOG_SAN_SHOWS_HOST, DIALOG_STYLE_INPUT, "SAN Shows | Host", "Type the name of the show's host(s).", "Enter", "Cancel");				
					}
					case 2:
					{
						ShowPlayerDialogEx(playerid, DIALOG_SAN_SHOWS_GLOBAL, DIALOG_STYLE_LIST, "SAN Shows | Global Channels", "Enable Global Channels\nDisable Global Channels", "Enter", "Cancel");				
					}
					case 3:
					{
						ShowPlayerDialogEx(playerid, DIALOG_SAN_SHOWS_TYPE, DIALOG_STYLE_LIST, "SAN Shows | Show Type", "TV Show\nRadio Show\nCustom Show", "Enter", "Cancel");				
					}
					case 4:
					{
						ShowPlayerDialogEx(playerid, DIALOG_SAN_SHOWS_TOGGLE, DIALOG_STYLE_LIST, "SAN Shows | Start / Stop Broadcast", "{EEFFEE}START {FFFFFF}Broadcast\n{FFDDDD}STOP {FFFFFF}Broadcast", "Enter", "Cancel");
					}
				}
				return 1;
			}
			else
			{
				SAN_ShowsDialog(playerid, 1);
			}
		}
		case DIALOG_SAN_SHOWS_GLOBAL:
		{
			if(response)
			{
				new channel = GetPVarInt(playerid, "SAN_EditingChannelID");
				switch(listitem)
				{
					case 0: SANShows[channel][Global] = 0; 
					case 1: SANShows[channel][Global] = 1;
				}
				return SAN_ShowsDialog(playerid, 3);
			}
			else return SAN_ShowsDialog(playerid, 3);				
		}
		case DIALOG_SAN_SHOWS_TYPE:
		{
			if(response)
			{
				new channel = GetPVarInt(playerid, "SAN_EditingChannelID");
				switch(listitem)
				{
					case 0:
					{
						SANShows[channel][ChannelType] = 0;
						format(SANShows[channel][szChannelType], 12, "TV");
					}
					case 1:
					{
						SANShows[channel][ChannelType] = 1;
						format(SANShows[channel][szChannelType], 12, "RADIO");
					}
					case 2:
					{
						SANShows[channel][ChannelType] = 2;
						format(SANShows[channel][szChannelType], 12, "%s", inputtext);
					}
				}
				return SAN_ShowsDialog(playerid, 3);
			}
			else return SAN_ShowsDialog(playerid, 3);
		}
		case DIALOG_SAN_SHOWS_TOGGLE:
		{
			if(response)
			{
				new channel = GetPVarInt(playerid, "SAN_EditingChannelID");
				switch(listitem)
				{
					case 0: 
					{
						if(isnull(SANShows[channel][szChannelType])) return ShowPlayerDialogEx(playerid, DIALOG_SAN_SHOWS_TYPE, DIALOG_STYLE_LIST, "SAN Shows | Show Type | FORGOTTEN!", "TV Show\nRadio Show\nCustom Show", "Enter", "Cancel");				
						if(SANShows[channel][Global] == 0 && strfind(SANShows[channel][szChannelType], "[G]", true) == -1) format(SANShows[channel][szChannelType], 32, "[G] %s", SANShows[channel][szChannelType]);
						SANShows[channel][ChannelActive] = 1;
						SAN_Broadcast(playerid, channel);

					}
					case 1:
					{
						SANShows[channel][ChannelActive] = 0;
						SAN_Broadcast(playerid, channel);
					}
				}
				return SAN_ShowsDialog(playerid, 3);
			}
			else return SAN_ShowsDialog(playerid, 3);
		}
		case DIALOG_SAN_SHOWS_NAME:
		{
			if(response)
			{
				new channel = GetPVarInt(playerid, "SAN_EditingChannelID");
				format(SANShows[channel][ChannelName], 64, "%s", inputtext);
				UpdateSANewsBroadcast(channel);
				SAN_ShowsDialog(playerid, 3);
				return 1;
			}
			else return SAN_ShowsDialog(playerid, 3);
		}
		case DIALOG_SAN_SHOWS_HOST:
		{
			if(response)
			{
				new channel = GetPVarInt(playerid, "SAN_EditingChannelID");
				if(!isnull(inputtext))
				{
					format(SANShows[channel][Hosts], 64, "%s", inputtext);
				}
				UpdateSANewsBroadcast(channel);
				SAN_ShowsDialog(playerid, 3);
				return 1;
			}
			else return SAN_ShowsDialog(playerid, 3);
		}
		case DIALOG_SAN_CAMERAMAN:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						cmd_cameraman(playerid, "");
					}
					case 1:
					{
						SetPVarInt(playerid, "CameramanChannelID", 1);
						SAN_ShowsDialog(playerid, 0);
					}
					case 2:
					{

						format(szMiscArray, sizeof(szMiscArray), "<----- Static Camera Menu\n\
							----------- DYNAMIC CAMERA MENU -----------\n\
							Preview Point A\n\
							Set Point A\n\
							Preview Point B\n\
							Set Point B\n\
							------------------------------------------\n\
							Preview point-to-point camera\n\
							Finish & Broadcast");
						ShowPlayerDialogEx(playerid, DIALOG_SAN_DCAMERAMAN, DIALOG_STYLE_LIST, "SA News | Dynamic Camera Menu", szMiscArray, "Select", "Cancel");
					}
					case 3:
					{
						return 1;
					}
					case 4:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_SET, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 5:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_STOP, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 6:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_PREVIEW, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 7:
					{
						return 1;
					}
					case 8:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_BROADCAST, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 9:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_BIRDSEYE, GetPVarInt(playerid, "ChannelID_FMEM"));
					}					
					case 10:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_VEHICLE, GetPVarInt(playerid, "ChannelID_FMEM"));
					}					
					case 11:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_LOGOUT, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
				}		
			}
		}
		case DIALOG_SAN_DCAMERAMAN:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						cmd_cameraman(playerid, "");
					}
					case 1:
					{
						return 1;
					}
					case 2:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_SETPOINTA, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 3:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_POINTA, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 4:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_SETPOINTB, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 5:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_POINTB, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 6:
					{
						return 1;
					}
					case 7:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_PINTERPOLATE, GetPVarInt(playerid, "ChannelID_FMEM"));
					}					
					case 8:
					{
						SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_INTERPOLATE, GetPVarInt(playerid, "ChannelID_FMEM"));
					}					
				}		
			}
		}
		case DIALOG_SAN_DIRECTOR:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						cmd_bdirector(playerid, "");
					}
					case 1:
					{
						SetPVarInt(playerid, "DirectorChannelID", 1);
						SAN_ShowsDialog(playerid, 0);
					}
					case 2:
					{
						SAN_ShowsDialog(playerid, 2);
					}
					case 3:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_PREVIEW, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 4:
					{
						SAN_Process_ListCameras(playerid, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 5:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_STOP, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 6:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_PSTREAM, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 7:
					{
						cmd_bdirector(playerid, "");
					}
					case 8:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_BROADCAST, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 9:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_BIRDSEYE, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 10:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_INTERPOLATE, GetPVarInt(playerid, "ChannelID_FMEM"));
					}					
					case 11:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_VEHICLE, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 12:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_BSTREAM, GetPVarInt(playerid, "ChannelID_FMEM"));						
					}					
					case 13:
					{
						cmd_bdirector(playerid, "");
					}
					case 14:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_STARTCAM, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 15:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_STOPCAM, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 16:
					{
						cmd_bdirector(playerid, "");
					}
					case 17:
					{
						SAN_Process_Director(playerid, SAN_DIRECTOR_LOGOUT, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
				}		
			}
		}
		case DIALOG_SAN_CAMLIST:
		{
			if(response)
			{
				new szTitle[32];

				SetPVarInt(playerid, "ListItemID_Cameras", ListItemTrackID_Cameras[playerid][listitem]);
				format(szTitle, sizeof(szTitle), "SAN | Camera List | Channel %i", GetPVarInt(playerid, "ChannelID_FMEM"));
				format(szMiscArray, sizeof(szMiscArray), "Preview %s's camera\nBroadcast %s's camera", GetPlayerNameEx(ListItemTrackID_Cameras[playerid][listitem]), GetPlayerNameEx(ListItemTrackID_Cameras[playerid][listitem]));
				ShowPlayerDialogEx(playerid, DIALOG_SAN_CAMLIST2, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "Cancel");
			}
			else 
			{
				DeletePVar(playerid, "ListItemID_Cameras");
				cmd_bdirector(playerid, "");
			}
		}
		case DIALOG_SAN_CAMLIST2:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						if(GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You are already previewing a camera angle.");
						SAN_Process_StartPreview(playerid, GetPVarInt(playerid, "ListItemID_Cameras"));					
					}
					case 1:
					{
						switch(GetPVarInt(GetPVarInt(playerid, "ListItemID_Cameras"), "iCameraman_Type"))
						{
							case 1:
							{
								cameraangle = 1;
								SAN_Process_Camera(GetPVarInt(playerid, "ListItemID_Cameras"), GetPVarInt(playerid, "ChannelID_FMEM"));
							}
							case 2:
							{
								cameraangle = 4;
								SAN_Process_Camera(GetPVarInt(playerid, "ListItemID_Cameras"), GetPVarInt(playerid, "ChannelID_FMEM"));								
							}
							case 3:
							{
								cameraangle = 7;
								SAN_Process_Camera(GetPVarInt(playerid, "ListItemID_Cameras"), GetPVarInt(playerid, "ChannelID_FMEM"));										
							}
						}
					}
				}
			}
			else
			{
				DeletePVar(playerid, "ListItemID_Cameras");
				SAN_Process_ListCameras(playerid, GetPVarInt(playerid, "ChannelID_FMEM"));
			}
		}
		case DIALOG_SAN_PSTREAM:
		{
			if(response)
			{
				new Float:X, Float:Y, Float:Z;
				GetPlayerPos(playerid, X, Y, Z);
				format(SANShows[GetPVarInt(playerid, "ChannelID_FMEM")][szStream], 128, inputtext);
				PlayAudioStreamForPlayer(playerid, inputtext);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Press 'N' to stop previewing the stream.");
				SetPVarInt(playerid, "SAN_PreviewingStream", 1);
			}
			cmd_bdirector(playerid, "");
		}
		case DIALOG_SAN_BSTREAM:
		{
			if(response)
			{
				if(isnull(SANShows[GetPVarInt(playerid, "ChannelID_FMEM")][szStream]) || GetPVarInt(playerid, "SAN_PreviewingStream") == 0) return SendClientMessage(playerid, COLOR_GRAD1, "You haven't previewed your stream yet.");
				DeletePVar(playerid, "SAN_PreviewingStream");
				foreach(Player, i)
				{
					if(GetPVarType(i, "WatchingTV"))
					{
						PlayAudioStreamForPlayer(i, SANShows[GetPVarInt(playerid, "ChannelID")][szStream]);
						SendClientMessage(i, COLOR_LIGHTBLUE, "[SAN] Stream started. Press 'N' to mute it.");
						SetPVarInt(i, "SAN_PlayingStream", 1);
					}
				}
			}
			cmd_bdirector(playerid, "");
		}
		
	}
	return 0;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_NO)
	{
		if(GetPVarType(playerid, "PreviewingTV"))
		{
			SAN_Process_Cameraman(playerid, SAN_CAMERAMAN_STOP, GetPVarInt(playerid, "ChannelID_FMEM"));
		}
		if(GetPVarType(playerid, "SAN_PlayingStream")) StopAudioStreamForPlayer(playerid);
	}
	if(newkeys & KEY_CROUCH)
	{
		if(GetPVarType(playerid, "PreviewingTV"))
		{
			new channel = GetPVarInt(playerid, "ChannelID_FMEM");
			if(GetPVarInt(playerid, "iCameraman_Type") == 1)
			{
				CameramanFloats[channel][playerid][2] += 0.25;
				SetPlayerCameraPos(playerid, CameramanFloats[channel][playerid][0], CameramanFloats[channel][playerid][1], CameramanFloats[channel][playerid][2]);
				SetPlayerCameraLookAt(playerid, CameramanFloats[channel][playerid][0]+CameramanFVFloats[channel][playerid][0], CameramanFloats[channel][playerid][1]+CameramanFVFloats[channel][playerid][1], CameramanFloats[channel][playerid][2]+CameramanFVFloats[channel][playerid][2]);
			}
			else
			{
				if(GetPVarInt(playerid, "ICamPointA") == 1)
				{
					ICCameramanFloats[channel][playerid][2] += 0.25;
					SetPlayerCameraPos(playerid, ICCameramanFloats[channel][playerid][0], ICCameramanFloats[channel][playerid][1], ICCameramanFloats[channel][playerid][2]);
					SetPlayerCameraLookAt(playerid, ICCameramanFloats[channel][playerid][0]+ICCameramanFVFloats[channel][playerid][0], ICCameramanFloats[channel][playerid][1]+ICCameramanFVFloats[channel][playerid][1], ICCameramanFloats[channel][playerid][2]+ICCameramanFVFloats[channel][playerid][2]);	
				}
				else
				{
					ICCameramanFloats[channel][playerid][5] += 0.25;
					ICCameramanFVFloats[channel][playerid][5] += 0.25;
					SetPlayerCameraPos(playerid, ICCameramanFloats[channel][playerid][3], ICCameramanFloats[channel][playerid][4], ICCameramanFloats[channel][playerid][5]);
					SetPlayerCameraLookAt(playerid, ICCameramanFloats[channel][playerid][3]+ICCameramanFVFloats[channel][playerid][3], ICCameramanFloats[channel][playerid][4]+ICCameramanFVFloats[channel][playerid][4], ICCameramanFloats[channel][playerid][5]+ICCameramanFVFloats[channel][playerid][5]);	
				}
			}
		}
	}
	if(newkeys & KEY_SPRINT)
	{
		if(GetPVarType(playerid, "PreviewingTV"))
		{
			new channel = GetPVarInt(playerid, "ChannelID_FMEM");
			CameramanFloats[channel][playerid][2] -= 0.25;
			SetPlayerCameraPos(playerid, CameramanFloats[channel][playerid][0], CameramanFloats[channel][playerid][1], CameramanFloats[channel][playerid][2]);
			SetPlayerCameraLookAt(playerid, CameramanFloats[channel][playerid][0]+CameramanFVFloats[channel][playerid][0], CameramanFloats[channel][playerid][1]+CameramanFVFloats[channel][playerid][1], CameramanFloats[channel][playerid][2]+CameramanFVFloats[channel][playerid][2]);
		}		
	}
	return 1;
}

forward SAN_Init(choice);
public SAN_Init(choice)
{
	switch(choice)
	{
		case 0:
		{
			SAN_InitTextDraws();
		}
		case 1: {}
	}
}

forward SAN_PInit(playerid, choice);
public SAN_PInit(playerid, choice)
{
	switch(choice)
	{
		case 0:
		{
			TalkingLive[playerid] = INVALID_PLAYER_ID;
		}
	}
}

forward TVNews(color, string[], channel);
public TVNews(color, string[], channel)
{
	foreach(Player, i)
	{
		if(!gNews[i])
		{
			if(SANShows[channel][ChannelActive] == 1 && SANShows[channel][Global] == 0) return SendClientMessage(i, color, szMiscArray);
			if((SANShows[channel][ChannelActive] == 1 && SANShows[channel][Global] == 1 && GetPVarInt(i, "ChannelID") == channel)) return SendClientMessage(i, color, szMiscArray);
		}
	}
	return 1;
}


forward SAN_Viewers(playerid);
public SAN_Viewers(playerid)
{
	szMiscArray[0] = 0;
	foreach(Player, i)
	{
		if(GetPVarType(i, "WatchingTV"))
		{
			format(szMiscArray, sizeof(szMiscArray), "%s[CH. %i] || %s\n", szMiscArray, GetPVarInt(i, "ChannelID"), GetPlayerNameEx(i));
		}
	}
	if(isnull(szMiscArray)) return SendClientMessage(playerid, COLOR_GRAD1, "There are no viewers.");
	else ShowPlayerDialogEx(playerid, DIALOG_SAN_VIEWERS, DIALOG_STYLE_LIST, "SAN | Viewer List", szMiscArray, "--", "--");
	return 1;
}


forward SAN_ShowsDialog(playerid, choice);
public SAN_ShowsDialog(playerid, choice)
{
	szMiscArray[0] = 0;
	
	new szDialogLine[129],
		szTitle[64];
	
	for(new channel = 1; channel < MAX_SANCHANNELS; channel++)
	{
		switch(choice)
		{
			case 0 .. 1:
			{
				if(!isnull(SANShows[channel][ChannelName]))
				{
					switch(SANShows[channel][ChannelActive]) 
					{
						case 0:
						{
							format(szDialogLine, sizeof(szDialogLine), "{FF3232}[OFF] {FFFFFF}- [CH. %i] || {FFA500}%s {FFFFFF}|| Host: {32CD80}%s {FFFFFF}|| %s\n", channel, SANShows[channel][ChannelName], SANShows[channel][Hosts], SANShows[channel][szChannelType]);
							format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szDialogLine);
						
						}
						case 1: 
						{
							format(szDialogLine, sizeof(szDialogLine), "{7CFC00}[ON]  {FFFFFF}- [CH. %i] || {FFA500}%s {FFFFFF}|| Host: {32CD80}%s {FFFFFF}|| %s", channel, SANShows[channel][ChannelName], SANShows[channel][Hosts], SANShows[channel][szChannelType]);
							format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szDialogLine);
						}
					}
				}
				else
				{
					switch(SANShows[channel][ChannelActive]) 
					{
						case 0: format(szMiscArray, sizeof(szMiscArray), "%s{FF3232}[OFF] {FFFFFF}- [CH. %i] || ------ || Host: -- || --\n", szMiscArray, channel);
						case 1: format(szMiscArray, sizeof(szMiscArray), "%s {7CFC00}[ON]  {FFFFFF}- [CH. %i] || ------ || Host: -- || --\n", szMiscArray, channel);
					}
				}
			}
			case 2 .. 3:
			{
				if(shutdown == 1)
				{
					format(szMiscArray, sizeof(szMiscArray), "__________________________ {FF3232}SYSTEM OFFLINE {FFFFFF}________________\n");
				}
				else
				{
					format(szMiscArray, sizeof(szMiscArray), "__________________________ {7CFC00}SYSTEM ONLINE {FFFFFF}__________________________\n");
				}
				format(szMiscArray, sizeof(szMiscArray),"%sLog in to Channel\nList Shows\nEdit Shows\nLog Out of System", szMiscArray);
			}
		}
	}
	switch(choice)
	{
		case 0: return ShowPlayerDialogEx(playerid, DIALOG_SAN_SHOWS, DIALOG_STYLE_LIST, "SAN Shows | Tune in", szMiscArray, "Select", "Cancel");
		case 1: return ShowPlayerDialogEx(playerid, DIALOG_SAN_SHOWS_EDIT, DIALOG_STYLE_LIST, "SAN Shows | Edit Console", szMiscArray, "Select", "Cancel");
		case 2: return ShowPlayerDialogEx(playerid, DIALOG_SAN_SHOWS_MENU, DIALOG_STYLE_LIST, "SAN Shows | Menu", szMiscArray, "Select", "Cancel");
		case 3:
		{
			format(szTitle, sizeof(szTitle), "SAN | EDITING: Channel %i | %s", GetPVarInt(playerid, "SAN_EditingChannelID"), SANShows[GetPVarInt(playerid, "SAN_EditingChannelID")][ChannelName]);
			format(szMiscArray, sizeof(szMiscArray), "Edit Show Name\nEdit Show Host\nEdit Global Channel Routing\nEdit Show Type\nStart / Stop Broadcast");
			ShowPlayerDialogEx(playerid, DIALOG_SAN_SHOWS_EDIT2, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "Cancel");
		}
	}
	return 1;
}

forward SAN_SendRadioMessage(playerid, color, string[]);
public SAN_SendRadioMessage(playerid, color, string[]) 
{
	foreach(Player, i) 
	{
		if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember])
			SendClientMessage(i, color, szMiscArray);
	}
}

/*
forward TVObjects_Spawn();
public TVObjects_Spawn()
{
	TVObject[0] = CreateDynamicObject(2318, 1127.79, -1454.52, 17.43,   0.00, 0.00, 180.00);
	TVObject[1] = CreateDynamicObject(16101, 1128.36, -1454.57, 6.39,   0.00, 0.00, 0.72),
	TVObject[2] = CreateDynamicObject(2318, 1128.41, -1454.51, 17.43,   0.00, 0.00, 180.00),
	TVObject[3] = CreateDynamicObject(2318, 1129.03, -1454.50, 17.43,   0.00, 0.00, 180.00),
	TVObject[4] = CreateDynamicObject(16101, 1128.36, -1454.57, 6.39,   0.00, 0.00, 0.72);
}
*/

/*
forward TVObjects_DeSpawn();
public TVObjects_DeSpawn()
{
	for(new i; i < sizeof(TVObject) ; i++)
	{
		DestroyDynamicObject(TVObject[i]);
	}
}
*/

forward SAN_Broadcast(playerid, channel);
public SAN_Broadcast(playerid, channel)
{
	szMiscArray[0] = 0;
	if(IsAReporter(playerid) && PlayerInfo[playerid][pRank] > 1)
	{
		if(shutdown == 1) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "The news system is currently shut down." );
		{
			if(isnull(SANShows[channel][Hosts])) format(SANShows[channel][Hosts], 64, "%s", GetPlayerNameEx(playerid));
			if(SANShows[channel][ChannelActive] == 1)
			{
				if(iLastCameraman[channel] == -1)
				{
					SetPVarInt(playerid, "iCameraman_Type", 1);
					cameraangle = 1;
					SAN_Process_Camera(playerid, channel);
				}
			    // TV Object is a part of the "TV Hotspots"-system. It basically creates a few objects at a few hotspots where people can do /watchtv. (They can do it inside any interior though).
				// TVObjects_Spawn();
 				// SendClientMessage(playerid, COLOR_LIGHTBLUE, "* You're now broadcasting LIVE.");
 				broadcasting = 1;
 				format(szMiscArray, sizeof(szMiscArray), "** %s has started the systems on Channel %i. **", GetPlayerNameEx(playerid), GetPVarInt(playerid, "ChannelID_FMEM"));
				SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "[SAN]: We will broadcast %s LIVE with %s on Channel %i. (( Use /shows to tune in! ))", SANShows[channel][ChannelName], SANShows[channel][Hosts], channel); // This announces the broadcast to all players.
                OOCNews(COLOR_NEWS,szMiscArray);
				if(!SANShows[channel][SANews3DText][0])
				{
					new Float:X, Float:Y;
					GetXYInFrontOfPlayer(playerid, X, Y, -1.0);
					SANShows[channel][SANews3DText][0] = CreateDynamic3DTextLabel(szMiscArray, COLOR_LIGHTBLUE, X, Y+0.5, CameramanFloats[channel][playerid][2],5.0);
				}
				UpdateSANewsBroadcast(channel);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "* No longer broadcasting");
				broadcasting = 0; // This makes sure we aren't broadcasting anymore.
				SANShows[channel][san_iRatings] = 0;
				UpdateSANewsBroadcast(channel);
				DestroyDynamic3DTextLabel(SANShows[channel][camera]);
				foreach(Player, i)
				{
					if(GetPVarType(i, "WatchingTV"))
					{
						Character_Actor(i, 1);
						SAN_HideTextDraws(i);
						SetPlayerVirtualWorld(i, BroadcastLastVW[i]);
						PlayerInfo[i][pVW] = BroadcastLastVW[i];
						SetPlayerInterior(i, BroadcastLastInt[i]);
						PlayerInfo[i][pInt] = BroadcastLastInt[i];
						SetPlayerFacingAngle(i, BroadcastFloats[i][0]);
						SetCameraBehindPlayer(i);
						TogglePlayerSpectating(i, 0);
						DeletePVar(i, "ChannelID");
						Player_StreamPrep(i, BroadcastFloats[i][1],BroadcastFloats[i][2],BroadcastFloats[i][3], FREEZE_TIME);
						DeletePVar(i, "WatchingTV");
						SendClientMessage(playerid, COLOR_GRAD1, "The show has been ended by the producers.");
						SendClientMessage(playerid, COLOR_GRAD1, "Fetching your character's old position...");
						SetTimerEx("SAN_SetPos", 5000, false, "i", i);
    				}
				}
			}
		}
	}
	return 1;
}



forward SAN_ListenRadio(playerid, channel);
public SAN_ListenRadio(playerid, channel)
{
	szMiscArray[0] = 0;
	if(!GetPVarType(playerid, "WatchingTV"))
	{
		if(GetPVarType(playerid, "ChannelID"))
		{
			if(GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot use this command while previewing a camera angle.");
			if(SANShows[channel][ChannelActive] == 0) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Nothing's on that TV Channel!"); // This makes sure that they can't do /watchtv when there's no one broadcasting.
			format(szMiscArray, sizeof(szMiscArray), "* %s tunes in to %s on [SAN] Channel %i", GetPlayerNameEx(playerid), SANShows[GetPVarInt(playerid, "ChannelID")][ChannelName], GetPVarInt(playerid, "ChannelID"));
			ProxDetector(20.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Type /shows again to stop listening to the radio broadcast.");
			SetPVarInt(playerid, "WatchingTV", 1);
						
			// Viewers
			SANShows[channel][san_iRatings]++;
			UpdateSANewsBroadcast(channel); // Updates the SANews3Dtext.
			
			format(szMiscArray, sizeof(szMiscArray), "[SAN Radio] presents %s, live on Channel %i.", SANShows[channel][Hosts], channel);
			SendClientMessage(playerid, COLOR_SANRADIO, szMiscArray);
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD1, "[SAN] Something went wrong. Please try again later.");
		}
	}
	else
	{
		format(szMiscArray, sizeof(szMiscArray), "* %s stops following %s on [SAN] Channel %i", GetPlayerNameEx(playerid), SANShows[GetPVarInt(playerid, "ChannelID")][ChannelName], GetPVarInt(playerid, "ChannelID"));
		ProxDetector(15.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		DeletePVar(playerid, "WatchingTV");
		DeletePVar(playerid, "ChannelID");
	}
	return 1;
}



forward SAN_WatchTV(playerid, channel);
public SAN_WatchTV(playerid, channel)
{
	szMiscArray[0] = 0;

	if(GetPVarType(playerid, "WatchingTV")) {
		SAN_StopWatching(playerid);
		return 1;
	}
	for(new i; i < MAX_HOUSES; ++i)
	{
		if(IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
		{
			if(GetPVarType(playerid, "ChannelID"))
			{
				if(GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot use this command while previewing a camera angle.");
				if(SANShows[channel][ChannelActive] == 0) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Nothing's on that TV Channel!"); // This makes sure that they can't do /watchtv when there's no one broadcasting.
				format(szMiscArray, sizeof(szMiscArray), "* %s starts watching TV.", GetPlayerNameEx(playerid));
				ProxDetector(15.0, playerid, szMiscArray, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Type /shows again to stop watching TV.");
				Character_Actor(playerid, 0);
				BroadcastLastVW[playerid] = GetPlayerVirtualWorld(playerid);
				BroadcastLastInt[playerid] = GetPlayerInterior(playerid);
				SetPVarInt(playerid, "SAN_INT", GetPlayerInterior(playerid));
				GetPlayerPos(playerid, BroadcastFloats[playerid][1], BroadcastFloats[playerid][2], BroadcastFloats[playerid][3]);
				GetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);
				SetPVarInt(playerid, "WatchingTV", 1);
							
				// Viewers
				SANShows[channel][san_iRatings]++;
				UpdateSANewsBroadcast(channel); // Updates the SANews3Dtext.
				
				format(szMiscArray, sizeof(szMiscArray), "[SAN Television] presents %s, live on Channel %i.", SANShows[channel][Hosts], channel);
				SendClientMessage(playerid, COLOR_ORANGE, szMiscArray);

				SAN_Process_WatchTV(playerid, channel);
				return 1;
			}
			else
			{
				SAN_StopWatching(playerid);
				return 1;
			}
		}
	}
	SendClientMessage(playerid, COLOR_GRAD1, "You must be in a house to watch television.");
	return 1;
}

SAN_StopWatching(playerid)
{
	szMiscArray[0] = 0;
	Character_Actor(playerid, 1);
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) TogglePlayerSpectating(playerid, 0);
	SAN_HideTextDraws(playerid);
	Player_StreamPrep(playerid, BroadcastFloats[playerid][1],BroadcastFloats[playerid][2],BroadcastFloats[playerid][3], FREEZE_TIME);
	SetPlayerVirtualWorld(playerid, BroadcastLastVW[playerid]);
	SetPlayerInterior(playerid, BroadcastLastInt[playerid]);
	SetPlayerInterior(playerid, GetPVarInt(playerid, "SAN_INT"));
	DeletePVar(playerid, "SAN_INT");
	SetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);
	SetCameraBehindPlayer(playerid);
	format(szMiscArray, sizeof(szMiscArray), "* %s stops following %s on [SAN] Channel %i", GetPlayerNameEx(playerid), SANShows[GetPVarInt(playerid, "ChannelID")][ChannelName], GetPVarInt(playerid, "ChannelID"));
	ProxDetector(15.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	DeletePVar(playerid, "WatchingTV");
	DeletePVar(playerid, "ChannelID");
	SendClientMessage(playerid, COLOR_GRAD1, "Fetching your character's old position...");
	SetTimerEx("SAN_SetPos", 5000, false, "i", playerid);
}

forward SAN_Process_WatchTV(playerid, channel);
public SAN_Process_WatchTV(playerid, channel)
{
	// Camera angles. They're constantly updated when someone's using /cameraman [choice]. (The "TextDrawHideForPlayer" is used so that the "Technical Difficulties" textdraw isn't displayed).
	TogglePlayerSpectating(playerid, 1);

	format(szMiscArray, sizeof(szMiscArray), "Channel %d", channel);
	TextDrawSetString(TV_text[6], szMiscArray);
	TextDrawSetString(TV_text[4], SANShows[GetPVarInt(playerid, "ChannelID")][ChannelName]);

	SAN_ShowTextDraws(playerid);	
	SetPlayerInterior(playerid, GetPVarInt(iLastCameraman[channel], "CameramanLastInt"));
	SetPlayerVirtualWorld(playerid, GetPVarInt(iLastCameraman[channel], "CameramanLastVW"));
	TogglePlayerControllable(playerid, 0);
	TextDrawHideForPlayer(playerid, TV_text[11]);
	TextDrawHideForPlayer(playerid, TV_text[12]);
	TextDrawHideForPlayer(playerid, TV_text[13]);
	SetTimerEx("SAN_Process_CameraAngle", 500, false, "ii", playerid, channel);
}


forward SAN_Process_CameraAngle(i, channel);
public SAN_Process_CameraAngle(i, channel)
{
	if(iLastCameraman[channel] == -1) cameraangle = 0;
	switch(cameraangle)
	{
		case 0:
		{
			SAN_ShowTextDraws(i);
		}
		case 1 .. 3:
		{
			SetPlayerPos(i, CameramanFloats[channel][iLastCameraman[channel]][0], CameramanFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2]-15.0); // Teleports the player 15 meters under the cameraman (in the ground, invisible).
		}
		case 4:
		{
			SetPlayerPos(i, ICCameramanFloats[channel][iLastCameraman[channel]][3], ICCameramanFloats[channel][iLastCameraman[channel]][4], ICCameramanFloats[channel][iLastCameraman[channel]][5]-15.0); // Teleports the player 15 meters under the cameraman (in the ground, invisible).		
		}
		case 5:
		{
			SetPlayerPos(i, CameramanFloats[channel][iLastCameraman[channel]][0], CameramanFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2]-15.0); // Teleports the player 15 meters under the cameraman (in the ground, invisible).		
		}
	}
	switch(cameraangle)
	{
		case 0:
		{
			SetPlayerCameraPos(i, 735.4360, -1392.6974, 13.6314);
			SetPlayerCameraLookAt(i, 734.8319, -1391.8953, 13.7662);		
		}
		case 1:
		{
			SetPlayerCameraPos(i, CameramanFloats[channel][iLastCameraman[channel]][0], CameramanFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2]);
			SetPlayerCameraLookAt(i, CameramanFloats[channel][iLastCameraman[channel]][0]+CameramanFVFloats[channel][iLastCameraman[channel]][0],  CameramanFloats[channel][iLastCameraman[channel]][1]+CameramanFVFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2]+CameramanFVFloats[channel][iLastCameraman[channel]][2]);
		
		}
		case 2:
		{
			InterpolateCameraPos(i, CameramanFloats[channel][iLastCameraman[channel]][0]-10.0,
			CameramanFloats[channel][iLastCameraman[channel]][1], 
			CameramanFloats[channel][iLastCameraman[channel]][2]+30.0, 
			CameramanFloats[channel][iLastCameraman[channel]][0]-5.0, 
			CameramanFloats[channel][iLastCameraman[channel]][1], 
			CameramanFloats[channel][iLastCameraman[channel]][2]+20.0, 10000, CAMERA_MOVE);
			InterpolateCameraLookAt(i, CameramanFloats[channel][iLastCameraman[channel]][0]+CameramanFloats[channel][iLastCameraman[channel]][0],
			CameramanFloats[channel][iLastCameraman[channel]][1]+CameramanFloats[channel][iLastCameraman[channel]][1],
			CameramanFloats[channel][iLastCameraman[channel]][2]+CameramanFloats[channel][iLastCameraman[channel]][2],
			CameramanFloats[channel][iLastCameraman[channel]][0]+CameramanFloats[channel][iLastCameraman[channel]][0],
			CameramanFloats[channel][iLastCameraman[channel]][1]+CameramanFloats[channel][iLastCameraman[channel]][1],
			CameramanFloats[channel][iLastCameraman[channel]][2]+CameramanFloats[channel][iLastCameraman[channel]][2], 10000, CAMERA_MOVE);		
		}
		case 3:
		{
			SetPlayerCameraPos(i, CameramanFloats[channel][iLastCameraman[channel]][0], CameramanFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2]);
			SetPlayerCameraLookAt(i, CameramanFloats[channel][iLastCameraman[channel]][0]+CameramanFVFloats[channel][iLastCameraman[channel]][0], CameramanFloats[channel][iLastCameraman[channel]][1]+CameramanFVFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2]+CameramanFVFloats[channel][iLastCameraman[channel]][2]);		
		}
		case 4:
		{
			InterpolateCameraPos(i, ICCameramanFloats[channel][iLastCameraman[channel]][0], ICCameramanFloats[channel][iLastCameraman[channel]][1], ICCameramanFloats[channel][iLastCameraman[channel]][2], ICCameramanFloats[channel][iLastCameraman[channel]][3], ICCameramanFloats[channel][iLastCameraman[channel]][4], ICCameramanFloats[channel][iLastCameraman[channel]][5], 10000, CAMERA_MOVE);
			InterpolateCameraLookAt(i, ICCameramanFloats[channel][iLastCameraman[channel]][0]+ICCameramanFVFloats[channel][iLastCameraman[channel]][0],
			ICCameramanFloats[channel][iLastCameraman[channel]][1]+ICCameramanFVFloats[channel][iLastCameraman[channel]][1],
			ICCameramanFloats[channel][iLastCameraman[channel]][2]+ICCameramanFVFloats[channel][iLastCameraman[channel]][2],
			ICCameramanFloats[channel][iLastCameraman[channel]][3]+ICCameramanFVFloats[channel][iLastCameraman[channel]][3],
			ICCameramanFloats[channel][iLastCameraman[channel]][4]+ICCameramanFVFloats[channel][iLastCameraman[channel]][4],
			ICCameramanFloats[channel][iLastCameraman[channel]][5]+ICCameramanFVFloats[channel][iLastCameraman[channel]][5], 10000, CAMERA_MOVE);
		}
		case 5:
		{
			SetPlayerCameraPos(i, CameramanFloats[channel][iLastCameraman[channel]][0], CameramanFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2]);
			SetPlayerCameraLookAt(i, CameramanFloats[channel][iLastCameraman[channel]][0]+CameramanFVFloats[channel][iLastCameraman[channel]][0],  CameramanFloats[channel][iLastCameraman[channel]][1]+CameramanFVFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2]+CameramanFVFloats[channel][iLastCameraman[channel]][2]);

		}
		case 6 .. 7:
		{
			PlayerSpectateVehicle(i, GetPVarInt(iLastCameraman[channel], "SAN_iVehCam"), SPECTATE_MODE_SIDE);
		}
	}
}

forward SAN_ShowTextDraws(playerid);
public SAN_ShowTextDraws(playerid)
{
	TextDrawShowForPlayer(playerid, TV_text[0]);
	TextDrawShowForPlayer(playerid, TV_text[1]);
	TextDrawShowForPlayer(playerid, TV_text[2]);
	TextDrawShowForPlayer(playerid, TV_text[3]);
	TextDrawShowForPlayer(playerid, TV_text[4]);
	TextDrawShowForPlayer(playerid, TV_text[5]);
	TextDrawShowForPlayer(playerid, TV_text[6]);
	TextDrawShowForPlayer(playerid, TV_text[7]);
	TextDrawShowForPlayer(playerid, TV_text[8]);
	TextDrawShowForPlayer(playerid, TV_text[9]);
	TextDrawShowForPlayer(playerid, TV_text[10]);

	if(cameraangle == 0)
	{
		TextDrawShowForPlayer(playerid, TV_text[11]);
		TextDrawShowForPlayer(playerid, TV_text[12]);
		TextDrawShowForPlayer(playerid, TV_text[13]);
	}
}

forward SAN_HideTextDraws(playerid);
public SAN_HideTextDraws(playerid)
{
	TextDrawHideForPlayer(playerid, TV_text[0]);
	TextDrawHideForPlayer(playerid, TV_text[1]);
	TextDrawHideForPlayer(playerid, TV_text[2]);
	TextDrawHideForPlayer(playerid, TV_text[3]);
	TextDrawHideForPlayer(playerid, TV_text[4]);
	TextDrawHideForPlayer(playerid, TV_text[5]);
	TextDrawHideForPlayer(playerid, TV_text[6]);
	TextDrawHideForPlayer(playerid, TV_text[7]);
	TextDrawHideForPlayer(playerid, TV_text[8]);
	TextDrawHideForPlayer(playerid, TV_text[9]);
	TextDrawHideForPlayer(playerid, TV_text[10]);
	TextDrawHideForPlayer(playerid, TV_text[11]);
	TextDrawHideForPlayer(playerid, TV_text[12]);
	TextDrawHideForPlayer(playerid, TV_text[13]);
}


forward SAN_Process_Login(playerid);
public SAN_Process_Login(playerid)
{
	if(!GetPVarType(playerid, "ChannelID_FMEM"))
	{
		format(szMiscArray, sizeof(szMiscArray), "___________________________ {32CD80} SAN | LOGIN {FFFFFF}____________________\nClick Here to log in to a channel.");
		ShowPlayerDialogEx(playerid, DIALOG_SAN_LOGIN, DIALOG_STYLE_LIST, "SAN | Channel Login Panel", szMiscArray, "Select", "Cancel");
		return 0;
	}
	return 1;
}


forward SAN_Process_Logout(playerid);
public SAN_Process_Logout(playerid)
{
	szMiscArray[0] = 0;
	if(GetPVarType(playerid, "ChannelID_FMEM"))
	{
		
		format(szMiscArray, sizeof(szMiscArray), "** %s signed out from Channel %i. **", GetPlayerNameEx(playerid), GetPVarInt(playerid, "ChannelID_FMEM"));
		SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
		DeletePVar(playerid, "ChannelID");
		DeletePVar(playerid, "ChannelID_FMEM");
		DeletePVar(playerid, "iCameraman_Type");
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "You are not signed into a channel.");
	}
}



forward SAN_Process_ListCameras(playerid, channel);
public SAN_Process_ListCameras(playerid, channel)
{
	szMiscArray[0] = 0;
	new szTitle[32];
	foreach(Player, i)
	{
		if(GetPVarInt(i, "ChannelID_FMEM") == GetPVarInt(playerid, "ChannelID_FMEM"))
		{
			if(CameramanFloats[GetPVarInt(i, "ChannelID_FMEM")][i][1] != 0.0 || ICCameramanFloats[GetPVarInt(i, "ChannelID_FMEM")][i][0] != 0.0 && ICCameramanFloats[GetPVarInt(i, "ChannelID_FMEM")][i][3] != 0.0)
			{
				switch(GetPVarInt(i, "iCameraman_Type"))
				{
					case 1:
					{
						format(szMiscArray, sizeof(szMiscArray), "%s Name: %s || {FFFF99}STATIC\n", szMiscArray, GetPlayerNameEx(i));
					}
					case 2:
					{
						format(szMiscArray, sizeof(szMiscArray), "%s Name: %s || {CCFFCC}DYNAMIC{FFFFFF}\n", szMiscArray, GetPlayerNameEx(i));
					}
					case 3:
					{
						format(szMiscArray, sizeof(szMiscArray), "%s Name: %s || {BBEEFF}VEHICLE{FFFFFF}\n", szMiscArray, GetPlayerNameEx(i));
					}
				}
			}
			if(i == iLastCameraman[channel])
			{
				format(szMiscArray, sizeof(szMiscArray), "%s Name: %s || {4C4CFF}BROADCASTING\n", szMiscArray, GetPlayerNameEx(i));
			}
			ListItemTrackID_Cameras[playerid][GetPVarInt(playerid, "ListItemID_Cameras")] = i;
			SetPVarInt(playerid, "ListItemID_Cameras", GetPVarInt(playerid, "ListItemID_Cameras") + 1);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
		}
	}
	if(!isnull(szMiscArray))
	{
		format(szTitle, sizeof(szTitle), "SAN | Camera List | Channel %i", GetPVarInt(playerid, "ChannelID_FMEM"));
		ShowPlayerDialogEx(playerid, DIALOG_SAN_CAMLIST, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "Cancel");
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "There are no active camera's right now.");
	return 1;
}


forward SAN_Process_Cameraman(playerid, choice, channel);
public SAN_Process_Cameraman(playerid, choice, channel)
{
	szMiscArray[0] = 0;
	switch(choice)
	{
		case SAN_CAMERAMAN_SET:
		{
			if(GetPVarInt(playerid, "WatchingTV") == 1) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot set an angle when you are already watching the TV.");
			TogglePlayerControllable(playerid, 0);
			if(!GetPVarType(playerid, "PreviewingTV"))
			{
				GetPlayerPos(playerid, CameramanFloats[channel][playerid][0], CameramanFloats[channel][playerid][1], CameramanFloats[channel][playerid][2]);
				GetPlayerCameraFrontVector(playerid,CameramanFVFloats[channel][playerid][0], CameramanFVFloats[channel][playerid][1], CameramanFVFloats[channel][playerid][2]);
			}
			SetPlayerCameraPos(playerid, CameramanFloats[channel][playerid][0], CameramanFloats[channel][playerid][1], CameramanFloats[channel][playerid][2]);
			SetPlayerCameraLookAt(playerid, CameramanFloats[channel][playerid][0]+CameramanFVFloats[channel][playerid][0],  CameramanFloats[channel][playerid][1]+CameramanFVFloats[channel][playerid][1], CameramanFloats[channel][playerid][2]+CameramanFVFloats[channel][playerid][2]);
			SetPVarInt(playerid, "PreviewingTV", 1);
			cameraangle = 1;			
			GetPlayerPos(playerid, BroadcastFloats[playerid][1], BroadcastFloats[playerid][2], BroadcastFloats[playerid][3]);
			BroadcastLastVW[playerid] = GetPlayerVirtualWorld(playerid);
			BroadcastLastInt[playerid] = GetPlayerInterior(playerid);
			GetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);
			SAN_ShowTextDraws(playerid);
			SetPVarInt(playerid, "iCameraman_Type", 1);
			format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] Cameraman %s is setting the camera angle... **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid));
			SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Use 'N' to cancel. Use -- '/cameraman' -> Broadcast -- to broadcast the current angle.");
		}
		case SAN_CAMERAMAN_PREVIEW:
		{
			if(iLastCameraman[channel] == -1)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "* There is no cameraman active.");
				return 1;
			}
			playerid = iLastCameraman[channel];
			// SAN_Process_StartPreview(playerid, iLastCameraman[channel]);
			SetPVarInt(playerid, "PreviewingTV", 1);
			SetPlayerCameraPos(playerid, CameramanFloats[channel][playerid][0], CameramanFloats[channel][playerid][1], CameramanFloats[channel][playerid][2]);
			SetPlayerCameraLookAt(playerid, CameramanFVFloats[channel][playerid][0], CameramanFVFloats[channel][playerid][1], CameramanFVFloats[channel][playerid][2]);
		}
		case SAN_CAMERAMAN_STOP:
		{
			if(GetPVarType(playerid, "PreviewingTV"))
			{
				SAN_Process_StopPreview(playerid);
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "You were not previewing a camera angle.");
		}
		case SAN_CAMERAMAN_BROADCAST:
		{
			if(GetPVarType(playerid, "WatchingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot set an angle when you are already watching the TV.");
			// SAN_CreateCamera(playerid, channel);
			iLastCameraman[channel] = playerid;
			SANShows[channel][san_iVehicleID] = 0;
			cameraangle = 1;
			SetPVarInt(playerid, "iCameraman_Type", 1);
			format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] %s is broadcasting his/her camera angle. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid));
			SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
			SAN_Process_Camera(playerid, channel);
			SAN_Process_StopPreview(playerid);
		}
		case SAN_CAMERAMAN_BIRDSEYE:
		{
			SANShows[channel][san_iVehicleID] = 0;
			SetPVarInt(playerid, "iCameraman_Type", 4);
			format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] %s changes the camera angle to the 'Bird's Eye' view. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid));
			SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
			cameraangle = 2;
			SAN_Process_Camera(playerid, channel);
		}
		case SAN_CAMERAMAN_VEHICLE: // Nifty stuff here: The camera is set on the wing/foot of the aircraft. I used the spectate function, and it's working brilliantly (it's really smooth).
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				iLastCameraman[channel] = playerid;
				SetPVarInt(iLastCameraman[channel], "SAN_iVehCam", GetPlayerVehicleID(playerid));
				SetPVarInt(playerid, "iCameraman_Type", 3);
				SendClientMessage(playerid, 0xFFFFFFAA, "Your camera is now attached to the vehicle.");
				SANShows[channel][san_iVehicleID] = 1;
				cameraangle = 7;
				format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] %s is broadcasting from the &s  **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid), GetVehicleName(GetVehicleModel(GetPVarInt(iLastCameraman[channel], "SAN_iVehCam"))));
				SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
				SAN_Process_Camera(playerid, channel);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "* You must be in a vehicle to use this command!");
				return 1;
			}
		}
		case SAN_CAMERAMAN_LOGOUT: // THE QUIT FUNCTION (GET DATA).
		{
			SAN_Process_Logout(playerid);
		}
		case SAN_CAMERAMAN_SETPOINTA: // This allows the cameraman to preview POINT A of the interpolate-camera function.
		{
			if(GetPVarType(playerid, "WatchingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot set an angle when you are already watching the TV.");
			if(GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You are already previewing the camera angle.");
			GetPlayerPos(playerid, BroadcastFloats[playerid][1], BroadcastFloats[playerid][2], BroadcastFloats[playerid][3]);
			BroadcastLastVW[playerid] = GetPlayerVirtualWorld(playerid);
			BroadcastLastInt[playerid] = GetPlayerInterior(playerid);
			GetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);
			SetPVarInt(playerid, "PreviewingTV", 1);
			SetPVarInt(playerid, "iCameraman_Type", 2);
			SetPVarInt(playerid, "ICamPointA", 1);
			TogglePlayerControllable(playerid, 0);
			GetPlayerPos(playerid,ICCameramanFloats[channel][playerid][0], ICCameramanFloats[channel][playerid][1], ICCameramanFloats[channel][playerid][2]);
			GetPlayerCameraFrontVector(playerid, ICCameramanFVFloats[channel][playerid][0], ICCameramanFVFloats[channel][playerid][1], ICCameramanFVFloats[channel][playerid][2]);
			SetPlayerCameraPos(playerid, ICCameramanFloats[channel][playerid][0], ICCameramanFloats[channel][playerid][1], ICCameramanFloats[channel][playerid][2]);
			SetPlayerCameraLookAt(playerid, ICCameramanFloats[channel][playerid][0]+ICCameramanFVFloats[channel][playerid][0],  ICCameramanFloats[channel][playerid][1]+ICCameramanFVFloats[channel][playerid][1], ICCameramanFloats[channel][playerid][2]+ICCameramanFVFloats[channel][playerid][2]);
			SAN_ShowTextDraws(playerid);
		}
		case SAN_CAMERAMAN_POINTA:
		{
			if(GetPVarType(playerid, "WatchingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot set an angle when you are already watching the TV.");
			SetPVarInt(playerid, "iCameraman_Type", 2);
			if(!GetPVarType(playerid, "PreviewingTV"))
			{
				GetPlayerPos(playerid,ICCameramanFloats[channel][playerid][0], ICCameramanFloats[channel][playerid][1], ICCameramanFloats[channel][playerid][2]);
				GetPlayerCameraFrontVector(playerid, ICCameramanFVFloats[channel][playerid][0], ICCameramanFVFloats[channel][playerid][1], ICCameramanFVFloats[channel][playerid][2]);
			}
			format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] %s has set the first interpolate of the camera angle. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid));
			SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
			SAN_Process_StopPreview(playerid);
		}
		case SAN_CAMERAMAN_SETPOINTB:
		{
			if(GetPVarType(playerid, "WatchingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot set an angle when you are already watching the TV.");
			if(GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You are already previewing the camera angle.");
			GetPlayerPos(playerid, BroadcastFloats[playerid][1], BroadcastFloats[playerid][2], BroadcastFloats[playerid][3]);
			BroadcastLastVW[playerid] = GetPlayerVirtualWorld(playerid);
			BroadcastLastInt[playerid] = GetPlayerInterior(playerid);
			GetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);
			SetPVarInt(playerid, "iCameraman_Type", 2);
			SetPVarInt(playerid, "PreviewingTV", 1);
			TogglePlayerControllable(playerid, 0);
			GetPlayerPos(playerid,ICCameramanFloats[channel][playerid][3], ICCameramanFloats[channel][playerid][4], ICCameramanFloats[channel][playerid][5]);
			GetPlayerCameraFrontVector(playerid, ICCameramanFVFloats[channel][playerid][3], ICCameramanFVFloats[channel][playerid][4], ICCameramanFVFloats[channel][playerid][5]);
			SetPlayerCameraPos(playerid, ICCameramanFloats[channel][playerid][3], ICCameramanFloats[channel][playerid][4], ICCameramanFloats[channel][playerid][5]);
			SetPlayerCameraLookAt(playerid, ICCameramanFloats[channel][playerid][3]+ICCameramanFVFloats[channel][playerid][3], ICCameramanFloats[channel][playerid][4]+ICCameramanFVFloats[channel][playerid][4], ICCameramanFloats[channel][playerid][5]+ICCameramanFVFloats[channel][playerid][5]);
			SAN_ShowTextDraws(playerid);
		}
		case SAN_CAMERAMAN_POINTB: // This allows the cameraman to finish POINT B of the interpolate-camera function and store the data for the players using /watchtv.
		{
			if(GetPVarType(playerid, "WatchingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot set an angle when you are already watching the TV.");
			SetPVarInt(playerid, "iCameraman_Type", 2);
			if(!GetPVarType(playerid, "PreviewingTV"))
			{
				GetPlayerPos(playerid,ICCameramanFloats[channel][playerid][3], ICCameramanFloats[channel][playerid][4], ICCameramanFloats[channel][playerid][5]);
				GetPlayerCameraFrontVector(playerid, ICCameramanFVFloats[channel][playerid][3], ICCameramanFVFloats[channel][playerid][4], ICCameramanFVFloats[channel][playerid][5]);
			}
			format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] %s has set the last interpolate of the camera angle. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid));
			SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
			SAN_Process_StopPreview(playerid);
		}
		case SAN_CAMERAMAN_PINTERPOLATE: // The camerman can preview his interpolate settings.
		{
			if(GetPVarType(playerid, "WatchingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot set an angle when you are already watching the TV.");
			if(GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You are already previewing the camera angle.");
			GetPlayerPos(playerid, BroadcastFloats[playerid][1], BroadcastFloats[playerid][2], BroadcastFloats[playerid][3]);
			BroadcastLastVW[playerid] = GetPlayerVirtualWorld(playerid);
			BroadcastLastInt[playerid] = GetPlayerInterior(playerid);
			GetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);
			
			InterpolateCameraPos(playerid, ICCameramanFloats[channel][playerid][0], 
			ICCameramanFloats[channel][playerid][1], ICCameramanFloats[channel][playerid][2], 
			ICCameramanFloats[channel][playerid][3], ICCameramanFloats[channel][playerid][4], 
			ICCameramanFloats[channel][playerid][5], 10000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, ICCameramanFloats[channel][playerid][0]+ICCameramanFVFloats[channel][playerid][0],  
			ICCameramanFloats[channel][playerid][1]+ICCameramanFVFloats[channel][playerid][1], 
			ICCameramanFloats[channel][playerid][2]+ICCameramanFVFloats[channel][playerid][2], 
			ICCameramanFloats[channel][playerid][3]+ICCameramanFVFloats[channel][playerid][3], 
			ICCameramanFloats[channel][playerid][4]+ICCameramanFVFloats[channel][playerid][4], 
			ICCameramanFloats[channel][playerid][5]+ICCameramanFVFloats[channel][playerid][5], 10000, CAMERA_MOVE);
			
			SetPVarInt(playerid, "PreviewingTV", 1);
			TogglePlayerControllable(playerid, 0);
			SAN_ShowTextDraws(playerid);
		}
		case SAN_CAMERAMAN_INTERPOLATE: // This will finalize the interpolate-camera settings of the cameraman, and stream it to the broadcast (the players using /watchtv).
		{
			if(ICCameramanFloats[channel][playerid][0] == 0.0 || ICCameramanFloats[channel][playerid][3] == 0.0) return SendClientMessage(playerid, COLOR_GRAD1, "To broadcast, you must set up point A and B first.");
			SetPVarInt(playerid, "iCameraman_Type", 2);
			SANShows[channel][san_iVehicleID] = 0;
			cameraangle = 4;
			format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] %s is broadcasting the dynamic (point A-B / interpolate) camera. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid));
			SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
			if(GetPVarType(playerid, "PreviewingTV")) SAN_Process_StopPreview(playerid);
			SAN_Process_Camera(playerid, channel);
		}
	}
	return 1;
}

/*
SAN_CreateCamera(playerid, channel)
{
	new Float:X, Float:Y, Float:Z, Float:R;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, R);			
	GetXYInFrontOfPlayer(playerid, X, Y, -1.5);
	for(new i; i < MAX_SANCAMERAS; ++i)
	{
		if(!IsValidDynamicObject(SANShows[channel][iCameraObject][i]))
		{
			SANShows[channel][iCameraObject][i] = CreateDynamicObject(18654, X, Y, Z-2.25,   0.00000, 35.00000, 90-R);
			return 1;
		}
	}
	for(new i; i < 6; ++i) DestroyDynamicObject(SANShows[channel][iCameraObject][i]);
	return SendClientMessage(playerid, COLOR_GRAD1, "The maximum spawned cameras has been reached. The server cleaned up 6 SAN cameras.");
}
*/

forward SAN_Process_Director(playerid, choice, channel);
public SAN_Process_Director(playerid, choice, channel)
{
	szMiscArray[0] = 0;
	switch(choice)
	{
		case SAN_DIRECTOR_PREVIEW:
		{
			if(iLastCameraman[channel] == -1)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "* There is no cameraman active.");
				return 1;
			}
			SAN_Process_StartPreview(playerid, iLastCameraman[channel]);
		}
		case SAN_DIRECTOR_STOP:
		{
			if(GetPVarType(playerid, "PreviewingTV"))
			{
				if(iLastCameraman[channel] == -1) SendClientMessage(playerid, COLOR_LIGHTBLUE, "* There is no cameraman active.");
				SAN_Process_StopPreview(playerid);
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "You were not previewing a camera angle.");
		}
		case SAN_DIRECTOR_PSTREAM:
		{
			ShowPlayerDialogEx(playerid, DIALOG_SAN_PSTREAM, DIALOG_STYLE_INPUT, "SAN | Preview Stream", "Paste the link of the stream here.", "Listen", "Cancel");
		}
		case SAN_DIRECTOR_BROADCAST:
		{
			SAN_Process_ListCameras(playerid, GetPVarInt(playerid, "ChannelID_FMEM"));		
		}
		case SAN_DIRECTOR_BIRDSEYE:
		{
			if(GetPlayerInterior(iLastCameraman[channel]) == 0)
			{
				if(iLastCameraman[channel] == -1) SendClientMessage(playerid, COLOR_LIGHTBLUE, "* There is no cameraman active.");
				format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] Broadcast Director %s changes the camera angle to the 'Bird's Eye' angle. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid));
				SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
				SANShows[channel][san_iVehicleID] = 0;
				cameraangle = 2;
				DestroyDynamic3DTextLabel(SANShows[channel][camera]);
				SANShows[channel][camera] = CreateDynamic3DTextLabel("*The Camera*",COLOR_RED,CameramanFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2],15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
				SAN_Process_Camera(iLastCameraman[channel], channel);
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "This camera angle can only be used outside.");
		}
		case SAN_DIRECTOR_INTERPOLATE:
		{
			if(ICCameramanFloats[channel][iLastCameraman[channel]][0] != 0.0)
			{
				format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] Broadcast Director %s is broadcasting the point-to-point camera. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid));
				SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
				SANShows[channel][san_iVehicleID] = 0;
				cameraangle = 4;
				DestroyDynamic3DTextLabel(SANShows[channel][camera]);
				SANShows[channel][camera] = CreateDynamic3DTextLabel("*The Camera*",COLOR_RED,ICCameramanFloats[channel][iLastCameraman[channel]][1],ICCameramanFloats[channel][iLastCameraman[channel]][2],ICCameramanFloats[channel][iLastCameraman[channel]][3],15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
				SAN_Process_Camera(iLastCameraman[channel], channel);
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "No one set up a point-to-point camera yet.");
		}
		case SAN_DIRECTOR_VEHICLE:
		{
			if(SANShows[channel][san_iVehicleID] == 0) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* There is no vehicle camera active!");
			format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] %s: The camera is now broadcasting from the %s. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid), GetVehicleName(GetPVarInt(iLastCameraman[channel], "SAN_iVehCam")));
			SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
			cameraangle = 7;
			SANShows[channel][san_iVehicleID] = 1;
			SAN_Process_Camera(iLastCameraman[channel], channel);
		}
		case SAN_DIRECTOR_BSTREAM:
		{
			ShowPlayerDialogEx(playerid, DIALOG_SAN_BSTREAM, DIALOG_STYLE_INPUT, "SAN | Preview Stream", "Paste the link of the stream here.", "Listen", "Cancel");
		}
		case SAN_DIRECTOR_STARTCAM:
		{
			SAN_HideTextDraws(playerid);
			cameraangle = 1;
			SANShows[channel][san_iVehicleID] = 0;
			broadcasting = 1;
			SANShows[channel][ChannelActive] = 1;
			format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] %s has started all current cameras. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid));
			SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "The TV is now back on air. Use '/cameraangle cameraman' to start setting a camera position.");
			TextDrawHideForAll(TV_text[11]);
			TextDrawHideForAll(TV_text[12]);
			TextDrawHideForAll(TV_text[13]);
			SAN_Process_Camera(iLastCameraman[channel], channel);
		}
		case SAN_DIRECTOR_STOPCAM:
		{
			cameraangle = -1;
			SANShows[channel][san_iVehicleID] = INVALID_VEHICLE_ID;
			format(szMiscArray, sizeof(szMiscArray), "** [CH. %i] %s has stopped the broadcast. **", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid));
			SAN_SendRadioMessage(playerid, RADIO, szMiscArray);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Broadcasting has just been shutdown..");
			broadcasting = 0;
			SANShows[channel][ChannelActive] = 0;
			for(new ichannel; ichannel < MAX_SANCHANNELS; ++ichannel)
			{
				UpdateSANewsBroadcast(ichannel);
				DestroyDynamic3DTextLabel(SANShows[ichannel][camera]);
			}
			foreach(Player, i)
			{
				SAN_Stop(i);
			}
			// SAN_ShowTextDraws(playerid);
			// SAN_Process_Camera(iLastCameraman[channel], channel);
		}
		case SAN_DIRECTOR_LOGOUT:
		{
			SAN_Process_Logout(playerid);
		}
	}
	return 1;
}


SAN_Process_StartPreview(playerid, giveplayerid)
{
	szMiscArray[0] = 0;
	if(GetPVarType(playerid, "WatchingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot preview an angle when you are already watching the TV.");
	if(GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You are already previewing a camera angle.");
	BroadcastLastVW[playerid] = GetPlayerVirtualWorld(playerid);
	BroadcastLastInt[playerid] = GetPlayerInterior(playerid);
	SetPVarInt(playerid, "PreviewingTV", 1);
	format(szMiscArray, sizeof(szMiscArray), "You are viewing %s's camera angle.", GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
	GetPlayerPos(playerid, BroadcastFloats[playerid][1], BroadcastFloats[playerid][2], BroadcastFloats[playerid][3]);
	GetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Use 'N' to cancel. Use -- '/bdirector' or '/cameraman' -> Broadcast -- to broadcast the current angle.");
	SAN_ShowTextDraws(playerid);
	DeletePVar(playerid, "ListItemID_Cameras");
	TogglePlayerControllable(playerid, 0);
	TogglePlayerSpectating(playerid, 1);
	SetTimerEx("SAN_Process_StartPreview2", 500, false, "ii", playerid, giveplayerid);
	return 1;	
}

forward SAN_Process_StartPreview2(playerid, giveplayerid);
public SAN_Process_StartPreview2(playerid, giveplayerid)
{
	new channel = GetPVarInt(giveplayerid, "ChannelID_FMEM");
	switch(GetPVarInt(giveplayerid, "iCameraman_Type"))
	{
		case 1:
		{
			SetPlayerPos(playerid, CameramanFloats[channel][giveplayerid][0], CameramanFloats[channel][giveplayerid][1], CameramanFloats[channel][giveplayerid][2]-15);
			SetPlayerCameraPos(playerid, CameramanFloats[channel][giveplayerid][0], CameramanFloats[channel][giveplayerid][1], CameramanFloats[channel][giveplayerid][2]);
			SetPlayerCameraLookAt(playerid, CameramanFloats[channel][giveplayerid][0]+CameramanFVFloats[channel][giveplayerid][0],  CameramanFloats[channel][giveplayerid][1]+CameramanFVFloats[channel][giveplayerid][1], CameramanFloats[channel][giveplayerid][2]+CameramanFVFloats[channel][giveplayerid][2]);
		}
		case 2:
		{
			SetPlayerPos(playerid, ICCameramanFloats[channel][giveplayerid][0], ICCameramanFloats[channel][giveplayerid][1], ICCameramanFloats[channel][giveplayerid][2]-15);
			InterpolateCameraPos(playerid, ICCameramanFloats[channel][giveplayerid][0],
			ICCameramanFloats[channel][giveplayerid][1],
			ICCameramanFloats[channel][giveplayerid][2],
			ICCameramanFloats[channel][giveplayerid][3],
			ICCameramanFloats[channel][giveplayerid][4],
			ICCameramanFloats[channel][giveplayerid][5], 10000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, ICCameramanFloats[channel][giveplayerid][0]+ICCameramanFVFloats[channel][giveplayerid][0],
			ICCameramanFloats[channel][giveplayerid][1]+ICCameramanFVFloats[channel][giveplayerid][1],
			ICCameramanFloats[channel][giveplayerid][2]+ICCameramanFVFloats[channel][giveplayerid][2],
			ICCameramanFloats[channel][giveplayerid][3]+ICCameramanFVFloats[channel][giveplayerid][3],
			ICCameramanFloats[channel][giveplayerid][4]+ICCameramanFVFloats[channel][giveplayerid][4],
			ICCameramanFloats[channel][giveplayerid][5]+ICCameramanFVFloats[channel][giveplayerid][5], 10000, CAMERA_MOVE);		
		}
		case 3:
		{
			PlayerSpectateVehicle(playerid, GetPVarInt(iLastCameraman[channel], "SAN_iVehCam"), SPECTATE_MODE_SIDE);
		}
	}
	return 1;
}

forward SAN_Process_StopPreview(playerid);
public SAN_Process_StopPreview(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) TogglePlayerSpectating(playerid, 0);
	if(GetPVarType(playerid, "PreviewingTV"))
	{
		SAN_HideTextDraws(playerid);
		DeletePVar(playerid, "ICamPointA");
		Player_StreamPrep(playerid, BroadcastFloats[playerid][1],BroadcastFloats[playerid][2],BroadcastFloats[playerid][3], FREEZE_TIME);
		SetPlayerVirtualWorld(playerid, BroadcastLastVW[playerid]);
		SetPlayerInterior(playerid, BroadcastLastInt[playerid]);
		SetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);
		SetCameraBehindPlayer(playerid);
		DeletePVar(playerid, "PreviewingTV");
	}
}


forward SAN_Process_Camera(playerid, channel);
public SAN_Process_Camera(playerid, channel)
{
	szMiscArray[0] = 0;
	iLastCameraman[channel] = playerid;
	if(GetPVarInt(playerid, "ListItemID_Cameras") != playerid)
	{
		if(GetPVarType(playerid, "PreviewingTV"))
		{
			SAN_HideTextDraws(playerid);
			DeletePVar(playerid, "ICamPointA");
			SetPlayerPos(playerid,BroadcastFloats[playerid][1],BroadcastFloats[playerid][2],BroadcastFloats[playerid][3]);
			Player_StreamPrep(playerid, BroadcastFloats[playerid][1],BroadcastFloats[playerid][2],BroadcastFloats[playerid][3], FREEZE_TIME);
			SetPlayerVirtualWorld(playerid, BroadcastLastVW[playerid]);
			SetPlayerInterior(playerid, BroadcastLastInt[playerid]);
			SetPlayerFacingAngle(playerid, BroadcastFloats[playerid][0]);
			SetCameraBehindPlayer(playerid);
			DeletePVar(playerid, "PreviewingTV");
		}
	}
	if(!GetPVarType(playerid, "ListItemID_Cameras"))
	{
		GetPlayerPos(playerid, CameramanFloats[channel][iLastCameraman[channel]][0], CameramanFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2]);
		GetPlayerCameraFrontVector(playerid, CameramanFVFloats[channel][iLastCameraman[channel]][0], CameramanFVFloats[channel][iLastCameraman[channel]][1], CameramanFVFloats[channel][iLastCameraman[channel]][2]);
		SetPVarInt(playerid, "CameramanLastInt", GetPlayerInterior(playerid));
		SetPVarInt(playerid, "CameramanLastVW", GetPlayerVirtualWorld(playerid));
	}
	
	if(cameraangle == 6 || cameraangle == 7) SetPVarInt(iLastCameraman[channel], "SAN_iVehCam", GetPlayerVehicleID(playerid));
	
	DeletePVar(playerid, "ListItemID_Cameras");
	format(szMiscArray, sizeof(szMiscArray), "*SAN | Camera*\n {FFFFFF}Channel: %i\nOperator: %s", channel, GetPlayerNameEx(iLastCameraman[channel]));
	DestroyDynamic3DTextLabel(SANShows[channel][camera]);
	SANShows[channel][camera] = CreateDynamic3DTextLabel(szMiscArray, COLOR_NEWS, CameramanFloats[channel][iLastCameraman[channel]][0], CameramanFloats[channel][iLastCameraman[channel]][1], CameramanFloats[channel][iLastCameraman[channel]][2],15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	// SAN_Create_Camera(playerid, 1);
	
	foreach(Player,i)
	{
		if(GetPVarType(i, "WatchingTV"))
		{
			if(GetPVarInt(i, "ChannelID") == channel)
			{
				SAN_Process_CameraAngle(i, channel);
			}
		}
	}
	return 1;
}

UpdateSANewsBroadcast(channel, ishutdown = 0)
{
	if(ishutdown == 1) {

		DestroyDynamic3DTextLabel(SANShows[channel][SANews3DText][0]);
		DestroyDynamic3DTextLabel(SANShows[channel][SANews3DText][1]);
		DestroyDynamic3DTextLabel(SANShows[channel][camera]);
	}
	szMiscArray[0] = 0;
	if(SANShows[channel][ChannelActive] == 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}MAIN SYSTEM MONITOR\n{32CD80}SAN | Channel {FFFFFF}%i\n{32CD80}Name: {FFFFFF}%s\n{32CD80}Host: {FFFFFF}%s\n{32CD80}View: {FF4C4C}Not Broadcasting\n{32CD80}Viewer Rating: {FFFFFF}- **", channel, SANShows[channel][ChannelName], SANShows[channel][Hosts], SANShows[channel][Hosts]);
	}
	else
	{
		format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}MAIN SYSTEM MONITOR\n{32CD80}SAN | Channel {FFFFFF}%i\n{32CD80}Name: {FFFFFF}%s\n{32CD80}Host: {FFFFFF}%s\n{32CD80}Currently: {7CFC00}Broadcasting\n{32CD80}Viewer Rating: {FFFFFF}%i", channel, SANShows[channel][ChannelName], SANShows[channel][Hosts], SANShows[channel][san_iRatings]);
	}
	UpdateDynamic3DTextLabelText(SANShows[channel][SANews3DText][0], COLOR_LIGHTBLUE, szMiscArray);
	if(broadcasting == 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "{32CD80}SAN | Channel {FFFFFF}%i\n{32CD80}Name: {FFFFFF}%s\n{32CD80}Currently: {FF4C4C}Not Broadcasting\n{32CD80}Viewer Rating: {FFFFFF} **", channel, SANShows[channel][ChannelName]);
	}
	else
	{
		format(szMiscArray, sizeof(szMiscArray), "{32CD80}SAN | Channel {FFFFFF}%i\n{32CD80}Name: {FFFFFF}%s\n{32CD80}Currently: {7CFC00}Broadcasting\n{32CD80}Viewer Rating: {FFFFFF}%i", channel, SANShows[channel][ChannelName], SANShows[channel][san_iRatings]);
	}
	UpdateDynamic3DTextLabelText(SANShows[channel][SANews3DText][1], COLOR_LIGHTBLUE, szMiscArray);
}

SAN_Stop(i)
{
	if(GetPVarType(i, "WatchingTV"))
	{
		SAN_HideTextDraws(i);
		TogglePlayerSpectating(i, 0);
		Character_Actor(i, 1);
		Player_StreamPrep(i,BroadcastFloats[i][1],BroadcastFloats[i][2],BroadcastFloats[i][3], FREEZE_TIME);
		SetPlayerVirtualWorld(i, BroadcastLastVW[i]);
		PlayerInfo[i][pInt] = BroadcastLastVW[i];
		SetPlayerInterior(i, BroadcastLastInt[i]);
		PlayerInfo[i][pInt] = BroadcastLastInt[i];
		SetPlayerFacingAngle(i, BroadcastFloats[i][0]);
		DeletePVar(i, "WatchingTV");
		DeletePVar(i, "ChannelID");
		SendClientMessage(i, COLOR_GRAD1, "Fetching your character's old position...");
		SetTimerEx("SAN_SetPos", 5000, false, "i", i);
		for(new channel; channel < MAX_SANCHANNELS; channel ++)
		{
			SANShows[channel][san_iRatings] = 0;
			UpdateSANewsBroadcast(channel, 1);
		}
	}
}

forward SAN_SetPos(i);
public SAN_SetPos(i) {

	Player_StreamPrep(i, BroadcastFloats[i][1], BroadcastFloats[i][2], BroadcastFloats[i][3], FREEZE_TIME);
	SetPlayerVirtualWorld(i, BroadcastLastVW[i]);
	PlayerInfo[i][pInt] = BroadcastLastVW[i];
	SetPlayerInterior(i, BroadcastLastInt[i]);
	PlayerInfo[i][pInt] = BroadcastLastInt[i];
	SetPlayerFacingAngle(i, BroadcastFloats[i][0]);
}

/*
forward SAN_Create_Camera(playerid, choice);
public SAN_Create_Camera(playerid, choice)
{
	new Float:Pos_x, Float:Pos_y, Float:Pos_z, Float:Pos_r;
	GetPlayerPos(playerid, Pos_x, Pos_y, Pos_z);
	Pos_z -= 1.1;
	GetXYInFrontOfPlayer(playerid, Pos_x, Pos_y, -1.5);
	GetPlayerFacingAngle(playerid, Pos_r);
	switch(choice)
	{
		case 1:
		{
			if(GetPVarInt(playerid, "CreatedCamera") == 0)
			{
				SetPVarInt(playerid, "CreatedCamera", 1);
				SAN_Camera_Objects[playerid][0] = CreateDynamicObject(18655, Pos_x+-0.75554, Pos_y+0.02661, Pos_z+-1.08045,   0.00000, 35.00000, 0.00000+Pos_r);
				SAN_Camera_Objects[playerid][1] = CreateDynamicObject(2994, Pos_x+0.38326, Pos_y+0.07556, Pos_z+0.63245,   0.00000, 0.00000, 180.00000+Pos_r);
				SAN_Camera_Objects[playerid][2] = CreateDynamicObject(19279, Pos_x+0.75555, Pos_y+0.07361, Pos_z+0.40515,   345.00000, 0.00000, 270.00000+Pos_r);
				SAN_Camera_Objects[playerid][3] = CreateDynamicObject(2343, Pos_x+-0.36984, Pos_y+-0.07556, Pos_z+1.08045,   0.00000, 0.00000, 0.00000+Pos_r);

				return 1;
			}
			else
			{
				DeletePVar(playerid, "CreatedCamera");
				SetTimerEx("SAN_Create_Camera", 1000, 0, "ii", playerid, 1);
				for(new i; i < sizeof SAN_Camera_Objects; i++)
				{
					DestroyDynamicObject(SAN_Camera_Objects[playerid][i]);
				}
				return 1;
			}
		}
		default:
		{
			for(new i; i < sizeof SAN_Camera_Objects; i++)
			{
				DestroyDynamicObject(SAN_Camera_Objects[playerid][i]);
			}
			return 1;
		}
	}
	return 1;
}
*/

CMD:sanhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "----------------------------------------------------------");	
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "SAN CMD [TV]: {FFFFFF}/shows | /showmenu | /editshow | /broadcast | /cameraman | /channeldesc");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "SAN CMD [DIR]: {FFFFFF}/bdirector | /stopnews | /showkick | /sanrank");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "SAN CMD [CHATS]: {FFFFFF}/news | /live | /show (/sh) | /showinvite | /setchannel");
	SendClientMessage(playerid, COLOR_WHITE, "----------------------------------------------------------");	
	return 1;
}

CMD:acceptshow(playerid, params[])
{
	if(GetPVarInt(playerid, "TVOffer") < MAX_PLAYERS) {
		if(IsPlayerConnected(GetPVarInt(playerid, "TVOffer"))) {
			if (ProxDetectorS(5.0, playerid, GetPVarInt(playerid, "TVOffer"))) {
				SendClientMessage(GetPVarInt(playerid, "TVOffer"), COLOR_LIGHTBLUE, "* The player accepted your invite.");
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "* The show has begun! Use '/mic' to talk. (Use /shows to stop).");
				SetPVarInt(playerid, "ChannelID", GetPVarInt(GetPVarInt(playerid, "TVOffer"), "ChannelID_FMEM"));
				DeletePVar(playerid, "ChannelID_FMEM");
				SetPVarInt(playerid, "TalkingTV", GetPVarInt(playerid, "TVOffer"));
				SetPVarInt(GetPVarInt(playerid, "TVOffer"), "TalkingTV", playerid);
				SetPVarInt(playerid, "TVOffer", INVALID_PLAYER_ID);
				return 1;
			}
			else {
				SendClientMessage(playerid, COLOR_GREY, "   You are too far away from the News Reporter!");
				return 1;
			}
		}
	}
	return 1;
}

CMD:showkick(playerid, params[])
{
	if(!IsAReporter(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "     You are not a News Reporter.");
	if(!SAN_RankCheck(playerid, 1)) return 1;
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /showkick [playerid]");
	if(GetPVarInt(giveplayerid, "TalkingTV") == GetPVarInt(playerid, "TalkingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "That player is not on the show.");
	SetPVarInt(giveplayerid, "TalkingTV", INVALID_PLAYER_ID);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "You have successfully kicked the player from the show.");
	SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "You have been kicked from the show.");
	return 1;
}

CMD:stopnews(playerid, params[])
{
	if(IsAReporter(playerid))
	{
		if(!SAN_RankCheck(playerid, 3)) return 1;
		if(shutdown == 0)
		{
			shutdown = 1;
			SendClientMessage(playerid, COLOR_WHITE, "You have just shutdown the whole news system and are ending anything in progres..." );
			if(broadcasting == 1)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Broadcasting has just been shutdown..");
				broadcasting = 0;
				for(new channel; channel < MAX_SANCHANNELS; channel ++)
				{
					UpdateSANewsBroadcast(channel, 1);
				}
				foreach(Player, i)
				{
					SAN_Stop(i);
				}
			}
			foreach(Player, i)
			{
				if(TalkingLive[i] != INVALID_PLAYER_ID)
				{
					SendClientMessage(i, COLOR_LIGHTBLUE, "* Live conversation ended.");
					SendClientMessage(TalkingLive[i], COLOR_LIGHTBLUE, "* Live conversation ended.");
					TogglePlayerControllable(i, 1);
					TogglePlayerControllable(TalkingLive[i], 1);
					TalkingLive[TalkingLive[i]] = INVALID_PLAYER_ID;
					TalkingLive[i] = INVALID_PLAYER_ID;
					SendClientMessage(i, COLOR_LIGHTBLUE, "* Live has just been shutdown..");
				}
				else if(GetPVarInt(i, "TalkingTV") != INVALID_PLAYER_ID)
				{
					SendClientMessage(i, COLOR_LIGHTBLUE, "* Show ended.");
					SendClientMessage(GetPVarInt(i, "TalkingTV"), COLOR_LIGHTBLUE, "* Show ended.");
					SetPVarInt(GetPVarInt(i, "TalkingTV"), "TalkingTV", INVALID_PLAYER_ID);
					SetPVarInt(i, "TalkingTV", INVALID_PLAYER_ID);
					SendClientMessage(i, COLOR_LIGHTBLUE, "* The show has just been shutdown...");
				}
			}
		}
		else
		{
			shutdown = 0;
			SendClientMessage(playerid, COLOR_WHITE, "You have just turned the news system back on. " );
		}
	}
	return 1;
}

// This command 'launches' the broadcast in the air. Until this hasn't been executed, the whole system is in "Training Mode" (People can't use /watchtv).
CMD:broadcast(playerid, params[])
{
	if(IsAReporter(playerid))
	{
		if(!SAN_RankCheck(playerid, 2)) return 1;
		if(!GetPVarType(playerid, "ChannelID_FMEM")) return cmd_setchannel(playerid, "");
		if(broadcasting == 0)
		{
			broadcasting = 1;
			SAN_Broadcast(playerid, GetPVarInt(playerid, "ChannelID_FMEM"));
			return 1;
		}
		else
		{
			new channel = GetPVarInt(playerid, "ChannelID_FMEM");
			SANShows[channel][ChannelActive] = 0;
			broadcasting = 0;
			SAN_Broadcast(playerid, channel);
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "     You are not a News Reporter.");
	}
	return 1;
}


CMD:news(playerid, params[])
{
	szMiscArray[0] = 0;
	if(IsAReporter(playerid))
	{
		if(!SAN_RankCheck(playerid, 0)) return 1;
		if(shutdown == 1) return SendClientMessage(playerid, COLOR_WHITE, "The news system is currently shut down." );
		if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /news [text]");

		new newcar = GetPlayerVehicleID(playerid);
		if(IsANewsCar(newcar) || IsPlayerInRangeOfPoint(playerid, 35.0, 664.6821,-2.3673,1101.2085) || IsPlayerInRangeOfPoint(playerid, 35.0, 651.1910,-19.9795,1101.2200) || IsPlayerInRangeOfPoint(playerid, 35.0, 646.7300,-6.6966,1101.2085))
		{
			if(PlayerInfo[playerid][pRank] < 1)
			{
				SendClientMessage(playerid, COLOR_GRAD2, "You must be at least rank 1.");
			}
			else
			{
				format(szMiscArray, sizeof(szMiscArray), "NR %s: %s", GetPlayerNameEx(playerid), params);
				OOCNews(COLOR_NEWS, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "[NEWS] NR %s: %s", GetPlayerNameEx(playerid), params);
				GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "You're not in a news van or chopper or in the studio.");
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREY, "     You are not a News Reporter.");
	}
	return 1;
}

// -------------------------------------------- NEW COMMANDS BY JINGLES -----------------------------------

CMD:setchannel(playerid, params[])
{
	if(IsAReporter(playerid))
	{
		if(!SAN_RankCheck(playerid, 2)) return 1;
		SetPVarInt(playerid, "LoginChannelID", 1);
		SAN_ShowsDialog(playerid, 0);
	}
	else SendClientMessage(playerid, COLOR_GREY, "     You are not a News Reporter.");
	return 1;
}



// WARNING: Please make sure that people can only use /watchtv in any interior (and mayby at some TV hotspots).
CMD:watchtv(playerid, params[])
{
	cmd_shows(playerid, "");
	return 1;
}

CMD:viewers(playerid, params[])
{
	if(IsAReporter(playerid)) SAN_Viewers(playerid);
	else SendClientMessage(playerid, COLOR_GREY, "     You are not a News Reporter.");	
	return 1;
}


CMD:sh(playerid, params[])
{
	cmd_mic(playerid, "");
	return 1;
}

CMD:shows(playerid, params[])
{
	if(!GetPVarType(playerid, "WatchingTV"))
	{
		SAN_ShowsDialog(playerid, 0);
	}
	else
	{
		if(SANShows[GetPVarInt(playerid, "ChannelID")][ChannelType] != 1)
		{
			SAN_WatchTV(playerid, SAN_INVALID_CHANNEL);
		}
		else
		{		
			SAN_ListenRadio(playerid, SAN_INVALID_CHANNEL);
		}
	}
	return 1;
}



CMD:mic(playerid, params[])
{
	szMiscArray[0] = 0;
	if(shutdown == 1) return SendClientMessage(playerid, COLOR_WHITE, "The news system is currently shut down." );
	if(broadcasting == 0) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* No one is broadcasting!");
	if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /mic [text]");
	if(GetPVarInt(playerid, "ChannelID_FMEM"))
	{
		switch(SANShows[GetPVarInt(playerid, "ChannelID_FMEM")][Global])
		{
			case 0:
			{
				switch(SANShows[GetPVarInt(playerid, "ChannelID_FMEM")][ChannelType])
				{
					case 0:
					{
						format(szMiscArray, sizeof(szMiscArray), "[SAN] Host %s: %s", GetPlayerNameEx(playerid), params);
						TVNews(COLOR_NEWS, szMiscArray, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 1:
					{
						format(szMiscArray, sizeof(szMiscArray), "[SAN] Host %s: %s", GetPlayerNameEx(playerid), params);
						TVNews(COLOR_SANRADIO, szMiscArray, GetPVarInt(playerid, "ChannelID_FMEM"));					
					}
				}
				return 1;			
			}
			case 1:
			{
				switch(SANShows[GetPVarInt(playerid, "ChannelID_FMEM")][ChannelType])
				{
					case 0:
					{
						format(szMiscArray, sizeof(szMiscArray), "[CH. %i] TV Host %s: %s", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid), params);
						TVNews(COLOR_NEWS, szMiscArray, GetPVarInt(playerid, "ChannelID_FMEM"));
					}
					case 1:
					{
						format(szMiscArray, sizeof(szMiscArray), "[CH. %i] Host %s: %s", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid), params);
						TVNews(COLOR_SANRADIO, szMiscArray, GetPVarInt(playerid, "ChannelID_FMEM"));					
					}
					case 2:
					{
						format(szMiscArray, sizeof(szMiscArray), "[CH. %i] [SAN] %s: %s", GetPVarInt(playerid, "ChannelID_FMEM"), GetPlayerNameEx(playerid), params);
						TVNews(COLOR_NEWS, szMiscArray, GetPVarInt(playerid, "ChannelID_FMEM"));					
					}
				}
				return 1;
			}
		}
	}
	if(IsAReporter(playerid) && !GetPVarInt(playerid, "ChannelID_FMEM"))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "You are not logged in to a channel. Please login now."); 
		return cmd_setchannel(playerid, "");
	}
	if(GetPVarInt(playerid, "ChannelID"))
	{
		if(GetPVarInt(playerid, "TalkingTV") != INVALID_PLAYER_ID)
		{
			switch(SANShows[GetPVarInt(playerid, "ChannelID")][Global])
			{
				case 0:
				{
					switch(SANShows[GetPVarInt(playerid, "ChannelID_FMEM")][ChannelType])
					{
						case 0:
						{
							format(szMiscArray, sizeof(szMiscArray), "[SAN] Guest %s: %s", GetPlayerNameEx(playerid), params);
							TVNews(COLOR_NEWS2, szMiscArray, GetPVarInt(playerid, "ChannelID_FMEM"));
						}
						case 1:
						{
							format(szMiscArray, sizeof(szMiscArray), "[SAN] Guest %s: %s", GetPlayerNameEx(playerid), params);
							TVNews(COLOR_SANRADIO2, szMiscArray, GetPVarInt(playerid, "ChannelID_FMEM"));					
						}
					}
					return 1;			
				}
				case 1:
				{
					switch(SANShows[GetPVarInt(playerid, "ChannelID")][ChannelType])
					{
						case 0:
						{
							format(szMiscArray, sizeof(szMiscArray), "[CH. %i] TV Guest %s: %s", GetPVarInt(playerid, "ChannelID"), GetPlayerNameEx(playerid), params);
							TVNews(COLOR_NEWS2, szMiscArray, GetPVarInt(playerid, "ChannelID"));
						}
						case 1:
						{
							format(szMiscArray, sizeof(szMiscArray), "[CH. %i] Radio Guest %s: %s", GetPVarInt(playerid, "ChannelID"), GetPlayerNameEx(playerid), params);
							TVNews(COLOR_SANRADIO2, szMiscArray, GetPVarInt(playerid, "ChannelID"));				
						}
						case 2:
						{
							format(szMiscArray, sizeof(szMiscArray), "[CH. %i] [SAN] Guest %s: %s", GetPVarInt(playerid, "ChannelID"), GetPlayerNameEx(playerid), params);
							TVNews(COLOR_NEWS2, szMiscArray, GetPVarInt(playerid, "ChannelID"));
						}
					}
				}
			}
			return 1;
		}
		else return SendClientMessage(playerid, COLOR_GRAD1, "You are not on a show.");
	}
	return 1;
}

// The TV show invite: People of SA News can invite people to this 'chat channel'.
CMD:showinvite(playerid, params[])
{
	szMiscArray[0] = 0;
	if(!IsAReporter(playerid)) return SendClientMessage(playerid, COLOR_GREY, "     You are not a News Reporter."); 
	if(!SAN_RankCheck(playerid, 1)) return 1;
	if(shutdown == 1) return SendClientMessage(playerid, COLOR_WHITE, "The news system is currently shut down." );
	if(GetPVarType(playerid, "ChannelID_FMEM"))
	{
		new giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /showinvite [playerid]");
		if (IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(5.0, playerid, giveplayerid))
			{
				if(PlayerInfo[giveplayerid][pLiveBanned] == 1) return SendClientMessage(playerid, COLOR_GREY, "That player is banned from the air.");
				if(PlayerCuffed[giveplayerid] >= 1 || PlayerCuffed[playerid] >= 1)
				{
					SendClientMessage(playerid, COLOR_GRAD2, "You are unable to do this right now.");
				}
				else
				{
					if(SANShows[GetPVarInt(playerid, "ChannelID_FMEM")][ChannelType] != 1)
					{
						if(giveplayerid == playerid) return SendClientMessage(playerid, COLOR_GREY, "USAGE: '/mic' to talk on the TV Show!");
						format(szMiscArray, sizeof(szMiscArray), "* You offered %s to participate in the TV Show.", GetPlayerNameEx(giveplayerid));
						SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "* %s offered you to participate in the TV Show, type /acceptshow to accept.", GetPlayerNameEx(playerid));
						SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
					}
					else
					{
						if(giveplayerid == playerid) return SendClientMessage(playerid, COLOR_GREY, "USAGE: '/mic' to talk on the Radio Show!");
						format(szMiscArray, sizeof(szMiscArray), "* You offered %s to participate in the Radio Show.", GetPlayerNameEx(giveplayerid));
						SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "* %s offered you to participate in the Radio Show, type /acceptshow to accept.", GetPlayerNameEx(playerid));
						SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
					}
					SetPVarInt(giveplayerid, "TVOffer", playerid);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "That player isn't near you.");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "Invalid player specified.");
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You have not logged in to a channel. (Use '/setchannel' to login).");
	return 1;
}

CMD:showmenu(playerid, params[])
{
	if(!IsAReporter(playerid)) return SendClientMessage(playerid, COLOR_GREY, "     You are not a News Reporter."); 
	if(!SAN_RankCheck(playerid, 0)) return 1;
	SAN_ShowsDialog(playerid, 2);
	return 1;
}


CMD:editshow(playerid, params[])
{
	if(!IsAReporter(playerid)) return SendClientMessage(playerid, COLOR_GREY, "     You are not a News Reporter."); 
	if(!SAN_RankCheck(playerid, 2)) return 1;
	SAN_ShowsDialog(playerid, 1);
	return 1;
}

CMD:togshow(playerid, params[])
{
	if (!gNews[playerid])
	{
		gNews[playerid] = 1;
		PlayerInfo[playerid][pToggledChats][1] = 1;
		SendClientMessage(playerid, COLOR_GRAD2, "You have disabled the TV chat.");
	}
	else
	{
		gNews[playerid] = 0;
		PlayerInfo[playerid][pToggledChats][1] = 0;
		SendClientMessage(playerid, COLOR_GRAD2, "You have enabled the TV chat.");
	}
	return 1;
}

CMD:listcameras(playerid, params[])
{
	if(!IsAReporter(playerid)) return SendClientMessage(playerid, COLOR_GREY, "     You are not a News Reporter."); 
	if(!SAN_RankCheck(playerid, 0)) return 1;
	SAN_Process_ListCameras(playerid, GetPVarInt(playerid, "ChannelID_FMEM"));
	return 1;
}

SAN_RankCheck(playerid, slot) {

	if(PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iWithdrawRank][slot]) return 1;
	SendClientMessage(playerid, COLOR_GRAD1, "You do not have the permissions to use this command.");
	return 0;
}

CMD:cameraman(playerid, params[])
{
	if(IsAReporter(playerid))
	{
		if(!SAN_RankCheck(playerid, 0)) return 1;
		SetPVarInt(playerid, "CameramanChannelID", 1);
		if(!SAN_Process_Login(playerid)) return 1;
		DeletePVar(playerid, "CameramanChannelID");

		for(new channel; channel < MAX_SANCHANNELS; channel++)
		{
			if(shutdown == 1)
			{
				format(szMiscArray, sizeof(szMiscArray), "__________________________ {FF3232}SYSTEM OFFLINE {FFFFFF}________________\nActive: {FFA500}--- {FFFFFF}|| {32CD80}Channel ---{FFFFFF} (click to change)\n");
				break;
			}
			if(GetPVarInt(playerid, "ChannelID_FMEM") == channel)
			{
				if(SANShows[channel][ChannelActive] == 1)
				{
					format(szMiscArray, sizeof(szMiscArray), "______________________________ {FF4C4C}ON AIR {FFFFFF}______________________________\nActive: {FFA500}%s {FFFFFF}|| {32CD80}Channel %i{FFFFFF} (click to change)\n", SANShows[channel][ChannelName], GetPVarInt(playerid, "ChannelID_FMEM"));
					break;
				}
				if(SANShows[channel][ChannelActive] == 0)
				{
					format(szMiscArray, sizeof(szMiscArray), "__________________________ {7CFC00}SYSTEM ONLINE {FFFFFF}__________________________\nActive: {FFA500}%s {FFFFFF}|| {32CD80}Channel %i{FFFFFF} (click to change)\n", SANShows[channel][ChannelName], GetPVarInt(playerid, "ChannelID_FMEM"));
					break;
				}
			}
		}
		format(szMiscArray, sizeof(szMiscArray), "%s--> Dynamic Camera Menu\n\
			_______________________  STATIC CAMERA MENU _______________________ \n\
			Set Camera Position\n\
			Stop viewing current camera\n\
			Preview SET camera\n\
			------------------------------------------\n\
			Broadcast Camera Position\n\
			Birdseye View\n\
			Vehicle Camera\n\
			Log out out of camera system", szMiscArray);
		ShowPlayerDialogEx(playerid, DIALOG_SAN_CAMERAMAN, DIALOG_STYLE_LIST, "SA News | Cameraman Menu", szMiscArray, "Select", "Cancel");
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "     You are not a News Reporter.");
	}
	return 1;
}


CMD:bdirector(playerid, params[])
{
	szMiscArray[0] = 0;

 	if(!IsAReporter(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "	You are not a News Reporter.");
 	if(!SAN_RankCheck(playerid, 2)) return 1;
	if(PlayerInfo[playerid][pRank] < 3) return SendClientMessage(playerid, COLOR_GRAD1, "You must be at least Rank 3 to use the Broadcast Director system.");
	{
		SetPVarInt(playerid, "DirectorChannelID", 1);
		if(!SAN_Process_Login(playerid)) return 1;
		DeletePVar(playerid, "DirectorChannelID");

		for(new channel; channel < MAX_SANCHANNELS; channel++)
		{
			if(shutdown == 1)
			{
				format(szMiscArray, sizeof(szMiscArray), "__________________________ {FF3232}SYSTEM OFFLINE {FFFFFF}________________\nActive: {FFA500}--- {FFFFFF}|| {32CD80}Channel ---{FFFFFF} (click to change)\n");
				break;
			}
			if(GetPVarInt(playerid, "ChannelID_FMEM") == channel)
			{
				if(SANShows[channel][ChannelActive] == 1)
				{
					format(szMiscArray, sizeof(szMiscArray), "______________________________ {FF4C4C}ON AIR {FFFFFF}______________________________\nActive: {FFA500}%s {FFFFFF}|| {32CD80}Channel %i{FFFFFF} (click to change)\n", SANShows[channel][ChannelName], GetPVarInt(playerid, "ChannelID_FMEM"));
					break;
				}
				if(SANShows[channel][ChannelActive] == 0)
				{
					format(szMiscArray, sizeof(szMiscArray), "__________________________ {7CFC00}SYSTEM ONLINE {FFFFFF}__________________________\nActive: {FFA500}%s {FFFFFF}|| {32CD80}Channel %i{FFFFFF} (click to change)\n", SANShows[channel][ChannelName], GetPVarInt(playerid, "ChannelID_FMEM"));
					break;
				}
			}
		}
	
		strcat(szMiscArray, "\n\
			----> {32CD80}TV MENU{FFFFFF} (edit channel)\n\
			Preview SET camera\n\
			List all camera's\n\
			Stop viewing current camera\n\
			Preview Stream\n\
			----------------------------------\n\
			Broadcast Cameraman's Camera (list)\n\
			Broadcast Birdseye View\n\
			Broadcast Point-to-Point Camera\n\
			Broadcast Vehicle Camera\n\
			Broadcast Stream\n\
			----------------------------------\n", sizeof(szMiscArray));

		strcat(szMiscArray, "\
			Start System\n\
			Shutdown/Stop System \n\
			----------------------------------\n\
			Log out of the system", sizeof(szMiscArray));

		ShowPlayerDialogEx(playerid, DIALOG_SAN_DIRECTOR, DIALOG_STYLE_LIST, "SA News | Broadcast Director Menu", szMiscArray, "Select", "Cancel");
	}
	return 1;
}

// TV "Name" Command:
CMD:channeldesc(playerid, params[])
{
	szMiscArray[0] = 0;
	if(IsAReporter(playerid))
	{
		if(!SAN_RankCheck(playerid, 2)) return 1;
		if(!isnull(params))
		{
			format(szMiscArray, sizeof(szMiscArray), "TV Channel line set to: %s", params);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
			TextDrawSetString(TV_text[4], params);
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "Usage: /channeldesc [description]");
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "     You are not a News Reporter.");
	}
	return 1;
}



CMD:cm(playerid, params[])
{
	cmd_cameraman(playerid, "");
	return 1;
}

forward SAN_InitTextDraws();
public SAN_InitTextDraws()
{

	TV_text[0] = TextDrawCreate(0.000000, 120.000000, "tv-left");
	TextDrawAlignment(TV_text[0], 2);
	TextDrawBackgroundColor(TV_text[0], 255);
	TextDrawFont(TV_text[0], 1);
	TextDrawLetterSize(TV_text[0], 0.500000, 26.000000);
	TextDrawColor(TV_text[0], 0);
	TextDrawSetOutline(TV_text[0], 0);
	TextDrawSetProportional(TV_text[0], 1);
	TextDrawSetShadow(TV_text[0], 0);
	TextDrawUseBox(TV_text[0], 1);
	TextDrawBoxColor(TV_text[0], 255);
	TextDrawTextSize(TV_text[0], 11.000000, 11.000000);
	TextDrawSetSelectable(TV_text[0], 0);

	TV_text[1] = TextDrawCreate(638.000000, 85.000000, "tv-right");
	TextDrawAlignment(TV_text[1], 2);
	TextDrawBackgroundColor(TV_text[1], 255);
	TextDrawFont(TV_text[1], 1);
	TextDrawLetterSize(TV_text[1], 0.500000, 26.000000);
	TextDrawColor(TV_text[1], 0);
	TextDrawSetOutline(TV_text[1], 0);
	TextDrawSetProportional(TV_text[1], 1);
	TextDrawSetShadow(TV_text[1], 0);
	TextDrawUseBox(TV_text[1], 1);
	TextDrawBoxColor(TV_text[1], 255);
	TextDrawTextSize(TV_text[1], 11.000000, 11.000000);
	TextDrawSetSelectable(TV_text[1], 0);

	TV_text[2] = TextDrawCreate(313.000000, 439.000000, "tv-down");
	TextDrawAlignment(TV_text[2], 2);
	TextDrawBackgroundColor(TV_text[2], 255);
	TextDrawFont(TV_text[2], 1);
	TextDrawLetterSize(TV_text[2], 0.500000, 1.000000);
	TextDrawColor(TV_text[2], 0);
	TextDrawSetOutline(TV_text[2], 0);
	TextDrawSetProportional(TV_text[2], 1);
	TextDrawSetShadow(TV_text[2], 0);
	TextDrawUseBox(TV_text[2], 1);
	TextDrawBoxColor(TV_text[2], 255);
	TextDrawTextSize(TV_text[2], 11.000000, 501.000000);
	TextDrawSetSelectable(TV_text[2], 0);

	TV_text[3] = TextDrawCreate(313.000000, -1.000000, "tv-up");
	TextDrawAlignment(TV_text[3], 2);
	TextDrawBackgroundColor(TV_text[3], 255);
	TextDrawFont(TV_text[3], 1);
	TextDrawLetterSize(TV_text[3], 0.500000, 1.000000);
	TextDrawColor(TV_text[3], 0);
	TextDrawSetOutline(TV_text[3], 0);
	TextDrawSetProportional(TV_text[3], 1);
	TextDrawSetShadow(TV_text[3], 0);
	TextDrawUseBox(TV_text[3], 1);
	TextDrawBoxColor(TV_text[3], 255);
	TextDrawTextSize(TV_text[3], 11.000000, 501.000000);
	TextDrawSetSelectable(TV_text[3], 0);

	TV_text[4] = TextDrawCreate(317.000000, 424.000000, "news-line");
	TextDrawAlignment(TV_text[4], 2);
	TextDrawBackgroundColor(TV_text[4], 255);
	TextDrawFont(TV_text[4], 2);
	TextDrawLetterSize(TV_text[4], 0.200000, 0.999999);
	TextDrawColor(TV_text[4], -1);
	TextDrawSetOutline(TV_text[4], 0);
	TextDrawSetProportional(TV_text[4], 1);
	TextDrawSetShadow(TV_text[4], 0);
	TextDrawUseBox(TV_text[4], 1);
	TextDrawBoxColor(TV_text[4], 100);
	TextDrawTextSize(TV_text[4], 11.000000, 191.000000);
	TextDrawSetSelectable(TV_text[4], 0);

	TV_text[5] = TextDrawCreate(317.000000, 10.000000, "SAN-TV");
	TextDrawAlignment(TV_text[5], 2);
	TextDrawBackgroundColor(TV_text[5], 255);
	TextDrawFont(TV_text[5], 2);
	TextDrawLetterSize(TV_text[5], 0.289999, 1.400000);
	TextDrawColor(TV_text[5], -1);
	TextDrawSetOutline(TV_text[5], 0);
	TextDrawSetProportional(TV_text[5], 1);
	TextDrawSetShadow(TV_text[5], 0);
	TextDrawUseBox(TV_text[5], 1);
	TextDrawBoxColor(TV_text[5], 100);
	TextDrawTextSize(TV_text[5], 11.000000, 51.000000);
	TextDrawSetSelectable(TV_text[5], 0);

	TV_text[6] = TextDrawCreate(317.000000, 438.000000, "Channel 1");
	TextDrawAlignment(TV_text[6], 2);
	TextDrawBackgroundColor(TV_text[6], 255);
	TextDrawFont(TV_text[6], 1);
	TextDrawLetterSize(TV_text[6], 0.260000, 1.100000);
	TextDrawColor(TV_text[6], -1);
	TextDrawSetOutline(TV_text[6], 0);
	TextDrawSetProportional(TV_text[6], 1);
	TextDrawSetShadow(TV_text[6], 0);
	TextDrawSetSelectable(TV_text[6], 0);

	TV_text[7] = TextDrawCreate(-0.500, -0.500, "LD_SPAC:tvcorn");
    TextDrawFont(TV_text[7], 4);
    TextDrawTextSize(TV_text[7], 98.500, 149.500);
    TextDrawColor(TV_text[7], 255);

    TV_text[8] = TextDrawCreate(-0.500, 448.000, "LD_SPAC:tvcorn");
    TextDrawFont(TV_text[8], 4);
    TextDrawTextSize(TV_text[8], 89.500, -132.500);
    TextDrawColor(TV_text[8], 255);

    TV_text[9] = TextDrawCreate(640.000, -2.000, "LD_SPAC:tvcorn");
    TextDrawFont(TV_text[9], 4);
    TextDrawTextSize(TV_text[9], -99.500, 152.500);
    TextDrawColor(TV_text[9], 255);

    TV_text[10] = TextDrawCreate(640.000, 448.000, "LD_SPAC:tvcorn");
    TextDrawFont(TV_text[10], 4);
    TextDrawTextSize(TV_text[10], -116.000, -143.000);
    TextDrawColor(TV_text[10], 255);


// Reset TV Textdraws (/director stopcameras).
	TV_text[11] = TextDrawCreate(0.000000, 101.500000, "LD_SPAC:white");
	TextDrawLetterSize(TV_text[11], 0.000000, 0.000000);
	TextDrawTextSize(TV_text[11], 640.000000, 240.187500);
	TextDrawAlignment(TV_text[11], 1);
	TextDrawColor(TV_text[11], 255);
	TextDrawUseBox(TV_text[11], true);
	TextDrawBoxColor(TV_text[11], 255);
	TextDrawSetShadow(TV_text[11], 0);
	TextDrawSetOutline(TV_text[11], 0);
	TextDrawBackgroundColor(TV_text[11], 255);
	TextDrawFont(TV_text[11], 4);

	TV_text[12] = TextDrawCreate(251.999984, 218.312500, "Please wait...");
	TextDrawLetterSize(TV_text[12], 0.449999, 1.600000);
	TextDrawAlignment(TV_text[12], 1);
	TextDrawColor(TV_text[12], -1);
	TextDrawSetShadow(TV_text[12], 0);
	TextDrawSetOutline(TV_text[12], 1);
	TextDrawBackgroundColor(TV_text[12], 51);
	TextDrawFont(TV_text[12], 1);
	TextDrawSetProportional(TV_text[12], 1);

	TV_text[13] = TextDrawCreate(190.800003, 205.187500, "We are currently experiencing technical difficulties.");
	TextDrawLetterSize(TV_text[13], 0.249999, 1.302500);
	TextDrawAlignment(TV_text[13], 1);
	TextDrawColor(TV_text[13], -1);
	TextDrawSetShadow(TV_text[13], 0);
	TextDrawSetOutline(TV_text[13], 1);
	TextDrawBackgroundColor(TV_text[13], 51);
	TextDrawFont(TV_text[13], 1);
	TextDrawSetProportional(TV_text[13], 1);


}