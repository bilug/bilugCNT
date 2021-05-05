#!/bin/bash

#
#  Questo file eseguibile e' parte del programma di contabilita' scritto e
#  mantenuto da Daniele Vallini del Gruppo Linux di Biella (BiLUG)
#
#   vallini.daniele@bilug.linux.it       www.bilug.it
#
#  Il programma e' stato curato e collaudato da tempo ma viene fornito
#  privo di qualsiasi garanzia poiche' e' compito dell' utilizzatore
#  verificarne l' adeguatezza alle proprie esigenze.
#
#  Il programma e' liberamente utilizzabile nei termini della licenza GPL3
#   http://www.gnu.org/licenses/gpl.txt
#
#  Il codice puo' essere liberamente modificato ed adattato ma questo
#  commento introduttivo deve essere mantenuto
#
#  E' gradita ogni forma di collaborazione segnalando commenti, sviluppi
#  ed integrazioni al Gruppo Linux di Biella - BiLUG

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
gn="[0;33;40m"   # giallo su nero
Gn="[1;33;40m"   # giallo grassetto su nero
bn="[0;34;40m"   # blu su nero  (cattiva visibilita')
Bn="[1;34;40m"   # blu grassetto su nero (cattiva visibilita')
mn="[0;35;40m"   # magenta su nero
Mn="[1;35;40m"   # magenta grassetto su nero
cn="[0;36;40m"   # cyan su nero
Cn="[1;36;40m"   # cyan grassetto su nero

z="[0m";         # normale

db=/home/cnt/cnt.db  # definisco la posizione del database

b(){
echo "
$Rn >>> $gn prima data inclusa (aammgg)
$z"
read data1
case $data1 in
"") b;;
"<") /home/cnt/cnt1.sh;;
"<<") /home/cnt/cnt1.sh;;
esac
echo "
$Rn >>> $gn ultima data inclusa (aammgg)
$z"
read data2
case $data2 in
"") b;;
"<") b;;
"<<") /home/cnt/cnt1.sh;;
esac
b0
}

b0(){

echo "
$gn BILANCIO  ESERCIZIO DA $rn $data1 $gn A $rn $data2

$Rn (c) $gn clienti
$Rn (f) $gn fornitori
$Rn (m) $gn magazzino
$Rn (g) $gn giornale
"
read x
case $x in
c)   bc;;
f)   bf;;
m)   b1;;
g)   b1;;
"<") b;;
"<<") /home/cnt/cnt1.sh;;
esac
b0
}

b1(){
echo "
$gn BILANCIO  ESERCIZIO DA $rn $data1 $gn A $rn $data2

$gn Magazzino
$Rn (m1) $gn scritture magazzino precedenti $data1
$Rn (m2) $gn scritture magazzino successive $data2
$Rn (m3) $gn codici articolo errati
$Rn (m4) $gn articoli senza movimento
$Rn (m5) $gn bilancio magazzino
$Rn (m6) $gn chiusura magazzino

$gn Giornale
$Rn (g1) $gn scritture giornale precedenti $data1
$Rn (g2) $gn scritture giornale successive $data2
$Rn (g3) $gn conti senza nome
$Rn (g4) $gn conti senza movimento
$Rn (g5) $gn bilancio conti
$Rn (g6) $gn chiusura conti
$z"
read x
case $x in
m1) bm1;;
m2) bm2;;
m3) bm3;;
m4) bm4;;
m5) bm5;;
m6) bm6;;
g1) bg1;;
g2) bg2;;
g3) bg3;;
g4) bg4;;
g5) bg5;;
g6) bg6;;
"<") b0;;
"<<") /home/cnt/cnt1.sh;;
esac
b1
}

bc(){
clear
echo "
$gn BILANCIO ESERCIZIO $rn CLIENTI $gnDA $rn $data1 $gn A $rn $data2

$Rn (e) $gn  elenco fatture
$Rn (++) $gn chiusura fatture
"
read x
case $x in
e) bce;;
"++") echo " modulo da scrivere";;
"<") b;;
"<<") /home/cnt/cnt1.sh;;
esac
echo "
$Rn (Inv) $gn per continuare
$z"
read x
bc
}

bce(){
echo "
.header ON
.mode column
.width 5 7 7 7 8 4 13
SELECT *
FROM clifat1
WHERE datafat between '$data1' and '$data2';

 SELECT *
 FROM clifat2
 WHERE datafat between '$data1' and '$data2';"
sqlite3 -header -column $db < /home/cnt/sql

}

