<?php
	/********************************************************************************/
	/* Fichier de Configuration 													*/
	/********************************************************************************/
	
	//Identifiant FTP
	define('hostftp','ftp1.yulpa.io'); 										//Serveur
	define('loginftp','hervegac@gactechnology.hcconsulting.fr'); 			//Login
	define('passftp','!tgi4_iu4'); 											//Password
		
	//Définition des variables de connexion à la Base de Données
	define('host','mysql3.yulpa.io'); 				//Serveur
	define('login','145852_hervegac'); 				//Login
	define('pass','5dbUYZqDNUvEvhCK'); 				//Password
	define('database','145852_gactechnology'); 		//Base de Données
	//Fonction de connexion à la base de données "gactechnology"
	function connectMaBase()
	{
		error_reporting(E_ALL ^ E_NOTICE ^ E_DEPRECATED);
		$link = mysql_connect(host,login,pass) or die("Impossible de se connecter : ".mysql_error());
		mysql_select_db(database,$link) or die("base inconnue ou introuvable : ".mysql_error());
	}

	/*************************************************
	----------------Fonctions Générales---------------
	*************************************************/
	// Fonction de Suppression des Caractères Spéciaux
	function stripAccents($texte)
	{
		$texte = str_replace(
								array(
									'à', 'â', 'ä', 'á', 'ã', 'å',
									'î', 'ï', 'ì', 'í', 
									'ô', 'ö', 'ò', 'ó', 'õ', 'ø', 
									'ù', 'û', 'ü', 'ú', 
									'é', 'è', 'ê', 'ë', 
									'ç', 'ÿ', 'ñ',
									'À', 'Â', 'Ä', 'Á', 'Ã', 'Å',
									'Î', 'Ï', 'Ì', 'Í', 
									'Ô', 'Ö', 'Ò', 'Ó', 'Õ', 'Ø', 
									'Ù', 'Û', 'Ü', 'Ú', 
									'É', 'È', 'Ê', 'Ë', 
									'Ç', 'Ÿ', 'Ñ' 
								),
								array(
									'a', 'a', 'a', 'a', 'a', 'a', 
									'i', 'i', 'i', 'i', 
									'o', 'o', 'o', 'o', 'o', 'o', 
									'u', 'u', 'u', 'u', 
									'e', 'e', 'e', 'e', 
									'c', 'y', 'n', 
									'A', 'A', 'A', 'A', 'A', 'A', 
									'I', 'I', 'I', 'I', 
									'O', 'O', 'O', 'O', 'O', 'O', 
									'U', 'U', 'U', 'U', 
									'E', 'E', 'E', 'E', 
									'C', 'Y', 'N' 
								),$texte);
		return $texte;
	}
	
	// Fonction de Convertion de Secondes en Semaine/Jour/Heure/Minutes/Secondes
	function format_temps($sec) {
 		$semaines = floor($sec/604800);
		$reste=$sec%604800;
		$jours=floor($reste/86400);
		$reste=$reste%86400;
		$heures=floor($reste/3600);
		$reste=$reste%3600;
		$minutes=floor($reste/60);
		$secondes=$reste%60;
		return array(
						"seconde" => $secondes,
						"minute" => $minutes,
						"heure" => $heures,
						"jour" => $jours,
						"semaine" => $semaines,);
	}
?>