#!/bin/bash

#
#  Questo file eseguibile e' parte del programma di contabilita' scritto e
#  mantenuto da Daniele Vallini del Gruppo Linux di Biella (BiLUG)
#
#   vallini.daniele@bilug.linux.it         www.bilug.it
#
#  Il programma e' in progressivo sviluppo e viene fornito privo di
#  qualsiasi garanzia poiche' e' compito dell' utilizzatore
#  verificarne l' adeguatezza alle proprie esigenze.
#
#  Il programma e' liberamente utilizzabile nei termini della licenza GPL3
#
#   http://www.gnu.org/licenses/gpl.txt
#
#  E' gradita ogni forma di collaborazione segnalando commenti, sviluppi
#  ed integrazioni al Gruppo Linux di Biella - BiLUG
#
#  Il codice puo' essere liberamente modificato ed adattato ma questo
#  commento introduttivo deve essere mantenuto
#

# colorazione con sequenze ANSI

nn="[0;0;40m"    # fondo nero
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

db=/home/cnt/cnt.db  # file del database
sql=/home/cnt/sql    # file dell'SQL

##########  FUNZIONI  ##########


g() {
echo "
$Rn  (n) $gn nuovo movimento
$Rn  (q) $gn query
$Rn  (m) $gn manutenzioni
"
read x
case $x in
m) gm;;
n) gn;;
q) gq;;
"<") /home/cnt/cnt1.sh;;
"<<") /home/cnt/cnt1.sh;;
esac
g

}

gac() {
echo > /home/cnt/sql "
SELECT *
FROM giocon
ORDER BY cod;"
sqlite3 /home/cnt/cnt.db < /home/cnt/sql > /home/cnt/dati
mcedit  /home/cnt/dati
echo > /home/cnt/sql "
DELETE FROM giocon;
LOAD DATA INFILE '/home/cnt/dati'
INTO TABLE giocon;"
sqlite3 /home/cnt/cnt.db < /home/cnt/sql
}

gao() {
echo > /home/cnt/sql "
;
SELECT *
FROM gioope
ORDER BY cod;"
sqlite3 /home/cnt/cnt.db < /home/cnt/sql > /home/cnt/dati
mcedit  /home/cnt/dati
echo > /home/cnt/sql "
;
DELETE FROM gioope;
LOAD DATA INFILE '/home/cnt/dati'
INTO TABLE gioope;"
sqlite3 /home/cnt/cnt.db < /home/cnt/sql
}

gm(){
echo "
$Rn (c) $gn conti
$Rn (o) $gn codici operazione
$Rn (s) $gn squadrature
$z"
read x
case $x in
c) gmc;;
o) gmo;;
s) gms;;
"<") g;;
"<<") g;;
esac
gm
}

gmc(){
echo "
$gn       CONTI ESISTENTI
$vn"
echo "
.header ON
.mode column
.width 10 25
SELECT
idcon AS codice,
conto
FROM giocon
ORDER BY idcon;
" | sqlite3 $db

echo "
$Rn (+) $gn creo nuovo conto
$Rn (-) $gn elimino conto esistente
$z"
read x
case $x in
"+") gmc+;;
"-") gmc-;;
"<") gm;;
"<<") g;;
esac
gmc
}

gmc+(){
echo "
$Rn >>> $gn immettere nuovo codice conto max 10 caratteri
$z"
read idcon
case $idcon in
"") gmc+;;
"<") gmc;;
"<<") g;;
esac
gmc+1
}

gmc+1(){
echo "
$gn      nuovo codice conto $rn $idcon
$Rn >>> $gn immettere descrizione conto max 25 caratteri
$z"
read conto
case $conto in
"") gmc+1;;
"<") gmc+;;
"<<") g;;
esac
gmc+2
}

gmc+2(){
echo "
$gn nuovo codice conto $rn $idcon $gn descrizione $rn $conto


$Rn (+) $gn memorizzo nuovo codice conto e descrizione
$Rn (-) $gn abbandono la memorizzazione
$z"
read x
case $x in
"") gmc+2;;
"<") gmc+1;;
"<<") g;;
esac
echo "
INSERT INTO giocon
VALUES ('$idcon', '$conto');
" | sqlite3 $db
echo "
$mn   ------------------------------------------
$mn      ***   REGISTRAZIONE ESEGUITA   ***
$mn   ------------------------------------------
$z"
gmc
}

