#!/bin/bash

#
#  Questo file eseguibile e' parte del programma di contabilita' scritto e
#  mantenuto da Daniele Vallini del Gruppo Linux di Biella (BiLUG)
#
#   vallini.daniele@bilug.linux.it         www.bilug.it
#
#  Il programma e' stato curato e collaudato da tempo ma viene fornito
#  privo di qualsiasi garanzia poiche' e' compito dell' utilizzatore
#  verificarne l' adeguatezza alle proprie esigenze.
#
#  Il programma e' liberamente utilizzabile nei termini della licenza GPL3
#
#   http://www.gnu.org/licenses/gpl.txt
#
#  Il codice puo' essere liberamente modificato ed adattato ma questo
#  commento introduttivo deve essere mantenuto
#
#  E' gradita ogni forma di collaborazione segnalando commenti, sviluppi
#  ed integrazioni al Gruppo Linux di Biella - BiLUG


# colorazione con sequenze ANSI

nn="[0;0;01m"    # fondo nero
rr="[0;0;41m"    # fondo rosso
vv="[0;0;42m"    # fondo verde
gg="[0;0;43m"    # fondo giallo
bb="[0;0;44m"    # fondo blu
mm="[0;0;45m"    # fondo magenta
cc="[0;0;46m"    # fondo cyan

rn="[0;31;40m"   # rosso su nero
Rn="[1;31;40m"   # rosso grassetto su nero
vn="[0;32;40m"   # verde su nero
Vn="[1;32;40m"   # verde grassetto su nero
gn="[0;33;40m "  # giallo su nero
Gn="[1;33;40m"   # giallo grassetto su nero
bn="[0;34;40m"   # blu su nero  (cattiva visibilita')
Bn="[1;34;40m"   # blu grassetto su nero (cattiva visibilita')
mn="[0;35;40m"   # magenta su nero
Mn="[1;35;40m"   # magenta grassetto su nero
cn="[0;36;40m"   # cyan su nero
Cn="[1;36;40m"   # cyan grassetto su nero

z="[0m";         # normale

db=/home/cnt/cnt.db
sql=/home/cnt/sql

m() {
clear
echo "
$gn
          +------------------------------+
          |    CONTABILITA'  MAGAZZINO   |
          +------------------------------+
          | $Rn  (n) $gn   nuovo movimento    |
          | $Rn  (q) $gn   query              |
          | $Rn  (m) $gn   manutenzione       |
          +------------------------------+
$z"
read x
case $x in
n) mn;;
q) mq;;
m) mm;;
"<") /home/cnt/cnt1.sh;;
"<<") /home/cnt/cnt1.sh;;
esac
m
}

mm(){
echo "
$Rn   (a) $gn articoli
$Rn   (c) $gn codici operazione
$z"
read x
case $x in
a)    mma;;
c)    mmo;;
"<")  m;;
"<<") m;;
esac
mm
}

mma(){
echo $vn
echo "
SELECT idart, articolo AS '          articolo            '
FROM magart
ORDER BY idart;
" |  sqlite3  -header -column $db
echo "
$Rn   (e) $gn elimino articolo
$Rn   (n) $gn nuovo articolo
$z"
read x
case $x in
e)    mme;;
n)    mmn;;
"<")  mm;;
"<<") m;;
esac
mma
}

mmo(){
echo "
$gn   CODICI OPERAZIONE ESISTENTI
$vn"
echo "
.header ON
.mode column
.width 6 25
SELECT
idmov AS codice,
movime AS '   descrizione'
FROM magmov
ORDER BY idmov;
" | sqlite3 $db

echo "
$Rn (+) $gn creo nuovo codice operazione
$Rn (-) $gn elimino codice operazione esistente
$z"
read x
case $x in
"+") mmo+;;
"-") mmo-;;
"<") mm;;
"<<") m;;
esac
mmc
}

mmo+(){
echo "
$Rn >>> $gn immettere nuovo codice max 2 caratteri
$z"
read idmov
case $idmov in
"") mmo+;;
"<") mmo;;
"<<") m;;
esac
mmo+1
}

