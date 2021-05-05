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
#
#          www.bilug.it          linux@ml.bilug.linux.it


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
Cn="[1;36;40m"   # cyan grassetto su ner

Ng="[1;30;43m"   # nero grassetto su giallo
z="[0m";         # normale

db=/home/cnt/cnt.db   # file database
sql=/home/cnt/sql     # file sql

c(){
echo $gn
#echo "
#$gn Verifica eventuali clienti privi di anagrafica:"
echo "
SELECT giornale.idcli AS '   codici clienti privi di anagrafica'
FROM giornale LEFT JOIN cliana
ON giornale.idcli=cliana.idcli
WHERE cliana.idcli IS NULL
GROUP BY giornale.idcli;
" | sqlite3 -line /home/cnt/cnt.db

echo "
$gn
           C L I E N T I
  ---------------------------------
  
  $Rn  (e) $gn   Emissione fattura
  $Rn  (p) $gn   Pagamento fattura
  $Rn  (s) $gn   Stampa fattura
  $Rn  (z) $gn   Annulla fattura

  $Rn  (c) $gn   Corrispettivi
  $Rn  (a) $gn   Anagrafe clienti
  $Rn  (q) $gn   Query
  
  
$z"
read x	       
case $x in
a) ca;;
c) cc;;
e) ce;;
p) cp;;
q) cq;;
s) cs;;
z) cz;;
"<") /home/cnt/cnt1.sh;;
"<<") /home/cnt/cnt1.sh;;
esac
c	       
}

ca() {
echo "
$mn ------------------------------------------------------------------------ $vn

$Rn    >>> $gn codice cliente
$Rn    (m) $gn modifica $Rn $idcli
$Rn    (n) $gn nuovo cliente
$Rn    (e) $gn elimina cliente
$vn"
read x
case $x in
"") echo "SELECT idcli,cliente,citta FROM cliana ORDER BY idcli;
    " | sqlite3 -column -header "/home/cnt/cnt.db"; ca;;
e)  cae;;
m)  cam;;
n)  can;;
"<") c;;
"<<") /home/cnt/cnt1.sh;;
esac
idcli=$x
echo
echo "
 SELECT *
 FROM cliana
 WHERE idcli like '$idcli';
 " | sqlite3 -line /home/cnt/cnt.db
ca
}

cae(){
echo "$gn
   --------------------------------------------------
                 ANAGRAFE  CLIENTI 
   --------------------------------------------------

$Rn >>> $gn codice cliente da eliminare
$vn"
read idcli
case $idcli in
"") cae0;;
"<") ca;;
"<<") c;;
esac
echo "
 
 SELECT idcli,piva,codfis,pagamen
 FROM cliana
 WHERE idcli like '$idcli';
 " | sqlite3 -column -header /home/cnt/cnt.db
echo
echo "
 SELECT cliente,clien2,via,citta
 FROM cliana
 WHERE idcli like '$idcli';
 " | sqlite3 -column -header /home/cnt/cnt.db
echo
echo "
 SELECT destina,destin2,destvia,destcit
 FROM cliana
 WHERE idcli like '$idcli';
 " | sqlite3 -column -header /home/cnt/cnt.db
cae1
}

cae0(){
echo "
.mode column
.header ON
.width 8 40 40
SELECT idcli, cliente, citta
FROM cliana
ORDER BY idcli;
" | sqlite3 $db
cae
}

cae1(){
echo "$gn
   --------------------------------------------------
                  ANAGRAFE  CLIENTI
   --------------------------------------------------

$Rn   (y) $gn confermo eliminazione $rn $idcli
"
read x
case $x in
y)    cae2;;
"")   cae1;;
"<")   cae;;
"<<") c;;
esac
cae1
}

cae2(){
echo > /home/cnt/sql "
DELETE FROM cliana
WHERE idcli = '$idcli';"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql

echo "$gn
   --------------------------------------------------
                  ANAGRAFE  CLIENTI
   --------------------------------------------------

          eliminato cliente $rn $idcli

$gn  (Inv)  per continuare
"
read x
cae
}

cam(){
echo "
$gn         cliente $Rn $idcli

$Rn    >>> $gn campo da modificare $z"
read campo
case $campo in
"")
echo > /home/cnt/sql "
SELECT idcli,cliente,clien2,via
FROM cliana
ORDER BY idcli;"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql;;
"<") ca;;
"<<") c;;
esac
cam1
}

cam1(){
echo "
$Rn    >>> $gn modifica
$z"
read modif
echo " 

$gn  cliente  = $Rn $idcli
$gn  campo    = $Rn $campo
$gn  modifica = $Rn $modif

$Rn   (+) $gn registro modifica
$vn"
read x
case $x in
"+")  cam2;;
"<")  ca;;
"<<") c;;
esac
cam1
}

cam2(){
echo "
 UPDATE cliana
 SET $campo='$modif'
 WHERE idcli like '$idcli';
 " | sqlite3 -column -header /home/cnt/cnt.db
echo "
 SELECT idcli,cliente,clien2,via,citta
 FROM cliana
 WHERE idcli like '$idcli';
 " | sqlite3 -column -header /home/cnt/cnt.db
echo
echo "
 SELECT piva,pagamen
 FROM cliana
 WHERE idcli like '$idcli';
 " | sqlite3 -column -header /home/cnt/cnt.db
 echo
echo "
 SELECT destina,destin2,destvia,destcit
 FROM cliana
 WHERE idcli like '$idcli';
 " | sqlite3 -column -header /home/cnt/cnt.db
ca
}

can(){
echo "
$Gn          ANAGRAFICA NUOVO CLIENTE

$Rn >>> $Gn codice cliente, max 5 caratteri $z"
read idcli
echo "
codice cliente:  $idcli
"
case $idcli in
"")
echo > /home/cnt/sql "
SELECT idcli,cliente,clien2,via,citta
FROM cliana
ORDER by idcli;"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql
can;;
"<") ca;;
"<<") c;;
esac
echo > /home/cnt/sql "
SELECT idcli,cliente,clien2,via,citta
FROM cliana
WHERE idcli like '$idcli';"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql
can1
}

can1(){
echo "$Rn >>> $Gn ragione sociale 1 $z"
read cliente
echo "
codice cliente:  $idcli
ragione sociale: $cliente
"
case $cliente in
"") can1;;
"<") can;;
"<<") c;;
esac
can2
}

can2(){
echo "$Rn >>> $Gn ragione sociale 2 $z"
read clien2
echo "
codice cliente:    $idcli
ragione sociale:   $cliente
ragione sociale2:  $clien2
" 
case $clien2 in
"") can2;;
"<") can1;;
"<<") c;;
esac
can3
}

can3(){
echo "$Rn >>> $Gn via $z"
read via
echo "
codice cliente:   $idcli
ragione sociale:  $cliente
ragione sociale2: $clien2
via:              $via
" 
case $via in
"") can3;;
"<") can2;;
"<<") c;;
esac
can4
}

can4(){
echo "$Rn >>> $Gn CAP, citta', provincia $z"
read citta
echo "
codice cliente:    $idcli
ragione sociale:   $cliente
ragione sociale2:  $clien2
via:               $via
citta:             $citta
" 
case $citta in
"") can4;;
"<") can3;;
"<<") c;;
esac
can5
}

can5(){ 
echo "$Rn >>> $Gn partita IVA $z"
read piva
echo "
codice cliente:    $idcli
ragione sociale:   $cliente
ragione sociale2:  $clien2
via:               $via
citta:             $citta
partita iva:       $piva
" 
case $piva in
"") can5;;
"<") can4;;
"<<") c;;
esac
can6
}

