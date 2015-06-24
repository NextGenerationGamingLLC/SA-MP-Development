/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50528
Source Host           : localhost:3306
Source Database       : test

Target Server Type    : MYSQL
Target Server Version : 50528
File Encoding         : 65001

Date: 2013-06-02 17:54:15
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `groups`
-- ----------------------------
DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Type` tinyint(4) NOT NULL DEFAULT '0',
  `Name` varchar(64) NOT NULL DEFAULT '',
  `MOTD` varchar(128) NOT NULL DEFAULT '',
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
  `CrimeType` int(11) NOT NULL DEFAULT '0',
  `gAmmo0` int(11) NOT NULL DEFAULT '0',
  `gAmmo1` int(11) NOT NULL DEFAULT '0',
  `gAmmo2` int(11) NOT NULL DEFAULT '0',
  `gAmmo3` int(11) NOT NULL DEFAULT '0',
  `gAmmo4` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of groups
-- ----------------------------
