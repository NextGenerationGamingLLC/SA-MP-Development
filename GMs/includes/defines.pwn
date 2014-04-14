/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/
				
//--------------------------------[DEFINES.PWN]--------------------------------


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
 
 			/*  ---------------- Enable the Windows/Android Application ----------------- */
//#define SOCKET_ENABLED
			/*  ---------------- SERVER PLATFORM ---------------- */
//#define _WIN32
#define _LINUX
			/*  ---------------- DISABLE NPCs ----------------- */
#define	FOREACH_NO_BOTS
			/*  ---------------- PRAGMAS ----------------- */
#pragma dynamic 4500000
			/*  ---------------- NATIVES ----------------- */
native WP_Hash(buffer[], len, const str[]);
native gpci(playerid, serial[], maxlen);
			/*  ---------------- SERVER DEFINES ----------------- */
#undef 			MAX_PLAYERS
#define 		MAX_PLAYERS					(700)
#define 		MAX_PING 					1200
#define			INVALID_SAMP_ID				65535
#define			WEB_SERVER					"64.31.32.194"
#define			SAMP_WEB					"127.0.0.1"
			/*  ---------------- TIMERS ----------------- */
#define			TYPE_TPMATRUNTIMER 			1
#define			TYPE_TPDRUGRUNTIMER 		2
#define			TYPE_ARMSTIMER 				3
#define			TYPE_GIVEWEAPONTIMER 		4
#define			TYPE_HOSPITALTIMER 			5
#define			TYPE_SEXTIMER 				6
#define			TYPE_FLOODPROTECTION 		7
#define			TYPE_HEALTIMER 				8
#define 		TYPE_GUARDTIMER 			9
#define			TYPE_TPTRUCKRUNTIMER 		10
#define			TYPE_SHOPORDERTIMER 		11
#define 		TYPE_SELLMATSTIMER 			12
#define 		TYPE_TPPIZZARUNTIMER 		13
#define 		TYPE_PIZZATIMER 			14
#define 		TYPE_CRATETIMER 			15

			/*  ---------------- MISC ----------------- */
#define 		RED_FLAG_OBJ 				1580
#define 		BLUE_FLAG_OBJ 				1579
#define 		HILL_OBJ 					1578
#define 		VEHICLE_RESPAWN 			7200
#define 		SPEEDGUN 					43
#define 		MAX_NOP_WARNINGS 			4
#define 		NEW_VULNERABLE 				(24)
#define 		TIME_TO_CLAIM 				(1)
#define 		TIME_TO_TAKEOVER 			(10)
#define 		MAX_FAMILY 					(17)
#define 		MAX_POINTS 					(8)
#define 		MAX_DMAPICONS 				(400)
#define 		MAX_DDOORS					(3000)
#define 		MAX_HOUSES 					(5500)
#define 		MAX_OWNABLE_HOUSES 			(2)
#define 		MAX_GATES 					(4000)
#define 		MAX_EVENTPOINTS 			(50)
#define 		INVALID_HOUSE_ID			(-1)
#define			MAX_TURFS					(150)
#define			MAX_ARENAS					(10)
#define			MAX_MAILBOXES				(50)
#define 		MAX_3DLABELS 				(500)
#define 		MAX_SPEEDCAMERAS			(50)
#define 		MAX_PAYNSPRAYS				(25)
#define 		MAX_ARRESTPOINTS			(30)
#define 		MAX_IMPOUNDPOINTS			(20)
#define         NATION_SAN_ANDREAS		 	0
#define         NATION_TIERRA_ROBADA	 	1
#define			MAX_ZONE_NAME				28
#define 		MAX_MODS 					15
#define 		FREEZE_TIME					2000
#define 		CREDITS_AMOUNT_REFERRAL     100
#define 		MAX_PLAYERVEHICLES 			500
#define 		MAX_PLAYERTOYS 				200
#define 		MAX_GANG_VEHICLES 			16
#define 		INVALID_PLAYER_VEHICLE_ID 	0
#define 		CRATE_COST 					50000
#define 		MAX_REPORTS  				1000
#define 		INVALID_REPORT_ID 			-1
#define 		MAX_CALLS  					1000
#define 		INVALID_CALL_ID 			-1
#define 		WEAPON_HACKER_WARNINGS  	4
#define 		NOOB_SKIN 					299
#define 		MAX_ITEMS 					(40)
#define 		RocketHeight 				50
#define 		TYPE_COUNTDOWN 				2000
#define 		TYPE_LAUNCH 				2001
#define 		TYPE_EXPLODE 				2002
#define 		MAX_FIREWORKS 				100
#define 		FireworkSpread 				30
#define 		REGULAR_MAIL    			0
#define 		PRIORITY_MAIL    			1
#define 		PREMIUM_MAIL    			2
#define 		GOVERNMENT_MAIL 			3
#define			MAX_RFLTEAMS				200
#define			MAX_GANGTAGS				150
#define			MAX_DYNAMIC_BUSINESSES		(200)
#define			MAX_DYNAMIC_BUSINESS_NAME	(32)
#define			MAX_DYNAMIC_BUSINESS_RANKS	(6)
//#define 		SHOPAUTOMATED
#define 		zombiemode
#define 		event_chancegambler

// strcpy - Simon / Y_LESS
/*#define strcpy(%0,%1,%2) \
    strcat((%0[0] = '\0', %0), %1, %2)*/

			/*  ---------------- FUNCTIONS ----------------- */
#define 		GetVehicleName(%0) VehicleName[GetVehicleModel(%0)-400]
#define 		GetPlayerCash(%0) PlayerInfo[%0][pCash]
#define 		GivePlayerCash(%0,%1) PlayerInfo[%0][pCash] += (%1)
#define 		ini_SetString(%0,%1,%2)			if(%2[0]) fwrite(%0, %1), fputchar(%0, '=', false) && fwrite(%0, %2) && fwrite(%0, "\r\n")
#define 		ini_SetInteger(%0,%1,%2,%3)     format(%1, sizeof(%1), "%s=%d\r\n", %2, %3) && fwrite(%0, %1)
#define 		ini_SetFloat(%0,%1,%2,%3)       format(%1, sizeof(%1), "%s=%f\r\n", %2, %3) && fwrite(%0, %1)
#define 		chrtoupper(%1) \
        			(((%1) > 0x60 && (%1) <= 0x7A) ? ((%1) ^ 0x20) : (%1))				

// strcpy - Simon / Y_LESS
/*#define strcpy(%0,%1,%2) \
    strcat((%0[0] = '\0', %0), %1, %2)*/
    
			/*  ---------------- DYNAMIC GROUP ----------------- */
