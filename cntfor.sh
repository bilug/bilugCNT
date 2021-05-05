#!/bin/bash

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
#  www.bilug.it   linux@ml.bilug.linux.it

#  COLORAZIONE CON SEQUENZE ANSI

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
z="[0m";         # normale

bp="beep -f 100 -n -f 2000 -n -f 1500"
db=/home/cnt/cnt.db
sql=/home/cnt/sql

f() {
echo "

$gn         FORNITORI
$mn ---------------------------
$Rn (n) $gn nuova fattura
$Rn (p) $gn pagamento fattura
$Rn (q) $gn query
$Rn (a) $gn anagrafe fornitori
$z"
read x
case $x in
n) fn;;
p) fp;;
q) fq;;
a) fa;;
"<") /home/cnt/cnt1.sh ;;
"<<") /home/cnt/cnt1.sh ;;
esac
f
}

fa(){
echo > $sql "
SELECT idfor, fornitore
FROM forana
ORDER BY idfor;
" | sqlite3 -init $sql $db 

echo "
   Fornitori privi di anagrafica:
"
echo > /home/cnt/sql "

SELECT giornale.idfor
FROM giornale LEFT JOIN forana
ON giornale.idfor=forana.idfor
WHERE forana.idfor IS NULL
GROUP BY giornale.idfor;"
sqlite3 $db < /home/cnt/sql

echo "
$Rn (e) $gn elimina esistente
$Rn (m) $gn modifica esistente
$Rn (n) $gn nuovo"
read x
case $x in
e) fae;;
m) fam;;
n) fan;;
"<") f;;
"<<") f ;;
esac
fa
}

fae(){
echo " >>> codice fornitore"
read cod
case $cod in
"") fae;;
"<") fa;;
"<<") f ;;
esac
echo "
DELETE
FROM forana
WHERE idfor = '$cod';
" | $db
fa
}

fam(){
echo "
$Rn >>> $gn codice fornitore da modificare
"
read idfor
case $idfor in
"") 
    echo $vn
    echo "SELECT * FROM forana ORDER BY idfor;" | sqlite3 -header -column $db
    fam;;
"<") fa;;
"<<") f ;;
esac
echo > /home/cnt/sql "
SELECT *
FROM forana
WHERE idfor = '$idfor'"
sqlite3 $db < /home/cnt/sql

echo "

   dato da modificare

   (f)  codice fornitore
   (n)  nome 
   (v)  via
   (c)  città
   (i)  partita IVA
   (s)  codice fiscale

"
read x
case $x in
f) nome='codice fornitore'; id='idfor';;
n) nome='nome'; id='nome';;
v) nome='via'; id='via';;
c) nome='città'; id='citta';;
i) nome='partita IVA'; id='piva';;
s) nome='codice fiscale'; id='codfis';;
"<") fa;;
"<<") f ;;
esac
fam1
}

fam1(){
echo "
   >>> nuovo/a $nome
"
read x
echo > /home/cnt/sql "
UPDATE forana SET $id='$x' WHERE idfor='$idfor';
SELECT * FROM forana WHERE idfor='$idfor';"
sqlite3 $db < /home/cnt/sql
read x

fa
}


fan(){
echo "
$gn      ANAGRAFICA NUOVO FORNITORE

$Rn   >>> $gn codice fornitore"
read cod
case $cod in
"") fan;;
"<") fa;;
"<<") f ;;
esac

fan1
}

fan1(){
echo "
$Rn   >>> $gn nome"
read nome
case $nome in
"") fan1;;
"<") fan;;
"<<") f ;;
esac
fan2
}

fan2(){
echo "
$Rn   >>> $gn CAP Citta' Provincia"
read citta
case $citta in
"") fan2;;
"<") fan1;;
"<<") f ;;
esac
fan3
}

fan3(){
echo "[0;1;31m >>> [0m via"
read via
case $via in
"") fan3;;
"<") fan2;;
"<<") f ;;
esac
fan4
}