mmo+1(){
echo "
$gn      nuovo codice $rn $idmov
$Rn >>> $gn immettere descrizione codice max 25 caratteri
$z"
read movime
case $movime in
"") mmo+1;;
"<") mmo+;;
"<<") m;;
esac
mmo+2
}

mmo+2(){
echo "
$gn nuovo codice operazione $rn $idmov $gn descrizione $rn $movime


$Rn (+) $gn memorizzo nuovo codice e descrizione
$Rn (<) $gn abbandono la memorizzazione
$z"
read x
case $x in
"") mmo+2;;
"<") mmo+1;;
"<<") m;;
esac
echo "
INSERT INTO magmov
VALUES ('$idmov', '$movime');
" | sqlite3 $db
echo "
$mn   ------------------------------------------
$mn      ***   REGISTRAZIONE ESEGUITA   ***
$mn   ------------------------------------------
$z"
mmo
}

mmo-(){
echo "
$Rn >>> $gn immettere codice da eliminare
$z"
read idmov
case $idmov in
"") mmo-;;
"<") mmo;;
"<<") m;;
esac
echo $vn
echo "
.header ON
.mode column
.width 6 25
SELECT
idmov AS codice,
movime AS '   descrizione'
FROM magmov
WHERE idmov = '$idmov';
" | sqlite3 $db
mmo-1
}

mmo-1(){
echo "
$Rn (+) $gn elimino codice e descrizione
$Rn (<) $gn abbandono la memorizzazione
$z"
read x
case $x in
"+") mmo-2;;
"<") mmo-;;
"<<") m;;
esac
mmo-2
}

mmo-2(){
echo "
DELETE FROM magmov
WHERE idmov='$idmov';
" | sqlite3 $db
echo "
$mn   -----------------------------------------
$mn       ***   ELIMINAZIONE ESEGUITA   ***
$mn   -----------------------------------------
$z"
mmo
}

mme(){
echo "
$Rn   >>> $gn idart articolo
$z"
read idart
case $idart in
"")   mma;;
"<")  mm;;
"<<") m;;
esac
echo $vn
echo "SELECT * FROM magart WHERE idart='$idart';" | sqlite3 -header -column $db
echo
echo "SELECT * FROM magazzino WHERE idart='$idart';" | sqlite3 -header -column $db
echo
echo "SELECT SUM(quanti) AS Giacenza FROM magazzino WHERE idart='$idart';" | sqlite3 -line $db
mme1
}

mme1(){
echo "
$Rn   (+) $gn confermo eliminazione articolo $idart da tabella articoli
$z"
read x
case $x in
"+")  mme2;;
"")   mme1;;
"<")  mme;;
"<<") m;;
esac
}

mme2(){
echo "DELETE FROM magart WHERE idart='$idart';" | sqlite3 $db
echo "
$mm                 $Gn   articolo $idart eliminato   $mm                    $z"
mma
}

mmn(){
echo "
$mn ------------------------------------------------------------------------ $z
"
echo "
$Rn   >>>  $gn id articolo (idart)
$z"
read idart
case $idart in
"")   mmn;;
"<")  mm;;
"<<") m;;
esac
mmn1
}

mmn1(){
echo "
$mn ------------------------------------------------------------------------ $z
"
echo "
$Rn   >>>  $gn articolo
$z"
read articolo
case $articolo in
"")   mmn1;;
"<")  mmn;;
"<<") m;;
esac
mmn2
}

mmn2(){
echo "
$mn ------------------------------------------------------------------------ $z
"
echo "
$Rn   >>>  $gn unità di misura (unimis)
$z"
read unimis
case $unimis in
"")   mmn2;;
"<")  mmn1;;
"<<") m;;
esac
mmn3
}

mmn3(){
echo "
$mn ------------------------------------------------------------------------ $z
"
echo "
$Rn   >>>  $gn aliquota iva (aliva)
$z"
read aliva
case $aliva in
"")   mmn3;;
"<")  mmn2;;
"<<") m;;
esac
mmn4
}

mmn4(){
echo "
$mn ------------------------------------------------------------------------ $z
"
echo "
$Rn   >>>  $gn costo
$z"
read costo
case $costo in
"")   mmn4;;
"<")  mmn3;;
"<<") m;;
esac
mmn5
}

