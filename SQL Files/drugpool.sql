-- phpMyAdmin SQL Dump
-- version 4.4.1.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 12, 2015 at 06:09 AM
-- Server version: 5.5.44
-- PHP Version: 5.6.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ngrp_main`
--

-- --------------------------------------------------------

--
-- Table structure for table `drugpool`
--

CREATE TABLE IF NOT EXISTS `drugpool` (
  `id` int(11) NOT NULL,
  `drugid` int(11) NOT NULL DEFAULT '-1',
  `quality` int(11) NOT NULL DEFAULT '0',
  `DBID` int(11) NOT NULL DEFAULT '-1',
  `name` varchar(32) NOT NULL DEFAULT 'None',
  `timestamp` int(11) NOT NULL DEFAULT '0',
  `spawned` int(11) NOT NULL DEFAULT '0',
  `posx` float NOT NULL DEFAULT '0',
  `posy` float NOT NULL DEFAULT '0',
  `posz` float NOT NULL DEFAULT '0',
  `vw` int(11) NOT NULL DEFAULT '0',
  `int` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