fan4(){
echo "[0;1;31m >>> [0m partita iva"
read piva
case $piva in
"") fan4;;
"<") fan3;;
"<<") f ;;
esac
fan5
}

fan5(){
echo "[0;1;31m >>> [0m codice fiscale
"
read codfis
case $codfis in
"<") fan4;;
"<<") f ;;
esac
fan6
}

fan6(){
echo > $sql "
.header ON
.mode column
.width 8 30

 INSERT INTO forana
 VALUES ('$cod','$nome','$via','$citta','$piva','$codfis');

 INSERT INTO giocon
 VALUES ('pf$cod','$nome');

 SELECT *
 FROM forana
 ORDER BY idfor;

 SELECT *
 FROM giocon
 WHERE idcon like 'pf%'
 ORDER BY idcon;
" | sqlite3 -init $sql $db
fa
}

fp(){
clear
echo "
$gn   PAGAMENTO FATTURA FORNITORE

$Rn   >>> $gn codice fornitore
$z"
read idfor
case $idfor in
"") fp01;;
"<") f;;
"<<") f ;;
esac
echo "
.header ON
.mode column
.width 8 8 8 8 8 8 8 30
SELECT *
FROM giornale
WHERE idcon like 'pf$idfor'
ORDER BY nrfat, data;
" | sqlite3 $db

saldo=`echo "
SELECT SUM(importo)
FROM giornale
WHERE idcon = 'pf$idfor';
" | sqlite3 $db`
fornitore=`echo "
SELECT fornitore
FROM forana
WHERE idfor='$idfor';
" | sqlite3 $db`
echo "
$gn Scritture fornitore $rn $idfor $fornitore
$gn saldo = $rn $saldo
"
fp1
}

fp01(){
echo $vn
echo "
.header ON
.mode column
.width 8 30
SELECT idfor, fornitore
FROM forana
WHERE idfor like 'pf%'
ORDER BY idfor;
" | sqlite3 $db
fp
}

fp1(){
echo "
$gn Fornitore $rn $idfor  $fornitore

$Rn >>> $gn numero fattura in pagamento
$z"
read nrfat
case $nrfat in
"") fp1;;
"<") f;;
"<<") f ;;
esac
echo "
.header ON
.mode column
.width 8 8 8 8 8 8 8 30
SELECT *
FROM giornale
WHERE idope like 'f%'
AND nrfat=$nrfat
ORDER BY data;
" | sqlite3 $db

echo "
$gn Scritture fornitore $rn $idfor $gn fattura nr $rn $nrfat
"
fp2
}

fp2(){
echo "
$gn Fornitore $rn $idfor  $fornitore
$gn fattura in pagamento nr $rn $nrfat

$Rn >>> $gn data pagamento (aammgg) def $rn $(date +%y%m%d--%a)
$z"
read data
case $data in
"") data="$(date +%y%m%d)";;
"<") fp;;
"<<") f ;;
esac
fp3
}

fp3(){
echo "
$gn Fornitore $rn $idfor  $fornitore
$gn Fattura in pagamento nr $rn $nrfat
$gn Data pagamento $rn $data

$Rn >>> $gn importo fattura
$z"
read importo
case $importo in
"") fp3;;
"<") fp2;;
"<<") f ;;
esac
fp4
}

fp4(){
echo "
$gn Fornitore               $rn $idfor  $fornitore
$gn Fattura in pagamento nr $rn $nrfat
$gn Data pagamento          $rn $data
$gn Importo fattura         $rn $importo

$Rn >>> $gn nota def $rn $idfor"
read nota
case $nota in
"") nota=$idfor;;
"<") fp3;;
"<<") f ;;
esac
echo "
$gn Bozza scritture pagamento fornitore $rn $idfor $fornitore $gn in data $rn $data
$vn"
echo "
DROP TABLE giornaletmp;
CREATE TABLE giornaletmp
(data TEXT,
 idope TEXT(4),
 idcon TEXT(10),
 importo REAL(12,2),
 nrfat INTEGER(3),
idfor TEXT(6),
codcli TEXT(6),
nota TEXT(50));
INSERT INTO giornaletmp VALUES('$data','fp','pf$idfor',$importo,$nrfat,'$idfor','0','$nota');
.header ON
.mode column
.width 10 8 8 8 8 8 8 30
SELECT *
FROM giornaletmp;
" | sqlite3 $db
fp5
}