can6(){
echo "$Rn >>> $Gn eventuale codice fiscale $z"
read codfis
echo "
codice cliente:    $idcli
ragione sociale:   $cliente
ragione sociale2:  $clien2
via:               $via
citta:             $citta
partita iva:       $piva
codice fiscale:    $codfis
" 
case $codfis in
"") can6;;
"<") can5;;
"<<") c;;
esac
can7
}

can7(){
echo "$Rn >>> $Gn listino $gn
      1 gros1 (min)
      2 gros2 (max)
      m minuto $z"
read listino
echo "
codice cliente:    $idcli
ragione sociale:   $cliente
ragione sociale2:  $clien2
via:               $via
citta:             $citta
partita iva:       $piva
codice fiscale:    $codfis
listino:           $listino
" 
case $listino in
"") can7;;
"<") can6;;
"<<") c;;
esac
can8
}

can8(){
echo "$Rn >>> $Gn pagamento $z"
read pagamen
echo "
codice cliente:    $idcli
ragione sociale:   $cliente
ragione sociale2:  $clien2
via:               $via
citta:             $citta
partita iva:       $piva
codice fiscale:    $codfis
listino:           $listino
pagamento:         $pagamen
" 
case $pagamen in
"") can8;;
"<") can7;;
"<<") c;;
esac
can9
}

can9(){
echo "$Rn >>> $Gn destinazione 1 $z"
read destina
echo "
codice cliente:    $idcli
ragione sociale:   $cliente
ragione sociale2:  $clien2
via:               $via
citta:             $citta
partita iva:       $piva
codice fiscale:    $codfis
listino:           $listino
pagamento:         $pagamen
destinazione1:     $destina    
" 
case $destina in
"") can9;;
"<") can8;;
"<<") c;;
esac
can10
}

can10(){
echo "$Rn >>> $Gn destinazione 2 $z"
read destin2
echo "
codice cliente:    $idcli
ragione sociale:   $cliente
ragione sociale2:  $clien2
via:               $via
citta:             $citta
partita iva:       $piva
codice fiscale:    $codfis
listino:           $listino
pagamento:         $pagamen
destinazione1:     $destina
destinazione2:     $destin2
" 
case $destin2 in
"") can10;;
"<") can9;;
"<<") c;;
esac
can11
}

can11(){
echo "$Rn >>> $Gn destinazione via $z"
read destvia
echo "
codice cliente:    $idcli
ragione sociale:   $cliente
ragione sociale2:  $clien2
via:               $via
citta:             $citta
partita iva:       $piva
codice fiscale:    $codfis
listino:           $listino
pagamento:         $pagamen
destinazione1:     $destina
destinazione2:     $destin2
destinazione via:  $destvia
" 

case $destvia in
"") can11;;
"<") can10;;
"<<") c;;
esac
can12
}

can12(){
echo "$Rn >>> $Gn destinazione 4 $z"
read destcit
echo "
codice cliente:    $idcli
ragione sociale:   $cliente
ragione sociale2:  $clien2
via:               $via
citta:             $citta
partita iva:       $piva
codice fiscale:    $codfis
listino:           $listino
pagamento:         $pagamen
destinazione1:     $destina
destinazione2:     $destin2
destinazione via:  $destvia
destinazione citta:$destcit
" 
case $destcit in
"") can12;;
"<") can11;;
"<<") c;;
esac
can13
}

can13(){
echo "$Rn (+) $Gn per confermare $z"
read x
case $x in
"+") can14;;
"<") can12;;
"<<") c;;
esac
can13 
}

can14(){
echo > /home/cnt/sql "
INSERT INTO cliana VALUES (
'$idcli',
'$cliente',
'$clien2',
'$via',
'$citta',
'$piva',
'$codfis',
'$listino',
'$pagamen',
'$destina',
'$destin2',
'$destvia',
'$destcit');

SELECT *
FROM cliana
WHERE idcli = '$idcli';"
sqlite3 -line /home/cnt/cnt.db < /home/cnt/sql
ca
}

#####     CLIENTI CORRISPETTIVI

cc(){
idmov=cc
movmag=$(echo "SELECT movime FROM magmov WHERE idmov='$idmov';" | sqlite3 /home/cnt/cnt.db)

echo "
$mn ------------------------------------------------------------------------ $vn

$Rn  >>> $gn data movimento $vn (aammgg)

$gn default oggi $vn `date +%y%m%d-%A`$z
"
read data
case $data in
 "")   data=`date +%y%m%d`;;
 "<")  c;;
 "<<") c;;
esac
echo "
DROP TABLE IF EXISTS clicor;
CREATE TABLE clicor
(idart     TEXT(6)    NOT NULL,
 quanti    INT(5)     NOT NULL,
 prezzo    REAL(6,2)  NOT NULL,
 subtot    REAL(8,2)  NOT NULL,
 aliva     INT(2)     NOT NULL,
 iva       REAL(8,2)  NOT NULL,
 nota      TEXT(50));
" | sqlite3 $db
cc1
}

cc1(){
echo "
$mn ------------------------------------------------------------------------ $vn

   data movimento    $data
   codice movimento  $idmov  $movmag

$Rn   >>> $gn codice articolo
"
read idart
case $idart in
"")   cc1a;;
"<")  cc1;;
"<<") c;;
esac
echo $vn
echo > $sql "
.mode column
.header ON
.width 6 8 8 8 8 8 8 8
SELECT *
FROM magazzino
WHERE idart='$idart'
ORDER BY data desc,idmov
limit 20;
" | sqlite3 -init $sql $db
echo
echo > $sql "
SELECT
SUM(magazzino.quanti) AS Esistenza
FROM magazzino
WHERE idart = '$idart';
" | sqlite3 -line $db  < $sql
echo
echo > $sql "
.mode column
.header ON
SELECT *
FROM magart
WHERE idart='$idart';
" | sqlite3 -init $sql $db
echo $z
articolo=$(echo "SELECT articolo FROM magart WHERE idart='$idart';" | sqlite3 $db)
unimis=$(echo "SELECT unimis FROM magart WHERE idart='$idart';" | sqlite3 $db)
aliva=$(echo "SELECT aliva FROM magart WHERE idart='$idart';" | sqlite3 $db)

cc2
}

cc1a(){

echo "
$mn ------------------------------------------------------------------------ $vn
"
echo > $sql "
.header ON
.mode column
.width 6 31 8 8 8 8 8 8
SELECT *
FROM magart
ORDER BY idart;
" | sqlite3 -init $sql $db
echo "$z"
cc1
}

cc2(){
echo "
$mn ------------------------------------------------------------------------ $vn

   data operazione    $data
   codice operazione  $idmov     $movmag
   articolo           $idart   $articolo

$Rn   >>> $gn quantita'
$z"
read quanti
case $quanti in
"")   cc2;;
"<")  cc1;;
"<<") c;;
esac
cc3
}


cc3(){
echo "
$mn ------------------------------------------------------------------------ $vn
 
   data operazione    $data
   codice operazione  $idmov     $movmag
   articolo           $idart   $articolo
   quantità           $unimis $quanti

$Rn   >>> $gn prezzo
$z"
read prezzo
case $prezzo in
"")   cc3a;;
"<")  cc2;;
"<<") c;;
esac
cc4
}

cc3a(){
echo $vn
echo > $sql "
.header ON
.mode column
.width 6 31 8 8 8 8 8 8
SELECT *
FROM magart
WHERE idart='$idart';
" | sqlite3 -init $sql $db
echo "$z"
cc3
}