bf(){
echo "
           modulo non attivo
"
bc
}

bg1(){
echo "
$gn   ****  INIZIO SCRITTURE PRECEDENTI $data1  **** $vn"
echo "
.header ON
.mode column
.width 7 5 8 13 6 6 6 50
SELECT *
FROM giornale
WHERE data < '$data1'
ORDER BY data,idcon;
" | sqlite3 $db
echo  "
$gn   ****   FINE SCRITTURE PRECEDENTI $data1   ****

    ****   >>> Invio per procedere   **** $z"
read x
# > /cnt/dati
#echo >> /cnt/dati "   **** SCRITTURE PRECEDENTI $data1"
#xterm -bg beige -fg blue  -g 90x40+230+0 -hold -e cat /cnt/dati &
b1
}


bg2(){
echo "
$gn    ****  INIZIO SCRITTURE SUCCESSIVE $data2  **** $vn"

echo "
.header ON
.mode column
.width 7 5 8 13 6 6 6 50
SELECT *
FROM giornale
WHERE data > '$data2'
ORDER BY data,idcon;
" | sqlite3 $db
echo "
$gn    ****   FINE SCRITTURE SUCCESSIVE $data2   ****

    ****   >>> Invio per procedere   **** $z"
read x

# > /cnt/dati
#echo >> /cnt/dati "   **** SCRITTURE SUCCESSIVE $data2"
#xterm -bg beige -fg blue  -g 90x40+230+0 -hold -e cat /cnt/dati &
b1
}

bg3(){
echo "$gn    ****   INIZIO CONTI SENZA NOME  **** $vn"

echo > /home/cnt/sql "

SELECT giornale.idcon
FROM giornale left join giocon
ON giornale.idcon = giocon.idcon
WHERE giocon.idcon IS NULL
GROUP BY giornale.idcon
ORDER BY giornale.idcon;"
sqlite3 -header -column $db < /home/cnt/sql
echo "$gn    ****   FINE CONTI SENZA NOME   ****

    ****   >>> Invio per procedere   **** $z"
read x

# > /cnt/dati
#xterm -bg beige -fg blue  -g 24x15+630+0 -hold -T "Conti senza nome" -e cat /cnt/dati & 
#b0
}

bg4(){
echo "$gn    ****  INIZIO CONTI SENZA MOVIMENTO  **** $vn"

echo > /home/cnt/sql "

SELECT giocon.idcon,giocon.conto
FROM giocon LEFT JOIN giornale
ON giocon.idcon=giornale.idcon
WHERE giornale.idcon IS NULL
AND giocon.conto NOT LIKE '-%';"
sqlite3 -header -column $db < /home/cnt/sql
echo "$gn   ****    FINE CONTI SENZA MOVIMENTO  ****

   ****   >>> Invio per procedere   **** $z"
read x

# > /cnt/dati
#xterm -bg beige -fg blue  -g 40x40+530+0 -hold -T "Conti senza movimento" -e cat /cnt/dati &
 
b0
}