fp5(){
#echo "
#.header ON
#.mode column
#.width 8 8 8 8 8 8 8 50
#SELECT * FROM giornaletmp;
#" | sqlite3 $db
echo "
$Rn >>> $gn codice conto addebitato
$z"
read idcon
case $idcon in
"") fp50;;
"<") fp5;;
"<<") f ;;
esac
conto=`echo "SELECT conto FROM giocon WHERE idcon = '$idcon';" | sqlite3 $db`
fp6
}

fp50(){
echo $vn
echo "
.header ON
.mode column
.width 8 30
SELECT *
FROM giocon
ORDER BY idcon;
" | sqlite3 $db
fp5
}

fp6(){
echo "
$gn Scritture esistenti conto $rn $idcon $conto:
$vn"
echo "
.header ON
.mode column
.width 8 8 8 8 8 8 8 30
SELECT *
FROM giornale
WHERE idcon='$idcon'
ORDER BY data;
" | sqlite3 $db
squadra=`echo "SELECT ROUND(SUM(importo),2) FROM giornaletmp;" | sqlite3 $db`
echo "
$gn Fornitore               $rn $idfor  $fornitore
$gn Fattura in pagamento nr $rn $nrfat
$gn Data pagamento          $rn $data
$gn Conto addebitato        $rn $idcon

$gn Squadratura bozza scrittura = $rn $squadra

$Rn >>> $gn importo addebitato
$z"
read importo
case $importo in
"") fp6;;
"<") fp5;;
"<<") f;;
esac
fp7
}

fp7(){
echo "
$gn Fornitore               $rn $idfor  $fornitore
$gn Fattura in pagamento nr $rn $nrfat
$gn Data pagamento          $rn $data
$gn Conto addebitato        $rn $idcon
$gn Importo addebitato      $rn $importo

$Rn >>> $gn nota  defaul $rn $idfor
$z"
read nota
case $nota in
"") nota=$idfor;;
"<") fp2;;
"<<") f ;;
esac
fp8
}

fp8(){
echo "
$gn Bozza scritture pagamento fornitore $rn $idfor $fornitore $gn in data $rn $data
$vn"
echo "
.header ON
.mode column
.width 8 8 8 8 8 8 8 50
INSERT INTO giornaletmp
VALUES('$data','fp','$idcon',$importo,$nrfat,'$idfor','0','$nota');
SELECT *
FROM giornaletmp;
" | sqlite3 $db
squadra=`echo "SELECT ROUND(SUM(importo),2) FROM giornaletmp;" | sqlite3 $db`
if [ "$squadra" = "0.0" ]
then fp9
else echo "
$gn le scritture non quadrano
$gn squadratura = $rn $squadra

$gn immettere i successivi movimenti
$gn di conto per la quadratura
"
fp5
fi
}

fp9(){
echo "
$gn Le scritture quadrano, puoi registrare

$Rn (.) $gn Registro
$Rn (-) $gn Rettifico scritture
$vn"
read x
case $x in
"") fp9;;
".") fp10;;
"-") fp11;;
"<") fp7;;
"<<") f;;
esac
fp9
}

fp10(){
echo "
$gn Scritture registrate in data $data:
$vn"
echo "
.header ON
.mode column
.width 8 8 8 8 8 8 8 30
INSERT INTO giornale
SELECT *
FROM giornaletmp;
SELECT *
FROM giornale
WHERE data='$data'
ORDER BY idope;
" | sqlite3 $db
echo "
$rn REGISTRAZIONE COMPLETATA
"
fp
}

