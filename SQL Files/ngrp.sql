-- phpMyAdmin SQL Dump
-- version 4.0.4
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 01, 2015 at 08:06 PM
-- Server version: 5.5.32
-- PHP Version: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Table structure for table `911calls`
--

CREATE TABLE IF NOT EXISTS `911calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Caller` varchar(24) COLLATE utf8_bin NOT NULL DEFAULT 'N/A',
  `Phone` int(11) NOT NULL DEFAULT '0',
  `Area` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'None',
  `MainZone` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'None',
  `Description` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'None',
  `Type` int(11) NOT NULL DEFAULT '0',
  `Time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Online` int(11) NOT NULL DEFAULT '0',
  `UpdateDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `RegiDate` datetime DEFAULT NULL,
  `LastLogin` datetime DEFAULT NULL,
  `Username` varchar(32) NOT NULL DEFAULT '',
  `Key` varchar(256) NOT NULL DEFAULT '',
  `Salt` varchar(255) NOT NULL,
  `LastPassChange` datetime NOT NULL,
  `Email` varchar(256) NOT NULL DEFAULT '',
  `IP` varchar(32) NOT NULL DEFAULT '0.0.0.0',
  `SecureIP` varchar(32) NOT NULL DEFAULT '0.0.0.0',
  `Registered` int(11) NOT NULL DEFAULT '0',
  `ConnectedTime` int(11) NOT NULL DEFAULT '0',
  `Sex` int(11) NOT NULL DEFAULT '1',
  `Age` int(11) NOT NULL DEFAULT '18',
  `BirthDate` date NOT NULL DEFAULT '0000-00-00',
  `Band` int(11) NOT NULL DEFAULT '0',
  `PermBand` int(11) NOT NULL DEFAULT '0',
  `Warnings` int(11) NOT NULL DEFAULT '0',
  `referral_id` int(11) NOT NULL DEFAULT '0',
  `Disabled` int(11) NOT NULL DEFAULT '0',
  `Level` int(11) NOT NULL DEFAULT '1',
  `AdminLevel` int(11) NOT NULL DEFAULT '0',
  `AdminType` int(11) NOT NULL DEFAULT '0',
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
  `ShopTech` int(11) NOT NULL DEFAULT '0',
  `HR` int(11) NOT NULL,
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
  `CarLic` int(11) NOT NULL DEFAULT '1',
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
  `MarriedID` int(11) NOT NULL DEFAULT '-1',
  `MarriedTo` varchar(32) NOT NULL DEFAULT 'Nobody',
  `ContractBy` varchar(32) NOT NULL DEFAULT 'Nobody',
  `ContractDetail` varchar(64) NOT NULL DEFAULT 'None',
  `WantedLevel` int(11) NOT NULL DEFAULT '0',
  `Insurance` int(11) NOT NULL DEFAULT '0',
  `NewMuted` int(11) NOT NULL DEFAULT '0',
  `NewMutedTotal` int(11) NOT NULL DEFAULT '0',
  `AdMuted` int(11) NOT NULL DEFAULT '0',
  `AdMutedTotal` int(11) NOT NULL DEFAULT '0',
  `HelpMute` int(11) NOT NULL DEFAULT '0',
  `Helper` int(11) NOT NULL DEFAULT '0',
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
  `FactionModerator` int(11) NOT NULL DEFAULT '0',
  `GangModerator` int(11) NOT NULL DEFAULT '0',
  `SeniorModerator` int(11) NOT NULL DEFAULT '0',
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
  `Smslog0` varchar(256) NOT NULL DEFAULT '',
  `Smslog1` varchar(256) NOT NULL DEFAULT '',
  `Smslog2` varchar(256) NOT NULL DEFAULT '',
  `Smslog3` varchar(256) NOT NULL DEFAULT '',
  `Smslog4` varchar(256) NOT NULL DEFAULT '',
  `Smslog5` varchar(256) NOT NULL DEFAULT '',
  `Smslog6` varchar(256) NOT NULL DEFAULT '',
  `Smslog7` varchar(256) NOT NULL DEFAULT '',
  `Smslog8` varchar(256) NOT NULL DEFAULT '',
  `Smslog9` varchar(256) NOT NULL DEFAULT '',
  `KillLog0` varchar(256) NOT NULL DEFAULT '',
  `KillLog1` varchar(256) NOT NULL DEFAULT '',
  `KillLog2` varchar(256) NOT NULL DEFAULT '',
  `KillLog3` varchar(256) NOT NULL DEFAULT '',
  `KillLog4` varchar(256) NOT NULL DEFAULT '',
  `KillLog5` varchar(256) NOT NULL DEFAULT '',
  `KillLog6` varchar(256) NOT NULL DEFAULT '',
  `KillLog7` varchar(256) NOT NULL DEFAULT '',
  `KillLog8` varchar(256) NOT NULL DEFAULT '',
  `KillLog9` varchar(256) NOT NULL DEFAULT '',
  `pWExists` int(11) NOT NULL DEFAULT '0',
  `pWX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pWY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pWZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pWVW` int(11) NOT NULL DEFAULT '0',
  `pWInt` int(11) NOT NULL DEFAULT '0',
  `pWValue` int(11) NOT NULL DEFAULT '-1',
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
  `pv0PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv0PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv0PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv0PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv0ModelId` int(11) NOT NULL DEFAULT '0',
  `pv0Lock` int(11) NOT NULL DEFAULT '0',
  `pv0dLocked` int(11) NOT NULL DEFAULT '0',
  `pv0PaintJob` int(11) NOT NULL DEFAULT '-1',
  `pv0Color1` int(11) NOT NULL DEFAULT '0',
  `pv0Color2` int(11) NOT NULL DEFAULT '0',
  `pv0Price` int(11) NOT NULL DEFAULT '0',
  `pv0Ticket` int(11) NOT NULL DEFAULT '0',
  `pv0Weapon0` int(11) NOT NULL DEFAULT '0',
  `pv0Weapon1` int(11) NOT NULL DEFAULT '0',
  `pv0Weapon2` int(11) NOT NULL DEFAULT '0',
  `pv0WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pv0Fuel` float(10,5) NOT NULL DEFAULT '100.00000',
  `pv0Impound` int(11) NOT NULL DEFAULT '0',
  `pv0Spawned` int(11) NOT NULL DEFAULT '0',
  `pv0Disabled` int(11) NOT NULL DEFAULT '0',
  `pv0Plate` varchar(32) NOT NULL DEFAULT '',
  `pv0Mod0` int(11) NOT NULL DEFAULT '0',
  `pv0Mod1` int(11) NOT NULL DEFAULT '0',
  `pv0Mod2` int(11) NOT NULL DEFAULT '0',
  `pv0Mod3` int(11) NOT NULL DEFAULT '0',
  `pv0Mod4` int(11) NOT NULL DEFAULT '0',
  `pv0Mod5` int(11) NOT NULL DEFAULT '0',
  `pv0Mod6` int(11) NOT NULL DEFAULT '0',
  `pv0Mod7` int(11) NOT NULL DEFAULT '0',
  `pv0Mod8` int(11) NOT NULL DEFAULT '0',
  `pv0Mod9` int(11) NOT NULL DEFAULT '0',
  `pv0Mod10` int(11) NOT NULL DEFAULT '0',
  `pv0Mod11` int(11) NOT NULL DEFAULT '0',
  `pv0Mod12` int(11) NOT NULL DEFAULT '0',
  `pv0Mod13` int(11) NOT NULL DEFAULT '0',
  `pv0Mod14` int(11) NOT NULL DEFAULT '0',
  `pv1PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv1PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv1PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv1PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv1ModelId` int(11) NOT NULL DEFAULT '0',
  `pv1Lock` int(11) NOT NULL DEFAULT '0',
  `pv1dLocked` int(11) NOT NULL DEFAULT '0',
  `pv1PaintJob` int(11) NOT NULL DEFAULT '-1',
  `pv1Color1` int(11) NOT NULL DEFAULT '0',
  `pv1Color2` int(11) NOT NULL DEFAULT '0',
  `pv1Price` int(11) NOT NULL DEFAULT '0',
  `pv1Ticket` int(11) NOT NULL DEFAULT '0',
  `pv1Weapon0` int(11) NOT NULL DEFAULT '0',
  `pv1Weapon1` int(11) NOT NULL DEFAULT '0',
  `pv1Weapon2` int(11) NOT NULL DEFAULT '0',
  `pv1WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pv1Fuel` float(10,5) NOT NULL DEFAULT '100.00000',
  `pv1Impound` int(11) NOT NULL DEFAULT '0',
  `pv1Spawned` int(11) NOT NULL DEFAULT '0',
  `pv1Disabled` int(11) NOT NULL DEFAULT '0',
  `pv1Plate` varchar(32) NOT NULL DEFAULT '',
  `pv1Mod0` int(11) NOT NULL DEFAULT '0',
  `pv1Mod1` int(11) NOT NULL DEFAULT '0',
  `pv1Mod2` int(11) NOT NULL DEFAULT '0',
  `pv1Mod3` int(11) NOT NULL DEFAULT '0',
  `pv1Mod4` int(11) NOT NULL DEFAULT '0',
  `pv1Mod5` int(11) NOT NULL DEFAULT '0',
  `pv1Mod6` int(11) NOT NULL DEFAULT '0',
  `pv1Mod7` int(11) NOT NULL DEFAULT '0',
  `pv1Mod8` int(11) NOT NULL DEFAULT '0',
  `pv1Mod9` int(11) NOT NULL DEFAULT '0',
  `pv1Mod10` int(11) NOT NULL DEFAULT '0',
  `pv1Mod11` int(11) NOT NULL DEFAULT '0',
  `pv1Mod12` int(11) NOT NULL DEFAULT '0',
  `pv1Mod13` int(11) NOT NULL DEFAULT '0',
  `pv1Mod14` int(11) NOT NULL DEFAULT '0',
  `pv2PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv2PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv2PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv2PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv2ModelId` int(11) NOT NULL DEFAULT '0',
  `pv2Lock` int(11) NOT NULL DEFAULT '0',
  `pv2dLocked` int(11) NOT NULL DEFAULT '0',
  `pv2PaintJob` int(11) NOT NULL DEFAULT '-1',
  `pv2Color1` int(11) NOT NULL DEFAULT '0',
  `pv2Color2` int(11) NOT NULL DEFAULT '0',
  `pv2Price` int(11) NOT NULL DEFAULT '0',
  `pv2Ticket` int(11) NOT NULL DEFAULT '0',
  `pv2Weapon0` int(11) NOT NULL DEFAULT '0',
  `pv2Weapon1` int(11) NOT NULL DEFAULT '0',
  `pv2Weapon2` int(11) NOT NULL DEFAULT '0',
  `pv2WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pv2Fuel` float(10,5) NOT NULL DEFAULT '100.00000',
  `pv2Impound` int(11) NOT NULL DEFAULT '0',
  `pv2Spawned` int(11) NOT NULL DEFAULT '0',
  `pv2Disabled` int(11) NOT NULL DEFAULT '0',
  `pv2Plate` varchar(32) NOT NULL DEFAULT '',
  `pv2Mod0` int(11) NOT NULL DEFAULT '0',
  `pv2Mod1` int(11) NOT NULL DEFAULT '0',
  `pv2Mod2` int(11) NOT NULL DEFAULT '0',
  `pv2Mod3` int(11) NOT NULL DEFAULT '0',
  `pv2Mod4` int(11) NOT NULL DEFAULT '0',
  `pv2Mod5` int(11) NOT NULL DEFAULT '0',
  `pv2Mod6` int(11) NOT NULL DEFAULT '0',
  `pv2Mod7` int(11) NOT NULL DEFAULT '0',
  `pv2Mod8` int(11) NOT NULL DEFAULT '0',
  `pv2Mod9` int(11) NOT NULL DEFAULT '0',
  `pv2Mod10` int(11) NOT NULL DEFAULT '0',
  `pv2Mod11` int(11) NOT NULL DEFAULT '0',
  `pv2Mod12` int(11) NOT NULL DEFAULT '0',
  `pv2Mod13` int(11) NOT NULL DEFAULT '0',
  `pv2Mod14` int(11) NOT NULL DEFAULT '0',
  `pv3PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv3PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv3PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv3PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv3ModelId` int(11) NOT NULL DEFAULT '0',
  `pv3Lock` int(11) NOT NULL DEFAULT '0',
  `pv3dLocked` int(11) NOT NULL DEFAULT '0',
  `pv3PaintJob` int(11) NOT NULL DEFAULT '-1',
  `pv3Color1` int(11) NOT NULL DEFAULT '0',
  `pv3Color2` int(11) NOT NULL DEFAULT '0',
  `pv3Price` int(11) NOT NULL DEFAULT '0',
  `pv3Ticket` int(11) NOT NULL DEFAULT '0',
  `pv3Weapon0` int(11) NOT NULL DEFAULT '0',
  `pv3Weapon1` int(11) NOT NULL DEFAULT '0',
  `pv3Weapon2` int(11) NOT NULL DEFAULT '0',
  `pv3WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pv3Fuel` float(10,5) NOT NULL DEFAULT '100.00000',
  `pv3Impound` int(11) NOT NULL DEFAULT '0',
  `pv3Spawned` int(11) NOT NULL DEFAULT '0',
  `pv3Disabled` int(11) NOT NULL DEFAULT '0',
  `pv3Plate` varchar(32) NOT NULL DEFAULT '',
  `pv3Mod0` int(11) NOT NULL DEFAULT '0',
  `pv3Mod1` int(11) NOT NULL DEFAULT '0',
  `pv3Mod2` int(11) NOT NULL DEFAULT '0',
  `pv3Mod3` int(11) NOT NULL DEFAULT '0',
  `pv3Mod4` int(11) NOT NULL DEFAULT '0',
  `pv3Mod5` int(11) NOT NULL DEFAULT '0',
  `pv3Mod6` int(11) NOT NULL DEFAULT '0',
  `pv3Mod7` int(11) NOT NULL DEFAULT '0',
  `pv3Mod8` int(11) NOT NULL DEFAULT '0',
  `pv3Mod9` int(11) NOT NULL DEFAULT '0',
  `pv3Mod10` int(11) NOT NULL DEFAULT '0',
  `pv3Mod11` int(11) NOT NULL DEFAULT '0',
  `pv3Mod12` int(11) NOT NULL DEFAULT '0',
  `pv3Mod13` int(11) NOT NULL DEFAULT '0',
  `pv3Mod14` int(11) NOT NULL DEFAULT '0',
  `pv4PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv4PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv4PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv4PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv4ModelId` int(11) NOT NULL DEFAULT '0',
  `pv4Lock` int(11) NOT NULL DEFAULT '0',
  `pv4dLocked` int(11) NOT NULL DEFAULT '0',
  `pv4PaintJob` int(11) NOT NULL DEFAULT '-1',
  `pv4Color1` int(11) NOT NULL DEFAULT '0',
  `pv4Color2` int(11) NOT NULL DEFAULT '0',
  `pv4Price` int(11) NOT NULL DEFAULT '0',
  `pv4Ticket` int(11) NOT NULL DEFAULT '0',
  `pv4Weapon0` int(11) NOT NULL DEFAULT '0',
  `pv4Weapon1` int(11) NOT NULL DEFAULT '0',
  `pv4Weapon2` int(11) NOT NULL DEFAULT '0',
  `pv4WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pv4Fuel` float(10,5) NOT NULL DEFAULT '100.00000',
  `pv4Impound` int(11) NOT NULL DEFAULT '0',
  `pv4Spawned` int(11) NOT NULL DEFAULT '0',
  `pv4Disabled` int(11) NOT NULL DEFAULT '0',
  `pv4Plate` varchar(32) NOT NULL DEFAULT '',
  `pv4Mod0` int(11) NOT NULL DEFAULT '0',
  `pv4Mod1` int(11) NOT NULL DEFAULT '0',
  `pv4Mod2` int(11) NOT NULL DEFAULT '0',
  `pv4Mod3` int(11) NOT NULL DEFAULT '0',
  `pv4Mod4` int(11) NOT NULL DEFAULT '0',
  `pv4Mod5` int(11) NOT NULL DEFAULT '0',
  `pv4Mod6` int(11) NOT NULL DEFAULT '0',
  `pv4Mod7` int(11) NOT NULL DEFAULT '0',
  `pv4Mod8` int(11) NOT NULL DEFAULT '0',
  `pv4Mod9` int(11) NOT NULL DEFAULT '0',
  `pv4Mod10` int(11) NOT NULL DEFAULT '0',
  `pv4Mod11` int(11) NOT NULL DEFAULT '0',
  `pv4Mod12` int(11) NOT NULL DEFAULT '0',
  `pv4Mod13` int(11) NOT NULL DEFAULT '0',
  `pv4Mod14` int(11) NOT NULL DEFAULT '0',
  `pv5PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv5PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv5PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv5PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv5ModelId` int(11) NOT NULL DEFAULT '0',
  `pv5Lock` int(11) NOT NULL DEFAULT '0',
  `pv5dLocked` int(11) NOT NULL DEFAULT '0',
  `pv5PaintJob` int(11) NOT NULL DEFAULT '-1',
  `pv5Color1` int(11) NOT NULL DEFAULT '0',
  `pv5Color2` int(11) NOT NULL DEFAULT '0',
  `pv5Price` int(11) NOT NULL DEFAULT '0',
  `pv5Ticket` int(11) NOT NULL DEFAULT '0',
  `pv5Weapon0` int(11) NOT NULL DEFAULT '0',
  `pv5Weapon1` int(11) NOT NULL DEFAULT '0',
  `pv5Weapon2` int(11) NOT NULL DEFAULT '0',
  `pv5WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pv5Fuel` float(10,5) NOT NULL DEFAULT '100.00000',
  `pv5Impound` int(11) NOT NULL DEFAULT '0',
  `pv5Spawned` int(11) NOT NULL DEFAULT '0',
  `pv5Disabled` int(11) NOT NULL DEFAULT '0',
  `pv5Plate` varchar(32) NOT NULL DEFAULT '',
  `pv5Mod0` int(11) NOT NULL DEFAULT '0',
  `pv5Mod1` int(11) NOT NULL DEFAULT '0',
  `pv5Mod2` int(11) NOT NULL DEFAULT '0',
  `pv5Mod3` int(11) NOT NULL DEFAULT '0',
  `pv5Mod4` int(11) NOT NULL DEFAULT '0',
  `pv5Mod5` int(11) NOT NULL DEFAULT '0',
  `pv5Mod6` int(11) NOT NULL DEFAULT '0',
  `pv5Mod7` int(11) NOT NULL DEFAULT '0',
  `pv5Mod8` int(11) NOT NULL DEFAULT '0',
  `pv5Mod9` int(11) NOT NULL DEFAULT '0',
  `pv5Mod10` int(11) NOT NULL DEFAULT '0',
  `pv5Mod11` int(11) NOT NULL DEFAULT '0',
  `pv5Mod12` int(11) NOT NULL DEFAULT '0',
  `pv5Mod13` int(11) NOT NULL DEFAULT '0',
  `pv5Mod14` int(11) NOT NULL DEFAULT '0',
  `pv6PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv6PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv6PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv6PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv6ModelId` int(11) NOT NULL DEFAULT '0',
  `pv6Lock` int(11) NOT NULL DEFAULT '0',
  `pv6dLocked` int(11) NOT NULL DEFAULT '0',
  `pv6PaintJob` int(11) NOT NULL DEFAULT '-1',
  `pv6Color1` int(11) NOT NULL DEFAULT '0',
  `pv6Color2` int(11) NOT NULL DEFAULT '0',
  `pv6Price` int(11) NOT NULL DEFAULT '0',
  `pv6Ticket` int(11) NOT NULL DEFAULT '0',
  `pv6Weapon0` int(11) NOT NULL DEFAULT '0',
  `pv6Weapon1` int(11) NOT NULL DEFAULT '0',
  `pv6Weapon2` int(11) NOT NULL DEFAULT '0',
  `pv6WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pv6Fuel` float(10,5) NOT NULL DEFAULT '100.00000',
  `pv6Impound` int(11) NOT NULL DEFAULT '0',
  `pv6Spawned` int(11) NOT NULL DEFAULT '0',
  `pv6Disabled` int(11) NOT NULL DEFAULT '0',
  `pv6Plate` varchar(32) NOT NULL DEFAULT '',
  `pv6Mod0` int(11) NOT NULL DEFAULT '0',
  `pv6Mod1` int(11) NOT NULL DEFAULT '0',
  `pv6Mod2` int(11) NOT NULL DEFAULT '0',
  `pv6Mod3` int(11) NOT NULL DEFAULT '0',
  `pv6Mod4` int(11) NOT NULL DEFAULT '0',
  `pv6Mod5` int(11) NOT NULL DEFAULT '0',
  `pv6Mod6` int(11) NOT NULL DEFAULT '0',
  `pv6Mod7` int(11) NOT NULL DEFAULT '0',
  `pv6Mod8` int(11) NOT NULL DEFAULT '0',
  `pv6Mod9` int(11) NOT NULL DEFAULT '0',
  `pv6Mod10` int(11) NOT NULL DEFAULT '0',
  `pv6Mod11` int(11) NOT NULL DEFAULT '0',
  `pv6Mod12` int(11) NOT NULL DEFAULT '0',
  `pv6Mod13` int(11) NOT NULL DEFAULT '0',
  `pv6Mod14` int(11) NOT NULL DEFAULT '0',
  `pv7PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv7PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv7PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv7PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv7ModelId` int(11) NOT NULL DEFAULT '0',
  `pv7Lock` int(11) NOT NULL DEFAULT '0',
  `pv7dLocked` int(11) NOT NULL DEFAULT '0',
  `pv7PaintJob` int(11) NOT NULL DEFAULT '-1',
  `pv7Color1` int(11) NOT NULL DEFAULT '0',
  `pv7Color2` int(11) NOT NULL DEFAULT '0',
  `pv7Price` int(11) NOT NULL DEFAULT '0',
  `pv7Ticket` int(11) NOT NULL DEFAULT '0',
  `pv7Weapon0` int(11) NOT NULL DEFAULT '0',
  `pv7Weapon1` int(11) NOT NULL DEFAULT '0',
  `pv7Weapon2` int(11) NOT NULL DEFAULT '0',
  `pv7WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pv7Fuel` float(10,5) NOT NULL DEFAULT '100.00000',
  `pv7Impound` int(11) NOT NULL DEFAULT '0',
  `pv7Spawned` int(11) NOT NULL DEFAULT '0',
  `pv7Disabled` int(11) NOT NULL DEFAULT '0',
  `pv7Plate` varchar(32) NOT NULL DEFAULT '',
  `pv7Mod0` int(11) NOT NULL DEFAULT '0',
  `pv7Mod1` int(11) NOT NULL DEFAULT '0',
  `pv7Mod2` int(11) NOT NULL DEFAULT '0',
  `pv7Mod3` int(11) NOT NULL DEFAULT '0',
  `pv7Mod4` int(11) NOT NULL DEFAULT '0',
  `pv7Mod5` int(11) NOT NULL DEFAULT '0',
  `pv7Mod6` int(11) NOT NULL DEFAULT '0',
  `pv7Mod7` int(11) NOT NULL DEFAULT '0',
  `pv7Mod8` int(11) NOT NULL DEFAULT '0',
  `pv7Mod9` int(11) NOT NULL DEFAULT '0',
  `pv7Mod10` int(11) NOT NULL DEFAULT '0',
  `pv7Mod11` int(11) NOT NULL DEFAULT '0',
  `pv7Mod12` int(11) NOT NULL DEFAULT '0',
  `pv7Mod13` int(11) NOT NULL DEFAULT '0',
  `pv7Mod14` int(11) NOT NULL DEFAULT '0',
  `pv8PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv8PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv8PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv8PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv8ModelId` int(11) NOT NULL DEFAULT '0',
  `pv8Lock` int(11) NOT NULL DEFAULT '0',
  `pv8dLocked` int(11) NOT NULL DEFAULT '0',
  `pv8PaintJob` int(11) NOT NULL DEFAULT '-1',
  `pv8Color1` int(11) NOT NULL DEFAULT '0',
  `pv8Color2` int(11) NOT NULL DEFAULT '0',
  `pv8Price` int(11) NOT NULL DEFAULT '0',
  `pv8Ticket` int(11) NOT NULL DEFAULT '0',
  `pv8Weapon0` int(11) NOT NULL DEFAULT '0',
  `pv8Weapon1` int(11) NOT NULL DEFAULT '0',
  `pv8Weapon2` int(11) NOT NULL DEFAULT '0',
  `pv8WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pv8Fuel` float(10,5) NOT NULL DEFAULT '100.00000',
  `pv8Impound` int(11) NOT NULL DEFAULT '0',
  `pv8Spawned` int(11) NOT NULL DEFAULT '0',
  `pv8Disabled` int(11) NOT NULL DEFAULT '0',
  `pv8Plate` varchar(32) NOT NULL DEFAULT '',
  `pv8Mod0` int(11) NOT NULL DEFAULT '0',
  `pv8Mod1` int(11) NOT NULL DEFAULT '0',
  `pv8Mod2` int(11) NOT NULL DEFAULT '0',
  `pv8Mod3` int(11) NOT NULL DEFAULT '0',
  `pv8Mod4` int(11) NOT NULL DEFAULT '0',
  `pv8Mod5` int(11) NOT NULL DEFAULT '0',
  `pv8Mod6` int(11) NOT NULL DEFAULT '0',
  `pv8Mod7` int(11) NOT NULL DEFAULT '0',
  `pv8Mod8` int(11) NOT NULL DEFAULT '0',
  `pv8Mod9` int(11) NOT NULL DEFAULT '0',
  `pv8Mod10` int(11) NOT NULL DEFAULT '0',
  `pv8Mod11` int(11) NOT NULL DEFAULT '0',
  `pv8Mod12` int(11) NOT NULL DEFAULT '0',
  `pv8Mod13` int(11) NOT NULL DEFAULT '0',
  `pv8Mod14` int(11) NOT NULL DEFAULT '0',
  `pv9PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv9PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv9PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv9PosAngle` float(10,5) NOT NULL DEFAULT '0.00000',
  `pv9ModelId` int(11) NOT NULL DEFAULT '0',
  `pv9Lock` int(11) NOT NULL DEFAULT '0',
  `pv9dLocked` int(11) NOT NULL DEFAULT '0',
  `pv9PaintJob` int(11) NOT NULL DEFAULT '-1',
  `pv9Color1` int(11) NOT NULL DEFAULT '0',
  `pv9Color2` int(11) NOT NULL DEFAULT '0',
  `pv9Price` int(11) NOT NULL DEFAULT '0',
  `pv9Ticket` int(11) NOT NULL DEFAULT '0',
  `pv9Weapon0` int(11) NOT NULL DEFAULT '0',
  `pv9Weapon1` int(11) NOT NULL DEFAULT '0',
  `pv9Weapon2` int(11) NOT NULL DEFAULT '0',
  `pv9WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `pv9Fuel` float(10,5) NOT NULL DEFAULT '100.00000',
  `pv9Impound` int(11) NOT NULL DEFAULT '0',
  `pv9Spawned` int(11) NOT NULL DEFAULT '0',
  `pv9Disabled` int(11) NOT NULL DEFAULT '0',
  `pv9Plate` varchar(32) NOT NULL DEFAULT '',
  `pv9Mod0` int(11) NOT NULL DEFAULT '0',
  `pv9Mod1` int(11) NOT NULL DEFAULT '0',
  `pv9Mod2` int(11) NOT NULL DEFAULT '0',
  `pv9Mod3` int(11) NOT NULL DEFAULT '0',
  `pv9Mod4` int(11) NOT NULL DEFAULT '0',
  `pv9Mod5` int(11) NOT NULL DEFAULT '0',
  `pv9Mod6` int(11) NOT NULL DEFAULT '0',
  `pv9Mod7` int(11) NOT NULL DEFAULT '0',
  `pv9Mod8` int(11) NOT NULL DEFAULT '0',
  `pv9Mod9` int(11) NOT NULL DEFAULT '0',
  `pv9Mod10` int(11) NOT NULL DEFAULT '0',
  `pv9Mod11` int(11) NOT NULL DEFAULT '0',
  `pv9Mod12` int(11) NOT NULL DEFAULT '0',
  `pv9Mod13` int(11) NOT NULL DEFAULT '0',
  `pv9Mod14` int(11) NOT NULL DEFAULT '0',
  `pt0ModelID` int(5) NOT NULL DEFAULT '0',
  `pt0Bone` int(11) NOT NULL DEFAULT '0',
  `pt0PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt0PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt0PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt0RotX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt0RotY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt0RotZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt0ScaX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt0ScaY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt0ScaZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt1ModelID` int(5) NOT NULL DEFAULT '0',
  `pt1Bone` int(11) NOT NULL DEFAULT '0',
  `pt1PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt1PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt1PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt1RotX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt1RotY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt1RotZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt1ScaX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt1ScaY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt1ScaZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt2ModelID` int(5) NOT NULL DEFAULT '0',
  `pt2Bone` int(11) NOT NULL DEFAULT '0',
  `pt2PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt2PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt2PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt2RotX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt2RotY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt2RotZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt2ScaX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt2ScaY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt2ScaZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt3ModelID` int(5) NOT NULL DEFAULT '0',
  `pt3Bone` int(11) NOT NULL DEFAULT '0',
  `pt3PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt3PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt3PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt3RotX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt3RotY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt3RotZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt3ScaX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt3ScaY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt3ScaZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt4ModelID` int(5) NOT NULL DEFAULT '0',
  `pt4Bone` int(11) NOT NULL DEFAULT '0',
  `pt4PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt4PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt4PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt4RotX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt4RotY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt4RotZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt4ScaX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt4ScaY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt4ScaZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt5ModelID` int(5) NOT NULL DEFAULT '0',
  `pt5Bone` int(11) NOT NULL DEFAULT '0',
  `pt5PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt5PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt5PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt5RotX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt5RotY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt5RotZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt5ScaX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt5ScaY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt5ScaZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt6ModelID` int(5) NOT NULL DEFAULT '0',
  `pt6Bone` int(11) NOT NULL DEFAULT '0',
  `pt6PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt6PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt6PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt6RotX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt6RotY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt6RotZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt6ScaX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt6ScaY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt6ScaZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt7ModelID` int(5) NOT NULL DEFAULT '0',
  `pt7Bone` int(11) NOT NULL DEFAULT '0',
  `pt7PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt7PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt7PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt7RotX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt7RotY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt7RotZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt7ScaX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt7ScaY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt7ScaZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt8ModelID` int(5) NOT NULL DEFAULT '0',
  `pt8Bone` int(11) NOT NULL DEFAULT '0',
  `pt8PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt8PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt8PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt8RotX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt8RotY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt8RotZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt8ScaX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt8ScaY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt8ScaZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt9ModelID` int(5) NOT NULL DEFAULT '0',
  `pt9Bone` int(11) NOT NULL DEFAULT '0',
  `pt9PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt9PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt9PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt9RotX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt9RotY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt9RotZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt9ScaX` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt9ScaY` float(10,5) NOT NULL DEFAULT '0.00000',
  `pt9ScaZ` float(10,5) unsigned zerofill NOT NULL DEFAULT '0000.00000',
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
  `pv0Restricted` int(11) NOT NULL DEFAULT '0',
  `pv1Restricted` int(11) NOT NULL DEFAULT '0',
  `pv2Restricted` int(11) NOT NULL DEFAULT '0',
  `pv3Restricted` int(11) NOT NULL DEFAULT '0',
  `pv4Restricted` int(11) NOT NULL DEFAULT '0',
  `pv5Restricted` int(11) NOT NULL DEFAULT '0',
  `pv6Restricted` int(11) NOT NULL DEFAULT '0',
  `pv7Restricted` int(11) NOT NULL DEFAULT '0',
  `pv8Restricted` int(11) NOT NULL DEFAULT '0',
  `pv9restricted` int(11) NOT NULL DEFAULT '0',
  `Scripter` int(11) NOT NULL DEFAULT '0',
  `PR` int(11) NOT NULL DEFAULT '0',
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
  `Trickortreat` int(11) NOT NULL DEFAULT '0',
  `RHMutes` int(1) NOT NULL DEFAULT '0',
  `RHMuteTime` int(11) NOT NULL DEFAULT '0',
  `GiftCode` int(11) NOT NULL DEFAULT '0',
  `Table` int(11) NOT NULL DEFAULT '0',
  `OpiumSeeds` int(11) NOT NULL DEFAULT '0',
  `RawOpium` int(11) NOT NULL DEFAULT '0',
  `Heroin` int(11) NOT NULL DEFAULT '0',
  `Syringe` int(11) NOT NULL DEFAULT '0',
  `Skins` int(2) NOT NULL DEFAULT '0',
  `Hunger` int(11) NOT NULL DEFAULT '50',
  `HungerTimer` int(11) NOT NULL DEFAULT '0',
  `HungerDeathTimer` int(11) NOT NULL DEFAULT '0',
  `Fitness` int(11) NOT NULL DEFAULT '0',
  `Credits` int(11) NOT NULL DEFAULT '0',
  `LastCharmReceived` int(11) NOT NULL DEFAULT '0',
  `HealthCare` int(11) NOT NULL DEFAULT '0',
  `TotalCredits` int(11) NOT NULL DEFAULT '0',
  `911Muted` int(11) NOT NULL DEFAULT '0',
  `ForcePasswordChange` int(11) NOT NULL DEFAULT '0',
  `ReceivedCredits` int(11) NOT NULL DEFAULT '0',
  `Pin` varchar(256) NOT NULL DEFAULT '',
  `RimMod` int(11) NOT NULL DEFAULT '0',
  `Tazer` int(11) NOT NULL DEFAULT '0',
  `Cuff` int(11) NOT NULL DEFAULT '0',
  `CarVoucher` int(11) NOT NULL DEFAULT '0',
  `ReferredBy` varchar(32) NOT NULL DEFAULT 'Nobody',
  `PendingRefReward` int(11) NOT NULL DEFAULT '0',
  `Refers` int(11) NOT NULL DEFAULT '0',
  `Developer` int(11) NOT NULL DEFAULT '0',
  `Famed` int(11) NOT NULL DEFAULT '0',
  `FamedMuted` int(11) NOT NULL DEFAULT '0',
  `DefendTime` int(11) NOT NULL DEFAULT '0',
  `VehicleSlot` int(11) NOT NULL DEFAULT '0',
  `PVIPVoucher` int(11) NOT NULL DEFAULT '0',
  `ToySlot` int(11) NOT NULL,
  `RFLTeam` int(11) NOT NULL,
  `RFLTeamL` int(11) NOT NULL,
  `VehVoucher` int(11) NOT NULL,
  `SVIPVoucher` int(11) NOT NULL,
  `GVIPVoucher` int(11) NOT NULL,
  `GiftVoucher` int(11) NOT NULL,
  `ContactSlot` int(11) NOT NULL DEFAULT '0',
  `FallIntoFun` int(11) NOT NULL,
  `AP` int(11) NOT NULL,
  `Security` int(11) NOT NULL,
  `HungerVoucher` int(11) NOT NULL,
  `BoughtCure` int(11) NOT NULL,
  `Vials` int(11) NOT NULL,
  `ShopTut` int(11) NOT NULL,
  `ShopCounter` int(11) NOT NULL,
  `ShopNotice` int(11) NOT NULL,
  `AdvertVoucher` int(11) NOT NULL DEFAULT '0',
  `SVIPExVoucher` int(11) NOT NULL DEFAULT '0',
  `GVIPExVoucher` int(11) NOT NULL DEFAULT '0',
  `VIPSellable` int(11) NOT NULL DEFAULT '0',
  `ReceivedPrize` int(11) NOT NULL DEFAULT '0',
  `Job3` int(11) NOT NULL DEFAULT '0',
  `Apartment3` int(11) NOT NULL DEFAULT '0',
  `VIPSpawn` int(11) NOT NULL DEFAULT '0',
  `FreeAdsDay` int(11) NOT NULL DEFAULT '0',
  `FreeAdsLeft` int(11) NOT NULL DEFAULT '0',
  `BuddyInvites` int(11) NOT NULL DEFAULT '0',
  `ReceivedBGift` int(11) NOT NULL DEFAULT '0',
  `pVIPJob` int(11) NOT NULL DEFAULT '0',
  `LastBirthday` int(11) NOT NULL DEFAULT '0',
  `AvatarLink` varchar(255) NOT NULL DEFAULT './img/avatar-mini.png',
  `AccountRestricted` int(11) NOT NULL DEFAULT '0',
  `Watchlist` int(11) NOT NULL DEFAULT '0',
  `WatchlistTime` int(11) NOT NULL DEFAULT '0',
  `Backpack` int(11) NOT NULL DEFAULT '0',
  `BEquipped` int(11) NOT NULL DEFAULT '0',
  `BStoredH` int(11) NOT NULL DEFAULT '-1',
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
  `BetaTester` int(11) NOT NULL,
  `BRTimeout` int(11) NOT NULL,
  `NewbieTogged` int(11) NOT NULL,
  `VIPTogged` int(11) NOT NULL,
  `FamedTogged` int(11) NOT NULL,
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
  `mInventory` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `mPurchaseCounts` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `mCooldowns` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `mBoost` varchar(255) NOT NULL DEFAULT '0|0',
  `mShopNotice` varchar(255) NOT NULL DEFAULT '0|0',
  `BItem11` int(11) NOT NULL DEFAULT '0',
  `pExamineDesc` varchar(255) NOT NULL,
  `Badge` varchar(8) NOT NULL DEFAULT 'None',
  `FavStation` varchar(255) NOT NULL,
  `pDedicatedPlayer` int(11) NOT NULL DEFAULT '0',
  `pDedicatedEnabled` int(11) NOT NULL DEFAULT '0',
  `pDedicatedMuted` int(11) NOT NULL DEFAULT '0',
  `pDedicatedWarn` int(11) NOT NULL DEFAULT '0',
  `pOED` int(11) NOT NULL DEFAULT '0',
  `zFuelCan` int(11) NOT NULL DEFAULT '0',
  `BackPackItems` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0',
  `bTicket` int(11) NOT NULL DEFAULT '0',
  `JailedInfo` varchar(255) NOT NULL DEFAULT '0|0|0|0|0',
  `JailedWeapons` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0',
  `pVIPMod` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`Username`),
  KEY `Username` (`Username`(5))
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `anticheat`
--

CREATE TABLE IF NOT EXISTS `anticheat` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `app_admins`
--

CREATE TABLE IF NOT EXISTS `app_admins` (
  `id` int(254) NOT NULL AUTO_INCREMENT,
  `adminName` varchar(254) DEFAULT NULL,
  `status` int(10) DEFAULT '1',
  `lastMsg` varchar(254) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `app_todo`
--

CREATE TABLE IF NOT EXISTS `app_todo` (
  `id` int(254) NOT NULL AUTO_INCREMENT,
  `adminName` varchar(254) DEFAULT NULL,
  `todo` varchar(999) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `arenas`
--

CREATE TABLE IF NOT EXISTS `arenas` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `arrestpoints`
--

CREATE TABLE IF NOT EXISTS `arrestpoints` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `arrestreports`
--

CREATE TABLE IF NOT EXISTS `arrestreports` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `copid` int(12) NOT NULL DEFAULT '0',
  `suspectid` int(12) NOT NULL DEFAULT '0',
  `shortreport` varchar(512) NOT NULL DEFAULT '',
  `longreport` varchar(2024) NOT NULL DEFAULT '',
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `auctions`
--

CREATE TABLE IF NOT EXISTS `auctions` (
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

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bugcomments`
--