bg5(){
echo " 

+------------------------------------------------------------------+
|   Il  bilancio  e'  temporaneamente  su  /home/cnt/bilancio      |
| completate le verifiche trasferirlo su /home/cnt/bilanci/bil20xx |
|      prima  di  chiudere  definitivamente  l' esercizio          |
+------------------------------------------------------------------+

   >>> Invio per continuare
"
read x

costi=`echo "SELECT ROUND(SUM(importo)) FROM giornale WHERE idcon like 'c%' AND data between '$data1' AND '$data2';" | sqlite3 $db`
#costi1=${costi%.0}   # elimino .0 finale
ricavi=`echo "SELECT ROUND(SUM(importo)) FROM giornale WHERE idcon like 'r%' AND data between '$data1' AND '$data2';" | sqlite3 $db`
#ricavi1=${ricavi%.0}  # elimino .0 finale
saldoeconomici=`echo "SELECT $costi+$ricavi;" | sqlite3 $db`
#saldeco1=${saldeco%.0}  # elimino .0 finale
attivo=`echo "SELECT ROUND(SUM(importo)) FROM giornale WHERE idcon like 'a%' AND data between '$data1' AND '$data2';" | sqlite3 $db`
passivo=`echo "SELECT ROUND(SUM(importo)) FROM giornale WHERE idcon like 'p%' AND data between '$data1' AND '$data2';" | sqlite3 $db`
saldopatrimoniali=`echo "SELECT $attivo+$passivo;" | sqlite3 $db`
capitalenetto=`echo "SELECT ROUND(SUM(importo)) FROM giornale WHERE idcon like 'n%' AND data between '$data1' AND '$data2';" | sqlite3 $db`
squadratura=`echo "SELECT ROUND(SUM(importo)) FROM giornale WHERE data between '$data1' and '$data2';" | sqlite3 $db`


echo > /home/cnt/bilancio "

 BILANCIO ESERCIZIO  DA  $data1  A  $data2
 -----------------------------------------

 Costi                 $costi
 Ricavi              $ricavi
 Saldo Economici     $saldoeconomici

 Attivo              $attivo
 Passivo                $passivo
 Saldo Patrimoniali  $saldopatrimoniali

 Capitale Netto     $capitalenetto

 Squadratura               $squadratura


"


echo "
.header ON
.mode column
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'cn%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio

echo "
.mode column
SELECT 'TOTALE COSTI PRODUZIONI NATURALI     ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'cn%'
AND data between '$data1' and '$data2';
" | sqlite3 $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'cz%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio

echo "
SELECT 'TOTALE COSTI PRODUZIONI ZOOTECNICHE    ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'cz%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'cm%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio

echo "
SELECT 'TOTALE COSTI MANUTENZIONI             ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'cm%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'ca%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio

echo "
SELECT 'TOTALE AMMORTAMENTI                ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'ca%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'cd%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio

echo "
SELECT 'TOTALE COSTI DOMESTICI             ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'cd%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'cg%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio

echo "
SELECT 'TOTALE COSTI GENERALI               ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'cg%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
SELECT 'TOTALE COSTI                       ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'c%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'r%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
'

echo "
SELECT 'TOTALE RICAVI                      ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'r%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'al%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
'

echo "
SELECT 'TOTALE LIQUIDITA               ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'al%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'ac%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
'

echo "
SELECT 'TOTALE CREDITI VERSO CLIENTI     ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'ac%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'air%' or giornale.idcon like 'aiv%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
'

echo "
SELECT 'TOTALE CREDITI DI IMPOSTA           ',ROUND(SUM(importo))
FROM giornale
WHERE giornale.idcon like 'air%' or giornale.idcon like 'aiv%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
SELECT 'TOTALE MAGAZZINO                  ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'az'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'aa%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
SELECT 'TOTALE ATTREZZATURE               ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'aa%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'
echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'am%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio

echo "
SELECT 'TOTALE MACCHINE                  ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'am%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'
echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'aim%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
SELECT 'TOTALE IMPIANTI               ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'aim%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'af%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3 $db >> /home/cnt/bilancio

echo "
SELECT 'TOTALE FABBRICATI                ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'af%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
.mode column
.width 10 25 13
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'at%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3  $db >> /home/cnt/bilancio

echo "
SELECT 'TOTALE TERRENI                   ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'at%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'
#echo > /home/cnt/sql "
#
#SELECT CONCAT('TOTALE ATTIVI DIVERSI               ',SUM(importo))
#FROM giornale
#WHERE idcon like 'add'
#AND data between '$data1' and '$data2';"
#sqlite3  -column $db < /home/cnt/sql >> /cnt/dati
#echo>> /cnt/dati '
#'
echo "
SELECT 'TOTALE ATTIVO                  ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'a%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'
echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'p%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
SELECT 'TOTALE PASSIVO                    ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'p%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
'
echo "
.mode column
.width 10 25 13 
SELECT giornale.idcon,giocon.conto,ROUND(SUM(giornale.importo)) AS totale
FROM giornale
LEFT JOIN giocon
ON giornale.idcon=giocon.idcon
WHERE giornale.idcon like 'n%'
AND giornale.data between '$data1' and '$data2'
GROUP BY giornale.idcon
ORDER BY giornale.idcon;
" | sqlite3  -column $db >> /home/cnt/bilancio
echo >> /home/cnt/bilancio '
--------------------------------------------------'

echo "
SELECT 'TOTALE CAPITALE NETTO             ',ROUND(SUM(importo))
FROM giornale
WHERE idcon like 'n%'
AND data between '$data1' and '$data2';
" | sqlite3  -column $db >> /home/cnt/bilancio

sed "s/\.0//" /home/cnt/bilancio > /home/cnt/bilancio1

less /home/cnt/bilancio1
b0
}