mmn5(){
echo "
$mn ------------------------------------------------------------------------ $z
"
echo "
$Rn   >>>  $gn listino ingrosso min (gros1)
$z"
read gros1
case $gros1 in
"")   mmn5;;
"<")  mmn4;;
"<<") m;;
esac
mmn6
}

mmn6(){
echo "
$mn ------------------------------------------------------------------------ $z
"
echo "
$Rn   >>>  $gn listino ingrosso max (gros2)
$z"
read gros2
case $gros2 in
"")   mmn6;;
"<")  mmn5;;
"<<") m;;
esac
mmn7
}

mmn7(){
echo "
$mn ------------------------------------------------------------------------ $z
"
echo "
$Rn   >>>  $gn listino minuto (minuto)
$z"
read minuto
case $minuto in
"")   mmn7;;
"<")  mmn6;;
"<<") m;;
esac
mmn8
}

mmn8(){
echo "
$mn ------------------------------------------------------------------------ $z
"
echo "
$gn   nuovo articolo da registrare:
   
 idart    = $idart
 articolo = $articolo
 unimis   = $unimis
 aliva    = $aliva
 costo    = $costo
 gros1    = $gros1
 gros2    = $gros2
 minuto   = $minuto
 
$Rn   (+)  $gn confermo registrazione
$z"
read $x
case $x in
"")   mmn8;;
"<")  mmn7;;
"<<") m;;
esac
mmn9
}

mmn9(){
echo "
$mn ------------------------------------------------------------------------ $vn
"
echo " INSERT INTO magart VALUES('$idart','$articolo','$unimis','$aliva','$costo','$gros1','$gros2','$minuto');" | sqlite3 $db
echo
echo "SELECT * FROM magart WHERE idart='$idart';" | sqlite3 -header -column $db
echo "
$mm               $Rn   REGISTRAZIONE COMPLETATA   $mm                            $z
"
mma
}











zmma(){
echo "  Creo tabella tmp e file /cnt/tmp

  modificare quindi chiudere l' editor
  Invio per continuare"
read x
case $x in
"<") mm;;
"<<") m;;
esac
echo > /cnt/sql "
;
DROP TABLE IF EXISTS tmp;
CREATE TABLE tmp (
id char(6) NOT NULL PRIMARY KEY,
descr char(26) NOT NULL,
um char(2),
aliqiva tinyint(2) unsigned);
INSERT tmp
SELECT *
FROM magart
ORDER BY id;
SELECT *
FROM tmp"
mysql cnt< /cnt/sql > /cnt/tmp
mcedit /cnt/tmp
echo > /cnt/sql "
;
RENAME TABLE magart TO magartold;
CREATE TABLE magart (
id char(6) NOT NULL PRIMARY KEY,
descr char(26) NOT NULL,
um char(2),
aliqiva tinyint(2) unsigned);
LOAD DATA INFILE '/cnt/tmp'
INTO TABLE magart;
SELECT *
FROM magart;
DROP TABLE IF EXISTS magartold;"
mysql cnt< /cnt/sql
echo "  AGGIORNAMENTO ESEGUITO
  Invio per continuare"
read x
m
}

zmmc(){
echo "  Creo tabella tmp e file /cnt/tmp

  modificare quindi chiudere l' editor
  Invio per continuare"
read x
case $x in
"<");;
0);;
esac
echo > /cnt/sql "
;
DROP TABLE IF EXISTS tmp;
CREATE TABLE tmp (
cod char(2) NOT NULL PRIMARY KEY,
nome char(20) NOT NULL);
INSERT tmp
SELECT *
FROM magmov
ORDER BY cod;
SELECT *
FROM tmp"
mysql cnt < /cnt/sql > /cnt/tmp
mcedit /cnt/tmp
echo > /cnt/sql "
;
RENAME TABLE magmov TO magmovold
CREATE TABLE magmov (
cod char(2) NOT NULL PRIMARY KEY,
nome char(20) NOT NULL);
LOAD DATA INFILE '/cnt/tmp'
INTO TABLE magmov;
SELECT *
FROM magmov;
DROP TABLE IF EXISTS magmovold;"
mysql cnt< /cnt/sql
echo "  AGGIORNAMENTO ESEGUITO
  Invio per continuare"
