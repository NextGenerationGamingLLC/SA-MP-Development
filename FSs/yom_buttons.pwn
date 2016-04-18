/*##############################################################################


					#########################################
					#										#
					#	  BUTTONS - FILTERSCRIPT BY YOM		#
					#               v1.3 BETA               #
					#       Steal my work and die >:D		#
					#                                       #
					#########################################


- Informations about this file:
===============================

	-	You must #include <yom_buttons> in the scripts you want to use buttons




- Copyright:
============

	-	Yom's Scripts Factory � �.
	-	You can use this script and distribute it but,
	-	You WILL NOT sell it or tell it's your own work.



- Versions changes:
===================

	-	1.0 :	Initial release.
	
	-	1.1 :	Small tweaks here and there.
	
	-	1.2 :   Removed: rX and rY parameters (was useless, for me anyway)
	            Changed: rZ parameter is now named Angle
	            Changed: CreateButton now returns the objectid, not the buttonid.
	            Added: Sets the pos of the player, so he press exactly on the button.
	            
	-   1.3 :   Changed again: CreateButton returns the buttonid (from 1 to MAX_BUTTONS).
	            Changed: Player can press the button from any angle
	            Added: more or less useful functions for use in your scripts
	            Added: sound
	            Added: button placer (if debug enabled, type /button)
	            THIS IS A BETA VERSION, PLEASE DON'T BE A BASTARD, AND REPORT BUGS/PROBLEMS!


##############################################################################*/










/*################################ CONFIGURATION #############################*/

//max buttons that can be created.
#define MAX_BUTTONS  200


//this is the distance max for detecting buttons. If the player is at this
//distance, or less, of a button, he will press this button.
#define MAX_DISTANCE	1.3


//this is the object modelid used for buttons.
//i'm asking for nice objects, if you know some that can be used as buttons, tell me!
#define OBJECT			2886


//comment this line to disable the sound, or change the number for another sound
//don't forget that you can do whatever you want in OnPlayerPressButton
#define SOUND           1083


//comment this line to disable debug (recommended once you finished using the
//buttons editor, this will make the script more efficient)
//#define DEBUG

/*############################################################################*/










/*----------------------------------------------------------------------------*/
#include <a_samp>
#undef  MAX_PLAYERS
#define MAX_PLAYERS (700)
#include <streamer>

#define INVALID_BUTTON_ID   -1


enum BUTTON_INFOS
{
	bool:Created,
	bool:Moving,
	bool:Usable[MAX_PLAYERS],
	Float:Pos[4],
	ObjectID
}

new ButtonInfo[MAX_BUTTONS+1][BUTTON_INFOS];

#if defined DEBUG

	enum PLAYER_INFOS
	{
		Float:MSpeed,
		SelectedButton,
		TimerID
	}
	
	new PlayerInfo[MAX_PLAYERS][PLAYER_INFOS];
	new String[128];

#endif
/*----------------------------------------------------------------------------*/