bg6(){
echo "
$rn       ATTENZIONE !  LA SEGUENTE PROCEDURA E' IRREVERSIBILE
$rn   SALVARE E STAMPARE IL BILANCIO DEFINITIVO PRIMA DI PROCEDERE

$gn   Prima data esercizio  $rn $data1
$gn   Ultima data esercizio $rn $data2

$Rn   >>> $gn Data riporto a nuovo (aammgg)

$z"
read data3
case $data3 in
"") bg6;;
"<") b;;
"<<") b;;
esac 
bg7
}

bg7(){

giopre=gio20${data2:0:2}

echo "

$gn   Prima data esercizio         $rn $data1
$gn   Ultima data esercizio        $rn $data2
$gn   Data riporto a nuovo         $rn $data3
$gn   Tabella esercizio precedente $rn $giopre 

$gn   - Elimino eventuale tabella giobkp
$gn   - Creo nuova tabella giobkp
$gn   - Copio giornale in giobkp
$gn   - Creo tabella esercizio precedente $rn $giopre
$gn   - Inserisco in giopre scritture giornale <= $rn $data2
$gn   - Inserisco in giornale con data $rn $data3 i saldi
$gn     dei conti patrimoniali e di capitale al $rn $data2
$gn   - Elimino da giornale le scritture con data <= $rn $data2

$Rn   (++) $gn per procedere
$z"

read x
case $x in
++) bg8xx;;
"<") b0;;
"<<") b;;
esac   
}

bg8(){
echo > /home/cnt/sql "

DROP TABLE IF EXISTS giobkp;

CREATE TABLE giobkp (data date NOT NULL,  
idope char(2) NOT NULL,
idcon char(7) NOT NULL,
importo real(12,2),
nrfat int(4),
idfor char(6),
idcli char(6),
nota varchar(50));

INSERT INTO giobkp
SELECT *
FROM giornale
ORDER BY data,idope,idcon;

DROP TABLE IF EXISTS giopre;

CREATE TABLE $giopre
(data date NOT NULL,
idope char(2) NOT NULL,
idcon char(7) NOT NULL,
importo real(12,2),
nrfat int(4),
idfor char(6),
idcli char(6),
nota varchar(50));

INSERT INTO $giopre
SELECT *
FROM giornale
WHERE data <= '$data2'
ORDER BY data,idope,idcon;

INSERT INTO giornale
SELECT '$data3','ap',idcon,SUM(importo),00,'','','apertura patrimoniali'
FROM $giopre
WHERE (idcon  like 'a%' or idcon like 'p%' or idcon like 'n%')
GROUP BY idcon;
"
sqlite3 $db < /home/cnt/sql
echo '
   ***   COMPLETATA CHIUSURA BILANCIO   ***
'
}


bm1(){
echo "   ****  INIZIO SCRITTURE MAGAZZINO PRECEDENTI $data1"
echo "
.header ON
.mode column
SELECT *
FROM magazzino
WHERE data < '$data1'
ORDER BY data;
" | sqlite3 $db
echo "   ****   FINE SCRITTURE MAGAZZINO PRECEDENTI  $data1"
echo "
   ****   >>> Invio per procedere   ****"
read x

b0
}

bm2(){
echo "   ****  INIZIO SCRITTURE MAGAZZINO SUCCESSIVE $data2"
echo "
.header ON
.mode column
SELECT *
FROM magazzino
WHERE data > '$data2'
ORDER BY data;
" | sqlite3 $db
echo "   ****  FINE SCRITTURE MAGAZZINO SUCCESSIVE $data2"
echo "
   ****   >>> Invio per procedere   ****"
read x

b0
}

bm3(){
echo "   ****  INIZIO CODICI ARTICOLI ERRATI  ****"
echo > /home/cnt/sql "

SELECT magazzino.idart
FROM magazzino left join magart
ON magazzino.idart = magart.idart
WHERE magart.idart IS NULL
GROUP BY magazzino.idart
ORDER BY magazzino.idart;"
sqlite3  -column $db < /home/cnt/sql
echo "   ****   FINE CODICI ARTICOLI ERRATI   ****"
echo "
   ***   >>> Invio per procedere   ***"
read x

b0
}

bm4(){
echo "   ****  INIZIO ARTICOLI SENZA MOVIMENTO  ****"
echo > /home/cnt/sql "

SELECT * from magart left join magazzino
ON magart.idart = magazzino.idart
WHERE magazzino.idart IS NULL
ORDER BY magart.idart;"
sqlite3 -header -column $db < /home/cnt/sql
echo "   ****   FINE ARTICOLI SENZA MOVIMENTO   ****"
echo "
   ****   >>> Invio per procedere   ****"
read x

b0
}

