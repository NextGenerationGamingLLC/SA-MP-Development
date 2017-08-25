stock ShowStats(playerid,targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new resultline[1024], header[65], org[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
		new sext[16], std[20], nation[24], biz[128];
		if(PlayerInfo[targetid][pSex] == 1) { sext = "Male"; } else { sext = "Female"; }
		switch(GetPVarInt(targetid, "STD"))
		{
		    case 1: std = "Chlamydia";
		    case 2: std = "Gonorrhea";
		    case 3: std = "Syphilis";
		    default: std = "None";
		}
		if(PlayerInfo[targetid][pMember] != INVALID_GROUP_ID)
		{
			GetPlayerGroupInfo(targetid, rank, division, employer);
			format(org, sizeof(org), "Group: %s (%d)\nRank: %s (%d)\nDivision: %s (%d)\n", employer, PlayerInfo[targetid][pMember], rank, PlayerInfo[targetid][pRank], division, PlayerInfo[targetid][pDivision]);
			if(arrGroupData[PlayerInfo[targetid][pMember]][g_iGroupType] != GROUP_TYPE_CRIMINAL) format(org, sizeof(org), "%sBadge Number: %s\n", org, PlayerInfo[targetid][pBadge]);
		}
		else format(org, sizeof(org), "");
		if(PlayerInfo[targetid][pBusiness] != INVALID_BUSINESS_ID) format(biz, sizeof(biz), "Business: %s (%d)\nRank: %s (%d)\n", Businesses[PlayerInfo[targetid][pBusiness]][bName], PlayerInfo[targetid][pBusiness], GetBusinessRankName(PlayerInfo[targetid][pBusinessRank]), PlayerInfo[targetid][pBusinessRank]);
		else format(biz, sizeof(biz), "");
		switch(PlayerInfo[targetid][pNation])
		{
			case 0: nation = "San Andreas";
			case 1: nation = "New Robada";
			case 2: nation = "None";
		}
		new insur[32];
		insur = GetHospitalName(PlayerInfo[targetid][pInsurance]);

		new staffrank[64];
		if(PlayerInfo[targetid][pHelper] > 0 || PlayerInfo[targetid][pWatchdog] > 0 || PlayerInfo[targetid][pSEC] > 0 || PlayerInfo[targetid][pAdmin] == 1 || (PlayerInfo[targetid][pAdmin] > 1 && PlayerInfo[playerid][pAdmin] <= PlayerInfo[targetid][pAdmin])) format(staffrank, sizeof(staffrank), "%s", GetStaffRank(targetid));
		else staffrank = "";
		new drank[64];
		if(PlayerInfo[targetid][pDonateRank] > 0)
		{
			switch(PlayerInfo[targetid][pDonateRank])
			{
				case 1: drank = "{800080}Bronze VIP{FFFFFF}\n";
				case 2: drank = "{800080}Silver VIP{FFFFFF}\n";
				case 3: drank = "{FFD700}Gold VIP{FFFFFF}\n";
				case 4: drank = "{E5E4E2}Platinum VIP{FFFFFF}\n";
			}
		}
		new svipmod[40];
		if(PlayerInfo[targetid][pVIPMod])
		{
			switch(PlayerInfo[targetid][pVIPMod])
			{
				case 1: svipmod = "{800080}VIP Moderator{FFFFFF}\n";
				case 2: svipmod = "{800080}Senior VIP Moderator{FFFFFF}\n";
			}
		}
		new famedrank[64];
		if(PlayerInfo[targetid][pFamed] > 0)
		{
			switch(PlayerInfo[targetid][pFamed])
			{
				case 1: famedrank = "{228B22}Old-School{FFFFFF}\n";
				case 2: famedrank = "{FF7F00}Chartered Old-School{FFFFFF}\n";
				case 3: famedrank = "{ADFF2F}Famed{FFFFFF}\n";
				case 4: famedrank = "{8F00FF}Famed Commissioner{FFFFFF}\n";
				case 5: famedrank = "{8F00FF}Famed Moderator{FFFFFF}\n";
				case 6: famedrank = "{8F00FF}Famed Vice-Chairman{FFFFFF}\n";
				case 7: famedrank = "{8F00FF}Famed Chairman{FFFFFF}\n";
			}
		}
		new dprank[64];
		if(PlayerInfo[targetid][pDedicatedPlayer] > 0)
		{
			switch(PlayerInfo[targetid][pDedicatedPlayer])
			{
				case 1: dprank = "{336600}Tier 1 Dedicated Player{FFFFFF}\n";
				case 2: dprank = "{336600}Tier 2 Dedicated Player{FFFFFF}\n";
				case 3: dprank = "{336600}Tier 3 Dedicated Player{FFFFFF}\n";
				case 4: dprank = "{336600}Dedicated Moderator{FFFFFF}\n";
			}
		}
		if(PlayerInfo[targetid][pMarriedID] == -1) format(PlayerInfo[targetid][pMarriedName], MAX_PLAYER_NAME, "Nobody");
		new nxtlevel = PlayerInfo[targetid][pLevel]+1;
		new expamount = nxtlevel*4;
		new Float:health, Float:armor;
		GetHealth(targetid, health);
		GetArmour(targetid, armor);
		new Float:px,Float:py,Float:pz;
		GetPlayerPos(targetid, px, py, pz);
		new zone[MAX_ZONE_NAME];
		GetPlayer3DZone(targetid, zone, sizeof(zone));
		new fifstr[128];
		if(FIFEnabled)
		{
			format(fifstr, sizeof(fifstr), "{FF8000}FIF Hours:{FFFFFF} %d\n{FF8000}FIF Chances:{FFFFFF} %d\n", FIFInfo[targetid][FIFHours], FIFInfo[targetid][FIFChances]);
		}
		SetPVarInt(playerid, "ShowStats", targetid);
		format(header, sizeof(header), "Showing Statistics of %s", GetPlayerNameEx(targetid));
		format(resultline, sizeof(resultline),"%s\n\
			%s\
			%s\
			%s\
			%s\
			%s\
			{FFFFFF}Level: %d\n\
			Gender: %s\n\
			Date of Birth: %s\n\
			Current Location: %s (%0.2f, %0.2f, %0.2f)\n\
			Married To: %s\n\
			Health: %.1f\n\
			Armor: %.1f\n\
			Playing Hours: %s\n\
			Dedicated Hours: %s\n\
			Fitness: %d\n\
			Upgrade Points: %s\n\
			Next Level: %s{303030}/{FFFFFF}%s hours\n\
			Nation: %s\n\
			%s\
			%s\
			Job: %s (Level: %d)\n\
			Job 2: %s (Level: %d)\n\
			Job 3: %s (Level: %d)\n\
			Insurance: %s",
			staffrank,
			famedrank,
			dprank,
			drank,
			svipmod,
			fifstr,
			PlayerInfo[targetid][pLevel],
			sext,
			PlayerInfo[targetid][pBirthDate],
			zone, px, py, pz,
			PlayerInfo[targetid][pMarriedName],
			health,
			armor,
			number_format(PlayerInfo[targetid][pConnectHours]),
			number_format(PlayerInfo[targetid][pDedicatedHours]),			
			PlayerInfo[targetid][pFitness],
			number_format(PlayerInfo[targetid][gPupgrade]),
			number_format(PlayerInfo[targetid][pExp]),
			number_format(expamount),
			nation,
			org,
			biz,
			GetJobName(PlayerInfo[targetid][pJob]),
			GetJobLevel(targetid, PlayerInfo[targetid][pJob]),
			GetJobName(PlayerInfo[targetid][pJob2]),
			GetJobLevel(targetid, PlayerInfo[targetid][pJob2]),
			GetJobName(PlayerInfo[targetid][pJob3]),
			GetJobLevel(targetid, PlayerInfo[targetid][pJob3]),
			insur);
		ShowPlayerDialogEx(playerid, DISPLAY_STATS, DIALOG_STYLE_MSGBOX, header, resultline, "Next Page", "Close");
	}
	return 1;
}