cc4(){
echo "
$mn ------------------------------------------------------------------------ $vn

   data operazione    $data
   codice operazione  $idmov     $movmag
   articolo           $idart   $articolo
   quantità           $unimis $quanti
   prezzo             $prezzo
   aliquota iva       $aliva

$Rn   >>> $gn nota"
read nota
case $nota in
"<") cc3;;
"<<") c;;
esac
subtot=$(echo "scale=3; $quanti * $prezzo" | bc)
iva=$(echo "scale=3; $quanti * $prezzo * $aliva /100" | bc)
echo $cn
echo "
INSERT INTO clicor VALUES (
'$idart',
$quanti,
$prezzo,
ROUND($subtot,2),
$aliva,
ROUND($iva,2),
'$nota');
" | sqlite3 $db
cc5
}

cc5(){

echo "
$mn ------------------------------------------------------------------------ $vn

   data operazione    $data
   codice operazione  $idmov     $movmag
   articolo           $idart   $articolo
   quantità           $unimis $quanti
   prezzo             $prezzo
   subtotale ivato    $subtot
   aliquota iva       $aliva
   iva                $iva
   nota               $nota
$gn

Prospetto movimenti:
$vn"
echo > $sql "
.header ON
.mode column
.width 6 6 6 6 6 6 30
SELECT * FROM clicor;
" | sqlite3  -init $sql $db
echo "

$Rn   (+) $gn altro articolo $z
$Rn   (-) $gn fine articoli $z"
read x
case $x in
"+") cc1;;
"-") cc6;;
"<") cc4;;
"<<") c;;
esac
cc5
}

cc6(){
#sum='sum(iva)'
#iva4=`echo "select $sum FROM clicor WHERE aliva=4 GROUP BY aliva;" | sqlite3 $db`
#iva10=`echo "select $sum FROM clicor WHERE aliva=10 GROUP BY aliva;" | sqlite3 $db`
#echo "iva 4 $iva4"
#echo "iva 10 $iva10"
 echo "
$mn ------------------------------------------------------------------------ $gn

Prospetto scritture magazzino:
$vn"

echo > $sql "
.header ON
.mode column
.width 6 6 6 6 6 6 6 30
SELECT
'$data' AS data,
'$idmov' AS idmov,
idart,
quanti*-1 AS nr,
prezzo,
00 AS nrfat,
00 AS lotto,
nota
FROM clicor;
" | sqlite3 -init $sql $db

echo "
$gn
Prospetto scritture contabilita' generale:
$vn"

echo > $sql "
.header ON
.mode column
.width 6 6 6 6 6 6 6 30
SELECT
'$data' AS data,
'$idmov'AS idmov,
'alc' AS idcon,
SUM (quanti*prezzo) AS totale,
00 AS nrfat,
00 AS idfor,
00 AS idcli,
nota
FROM clicor;
.header OFF
SELECT
'$data' AS data,
'$idmov'AS idmov,
'piva4' AS idcon,
SUM(iva)*-1,
00 AS nrfat,
00 AS idfor,
00 AS idcli,
nota
FROM clicor
WHERE aliva=4
GROUP BY aliva;
SELECT
'$data' AS data,
'$idmov'AS idmov,
'piva10' AS idcon,
SUM(iva)*-1,
00 AS nrfat,
00 AS idfor,
00 AS idcli,
nota
FROM clicor
WHERE aliva=10
GROUP BY aliva;
SELECT
'$data' AS data,
'$idmov'AS idmov,
'rcc' AS idcon,
SUM(quanti*prezzo)*-1+SUM(iva),
00 AS nrfat,
00 AS idfor,
00 AS idcli,
nota
FROM clicor;
" | sqlite3 -init $sql $db



echo "
$Rn  (.)  $gn registro
$Rn  (<)  $gn indietro
"
read x
case $x in
".") cc7;;
"<") cc5;;
"<<") c;;
esac
}

cc7() {
echo "
INSERT INTO magazzino
SELECT
'$data' AS data,
'$idmov' AS idmov,
idart,
quanti*-1 AS nr,
prezzo,
00 AS nrfat,
00 AS lotto,
nota
FROM clicor;

INSERT INTO giornale
SELECT
'$data' AS data,
'$idmov'AS idmov,
'alc' AS idcon,
SUM (quanti*prezzo) AS totale,
00 AS nrfat,
00 AS idfor,
00 AS idcli,
nota
FROM clicor;

INSERT INTO giornale
SELECT
'$data' AS data,
'$idmov'AS idmov,
'piva4' AS idcon,
SUM(iva)*-1,
00 AS nrfat,
00 AS idfor,
00 AS idcli,
nota
FROM clicor
WHERE aliva=4
GROUP BY aliva;

INSERT INTO giornale
SELECT
'$data' AS data,
'$idmov'AS idmov,
'piva10' AS idcon,
SUM(iva)*-1,
00 AS nrfat,
00 AS idfor,
00 AS idcli,
nota
FROM clicor
WHERE aliva=10
GROUP BY aliva;

INSERT INTO giornale
SELECT
'$data' AS data,
'$idmov'AS idmov,
'rcc' AS idcon,
SUM(quanti*prezzo)*-1+SUM(iva),
00 AS nrfat,
00 AS idfor,
00 AS idcli,
nota
FROM clicor;
" | sqlite3 $db


echo "
$vn   SCRITTURE MAGAZZINO INSERITE IN DATA $data:
"
echo > $sql "
.header ON
.mode column
SELECT *
FROM magazzino
WHERE data='$data'
ORDER BY idmov;
" | sqlite3 -init $sql $db
echo "
$vn   SCRITTURE GIORNALE INSERITE IN DATA $data:
"
echo > $sql "
.header ON
.mode column
SELECT *
FROM giornale
WHERE data='$data'
ORDER BY idope;
" | sqlite3 -init $sql $db
echo "

$mm                         $Rn   REGISTRAZIONE COMPLETATA   $mm                  $z
"
c
}


#####   CLIENTI EMISSIONE FATTURA   #####
ce() {
clear
echo > /home/cnt/sql "
SELECT *
FROM giornale
WHERE idope like 'cf'
AND idcon like 'ac%'
ORDER BY nrfat desc
LIMIT 5;"
echo "
$mn ------------------------------------------------------------------------ $vn

$gn
 ULTIME 5 FATTURE REGISTRATE:
$vn"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql
echo "
$mn ------------------------------------------------------------------------ $vn
   $Rn >>> $gn numero fattura
$z"
read nrfat
case $nrfat in
"")   ce;;
"<")  c;;
">>") c;;
esac
ce1
}

ce1(){
clear
echo "
$mn ------------------------------------------------------------------------ $vn

   $gn numero fattura $Rn $nrfat

   $Rn >>> $gn data fattura (aammgg) def $(date +%y%m%d--%a))
$z"
read datafat
case $datafat in
"")   datafat="$(date +%y%m%d)";;
"<")  ce1;;
"<<") c;;
esac
ce2
}

ce2(){
clear
echo "
$mn ------------------------------------------------------------------------ $vn

   $gn numero fattura $Rn $nrfat


   $Rn >>> $gn codice cliente
$z"
read idcli
case $idcli in
"")
echo $vn
echo > /home/cnt/sql "
SELECT idcli,cliente,citta
FROM cliana
ORDER BY idcli;"
sqlite3  -column -header /home/cnt/cnt.db < /home/cnt/sql
echo "
$Rn Inv $gn per continuare
"
read x
# > /cnt/dati
# xterm -bg beige -fg blue  -g 75x15+310+0 -e less /cnt/dati
ce2;;
"<") ce;;
"<<") c;;
esac
echo > /home/cnt/sql "
DROP TABLE IF EXISTS clifat2tmp;

CREATE TABLE clifat2tmp (
 nrfat    INT(4),
 articolo TEXT(26),
 lotto    TEXT(6),
 unimis   TEXT(2),
 quanti   INT(5),
 prezzo   REAL(6,2),
 aliva    INT(2),
 iva      REAL(8,2),
 subtot   REAL(8,2));"
sqlite3 /home/cnt/cnt.db < /home/cnt/sql
ce3
}

