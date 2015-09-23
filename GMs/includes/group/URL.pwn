/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[URL.PWN]--------------------------------


 * Copyright (c) 2014, Next Generation Gaming, LLC
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

new Float:rFL[1][3], Float:rSP[MAX_RSP][4], rCRU[128], Float:rDistance, Startpoints, CPT;

#include <YSI\y_hooks>

// Hooks
hook OnGameModeInit() {

	ResetRaceProperties();
	return 1;
}

hook OnGameModeExit() {

    DeleteGVar("rFL");
    DeleteGVar("rSP");
    DeleteGVar("rCRU");
    DeleteGVar("rRA");
    DeleteGVar("rType");
    DeleteGVar("rDistance");
    DeleteGVar("rDP");
    DeleteGVar("rLaps");
    DeleteGVar("Startpoints");
    DeleteGVar("cPN");
    DeleteGVar("sPN");
    DeleteGVar("CPT");
    DeleteGVar("Racers");
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	DeletePVar(playerid, "rR");
	DeletePVar(playerid, "rECP");
	DeletePVar(playerid, "rESP");
	DeletePVar(playerid, "rESP");
	DeletePVar(playerid, "rED");
	DeletePVar(playerid, "rCEC");
	DeletePVar(playerid, "LapsDone");
	DeletePVar(playerid, "rLapTime");
	DeletePVar(playerid, "rLTS");
	DeletePVar(playerid, "rLS");
	DeletePVar(playerid, "rLM");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(dialogid)
		{
		    case 1:
		    {
		        switch(listitem)
		        {
		            case 0:
		            {
		                ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT, "Race Setup", "Please enter a specified race type.\n{66AACC}1 {FFFFFF}for impromptu, {66AACC}2 {FFFFFF}for circut.", "Confirm", "Close");
		            }
		            case 1:
		            {
		                if(GetGVarInt("rType") == 1)
						{

					 		DisplayRaceDialog(playerid);
					 		return SendClientMessage(playerid, -1, "You cannot use laps with a impromptu race.");
						}
		                ShowPlayerDialog(playerid, 3, DIALOG_STYLE_INPUT, "Race Setup", "Please enter a specified number of race laps.\n{66AACC}1{FFFFFF}-{66AACC}10{FFFFFF}", "Confirm", "Close");
		            }
		            case 2:
		            {
		                if(GetPVarInt(playerid, "rECP") >= 1) return SendClientMessage(playerid, -1, "You are currently already editing the finishline!");
		                if(GetPVarInt(playerid, "rED") >= 1) return SendClientMessage(playerid, -1, "You are currently already editing the distance point!");
		                if(GetPVarInt(playerid, "rESP") >= 1) return SendClientMessage(playerid, -1, "You are currently already editing startpoints! Hit Y to finish!");
                  		SendClientMessage(playerid, -1, "You have began editing the race finishline, please press your {8A0829}FIRE {FFFFFF}key to place the finishline.");
		                SetPVarInt(playerid, "rECP", 1);
		            }
		            case 3:
		            {
		                if(GetPVarInt(playerid, "rECP") >= 1) return SendClientMessage(playerid, -1, "You are currently already editing the finishline!");
		                if(GetPVarInt(playerid, "rED") >= 1) return SendClientMessage(playerid, -1, "You are currently already editing the distance point!");
		                if(GetPVarInt(playerid, "rESP") >= 1) return SendClientMessage(playerid, -1, "You are currently already editing startpoints! Hit Y to finish!");
                  		SendClientMessage(playerid, -1, "You have began editing the race starts, please press your {8A0829}FIRE {FFFFFF}key to place a start. (Hit Y when you've finished.)");
		                SetPVarInt(playerid, "rESP", 1);
		            }
		            case 4:
		            {
		                if(GetPVarInt(playerid, "rECP") >= 1) return SendClientMessage(playerid, -1, "You are currently already editing the finishline!");
		                if(GetPVarInt(playerid, "rED") >= 1) return SendClientMessage(playerid, -1, "You are currently already editing the distance point!");
		                if(GetPVarInt(playerid, "rESP") >= 1) return SendClientMessage(playerid, -1, "You are currently already editing startpoints! Hit Y to finish!");
		                if(GetGVarInt("rType") != 2) return SendClientMessage(playerid, -1, "Distance cannot be used with impromptu.");
		                if(GetGVarInt("cPN") <= -1) return SendClientMessage(playerid, -1, "You MUST add the finishline before adding the distance point!");
                  		SendClientMessage(playerid, -1, "How far should the racer have to travel before re-entering the checkpoint? Please press your {8A0829}FIRE {FFFFFF}key to finish.");
		                SetPVarInt(playerid, "rED", 1);
		            }
		            case 5:
		            {
		                ShowPlayerDialog(playerid, 5, DIALOG_STYLE_INPUT, "Race Setup", "Please enter a custom radio URL.\n", "Confirm", "Close");
		            }
		            case 6:
		            {
		                new string[128];
		                if(GetGVarInt("cPN") <= -1) return SendClientMessage(playerid, -1, "You must add the finish line before starting a race!");
		                if(GetGVarInt("sPN") <= 1) return SendClientMessage(playerid, -1, "You must add at least two start points before starting a race!");
		                if(GetGVarInt("rType") >= 2 && GetGVarInt("rLaps") <= 1) return SendClientMessage(playerid, -1, "You must add at least two laps before starting a circut race!");
		                if(GetGVarInt("rType") >= 2 && GetGVarInt("rDP") <= -1) return SendClientMessage(playerid, -1, "You must add a distance point before starting a circut!");
						SetGVarInt("rRA", 1);
						SetGVarInt("rStarter", playerid);
						format(string, 128, "%s has set up a race! Use the command /joinrace to participate.", GetPlayerNameEx(playerid));
 						SendGroupMessage(9, COLOR_YELLOW, string);
		            }
		            case 7:
		            {
  	   		    		ResetRaceProperties();
	   		   		 	DisplayRaceDialog(playerid);
		            }
				}
			}
			case 2:
		    {
		        if(IsNumeric(inputtext))
		        {
		        	if(strval(inputtext) >= 0 && strval(inputtext) <= 2)
		        	{
		                SetGVarInt("rType", strval(inputtext));

		                DisplayRaceDialog(playerid);
		                if(strval(inputtext) == 2) { SetGVarInt("rLaps", 2); }
		                if(strval(inputtext) == 1) { SetGVarInt("rLaps", 0); }
		        	}
		        	else return ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT, "Race Setup", "Please enter a specified race type.\n{66AACC}1 {FFFFFF}for impromptu, {66AACC}2 {FFFFFF}for circut.\n\n{8A0829} Invalid Race Type!", "Confirm", "Close");
				}
				else return ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT, "Race Setup", "Please enter a specified race type.\n{66AACC}1 {FFFFFF}for impromptu, {66AACC}2 {FFFFFF}for circut.\n\n{8A0829} Please enter a numeric value!", "Confirm", "Close");
			}
			case 3:
		    {
		        if(IsNumeric(inputtext))
		        {
		        	if(strval(inputtext) >= 0 && strval(inputtext) <= 10)
		        	{
		                SetGVarInt("rLaps", strval(inputtext));

		                DisplayRaceDialog(playerid);
		        	}
		        	else return ShowPlayerDialog(playerid, 3, DIALOG_STYLE_INPUT, "Race Setup", "Please enter a specified number of race laps.\n{66AACC}1{FFFFFF}-{66AACC}10{FFFFFF}", "Confirm", "Close");
				}
				else return ShowPlayerDialog(playerid, 3, DIALOG_STYLE_INPUT, "Race Setup", "Please enter a specified number of race laps.\n{66AACC}1{FFFFFF}-{66AACC}10{FFFFFF}\n\n{8A0829} Please enter a numeric value!", "Confirm", "Close");
			}
			case 4:
		    {
		        new string[128];
     	    	format(string, 128, "%s", inputtext);
      	    	SetGVarString("rCRU", string);

	        	SendClientMessage(playerid, -1, "*   You have successfully set the race radio station.");
       	    	DisplayRaceDialog(playerid);
	   		}
		}
	}
	return 1;
}
hook OnPlayerEnterRaceCheckpoint(playerid)
{
    if(GetGVarInt("rType") == 2 && GetPVarInt(playerid, "rCEC") == 1)
	{
	    // Perhaps a check- doesn't have to be here but maybe to ensure the player is still in URL
	    {
    		new i = GetPVarInt(playerid, "LapsDone");
	    	SetPVarInt(playerid, "LapsDone", i + 1);
			new lapstring[256];
			SetPVarInt(playerid, "rLTS", gettime() - GetPVarInt(playerid, "rLapTime"));
			SetPVarInt(playerid, "rLS", GetPVarInt(playerid,"rLTS") % 60);
			SetPVarInt(playerid,"rLM",(GetPVarInt(playerid, "rLTS") - GetPVarInt(playerid, "rLS")) / 60);
 			if(GetPVarInt(playerid, "rLS") << 10) { format(lapstring, 256, "~r~LAP %d/%d COMPLETE~n~~g~LAP TIME: ~y~%i:0%i.", GetPVarInt(playerid, "LapsDone"), GetGVarInt("rLaps"), GetPVarInt(playerid, "rLM"), GetPVarInt(playerid, "rLS")); }
 			else { format(lapstring, 256, "~r~LAP %d/%d COMPLETE~n~~g~LAP TIME: ~y~%i:%i.", GetPVarInt(playerid, "LapsDone"), GetGVarInt("rLaps"), GetPVarInt(playerid, "rLM"), GetPVarInt(playerid, "rLS")); }
  			GameTextForPlayer(playerid, lapstring, 5000, 4);
	        DisablePlayerRaceCheckpoint(playerid);
	        if(GetPVarInt(playerid, "LapsDone") + 1 == GetGVarInt("rLaps")) { SetPlayerRaceCheckpoint(playerid, 1, rFL[0][0], rFL[0][1], rFL[0][2], 0.0, 0.0, 0.0, 10); }
	        else if(GetPVarInt(playerid, "LapsDone") == GetGVarInt("rLaps")) EndRace(playerid, 0);
			else { SetPlayerRaceCheckpoint(playerid, 0, rFL[0][0], rFL[0][1], rFL[0][2], 0.0, 0.0, 0.0, 10); }
			SetPVarInt(playerid, "rLapTime", gettime());
      		SetPVarInt(playerid, "rCEC", 0);
      		CPT = SetTimerEx("CanEnterCheckpoint", 1000, true, "i", playerid);
		}
		return 1;
	}
	else if(GetGVarInt("rType") == 1) { EndRace(playerid, 0); }
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if ((newkeys & KEY_FIRE) && !(oldkeys & KEY_FIRE))
    {
        if(GetPVarInt(playerid, "rECP") >= 1)
        {
            if(GetGVarInt("rDP") >= 1) return SendClientMessage(playerid, -1, "You have reached the maximum number of finishlines. (1)");

            GetPlayerPos(playerid, rFL[0][0], rFL[0][1], rFL[0][2]);
            SendClientMessage(playerid, -1, "Finishline set.");
            DisplayRaceDialog(playerid);
            SetPVarInt(playerid, "rECP", 0);
            SetGVarFloat("rFLX", rFL[0][0]);
    		SetGVarFloat("rFLY", rFL[0][1]);
    		SetGVarFloat("rFLZ", rFL[0][2]);
    		new r = GetGVarInt("cPN");
    		SetGVarInt("cPN", r + 1);
        }

        else if(GetPVarInt(playerid, "rESP") >= 1)
        {
            if(GetGVarInt("Startpoints", Startpoints) >= 3) return SendClientMessage(playerid, -1, "You have reached the maximum number of start points. (4)");
            new i = GetGVarInt("Startpoints", Startpoints);
            SetGVarInt("Startpoints", i + 1);

            GetPlayerPos(playerid, rSP[Startpoints][0], rSP[Startpoints][1], rSP[Startpoints][2]);
            if(!IsPlayerInAnyVehicle(playerid)) GetPlayerFacingAngle(playerid, rSP[Startpoints][3]);
            else {
            new veh = GetPlayerVehicleID(playerid);
            GetVehicleZAngle(veh, rSP[Startpoints][3]); }

            SendClientMessage(playerid, -1, "Startpoint set.");
            SetGVarFloat("rSPX", rSP[Startpoints][0]);
    		SetGVarFloat("rSPY", rSP[Startpoints][1]);
    		SetGVarFloat("rSPZ", rSP[Startpoints][2]);
    		SetGVarFloat("rSPA", rSP[Startpoints][3]);
    		new r = GetGVarInt("sPN");
    		SetGVarInt("sPN", r + 1);
    		printf("%f, %f, %f, %f", rSP[Startpoints][0], rSP[Startpoints][1], rSP[Startpoints][2], rSP[Startpoints][3]);
        }
        else if(GetPVarInt(playerid, "rED") >= 1)
		{
            SetGVarFloat("rDistance", GetPlayerDistanceFromPoint(playerid, rFL[0][0], rFL[0][1], rFL[0][2]));
            SendClientMessage(playerid, -1, "Distance set.");
            SetPVarInt(playerid, "rED", 0);
            DisplayRaceDialog(playerid);
            new r = GetGVarInt("rDP");
    		SetGVarInt("rDP", r + 1);
		}
    }
    if ((newkeys & KEY_YES) && !(oldkeys & KEY_YES))
    {
        if(GetPVarInt(playerid, "rESP") >= 1)
        {
            SendClientMessage(playerid, -1, "You have stopped editing start points, to reset them, redo them or hit the 'reset' button.");
            SetGVarInt("Startpoints", -1);
            SetPVarInt(playerid, "rESP", 0);
        }
    }
	return 1;
}

