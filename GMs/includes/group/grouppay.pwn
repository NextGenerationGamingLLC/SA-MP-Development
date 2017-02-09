#include <YSI\y_hooks>

GovEditGroupBudget(playerid)
{
	szMiscArray[0] = 0;
	new szTitle[GROUP_MAX_NAME_LEN + 8];
	for(new i = 0; i != MAX_GROUPS; ++i) {
		if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] != arrGroupData[i][g_iAllegiance]) {
			format(szMiscArray, sizeof szMiscArray, "%s----\t{FFFFFF}----\n", szMiscArray);
		}
		else format(szMiscArray, sizeof szMiscArray, "%s{%s}%s\t{FFFFFF}$%s\n", szMiscArray, Group_NumToDialogHex(arrGroupData[i][g_hDutyColour]), arrGroupData[i][g_szGroupName], number_format(arrGroupData[i][g_iBudgetPayment]));
	}
	format(szTitle, sizeof(szTitle), "{%s}%s {FFFFFF}| Budget Overview", Group_NumToDialogHex(arrGroupData[PlayerInfo[playerid][pLeader]][g_hDutyColour]), arrGroupData[PlayerInfo[playerid][pLeader]][g_szGroupName]);
	return ShowPlayerDialogEx(playerid, DIALOG_GROUP_GOVLISTPAY, DIALOG_STYLE_TABLIST, "Edit Group Budget", szMiscArray, "Edit", "Cancel");
}

