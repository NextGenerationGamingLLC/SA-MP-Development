/*
Navicat MySQL Data Transfer

Source Server         : NGG SQL
Source Server Version : 50625
Source Host           : samp.ng-gaming.net:3306
Source Database       : samp_main

Target Server Type    : MYSQL
Target Server Version : 50625
File Encoding         : 65001

Date: 2015-06-09 05:04:40
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for 911Calls
-- ----------------------------
DROP TABLE IF EXISTS `911Calls`;
CREATE TABLE `911Calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Caller` varchar(24) NOT NULL DEFAULT 'N/A',
  `Phone` int(11) NOT NULL DEFAULT '0',
  `Area` varchar(255) NOT NULL DEFAULT 'None',
  `MainZone` varchar(255) NOT NULL DEFAULT 'None',
  `Description` varchar(255) NOT NULL DEFAULT 'None',
  `Type` int(11) NOT NULL DEFAULT '0',
  `Time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44108 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for accounts
-- ----------------------------
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Online` int(11) NOT NULL DEFAULT '0',
  `UpdateDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `RegiDate` datetime DEFAULT NULL,
  `LastLogin` datetime DEFAULT NULL,
  `Username` varchar(32) NOT NULL DEFAULT '',
  `Key` varchar(256) NOT NULL DEFAULT '',
  `Salt` varchar(11) DEFAULT NULL,
  `LastPassChange` datetime NOT NULL DEFAULT '2014-07-09 05:06:42',
  `Email` varchar(256) NOT NULL DEFAULT '',
  `_Email` varchar(256) NOT NULL DEFAULT '',
  `EmailOptOut` int(1) NOT NULL DEFAULT '0',
  `IP` varchar(32) NOT NULL DEFAULT '0.0.0.0',
  `SecureIP` varchar(32) NOT NULL DEFAULT '0.0.0.0',
  `Registered` int(11) NOT NULL DEFAULT '0',
  `ConnectedTime` int(11) NOT NULL DEFAULT '0',
  `Sex` int(11) NOT NULL DEFAULT '1',
  `BirthDate` date DEFAULT '0000-00-00',
  `Age` int(11) NOT NULL DEFAULT '18',
  `Band` int(11) NOT NULL DEFAULT '0',
  `PermBand` int(11) NOT NULL DEFAULT '0',
  `Warnings` int(11) NOT NULL DEFAULT '0',
  `Disabled` int(11) NOT NULL DEFAULT '0',
  `Level` int(11) NOT NULL DEFAULT '1',
  `AdminLevel` int(11) NOT NULL DEFAULT '0',
  `AdminType` int(1) NOT NULL DEFAULT '0',
  `SeniorModerator` int(11) NOT NULL DEFAULT '0',
  `Helper` int(11) NOT NULL DEFAULT '0',
  `DonateRank` int(11) NOT NULL DEFAULT '0',
  `Respect` int(11) NOT NULL DEFAULT '0',
  `Money` bigint(11) NOT NULL DEFAULT '5000',
  `Bank` bigint(11) NOT NULL DEFAULT '20000',
  `pHealth` float(10,5) NOT NULL DEFAULT '50.00000',
  `pArmor` float(10,5) NOT NULL DEFAULT '0.00000',
  `pSHealth` float(10,5) NOT NULL DEFAULT '0.00000',
  `Int` int(11) NOT NULL DEFAULT '0',
  `VirtualWorld` int(11) NOT NULL DEFAULT '0',
  `Model` int(11) NOT NULL DEFAULT '299',
  `SPos_x` float(20,5) NOT NULL DEFAULT '0.00000',
  `SPos_y` float(20,5) NOT NULL DEFAULT '0.00000',
  `SPos_z` float(20,5) NOT NULL DEFAULT '0.00000',
  `SPos_r` float(20,5) NOT NULL DEFAULT '0.00000',
  `BanAppealer` int(11) NOT NULL DEFAULT '0',
  `PR` int(11) NOT NULL DEFAULT '0',
  `HR` int(11) NOT NULL DEFAULT '0',
  `AP` int(11) NOT NULL DEFAULT '0',
  `Security` int(11) NOT NULL DEFAULT '0',
  `ShopTech` int(11) NOT NULL DEFAULT '0',
  `FactionModerator` int(11) NOT NULL DEFAULT '0',
  `GangModerator` int(11) NOT NULL DEFAULT '0',
  `Undercover` int(11) NOT NULL DEFAULT '0',
  `TogReports` int(11) NOT NULL DEFAULT '0',
  `Radio` int(11) NOT NULL DEFAULT '0',
  `RadioFreq` int(11) NOT NULL DEFAULT '0',
  `UpgradePoints` int(11) NOT NULL DEFAULT '0',
  `Origin` int(11) NOT NULL DEFAULT '0',
  `Muted` int(11) NOT NULL DEFAULT '0',
  `Crimes` int(11) NOT NULL DEFAULT '0',
  `Accent` int(11) NOT NULL DEFAULT '0',
  `CHits` int(11) NOT NULL DEFAULT '0',
  `FHits` int(11) NOT NULL DEFAULT '0',
  `Arrested` int(11) NOT NULL DEFAULT '0',
  `Phonebook` int(11) NOT NULL DEFAULT '0',
  `LottoNr` int(11) NOT NULL DEFAULT '0',
  `Fishes` int(11) NOT NULL DEFAULT '0',
  `BiggestFish` int(11) NOT NULL DEFAULT '0',
  `Job` int(11) NOT NULL DEFAULT '0',
  `Job2` int(11) NOT NULL DEFAULT '0',
  `Paycheck` int(11) NOT NULL DEFAULT '0',
  `HeadValue` int(11) NOT NULL DEFAULT '0',
  `Jailed` int(11) NOT NULL DEFAULT '0',
  `JailTime` int(11) NOT NULL DEFAULT '0',
  `WRestricted` int(11) NOT NULL DEFAULT '0',
  `Materials` int(11) NOT NULL DEFAULT '0',
  `Crates` int(11) NOT NULL DEFAULT '0',
  `Pot` int(11) NOT NULL DEFAULT '0',
  `Crack` int(11) NOT NULL DEFAULT '0',
  `Nation` int(1) NOT NULL DEFAULT '0',
  `Leader` int(11) NOT NULL DEFAULT '-1',
  `Member` int(11) NOT NULL DEFAULT '-1',
  `Division` int(11) NOT NULL DEFAULT '-1',
  `Badge` varchar(8) NOT NULL DEFAULT 'None',
  `FMember` int(11) NOT NULL DEFAULT '255',
  `Rank` int(11) NOT NULL DEFAULT '-1',
  `DetSkill` int(11) NOT NULL DEFAULT '0',
  `SexSkill` int(11) NOT NULL DEFAULT '0',
  `BoxSkill` int(11) NOT NULL DEFAULT '0',
  `LawSkill` int(11) NOT NULL DEFAULT '0',
  `MechSkill` int(11) NOT NULL DEFAULT '0',
  `TruckSkill` int(11) NOT NULL DEFAULT '0',
  `DrugsSkill` int(11) NOT NULL DEFAULT '0',
  `ArmsSkill` int(11) NOT NULL DEFAULT '0',
  `SmugglerSkill` int(11) NOT NULL DEFAULT '0',
  `FishSkill` int(11) NOT NULL DEFAULT '0',
  `FightingStyle` int(11) NOT NULL DEFAULT '0',
  `PhoneNr` int(11) NOT NULL DEFAULT '0',
  `Apartment` int(11) NOT NULL DEFAULT '-1',
  `Apartment2` int(11) NOT NULL DEFAULT '-1',
  `Renting` int(11) NOT NULL DEFAULT '-1',
  `CarLic` int(11) NOT NULL DEFAULT '0',
  `FlyLic` int(11) NOT NULL DEFAULT '0',
  `BoatLic` int(11) NOT NULL DEFAULT '1',
  `FishLic` int(11) NOT NULL DEFAULT '1',
  `CheckCash` int(11) NOT NULL DEFAULT '0',
  `Checks` int(11) NOT NULL DEFAULT '0',
  `GunLic` int(11) NOT NULL DEFAULT '1',
  `Gun0` int(11) NOT NULL DEFAULT '0',
  `Gun1` int(11) NOT NULL DEFAULT '0',
  `Gun2` int(11) NOT NULL DEFAULT '0',
  `Gun3` int(11) NOT NULL DEFAULT '0',
  `Gun4` int(11) NOT NULL DEFAULT '0',
  `Gun5` int(11) NOT NULL DEFAULT '0',
  `Gun6` int(11) NOT NULL DEFAULT '0',
  `Gun7` int(11) NOT NULL DEFAULT '0',
  `Gun8` int(11) NOT NULL DEFAULT '0',
  `Gun9` int(11) NOT NULL DEFAULT '0',
  `Gun10` int(11) NOT NULL DEFAULT '0',
  `Gun11` int(11) NOT NULL DEFAULT '0',
  `DrugsTime` int(11) NOT NULL DEFAULT '0',
  `LawyerTime` int(11) NOT NULL DEFAULT '0',
  `LawyerFreeTime` int(11) NOT NULL DEFAULT '0',
  `MechTime` int(11) NOT NULL DEFAULT '0',
  `SexTime` int(11) NOT NULL DEFAULT '0',
  `PayDay` int(11) NOT NULL DEFAULT '0',
  `PayDayHad` int(11) NOT NULL DEFAULT '0',
  `CDPlayer` int(11) NOT NULL DEFAULT '0',
  `Dice` int(11) NOT NULL DEFAULT '0',
  `Spraycan` int(11) NOT NULL DEFAULT '0',
  `Rope` int(11) NOT NULL DEFAULT '0',
  `Cigars` int(11) NOT NULL DEFAULT '0',
  `Sprunk` int(11) NOT NULL DEFAULT '0',
  `Bombs` int(11) NOT NULL DEFAULT '0',
  `Wins` int(11) NOT NULL DEFAULT '0',
  `Loses` int(11) NOT NULL DEFAULT '0',
  `Tutorial` int(11) NOT NULL DEFAULT '0',
  `OnDuty` int(11) NOT NULL DEFAULT '0',
  `Hospital` int(11) NOT NULL DEFAULT '0',
  `Married` int(11) NOT NULL DEFAULT '0',
  `MarriedID` int(11) NOT NULL DEFAULT '-1',
  `MarriedTo` varchar(32) NOT NULL DEFAULT 'Nobody',
  `ContractBy` varchar(32) NOT NULL DEFAULT 'Nobody',
  `ContractDetail` varchar(64) NOT NULL DEFAULT 'None',
  `WantedLevel` int(11) NOT NULL DEFAULT '0',
  `Insurance` int(11) NOT NULL DEFAULT '0',
  `911Muted` int(1) NOT NULL DEFAULT '0',
  `NewMuted` int(11) NOT NULL DEFAULT '0',
  `NewMutedTotal` int(11) NOT NULL DEFAULT '0',
  `AdMuted` int(11) NOT NULL DEFAULT '0',
  `AdMutedTotal` int(11) NOT NULL DEFAULT '0',
  `HelpMute` int(11) NOT NULL DEFAULT '0',
  `ReportMuted` int(11) NOT NULL DEFAULT '0',
  `ReportMutedTotal` int(11) NOT NULL DEFAULT '0',
  `ReportMutedTime` int(11) NOT NULL DEFAULT '0',
  `VIPMuted` int(11) NOT NULL DEFAULT '0',
  `VIPMutedTime` int(11) NOT NULL DEFAULT '0',
  `GiftTime` int(11) NOT NULL DEFAULT '0',
  `AdvisorDutyHours` int(11) NOT NULL DEFAULT '0',
  `AcceptedHelp` int(11) NOT NULL DEFAULT '0',
  `AcceptReport` int(11) NOT NULL DEFAULT '0',
  `ShopTechOrders` int(11) NOT NULL DEFAULT '0',
  `TrashReport` int(11) NOT NULL DEFAULT '0',
  `GangWarn` int(11) NOT NULL DEFAULT '0',
  `FactionBanned` int(11) NOT NULL DEFAULT '0',
  `CSFBanned` int(11) NOT NULL DEFAULT '0',
  `VIPInviteDay` int(11) NOT NULL DEFAULT '0',
  `TempVIP` int(11) NOT NULL DEFAULT '0',
  `BuddyInvite` int(11) NOT NULL DEFAULT '0',
  `Tokens` int(11) NOT NULL DEFAULT '0',
  `PTokens` int(11) NOT NULL DEFAULT '0',
  `TriageTime` int(11) NOT NULL DEFAULT '0',
  `PrisonedBy` varchar(32) NOT NULL DEFAULT 'Nobody',
  `PrisonReason` varchar(128) NOT NULL DEFAULT 'None',
  `Flag` varchar(128) NOT NULL DEFAULT '',
  `TaxiLicense` int(11) NOT NULL DEFAULT '0',
  `TicketTime` int(11) NOT NULL DEFAULT '0',
  `Screwdriver` int(11) NOT NULL DEFAULT '0',
  `Smslog` int(11) NOT NULL DEFAULT '0',
  `Wristwatch` int(11) NOT NULL DEFAULT '0',
  `Surveillance` int(11) NOT NULL DEFAULT '0',
  `Tire` int(11) NOT NULL DEFAULT '0',
  `Firstaid` int(11) NOT NULL DEFAULT '0',
  `Rccam` int(11) NOT NULL DEFAULT '0',
  `Receiver` int(11) NOT NULL DEFAULT '0',
  `GPS` int(11) NOT NULL DEFAULT '0',
  `Sweep` int(11) NOT NULL DEFAULT '0',
  `SweepLeft` int(11) NOT NULL DEFAULT '0',
  `Bugged` int(11) NOT NULL DEFAULT '0',
  `pWExists` int(11) NOT NULL DEFAULT '0',
  `pWSeeds` int(11) NOT NULL DEFAULT '0',
  `Warrants` varchar(128) NOT NULL DEFAULT '',
  `JudgeJailTime` int(11) NOT NULL DEFAULT '0',
  `JudgeJailType` int(11) NOT NULL DEFAULT '0',
  `BeingSentenced` int(11) NOT NULL DEFAULT '0',
  `ProbationTime` int(11) NOT NULL DEFAULT '0',
  `DMKills` int(11) NOT NULL DEFAULT '0',
  `Order` varchar(63) NOT NULL DEFAULT '',
  `OrderConfirmed` int(11) NOT NULL DEFAULT '0',
  `CallsAccepted` int(11) NOT NULL DEFAULT '0',
  `PatientsDelivered` int(11) NOT NULL DEFAULT '0',
  `LiveBanned` int(11) NOT NULL DEFAULT '0',
  `FreezeBank` int(11) NOT NULL DEFAULT '0',
  `FreezeHouse` int(11) NOT NULL DEFAULT '0',
  `FreezeCar` int(11) NOT NULL DEFAULT '0',
  `Hydration` int(11) NOT NULL DEFAULT '0',
  `DoubleEXP` int(11) NOT NULL DEFAULT '0',
  `EXPToken` int(11) NOT NULL DEFAULT '0',
  `RacePlayerLaps` int(11) NOT NULL DEFAULT '0',
  `Ringtone` int(11) NOT NULL DEFAULT '0',
  `VIPM` int(11) NOT NULL DEFAULT '0',
  `VIPMO` int(11) NOT NULL DEFAULT '0',
  `VIPExpire` int(11) NOT NULL DEFAULT '0',
  `VIPSold` int(11) NOT NULL DEFAULT '0',
  `GVip` int(11) NOT NULL DEFAULT '0',
  `Speedo` int(11) NOT NULL DEFAULT '0',
  `Firework` int(11) NOT NULL DEFAULT '0',
  `Boombox` int(11) NOT NULL DEFAULT '0',
  `DrawChance` int(11) NOT NULL DEFAULT '0',
  `GoldBoxTokens` int(11) NOT NULL DEFAULT '0',
  `RewardHours` float(10,5) NOT NULL DEFAULT '0.00000',
  `DMRMuted` int(11) unsigned NOT NULL DEFAULT '0',
  `Watchdog` int(11) unsigned NOT NULL DEFAULT '0',
  `CarsRestricted` tinyint(2) NOT NULL DEFAULT '0',
  `Flagged` tinyint(2) NOT NULL DEFAULT '0',
  `LepPoints` int(11) unsigned NOT NULL DEFAULT '0',
  `LepSafePoints` int(11) NOT NULL DEFAULT '0',
  `LastCarWarning` int(11) NOT NULL DEFAULT '0',
  `CarWarns` int(11) NOT NULL DEFAULT '0',
  `Scripter` int(11) NOT NULL DEFAULT '0',
  `Hours` int(11) NOT NULL DEFAULT '0',
  `Paper` int(11) NOT NULL DEFAULT '0',
  `MailEnabled` int(11) NOT NULL DEFAULT '1',
  `Mailbox` int(11) NOT NULL DEFAULT '0',
  `UnreadMails` int(11) NOT NULL DEFAULT '0',
  `TreasureSkill` int(5) NOT NULL DEFAULT '0',
  `MetalDetector` int(5) NOT NULL DEFAULT '0',
  `HelpedBefore` int(11) NOT NULL DEFAULT '0',
  `Business` int(11) NOT NULL DEFAULT '-1',
  `BusinessRank` int(11) NOT NULL DEFAULT '-1',
  `pEventTokens` int(11) NOT NULL DEFAULT '0',
  `RHMutes` int(1) NOT NULL DEFAULT '0',
  `RHMuteTime` int(11) NOT NULL DEFAULT '0',
  `referral_id` varchar(20) DEFAULT NULL,
  `GiftCode` int(11) NOT NULL DEFAULT '0',
  `Table` int(11) NOT NULL DEFAULT '0',
  `OpiumSeeds` int(11) NOT NULL DEFAULT '0',
  `RawOpium` int(11) NOT NULL DEFAULT '0',
  `Heroin` int(11) NOT NULL DEFAULT '0',
  `Syringe` int(11) NOT NULL DEFAULT '0',
  `Skins` int(11) NOT NULL DEFAULT '0',
  `Hunger` int(11) NOT NULL DEFAULT '50',
  `HungerTimer` int(11) NOT NULL DEFAULT '0',
  `HungerDeathTimer` int(11) NOT NULL DEFAULT '0',
  `Fitness` int(11) NOT NULL DEFAULT '0',
  `LastCharmReceived` int(11) NOT NULL DEFAULT '0',
  `ForcePasswordChange` int(11) NOT NULL DEFAULT '0',
  `Credits` int(11) NOT NULL DEFAULT '0',
  `ReceivedCredits` int(11) NOT NULL DEFAULT '0',
  `TotalCredits` int(11) NOT NULL DEFAULT '0',
  `HealthCare` int(11) NOT NULL DEFAULT '0',
  `Pin` varchar(256) NOT NULL DEFAULT '',
  `RimMod` int(11) NOT NULL DEFAULT '0',
  `Tazer` int(11) NOT NULL DEFAULT '0',
  `Cuff` int(11) NOT NULL DEFAULT '0',
  `CarVoucher` int(11) NOT NULL DEFAULT '0',
  `ReferredBy` varchar(32) NOT NULL DEFAULT 'Nobody',
  `ReferredID` int(11) NOT NULL DEFAULT '-1',
  `PendingRefReward` int(11) NOT NULL DEFAULT '0',
  `Refers` int(11) NOT NULL DEFAULT '0',
  `Developer` int(11) NOT NULL DEFAULT '0',
  `Famed` int(11) NOT NULL DEFAULT '0',
  `FamedMuted` int(11) NOT NULL DEFAULT '0',
  `DefendTime` int(11) NOT NULL DEFAULT '0',
  `PVIPVoucher` int(11) NOT NULL DEFAULT '0',
  `VehicleSlot` int(11) NOT NULL DEFAULT '0',
  `ToySlot` int(11) NOT NULL DEFAULT '0',
  `RFLTeam` int(11) NOT NULL DEFAULT '-1',
  `RFLTeamL` int(11) NOT NULL DEFAULT '-1',
  `ReceivedCreditReward` int(11) NOT NULL DEFAULT '0',
  `GiftVoucher` int(11) NOT NULL DEFAULT '0',
  `VehVoucher` int(11) NOT NULL DEFAULT '0',
  `SVIPVoucher` int(11) NOT NULL DEFAULT '0',
  `GVIPVoucher` int(11) NOT NULL DEFAULT '0',
  `FallIntoFun` int(11) NOT NULL DEFAULT '0',
  `HungerVoucher` int(11) NOT NULL DEFAULT '0',
  `BoughtCure` int(11) NOT NULL DEFAULT '0',
  `Vials` int(11) NOT NULL DEFAULT '0',
  `ShopCounter` int(11) NOT NULL DEFAULT '0',
  `ShopNotice` int(11) NOT NULL DEFAULT '0',
  `AdvertVoucher` int(11) NOT NULL DEFAULT '0',
  `SVIPExVoucher` int(11) NOT NULL DEFAULT '0',
  `GVIPExVoucher` int(11) NOT NULL DEFAULT '0',
  `VIPSellable` int(11) NOT NULL DEFAULT '0',
  `ReceivedPrize` int(11) NOT NULL DEFAULT '0',
  `VIPSpawn` int(11) NOT NULL DEFAULT '0',
  `FreeAdsDay` int(11) NOT NULL DEFAULT '0',
  `FreeAdsLeft` int(11) NOT NULL DEFAULT '0',
  `BuddyInvites` int(11) NOT NULL DEFAULT '0',
  `ReceivedBGift` int(11) NOT NULL DEFAULT '0',
  `pVIPJob` int(11) NOT NULL DEFAULT '1',
  `LastBirthday` int(11) NOT NULL DEFAULT '0',
  `Job3` int(11) NOT NULL DEFAULT '0',
  `Apartment3` int(11) NOT NULL DEFAULT '-1',
  `Backpack` int(11) NOT NULL DEFAULT '0',
  `BEquipped` int(11) NOT NULL DEFAULT '0',
  `BStoredH` int(11) NOT NULL DEFAULT '0',
  `BStoredV` int(11) NOT NULL DEFAULT '0',
  `BItem0` int(11) NOT NULL DEFAULT '0',
  `BItem1` int(11) NOT NULL DEFAULT '0',
  `BItem2` int(11) NOT NULL DEFAULT '0',
  `BItem3` int(11) NOT NULL DEFAULT '0',
  `BItem4` int(11) NOT NULL DEFAULT '0',
  `BItem5` int(11) NOT NULL DEFAULT '0',
  `BItem6` int(11) NOT NULL DEFAULT '0',
  `BItem7` int(11) NOT NULL DEFAULT '0',
  `BItem8` int(11) NOT NULL DEFAULT '0',
  `BItem9` int(11) NOT NULL DEFAULT '0',
  `BItem10` int(11) NOT NULL DEFAULT '0',
  `AccountRestricted` int(11) NOT NULL DEFAULT '0',
  `Watchlist` int(11) NOT NULL DEFAULT '0',
  `WatchlistTime` int(11) NOT NULL DEFAULT '0',
  `BetaTester` int(11) NOT NULL DEFAULT '0',
  `AvatarLink` varchar(255) NOT NULL DEFAULT 'http://',
  `cms` int(11) NOT NULL DEFAULT '0',
  `BRTimeout` int(11) NOT NULL DEFAULT '0',
  `NewbieTogged` int(11) NOT NULL DEFAULT '0',
  `VIPTogged` int(11) NOT NULL DEFAULT '0',
  `FamedTogged` int(11) NOT NULL DEFAULT '0',
  `pDigCooldown` int(11) NOT NULL DEFAULT '0',
  `ToolBox` int(11) NOT NULL DEFAULT '0',
  `CrowBar` int(11) NOT NULL DEFAULT '0',
  `CarLockPickSkill` int(11) NOT NULL DEFAULT '0',
  `LockPickVehCount` int(11) NOT NULL DEFAULT '0',
  `LockPickTime` int(11) NOT NULL DEFAULT '0',
  `SEC` int(11) NOT NULL DEFAULT '0',
  `BM` int(11) NOT NULL DEFAULT '0',
  `Isolated` int(11) NOT NULL DEFAULT '0',
  `WantedJailTime` int(11) NOT NULL DEFAULT '0',
  `WantedJailFine` int(11) NOT NULL DEFAULT '0',
  `NextNameChange` int(11) NOT NULL DEFAULT '0',
  `pExamineDesc` varchar(256) NOT NULL DEFAULT 'None',
  `FavStation` varchar(255) NOT NULL DEFAULT '',
  `pDedicatedPlayer` int(11) NOT NULL DEFAULT '0',
  `pDedicatedEnabled` int(11) NOT NULL DEFAULT '0',
  `pDedicatedMuted` int(11) NOT NULL DEFAULT '0',
  `pDedicatedWarn` int(11) NOT NULL DEFAULT '0',
  `BItem11` int(11) NOT NULL DEFAULT '0',
  `mInventory` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `mPurchaseCounts` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `mCooldowns` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `mBoost` varchar(255) NOT NULL DEFAULT '0|0',
  `mShopNotice` varchar(255) NOT NULL DEFAULT '0|0',
  `zFuelCan` int(11) NOT NULL DEFAULT '0',
  `bTicket` int(11) NOT NULL DEFAULT '0',
  `JailedInfo` varchar(255) NOT NULL DEFAULT '0|0|0|0|0',
  `JailedWeapons` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0',
  `pVIPMod` int(11) NOT NULL DEFAULT '0',
  `EmailConfirmed` int(11) NOT NULL DEFAULT '0',
  `EmailCount` int(11) NOT NULL DEFAULT '0',
  `Trickortreat` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `userid` (`id`) USING BTREE,
  KEY `username` (`Username`) USING BTREE,
  KEY `admin` (`AdminLevel`) USING BTREE,
  KEY `disabled` (`Disabled`) USING BTREE,
  KEY `group` (`Member`) USING BTREE,
  KEY `phone` (`PhoneNr`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1000519030 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for anticheat
-- ----------------------------
DROP TABLE IF EXISTS `anticheat`;
CREATE TABLE `anticheat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` int(11) NOT NULL,
  `microtime` int(11) NOT NULL,
  `damagedid` int(11) NOT NULL,
  `damagedlastupdate` int(11) NOT NULL,
  `damagedping` int(11) NOT NULL,
  `giverid` int(11) NOT NULL,
  `giverping` int(11) NOT NULL,
  `amount` float(10,5) NOT NULL,
  `weaponid` tinyint(3) NOT NULL,
  `damagedX` float(10,5) NOT NULL,
  `damagedY` float(10,5) NOT NULL,
  `damagedZ` float(10,5) NOT NULL,
  `giverX` float(10,5) NOT NULL,
  `giverY` float(10,5) NOT NULL,
  `giverZ` float(10,5) NOT NULL,
  `giverCX` float(10,5) NOT NULL,
  `giverCY` float(10,5) NOT NULL,
  `giverCZ` float(10,5) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5437 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for app_admins
-- ----------------------------
DROP TABLE IF EXISTS `app_admins`;
CREATE TABLE `app_admins` (
  `id` int(254) NOT NULL AUTO_INCREMENT,
  `adminName` varchar(254) DEFAULT NULL,
  `status` varchar(10) DEFAULT '1',
  `lastMsg` varchar(254) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for app_todo
-- ----------------------------
DROP TABLE IF EXISTS `app_todo`;
CREATE TABLE `app_todo` (
  `id` int(254) NOT NULL AUTO_INCREMENT,
  `adminName` varchar(254) DEFAULT NULL,
  `todo` varchar(999) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for arenas
-- ----------------------------
DROP TABLE IF EXISTS `arenas`;
CREATE TABLE `arenas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT 'Name',
  `vw` int(11) NOT NULL DEFAULT '0',
  `interior` int(11) NOT NULL DEFAULT '0',
  `dm1` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `dm2` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `dm3` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `dm4` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `red1` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `red2` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `red3` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `blue1` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `blue2` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `blue3` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `flagred` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0',
  `flagblue` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0',
  `hill` varchar(128) NOT NULL DEFAULT '0.0|0.0|0.0',
  `hillr` float(11,4) NOT NULL DEFAULT '0.0000',
  `veh1` varchar(128) NOT NULL DEFAULT '0|0.0|0.0|0.0|0.0',
  `veh2` varchar(128) NOT NULL DEFAULT '0|0.0|0.0|0.0|0.0',
  `veh3` varchar(128) NOT NULL DEFAULT '0|0.0|0.0|0.0|0.0',
  `veh4` varchar(128) NOT NULL DEFAULT '0|0.0|0.0|0.0|0.0',
  `veh5` varchar(128) NOT NULL DEFAULT '0|0.0|0.0|0.0|0.0',
  `veh6` varchar(128) NOT NULL DEFAULT '0|0.0|0.0|0.0|0.0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for arrestpoints
-- ----------------------------
DROP TABLE IF EXISTS `arrestpoints`;
CREATE TABLE `arrestpoints` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `VW` int(5) NOT NULL DEFAULT '0',
  `Int` int(5) NOT NULL DEFAULT '0',
  `Type` int(1) NOT NULL DEFAULT '0',
  `jailVW` int(5) NOT NULL DEFAULT '0',
  `jailInt` int(5) NOT NULL DEFAULT '0',
  `jailpos1x` float(10,5) NOT NULL DEFAULT '0.00000',
  `jailpos1y` float(10,5) NOT NULL DEFAULT '0.00000',
  `jailpos1z` float(10,5) NOT NULL DEFAULT '0.00000',
  `jailpos2x` float(10,5) NOT NULL DEFAULT '0.00000',
  `jailpos2y` float(10,5) NOT NULL DEFAULT '0.00000',
  `jailpos2z` float(10,5) NOT NULL DEFAULT '0.00000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for arrestreports
-- ----------------------------
DROP TABLE IF EXISTS `arrestreports`;
CREATE TABLE `arrestreports` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `copid` int(12) NOT NULL DEFAULT '0',
  `suspectid` int(12) NOT NULL DEFAULT '0',
  `shortreport` varchar(512) NOT NULL DEFAULT '',
  `longreport` varchar(2024) NOT NULL DEFAULT '',
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `origin` int(11) NOT NULL DEFAULT '1' COMMENT 'SA=1 | TR=2',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `issuer` (`copid`) USING BTREE,
  KEY `suspect` (`suspectid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43356 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for auctions
-- ----------------------------
DROP TABLE IF EXISTS `auctions`;
CREATE TABLE `auctions` (
  `id` int(11) NOT NULL,
  `BiddingFor` varchar(64) NOT NULL DEFAULT '(none)',
  `InProgress` int(11) NOT NULL DEFAULT '0',
  `Bid` int(11) NOT NULL DEFAULT '0',
  `Bidder` int(11) NOT NULL DEFAULT '0',
  `Expires` int(11) NOT NULL DEFAULT '0',
  `Wining` varchar(24) NOT NULL DEFAULT '(none)',
  `Increment` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for bans
-- ----------------------------
DROP TABLE IF EXISTS `bans`;
CREATE TABLE `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `ip_address` varchar(32) DEFAULT NULL,
  `reason` varchar(156) DEFAULT NULL,
  `date_added` datetime DEFAULT NULL,
  `date_unban` datetime DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `link` varchar(156) DEFAULT NULL,
  `admin` varchar(156) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82420 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for bugComments
-- ----------------------------
DROP TABLE IF EXISTS `bugComments`;
CREATE TABLE `bugComments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bugid` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `comment` text NOT NULL,
  `ip` varchar(255) NOT NULL,
  `time` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3804 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for bugs
-- ----------------------------
DROP TABLE IF EXISTS `bugs`;
CREATE TABLE `bugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ReportedBy` varchar(255) DEFAULT NULL,
  `Time` int(255) DEFAULT NULL,
  `Bug` varchar(46) DEFAULT NULL,
  `AssignedTo` varchar(255) NOT NULL DEFAULT 'Nobody',
  `Status` int(11) DEFAULT '0',
  `Description` text,
  `Deleted` int(1) NOT NULL DEFAULT '0',
  `Anonymous` int(1) NOT NULL DEFAULT '0',
  `Tech` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1780 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for businesses
-- ----------------------------
DROP TABLE IF EXISTS `businesses`;
CREATE TABLE `businesses` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(40) NOT NULL DEFAULT 'Unnamed Business',
  `Type` int(11) NOT NULL DEFAULT '0',
  `Value` int(11) NOT NULL DEFAULT '0',
  `OwnerID` int(11) NOT NULL DEFAULT '0',
  `OwnerName` varchar(40) NOT NULL DEFAULT 'None',
  `Months` int(11) NOT NULL DEFAULT '0',
  `SafeBalance` int(11) NOT NULL DEFAULT '0',
  `Inventory` int(11) NOT NULL DEFAULT '0',
  `InventoryCapacity` int(11) NOT NULL DEFAULT '1000',
  `Status` int(11) NOT NULL DEFAULT '1',
  `Level` tinyint(4) NOT NULL DEFAULT '1',
  `LevelProgress` int(11) NOT NULL DEFAULT '0',
  `AutoSale` tinyint(4) NOT NULL DEFAULT '1',
  `OrderDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `OrderAmount` int(11) NOT NULL DEFAULT '0',
  `OrderBy` varchar(24) NOT NULL DEFAULT '',
  `OrderState` int(11) NOT NULL DEFAULT '0',
  `TotalSales` int(11) NOT NULL DEFAULT '0',
  `Bargain` tinyint(4) NOT NULL DEFAULT '0',
  `ExteriorX` float NOT NULL DEFAULT '0',
  `ExteriorY` float NOT NULL DEFAULT '0',
  `ExteriorZ` float NOT NULL DEFAULT '0',
  `ExteriorA` float NOT NULL DEFAULT '0',
  `InteriorX` float NOT NULL DEFAULT '0',
  `InteriorY` float NOT NULL DEFAULT '0',
  `InteriorZ` float NOT NULL DEFAULT '0',
  `InteriorA` float NOT NULL DEFAULT '0',
  `Interior` tinyint(4) NOT NULL DEFAULT '0',
  `CustomExterior` int(11) NOT NULL DEFAULT '0',
  `CustomInterior` int(11) NOT NULL DEFAULT '0',
  `SupplyPointX` float NOT NULL DEFAULT '0',
  `SupplyPointY` float NOT NULL DEFAULT '0',
  `SupplyPointZ` float NOT NULL DEFAULT '0',
  `Item1Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item2Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item3Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item4Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item5Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item6Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item7Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item8Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item9Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item10Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item11Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item12Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item13Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item14Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item15Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item16Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item17Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item18Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Item19Price` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank0Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank1Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank2Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank3Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank4Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank5Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Pay` tinyint(4) NOT NULL DEFAULT '0',
  `GasPrice` float unsigned NOT NULL DEFAULT '0',
  `MinInviteRank` tinyint(4) NOT NULL DEFAULT '4',
  `MinSupplyRank` tinyint(4) NOT NULL DEFAULT '5',
  `MinGiveRankRank` tinyint(4) NOT NULL DEFAULT '5',
  `MinSafeRank` tinyint(4) NOT NULL DEFAULT '5',
  `GasPump1PosX` float NOT NULL DEFAULT '0',
  `GasPump1PosY` float NOT NULL DEFAULT '0',
  `GasPump1PosZ` float NOT NULL DEFAULT '0',
  `GasPump1Angle` float NOT NULL DEFAULT '0',
  `GasPump1Model` float NOT NULL DEFAULT '0',
  `GasPump1Capacity` float NOT NULL DEFAULT '0',
  `GasPump1Gas` float NOT NULL DEFAULT '0',
  `GasPump2PosX` float NOT NULL DEFAULT '0',
  `GasPump2PosY` float NOT NULL DEFAULT '0',
  `GasPump2PosZ` float NOT NULL DEFAULT '0',
  `GasPump2Angle` float NOT NULL DEFAULT '0',
  `GasPump2Model` float NOT NULL DEFAULT '0',
  `GasPump2Capacity` float NOT NULL DEFAULT '0',
  `GasPump2Gas` float NOT NULL DEFAULT '0',
  `Car0PosX` float NOT NULL DEFAULT '0',
  `Car0PosY` float NOT NULL DEFAULT '0',
  `Car0PosZ` float NOT NULL DEFAULT '0',
  `Car0PosAngle` float NOT NULL DEFAULT '0',
  `Car0ModelId` int(11) NOT NULL DEFAULT '0',
  `Car0Price` int(11) NOT NULL DEFAULT '0',
  `Car1PosX` float NOT NULL DEFAULT '0',
  `Car1PosY` float NOT NULL DEFAULT '0',
  `Car1PosZ` float NOT NULL DEFAULT '0',
  `Car1PosAngle` float NOT NULL DEFAULT '0',
  `Car1ModelId` int(11) NOT NULL DEFAULT '0',
  `Car1Price` int(11) NOT NULL DEFAULT '0',
  `Car2PosX` float NOT NULL DEFAULT '0',
  `Car2PosY` float NOT NULL DEFAULT '0',
  `Car2PosZ` float NOT NULL DEFAULT '0',
  `Car2PosAngle` float NOT NULL DEFAULT '0',
  `Car2ModelId` int(11) NOT NULL DEFAULT '0',
  `Car2Price` int(11) NOT NULL DEFAULT '0',
  `Car3PosX` float NOT NULL DEFAULT '0',
  `Car3PosY` float NOT NULL DEFAULT '0',
  `Car3PosZ` float NOT NULL DEFAULT '0',
  `Car3PosAngle` float NOT NULL DEFAULT '0',
  `Car3ModelId` int(11) NOT NULL DEFAULT '0',
  `Car3Price` int(11) NOT NULL DEFAULT '0',
  `Car1Stock` int(11) NOT NULL DEFAULT '0',
  `Car2Stock` int(11) NOT NULL DEFAULT '0',
  `Car3Stock` int(11) NOT NULL DEFAULT '0',
  `Car1Order` int(11) NOT NULL DEFAULT '0',
  `Car2Order` int(11) NOT NULL DEFAULT '0',
  `Car3Order` int(11) NOT NULL DEFAULT '0',
  `Car4PosX` float NOT NULL DEFAULT '0',
  `Car4PosY` float NOT NULL DEFAULT '0',
  `Car4PosZ` float NOT NULL DEFAULT '0',
  `Car4PosAngle` float NOT NULL DEFAULT '0',
  `Car4ModelId` int(11) NOT NULL DEFAULT '0',
  `Car4Price` int(11) NOT NULL DEFAULT '0',
  `Car5PosX` int(11) NOT NULL DEFAULT '0',
  `Car5PosY` float NOT NULL DEFAULT '0',
  `Car5PosZ` float NOT NULL DEFAULT '0',
  `Car5PosAngle` float NOT NULL DEFAULT '0',
  `Car5ModelId` int(11) NOT NULL DEFAULT '0',
  `Car5Price` int(11) NOT NULL DEFAULT '0',
  `Car6PosX` float NOT NULL DEFAULT '0',
  `Car6PosY` float NOT NULL DEFAULT '0',
  `Car6PosZ` float NOT NULL DEFAULT '0',
  `Car6PosAngle` float NOT NULL DEFAULT '0',
  `Car6ModelId` int(11) NOT NULL DEFAULT '0',
  `Car6Price` int(11) NOT NULL DEFAULT '0',
  `Car7PosX` float NOT NULL DEFAULT '0',
  `Car7PosY` float NOT NULL DEFAULT '0',
  `Car7PosZ` float NOT NULL DEFAULT '0',
  `Car7PosAngle` float NOT NULL DEFAULT '0',
  `Car7ModelId` int(11) NOT NULL DEFAULT '0',
  `Car7Price` int(11) NOT NULL DEFAULT '0',
  `Car8PosX` float NOT NULL DEFAULT '0',
  `Car8PosY` float NOT NULL DEFAULT '0',
  `Car8PosZ` float NOT NULL DEFAULT '0',
  `Car8PosAngle` float NOT NULL DEFAULT '0',
  `Car8ModelId` int(11) NOT NULL DEFAULT '0',
  `Car8Price` int(11) NOT NULL DEFAULT '0',
  `Car9PosX` float NOT NULL DEFAULT '0',
  `Car9PosY` float NOT NULL DEFAULT '0',
  `Car9PosZ` float NOT NULL DEFAULT '0',
  `Car9PosAngle` float NOT NULL DEFAULT '0',
  `Car9ModelId` int(11) NOT NULL DEFAULT '0',
  `Car9Price` int(11) NOT NULL DEFAULT '0',
  `PurchaseX` float NOT NULL DEFAULT '0',
  `PurchaseY` float NOT NULL DEFAULT '0',
  `PurchaseZ` float NOT NULL DEFAULT '0',
  `PurchaseAngle` float NOT NULL DEFAULT '0',
  `TotalProfits` int(11) NOT NULL DEFAULT '0',
  `GymEntryFee` int(11) NOT NULL DEFAULT '0',
  `GymType` int(11) NOT NULL DEFAULT '0',
  `CustomVW` int(11) NOT NULL DEFAULT '0',
  `Grade` int(11) NOT NULL DEFAULT '0',
  `MaxLevel` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for businesssales
-- ----------------------------
DROP TABLE IF EXISTS `businesssales`;
CREATE TABLE `businesssales` (
  `bID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `BusinessID` int(11) unsigned NOT NULL DEFAULT '0',
  `Text` varchar(128) DEFAULT '0',
  `Price` int(11) DEFAULT '0',
  `Available` int(11) NOT NULL DEFAULT '0',
  `Purchased` int(11) DEFAULT '0',
  `Type` int(11) DEFAULT '0',
  PRIMARY KEY (`bID`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for countrysec
-- ----------------------------
DROP TABLE IF EXISTS `countrysec`;
CREATE TABLE `countrysec` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT '0',
  `code` varchar(2) DEFAULT NULL,
  `code2` varchar(2) DEFAULT NULL,
  `region` varchar(2) DEFAULT NULL,
  `optout` int(11) DEFAULT '0',
  `code2exp` int(11) DEFAULT NULL,
  `regenabled` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  UNIQUE KEY `userid` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27088 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_access
-- ----------------------------
DROP TABLE IF EXISTS `cp_access`;
CREATE TABLE `cp_access` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `punish` int(1) NOT NULL DEFAULT '0',
  `refund` int(1) NOT NULL DEFAULT '0',
  `ban` int(1) NOT NULL DEFAULT '0',
  `tech` int(1) NOT NULL DEFAULT '0',
  `cplgeneral` int(1) NOT NULL DEFAULT '0',
  `cplstaff` int(1) NOT NULL DEFAULT '0',
  `cplfaction` int(1) NOT NULL DEFAULT '0',
  `cplfamily` int(1) NOT NULL DEFAULT '0',
  `cplcr` int(1) NOT NULL DEFAULT '0',
  `cplaccess` int(1) NOT NULL DEFAULT '0',
  `gladmin` int(1) NOT NULL DEFAULT '0',
  `gladminauction` int(1) NOT NULL DEFAULT '0',
  `gladmingive` int(1) NOT NULL DEFAULT '0',
  `gladminpay` int(1) NOT NULL DEFAULT '0',
  `glauction` int(1) NOT NULL DEFAULT '0',
  `glban` int(1) NOT NULL DEFAULT '0',
  `glbedit` int(1) NOT NULL DEFAULT '0',
  `glbusiness` int(1) NOT NULL DEFAULT '0',
  `glcontracts` int(1) NOT NULL DEFAULT '0',
  `glcrime` int(1) NOT NULL DEFAULT '0',
  `glddedit` int(1) NOT NULL DEFAULT '0',
  `gldealership` int(1) NOT NULL DEFAULT '0',
  `gldmpedit` int(1) NOT NULL DEFAULT '0',
  `gldv` int(1) NOT NULL DEFAULT '0',
  `gldvspawn` int(1) NOT NULL DEFAULT '0',
  `gleditgroup` int(1) NOT NULL DEFAULT '0',
  `glfaction` int(1) NOT NULL DEFAULT '0',
  `glfamily` int(1) NOT NULL DEFAULT '0',
  `glflagmove` int(1) NOT NULL DEFAULT '0',
  `glflags` int(1) NOT NULL DEFAULT '0',
  `glfmembercount` int(1) NOT NULL DEFAULT '0',
  `glgedit` int(1) NOT NULL DEFAULT '0',
  `glgifts` int(1) NOT NULL DEFAULT '0',
  `glgov` int(1) NOT NULL DEFAULT '0',
  `glgroup` int(1) NOT NULL DEFAULT '0',
  `glhack` int(1) NOT NULL DEFAULT '0',
  `glhedit` int(1) NOT NULL DEFAULT '0',
  `glhouse` int(1) NOT NULL DEFAULT '0',
  `glhsafe` int(1) NOT NULL DEFAULT '0',
  `glkick` int(1) NOT NULL DEFAULT '0',
  `gllicenses` int(1) NOT NULL DEFAULT '0',
  `glmail` int(1) NOT NULL DEFAULT '0',
  `glmoderator` int(1) NOT NULL DEFAULT '0',
  `glmute` int(1) NOT NULL DEFAULT '0',
  `glpads` int(1) NOT NULL DEFAULT '0',
  `glpassword` int(1) NOT NULL DEFAULT '0',
  `glpay` int(1) NOT NULL DEFAULT '0',
  `glplant` int(1) NOT NULL DEFAULT '0',
  `glplayervehicle` int(1) NOT NULL DEFAULT '0',
  `glpnsedit` int(1) NOT NULL DEFAULT '0',
  `glpoker` int(1) NOT NULL DEFAULT '0',
  `glrpspecial` int(1) NOT NULL DEFAULT '0',
  `glsecurity` int(1) NOT NULL DEFAULT '0',
  `glsetvip` int(1) NOT NULL DEFAULT '0',
  `glshopconfirmedorders` int(1) NOT NULL DEFAULT '0',
  `glshoplog` int(1) NOT NULL DEFAULT '0',
  `glshoporders` int(1) NOT NULL DEFAULT '0',
  `glsobeit` int(1) NOT NULL DEFAULT '0',
  `glspeedcam` int(1) NOT NULL DEFAULT '0',
  `glstats` int(1) NOT NULL DEFAULT '0',
  `gltledit` int(1) NOT NULL DEFAULT '0',
  `gltoydelete` int(1) NOT NULL DEFAULT '0',
  `gltoys` int(1) NOT NULL DEFAULT '0',
  `glundercover` int(1) NOT NULL DEFAULT '0',
  `glvipnamechanges` int(1) NOT NULL DEFAULT '0',
  `glvipremove` int(1) NOT NULL DEFAULT '0',
  `glsellcredits` int(1) NOT NULL DEFAULT '0',
  `gllogincredits` int(1) NOT NULL DEFAULT '0',
  `glcleo` int(1) NOT NULL DEFAULT '0',
  `glcredits` int(1) NOT NULL DEFAULT '0',
  `glbackpack` int(11) DEFAULT '0',
  `glvoucher` int(11) DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_admin_notes
-- ----------------------------
DROP TABLE IF EXISTS `cp_admin_notes`;
CREATE TABLE `cp_admin_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` int(1) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `invoke_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `points` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2646 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_cache_email
-- ----------------------------
DROP TABLE IF EXISTS `cp_cache_email`;
CREATE TABLE `cp_cache_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) DEFAULT NULL,
  `email_address` varchar(255) DEFAULT NULL,
  `token` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_cache_passreset
-- ----------------------------
DROP TABLE IF EXISTS `cp_cache_passreset`;
CREATE TABLE `cp_cache_passreset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(128) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_cache_sec_questions
-- ----------------------------
DROP TABLE IF EXISTS `cp_cache_sec_questions`;
CREATE TABLE `cp_cache_sec_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `answer` varchar(128) NOT NULL,
  `token` varchar(128) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2636 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_faction
-- ----------------------------
DROP TABLE IF EXISTS `cp_faction`;
CREATE TABLE `cp_faction` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(64) DEFAULT NULL,
  `rank_0` varchar(64) DEFAULT NULL,
  `rank_1` varchar(64) DEFAULT NULL,
  `rank_2` varchar(64) DEFAULT NULL,
  `rank_3` varchar(64) DEFAULT NULL,
  `rank_4` varchar(64) DEFAULT NULL,
  `rank_5` varchar(64) DEFAULT NULL,
  `rank_6` varchar(64) DEFAULT NULL,
  `div_0` varchar(64) DEFAULT NULL,
  `div_1` varchar(64) DEFAULT NULL,
  `div_2` varchar(64) DEFAULT NULL,
  `div_3` varchar(64) DEFAULT NULL,
  `div_4` varchar(64) DEFAULT NULL,
  `div_5` varchar(64) DEFAULT NULL,
  `div_6` varchar(64) DEFAULT NULL,
  `div_7` varchar(64) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_family
-- ----------------------------
DROP TABLE IF EXISTS `cp_family`;
CREATE TABLE `cp_family` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(64) DEFAULT NULL,
  `leader` int(11) DEFAULT NULL,
  `rank_1` varchar(64) DEFAULT NULL,
  `rank_2` varchar(64) DEFAULT NULL,
  `rank_3` varchar(64) DEFAULT NULL,
  `rank_4` varchar(64) DEFAULT NULL,
  `rank_5` varchar(64) DEFAULT NULL,
  `rank_6` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_info_states
-- ----------------------------
DROP TABLE IF EXISTS `cp_info_states`;
CREATE TABLE `cp_info_states` (
  `state_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK: Unique state ID',
  `state_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT 'State name with first letter capital',
  `state_abbr` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Optional state abbreviation (US is 2 capital letters)',
  PRIMARY KEY (`state_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for cp_info_temp
-- ----------------------------
DROP TABLE IF EXISTS `cp_info_temp`;
CREATE TABLE `cp_info_temp` (
  `order_id` varchar(12) NOT NULL,
  `player_id` varchar(200) DEFAULT NULL,
  `first_name` varchar(120) DEFAULT NULL,
  `last_name` varchar(120) DEFAULT NULL,
  `billing_address` varchar(120) DEFAULT NULL,
  `country` varchar(120) DEFAULT NULL,
  `state` varchar(120) DEFAULT NULL,
  `city` varchar(120) DEFAULT NULL,
  `zip_code` varchar(120) DEFAULT NULL,
  `gift_player` varchar(200) DEFAULT NULL,
  `purchasetype` varchar(120) DEFAULT NULL,
  `method` varchar(120) DEFAULT NULL,
  `date_added` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_leave
-- ----------------------------
DROP TABLE IF EXISTS `cp_leave`;
CREATE TABLE `cp_leave` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `date_leave` date DEFAULT NULL,
  `date_return` date DEFAULT NULL,
  `reason` varchar(1024) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `acceptedby_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1040 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_log_access
-- ----------------------------
DROP TABLE IF EXISTS `cp_log_access`;
CREATE TABLE `cp_log_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92965 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_log_cr
-- ----------------------------
DROP TABLE IF EXISTS `cp_log_cr`;
CREATE TABLE `cp_log_cr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10768 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_log_faction
-- ----------------------------
DROP TABLE IF EXISTS `cp_log_faction`;
CREATE TABLE `cp_log_faction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57739 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_log_family
-- ----------------------------
DROP TABLE IF EXISTS `cp_log_family`;
CREATE TABLE `cp_log_family` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21630 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_log_general
-- ----------------------------
DROP TABLE IF EXISTS `cp_log_general`;
CREATE TABLE `cp_log_general` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=446569 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_log_security
-- ----------------------------
DROP TABLE IF EXISTS `cp_log_security`;
CREATE TABLE `cp_log_security` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=327422 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_log_staff
-- ----------------------------
DROP TABLE IF EXISTS `cp_log_staff`;
CREATE TABLE `cp_log_staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=444766 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_mass_email
-- ----------------------------
DROP TABLE IF EXISTS `cp_mass_email`;
CREATE TABLE `cp_mass_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) DEFAULT NULL,
  `message` varchar(25565) DEFAULT NULL,
  `creator` int(11) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_sent` datetime DEFAULT NULL,
  `banned` int(1) NOT NULL DEFAULT '0',
  `disabled` int(1) NOT NULL DEFAULT '0',
  `admins` varchar(255) NOT NULL DEFAULT '0',
  `helpers` varchar(255) NOT NULL DEFAULT '0',
  `vip` varchar(255) NOT NULL DEFAULT '0',
  `famed` varchar(255) NOT NULL DEFAULT '0',
  `faction` varchar(255) NOT NULL DEFAULT '0',
  `faction_rank` varchar(255) NOT NULL DEFAULT '0',
  `gang` varchar(255) NOT NULL DEFAULT '0',
  `gang_rank` varchar(255) NOT NULL DEFAULT '0',
  `biz` varchar(255) NOT NULL DEFAULT '0',
  `biz_rank` varchar(255) NOT NULL DEFAULT '0',
  `bypass` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_misc
-- ----------------------------
DROP TABLE IF EXISTS `cp_misc`;
CREATE TABLE `cp_misc` (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `from` varchar(128) NOT NULL,
  `message` varchar(128) DEFAULT NULL,
  `status` int(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_punishment
-- ----------------------------
DROP TABLE IF EXISTS `cp_punishment`;
CREATE TABLE `cp_punishment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) DEFAULT NULL,
  `date_added` date DEFAULT NULL,
  `addedby_id` int(11) DEFAULT NULL,
  `reason` varchar(1024) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `prison` int(11) DEFAULT NULL,
  `warn` int(1) DEFAULT NULL,
  `fine` int(11) DEFAULT NULL,
  `ban` int(1) DEFAULT NULL,
  `wep_restrict` int(11) DEFAULT NULL,
  `other_punish` varchar(1024) DEFAULT NULL,
  `link` varchar(1024) DEFAULT NULL,
  `date_issued` date DEFAULT NULL,
  `issuedby_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26847 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_refund
-- ----------------------------
DROP TABLE IF EXISTS `cp_refund`;
CREATE TABLE `cp_refund` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `money` int(10) DEFAULT '0',
  `materials` int(10) DEFAULT '0',
  `pot` int(10) DEFAULT '0',
  `crack` int(10) DEFAULT '0',
  `boombox` int(10) DEFAULT '0',
  `viptoken` int(10) DEFAULT '0',
  `refund` varchar(512) DEFAULT NULL,
  `link` varchar(256) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `auth` varchar(256) DEFAULT NULL,
  `addedby_id` int(11) DEFAULT NULL,
  `date_added` date DEFAULT NULL,
  `issuedby_id` int(1) DEFAULT NULL,
  `date_issued` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4892 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_restricted_archive
-- ----------------------------
DROP TABLE IF EXISTS `cp_restricted_archive`;
CREATE TABLE `cp_restricted_archive` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) DEFAULT NULL,
  `removed_by` int(12) DEFAULT NULL,
  `removed_date` datetime DEFAULT NULL,
  `reason` varchar(524) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_security_files
-- ----------------------------
DROP TABLE IF EXISTS `cp_security_files`;
CREATE TABLE `cp_security_files` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) NOT NULL,
  `uploader_id` int(12) NOT NULL,
  `file_name` varchar(524) NOT NULL,
  `file_type` varchar(524) NOT NULL,
  `file_size` varchar(524) NOT NULL,
  `file_location` varchar(524) NOT NULL,
  `file_description` varchar(524) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=321 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_security_notes
-- ----------------------------
DROP TABLE IF EXISTS `cp_security_notes`;
CREATE TABLE `cp_security_notes` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) NOT NULL,
  `note_by` int(12) NOT NULL,
  `note` varchar(524) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_security_profiles
-- ----------------------------
DROP TABLE IF EXISTS `cp_security_profiles`;
CREATE TABLE `cp_security_profiles` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) NOT NULL,
  `forum_name` varchar(524) NOT NULL,
  `teamspeak_name` varchar(524) NOT NULL,
  `recommending_admin` varchar(524) NOT NULL,
  `rp_names` varchar(524) NOT NULL,
  `email_addresses` varchar(524) NOT NULL,
  `messenger_handles` varchar(524) NOT NULL,
  `security_orientation` date NOT NULL,
  `security_profile` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=313 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_shift_blocks
-- ----------------------------
DROP TABLE IF EXISTS `cp_shift_blocks`;
CREATE TABLE `cp_shift_blocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shift_id` int(11) NOT NULL,
  `shift` varchar(3) DEFAULT NULL,
  `time_start` time DEFAULT NULL,
  `time_end` time DEFAULT NULL,
  `needs_sunday` int(11) DEFAULT '1',
  `needs_monday` int(11) DEFAULT '1',
  `needs_tuesday` int(11) DEFAULT '1',
  `needs_wednesday` int(11) DEFAULT '1',
  `needs_thursday` int(11) DEFAULT '1',
  `needs_friday` int(11) DEFAULT '1',
  `needs_saturday` int(11) DEFAULT '1',
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_shift_leader
-- ----------------------------
DROP TABLE IF EXISTS `cp_shift_leader`;
CREATE TABLE `cp_shift_leader` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `shift_id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1720 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_shifts
-- ----------------------------
DROP TABLE IF EXISTS `cp_shifts`;
CREATE TABLE `cp_shifts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` int(1) DEFAULT NULL,
  `shift_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `sign_up` datetime DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `bonus` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`user_id`) USING BTREE,
  KEY `shiftid` (`shift_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=153214 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_stat
-- ----------------------------
DROP TABLE IF EXISTS `cp_stat`;
CREATE TABLE `cp_stat` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL,
  `timezone` varchar(128) NOT NULL DEFAULT 'NULL',
  `gtalk` varchar(124) DEFAULT 'N/A',
  `paypal` varchar(128) DEFAULT NULL,
  `points` int(11) DEFAULT '0',
  `shift` int(11) DEFAULT '0',
  `shift_day` varchar(255) DEFAULT NULL,
  `shift_restrict` varchar(255) DEFAULT NULL,
  `shift_complete` int(11) DEFAULT '0',
  `shift_partcomplete` int(11) DEFAULT '0',
  `shift_missed` int(11) DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_store_cart
-- ----------------------------
DROP TABLE IF EXISTS `cp_store_cart`;
CREATE TABLE `cp_store_cart` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `cart_id` int(12) NOT NULL,
  `customer_id` int(12) NOT NULL,
  `customer_ip_address` varchar(32) NOT NULL,
  `cart_pack_id` varchar(32) NOT NULL,
  `date_item_added` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2781 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_store_manage
-- ----------------------------
DROP TABLE IF EXISTS `cp_store_manage`;
CREATE TABLE `cp_store_manage` (
  `id` int(12) NOT NULL,
  `pack_id` int(12) NOT NULL,
  `pack_picture` varchar(120) NOT NULL DEFAULT '',
  `total_tokens` varchar(12) NOT NULL,
  `old_price` varchar(12) DEFAULT NULL,
  `total_price` varchar(12) NOT NULL,
  `additional_tokens` varchar(12) DEFAULT NULL,
  `store_online` varchar(12) NOT NULL DEFAULT 'OFF',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_store_orders
-- ----------------------------
DROP TABLE IF EXISTS `cp_store_orders`;
CREATE TABLE `cp_store_orders` (
  `id` int(24) NOT NULL AUTO_INCREMENT,
  `order_id` int(12) DEFAULT NULL,
  `order_status` varchar(60) DEFAULT NULL,
  `customer_id` int(12) DEFAULT NULL,
  `customer_ip_address` varchar(60) DEFAULT NULL,
  `pack_id` int(12) DEFAULT NULL,
  `pack_total_tokens` varchar(12) DEFAULT NULL,
  `pack_total_price` varchar(12) DEFAULT NULL,
  `gift_player_id` varchar(24) DEFAULT NULL,
  `payment_method` varchar(12) DEFAULT NULL,
  `payment_address` varchar(150) DEFAULT NULL,
  `date_purchased` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1106 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_support_faq
-- ----------------------------
DROP TABLE IF EXISTS `cp_support_faq`;
CREATE TABLE `cp_support_faq` (
  `faq_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` int(12) NOT NULL DEFAULT '0',
  `isenabled` int(1) unsigned NOT NULL DEFAULT '1',
  `question` varchar(125) NOT NULL DEFAULT '',
  `answer` varchar(500) NOT NULL,
  `created` varchar(150) NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` varchar(150) NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`faq_id`),
  UNIQUE KEY `title_2` (`question`) USING BTREE,
  KEY `dept_id` (`category`) USING BTREE,
  KEY `active` (`isenabled`) USING BTREE,
  FULLTEXT KEY `title` (`question`,`answer`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_support_faq_category
-- ----------------------------
DROP TABLE IF EXISTS `cp_support_faq_category`;
CREATE TABLE `cp_support_faq_category` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `category` varchar(250) DEFAULT NULL,
  `sub_category` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_support_items
-- ----------------------------
DROP TABLE IF EXISTS `cp_support_items`;
CREATE TABLE `cp_support_items` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `sort_id` int(6) NOT NULL,
  `item_category` varchar(32) NOT NULL,
  `item_name` varchar(32) NOT NULL,
  `item_picture` varchar(150) NOT NULL DEFAULT '',
  `item_credit_price` varchar(12) NOT NULL,
  `item_description` varchar(5000) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_support_tickets
-- ----------------------------
DROP TABLE IF EXISTS `cp_support_tickets`;
CREATE TABLE `cp_support_tickets` (
  `ticket_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticketID` varchar(12) DEFAULT NULL,
  `area` varchar(150) NOT NULL DEFAULT '2',
  `priority` varchar(12) NOT NULL DEFAULT 'Normal',
  `p_id` int(20) unsigned NOT NULL DEFAULT '0',
  `email` varchar(150) NOT NULL DEFAULT '',
  `subject` varchar(150) NOT NULL DEFAULT '[no subject]',
  `ip_address` varchar(40) NOT NULL DEFAULT '',
  `status` varchar(24) NOT NULL DEFAULT 'open',
  `isoverdue` int(1) unsigned NOT NULL DEFAULT '0',
  `isanswered` int(1) unsigned NOT NULL DEFAULT '0',
  `duedate` varchar(150) DEFAULT NULL,
  `reopened` varchar(150) DEFAULT NULL,
  `closed` varchar(150) DEFAULT NULL,
  `lastmessage` varchar(150) DEFAULT NULL,
  `lastresponse` varchar(150) DEFAULT NULL,
  `created` varchar(150) NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` varchar(150) NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ticket_id`),
  UNIQUE KEY `email_extid` (`ticketID`,`email`) USING BTREE,
  KEY `staff_id` (`p_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `priority_id` (`area`) USING BTREE,
  KEY `created` (`created`) USING BTREE,
  KEY `closed` (`closed`) USING BTREE,
  KEY `duedate` (`duedate`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=136 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_support_tickets_response
-- ----------------------------
DROP TABLE IF EXISTS `cp_support_tickets_response`;
CREATE TABLE `cp_support_tickets_response` (
  `response_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `p_id` int(20) unsigned NOT NULL DEFAULT '0',
  `form` int(11) unsigned NOT NULL DEFAULT '0',
  `staff` int(11) unsigned NOT NULL DEFAULT '0',
  `response` varchar(1000) NOT NULL,
  `ip_address` varchar(40) NOT NULL DEFAULT '',
  `created` varchar(150) NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` varchar(150) NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`response_id`),
  KEY `ticket_id` (`ticket_id`) USING BTREE,
  KEY `staff_id` (`p_id`) USING BTREE,
  FULLTEXT KEY `response` (`response`)
) ENGINE=MyISAM AUTO_INCREMENT=286 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_api_key
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_api_key`;
CREATE TABLE `cp_tickets_api_key` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `isactive` tinyint(1) NOT NULL DEFAULT '1',
  `ipaddr` varchar(64) NOT NULL,
  `apikey` varchar(255) NOT NULL,
  `can_create_tickets` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `can_exec_cron` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `notes` text,
  `updated` datetime NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `apikey` (`apikey`) USING BTREE,
  KEY `ipaddr` (`ipaddr`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_attachment
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_attachment`;
CREATE TABLE `cp_tickets_attachment` (
  `object_id` int(11) unsigned NOT NULL,
  `type` char(1) NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  `inline` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`,`file_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_canned_response
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_canned_response`;
CREATE TABLE `cp_tickets_canned_response` (
  `canned_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dept_id` int(10) unsigned NOT NULL DEFAULT '0',
  `isenabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `title` varchar(255) NOT NULL DEFAULT '',
  `response` text NOT NULL,
  `lang` varchar(16) NOT NULL DEFAULT 'en_US',
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`canned_id`),
  UNIQUE KEY `title` (`title`) USING BTREE,
  KEY `dept_id` (`dept_id`) USING BTREE,
  KEY `active` (`isenabled`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_config
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_config`;
CREATE TABLE `cp_tickets_config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `namespace` varchar(64) NOT NULL,
  `key` varchar(64) NOT NULL,
  `value` text NOT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `namespace` (`namespace`,`key`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_content
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_content`;
CREATE TABLE `cp_tickets_content` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `content_id` int(10) unsigned NOT NULL DEFAULT '0',
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `type` varchar(32) NOT NULL DEFAULT 'other',
  `name` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `lang` varchar(16) NOT NULL DEFAULT 'en_US',
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_department
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_department`;
CREATE TABLE `cp_tickets_department` (
  `dept_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tpl_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sla_id` int(10) unsigned NOT NULL DEFAULT '0',
  `email_id` int(10) unsigned NOT NULL DEFAULT '0',
  `autoresp_email_id` int(10) unsigned NOT NULL DEFAULT '0',
  `manager_id` int(10) unsigned NOT NULL DEFAULT '0',
  `dept_name` varchar(128) NOT NULL DEFAULT '',
  `dept_signature` text NOT NULL,
  `ispublic` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `group_membership` tinyint(1) NOT NULL DEFAULT '0',
  `ticket_auto_response` tinyint(1) NOT NULL DEFAULT '1',
  `message_auto_response` tinyint(1) NOT NULL DEFAULT '0',
  `updated` datetime NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`dept_id`),
  UNIQUE KEY `dept_name` (`dept_name`) USING BTREE,
  KEY `manager_id` (`manager_id`) USING BTREE,
  KEY `autoresp_email_id` (`autoresp_email_id`) USING BTREE,
  KEY `tpl_id` (`tpl_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_draft
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_draft`;
CREATE TABLE `cp_tickets_draft` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) unsigned NOT NULL,
  `namespace` varchar(32) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `extra` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_email
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_email`;
CREATE TABLE `cp_tickets_email` (
  `email_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `noautoresp` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `priority_id` tinyint(3) unsigned NOT NULL DEFAULT '2',
  `dept_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `topic_id` int(11) unsigned NOT NULL DEFAULT '0',
  `email` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `userid` varchar(255) NOT NULL,
  `userpass` varchar(255) CHARACTER SET ascii NOT NULL,
  `mail_active` tinyint(1) NOT NULL DEFAULT '0',
  `mail_host` varchar(255) NOT NULL,
  `mail_protocol` enum('POP','IMAP') NOT NULL DEFAULT 'POP',
  `mail_encryption` enum('NONE','SSL') NOT NULL,
  `mail_port` int(6) DEFAULT NULL,
  `mail_fetchfreq` tinyint(3) NOT NULL DEFAULT '5',
  `mail_fetchmax` tinyint(4) NOT NULL DEFAULT '30',
  `mail_archivefolder` varchar(255) DEFAULT NULL,
  `mail_delete` tinyint(1) NOT NULL DEFAULT '0',
  `mail_errors` tinyint(3) NOT NULL DEFAULT '0',
  `mail_lasterror` datetime DEFAULT NULL,
  `mail_lastfetch` datetime DEFAULT NULL,
  `smtp_active` tinyint(1) DEFAULT '0',
  `smtp_host` varchar(255) NOT NULL,
  `smtp_port` int(6) DEFAULT NULL,
  `smtp_secure` tinyint(1) NOT NULL DEFAULT '1',
  `smtp_auth` tinyint(1) NOT NULL DEFAULT '1',
  `smtp_spoofing` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`email_id`),
  UNIQUE KEY `email` (`email`) USING BTREE,
  KEY `priority_id` (`priority_id`) USING BTREE,
  KEY `dept_id` (`dept_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_email_account
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_email_account`;
CREATE TABLE `cp_tickets_email_account` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `protocol` varchar(64) NOT NULL DEFAULT '',
  `host` varchar(128) NOT NULL DEFAULT '',
  `port` int(11) NOT NULL,
  `username` varchar(128) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `options` varchar(512) DEFAULT NULL,
  `errors` int(11) unsigned DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `lastconnect` timestamp NULL DEFAULT NULL,
  `lasterror` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_email_template
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_email_template`;
CREATE TABLE `cp_tickets_email_template` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tpl_id` int(11) unsigned NOT NULL,
  `code_name` varchar(32) NOT NULL,
  `subject` varchar(255) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `template_lookup` (`tpl_id`,`code_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_email_template_group
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_email_template_group`;
CREATE TABLE `cp_tickets_email_template_group` (
  `tpl_id` int(11) NOT NULL AUTO_INCREMENT,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `name` varchar(32) NOT NULL DEFAULT '',
  `lang` varchar(16) NOT NULL DEFAULT 'en_US',
  `notes` text,
  `created` datetime NOT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tpl_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_faq
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_faq`;
CREATE TABLE `cp_tickets_faq` (
  `faq_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned NOT NULL DEFAULT '0',
  `ispublished` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `question` varchar(255) NOT NULL,
  `answer` text NOT NULL,
  `keywords` tinytext,
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`faq_id`),
  UNIQUE KEY `question` (`question`) USING BTREE,
  KEY `category_id` (`category_id`) USING BTREE,
  KEY `ispublished` (`ispublished`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_faq_category
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_faq_category`;
CREATE TABLE `cp_tickets_faq_category` (
  `category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ispublic` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `name` varchar(125) DEFAULT NULL,
  `description` text NOT NULL,
  `notes` tinytext NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`category_id`),
  KEY `ispublic` (`ispublic`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_faq_topic
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_faq_topic`;
CREATE TABLE `cp_tickets_faq_topic` (
  `faq_id` int(10) unsigned NOT NULL,
  `topic_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`faq_id`,`topic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_file
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_file`;
CREATE TABLE `cp_tickets_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ft` char(1) NOT NULL DEFAULT 'T',
  `bk` char(1) NOT NULL DEFAULT 'D',
  `type` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  `size` bigint(20) unsigned NOT NULL DEFAULT '0',
  `key` varchar(86) CHARACTER SET ascii NOT NULL,
  `signature` varchar(86) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `attrs` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ft` (`ft`) USING BTREE,
  KEY `key` (`key`) USING BTREE,
  KEY `signature` (`signature`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_file_chunk
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_file_chunk`;
CREATE TABLE `cp_tickets_file_chunk` (
  `file_id` int(11) NOT NULL,
  `chunk_id` int(11) NOT NULL,
  `filedata` longblob NOT NULL,
  PRIMARY KEY (`file_id`,`chunk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_filter
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_filter`;
CREATE TABLE `cp_tickets_filter` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `execorder` int(10) unsigned NOT NULL DEFAULT '99',
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `status` int(11) unsigned NOT NULL DEFAULT '0',
  `match_all_rules` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `stop_onmatch` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `reject_ticket` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `use_replyto_email` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `disable_autoresponder` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `canned_response_id` int(11) unsigned NOT NULL DEFAULT '0',
  `email_id` int(10) unsigned NOT NULL DEFAULT '0',
  `priority_id` int(10) unsigned NOT NULL DEFAULT '0',
  `dept_id` int(10) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(10) unsigned NOT NULL DEFAULT '0',
  `team_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sla_id` int(10) unsigned NOT NULL DEFAULT '0',
  `form_id` int(11) unsigned NOT NULL DEFAULT '0',
  `topic_id` int(11) unsigned NOT NULL DEFAULT '0',
  `ext_id` varchar(11) DEFAULT NULL,
  `target` enum('Any','Web','Email','API') NOT NULL DEFAULT 'Any',
  `name` varchar(32) NOT NULL DEFAULT '',
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `target` (`target`) USING BTREE,
  KEY `email_id` (`email_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_filter_rule
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_filter_rule`;
CREATE TABLE `cp_tickets_filter_rule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `filter_id` int(10) unsigned NOT NULL DEFAULT '0',
  `what` varchar(32) NOT NULL,
  `how` enum('equal','not_equal','contains','dn_contain','starts','ends','match','not_match') NOT NULL,
  `val` varchar(255) NOT NULL,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `notes` tinytext NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `filter` (`filter_id`,`what`,`how`,`val`) USING BTREE,
  KEY `filter_id` (`filter_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_form
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_form`;
CREATE TABLE `cp_tickets_form` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(8) NOT NULL DEFAULT 'G',
  `deletable` tinyint(1) NOT NULL DEFAULT '1',
  `title` varchar(255) NOT NULL,
  `instructions` varchar(512) DEFAULT NULL,
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_form_entry
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_form_entry`;
CREATE TABLE `cp_tickets_form_entry` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(11) unsigned NOT NULL,
  `object_id` int(11) unsigned DEFAULT NULL,
  `object_type` char(1) NOT NULL DEFAULT 'T',
  `sort` int(11) unsigned NOT NULL DEFAULT '1',
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entry_lookup` (`object_type`,`object_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_form_entry_values
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_form_entry_values`;
CREATE TABLE `cp_tickets_form_entry_values` (
  `entry_id` int(11) unsigned NOT NULL,
  `field_id` int(11) unsigned NOT NULL,
  `value` text,
  `value_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`entry_id`,`field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_form_field
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_form_field`;
CREATE TABLE `cp_tickets_form_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(11) unsigned NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'text',
  `label` varchar(255) NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `private` tinyint(1) NOT NULL DEFAULT '0',
  `edit_mask` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL,
  `configuration` text,
  `sort` int(11) unsigned NOT NULL,
  `hint` varchar(512) DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_group_dept_access
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_group_dept_access`;
CREATE TABLE `cp_tickets_group_dept_access` (
  `group_id` int(10) unsigned NOT NULL DEFAULT '0',
  `dept_id` int(10) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `group_dept` (`group_id`,`dept_id`) USING BTREE,
  KEY `dept_id` (`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_groups
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_groups`;
CREATE TABLE `cp_tickets_groups` (
  `group_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `group_name` varchar(50) NOT NULL DEFAULT '',
  `can_create_tickets` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `can_edit_tickets` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `can_post_ticket_reply` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `can_delete_tickets` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `can_close_tickets` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `can_assign_tickets` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `can_transfer_tickets` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `can_ban_emails` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `can_manage_premade` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `can_manage_faq` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `can_view_staff_stats` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`group_id`),
  KEY `group_active` (`group_enabled`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_help_topic
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_help_topic`;
CREATE TABLE `cp_tickets_help_topic` (
  `topic_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `topic_pid` int(10) unsigned NOT NULL DEFAULT '0',
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `ispublic` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `noautoresp` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `priority_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dept_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(10) unsigned NOT NULL DEFAULT '0',
  `team_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sla_id` int(10) unsigned NOT NULL DEFAULT '0',
  `page_id` int(10) unsigned NOT NULL DEFAULT '0',
  `form_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sort` int(10) unsigned NOT NULL DEFAULT '0',
  `topic` varchar(32) NOT NULL DEFAULT '',
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`topic_id`),
  UNIQUE KEY `topic` (`topic`,`topic_pid`) USING BTREE,
  KEY `topic_pid` (`topic_pid`) USING BTREE,
  KEY `priority_id` (`priority_id`) USING BTREE,
  KEY `dept_id` (`dept_id`) USING BTREE,
  KEY `staff_id` (`staff_id`,`team_id`) USING BTREE,
  KEY `sla_id` (`sla_id`) USING BTREE,
  KEY `page_id` (`page_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_input_form_attributes
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_input_form_attributes`;
CREATE TABLE `cp_tickets_input_form_attributes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(11) unsigned NOT NULL,
  `attribute_name` varchar(32) DEFAULT NULL,
  `attribute_value` text,
  `unused_flag` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `form_id_2` (`form_id`,`attribute_name`) USING BTREE,
  KEY `form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_input_forms
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_input_forms`;
CREATE TABLE `cp_tickets_input_forms` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT '3' COMMENT '2 - default/non-deletable, 3 - custom',
  `identifier` varchar(32) NOT NULL,
  `title` varchar(64) DEFAULT NULL,
  `notes` text,
  `unused_flag` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_list
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_list`;
CREATE TABLE `cp_tickets_list` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `name_plural` varchar(255) DEFAULT NULL,
  `sort_mode` enum('Alpha','-Alpha','SortCol') NOT NULL DEFAULT 'Alpha',
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_list_items
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_list_items`;
CREATE TABLE `cp_tickets_list_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `list_id` int(11) DEFAULT NULL,
  `status` int(11) unsigned NOT NULL DEFAULT '1',
  `value` varchar(255) NOT NULL,
  `extra` varchar(255) DEFAULT NULL,
  `sort` int(11) NOT NULL DEFAULT '1',
  `properties` text,
  PRIMARY KEY (`id`),
  KEY `list_item_lookup` (`list_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_note
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_note`;
CREATE TABLE `cp_tickets_note` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) unsigned DEFAULT NULL,
  `staff_id` int(11) unsigned NOT NULL DEFAULT '0',
  `ext_id` varchar(10) DEFAULT NULL,
  `body` text,
  `status` int(11) unsigned NOT NULL DEFAULT '0',
  `sort` int(11) unsigned NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_organization
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_organization`;
CREATE TABLE `cp_tickets_organization` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `manager` varchar(16) NOT NULL DEFAULT '',
  `status` int(11) unsigned NOT NULL DEFAULT '0',
  `domain` varchar(256) NOT NULL DEFAULT '',
  `extra` text,
  `created` timestamp NULL DEFAULT NULL,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_plugin
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_plugin`;
CREATE TABLE `cp_tickets_plugin` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `install_path` varchar(60) NOT NULL,
  `isphar` tinyint(1) NOT NULL DEFAULT '0',
  `isactive` tinyint(1) NOT NULL DEFAULT '0',
  `version` varchar(64) DEFAULT NULL,
  `installed` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_session
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_session`;
CREATE TABLE `cp_tickets_session` (
  `session_id` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  `session_data` blob,
  `session_expire` datetime DEFAULT NULL,
  `session_updated` datetime DEFAULT NULL,
  `user_id` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT 'osT+ staff/client ID',
  `user_ip` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `user_agent` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`session_id`),
  KEY `updated` (`session_updated`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for cp_tickets_sla
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_sla`;
CREATE TABLE `cp_tickets_sla` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `enable_priority_escalation` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `disable_overdue_alerts` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `grace_period` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL DEFAULT '',
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_sla_schedules
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_sla_schedules`;
CREATE TABLE `cp_tickets_sla_schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sla_id` int(11) NOT NULL,
  `day_of_week` tinyint(3) DEFAULT NULL,
  `option` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0 - 24hrs, 1 - day off, 2 - schedule',
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sla_id_2` (`sla_id`,`day_of_week`) USING BTREE,
  KEY `sla_id` (`sla_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_staff
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_staff`;
CREATE TABLE `cp_tickets_staff` (
  `staff_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(10) unsigned NOT NULL DEFAULT '0',
  `dept_id` int(10) unsigned NOT NULL DEFAULT '0',
  `timezone_id` int(10) unsigned NOT NULL DEFAULT '0',
  `username` varchar(32) NOT NULL DEFAULT '',
  `firstname` varchar(32) DEFAULT NULL,
  `lastname` varchar(32) DEFAULT NULL,
  `passwd` varchar(128) DEFAULT NULL,
  `backend` varchar(32) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `phone` varchar(24) NOT NULL DEFAULT '',
  `phone_ext` varchar(6) DEFAULT NULL,
  `mobile` varchar(24) NOT NULL DEFAULT '',
  `signature` text NOT NULL,
  `notes` text,
  `isactive` tinyint(1) NOT NULL DEFAULT '1',
  `isadmin` tinyint(1) NOT NULL DEFAULT '0',
  `isvisible` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `onvacation` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `assigned_only` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `show_assigned_tickets` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `daylight_saving` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `change_passwd` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `max_page_size` int(11) unsigned NOT NULL DEFAULT '0',
  `auto_refresh_rate` int(10) unsigned NOT NULL DEFAULT '0',
  `default_signature_type` enum('none','mine','dept') NOT NULL DEFAULT 'none',
  `default_paper_size` enum('Letter','Legal','Ledger','A4','A3') NOT NULL DEFAULT 'Letter',
  `created` datetime NOT NULL,
  `lastlogin` datetime DEFAULT NULL,
  `passwdreset` datetime DEFAULT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `username` (`username`) USING BTREE,
  KEY `dept_id` (`dept_id`) USING BTREE,
  KEY `issuperuser` (`isadmin`) USING BTREE,
  KEY `group_id` (`group_id`,`staff_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_syslog
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_syslog`;
CREATE TABLE `cp_tickets_syslog` (
  `log_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `log_type` enum('Debug','Warning','Error') NOT NULL,
  `title` varchar(255) NOT NULL,
  `log` text NOT NULL,
  `logger` varchar(64) NOT NULL,
  `ip_address` varchar(64) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `log_type` (`log_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_team
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_team`;
CREATE TABLE `cp_tickets_team` (
  `team_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(10) unsigned NOT NULL DEFAULT '0',
  `isenabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `noalerts` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `name` varchar(125) NOT NULL DEFAULT '',
  `notes` text,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`team_id`),
  UNIQUE KEY `name` (`name`) USING BTREE,
  KEY `isnabled` (`isenabled`) USING BTREE,
  KEY `lead_id` (`lead_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_team_member
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_team_member`;
CREATE TABLE `cp_tickets_team_member` (
  `team_id` int(10) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(10) unsigned NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`team_id`,`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_ticket
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_ticket`;
CREATE TABLE `cp_tickets_ticket` (
  `ticket_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `number` varchar(20) DEFAULT NULL,
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `user_email_id` int(11) unsigned NOT NULL DEFAULT '0',
  `dept_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sla_id` int(10) unsigned NOT NULL DEFAULT '0',
  `topic_id` int(10) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(10) unsigned NOT NULL DEFAULT '0',
  `team_id` int(10) unsigned NOT NULL DEFAULT '0',
  `email_id` int(11) unsigned NOT NULL DEFAULT '0',
  `ip_address` varchar(64) NOT NULL DEFAULT '',
  `status` enum('open','closed') NOT NULL DEFAULT 'open',
  `source` enum('Web','Email','Phone','API','Other') NOT NULL DEFAULT 'Other',
  `isoverdue` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `isanswered` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `duedate` datetime DEFAULT NULL,
  `reopened` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  `lastmessage` datetime DEFAULT NULL,
  `lastresponse` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`ticket_id`),
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `dept_id` (`dept_id`) USING BTREE,
  KEY `staff_id` (`staff_id`) USING BTREE,
  KEY `team_id` (`staff_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `created` (`created`) USING BTREE,
  KEY `closed` (`closed`) USING BTREE,
  KEY `duedate` (`duedate`) USING BTREE,
  KEY `topic_id` (`topic_id`) USING BTREE,
  KEY `sla_id` (`sla_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_ticket__cdata
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_ticket__cdata`;
CREATE TABLE `cp_tickets_ticket__cdata` (
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `subject` mediumtext,
  `priority` mediumtext,
  `priority_id` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_ticket_attachment
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_ticket_attachment`;
CREATE TABLE `cp_tickets_ticket_attachment` (
  `attach_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `file_id` int(10) unsigned NOT NULL DEFAULT '0',
  `ref_id` int(11) unsigned NOT NULL DEFAULT '0',
  `inline` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  PRIMARY KEY (`attach_id`),
  KEY `ticket_id` (`ticket_id`) USING BTREE,
  KEY `ref_id` (`ref_id`) USING BTREE,
  KEY `file_id` (`file_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_ticket_collaborator
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_ticket_collaborator`;
CREATE TABLE `cp_tickets_ticket_collaborator` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `isactive` tinyint(1) NOT NULL DEFAULT '1',
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `role` char(1) NOT NULL DEFAULT 'M',
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `collab` (`ticket_id`,`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_ticket_email_info
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_ticket_email_info`;
CREATE TABLE `cp_tickets_ticket_email_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `thread_id` int(11) unsigned NOT NULL,
  `email_mid` varchar(255) NOT NULL,
  `headers` text,
  PRIMARY KEY (`id`),
  KEY `email_mid` (`email_mid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_ticket_event
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_ticket_event`;
CREATE TABLE `cp_tickets_ticket_event` (
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(11) unsigned NOT NULL,
  `team_id` int(11) unsigned NOT NULL,
  `dept_id` int(11) unsigned NOT NULL,
  `topic_id` int(11) unsigned NOT NULL,
  `state` enum('created','closed','reopened','assigned','transferred','overdue') NOT NULL,
  `staff` varchar(255) NOT NULL DEFAULT 'SYSTEM',
  `annulled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL,
  KEY `ticket_state` (`ticket_id`,`state`,`timestamp`) USING BTREE,
  KEY `ticket_stats` (`timestamp`,`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_ticket_lock
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_ticket_lock`;
CREATE TABLE `cp_tickets_ticket_lock` (
  `lock_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(10) unsigned NOT NULL DEFAULT '0',
  `expire` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`lock_id`),
  UNIQUE KEY `ticket_id` (`ticket_id`) USING BTREE,
  KEY `staff_id` (`staff_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_ticket_priority
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_ticket_priority`;
CREATE TABLE `cp_tickets_ticket_priority` (
  `priority_id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `priority` varchar(60) NOT NULL DEFAULT '',
  `priority_desc` varchar(30) NOT NULL DEFAULT '',
  `priority_color` varchar(7) NOT NULL DEFAULT '',
  `priority_urgency` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `ispublic` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`priority_id`),
  UNIQUE KEY `priority` (`priority`) USING BTREE,
  KEY `priority_urgency` (`priority_urgency`) USING BTREE,
  KEY `ispublic` (`ispublic`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_ticket_thread
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_ticket_thread`;
CREATE TABLE `cp_tickets_ticket_thread` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) unsigned NOT NULL DEFAULT '0',
  `ticket_id` int(11) unsigned NOT NULL DEFAULT '0',
  `staff_id` int(11) unsigned NOT NULL DEFAULT '0',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `thread_type` enum('M','R','N') NOT NULL,
  `poster` varchar(128) NOT NULL DEFAULT '',
  `source` varchar(32) NOT NULL DEFAULT '',
  `title` varchar(255) DEFAULT NULL,
  `body` text NOT NULL,
  `format` varchar(16) NOT NULL DEFAULT 'html',
  `ip_address` varchar(64) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_id` (`ticket_id`) USING BTREE,
  KEY `staff_id` (`staff_id`) USING BTREE,
  KEY `pid` (`pid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_timezone
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_timezone`;
CREATE TABLE `cp_tickets_timezone` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `offset` float(3,1) NOT NULL DEFAULT '0.0',
  `timezone` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_user
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_user`;
CREATE TABLE `cp_tickets_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int(10) unsigned NOT NULL,
  `default_email_id` int(10) NOT NULL,
  `status` int(11) unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `org_id` (`org_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_user_account
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_user_account`;
CREATE TABLE `cp_tickets_user_account` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `status` int(11) unsigned NOT NULL DEFAULT '0',
  `timezone_id` int(11) NOT NULL DEFAULT '0',
  `dst` tinyint(1) NOT NULL DEFAULT '1',
  `lang` varchar(16) DEFAULT NULL,
  `username` varchar(64) DEFAULT NULL,
  `passwd` varchar(128) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `backend` varchar(32) DEFAULT NULL,
  `registered` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_tickets_user_email
-- ----------------------------
DROP TABLE IF EXISTS `cp_tickets_user_email`;
CREATE TABLE `cp_tickets_user_email` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `address` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `address` (`address`) USING BTREE,
  KEY `user_email_lookup` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cp_weekly_reports
-- ----------------------------
DROP TABLE IF EXISTS `cp_weekly_reports`;
CREATE TABLE `cp_weekly_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `q1` varchar(512) DEFAULT NULL,
  `q2` varchar(512) DEFAULT NULL,
  `q3` varchar(512) DEFAULT NULL,
  `q4` varchar(512) DEFAULT NULL,
  `q5` varchar(512) DEFAULT NULL,
  `status` int(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cp_whitelist
-- ----------------------------
DROP TABLE IF EXISTS `cp_whitelist`;
CREATE TABLE `cp_whitelist` (
  `id` int(11) NOT NULL,
  `username` varchar(25) NOT NULL,
  `key` varchar(128) NOT NULL,
  `ip` varchar(15) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for crates
-- ----------------------------
DROP TABLE IF EXISTS `crates`;
CREATE TABLE `crates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Active` int(11) NOT NULL DEFAULT '0',
  `CrateX` float NOT NULL DEFAULT '0',
  `CrateY` float NOT NULL DEFAULT '0',
  `CrateZ` float NOT NULL DEFAULT '0',
  `GunQuantity` int(11) NOT NULL DEFAULT '50',
  `InVehicle` int(11) NOT NULL DEFAULT '0',
  `Int` int(11) NOT NULL DEFAULT '0',
  `VW` int(11) NOT NULL DEFAULT '0',
  `PlacedBy` varchar(24) NOT NULL DEFAULT 'Unknown',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for crimesdata
-- ----------------------------
DROP TABLE IF EXISTS `crimesdata`;
CREATE TABLE `crimesdata` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `type` int(2) DEFAULT '1',
  `nation` int(2) DEFAULT '1',
  `name` varchar(32) DEFAULT 'N/A',
  `jailtime` int(6) DEFAULT '1',
  `fine` int(8) DEFAULT '1',
  `bail` int(8) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for ddoors
-- ----------------------------
DROP TABLE IF EXISTS `ddoors`;
CREATE TABLE `ddoors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(128) NOT NULL DEFAULT 'None',
  `Owner` int(11) NOT NULL DEFAULT '-1',
  `OwnerName` varchar(256) NOT NULL DEFAULT 'Nobody',
  `CustomInterior` int(11) NOT NULL DEFAULT '0',
  `ExteriorVW` int(11) NOT NULL DEFAULT '0',
  `ExteriorInt` int(11) NOT NULL DEFAULT '0',
  `InteriorVW` int(11) NOT NULL DEFAULT '0',
  `InteriorInt` int(11) NOT NULL DEFAULT '0',
  `ExteriorX` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExteriorY` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExteriorZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExteriorA` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorX` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorY` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorA` float(10,5) NOT NULL DEFAULT '0.00000',
  `CustomExterior` int(11) NOT NULL DEFAULT '0',
  `Type` int(1) NOT NULL DEFAULT '0',
  `Rank` int(1) NOT NULL DEFAULT '-1',
  `VIP` int(11) NOT NULL DEFAULT '0',
  `DPC` int(11) NOT NULL DEFAULT '0',
  `Allegiance` int(11) NOT NULL DEFAULT '0',
  `GroupType` int(11) NOT NULL DEFAULT '0',
  `Family` int(11) NOT NULL DEFAULT '0',
  `Faction` int(11) NOT NULL DEFAULT '-1',
  `Admin` int(11) NOT NULL DEFAULT '0',
  `Wanted` int(11) NOT NULL DEFAULT '0',
  `VehicleAble` int(11) NOT NULL DEFAULT '0',
  `Color` int(11) NOT NULL DEFAULT '0',
  `PickupModel` int(11) NOT NULL DEFAULT '0',
  `Pass` varchar(24) NOT NULL DEFAULT 'pass',
  `Locked` int(11) NOT NULL DEFAULT '0',
  `Famed` int(11) NOT NULL DEFAULT '0',
  `LastLogin` int(11) NOT NULL DEFAULT '0',
  `Expire` int(11) NOT NULL DEFAULT '0',
  `Inactive` int(11) NOT NULL DEFAULT '0',
  `Ignore` int(11) NOT NULL DEFAULT '0',
  `Counter` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3001 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dedi_april
-- ----------------------------
DROP TABLE IF EXISTS `dedi_april`;
CREATE TABLE `dedi_april` (
  `id` int(11) NOT NULL DEFAULT '0',
  `Username` varchar(255) DEFAULT NULL,
  `RewardHours` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for devcpBans
-- ----------------------------
DROP TABLE IF EXISTS `devcpBans`;
CREATE TABLE `devcpBans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `anon` int(1) NOT NULL DEFAULT '0',
  `bugs` int(1) NOT NULL DEFAULT '0',
  `updated` int(34) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for devcpLogs
-- ----------------------------
DROP TABLE IF EXISTS `devcpLogs`;
CREATE TABLE `devcpLogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `log` text NOT NULL,
  `type` varchar(255) NOT NULL,
  `time` int(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `bugid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=17049 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for dm_watchdog
-- ----------------------------
DROP TABLE IF EXISTS `dm_watchdog`;
CREATE TABLE `dm_watchdog` (
  `id` int(11) NOT NULL DEFAULT '0',
  `reporter` int(11) NOT NULL DEFAULT '0',
  `timestamp` int(11) NOT NULL DEFAULT '0',
  `superwatch` tinyint(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dmap
-- ----------------------------
DROP TABLE IF EXISTS `dmap`;
CREATE TABLE `dmap` (
  `PlayerID` int(11) NOT NULL DEFAULT '-1',
  `Username` varchar(255) NOT NULL DEFAULT '',
  `PosX` float(11,0) DEFAULT NULL,
  `PosY` float(11,0) DEFAULT NULL,
  `PosZ` float(11,0) DEFAULT NULL,
  `VehID` int(3) DEFAULT NULL,
  `VehModel` int(3) DEFAULT NULL,
  PRIMARY KEY (`PlayerID`,`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dmapicons
-- ----------------------------
DROP TABLE IF EXISTS `dmapicons`;
CREATE TABLE `dmapicons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `MarkerType` int(11) NOT NULL DEFAULT '0',
  `Color` int(11) NOT NULL DEFAULT '0',
  `VW` int(11) NOT NULL DEFAULT '0',
  `Int` int(11) NOT NULL DEFAULT '0',
  `PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for event_hungergames-2013-10
-- ----------------------------
DROP TABLE IF EXISTS `event_hungergames-2013-10`;
CREATE TABLE `event_hungergames-2013-10` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=94523 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for events
-- ----------------------------
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for FallIntoFun
-- ----------------------------
DROP TABLE IF EXISTS `FallIntoFun`;
CREATE TABLE `FallIntoFun` (
  `player` int(50) NOT NULL DEFAULT '0',
  `FIFHours` int(30) DEFAULT '0',
  `FIFChances` int(30) DEFAULT '0',
  PRIMARY KEY (`player`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for families
-- ----------------------------
DROP TABLE IF EXISTS `families`;
CREATE TABLE `families` (
  `ID` tinyint(1) NOT NULL AUTO_INCREMENT,
  `Taken` tinyint(1) NOT NULL DEFAULT '0',
  `Name` varchar(40) NOT NULL DEFAULT 'None',
  `MOTD1` varchar(128) NOT NULL DEFAULT 'None',
  `Leader` varchar(24) NOT NULL DEFAULT 'None',
  `Bank` int(11) NOT NULL DEFAULT '0',
  `Cash` int(11) NOT NULL DEFAULT '0',
  `FamilyUSafe` int(11) NOT NULL DEFAULT '0',
  `FamilySafeX` float(11,5) NOT NULL DEFAULT '0.00000',
  `FamilySafeY` float(11,5) NOT NULL DEFAULT '0.00000',
  `FamilySafeZ` float(11,5) NOT NULL DEFAULT '0.00000',
  `FamilySafeVW` int(11) NOT NULL DEFAULT '-1',
  `FamilySafeInt` int(11) NOT NULL DEFAULT '-1',
  `Pot` int(11) NOT NULL DEFAULT '0',
  `Crack` int(11) NOT NULL DEFAULT '0',
  `Mats` int(11) NOT NULL DEFAULT '0',
  `Rank0` varchar(30) NOT NULL DEFAULT 'Newb',
  `Rank1` varchar(30) NOT NULL DEFAULT 'Outsider',
  `Rank2` varchar(30) NOT NULL DEFAULT 'Associate',
  `Rank3` varchar(30) NOT NULL DEFAULT 'Soldier',
  `Rank4` varchar(30) NOT NULL DEFAULT 'Capo',
  `Rank5` varchar(30) NOT NULL DEFAULT 'Underboss',
  `Rank6` varchar(30) NOT NULL DEFAULT 'Godfather',
  `Members` smallint(6) NOT NULL DEFAULT '0',
  `MaxSkins` tinyint(4) NOT NULL DEFAULT '0',
  `Skin1` int(11) NOT NULL DEFAULT '0',
  `Skin2` int(11) NOT NULL DEFAULT '0',
  `Skin3` int(11) NOT NULL DEFAULT '0',
  `Skin4` int(11) NOT NULL DEFAULT '0',
  `Skin5` int(11) NOT NULL DEFAULT '0',
  `Skin6` int(11) NOT NULL DEFAULT '0',
  `Skin7` int(11) NOT NULL DEFAULT '0',
  `Skin8` int(11) NOT NULL DEFAULT '0',
  `Color` int(11) NOT NULL DEFAULT '0',
  `TurfTokens` int(11) NOT NULL DEFAULT '0',
  `Gun1` tinyint(4) NOT NULL DEFAULT '0',
  `Gun2` tinyint(4) NOT NULL DEFAULT '0',
  `Gun3` tinyint(4) NOT NULL DEFAULT '0',
  `Gun4` tinyint(4) NOT NULL DEFAULT '0',
  `Gun5` tinyint(4) NOT NULL DEFAULT '0',
  `Gun6` tinyint(4) NOT NULL DEFAULT '0',
  `Gun7` tinyint(4) NOT NULL DEFAULT '0',
  `Gun8` tinyint(4) NOT NULL DEFAULT '0',
  `Gun9` tinyint(4) NOT NULL DEFAULT '0',
  `Gun10` tinyint(4) NOT NULL DEFAULT '0',
  `ExteriorX` float(11,5) NOT NULL DEFAULT '0.00000',
  `ExteriorY` float(11,5) NOT NULL DEFAULT '0.00000',
  `ExteriorZ` float(11,5) NOT NULL DEFAULT '0.00000',
  `ExteriorA` float(11,5) NOT NULL DEFAULT '0.00000',
  `InteriorX` float(11,5) NOT NULL DEFAULT '0.00000',
  `InteriorY` float(11,5) NOT NULL DEFAULT '0.00000',
  `InteriorZ` float(11,5) NOT NULL DEFAULT '0.00000',
  `InteriorA` float(11,5) NOT NULL DEFAULT '0.00000',
  `VW` int(11) NOT NULL DEFAULT '0',
  `INT` int(11) NOT NULL DEFAULT '0',
  `CustomInterior` int(11) NOT NULL DEFAULT '0',
  `Division0` varchar(16) NOT NULL DEFAULT 'None',
  `Division1` varchar(16) NOT NULL DEFAULT 'None',
  `Division2` varchar(16) NOT NULL DEFAULT 'None',
  `Division3` varchar(16) NOT NULL DEFAULT 'None',
  `Division4` varchar(16) NOT NULL DEFAULT 'None',
  `Heroin` int(11) NOT NULL DEFAULT '0',
  `GtObject` int(11) NOT NULL DEFAULT '1490',
  `MOTD2` varchar(128) NOT NULL DEFAULT '0',
  `MOTD3` varchar(128) NOT NULL DEFAULT '0',
  `fontface` varchar(32) NOT NULL DEFAULT 'Arial',
  `fontsize` int(11) NOT NULL DEFAULT '24',
  `bold` int(11) NOT NULL DEFAULT '0',
  `fontcolor` int(32) NOT NULL DEFAULT '-1',
  `backcolor` int(32) NOT NULL DEFAULT '0',
  `text` varchar(32) NOT NULL DEFAULT 'Preview',
  `gtUsed` int(11) NOT NULL DEFAULT '0',
  `FamColor` mediumint(8) unsigned NOT NULL DEFAULT '130303',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for flags
-- ----------------------------
DROP TABLE IF EXISTS `flags`;
CREATE TABLE `flags` (
  `fid` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `time` datetime NOT NULL,
  `issuer` varchar(24) NOT NULL,
  `flag` varchar(128) NOT NULL,
  `type` int(11) NOT NULL DEFAULT '1' COMMENT '1 = Regular | 2 = Admin',
  PRIMARY KEY (`fid`),
  UNIQUE KEY `id` (`fid`) USING BTREE,
  KEY `userid` (`id`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=71889 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for gangtags
-- ----------------------------
DROP TABLE IF EXISTS `gangtags`;
CREATE TABLE `gangtags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `posx` float(11,4) NOT NULL DEFAULT '0.0000',
  `posy` float(11,4) NOT NULL DEFAULT '0.0000',
  `posz` float(11,4) NOT NULL DEFAULT '0.0000',
  `posrx` float(11,4) NOT NULL DEFAULT '0.0000',
  `posry` float(11,4) NOT NULL DEFAULT '0.0000',
  `posrz` float(11,4) NOT NULL DEFAULT '0.0000',
  `objectid` int(11) NOT NULL DEFAULT '1490',
  `vw` int(11) NOT NULL DEFAULT '0',
  `interior` int(11) NOT NULL DEFAULT '0',
  `family` int(11) NOT NULL DEFAULT '255',
  `used` int(11) NOT NULL DEFAULT '0',
  `time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for garages
-- ----------------------------
DROP TABLE IF EXISTS `garages`;
CREATE TABLE `garages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Owner` int(11) NOT NULL DEFAULT '-1',
  `OwnerName` varchar(24) NOT NULL DEFAULT 'Nobody',
  `ExteriorX` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExteriorY` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExteriorZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExteriorA` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExteriorVW` int(11) NOT NULL DEFAULT '0',
  `ExteriorInt` int(11) NOT NULL DEFAULT '0',
  `CustomExterior` int(11) NOT NULL DEFAULT '0',
  `InteriorX` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorY` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorA` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorVW` int(11) NOT NULL DEFAULT '0',
  `Pass` varchar(24) NOT NULL DEFAULT 'pass',
  `Locked` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3000 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for gates
-- ----------------------------
DROP TABLE IF EXISTS `gates`;
CREATE TABLE `gates` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `HID` int(11) NOT NULL DEFAULT '-1',
  `Speed` float NOT NULL DEFAULT '10',
  `Range` float NOT NULL DEFAULT '10',
  `Model` int(11) NOT NULL DEFAULT '18631',
  `VW` int(11) NOT NULL DEFAULT '0',
  `Int` int(11) NOT NULL DEFAULT '0',
  `Pass` varchar(24) NOT NULL DEFAULT '',
  `PosX` float NOT NULL DEFAULT '0',
  `PosY` float NOT NULL DEFAULT '0',
  `PosZ` float NOT NULL DEFAULT '0',
  `RotX` float NOT NULL DEFAULT '0',
  `RotY` float NOT NULL DEFAULT '0',
  `RotZ` float NOT NULL DEFAULT '0',
  `PosXM` float NOT NULL DEFAULT '0',
  `PosYM` float NOT NULL DEFAULT '0',
  `PosZM` float NOT NULL DEFAULT '0',
  `RotXM` float NOT NULL DEFAULT '0',
  `RotYM` float NOT NULL DEFAULT '0',
  `RotZM` float NOT NULL DEFAULT '0',
  `Allegiance` int(11) NOT NULL DEFAULT '0',
  `GroupType` int(11) NOT NULL DEFAULT '0',
  `GroupID` int(2) NOT NULL DEFAULT '-1',
  `FamilyID` int(2) NOT NULL DEFAULT '-1',
  `RenderHQ` int(11) NOT NULL DEFAULT '1',
  `Timer` int(1) NOT NULL DEFAULT '0',
  `Automate` int(1) NOT NULL DEFAULT '0',
  `Locked` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `id` (`ID`) USING BTREE,
  KEY `houseid` (`HID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4001 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for giftbox
-- ----------------------------
DROP TABLE IF EXISTS `giftbox`;
CREATE TABLE `giftbox` (
  `dgMoney0` int(11) DEFAULT '0',
  `dgRimKit0` int(11) DEFAULT '0',
  `dgFirework0` int(11) DEFAULT '0',
  `dgGVIP0` int(11) DEFAULT '0',
  `dgGVIPEx0` int(11) DEFAULT '0',
  `dgSVIP0` int(11) DEFAULT '0',
  `dgSVIPEx0` int(11) DEFAULT '0',
  `dgCarSlot0` int(11) DEFAULT '0',
  `dgToySlot0` int(11) DEFAULT '0',
  `dgArmor0` int(11) DEFAULT '0',
  `dgFirstaid0` int(11) DEFAULT '0',
  `dgDDFlag0` int(11) DEFAULT '0',
  `dgGateFlag0` int(11) DEFAULT '0',
  `dgCredits0` int(11) DEFAULT '0',
  `dgPriorityAd0` int(11) DEFAULT '0',
  `dgHealthNArmor0` int(11) DEFAULT '0',
  `dgRespectPoint0` int(11) DEFAULT '0',
  `dgCarVoucher0` int(11) DEFAULT '0',
  `dgBuddyInvite0` int(11) DEFAULT '0',
  `dgLaser0` int(11) DEFAULT '0',
  `dgCustomToy0` int(11) DEFAULT '0',
  `dgAdmuteReset0` int(11) DEFAULT '0',
  `dgNewbieMuteReset0` int(11) DEFAULT '0',
  `dgRestrictedCarVoucher0` int(11) DEFAULT '0',
  `dgPlatinumVIPVoucher0` int(11) DEFAULT '0',
  `dgGiftReset0` int(11) DEFAULT '0',
  `dgMaterial0` int(11) DEFAULT '0',
  `dgWarning0` int(11) DEFAULT '0',
  `dgPot0` int(11) DEFAULT '0',
  `dgCrack0` int(11) DEFAULT '0',
  `dgPaintballToken0` int(11) DEFAULT '0',
  `dgVIPToken0` int(11) DEFAULT '0',
  `dgMoney1` int(11) DEFAULT '0',
  `dgRimKit1` int(11) DEFAULT '0',
  `dgFirework1` int(11) DEFAULT '0',
  `dgGVIP1` int(11) DEFAULT '0',
  `dgGVIPEx1` int(11) DEFAULT '0',
  `dgSVIP1` int(11) DEFAULT '0',
  `dgSVIPEx1` int(11) DEFAULT '0',
  `dgCarSlot1` int(11) DEFAULT '0',
  `dgToySlot1` int(11) DEFAULT '0',
  `dgArmor1` int(11) DEFAULT '0',
  `dgFirstaid1` int(11) DEFAULT '0',
  `dgDDFlag1` int(11) DEFAULT '0',
  `dgGateFlag1` int(11) DEFAULT '0',
  `dgCredits1` int(11) DEFAULT '0',
  `dgPriorityAd1` int(11) DEFAULT '0',
  `dgHealthNArmor1` int(11) DEFAULT '0',
  `dgRespectPoint1` int(11) DEFAULT '0',
  `dgCarVoucher1` int(11) DEFAULT '0',
  `dgBuddyInvite1` int(11) DEFAULT '0',
  `dgLaser1` int(11) DEFAULT '0',
  `dgCustomToy1` int(11) DEFAULT '0',
  `dgAdmuteReset1` int(11) DEFAULT '0',
  `dgNewbieMuteReset1` int(11) DEFAULT '0',
  `dgRestrictedCarVoucher1` int(11) DEFAULT '0',
  `dgPlatinumVIPVoucher1` int(11) DEFAULT '0',
  `dgGiftReset1` int(11) DEFAULT '0',
  `dgMaterial1` int(11) DEFAULT '0',
  `dgWarning1` int(11) DEFAULT '0',
  `dgPot1` int(11) DEFAULT '0',
  `dgCrack1` int(11) DEFAULT '0',
  `dgPaintballToken1` int(11) DEFAULT '0',
  `dgVIPToken1` int(11) DEFAULT '0',
  `dgMoney2` int(11) DEFAULT '0',
  `dgRimKit2` int(11) DEFAULT '0',
  `dgFirework2` int(11) DEFAULT '0',
  `dgGVIP2` int(11) DEFAULT '0',
  `dgGVIPEx2` int(11) DEFAULT '0',
  `dgSVIP2` int(11) DEFAULT '0',
  `dgSVIPEx2` int(11) DEFAULT '0',
  `dgCarSlot2` int(11) DEFAULT '0',
  `dgToySlot2` int(11) DEFAULT '0',
  `dgArmor2` int(11) DEFAULT '0',
  `dgFirstaid2` int(11) DEFAULT '0',
  `dgDDFlag2` int(11) DEFAULT '0',
  `dgGateFlag2` int(11) DEFAULT '0',
  `dgCredits2` int(11) DEFAULT '0',
  `dgPriorityAd2` int(11) DEFAULT '0',
  `dgHealthNArmor2` int(11) DEFAULT '0',
  `dgRespectPoint2` int(11) DEFAULT '0',
  `dgCarVoucher2` int(11) DEFAULT '0',
  `dgBuddyInvite2` int(11) DEFAULT '0',
  `dgLaser2` int(11) DEFAULT '0',
  `dgCustomToy2` int(11) DEFAULT '0',
  `dgAdmuteReset2` int(11) DEFAULT '0',
  `dgNewbieMuteReset2` int(11) DEFAULT '0',
  `dgRestrictedCarVoucher2` int(11) DEFAULT '0',
  `dgPlatinumVIPVoucher2` int(11) DEFAULT '0',
  `dgGiftReset2` int(11) DEFAULT '0',
  `dgMaterial2` int(11) DEFAULT '0',
  `dgWarning2` int(11) DEFAULT '0',
  `dgPot2` int(11) DEFAULT '0',
  `dgCrack2` int(11) DEFAULT '0',
  `dgPaintballToken2` int(11) DEFAULT '0',
  `dgVIPToken2` int(11) DEFAULT '0',
  `dgMoney3` int(11) DEFAULT '0',
  `dgRimKit3` int(11) DEFAULT '0',
  `dgFirework3` int(11) DEFAULT '0',
  `dgGVIP3` int(11) DEFAULT '0',
  `dgGVIPEx3` int(11) DEFAULT '0',
  `dgSVIP3` int(11) DEFAULT '0',
  `dgSVIPEx3` int(11) DEFAULT '0',
  `dgCarSlot3` int(11) DEFAULT '0',
  `dgToySlot3` int(11) DEFAULT '0',
  `dgArmor3` int(11) DEFAULT '0',
  `dgFirstaid3` int(11) DEFAULT '0',
  `dgDDFlag3` int(11) DEFAULT '0',
  `dgGateFlag3` int(11) DEFAULT '0',
  `dgCredits3` int(11) DEFAULT '0',
  `dgPriorityAd3` int(11) DEFAULT '0',
  `dgHealthNArmor3` int(11) DEFAULT '0',
  `dgRespectPoint3` int(11) DEFAULT '0',
  `dgCarVoucher3` int(11) DEFAULT '0',
  `dgBuddyInvite3` int(11) DEFAULT '0',
  `dgLaser3` int(11) DEFAULT '0',
  `dgCustomToy3` int(11) DEFAULT '0',
  `dgAdmuteReset3` int(11) DEFAULT '0',
  `dgNewbieMuteReset3` int(11) DEFAULT '0',
  `dgRestrictedCarVoucher3` int(11) DEFAULT '0',
  `dgPlatinumVIPVoucher3` int(11) DEFAULT '0',
  `dgGiftReset3` int(11) DEFAULT '0',
  `dgMaterial3` int(11) DEFAULT '0',
  `dgWarning3` int(11) DEFAULT '0',
  `dgPot3` int(11) DEFAULT '0',
  `dgCrack3` int(11) DEFAULT '0',
  `dgPaintballToken3` int(11) DEFAULT '0',
  `dgVIPToken3` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for giftpage_dec
-- ----------------------------
DROP TABLE IF EXISTS `giftpage_dec`;
CREATE TABLE `giftpage_dec` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dID` varchar(32) NOT NULL,
  `Username` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL DEFAULT '0',
  `rToken` int(11) NOT NULL DEFAULT '0',
  `usedReset` int(11) NOT NULL DEFAULT '0',
  `plyHour` int(11) DEFAULT '0',
  `sgToken` int(11) DEFAULT '0',
  `sBeer` int(11) DEFAULT '0',
  `rBeer` int(11) DEFAULT '0',
  `rVIP` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=640 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for groupbans
-- ----------------------------
DROP TABLE IF EXISTS `groupbans`;
CREATE TABLE `groupbans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `TypeBan` int(11) NOT NULL DEFAULT '-1',
  `PlayerID` int(11) NOT NULL DEFAULT '-1',
  `BanDate` datetime NOT NULL DEFAULT '2001-01-12 00:00:00',
  `GroupBan` int(11) NOT NULL DEFAULT '-1',
  `BannedBy` varchar(24) NOT NULL DEFAULT '',
  `BanReason` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=380 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for groups
-- ----------------------------
DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Type` tinyint(4) NOT NULL DEFAULT '0',
  `Name` varchar(64) NOT NULL DEFAULT '',
  `MOTD` varchar(128) NOT NULL DEFAULT 'None',
  `MOTD2` varchar(128) NOT NULL DEFAULT 'None',
  `MOTD3` varchar(128) NOT NULL DEFAULT 'None',
  `Allegiance` tinyint(4) NOT NULL DEFAULT '0',
  `Bug` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `Radio` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `DeptRadio` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `GovAnnouncement` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `SpikeStrips` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `Barricades` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `Cones` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `Flares` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `Barrels` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `Ladders` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `FreeNameChange` tinyint(3) unsigned NOT NULL DEFAULT '255',
  `CrateIslandAccess` tinyint(4) unsigned NOT NULL DEFAULT '255',
  `DutyColour` mediumint(8) unsigned NOT NULL DEFAULT '16777215',
  `RadioColour` mediumint(8) unsigned NOT NULL DEFAULT '16777215',
  `Budget` int(11) NOT NULL DEFAULT '0',
  `BudgetPayment` int(11) NOT NULL DEFAULT '0',
  `Stock` int(11) NOT NULL DEFAULT '0',
  `LockerCostType` int(11) NOT NULL DEFAULT '2',
  `CrateX` float NOT NULL DEFAULT '0',
  `CrateY` float NOT NULL DEFAULT '0',
  `CrateZ` float NOT NULL DEFAULT '0',
  `Rank0` varchar(30) NOT NULL DEFAULT '',
  `Rank1` varchar(30) NOT NULL DEFAULT '',
  `Rank2` varchar(30) NOT NULL DEFAULT '',
  `Rank3` varchar(30) NOT NULL DEFAULT '',
  `Rank4` varchar(30) NOT NULL DEFAULT '',
  `Rank5` varchar(30) NOT NULL DEFAULT '',
  `Rank6` varchar(30) NOT NULL DEFAULT '',
  `Rank7` varchar(30) NOT NULL DEFAULT '',
  `Rank8` varchar(30) NOT NULL DEFAULT '',
  `Rank9` varchar(30) NOT NULL DEFAULT '',
  `Rank0Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank1Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank2Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank3Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank4Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank5Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank6Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank7Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank8Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank9Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Div0` varchar(30) NOT NULL DEFAULT 'None',
  `Div1` varchar(16) NOT NULL DEFAULT 'None',
  `Div2` varchar(16) NOT NULL DEFAULT 'None',
  `Div3` varchar(16) NOT NULL DEFAULT 'None',
  `Div4` varchar(16) NOT NULL DEFAULT 'None',
  `Div5` varchar(16) NOT NULL DEFAULT 'None',
  `Div6` varchar(16) NOT NULL DEFAULT 'None',
  `Div7` varchar(16) NOT NULL DEFAULT 'None',
  `Div8` varchar(16) NOT NULL DEFAULT 'None',
  `Div9` varchar(16) NOT NULL DEFAULT 'None',
  `Div10` varchar(16) NOT NULL DEFAULT 'None',
  `Gun0` tinyint(4) NOT NULL DEFAULT '0',
  `Cost0` int(11) NOT NULL DEFAULT '0',
  `Gun1` tinyint(4) NOT NULL DEFAULT '0',
  `Cost1` int(11) NOT NULL DEFAULT '0',
  `Gun2` tinyint(4) NOT NULL DEFAULT '0',
  `Cost2` int(11) NOT NULL DEFAULT '0',
  `Gun3` tinyint(4) NOT NULL DEFAULT '0',
  `Cost3` int(11) NOT NULL DEFAULT '0',
  `Gun4` tinyint(4) NOT NULL DEFAULT '0',
  `Cost4` int(11) NOT NULL DEFAULT '0',
  `Gun5` tinyint(4) NOT NULL DEFAULT '0',
  `Cost5` int(11) NOT NULL DEFAULT '0',
  `Gun6` tinyint(4) NOT NULL DEFAULT '0',
  `Cost6` int(11) NOT NULL DEFAULT '0',
  `Gun7` tinyint(4) NOT NULL DEFAULT '0',
  `Cost7` int(11) NOT NULL DEFAULT '0',
  `Gun8` tinyint(4) NOT NULL DEFAULT '0',
  `Cost8` int(11) NOT NULL DEFAULT '0',
  `Gun9` tinyint(4) NOT NULL DEFAULT '0',
  `Cost9` int(11) NOT NULL DEFAULT '0',
  `Gun10` tinyint(4) NOT NULL DEFAULT '0',
  `Cost10` int(11) NOT NULL DEFAULT '0',
  `Gun11` tinyint(4) NOT NULL DEFAULT '0',
  `Cost11` int(11) NOT NULL DEFAULT '0',
  `Gun12` tinyint(4) NOT NULL DEFAULT '0',
  `Cost12` int(11) NOT NULL DEFAULT '0',
  `Gun13` tinyint(4) NOT NULL DEFAULT '0',
  `Cost13` int(11) NOT NULL DEFAULT '0',
  `Gun14` tinyint(4) NOT NULL DEFAULT '0',
  `Cost14` int(11) NOT NULL DEFAULT '0',
  `Gun15` tinyint(4) NOT NULL DEFAULT '0',
  `Cost15` int(11) NOT NULL DEFAULT '0',
  `Gun16` int(11) NOT NULL DEFAULT '0',
  `Cost16` int(11) NOT NULL DEFAULT '0',
  `CratesOrder` int(11) NOT NULL DEFAULT '0',
  `CrateIsland` int(4) NOT NULL DEFAULT '255',
  `IntRadio` int(11) NOT NULL DEFAULT '255',
  `GarageX` float(11,0) NOT NULL DEFAULT '0',
  `GarageY` float(11,0) NOT NULL DEFAULT '0',
  `GarageZ` float(11,0) NOT NULL DEFAULT '0',
  `TackleAccess` int(11) NOT NULL DEFAULT '255',
  `WheelClamps` int(11) NOT NULL DEFAULT '255',
  `DoCAccess` int(11) NOT NULL DEFAULT '255',
  `MedicAccess` int(11) NOT NULL DEFAULT '-1',
  `DMVAccess` int(11) NOT NULL DEFAULT '255',
  `OOCChat` int(11) NOT NULL DEFAULT '255',
  `OOCColor` mediumint(8) unsigned NOT NULL DEFAULT '130303',
  `Pot` int(11) NOT NULL DEFAULT '0',
  `Crack` int(11) NOT NULL DEFAULT '0',
  `Heroin` int(11) NOT NULL DEFAULT '0',
  `Syringes` int(11) NOT NULL DEFAULT '0',
  `Opium` int(11) NOT NULL DEFAULT '0',
  `TurfCapRank` int(11) NOT NULL DEFAULT '255',
  `PointCapRank` int(11) NOT NULL DEFAULT '255',
  `WithdrawRank` int(11) NOT NULL DEFAULT '255',
  `GClothes0` int(11) NOT NULL DEFAULT '0',
  `GClothes1` int(11) NOT NULL DEFAULT '0',
  `GClothes2` int(11) NOT NULL DEFAULT '0',
  `GClothes3` int(11) NOT NULL DEFAULT '0',
  `GClothes4` int(11) NOT NULL DEFAULT '0',
  `GClothes5` int(11) NOT NULL DEFAULT '0',
  `GClothes6` int(11) NOT NULL DEFAULT '0',
  `GClothes7` int(11) NOT NULL DEFAULT '0',
  `GClothes8` int(11) NOT NULL DEFAULT '0',
  `GClothes9` int(11) NOT NULL DEFAULT '0',
  `Tokens` int(11) NOT NULL DEFAULT '0',
  `Mats` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for groupvehs
-- ----------------------------
DROP TABLE IF EXISTS `groupvehs`;
CREATE TABLE `groupvehs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `SpawnedID` int(11) NOT NULL DEFAULT '65535',
  `vDisabled` tinyint(4) NOT NULL DEFAULT '0',
  `gID` int(11) NOT NULL DEFAULT '-1',
  `gDivID` int(11) NOT NULL DEFAULT '0',
  `vModel` int(11) NOT NULL DEFAULT '0',
  `vPlate` varchar(32) NOT NULL,
  `vMaxHealth` float NOT NULL DEFAULT '1000',
  `vFuel` int(11) NOT NULL DEFAULT '100',
  `vType` int(11) NOT NULL DEFAULT '0',
  `vLoadMax` int(11) NOT NULL DEFAULT '2',
  `vCol1` int(11) NOT NULL DEFAULT '0',
  `vCol2` int(11) NOT NULL DEFAULT '0',
  `vX` float NOT NULL DEFAULT '0',
  `vY` float NOT NULL DEFAULT '0',
  `vZ` float NOT NULL DEFAULT '0',
  `vRotZ` float NOT NULL DEFAULT '0',
  `vUpkeep` int(11) NOT NULL DEFAULT '0',
  `vMod0` int(11) NOT NULL DEFAULT '0',
  `vMod1` int(11) NOT NULL DEFAULT '0',
  `vMod2` int(11) NOT NULL DEFAULT '0',
  `vMod3` int(11) NOT NULL DEFAULT '0',
  `vMod4` int(11) NOT NULL DEFAULT '0',
  `vMod5` int(11) NOT NULL DEFAULT '0',
  `vMod6` int(11) NOT NULL DEFAULT '0',
  `vMod7` int(11) NOT NULL DEFAULT '0',
  `vMod8` int(11) NOT NULL DEFAULT '0',
  `vMod9` int(11) NOT NULL DEFAULT '0',
  `vMod10` int(11) NOT NULL DEFAULT '0',
  `vMod11` int(11) NOT NULL DEFAULT '0',
  `vMod12` int(11) NOT NULL DEFAULT '0',
  `vMod13` int(11) NOT NULL DEFAULT '0',
  `vMod14` int(11) NOT NULL DEFAULT '0',
  `vAttachedObjectModel1` int(11) NOT NULL DEFAULT '65535',
  `vObjectX1` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectY1` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectZ1` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRX1` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRY1` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRZ1` float(11,2) NOT NULL DEFAULT '0.00',
  `vAttachedObjectModel2` int(11) NOT NULL DEFAULT '65535',
  `vObjectX2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectY2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectZ2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRX2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRY2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRZ2` float(11,2) NOT NULL DEFAULT '0.00',
  `vVW` int(11) NOT NULL DEFAULT '0',
  `vInt` int(11) NOT NULL DEFAULT '0',
  `fID` int(11) NOT NULL DEFAULT '0',
  `rID` int(11) NOT NULL DEFAULT '0',
  `vSiren` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=700 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for gWeapons
-- ----------------------------
DROP TABLE IF EXISTS `gWeapons`;
CREATE TABLE `gWeapons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Weapon_ID` int(11) NOT NULL DEFAULT '0',
  `Group_ID` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2001 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for hgbackpacks
-- ----------------------------
DROP TABLE IF EXISTS `hgbackpacks`;
CREATE TABLE `hgbackpacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `posx` float(20,0) NOT NULL,
  `posy` float(20,0) NOT NULL,
  `posz` float(20,0) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=822 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for house_closet
-- ----------------------------
DROP TABLE IF EXISTS `house_closet`;
CREATE TABLE `house_closet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `skinid` int(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6397 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for houses
-- ----------------------------
DROP TABLE IF EXISTS `houses`;
CREATE TABLE `houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Owned` int(11) NOT NULL DEFAULT '0',
  `Level` int(11) NOT NULL DEFAULT '999',
  `Description` varchar(16) NOT NULL DEFAULT 'High',
  `OwnerID` int(11) NOT NULL DEFAULT '-1',
  `OwnerName` varchar(24) NOT NULL DEFAULT 'Nobody',
  `Owner` varchar(24) NOT NULL DEFAULT 'No-Owner',
  `ExteriorX` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExteriorY` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExteriorZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExteriorR` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorX` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorY` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorR` float(10,5) NOT NULL DEFAULT '0.00000',
  `ExtIW` int(11) NOT NULL DEFAULT '0',
  `ExtVW` int(11) NOT NULL DEFAULT '0',
  `IntIW` int(11) NOT NULL DEFAULT '9',
  `IntVW` int(11) NOT NULL DEFAULT '0',
  `Lock` int(11) NOT NULL DEFAULT '0',
  `Rentable` int(11) NOT NULL DEFAULT '0',
  `RentFee` int(11) NOT NULL DEFAULT '0',
  `Value` int(11) NOT NULL DEFAULT '0',
  `SafeMoney` int(11) NOT NULL DEFAULT '0',
  `Pot` int(11) NOT NULL DEFAULT '0',
  `Crack` int(11) NOT NULL DEFAULT '0',
  `Materials` int(11) NOT NULL DEFAULT '0',
  `Weapons0` int(11) NOT NULL DEFAULT '0',
  `Weapons1` int(11) NOT NULL DEFAULT '0',
  `Weapons2` int(11) NOT NULL DEFAULT '0',
  `Weapons3` int(11) NOT NULL DEFAULT '0',
  `Weapons4` int(11) NOT NULL DEFAULT '0',
  `GLUpgrade` int(11) NOT NULL DEFAULT '0',
  `PickupID` int(11) NOT NULL DEFAULT '0',
  `CustomInterior` int(11) NOT NULL DEFAULT '0',
  `CustomExterior` int(11) NOT NULL DEFAULT '0',
  `ExteriorA` float(10,5) NOT NULL DEFAULT '0.00000',
  `InteriorA` float(10,5) NOT NULL DEFAULT '0.00000',
  `MailX` float(10,5) NOT NULL DEFAULT '0.00000',
  `MailY` float(10,5) NOT NULL DEFAULT '0.00000',
  `MailZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `MailA` float(10,5) NOT NULL DEFAULT '0.00000',
  `MailType` tinyint(4) NOT NULL DEFAULT '0',
  `Heroin` int(11) NOT NULL DEFAULT '0',
  `ClosetX` float(10,5) NOT NULL DEFAULT '0.00000',
  `ClosetY` float(10,5) NOT NULL DEFAULT '0.00000',
  `ClosetZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `SignDesc` varchar(255) NOT NULL DEFAULT 'None',
  `SignX` float(10,5) NOT NULL DEFAULT '0.00000',
  `SignY` float(10,5) NOT NULL DEFAULT '0.00000',
  `SignZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `SignA` float(10,5) NOT NULL DEFAULT '0.00000',
  `SignExpire` int(11) NOT NULL DEFAULT '0',
  `LastLogin` int(11) NOT NULL DEFAULT '0',
  `Expire` int(11) NOT NULL DEFAULT '0',
  `Inactive` int(11) NOT NULL DEFAULT '0',
  `Ignore` int(11) NOT NULL DEFAULT '0',
  `Counter` int(11) NOT NULL DEFAULT '0',
  `Listed` int(11) NOT NULL DEFAULT '0',
  `ListingPrice` int(11) NOT NULL DEFAULT '0',
  `LinkedDoor0` int(11) NOT NULL DEFAULT '0',
  `LinkedDoor1` int(11) NOT NULL DEFAULT '0',
  `LinkedDoor2` int(11) NOT NULL DEFAULT '0',
  `LinkedDoor3` int(11) NOT NULL DEFAULT '0',
  `LinkedDoor4` int(11) NOT NULL DEFAULT '0',
  `PendingApproval` int(11) NOT NULL DEFAULT '0',
  `ListedTimeStamp` int(11) NOT NULL DEFAULT '0',
  `ListingDescription` varchar(128) NOT NULL DEFAULT 'None',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`OwnerID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5001 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for humankills
-- ----------------------------
DROP TABLE IF EXISTS `humankills`;
CREATE TABLE `humankills` (
  `id` int(11) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for impoundpoints
-- ----------------------------
DROP TABLE IF EXISTS `impoundpoints`;
CREATE TABLE `impoundpoints` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `VW` int(5) NOT NULL DEFAULT '0',
  `Int` int(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for ip_bans
-- ----------------------------
DROP TABLE IF EXISTS `ip_bans`;
CREATE TABLE `ip_bans` (
  `bid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(32) NOT NULL,
  `end_ip` varchar(32) DEFAULT NULL,
  `date` datetime NOT NULL,
  `reason` varchar(128) NOT NULL,
  `admin` varchar(32) NOT NULL,
  PRIMARY KEY (`bid`),
  UNIQUE KEY `id` (`bid`) USING BTREE,
  KEY `ipaddress` (`ip`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=185910 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for jobstuff
-- ----------------------------
DROP TABLE IF EXISTS `jobstuff`;
CREATE TABLE `jobstuff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pId` int(11) NOT NULL,
  `junkmetal` int(11) NOT NULL DEFAULT '0',
  `newcoin` int(11) NOT NULL DEFAULT '0',
  `oldcoin` int(11) NOT NULL DEFAULT '0',
  `brokenwatch` int(11) NOT NULL DEFAULT '0',
  `oldkey` int(11) NOT NULL DEFAULT '0',
  `treasure` int(11) NOT NULL DEFAULT '0',
  `goldwatch` int(11) NOT NULL DEFAULT '0',
  `silvernugget` int(11) NOT NULL DEFAULT '0',
  `goldnugget` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  UNIQUE KEY `userid` (`pId`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=494960 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for jurisdictions
-- ----------------------------
DROP TABLE IF EXISTS `jurisdictions`;
CREATE TABLE `jurisdictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `GroupID` int(11) NOT NULL DEFAULT '-1',
  `AreaName` varchar(64) DEFAULT NULL,
  `JurisdictionID` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for kills
-- ----------------------------
DROP TABLE IF EXISTS `kills`;
CREATE TABLE `kills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `killerid` int(11) NOT NULL DEFAULT '-1',
  `killedid` int(11) NOT NULL DEFAULT '-1',
  `date` datetime DEFAULT NULL,
  `weapon` varchar(56) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `killer` (`killerid`) USING BTREE,
  KEY `killed` (`killedid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9118714 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for leaderboards
-- ----------------------------
DROP TABLE IF EXISTS `leaderboards`;
CREATE TABLE `leaderboards` (
  `Username` varchar(36) NOT NULL DEFAULT 'None',
  `seconds` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for letters
-- ----------------------------
DROP TABLE IF EXISTS `letters`;
CREATE TABLE `letters` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Sender_Id` int(11) DEFAULT NULL,
  `Receiver_Id` int(11) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Message` varchar(255) DEFAULT NULL,
  `Notify` varchar(1) DEFAULT NULL,
  `Delivery_Min` int(11) DEFAULT NULL,
  `Read` int(11) DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8334 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for lockers
-- ----------------------------
DROP TABLE IF EXISTS `lockers`;
CREATE TABLE `lockers` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Group_ID` int(11) NOT NULL DEFAULT '-1',
  `Locker_ID` int(11) NOT NULL,
  `LockerX` float NOT NULL DEFAULT '0',
  `LockerY` float NOT NULL DEFAULT '0',
  `LockerZ` float NOT NULL DEFAULT '0',
  `LockerVW` int(11) NOT NULL DEFAULT '0',
  `LockerShare` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for login_strikes
-- ----------------------------
DROP TABLE IF EXISTS `login_strikes`;
CREATE TABLE `login_strikes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(15) NOT NULL,
  `username` varchar(128) DEFAULT NULL,
  `date` datetime NOT NULL,
  `ccstrike` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=424 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for lotto
-- ----------------------------
DROP TABLE IF EXISTS `lotto`;
CREATE TABLE `lotto` (
  `tid` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=219724 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for mailboxes
-- ----------------------------
DROP TABLE IF EXISTS `mailboxes`;
CREATE TABLE `mailboxes` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `VW` int(11) NOT NULL DEFAULT '0',
  `Int` int(11) NOT NULL DEFAULT '0',
  `Model` int(11) NOT NULL DEFAULT '3407',
  `PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `Angle` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for mdc
-- ----------------------------
DROP TABLE IF EXISTS `mdc`;
CREATE TABLE `mdc` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `time` datetime NOT NULL,
  `issuer` varchar(24) NOT NULL,
  `crime` varchar(128) NOT NULL,
  `active` tinyint(2) DEFAULT '1',
  `origin` int(11) NOT NULL DEFAULT '1' COMMENT 'SA = | TR=2',
  PRIMARY KEY (`cid`),
  UNIQUE KEY `id` (`cid`) USING BTREE,
  KEY `userid` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=442659 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for misc
-- ----------------------------
DROP TABLE IF EXISTS `misc`;
CREATE TABLE `misc` (
  `gMOTD` varchar(256) NOT NULL,
  `aMOTD` varchar(256) NOT NULL,
  `vMOTD` varchar(256) NOT NULL,
  `cMOTD` varchar(256) NOT NULL,
  `pMOTD` varchar(256) NOT NULL,
  `ShopTechPay` float(11,1) NOT NULL DEFAULT '0.5',
  `Safe` int(11) NOT NULL DEFAULT '0',
  `TicketsSold` int(11) NOT NULL DEFAULT '0',
  `GiftCode` varchar(32) NOT NULL DEFAULT 'off',
  `GiftCodeBypass` int(11) NOT NULL DEFAULT '0',
  `TotalCitizens` int(11) NOT NULL DEFAULT '0',
  `TRCitizens` int(11) NOT NULL DEFAULT '0',
  `SecurityCode` varchar(32) NOT NULL DEFAULT 'none',
  `ShopClosed` int(11) NOT NULL DEFAULT '0',
  `RimMod` int(11) NOT NULL DEFAULT '0',
  `CarVoucher` int(11) NOT NULL DEFAULT '0',
  `PVIPVoucher` int(11) NOT NULL DEFAULT '0',
  `GarageVW` int(11) DEFAULT '0',
  `PumpkinStock` int(11) NOT NULL DEFAULT '0',
  `HalloweenShop` int(11) NOT NULL DEFAULT '0',
  `devnews` text NOT NULL,
  `PassComplexCheck` int(11) NOT NULL DEFAULT '0',
  `InactiveStatus` int(11) NOT NULL DEFAULT '0',
  `hInactiveDays` int(11) NOT NULL DEFAULT '90',
  `hCounterHours` int(11) NOT NULL DEFAULT '5',
  `hExpireWeeks` int(11) NOT NULL DEFAULT '2',
  `ddInactiveDays` int(11) NOT NULL DEFAULT '90',
  `ddCounterHours` int(11) NOT NULL DEFAULT '5',
  `ddExpireWeeks` int(11) NOT NULL DEFAULT '2'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for nation_queue
-- ----------------------------
DROP TABLE IF EXISTS `nation_queue`;
CREATE TABLE `nation_queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `name` varchar(24) DEFAULT NULL,
  `date` datetime NOT NULL,
  `nation` int(1) NOT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `user_id` (`playerid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40403 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for nonrppoints
-- ----------------------------
DROP TABLE IF EXISTS `nonrppoints`;
CREATE TABLE `nonrppoints` (
  `sqlid` int(11) DEFAULT '0',
  `point` int(11) DEFAULT '0',
  `expiration` int(11) DEFAULT '0',
  `reason` varchar(128) DEFAULT NULL,
  `issuer` int(11) DEFAULT '0',
  `active` int(11) DEFAULT '0',
  `manual` int(11) DEFAULT '0',
  KEY `id` (`sqlid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for parking_meters
-- ----------------------------
DROP TABLE IF EXISTS `parking_meters`;
CREATE TABLE `parking_meters` (
  `MeterID` int(11) NOT NULL AUTO_INCREMENT,
  `MeterActive` int(11) NOT NULL DEFAULT '0',
  `MeterRate` int(11) NOT NULL DEFAULT '500',
  `MeterRange` float(10,5) NOT NULL DEFAULT '0.00000',
  `MeterPosition0` float(10,5) NOT NULL DEFAULT '0.00000',
  `MeterPosition1` float(10,5) NOT NULL DEFAULT '0.00000',
  `MeterPosition2` float(10,5) NOT NULL DEFAULT '0.00000',
  `MeterPosition3` float(10,5) NOT NULL DEFAULT '0.00000',
  `MeterPosition4` float(10,5) NOT NULL DEFAULT '0.00000',
  `MeterPosition5` float(10,5) NOT NULL DEFAULT '0.00000',
  `ParkedPosition0` float(10,5) NOT NULL DEFAULT '0.00000',
  `ParkedPosition1` float(10,5) NOT NULL DEFAULT '0.00000',
  `ParkedPosition2` float(10,5) NOT NULL DEFAULT '0.00000',
  `ParkedPosition3` float(10,5) NOT NULL DEFAULT '0.00000',
  PRIMARY KEY (`MeterID`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for paynsprays
-- ----------------------------
DROP TABLE IF EXISTS `paynsprays`;
CREATE TABLE `paynsprays` (
  `id` int(11) NOT NULL,
  `Status` int(1) NOT NULL DEFAULT '0',
  `PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `VW` int(11) NOT NULL DEFAULT '0',
  `Int` int(11) NOT NULL DEFAULT '0',
  `GroupCost` int(11) NOT NULL DEFAULT '0',
  `RegCost` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for pcount
-- ----------------------------
DROP TABLE IF EXISTS `pcount`;
CREATE TABLE `pcount` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `time` time NOT NULL DEFAULT '00:00:00',
  `count` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`date`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for plants
-- ----------------------------
DROP TABLE IF EXISTS `plants`;
CREATE TABLE `plants` (
  `plantID` int(11) NOT NULL AUTO_INCREMENT,
  `Owner` int(11) NOT NULL DEFAULT '0',
  `Object` int(11) NOT NULL DEFAULT '0',
  `PlantType` int(11) NOT NULL DEFAULT '0',
  `PositionX` float NOT NULL DEFAULT '0',
  `PositionY` float NOT NULL DEFAULT '0',
  `PositionZ` float NOT NULL DEFAULT '0',
  `Virtual` int(11) NOT NULL DEFAULT '0',
  `Interior` int(11) NOT NULL DEFAULT '0',
  `Growth` int(11) NOT NULL DEFAULT '0',
  `Expires` int(11) NOT NULL DEFAULT '0',
  `DrugsSkill` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`plantID`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for points
-- ----------------------------
DROP TABLE IF EXISTS `points`;
CREATE TABLE `points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `posx` float(20,5) NOT NULL DEFAULT '0.00000',
  `posy` float(20,5) NOT NULL DEFAULT '0.00000',
  `posz` float(20,5) NOT NULL DEFAULT '0.00000',
  `vw` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `vulnerable` int(11) NOT NULL DEFAULT '0',
  `matpoint` int(11) NOT NULL DEFAULT '0',
  `owner` varchar(128) DEFAULT NULL,
  `cappername` varchar(24) DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `captime` int(11) NOT NULL DEFAULT '0',
  `capfam` int(11) NOT NULL DEFAULT '-1',
  `capname` varchar(24) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for pvehpositions
-- ----------------------------
DROP TABLE IF EXISTS `pvehpositions`;
CREATE TABLE `pvehpositions` (
  `id` int(11) NOT NULL DEFAULT '-1',
  `pv0ModelId` int(11) NOT NULL DEFAULT '0',
  `pv0PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv0PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv0PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv0PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv1ModelId` int(11) NOT NULL DEFAULT '0',
  `pv1PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv1PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv1PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv1PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv2ModelId` int(11) NOT NULL DEFAULT '0',
  `pv2PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv2PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv2PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv2PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv3ModelId` int(11) NOT NULL DEFAULT '0',
  `pv3PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv3PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv3PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv3PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv4ModelId` int(11) NOT NULL DEFAULT '0',
  `pv4PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv4PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv4PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv4PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv5ModelId` int(11) NOT NULL DEFAULT '0',
  `pv5PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv5PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv5PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv5PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv6ModelId` int(11) NOT NULL DEFAULT '0',
  `pv6PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv6PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv6PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv6PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv7ModelId` int(11) NOT NULL DEFAULT '0',
  `pv7PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv7PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv7PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv7PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv8ModelId` int(11) NOT NULL DEFAULT '0',
  `pv8PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv8PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv8PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv8PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv9ModelId` int(11) NOT NULL DEFAULT '0',
  `pv9PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv9PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv9PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv9PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for rentedcars
-- ----------------------------
DROP TABLE IF EXISTS `rentedcars`;
CREATE TABLE `rentedcars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sqlid` int(11) DEFAULT '0',
  `modelid` int(11) DEFAULT '0',
  `posx` float DEFAULT '0',
  `posy` float DEFAULT '0',
  `posz` float DEFAULT '0',
  `posa` float DEFAULT '0',
  `spawned` int(11) DEFAULT '0',
  `hours` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=242 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for requestComments
-- ----------------------------
DROP TABLE IF EXISTS `requestComments`;
CREATE TABLE `requestComments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rid` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `comment` text NOT NULL,
  `ip` varchar(255) NOT NULL,
  `time` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=105 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for requests
-- ----------------------------
DROP TABLE IF EXISTS `requests`;
CREATE TABLE `requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requestedBy` varchar(255) NOT NULL,
  `time` int(255) NOT NULL,
  `details` text NOT NULL,
  `gdoc` text NOT NULL,
  `assignedTo` varchar(255) NOT NULL DEFAULT 'Miguel',
  `priority` int(2) NOT NULL,
  `value` int(50) NOT NULL,
  `status` int(2) NOT NULL,
  `progress` int(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `deleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=66 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for rewardcalc
-- ----------------------------
DROP TABLE IF EXISTS `rewardcalc`;
CREATE TABLE `rewardcalc` (
  `pID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for rflteams
-- ----------------------------
DROP TABLE IF EXISTS `rflteams`;
CREATE TABLE `rflteams` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT 'Not Used',
  `used` int(2) NOT NULL DEFAULT '0',
  `laps` int(5) NOT NULL DEFAULT '0',
  `leader` varchar(26) NOT NULL DEFAULT 'None',
  `members` int(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for sales
-- ----------------------------
DROP TABLE IF EXISTS `sales`;
CREATE TABLE `sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Month` datetime NOT NULL,
  `TotalSold0` int(11) NOT NULL DEFAULT '0',
  `AmountMade0` int(11) NOT NULL DEFAULT '0',
  `TotalSold1` int(11) NOT NULL DEFAULT '0',
  `AmountMade1` int(11) NOT NULL DEFAULT '0',
  `TotalSold2` int(11) NOT NULL DEFAULT '0',
  `AmountMade2` int(11) NOT NULL DEFAULT '0',
  `TotalSold3` int(11) NOT NULL DEFAULT '0',
  `AmountMade3` int(11) NOT NULL DEFAULT '0',
  `TotalSold4` int(11) NOT NULL DEFAULT '0',
  `AmountMade4` int(11) NOT NULL DEFAULT '0',
  `TotalSold5` int(11) NOT NULL DEFAULT '0',
  `AmountMade5` int(11) NOT NULL DEFAULT '0',
  `TotalSold6` int(11) NOT NULL DEFAULT '0',
  `AmountMade6` int(11) NOT NULL DEFAULT '0',
  `TotalSold7` int(11) NOT NULL DEFAULT '0',
  `AmountMade7` int(11) NOT NULL DEFAULT '0',
  `TotalSold8` int(11) NOT NULL DEFAULT '0',
  `AmountMade8` int(11) NOT NULL DEFAULT '0',
  `TotalSold9` int(11) NOT NULL DEFAULT '0',
  `AmountMade9` int(11) NOT NULL DEFAULT '0',
  `TotalSold10` int(11) NOT NULL DEFAULT '0',
  `AmountMade10` int(11) NOT NULL DEFAULT '0',
  `TotalSold11` int(11) NOT NULL DEFAULT '0',
  `AmountMade11` int(11) NOT NULL DEFAULT '0',
  `TotalSold12` int(11) NOT NULL DEFAULT '0',
  `AmountMade12` int(11) NOT NULL DEFAULT '0',
  `TotalSold13` int(11) NOT NULL DEFAULT '0',
  `AmountMade13` int(11) NOT NULL DEFAULT '0',
  `TotalSold14` int(11) NOT NULL DEFAULT '0',
  `AmountMade14` int(11) NOT NULL DEFAULT '0',
  `TotalSold15` int(11) NOT NULL DEFAULT '0',
  `AmountMade15` int(11) NOT NULL DEFAULT '0',
  `TotalSold16` int(11) NOT NULL DEFAULT '0',
  `AmountMade16` int(11) NOT NULL DEFAULT '0',
  `TotalSold17` int(11) NOT NULL DEFAULT '0',
  `AmountMade17` int(11) NOT NULL DEFAULT '0',
  `TotalSold18` int(11) NOT NULL DEFAULT '0',
  `AmountMade18` int(11) NOT NULL DEFAULT '0',
  `TotalSold19` int(11) NOT NULL DEFAULT '0',
  `AmountMade19` int(11) NOT NULL DEFAULT '0',
  `TotalSold20` int(11) NOT NULL DEFAULT '0',
  `AmountMade20` int(11) NOT NULL DEFAULT '0',
  `TotalSold21` int(11) NOT NULL DEFAULT '0',
  `AmountMade21` int(11) NOT NULL DEFAULT '0',
  `TotalSold22` int(11) NOT NULL DEFAULT '0',
  `AmountMade22` int(11) NOT NULL DEFAULT '0',
  `TotalSold23` int(11) NOT NULL DEFAULT '0',
  `AmountMade23` int(11) NOT NULL DEFAULT '0',
  `TotalSold24` int(11) NOT NULL DEFAULT '0',
  `AmountMade24` int(11) NOT NULL DEFAULT '0',
  `TotalSold25` int(11) NOT NULL DEFAULT '0',
  `AmountMade25` int(11) NOT NULL DEFAULT '0',
  `TotalSold26` int(11) NOT NULL DEFAULT '0',
  `AmountMade26` int(11) NOT NULL DEFAULT '0',
  `TotalSold27` int(11) NOT NULL DEFAULT '0',
  `AmountMade27` int(11) NOT NULL DEFAULT '0',
  `TotalSold28` int(11) NOT NULL DEFAULT '0',
  `AmountMade28` int(11) NOT NULL DEFAULT '0',
  `TotalSold29` int(11) NOT NULL DEFAULT '0',
  `AmountMade29` int(11) NOT NULL DEFAULT '0',
  `TotalSold30` int(11) NOT NULL DEFAULT '0',
  `AmountMade30` int(11) NOT NULL DEFAULT '0',
  `TotalSold31` int(11) NOT NULL DEFAULT '0',
  `AmountMade31` int(11) NOT NULL DEFAULT '0',
  `TotalSold32` int(11) NOT NULL DEFAULT '0',
  `AmountMade32` int(11) NOT NULL DEFAULT '0',
  `TotalSold33` int(11) NOT NULL DEFAULT '0',
  `AmountMade33` int(11) NOT NULL DEFAULT '0',
  `TotalSold34` int(11) NOT NULL DEFAULT '0',
  `AmountMade34` int(11) NOT NULL DEFAULT '0',
  `TotalSold35` int(11) NOT NULL DEFAULT '0',
  `AmountMade35` int(11) NOT NULL DEFAULT '0',
  `TotalSold36` int(11) NOT NULL DEFAULT '0',
  `AmountMade36` int(11) NOT NULL DEFAULT '0',
  `TotalSold37` int(11) NOT NULL DEFAULT '0',
  `AmountMade37` int(11) NOT NULL DEFAULT '0',
  `TotalSold38` int(11) NOT NULL DEFAULT '0',
  `AmountMade38` int(11) NOT NULL DEFAULT '0',
  `TotalSold39` int(11) NOT NULL DEFAULT '0',
  `AmountMade39` int(11) NOT NULL DEFAULT '0',
  `TotalSold40` int(11) NOT NULL DEFAULT '0',
  `AmountMade40` int(11) NOT NULL DEFAULT '0',
  `TotalSoldMicro` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `AmountMadeMicro` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for scp_passchange
-- ----------------------------
DROP TABLE IF EXISTS `scp_passchange`;
CREATE TABLE `scp_passchange` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `name` varchar(50) NOT NULL,
  `rpname` varchar(128) NOT NULL,
  `pass_cp` int(1) NOT NULL DEFAULT '0',
  `pass_ig` int(1) NOT NULL DEFAULT '0',
  `addinfo` varchar(255) DEFAULT NULL,
  `passall` int(1) NOT NULL DEFAULT '0',
  `status` int(1) NOT NULL DEFAULT '0',
  `adminname` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sec_questions
-- ----------------------------
DROP TABLE IF EXISTS `sec_questions`;
CREATE TABLE `sec_questions` (
  `userid` int(11) NOT NULL,
  `question` varchar(256) NOT NULL,
  `answer` varchar(256) NOT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for shop
-- ----------------------------
DROP TABLE IF EXISTS `shop`;
CREATE TABLE `shop` (
  `order_product_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL DEFAULT '0',
  `product_id` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(2) NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL DEFAULT '',
  `price` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `quantity` int(4) NOT NULL DEFAULT '0',
  `delivered` tinyint(1) NOT NULL DEFAULT '0',
  `updatedate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deliveruser` varchar(32) NOT NULL DEFAULT '',
  `ip` varchar(32) NOT NULL DEFAULT '',
  `email` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`order_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for shop_orders
-- ----------------------------
DROP TABLE IF EXISTS `shop_orders`;
CREATE TABLE `shop_orders` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) NOT NULL,
  `GiftVoucher` int(12) NOT NULL DEFAULT '0',
  `CarVoucher` int(12) NOT NULL DEFAULT '0',
  `VehVoucher` int(12) NOT NULL DEFAULT '0',
  `SVIPVoucher` int(12) NOT NULL DEFAULT '0',
  `GVIPVoucher` int(12) NOT NULL DEFAULT '0',
  `PVIPVoucher` int(12) NOT NULL DEFAULT '0',
  `credits_spent` int(12) NOT NULL DEFAULT '0',
  `status` int(12) NOT NULL DEFAULT '0',
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for shopprices
-- ----------------------------
DROP TABLE IF EXISTS `shopprices`;
CREATE TABLE `shopprices` (
  `Price0` int(11) NOT NULL DEFAULT '0',
  `Price1` int(11) NOT NULL DEFAULT '0',
  `Price2` int(11) NOT NULL DEFAULT '0',
  `Price3` int(11) NOT NULL DEFAULT '0',
  `Price4` int(11) NOT NULL DEFAULT '0',
  `Price5` int(11) NOT NULL DEFAULT '0',
  `Price6` int(11) NOT NULL DEFAULT '0',
  `Price7` int(11) NOT NULL DEFAULT '0',
  `Price8` int(11) NOT NULL DEFAULT '0',
  `Price9` int(11) NOT NULL DEFAULT '0',
  `Price10` int(11) NOT NULL DEFAULT '0',
  `Price11` int(11) NOT NULL DEFAULT '0',
  `Price12` int(11) NOT NULL DEFAULT '0',
  `Price13` int(11) NOT NULL DEFAULT '0',
  `Price14` int(11) NOT NULL DEFAULT '0',
  `Price15` int(11) NOT NULL DEFAULT '0',
  `Price16` int(11) NOT NULL DEFAULT '0',
  `Price17` int(11) NOT NULL DEFAULT '0',
  `Price18` int(11) NOT NULL DEFAULT '0',
  `Price19` int(11) NOT NULL DEFAULT '0',
  `Price20` int(11) NOT NULL DEFAULT '0',
  `Price21` int(11) NOT NULL DEFAULT '0',
  `Price22` int(11) NOT NULL DEFAULT '0',
  `Price23` int(11) NOT NULL DEFAULT '0',
  `Price24` int(11) NOT NULL DEFAULT '0',
  `Price25` int(11) NOT NULL DEFAULT '0',
  `Price26` int(11) NOT NULL DEFAULT '0',
  `Price27` int(11) NOT NULL DEFAULT '0',
  `Price28` int(11) NOT NULL DEFAULT '0',
  `Price29` int(11) NOT NULL DEFAULT '0',
  `Price30` int(11) NOT NULL DEFAULT '0',
  `Price31` int(11) NOT NULL DEFAULT '0',
  `Price32` int(11) NOT NULL DEFAULT '0',
  `Price33` int(11) NOT NULL DEFAULT '0',
  `Price34` int(11) NOT NULL DEFAULT '0',
  `Price35` int(11) NOT NULL DEFAULT '0',
  `Price36` int(11) NOT NULL DEFAULT '0',
  `Price37` int(11) NOT NULL DEFAULT '0',
  `Price38` int(11) NOT NULL DEFAULT '0',
  `Price39` int(11) NOT NULL DEFAULT '0',
  `Price40` int(11) NOT NULL DEFAULT '0',
  `MicroPrices` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  PRIMARY KEY (`Price0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for shoptech
-- ----------------------------
DROP TABLE IF EXISTS `shoptech`;
CREATE TABLE `shoptech` (
  `id` int(11) NOT NULL DEFAULT '0',
  `total` int(11) NOT NULL DEFAULT '0',
  `dtotal` float(11,1) NOT NULL DEFAULT '0.0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sig_stats
-- ----------------------------
DROP TABLE IF EXISTS `sig_stats`;
CREATE TABLE `sig_stats` (
  `user_id` int(11) NOT NULL DEFAULT '-1',
  `enabled` int(1) NOT NULL DEFAULT '0',
  `field1` int(1) NOT NULL DEFAULT '1',
  `field2` int(1) NOT NULL DEFAULT '1',
  `field3` int(1) NOT NULL DEFAULT '1',
  `field4` int(1) NOT NULL DEFAULT '1',
  `field5` int(1) NOT NULL DEFAULT '1',
  `field6` int(1) NOT NULL DEFAULT '1',
  `field7` int(1) NOT NULL DEFAULT '1',
  `field8` int(1) NOT NULL DEFAULT '1',
  `field9` int(1) NOT NULL DEFAULT '1',
  `field10` int(1) NOT NULL DEFAULT '1',
  `field11` int(1) NOT NULL DEFAULT '1',
  `field12` int(1) NOT NULL DEFAULT '1',
  `field13` int(1) NOT NULL DEFAULT '1',
  `field14` int(1) NOT NULL DEFAULT '1',
  `field15` int(1) NOT NULL DEFAULT '1',
  `field16` int(1) NOT NULL DEFAULT '1',
  `field17` int(1) NOT NULL DEFAULT '1',
  `field18` int(1) NOT NULL DEFAULT '1',
  `field19` int(1) NOT NULL DEFAULT '1',
  `field20` int(1) NOT NULL DEFAULT '1',
  `field21` int(1) NOT NULL DEFAULT '1',
  `field22` int(1) NOT NULL DEFAULT '1',
  `field23` int(1) NOT NULL DEFAULT '1',
  `field24` int(1) NOT NULL DEFAULT '1',
  `field25` int(1) NOT NULL DEFAULT '1',
  `field26` int(1) NOT NULL DEFAULT '1',
  `field27` int(1) NOT NULL DEFAULT '1',
  `field28` int(1) NOT NULL DEFAULT '1',
  `field29` int(1) NOT NULL DEFAULT '1',
  `field30` int(1) NOT NULL DEFAULT '1',
  `field31` int(1) NOT NULL DEFAULT '1',
  `field32` int(1) NOT NULL DEFAULT '1',
  `field33` int(1) NOT NULL DEFAULT '1',
  `field34` int(1) NOT NULL DEFAULT '1',
  `field35` int(1) NOT NULL DEFAULT '1',
  `field36` int(1) NOT NULL DEFAULT '1',
  `field37` int(1) NOT NULL DEFAULT '1',
  `field38` int(1) NOT NULL DEFAULT '1',
  `field39` int(1) NOT NULL DEFAULT '1',
  `field40` int(1) NOT NULL DEFAULT '1',
  `field41` int(1) NOT NULL DEFAULT '1',
  `field42` int(1) NOT NULL DEFAULT '1',
  `field43` int(1) NOT NULL DEFAULT '1',
  `field44` int(1) NOT NULL DEFAULT '1',
  `field45` int(1) NOT NULL DEFAULT '1',
  `field46` int(1) NOT NULL DEFAULT '1',
  `field47` int(1) NOT NULL DEFAULT '1',
  `field48` int(1) NOT NULL DEFAULT '1',
  `field49` int(1) NOT NULL DEFAULT '1',
  `field50` int(1) NOT NULL DEFAULT '1',
  `field51` int(1) NOT NULL DEFAULT '1',
  `field52` int(1) NOT NULL DEFAULT '1',
  `field53` int(1) NOT NULL DEFAULT '1',
  `field54` int(1) NOT NULL DEFAULT '1',
  `field55` int(1) NOT NULL DEFAULT '1',
  `field56` int(1) NOT NULL DEFAULT '1',
  `field57` int(1) NOT NULL DEFAULT '1',
  `field58` int(1) NOT NULL DEFAULT '1',
  `field59` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms
-- ----------------------------
DROP TABLE IF EXISTS `sms`;
CREATE TABLE `sms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(24) DEFAULT NULL,
  `senderid` int(11) NOT NULL DEFAULT '-1',
  `sendernumber` int(11) NOT NULL DEFAULT '0',
  `receiver` varchar(24) DEFAULT NULL,
  `receiverid` int(11) NOT NULL DEFAULT '-1',
  `receivernumber` int(11) NOT NULL DEFAULT '0',
  `message` varchar(128) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `sender` (`senderid`) USING BTREE,
  KEY `receiver` (`receiverid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4695114 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sobeitkicks
-- ----------------------------
DROP TABLE IF EXISTS `sobeitkicks`;
CREATE TABLE `sobeitkicks` (
  `sqlID` int(11) NOT NULL DEFAULT '0',
  `Kicks` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`sqlID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for speed_cameras
-- ----------------------------
DROP TABLE IF EXISTS `speed_cameras`;
CREATE TABLE `speed_cameras` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pos_x` float(10,5) NOT NULL,
  `pos_y` float(10,5) NOT NULL,
  `pos_z` float(10,5) NOT NULL,
  `rotation` float(10,5) NOT NULL,
  `range` float(10,5) NOT NULL,
  `speed_limit` float(10,5) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8 COMMENT='Contains data regarding speed cameras.';

-- ----------------------------
-- Table structure for text_labels
-- ----------------------------
DROP TABLE IF EXISTS `text_labels`;
CREATE TABLE `text_labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Text` varchar(128) NOT NULL DEFAULT '0',
  `PosX` float NOT NULL DEFAULT '0',
  `PosY` float NOT NULL DEFAULT '0',
  `PosZ` float NOT NULL DEFAULT '0',
  `VW` int(11) NOT NULL DEFAULT '0',
  `Int` int(11) NOT NULL DEFAULT '0',
  `Color` int(11) NOT NULL DEFAULT '0',
  `PickupModel` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for tokens_call
-- ----------------------------
DROP TABLE IF EXISTS `tokens_call`;
CREATE TABLE `tokens_call` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `hour` int(2) DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16196 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tokens_report
-- ----------------------------
DROP TABLE IF EXISTS `tokens_report`;
CREATE TABLE `tokens_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `hour` time DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`playerid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=139235 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tokens_request
-- ----------------------------
DROP TABLE IF EXISTS `tokens_request`;
CREATE TABLE `tokens_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `hour` time DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`playerid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=190829 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tokens_wd
-- ----------------------------
DROP TABLE IF EXISTS `tokens_wd`;
CREATE TABLE `tokens_wd` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `hour` time DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19806 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for toolaccess
-- ----------------------------
DROP TABLE IF EXISTS `toolaccess`;
CREATE TABLE `toolaccess` (
  `uid` int(11) NOT NULL,
  `AccessLevel` tinyint(4) unsigned DEFAULT NULL,
  `IP` int(11) unsigned DEFAULT NULL,
  `subnet` tinyint(4) NOT NULL DEFAULT '32',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for toys
-- ----------------------------
DROP TABLE IF EXISTS `toys`;
CREATE TABLE `toys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL DEFAULT '0',
  `modelid` int(11) NOT NULL DEFAULT '0',
  `bone` int(11) NOT NULL DEFAULT '0',
  `posx` float NOT NULL DEFAULT '0',
  `posy` float NOT NULL DEFAULT '0',
  `posz` float NOT NULL DEFAULT '0',
  `rotx` float NOT NULL DEFAULT '0',
  `roty` float NOT NULL DEFAULT '0',
  `rotz` float NOT NULL DEFAULT '0',
  `scalex` float NOT NULL DEFAULT '0',
  `scaley` float NOT NULL DEFAULT '0',
  `scalez` float NOT NULL DEFAULT '0',
  `tradable` int(11) NOT NULL DEFAULT '0',
  `special` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`player`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=648288 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for track_backdoor
-- ----------------------------
DROP TABLE IF EXISTS `track_backdoor`;
CREATE TABLE `track_backdoor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `door_id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for track_gate
-- ----------------------------
DROP TABLE IF EXISTS `track_gate`;
CREATE TABLE `track_gate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `gate_id` int(11) NOT NULL,
  `gate_move` int(1) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for track_gvip
-- ----------------------------
DROP TABLE IF EXISTS `track_gvip`;
CREATE TABLE `track_gvip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `vipm` varchar(11) DEFAULT NULL,
  `type` varchar(15) DEFAULT NULL,
  `expiration` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `forum_link` varchar(128) NOT NULL,
  `tsuid` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for track_house
-- ----------------------------
DROP TABLE IF EXISTS `track_house`;
CREATE TABLE `track_house` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `house_move` int(2) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for track_pvip
-- ----------------------------
DROP TABLE IF EXISTS `track_pvip`;
CREATE TABLE `track_pvip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `vipm` varchar(10) DEFAULT NULL,
  `restrict_veh` varchar(10) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `forum_link` varchar(128) NOT NULL,
  `ts_id` varchar(60) NOT NULL,
  `money_link` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for track_ts
-- ----------------------------
DROP TABLE IF EXISTS `track_ts`;
CREATE TABLE `track_ts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` varchar(11) NOT NULL,
  `database_id` int(11) DEFAULT NULL,
  `channel_name` varchar(128) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `forum_link` varchar(128) NOT NULL,
  `tsuid` varchar(50) NOT NULL,
  `type` varchar(6) NOT NULL,
  `channel_no` int(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for track_vip
-- ----------------------------
DROP TABLE IF EXISTS `track_vip`;
CREATE TABLE `track_vip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `vip` int(1) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `vipm` int(11) NOT NULL,
  `expiration` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for turfs
-- ----------------------------
DROP TABLE IF EXISTS `turfs`;
CREATE TABLE `turfs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` varchar(255) NOT NULL DEFAULT 'None|-1|0|0|12|0.000000|0.000000|0.000000|0.000000' COMMENT 'Name|OwnerID|Locked|Special|Vulnerable|MinX|MinY|MaxX|MaxY',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for user_leaves
-- ----------------------------
DROP TABLE IF EXISTS `user_leaves`;
CREATE TABLE `user_leaves` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `uid` varchar(9) NOT NULL,
  `date_leave` date NOT NULL,
  `date_return` date NOT NULL,
  `reason` varchar(512) NOT NULL,
  `status` int(9) NOT NULL,
  `accept_uid` int(9) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=151 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for user_notes
-- ----------------------------
DROP TABLE IF EXISTS `user_notes`;
CREATE TABLE `user_notes` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `uid` varchar(256) NOT NULL,
  `note` varchar(512) NOT NULL,
  `addDate` date NOT NULL,
  `invokeid` varchar(256) NOT NULL,
  `type` int(6) NOT NULL,
  `points` int(6) NOT NULL,
  `status` int(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=417 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for vehicles
-- ----------------------------
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sqlID` int(11) NOT NULL DEFAULT '0',
  `pvModelId` int(11) NOT NULL DEFAULT '0',
  `pvPosX` float NOT NULL DEFAULT '0',
  `pvPosY` float NOT NULL DEFAULT '0',
  `pvPosZ` float NOT NULL DEFAULT '0',
  `pvPosAngle` float NOT NULL DEFAULT '0',
  `pvLock` int(11) NOT NULL DEFAULT '0',
  `pvLocked` int(11) NOT NULL DEFAULT '0',
  `pvPaintJob` int(11) NOT NULL DEFAULT '0',
  `pvColor1` int(11) NOT NULL DEFAULT '0',
  `pvColor2` int(11) NOT NULL DEFAULT '0',
  `pvPrice` int(11) NOT NULL DEFAULT '0',
  `pvTicket` int(11) NOT NULL DEFAULT '0',
  `pvRestricted` int(11) NOT NULL DEFAULT '0',
  `pvWeapon0` int(11) NOT NULL DEFAULT '0',
  `pvWeapon1` int(11) NOT NULL DEFAULT '0',
  `pvWeapon2` int(11) NOT NULL DEFAULT '0',
  `pvWepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pvFuel` float NOT NULL DEFAULT '0',
  `pvImpound` int(11) NOT NULL DEFAULT '0',
  `pvDisabled` int(11) NOT NULL DEFAULT '0',
  `pvPlate` varchar(32) NOT NULL DEFAULT 'None',
  `pvMod0` int(11) NOT NULL DEFAULT '0',
  `pvMod1` int(11) NOT NULL DEFAULT '0',
  `pvMod2` int(11) NOT NULL DEFAULT '0',
  `pvMod3` int(11) NOT NULL DEFAULT '0',
  `pvMod4` int(11) NOT NULL DEFAULT '0',
  `pvMod5` int(11) NOT NULL DEFAULT '0',
  `pvMod6` int(11) NOT NULL DEFAULT '0',
  `pvMod7` int(11) NOT NULL DEFAULT '0',
  `pvMod8` int(11) NOT NULL DEFAULT '0',
  `pvMod9` int(11) NOT NULL DEFAULT '0',
  `pvMod10` int(11) NOT NULL DEFAULT '0',
  `pvMod11` int(11) NOT NULL DEFAULT '0',
  `pvMod12` int(11) NOT NULL DEFAULT '0',
  `pvMod13` int(11) NOT NULL DEFAULT '0',
  `pvMod14` int(11) NOT NULL DEFAULT '0',
  `pvVW` int(11) NOT NULL DEFAULT '0',
  `pvInt` int(11) NOT NULL DEFAULT '0',
  `pvCrashFlag` int(11) NOT NULL DEFAULT '0',
  `pvCrashY` float NOT NULL DEFAULT '0',
  `pvCrashZ` float NOT NULL DEFAULT '0',
  `pvCrashAngle` float NOT NULL DEFAULT '0',
  `pvCrashX` float NOT NULL DEFAULT '0',
  `pvCrashVW` int(11) NOT NULL DEFAULT '0',
  `pvAlarm` int(11) NOT NULL DEFAULT '0',
  `pvLastLockPickedBy` varchar(24) NOT NULL DEFAULT 'Empty',
  `pvLocksLeft` int(11) NOT NULL DEFAULT '5',
  `pvHealth` float NOT NULL DEFAULT '1000',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`sqlID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=426791 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for watchdog_reports
-- ----------------------------
DROP TABLE IF EXISTS `watchdog_reports`;
CREATE TABLE `watchdog_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reporter` int(11) NOT NULL DEFAULT '0',
  `report` text NOT NULL,
  `reported` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '1 = DM Alert | 2 = Refer',
  `time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6354 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for zombie
-- ----------------------------
DROP TABLE IF EXISTS `zombie`;
CREATE TABLE `zombie` (
  `id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for zombieheals
-- ----------------------------
DROP TABLE IF EXISTS `zombieheals`;
CREATE TABLE `zombieheals` (
  `id` int(11) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for zombiekills
-- ----------------------------
DROP TABLE IF EXISTS `zombiekills`;
CREATE TABLE `zombiekills` (
  `id` int(11) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Event structure for Auto-Prune Bans
-- ----------------------------
DROP EVENT IF EXISTS `Auto-Prune Bans`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `Auto-Prune Bans` ON SCHEDULE EVERY 1 DAY STARTS '2012-09-04 01:00:00' ON COMPLETION PRESERVE ENABLE DO UPDATE `bans` SET `status` = '5' WHERE `status` = '1' AND `date_added` < NOW() - INTERVAL 1 WEEK
;;
DELIMITER ;

-- ----------------------------
-- Event structure for CCStrike Auto-Remove
-- ----------------------------
DROP EVENT IF EXISTS `CCStrike Auto-Remove`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `CCStrike Auto-Remove` ON SCHEDULE EVERY 30 MINUTE STARTS '2014-11-07 06:28:14' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM `login_strikes` WHERE `ccstrike` = 1 AND `date` < NOW() - INTERVAL 2 WEEK ORDER BY `date` ASC
;;
DELIMITER ;

-- ----------------------------
-- Event structure for Email Cache Expiration
-- ----------------------------
DROP EVENT IF EXISTS `Email Cache Expiration`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `Email Cache Expiration` ON SCHEDULE EVERY 1 HOUR STARTS '2012-09-26 16:00:00' ON COMPLETION PRESERVE ENABLE DO DELETE FROM `cp_cache_email` WHERE `date` <= NOW() - INTERVAL 1 HOUR
;;
DELIMITER ;

-- ----------------------------
-- Event structure for Get Player Count (Hourly)
-- ----------------------------
DROP EVENT IF EXISTS `Get Player Count (Hourly)`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `Get Player Count (Hourly)` ON SCHEDULE EVERY 15 MINUTE STARTS '2014-08-25 00:00:00' ON COMPLETION PRESERVE ENABLE DO INSERT INTO `pcount` (`date`, `time`, `count`) VALUES (NOW(), NOW(), (SELECT COUNT(*) FROM `accounts` WHERE `Online` > 0))
;;
DELIMITER ;

-- ----------------------------
-- Event structure for Inactive Sweep
-- ----------------------------
DROP EVENT IF EXISTS `Inactive Sweep`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `Inactive Sweep` ON SCHEDULE EVERY 1 DAY STARTS '2012-09-04 01:00:00' ON COMPLETION PRESERVE ENABLE DO DELETE FROM `accounts` WHERE `Band` = 0 AND `ConnectedTime` = '0' AND `UpdateDate` < NOW() - INTERVAL 1 WEEK
;;
DELIMITER ;

-- ----------------------------
-- Event structure for Login Strikes Auto-Removal
-- ----------------------------
DROP EVENT IF EXISTS `Login Strikes Auto-Removal`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `Login Strikes Auto-Removal` ON SCHEDULE EVERY 1 MINUTE STARTS '2012-09-26 16:00:00' ON COMPLETION PRESERVE ENABLE DO DELETE FROM `login_strikes` WHERE `ccstrike` = 0 AND `date` < NOW() - INTERVAL 15 MINUTE ORDER BY `date` ASC
;;
DELIMITER ;

-- ----------------------------
-- Event structure for Online Temp Fix
-- ----------------------------
DROP EVENT IF EXISTS `Online Temp Fix`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `Online Temp Fix` ON SCHEDULE EVERY 1 HOUR STARTS '2014-07-13 03:51:34' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE `accounts` SET `Online` = 0 WHERE `LastLogin` < NOW() - INTERVAL 12 HOUR AND `Online` = 1
;;
DELIMITER ;

-- ----------------------------
-- Event structure for Staff Password Expiry
-- ----------------------------
DROP EVENT IF EXISTS `Staff Password Expiry`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `Staff Password Expiry` ON SCHEDULE EVERY 6 HOUR STARTS '2014-07-09 05:10:51' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE `accounts` SET `ForcePasswordChange` = 1 WHERE (`AdminLevel` > 0 OR `Watchdog` > 0 OR `Helper` > 1) AND `LastPassChange` < NOW() - INTERVAL 2 MONTH
;;
DELIMITER ;

-- ----------------------------
-- Event structure for VIP Expiration
-- ----------------------------
DROP EVENT IF EXISTS `VIP Expiration`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `VIP Expiration` ON SCHEDULE EVERY 1 HOUR STARTS '2012-09-04 23:00:00' ON COMPLETION PRESERVE ENABLE DO UPDATE `accounts` SET `DonateRank` = 0, `VIPExpire` = 0 WHERE (`DonateRank` BETWEEN 1 AND 3) AND `VIPExpire` > 0 AND `VIPExpire` < Unix_Timestamp() AND `AdminLevel` < 2
;;
DELIMITER ;

-- ----------------------------
-- Event structure for Watchdog Points Expiration
-- ----------------------------
DROP EVENT IF EXISTS `Watchdog Points Expiration`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `Watchdog Points Expiration` ON SCHEDULE EVERY 1 DAY STARTS '2014-02-11 12:11:14' ON COMPLETION PRESERVE ENABLE DO UPDATE `nonrppoints` SET `active` = '0' WHERE `active` = '1' AND `expiration` < UNIX_TIMESTAMP()
;;
DELIMITER ;

-- ----------------------------
-- Event structure for Whitelist Request Prune
-- ----------------------------
DROP EVENT IF EXISTS `Whitelist Request Prune`;
DELIMITER ;;
CREATE DEFINER=`samp_main`@`127.0.0.1` EVENT `Whitelist Request Prune` ON SCHEDULE EVERY 1 HOUR STARTS '2012-09-26 16:00:00' ON COMPLETION PRESERVE ENABLE DO DELETE FROM `cp_whitelist` WHERE `date` < NOW() - INTERVAL 1 HOUR
;;
DELIMITER ;
