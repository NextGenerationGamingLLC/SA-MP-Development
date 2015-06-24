/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Help Commands

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)
					
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

CMD:help(playerid, params[])
{
	new string[512];
	if(PlayerInfo[playerid][pLevel] <= 3)
	{
		SendClientMessageEx(playerid, TEAM_AZTECAS_COLOR,"*** HELP *** /report /requesthelp (/newb)ie /tognewbie");
	}
	SendClientMessageEx(playerid, COLOR_WHITE,"*** ACCOUNT *** /rules /faq /(net)stats /inventory /quickstats /myguns /buylevel /upgrade /changepass /killcheckpoint /resetupgrades(100k)");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** CHAT *** /w(hisper) /o(oc) /s(hout) /l(ow) /b /ad(vertisement)s /f(amily) /togooc /tognews /togfam /togwhisper /cancelcall");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** CHAT *** /me /ame /lme /do /ldo /se(texamine) /examine");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** BANK *** /balance /withdraw /deposit /wiretransfer /abalance /awithdraw /adeposit /awiretransfer");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** GENERAL *** /pay /writecheck /cashchecks /charity /time /buy /(check)id /music /showlicenses /clothes /mywarrants");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** GENERAL *** /apply /skill /stopani /kill /buyclothes /droplicense /calculate /refuel /car /seatbelt /checkbelt, /defendtime");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** GENERAL *** /cancel /accept /eject /usepot /usecrack /contract /service /families /joinevent /checkplant /nextpaycheck, /nextgift, /pointtime");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** GENERAL *** /speedo /speedopos /viewmotd /pickveh /cracktrunk /backpackhelp /nextnamechange /rld /myammo");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** SHOP *** /shophelp /credits /sellcredits /microshop /activeitems /cooldowns");

	switch(PlayerInfo[playerid][pJob])
	{
		case 1: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /find");
		case 2: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /lawyerduty /free /defend /wanted /offerappeal /finishappeal");
		case 3: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sex");
		case 4: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sell /getcrack /getpot /getseeds /getopiumseeds /plantpotseeds /plantopiumseeds /pickplant /checkplant");
		case 5: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /dropcar");
		case 7: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fix /nos /hyd /repair /refill /mechduty");
		case 8: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /guard /frisk");
		case 9: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /sellgun");
		case 10: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sellnewcar");
		case 12: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fight");
		case 14: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getcrate");
		case 15: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /papers /bring /deliver");
		case 17: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fare");
		case 18: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /craft");
		case 19: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /selldrink");
		case 20: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /loadshipment /checkcargo /hijackcargo");
		case 21: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getpizza");
	}
	switch(PlayerInfo[playerid][pJob2])
	{
		case 1: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /find");
		case 2: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /lawyerduty /free /defend /wanted");
		case 3: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sex");
		case 4: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sell /getcrack /getpot /getseeds /getopiumseeds /plantpotseeds /plantopiumseeds /pickplant /checkplant");
		case 5: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /dropcar");
		case 7: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fix /nos /hyd /repair /refill /mechduty");
		case 8: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /guard /frisk");
		case 9: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /sellgun");
		case 10: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sellnewcar");
		case 12: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fight");
		case 14: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getcrate");
		case 15: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /papers /bring /deliver");
		case 17: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fare");
		case 18: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /craft");
		case 19: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /selldrink");
		case 20: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /loadshipment /checkcargo /hijackcargo");
		case 21: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getpizza");
	}
	switch(PlayerInfo[playerid][pJob3])
	{
		case 1: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /find");
		case 2: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /lawyerduty /free /defend /wanted");
		case 3: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sex");
		case 4: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sell /getcrack /getpot /getseeds /getopiumseeds /plantpotseeds /plantopiumseeds /pickplant /checkplant");
		case 5: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /dropcar");
		case 7: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fix /nos /hyd /repair /refill /mechduty");
		case 8: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /guard /frisk");
		case 9: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /sellgun");
		case 10: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /sellnewcar");
		case 12: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fight");
		case 14: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getcrate");
		case 15: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /papers /bring /deliver");
		case 17: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /fare");
		case 18: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getmats /sell /craft");
		case 19: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /selldrink");
		case 20: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /loadshipment /checkcargo /hijackcargo");
		case 21: SendClientMessageEx(playerid,COLOR_WHITE,"*** JOB *** /getpizza");	
	}	
	new iGroupID = PlayerInfo[playerid][pMember];
	if(iGroupID != INVALID_GROUP_ID)
	{
	    switch(arrGroupData[iGroupID][g_iGroupType])
	    {
			case 1:
			{
			    format(string, sizeof(string), "*** %s *** (/r)adio /dept (/m)egaphone (/su)spect /locker /mdc /detain /arrest /warrantarrest /wanted /cuff /tazer", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "*** %s ***  /frisk /take /ticket (/gov)ernment /clothes /ram /invite /giverank /deploy /destroy /pddoor /pdcell", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "*** %s ***  /spikes /revokelicense /vcheck /vmdc /vticket /tow /untow /impound /dmvrelease /gdonate /togradio /togdept", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "*** %s ***  /flares /cones /wants /docarrest /siren /destroyplant /radargun /searchcar /dvsiren /vradar /loadammo /deliverammo", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
				if(PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iBugAccess]) format(string, sizeof(string), "%s /bug /listbugs /clearbugs /hfind",string);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				if(arrGroupData[PlayerInfo[playerid][pMember]][g_iCrateIsland] != INVALID_RANK) {
                    format(string, sizeof(string), "*** %s ***  /cratelimit /viewcrateorders", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
				format(string, sizeof(string), "*** %s ***  /placekit /usekit /backup (code2) /backupall /backupint /calls /a(ccept)c(all) /i(gnore)c(all) /wheelclamp", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);

			}
			case 2:
			{
				format(string, sizeof(string), "*** %s *** (/f)amily /r /contracts /givemehit /order /ranks /profile /h(show)badge /hfind /togbr /execute", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "*** %s *** /plantbomb /plantcarbomb /pickupbomb /myc4 /invite /giverank /showmehq /showmehq2 /showmehq3", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			case 3:
			{
				format(string, sizeof(string), "*** %s ***  (/r)adio /dept (/m)egaphone /heal /clothes /invite /giverank /locker /gdonate", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "*** %s ***  /getpt /movept /loadpt /deliverpt /destroyplant /calls /a(ccept)c(all) /i(gnore)c(all)", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			case 4:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "*** NEWS AGENCY *** /live /news [text] /broadcast /cameraangle /clothes /invite /giverank /liveban");
   			}
			case 5:
			{
				if(PlayerInfo[playerid][pRank] < 3)
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "*** GOVERNMENT *** (/r)adio /dept /locker /mdc /deploy /destroy /spikes /tazer /frisk /cuff");
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "*** GOVERNMENT *** (/r)adio /dept /locker /settax /checktax /taxwithdraw /invite /giverank (/gov)ernment (/su)spect");
					SendClientMessageEx(playerid, COLOR_WHITE, "*** GOVERNMENT *** /mdc /detain /arrest /wanted /cuff /tazer /frisk /take /ticket /clothes /ram /invite /giverank /setbudget");
					SendClientMessageEx(playerid, COLOR_WHITE, "*** GOVERNMENT *** /spikes /destroyplant /radargun /warrantarrest /pardon /commute /wants /deploy /destroy");
				}
			}
			case 6:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "*** JUDICIAL SYSTEM *** (/r)adio /dept /warrant /warrantwd /judgefine /judgejail /judgeprison /probation /wants /subpoena");
				SendClientMessageEx(playerid, COLOR_WHITE, "*** JUDICIAL SYSTEM *** /invite /uninvite /giverank /trial /adjourn /sentence /reward /checkjudgements /reversejudgement");
				SendClientMessageEx(playerid, COLOR_WHITE, "*** JUDICIAL SYSTEM *** /present /freezebank /freezeassets /probation /gdonate /viewassets");
			}
			case 7:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "*** TRANSPORT *** /fare /ataxi /r /invite /giverank /eba /gdonate");
			}
			case 8:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "*** TOWING *** (/r)adio /dept /locker /(un)tow /impound /vcheck /vmdc /vticket /gdonate /calls /a(ccept)c(all) /i(gnore)c(all)");
			}
			case 9:
			{
			    SendClientMessageEx(playerid, COLOR_WHITE, "*** URL *** /countdown");
			}
			case 10:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "*** FAMILY *** (/f)amily /locker /gate /clothes");
			}
		}
		if (0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "*** GROUP LEADER *** /invite /uninvite /ouninvite /setdiv /giverank /online /setbadge /setdivname");
			if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_MEDIC || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_JUDICIAL || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_TAXI)
			{
			    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "*** GROUP LEADER *** /viewbudget /grepocars /gvbuyback /gdonate /ordercrates /dvtrackcar /gwithdraw /dvstorage");
			}
			else if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV)
			{
			    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "*** GROUP LEADER *** /checkapps /deport");
			}
			else if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_CRIMINAL)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "*** GROUP LEADER *** /adjustwithdrawrank");
			}
		}
	}
	if (PlayerInfo[playerid][pAdmin] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "*** ADMIN *** (/a)dmin (/ah)elp");
	}
	if (PlayerInfo[playerid][pHelper] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "*** COMMUNITY ADVISOR *** (/ch)elp");
	}
	if(PlayerInfo[playerid][pDonateRank] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_PURPLE, "*** VIP *** /travel /viplocker /tokenhelp /buddyinvite /phoneprivacy /setautoreply");
	}
	if(PlayerInfo[playerid][pDonateRank] >= 2)
	{
		format(string, sizeof(string), "*** VIP *** /spawnatvip (%s credits) /vipgunsleft", number_format(ShopItems[30][sItemPrice]));
		SendClientMessageEx(playerid, COLOR_PURPLE, string);
	}
	if(PlayerInfo[playerid][pDonateRank] >= 4)
	{
		SendClientMessageEx(playerid, COLOR_PURPLE, "*** VIP *** /freeads /pvipjob /vipplate");
	}
	if(PlayerInfo[playerid][pVIPMod])
	{
		SendClientMessageEx(playerid, COLOR_PURPLE, "*** VIP Moderator *** /vipparty /vto /vtoreset /vmute /vsuspend /vipm");
	}
	SendClientMessageEx(playerid, COLOR_WHITE,"*** OTHER *** /cellphonehelp /carhelp /househelp /toyhelp /renthelp /jobhelp /animhelp /fishhelp /insurehelp");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** OTHER *** /mailhelp /businesshelp /voucherhelp /backpackhelp");
	
	//Start of Famed Commands
	if(PlayerInfo[playerid][pFamed] >= 1)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "*** Old-School *** /fc /famedlocker /togfamed /famedplate [os/removed] /travel famed");
	}
	if(PlayerInfo[playerid][pFamed] >= 2)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "*** Chartered Old-School *** /famedplate [os/cos/removed]");
	}
    if(PlayerInfo[playerid][pFamed] >= 3)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "*** Famed *** /buyinsurance /famedplate [os/cos/famed/removed]");
	}
	if(PlayerInfo[playerid][pFamed] >= 4)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "*** Famed Commissioner *** /fmute /funmute, /fmembers");
	}
	if(PlayerInfo[playerid][pFamed] >= 6)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "*** Famed Vice-Chairman *** /osetfamed /setfamed");
	}
	//end of famed commands
	return 1;
}