gmc-(){
echo "
$Rn >>> $gn immettere codice conto da eliminare
$z"
read idcon
case $idcon in
"") gmc-;;
"<") gmc;;
"<<") g;;
esac
echo $vn
echo "
.header ON
.mode column
.width 6 25
SELECT
idcon AS codice,
conto
FROM giocon
WHERE idcon = '$idcon';
" | sqlite3 $db
gmc-1
}

gmc-1(){
echo "
$Rn (+) $gn elimino codice conto e descrizione
$Rn (-) $gn abbandono la procedura
$z"
read x
case $x in
"+") gmc-2;;
"-") gmc;;
"<") gmc-;;
"<<") g;;
esac
gmc-2
}

gmc-2(){
echo "
DELETE FROM giocon
WHERE idcon='$idcon';
" | sqlite3 $db
echo "
$mn   -----------------------------------------
$mn       ***   ELIMINAZIONE ESEGUITA   ***
$mn   -----------------------------------------
$z"
gmc
}

gmo(){
echo "
$gn   CODICI OPERAZIONE ESISTENTI
$vn"
echo "
.header ON
.mode column
.width 6 25
SELECT
idope AS codice,
operazio AS '   descrizione'
FROM gioope
ORDER BY idope;
" | sqlite3 $db

echo "
$Rn (+) $gn creo nuovo codice operazione
$Rn (-) $gn elimino codice operazione esistente
$z"
read x
case $x in
"+") gmo+;;
"-") gmo-;;
"<") gm;;
"<<") g;;
esac
gmo
}

gmo+(){
echo "
$Rn >>> $gn immettere nuovo codice max 3 caratteri
$z"
read idope
case $idope in
"") gmo+;;
"<") gmo;;
"<<") g;;
esac
gmo+1
}

gmo+1(){
echo "
$gn      nuovo codice $rn $idope
$Rn >>> $gn immettere descrizione codice max 25 caratteri
$z"
read operazio
case $operazio in
"") gmo+1;;
"<") gmo+;;
"<<") g;;
esac
gmo+2
}

gmo+2(){
echo "
$gn nuovo codice operazione $rn $idope $gn descrizione $rn $operazio


$Rn (+) $gn memorizzo nuovo codice e descrizione
$Rn (-) $gn abbandono la memorizzazione
$z"
read x
case $x in
"") gmo+2;;
"<") gmo+1;;
"<<") g;;
esac
echo "
INSERT INTO gioope
VALUES ('$idope', '$operazio');
" | sqlite3 $db
echo "
$mn   ------------------------------------------
$mn      ***   REGISTRAZIONE ESEGUITA   ***
$mn   ------------------------------------------
$z"
gmo
}

gmo-(){
echo "
$Rn >>> $gn immettere codice da eliminare
$z"
read idope
case $idope in
"") gmo-;;
"<") gmo;;
"<<") g;;
esac
echo $vn
echo "
.header ON
.mode column
.width 6 25
SELECT
idope AS codice,
operazio AS '   descrizione'
FROM gioope
WHERE idope = '$idope';
" | sqlite3 $db
gmo-1
}

gmo-1(){
echo "
$Rn (+) $gn elimino codice e descrizione
$Rn (-) $gn abbandono la memorizzazione
$z"
read x
case $x in
"+") gmo-2;;
"-") gmo;;
"<") gmo-;;
"<<") g;;
esac
gmo-2
}

gmo-2(){
echo "
DELETE FROM gioope
WHERE idope='$idope';
" | sqlite3 $db
echo "
$mn   -----------------------------------------
$mn       ***   ELIMINAZIONE ESEGUITA   ***
$mn   -----------------------------------------
$z"
gmo
}

gms(){
echo > /home/cnt/sql "
;
DROP TABLE IF EXISTS giotmp;
CREATE TABLE giotmp
(data DATE,
importo DOUBLE(12,2));
INSERT giotmp
SELECT data,SUM(importo)
FROM giornale
GROUP BY data;
SELECT *
FROM giotmp
WHERE importo >0.01;
SELECT *
FROM giotmp
WHERE importo <-0.01;"
sqlite3 /home/cnt/cnt.db -t < /home/cnt/sql
}