ce3(){
clear
echo > /home/cnt/sql "
SELECT * FROM cliana where idcli='$idcli';";
echo $vn
sqlite3 -line /home/cnt/cnt.db < /home/cnt/sql
echo $z
cliente=$(echo "SELECT cliente FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
listino=$(echo "select listino from cliana where idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
case $listino in
1) listino=gros1;;
2) listino=gros2;;
esac


echo "
$mn ------------------------------------------------------------------------ $vn


  $gn numero fattura        $Rn $nrfat
  $gn data fattura (aammgg) $Rn $datafat
  $gn cliente               $Rn $idcli   $cliente
  $gn listino               $Rn $listino

$Rn   >>> $gn codice articolo
$vn"
read idart
case $idart in
"")   echo " SELECT * FROM magart ORDER BY idart;" | sqlite3 -column -header /home/cnt/cnt.db
      echo " $Rn Inv $gn per procedere"
      read x
      ce3;;
"<")  ce2;;
"<<") c;;
esac
ce4
}

ce4(){
clear
articolo=$(echo "SELECT articolo FROM magart WHERE idart='$idart';" | sqlite3 /home/cnt/cnt.db)
unimis=$(echo "select unimis from magart where idart='$idart';" | sqlite3 /home/cnt/cnt.db)
prezzo=$(echo "select $listino from magart where idart='$idart';" | sqlite3 /home/cnt/cnt.db)
aliva=$(echo "select aliva from magart where idart='$idart';" | sqlite3 /home/cnt/cnt.db)

echo "
$gn listino = $rn $listino
$gn prezzo  = $rn $prezzo
$gn iva     = $rn $aliva

$Rn (+) $gn confermo prezzo listino
$Rn >>> $gn immetti prezzo fuori listino
$z"
read x
case $x in
"+") ce4a;;
"") ce4;;
"<") ce3;;
"<<") ce;;
esac
prezzo=$x
ce4a
}

ce4a(){
echo "
 SELECT
 magart.idart AS idart,
 magart.articolo AS articolo,
 SUM(magazzino.quanti) AS esistenza
 FROM magart,magazzino
 WHERE magazzino.idart = '$idart'
 AND magart.idart = '$idart'
 GROUP BY idart;
 " | sqlite3 -column -header /home/cnt/cnt.db
echo
echo "
 SELECT *
 FROM magazzino
 WHERE idart = '$idart'
 ORDER BY data desc,idmov,nrfat
 LIMIT 25;
 " | sqlite3 -column -header /home/cnt/cnt.db
echo "$z"

echo "
$mn ------------------------------------------------------------------------ $vn

  $gn numero fattura        $rn $nrfat
  $gn data fattura (aammgg) $rn $datafat
  $gn cliente               $rn $idcli   $cliente
  $gn articolo              $rn $idart   $articolo
  $gn prezzo                $rn $prezzo
  $gn aliquota iva          $rn $aliva

  $Rn >>>  lotto (aammgg scadenza) $z"
read lotto
case $lotto in
"<")  ce4;;
"<<") c;;
esac
ce5
}

ce5(){
echo "
$mn ------------------------------------------------------------------------ $vn

  $gn numero fattura        $rn $nrfat
  $gn data fattura (aammgg) $rn $datafat
  $gn cliente               $rn $idcli   $cliente
  $gn articolo              $rn $idart   $articolo
  $gn prezzo                $rn $prezzo
  $gn aliquota iva          $rn $aliva
  $gn lotto                 $Rn $lotto


  $Rn >>> $gn quantita' $z"
read quanti
case $quanti in
"")   ce5;;
"<")  ce4;;
"<<") c;;
esac
subtot=$(echo "scale=3;$quanti*$prezzo" | bc)
iva=$(echo "scale=3;$quanti*$prezzo*$aliva/100" | bc)
ce6
}

ce6(){
clear
echo "
$mn ------------------------------------------------------------------------

  $gn numero fattura        $Rn $nrfat
  $gn data fattura (aammgg) $Rn $datafat
  $gn cliente               $Rn $idcli     $cliente
  $gn articolo              $Rn $idart     $articolo
  $gn lotto                 $Rn $lotto
  $gn listino               $Rn $listino
  $gn quantità              $Rn $unimis    $quanti
  $gn prezzo                $Rn $prezzo
  $gn aliva                 $Rn $aliva%
  $gn iva                   $Rn $iva
  $gn subtotale             $Rb $subtot

  $Rn (+) $gn conferma $z"
read x
case $x in
"")   ce6;;
"<")  ce5;;
"<<") c;;
esac

echo "
INSERT INTO clifat2tmp VALUES (
$nrfat,
'$articolo',
'$lotto',
'$unimis',
$quanti,
$prezzo,
$aliva,
ROUND($iva,2),
ROUND($subtot,2));
" | sqlite3 /home/cnt/cnt.db

ce7
}

ce7(){
clear
echo "
$mn ------------------------------------------------------------------------ $vn
"
echo "SELECT * FROM clifat2tmp;" | sqlite3 -header -column /home/cnt/cnt.db
echo "

$Rn    (+) $gn  nuovo codice articolo
$Rn    (-) $gn  fine articoli, completo fattura
$z"
read x
case $x in
"+")  ce3;;
"-")  ce8;;
"")   ce7;;
"<<") c;;
esac
ce4
}

ce8(){
clear
echo "
$mn ------------------------------------------------------------------------ $vn

$Rn    >>> $gn data trasporto (default $rn $datafat)
$z"
read datatras
case $datatras in
"")   datatras="$datafat";;
"<")  ce7;;
"<<")  c;;
esac
ce9
}

ce9(){
clear
echo "
$mn ------------------------------------------------------------------------ $vn

       data trasporto  $gn $datatra

       $gn trasportatore

$Rn    (d) $gn destinatario
$Rn    (m) $gn mittente
$Rn    (v) $gn vettore
$z"
read trasp
case $trasp in
"d") trasp="destinatario";;
"m") trasp="mittente";;
"v") trasp="vettore";;
"")  ce9;;
"<")  ce8;;
"<<")  c;;
esac
ce10
}

ce10(){
clear
echo "
$mn ------------------------------------------------------------------------

$vn    data trasporto  $gn $datatras
$vn    trasportatore   $gn $traspo

$Rn    >>> $gn numero colli
$z"
read colli
case $colli in
"")   ce10;;
"<")  ce9;;
"<<") c;;
esac
echo "
DROP TABLE IF EXISTS clifat1tmp;
CREATE TABLE clifat1tmp
(nrfat   INT(4),
idcli    TEXT(6),
datafat  TEXT(6),
datatras TEXT(6),
causale  TEXT(7),
colli    TEXT(3),
trasp    TEXT(12)); 
INSERT INTO clifat1tmp VALUES (
'$nrfat',
'$idcli',
'$datafat',
'$datatras',
'vendita',
'$colli',
'$trasp');
" | sqlite3 /home/cnt/cnt.db
ce11
}

