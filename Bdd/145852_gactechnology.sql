-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Hôte : mysql3.yulpa.io
-- Généré le :  jeu. 19 avr. 2018 à 06:33
-- Version du serveur :  5.5.56-MariaDB-cll-lve
-- Version de PHP :  7.0.27-1~dotdeb+8.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `145852_gactechnology`
--

-- --------------------------------------------------------

--
-- Structure de la table `date_maj_dump`
--

CREATE TABLE `date_maj_dump` (
  `dmd_id` smallint(5) UNSIGNED NOT NULL COMMENT 'Identifiant d''import',
  `dmd_filename` varchar(50) NOT NULL COMMENT 'Nom du fichier d''import',
  `dmd_date_start` datetime NOT NULL COMMENT 'Date du dÃ©but de l''import',
  `dmd_date_finish` datetime DEFAULT NULL COMMENT 'Date de fin de l''import'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `tickets_appels`
--

CREATE TABLE `tickets_appels` (
  `ta_id` int(11) NOT NULL,
  `compte_facture` int(8) UNSIGNED NOT NULL COMMENT 'Compte Facture',
  `numero_facture` int(8) UNSIGNED NOT NULL COMMENT 'Numero Facture',
  `numero_abonne` int(8) UNSIGNED NOT NULL COMMENT 'Numero abonne',
  `date_appel` varchar(10) DEFAULT NULL COMMENT 'Date',
  `heure_appel` varchar(10) DEFAULT NULL COMMENT 'Heure',
  `duree_reelle` varchar(10) DEFAULT NULL COMMENT 'Duree-volume reel',
  `duree_facture` varchar(10) DEFAULT NULL COMMENT 'Duree-volume facture',
  `type_appel` varchar(100) DEFAULT NULL COMMENT 'Type'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `tickets_data`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `tickets_data` (
`ta_id` int(11)
,`compte_facture` int(8) unsigned
,`numero_facture` int(8) unsigned
,`numero_abonne` int(8) unsigned
,`date_appel` varchar(10)
,`heure_appel` varchar(10)
,`duree_reelle` varchar(10)
,`duree_facture` varchar(10)
,`type_appel` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `tickets_sms`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `tickets_sms` (
`ta_id` int(11)
,`compte_facture` int(8) unsigned
,`numero_facture` int(8) unsigned
,`numero_abonne` int(8) unsigned
,`date_appel` varchar(10)
,`heure_appel` varchar(10)
,`duree_reelle` varchar(10)
,`duree_facture` varchar(10)
,`type_appel` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `tickets_voix`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `tickets_voix` (
`ta_id` int(11)
,`compte_facture` int(8) unsigned
,`numero_facture` int(8) unsigned
,`numero_abonne` int(8) unsigned
,`date_appel` varchar(10)
,`heure_appel` varchar(10)
,`duree_reelle` varchar(10)
,`duree_facture` varchar(10)
,`type_appel` varchar(100)
);

-- --------------------------------------------------------

--
-- Structure de la vue `tickets_data`
--
DROP TABLE IF EXISTS `tickets_data`;

CREATE ALGORITHM=UNDEFINED DEFINER=`145852_hervegac`@`%` SQL SECURITY DEFINER VIEW `tickets_data`  AS  select `tickets_appels`.`ta_id` AS `ta_id`,`tickets_appels`.`compte_facture` AS `compte_facture`,`tickets_appels`.`numero_facture` AS `numero_facture`,`tickets_appels`.`numero_abonne` AS `numero_abonne`,`tickets_appels`.`date_appel` AS `date_appel`,`tickets_appels`.`heure_appel` AS `heure_appel`,`tickets_appels`.`duree_reelle` AS `duree_reelle`,`tickets_appels`.`duree_facture` AS `duree_facture`,`tickets_appels`.`type_appel` AS `type_appel` from `tickets_appels` where ((`tickets_appels`.`type_appel` like '%data%') or ((`tickets_appels`.`type_appel` like '%3G%') and (`tickets_appels`.`heure_appel` > '18:00:00') and (`tickets_appels`.`heure_appel` > '08:00:00'))) ;

-- --------------------------------------------------------

--
-- Structure de la vue `tickets_sms`
--
DROP TABLE IF EXISTS `tickets_sms`;

CREATE ALGORITHM=UNDEFINED DEFINER=`145852_hervegac`@`%` SQL SECURITY DEFINER VIEW `tickets_sms`  AS  select `tickets_appels`.`ta_id` AS `ta_id`,`tickets_appels`.`compte_facture` AS `compte_facture`,`tickets_appels`.`numero_facture` AS `numero_facture`,`tickets_appels`.`numero_abonne` AS `numero_abonne`,`tickets_appels`.`date_appel` AS `date_appel`,`tickets_appels`.`heure_appel` AS `heure_appel`,`tickets_appels`.`duree_reelle` AS `duree_reelle`,`tickets_appels`.`duree_facture` AS `duree_facture`,`tickets_appels`.`type_appel` AS `type_appel` from `tickets_appels` where ((`tickets_appels`.`type_appel` like '%sms%') or (`tickets_appels`.`type_appel` like '%mms%')) ;

-- --------------------------------------------------------

--
-- Structure de la vue `tickets_voix`
--
DROP TABLE IF EXISTS `tickets_voix`;

CREATE ALGORITHM=UNDEFINED DEFINER=`145852_hervegac`@`%` SQL SECURITY DEFINER VIEW `tickets_voix`  AS  select `tickets_appels`.`ta_id` AS `ta_id`,`tickets_appels`.`compte_facture` AS `compte_facture`,`tickets_appels`.`numero_facture` AS `numero_facture`,`tickets_appels`.`numero_abonne` AS `numero_abonne`,`tickets_appels`.`date_appel` AS `date_appel`,`tickets_appels`.`heure_appel` AS `heure_appel`,`tickets_appels`.`duree_reelle` AS `duree_reelle`,`tickets_appels`.`duree_facture` AS `duree_facture`,`tickets_appels`.`type_appel` AS `type_appel` from `tickets_appels` where ((not((`tickets_appels`.`type_appel` like '%data%'))) and (not((`tickets_appels`.`type_appel` like '%3G%'))) and (not((`tickets_appels`.`type_appel` like '%sms%'))) and (not((`tickets_appels`.`type_appel` like '%mms%'))) and (`tickets_appels`.`date_appel` > '2012-02-14')) ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `date_maj_dump`
--
ALTER TABLE `date_maj_dump`
  ADD PRIMARY KEY (`dmd_id`);

--
-- Index pour la table `tickets_appels`
--
ALTER TABLE `tickets_appels`
  ADD PRIMARY KEY (`ta_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `date_maj_dump`
--
ALTER TABLE `date_maj_dump`
  MODIFY `dmd_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identifiant d''import';

--
-- AUTO_INCREMENT pour la table `tickets_appels`
--
ALTER TABLE `tickets_appels`
  MODIFY `ta_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107972;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Hôte : mysql3.yulpa.io
-- Généré le :  jeu. 19 avr. 2018 à 06:33
-- Version du serveur :  5.5.56-MariaDB-cll-lve
-- Version de PHP :  7.0.27-1~dotdeb+8.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `145852_gactechnology`
--

-- --------------------------------------------------------

--
-- Structure de la table `date_maj_dump`
--

CREATE TABLE `date_maj_dump` (
  `dmd_id` smallint(5) UNSIGNED NOT NULL COMMENT 'Identifiant d''import',
  `dmd_filename` varchar(50) NOT NULL COMMENT 'Nom du fichier d''import',
  `dmd_date_start` datetime NOT NULL COMMENT 'Date du dÃ©but de l''import',
  `dmd_date_finish` datetime DEFAULT NULL COMMENT 'Date de fin de l''import'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `tickets_appels`
--

CREATE TABLE `tickets_appels` (
  `ta_id` int(11) NOT NULL,
  `compte_facture` int(8) UNSIGNED NOT NULL COMMENT 'Compte Facture',
  `numero_facture` int(8) UNSIGNED NOT NULL COMMENT 'Numero Facture',
  `numero_abonne` int(8) UNSIGNED NOT NULL COMMENT 'Numero abonne',
  `date_appel` varchar(10) DEFAULT NULL COMMENT 'Date',
  `heure_appel` varchar(10) DEFAULT NULL COMMENT 'Heure',
  `duree_reelle` varchar(10) DEFAULT NULL COMMENT 'Duree-volume reel',
  `duree_facture` varchar(10) DEFAULT NULL COMMENT 'Duree-volume facture',
  `type_appel` varchar(100) DEFAULT NULL COMMENT 'Type'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `tickets_data`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `tickets_data` (
`ta_id` int(11)
,`compte_facture` int(8) unsigned
,`numero_facture` int(8) unsigned
,`numero_abonne` int(8) unsigned
,`date_appel` varchar(10)
,`heure_appel` varchar(10)
,`duree_reelle` varchar(10)
,`duree_facture` varchar(10)
,`type_appel` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `tickets_sms`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `tickets_sms` (
`ta_id` int(11)
,`compte_facture` int(8) unsigned
,`numero_facture` int(8) unsigned
,`numero_abonne` int(8) unsigned
,`date_appel` varchar(10)
,`heure_appel` varchar(10)
,`duree_reelle` varchar(10)
,`duree_facture` varchar(10)
,`type_appel` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `tickets_voix`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `tickets_voix` (
`ta_id` int(11)
,`compte_facture` int(8) unsigned
,`numero_facture` int(8) unsigned
,`numero_abonne` int(8) unsigned
,`date_appel` varchar(10)
,`heure_appel` varchar(10)
,`duree_reelle` varchar(10)
,`duree_facture` varchar(10)
,`type_appel` varchar(100)
);

-- --------------------------------------------------------

--
-- Structure de la vue `tickets_data`
--
DROP TABLE IF EXISTS `tickets_data`;

CREATE ALGORITHM=UNDEFINED DEFINER=`145852_hervegac`@`%` SQL SECURITY DEFINER VIEW `tickets_data`  AS  select `tickets_appels`.`ta_id` AS `ta_id`,`tickets_appels`.`compte_facture` AS `compte_facture`,`tickets_appels`.`numero_facture` AS `numero_facture`,`tickets_appels`.`numero_abonne` AS `numero_abonne`,`tickets_appels`.`date_appel` AS `date_appel`,`tickets_appels`.`heure_appel` AS `heure_appel`,`tickets_appels`.`duree_reelle` AS `duree_reelle`,`tickets_appels`.`duree_facture` AS `duree_facture`,`tickets_appels`.`type_appel` AS `type_appel` from `tickets_appels` where ((`tickets_appels`.`type_appel` like '%data%') or ((`tickets_appels`.`type_appel` like '%3G%') and (`tickets_appels`.`heure_appel` > '18:00:00') and (`tickets_appels`.`heure_appel` > '08:00:00'))) ;

-- --------------------------------------------------------

--
-- Structure de la vue `tickets_sms`
--
DROP TABLE IF EXISTS `tickets_sms`;

CREATE ALGORITHM=UNDEFINED DEFINER=`145852_hervegac`@`%` SQL SECURITY DEFINER VIEW `tickets_sms`  AS  select `tickets_appels`.`ta_id` AS `ta_id`,`tickets_appels`.`compte_facture` AS `compte_facture`,`tickets_appels`.`numero_facture` AS `numero_facture`,`tickets_appels`.`numero_abonne` AS `numero_abonne`,`tickets_appels`.`date_appel` AS `date_appel`,`tickets_appels`.`heure_appel` AS `heure_appel`,`tickets_appels`.`duree_reelle` AS `duree_reelle`,`tickets_appels`.`duree_facture` AS `duree_facture`,`tickets_appels`.`type_appel` AS `type_appel` from `tickets_appels` where ((`tickets_appels`.`type_appel` like '%sms%') or (`tickets_appels`.`type_appel` like '%mms%')) ;

-- --------------------------------------------------------

--
-- Structure de la vue `tickets_voix`
--
DROP TABLE IF EXISTS `tickets_voix`;

CREATE ALGORITHM=UNDEFINED DEFINER=`145852_hervegac`@`%` SQL SECURITY DEFINER VIEW `tickets_voix`  AS  select `tickets_appels`.`ta_id` AS `ta_id`,`tickets_appels`.`compte_facture` AS `compte_facture`,`tickets_appels`.`numero_facture` AS `numero_facture`,`tickets_appels`.`numero_abonne` AS `numero_abonne`,`tickets_appels`.`date_appel` AS `date_appel`,`tickets_appels`.`heure_appel` AS `heure_appel`,`tickets_appels`.`duree_reelle` AS `duree_reelle`,`tickets_appels`.`duree_facture` AS `duree_facture`,`tickets_appels`.`type_appel` AS `type_appel` from `tickets_appels` where ((not((`tickets_appels`.`type_appel` like '%data%'))) and (not((`tickets_appels`.`type_appel` like '%3G%'))) and (not((`tickets_appels`.`type_appel` like '%sms%'))) and (not((`tickets_appels`.`type_appel` like '%mms%'))) and (`tickets_appels`.`date_appel` > '2012-02-14')) ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `date_maj_dump`
--
ALTER TABLE `date_maj_dump`
  ADD PRIMARY KEY (`dmd_id`);

--
-- Index pour la table `tickets_appels`
--
ALTER TABLE `tickets_appels`
  ADD PRIMARY KEY (`ta_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `date_maj_dump`
--
ALTER TABLE `date_maj_dump`
  MODIFY `dmd_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identifiant d''import';

--
-- AUTO_INCREMENT pour la table `tickets_appels`
--
ALTER TABLE `tickets_appels`
  MODIFY `ta_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107972;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