gn() {
clear
echo "
$Rn >>> $gn data scrittura $vn (aammgg)

     $gn default oggi $vn `date +%y%m%d-%A`$z

"
read data
case $data in
"") data=`date +%y%m%d`; gn1;; 
"<") g;;
"<<") g;;
esac
gn1
}

gn1(){
clear
squadra=`echo "SELECT round(sum(importo),2) FROM giornale;" | sqlite3 $db`
echo "
$gn scritture giornale in data $data:
$vn"
echo "
.header ON
.mode column
.width 8 8 8 10 8 8 8 50
SELECT *
FROM giornale
WHERE DATA = '$data'
ORDER BY idope,nrfat;
" | sqlite3 $db
echo "
$gn Squadratura Giornale = $rn $squadra
$z"
gn2
}

gn2(){
echo "
$vn   data   $data   `date +%A -d $data`

$Rn   >>>  $gn codice operazione
$z"
read idope
case $idope in
"") gn2a;;
"<") gn;;
"<<") g;;
esac
operazione=$(echo "SELECT operazio FROM gioope WHERE idope='$idope';" | sqlite3 $db)
if [[ $operazione = "" ]]
then echo "
$Rn codice operazione sconosciuto, immettere codice corretto
"
gn2
fi
echo "$vn  $operazione"

echo > /home/cnt/sql "
DROP TABLE IF EXISTS giornaletmp;
CREATE TABLE giornaletmp
(data    TEXT(6),
 idope   TEXT(4),
 conto   TEXT(10),
 importo REAL(12,2),
 nrfat   INT(4),
 idfor   TEXT(6),
 idcli   TEXT(6),
 nota    TEXT(50));"
sqlite3 /home/cnt/cnt.db < /home/cnt/sql
gn3
}

gn2a(){
clear
echo $vn
echo "
.header ON
.mode column
.width 6 25
SELECT *
FROM gioope
ORDER BY idope;
" | sqlite3 $db
echo $z
gn2
}

gn3(){
nrfat=0
echo "
$vn data         $data   `date +%A -d $data`
$vn operazione   $idope  $operazione

$Rn   >>>  $gn codice conto
$z"
read idcon
case $idcon in
"") gn3a;;
#"<") gn2;;
"<<") g;;
esac
idcon=$(echo "SELECT idcon FROM giocon WHERE idcon='$idcon';" | sqlite3 $db)
conto=$(echo "SELECT conto FROM giocon WHERE idcon='$idcon';" | sqlite3 $db)
if [[ $idcon = "" ]]
then echo "
$Rn codice conto sconosciuto, immettere codice corretto
"
gn3
fi
gn4
}

gn3a(){
#echo "
#$bb                                                                         $z

#   $Rn (a) $gn attivita'
#   $Rn (p) $gn passivita'
#   $Rn (c) $gn costi
#   $Rn (r) $gn ricavi
#   $Rn (n) $gn capitale netto
#$z"
#read id
echo $vn
echo "
.header ON
.mode column
.width 6 30
SELECT *
FROM giocon
ORDER BY idcon;
" | sqlite3 $db
gn3
}

gn4(){
clear
echo "
$gn Ultime 15 scritture conto $rn $idcon  $conto:
$vn"
echo "
.header ON
.mode column
.width 7 5 5 11 6 6 6 50

SELECT *
FROM giornale
WHERE idcon = '$idcon'
ORDER BY data desc
LIMIT 15;
" | sqlite3 $db
saldo=`echo "SELECT ROUND(SUM(importo),2) FROM giornale WHERE idcon='$idcon';" | sqlite3 $db`
echo "
$vn Saldo Conto = $rn $saldo
"
#$gn Bozza Scritture:
#$vn
#echo "
#.header ON
#.mode column
#.width 8 8 8 10 8 8 8 30
#SELECT * FROM giornaletmp;
#" | sqlite3 $db
#sum='SUM(importo)'
#squadra=`echo "SELECT round(sum(importo),2) FROM giornaletmp;" | sqlite3 $db`
echo "
$gn Bozza scrittura in corso:
$vn
 data          $data   `date +%A -d $data`
 operazione    $idope       $operazione
 conto         $idcon      $conto

$gn squadratura =$rn $squadra

$Rn >>> $gn importi
$z"
read impo
case $impo in
"") gn4;;
"<") gn3;;
"<<") g::
esac
#tot=`echo "$importo" | bc`
importo=`echo "$impo" | bc`;
echo "
$vn totale = $rn $importo
"
gn5
}

