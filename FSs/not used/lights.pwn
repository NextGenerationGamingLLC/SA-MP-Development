//-_-_-_-_-_-_-_-_-_-_-_-_Neon System By [EDT]Quattro-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
//-_-_-_-_-_-_-_-_-_-_-_-_-_-Do Not Remove Credits_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
//-_-_-_-_-_-_-_-_-_-_-_-_-Commands: /neonshop /neon-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
//-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_Enjoy Using It!-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
//-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

#include <a_samp>
#define LIGHTS 1515151
new blue, blue2, red, red2, green, green2, white, white2, pink, pink2, yellow, yellow2, police, police2, interior, interior2, back, back2, front, front2, undercover, undercover2;
new status[11];

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp(cmdtext, "/neon123", true)==0)
	{
 		if(IsPlayerAdmin(playerid))
    	{
    		ShowPlayerDialog(playerid, 8889, DIALOG_STYLE_LIST, "Pick Neon Color", "Blue\nRed\nGreen\nWhite\nPink\nYellow\nPolice Strobe\nInterior Lights\nBack Neon\nFront neon\nUndercover Roof Light\nRemove All Neon", "Select", "Cancel");
    		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 10.0);
		}
		return 1;
	}
	
	if (strcmp("/santa1234", cmdtext, true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			SetPlayerAttachedObject(playerid, 0, 19079, 1, -10, -5, 1,0,0, 0,50,50,50);
			return 1;
		}
	}
		
	if (strcmp(cmdtext, "/undercovah", true)==0)
	{
		if(IsPlayerAdmin(playerid))
 		{
			if(status[10] == 1)
		    {
		        DestroyObject(undercover);
    			DestroyObject(undercover2);
    			status[10] = 0;
			}
			else
			{
			    status[10] = 1;
	   			//undercover
	   			undercover = CreateObject(18646,0,0,0,0,0,0);
	            undercover2 = CreateObject(18646,0,0,0,0,0,0);
	            AttachObjectToVehicle(undercover, GetPlayerVehicleID(playerid), -0.5, -0.2, 0.8, 2.0, 2.0, 3.0);
	            AttachObjectToVehicle(undercover2, GetPlayerVehicleID(playerid), -0.5, -0.2, 0.8, 2.0, 2.0, 3.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Undercover lights installed");
			}

			if(status[8] == 1)
		    {
		        DestroyObject(back);
   				DestroyObject(back2);
   				status[8] = 0;
			}
			else
			{
			    status[8] = 1;
				//back
	            back = CreateObject(18646,0,0,0,0,0,0);
	            back2 = CreateObject(18646,0,0,0,0,0,0);
	            AttachObjectToVehicle(back, GetPlayerVehicleID(playerid), -0.0, -1.5, -1, 2.0, 2.0, 3.0);
	            AttachObjectToVehicle(back2, GetPlayerVehicleID(playerid), -0.0, -1.5, -1, 2.0, 2.0, 3.0);
	            SendClientMessage(playerid, 0xFFFFFFAA, "Back neon installed");
			}

		    if(status[9] == 1)
		    {
		        DestroyObject(front);
   				DestroyObject(front2);
    			status[9] = 0;
			}
			else
			{
			    status[9] = 1;
				//front
	   			front = CreateObject(18646,0,0,0,0,0,0);
	        	front2 = CreateObject(18646,0,0,0,0,0,0);
	         	AttachObjectToVehicle(front, GetPlayerVehicleID(playerid), -0.0, 1.5, -1, 2.0, 2.0, 3.0);
	  	       	AttachObjectToVehicle(front2, GetPlayerVehicleID(playerid), -0.0, 1.5, -1, 2.0, 2.0, 3.0);
	           	SendClientMessage(playerid, 0xFFFFFFAA, "Front neon installed");
           	}
		}
		return 1;
	}
	return 0;
}