ce11(){
clear
echo "
$mn ------------------------------------------------------------------------

$gn  Dati fattura da registrare:
$vn   
   clifat1tmp:
"
echo "SELECT * FROM clifat1tmp;" | sqlite3 -header -column /home/cnt/cnt.db
echo "
   clifat2tmp:
"    
echo "SELECT * FROM clifat2tmp;" | sqlite3 -header -column /home/cnt/cnt.db

# utilizzo queste variabili altrimenti l'highlighting di mcedit sballa

x="SUM(subtot)"
y="SUM(iva)"

impo4=$(echo "SELECT $x FROM clifat2tmp WHERE aliva=4 GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)
impo10=$(echo "SELECT $x FROM clifat2tmp WHERE aliva=10 GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)
impo21=$(echo "SELECT $x FROM clifat2tmp WHERE aliva=21 GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)
iva4=$(echo "SELECT $y FROM clifat2tmp WHERE aliva=4 GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)
iva10=$(echo "SELECT $y FROM clifat2tmp WHERE aliva=10 GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)
iva21=$(echo "SELECT $y FROM clifat2tmp WHERE aliva=21 GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)


# verifico le stringhe nulle altrimenti bc scassa

if [ -z $impo4 ]
then
 impo4a="0.00"
 iva4a="0.00"
else 
 impo4a=$impo4
 iva4a=$iva4
fi

if [ -z $impo10 ]
then
 impo10a="0.00"
 iva10a="0.00"
else 
 impo10a=$impo10
 iva10a=$iva10
fi

if [ -z $impo21 ]
then
 impo21a="0.00"
 iva21a="0.00"
else 
 impo21a=$impo21
 iva21a=$iva21
fi

totimpo=$(echo "scale=2; $impo4a + $impo10a +$impo21a" | bc)
totiva=$(echo "scale=2; $iva4a + $iva10a + $iva21a" | bc)
totfat=$(echo "scale=2; $totimpo + $totiva" | bc)
 
echo "
$vn
   
   imponibile 4%   $impo4a
   imposta         $iva4a
   
   imponibile 10%  $impo10a
   imposta         $iva10a
   

   imponibile 21%  $impo21a
   imposta         $iva21a
   
   totale imponibile  $totimpo
   totale IVA         $totiva
   totale fattura     $totfat
	    

$Rn   (+) $vn registro fattura
$z"
read x
case $x in
"+")  ce12;;
"")   ce11;;
"<")  ce8;;
"<<") c;;
esac
ce12
}


ce12(){
clear
echo $vn
echo "INSERT INTO clifat1 SELECT * FROM clifat1tmp;" | sqlite3 /home/cnt/cnt.db
echo "INSERT INTO clifat2 SELECT * FROM clifat2tmp;" | sqlite3 /home/cnt/cnt.db
echo "INSERT INTO giornale VALUES('$datafat','cf','ac$idcli',$totfat,$nrfat,'--','$idcli','--');" | sqlite3 /home/cnt/cnt.db
echo "INSERT INTO giornale VALUES('$datafat','cf','aiva',-$totiva,$nrfat,'--','$idcli','--');" | sqlite3 /home/cnt/cnt.db
echo "INSERT INTO giornale VALUES('$datafat','cf','rc',-$totimpo,$nrfat,'--','$idcli','--');" | sqlite3 /home/cnt/cnt.db
echo "INSERT INTO magazzino SELECT clifat1tmp.datafat,'cf',magart.idart,-clifat2tmp.quanti,clifat2tmp.prezzo,clifat2tmp.nrfat,clifat2tmp.lotto,'$idcli' FROM clifat1tmp,clifat2tmp,magart WHERE magart.articolo=clifat2tmp.articolo;" | sqlite3 /home/cnt/cnt.db
echo "SELECT * FROM giornale WHERE data='$datafat' AND nrfat='$nrfat';" | sqlite3 -header -column /home/cnt/cnt.db


echo "
$mn ------------------------------------------------------------------------

$Rn  (+) $vn visualizzazione fattura
$Rn  (-) $vn chiudo l'applicazione
$z" 
read x
case $x in
"+")  cs1;;
"-")  exit;;
esac
}

cp() {
echo "
$mn ------------------------------------------------------------------------
$gn
   CLIENTI PAGAMENTO FATTURA
   -------------------------
      
$Rn   >>> $gn codice cliente $z"
read idcli
case $idcli in
"")
echo $vn

echo "
SELECT 
idcli AS codice,
cliente 
FROM cliana
ORDER BY idcli;
" | sqlite3  -column -header $db
cp;;
"<") c;;
"<<") c;;
esac
echo $vn
echo "
SELECT cliente AS '           cliente              '
FROM cliana
WHERE idcli = '$idcli';
" | sqlite3  -column -header $db
echo
echo "
SELECT 
giornale.nrfat AS 'fattura',
giornale.importo,
giornale.data AS 'data (aammgg)',
gioope.operazio AS '   operazione    '
FROM giornale,gioope
WHERE idcon like 'ac$idcli'
AND gioope.idope=giornale.idope
ORDER BY giornale.nrfat,giornale.data;
" | sqlite3 -column -header $db
echo
echo "
SELECT SUM(giornale.importo) AS 'Totale Credito Attuale'
FROM giornale
WHERE giornale.idcon like 'ac$idcli';
" | sqlite3 -column -header $db
cp3
}

cp3(){
echo "
$mn ------------------------------------------------------------------------
$vn
codice cliente:          $idcli

$Rn   >>> $gn data pagamento (aammgg)  default oggi $(date +%y%m%d) $z
"
read datpag
case $datpag in
"") datpag="$(date +%y%m%d)";;
"<") cp;;
"<<") c;;
esac
echo "$vn
Scritture giornale in data $datpag
"

echo "
SELECT *
FROM giornale
WHERE data='$datpag';
" | sqlite3 -column -header $db
cp4
}

cp4(){
echo "
$mn ------------------------------------------------------------------------
$vn
codice cliente:           $idcli
data pagamento (aammgg):  $datpag


$Rn >>> $gn codice conto accreditato"
read idcon
case $idcon in
"")
echo "
$Rn   >>> $gn primi caratteri codice
          a  attivita
          p  passivita
          c  costi
          r  ricavi
          cn capitale
$z"
read x
echo $vn
echo "
SELECT 
idcon AS codice,
conto AS '           conto           '
FROM giocon
WHERE idcon like '$x%';
" | sqlite3 -column -header $db
cp4;; 
"<") cp;;
"<<") c;;
esac
echo $vn
echo "
SELECT
idcon,
conto AS '        conto      '
FROM giocon
WHERE idcon='$idcon';
" | sqlite3 -column -header $db
cp5
}

cp5(){
echo "
$mn ------------------------------------------------------------------------

$vn
codice cliente:           $idcli
data pagamento (aammgg):  $datpag
codice conto accreditato: $idcon

$Rn >>> $gn numero fattura pagata $z"
read nrfat
case $nrfat in
"")  echo $vn
     echo "
     SELECT 
     giornale.nrfat AS 'fattura',
     giornale.importo,
     giornale.data AS 'data (aammgg)',
     gioope.operazio AS '   operazione   '
     FROM giornale,gioope
     WHERE idcon like 'ac$idcli'
     AND gioope.idope=giornale.idope
     ORDER BY giornale.nrfat,giornale.data;
     " | sqlite3 -column -header $db
     cp5;;
"<")  cp4;;
"<<") c;;
esac
echo $vn
echo "
SELECT *
FROM giornale
WHERE idcli = '$idcli'
AND nrfat='$nrfat';
" | sqlite3 -column -header $db

creditfat=`echo "
SELECT SUM(importo)
FROM giornale
WHERE idcon='ac$idcli'
AND nrfat=$nrfat;" | sqlite3 $db`
echo "
il credito relativo alla fattura e' $creditfat"
cp6
}


cp6(){
echo "
$mn ------------------------------------------------------------------------

$vn
codice cliente          : $idcli
data pagamento (aammgg) : $datpag
codice conto accreditato: $idcon
fattura pagata          : $nrfat

$Rn >>> $gn importo accreditato, default $creditfat $z"
read importo
case $importo in
"") importo=$creditfat;;
"<") cp5;;
"<<") c;;
esac
cp7
}