// First-dimension array sizes - CRITICAL.
#define 		MAX_GROUPS 					20
#define 		MAX_GROUP_RANKS 			10
#define 		MAX_GROUP_DIVS 				10
#define 		MAX_GROUP_WEAPONS			16
#define			MAX_DYNAMIC_VEHICLES        700
#define         MAX_DV_OBJECTS          	2
#define         MAX_DV_MODS                 15
#define 		MAX_GROUP_LOCKERS           5
#define 		MAX_GROUP_JURISDICTIONS     10

#define			DYNAMIC_FAMILY_CLOTHES		1337

// Third and fourth-dimension sizes.
#define			GROUP_MAX_NAME_LEN			32
#define			GROUP_MAX_RANK_LEN			30
#define			GROUP_MAX_DIV_LEN			16
#define			GROUP_MAX_MOTD_LEN   		128

// General constants.
#define			MAX_GROUP_ALLEGIANCES		3
#define			MAX_GROUP_TYPES             10
#define         MAX_LOCKER_STOCK        	1500
#define         MAX_CRATES             		20
#define 		MAX_SPIKES 					20
#define 		MAX_CONES 					20
#define 		MAX_FLARES 					20
#define 		MAX_BARRICADES 				20
#define 		MAX_BARRELS 				20
#define         MAX_AUCTIONS                10
#define         MAX_PLANTS                  300
#define         MAX_BUSINESSSALES           100
#define 		INVALID_FAMILY_ID   		255
#define 		INVALID_GROUP_ID 			-1
#define 		INVALID_RANK     			255
#define 		INVALID_DIVISION       		-1

// Query thread IDs.
#define         GROUP_QUERY_LOAD			1
#define         GROUP_QUERY_INVITE			2
#define         GROUP_QUERY_ADDBAN			3
#define         GROUP_QUERY_UNBAN   		4
#define         GROUP_QUERY_UNCHECK   		5
#define         GROUP_QUERY_UNINVITE  		6
#define         GROUP_QUERY_LOCKERS     	7
#define         GROUP_QUERY_JURISDICTIONS   8

//Query thread IDs for Dynamic Vehicles
#define         GV_QUERY_LOAD               1
#define         GV_QUERY_SAVE               2

			/*  ---------------- BUSINESSES ----------------- */
                     /* ===[Ignore the tab space]=== */
#define 		MAX_BUSINESSES 						200
#define 		MAX_BUSINESS_NAME 					48
#define 		MAX_BUSINESS_DEALERSHIP_VEHICLES    10
#define 		MAX_BUSINESS_GAS_PUMPS 			    2
#define 		INVALID_BUSINESS_ID 				-1
#define 		INVALID_GAS_PUMP 					-1
#define 		INVALID_STORE_ITEM 					-1
#define 		BUSINESS_BASE_VW 					100000
#define 		BUSINESS_OPEN_COLOR 				0x22FF2299
#define 		BUSINESS_CLOSED_COLOR 				0xFF222299
#define 		BUSINESS_NAME_COLOR 				0xFFFFFF99
#define 		BUSINESS_PRICE_COLOR				0x33CCFF88
#define 		BUSINESS_TAX_PERCENT                10
#define 		BUSINESS_TYPE_GASSTATION 			1
#define 		BUSINESS_TYPE_CLOTHING 				2
#define 		BUSINESS_TYPE_RESTAURANT 			3
#define 		BUSINESS_TYPE_GUNSHOP 				4
#define 		BUSINESS_TYPE_NEWCARDEALERSHIP 		5
#define 		BUSINESS_TYPE_OLDCARDEALERSHIP 		6
#define 		BUSINESS_TYPE_MECHANIC 				7
#define 		BUSINESS_TYPE_STORE 				8
#define 		BUSINESS_TYPE_BAR					9
#define 		BUSINESS_TYPE_CLUB 					10
#define 		BUSINESS_TYPE_SEXSHOP 				11
#define 		BUSINESS_TYPE_GYM 					12
#define 		BUSINESS_ITEMS_COST 				1500
#define 		ITEM_CELLPHONE 						1
#define 		ITEM_PHONEBOOK 						2
#define 		ITEM_DICE 							3
#define 		ITEM_CONDOM 						4
#define 		ITEM_MUSICPLAYER 					5
#define 		ITEM_ROPE 							6
#define 		ITEM_CIGAR 							7
#define 		ITEM_SPRUNK 						8
#define 		ITEM_VEHICLELOCK 					9
#define 		ITEM_SPRAYCAN						10
#define 		ITEM_RADIO 							11
#define 		ITEM_CAMERA 						12
#define 		ITEM_LOTTERYTICKET 					13
#define 		ITEM_CHECKBOOK						14
#define 		ITEM_PAPERS 						15
#define 		ITEM_ILOCK                      	16
#define 		ITEM_ELOCK                      	17
#define 		ITEM_SCALARM                      	18
#define 		FUEL_PUMP_RATE 						0.1 // Gallons per second
#define 		BIZ_PENALTY 						0.2

			/*  ---------------- DIALOGS ----------------- */
