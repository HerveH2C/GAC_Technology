-- phpMyAdmin SQL
-- Généré le: 19/04/2018 à 05:51:35
-- Par Hervé CARROTTE
--
USE `145852_gactechnology`;
-- --------------------------------------------------------
--
-- Suppression des tables
--
DROP TABLE IF EXISTS `tickets_appels`;
-- --------------------------------------------------------
--
-- Structure de la table `tickets_appels`
--
CREATE TABLE IF NOT EXISTS `tickets_appels` (
  `compte_facture` INT(8) UNSIGNED NOT NULL COMMENT 'Compte Facture',
  `numero_facture` INT(8) UNSIGNED NOT NULL COMMENT 'Numero Facture',
  `numero_abonne` INT(8) UNSIGNED NOT NULL COMMENT 'Numero abonne',
  `date_appel` VARCHAR(10)  DEFAULT NULL COMMENT 'Date',
  `heure_appel` VARCHAR(10) DEFAULT NULL COMMENT 'Heure',
  `duree_reelle` VARCHAR(10) DEFAULT NULL COMMENT 'Duree-volume reel',
  `duree_facture` VARCHAR(10) DEFAULT NULL COMMENT 'Duree-volume facture',
  `type_appel` VARCHAR(100) DEFAULT NULL COMMENT 'Type'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