public OnFilterScriptInit()
{
    status[0] = 0;
    status[1] = 0;
    status[2] = 0;
    status[3] = 0;
    status[4] = 0;
    status[5] = 0;
    status[6] = 0;
    status[7] = 0;
    status[8] = 0;
    status[9] = 0;
    status[10] = 0;
}
public OnFilterScriptExit()
{
	RemoveAll();
}
stock RemoveAll()
{
    status[0] = 0;
    status[1] = 0;
    status[2] = 0;
    status[3] = 0;
    status[4] = 0;
    status[5] = 0;
    status[6] = 0;
    status[7] = 0;
    status[8] = 0;
    status[9] = 0;
    status[10] = 0;
    
    DestroyObject(blue);
    DestroyObject(blue2);
	DestroyObject(red);
	DestroyObject(red2);
	DestroyObject(green);
	DestroyObject(white);
	DestroyObject(pink);
	DestroyObject(yellow);
	DestroyObject(green2);
	DestroyObject(white2);
	DestroyObject(pink2);
	DestroyObject(yellow2);
	DestroyObject(police);
	DestroyObject(interior);
	DestroyObject(police2);
	DestroyObject(interior2);
	DestroyObject(back);
	DestroyObject(front);
	DestroyObject(undercover);
	DestroyObject(back2);
	DestroyObject(front2);
	DestroyObject(undercover2);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
 	if(dialogid == 8889)
	{
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 10.0);
		if(response)
		{
			if(listitem == 0)
			{
			    if(status[0] == 1)
			    {
			        DestroyObject(blue);
    				DestroyObject(blue2);
    				status[0] = 0;
				}
				else
				{
				    status[0] = 1;
					//blue
					blue = CreateObject(18648,0,0,0,0,0,0);
		            blue2 = CreateObject(18648,0,0,0,0,0,0);
		            AttachObjectToVehicle(blue, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            AttachObjectToVehicle(blue2, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				}
		 	}
			if(listitem == 1)
			{
			    if(status[1] == 1)
			    {
			        DestroyObject(red);
    				DestroyObject(red2);
    				status[1] = 0;
				}
				else
				{
				    status[1] = 1;
					//red
		            red = CreateObject(18647,0,0,0,0,0,0);
		            red2 = CreateObject(18647,0,0,0,0,0,0);
		            AttachObjectToVehicle(red, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            AttachObjectToVehicle(red2, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid, 0xFFFFFFAA, "neon installed");
				}
			}
			if(listitem == 2)
			{
			    if(status[2] == 1)
			    {
			        DestroyObject(green);
    				DestroyObject(green2);
    				status[2] = 0;
				}
				else
				{
				    status[2] = 1;
					//green
		  			green = CreateObject(18649,0,0,0,0,0,0);
		            green2 = CreateObject(18649,0,0,0,0,0,0);
		            AttachObjectToVehicle(green, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            AttachObjectToVehicle(green2, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid, 0xFFFFFFAA, "neon installed");
				}
      		}
			if(listitem == 3)
			{
			    if(status[3] == 1)
			    {
			        DestroyObject(white);
    				DestroyObject(white2);
    				status[3] = 0;
				}
				else
				{
				    status[3] = 1;
					//white
			   	   	white = CreateObject(18652,0,0,0,0,0,0);
		            white2 = CreateObject(18652,0,0,0,0,0,0);
		            AttachObjectToVehicle(white, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            AttachObjectToVehicle(white2, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid, 0xFFFFFFAA, "neon installed");
				}
			}
			if(listitem == 4)
			{
			    if(status[4] == 1)
			    {
			        DestroyObject(pink);
    				DestroyObject(pink2);
    				status[4] = 0;
				}
				else
				{
				    status[4] = 1;
				    pink = CreateObject(18651,0,0,0,0,0,0);
		            pink2 = CreateObject(18651,0,0,0,0,0,0);
		            AttachObjectToVehicle(pink, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            AttachObjectToVehicle(pink2, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid, 0xFFFFFFAA, "neon installed");
				}
			}
			if(listitem == 5)
			{
			    if(status[5] == 1)
			    {
			        DestroyObject(yellow);
    				DestroyObject(yellow2);
    				status[5] = 0;
				}
				else
				{
				    status[5] = 1;
					//yellow
				 	yellow = CreateObject(18650,0,0,0,0,0,0);
		            yellow2 = CreateObject(18650,0,0,0,0,0,0);
		            AttachObjectToVehicle(yellow, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            AttachObjectToVehicle(yellow2, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid, 0xFFFFFFAA, "neon installed");
				}
			}
			if(listitem == 6)
			{
			    if(status[6] == 1)
			    {
			        DestroyObject(police);
    				DestroyObject(police2);
    				status[6] = 0;
				}
				else
				{
				    status[6] = 1;
					//police
	   	 		   	police = CreateObject(18646,0,0,0,0,0,0);
		            police2 = CreateObject(18646,0,0,0,0,0,0);
		            AttachObjectToVehicle(police, GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            AttachObjectToVehicle(police2, GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		            SendClientMessage(playerid, 0xFFFFFFAA, "neon installed");
				}
           	}

			if(listitem == 7)
			{
                if(status[7] == 1)
			    {
			        DestroyObject(interior);
    				DestroyObject(interior2);
    				status[7] = 0;
				}
				else
				{
				    status[7] = 1;
		           	interior = CreateObject(18646,0,0,0,0,0,0);
		            interior2 = CreateObject(18646,0,0,0,0,0,0);
		            AttachObjectToVehicle(interior, GetPlayerVehicleID(playerid), 0, -0.0, 0, 2.0, 2.0, 3.0);
		            AttachObjectToVehicle(interior2, GetPlayerVehicleID(playerid), 0, -0.0, 0, 2.0, 2.0, 3.0);
		            SendClientMessage(playerid, 0xFFFFFFAA, "Interior lights installed");
				}
			}
          	if(listitem == 8)
			{
			    if(status[8] == 1)
			    {
			        DestroyObject(back);
    				DestroyObject(back2);
    				status[8] = 0;
				}
				else
				{
				    status[8] = 1;
					//back
		            back = CreateObject(18646,0,0,0,0,0,0);
		            back2 = CreateObject(18646,0,0,0,0,0,0);
		            AttachObjectToVehicle(back, GetPlayerVehicleID(playerid), -0.0, -1.5, -1, 2.0, 2.0, 3.0);
		            AttachObjectToVehicle(back2, GetPlayerVehicleID(playerid), -0.0, -1.5, -1, 2.0, 2.0, 3.0);
		            SendClientMessage(playerid, 0xFFFFFFAA, "Back neon installed");
				}
    		}
     		if(listitem == 9)
			{
			    if(status[9] == 1)
			    {
			        DestroyObject(front);
    				DestroyObject(front2);
    				status[9] = 0;
				}
				else
				{
				    status[9] = 1;
					//front
		   			front = CreateObject(18646,0,0,0,0,0,0);
		        	front2 = CreateObject(18646,0,0,0,0,0,0);
		         	AttachObjectToVehicle(front, GetPlayerVehicleID(playerid), -0.0, 1.5, -0.6, 2.0, 2.0, 3.0);
		  	       	AttachObjectToVehicle(front2, GetPlayerVehicleID(playerid), -0.0, 1.5, -0.6, 2.0, 2.0, 3.0);
		           	SendClientMessage(playerid, 0xFFFFFFAA, "Front neon installed");
				}
            }
            if(listitem == 10)
			{
			    if(status[10] == 1)
			    {
			        DestroyObject(undercover);
    				DestroyObject(undercover2);
    				status[10] = 0;
				}
				else
				{
				    status[10] = 1;
	   				//undercover
	    			undercover = CreateObject(18646,0,0,0,0,0,0);
		            undercover2 = CreateObject(18646,0,0,0,0,0,0);
		            AttachObjectToVehicle(undercover, GetPlayerVehicleID(playerid), -0.5, -0.2, 0.8, 2.0, 2.0, 3.0);
		            AttachObjectToVehicle(undercover2, GetPlayerVehicleID(playerid), -0.5, -0.2, 0.8, 2.0, 2.0, 3.0);
		            SendClientMessage(playerid, 0xFFFFFFAA, "Undercover lights installed");
				}
         	}
			if(listitem == 11)
			{
				//remove neon
	            RemoveAll();
			}
		}
	}
	return 0;
	}
