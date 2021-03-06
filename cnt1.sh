./cntbil.sh                                                                                         0000755 0001751 0001751 00000062517 11753211446 011200  0                                                                                                    ustar   cnt                             cnt                                                                                                                                                                                                                    #!/bin/bash

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

b                                                                                                                                                                                 ./cntcli.sh                                                                                         0000755 0001751 0001751 00000143350 11650014767 011177  0                                                                                                    ustar   cnt                             cnt                                                                                                                                                                                                                    #!/bin/bash

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
   quantit??           $unimis $quanti

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
   quantit??           $unimis $quanti
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
   quantit??           $unimis $quanti
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
  $gn quantit??              $Rn $unimis    $quanti
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
#e con lunghezza 6 caratteri ?? \"$b\"."
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

c                                                                                                                                                                                                                                                                                        ./cntfor.sh                                                                                         0000755 0001751 0001751 00000041661 11340717517 011217  0                                                                                                    ustar   cnt                             cnt                                                                                                                                                                                                                    #!/bin/bash

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
   (c)  citt??
   (i)  partita IVA
   (s)  codice fiscale

"
read x
case $x in
f) nome='codice fornitore'; id='idfor';;
n) nome='nome'; id='nome';;
v) nome='via'; id='via';;
c) nome='citt??'; id='citta';;
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

f                                                                               ./cntgen.sh                                                                                         0000755 0001751 0001751 00000050625 11752436562 011207  0                                                                                                    ustar   cnt                             cnt                                                                                                                                                                                                                    #!/bin/bash

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
                                                                                                           ./cntmag.sh                                                                                         0000755 0001751 0001751 00000044173 12027071230 011162  0                                                                                                    ustar   cnt                             cnt                                                                                                                                                                                                                    #!/bin/bash

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
$Rn   >>>  $gn unit?? di misura (unimis)
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
      quantit??           $quanti


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
      quantit??           $quanti
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
      quantit??           $quanti
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
      quantit??           $quanti
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

m                                                                                                                                                                                                                                                                                                                                                                                                     ./ESEGUIMI.sh                                                                                       0000755 0001750 0001750 00000020522 12027026412 011044  0                                                                                                    ustar   dan                             dan                                                                                                                                                                                                                    #! /bin/bash

# colorazione con sequenze ANSI

nn="[0;0;01m"    # fondo nero
rr="[0;0;41m"    # fondo ross
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
bn="[0;34;40m"   # blu su nero
Bn="[1;34;40m"   # blu grassetto su nero
mn="[0;35;40m"   # magenta su nero
Mn="[1;35;40m"   # magenta grassetto su nero
cn="[0;36;40m"   # cyan su nero
Cn="[1;36;40m"   # cyan grassetto su nero

z="[0m";         # normale

ini1(){
clear
echo "
$vn

  Questo file eseguibile e' parte del programma di contabilita' scritto e
  mantenuto da Daniele Vallini del Gruppo Linux di Biella (BiLUG)

$rn   vallini.daniele@bilug.it          www.bilug.it $vn

  Il programma e' stato curato e collaudato da tempo ma viene fornito
  privo di qualsiasi garanzia poiche' e' compito dell' utilizzatore
  verificarne l' adeguatezza alle proprie esigenze.

  Il programma e' liberamente utilizzabile nei termini della licenza GPL3

$rn   http://www.gnu.org/licenses/gpl.txt $vn

  Il codice puo' essere liberamente modificato ed adattato ma questo
  commento introduttivo deve essere mantenuto

  E' gradita ogni forma di collaborazione segnalando commenti, sviluppi ed
  integrazioni al Gruppo Linux di Biella - BiLUG, mailing list pubblica:

$rn  linux@ml.bilug.linux.it


$Rn   (+) $gn procedo
$Rn   (-) $gn abbandono

$gn        CONFERMARE OGNI OPZIONE CON $rn Invio
"
read x
case $x in
"+") ini2;;
"-") exit;;
esac
ini1
}

