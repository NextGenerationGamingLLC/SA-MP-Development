CMD:togemailcheck(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return 1;
	SendClientMessageEx(playerid, -1, emailcheck ? ("Email checks disabled"):("Email checks enabled"));
	emailcheck = !emailcheck;
	return 1;
}

InvalidEmailCheck(playerid, email[], task)
{
	if(isnull(email))
		return ShowPlayerDialogEx(playerid, EMAIL_VALIDATION, DIALOG_STYLE_INPUT, "E-mail Registration", "Please enter a valid e-mail address to associate with your account.", "Submit", "");
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "%s/email_check.php?t=%d&e=%s", SAMP_WEB, task, email);
	HTTP(playerid, HTTP_GET, szMiscArray, "", "OnInvalidEmailCheck");
	return 1;
}

forward OnInvalidEmailCheck(playerid, response_code, data[]);
public OnInvalidEmailCheck(playerid, response_code, data[])
{
	if(response_code == 200)
	{
		new result = strval(data);
		if(result == 0) // Invalid, Show dialog
			ShowPlayerDialogEx(playerid, EMAIL_VALIDATION, DIALOG_STYLE_INPUT, "E-mail Registration - {FF0000}Error", "Please enter a valid e-mail address to associate with your account.", "Submit", "");
		if(result == 1) // Valid from login check
			if(!GetPVarInt(playerid, "EmailConfirmed"))
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "Your email has not yet been confirmed. Please take steps to confirm it or go to cp.ng-gaming.net to change your email.");
			}
		if(result == 2) // Valid from dialog
		{
			szMiscArray[0] = 0;
			GetPVarString(playerid, "pEmail", szMiscArray, 128);
			mysql_escape_string(szMiscArray, PlayerInfo[playerid][pEmail]);
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET `Email` = '%s', `EmailConfirmed` = 0 WHERE `id` = %d", PlayerInfo[playerid][pEmail], PlayerInfo[playerid][pId]);
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
			format(szMiscArray, sizeof(szMiscArray), "A confirmation email will be sent to '%s' soon.\n\
			This email will need to be confirmed within 7 days or you will be prompted to enter a new one.\n\
			Please make an effort to confirm it as it will be used for important changes and notifications in regards to your account.", PlayerInfo[playerid][pEmail]);
			ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Email Confirmation", szMiscArray, "Okay", "");
			format(szMiscArray, sizeof(szMiscArray), "%s/mail.php?id=%d", CP_WEB, PlayerInfo[playerid][pId]);
			HTTP(playerid, HTTP_HEAD, szMiscArray, "", "");
		}
	}
	return 1;
}

#include <YSI\y_hooks>
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	if(dialogid == EMAIL_VALIDATION)
	{
		if(!response || isnull(inputtext))
			ShowPlayerDialogEx(playerid, EMAIL_VALIDATION, DIALOG_STYLE_INPUT, "E-mail Registration - {FF0000}Error", "Please enter a valid e-mail address to associate with your account.", "Submit", "");
		SetPVarString(playerid, "pEmail", inputtext);
		InvalidEmailCheck(playerid, inputtext, 2);
	}
	return 0;
}