// Timers
forward CanEnterCheckpoint(playerid);
public CanEnterCheckpoint(playerid)
{
	new Float:fDistance;
    fDistance = GetPlayerDistanceFromPoint(playerid, rFL[0][0], rFL[0][1], rFL[0][2]);

    if(fDistance >= GetGVarFloat("rDistance"))
    {
    	SetPVarInt(playerid, "rCEC", 1);
    	KillTimer(CPT);
	}
}

// Functions

ResetRaceProperties()
{

	SetGVarFloat("rFLX", -1);
	SetGVarFloat("rFLY", -1);
	SetGVarFloat("rFLZ", -1);

	for(new i = 0; i < MAX_RSP; i++)
    {
    	SetGVarFloat("rSPX", -1);
    	SetGVarFloat("rSPY", -1);
    	SetGVarFloat("rSPZ", -1);
    	SetGVarFloat("rSPA", -1);
	}

	SetGVarFloat("-1", rDistance);

    SetGVarString(rCRU, "Not Set");
    SetGVarInt("rType", 1);
    SetGVarInt("rLaps", 0);
    SetGVarInt("rRA", 0);
	SetGVarInt("Racers", -1);
    SetGVarInt("Startpoints", -1);
    SetGVarInt("cPN", -1);
    SetGVarInt("rDP", -1);
	return 1;
}


