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
CREATE TABLE IF NOT EXISTS `dynpoints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pointname` varchar(24) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `posx` float(20,5) NOT NULL,
  `posy` float(20,5) NOT NULL,
  `posz` float(20,5) NOT NULL,
  `pos2x` float(20,5) NOT NULL,
  `pos2y` float(20,5) NOT NULL,
  `pos2z` float(20,5) NOT NULL,
  `vw` int(11) NOT NULL DEFAULT '0',
  `int` int(11) NOT NULL DEFAULT '0',
  `vw2` int(11) NOT NULL DEFAULT '0',
  `int2` int(11) NOT NULL DEFAULT '0',
  `boatonly` int(11) NOT NULL DEFAULT '0',
  `ready` int(11) NOT NULL DEFAULT '0',
  `capturename` varchar(24) DEFAULT 'N/A',
  `capturegroup` int(11) NOT NULL DEFAULT '-1',
  `locked` int(11) NOT NULL DEFAULT '1',
  `timer` int(11) NOT NULL DEFAULT '0',
  `amounthour` int(11) NOT NULL DEFAULT '0',
  `amount0` int(11) NOT NULL DEFAULT '0',
  `amount1` int(11) NOT NULL DEFAULT '0',
  `amount2` int(11) NOT NULL DEFAULT '0',
  `amount3` int(11) NOT NULL DEFAULT '0',
  `amount4` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;

--
-- Dumping data for table `dynpoints`
--

INSERT INTO `dynpoints` (`id`, `pointname`, `type`, `posx`, `posy`, `posz`, `pos2x`, `pos2y`, `pos2z`, `vw`, `int`, `vw2`, `int2`, `boatonly`, `ready`, `capturename`, `capturegroup`, `locked`, `timer`, `amounthour`, `amount0`, `amount1`, `amount2`, `amount3`, `amount4`) VALUES
(1, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(2, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(3, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(4, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(5, NULL, 0, 0.00000, 0.00000, 13.55469, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(6, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(7, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(8, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(9, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(10, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(11, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(12, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(13, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(14, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(15, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(16, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(17, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(18, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(19, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0),
(20, NULL, 0, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 1, 'N/A', -1, 1, 0, 0, 0, 0, 0, 0, 0);