/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50545
Source Host           : localhost:3306
Source Database       : samp

Target Server Type    : MYSQL
Target Server Version : 50545
File Encoding         : 65001

Date: 2016-01-17 01:47:13
*/

SET FOREIGN_KEY_CHECKS=0;

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
  `vObjectText1` varchar(255) DEFAULT NULL,
  `vObjectMatSize1` int(3) NOT NULL DEFAULT '90',
  `vObjectFont1` varchar(255) NOT NULL DEFAULT 'Arial',
  `vObjectSize1` int(3) NOT NULL DEFAULT '24',
  `vObjectColor1` mediumint(8) unsigned NOT NULL DEFAULT '1',
  `vObjectBGColor1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `vAttachedObjectModel2` int(11) NOT NULL DEFAULT '65535',
  `vObjectX2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectY2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectZ2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRX2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRY2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRZ2` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectText2` varchar(255) DEFAULT NULL,
  `vObjectMatSize2` int(3) NOT NULL DEFAULT '90',
  `vObjectFont2` varchar(255) NOT NULL DEFAULT 'Arial',
  `vObjectSize2` int(3) NOT NULL DEFAULT '24',
  `vObjectColor2` mediumint(8) unsigned NOT NULL DEFAULT '1',
  `vObjectBGColor2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `vAttachedObjectModel3` int(11) NOT NULL DEFAULT '65535',
  `vObjectX3` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectY3` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectZ3` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRX3` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRY3` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRZ3` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectText3` varchar(255) DEFAULT NULL,
  `vObjectMatSize3` int(3) NOT NULL DEFAULT '90',
  `vObjectFont3` varchar(255) NOT NULL DEFAULT 'Arial',
  `vObjectSize3` int(3) NOT NULL DEFAULT '24',
  `vObjectColor3` mediumint(8) unsigned NOT NULL DEFAULT '1',
  `vObjectBGColor3` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `vAttachedObjectModel4` int(11) NOT NULL DEFAULT '65535',
  `vObjectX4` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectY4` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectZ4` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRX4` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRY4` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectRZ4` float(11,2) NOT NULL DEFAULT '0.00',
  `vObjectText4` varchar(255) DEFAULT NULL,
  `vObjectMatSize4` int(3) NOT NULL DEFAULT '90',
  `vObjectFont4` varchar(255) NOT NULL DEFAULT 'Arial',
  `vObjectSize4` int(3) NOT NULL DEFAULT '24',
  `vObjectColor4` mediumint(8) unsigned NOT NULL DEFAULT '1',
  `vObjectBGColor4` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `vVW` int(11) NOT NULL DEFAULT '0',
  `vInt` int(11) NOT NULL DEFAULT '0',
  `fID` int(11) NOT NULL DEFAULT '0',
  `rID` int(11) NOT NULL DEFAULT '0',
  `vSiren` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=700 DEFAULT CHARSET=latin1;