#define 		DIALOG_NOTHING 				32767
#define 		DIALOG_NUNMUTE 				10
#define 		DIALOG_SHOWSCORES 			11
#define 		DIALOG_NAMECHANGE 			261
#define 		DIALOG_NAMECHANGE2 			262
#define			BIGEARS						(10)
#define			BIGEARS2					(20)
#define			BIGEARS3					(30)
#define			BIGEARS4					(40)
#define			BIGEARS5					(41)
#define			MAINMENU					(50)
#define			MAINMENU2					(60)
#define         MAINMENU3                   (70)
#define 		NULLEMAIL                   (80)
#define 		EMAIL_VALIDATION            (81)
#define         PMOTDNOTICE                 (90)
#define			TWADMINMENU					(100)
#define			TWEDITTURFSSELECTION		(110)
#define			TWEDITTURFSMENU				(120)
#define			TWEDITFCOLORSSELECTION		(130)
#define			TWEDITFCOLORSMENU			(140)
#define			TWEDITTURFSOWNER			(150)
#define			TWEDITTURFSLOCKED			(160)
#define			TWEDITTURFSVUL				(170)
#define			TWEDITTURFSPERKS			(180)
#define			PBMAINMENU					(200)
#define			PBARENASELECTION			(210)
#define			PBTOKENBUYMENU				(220)
#define			PBSETUPARENA				(230)
#define			PBJOINPASSWORD				(240)
#define			PBJOINTEAM					(250)
#define			PBSWITCHTEAM				(260)
#define			PBCHANGEPASSWORD			(270)
#define			PBCHANGEGAMEMODE			(280)
#define			PBCHANGELIMIT				(290)
#define			PBCHANGETIMELEFT			(300)
#define			PBCHANGEBIDMONEY			(310)
#define			PBCHANGEHEALTH				(320)
#define			PBCHANGEARMOR				(330)
#define			PBCHANGEWEAPONS1			(340)
#define			PBCHANGEWEAPONS2			(350)
#define			PBCHANGEWEAPONS3			(360)
#define			PBCHANGEEXPLOITPERM			(370)
#define			PBCHANGEFLAGINSTAGIB		(380)
#define			PBCHANGEFLAGNOWEAPONS		(390)
#define			PBARENASCORES				(400)
#define			PBADMINMENU					(410)
#define			PBEDITMENU					(420)
#define			PBEDITARENAMENU				(430)
#define			PBEDITARENANAME				(440)
#define			PBEDITARENADMSPAWNS			(450)
#define			PBEDITARENATEAMSPAWNS		(460)
#define			PBEDITARENAFLAGSPAWNS		(470)
#define			PBEDITARENAINT				(480)
#define			PBEDITARENAVW				(490)
#define			PBEDITARENAHILLRADIUS		(500)
#define			PBCHANGEWAR					(501)
#define			DOORLOCK					(510)
#define			NMUTE						(520)
#define			ADMUTE						(530)
#define			RTONEMENU					(540)
#define			RCPINTRO					(550)
#define			RCPINTRO2					(560)
#define			RCPCHOOSE					(570)
#define			RCPSIZE						(580)
#define			RCPTYPE						(590)
#define			RCPEDITMENU					(600)
#define			RCPEDITMENU2				(610)

#define			DIALOG_SHOPORDER			(620)
#define			DIALOG_SHOPORDER2			(621)
#define			DIALOG_SHOPORDEREMAIL		(622)
#define			DIALOG_SHOPDELIVER			(623)
#define			DIALOG_SHOPDELIVERCAR		(624)
#define			DIALOG_SHOPDELIVERCAR2		(625)

#define			DIALOG_SHOPERROR			(630)
#define			DIALOG_SHOPSENT				(640)
#define			DIALOG_SHOPERROR2			(650)
#define			DIALOG_LOADTRUCK			(660)
#define         DIALOG_LOADTRUCKOLD         (670)
#define			DIALOG_LOADTRUCKL			(680)
#define			DIALOG_LOADTRUCKI			(690)