read x
g
}

mn() {
echo " 
$mn ------------------------------------------------------------------------ $vn
 
$Rn  >>> $gn data scrittura $vn (aammgg) 
 
      $gn default oggi $vn `date +%y%m%d-%A`$z 
"
read data
case $data in
"")   data=`date +%y%m%d`; mn1;;
"<")  m;;
"<<") m;;
esac
mn1
}     


mn1(){
echo "
$mn ------------------------------------------------------------------------ $vn

    data movimento  $data

$Rn   >>> $gn codice movimento
$z"	  
read idmov
case $idmov in
"")   mn1a;; 
"<")  mn;;
"<<") m;;
esac
movmag=$(echo "SELECT movime FROM magmov WHERE idmov='$idmov';" | sqlite3 $db)
mn2
}

mn1a(){
echo $vn
echo " SELECT idmov,movime FROM magmov ORDER BY idmov;" | sqlite3 -separator '	' $db
echo $z
mn1
}

mn2(){
echo "
$mn ------------------------------------------------------------------------ $vn

   data operazione    $data
   codice operazione  $idmov  $movmag
$z	  

$Rn   >>> $gn codice articolo
$z"	  
read idart
case $idart in
"")   mn2a;;
"<")  mn1;;
"<<") m;;
esac
echo > $sql "
SELECT *
FROM magazzino
WHERE idart='$idart'
ORDER BY data desc,idmov
limit 20;"
echo $vn
sqlite3 -column -header $db  < $sql
echo
echo > $sql "
SELECT
SUM(magazzino.quanti) AS Esistenza
FROM magazzino
WHERE idart = '$idart';"
sqlite3 -line $db  < $sql
echo
echo > $sql "
SELECT *
FROM magart
WHERE idart='$idart';"
sqlite3 -column -header $db  < $sql
echo $z
articolo=$(echo "SELECT articolo FROM magart WHERE idart='$idart';" | sqlite3 $db)
mn3
}

mn2a(){

echo " 
$mn ------------------------------------------------------------------------ $vn
"
echo " SELECT idart,articolo FROM magart ORDER BY idart;" | sqlite3 -header -separator '	'  $db

echo "$z"
mn2
}

mn3(){
echo "
$mn ------------------------------------------------------------------------ $vn

      data operazione    $data
      codice operazione  $idmov     $movmag
      articolo           $idart   $articolo

$Rn   >>> $gn quantita'  (+ carico  - scarico)
$z"
read quanti
case $quanti in
"")   mn3;;
"<")  mn2;;
"<<") m;;
esac
mn4
}

mn4(){
echo "
$mn ------------------------------------------------------------------------ $vn

      data operazione    $data
      codice operazione  $idmov     $movmag
      articolo           $idart   $articolo
      quantità           $quanti


$Rn   >>> $gn prezzo $z"
read prezzo
case $prezzo in
"")   mn4a;;
"<")  mn3;;
"<<") m;;
esac
mn5
}

mn4a(){
echo > $sql "
SELECT * FROM magart
WHERE idart='$idart';"
echo "$vn"
sqlite3 -column -header $db < $sql
echo "$z" 
mn4
}

mn5(){
echo "
$mn ------------------------------------------------------------------------ $vn

      data operazione    $data
      codice operazione  $idmov     $movmag
      articolo           $idart   $articolo
      quantità           $quanti
      prezzo             $prezzo

$Rn   >>> $gn lotto (aammgg) $z"
read lotto
case $lotto in
"<") mn4;;
"<<") m;;
esac
mn6

}
mn6(){
echo "
$mn ------------------------------------------------------------------------ $vn

      data operazione    $data
      codice operazione  $idmov     $movmag
      articolo           $idart   $articolo
      quantità           $quanti
      prezzo             $prezzo
      lotto              $lotto
      
$Rn   >>> $gn nota"
read nota
case $nota in
"<") mn5;;
"<<") m;;
esac
mn7
}

mn7(){
echo "
$mn ------------------------------------------------------------------------ $vn

      data operazione    $data
      codice operazione  $idmov     $movmag
      articolo           $idart   $articolo
      quantità           $quanti
      prezzo             $prezzo
      lotto              $lotto
      nota               $nota

$Rn   Inv $gn OK procedo $z"
read x
case $x in
"<") mn6;;
"<<") m;;
esac
mn8
}