DisplayRaceDialog(playerid)
{
    new string[462];

    format(string, sizeof(string), "Race Type{66AACC}%d\nLaps{66AACC}%d\nSet Race Finshline\n\
    	Set Race Startpoints{66AACC}\nSet Race Distance\nCustom Radio Station\nConfirm Race\nReset", GetGVarInt("rType"), GetGVarInt("rLaps"));
    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_LIST, "Race Setup", string, "Race Setup", "Cancel");
}

EndRace(playerid, forceend)
{
	new string[128];
    foreach(new i : Player)
    {
        if(GetPVarInt(i, "rR") >= 1)
        {
            TogglePlayerControllable(i, 1);
            DisablePlayerRaceCheckpoint(i);
            SetPVarInt(i, "rR", 0);
            StopAudioStreamForPlayer(i);
        }
    }
    if(forceend != 1 && GetGVarInt("rType") >= 2)
    {
		new lapstring[256];
		SetPVarInt(playerid, "rLTS", gettime() - GetPVarInt(playerid, "rLapTime"));
		SetPVarInt(playerid, "rLS", GetPVarInt(playerid,"rLTS") % 60);
		SetPVarInt(playerid,"rLM",(GetPVarInt(playerid, "rLTS") - GetPVarInt(playerid, "rLS")) / 60);
		if(GetPVarInt(playerid, "rLS") << 10) { format(lapstring, 256, "~r~LAP %d/%d COMPLETE~n~~g~LAP TIME: ~y~%i:0%i.", GetPVarInt(playerid, "LapsDone"), GetGVarInt("rLaps"), GetPVarInt(playerid, "rLM"), GetPVarInt(playerid, "rLS")); }
		else { format(lapstring, 256, "~r~LAP %d/%d COMPLETE~n~~g~LAP TIME: ~y~%i:%i.", GetPVarInt(playerid, "LapsDone"), GetGVarInt("rLaps"), GetPVarInt(playerid, "rLM"), GetPVarInt(playerid, "rLS")); }
		GameTextForPlayer(playerid, lapstring, 5000, 4);
   }

  	ResetRaceProperties();

    format(string, 128, "%s has force ended the race!", GetPlayerNameEx(playerid));
    if(forceend >= 1) { SendGroupMessage(9, COLOR_YELLOW, string); return 1; }

	format(string, 128, "Congratulations to %s for winning the race!", GetPlayerNameEx(playerid));
    SendGroupMessage(9, COLOR_YELLOW, string);
    return 1;
}


