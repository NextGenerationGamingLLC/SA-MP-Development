-- phpMyAdmin SQL Dump
-- version 4.4.1.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 12, 2015 at 06:06 AM
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
-- Table structure for table `blackmarkets`
--

CREATE TABLE IF NOT EXISTS `blackmarkets` (
  `id` int(11) NOT NULL DEFAULT '0',
  `groupid` int(11) NOT NULL DEFAULT '0',
  `seized` int(11) NOT NULL DEFAULT '0',
  `seizedtimestamp` int(11) NOT NULL DEFAULT '0',
  `posx` float NOT NULL DEFAULT '0',
  `posy` float NOT NULL DEFAULT '0',
  `posz` float NOT NULL DEFAULT '0',
  `delposx` float NOT NULL DEFAULT '0',
  `delposy` float NOT NULL DEFAULT '0',
  `delposz` float NOT NULL DEFAULT '0',
  `vw` int(11) NOT NULL DEFAULT '0',
  `int` int(11) NOT NULL DEFAULT '0',
  `mgseeds` int(11) NOT NULL DEFAULT '0',
  `canseeds` int(11) NOT NULL DEFAULT '0',
  `muriatic` int(11) NOT NULL DEFAULT '0',
  `lye` int(11) NOT NULL DEFAULT '0',
  `ethyl` int(11) NOT NULL DEFAULT '0',
  `ephedrine` int(11) NOT NULL DEFAULT '0',
  `diswater` int(11) DEFAULT '0',
  `opiumpop` int(11) NOT NULL DEFAULT '0',
  `lime` int(11) NOT NULL DEFAULT '0',
  `cocaineing` int(11) NOT NULL DEFAULT '0',
  `baking` int(11) NOT NULL DEFAULT '0',
  `cocextract` int(11) NOT NULL DEFAULT '0',
  `nbenzynol` int(11) NOT NULL DEFAULT '0',
  `pmkoil` int(11) NOT NULL DEFAULT '0',
  `mdmacrys` int(11) NOT NULL DEFAULT '0',
  `cafeine` int(11) NOT NULL DEFAULT '0',
  `mgseedsprice` int(11) NOT NULL DEFAULT '0',
  `canextractprice` int(11) NOT NULL DEFAULT '0',
  `muriaticprice` int(11) NOT NULL DEFAULT '0',
  `lyeprice` int(11) NOT NULL DEFAULT '0',
  `ethylprice` int(11) NOT NULL DEFAULT '0',
  `ephedrineprice` int(11) NOT NULL DEFAULT '0',
  `diswaterprice` int(11) NOT NULL DEFAULT '0',
  `opiumprice` int(11) NOT NULL DEFAULT '0',
  `limeprice` int(11) NOT NULL DEFAULT '0',
  `cocaineprice` int(11) NOT NULL DEFAULT '0',
  `bakingprice` int(11) NOT NULL DEFAULT '0',
  `cocextractprice` int(11) NOT NULL DEFAULT '0',
  `nbenzynolprice` int(11) NOT NULL DEFAULT '0',
  `pmkoilprice` int(11) NOT NULL DEFAULT '0',
  `mdmacrysprice` int(11) NOT NULL DEFAULT '0',
  `cafeineprice` int(11) NOT NULL DEFAULT '0',
  `mgseedspay` int(11) NOT NULL DEFAULT '0',
  `canseedspay` int(11) NOT NULL DEFAULT '0',
  `lyepay` int(11) NOT NULL DEFAULT '0',
  `ethylpay` int(11) NOT NULL DEFAULT '0',
  `ephedrinepay` int(11) NOT NULL DEFAULT '0',
  `diswaterpay` int(11) NOT NULL DEFAULT '0',
  `opiumpay` int(11) NOT NULL DEFAULT '0',
  `limepay` int(11) NOT NULL DEFAULT '0',
  `cocainepay` int(11) NOT NULL DEFAULT '0',
  `bakingpay` int(11) NOT NULL DEFAULT '0',
  `cocextractpay` int(11) NOT NULL DEFAULT '0',
  `nbenzynolpay` int(11) NOT NULL DEFAULT '0',
  `pmkoilpay` int(11) NOT NULL DEFAULT '0',
  `mdmacryspay` int(11) NOT NULL DEFAULT '0',
  `cafeinepay` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blackmarkets`
--
ALTER TABLE `blackmarkets`
  ADD PRIMARY KEY (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
