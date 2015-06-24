-- phpMyAdmin SQL Dump
-- version 4.3.11
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Gegenereerd op: 31 mei 2015 om 22:49
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
-- Tabelstructuur voor tabel `gCrates`
--

CREATE TABLE IF NOT EXISTS `gCrates` (
  `iCrateID` int(11) NOT NULL,
  `iGroupID` int(11) NOT NULL,
  `9mm` int(11) NOT NULL,
  `sdpistol` int(11) NOT NULL,
  `deagle` int(11) NOT NULL,
  `uzi` int(11) NOT NULL,
  `tec9` int(11) NOT NULL,
  `mp5` int(11) NOT NULL,
  `m4` int(11) NOT NULL,
  `ak47` int(11) NOT NULL,
  `rifle` int(11) NOT NULL,
  `sniper` int(11) NOT NULL,
  `shotty` int(11) NOT NULL,
  `sawnoff` int(11) NOT NULL,
  `spas` int(11) NOT NULL,
  `ammo0` int(11) NOT NULL,
  `ammo1` int(11) NOT NULL,
  `ammo2` int(11) NOT NULL,
  `ammo3` int(11) NOT NULL,
  `ammo4` int(11) NOT NULL,
  `pot` int(11) NOT NULL,
  `crack` int(11) NOT NULL,
  `heroin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `gCrates`
--
ALTER TABLE `gCrates`
  ADD PRIMARY KEY (`iCrateID`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
