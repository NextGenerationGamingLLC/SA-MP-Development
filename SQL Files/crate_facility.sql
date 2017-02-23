-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 09, 2017 at 04:16 AM
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
-- Table structure for table `crate_facility`
--

CREATE TABLE IF NOT EXISTS `crate_facility` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(52) NOT NULL DEFAULT '----',
  `Group` int(11) NOT NULL DEFAULT '-1',
  `Posx` float(20,5) NOT NULL DEFAULT '0.00000',
  `Posy` float(20,5) NOT NULL DEFAULT '0.00000',
  `Posz` float(20,5) NOT NULL DEFAULT '0.00000',
  `Posr` float(20,5) NOT NULL DEFAULT '0.00000',
  `Int` int(11) NOT NULL DEFAULT '0',
  `Vw` int(11) NOT NULL DEFAULT '0',
  `Prodmax` int(11) NOT NULL DEFAULT '10',
  `ProdPrep` int(11) NOT NULL DEFAULT '0',
  `ProdReady` int(11) NOT NULL DEFAULT '0',
  `ProdTimer` int(11) NOT NULL DEFAULT '1',
  `ProdStatus` int(11) NOT NULL DEFAULT '1',
  `ProdCost` int(11) NOT NULL DEFAULT '0',
  `ProdMulti` int(11) NOT NULL DEFAULT '5',
  `RaidTimer` int(11) NOT NULL DEFAULT '0',
  `Cooldown` int(11) NOT NULL DEFAULT '0',
  `Raidable` int(1) NOT NULL DEFAULT '1',
  `Active` int(1) NOT NULL DEFAULT '0',
  `Timer` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `crate_facility`
--

INSERT INTO `crate_facility` (`id`, `Name`, `Group`, `Posx`, `Posy`, `Posz`, `Posr`, `Int`, `Vw`, `Prodmax`, `ProdPrep`, `ProdReady`, `ProdTimer`, `ProdStatus`, `ProdCost`, `ProdMulti`, `RaidTimer`, `Cooldown`, `Raidable`, `Active`, `Timer`) VALUES
(1, '---', -1, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 1, 0, 0),
(2, '---', -1, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0),
(3, '----', -1, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0),
(4, '---', -1, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0),
(5, '----', -1, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0),
(6, '----', -1, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0),
(7, '----', -1, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0),
(8, '----', -1, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0),
(9, '----', -1, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0),
(10, '----', -1, 0.00000, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