ini2(){
clear

echo "
$vn
  Il programma di installazione esegue le seguenti operazioni:

$gn - verifica la presenza dei programmi:
$rn
  - xterm
  - sqlite3

$gn - crea l'utente cnt,

$gn - inserisce in /home/cnt i moduli del programma di contabilita':
$rn
   - cnt1.sh      (avvio)
   - cntbil.sh    (bilanci)
   - cntcli.sh    (clienti)
   - cntfor.sh    (fornitori)
   - cntgen.sh    (generale)
   - cntmag.sh    (magazzino)

   - ESEGUIMI.sh  (installatore dell'applicativo)
   - LEGGIMI.txt  (documentazione di installazione)

$gn - crea il database con le sue tabelle nel file /home/cnt/cnt.db:
$rn
   - cliana         anagrafe clienti
   - clifat1        fatture clienti parte 1
   - clifat2        fatture clienti parte 2
   - forana         anagrafe fornitori
   - giocon         piano dei conti
   - gioope         codici di operazione contabile
   - giornale       libro giornale
   - magart         articoli di magazzino
   - magazzino      movimenti di magazzino
   - magope         codici di operazione di magazzino


 $Rn (+)  $gn procedo
 $Rn (-)  $gn abbandono
 $Rn (<)  $gn indietro
$z"
read x
case $x in
"+") inst1;;
"-") exit;;
"<") ini1;;
esac
ini2
}

inst1(){
clear
xx=`whoami`
if [ "$xx" = "root" ] 
then
   echo "$vn  OK sei l'utente  $xx, puoi procedere"
   inst2
else 
   echo "
$vn  Sei l'utente $xx, devi essere root per procedere

$gn              Fra 5 secondi esco
"
sleep 5
exit
fi
}

inst2(){
echo "
$vn  verifico l'installazione della console xterm'
"
file=/usr/bin/xterm
if [[ -e $file ]]
then echo "
$gn  OK $file e' installato
"
inst3
else echo "
$vn non esiste $file, provvedi ad installarlo
$vn con il comando $gn apt-get install xterm

$gn          fra 5 secondi esco
"
sleep 5
exit
fi
}

inst3(){
echo "
$vn  verifico l'installazione di sqlite3
$vn  (e' il database)
"
file=/usr/bin/sqlite3
if [[ -e $file ]]
then echo "
$gn  OK $file e' installato
"
inst4
else echo "
$vn non esiste $file, provvedi ad installarlo
$vn con il comando apt-get install sqlite3

$gn           fra 5 secondi esco
"
sleep 5
exit
fi
}

inst4(){
echo "
$vn  Creo il gruppo $rn cnt e l'utente $rn cnt $vn per il quale devi
$vn  immettere la password, gli altri dati richiesti (nome, stanza,
$vn  telefoni, altro) sono facoltativi.

$gn  ATTENZIONE: se utente e gruppo cnt gia' esistono verranno annullati e
$gn  l'utente ricreato con nuova password

$Rn (+)  $gn procedo
$Rn (-)  $gn abbandono
$Rn (<)  $gn indietro
$z"
read x
case $x in
"+") inst5;;
"-") exit;;
"<") inst3
esac
inst4
}

inst5(){
clear
delgroup cnt
deluser cnt
adduser cnt
echo "
$vn installato gruppo cnt ed utente cnt, $gn ricordati la password!
"
inst6
}

