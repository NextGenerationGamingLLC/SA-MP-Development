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
-- Table structure for table `jobs_types`
--

CREATE TABLE IF NOT EXISTS `jobs_types` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `jobs_types`
--

INSERT INTO `jobs_types` (`id`, `name`) VALUES
(0, 'Tax Consultant'),
(1, 'Detective'),
(2, 'Lawyer'),
(3, 'Prostitute'),
(4, 'Drug Dealer'),
(5, 'Pimp'),
(6, '-----'),
(7, 'Mechanic'),
(8, 'Bodyguard'),
(9, 'Weapon Dealer'),
(10, '-----'),
(11, '-----'),
(12, 'Boxer'),
(13, '-----'),
(14, 'Smuggler'),
(15, 'Street Sweeper'),
(16, 'Ice Cream Man'),
(17, 'Taxi Driver'),
(18, 'Craftsman'),
(19, 'Bartender'),
(20, 'Shipment Contractor'),
(21, 'Pizzaboy'),
(24, 'Pilot'),
(25, 'Trashman'),
(28, 'Plumber');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jobs_types`
--
ALTER TABLE `jobs_types`
  ADD PRIMARY KEY (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