#define         RESTAURANTMENU              (930)
#define         RESTAURANTMENU2             (931)
#define			STOREMENU					(940)
#define			LOTTOMENU					(950)
#define			ELEVATOR					(960)
#define			ELEVATOR2					(970)
#define			ELEVATOR3					(980)
#define			RENTMENU					(990)
#define			VIPNUMMENU					(1000)
#define			VIPNUMMENU2					(1010)
#define			TRACKCAR					(1030)
#define         TRACKCAR2                   (1035)
#define			GOTOPLAYERCAR				(1050)
#define			VEHICLESTORAGE				(1060)
#define         DV_TRACKCAR                 (1061)
#define         DV_STORAGE                  (1062)
#define			DIALOG_NUMBER_PLATE			(1080)
#define			DIALOG_NUMBER_PLATE_CHOSEN	(1090)
#define			COLORMENU					(1100)
#define			FIGHTMENU					(1110)
#define			REPORTSMENU					(1120)
#define			VIPWEPSMENU					(1290)
#define			SEMENU						(1460)
#define			SESKINS						(1470)
#define			SEGEAR						(1480)
#define			MPSMENU						(1490)
#define			MPSSKINS					(1500)
#define			MPSGEAR						(1510)
#define			MPSRELEASE					(1520)
#define			MPSPAYTICKETSCOP			(1530)
#define			MPSPAYTICKETS				(1540)
#define			GIVEKEYS					(1550)
#define			REMOVEKEYS					(1560)
#define			MPSFRELEASE					(1570)
#define			HQENTRANCE					(1580)
#define			HQEXIT						(1590)
#define			HQCUSTOMINT					(1600)
#define			HQDELETE					(1610)
#define			FAQMENU						(1620)
#define			COLOREDDOTSFAQ				(1630)
#define			LOCKSFAQ					(1640)
#define			SKINSFAQ					(1650)
#define			ATMFAQ						(1660)
#define			FACTIONSFAQ					(1670)
#define			GANGSFAQ					(1680)
#define			HITMENFAQ					(1690)
#define			WEBSITEFAQ					(1700)
#define			FURTHERHELPFAQ				(1710)
#define			SHOPMENU					(1720)
#define			UNMODCARMENU				(1730)
#define			DIALOG_CDBUY				(1740)
#define			DIALOG_CDLOCKBUY			(1910)
#define			DIALOG_CDLOCKMENU			(1920)
#define			DIALOG_CDGLOCKMENU			(1940)
#define			JOBHELPMENU					(1950)
#define			DETECTIVEJOB				(1960)
#define			DETECTIVEJOB2				(1970)
#define			DETECTIVEJOB3				(1980)
#define			LAWYERJOB					(1990)
#define			LAWYERJOB2					(2000)
#define			LAWYERJOB3					(2010)
#define			WHOREJOB					(2020)
#define			WHOREJOB2					(2030)
#define			WHOREJOB3					(2040)
#define			DRUGDEALERJOB				(2050)
#define			DRUGDEALERJOB2				(2060)
#define			DRUGDEALERJOB3				(2070)
#define			MECHANICJOB					(2080)
#define			MECHANICJOB2				(2090)
#define			MECHANICJOB3				(2100)
#define			BODYGUARDJOB				(2110)
#define			BODYGUARDJOB2				(2120)
#define			BODYGUARDJOB3				(2130)
#define			ARMSDEALERJOB				(2140)
#define			ARMSDEALERJOB2				(2150)
#define			ARMSDEALERJOB3				(2160)
#define			BOXERJOB					(2170)
#define			BOXERJOB2					(2180)
#define			BOXERJOB3					(2190)
#define			TAXIJOB						(2200)
#define			TAXIJOB2					(2210)
#define			TAXIJOB3					(2220)
#define			SMUGGLEJOB					(2230)
#define			SMUGGLEJOB2					(2240)
#define			SMUGGLEJOB3					(2250)
#define			CRAFTJOB					(2260)
#define			BARTENDERJOB				(2270)
#define			TRUCKERJOB					(2280)
#define			PIZZAJOB					(2290)
#define			MDC_START_ID				(2300)
#define			MDC_MAIN					(2310)
#define			MDC_FIND					(2320)
#define			MDC_MEMBERS					(2330)
#define			MDC_BLANK					(2340)
#define			MDC_WARRANTS				(2350)
#define			MDC_CHECK					(2360)
#define			MDC_LICENSES				(2370)
#define			MDC_MESSAGE					(2420)
#define			MDC_SMS						(2430)
#define			MDC_BOLOLIST				(2440)
#define			MDC_ISSUE					(2450)
#define			MDC_DELETE					(2460)
#define			MDC_DEL_WARRANT				(2470)
#define			MDC_DEL_BOLO				(2480)
#define			MDC_LOGOUT					(2490)
#define			MDC_CREATE					(2500)
#define			MDC_CIVILIANS				(2510)
#define			MDC_ISSUE_SLOT				(2520)
#define			MDC_MESSAGE_2				(2530)
#define			MDC_SMS_2					(2540)
#define			MDC_BOLO					(2550)
#define			MDC_BOLO_SLOT				(2560)
#define			MDC_END_ID					(2570)
#define			AUDIO_URL					(2580)
#define			DRINKLISTDIALOG				(2590)
#define			DRINKDIALOG					(2600)
#define			TIPDIALOG					(2610)
#define			LAELEVATOR					(2620)
#define			GIVETOY						(2629)
#define			TOYS						(2630)
#define			DELETETOY					(2640)
#define			WEARTOY						(2650)
#define			SELLTOY						(2655)
#define			CONFIRMSELLTOY				(2656)
#define			BUYTOYS						(2660)
#define			BUYTOYS2					(2670)
#define			BUYTOYS3					(2680)
#define			BUYTOYSGOLD					(2690)
#define			BUYTOYSGOLD2				(2700)
#define			BUYTOYSGOLD3				(2710)
#define			EDITTOYS					(2720)
#define			EDITTOYS2					(2730)
#define			EDITTOYSBONE				(2740)
#define			EDITTOYSPX					(2750)
#define			EDITTOYSPY					(2760)
#define			EDITTOYSPZ					(2770)
#define			EDITTOYSRX					(2780)
#define			EDITTOYSRY					(2790)
#define			EDITTOYSRZ					(2800)
#define			EDITTOYSSX					(2810)
#define			EDITTOYSSY					(2820)
#define			EDITTOYSSZ					(2830)
#define			LAELEVATORPASS				(2840)
#define			NGMENU						(2850)
#define			NGMENUWEP					(2860)
#define			NGMENUSKIN					(2870)
#define			BUYTOYSCOP					(2880)
#define			BUYTOYSCOP2					(2890)
#define			BUYTOYSCOP3					(2900)
#define			DIALOG_LICENSE_BUY			(2910)
#define			DIALOG_ADMAIN				(2920)
#define			DIALOG_ADLIST				(2930)
#define			DIALOG_ADPLACE				(2940)
#define			DIALOG_ADPLACEP				(2950)
#define			DIALOG_ADSEARCH				(2960)
#define			DIALOG_ADSEARCHLIST			(2970)
#define			DIALOG_ADFINAL				(2980)
#define			DIALOG_ADCATEGORY			(2981)
#define			DIALOG_ADCATEGORYPLACE		(2982)
#define			DIALOG_ADCATEGORYPLACEP		(2983)
#define			DIALOG_ADVERTVOUCHER		(2984)
#define			SELLVIP						(3000)
#define			DIALOG_DELETECAR			(3010)
#define         PANEL                       (3020)
#define         PANELCONTROLS               (3030)
#define			DIALOG_CHANGEPASS			(3040)
#define         DIALOG_CHANGEPASS2          (3045)
#define 		SETSTATION      			(3050)
#define			CUSTOM_URLCHOICE			(3051)
#define 		GENRES      				(3060)
#define 		STATIONLIST 				(3070)
#define 		STATIONLISTEN 				(3080)
#define 		TOP50LIST       			(3090)
#define 		TOP50LISTEN     			(3100)
#define 		STATIONSEARCH   			(3110)
#define 		STATIONSEARCHLIST   		(3120)
#define 		STATIONSEARCHLISTEN 		(3130)
#define 		INTERACTMAIN				(3140)
#define 		INTERACTPAY					(3150)
#define 		INTERACTGIVE				(3160)
#define 		INTERACTGIVE2				(3170)
#define         REGISTERSEX                 (3180)
#define         REGISTERMONTH               (3190)
#define         REGISTERDAY                 (3192)
#define         REGISTERYEAR                (3194)
#define         REGISTERREF                 (3195)
#define			STORAGESTORE                (3200)
#define         STORAGEEQUIP                (3210)
#define         DMRCONFIRM                  (3220)
#define			SHOPOBJECT_ORDERID			(3230)
#define			SHOPOBJECT_GIVEPLAYER		(3231)
#define			SHOPOBJECT_OBJECTID			(3232)
#define			SHOPOBJECT_TOYSLOT			(3233)
#define			SHOPOBJECT_SUCCESS			(3234)
#define         MDC_SHOWCRIMES              (3235)
#define         VIP_EXPIRES                 (3236)
#define         ADMIN_VEHCHECK              (3237)
#define         FLAG_LIST             		(3238)
#define         FLAG_DELETE                 (3239)
#define         FLAG_DELETE2                (3240)
#define         CRATE_GUNMENU               (3241)
#define         PBFORCE                   	(3242)
#define			MDC_REPORTS					(3243)
#define			MDC_SHOWREPORTS				(3244)

#define 		DIALOG_LISTGROUPS 			(3250)
#define 		DIALOG_EDITGROUP 			(3251)
#define 		DIALOG_GROUP_NAME 			(3252)
#define 		DIALOG_GROUP_TYPE			(3253)
#define 		DIALOG_GROUP_ALLEGIANCE 	(3254)
#define 		DIALOG_GROUP_DUTYCOL		(3355)
#define 		DIALOG_GROUP_RADIOCOL		(3356)
#define 		DIALOG_GROUP_EDITSTOCK		(3357)
#define 		DIALOG_GROUP_EDITWEPS		(3358)
#define 		DIALOG_GROUP_EDITDIVS		(3359)
#define 		DIALOG_GROUP_EDITRANKS		(3360)
#define 		DIALOG_GROUP_GETWEPS		(3362)
#define 		DIALOG_GROUP_GETSKIN		(3363)
#define 		DIALOG_GROUP_DISBAND		(3364)
#define 		DIALOG_GROUP_EDITCOST		(3365)
#define 		DIALOG_GROUP_EDITWEPID		(3366)
#define 		DIALOG_GROUP_EDITDIV		(3367)
#define 		DIALOG_GROUP_EDITRANK		(3368)
#define 		DIALOG_GROUP_LOCKERPOS		(3369)
#define 		DIALOG_GROUP_CRATEPOS		(3370)
#define 		DIALOG_GROUP_LOCKERS		(3371)