mn8(){
echo "
$mn ------------------------------------------------------------------------ $vn

Risultato Economico = `echo "$quanti*$prezzo" | bc`

$Rn (.)  $gn registro
$Rn (<<) $gn annullo la scrittura"
read x
case $x in
".") mn9;;
"<<") m;;
esac
mn8
}

mn9() {
echo > $sql "
INSERT INTO magazzino
VALUES ('$data','$idmov','$idart','$quanti','$prezzo','0','$lotto','$nota');
SELECT * FROM magazzino
WHERE data='$data'
ORDER BY idmov;"
echo "
$vn   SCRITTURE MAGAZZINO INSERITE IN DATA $data:
"
sqlite3 -column -header $db < $sql 
echo "
$mm                         $Rn   REGISTRAZIONE COMPLETATA   $mm                  $z
"
mn
}



#questa funzione e' un cesso da rivedere
mnr(){
echo > $sql "
SELECT *
FROM magatmp;"
sqlite3 $db < $sql > /cnt/dati
mcedit  /cnt/dati
echo > $sql "
DELETE FROM magatmp;
LOAD DATA INFILE '/cnt/dati'
INTO TABLE magatmp;
DELETE FROM magatmp
WHERE data='0000-00-00';
SELECT * FROM magatmp;"
#echo "[0;32m"
sqlite3 $db< $sql 
echo "
$Rn  (r) $gn ripeto verifica
$Rn  (+) $gn continua scritture
$Rn  (.) $gn registrazione"
read x
case $x in
"r") mnr;;
"+") mn2;;
".") mn0;;
esac
mnr
}

mq(){
echo "
$mn ------------------------------------------------------------------------ $vn

  +----------------------------+
  |      QUERY  MAGAZZINO      |
  +----------------------------+

$Rn   (Inv) $gn anno corrente
$Rn    >>>  $gn anno precedente $rn (aa)
"
read mgz
case $mgz in
"")   mgz=magazzino;mq1;;
"<")  m;;
"<<") m;;
esac
mgz=maga$mgz
mq1
}

mq1(){
echo "
$mn ------------------------------------------------------------------------ $vn

    Query $mgz

$Rn   (a) $gn codice articolo
$Rn   (c) $gn nr fattura cliente
$Rn   (f) $gn nr fattura fornitore
$Rn   (d) $gn data
$Rn   (m) $gn codice movimento
$Rn   (i) $gn inventario
$z" 
read x
case $x in
a) mqa;;
c) mqc;;
f) mqf;;
d) mqd;;
m) mqm;;
i) mqi;;
"<")  mq;;
"<<") m;;
esac
mq1
}

mqa(){
echo "
$mn ------------------------------------------------------------------------ $vn

      Query $mgz
    
$Rn   >>> $gn  codice articolo
$z"
read idart
case $idart in
"") mqaa;;
"<") mq1;;
"<<") m;;
esac
echo $vn
echo "SELECT * FROM magart WHERE idart = '$idart';" | sqlite3 -column -header $db
echo
echo "SELECT * FROM $mgz WHERE idart = '$idart' ORDER BY data;" | sqlite3 -column -header $db
echo
echo "SELECT SUM(quanti) AS GIACENZA FROM $mgz WHERE idart='$idart';" | sqlite3 -line $db
echo
echo "SELECT idmov, SUM(quanti) AS totali FROM $mgz WHERE idart='$idart' GROUP BY idmov;" | sqlite3 -column -header $db

mqa
}

mqc(){
echo "
$mn ------------------------------------------------------------------------ $vn

      Query $mgz

$Rn   >>> $gn  numero fattura cliente
$z"
read nrfat
case $nrfat in
"") mqc;;
"<") mq1;;
"<<") m;;
esac
echo $vn
echo "SELECT * FROM $mgz WHERE nrfat='$nrfat' AND idmov='cf';" | sqlite3 -column -header $db
mqc
}