PlayerEditGroupPay(playerid)
{
	szMiscArray[0] = 0;
	new iGroupID = PlayerInfo[playerid][pLeader],
		szTitle[32 + GROUP_MAX_NAME_LEN];
	for(new i = 0; i != MAX_GROUP_RANKS; ++i) {
		format(szMiscArray, sizeof szMiscArray, "%s(%i) %s\t$%s\n", szMiscArray, i, arrGroupRanks[iGroupID][i], number_format(arrGroupData[iGroupID][g_iPaycheck][i]));
	}
	format(szTitle, sizeof szTitle, "{%s}(%s) {FFFFFF}| Edit Paychecks", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
	return ShowPlayerDialogEx(playerid, DIALOG_GROUP_PLISTPAY, DIALOG_STYLE_TABLIST, szTitle, szMiscArray, "Edit", "Cancel");
}

PayGroupMember(i)
{
	new
		iGroupID = PlayerInfo[i][pMember],
		iRank = PlayerInfo[i][pRank];
	szMiscArray[0] = 0;
	if((0 <= iGroupID < MAX_GROUPS) && 0 <= iRank <= 9 && arrGroupData[iGroupID][g_iPaycheck][iRank] > 0) {
		if(arrGroupData[iGroupID][g_iBudget] > 0) {
			arrGroupData[iGroupID][g_iBudget] -= arrGroupData[iGroupID][g_iPaycheck][iRank];
			//GivePlayerCash(i, arrGroupData[iGroupID][g_iPaycheck][iRank]);
			GivePlayerCashEx(i, TYPE_BANK, arrGroupData[iGroupID][g_iPaycheck][iRank]);
			format(szMiscArray,sizeof(szMiscArray)," {%s}%s {FFFFFF}paycheck: $%s", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName], number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
			SendClientMessageEx(i, COLOR_GRAD2, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "%s has been paid $%s from %s's budget.", GetPlayerNameEx(i), number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]), arrGroupData[iGroupID][g_szGroupName]);
			GroupPayLog(iGroupID, szMiscArray);
		}
		else SendClientMessageEx(i, COLOR_RED, "Your group is in debt; no money is available for pay.");
	}
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {
		case DIALOG_GROUP_PLISTPAY: {

			new
				iGroupID = PlayerInfo[playerid][pLeader];

			if(response) {

				new
					szTitle[32 + GROUP_MAX_NAME_LEN];

				SetPVarInt(playerid, "Group_EditRank", listitem);
				format(szTitle, sizeof szTitle, "Edit Rank (%i)'s Paycheck {%s}(%s)", listitem, Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
				return ShowPlayerDialogEx(playerid, DIALOG_GROUP_PEDITPAY, DIALOG_STYLE_INPUT, szTitle, "Specify a paycheck amount for this rank.", "Set", "Cancel");
			}
			return 1;
		}
		case DIALOG_GROUP_PEDITPAY: {

			new
				iGroupID = PlayerInfo[playerid][pLeader],
				iRankID = GetPVarInt(playerid, "Group_EditRank");

			if(response) {

				if(isnull(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 0) return SendClientMessage(playerid, COLOR_GRAD1, "You specified an invalid value.");

				arrGroupData[iGroupID][g_iPaycheck][iRankID] = strval(inputtext);
				format(szMiscArray, sizeof(szMiscArray), "%s has changed the paycheck for rank %d (%s) to $%d in %s (%d)", GetPlayerNameEx(playerid), iRankID, arrGroupRanks[iGroupID][iRankID], strval(inputtext), arrGroupData[iGroupID][g_szGroupName], iGroupID + 1);
				Log("logs/group.log", szMiscArray);
				Log("logs/editgroup.log", szMiscArray);
				DeletePVar(playerid, "Group_EditRank");
				SaveGroup(iGroupID);
				return PlayerEditGroupPay(playerid);
			}
			return PlayerEditGroupPay(playerid);
		}
		case DIALOG_GROUP_GOVLISTPAY: {
			if(response) {
				if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] != arrGroupData[listitem][g_iAllegiance]) return SendClientMessage(playerid, COLOR_GRAD1, "This instance is not part of your nation.");
				SetPVarInt(playerid, "Gov_EditGroup", listitem);
				format(szMiscArray, sizeof szMiscArray, "Edit Paycheck | {%s}%s {FFFFFF}(ID: %i)", Group_NumToDialogHex(arrGroupData[listitem][g_hDutyColour]), arrGroupData[listitem][g_szGroupName], listitem);
				return ShowPlayerDialogEx(playerid, DIALOG_GROUP_GOVEDITPAY, DIALOG_STYLE_INPUT, szMiscArray, "Specify a budget for this group.", "Set", "Cancel");
			}
			return 1;
		}
		case DIALOG_GROUP_GOVEDITPAY: {

			new
				iGroupID = GetPVarInt(playerid, "Gov_EditGroup");

			if(response) {
				if(isnull(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 0) return SendClientMessage(playerid, COLOR_GRAD1, "You specified an invalid value.");
				
				arrGroupData[iGroupID][g_iBudgetPayment] = strval(inputtext);
				format(szMiscArray, sizeof(szMiscArray), "%s has changed the budget for %s to $%d", GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName], number_format(strval(inputtext)));
				Log("logs/group.log", szMiscArray);
				Log("logs/editgroup.log", szMiscArray);
				DeletePVar(playerid, "Gov_EditGroup");
				SaveGroup(iGroupID);
				return GovEditGroupBudget(playerid);
			}
			return GovEditGroupBudget(playerid);
		}
	}
	return 0;
}


CMD:editbudgets(playerid, params[])
{
	if(PlayerInfo[playerid][pLeader] == PlayerInfo[playerid][pMember] && IsAGovernment(playerid))
	{
		GovEditGroupBudget(playerid);
	}
	else SendClientMessage(playerid, COLOR_GRAD2, "You must be leading a government to use this command.");
	return 1;
}

CMD:editpaychecks(playerid, params[])
{
	if(PlayerInfo[playerid][pLeader] == PlayerInfo[playerid][pMember])
	{
		PlayerEditGroupPay(playerid);
	}
	else SendClientMessage(playerid, COLOR_GRAD2, "You must be a group leader to use this command.");
	return 1;
}