inst6(){
echo "
$vn copio ora in /home/cnt i moduli del programma:
$rn
   - cnt1.sh   (avvio)
   - cntbil.sh (bilanci)
   - cntcli.sh (clienti)
   - cntfor.sh (fornitori)
   - cntgen.sh (generale)
   - cntmag.sh (magazzino)

   - ESEGUIMI.sh  (installatore dell'applicazione)
   - LEGGIMI.txt  (documentazione di installazione)

$Rn >>>  $gn immetti la posizione ove si trovano detti file da copiare
$Rn (-)  $gn abbandono
$Rn (<)  $gn indietro
$z
"
read path
case $path in
("")  inst6;;
("-")  exit;;
("<")  inst4;;
esac
inst7
}

inst7(){
path1=/home/cnt
for file in "/cnt1.sh" "/cntbil.sh" "/cntcli.sh" "/cntfor.sh" "/cntgen.sh" "/cntmag.sh" "/ESEGUIMI.sh" "/LEGGIMI.txt"
do
if [[ -e $path$file ]]
then echo "$gn  OK $path$file esiste, copio in /home/cnt"
cp $path$file $path1/$file
else echo "$vn non esiste $path$file"
inst6
fi
done
inst8
}

inst8(){
echo "
$vn  verifico l'installazione dei moduli del programma
"
for file in "/cnt1.sh" "/cntbil.sh" "/cntcli.sh" "/cntfor.sh" "/cntgen.sh" "/cntmag.sh" "/ESEGUIMI.sh" "/LEGGIMI.txt"
do
if [[ -e $path1$file ]]
then echo "$gn  OK $path1$file e' installato"
else echo "$vn non esiste $path1$file"
inst6
fi
done
inst9
}

inst9(){

echo "
$vn  creo ora Il database sqlite3 e creo le tabelle necessarie
"
if [[ -e $path1/cnt.db ]]
  then echo "
  $rn  ATTENZIONE IL DATABASE ESISTE LA NUOVA CREAZIONE COMPORTA
  $rn  LA PERDITA DEI DATI ESISTENTI

  $Rn  (-) $gn Esco e salvo altrove il file /home/cnt/db
  $Rn  (+) $gn Procedo annullando il database esistente
  "
  read x
    case $x in
    "-") exit;;
    "+") rm /home/cnt/cnt.db; inst10;;
    "<") inst8;;
    esac
  else inst10
fi
}

