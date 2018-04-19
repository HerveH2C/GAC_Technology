#/bin/sh
date=`date "+%Y-%m-%d"`
#Test de la présence de l'archive
if [ -f "./tmp/dumpTickets/tickets_appels.zip" ];then

echo "<ul>";
echo "<li>MAJ en cours...</li>"

#EXTRACTION de l'archive
echo "<li>1- Extraction de l'archive tickets_appels</li>"
date +%d/%m/%y-%kh%M
unzip -oq ./tmp/dumpTickets/tickets_appels.zip -d ./tmp/dumpTickets/tickets_appels

#IMPORT des tables 
echo "<li>2- Création des tables </li>"
date +%d/%m/%y-%kh%M
/usr/bin/mysql< ./tmp/dumpTickets/Query/ocean_noindex.sql --host=mysql3.yulpa.io --user=145852_hervegac --password=5dbUYZqDNUvEvhCK --database=145852_gactechnology

#IMPORT des données des tables 
echo "<li>3- Import des tables </li>"
date +%d/%m/%y-%kh%M
/usr/bin/mysql --host=mysql3.yulpa.io --user=145852_hervegac --password=5dbUYZqDNUvEvhCK --database=145852_gactechnology<<EOFMYSQL
LOAD DATA LOCAL INFILE './tmp/dumpTickets/tickets_appels/tickets_appels_201202.csv' IGNORE INTO TABLE tickets_appels FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 3 LINES;
EOFMYSQL

#INDEXATION des tables
echo "<li>4- Indexation des tables</li>"
date +%d/%m/%y-%kh%M
/usr/bin/mysql< ./tmp/dumpTickets/Query/ocean_index.sql --host=mysql3.yulpa.io --user=145852_hervegac --password=5dbUYZqDNUvEvhCK --database=145852_gactechnology

#SUPPRESSION de l'archive
echo "<li>5- Suppression de l'archive tickets_appels</li>"
date +%d/%m/%y-%kh%M
rm -rf ./tmp/dumpTickets/tickets_appels.zip

#SUPPRESSION des fichiers CSV
echo "<li>6- Suppression du dossier tickets_appels</li>"
date +%d/%m/%y-%kh%M
rm -rf ./tmp/dumpTickets/tickets_appels

#SAUVEGARDE de la date de fin
/usr/bin/mysql --host=mysql3.yulpa.io --user=145852_hervegac --password=5dbUYZqDNUvEvhCK --database=gactechnology<<EOFMYSQL
UPDATE date_maj_dump SET dmd_date_finish=NOW() ORDER BY dmd_id DESC LIMIT 1;
EOFMYSQL

echo "<li>MAJ réalisée avec succès ;)</li>";
echo "</ul>";

else
echo "MAJ OCEAN NOK : Archive zip introuvable";
fi