cp7(){
echo "
$mn ------------------------------------------------------------------------

$vn
codice cliente          : $idcli
data pagamento (aammgg) : $datpag
codice conto accreditato: $idcon
fattura pagata          : $nrfat
importo accreditato     : $importo

$Rn  >>> $gn nota, default $rn $idcli $z"
read nota
case $nota in
"")    nota="$idcli";;
"<")   cp6;;
"<<")  c;;
esac
echo "$vn
BOZZA SCRITTURE CONTABILI:
"
echo " 
DROP TABLE IF EXISTS giornaletmp;
CREATE TABLE giornaletmp
(data TEXT,
 idope TEXT(4),
 idcon TEXT(10),
 importo REAL(10,2),
 nrfat INT(3),
 codfor TEXT(6),
 idcli TEXT(6),
 nota TEXT(50));
INSERT INTO giornaletmp
 VALUES ('$datpag','cp','ac$idcli',-$importo,'$nrfat','','$idcli','$nota');
INSERT INTO giornaletmp
 VALUES ('$datpag','cp','$idcon',$importo,'$nrfat','','$idcli','$nota');
SELECT * FROM giornaletmp;
" | sqlite3 -column -header $db
#residuo=`echo "SELECT $creditfat - $importo;" | sqlite3 $db`
residuo=`echo "scale=2; $creditfat-$importo" | bc`
echo "
residuo = $residuo"
if [ "$residuo" = "0" ]
then echo "
$gn la fattura e' pagata a saldo
"
else
echo "$rn 
         residuo = $residuo
$gn
la fattura  non e' stata  pagata a saldo,
successivamente  a  questa  registrazione
immettere le scritture di saldo contabile"
fi
cp8
}

cp8() {
echo "
$mn ------------------------------------------------------------------------

$Rn  (.) $gn registro
"
read x
case $x in
".") cp9;;
"<") cp7;;
"<<") c;;
esac
cp8
}

zcp9(){
echo "
$mn ------------------------------------------------------------------------
$gn
   CLIENTI PAGAMENTO FATTURA

$Rn >>> $gn conto accreditato"
read idcon
echo "
$mn ------------------------------------------------------------------------
$gn
   CLIENTI PAGAMENTO FATTURA

$Rn >>> $gn importo accreditato"
read importo
echo "
$mn ------------------------------------------------------------------------ $vn

$Rn >>> $gn nota, def  $idcli"
read nota
if $nota=''
then
nota='$idcli'
fi

echo > /home/cnt/sql "
 
INSERT INTO giornaletmp
VALUES ('$datpag','cp','$idcon',$importo,'$nrfat','$nota');
SELECT * FROM giornaletmp;"
echo $vn
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql
# > /cnt/dati
#xterm -bg beige -fg blue -g 75x15 -e less /cnt/dati &
cp8
}

cp9(){
echo "
$mn ------------------------------------------------------------------------
$vn
Scritture giornale in data $datpag
"
echo "
INSERT INTO giornale
SELECT * FROM giornaletmp;
" | sqlite3 $db
echo
echo "
SELECT * FROM giornale
WHERE data='$datpag'
ORDER BY idope;
" | sqlite3 -column -header $db
echo
echo "
SELECT SUM(importo)
AS 'squadratura in data $datpag'
FROM giornale
WHERE data='$datpag';
" | sqlite3 -column -header $db


echo "
$gn ----------------------------
$Rn   REGISTRAZIONE   EFFETTUATA
$gn ----------------------------
"
cp
}


cq(){
echo "
$mn ------------------------------------------------------------------------ $vn

$gn
   ---------------------------------
     CONTABILITA' CLIENTI - QUERY
   ---------------------------------

$Rn       (Inv) $gn  attuale
"
read x
case $x in
"") gio=giornale;;
9) gio=gio2009;;
"<") c;;
"<<") c;;
esac
cq1
}

cq1(){
echo "
$mn ------------------------------------------------------------------------ $vn


$gn
   -------------------------------------
       CONTABILITA' CLIENTI - QUERY
   -------------------------------------
     
$Rn  (c)  $gn per cliente
$Rn  (n)  $gn per nr fattura
$Rn  (e)  $gn elenco fiscale fatture
"
read x
case $x in
e) cqe;;
c) cqc;;
n) cqn;;
"<") cq;;
"<<") c;;
esac
echo "[0m"
cq
}

cqc(){
echo "$Rn >>> $gn codice cliente"
read idcli
echo $vn
case $idcli in
"") 
echo > /home/cnt/sql "
SELECT *
FROM giornale
WHERE idcon like 'ac%'
GROUP BY idcon
ORDER BY idcon;"
echo "[0m"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql
;;
"<") cq;;
"<<") c;;
esac
cliente=`echo "SELECT cliente FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db`
echo > /home/cnt/sql "
SELECT *
FROM giornale
WHERE idcon like 'ac$idcli'
ORDER BY nrfat,data;"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql
echo
echo > /home/cnt/sql "
SELECT SUM(importo)
FROM giornale
WHERE idcon = 'ac$idcli'
AND idope='cf';"
sqlite3 -column -header /home/cnt/cnt.db  < /home/cnt/sql

echo
echo > /home/cnt/sql "
CREATE TEMPORARY TABLE tmp (
nrfat INTEGER,
importo INTEGER);

INSERT INTO tmp
SELECT nrfat, SUM(importo)
FROM giornale
WHERE idcon='ac$idcli'
GROUP BY nrfat;

DELETE
FROM tmp 
WHERE nrfat =0
OR importo <=0;

SELECT 
giornale.nrfat,
giornale.data,
giornale.importo
FROM giornale,tmp
WHERE giornale.nrfat=tmp.nrfat
AND giornale.idcon='ac$idcli'
ORDER BY giornale.nrfat;"

echo > /home/cnt/dati "
------------------------------------------------------------
Situazione Credito Fatture   $cliente
------------------------------------------------------------

numero   data (aammgg)  importo
-------------------------------
" 
sqlite3 -column /home/cnt/cnt.db < /home/cnt/sql >> /home/cnt/dati
echo > /home/cnt/sql "
SELECT SUM(importo)
FROM giornale
WHERE idcon = 'ac$idcli';"
echo >> /home/cnt/dati "

-------------------
Totale Credito Euro
-------------------
"
sqlite3 -column /home/cnt/cnt.db < /home/cnt/sql >> /home/cnt/dati
cat /home/cnt/dati
cqc1
}

cqc1(){
echo "
$mn ------------------------------------------------------------------------ $vn

   $Rn (s)  $gn Stampa credito "
read x
case $x in
s) lp /home/cnt/dati;;
"<")  cqc;;
"<<") c;;
"")   cqc1;;
esac
echo $z
cqc1
}

cqe(){
clear
echo "
$mn ------------------------------------------------------------------------ $vn

           Modulo da rivedere se sara' necessario
"
cq
echo > /home/cnt/sql " 
 
 
CREATE TEMPORARY TABLE imposta 
(idcli char(6), imposta int); 
 
INSERT imposta 
SELECT 
idcli,ROUND(SUM(importo))*-1 
FROM $gio 
WHERE idope='cf' 
AND idcon='aiva' 
GROUP BY idcli; 
 
CREATE TEMPORARY TABLE totali 
(idcli char(6), totali int); 
 
INSERT totali 
SELECT 
idcli,SUM(importo) 
FROM $gio 
WHERE idope='cf' 
AND idcon like 'ac%'             
GROUP BY idcli;          
                                 
SELECT                      
totali.idcli,                 
cliana.codfis,
cliana.piva, 
totali.totali-imposta.imposta AS imponibili, 
imposta.imposta,                                                                                                                                               
totali.totali                                                                                                                                                  
FROM imposta,totali,cliana                                                                                                                                     
WHERE imposta.idcli=totali.idcli                                                                                                                             
AND cliana.idcli=totali.idcli                                                                                                                                
ORDER BY totali.idcli;                                                                                                                                        
 
SELECT 
SUM(totali.totali)-SUM(imposta.imposta) AS 'imponibile totale', 
SUM(imposta.imposta) AS 'imposta totale', 
SUM(totali.totali) AS 'totale fatture' 
FROM imposta,totali 
WHERE imposta.idcli=totali.idcli"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql > /home/cnt/dati
cat /home/cnt/dati
echo " 
   ----------------------------- 
      ELENCO FISCALE CLIENTI 
   ----------------------------- 
    (+)  stampo elenco 
    (<)  indietro 
    (<)  inizio 
   -----------------------------     
"
read x      
case $x in 
#+) pr -o 6 -h "" /cnt/dati | lpr -P EPL-5700;; 
+) lp /home/cnt/dati;;
"<") gq;; 
"<<") c; 
esac 
cqe
} 