CMD:editrace(playerid, params[])
{
	if(IsARacer(playerid) && PlayerInfo[playerid][pLeader] == PlayerInfo[playerid][pMember])
	{
    	if(GetGVarInt("rRA") >= 1) return SendClientMessage(playerid, -1, "*   Please wait, a race is already active.");

	    DisplayRaceDialog(playerid);
    	return 1;
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a in the URL or a URL leader.");
	return 1;
}

CMD:startrace(playerid, params[])
{
	if(IsARacer(playerid) && PlayerInfo[playerid][pLeader] == PlayerInfo[playerid][pMember])
	{
    	if(GetGVarInt("rRA") <= 0) return SendClientMessage(playerid, -1, "There are currently no races active.");

    	foreach(new i : Player)
    	{
        	if(GetPVarInt(i, "rR") >= 1)
        	{
        	    SetPVarInt(playerid, "rLapTime", gettime());
            	TogglePlayerControllable(i, 1);
            	GameTextForPlayer(i, "~g~Go!", 5000, 4);
            	SetPVarInt(playerid, "LapsDone", 0);
            	SetGVarInt("rCEC", 1);
            	SetPlayerRaceCheckpoint(i, 1, rFL[0][0], rFL[0][1], rFL[0][2], 0.0, 0.0, 0.0, 10);
        	}
    	}
    	if(GetGVarInt("rType") == 2) { CPT = SetTimerEx("CanEnterCheckpoint", 1000, true, "i", playerid); } // Not really sure how to make this a Gvar, all it does is give a variable to the timer so it's not that big of a deal, you can make it one if you want but I'm lost on how to myself.
    }
    else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a in the URL or a URL leader.");
    return 1;
}

CMD:endrace(playerid, params[])
{
	if(IsARacer(playerid) && PlayerInfo[playerid][pLeader] == PlayerInfo[playerid][pMember])
	{
    	if(GetGVarInt("rRA") <= 0) return SendClientMessage(playerid, -1, "There are currently no races active.");
    	EndRace(playerid, 1);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a in the URL or a URL leader.");
	return 1;
}

CMD:joinrace(playerid, params[])
{
	if(IsARacer(playerid))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 35.0, rSP[0][0], rSP[0][1], rSP[0][2]))
	    {
	        if(IsPlayerInAnyVehicle(playerid)) // Or make it so they need their own vehicle, it's up to you Dom - jason.
	        {
    			if(GetGVarInt("rRA") <= 0) return SendClientMessage(playerid, -1, "There are currently no races active.");
    			if(GetPVarInt(playerid, "rR") >= 1) return SendClientMessage(playerid, -1, "You are already in a race!");

    			new i = GetGVarInt("Racers");
				SetGVarInt("Racers", i + 1);

				if(GetGVarFloat("rSPX") == -1) return SendClientMessage(playerid, -1, "There are no more start points to support another racer.");

				new vehid = GetPlayerVehicleID(playerid);
				SetVehiclePos(vehid, rSP[GetGVarInt("Racers")][0],rSP[GetGVarInt("Racers")][1],rSP[GetGVarInt("Racers")][2]);
				SetVehicleZAngle(vehid, rSP[GetGVarInt("Racers")][3]);

	  	  		GetGVarString("rCRU", rCRU, sizeof(rCRU));
    			PlayAudioStreamForPlayer(playerid, rCRU);
    			TogglePlayerControllable(playerid, 0);
    			SetCameraBehindPlayer(playerid);
    			SetPVarInt(playerid, "rR", 1);
    			return 1;
			}
		}
		else SendClientMessage(playerid, -1, "You are not near a race starting point.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a in the URL.");
	return 1;
}