#define 		DIALOG_GROUP_RADIOACC		(3372)
#define 		DIALOG_GROUP_DEPTRADIOACC	(3373)
#define 		DIALOG_GROUP_INTRADIOACC	(3374)
#define 		DIALOG_GROUP_BUGACC			(3375)
#define 		DIALOG_GROUP_GOVACC			(3376)
#define 		DIALOG_GROUP_FREENC			(3377)
#define 		DIALOG_GROUP_SPIKES			(3378)
#define 		DIALOG_GROUP_CADES			(3379)
#define 		DIALOG_GROUP_CONES			(3380)
#define 		DIALOG_GROUP_FLARES			(3381)
#define 		DIALOG_GROUP_BARRELS		(3382)
#define 		DIALOG_GROUP_CRATE			(3383)
#define 		DIALOG_GROUP_LISTPAY		(3384)
#define 		DIALOG_GROUP_EDITPAY		(3385)

#define 		DIALOG_GROUP_LOCKERDELETECONF		(3386)
#define 		DIALOG_GROUP_LOCKERACTION			(3387)
#define 		DIALOG_GROUP_COSTTYPE				(3388)

#define			DIALOG_GROUP_GARAGEPOS				(3389)

#define 		DIALOG_GROUP_JURISDICTION_ADD		(3390)
#define 		DIALOG_GROUP_JURISDICTION_ADD2		(3391)
#define 		DIALOG_GROUP_JURISDICTION_LIST		(3392)
#define 		DIALOG_GROUP_JURISDICTION_REMOVE	(3393)

#define			DIALOG_GROUP_GARAGERANGE			(3394)

#define			DIALOG_GROUP_TACKLEACCESS			(3395)

#define         DIALOG_REPORTMENU           (3490)
#define         DIALOG_REPORTMENU2          (3500)
#define         DIALOG_REPORTDM             (3540)
#define         DIALOG_REPORTRK		        (3550)
#define         DIALOG_REPORTKOS            (3560)
#define         DIALOG_REPORTCR             (3570)
#define         DIALOG_REPORTCARRAM         (3580)
#define         DIALOG_REPORTPG             (3590)
#define         DIALOG_REPORTMG             (3600)
#define         DIALOG_REPORTSPAM           (3610)
#define         DIALOG_REPORTGDE            (3620)
#define         DIALOG_REPORTHACK           (3630)
#define         DIALOG_REPORTMF             (3640)
#define         DIALOG_REPORTSA             (3650)
#define         DIALOG_REPORTNRPN           (3660)
#define         DIALOG_REPORTBANEVADE       (3670)
#define         DIALOG_REPORTGE             (3680)
#define         DIALOG_REPORTRHN            (3690)
#define         DIALOG_REPORTRSE            (3700)
#define         DIALOG_REPORTLOG            (3710)
#define         DIALOG_REPORTCARSURF        (3720)
#define         DIALOG_REPORTNRPB           (3730)
#define         DIALOG_REPORTFREE           (3740)
#define         DIALOG_REPORTNOTLIST		(3750)
#define         DIALOG_REPORTNOTLIST2       (3755)
#define         DIALOG_UNMUTE               (3760)
#define         DIALOG_REPORTNRPB2          (3770)
#define         DIALOG_REPORTNAME           (3780)
#define         DIALOG_SPEAKTOADMIN         (3790)

#define         DIALOG_SUSPECTMENU          (3791)
#define			DIALOG_REPORTTEAMNAME		(3792)

#define         DIALOG_DEDICATEDPLAYER      (3800)

#define 		DIALOG_POMAILS 				(3810)
#define		 	DIALOG_PODETAIL 			(3820)
#define 		DIALOG_POTRASHED 			(3830)
#define 		DIALOG_POSTAMP 				(3840)
#define 		DIALOG_PORECEIVER 			(3850)
#define 		DIALOG_POMESSAGE 			(3860)

#define       	LISTTOYS_DELETETOY         	(3861)
#define       	LISTTOYS_DELETETOYCONFIRM   (3862)

#define         G_LOCKER_MAIN               (3863)
#define         G_LOCKER_EQUIPMENT          (3865)
#define         G_LOCKER_SWATUNIFORM        (3866)
#define         G_LOCKER_UNIFORM            (3867)
#define         G_LOCKER_UNDERCOVER         (3868)
#define         G_LOCKER_CLEARSUSPECT       (3869)

#define 		DIALOG_DPC					(3870)
#define 		DIALOG_DPC_WEAPONS			(3871)
#define 		DIALOG_DPC_COLOR			(3872)

#define			DIALOG_STOREPRICES          (3900)
#define			DIALOG_STOREITEMPRICE       (3910)
#define         DIALOG_STORECLOTHINGPRICE   (3911)
#define         DIALOG_GUNSHOPPRICE         (3912)
#define         DIALOG_BARPRICE             (3913)
#define         DIALOG_BARPRICE2            (3914)
#define         DIALOG_SEXSHOP              (3915)
#define         DIALOG_SEXSHOP2             (3916)
#define         DIALOG_GUNPRICES            (3917)
#define         DIALOG_RESTAURANT           (3918)
#define         DIALOG_RESTAURANT2          (3919)

#define			DIALOG_GASPRICE       		(3930)

#define 		DIALOG_SWITCHGROUP 			(3940)
#define 		DIALOG_MAKELEADER			(3950)
#define         DIALOG_HBADGE               (3951)

#define         DIALOG_AUCTIONS             (3960)
#define         DIALOG_AUCTIONS2            (3970)
#define         DIALOG_AUCTIONS3            (3980)
#define         DIALOG_ADMINAUCTIONS        (3990)
#define         DIALOG_ADMINAUCTIONS2       (4000)
#define         DIALOG_ADMINAUCTIONS3       (4010)
#define         DIALOG_ADMINAUCTIONS4       (4020)
#define         DIALOG_ADMINAUCTIONS5       (4030)
#define         DIALOG_ADMINAUCTIONS6       (4040)
#define         DIALOG_ADMINAUCTIONS7       (4050)

