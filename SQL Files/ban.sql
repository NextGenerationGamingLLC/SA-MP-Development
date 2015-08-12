/*
 Navicat Premium Data Transfer

 Source Server         : NGG
 Source Server Type    : MySQL
 Source Server Version : 50625
 Source Host           : samp.ng-gaming.net
 Source Database       : samp_beta

 Target Server Type    : MySQL
 Target Server Version : 50625
 File Encoding         : utf-8

 Date: 08/10/2015 13:36:49 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `ban`
-- ----------------------------
DROP TABLE IF EXISTS `ban`;
CREATE TABLE `ban` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bannedid` int(11) NOT NULL,
  `creatorid` int(11) NOT NULL,
  `IP` varchar(17) NOT NULL,
  `reason` varchar(128) NOT NULL,
  `createdate` int(11) NOT NULL,
  `liftdate` int(11) NOT NULL,
  `active` int(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS = 1;
