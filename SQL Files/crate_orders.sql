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
-- Table structure for table `crate_orders`
--

CREATE TABLE IF NOT EXISTS `crate_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Facility` int(11) NOT NULL DEFAULT '-1',
  `Crates` int(11) NOT NULL DEFAULT '0',
  `PerCrate` int(11) NOT NULL DEFAULT '0',
  `OrderBy` varchar(25) NOT NULL DEFAULT 'Unknown',
  `Delivered` int(11) NOT NULL DEFAULT '0',
  `Status` int(11) NOT NULL DEFAULT '0',
  `Time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=41 ;

--
-- Dumping data for table `crate_orders`
--

INSERT INTO `crate_orders` (`id`, `Facility`, `Crates`, `PerCrate`, `OrderBy`, `Delivered`, `Status`, `Time`) VALUES
(1, -1, 1, 0, 'Unknown', 0, 0, 0),
(2, -1, 0, 0, 'Unknown', 0, 0, 0),
(3, -1, 10, 0, 'Unknown', 1, 1, 0),
(4, -1, 0, 0, 'Unknown', 0, 0, 0),
(5, -1, 0, 0, 'Unknown', 0, 0, 0),
(6, -1, 0, 0, 'Unknown', 0, 0, 0),
(7, -1, 0, 0, 'Unknown', 0, 0, 0),
(8, -1, 0, 0, 'Unknown', 0, 0, 0),
(9, -1, 0, 0, 'Unknown', 0, 0, 0),
(10, -1, 0, 0, 'Unknown', 0, 0, 0),
(11, -1, 0, 0, 'Unknown', 0, 0, 0),
(12, -1, 0, 0, 'Unknown', 0, 1, 0),
(13, -1, 0, 0, 'Unknown', 0, 0, 0),
(14, -1, 0, 0, 'Unknown', 0, 0, 0),
(15, -1, 0, 0, 'Unknown', 0, 0, 0),
(16, -1, 0, 0, 'Unknown', 0, 0, 0),
(17, -1, 0, 0, 'Unknown', 0, 0, 0),
(18, -1, 0, 0, 'Unknown', 0, 0, 0),
(19, -1, 0, 0, 'Unknown', 0, 0, 0),
(20, -1, 0, 0, 'Unknown', 0, 0, 0),
(21, -1, 0, 0, 'Unknown', 0, 0, 0),
(22, -1, 0, 0, 'Unknown', 0, 0, 0),
(23, -1, 0, 0, 'Unknown', 0, 0, 0),
(24, -1, 0, 0, 'Unknown', 0, 0, 0),
(25, -1, 0, 0, 'Unknown', 0, 0, 0),
(26, -1, 0, 0, 'Unknown', 0, 0, 0),
(27, -1, 0, 0, 'Unknown', 0, 0, 0),
(28, -1, 0, 0, 'Unknown', 0, 0, 0),
(29, -1, 0, 0, 'Unknown', 0, 0, 0),
(30, -1, 0, 0, 'Unknown', 0, 0, 0),
(31, -1, 0, 0, 'Unknown', 0, 0, 0),
(32, -1, 0, 0, 'Unknown', 0, 0, 0),
(33, -1, 0, 0, 'Unknown', 0, 0, 0),
(34, -1, 0, 0, 'Unknown', 0, 0, 0),
(35, -1, 0, 0, 'Unknown', 0, 0, 0),
(36, -1, 0, 0, 'Unknown', 0, 0, 0),
(37, -1, 0, 0, 'Unknown', 0, 0, 0),
(38, -1, 0, 0, 'Unknown', 0, 0, 0),
(39, -1, 0, 0, 'Unknown', 0, 0, 0),
(40, -1, 0, 0, 'Unknown', 0, 0, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
