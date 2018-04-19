<?php
	/****************************************************************************/
	/* Fichier de Traitement 													*/
	/****************************************************************************/
	include('config.php');
	
	/**
	 * ressource connect_ftp ( string $host , string $user , string $password )
	 * connect_ftp() opens a FTP connection to the specified host.
	 * Return : a FTP stream on success or FALSE on error
	 */
	function connect_ftp() 
	{
		// Mise en place d'une connexion FTP
		$session = ftp_connect(hostftp) or die("Impossible de se connecter au serveur $ftp_server");
		
		// Tentative d'identification
		if ($login = @ftp_login($session, loginftp, passftp)) {
			//echo "Connecté en tant que ".loginftp."@".hostftp."\n";
		} else {
			//echo "Connexion impossible en tant que ".loginftp."\n";
		}
		return !$login ? FALSE : $session;
	}
	 
	/**
	 * bool upload_ftp ( ressource $ftp_stream, array $file [, string $upload_dir = FALSE] )
	 * upload_file() puts a local file to the specified FTP server.
	 * Return : TRUE on success or FALSE on failure
	 */
	function upload_ftp($ftp_stream, $file, $filesource, $upload_dir = FALSE) 
	{
		$file = "tickets_appels.zip";
		$destination = './tmp/dumpTickets/'. $file;
		if (!copy($filesource, $destination))
		{
			return false;
		}
		else
		{
			return true;
		}
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="/css/accueil.css" rel="stylesheet" title="Style" />
		<title>MAJ DUMP TICKETS</title>
	</head>
	<body>
		
		<form method="post" enctype="multipart/form-data" action="index.php">
			<table align= "center"  style="border: medium solid #000000">
				<td><font size=3 align="left"><b>Sélectionnez votre archive en ".zip":</b></font></td>
				<td align="left"><input type="file" name="dumpTickets" value="myValue" multiple="multiple"></td>
				<td align="left"><input type="submit" value="Importer" name="importer"></td>
			</table>
		</form>
		<?php
		error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING ^ E_DEPRECATED);
		connectMaBase();
		// Demande d'injection du Dump
		if(array_key_exists('dumpTickets',$_FILES))
		{
			if(substr($_FILES['dumpTickets']['name'],-3)=='zip')
			{
				if(is_numeric(strpos($_FILES['dumpTickets']['name'],'tickets_appels')))
				{
					// Création de la table historique des DUMP si inexistante
					$sqls = "CREATE TABLE IF NOT EXISTS date_maj_dump (dmd_id SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identifiant d\'import',dmd_filename VARCHAR(50) NOT NULL COMMENT 'Nom du fichier d\'import',dmd_date_start DATETIME NOT NULL COMMENT 'Date du début de l\'import',dmd_date_finish DATETIME DEFAULT NULL COMMENT 'Date de fin de l\'import',PRIMARY KEY (dmd_id)) ENGINE=InnoDB  DEFAULT CHARSET=utf8;";
					$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
					// Sauvegarde de la date de début
					$sqls = "INSERT INTO date_maj_dump (dmd_filename,dmd_date_start) VALUES ('".$_FILES['dumpTickets']['name']."',NOW());";
					$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
					
					// Transfert du fichier
					if($ftp_stream = connect_ftp()) 
					{
						//echo $ftp_stream.'<br/>';
						
						if(upload_ftp($ftp_stream, $_FILES['dumpTickets']['name'], $_FILES['dumpTickets']['tmp_name'], './tmp/dumpTickets')) 
						{
							// Transfert de l'archive vers le serveur OK
							$output=shell_exec('./tmp/dumpTickets/Query/ticket.sh');
							echo $output;
							
							$sqls = "UPDATE tickets_appels SET date_appel = str_to_date( date_appel, '%d/%m/%Y')";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							
							//SELECT * FROM tickets_appels WHERE `date_appel` > '2012-02-14'
							
							//SELECT * FROM tickets_appels WHERE `type_appel` like '%sms%' or `type_appel` like '%mms%' or `type_appel` like '%data%' or `type_appel` like '%3G%'
							
							/* Création de la Vue "tickets_sms" */ 
							$sqls = "DROP VIEW IF EXISTS tickets_sms";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							$sqls = "CREATE VIEW tickets_sms AS 
										SELECT * 
										FROM tickets_appels 
										WHERE type_appel like '%sms%' 
										OR type_appel like '%mms%'";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							
							/* Création de la Vue "tickets_data" */ 
							$sqls = "DROP VIEW IF EXISTS tickets_data";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							$sqls = "CREATE VIEW tickets_data AS 
										SELECT * 
										FROM tickets_appels 
										WHERE type_appel like '%data%' 
										OR type_appel like '%3G%'
										AND heure_appel > '18:00:00' 
										AND heure_appel > '08:00:00'";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							
							/* Création de la Vue "tickets_voix" */ 
							$sqls = "DROP VIEW IF EXISTS tickets_voix";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							$sqls = "CREATE VIEW tickets_voix AS 
										SELECT * 
										FROM tickets_appels 
										WHERE type_appel NOT like '%data%' 
										AND type_appel NOT like '%3G%'
										AND type_appel NOT like '%sms%' 
										AND type_appel NOT like '%mms%'
										AND date_appel > '2012-02-14'";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							
							// Convertion de la Durée Réelle en secondes
							$sqls = "UPDATE tickets_voix SET duree_reelle = TIME_TO_SEC(duree_reelle)";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							
							//$dateToday = date("d/m/Y");
							//mysql_query("UPDATE TABLEINFO SET INFORMATIONS  = '$dateToday' WHERE ID_INFO  = 1");
							echo '<br/>---------------------------------<br/>';
							
							/* Traitement de la Question 2.1 */
							$sqls = "SELECT SUM(duree_reelle) AS TempSecondes FROM tickets_voix";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							if(mysql_num_rows($reqs)<>0)
							{
								$resul=mysql_fetch_object($reqs);
								$dureeglobale = format_temps($resul->TempSecondes);
								echo '<li>Durée totale réelle des appels effectués après le 15/02/2012 (inclus) : '.$resul->TempSecondes.' en secondes soit \r\n'.$dureeglobale['semaine'].' semaines '.
										$dureeglobale['jour'].' jours '.$dureeglobale['heure'].' heures '.$dureeglobale['minute'].' minutes '.$dureeglobale['seconde'].' secondes </li><br/>';
							}
							
							echo '<br/>---------------------------------<br/>';
							
							/* Traitement de la Question 2.2 */
							//WHERE ta.numero_abonne = 25233218
							$sqls = "SELECT DISTINCT ta.numero_abonne, 
										(	SELECT SUM(td.duree_facture) 
											FROM tickets_data as td 
											WHERE td.numero_abonne = ta.numero_abonne 
											group by td.numero_abonne) AS VolumeData 
										FROM tickets_appels AS ta
										
										ORDER BY VolumeData DESC
										LIMIT 10";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							while($resul=mysql_fetch_array($reqs))
							{
								$tabts[]=$resul;
							}
							echo '<br/>';
							echo '<li>TOP 10 des volumes data facturés en dehors de la tranche horaire 8h00-18h00, par Abonné :</li><br/>';
							foreach($tabts AS $keyts=>$valts)
							{
								echo 'Abonné : '.$valts['numero_abonne'].' - volume facturé de data : '.$valts['VolumeData'].'<br/>';
							}

							echo '<br/>---------------------------------<br/>';
							
							/* Traitement Question 2.3 */
							$sqls = "SELECT COUNT(ta_id) AS NbSMS 
										FROM tickets_sms 
										WHERE type_appel like '%envoi%sms%'";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							
							if(mysql_num_rows($reqs)<>0)
							{
								$resul=mysql_fetch_object($reqs);
								echo '<li>Quantité totale de SMS envoyés par l\'ensemble des abonnés : '.$resul->NbSMS.'</li><br/>';
							}
							$sqls = "SELECT COUNT(ta_id) AS NbMMS 
										FROM tickets_sms 
										WHERE type_appel like '%envoi%mms%'";
							$reqs = mysql_query($sqls)or die('Erreur SQL !<br />'.$sqls.'<br />'.mysql_error());
							
							if(mysql_num_rows($reqs)<>0)
							{
								$resul=mysql_fetch_object($reqs);
								echo '<li>Quantité totale de MMS envoyés par l\'ensemble des abonnés : '.$resul->NbMMS.'</li><br/>';
							}
						}
						else
						{ 
							// Transfert de l'archive vers le serveur KO
							?>
							<script language="JavaScript">
								alert("Problème de transfert de l'archive vers le serveur. Merci de contacter votre administrateur.");
							</script>
							<?php
						}
					}
					else
					{
						echo "La connexion FTP a échoué !";
					}
				}
				else
				{
					?>
					<script language="JavaScript">
						alert("Le nom de l'archive est incorrect.");
					</script>
					<?php
				}
			}
			else
			{
				?>
				<script language="JavaScript">
					alert("L'archive que vous essayez d'importer n'est pas au format zip.");
				</script>
				<?php
			}
		}
		?>
	</body>
</html>