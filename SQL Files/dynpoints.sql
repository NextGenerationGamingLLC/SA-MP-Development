/*
Navicat MySQL Data Transfer

Source Server         : Peak Gaming
Source Server Version : 50617
Source Host           : localhost:3306
Source Database       : ngrp

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2016-05-08 20:44:25
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dynpoints
-- ----------------------------
DROP TABLE IF EXISTS `dynpoints`;
CREATE TABLE `dynpoints` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `pointname` varchar(255) NOT NULL,
  `type` int(255) NOT NULL,
  `posx` float(20,5) NOT NULL,
  `posy` float(20,5) NOT NULL,
  `posz` float(20,5) NOT NULL,
  `pos2x` float(20,5) NOT NULL,
  `pos2y` float(20,5) NOT NULL,
  `pos2z` float(20,5) NOT NULL,
  `vw` int(255) NOT NULL,
  `vw2` int(255) NOT NULL,
  `capturable` int(255) NOT NULL,
  `captureplayername` varchar(255) NOT NULL,
  `playernamecapping` varchar(255) NOT NULL,
  `cappergroup` int(255) NOT NULL DEFAULT '-1',
  `cappergroupowned` int(255) NOT NULL DEFAULT '-1',
  `inactive` int(255) NOT NULL DEFAULT '1',
  `materials` int(255) NOT NULL,
  `timestamp1` int(255) NOT NULL,
  `timestamp2` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of dynpoints
-- ----------------------------
INSERT INTO `dynpoints` VALUES ('1', 'Materials Pickup 1', '0', '1423.87769', '-1319.38586', '13.55469', '2167.88696', '-2273.65161', '13.38234', '0', '0', '0', 'Jason', 'Jason', '-1', '19', '0', '500', '15', '-1');
INSERT INTO `dynpoints` VALUES ('2', 'Materials Pickup 2', '0', '2390.53979', '-2009.37781', '13.55370', '2287.68481', '-1106.71497', '37.97656', '0', '0', '0', 'Jason', 'Jason', '-1', '19', '0', '0', '15', '-1');
INSERT INTO `dynpoints` VALUES ('3', 'Materials Factory 1', '3', '2167.06226', '-2273.33887', '13.37262', '0.00000', '0.00000', '0.00000', '0', '0', '0', 'Jason', 'Jason', '-1', '19', '0', '0', '15', '-1');
INSERT INTO `dynpoints` VALUES ('4', 'Materials Factory 2', '3', '2288.05420', '-1104.90759', '38.31731', '0.00000', '0.00000', '0.00000', '0', '0', '0', 'Jason', 'Jason', '-1', '19', '0', '0', '15', '-1');
INSERT INTO `dynpoints` VALUES ('5', 'Drug House', '1', '2176.32959', '-1671.48743', '14.94541', '51.61081', '-285.93063', '1.28122', '0', '0', '0', 'Jason', 'Jason', '-1', '19', '0', '0', '15', '-1');
INSERT INTO `dynpoints` VALUES ('6', 'Crack Lab', '2', '2352.11133', '-1167.48218', '27.68519', '51.61081', '-285.93063', '1.28122', '0', '0', '0', 'Jason', 'Jason', '-1', '3', '0', '9999', '17', '-1');
INSERT INTO `dynpoints` VALUES ('7', 'San Fierro Docks', '3', '-1549.16870', '123.95258', '3.55469', '0.00000', '0.00000', '0.00000', '0', '0', '0', 'Jason', 'Jason', '-1', '19', '0', '6000', '15', '-1');
INSERT INTO `dynpoints` VALUES ('8', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('9', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('10', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('11', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('12', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('13', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('14', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('15', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('16', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('17', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('18', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('19', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
INSERT INTO `dynpoints` VALUES ('20', '', '0', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0.00000', '0', '0', '1', '', '', '-1', '-1', '1', '0', '0', '0');