gn5(){
clear
echo "
$vn data          $data   `date +%A -d $data`
$vn operazione    $idope      $operazione
$vn conto         $idcon      $conto
$vn importo       $importo

$Rn >>> $gn eventuale nota   default: $rn $nota
$z"
read nota0
case $nota0 in
"") gn6;;
"<") gn4;;
"<<") g;;
esac
nota=$nota0
gn6
}

gn6(){
clear
echo $vn
echo "
.header ON
.mode column
.width 8 8 8 10 8 8 8 50
INSERT INTO giornaletmp
VALUES ('$data','$idope','$idcon','$importo','$nrfat','0','0','$nota');
SELECT * FROM giornaletmp;
" | sqlite3 $db
sum='SUM(importo)'
squadra=`echo "SELECT round(sum(importo),2) FROM giornaletmp;" | sqlite3 $db`
if [ "$squadra" = "0.0" ]
then gn7
else echo "
$gn le scritture non quadrano
$gn squadratura = $rn $squadra

$gn immettere i successivi movimenti
$gn di conto per la quadratura
"
gn3
fi 
}

gn7(){
clear
echo $vn
echo "
.header ON
.mode column
.width 8 8 8 10 8 8 8 50
SELECT * FROM giornaletmp;
" | sqlite3 $db

echo "
$mn ***   le scritture quadrano   ***

$Rn (+) $gn continuare le scritture
$Rn (-) $gn rettifica (il modulo e un cesso, da rivedere)
$Rn (.) $gn registrazione
$z"
read x
case $x in
"+") gn3;;
"-") gn8;;
".") gn9;;
"<") gn5;;
"<<") gn;;
esac
gn7
}

gn8() {
clear
echo "
SELECT *
FROM giornaletmp;
" | sqlite3 $db > /home/cnt/dati
#mcedit -back white -g 75x10+210+0 /home/cnt/dati
mcedit  /home/cnt/dati
echo $vn
echo "
DELETE FROM giornaletmp;
.header ON
.mode column
.width 8 8 8 10 8 8 8 50
.import '/home/cnt/dati' 'giornaletmp';
DELETE FROM giornaletmp
WHERE data='0000-00-00'
OR importo is NULL;
SELECT SUM(importo) FROM giornaletmp;
SELECT * FROM giornaletmp;
" | sqlite3 $db
# > /home/cnt/dati1
#xterm -bg beige -fg blue -g 90x15 -e less /home/cnt/dati1 &
echo "
[0;1;31m (/) [0m ripetere verifica
[0;1;31m (+) [0m continua scritture
[0;1;31m (.) [0m registrazione"
read x
case $x in
"/") gn8;;
"+") gn6;;
".") gn9;;
esac
gn8
}

gn9() {
clear
echo "
.header ON
.mode column
.width 8 8 8 10 8 8 8 50
INSERT INTO giornale
SELECT * FROM giornaletmp;
SELECT *
FROM giornale
WHERE data='$data'
order by idope;
" | sqlite3 $db
echo "
$rn COMPLETATA REGISTRAZIONE SCRITTURE GIORNALE IN DATA $data
$vn"
gn
}

gq() {
echo "
$gn

    --------------------------------
      CONTABILITA' GENERALE - QUERY
    ---------------------------------

$Rn   (Inv)  $gn attuale
          -------------------------------
"
read gio
case $gio in
"") gio=giornale;;
"<") g;;
"<<") g;;
esac
gq1
}