#define         DIALOG_REVISION     	    (4060)

#define 		DIALOG_CGAMESADMINMENU      (4090)
#define 		DIALOG_CGAMESSELECTPOKER    (4100)
#define 		DIALOG_CGAMESSETUPPOKER     (4110)
#define 		DIALOG_CGAMESCREDITS        (4120)
#define 		DIALOG_CGAMESSETUPPGAME     (4130)
#define 		DIALOG_CGAMESSETUPPGAME2	(4140)
#define 		DIALOG_CGAMESSETUPPGAME3	(4150)
#define 		DIALOG_CGAMESSETUPPGAME4	(4160)
#define 		DIALOG_CGAMESSETUPPGAME5	(4170)
#define 		DIALOG_CGAMESSETUPPGAME6	(4180)
#define 		DIALOG_CGAMESSETUPPGAME7	(4190)
#define 		DIALOG_CGAMESBUYINPOKER		(4200)
#define 		DIALOG_CGAMESCALLPOKER		(4210)
#define 		DIALOG_CGAMESRAISEPOKER     (4220)

#define         SKIN_LIST             		(4230)
#define         SKIN_CONFIRM           		(4240)
#define         SKIN_DELETE                 (4250)
#define         SKIN_DELETE2                (4260)

#define 		SPEEDCAM_DIALOG_MAIN		(4501)
#define         SPEEDCAM_DIALOG_RANGEC		(4502)
#define         SPEEDCAM_DIALOG_LIMIT		(4503)
#define         SPEEDCAM_DIALOG_OVERVIEW	(4504)
#define         SPEEDCAM_DIALOG_EDIT		(4505)
#define         SPEEDCAM_DIALOG_EDIT_IDX	(4506)
#define         SPEEDCAM_DIALOG_EDIT_POS	(4507)
#define         SPEEDCAM_DIALOG_EDIT_ROT	(4508)
#define         SPEEDCAM_DIALOG_EDIT_RANGE  (4509)
#define         SPEEDCAM_DIALOG_EDIT_LIMIT  (4510)
#define         SPEEDCAM_DIALOG_DELETE		(4511)
#define         SPEEDCAM_DIALOG_CONFIRMDEL  (4512)
#define         SPEEDCAM_DIALOG_GETNEAREST  (4513)

#define         NATION_APP_LIST			    (4520)
#define         NATION_APP_CHOOSE		    (4521)

//Shop Dialogs
#define         DIALOG_SHOPBUYTOYS          (4630)
#define         DIALOG_SHOPBUYTOYS2         (4635)
#define         DIALOG_SHOPBUYTOYS3         (4640)

#define         DIALOG_VIPSHOP              (4650)
#define         DIALOG_VIPSHOP2             (4655)
#define         DIALOG_VIPSHOP3             (4660)
#define         DIALOG_VIPBRONZE            (4665)
#define         DIALOG_VIPBRONZE2           (4666)
#define         DIALOG_VIPSILVER            (4670)
#define         DIALOG_VIPSILVER2           (4671)
#define         DIALOG_VIPGOLD              (4675)
#define         DIALOG_PURCHASEVIP          (4680)

#define         DIALOG_CARSHOP              (4690)
#define         DIALOG_CARSHOP2	            (4695)

#define         DIALOG_MISCSHOP             (4700)
#define         DIALOG_MISCSHOP2            (4705)

#define         DIALOG_EDITSHOP             (4710)
#define         DIALOG_EDITSHOP2            (4715)
#define         DIALOG_EDITSHOP3            (4720)

#define         DIALOG_SHOPBUSINESS         (4730)
#define         DIALOG_SHOPBUSINESS2        (4735)
#define         DIALOG_SHOPBUSINESS3        (4740)
#define         DIALOG_SHOPBUSINESS4        (4745)
#define         DIALOG_SHOPBUSINESS5        (4750)

#define         DIALOG_EDITSHOPBUSINESS     (4755)
#define         DIALOG_EDITSHOPBUSINESS2    (4760)
#define         DIALOG_EDITSHOPBUSINESS3    (4765)
#define         DIALOG_EDITSHOPBUSINESS4    (4770)
#define         DIALOG_EDITSHOPBUSINESS5    (4775)
#define         DIALOG_EDITSHOPBUSINESS6    (4780)
#define         DIALOG_EDITSHOPBUSINESS7    (4785)
#define         DIALOG_EDITSHOPBUSINESS8    (4790)
#define         DIALOG_EDITSHOPBUSINESS9    (4795)
#define         DIALOG_EDITSHOPBUSINESS10   (4800)
#define         DIALOG_EDITSHOPBUSINESS11   (4805)
#define         DIALOG_EDITSHOPBUSINESS12   (4810)
#define         DIALOG_EDITSHOPBUSINESS13   (4815)

#define         DIALOG_HOUSESHOP            (4820)
#define         DIALOG_HOUSESHOP2           (4825)
#define         DIALOG_HOUSESHOP3           (4830)
#define         DIALOG_HOUSESHOP4           (4835)
#define         DIALOG_HOUSESHOP5           (4836)
#define         DIALOG_HOUSESHOP6           (4837)
#define         DIALOG_HOUSESHOP7           (4838)
#define         DIALOG_HOUSESHOP8           (4839)

#define         DIALOG_ENTERPIN             (4840)
#define         DIALOG_CREATEPIN            (4845)
#define         DIALOG_CREATEPIN2           (4850)

#define         DIALOG_VIEWSALE             (4855)
#define         DIALOG_VIEWSALE2            (4856)

#define         DIALOG_SHOPGIFTRESET        (4860)
#define			DIALOG_SHOPTOTRESET			(4861)
#define			DIALOG_HALLOWEENSHOP		(4862)
#define			DIALOG_HALLOWEENSHOP1		(4863)
#define			DIALOG_HALLOWEENSHOP2		(4864)
#define         DIALOG_HEALTHCARE           (4865)
#define         DIALOG_HEALTHCARE2          (4870)
#define         DIALOG_RENTACAR             (4875)

#define         DIALOG_SHOPHELPMENU         (4880)
#define			DIALOG_EDITSHOPMENU        	(4885)
#define         DIALOG_CHARGEPLAYER         (4890)
#define         DIALOG_SHOPNEON             (4895)
#define         DIALOG_SHOPHELPMENU2        (4900)
#define         DIALOG_SHOPHELPMENU3        (4905)
#define         DIALOG_SHOPHELPMENU4        (4910)
#define         DIALOG_SHOPHELPMENU5        (4915)
#define         DIALOG_SHOPHELPMENU6        (4920)
#define         DIALOG_SHOPHELPMENU7        (4925)
#define         DIALOG_SHOPHELPMENU8        (4930)
#define         DIALOG_SHOPHELPMENU9        (4935)

