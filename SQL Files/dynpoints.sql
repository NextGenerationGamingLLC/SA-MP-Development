-- phpMyAdmin SQL Dump
-- version 4.4.1.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 12, 2015 at 06:11 AM
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
-- Table structure for table `dynpoints`
--

CREATE TABLE IF NOT EXISTS `dynpoints` (
  `id` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0',
  `name` varchar(32) NOT NULL DEFAULT 'Factory',
  `captureable` int(11) NOT NULL DEFAULT '1',
  `groupid` int(11) NOT NULL DEFAULT '0',
  `posx` float NOT NULL DEFAULT '0',
  `posy` float NOT NULL DEFAULT '0',
  `posz` float NOT NULL DEFAULT '0',
  `delposx` float NOT NULL DEFAULT '0',
  `delposy` float NOT NULL DEFAULT '0',
  `delposz` float NOT NULL DEFAULT '0',
  `vw` int(11) NOT NULL DEFAULT '0',
  `int` int(11) NOT NULL DEFAULT '0',
  `9mm` int(11) NOT NULL DEFAULT '0',
  `sdpistol` int(11) NOT NULL DEFAULT '0',
  `deagle` int(11) NOT NULL DEFAULT '0',
  `uzi` int(11) NOT NULL DEFAULT '0',
  `tec9` int(11) NOT NULL DEFAULT '0',
  `mp5` int(11) NOT NULL DEFAULT '0',
  `m4` int(11) NOT NULL DEFAULT '0',
  `ak47` int(11) NOT NULL DEFAULT '0',
  `rifle` int(11) NOT NULL DEFAULT '0',
  `sniper` int(11) NOT NULL DEFAULT '0',
  `shotty` int(11) NOT NULL DEFAULT '0',
  `sawnoff` int(11) NOT NULL DEFAULT '0',
  `spas` int(11) NOT NULL DEFAULT '0',
  `ammo0` int(11) NOT NULL DEFAULT '0',
  `ammo1` int(11) NOT NULL DEFAULT '0',
  `ammo2` int(11) NOT NULL DEFAULT '0',
  `ammo3` int(11) NOT NULL DEFAULT '0',
  `ammo4` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `dynpoints`
--
ALTER TABLE `dynpoints`
  ADD PRIMARY KEY (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