/*----------------------------------------------------------------------------*/
Float:Distance3D(Float:PointA[], Float:PointB[], bool:sqrt = true)
{
	new Float:Dist[4];
	
	for (new i = 0; i < 3; i++)
	{
	    Dist[i] = PointA[i] - PointB[i];
	    Dist[i] *= Dist[i];
	}
	
	Dist[3] = Dist[0] + Dist[1] + Dist[2];
	
	return sqrt ? floatsqroot(Dist[3]) : Dist[3];
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
Float:Angle2D(Float:PointA[], Float:PointB[])
{
	new bool:A_LS_B[2], Float:Dist[2], Float:Angle;

	for (new i = 0; i < 2; i++)
	{
	    A_LS_B[i] = PointA[i] < PointB[i];
	    Dist[i] = A_LS_B[i] ? PointB[i] - PointA[i] : PointA[i] - PointB[i];
	}

	Angle = atan2(Dist[1],Dist[0]);
	Angle = A_LS_B[0] ? 270.0 + Angle : 90.0 - Angle;
	Angle = A_LS_B[1] ? Angle : 180.0 - Angle;

	return Angle;
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
GetClosestButton(Float:Point[], &Float:Distance = 0.0)
{
	new Closest = INVALID_BUTTON_ID, Float:Distance2 = 100000.0;

	for (new buttonid = 1, highest = FS_GetHighestButtonID(); buttonid <= highest; buttonid ++)
	{
		if (ButtonInfo[buttonid][Created])
		{
			Distance = Distance3D(Point, ButtonInfo[buttonid][Pos]);

			if (Distance < Distance2)
			{
				Distance2 = Distance;
				Closest = buttonid;
			}
		}
	}

	Distance = Distance2;

	return Closest;
}
/*----------------------------------------------------------------------------*/










/*----------------------------------------------------------------------------*/
forward FS_CreateButton(Float:X, Float:Y, Float:Z, Float:Angle, VW);
public FS_CreateButton(Float:X, Float:Y, Float:Z, Float:Angle, VW)
{
	new buttonid;
	
	for(buttonid = 1; buttonid <= MAX_BUTTONS; buttonid ++)
	    if (!ButtonInfo[buttonid][Created])
			break;

	ButtonInfo[buttonid][ObjectID]	= CreateDynamicObject(OBJECT,X,Y,Z,0.0,0.0,Angle, VW);
	ButtonInfo[buttonid][Pos][0]	= X;
	ButtonInfo[buttonid][Pos][1]	= Y;
	ButtonInfo[buttonid][Pos][2]	= Z;
	ButtonInfo[buttonid][Pos][3]	= Angle;
	ButtonInfo[buttonid][Moving]	= false;
	ButtonInfo[buttonid][Created]	= true;
	
	for (new playerid = 0; playerid < MAX_PLAYERS; playerid ++)
	    ButtonInfo[buttonid][Usable][playerid] = true;

	return buttonid;
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
forward FS_DestroyButton(buttonid);
public FS_DestroyButton(buttonid)
{
	if (FS_IsValidButton(buttonid))
	{
		CallRemoteFunction("OnButtonDestroyed", "i", buttonid);
		ButtonInfo[buttonid][Created] = false;
		DestroyDynamicObject(ButtonInfo[buttonid][ObjectID]);
	}
}
/*----------------------------------------------------------------------------*/










/*----------------------------------------------------------------------------*/
forward FS_SetButtonPos(buttonid, Float:X, Float:Y, Float:Z, Float:Angle);
public FS_SetButtonPos(buttonid, Float:X, Float:Y, Float:Z, Float:Angle)
{
    if (FS_IsValidButton(buttonid))
	{
	    new objectid = ButtonInfo[buttonid][ObjectID];
		SetDynamicObjectPos(objectid, X, Y, Z);
		SetDynamicObjectRot(objectid, 0.0, 0.0, Angle);
		ButtonInfo[buttonid][Pos][0] = X;
		ButtonInfo[buttonid][Pos][1] = Y;
		ButtonInfo[buttonid][Pos][2] = Z;
		ButtonInfo[buttonid][Pos][3] = Angle;
	}
}
/*----------------------------------------------------------------------------*/










/*----------------------------------------------------------------------------*/
forward FS_MoveButton(buttonid, Float:X, Float:Y, Float:Z, Float:Speed);
public FS_MoveButton(buttonid, Float:X, Float:Y, Float:Z, Float:Speed)
{
    if (FS_IsValidButton(buttonid))
    {
        MoveDynamicObject(ButtonInfo[buttonid][ObjectID], X, Y, Z, Speed);
        ButtonInfo[buttonid][Moving] = true;
		ButtonInfo[buttonid][Pos][0] = X;
		ButtonInfo[buttonid][Pos][1] = Y;
		ButtonInfo[buttonid][Pos][2] = Z;
	}
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
forward FS_StopButton(buttonid);
public FS_StopButton(buttonid)
{
	if (FS_IsValidButton(buttonid))
		StopDynamicObject(ButtonInfo[buttonid][ObjectID]);
}
/*----------------------------------------------------------------------------*/










/*----------------------------------------------------------------------------*/
forward bool:FS_IsValidButton(buttonid);
public bool:FS_IsValidButton(buttonid)
{
	return (buttonid <= MAX_BUTTONS && ButtonInfo[buttonid][Created]);
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
forward FS_GetHighestButtonID();
public FS_GetHighestButtonID()
{
    for (new buttonid = MAX_BUTTONS; buttonid > 0; buttonid --)
		if (ButtonInfo[buttonid][Created])
		    return buttonid;

	return INVALID_BUTTON_ID;
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
forward FS_GetButtonObjectID(buttonid);
public FS_GetButtonObjectID(buttonid)
{
	return FS_IsValidButton(buttonid) ? ButtonInfo[buttonid][ObjectID] : INVALID_OBJECT_ID;
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
forward FS_GetObjectButtonID(objectid);
public FS_GetObjectButtonID(objectid)
{
	for (new buttonid = 1, highest = FS_GetHighestButtonID(); buttonid <= highest; buttonid ++)
	    if (ButtonInfo[buttonid][Created] && ButtonInfo[buttonid][ObjectID] == objectid)
			return buttonid;

	return INVALID_BUTTON_ID;
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
forward FS_PrintButtonsInfos();
public FS_PrintButtonsInfos()
{
	print
	(
		"\n \
		���������������������������������������������������������Ŀ\n \
		�                   Buttons Informations                  �\n \
		���������������������������������������������������������Ĵ\n \
		�ButtonID�ObjectID�    X    �    Y    �    Z    �    A    �\n \
		���������������������������������������������������������Ĵ"
	);

	for (new buttonid = 1; buttonid <= MAX_BUTTONS; buttonid ++)
	{
		if (ButtonInfo[buttonid][Created])
		{
			printf
			(
				" �%8d�%8d�%6.2f�%6.2f�%6.2f�%6.2f�",
				buttonid,
				ButtonInfo[buttonid][ObjectID],
				ButtonInfo[buttonid][Pos][0],
				ButtonInfo[buttonid][Pos][1],
				ButtonInfo[buttonid][Pos][2],
				ButtonInfo[buttonid][Pos][3]
			);
		}
	}

	print(" �����������������������������������������������������������\n");
}
/*----------------------------------------------------------------------------*/










/*----------------------------------------------------------------------------*/
forward Float:FS_GetDistanceToButton(buttonid, Float:X, Float:Y, Float:Z);
public Float:FS_GetDistanceToButton(buttonid, Float:X, Float:Y, Float:Z)
{
	if (FS_IsValidButton(buttonid))
	{
		new Float:Point[3];

		Point[0] = X;
		Point[1] = Y;
		Point[2] = Z;

		return Distance3D(Point, ButtonInfo[buttonid][Pos]);
	}

	return -1.0;
}
/*----------------------------------------------------------------------------*/










/*----------------------------------------------------------------------------*/
forward FS_TeleportPlayerToButton(playerid, buttonid);
public FS_TeleportPlayerToButton(playerid, buttonid)
{
	if (FS_IsValidButton(buttonid) && !ButtonInfo[buttonid][Moving])
	{
		new Float:Angle = ButtonInfo[buttonid][Pos][3];

		SetPlayerPos
		(
			playerid,
			ButtonInfo[buttonid][Pos][0] - (0.65 * floatsin(-Angle,degrees)),
			ButtonInfo[buttonid][Pos][1] - (0.65 * floatcos(-Angle,degrees)),
			ButtonInfo[buttonid][Pos][2] - 0.63
		);

		SetPlayerFacingAngle(playerid, -Angle);
		SetCameraBehindPlayer(playerid);
	}
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
forward FS_ToggleButtonEnabledForPlayer(playerid, buttonid, bool:enabled);
public FS_ToggleButtonEnabledForPlayer(playerid, buttonid, bool:enabled)
{
	if (FS_IsValidButton(buttonid))
		ButtonInfo[buttonid][Usable][playerid] = enabled;
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
forward FS_ToggleButtonEnabled(buttonid, bool:enabled);
public FS_ToggleButtonEnabled(buttonid, bool:enabled)
{
	if (FS_IsValidButton(buttonid))
	    for (new playerid = 0; playerid < MAX_PLAYERS; playerid ++)
			ButtonInfo[buttonid][Usable][playerid] = enabled;
}
/*----------------------------------------------------------------------------*/










/*----------------------------------------------------------------------------*/
forward OnPlayerPressButton_Delay(playerid, buttonid);
public OnPlayerPressButton_Delay(playerid, buttonid)
{
	#if defined SOUND
	    PlayerPlaySound(playerid, SOUND, 0.0, 0.0, 0.0);
	#endif
	CallRemoteFunction("OnPlayerPressButton", "ii", playerid, buttonid);
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if (newkeys & 16)
		{
			new Float:Distance, Float:Angle, Float:PlayerPos[3], buttonid;

			GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
		
			buttonid = GetClosestButton(PlayerPos, Distance);

			if (buttonid != INVALID_BUTTON_ID && ButtonInfo[buttonid][Usable][playerid] && Distance <= MAX_DISTANCE)
			{
				Angle = Angle2D(PlayerPos, ButtonInfo[buttonid][Pos]);

				SetPlayerFacingAngle(playerid, Angle);

				SetPlayerPos
				(
					playerid,
					ButtonInfo[buttonid][Pos][0] - (0.65 * floatsin(-Angle,degrees)),
					ButtonInfo[buttonid][Pos][1] - (0.65 * floatcos(-Angle,degrees)),
					ButtonInfo[buttonid][Pos][2] - 0.63
				);

				ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 10.0, 0, 0, 0, 0, 0);
				SetTimerEx("OnPlayerPressButton_Delay", 500, false, "ii", playerid, buttonid);
			}
		}


		#if defined DEBUG

		else if (newkeys & KEY_HANDBRAKE)
		{
			if (PlayerInfo[playerid][SelectedButton] != INVALID_BUTTON_ID)
		    {
				switch (PlayerInfo[playerid][MSpeed])
				{
			    	case 1.0 : { PlayerInfo[playerid][MSpeed] =  2.5; String = "Slow"; }
			    	case 2.5 : { PlayerInfo[playerid][MSpeed] =  5.0; String = "Normal"; }
			    	case 5.0 : { PlayerInfo[playerid][MSpeed] = 15.0; String = "Fast"; }
			    	default  : { PlayerInfo[playerid][MSpeed] =  1.0; String = "Very Slow"; }
				}
			
        		format(String, sizeof(String), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Movement speed~n~~r~%s~w~!", String);
        		GameTextForPlayer(playerid, String, 1500, 3);
			}
		}
		
		else if (newkeys & KEY_WALK)
		{
		    if (PlayerInfo[playerid][SelectedButton] != INVALID_BUTTON_ID)
				OnPlayerCommandText(playerid, "/button deselect");
			else
			    OnPlayerCommandText(playerid, "/button select");
		}
		
		#endif

	}
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
public OnObjectMoved(objectid)
{
	new buttonid = FS_GetObjectButtonID(objectid);
	
	if (buttonid != INVALID_BUTTON_ID)
	{
	    new Float:ObjectPos[3];
	    GetObjectPos(objectid, ObjectPos[0], ObjectPos[1], ObjectPos[2]);
	    ButtonInfo[buttonid][Pos][0] = ObjectPos[0];
	    ButtonInfo[buttonid][Pos][1] = ObjectPos[1];
	    ButtonInfo[buttonid][Pos][2] = ObjectPos[2];
	    ButtonInfo[buttonid][Moving] = false;
	    CallRemoteFunction("OnButtonMoved", "i", buttonid);
	}
}
/*----------------------------------------------------------------------------*/










/*----------------------------------------------------------------------------*/
public OnPlayerConnect(playerid)
{
    #if defined DEBUG
        if (PlayerInfo[playerid][SelectedButton] != INVALID_BUTTON_ID)
        {
    		PlayerInfo[playerid][SelectedButton] = INVALID_BUTTON_ID;
    		PlayerInfo[playerid][MSpeed] = 5.0;
    		KillTimer(PlayerInfo[playerid][TimerID]);
		}
	#endif
	
    ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 10.0, 0, 0, 0, 0, 0);
    return 1;
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
public OnGameModeInit()
{
    #if defined DEBUG
        FS_PrintButtonsInfos();
	#endif

	return true;
}
/*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
public OnGameModeExit()
{
    #if defined DEBUG
        FS_PrintButtonsInfos();
	#endif
	
	for (new buttonid = 1; buttonid <= MAX_BUTTONS; buttonid ++)
		if (ButtonInfo[buttonid][Created])
		    FS_DestroyButton(buttonid);

	return true;
}
/*----------------------------------------------------------------------------*/










/*----------------------------------------------------------------------------*/
#if defined DEBUG



	argpos(const string[], idx = 0, sep = ' ')
	{
		for(new i = idx, j = strlen(string); i < j; i++)
			if (string[i] == sep && string[i+1] != sep)
				return i+1;

		return -1;
	}



	public OnPlayerCommandText(playerid, cmdtext[])
	{
		if (strlen(cmdtext) > 50)
		{
			SendClientMessage(playerid, 0xFF0000FF, "Invalid command length (exceeding 50 characters)");
			return true;
		}
		
		
        if(!strcmp(cmdtext, "/button", .length = 7))
		{
		
		    if (!IsPlayerAdmin(playerid))
		        return true;
			
			
			
		    new	arg1 = argpos(cmdtext);



			if (!cmdtext[arg1])
			{
		    	SendClientMessage(playerid, 0xFF0000FF, "Button Editor's commands:");
		    	SendClientMessage(playerid, 0xFFFFFFFF, "\"/button create\" - Create a button at your position, then type \"/button select\" to move this button.");
            	SendClientMessage(playerid, 0xFFFFFFFF, "\"/button select <opt:buttonid>\" - If you don't use the optional parameter, it will select the closest button.");
				SendClientMessage(playerid, 0xFFFFFFFF, "\"/button save <opt:comment>\" - Save the positions of the selected button, optionally with a short comment.");
				SendClientMessage(playerid, 0xFFFFFFFF, "\"/button deselect\" - Deselect the selected button, this stops the editing mode.");
                SendClientMessage(playerid, 0xFF0000FF, "Button Editor's keys:");
				SendClientMessage(playerid, 0xFFFFFFFF, "Use Directional key to move the selected button forward, backward, to the left and to the right.");
                SendClientMessage(playerid, 0xFFFFFFFF, "Use Look Behind + Left or Right to rotate the selected button.");
				SendClientMessage(playerid, 0xFFFFFFFF, "Use Secondary Fire to change the movement speed.");
				SendClientMessage(playerid, 0xFFFFFFFF, "Use Walk to toggle Deselect/Select closest button.");
				return true;
			}



			else if (!strcmp(cmdtext[arg1], "create", .length = 6))
			{
			    new Float:PlayerPos[4], buttonid;
				GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
				GetPlayerFacingAngle(playerid, PlayerPos[3]);

				buttonid = FS_CreateButton(PlayerPos[0],PlayerPos[1],PlayerPos[2] + 0.63,PlayerPos[3]);
                format(String, sizeof(String), "Buttonid %d created! Select it with \"/button select\"", buttonid);
			    SendClientMessage(playerid, 0x00FF00FF, String);
		    	return true;
			}



			else if (!strcmp(cmdtext[arg1], "select", .length = 6))
			{
			    new arg2 = argpos(cmdtext, arg1),
			    	buttonid;
				
				if (PlayerInfo[playerid][SelectedButton] != INVALID_BUTTON_ID)
					KillTimer(PlayerInfo[playerid][TimerID]);
					
				if (!cmdtext[arg2])
				{
				    new Float:PlayerPos[3];
					GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
				    buttonid = GetClosestButton(PlayerPos);

				    if (buttonid == INVALID_BUTTON_ID)
				        SendClientMessage(playerid, 0xFF0000FF, "Can't find a button! You may need to create one!");
					
					else
					{
					    PlayerInfo[playerid][SelectedButton] = buttonid;
				    	PlayerInfo[playerid][TimerID] = SetTimerEx("ButtonEditor_Timer", 50, true, "ii", playerid, PlayerInfo[playerid][SelectedButton]);
						TogglePlayerControllable(playerid, false);
			    		format(String, sizeof(String), "Buttonid %d selected! Once you placed it where you want, save it with \"/button save <comment>\"", buttonid);
			    		SendClientMessage(playerid, 0x00FF00FF, String);
					}
				}
				else
				{
				    buttonid = strval(cmdtext[arg2]);
				    
					if (FS_IsValidButton(buttonid))
					{
					    PlayerInfo[playerid][SelectedButton] = buttonid;
				    	PlayerInfo[playerid][TimerID] = SetTimerEx("ButtonEditor_Timer", 50, true, "ii", playerid, PlayerInfo[playerid][SelectedButton]);
						TogglePlayerControllable(playerid, false);
			    		format(String, sizeof(String), "Buttonid %d selected! Once you placed it where you want, save it with \"/button save\"", buttonid);
			    		SendClientMessage(playerid, 0x00FF00FF, String);
					}
					
					else
				    	SendClientMessage(playerid, 0xFF0000FF, "This buttonid is invalid!");

				}
				return true;
			}



			else if (!strcmp(cmdtext[arg1], "save", .length = 4))
			{
			    new arg2 = argpos(cmdtext, arg1),
			    	buttonid = PlayerInfo[playerid][SelectedButton];
			    
			    if (buttonid != INVALID_BUTTON_ID)
			    {
			        new File:savedbuttons_file = fopen("savedbuttons.txt", io_append);

					if (!cmdtext[arg2])
					{
			        	format
						(
							String,
							sizeof(String),
							"CreateButton(%.2f, %.2f, %.2f, %.1f);\r\n",
							ButtonInfo[buttonid][Pos][0],
							ButtonInfo[buttonid][Pos][1],
							ButtonInfo[buttonid][Pos][2],
							float(floatround(ButtonInfo[buttonid][Pos][3])%360)
						);
					}
					else
					{
						format
						(
							String,
							sizeof(String),
							"CreateButton(%.2f, %.2f, %.2f, %.1f); // %s\r\n",
							ButtonInfo[buttonid][Pos][0],
							ButtonInfo[buttonid][Pos][1],
							ButtonInfo[buttonid][Pos][2],
							float(floatround(ButtonInfo[buttonid][Pos][3])%360),
							cmdtext[arg2]
						);
					}
					
			        fwrite(savedbuttons_file,String);
			        fclose(savedbuttons_file);
			        
			        SendClientMessage(playerid, 0x00FF00FF, "Button's informations saved in \"/scriptfiles/savedbuttons.txt\"!");
			    }
				else
				    SendClientMessage(playerid, 0xFF0000FF, "Umm..Select a button first?");

				return true;
			}



			else if (!strcmp(cmdtext[arg1], "deselect", .length = 6))
			{
			    if (PlayerInfo[playerid][SelectedButton] != INVALID_BUTTON_ID)
			    {
			        format(String, sizeof(String), "Buttonid %d deselected!", PlayerInfo[playerid][SelectedButton]);
			    	SendClientMessage(playerid, 0x00FF00FF, String);
			    	PlayerInfo[playerid][SelectedButton] = INVALID_BUTTON_ID;
			    	TogglePlayerControllable(playerid, true);
			    	KillTimer(PlayerInfo[playerid][TimerID]);
				}
				else
				    SendClientMessage(playerid, 0xFF0000FF, "Umm..Select a button first?");

				return true;
			}


			
			return false;
		}
		
		return false;
	}




	forward ButtonEditor_Timer(playerid, buttonid);
	public ButtonEditor_Timer(playerid, buttonid)
	{
	    new PlayerKeys[3],
	    	Float:Move_Sin = PlayerInfo[playerid][MSpeed]/100.0 * floatsin(-ButtonInfo[buttonid][Pos][3], degrees),
			Float:Move_Cos = PlayerInfo[playerid][MSpeed]/100.0 * floatcos(-ButtonInfo[buttonid][Pos][3], degrees);
			
	    GetPlayerKeys(playerid,PlayerKeys[0],PlayerKeys[1],PlayerKeys[2]);
	    
	    if (PlayerKeys[0] + PlayerKeys[1] + PlayerKeys[2] != 0 && PlayerKeys[0] != KEY_HANDBRAKE)
	    {
	    	if (PlayerKeys[0] & 512)
	    	{
				if (PlayerKeys[2] == KEY_LEFT)
					ButtonInfo[buttonid][Pos][3] += PlayerInfo[playerid][MSpeed]/5.0;

				else if (PlayerKeys[2] == KEY_RIGHT)
					ButtonInfo[buttonid][Pos][3] -= PlayerInfo[playerid][MSpeed]/5.0;
				
				format
				(
					String,
					sizeof(String),
					"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Rotating buttonid ~r~%d ~n~~w~Angle=~r~%d",
					buttonid,
					floatround(ButtonInfo[buttonid][Pos][3]) % 360
				);
				
				GameTextForPlayer(playerid, String, 1500, 3);
			}
			
			else
			{
	    		if (PlayerKeys[1] == KEY_UP)
	    		{
					ButtonInfo[buttonid][Pos][0] += Move_Sin;
					ButtonInfo[buttonid][Pos][1] += Move_Cos;
				}
				else if (PlayerKeys[1] == KEY_DOWN)
				{
					ButtonInfo[buttonid][Pos][0] -= Move_Sin;
					ButtonInfo[buttonid][Pos][1] -= Move_Cos;
				}
		
				if (PlayerKeys[2] == KEY_LEFT)
				{
					ButtonInfo[buttonid][Pos][0] -= Move_Cos;
					ButtonInfo[buttonid][Pos][1] += Move_Sin;
				}
				else if (PlayerKeys[2] == KEY_RIGHT)
				{
					ButtonInfo[buttonid][Pos][0] += Move_Cos;
					ButtonInfo[buttonid][Pos][1] -= Move_Sin;
				}
		
				format
				(
					String,
					sizeof(String),
					"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Moving buttonid ~r~%d ~n~~w~X=~r~%.2f ~w~Y=~r~%.2f",
					buttonid,
					ButtonInfo[buttonid][Pos][0],
					ButtonInfo[buttonid][Pos][1]
				);
				
				GameTextForPlayer(playerid, String, 1500, 3);
			}
			
			FS_SetButtonPos
			(
				buttonid,
				ButtonInfo[buttonid][Pos][0],
				ButtonInfo[buttonid][Pos][1],
				ButtonInfo[buttonid][Pos][2],
				ButtonInfo[buttonid][Pos][3]
			);
		}
	}




#endif
/*----------------------------------------------------------------------------*/

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) // Calling Fix by Winterfield - Do not remove
{
	CallRemoteFunction("OnPlayerEditGate", "iddffffff", playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
}