CREATE TABLE IF NOT EXISTS `bugcomments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bugid` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `comment` text NOT NULL,
  `ip` varchar(255) NOT NULL,
  `time` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bugcommentss`
--

CREATE TABLE IF NOT EXISTS `bugcommentss` (
  `id` int(11) DEFAULT '0',
  `CommentBy` varchar(32) DEFAULT NULL,
  `CommentTime` datetime DEFAULT NULL,
  `Comment` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bugs`
--

CREATE TABLE IF NOT EXISTS `bugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ReportedBy` varchar(255) DEFAULT NULL,
  `Time` int(255) DEFAULT NULL,
  `Bug` varchar(46) DEFAULT NULL,
  `AssignedTo` varchar(255) NOT NULL DEFAULT 'Nobody',
  `Status` int(11) DEFAULT '0',
  `Description` text,
  `Deleted` int(1) NOT NULL DEFAULT '0',
  `Anonymous` int(1) NOT NULL DEFAULT '0',
  `Tech` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bugss`
--

CREATE TABLE IF NOT EXISTS `bugss` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ReportedBy` varchar(32) DEFAULT '',
  `Date` date DEFAULT NULL,
  `Time` time DEFAULT NULL,
  `Bug` varchar(20) DEFAULT NULL,
  `AssignedTo` varchar(32) NOT NULL DEFAULT 'Nobody',
  `Status` int(11) DEFAULT '0',
  `Description` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bug_misc`
--

CREATE TABLE IF NOT EXISTS `bug_misc` (
  `news` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'None'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `businesses`
--

CREATE TABLE IF NOT EXISTS `businesses` (
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
  `Item15Price` mediumint(8) NOT NULL DEFAULT '0',
  `Item16Price` mediumint(8) NOT NULL DEFAULT '0',
  `Item17Price` mediumint(8) NOT NULL DEFAULT '0',
  `Item18Price` mediumint(8) NOT NULL DEFAULT '0',
  `Item19Price` mediumint(8) NOT NULL DEFAULT '0',
  `Rank0Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank1Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank2Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank3Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank4Pay` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `Rank5Pay` mediumint(8) NOT NULL,
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
  `Car1PosX` float NOT NULL DEFAULT '0',
  `Car1PosY` float NOT NULL DEFAULT '0',
  `Car1PosZ` float NOT NULL DEFAULT '0',
  `Car1PosAngle` float NOT NULL DEFAULT '0',
  `Car1ModelId` int(11) NOT NULL DEFAULT '0',
  `Car1Lock` int(11) NOT NULL DEFAULT '0',
  `Car1Locked` int(11) NOT NULL DEFAULT '0',
  `Car1PaintJob` int(11) NOT NULL DEFAULT '-1',
  `Car1Color1` int(11) NOT NULL DEFAULT '0',
  `Car1Color2` int(11) NOT NULL DEFAULT '0',
  `Car1Price` int(11) NOT NULL DEFAULT '0',
  `Car1Ticket` int(11) NOT NULL DEFAULT '0',
  `Car1Weapon0` int(11) NOT NULL DEFAULT '0',
  `Car1Weapon1` int(11) NOT NULL DEFAULT '0',
  `Car1Weapon2` int(11) NOT NULL DEFAULT '0',
  `Car1WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `Car1Fuel` float NOT NULL DEFAULT '100',
  `Car1Mod0` int(11) NOT NULL DEFAULT '0',
  `Car1Mod1` int(11) NOT NULL DEFAULT '0',
  `Car1Mod2` int(11) NOT NULL DEFAULT '0',
  `Car1Mod3` int(11) NOT NULL DEFAULT '0',
  `Car1Mod4` int(11) NOT NULL DEFAULT '0',
  `Car1Mod5` int(11) NOT NULL DEFAULT '0',
  `Car1Mod6` int(11) NOT NULL DEFAULT '0',
  `Car1Mod7` int(11) NOT NULL DEFAULT '0',
  `Car1Mod8` int(11) NOT NULL DEFAULT '0',
  `Car1Mod9` int(11) NOT NULL DEFAULT '0',
  `Car1Mod10` int(11) NOT NULL DEFAULT '0',
  `Car1Mod11` int(11) NOT NULL DEFAULT '0',
  `Car1Mod12` int(11) NOT NULL DEFAULT '0',
  `Car1Mod13` int(11) NOT NULL DEFAULT '0',
  `Car1Mod14` int(11) NOT NULL DEFAULT '0',
  `Car2PosX` float NOT NULL DEFAULT '0',
  `Car2PosY` float NOT NULL DEFAULT '0',
  `Car2PosZ` float NOT NULL DEFAULT '0',
  `Car2PosAngle` float NOT NULL DEFAULT '0',
  `Car2ModelId` int(11) NOT NULL DEFAULT '0',
  `Car2Lock` int(11) NOT NULL DEFAULT '0',
  `Car2Locked` int(11) NOT NULL DEFAULT '0',
  `Car2PaintJob` int(11) NOT NULL DEFAULT '-1',
  `Car2Color1` int(11) NOT NULL DEFAULT '0',
  `Car2Color2` int(11) NOT NULL DEFAULT '0',
  `Car2Price` int(11) NOT NULL DEFAULT '0',
  `Car2Ticket` int(11) NOT NULL DEFAULT '0',
  `Car2Weapon0` int(11) NOT NULL DEFAULT '0',
  `Car2Weapon1` int(11) NOT NULL DEFAULT '0',
  `Car2Weapon2` int(11) NOT NULL DEFAULT '0',
  `Car2WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `Car2Fuel` float NOT NULL DEFAULT '100',
  `Car2Mod0` int(11) NOT NULL DEFAULT '0',
  `Car2Mod1` int(11) NOT NULL DEFAULT '0',
  `Car2Mod2` int(11) NOT NULL DEFAULT '0',
  `Car2Mod3` int(11) NOT NULL DEFAULT '0',
  `Car2Mod4` int(11) NOT NULL DEFAULT '0',
  `Car2Mod5` int(11) NOT NULL DEFAULT '0',
  `Car2Mod6` int(11) NOT NULL DEFAULT '0',
  `Car2Mod7` int(11) NOT NULL DEFAULT '0',
  `Car2Mod8` int(11) NOT NULL DEFAULT '0',
  `Car2Mod9` int(11) NOT NULL DEFAULT '0',
  `Car2Mod10` int(11) NOT NULL DEFAULT '0',
  `Car2Mod11` int(11) NOT NULL DEFAULT '0',
  `Car2Mod12` int(11) NOT NULL DEFAULT '0',
  `Car2Mod13` int(11) NOT NULL DEFAULT '0',
  `Car2Mod14` int(11) NOT NULL DEFAULT '0',
  `Car3PosX` float NOT NULL DEFAULT '0',
  `Car3PosY` float NOT NULL DEFAULT '0',
  `Car3PosZ` float NOT NULL DEFAULT '0',
  `Car3PosAngle` float NOT NULL DEFAULT '0',
  `Car3ModelId` int(11) NOT NULL DEFAULT '0',
  `Car3Lock` int(11) NOT NULL DEFAULT '0',
  `Car3Locked` int(11) NOT NULL DEFAULT '0',
  `Car3PaintJob` int(11) NOT NULL DEFAULT '-1',
  `Car3Color1` int(11) NOT NULL DEFAULT '0',
  `Car3Color2` int(11) NOT NULL DEFAULT '0',
  `Car3Price` int(11) NOT NULL DEFAULT '0',
  `Car3Ticket` int(11) NOT NULL DEFAULT '0',
  `Car3Weapon0` int(11) NOT NULL DEFAULT '0',
  `Car3Weapon1` int(11) NOT NULL DEFAULT '0',
  `Car3Weapon2` int(11) NOT NULL DEFAULT '0',
  `Car3WepUpgrade` int(11) NOT NULL DEFAULT '0',
  `Car3Fuel` float NOT NULL DEFAULT '100',
  `Car3Mod0` int(11) NOT NULL DEFAULT '0',
  `Car3Mod1` int(11) NOT NULL DEFAULT '0',
  `Car3Mod2` int(11) NOT NULL DEFAULT '0',
  `Car3Mod3` int(11) NOT NULL DEFAULT '0',
  `Car3Mod4` int(11) NOT NULL DEFAULT '0',
  `Car3Mod5` int(11) NOT NULL DEFAULT '0',
  `Car3Mod6` int(11) NOT NULL DEFAULT '0',
  `Car3Mod7` int(11) NOT NULL DEFAULT '0',
  `Car3Mod8` int(11) NOT NULL DEFAULT '0',
  `Car3Mod9` int(11) NOT NULL DEFAULT '0',
  `Car3Mod10` int(11) NOT NULL DEFAULT '0',
  `Car3Mod11` int(11) NOT NULL DEFAULT '0',
  `Car3Mod12` int(11) NOT NULL DEFAULT '0',
  `Car3Mod13` int(11) NOT NULL DEFAULT '0',
  `Car3Mod14` int(11) NOT NULL DEFAULT '0',
  `Car1Stock` int(11) NOT NULL DEFAULT '0',
  `Car2Stock` int(11) NOT NULL DEFAULT '0',
  `Car3Stock` int(11) NOT NULL DEFAULT '0',
  `Car1Order` int(11) NOT NULL DEFAULT '0',
  `Car2Order` int(11) NOT NULL DEFAULT '0',
  `Car3Order` int(11) NOT NULL DEFAULT '0',
  `Car0PosX` float NOT NULL DEFAULT '0',
  `Car0PosY` float NOT NULL DEFAULT '0',
  `Car0PosZ` float NOT NULL DEFAULT '0',
  `Car0PosAngle` float NOT NULL DEFAULT '0',
  `Car0ModelId` int(11) NOT NULL DEFAULT '0',
  `Car0Price` int(11) NOT NULL DEFAULT '0',
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
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `businesssales`
--

CREATE TABLE IF NOT EXISTS `businesssales` (
  `bID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `BusinessID` int(11) unsigned NOT NULL DEFAULT '0',
  `Text` varchar(128) DEFAULT '0',
  `Price` int(11) DEFAULT '0',
  `Available` int(11) NOT NULL DEFAULT '0',
  `Purchased` int(11) DEFAULT '0',
  `Type` int(11) DEFAULT '0',
  PRIMARY KEY (`bID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `columns_priv`
--

CREATE TABLE IF NOT EXISTS `columns_priv` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Table_name` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Column_name` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Column_priv` set('Select','Insert','Update','References') CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`Host`,`Db`,`User`,`Table_name`,`Column_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column privileges';

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE IF NOT EXISTS `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sqlID` int(11) NOT NULL,
  `name` varchar(24) CHARACTER SET utf8 NOT NULL,
  `number` int(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `cp_access`
--

CREATE TABLE IF NOT EXISTS `cp_access` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `punish` tinyint(1) DEFAULT '0',
  `refund` tinyint(1) DEFAULT '0',
  `ban` tinyint(1) DEFAULT '0',
  `cplgeneral` tinyint(1) DEFAULT '0',
  `cplstaff` tinyint(1) DEFAULT NULL,
  `cplfaction` tinyint(1) DEFAULT NULL,
  `cplfamily` tinyint(1) DEFAULT NULL,
  `gladmin` tinyint(1) DEFAULT '0',
  `gladmingive` tinyint(1) DEFAULT NULL,
  `gladminpay` tinyint(1) DEFAULT NULL,
  `glban` tinyint(1) DEFAULT NULL,
  `glcontracts` tinyint(1) DEFAULT NULL,
  `glddedit` tinyint(1) DEFAULT NULL,
  `gldmpedit` tinyint(1) DEFAULT NULL,
  `glfaction` tinyint(1) DEFAULT NULL,
  `glfamily` tinyint(1) DEFAULT NULL,
  `glfmembercount` tinyint(1) DEFAULT NULL,
  `glgedit` tinyint(1) DEFAULT NULL,
  `glgifts` tinyint(1) DEFAULT NULL,
  `glhack` tinyint(1) DEFAULT NULL,
  `glhedit` tinyint(1) DEFAULT NULL,
  `glhouse` tinyint(1) DEFAULT NULL,
  `glkick` tinyint(1) DEFAULT NULL,
  `gllicenses` tinyint(1) DEFAULT NULL,
  `glmoderator` tinyint(1) DEFAULT NULL,
  `glmute` tinyint(1) DEFAULT NULL,
  `glpads` tinyint(1) DEFAULT NULL,
  `glpassword` tinyint(1) DEFAULT NULL,
  `glpay` tinyint(1) DEFAULT NULL,
  `glplayervehicle` tinyint(1) DEFAULT NULL,
  `glrpspecial` tinyint(1) DEFAULT NULL,
  `glsecurity` tinyint(1) DEFAULT NULL,
  `glsetvip` tinyint(1) DEFAULT NULL,
  `glshopconfirmedorders` tinyint(1) DEFAULT NULL,
  `glshoplog` tinyint(1) DEFAULT NULL,
  `glshoporders` tinyint(1) DEFAULT NULL,
  `glstats` tinyint(1) DEFAULT NULL,
  `glundercover` tinyint(1) DEFAULT NULL,
  `glvipnamechanges` tinyint(1) DEFAULT NULL,
  `glvipremove` tinyint(1) DEFAULT NULL,
  `cplaccess` tinyint(1) DEFAULT '0',
  `glrapid` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_admin_notes`
--

CREATE TABLE IF NOT EXISTS `cp_admin_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` int(1) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `invoke_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `points` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_cache_email`
--

CREATE TABLE IF NOT EXISTS `cp_cache_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `email_address` varchar(255) DEFAULT NULL,
  `token` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_cache_passreset`
--

CREATE TABLE IF NOT EXISTS `cp_cache_passreset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(128) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cp_cache_sec_questions`
--

CREATE TABLE IF NOT EXISTS `cp_cache_sec_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `answer` varchar(128) NOT NULL,
  `token` varchar(128) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cp_faction`
--

CREATE TABLE IF NOT EXISTS `cp_faction` (
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

-- --------------------------------------------------------

--
-- Table structure for table `cp_family`
--

CREATE TABLE IF NOT EXISTS `cp_family` (
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

-- --------------------------------------------------------

--
-- Table structure for table `cp_info_states`
--

CREATE TABLE IF NOT EXISTS `cp_info_states` (
  `state_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK: Unique state ID',
  `state_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT 'State name with first letter capital',
  `state_abbr` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Optional state abbreviation (US is 2 capital letters)',
  PRIMARY KEY (`state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cp_info_temp`
--

CREATE TABLE IF NOT EXISTS `cp_info_temp` (
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

-- --------------------------------------------------------

--
-- Table structure for table `cp_leave`
--

CREATE TABLE IF NOT EXISTS `cp_leave` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `date_leave` date DEFAULT NULL,
  `date_return` date DEFAULT NULL,
  `reason` varchar(1024) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `acceptedby_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_log`
--

CREATE TABLE IF NOT EXISTS `cp_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `section` varchar(255) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_log_access`
--

CREATE TABLE IF NOT EXISTS `cp_log_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_log_cr`
--

CREATE TABLE IF NOT EXISTS `cp_log_cr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_log_faction`
--

CREATE TABLE IF NOT EXISTS `cp_log_faction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_log_family`
--

CREATE TABLE IF NOT EXISTS `cp_log_family` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_log_general`
--

CREATE TABLE IF NOT EXISTS `cp_log_general` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_log_security`
--

CREATE TABLE IF NOT EXISTS `cp_log_security` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_log_staff`
--

CREATE TABLE IF NOT EXISTS `cp_log_staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `details` varchar(1024) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_mass_email`
--

CREATE TABLE IF NOT EXISTS `cp_mass_email` (
  `id` int(11) DEFAULT '0',
  `subject` varchar(255) COLLATE utf8_bin NOT NULL,
  `message` varchar(255) COLLATE utf8_bin NOT NULL,
  `creator` varchar(255) COLLATE utf8_bin NOT NULL,
  `create_date` datetime NOT NULL,
  `update_date` datetime NOT NULL,
  `last_sent` datetime NOT NULL,
  `banned` int(11) NOT NULL,
  `disabled` int(11) NOT NULL,
  `admins` int(11) NOT NULL,
  `helpers` int(11) NOT NULL,
  `vip` int(11) NOT NULL,
  `famed` int(11) NOT NULL,
  `faction` int(11) NOT NULL,
  `faction_rank` int(11) NOT NULL,
  `gang` int(11) NOT NULL,
  `gang_rank` int(11) NOT NULL,
  `biz` int(11) NOT NULL,
  `biz_rank` int(11) NOT NULL,
  `bypass` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `cp_misc`
--

CREATE TABLE IF NOT EXISTS `cp_misc` (
  `id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `from` varchar(24) COLLATE utf8_bin NOT NULL,
  `message` varchar(128) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `cp_punishment`
--

CREATE TABLE IF NOT EXISTS `cp_punishment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) DEFAULT NULL,
  `date_added` date DEFAULT NULL,
  `addedby_id` int(11) DEFAULT NULL,
  `reason` varchar(1024) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `prison` int(11) DEFAULT NULL,
  `jail` int(11) DEFAULT NULL,
  `warn` int(1) DEFAULT NULL,
  `fine` int(11) DEFAULT NULL,
  `ban` int(1) DEFAULT NULL,
  `wep_restrict` int(11) DEFAULT NULL,
  `other_punish` varchar(1024) DEFAULT NULL,
  `link` varchar(1024) DEFAULT NULL,
  `date_issued` date DEFAULT NULL,
  `issuedby_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_refund`
--

CREATE TABLE IF NOT EXISTS `cp_refund` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `refund` varchar(512) DEFAULT NULL,
  `link` varchar(256) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `auth` int(11) DEFAULT NULL,
  `addedby_id` int(11) DEFAULT NULL,
  `date_added` date DEFAULT NULL,
  `issuedby_id` int(1) DEFAULT NULL,
  `date_issued` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_restricted_archive`
--

CREATE TABLE IF NOT EXISTS `cp_restricted_archive` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) DEFAULT NULL,
  `removed_by` int(12) DEFAULT NULL,
  `removed_date` datetime DEFAULT NULL,
  `reason` varchar(524) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cp_security_files`
--

CREATE TABLE IF NOT EXISTS `cp_security_files` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) NOT NULL,
  `uploader_id` int(12) NOT NULL,
  `file_name` varchar(524) NOT NULL,
  `file_type` varchar(524) NOT NULL,
  `file_size` varchar(524) NOT NULL,
  `file_location` varchar(524) NOT NULL,
  `file_description` varchar(524) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cp_security_notes`
--

CREATE TABLE IF NOT EXISTS `cp_security_notes` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) NOT NULL,
  `note_by` int(12) NOT NULL,
  `note` varchar(524) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cp_security_profiles`
--

CREATE TABLE IF NOT EXISTS `cp_security_profiles` (
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cp_shifts`
--

CREATE TABLE IF NOT EXISTS `cp_shifts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` int(1) DEFAULT NULL,
  `shift_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `sign_up` datetime DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `bonus` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_shift_blocks`
--

CREATE TABLE IF NOT EXISTS `cp_shift_blocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shift_id` int(11) NOT NULL,
  `shift` varchar(1) DEFAULT NULL,
  `time_start` time DEFAULT NULL,
  `time_end` time DEFAULT NULL,
  `needs_sunday` int(11) DEFAULT NULL,
  `needs_monday` int(11) DEFAULT NULL,
  `needs_tuesday` int(11) DEFAULT NULL,
  `needs_wednesday` int(11) DEFAULT NULL,
  `needs_thursday` int(11) DEFAULT NULL,
  `needs_friday` int(11) DEFAULT NULL,
  `needs_saturday` int(11) DEFAULT NULL,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_shift_leader`
--

CREATE TABLE IF NOT EXISTS `cp_shift_leader` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `shift_id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_stat`
--

CREATE TABLE IF NOT EXISTS `cp_stat` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL,
  `timezone` varchar(128) NOT NULL DEFAULT 'NULL',
  `gtalk` varchar(124) DEFAULT 'N/A',
  `paypal` varchar(128) DEFAULT NULL,
  `points` int(11) DEFAULT '0',
  `shift` int(11) DEFAULT '0',
  `shift_restrict` varchar(255) DEFAULT NULL,
  `shift_complete` int(11) DEFAULT '0',
  `shift_partcomplete` int(11) DEFAULT '0',
  `shift_missed` int(11) DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_store_cart`
--

CREATE TABLE IF NOT EXISTS `cp_store_cart` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `cart_id` int(12) NOT NULL,
  `customer_id` int(12) NOT NULL,
  `customer_ip_address` varchar(32) NOT NULL,
  `cart_pack_id` varchar(32) NOT NULL,
  `date_item_added` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cp_store_manage`
--

CREATE TABLE IF NOT EXISTS `cp_store_manage` (
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

-- --------------------------------------------------------

--
-- Table structure for table `cp_store_orders`
--

CREATE TABLE IF NOT EXISTS `cp_store_orders` (
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cp_support_faq`
--

CREATE TABLE IF NOT EXISTS `cp_support_faq` (
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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_support_faq_category`
--

CREATE TABLE IF NOT EXISTS `cp_support_faq_category` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `category` varchar(250) DEFAULT NULL,
  `sub_category` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_support_items`
--

CREATE TABLE IF NOT EXISTS `cp_support_items` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `sort_id` int(6) NOT NULL,
  `item_category` varchar(32) NOT NULL,
  `item_name` varchar(32) NOT NULL,
  `item_picture` varchar(150) NOT NULL DEFAULT '',
  `item_credit_price` varchar(12) NOT NULL,
  `item_description` varchar(5000) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cp_support_tickets`
--

CREATE TABLE IF NOT EXISTS `cp_support_tickets` (
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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_support_tickets_response`
--

CREATE TABLE IF NOT EXISTS `cp_support_tickets_response` (
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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cp_weekly_reports`
--

CREATE TABLE IF NOT EXISTS `cp_weekly_reports` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cp_whitelist`
--

CREATE TABLE IF NOT EXISTS `cp_whitelist` (
  `id` int(11) NOT NULL,
  `username` varchar(25) NOT NULL,
  `key` varchar(128) NOT NULL,
  `ip` varchar(15) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `crates`
--

CREATE TABLE IF NOT EXISTS `crates` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `db`
--

CREATE TABLE IF NOT EXISTS `db` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Select_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Insert_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Update_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Delete_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Drop_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Grant_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `References_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Index_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Alter_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_tmp_table_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Lock_tables_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_view_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Show_view_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_routine_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Alter_routine_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Execute_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Event_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Trigger_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Host`,`Db`,`User`),
  KEY `User` (`User`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database privileges';

-- --------------------------------------------------------

--
-- Table structure for table `ddoors`
--

CREATE TABLE IF NOT EXISTS `ddoors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(128) NOT NULL DEFAULT 'None',
  `Owner` int(11) NOT NULL DEFAULT '-1',
  `OwnerName` varchar(24) NOT NULL DEFAULT 'Nobody',
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `dedi_april`
--

CREATE TABLE IF NOT EXISTS `dedi_april` (
  `id` int(11) NOT NULL DEFAULT '0',
  `Username` varchar(255) DEFAULT NULL,
  `RewardHours` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `devcpbans`
--

CREATE TABLE IF NOT EXISTS `devcpbans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `anon` int(1) NOT NULL DEFAULT '0',
  `bugs` int(1) NOT NULL DEFAULT '0',
  `updated` int(34) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `devcplogs`
--

CREATE TABLE IF NOT EXISTS `devcplogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `log` text NOT NULL,
  `type` varchar(255) NOT NULL,
  `time` int(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `bugid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `dmapicons`
--

CREATE TABLE IF NOT EXISTS `dmapicons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `MarkerType` int(11) NOT NULL DEFAULT '0',
  `Color` int(11) NOT NULL DEFAULT '0',
  `VW` int(11) NOT NULL DEFAULT '0',
  `Int` int(11) NOT NULL DEFAULT '0',
  `PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `dm_watchdog`
--

CREATE TABLE IF NOT EXISTS `dm_watchdog` (
  `id` int(11) NOT NULL DEFAULT '0',
  `reporter` int(11) NOT NULL DEFAULT '0',
  `timestamp` int(11) NOT NULL DEFAULT '0',
  `superwatch` tinyint(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `event`
--

CREATE TABLE IF NOT EXISTS `event` (
  `db` char(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `name` char(64) NOT NULL DEFAULT '',
  `body` longblob NOT NULL,
  `definer` char(77) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `execute_at` datetime DEFAULT NULL,
  `interval_value` int(11) DEFAULT NULL,
  `interval_field` enum('YEAR','QUARTER','MONTH','DAY','HOUR','MINUTE','WEEK','SECOND','MICROSECOND','YEAR_MONTH','DAY_HOUR','DAY_MINUTE','DAY_SECOND','HOUR_MINUTE','HOUR_SECOND','MINUTE_SECOND','DAY_MICROSECOND','HOUR_MICROSECOND','MINUTE_MICROSECOND','SECOND_MICROSECOND') DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_executed` datetime DEFAULT NULL,
  `starts` datetime DEFAULT NULL,
  `ends` datetime DEFAULT NULL,
  `status` enum('ENABLED','DISABLED','SLAVESIDE_DISABLED') NOT NULL DEFAULT 'ENABLED',
  `on_completion` enum('DROP','PRESERVE') NOT NULL DEFAULT 'DROP',
  `sql_mode` set('REAL_AS_FLOAT','PIPES_AS_CONCAT','ANSI_QUOTES','IGNORE_SPACE','NOT_USED','ONLY_FULL_GROUP_BY','NO_UNSIGNED_SUBTRACTION','NO_DIR_IN_CREATE','POSTGRESQL','ORACLE','MSSQL','DB2','MAXDB','NO_KEY_OPTIONS','NO_TABLE_OPTIONS','NO_FIELD_OPTIONS','MYSQL323','MYSQL40','ANSI','NO_AUTO_VALUE_ON_ZERO','NO_BACKSLASH_ESCAPES','STRICT_TRANS_TABLES','STRICT_ALL_TABLES','NO_ZERO_IN_DATE','NO_ZERO_DATE','INVALID_DATES','ERROR_FOR_DIVISION_BY_ZERO','TRADITIONAL','NO_AUTO_CREATE_USER','HIGH_NOT_PRECEDENCE','NO_ENGINE_SUBSTITUTION','PAD_CHAR_TO_FULL_LENGTH') NOT NULL DEFAULT '',
  `comment` char(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `originator` int(10) unsigned NOT NULL,
  `time_zone` char(64) CHARACTER SET latin1 NOT NULL DEFAULT 'SYSTEM',
  `character_set_client` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `collation_connection` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `db_collation` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `body_utf8` longblob,
  PRIMARY KEY (`db`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Events';

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE IF NOT EXISTS `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` int(11) NOT NULL DEFAULT '-1',
  `approvedby` int(11) NOT NULL DEFAULT '-1',
  `pos` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '0.0, 0.0, 0.0',
  `weapons` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '0,0,0,0,0',
  `skins` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '0,0',
  `time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `event_hungergames-2013-10`
--

CREATE TABLE IF NOT EXISTS `event_hungergames-2013-10` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `fallintofun`
--

CREATE TABLE IF NOT EXISTS `fallintofun` (
  `player` int(50) NOT NULL DEFAULT '0',
  `FIFHours` int(30) DEFAULT '0',
  `FIFChances` int(30) DEFAULT '0',
  PRIMARY KEY (`player`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `families`
--

CREATE TABLE IF NOT EXISTS `families` (
  `ID` tinyint(1) NOT NULL AUTO_INCREMENT,
  `Taken` tinyint(1) NOT NULL DEFAULT '0',
  `Name` varchar(40) NOT NULL DEFAULT 'None',
  `MOTD` varchar(64) NOT NULL DEFAULT 'None',
  `MOTD1` varchar(128) NOT NULL,
  `MOTD2` varchar(128) NOT NULL,
  `MOTD3` varchar(128) NOT NULL,
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
  `Division0` varchar(16) NOT NULL DEFAULT 'none',
  `Division1` varchar(16) NOT NULL DEFAULT 'none',
  `Division2` varchar(16) NOT NULL DEFAULT 'none',
  `Division3` varchar(16) NOT NULL DEFAULT 'none',
  `Division4` varchar(16) NOT NULL DEFAULT 'none',
  `Heroin` int(16) NOT NULL DEFAULT '0',
  `GtObject` int(11) NOT NULL DEFAULT '1490',
  `fontface` varchar(32) NOT NULL,
  `fontsize` int(11) NOT NULL,
  `bold` int(11) NOT NULL,
  `fontcolor` int(11) NOT NULL,
  `backcolor` int(11) NOT NULL,
  `text` varchar(32) NOT NULL,
  `gtUsed` int(11) NOT NULL,
  `FamColor` mediumint(8) unsigned NOT NULL DEFAULT '130303',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `flags`
--

CREATE TABLE IF NOT EXISTS `flags` (
  `fid` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `time` datetime NOT NULL,
  `issuer` varchar(24) NOT NULL,
  `flag` varchar(128) NOT NULL,
  `type` int(11) NOT NULL DEFAULT '1' COMMENT '1 = Regular | 2 = Admin',
  PRIMARY KEY (`fid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `func`
--

CREATE TABLE IF NOT EXISTS `func` (
  `name` binary(64) NOT NULL DEFAULT '                                                                ',
  `ret` tinyint(1) NOT NULL DEFAULT '0',
  `dl` char(128) COLLATE utf8_bin NOT NULL DEFAULT '',
  `type` enum('function','aggregate') CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User defined functions';

-- --------------------------------------------------------

--
-- Table structure for table `gangtags`
--

CREATE TABLE IF NOT EXISTS `gangtags` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `garages`
--

CREATE TABLE IF NOT EXISTS `garages` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `gates`
--

CREATE TABLE IF NOT EXISTS `gates` (
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
  `Automate` int(11) NOT NULL,
  `Locked` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `general_log`
--

CREATE TABLE IF NOT EXISTS `general_log` (
  `event_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_host` mediumtext NOT NULL,
  `thread_id` int(11) NOT NULL,
  `server_id` int(10) unsigned NOT NULL,
  `command_type` varchar(64) NOT NULL,
  `argument` mediumtext NOT NULL
) ENGINE=CSV DEFAULT CHARSET=utf8 COMMENT='General log';

-- --------------------------------------------------------

--
-- Table structure for table `giftbox`
--

CREATE TABLE IF NOT EXISTS `giftbox` (
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

-- --------------------------------------------------------

--
-- Table structure for table `giftpage_dec`
--

CREATE TABLE IF NOT EXISTS `giftpage_dec` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `groupbans`
--

CREATE TABLE IF NOT EXISTS `groupbans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `TypeBan` int(11) NOT NULL DEFAULT '-1',
  `PlayerID` int(11) NOT NULL DEFAULT '-1',
  `BanDate` datetime NOT NULL DEFAULT '2001-01-12 00:00:00',
  `GroupBan` int(11) NOT NULL DEFAULT '-1',
  `BannedBy` varchar(24) NOT NULL DEFAULT '',
  `BanReason` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE IF NOT EXISTS `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Type` tinyint(4) NOT NULL DEFAULT '0',
  `Name` varchar(64) NOT NULL DEFAULT '',
  `MOTD` varchar(128) NOT NULL DEFAULT '',
  `MOTD2` varchar(128) NOT NULL DEFAULT '',
  `MOTD3` varchar(128) NOT NULL DEFAULT '',
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
  `LockerCostType` int(11) NOT NULL,
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
  `Div0` varchar(30) NOT NULL,
  `Div1` varchar(16) NOT NULL DEFAULT '',
  `Div2` varchar(16) NOT NULL DEFAULT '',
  `Div3` varchar(16) NOT NULL DEFAULT '',
  `Div4` varchar(16) NOT NULL DEFAULT '',
  `Div5` varchar(16) NOT NULL DEFAULT '',
  `Div6` varchar(16) NOT NULL DEFAULT '',
  `Div7` varchar(16) NOT NULL DEFAULT '',
  `Div8` varchar(16) NOT NULL DEFAULT '',
  `Div9` varchar(16) NOT NULL DEFAULT '',
  `Div10` varchar(16) NOT NULL DEFAULT '',
  `Gun0` tinyint(4) NOT NULL,
  `Cost0` int(11) NOT NULL,
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
  `GarageX` float NOT NULL,
  `GarageY` float NOT NULL,
  `GarageZ` float NOT NULL,
  `TackleAccess` int(11) NOT NULL DEFAULT '255',
  `WheelClamps` int(11) NOT NULL DEFAULT '255',
  `DoCAccess` int(11) NOT NULL DEFAULT '255',
  `MedicAccess` int(11) NOT NULL DEFAULT '255',
  `DMVAccess` int(11) NOT NULL DEFAULT '255',
  `OOCChat` int(11) NOT NULL DEFAULT '0',
  `OOCColor` mediumint(8) unsigned NOT NULL DEFAULT '130303',
  `Pot` int(11) NOT NULL,
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
  `Mats` int(11) NOT NULL DEFAULT '0',
  `Tokens` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `groupvehs`
--

CREATE TABLE IF NOT EXISTS `groupvehs` (
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `groupvehss`
--

CREATE TABLE IF NOT EXISTS `groupvehss` (
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
  `rID` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gweapons`
--

CREATE TABLE IF NOT EXISTS `gweapons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Weapon_ID` int(11) NOT NULL DEFAULT '0',
  `Group_ID` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `help_category`
--

CREATE TABLE IF NOT EXISTS `help_category` (
  `help_category_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL DEFAULT '',
  `parent_category_id` smallint(5) unsigned DEFAULT NULL,
  `url` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`help_category_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='help categories';

-- --------------------------------------------------------

--
-- Table structure for table `help_keyword`
--

CREATE TABLE IF NOT EXISTS `help_keyword` (
  `help_keyword_id` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`help_keyword_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='help keywords';

-- --------------------------------------------------------

--
-- Table structure for table `help_relation`
--

CREATE TABLE IF NOT EXISTS `help_relation` (
  `help_topic_id` int(10) unsigned NOT NULL DEFAULT '0',
  `help_keyword_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`help_keyword_id`,`help_topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='keyword-topic relation';

-- --------------------------------------------------------

--
-- Table structure for table `help_topic`
--

CREATE TABLE IF NOT EXISTS `help_topic` (
  `help_topic_id` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL DEFAULT '',
  `help_category_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `example` text NOT NULL,
  `url` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`help_topic_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='help topics';

-- --------------------------------------------------------

--
-- Table structure for table `hgbackpacks`
--

CREATE TABLE IF NOT EXISTS `hgbackpacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `posx` float(20,0) NOT NULL,
  `posy` float(20,0) NOT NULL,
  `posz` float(20,0) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `host`
--

CREATE TABLE IF NOT EXISTS `host` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Select_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Insert_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Update_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Delete_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Drop_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Grant_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `References_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Index_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Alter_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_tmp_table_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Lock_tables_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_view_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Show_view_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_routine_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Alter_routine_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Execute_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Trigger_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Host`,`Db`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Host privileges;  Merged with database privileges';

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE IF NOT EXISTS `houses` (
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `house_closet`
--

CREATE TABLE IF NOT EXISTS `house_closet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `skinid` int(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `humankills`
--

CREATE TABLE IF NOT EXISTS `humankills` (
  `id` int(11) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `impoundpoints`
--

CREATE TABLE IF NOT EXISTS `impoundpoints` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `VW` int(5) NOT NULL DEFAULT '0',
  `Int` int(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ip_bans`
--

CREATE TABLE IF NOT EXISTS `ip_bans` (
  `bid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(32) NOT NULL,
  `date` datetime NOT NULL,
  `reason` varchar(128) NOT NULL,
  `admin` varchar(32) NOT NULL,
  PRIMARY KEY (`bid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `jobstuff`
--

CREATE TABLE IF NOT EXISTS `jobstuff` (
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `jurisdictions`
--

CREATE TABLE IF NOT EXISTS `jurisdictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `GroupID` int(11) NOT NULL DEFAULT '-1',
  `JurisdictionID` int(2) NOT NULL DEFAULT '0',
  `AreaName` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `kills`
--

CREATE TABLE IF NOT EXISTS `kills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `killerid` int(11) NOT NULL DEFAULT '-1',
  `killedid` int(11) NOT NULL DEFAULT '-1',
  `date` datetime DEFAULT NULL,
  `weapon` varchar(56) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `leaderboards`
--

CREATE TABLE IF NOT EXISTS `leaderboards` (
  `Username` varchar(36) NOT NULL DEFAULT 'None',
  `seconds` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `letters`
--

CREATE TABLE IF NOT EXISTS `letters` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Sender_Id` int(11) DEFAULT NULL,
  `Receiver_Id` int(11) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Message` varchar(255) DEFAULT NULL,
  `Notify` varchar(1) DEFAULT NULL,
  `Delivery_Min` int(11) DEFAULT NULL,
  `Read` int(11) DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `lockers`
--

CREATE TABLE IF NOT EXISTS `lockers` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Group_ID` int(11) NOT NULL DEFAULT '-1',
  `Locker_ID` int(11) NOT NULL,
  `LockerX` float NOT NULL DEFAULT '0',
  `LockerY` float NOT NULL DEFAULT '0',
  `LockerZ` float NOT NULL DEFAULT '0',
  `LockerVW` int(11) NOT NULL DEFAULT '0',
  `LockerShare` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `login_strikes`
--

CREATE TABLE IF NOT EXISTS `login_strikes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(15) NOT NULL,
  `username` varchar(128) DEFAULT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `lotto`
--

CREATE TABLE IF NOT EXISTS `lotto` (
  `tid` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  PRIMARY KEY (`tid`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `mail2`
--

CREATE TABLE IF NOT EXISTS `mail2` (
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mailboxes`
--

CREATE TABLE IF NOT EXISTS `mailboxes` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `VW` int(11) NOT NULL DEFAULT '0',
  `Int` int(11) NOT NULL DEFAULT '0',
  `Model` int(11) NOT NULL DEFAULT '3407',
  `PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `Angle` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `mdc`
--

CREATE TABLE IF NOT EXISTS `mdc` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `time` datetime NOT NULL,
  `issuer` varchar(24) NOT NULL,
  `crime` varchar(128) NOT NULL,
  `active` tinyint(2) DEFAULT '1',
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `misc`
--

CREATE TABLE IF NOT EXISTS `misc` (
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
  `SecurityCode` varchar(128) NOT NULL,
  `ShopClosed` int(11) NOT NULL DEFAULT '0',
  `RimMod` int(11) NOT NULL DEFAULT '0',
  `CarVoucher` int(11) NOT NULL DEFAULT '0',
  `PVIPVoucher` int(11) NOT NULL DEFAULT '0',
  `PVIPAmount` int(11) NOT NULL DEFAULT '0',
  `GarageVW` int(11) NOT NULL DEFAULT '0',
  `PumpkinStock` int(11) NOT NULL,
  `HalloweenShop` int(11) NOT NULL,
  `PassComplexCheck` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `nation_queue`
--

CREATE TABLE IF NOT EXISTS `nation_queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `name` varchar(24) DEFAULT NULL,
  `date` datetime NOT NULL,
  `nation` int(1) NOT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ndb_binlog_index`
--

CREATE TABLE IF NOT EXISTS `ndb_binlog_index` (
  `Position` bigint(20) unsigned NOT NULL,
  `File` varchar(255) NOT NULL,
  `epoch` bigint(20) unsigned NOT NULL,
  `inserts` bigint(20) unsigned NOT NULL,
  `updates` bigint(20) unsigned NOT NULL,
  `deletes` bigint(20) unsigned NOT NULL,
  `schemaops` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`epoch`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `nonrppoints`
--

CREATE TABLE IF NOT EXISTS `nonrppoints` (
  `sqlid` int(11) NOT NULL DEFAULT '0',
  `point` int(11) NOT NULL DEFAULT '0',
  `expiration` int(11) NOT NULL DEFAULT '0',
  `reason` varchar(128) COLLATE utf8_bin NOT NULL DEFAULT 'N/A',
  `issuer` int(11) NOT NULL DEFAULT '0',
  `active` int(11) NOT NULL DEFAULT '0',
  `manual` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `paynsprays`
--

CREATE TABLE IF NOT EXISTS `paynsprays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Status` int(1) NOT NULL DEFAULT '0',
  `PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `VW` int(11) NOT NULL DEFAULT '0',
  `Int` int(11) NOT NULL DEFAULT '0',
  `GroupCost` int(11) NOT NULL DEFAULT '0',
  `RegCost` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `plants`
--

CREATE TABLE IF NOT EXISTS `plants` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `plugin`
--

CREATE TABLE IF NOT EXISTS `plugin` (
  `name` varchar(64) NOT NULL DEFAULT '',
  `dl` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='MySQL plugins';

-- --------------------------------------------------------

--
-- Table structure for table `points`
--

CREATE TABLE IF NOT EXISTS `points` (
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
  `capfam` int(11) NOT NULL DEFAULT '255',
  `capname` varchar(24) NOT NULL DEFAULT 'NULL',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `proc`
--

CREATE TABLE IF NOT EXISTS `proc` (
  `db` char(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `name` char(64) NOT NULL DEFAULT '',
  `type` enum('FUNCTION','PROCEDURE') NOT NULL,
  `specific_name` char(64) NOT NULL DEFAULT '',
  `language` enum('SQL') NOT NULL DEFAULT 'SQL',
  `sql_data_access` enum('CONTAINS_SQL','NO_SQL','READS_SQL_DATA','MODIFIES_SQL_DATA') NOT NULL DEFAULT 'CONTAINS_SQL',
  `is_deterministic` enum('YES','NO') NOT NULL DEFAULT 'NO',
  `security_type` enum('INVOKER','DEFINER') NOT NULL DEFAULT 'DEFINER',
  `param_list` blob NOT NULL,
  `returns` longblob NOT NULL,
  `body` longblob NOT NULL,
  `definer` char(77) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sql_mode` set('REAL_AS_FLOAT','PIPES_AS_CONCAT','ANSI_QUOTES','IGNORE_SPACE','NOT_USED','ONLY_FULL_GROUP_BY','NO_UNSIGNED_SUBTRACTION','NO_DIR_IN_CREATE','POSTGRESQL','ORACLE','MSSQL','DB2','MAXDB','NO_KEY_OPTIONS','NO_TABLE_OPTIONS','NO_FIELD_OPTIONS','MYSQL323','MYSQL40','ANSI','NO_AUTO_VALUE_ON_ZERO','NO_BACKSLASH_ESCAPES','STRICT_TRANS_TABLES','STRICT_ALL_TABLES','NO_ZERO_IN_DATE','NO_ZERO_DATE','INVALID_DATES','ERROR_FOR_DIVISION_BY_ZERO','TRADITIONAL','NO_AUTO_CREATE_USER','HIGH_NOT_PRECEDENCE','NO_ENGINE_SUBSTITUTION','PAD_CHAR_TO_FULL_LENGTH') NOT NULL DEFAULT '',
  `comment` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `character_set_client` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `collation_connection` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `db_collation` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `body_utf8` longblob,
  PRIMARY KEY (`db`,`name`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stored Procedures';

-- --------------------------------------------------------

--
-- Table structure for table `procs_priv`
--

CREATE TABLE IF NOT EXISTS `procs_priv` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Routine_name` char(64) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Routine_type` enum('FUNCTION','PROCEDURE') COLLATE utf8_bin NOT NULL,
  `Grantor` char(77) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Proc_priv` set('Execute','Alter Routine','Grant') CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Host`,`Db`,`User`,`Routine_name`,`Routine_type`),
  KEY `Grantor` (`Grantor`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Procedure privileges';

-- --------------------------------------------------------

--
-- Table structure for table `proxies_priv`
--

CREATE TABLE IF NOT EXISTS `proxies_priv` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Proxied_host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Proxied_user` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `With_grant` tinyint(1) NOT NULL DEFAULT '0',
  `Grantor` char(77) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Host`,`User`,`Proxied_host`,`Proxied_user`),
  KEY `Grantor` (`Grantor`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User proxy privileges';

-- --------------------------------------------------------

--
-- Table structure for table `pvehpositions`
--

CREATE TABLE IF NOT EXISTS `pvehpositions` (
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

-- --------------------------------------------------------

--
-- Table structure for table `rentedcars`
--

CREATE TABLE IF NOT EXISTS `rentedcars` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `requestcomments`
--

CREATE TABLE IF NOT EXISTS `requestcomments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rid` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `comment` text NOT NULL,
  `ip` varchar(255) NOT NULL,
  `time` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE IF NOT EXISTS `requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requestedBy` varchar(255) NOT NULL,
  `time` int(255) NOT NULL,
  `details` text NOT NULL,
  `gdoc` text NOT NULL,
  `assignedTo` varchar(255) NOT NULL,
  `priority` int(2) NOT NULL,
  `value` int(50) NOT NULL,
  `status` int(2) NOT NULL,
  `progress` int(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `rewardcalc`
--

CREATE TABLE IF NOT EXISTS `rewardcalc` (
  `pID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `rflteams`
--

CREATE TABLE IF NOT EXISTS `rflteams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) CHARACTER SET utf8 NOT NULL,
  `leader` varchar(24) CHARACTER SET utf8 NOT NULL,
  `used` int(11) NOT NULL,
  `members` int(11) NOT NULL,
  `laps` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE IF NOT EXISTS `sales` (
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
  `TotalSold30` int(11) NOT NULL,
  `AmountMade30` int(11) NOT NULL,
  `TotalSold31` int(11) NOT NULL,
  `AmountMade31` int(11) NOT NULL,
  `TotalSold32` int(11) NOT NULL,
  `AmountMade32` int(11) NOT NULL,
  `TotalSold33` int(11) NOT NULL,
  `AmountMade33` int(11) NOT NULL,
  `TotalSold34` int(11) NOT NULL,
  `AmountMade34` int(11) NOT NULL,
  `TotalSold35` int(11) NOT NULL DEFAULT '0',
  `AmountMade35` int(11) NOT NULL,
  `TotalSold36` int(11) NOT NULL DEFAULT '0',
  `AmountMade36` int(11) NOT NULL DEFAULT '0',
  `TotalSold37` int(11) NOT NULL DEFAULT '0',
  `AmountMade37` int(11) NOT NULL DEFAULT '0',
  `TotalSold38` int(11) NOT NULL DEFAULT '0',
  `AmountMade38` int(11) NOT NULL DEFAULT '0',
  `TotalSold39` int(11) NOT NULL DEFAULT '0',
  `AmountMade39` int(11) NOT NULL,
  `TotalSoldMicro` varchar(512) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `AmountMadeMicro` varchar(512) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `TotalSold40` int(11) NOT NULL DEFAULT '0',
  `AmountMade40` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sec_questions`
--

CREATE TABLE IF NOT EXISTS `sec_questions` (
  `userid` int(11) NOT NULL,
  `question` varchar(256) NOT NULL,
  `answer` varchar(256) NOT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `servers`
--

CREATE TABLE IF NOT EXISTS `servers` (
  `Server_name` char(64) NOT NULL DEFAULT '',
  `Host` char(64) NOT NULL DEFAULT '',
  `Db` char(64) NOT NULL DEFAULT '',
  `Username` char(64) NOT NULL DEFAULT '',
  `Password` char(64) NOT NULL DEFAULT '',
  `Port` int(4) NOT NULL DEFAULT '0',
  `Socket` char(64) NOT NULL DEFAULT '',
  `Wrapper` char(64) NOT NULL DEFAULT '',
  `Owner` char(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`Server_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='MySQL Foreign Servers table';

-- --------------------------------------------------------

--
-- Table structure for table `shop`
--

CREATE TABLE IF NOT EXISTS `shop` (
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

-- --------------------------------------------------------

--
-- Table structure for table `shopprices`
--

CREATE TABLE IF NOT EXISTS `shopprices` (
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
  `Price19` int(11) NOT NULL,
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
  `MicroPrices` varchar(255) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `Price40` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Price0`),
  KEY `Price31` (`Price31`,`Price32`,`Price33`,`Price34`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `shoptech`
--

CREATE TABLE IF NOT EXISTS `shoptech` (
  `id` int(11) NOT NULL DEFAULT '0',
  `total` int(11) NOT NULL DEFAULT '0',
  `dtotal` float(11,1) NOT NULL DEFAULT '0.0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `shop_orders`
--

CREATE TABLE IF NOT EXISTS `shop_orders` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) DEFAULT NULL,
  `GiftVoucher` int(12) DEFAULT NULL,
  `CarVoucher` int(12) DEFAULT NULL,
  `VehVoucher` int(12) DEFAULT NULL,
  `SVIPVoucher` int(12) DEFAULT NULL,
  `GVIPVoucher` int(12) DEFAULT NULL,
  `credits_spent` int(12) DEFAULT NULL,
  `PVIPVoucher` int(12) DEFAULT NULL,
  `status` int(12) DEFAULT NULL,
  `date_added` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sig_stats`
--

CREATE TABLE IF NOT EXISTS `sig_stats` (
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

-- --------------------------------------------------------

--
-- Table structure for table `slow_log`
--

CREATE TABLE IF NOT EXISTS `slow_log` (
  `start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_host` mediumtext NOT NULL,
  `query_time` time NOT NULL,
  `lock_time` time NOT NULL,
  `rows_sent` int(11) NOT NULL,
  `rows_examined` int(11) NOT NULL,
  `db` varchar(512) NOT NULL,
  `last_insert_id` int(11) NOT NULL,
  `insert_id` int(11) NOT NULL,
  `server_id` int(10) unsigned NOT NULL,
  `sql_text` mediumtext NOT NULL
) ENGINE=CSV DEFAULT CHARSET=utf8 COMMENT='Slow log';

-- --------------------------------------------------------

--
-- Table structure for table `sms`
--

CREATE TABLE IF NOT EXISTS `sms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(24) DEFAULT NULL,
  `senderid` int(11) NOT NULL DEFAULT '-1',
  `sendernumber` int(11) NOT NULL DEFAULT '0',
  `receiver` varchar(24) DEFAULT NULL,
  `receiverid` int(11) NOT NULL DEFAULT '-1',
  `receivernumber` int(11) NOT NULL DEFAULT '0',
  `message` varchar(128) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sobeitkicks`
--

CREATE TABLE IF NOT EXISTS `sobeitkicks` (
  `sqlID` int(11) NOT NULL DEFAULT '0',
  `Kicks` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`sqlID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `speed_cameras`
--

CREATE TABLE IF NOT EXISTS `speed_cameras` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `pos_x` float(10,5) NOT NULL,
  `pos_y` float(10,5) NOT NULL,
  `pos_z` float(10,5) NOT NULL,
  `rotation` float(10,5) NOT NULL,
  `range` float(10,5) NOT NULL,
  `speed_limit` float(10,5) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Contains data regarding speed cameras.';

-- --------------------------------------------------------

--
-- Table structure for table `tables_priv`
--

CREATE TABLE IF NOT EXISTS `tables_priv` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Table_name` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Grantor` char(77) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Table_priv` set('Select','Insert','Update','Delete','Create','Drop','Grant','References','Index','Alter','Create View','Show view','Trigger') CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Column_priv` set('Select','Insert','Update','References') CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`Host`,`Db`,`User`,`Table_name`),
  KEY `Grantor` (`Grantor`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table privileges';

-- --------------------------------------------------------

--
-- Table structure for table `text_labels`
--

CREATE TABLE IF NOT EXISTS `text_labels` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `time_zone`
--

CREATE TABLE IF NOT EXISTS `time_zone` (
  `Time_zone_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Use_leap_seconds` enum('Y','N') NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Time_zone_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Time zones';

-- --------------------------------------------------------

--
-- Table structure for table `time_zone_leap_second`
--

CREATE TABLE IF NOT EXISTS `time_zone_leap_second` (
  `Transition_time` bigint(20) NOT NULL DEFAULT '0',
  `Correction` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Transition_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Leap seconds information for time zones';

-- --------------------------------------------------------

--
-- Table structure for table `time_zone_name`
--

CREATE TABLE IF NOT EXISTS `time_zone_name` (
  `Name` char(64) NOT NULL DEFAULT '',
  `Time_zone_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Time zone names';

-- --------------------------------------------------------

--
-- Table structure for table `time_zone_transition`
--

CREATE TABLE IF NOT EXISTS `time_zone_transition` (
  `Time_zone_id` int(10) unsigned NOT NULL DEFAULT '0',
  `Transition_time` bigint(20) NOT NULL DEFAULT '0',
  `Transition_type_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Time_zone_id`,`Transition_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Time zone transitions';

-- --------------------------------------------------------

--
-- Table structure for table `time_zone_transition_type`
--

CREATE TABLE IF NOT EXISTS `time_zone_transition_type` (
  `Time_zone_id` int(10) unsigned NOT NULL DEFAULT '0',
  `Transition_type_id` int(10) unsigned NOT NULL DEFAULT '0',
  `Offset` int(11) NOT NULL DEFAULT '0',
  `Is_DST` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Abbreviation` char(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`Time_zone_id`,`Transition_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Time zone transition types';

-- --------------------------------------------------------

--
-- Table structure for table `tokens_call`
--

CREATE TABLE IF NOT EXISTS `tokens_call` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `hour` int(2) DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tokens_report`
--

CREATE TABLE IF NOT EXISTS `tokens_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `hour` time DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tokens_request`
--

CREATE TABLE IF NOT EXISTS `tokens_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `hour` time DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tokens_wd`
--

CREATE TABLE IF NOT EXISTS `tokens_wd` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `hour` time DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tournaments`
--

CREATE TABLE IF NOT EXISTS `tournaments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Contestants` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '-1|-1|-1|-1|-1|-1|-1|-1|-1|-1|-1|-1|-1|-1|-1|-1',
  `QuarterFinals` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '-1|-1|-1|-1|-1|-1|-1|-1',
  `SemiFinals` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '-1|-1|-1|-1',
  `Finals` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '-1|-1',
  `Winner` int(11) NOT NULL DEFAULT '-1',
  `Tournament` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'Tournament Name',
  `active` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `toys`
--

CREATE TABLE IF NOT EXISTS `toys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `modelid` int(11) NOT NULL,
  `bone` int(11) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `rotx` float NOT NULL,
  `roty` float NOT NULL,
  `rotz` float NOT NULL,
  `scalex` float NOT NULL,
  `scaley` float NOT NULL,
  `scalez` float NOT NULL,
  `tradable` int(11) NOT NULL DEFAULT '0',
  `special` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `track_backdoor`
--

CREATE TABLE IF NOT EXISTS `track_backdoor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `door_id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `track_gate`
--

CREATE TABLE IF NOT EXISTS `track_gate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `gate_id` int(11) NOT NULL,
  `gate_move` int(1) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `track_gvip`
--

CREATE TABLE IF NOT EXISTS `track_gvip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `vipm` int(11) NOT NULL,
  `renewal` int(1) NOT NULL,
  `gift` int(1) NOT NULL,
  `expiration` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `track_house`
--

CREATE TABLE IF NOT EXISTS `track_house` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `house_move` int(2) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `track_pvip`
--

CREATE TABLE IF NOT EXISTS `track_pvip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `vipm` int(11) NOT NULL,
  `shop_email` varchar(128) NOT NULL,
  `restrict_veh` int(3) NOT NULL,
  `donate` int(11) NOT NULL DEFAULT '0',
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `track_ts`
--

CREATE TABLE IF NOT EXISTS `track_ts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `database_id` int(11) NOT NULL,
  `channel_name` varchar(128) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `track_vip`
--

CREATE TABLE IF NOT EXISTS `track_vip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `vip` int(1) NOT NULL,
  `order_id` varchar(11) NOT NULL,
  `vipm` int(11) NOT NULL,
  `expiration` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `turfs`
--

CREATE TABLE IF NOT EXISTS `turfs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'None|-1|0|0|12|0.000000|0.000000|0.000000|0.000000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Password` char(41) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `Select_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Insert_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Update_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Delete_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Drop_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Reload_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Shutdown_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Process_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `File_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Grant_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `References_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Index_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Alter_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Show_db_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Super_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_tmp_table_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Lock_tables_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Execute_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Repl_slave_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Repl_client_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_view_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Show_view_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_routine_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Alter_routine_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_user_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Event_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Trigger_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_tablespace_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `ssl_type` enum('','ANY','X509','SPECIFIED') CHARACTER SET utf8 NOT NULL DEFAULT '',
  `ssl_cipher` blob NOT NULL,
  `x509_issuer` blob NOT NULL,
  `x509_subject` blob NOT NULL,
  `max_questions` int(11) unsigned NOT NULL DEFAULT '0',
  `max_updates` int(11) unsigned NOT NULL DEFAULT '0',
  `max_connections` int(11) unsigned NOT NULL DEFAULT '0',
  `max_user_connections` int(11) unsigned NOT NULL DEFAULT '0',
  `plugin` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `authentication_string` text COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`Host`,`User`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and global privileges';

-- --------------------------------------------------------

--
-- Table structure for table `user_leaves`
--

CREATE TABLE IF NOT EXISTS `user_leaves` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `uid` varchar(9) NOT NULL,
  `date_leave` date NOT NULL,
  `date_return` date NOT NULL,
  `reason` varchar(512) NOT NULL,
  `status` int(9) NOT NULL,
  `accept_uid` int(9) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_notes`
--

CREATE TABLE IF NOT EXISTS `user_notes` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `uid` varchar(256) NOT NULL,
  `note` varchar(512) NOT NULL,
  `addDate` date NOT NULL,
  `invokeid` varchar(256) NOT NULL,
  `type` int(6) NOT NULL,
  `points` int(6) NOT NULL,
  `status` int(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE IF NOT EXISTS `vehicles` (
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
  `pvCrashFlag` int(11) NOT NULL,
  `pvCrashVW` int(11) NOT NULL,
  `pvCrashX` float NOT NULL,
  `pvCrashY` float NOT NULL,
  `pvCrashZ` float NOT NULL,
  `pvCrashAngle` float NOT NULL,
  `pvAlarm` int(11) NOT NULL DEFAULT '0',
  `pvLastLockPickedBy` varchar(24) NOT NULL DEFAULT 'Empty',
  `pvLocksLeft` int(11) NOT NULL DEFAULT '5',
  `pvHealth` float NOT NULL DEFAULT '1000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles2`
--

CREATE TABLE IF NOT EXISTS `vehicles2` (
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `watchdog_reports`
--

CREATE TABLE IF NOT EXISTS `watchdog_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reporter` int(11) NOT NULL DEFAULT '0',
  `report` text NOT NULL,
  `reported` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '1 = DM | 2 = Refer',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT 'Unix Timestamp',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `zombie`
--

CREATE TABLE IF NOT EXISTS `zombie` (
  `id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `zombieheals`
--

CREATE TABLE IF NOT EXISTS `zombieheals` (
  `id` int(11) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `zombiekills`
--

CREATE TABLE IF NOT EXISTS `zombiekills` (
  `id` int(11) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
