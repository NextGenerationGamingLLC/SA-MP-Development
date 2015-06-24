-- phpMyAdmin SQL Dump
-- version 4.3.11
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Gegenereerd op: 02 jun 2015 om 18:27
-- Serverversie: 5.6.24
-- PHP-versie: 5.6.8

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
-- Tabelstructuur voor tabel `safes`
--

CREATE TABLE IF NOT EXISTS `safes` (
  `safeDBID` int(11) NOT NULL,
  `safeType` int(11) NOT NULL DEFAULT '0',
  `safeTypeID` int(11) NOT NULL DEFAULT '-1',
  `safeModel` int(3) NOT NULL DEFAULT '0',
  `safeMoney` int(11) NOT NULL DEFAULT '0',
  `safeVW` int(11) NOT NULL DEFAULT '0',
  `safeInt` int(11) NOT NULL DEFAULT '0',
  `safePosX` float NOT NULL DEFAULT '0',
  `safePosY` float NOT NULL DEFAULT '0',
  `safePosZ` float NOT NULL DEFAULT '0',
  `safeRotX` float NOT NULL DEFAULT '0',
  `safeRotY` float NOT NULL DEFAULT '1',
  `safeRotZ` float NOT NULL DEFAULT '0',
  `safePin` varchar(5) DEFAULT '0000',
  `safeRobbed` int(11) NOT NULL DEFAULT '0',
  `safeRobbedTime` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `safes`
--
ALTER TABLE `safes`
  ADD PRIMARY KEY (`safeDBID`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `safes`
--
ALTER TABLE `safes`
  MODIFY `safeDBID` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