gq1() {
echo "
$Rn (s)  $gn saldo conti
$Rn (c)  $gn per conto
$Rn (d)  $gn per data
$Rn (g)  $gn generica
$Rn (ec) $gn elenco clienti
$Rn (ef) $gn elenco fornitori
"
read x
case $x in
c) gqc;;
d) gqd;;
ec) gqec;;
ef) gqef;;
g) gqg;;
s) gqs;;
"")  gq1;;
"<") gq;;
"<<") g;;
esac
}

gqc(){
echo "
$Rn >>> $gn codice conto
$z"
read idcon
case $idcon in
"") gqc1;;
"<") gq1;;
"<<") /g;;
esac
conto=`echo "SELECT conto FROM giocon WHERE idcon='$idcon';" | sqlite3 $db`
echo "
 Estratto Conto $conto ($idcon) al $(date +%d.%m.%Y)
   (+ dare     - avere)
" > /home/cnt/dati
echo "
.header ON
.mode column
.width 7 5 5 9 7 7 7 40
SELECT * FROM $gio
WHERE idcon = '$idcon'
ORDER BY data;
" | sqlite3  $db >> /home/cnt/dati
echo >> /home/cnt/dati
echo "
SELECT  ROUND(SUM(importo),2) AS SALDO FROM $gio
WHERE idcon = '$idcon';
" | sqlite3 -line $db >> /home/cnt/dati
echo $vn
cat /home/cnt/dati
gqc2
}

gqc1(){
echo $vn
echo "
.header ON
.mode column
.width 10 25
SELECT *
FROM giocon
WHERE idcon like '$c%'
ORDER BY idcon;
" | sqlite3  $db
# > /home/cnt/dati
#pr -t -l 60 -w 100 -3 /home/cnt/dati
gqc
}

gqc2(){
echo "
$Rn (s) $gn stampa
$Rn Inv $gn no stampa
$z"
read x
case $x in
"s") gqc3;;
"<") gqc;;
"<<") g;;
"") gqc;;
esac
}

gqc3(){
#a2ps -M 'A4' -R --columns=100 --rows=40 -1 -f 8 -B --borders=0 /home/cnt/dati
lp -o cpi=16 -o page-left=30 -o page-top=30 -o lpi=7 /home/cnt/dati
echo "
*** ATTENDERE STAMPA ***
"
sleep 5
gqc
}

gqd(){
echo "
$bb                                                                         $z

[0;1;31m > [0m data"
read data
case $data in
"") gqd;;
"<") gq;;
"<<") g;;
esac
echo $vn
echo "
.header ON
.mode column
.width 8 4 5 9 9 9 9 40
SELECT *
FROM $gio
WHERE data ='$data' ;
" | sqlite3 $db
gqd
}

gqec(){
echo "
   -----------------------------
    (c)  verifica per cliente
    (d)  verifica per data
    (n)  verifica per fattura

    (+)  procedo
    (-)  indietro
    (<)  inizio
   -----------------------------
"
read x
case $x in
c) y=nota;;
d) y=data;;
n) y=nrfat;;
+) gqec1;;
-) gq;;
"<") g;;
esac
echo > /home/cnt/sql "
;
SELECT * FROM $gio
WHERE idope='cf'
ORDER BY $y;"
sqlite3 /home/cnt/cnt.db  < /home/cnt/sql
gqec
}


gqec(){
echo "
   -----------------------------
          ELENCO  CLIENTI
   -----------------------------
    (c)  ordina per cliente
    (n)  ordina per nr fattura
    
    (+)  procedo
    (-)  indietro
    (<)  inizio
   -----------------------------    
"
read x     
case $x in
c) y=codcli;;
n) y=nrfat;;
+) gqec1;;
-) gq;;
"<") g;;
esac

echo > /home/cnt/sql "
;

SELECT data,codcli,nrfat,importo
FROM $gio
WHERE idope='cf'
AND conto like 'ac%'
ORDER BY $y,nrfat;"
sqlite3 /home/cnt/cnt.db  < /home/cnt/sql
gqec
}

