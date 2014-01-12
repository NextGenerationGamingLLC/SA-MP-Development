//
// Example use of chat above player's head
//

#include <a_samp>
#include "../include/gl_common.inc"

#define MESSAGE_COLOR 		  0xEEEEEEFF
#define ECHO_COLOR 		  	  0xEEEEEEFF
#define ACTION_COLOR     	  0xEE66EEFF

//------------------------------------------------

public OnFilterScriptInit()
{
	print("\n--Speech bubble example loaded.\n");
	return 1;
}

//------------------------------------------------

public OnPlayerText(playerid, text[])
{
	 if(strlen(text) > 128) return 0;
	 
	 new to_others[MAX_CHATBUBBLE_LENGTH+1];
	 new to_me[MAX_CHATBUBBLE_LENGTH+1];
	 
	 format(to_others,MAX_CHATBUBBLE_LENGTH,"Says: %s",text);
	 format(to_me,MAX_CHATBUBBLE_LENGTH,">> %s",text);
	 
     SetPlayerChatBubble(playerid,to_others,MESSAGE_COLOR,35.0,10000);
     SendClientMessage(playerid,ECHO_COLOR,to_me);
     
     return 0; // can't do normal chat with this loaded
}

//------------------------------------------------

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256];
	new Message[256];
	new	idx;
	new actiontext[MAX_CHATBUBBLE_LENGTH+1];

	cmd = strtok(cmdtext, idx);

	// Action command
	if(strcmp("/me", cmd, true) == 0)
	{
	    Message = strrest(cmdtext,idx);
	    format(actiontext,MAX_CHATBUBBLE_LENGTH,"* %s",Message);
       	SetPlayerChatBubble(playerid,actiontext,ACTION_COLOR,30.0,10000);
    	SendClientMessage(playerid,ACTION_COLOR,actiontext);
		return 1;
	}
	
	return 0; // not handled by this script
}

//------------------------------------------------