zcqe(){
echo "
$mn ------------------------------------------------------------------------ $vn
"
echo > /home/cnt/sql "

SELECT *
FROM giornale
WHERE idope='cf' and idcon like 'ac%'
ORDER BY nrfat;"
echo "[0m"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql

}
cqn(){
echo "
$mn ------------------------------------------------------------------------ $vn

[0;1;31m >>> [0m numero fattura"
read nrfat
case $nrfat in
"") cqn1;;
"<") cq;;
"<<") c;;
esac
echo > /home/cnt/sql "

SELECT *
FROM giornale
WHERE nrfat=$nrfat
AND idope like 'c%'
ORDER BY data;"
echo "[0m"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql
#echo > /home/cnt/sql "
#SELECT CONCAT(' Credito attuale ',SUM(importo))
#from giornale
#WHERE idcon like 'ac$idcli';"
#sqlite3 -column -header /home/cnt/cnt.db -N < /home/cnt/sql
# > /cnt/dati
#xterm -bg beige -fg blue -g 65x15 -e less /cnt/dati &
cq 
}

cqn1(){
echo "
SELECT *
FROM giornale
WHERE idcon like 'ac%'
AND idope = 'cf'
ORDER BY nrfat;
" | sqlite3 $db
cqn
}

#####   CLIENTI STAMPA FATTURA   #####
cs(){
echo "
$mn ------------------------------------------------------------------------

$gn     STAMPA  FATTURA

$Rn  >>> $vn numero fattura
$z" 
read nrfat
echo $vn
case $nrfat in
"")   csa;; 
"<")  c;;
"<<") c;;
esac
cs1
}

csa(){
echo "
SELECT *
FROM giornale
WHERE idope='cf'
AND idcon like 'ac%'
ORDER BY nrfat;
" | sqlite3 -header -column /home/cnt/cnt.db
cs
}

