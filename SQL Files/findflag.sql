-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jun 28, 2017 at 05:20 PM
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
-- Table structure for table `findflag`
--

CREATE TABLE IF NOT EXISTS `findflag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Model` int(11) NOT NULL DEFAULT '19306',
  `PosX` float(20,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(20,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(20,5) NOT NULL DEFAULT '0.00000',
  `Vw` int(11) NOT NULL DEFAULT '0',
  `Int` int(11) NOT NULL DEFAULT '0',
  `Spawn` int(11) NOT NULL DEFAULT '-1',
  `TagID` int(11) NOT NULL DEFAULT '1',
  `Tags` int(11) NOT NULL DEFAULT '0',
  `Time` int(11) NOT NULL DEFAULT '0',
  `Active` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `findflag`
--

INSERT INTO `findflag` (`id`, `Model`, `PosX`, `PosY`, `PosZ`, `Vw`, `Int`, `Spawn`, `TagID`, `Tags`, `Time`, `Active`) VALUES
(1, 19306, 0.00000, 0.00000, 0.00000, 0, 0, 0, 0, 0, 0, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