fp11() {
echo "ancora da scrivere"
}

fq() {
echo "
$gn
   --------------------------------- 
     CONTABILITA' FORNITORI - QUERY 
   ---------------------------------  

$Rn Inv $gn anno corrente
$Rn >>  $gn anno precedente (aa)
"
read x
case $x in
"") gio=giornale;fq1;;
"<") f;;
"<<") f ;;
esac
gio=gio19$x
fq1
}

fq1() {

echo "
   -------------------------------------
      CONTABILITA FORNITORI  -  QUERY
             $rn  $gio
   -------------------------------------

$Rn  (f) $gn  fornitore
$Rn  (n) $gn  numero fattura
$Rn  (c) $gn  corrispettivi
$Rn  (e) $gn  elenco fatture

   -------------------------------------
"
read x
case $x in
c) fqc;;
e) fqe;;
f) fqf;;
n) fqn;;
"<") fq;;
"<<") f ;;
esac
fq
}

fqc(){
echo > /home/cnt/sql "
SELECT * from giornale
WHERE idope like 'fc'
ORDER BY data;"
sqlite3 $db < /home/cnt/sql
fq
}

fqe(){
echo "
 (e) elenco fiscale
 (d) per data
 (f) per fornitore
 (n) per numero"
read x
case $x in
e) fqef;;
d) ord=data;;
f) ord=idcon;;
n) ord=nrfat;;
"") fqe;;
"<") fq;;
"<<") f ;;
esac
echo "
SELECT * from giornale
WHERE idope like 'ff'
and idcon like 'pf%'
order by $ord;
" | sqlite3 $db
fqe
}

fqef(){
echo "
CREATE TEMPORARY TABLE imposta
(idfor TEXT(6), imposta int);

INSERT imposta
SELECT
idfor,ROUND(SUM(importo),2)*-1
FROM $gio
WHERE idope='ff'
AND idcon='aiva'
GROUP BY idfor;

CREATE TEMPORARY TABLE totali
(idfor TEXT(6), totali int);

INSERT totali
SELECT
idfor,SUM(importo)
FROM $gio
WHERE idope='ff'
AND idcon like 'pf%'
GROUP BY idfor;

SELECT
totali.idfor,
forana.codfis,
forana.piva,
totali.totali-imposta.imposta AS imponibili,
imposta.imposta,
totali.totali
FROM imposta,totali,forana
WHERE imposta.idfor=totali.idfor
AND forana.idfor=totali.idfor
ORDER BY totali.idfor;

SELECT
SUM(totali.totali)-SUM(imposta.imposta) AS 'imponibile totale',
SUM(imposta.imposta) AS 'imposta totale',
SUM(totali.totali) AS 'totale fatture'
FROM imposta,totali
WHERE imposta.idfor=totali.idfor;
" | sqlite3 $db > /home/cnt/dati
cat /home/cnt/dati
echo "
$Rn (+) $gn stampo elenco fiscale clienti
$z"
read x
case $x in
+) lp /home/cnt/dati;;
"<") gq;;
"<<") f ;;
esac
fqe
}

fqf(){
echo "
SELECT idcon from $gio
WHERE idcon like 'pf%'
GROUP BY idcon
ORDER BY idcon;
" | sqlite3 $db
fqf1
}

fqf1(){
echo "[0;1;31m >>> [0m  codice fornitore"
read cod
case $cod in
"<") fq;;
"<<") f ;;
esac
echo "
SELECT * from $gio
WHERE idcon like 'pf$cod'
ORDER BY nrfat,data;
SELECT SUM(importo) AS SALDO
FROM giornale
WHERE idcon like 'pf$cod';
" | sqlite3 $db
fq
}

fqn(){
echo "[0;1;31m >>> [0m  numero fattura"
read nrfat
case $nrfat in
"") fqn1;;
"<") fq;;
"<<") f ;;
esac
echo "
SELECT * from $gio
WHERE idope like 'f%'
AND nrfat=$nrfat
ORDER BY data;
SELECT SUM(importo)
AS SQUADRATURA
FROM $gio
WHERE idope like 'f%'
AND nrfat=$nrfat;
" | sqlite3 $db
fqn
}