#define         DIALOG_911MENU		 	    (4940)
#define         DIALOG_911EMERGENCY 	    (4945)
#define         DIALOG_911MEDICAL	 	    (4950)
#define         DIALOG_911POLICE	 	    (4955)
#define         DIALOG_911TOWING			(4960)
#define         DIALOG_911PICKLOCK			(4961)
#define         DIALOG_911PICKLOCK2			(4962)

#define         DIALOG_SELLCREDITS          (4965)
#define         DIALOG_RIMMOD               (4970)
#define         DIALOG_RIMMOD2              (4975)
#define         DIALOG_TACKLED              (4980)

#define         DIALOG_LOCKER_OS            (4985)
#define         DIALOG_LOCKER_COS           (4990)
#define         DIALOG_LOCKER_FAMED         (4995)

#define 		DIALOG_PVIPVOUCHER			(5000)

#define 		DIALOG_HOUSEINVITE			(5005)

#define			DIALOG_ARRESTREPORT 		(5006)

#define			DIALOG_NRNCONFIRM			(5007)

// Relay For Life
#define			DIALOG_RFL_TEAMS			(5010)
#define			DIALOG_RFL_SEL				(5020)
#define			DIALOG_RFL_PLAYERS			(5030)

#define 		DISPLAY_STATS				(5040)
#define 		DISPLAY_STATS2				(5041)
#define 		DISPLAY_INV					(5042)
#define 		DISPLAY_INV2				(5043)

// Voucher System
#define			DIALOG_VOUCHER				(5050)
#define			DIALOG_VOUCHER2				(5051)
#define			DIALOG_VOUCHERADMIN			(5052)

// Hunger Games
#define			DIALOG_HUNGERGAMES			(5060)

#define 		DIALOG_ROLL					(5055)

// Gang Tags
#define			DIALOG_GANGTAG_MAIN			(5065)
#define			DIALOG_GANGTAG_EDIT			(5066)
#define			DIALOG_GANGTAG_EDIT1		(5067)
#define			DIALOG_GANGTAG_ID			(5068)
#define			DIALOG_GANGTAG_FAMILY		(5069)
#define			DIALOG_GANGTAG_FSELECT		(5070)
#define			DIALOG_GANGTAG_FTAG			(5071)
#define			DIALOG_GANGTAG_FTAGSEL		(5072)
#define 		DIALOG_GANGTAG_FTAGEDIT		(5073)

#define			DIALOG_CONFIRMADP			(5074)

#define			DIALOG_JFINE				(5075)
#define			DIALOG_JFINECONFIRM			(5076)

#define			DIALOG_GIFTBOX_VIEW			(5077)
#define			DIALOG_GIFTBOX_INFO			(5078)

#define			DIALOG_VIPSPAWN				(5079)

#define			DIALOG_VIPJOB				(5080)

#define 		DIALOG_NONRPACTION			(5081)
#define			DIALOG_WATCHLIST			(5082)
#define			DIALOG_WDREPORT				(5083)

#define 		DIALOG_BACKPACKS			(5085)
#define 		DIALOG_OBACKPACK			(5086)
#define 		DIALOG_BFOOD				(5087)
#define 		DIALOG_BNARCOTICS			(5088)
#define 		DIALOG_BNARCOTICS2			(5089)
#define 		DIALOG_BNARCOTICS3			(5090)
#define 		DIALOG_BGUNS				(5091)
#define 		DIALOG_BGUNS2				(5092)
#define 		DIALOG_BMEALSTORE			(5093)
#define			DIALOG_BMEDKIT				(5094)
#define			DIALOG_BDROP				(5095)

#define			DIALOG_BUGREPORT 			(6000)

// Objects
#define 		OBJ_POKER_TABLE 					19474

// GUI
#define 		GUI_POKER_TABLE						0

// Poker Misc
#define 		MAX_POKERTABLES 					100
#define 		MAX_POKERTABLEMISCOBJS				6
#define 		MAX_PLAYERPOKERUI					48
#define 		DRAWDISTANCE_POKER_TABLE 			150.0
#define 		DRAWDISTANCE_POKER_MISC 			50.0
#define 		CAMERA_POKER_INTERPOLATE_SPEED		5000 // ms (longer = slower)

			/*  ---------------- COLORS ----------------- */
    				/* ===[Ignore the tab space]=== */