cs1(){
#Estraggo i dati fattura posto nrfat=$nrfat

#echo > /home/cnt/.sqliterc ".width 30 7 6 6 7 5 5"

data=$(echo "SELECT data FROM giornale WHERE nrfat='$nrfat' AND idcon like'ac%';" | sqlite3 /home/cnt/cnt.db)
datagg=${data:4:2}
datamm=${data:2:2}
dataaa=${data:0:2}
data1=$datagg/$datamm/20$dataaa

idcli=$(echo "SELECT idcli FROM giornale WHERE nrfat='$nrfat' AND idcon like'ac%' LIMIT 1;" | sqlite3 /home/cnt/cnt.db)
cliente=$(echo "SELECT cliente FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
clien2=$(echo "SELECT clien2 FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
via=$(echo "SELECT via FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
citta=$(echo "SELECT citta FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
piva=$(echo "SELECT piva FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
codfis=$(echo "SELECT codfis FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)

xx="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" # stringa di spaziatura
xcliente=${#cliente}            # lunghezza della stringa cliente
ycliente=`expr 35 - $xcliente`  # nr spazi da aggiungere per arrivare a |
zcliente=`expr substr $xx 1 $ycliente`

xclien2=${#clien2}            # lunghezza della stringa clien2
yclien2=`expr 35 - $xclien2`  # nr spazi da aggiungere per arrivare a |
zclien2=`expr substr $xx 1 $yclien2`

xvia=${#via}            # lunghezza della stringa cliente
yvia=`expr 35 - $xvia`  # nr spazi da aggiungere per arrivare a |
zvia=`expr substr $xx 1 $yvia`

xcitta=${#citta}            # lunghezza della stringa citta
ycitta=`expr 35 - $xcitta`  # nr spazi da aggiungere per arrivare a |
zcitta=`expr substr $xx 1 $ycitta`

xcodfis=${#codfis}            # lunghezza della stringa codfis
ycodfis=`expr 35 - $xcodfis`  # nr spazi da aggiungere per arrivare a |
zcodfis=`expr substr $xx 1 $ycodfis`


#echo "xcliente=$xcliente"
#echo "ycliente=$ycliente"
#echo "zcliente=$zcliente"
#echo "xx=$xx"
#echo "x{#$ycliente}"
#z="x{10}"
#echo $z
#for x in `seq $ycliente`

#  substr: estrae una sottostringa, iniziando da posizione & lunghezza
#+ specificate
#b=`expr substr $a 2 6`
#echo "La sottostringa di \"$a\", iniziando dalla posizione 2,\
#e con lunghezza 6 caratteri è \"$b\"."
#${var:pos:lun}
#Espansione di un massimo di lun caratteri della variabile var, iniziando da pos. Vedi Esempio A-14 per una dimostrazione dell'uso creativo di questo


destina=$(echo "SELECT destina FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
destin2=$(echo "SELECT destin2 FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
destvia=$(echo "SELECT destvia FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
destcit=$(echo "SELECT destcit FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)

articoli=$(echo "
   SELECT
   articolo,
   lotto,
   quanti AS nr,
   prezzo,
   subtot,
   aliva AS '%iva',
   iva
   FROM  clifat2
   WHERE nrfat=$nrfat; 
 " | sqlite3 -column /home/cnt/cnt.db) 

pagamen=$(echo "SELECT pagamen FROM cliana WHERE idcli='$idcli';" | sqlite3 /home/cnt/cnt.db)
datatras=$(echo "SELECT datatras FROM clifat1 WHERE nrfat='$nrfat';" | sqlite3 /home/cnt/cnt.db)
datatrasgg=${datatras:4:2}
datatrasmm=${datatras:2:2}
datatrasaa=${datatras:0:2}
datatras1=$datatrasgg/$datatrasmm/20$datatrasaa
colli=$(echo "SELECT colli FROM clifat1 WHERE nrfat='$nrfat';" | sqlite3 /home/cnt/cnt.db)
trasp=$(echo "SELECT trasp FROM clifat1 WHERE nrfat='$nrfat';" | sqlite3 /home/cnt/cnt.db)

xtrasp=${#trasp}                    # lunghezza della stringa trasp
ytrasp=`expr 41 - $xtrasp`          # nr spazi da aggiungere per arrivare a |
ztrasp=`expr substr $xx 1 $ytrasp`



x="SUM(subtot)"
y="SUM(iva)"

impo4=$(echo "SELECT $x FROM clifat2 WHERE aliva=4 AND nrfat=$nrfat GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)
impo10=$(echo "SELECT $x FROM clifat2 WHERE aliva=10 AND nrfat=$nrfat GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)
impo21=$(echo "SELECT $x FROM clifat2 WHERE aliva=21 AND nrfat=$nrfat GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)
iva4=$(echo "SELECT $y FROM clifat2 WHERE aliva=4 AND nrfat=$nrfat GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)
iva10=$(echo "SELECT $y FROM clifat2 WHERE aliva=10 AND nrfat=$nrfat GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)
iva21=$(echo "SELECT $y FROM clifat2 WHERE aliva=21 AND nrfat=$nrfat GROUP BY aliva;" | sqlite3 /home/cnt/cnt.db)

# verifico le stringhe nulle altrimenti bc scassa

if [ -z $impo4 ]
then
 impo4a=0.00
 iva4a=0.00
else 
 impo4a=$impo4
 iva4a=$iva4
fi

if [ -z $impo10 ]
then
 impo10a=0.00
 iva10a=0.00
else 
 impo10a=$impo10
 iva10a=$iva10
fi

if [ -z $impo21 ]
then
 impo21a=0.00
 iva21a=0.00
else 
 impo21a=$impo21
 iva21a=$iva21
fi

##################### QUESTA ROBA NON VA, DA' ERRORE IN COMPILAZIONE: ########################


#ximpo4=${#impo4a}                    # lunghezza della stringa impo4
#yimpo4=`expr 16 - $impo4a`           # nr spazi da aggiungere per arrivare all'imponibile 4
#zimpo4=`expr 10 - $impo4a`           # nr spazi da aggiungere per arrivare a Imposta

###zimpo4=`expr substr $xx 1 $impo4`


#ximpo10=${#impo10a}                    # lunghezza della stringa impo10
#yimpo10=`expr 16 - $impo10a`           # nr spazi da aggiungere per arrivare all'imponibile 10
#zimpo10=`expr 10 - $impo10a`           # nr spazi da aggiungere per arrivare a Imponibile

###zimpo10=`expr substr $xx 1 $impo10`

#expr: argomenti non numerici
#expr: argomenti non numerici
#expr: argomenti non numerici
#expr: argomenti non numerici

#############################################################################################

totimpo=$(echo "scale=2; $impo4a + $impo10a + $impo21a" | bc)
totiva=$(echo "scale=2; $iva4a + $iva10a + $iva21a" | bc)
totfat=$(echo "scale=2; $totimpo + $totiva" | bc)
#+-------------------------------------------------------------------------------+
#|         AZIENDA  AGRICOLA  VALLINI  DANIELE  di  Olivetti  Alberto            |
#|                 prodotti  naturali  macinati  a  pietra                       |
#|                                                                               |
#|        13900 BIELLA VAGLIO - Via Bellavista 7 bis - tel 015 561180            |
#|        partita iva 02394330027  -  codice fiscale LVTLRT75H04A859O            |
#+---------------------------------------+---------------------------------------+

echo "
$mn ------------------------------------------------------------------------ $vn
"
echo > /home/cnt/fattura "













+-------------------------------+--------------------+--------------------------+
|    FATTURA ACCOMPAGNATORIA    |  NUMERO  $nrfat     |  DATA   $data1       |
+-------------------------------+--------------------+--------------------------+

+---------------------------------------+---------------------------------------+
|            DESTINAZIONE               |       DESTINATARIO SE DIVERSO         |
+---------------------------------------+---------------------------------------+

   $cliente $zcliente       $destina
   $clien2         $zclien2        $destin2
   $via $zvia       $destvia
   $citta $zcitta       $destcit
             
   p.iva $piva
   cod.fis. $codfis
      

"
#$articoli

echo > /home/cnt/sql "
.header ON
.mode column
.width 31 9 5 7 7 5 5
SELECT
   articolo,
   lotto,
   quanti AS 'nr',
   prezzo,
   subtot,
   aliva AS '%iva',
   iva
 FROM  clifat2
 WHERE nrfat=$nrfat;
" | sqlite3 -init /home/cnt/sql $db >> /home/cnt/fattura

echo >> /home/cnt/fattura "
--------------------------------------------------------------------------------

Imponibile 4%   $impo4a    Iva  $iva4a
Imponibile 10%  $impo10a   Iva  $iva10a
Imponibile 21%  $impo21a   Iva  $iva21a

Totale imponibile  $totimpo       Totale IVA $totiva       Totale fattura $totfat

PAGAMENTO: $pagamen

Contributo ambientale CONAI assolto

+-------------------------------+----------------------+-----------------------+
| DATA TRASPORTO:  $datatras1   | CAUSALE:  vendita    | NUMERO COLLI:  $colli
+----------------+--------------+----------------------+-----------------------+
| PORTO: franco  |   TRASPORTATORE: $trasp $ztrasp |
+----------------+-------------------------------------------------------------+

         Vettore                                firma del Destinatario

"
# quella vacca di bc ne' mette 0 davanti al . ne' pone sempre due decimali
# inoltre devo sostituire quel ^ usato per spaziare il destinatario

sed "s/ \./ 0./g
     s/\.0 /.00/g
     s/\.1 /.10/g
     s/\.2 /.20/g
     s/\.3 /.30/g
     s/\.4 /.40/g
     s/\.5 /.50/g
     s/\.6 /.60/g
     s/\.7 /.70/g
     s/\.8 /.80/g
     s/\.9 /.90/g
     s/\^/ /g
" /home/cnt/fattura > /home/cnt/fattura1
cat /home/cnt/fattura1
cs2
}

cs2(){
echo "
$mn ------------------------------------------------------------------------ $vn

$Rn (+) $gn stampa su stampante predefinita
$Rn (l) $gn stampa su EPL5500
$Rn (0) $gn stampa su porta lp0
$Rn (1) $gn stampa su porta lp1
$Rn (a) $gn altra fattura
$vn"
read x
case $x in
a) cs;;
"+") lp -o cpi=13 -o lpi=8 -o page-left=72 /home/cnt/fattura1;cs2;;
l) lp -d EPL5500 -o cpi=13 -o page-left=72 /home/cnt/fattura1; cs2;;
0) lp -o cpi=13 -o page-left=72 /home/cnt/fattura1 > /dev/lp0;cs2;;
1) lp -o cpi=13 -o page-left=72 /home/cnt/fattura1 > /dev/lp1;cs2;;
"<") cs;;
"<<") c;;
#l) a2ps -M 'A4' -R  -L 80 -B -s 2 --borders=0 --margin=20  -P EPL-5700 --columns=1 /home/cnt/fattura1;
#l) lpr -o cpi=12 -o page-left=90 -o page-top=30 -o lpi=7 -P EPL-5700 /cnt/fattura -P HPColor
# pr -o 2 -t /cnt/fattura | lpr -Plp0 -h
esac
cs2
}

cz(){
echo "
$mn ------------------------------------------------------------------------ $vn

          >>>  Numero fattura da annullare
          Inv  Elenco fatture
"
read nrfat
echo $nrfat
case $nrfat in
"")
 echo > /home/cnt/sql "
  SELECT *
  FROM giornale
  WHERE idope='cf'
  AND idcon like 'ac%'
  ORDER BY nrfat;"
 sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql
 cz;;
"<") c;;
"<<") c;
esac
echo > /home/cnt/sql "
 SELECT *
 FROM giornale
 WHERE idope='cf'
 AND nrfat=$nrfat;
 SELECT *
 FROM clifat1
 WHERE nrfat=$nrfat;
 SELECT *
 FROM clifat2
 WHERE nrfat=$nrfat;
 SELECT *
 FROM magazzino
 WHERE idmov='cf'
 AND nrfat=$nrfat;"
sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql
cz1
}

cz1(){
echo "
$mn ------------------------------------------------------------------------ $vn

          ++  Conferma annullamento
"
read x
case $x in
'++')
 echo > /home/cnt/sql "
 DELETE
 FROM giornale
 WHERE idope='cf'
 AND nrfat=$nrfat;
 DELETE
 FROM clifat1
 WHERE nrfat=$nrfat;
 DELETE
 FROM clifat2
 WHERE nrfat=$nrfat;
 DELETE
 FROM magazzino
 WHERE idmov='cf'
 AND nrfat=$nrfat;"
 sqlite3 -column -header /home/cnt/cnt.db < /home/cnt/sql
 echo "
          ***   ANNULLATA FATTURA $nrfat   ***
 ";;
'<') cz;;
'<<') c;;
esac
cz
}

c