bm5(){
echo > /home/cnt/sql "

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
AND data between '$data1' and '$data2'
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
AND data between '$data1' and '$data2'
GROUP BY idart
ORDER BY idart;

DROP TABLE IF EXISTS tmp3;

CREATE TABLE tmp3
(idart char(6),
saldo int(6));

INSERT INTO tmp3
SELECT idart,SUM(quanti)
FROM magazzino
WHERE data between '$data1' and '$data2'
GROUP BY idart
ORDER BY idart;

.headers ON
.mode column
.width 6 35 3 7 7 7 7 7 7

SELECT
magart.idart,
magart.articolo AS Descrizione,
magart.unimis,
tmp1.carico,
ROUND(tmp1.cosmed) AS cosmed,
tmp2.scarico,
ROUND(tmp2.ricmed) AS ricmed,
tmp3.saldo,
ROUND(tmp3.saldo*tmp1.cosmed) AS valtot
FROM magart
LEFT JOIN tmp1 ON magart.idart=tmp1.idart
LEFT JOIN tmp2 ON magart.idart=tmp2.idart
LEFT JOIN tmp3 ON magart.idart=tmp3.idart
ORDER BY magart.idart;"

sqlite3 $db < /home/cnt/sql
echo "
$gn VALORE TOTALE MAGAZZINO AL $rn $data2
$vn"
echo > /home/cnt/sql "
SELECT ROUND(SUM(tmp3.saldo*tmp1.cosmed))
FROM tmp1,tmp3
WHERE tmp1.idart=tmp3.idart;"
sqlite3 $db < /home/cnt/sql
echo "
   ****   >>> Invio per procedere   ****"
read x
b0
}

bm6(){
echo "
            ATTENZIONE !  LA SEGUENTE PROCEDURA E' IRREVERSIBILE:

   - CREA TABELLA mgzbkp
   - COPIA magazzino IN mgzbkp
   - CREA TABELLA mgzpre
   - COPIA IN mgzpre MOVIMENTI magazzino SINO A $data2
   - INSERISCE IN magazzino CON DATA $data3
     I SALDI ARTICOLI AL $data2 AI COSTI ANNUI MEDI
   
   [0:1;31m (++) [0m per procedere"
   
read x
case $x in
++) bm7;;
"<") b0;;
"<<") b;;
esac   
}

bm7(){
echo > /home/cnt/sql "

CREATE TABLE mgzbkp
(data date NOT NULL,
idmov varchar(2) NOT NULL,
idart varchar(7) NOT NULL,
quanti int(6) NOT NULL,
prezzo double(10,2) NOT NULL,
nrfat int(4),
lotto date,
nota varchar(35));

INSERT INTO mgzbkp
SELECT *
FROM magazzino
ORDER BY data,idmov,idart;

CREATE TABLE mgzpre
(data date NOT NULL,
idmov varchar(2) NOT NULL,
idart varchar(7) NOT NULL,
quanti int(6) NOT NULL,
prezzo double(10,2) NOT NULL,
nrfat int(4),
lotto date,
nota varchar(35));

INSERT INTO mgzpre
SELECT *
FROM magazzino
WHERE data <= '$data2'
ORDER BY data,idmov,idart;

DROP TABLE IF EXISTS tmp1;

CREATE TABLE tmp1
(idart varchar(6),
quanti int(6));

INSERT INTO tmp1
SELECT idart,
SUM(quanti)
FROM magazzino
WHERE data between '$data1' and '$data2'
GROUP BY idart
ORDER BY idart;

DROP TABLE IF EXISTS tmp2;

CREATE TABLE tmp2
(idart varchar(6),
cosmed double(8,2));

INSERT INTO tmp2
SELECT idart,
ROUND(SUM(quanti*prezzo)/SUM(quanti),2)
FROM magazzino
WHERE quanti >0
AND data between '$data1' and '$data2'
GROUP BY idart
ORDER BY idart;

INSERT INTO magazzino
SELECT $data3,'ap',tmp1.idart,
tmp1.quanti,tmp2.cosmed,00,'00','bilancio magazzino'
FROM tmp1,tmp2
WHERE tmp1.idart=tmp2.idart
ORDER BY tmp1.idart;

DELETE FROM magazzino
WHERE data <= '$data2';"
sqlite3 $db < /home/cnt/sql
}

b