gqec1(){
echo > /home/cnt/sql "
;

CREATE TEMPORARY TABLE imposta
(codcli char(6), imposta int);

INSERT imposta
SELECT
codcli,ROUND(SUM(importo))*-1
FROM $gio
WHERE idope='cf'
AND conto='aiva'
GROUP BY codcli;

CREATE TEMPORARY TABLE totali
(codcli char(6), totali int);

INSERT totali
SELECT
codcli,SUM(importo)
FROM $gio
WHERE idope='cf'
AND conto like 'ac%'
GROUP BY codcli;

SELECT
totali.codcli,
cliana.piva,
totali.totali-imposta.imposta AS imponibili,
imposta.imposta,
totali.totali
FROM imposta,totali,cliana
WHERE imposta.codcli=totali.codcli
AND cliana.codcli=totali.codcli
ORDER BY totali.codcli;

SELECT
SUM(totali.totali)-SUM(imposta.imposta) AS 'imponibile totale',
SUM(imposta.imposta) AS 'imposta totale',
SUM(totali.totali) AS 'totale fatture'
FROM imposta,totali
WHERE imposta.codcli=totali.codcli"
sqlite3 /home/cnt/cnt.db  < /home/cnt/sql > /home/cnt/dati
cat /home/cnt/dati
echo "
   -----------------------------
           ELENCO  CLIENTI
   -----------------------------
    (+)  stampo elenco
    (<)  indietro
    (<)  inizio
   -----------------------------    
"
read x     
case $x in
+) pr -o 6 -h "" /home/cnt/dati | lp -P EPL-5700;;
"<") gq;;
"<<") g;;
esac
gqec
}


gqef(){
echo "
   -----------------------------
         ELENCO  FORNITORI
   -----------------------------
    (f)  ordina per fornitore
    (n)  ordina per nr fattura

    (+)  procedo
    (<)  indietro
    (<<)  inizio
   -----------------------------
"
read x
case $x in
f) y=codfor;;
n) y=nrfat;;
+) gqef1;;
"<") gq;;
"<<") g;;
esac

echo > /home/cnt/sql "
;

SELECT data,codfor,nrfat,importo
FROM $gio
WHERE idope='ff'
AND conto like 'pf%'
ORDER BY $y,nrfat;"
sqlite3 /home/cnt/cnt.db  < /home/cnt/sql
gqef
}

gqef1(){
echo > /home/cnt/sql "
;

CREATE TEMPORARY TABLE imposta
(codfor char(6), imposta int);

INSERT imposta
SELECT
codfor,ROUND(SUM(importo))
FROM $gio
WHERE idope='ff'
AND conto='aiva'
GROUP BY codfor;

CREATE TEMPORARY TABLE totali
(codfor char(6), totali int);

INSERT totali
SELECT
codfor,SUM(importo)*-1
FROM $gio
WHERE idope='ff'
AND conto like 'pf%'
GROUP BY codfor;

SELECT
totali.codfor,
forana.piva,
totali.totali-imposta.imposta AS imponibili,
imposta.imposta,
totali.totali
FROM imposta,totali,forana
WHERE imposta.codfor=totali.codfor
AND forana.codfor=totali.codfor
ORDER BY totali.codfor;

SELECT
SUM(totali.totali)-SUM(imposta.imposta) AS 'imponibile totale',
SUM(imposta.imposta) AS 'imposta totale',
SUM(totali.totali) AS 'totale fatture'
FROM imposta,totali
WHERE imposta.codfor=totali.codfor"
sqlite3 /home/cnt/cnt.db  < /home/cnt/sql > /home/cnt/dati
cat /home/cnt/dati
echo "
   -----------------------------
         ELENCO  FORNITORI
   -----------------------------
    (+)  stampo elenco
    (<)  indietro
    (<<)  inizio
   -----------------------------
"
read x
case $x in
+) pr -o 6 -h "" /home/cnt/dati | lp -P EPL-5700;;
"<") gq;;
"<<") g;;
esac
gqef
}


gqg(){
echo "[0;1;31m (>) [0m data > di
[0;1;31m (<) [0m data < di
[0;1;31m (=) [0m data =
 default >"
read data1
case $data1 in
"")data1='>';;
"<") gq;;
"<<") g;;
esac
echo '   data' $data1
echo "[0;1;31m >>> [0m data, default 2000-01-01"
read data2
case $data2 in
"")data2=2000-01-01;;
"<") gq;;
"<<") g;;
esac
echo '   data' $data1 ' ' $data2
echo "[0;1;31m >>> [0m codice operazione"
read idope
case $idope in
"") idope=%;;
"<") gq;;
"<<") g;;
esac
echo '   data' $data1 ' ' $data2 '
   idope '$idope
