/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50621
Source Host           : localhost:3306
Source Database       : ngrpworking

Target Server Type    : MYSQL
Target Server Version : 50621
File Encoding         : 65001

Date: 2015-07-07 01:09:16
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `metaldetectors`
-- ----------------------------
DROP TABLE IF EXISTS `metaldetectors`;
CREATE TABLE `metaldetectors` (
  `id` int(11) NOT NULL,
  `posx` float(10,5) NOT NULL DEFAULT '0.00000',
  `posy` float(10,5) NOT NULL DEFAULT '0.00000',
  `posz` float(10,5) NOT NULL DEFAULT '0.00000',
  `rotx` float(10,5) NOT NULL DEFAULT '0.00000',
  `roty` float(10,5) NOT NULL DEFAULT '0.00000',
  `rotz` float(10,5) NOT NULL DEFAULT '0.00000',
  `vw` int(11) NOT NULL DEFAULT '0',
  `int` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of metaldetectors
-- ----------------------------
INSERT INTO `metaldetectors` VALUES ('0', '1531.83105', '-1710.58459', '12.38281', '0.00000', '0.00000', '0.00000', '0', '0');
INSERT INTO `metaldetectors` VALUES ('1', '1531.83105', '-1710.58459', '12.38281', '0.00000', '0.00000', '0.00000', '0', '0');
INSERT INTO `metaldetectors` VALUES ('4', '1531.83105', '-1710.58459', '12.38281', '0.00000', '0.00000', '0.00000', '0', '0');
INSERT INTO `metaldetectors` VALUES ('5', '1531.83105', '-1710.58459', '12.38281', '0.00000', '0.00000', '0.00000', '0', '0');