fqn1(){
echo "
SELECT * from $gio
WHERE idope like 'f'
ORDER BY idfor
" | sqlite3 $db
fqn
}

fn() {
echo "
$gn  REGISTRAZIONE  FATTURA  FORNITORE
$mn -----------------------------------

$Rn   >>>  $gn data fattura aammgg
        $gn (default $rn $(date +%y%m%d))
$z"
read data
case $data in
'') data=$(date +%y%m%d);fn1;;
'<') f;;
'<<') f ;;
esac
fn1
}

fn1(){

echo "
$gn  REGISTRAZIONE  FATTURA  FORNITORE
$mn -----------------------------------

$vn ULTIME 5 FATTURE FORNITORE REGISTRATE:
"
echo "
SELECT
data,idcon,importo,nrfat
from giornale
WHERE idope = 'ff'
and idcon like 'pf%'
ORDER BY nrfat desc
LIMIT 5;
" | sqlite3 $db
echo "
$vn data fattura $data

$Rn >>> $gn numero fattura
"
read nrfat
case $nrfat in
"") fn1;;
"<") fn;;
"<<") f ;;
esac
fn2
}


fn2(){
echo "
$gn REGISTRAZIONE  FATTURA  FORNITORE
$mn ---------------------------------

$vn data fattura   $rn $data
$vn numero fattura $rn $nrfat

$Rn >>> $gn codice fornitore
$z"
read idfor
case $idfor in
"")
   echo $vn
   echo "
   SELECT *
   FROM forana
   ORDER BY idfor;
   " | sqlite3 $db
   fn2;;
"<") fn;;
"<<") f ;;
esac
fn3
}


fn3(){
echo "
SELECT *
FROM forana
WHERE idfor= '$idfor';
SELECT *
FROM giornale
WHERE idcon like 'pf$idfor'
ORDER BY data;
" | sqlite3 $db

echo "
$gn   REGISTRAZIONE  FATTURA  FORNITORE
$mn  -----------------------------------

$vn   data fattura     $rn  $data
$vn   numero fattura   $rn  $nrfat
$vn   codice fornitore $rn  $idfor

$Rn   >>> $gn importo totale
$gn        (- se fattura  + se nota di accredito)

"
read importo
case $importo in
"") fn3;;
"<") fn2;;
"<<") f ;;
esac
fn4
}

fn4(){
echo "
$gn REGISTRAZIONE  FATTURA  FORNITORE
$mn ---------------------------------
$vn data fattura     $rn $data
$vn numero fattura   $rn $nrfat
$vn codice fornitore $rn $idfor
$vn importo totale   $rn $importo

$Rn >>> $gn nota eventuale
"
read nota
case $nota in
"<") fn3;;
"<<") f ;;
esac
fn5
}

fn5(){
echo $vn
echo "
.header ON
.mode column
.width 8 4 8 8 8 8 8 30

DROP TABLE giornaletmp;

CREATE TABLE giornaletmp
(data TEXT,
 idope TEXT(4),
 idcon TEXT(10),
 importo REAL(12,2),
 nrfat INTEGER(3)  ,
 idfor TEXT(6),
 idcli TEXT(6),
 nota TEXT(50));

INSERT INTO giornaletmp
VALUES ('$data','ff','pf$idfor',$importo,$nrfat,'$idfor','','$nota');

SELECT * FROM giornaletmp;
" | sqlite3 $db

squadra=`echo "SELECT ROUND(SUM(importo),2) FROM giornaletmp;" | sqlite3 $db`
echo " 
$vn SQUADRATURA = $rn $squadra
"
fn6
}

