-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 09, 2017 at 04:17 AM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `samp_test`
--

-- --------------------------------------------------------

--
-- Table structure for table `crate_vehicles`
--

CREATE TABLE IF NOT EXISTS `crate_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vModel` int(11) NOT NULL DEFAULT '-1',
  `vColor1` int(11) NOT NULL DEFAULT '0',
  `vColor2` int(11) NOT NULL DEFAULT '0',
  `vPlate` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `vGroup` int(11) NOT NULL DEFAULT '-1',
  `vRank` int(11) NOT NULL DEFAULT '-1',
  `vSpawned` int(1) NOT NULL DEFAULT '1',
  `vDisabled` int(1) NOT NULL DEFAULT '0',
  `vImpound` int(1) NOT NULL DEFAULT '0',
  `vTickets` int(11) NOT NULL DEFAULT '0',
  `vMaxHealth` int(11) NOT NULL DEFAULT '1000',
  `vHealth` float NOT NULL DEFAULT '1000',
  `vFuel` int(11) NOT NULL DEFAULT '100',
  `vPosX` float(20,5) NOT NULL DEFAULT '0.00000',
  `vPosY` float(20,5) NOT NULL DEFAULT '0.00000',
  `vPosZ` float(20,5) NOT NULL DEFAULT '0.00000',
  `vRotZ` float(20,5) NOT NULL DEFAULT '0.00000',
  `vInt` int(11) NOT NULL DEFAULT '0',
  `vVw` int(11) NOT NULL DEFAULT '0',
  `vCrateMax` int(11) NOT NULL DEFAULT '0',
  `vCrate` int(11) NOT NULL DEFAULT '-1',
  `FirstDrop` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