echo "[0;1;31m >>> [0m conto"
read conto
case $conto in
"") conto=%;;
"<") gq;;
"<<") g;;
esac
echo "[0;1;31m >>> [0m importo"
read importo
case $importo in
"") importo='>-999999999';;
"<") gq;;
"<<") g;;
esac
echo "[0;1;31m >>> [0m numero fattura"
read nrfat
case $nrfat in
"") nrfat='>-1';;
"<") gq;;
"<<") g;;
esac
echo "[0;1;31m >>> [0m nota o parte di essa"
read nota
case $nota in
"") nota=%;;
"<") gq;;
"<<") g;;
esac
echo > /home/cnt/sql "
;
SELECT * FROM $gio
WHERE data $data1 '$data2'
AND idope like '$idope'
AND conto like '$conto'
AND importo $importo
AND nrfat $nrfat
AND nota like '%$nota%'
ORDER BY data;"
echo '[0m'
sqlite3 /home/cnt/cnt.db  < /home/cnt/sql
# > /home/cnt/dati
echo > /home/cnt/sql "
;
SELECT ('   SALDO CONTO ',SUM(importo)) FROM $gio
WHERE data $data1 '$data2'
AND idope like '$idope'
AND conto like '$conto'
AND importo $importo
AND nrfat $nrfat
AND nota like '%$nota%';"
sqlite3 /home/cnt/cnt.db -N < /home/cnt/sql
# >> /home/cnt/dati
#xterm -g 85x15+250+360 -e less /home/cnt/dati &
gq
}

gqn(){
echo " [0;1;31m >>> [0m nota o parte di essa"
read nota
case $nota in
"<")gq;;
"<<")g;;
esac
echo > /home/cnt/sql "
;
SELECT *
FROM $gio
WHERE nota like '%$nota%'
ORDER BY nota,data;"
sqlite3 /home/cnt/cnt.db  < /home/cnt/sql
gqn
}

gqs(){
echo $vn
echo > $sql "
.headers ON
.mode column
SELECT
idcon,
ROUND(SUM(importo),2)
FROM giornale
GROUP BY idcon
ORDER BY idcon;
" | sqlite3 -init $sql $db
gq
}

gs(){
echo "[0m  data prima (compresa)"
read pri
echo "[0m  data ultima (compresa)"
read ult
echo > /home/cnt/sql "
;
SELECT
giornale.conto AS cod,
giocon.operazio AS conto,
SUM(giornale.importo) AS saldo
FROM giornale
LEFT JOIN giocon
ON giornale.conto=giocon.cod
WHERE giornale.data between '$pri' and '$ult'
GROUP BY giornale.conto
ORDER BY giornale.conto;"
sqlite3 /home/cnt/cnt.db  < /home/cnt/sql > /home/cnt/dati
mcedit /home/cnt/dati
#xterm -bg beige -fg blue -g 68x40 -e less /home/cnt/dati &
g
}

gv() {
echo > /home/cnt/sql "
;
DROP TABLE IF EXISTS tmp;
CREATE TABLE tmp
(data date,
idope char(4),
saldo double(12,2));
INSERT INTO tmp
SELECT
data,
idope,
sum(importo) AS saldo
FROM giornale
GROUP BY data,idope
ORDER BY data,idope;
SELECT * FROM tmp WHERE saldo <>0"
echo > /home/cnt/dati "
  * QUADRATURE ERRATE *
" 
sqlite3 /home/cnt/cnt.db  < /home/cnt/sql
# >> /home/cnt/dati
#xterm -bg beige -fg blue -g 40x10 -hold -e cat /home/cnt/dati &
g
}

h(){
echo "[0;42m        [0;31m    COMANDI   [0;42m          [0m

  h  questo aiuto
  *  elenco dati da immettere
  <  menu precedente
  <<  menu iniziale
  .  registrazione scrittura
  
  CONFERMARE OGNI COMANDO CON INVIO
"
}

g