#define CHECKPOINT_NONE 0
#define CHECKPOINT_HOME 12
#define CHECKPOINT_LOADTRUCK 97651
#define CHECKPOINT_RETURNTRUCK 97652
#define CHECKPOINT_HITMAN 123
#define CHECKPOINT_HITMAN2 124
#define CHECKPOINT_HITMAN3 125
#define CHECKPOINT_DELIVERY 126
#define COLOR_TWWHITE 0xFFFFFFAA
#define COLOR_TWYELLOW 0xFFFF00AA
#define COLOR_TWPINK 0xE75480AA
#define COLOR_TWRED 0xFF0000AA
#define COLOR_TWBROWN 0x654321AA
#define COLOR_TWGRAY 0x808080AA
#define COLOR_TWOLIVE 0x808000AA
#define COLOR_TWPURPLE 0x800080AA
#define COLOR_TWTAN 0xD2B48CAA
#define COLOR_TWAQUA 0x00FFFFAA
#define COLOR_TWORANGE 0xFF8C00AA
#define COLOR_TWAZURE 0x007FFFAA
#define COLOR_TWGREEN 0x008000AA
#define COLOR_TWBLUE 0x0000FFAA
#define COLOR_TWBLACK 0x000000AA
#define COLOR_ORANGE 0xFF8000FF
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6 0xF0F0F0FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_REALRED 0xFF0606FF
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTGREEN 0x9ACD32AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_TAXI 0xFFFF9000
#define COLOR_VIP 0xC93CCE00
#define COLOR_FAMED 0x99FF0000
#define COLOR_DPC 0x0080FFFF
#define COLOR_YELLOW2 0xF5DEB3AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_DBLUE 0x2641FEAA
#define COLOR_ALLDEPT 0xFF8282AA
#define COLOR_BLACK 0x000000AA
#define COLOR_NEWS 0xFFA500AA
#define COLOR_OOC 0xE0FFFFAA
#define COLOR_CYAN 0x40FFFFFF
#define	COLOR_LIME 0xABFF6600
#define PUBLICRADIO_COLOR 0x6DFB6DFF
#define TEAM_CYAN 1
#define TEAM_BLUE 2
#define TEAM_GREEN 3
#define TEAM_ORANGE 4
#define TEAM_COR 5
#define TEAM_BAR 6
#define TEAM_TAT 7
#define TEAM_CUN 8
#define TEAM_STR 9
#define TEAM_HIT 10
#define TEAM_ADMIN 11
#define PAINTBALL_TEAM_RED 0xFF000000
#define PAINTBALL_TEAM_BLUE 0x2641FE00
#define FIND_COLOR 0xB90000FF
#define TEAM_GREEN_COLOR 0xFFFFFFAA
#define TEAM_JOB_COLOR 0xFFB6C1AA
#define TEAM_HIT_COLOR 0xFFFFFF00
#define TEAM_BLUE_COLOR 0x2641FE00
#define TEAM_TAXI_COLOR 0xF2FF0000
#define COP_GREEN_COLOR 0x33AA33AA
#define TEAM_GROVE_COLOR 0x00D900C8
#define TEAM_AZTECAS_COLOR 0x01FCFFC8
#define TEAM_CYAN_COLOR 0xFF8282AA
#define TEAM_MED_COLOR 0xFF828200
#define TEAM_ORANGE_COLOR 0xFF800000
#define TEAM_APRISON_COLOR 0x9C791200
#define DEPTRADIO 0xFFD7004A
#define RADIO 0x8D8DFFFF
#define FRADIO 0xAA3333AA
#define COLOR_NEWBIE 0x7DAEFFFF
#define COLOR_COMBINEDCHAT 0x6CEFF0FF
#define COLOR_JOINHELPERCHAT 0xAAC0E4FF
#define COLOR_HELPERCHAT  0x0BBD5FEC8
#define COLOR_REPORT 0xFFFF91FF
#define COLOR_SHOP 0xE7E784FF
#define COLOR_TR 0x56B9B900
#define COLOR_BR 0xCD8500FF
#define SHITTY_JUDICIALSHITHOTCH 0xFF66CC00

			/*  ---------------- ELEVATOR ----------------- */
#define ELEVATOR_SPEED      (5.0)   // Movement speed of the elevator.
#define DOORS_SPEED         (4.0)   // Movement speed of the doors.
#define ELEVATOR_WAIT_TIME  (5000)  // Time in ms that the elevator will wait in each floor before continuing with the queue.
									// Be sure to give enough time for doors to open.
#define X_DOOR_CLOSED       (1786.627685)
#define X_DOOR_R_OPENED     (1785.027685)
#define X_DOOR_L_OPENED     (1788.227685)
#define GROUND_Z_COORD      (14.511476)
#define ELEVATOR_OFFSET     (0.059523)

#define ELEVATOR_STATE_IDLE     (0)
#define ELEVATOR_STATE_WAITING  (1)
#define ELEVATOR_STATE_MOVING   (2)
#define INVALID_FLOOR           (-1)

			/*  ---------------- mSelection ----------------- */
#define mS_TOTAL_ITEMS         	1000 // Max amount of items from all lists
#define mS_TOTAL_LISTS			20 // Max amount of lists
#define mS_TOTAL_ROT_ZOOM		100 // Max amount of items using extra information like zoom or rotations
#define mS_CUSTOM_MAX_ITEMS		20
#define mS_INVALID_LISTID		mS_TOTAL_LISTS
#define mS_CUSTOM_LISTID		(mS_TOTAL_LISTS+1)
#define mS_NEXT_TEXT   "Next"
#define mS_PREV_TEXT   "Prev"
#define mS_CANCEL_TEXT   "Cancel"
#define mS_SELECTION_ITEMS 		21
#define mS_ITEMS_PER_LINE  		7
#define mS_DIALOG_BASE_X   	75.0
#define mS_DIALOG_BASE_Y   	130.0
#define mS_DIALOG_WIDTH    	550.0
#define mS_DIALOG_HEIGHT   	180.0
#define mS_SPRITE_DIM_X    	60.0
#define mS_SPRITE_DIM_Y    	70.0
#define mS_LIST_START			0
#define mS_LIST_END				1
#define mS_ITEM_MODEL			0
#define mS_ITEM_ROT_ZOOM_ID 	1

			/*  ---------------- MySQL ----------------- */
#define 		NO_THREAD 						-1
#define 		NO_EXTRAID 						-1
#define 		LOADUSERDATA_THREAD 			1
#define 		SENDDATA_THREAD 				2
#define 		AUTH_THREAD 					3
#define 		LOGIN_THREAD 					4
#define 		REGISTER_THREAD 				5
#define 		ONLINE_THREAD 					6
#define 		LOADMOTDDATA_THREAD 			7
#define 		LOADPVEHPOS_THREAD 				8
#define 		CHECKPVEHPOS_THREAD 			9
#define 		MDC_THREAD 						10
#define 		LOADCRATE_THREAD 				11
#define 		IPBAN_THREAD 					12
#define 		LOADSALEDATA_THREAD 			13
#define 		LOADSHOPDATA_THREAD 			14
#define 		MAIN_REFERRAL_THREAD    		15
#define         REWARD_REFERRAL_THREAD          16
#define 		LOADPVEHICLE_THREAD				17
#define         OFFLINE_FAMED_THREAD            18
#define			BUG_LIST_THREAD					19
#define			LOADPTOYS_THREAD				21
#define			ADMINWHITELIST_THREAD			22
#define			LOADGIFTBOX_THREAD				23
#define			LOADPNONRPOINTS_THREAD			24
#define 		Flag_Query_Display  			1
#define 		Flag_Query_Offline  			2
#define 		Flag_Query_Count    			3
#define 		Skin_Query_Display   			1
#define 		Skin_Query_Count     			2
#define 		Skin_Query_ID	     			3
#define 		Skin_Query_Delete    			4
#define 		Skin_Query_Delete_ID 			5
#define 		TR_Citizen_Count   				1
#define 		Total_Count	       				2
#define 		CheckQueue  	   				1
#define 		UpdateQueue  	   				2
#define 		AppQueue	  	   				3
#define 		AddQueue	       				4
#define 		AcceptApp	  	   				1
#define 		DenyApp		  	   				2

// GivePlayerCashEx Types
#define			TYPE_BANK						1
#define			TYPE_ONHAND						2

//OnGangTagQueryFinish Threads
#define			LOAD_GANGTAGS					1
#define			SAVE_GANGTAG					2