fn6(){ 
echo "
$mn ---------------------------------

$Rn >>> $gn importo IVA

$gn      (+ se fattura   - se nota di accredito)

"
read iva
case $iva in
"<") fn3;;
"<<") f ;;
esac
echo $vn
echo "
.header ON
.mode column
.width 8 4 8 8 8 8 8 30
INSERT INTO giornaletmp
VALUES ('$data','ff','aiva',$iva,$nrfat,'$idfor','','$nota');
SELECT * FROM giornaletmp;
" | sqlite3 $db

squadra=`echo "SELECT ROUND(SUM(importo),2) FROM giornaletmp;" | sqlite3 $db`

echo "
$vn SQUADRATURA = $rn $squadra
"
fn7
}

fn7(){
echo "
$mn ---------------------------------

$Rn   >>>   $gn codice conto
$Rn   (Inv) $gn elenco conti
$Rn   (<)   $gn indietro
$Rn   (<<)  $gn inizio
"
read idcon
case $idcon in
"")
echo $vn
echo "
SELECT * FROM giocon
ORDER BY idcon;
" | sqlite3 $db
#> /home/cnt/dati
#pr -T -5 -W 130 < /home/cnt/dati
fn7;;
"<") fn6;;
">>") f ;;
esac
echo $vn
echo "
.header OFF
.mode column
.width 8 30
SELECT idcon, conto
FROM giocon
WHERE idcon ='$idcon';
" | sqlite3 $db
fn8
}

fn8(){
squadra=`echo "SELECT ROUND(SUM(importo),2) FROM giornaletmp;" | sqlite3 $db`

echo "$vn
squadratura = $rn $squadra

$Rn >>> $gn importo
$gn      (+ se fattura   - se nota di accredito)
"
read importo
case $importo in
"") fn8;;
"<") fn7;;
"<<") f ;;
esac
echo "
.header ON
.mode column
.width 8 4 8 8 8 8 8 30
INSERT INTO giornaletmp
VALUES ('$data','ff','$idcon',$importo,$nrfat,'$idfor','','$nota');
SELECT * FROM giornaletmp;
" | sqlite3 $db

squadra=`echo "SELECT ROUND(SUM(importo),2) FROM giornaletmp;" | sqlite3 $db`

echo "
$vn SQUADRATURA = $rn $squadra
"
if [[ "$squadra" = "0.0" ]]
then echo "
$gn le scritture quadrano, puoi registrare
"
fn9
else echo "
$gn le scritture non quadrano
"
fn7
fi
}

fn9(){
echo "
$mn ---------------------------------

$Rn (.) $gn registro nuova fattura
"
read x
case $x in
"") fn9;;
".") fn10;;
#/) fnr;;
"<") fn;;
"<<") f ;;
esac
}

fn10(){
echo "
$vn Scritture contabili in data $data
"
echo "
.header ON
.mode column
.width 8 4 8 8 8 8 8 30
INSERT INTO giornale
SELECT * FROM giornaletmp;
SELECT * FROM giornale WHERE data='$data' ORDER BY idope;
" | sqlite3 $db

squadra=`echo "SELECT ROUND(SUM(importo),2) FROM giornale;" | sqlite3 $db`

echo "
$vn SQUADRATURA GIORNALE = $rn $squadra

$mn ---------------------------
$mn   REGISTRAZIONE TERMINATA
$mn ---------------------------
$z
"
f
}

fnr(){
echo > /home/cnt/sql "

SELECT *
FROM giornaletmp;"
sqlite3 $db < /home/cnt/sql > /home/cnt/dati
mcedit /home/cnt/dati
echo "
DELETE FROM giornaletmp;
LOAD DATA INFILE '/home/cnt/dati'
INTO TABLE giornaletmp;
SELECT *
FROM giornaletmp;
" | sqlite3 $db
echo "[0;1;31m (.) [0m registra
[0;1;31m (/) [0m rettifica
[0;1;31m (+) [0m continua"
read x
case $x in
".") fr10;;
"/") frr;;
"<") fr;;
"+") fr3;;
"<<") f ;;
esac
}

f