inst10(){

echo > /home/cnt/sql "

CREATE TABLE cliana (
 idcli     TEXT(5)   PRIMARY KEY,
 cliente   TEXT(30)  NOT NULL,
 clien2    TEXT(30),
 via       TEXT(30)  NOT NULL,
 citta    TEXT(30)  NOT NULL,
 piva      TEXT(13)  NOT NULL,
 codfis    TEXT(16),
 listino   INT(1)    NOT NULL,
 pagamen   TEXT(80)  NOT NULL,
 destina   TEXT(30),
 destin2   TEXT(30),
 destvia   TEXT(30),
 destcit   TEXT(30)
);
CREATE TABLE clifat1 (
 nrfat     INT(4)     PRIMARY KEY,
 idcli     TEXT(6)    NOT NULL,
 datafat   TEXT(6)    NOT NULL,
 datatras  TEXT(6)    NOT NULL,
 causale   TEXT(7)    NOT NULL,
 colli     TEXT(3)    NOT NULL,
 trasp     TEXT(12)   NOT NULL
);
CREATE TABLE clifat2 (
 nrfat     INT(4)     NOT NULL,
 datafat   TEXT(6)    NOT NULL,
 idart     TEXT(6)    NOT NULL,
 quanti    INT(5)     NOT NULL,
 prezzo    REAL(6,2)  NOT NULL,
 iva       INT(2)     NOT NULL,
 lotto     TEXT(6)    NOT NULL
);
CREATE TABLE forana (
 idfor     TEXT(5)   PRIMARY KEY,
 fornitore TEXT(30)  NOT NULL,
 via       TEXT(30),
 citta     TEXT(30),
 piva      TEXT(11)  NOT NULL,
 codfis    TEXT(16)
);
 CREATE TABLE giornale (
 data      TEXT(6)  NOT NULL,
 idope     TEXT(4)  NOT NULL,
 idcon     TEXT(10) NOT NULL,
 importo   REAL(12,2),
 nrfat     INT(4),
 idfor     TEXT(6),
 idcli     TEXT(6),
 nota      TEXT(50)
);
CREATE TABLE gioope (
 idope     TEXT(3) PRIMARY KEY,
 operazio  TEXT(25)
);
CREATE TABLE giocon (
 idcon     TEXT(10) PRIMARY KEY,
 conto     TEXT(25)
);
CREATE TABLE magazzino (
 data      TEXT(6),
 idmov     TEXT(4),
 idart     TEXT(6),
 quanti    INT(6),
 prezzo    REAL(10,2),
 nrfat     INT(4),
 lotto     TEXT(6),
 nota      TEXT(50)
);
CREATE TABLE magart (
 idart     TEXT(6) PRIMARY KEY,
 articolo  TEXT(26) NOT NULL ,
 unimis    TEXT(2) NOT NULL,
 aliva     INT(2) NOT NULL,
 costo     REAL(8,2),
 gros1     REAL(8,2),
 gros2     REAL(8,2),
 minuto    REAL(8,2)
);
CREATE TABLE magmov (
 idmov     TEXT(2) PRIMARY KEY,
 movime    TEXT(20) NOT NULL
);"
sqlite3 /home/cnt/cnt.db < /home/cnt/sql

echo "$gn
Definisco l'utente cnt proprietario della directory /home/cnt"
chown -R cnt:cnt /home/cnt/*
echo "$gn
Creo un link simbolico /usr/bin/cnt -> /home/cnt/cnt1.sh"
ln -s /home/cnt/cnt1.sh /usr/bin/cnt
echo "$gn
Fine del processo di installazione del database

Per avviare il programma di contabilita' apri una console xterm, a pieno
schermo, con i poteri dell'utente cnt e digita semplicemente cnt.

premi ora Inv per terminare l'installazione"
echo "$z"
read x
exit
}

ini1                                                                                                                                                                              ./LEGGIMI.txt                                                                                       0000644 0001751 0001751 00000005500 11324016427 011165  0                                                                                                    ustar   cnt                             cnt                                                                                                                                                                                                                    
Il programma bilugcnt gestisce le scritture di contabilita' generale in
partita doppia e le relative elaborazioni, la contabilita' magazzino,
clienti, fornitori nonche' la chiusura annuale di bilancio con riporto
patrimoniali a nuovo esercizio.

E' destinato principalmente a contabilita' personali, familiari o di
piccole aziende.

L'applicativo e' in script bash, l'interfaccia grafica e' il terminale
xterm.

Puo' funzionare anche con la sola console testuale modificando le chiamate
a xterm e la dimensione dei caratteri per permettere la corretta lettura
degli output delle query.

Richiede risorse di macchina estremamente modeste e funziona ottimamente
anche su macchine molto vecchie e limitate.

E' costituito dai seguenti moduli:

  - cnt1.sh          menu principale
  - cntbil.sh        bilancio annuale
  - cntcli.sh        clienti
  - cntfor.sh        fornitori
  - cntmag.sh        magazzino

  - ESEGUIMI.sh      installatore dell'applicazione
  - LEGGIMI.txt      documentazione di installazione

L'applicativo richiama le funzioni dei seguenti programmi normalmente
disponibili nelle distribuzioni Linux:

  - interprete bash
  - sqlite3
  - xterm
  - cups

L'esecuzione dell'installer ESEGUIMI.sh verifica l'esistenza di xterm ed
sqlite3 ed altrimenti ne richiede l'installazione.

Se non si e' interessati alla stampa si puo' omettere l'installazione di
cups

Per l'installazione aprire un terminale con diritti di root, avviare il
programma ESEGUIMI.sh e seguirne la procedura.

Il programma e' liberamente utilizzabile nei termini della licenza GPL3:

              http://www.gnu.org/licenses/gpl.txt


PERSONALIZZAZIONE
-----------------

inserire i codici dei conti
inserire i codici di operazione

Questa contabilita' e' in partita doppia ed applica le seguenti
convenzioni nella definizione del nome dei conti e nell'immissione degli
importi:

categoria conto        segno      iniziale

economico costo            +            c
economico ricavo           -            r
patrimoniale attivo        +            a
patrimoniale passivo       -            p
patrimonio netto           -            cn

separazione decimali:      .
formato data:            aammgg   (e' il formato unificato ISO)

Il programma esegue automaticamente la somma di piu' importi.
Esempi del formato di immissione degli importi:

 -xxx.xx-yy.y+zz     xxx.x*yy     -xx.xx/y


UTILIZZO
--------

Ogni immissione deve venire confermata con (Inv)

Questi comandi non sono indicati ma sono sempre attivi:

(<)  ritorno all' immissione precedente
(<<) ritorno all' inizio del modulo di programma

Ad ogni avvio il programma verifica l' esistenza di squadrature nella
contabilita' affinche' possano immediatamente esere effettuate le
rettifiche delle scritture errate.

Inviate osservazioni e proposte di modifica direttamente in mailing list
pubblica bilug: linux@ml.bilug.linux.it

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                