mqf(){
echo "
$mn ------------------------------------------------------------------------ $vn

      Query $mgz

$Rn   >>> $gn  numero fattura fornitore
$z"
read nrfat
case $nrfat in
"") mqc;;
"<") mq1;;
"<<") m;;
esac
echo $vn
echo "SELECT * FROM $mgz WHERE nrfat='$nrfat' AND idmov='ff';" | sqlite3 -column -header $db
mqf
}

mqd(){
echo "
$Rn >>> $gn data (aammgg)
"
read data
case $data in
"") mqd;;
"<") mq1;;
"<<") m;;
esac
echo "mgz=$mgz"
echo "
SELECT *
FROM $mgz
WHERE data='$data'
ORDER BY idmov,idart,nrfat;
" | sqlite3 -column -header $db
mqd
}

mqm(){
echo "
$Rn >>> $gn codice movimento
"
read idmov
case $idmov in
"") mqd;;
"<") mq1;;
"<<") m;;
esac
echo "
SELECT *
FROM $mgz
WHERE idmov like '$idmov'
ORDER BY data,idart,nrfat;
" | sqlite3 -column -header $db
mqm
}

mqaa(){
echo $vn
echo "SELECT idart,articolo FROM magart;" | sqlite3 -separator '	' $db
echo $z
mqa
}

mqi(){
echo "  >>> data iniziale (aammgg) def 2009-01-01"
read ini
case $ini in "") ini=090101
esac
echo "  >>> data finale (aammgg) def 2009-12-31"
read fin
case $fin in "") fin=091231
esac
echo > $sql "
DROP TABLE IF EXISTS tmp1;
CREATE TABLE tmp1
(idart char(6),
carico int(6),
cosmed float(8,2));
INSERT INTO tmp1
SELECT idart,
SUM(quanti),
SUM(quanti*prezzo)/SUM(quanti)
FROM magazzino
WHERE quanti >0
AND data between '$ini' and '$fin'
GROUP BY idart
ORDER BY idart;
DROP TABLE IF EXISTS tmp2;
CREATE TABLE tmp2
(idart char(6),
scarico int(6),
ricmed float(8,2));
INSERT INTO tmp2
SELECT idart,
SUM(quanti),
SUM(quanti*prezzo)/SUM(quanti)
FROM magazzino
WHERE quanti <0
AND data between '$ini' and '$fin'
GROUP BY idart
ORDER BY idart;
DROP TABLE IF EXISTS tmp3;
CREATE TABLE tmp3
(idart char(6),
saldo int(6));
INSERT INTO tmp3
SELECT idart,SUM(quanti)
FROM magazzino
WHERE data between '$ini' and '$fin'
GROUP BY idart
ORDER BY idart;
SELECT magart.idart,
magart.articolo AS '       descrizione       ',
magart.unimis,
tmp1.carico,
tmp1.cosmed,
tmp2.scarico,
tmp2.ricmed,
tmp3.saldo,
tmp3.saldo*tmp1.cosmed AS valtot
FROM magart
LEFT JOIN tmp1 ON magart.idart=tmp1.idart
LEFT JOIN tmp2 ON magart.idart=tmp2.idart
LEFT JOIN tmp3 ON magart.idart=tmp3.idart
ORDER BY magart.idart;"
echo $vn
sqlite3 -column -header $db < $sql > /home/cnt/dati
tot=`echo "
SELECT SUM(tmp3.saldo*tmp1.cosmed)
FROM tmp1,tmp3
WHERE tmp1.idart=tmp3.idart;
" | sqlite3 $db` 
tot1=
echo "
Valore totale magazzino = $tot Euro
"
cat /home/cnt/dati

echo "
$gn
   *** STAMPA INVENTARIO ***

$Rn  (s) $gn invio alla stampante
$Rn   <  $gn precedente
$Rn  <<  $gn inizio
"
read x
case $x in
   s) lp -o cpi=13 -o page-left=72 -o landscape /home/cnt/fattura1;;
   #a2ps --landscape -B  --columns=1 -f 11 --borders=no /cnt/dati;;
#lpr -o cpi=14 -o page-left=30 -o page-top=30 -o lpi=7 -P EPL-5700 /cnt/fattura;;
 "<") mq;;
"<<") inizio;;
esac
#xterm -bg beige -fg blue -g 66x15 -e less /cnt/dati &
mq1
}

m